class_name AbilityContainer
extends Node

const HomingSpellProjectile3DClass = preload("res://scenes/effects/homing_spell_projectile_3d.gd")
const SkillshotProjectile3DClass = preload("res://scenes/effects/skillshot_projectile_3d.gd")
const SpellVisualFX3DClass = preload("res://scenes/effects/spell_visual_fx_3d.gd")
const SummonManagerClass = preload("res://systems/summons/summon_manager.gd")
const StateHistorySystemClass = preload("res://systems/history/state_history_system.gd")
const SpatialManagerClass = preload("res://systems/spatial/spatial_manager.gd")
const SpellObserverSystemClass = preload("res://systems/spells/spell_observer_system.gd")
const TetherManagerClass = preload("res://systems/tether/tether_manager.gd")
const AreaEffectManagerClass = preload("res://systems/areas/area_effect_manager.gd")
const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")

## Manages active ability slots, cooldown timers, level progression, and spellcasting

signal ability_casted(slot: AbilityResource.Slot, ability: AbilityResource)
signal ability_learned(slot: AbilityResource.Slot, ability: AbilityResource)
signal ability_leveled(slot: AbilityResource.Slot, new_level: int)
signal cooldown_ticked(slot: AbilityResource.Slot, remaining: float, total: float)
signal skill_points_updated(points: int)
signal ability_cast_started(slot: AbilityResource.Slot, ability: AbilityResource, cast_time: float)
signal ability_cast_interrupted(slot: AbilityResource.Slot, reason: String)
signal ability_cast_completed(slot: AbilityResource.Slot, ability: AbilityResource)
signal ability_executed(slot: AbilityResource.Slot, ability: AbilityResource, target_entity: BaseCombatEntity, target_point: Vector3)
signal ability_target_hit(slot: AbilityResource.Slot, ability: AbilityResource, target_entity: BaseCombatEntity, result: DamageResult)
signal ability_cast_failed(slot: AbilityResource.Slot, ability: AbilityResource, reason: CastValidationResult, message: String)

enum CastState {
	IDLE,
	CASTING,
	CHANNELING
}

enum CastValidationResult {
	OK,
	NOT_LEARNED,
	IS_PASSIVE,
	ON_COOLDOWN,
	NOT_ENOUGH_MANA,
	SILENCED,
	CASTER_DEAD,
	TARGET_REQUIRED,
	INVALID_TARGET,
	TARGET_DEAD,
	TARGET_NOT_TARGETABLE,
	OUT_OF_RANGE
}

@export var available_skill_points: int = 1

var abilities: Dictionary = {} # AbilityResource.Slot -> AbilityResource
var ability_levels: Dictionary = {} # AbilityResource.Slot -> int
var cooldown_timers: Dictionary = {} # AbilityResource.Slot -> float
var max_cooldown_timers: Dictionary = {} # AbilityResource.Slot -> float
var instances: Dictionary = {} # AbilityResource.Slot -> AbilityInstance

var current_cast_state: CastState = CastState.IDLE
var current_casting_slot: AbilityResource.Slot = AbilityResource.Slot.PASSIVE
var current_cast_time_remaining: float = 0.0
var current_cast_target_entity: BaseCombatEntity = null
var current_cast_target_point: Vector3 = Vector3.ZERO
var current_channel_time_remaining: float = 0.0
var current_channel_tick_remaining: float = 0.0

var is_free_spells_active: bool = false
var attribute_system: AttributeSystem = null
var effect_container: EffectContainer = null

func _init() -> void:
	_init_slot_structures()

func _ready() -> void:
	_resolve_parent_references()
	_init_slot_structures()

func _resolve_parent_references() -> void:
	if get_parent() != null:
		if "attribute_system" in get_parent() and get_parent().attribute_system != null:
			attribute_system = get_parent().attribute_system
		else:
			attribute_system = get_parent().get_node_or_null("AttributeSystem")
			
		if "effect_container" in get_parent() and get_parent().effect_container != null:
			effect_container = get_parent().effect_container
		else:
			effect_container = get_parent().get_node_or_null("EffectContainer")

func _process(delta: float) -> void:
	# 1. Cooldown Tickers
	for s in cooldown_timers.keys():
		if cooldown_timers[s] > 0.0:
			cooldown_timers[s] = maxf(0.0, cooldown_timers[s] - delta)
			cooldown_ticked.emit(s, cooldown_timers[s], max_cooldown_timers[s])
			
	# 2. Active Cast Windup Ticker & Interrupt System
	if current_cast_state == CastState.CASTING:
		_resolve_parent_references()
		var caster: BaseCombatEntity = get_parent() as BaseCombatEntity
		
		# Interrupt Check: Caster Died
		if caster != null and not caster.is_alive():
			interrupt_cast("caster_died")
			return
			
		# Interrupt Check: Silence / Stun / CC
		if effect_container != null and (effect_container.is_silenced() or effect_container.is_stunned()):
			interrupt_cast("crowd_control")
			return
			
		# Interrupt Check: Movement during stationary cast
		if caster != null and caster.velocity.length_squared() > 0.04:
			interrupt_cast("movement")
			return
			
		# Interrupt Check: Target unit became invalid / dead
		if current_cast_target_entity != null:
			if not is_instance_valid(current_cast_target_entity) or not current_cast_target_entity.is_alive() or not current_cast_target_entity.is_targetable:
				interrupt_cast("target_invalid")
				return
				
		current_cast_time_remaining -= delta
		if current_cast_time_remaining <= 0.0:
			_complete_cast()
	elif current_cast_state == CastState.CHANNELING:
		_process_channel(delta)

func is_casting() -> bool:
	return current_cast_state == CastState.CASTING

func get_cast_progress() -> float:
	var ab: AbilityResource = abilities.get(current_casting_slot)
	if ab == null or ab.cast_time <= 0.0:
		return 1.0
	return clampf(1.0 - (current_cast_time_remaining / ab.cast_time), 0.0, 1.0)

func _init_slot_structures() -> void:
	for s in [AbilityResource.Slot.PASSIVE, AbilityResource.Slot.Q, AbilityResource.Slot.W, AbilityResource.Slot.E, AbilityResource.Slot.R]:
		if not abilities.has(s):
			abilities[s] = null
			ability_levels[s] = 1 if s == AbilityResource.Slot.PASSIVE else 0
			cooldown_timers[s] = 0.0
			max_cooldown_timers[s] = 0.0
		_sync_instance(s)

const AbilityInst = preload("res://core/abilities/ability_instance.gd")
const AbilityDef = preload("res://core/abilities/ability_definition.gd")
const CastReq = preload("res://core/abilities/ability_cast_request.gd")

func _sync_instance(s: AbilityResource.Slot) -> void:
	var def = abilities.get(s)
	if not instances.has(s) or instances[s] == null:
		instances[s] = AbilityInst.new(def, s, get_parent() as BaseCombatEntity, self)
	else:
		instances[s].definition = def
		instances[s].caster = get_parent() as BaseCombatEntity
		instances[s].container = self
	instances[s].level = ability_levels.get(s, 0)
	instances[s].cooldown_remaining = cooldown_timers.get(s, 0.0)
	instances[s].max_cooldown = max_cooldown_timers.get(s, 0.0)

func get_instance(slot: AbilityResource.Slot) -> RefCounted:
	_sync_instance(slot)
	return instances.get(slot)

func get_ability_state(slot: AbilityResource.Slot) -> int:
	var inst = get_instance(slot)
	return inst.get_state() if inst != null else 0

func add_ability(slot: AbilityResource.Slot, res: AbilityResource) -> void:
	abilities[slot] = res
	if not ability_levels.has(slot):
		ability_levels[slot] = 1 if slot == AbilityResource.Slot.PASSIVE else 0
	cooldown_timers[slot] = 0.0
	max_cooldown_timers[slot] = 0.0
	_sync_instance(slot)
	ability_learned.emit(slot, res)

func set_ability(slot: AbilityResource.Slot, ability: AbilityResource) -> void:
	abilities[slot] = ability
	if ability != null and ability.is_passive:
		ability_levels[slot] = 1
	_sync_instance(slot)

func get_ability(slot: AbilityResource.Slot) -> AbilityResource:
	return abilities.get(slot)

func get_ability_level(slot: AbilityResource.Slot) -> int:
	return ability_levels.get(slot, 0)

func get_cooldown_remaining(slot: AbilityResource.Slot) -> float:
	return cooldown_timers.get(slot, 0.0)

func get_cooldown_total(slot: AbilityResource.Slot) -> float:
	return max_cooldown_timers.get(slot, 0.0)

func is_on_cooldown(slot: AbilityResource.Slot) -> bool:
	return cooldown_timers.get(slot, 0.0) > 0.0

func can_level_up_ability(slot: AbilityResource.Slot, enforce_hero_level: bool = true) -> bool:
	var ab: AbilityResource = abilities.get(slot)
	if ab == null or available_skill_points <= 0:
		return false
		
	var cur_lvl = ability_levels.get(slot, 0)
	if cur_lvl >= ab.max_level:
		return false
		
	if enforce_hero_level:
		var hero: BaseCombatEntity = get_parent() as BaseCombatEntity
		var h_lvl = hero.attribute_system.level if (hero != null and hero.attribute_system != null) else 1
		var target_lvl = cur_lvl + 1
		
		if slot == AbilityResource.Slot.R:
			if target_lvl == 1 and h_lvl < 6:
				return false
			elif target_lvl == 2 and h_lvl < 11:
				return false
			elif target_lvl == 3 and h_lvl < 16:
				return false
		else:
			var req_lvl = (target_lvl * 2) - 1
			if h_lvl < req_lvl:
				return false
				
	return true

func get_required_hero_level(slot: AbilityResource.Slot, target_level: int = -1) -> int:
	var cur_lvl = ability_levels.get(slot, 0)
	var target = target_level if target_level > 0 else (cur_lvl + 1)
	if slot == AbilityResource.Slot.R:
		if target == 1:
			return 6
		elif target == 2:
			return 11
		elif target == 3:
			return 16
		return 6 + ((target - 1) * 5)
	return max(1, (target * 2) - 1)

func level_up_ability(slot: AbilityResource.Slot, enforce_hero_level: bool = false) -> bool:
	if not can_level_up_ability(slot, enforce_hero_level):
		return false
		
	var cur_lvl = ability_levels.get(slot, 0)
	ability_levels[slot] = cur_lvl + 1
	available_skill_points -= 1
	_sync_instance(slot)
	ability_leveled.emit(slot, ability_levels[slot])
	skill_points_updated.emit(available_skill_points)
	return true

func add_skill_point() -> void:
	available_skill_points += 1
	skill_points_updated.emit(available_skill_points)

func can_cast(slot: AbilityResource.Slot) -> bool:
	return validate_cast(slot) == CastValidationResult.OK

func can_cast_on_target(slot: AbilityResource.Slot, target_entity: BaseCombatEntity = null, target_point: Vector3 = Vector3.ZERO) -> bool:
	return validate_cast(slot, target_entity, target_point) == CastValidationResult.OK

func validate_cast(slot: AbilityResource.Slot, target_entity: BaseCombatEntity = null, target_point: Vector3 = Vector3.ZERO) -> CastValidationResult:
	_resolve_parent_references()
	var caster: BaseCombatEntity = get_parent() as BaseCombatEntity
	if caster != null and not caster.is_alive():
		return CastValidationResult.CASTER_DEAD
		
	var ab: AbilityResource = abilities.get(slot)
	if ab == null:
		return CastValidationResult.NOT_LEARNED
	if ab.is_passive:
		return CastValidationResult.IS_PASSIVE
		
	var lvl = ability_levels.get(slot, 0)
	if lvl <= 0:
		return CastValidationResult.NOT_LEARNED
		
	if not is_free_spells_active:
		if cooldown_timers.get(slot, 0.0) > 0.0:
			return CastValidationResult.ON_COOLDOWN
		if effect_container != null and effect_container.is_silenced():
			return CastValidationResult.SILENCED
		if attribute_system != null:
			var cost = ab.get_mana_cost(lvl)
			if attribute_system.current_mana < cost:
				return CastValidationResult.NOT_ENOUGH_MANA
				
	var max_range = ab.get_cast_range(lvl)
	var caster_pos = caster.global_position if (caster != null and caster.is_inside_tree()) else (caster.position if caster != null else Vector3.ZERO)
	
	# Target validations
	match ab.target_type:
		AbilityResource.TargetType.SELF:
			if target_entity != null and target_entity != caster:
				return CastValidationResult.INVALID_TARGET
				
		AbilityResource.TargetType.SINGLE_TARGET:
			if target_entity == null:
				return CastValidationResult.TARGET_REQUIRED
			if not is_instance_valid(target_entity) or not target_entity.is_alive():
				return CastValidationResult.TARGET_DEAD
			if not target_entity.is_targetable:
				return CastValidationResult.TARGET_NOT_TARGETABLE
			if not ab.is_valid_target(caster, target_entity):
				return CastValidationResult.INVALID_TARGET
			var target_pos = target_entity.global_position if target_entity.is_inside_tree() else target_entity.position
			if max_range > 0.0 and caster_pos.distance_to(target_pos) > (max_range + 0.5):
				return CastValidationResult.OUT_OF_RANGE
					
		AbilityResource.TargetType.GROUND_AOE, AbilityResource.TargetType.DIRECTIONAL:
			if target_point != Vector3.ZERO:
				if max_range > 0.0 and caster_pos.distance_to(target_point) > (max_range + 0.5):
					return CastValidationResult.OUT_OF_RANGE
					
	return CastValidationResult.OK

func get_validation_error_message(result: CastValidationResult) -> String:
	match result:
		CastValidationResult.OK:
			return "Kullanılabilir"
		CastValidationResult.NOT_LEARNED:
			return "Yetenek öğrenilmedi"
		CastValidationResult.IS_PASSIVE:
			return "Pasif yetenek kullanılamaz"
		CastValidationResult.ON_COOLDOWN:
			return "Bekleme süresinde"
		CastValidationResult.NOT_ENOUGH_MANA:
			return "Yetersiz mana"
		CastValidationResult.SILENCED:
			return "Susturuldu (Silenced)"
		CastValidationResult.CASTER_DEAD:
			return "Karakter ölü"
		CastValidationResult.TARGET_REQUIRED:
			return "Hedef gerekli"
		CastValidationResult.INVALID_TARGET:
			return "Geçersiz hedef"
		CastValidationResult.TARGET_DEAD:
			return "Hedef ölü"
		CastValidationResult.TARGET_NOT_TARGETABLE:
			return "Hedef seçilemez"
		CastValidationResult.OUT_OF_RANGE:
			return "Menzil dışı"
	return "Geçersiz işlem"

func _report_cast_failure(slot: AbilityResource.Slot, reason: CastValidationResult) -> void:
	var ability: AbilityResource = abilities.get(slot)
	var message = get_validation_error_message(reason)
	ability_cast_failed.emit(slot, ability, reason, message)
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		var ability_name = ability.ability_name if ability != null else "Yetenek"
		GameEvents.combat_log_generated.emit("%s KULLANILAMADI: %s" % [ability_name.to_upper(), message])

func start_cast(slot: AbilityResource.Slot, target_entity: BaseCombatEntity = null, target_point: Vector3 = Vector3.ZERO) -> bool:
	var validation = validate_cast(slot, target_entity, target_point)
	if validation != CastValidationResult.OK:
		_report_cast_failure(slot, validation)
		return false
		
	var ab: AbilityResource = abilities.get(slot)
	if ab.cast_time > 0.0:
		current_cast_state = CastState.CASTING
		current_casting_slot = slot
		current_cast_time_remaining = ab.cast_time
		current_cast_target_entity = target_entity
		current_cast_target_point = target_point
		ability_cast_started.emit(slot, ab, ab.cast_time)
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.ability_cast_started.emit(get_parent(), ab, ab.cast_time)
		return true
	elif _get_channel_duration(ab) > 0.0:
		_begin_channel(slot, target_entity, target_point)
		return true
	else:
		return cast_ability(slot, target_entity, target_point)

func cancel_cast() -> bool:
	return interrupt_cast("manual_cancel")

func interrupt_cast(reason: String = "interrupted") -> bool:
	if current_cast_state == CastState.CASTING or current_cast_state == CastState.CHANNELING:
		var slot = current_casting_slot
		var ab: AbilityResource = abilities.get(slot)
		current_cast_state = CastState.IDLE
		current_cast_time_remaining = 0.0
		current_channel_time_remaining = 0.0
		current_channel_tick_remaining = 0.0
		current_cast_target_entity = null
		current_cast_target_point = Vector3.ZERO
		ability_cast_interrupted.emit(slot, reason)
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.ability_cast_interrupted.emit(get_parent(), ab, reason)
			GameEvents.combat_log_generated.emit("Yetenek kesildi: %s" % reason)
		return true
	return false

func _complete_cast() -> void:
	var slot = current_casting_slot
	var target_e = current_cast_target_entity
	var target_p = current_cast_target_point
	current_cast_time_remaining = 0.0
	var ab: AbilityResource = abilities.get(slot)
	if _get_channel_duration(ab) > 0.0:
		_begin_channel(slot, target_e, target_p)
	else:
		current_cast_state = CastState.IDLE
		current_cast_target_entity = null
		current_cast_target_point = Vector3.ZERO
		_execute_ability(slot, target_e, target_p)

func execute_aoe_spell(slot: AbilityResource.Slot, center_pos: Vector3, custom_radius: float = -1.0) -> Array[BaseCombatEntity]:
	var ab: AbilityResource = abilities.get(slot)
	if ab == null:
		return []
		
	var caster: BaseCombatEntity = get_parent() as BaseCombatEntity
	var radius = custom_radius if custom_radius > 0.0 else (ab.aoe_radius / 100.0 if ab.aoe_radius > 50.0 else ab.aoe_radius)
	if radius <= 0.0:
		radius = 3.5 # Default AoE radius in meters
		
	var affected: Array[BaseCombatEntity] = []
	var nodes: Array = []
	if is_inside_tree() and get_tree() != null:
		nodes = get_tree().get_nodes_in_group("combat_entities")
	else:
		nodes.append_array(HeroEntity.active_heroes)
		nodes.append_array(CreepEntity.active_creeps)
		
	for n in nodes:
		if n is BaseCombatEntity and is_instance_valid(n) and n.is_alive():
			var n_pos = n.global_position if n.is_inside_tree() else n.position
			if center_pos.distance_to(n_pos) <= radius:
				if ab.is_valid_target(caster, n):
					affected.append(n)
					
	return affected

func cast_ability(slot: AbilityResource.Slot, target_entity: BaseCombatEntity = null, target_point: Vector3 = Vector3.ZERO) -> bool:
	var validation = validate_cast(slot, target_entity, target_point)
	if validation != CastValidationResult.OK:
		_report_cast_failure(slot, validation)
		return false
		
	var ab: AbilityResource = abilities.get(slot)
	if _get_channel_duration(ab) > 0.0:
		_begin_channel(slot, target_entity, target_point)
	else:
		_execute_ability(slot, target_entity, target_point)
	return true

func _get_channel_duration(ab: AbilityResource) -> float:
	if ab == null:
		return 0.0
	return ab.channel_max_duration if ab.channel_max_duration > 0.0 else ab.channel_time

func _begin_channel(slot: AbilityResource.Slot, target_entity: BaseCombatEntity, target_point: Vector3) -> void:
	var ab: AbilityResource = abilities.get(slot)
	var duration := _get_channel_duration(ab)
	if duration <= 0.0:
		_execute_ability(slot, target_entity, target_point)
		return
	# The opening pulse commits mana/cooldown once; subsequent pulses are free.
	_execute_ability(slot, target_entity, target_point)
	current_cast_state = CastState.CHANNELING
	current_casting_slot = slot
	current_cast_target_entity = target_entity
	current_cast_target_point = target_point
	current_channel_time_remaining = duration
	current_channel_tick_remaining = ab.channel_tick_interval if ab.channel_tick_interval > 0.0 else 0.5

func _process_channel(delta: float) -> void:
	_resolve_parent_references()
	var caster: BaseCombatEntity = get_parent() as BaseCombatEntity
	var ab: AbilityResource = abilities.get(current_casting_slot)
	if caster == null or not caster.is_alive():
		interrupt_cast("caster_died")
		return
	if effect_container != null and (effect_container.is_silenced() or effect_container.is_stunned()):
		interrupt_cast("crowd_control")
		return
	if ab != null and ab.break_on_movement and caster.velocity.length_squared() > 0.04:
		interrupt_cast("movement")
		return
	current_channel_time_remaining -= delta
	current_channel_tick_remaining -= delta
	if current_channel_tick_remaining <= 0.0 and current_channel_time_remaining > 0.0:
		_execute_channel_tick(caster, ab)
		current_channel_tick_remaining = ab.channel_tick_interval if ab.channel_tick_interval > 0.0 else 0.5
	if current_channel_time_remaining <= 0.0:
		current_cast_state = CastState.IDLE
		current_channel_time_remaining = 0.0
		current_channel_tick_remaining = 0.0
		current_cast_target_entity = null
		current_cast_target_point = Vector3.ZERO

func _execute_channel_tick(caster: BaseCombatEntity, ab: AbilityResource) -> void:
	if ab == null:
		return
	var damage = _calculate_ability_damage(ab, ability_levels.get(current_casting_slot, 1))
	if damage <= 0.0:
		return
	if current_cast_target_entity != null and is_instance_valid(current_cast_target_entity) and current_cast_target_entity.is_alive():
		CombatCalculator.execute_damage(DamageRequest.create_spell_damage(caster, current_cast_target_entity, damage, ab.damage_type, ab.ability_name + " (Channel)"))
		return
	var center = current_cast_target_point if current_cast_target_point != Vector3.ZERO else (caster.global_position if caster.is_inside_tree() else caster.position)
	for target in execute_aoe_spell(current_casting_slot, center):
		CombatCalculator.execute_damage(DamageRequest.create_spell_damage(caster, target, damage, ab.damage_type, ab.ability_name + " (Channel)"))

func cast_request(request: RefCounted, instant_execute: bool = true) -> bool:
	if request == null:
		return false
	var is_free = request.get("is_free_cast") if "is_free_cast" in request else false
	var req_slot = request.get("slot") if "slot" in request else AbilityResource.Slot.Q
	var target_e = request.get("target_entity") if "target_entity" in request else null
	var target_p = request.get("target_point") if "target_point" in request else Vector3.ZERO
	
	if is_free:
		var prev_free = is_free_spells_active
		is_free_spells_active = true
		var res = cast_ability(req_slot, target_e, target_p)
		is_free_spells_active = prev_free
		return res
	elif instant_execute:
		return cast_ability(req_slot, target_e, target_p)
	else:
		return start_cast(req_slot, target_e, target_p)

func execute_dash(slot: AbilityResource.Slot, target_point: Vector3 = Vector3.ZERO) -> bool:
	var ab = abilities.get(slot)
	if ab == null:
		return false
	var caster: BaseCombatEntity = get_parent() as BaseCombatEntity
	if caster == null or not caster.is_alive():
		return false
		
	var dist = 6.0
	if "dash_distance" in ab:
		dist = ab.dash_distance
	elif ab.has_meta("dash_distance"):
		dist = float(ab.get_meta("dash_distance"))
		
	var cur_pos = caster.global_position if caster.is_inside_tree() else caster.position
	var dir = -caster.transform.basis.z.normalized()
	if target_point != Vector3.ZERO:
		dir = (target_point - cur_pos).normalized()
		dir.y = 0.0
		
	var dest = cur_pos + (dir * dist)
	if ab.stop_on_first_enemy:
		dest = _stop_dash_at_first_enemy(caster, cur_pos, dest)
	_move_caster_to(caster, dest, ab.leap_height if "leap_height" in ab else 0.0)
		
	if ab.has_method("on_movement_completed"):
		ab.on_movement_completed(caster, dest)
	return true

func execute_blink(slot: AbilityResource.Slot, target_point: Vector3) -> bool:
	var ab = abilities.get(slot)
	if ab == null or target_point == Vector3.ZERO:
		return false
	var caster: BaseCombatEntity = get_parent() as BaseCombatEntity
	if caster == null or not caster.is_alive():
		return false
		
	var max_range = 8.0
	if "blink_range" in ab:
		max_range = ab.blink_range
	elif ab.has_meta("blink_range"):
		max_range = float(ab.get_meta("blink_range"))
		
	var cur_pos = caster.global_position if caster.is_inside_tree() else caster.position
	var diff = target_point - cur_pos
	diff.y = 0.0
	if diff.length() > max_range:
		diff = diff.normalized() * max_range
		
	var dest = cur_pos + diff
	if caster.is_inside_tree():
		caster.global_position = dest
	else:
		caster.position = dest
		
	if ab.has_method("on_movement_completed"):
		ab.on_movement_completed(caster, dest)
	return true

func execute_heal(slot: AbilityResource.Slot, target: BaseCombatEntity) -> float:
	var ab = abilities.get(slot)
	if ab == null or target == null or not target.is_alive():
		return 0.0
	var lvl = ability_levels.get(slot, 1)
	var heal_amt = 100.0
	if ab.has_method("get_heal_amount"):
		var stat_stat = ab.get("heal_scaling_stat") if "heal_scaling_stat" in ab else StatModifier.TargetStat.ABILITY_POWER
		var stat_val = attribute_system.get_stat(stat_stat) if attribute_system != null else 0.0
		heal_amt = ab.get_heal_amount(lvl, stat_val)
	elif ab.has_meta("heal_amount"):
		heal_amt = float(ab.get_meta("heal_amount"))
		
	if target.attribute_system != null:
		var caster = get_parent() as BaseCombatEntity
		return CombatMechanicsClass.heal(caster, target, heal_amt, ab.ability_name)
	return 0.0

func execute_shield(slot: AbilityResource.Slot, target: BaseCombatEntity) -> float:
	var ab = abilities.get(slot)
	if ab == null or target == null or not target.is_alive():
		return 0.0
	var lvl = ability_levels.get(slot, 1)
	var shield_amt = 150.0
	var dur = 4.0
	if ab.has_method("get_shield_amount"):
		shield_amt = ab.get_shield_amount(lvl)
		dur = ab.get("shield_duration") if "shield_duration" in ab else 4.0
	elif ab.has_meta("shield_amount"):
		shield_amt = float(ab.get_meta("shield_amount"))
		
	if target.effect_container != null:
		var caster = get_parent() as BaseCombatEntity
		return CombatMechanicsClass.apply_shield(caster, target, ab.id + "_shield", ab.ability_name, shield_amt, dur)
	return 0.0

func _execute_ability(slot: AbilityResource.Slot, target_entity: BaseCombatEntity = null, target_point: Vector3 = Vector3.ZERO) -> void:
	_resolve_parent_references()
	var caster: BaseCombatEntity = get_parent() as BaseCombatEntity
	var ab: AbilityResource = abilities[slot]
	var lvl = ability_levels[slot]
	
	# Spend mana if not free spells
	if not is_free_spells_active:
		var cost = ab.get_mana_cost(lvl)
		if attribute_system != null:
			attribute_system.spend_mana(cost)
			
		# Calculate Cooldown with CDR
		var base_cd = ab.get_cooldown(lvl)
		var cdr = attribute_system.get_stat(StatModifier.TargetStat.COOLDOWN_REDUCTION) if attribute_system != null else 0.0
		var final_cd = base_cd * (1.0 - cdr)
		
		cooldown_timers[slot] = final_cd
		max_cooldown_timers[slot] = final_cd
	else:
		cooldown_timers[slot] = 0.0
		max_cooldown_timers[slot] = 0.0
		
	_sync_instance(slot)
	
	# Handle AbilityDefinition behaviors
	if "is_healing_ability" in ab and ab.is_healing_ability:
		execute_heal(slot, target_entity if target_entity != null else caster)
	if "is_shielding_ability" in ab and ab.is_shielding_ability:
		execute_shield(slot, target_entity if target_entity != null else caster)
	if "is_movement_ability" in ab and ab.is_movement_ability:
		var is_blink_ab = ab.get("is_blink") if "is_blink" in ab else false
		if is_blink_ab:
			execute_blink(slot, target_point)
		else:
			execute_dash(slot, target_point)
	
	# Handle Buff Modifiers
	if "buff_values" in ab and ab.buff_values is Array and not ab.buff_values.is_empty():
		var b_val = ab.get_buff_value(lvl) if ab.has_method("get_buff_value") else 0.0
		if b_val != 0.0 and attribute_system != null:
			var b_stat = ab.buff_stat if "buff_stat" in ab else StatModifier.TargetStat.ATTACK_SPEED
			var b_type = ab.buff_type if "buff_type" in ab else StatModifier.Type.FLAT
			var b_dur = ab.buff_duration if "buff_duration" in ab else 4.0
			var b_source = "ab_buff_" + ab.id
			attribute_system.remove_modifiers_by_source(b_source)
			var mod = StatModifier.new(b_stat, b_type, b_val, b_source, b_dur)
			attribute_system.add_modifier(mod)

	# Handle Secondary Buff Modifiers
	if "secondary_buff_values" in ab and ab.secondary_buff_values is Array and not ab.secondary_buff_values.is_empty():
		var sec_val = ab.get_secondary_buff_value(lvl) if ab.has_method("get_secondary_buff_value") else 0.0
		if sec_val != 0.0 and attribute_system != null:
			var sec_stat = ab.secondary_buff_stat if "secondary_buff_stat" in ab else StatModifier.TargetStat.MOVE_SPEED
			var sec_type = ab.secondary_buff_type if "secondary_buff_type" in ab else StatModifier.Type.PERCENT_ADD
			var sec_dur = ab.buff_duration if "buff_duration" in ab else 4.0
			var sec_source = "ab_sec_buff_" + ab.id
			attribute_system.remove_modifiers_by_source(sec_source)
			var sec_mod = StatModifier.new(sec_stat, sec_type, sec_val, sec_source, sec_dur)
			attribute_system.add_modifier(sec_mod)

	# 1. If ability targets an entity and deals damage
	if target_entity != null and target_entity.is_alive():
		var total_raw = _calculate_ability_damage(ab, lvl)
		
		if total_raw > 0.0:
			var req = DamageRequest.create_spell_damage(caster, target_entity, total_raw, ab.damage_type, ab.ability_name)
			var dmg_res = CombatCalculator.execute_damage(req)
			
			# Status effect application
			if ab.applies_status_effect and target_entity.effect_container != null:
				var eff = StatusEffect.new(ab.id + "_effect", ab.effect_type, ab.effect_duration, ab.effect_intensity)
				eff.source_entity = caster
				if ab.effect_type == StatusEffect.EffectType.KNOCKBACK:
					var knockback_origin = caster.global_position if caster != null and caster.is_inside_tree() else (caster.position if caster != null else Vector3.ZERO)
					eff.set_meta("knockback_origin", knockback_origin)
				target_entity.effect_container.apply_effect(eff)
				
			# Pull / Hook to caster or center
			if "pull_to_caster" in ab and ab.pull_to_caster and caster != null:
				var c_pos = caster.global_position if caster.is_inside_tree() else caster.position
				var t_pos_curr = target_entity.global_position if target_entity.is_inside_tree() else target_entity.position
				var p_dir = (c_pos - t_pos_curr).normalized()
				var new_p = c_pos - (p_dir * 1.5)
				if target_entity.is_inside_tree(): target_entity.global_position = new_p
				else: target_entity.position = new_p
				
			# Chain Bouncing
			if "chain_count" in ab and ab.chain_count > 0:
				var chain_targets = _find_chain_targets(caster, target_entity, ab.chain_count, ab.chain_bounce_radius)
				var chain_dmg = total_raw
				for ct in chain_targets:
					chain_dmg *= (1.0 - ab.chain_damage_falloff)
					var c_req = DamageRequest.create_spell_damage(caster, ct, chain_dmg, ab.damage_type, ab.ability_name)
					CombatCalculator.execute_damage(c_req)
				
			var t_pos = target_entity.global_position if target_entity.is_inside_tree() else target_entity.position
			ab.on_projectile_hit(caster, target_entity, t_pos)
			ability_target_hit.emit(slot, ab, target_entity, dmg_res)

	# 2. Directional Piercing Skillshot damage
	if ab.target_type == AbilityResource.TargetType.DIRECTIONAL and (target_entity == null or not is_instance_valid(target_entity)):
		var caster_pos = caster.global_position if (caster != null and caster.is_inside_tree()) else (caster.position if caster != null else Vector3.ZERO)
		var aim_dir = (target_point - caster_pos) if caster != null else Vector3.FORWARD
		aim_dir.y = 0.0
		if aim_dir.length_squared() < 0.01:
			aim_dir = -caster.global_transform.basis.z if (caster != null and caster.is_inside_tree()) else Vector3.FORWARD
		aim_dir = aim_dir.normalized()
		
		var max_range = ab.get_cast_range(lvl)
		if max_range <= 0.0: max_range = 12.0
		var width = ab.aoe_radius if ab.aoe_radius > 0.0 else 1.6
		var total_raw = _calculate_ability_damage(ab, lvl)
		
		var nodes: Array = []
		if is_inside_tree() and get_tree() != null:
			nodes = get_tree().get_nodes_in_group("combat_entities")
		else:
			nodes.append_array(HeroEntity.active_heroes)
			nodes.append_array(CreepEntity.active_creeps)
			
		for n in nodes:
			if n is BaseCombatEntity and n != caster and is_instance_valid(n) and n.is_alive() and ab.is_valid_target(caster, n):
				var n_pos = n.global_position if n.is_inside_tree() else n.position
				var to_enemy = n_pos - caster_pos
				to_enemy.y = 0.0
				var proj_dist = to_enemy.dot(aim_dir)
				if proj_dist >= 0.0 and proj_dist <= max_range:
					var perp_dist = (to_enemy - (aim_dir * proj_dist)).length()
					if perp_dist <= width:
						if total_raw > 0.0:
							var req = DamageRequest.create_spell_damage(caster, n, total_raw, ab.damage_type, ab.ability_name)
							var dmg_res = CombatCalculator.execute_damage(req)
							if ab.applies_status_effect and n.effect_container != null:
								var eff = StatusEffect.new(ab.id + "_effect", ab.effect_type, ab.effect_duration, ab.effect_intensity)
								eff.source_entity = caster
								if ab.effect_type == StatusEffect.EffectType.KNOCKBACK:
									eff.set_meta("knockback_origin", caster_pos)
								n.effect_container.apply_effect(eff)
							if "pull_to_caster" in ab and ab.pull_to_caster and caster != null:
								var p_dir = (caster_pos - n_pos).normalized()
								var new_p = caster_pos - (p_dir * 1.5)
								if n.is_inside_tree(): n.global_position = new_p
								else: n.position = new_p
							ability_target_hit.emit(slot, ab, n, dmg_res)
		
	# 3. Ground AoE / Area Spell damage and effects
	if target_point != Vector3.ZERO or ab.target_type == AbilityResource.TargetType.GROUND_AOE:
		var center = target_point if target_point != Vector3.ZERO else (caster.global_position if (caster != null and caster.is_inside_tree()) else Vector3.ZERO)
		var affected = execute_aoe_spell(slot, center)
		
		if ab.target_type == AbilityResource.TargetType.GROUND_AOE and ab.base_damage.size() > 0:
			var total_raw = _calculate_ability_damage(ab, lvl)
			
			if total_raw > 0.0:
				for target_enemy in affected:
					if target_enemy != null and is_instance_valid(target_enemy) and target_enemy.is_alive():
						var req = DamageRequest.create_spell_damage(caster, target_enemy, total_raw, ab.damage_type, ab.ability_name)
						var dmg_res = CombatCalculator.execute_damage(req)
						
						if ab.applies_status_effect and target_enemy.effect_container != null:
							var eff = StatusEffect.new(ab.id + "_effect", ab.effect_type, ab.effect_duration, ab.effect_intensity)
							eff.source_entity = caster
							if ab.effect_type == StatusEffect.EffectType.KNOCKBACK:
								eff.set_meta("knockback_origin", center)
							target_enemy.effect_container.apply_effect(eff)
							
						if "pull_to_center" in ab and ab.pull_to_center and center != Vector3.ZERO:
							if target_enemy.is_inside_tree(): target_enemy.global_position = center
							else: target_enemy.position = center
							
						ability_target_hit.emit(slot, ab, target_enemy, dmg_res)
						
		ab.on_aoe_triggered(caster, center, affected)
		if ab.area_duration > 0.0:
			var area_radius = ab.aoe_radius / 100.0 if ab.aoe_radius > 50.0 else ab.aoe_radius
			AreaEffectManagerClass.create_zone(caster, center, maxf(0.5, area_radius), ab.area_duration, ab.area_tick_interval, _calculate_ability_damage(ab, lvl), ab.damage_type, ab.applies_status_effect, ab.effect_type, ab.effect_duration, ab.effect_intensity, ab.ability_name)
			
	# 4. Dispatch RED / Special Mechanics
	_dispatch_special_mechanics(slot, ab, target_entity, target_point, lvl)

	ability_casted.emit(slot, ab)
	ability_cast_completed.emit(slot, ab)
	ability_executed.emit(slot, ab, target_entity, target_point)
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.ability_cast.emit(caster, ab, target_point, target_entity)
	SpellObserverSystemClass.record_cast(caster, ab, target_point, target_entity)
		
	_spawn_ability_visuals(slot, ab, target_entity, target_point)

func _calculate_ability_damage(ab: AbilityResource, lvl: int) -> float:
	var base_dmg = ab.get_base_damage(lvl)
	var scaling_val = attribute_system.get_stat(ab.scaling_stat) if attribute_system != null else 0.0
	var total_raw = base_dmg + (scaling_val * ab.scaling_ratio)
	
	if "conversion_source_stat" in ab and ab.conversion_source_stat >= 0 and attribute_system != null:
		total_raw += attribute_system.get_stat(ab.conversion_source_stat) * ab.conversion_ratio
		
	if "scale_by_missing_resource" in ab and ab.scale_by_missing_resource and attribute_system != null:
		var cur_hp = attribute_system.current_health
		var max_hp = maxf(1.0, attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
		var missing_ratio = 1.0 - clampf(cur_hp / max_hp, 0.0, 1.0)
		total_raw *= (1.0 + (missing_ratio * maxf(0.5, ab.conversion_ratio)))
		
	return total_raw

func _find_chain_targets(caster: BaseCombatEntity, initial_target: BaseCombatEntity, max_chains: int, radius: float) -> Array[BaseCombatEntity]:
	var result: Array[BaseCombatEntity] = []
	if initial_target == null or max_chains <= 0:
		return result
		
	var r = radius if radius > 0.0 else 5.0
	var nodes = HeroEntity.active_heroes
	var t_pos = initial_target.global_position if initial_target.is_inside_tree() else initial_target.position
	
	for n in nodes:
		if n is BaseCombatEntity and n != initial_target and n != caster and is_instance_valid(n) and n.is_alive() and n.team != caster.team:
			var n_pos = n.global_position if n.is_inside_tree() else n.position
			if t_pos.distance_to(n_pos) <= r:
				result.append(n)
				if result.size() >= max_chains:
					break
	return result

func _dispatch_special_mechanics(slot: AbilityResource.Slot, ab: AbilityResource, target_entity: BaseCombatEntity, target_point: Vector3, lvl: int) -> void:
	var caster = get_parent() as BaseCombatEntity
	if caster == null:
		return
	var c_pos = caster.global_position if caster.is_inside_tree() else caster.position
	var aim_point = target_point if target_point != Vector3.ZERO else (c_pos + Vector3(0, 0, -3.0))
	var ab_id = ab.id.to_lower()
	
	# Leap / Dash mechanics
	if "leap_height" in ab and (ab.leap_height > 0.0 or ab.is_reverse_dash):
		var dash_dest = aim_point
		if ab.is_reverse_dash:
			dash_dest = c_pos - (aim_point - c_pos).normalized() * ab.get_cast_range(lvl)
		if ab.stop_on_first_enemy:
			dash_dest = _stop_dash_at_first_enemy(caster, c_pos, dash_dest)
		_move_caster_to(caster, dash_dest, ab.leap_height)
		
	# Aethon Constructs
	if ab_id == "aethon_q":
		if caster != null and caster.has_method("cast_aethon_q"):
			caster.cast_aethon_q(aim_point)
		else:
			SummonManagerClass.spawn_construct(caster, SummonManagerClass.ConstructType.GUARDIAN, aim_point, 320.0 + (float(lvl) * 60.0), 35.0 + (float(lvl) * 10.0))
	elif ab_id == "aethon_w":
		if caster != null and caster.has_method("cast_aethon_w"):
			caster.cast_aethon_w(aim_point)
		else:
			SummonManagerClass.spawn_construct(caster, SummonManagerClass.ConstructType.CANNON, aim_point, 240.0 + (float(lvl) * 45.0), 50.0 + (float(lvl) * 15.0))
	elif ab_id == "aethon_e":
		if caster != null and caster.has_method("cast_aethon_e"):
			caster.cast_aethon_e()
		else:
			SummonManagerClass.reconfigure_constructs(caster)
	elif ab_id == "aethon_r":
		if caster != null and caster.has_method("cast_aethon_r"):
			caster.cast_aethon_r(aim_point)
		else:
			SummonManagerClass.assemble_siege_construct(caster, aim_point)
		
	# Rivena Shades
	elif ab_id == "rivena_q":
		if caster != null and caster.has_method("cast_rivena_q") and target_entity != null:
			caster.cast_rivena_q(target_entity)
		else:
			SummonManagerClass.spawn_shade(caster, c_pos)
	elif ab_id == "rivena_w":
		if caster != null and caster.has_method("cast_rivena_w"):
			caster.cast_rivena_w(aim_point)
		else:
			var swap_loc = SummonManagerClass.swap_with_shade(caster, aim_point)
			if swap_loc != Vector3.ZERO:
				if caster.is_inside_tree(): caster.global_position = swap_loc
				else: caster.position = swap_loc
	elif ab_id == "rivena_e":
		if caster != null and caster.has_method("cast_rivena_e") and target_entity != null:
			caster.cast_rivena_e(target_entity)
	elif ab_id == "rivena_r":
		if caster != null and caster.has_method("cast_rivena_r"):
			caster.cast_rivena_r()
			
	# Kaelgor Furnace Heart & Overheat
	elif ab_id == "kaelgor_q":
		if caster != null and caster.has_method("cast_kaelgor_q") and target_entity != null:
			caster.cast_kaelgor_q(target_entity)
	elif ab_id == "kaelgor_w":
		if caster != null and caster.has_method("cast_kaelgor_w"):
			caster.cast_kaelgor_w()
	elif ab_id == "kaelgor_e":
		if caster != null and caster.has_method("cast_kaelgor_e"):
			caster.cast_kaelgor_e()
	elif ab_id == "kaelgor_r":
		if caster != null and caster.has_method("cast_kaelgor_r"):
			caster.cast_kaelgor_r()
			
	# Solen Solar Archer
	elif ab_id == "solen_q":
		if caster != null and caster.has_method("_cast_piercing_arrow"):
			caster._cast_piercing_arrow(lvl, aim_point)
	elif ab_id == "solen_w":
		if caster != null and caster.has_method("_cast_blinding_flash"):
			caster._cast_blinding_flash(lvl)
	elif ab_id == "solen_e":
		if caster != null and caster.has_method("_cast_solar_vault"):
			caster._cast_solar_vault(lvl)
	elif ab_id == "solen_r":
		if caster != null and caster.has_method("_cast_supernova_barrage"):
			caster._cast_supernova_barrage(lvl, aim_point)
			
	# Grom Apex Stalker
	elif ab_id == "grom_q":
		if caster != null and caster.has_method("cast_grom_q") and target_entity != null:
			caster.cast_grom_q(target_entity)
	elif ab_id == "grom_w":
		if caster != null and caster.has_method("cast_grom_w"):
			caster.cast_grom_w()
	elif ab_id == "grom_e":
		if caster != null and caster.has_method("cast_grom_e"):
			caster.cast_grom_e(aim_point)
	elif ab_id == "grom_r":
		if caster != null and caster.has_method("cast_grom_r"):
			caster.cast_grom_r(target_entity)
			
	# Sera Astral Enchanter
	elif ab_id == "sera_q":
		if caster != null and caster.has_method("cast_sera_q") and target_entity != null:
			caster.cast_sera_q(target_entity)
	elif ab_id == "sera_w":
		if caster != null and caster.has_method("cast_sera_w"):
			caster.cast_sera_w(target_entity)
	elif ab_id == "sera_e":
		if caster != null and caster.has_method("cast_sera_e"):
			caster.cast_sera_e(target_entity)
	elif ab_id == "sera_r":
		if caster != null and caster.has_method("cast_sera_r"):
			caster.cast_sera_r()
			
	# Nymera Chrono Weaver
	elif ab_id == "nymera_q":
		if caster != null and caster.has_method("cast_nymera_q"):
			caster.cast_nymera_q(aim_point)
	elif ab_id == "nymera_w":
		if caster != null and caster.has_method("cast_nymera_w") and target_entity != null:
			caster.cast_nymera_w(target_entity)
		else:
			var t = target_entity if target_entity != null else caster
			StateHistorySystemClass.rewind_entity(t, 3.0, Time.get_ticks_msec() / 1000.0)
	elif ab_id == "nymera_e":
		if caster != null and caster.has_method("cast_nymera_e") and target_entity != null:
			caster.cast_nymera_e(target_entity)
	elif ab_id == "nymera_r":
		if caster != null and caster.has_method("cast_nymera_r"):
			caster.cast_nymera_r(aim_point)
		else:
			var t = target_entity if target_entity != null else caster
			var dmg_window = StateHistorySystemClass.get_damage_taken_in_window(t, 4.0, Time.get_ticks_msec() / 1000.0)
			if dmg_window > 0.0:
				var req = DamageRequest.create_spell_damage(caster, t, minf(dmg_window * 0.45, 450.0), DamageRequest.DamageType.MAGICAL, "Temporal Collapse")
				CombatCalculator.execute_damage(req)
			
	# Neris Spatial Architecture
	elif ab_id == "neris_q":
		if caster != null and caster.has_method("cast_neris_q"):
			caster.cast_neris_q(c_pos + Vector3(-3, 0, 0), aim_point)
		else:
			SpatialManagerClass.create_node(caster, aim_point)
	elif ab_id == "neris_w":
		if caster != null and caster.has_method("cast_neris_w"):
			caster.cast_neris_w()
		else:
			SpatialManagerClass.create_wall(caster, aim_point + Vector3(-3, 0, 0), aim_point + Vector3(3, 0, 0))
	elif ab_id == "neris_e":
		if caster != null and caster.has_method("cast_neris_e"):
			caster.cast_neris_e(c_pos, aim_point)
		else:
			SpatialManagerClass.create_gate(caster, c_pos, aim_point)
	elif ab_id == "neris_r":
		if caster != null and caster.has_method("cast_neris_r"):
			caster.cast_neris_r(aim_point)
		else:
			SpatialManagerClass.create_node(caster, aim_point + Vector3(-4, 0, -4))
			SpatialManagerClass.create_node(caster, aim_point + Vector3(4, 0, -4))
			SpatialManagerClass.create_node(caster, aim_point + Vector3(4, 0, 4))
			SpatialManagerClass.create_node(caster, aim_point + Vector3(-4, 0, 4))
			
	# Durn Heavy Artillery & Siege Mode
	elif ab_id == "durn_q":
		if caster != null and caster.has_method("cast_durn_q"):
			caster.cast_durn_q(aim_point)
	elif ab_id == "durn_w":
		if caster != null and caster.has_method("cast_durn_w"):
			caster.cast_durn_w()
	elif ab_id == "durn_e":
		if caster != null and caster.has_method("cast_durn_e"):
			caster.cast_durn_e(aim_point)
	elif ab_id == "durn_r":
		if caster != null and caster.has_method("cast_durn_r"):
			caster.cast_durn_r(aim_point)
		
	# Seris Traps & Detonation
	elif ab_id == "seris_q":
		if caster != null and caster.has_method("cast_seris_q") and target_entity != null:
			caster.cast_seris_q(target_entity)
	elif ab_id == "seris_w":
		if caster != null and caster.has_method("cast_seris_w"):
			caster.cast_seris_w(aim_point)
		else:
			SpatialManagerClass.place_trap(caster, aim_point)
	elif ab_id == "seris_e":
		if caster != null and caster.has_method("cast_seris_e"):
			caster.cast_seris_e()
		else:
			SpatialManagerClass.detonate_all_traps(caster)
	elif ab_id == "seris_r":
		if caster != null and caster.has_method("cast_seris_r"):
			caster.cast_seris_r(aim_point)
		else:
			for offset in [Vector3(-3, 0, 0), Vector3(3, 0, 0), Vector3(0, 0, -3), Vector3(0, 0, 3)]:
				SpatialManagerClass.place_trap(caster, aim_point + offset)
				
	# Noctis Sensory Thief
	elif ab_id == "noctis_q":
		if caster != null and caster.has_method("cast_noctis_q") and target_entity != null:
			caster.cast_noctis_q(target_entity)
	elif ab_id == "noctis_w":
		if caster != null and caster.has_method("cast_noctis_w"):
			caster.cast_noctis_w()
	elif ab_id == "noctis_e":
		if caster != null and caster.has_method("cast_noctis_e") and target_entity != null:
			caster.cast_noctis_e(target_entity)
	elif ab_id == "noctis_r":
		if caster != null and caster.has_method("cast_noctis_r"):
			caster.cast_noctis_r(aim_point)
			
	# Kaeli Rhythm Blade & Tempo
	elif ab_id == "kaeli_q":
		if caster != null and caster.has_method("cast_kaeli_q") and target_entity != null:
			caster.cast_kaeli_q(target_entity)
	elif ab_id == "kaeli_w":
		if caster != null and caster.has_method("cast_kaeli_w"):
			caster.cast_kaeli_w()
	elif ab_id == "kaeli_e":
		if caster != null and caster.has_method("cast_kaeli_e"):
			caster.cast_kaeli_e()
	elif ab_id == "kaeli_r":
		if caster != null and caster.has_method("cast_kaeli_r"):
			caster.cast_kaeli_r()
			
	# Nixe Wall-Crawler & Arachnid Ambush
	elif ab_id == "nixe_q":
		if caster != null and caster.has_method("cast_nixe_q"):
			caster.cast_nixe_q(aim_point)
	elif ab_id == "nixe_w":
		if caster != null and caster.has_method("cast_nixe_w"):
			caster.cast_nixe_w(aim_point)
	elif ab_id == "nixe_e":
		if caster != null and caster.has_method("cast_nixe_e"):
			caster.cast_nixe_e()
	elif ab_id == "nixe_r":
		if caster != null and caster.has_method("cast_nixe_r") and target_entity != null:
			caster.cast_nixe_r(target_entity)
			
	# Zin Mirror Dancer & Prismatic Clones
	elif ab_id == "zin_q":
		if caster != null and caster.has_method("cast_zin_q"):
			caster.cast_zin_q(aim_point)
	elif ab_id == "zin_w":
		if caster != null and caster.has_method("cast_zin_w"):
			caster.cast_zin_w()
	elif ab_id == "zin_e":
		if caster != null and caster.has_method("cast_zin_e"):
			caster.cast_zin_e()
	elif ab_id == "zin_r":
		if caster != null and caster.has_method("cast_zin_r"):
			caster.cast_zin_r(aim_point)
			
	# Geras Tectonic Architect & Earth Shaping
	elif ab_id == "geras_q":
		if caster != null and caster.has_method("cast_geras_q"):
			caster.cast_geras_q(aim_point)
	elif ab_id == "geras_w":
		if caster != null and caster.has_method("cast_geras_w"):
			caster.cast_geras_w(aim_point)
	elif ab_id == "geras_e":
		if caster != null and caster.has_method("cast_geras_e"):
			caster.cast_geras_e(aim_point)
	elif ab_id == "geras_r":
		if caster != null and caster.has_method("cast_geras_r"):
			caster.cast_geras_r(aim_point)
			
	# Lyra Ethereal Symbiote & Friendly Tether
	elif ab_id == "lyra_q":
		if caster != null and caster.has_method("cast_lyra_q") and target_entity != null:
			caster.cast_lyra_q(target_entity)
	elif ab_id == "lyra_w":
		if caster != null and caster.has_method("cast_lyra_w"):
			caster.cast_lyra_w()
	elif ab_id == "lyra_e":
		if caster != null and caster.has_method("cast_lyra_e"):
			caster.cast_lyra_e()
	elif ab_id == "lyra_r":
		if caster != null and caster.has_method("cast_lyra_r"):
			caster.cast_lyra_r(aim_point)
			
	# Veylin Mimicry & Counterspell
	elif ab_id == "veylin_q":
		if caster != null and caster.has_method("cast_veylin_q") and target_entity != null:
			caster.cast_veylin_q(target_entity)
	elif ab_id == "veylin_w":
		if caster != null and caster.has_method("cast_veylin_w"):
			caster.cast_veylin_w()
		else:
			SpellObserverSystemClass.try_counter_spell(caster, "Target Spell")
	elif ab_id == "veylin_e":
		if caster != null and caster.has_method("cast_veylin_e"):
			caster.cast_veylin_e()
	elif ab_id == "veylin_r":
		if caster != null and caster.has_method("cast_veylin_r"):
			caster.cast_veylin_r(aim_point)
		else:
			var mimicked = SpellObserverSystemClass.mimic_ability(caster, target_entity)
			if mimicked != null:
				set_ability(AbilityResource.Slot.R, mimicked)
			
	# Combat Tethers & Selka Cursesmith
	elif ab_id == "selka_q":
		if caster != null and caster.has_method("cast_selka_q") and target_entity != null:
			caster.cast_selka_q(target_entity)
	elif ab_id == "selka_w":
		if caster != null and caster.has_method("cast_selka_w"):
			caster.cast_selka_w(aim_point)
	elif ab_id == "selka_e":
		if caster != null and caster.has_method("cast_selka_e"):
			caster.cast_selka_e()
	elif ab_id == "selka_r":
		if caster != null and caster.has_method("cast_selka_r"):
			caster.cast_selka_r()
		elif target_entity != null:
			TetherManagerClass.create_tether(caster, target_entity, TetherManagerClass.TetherType.LIFE_LINK, 0.40, 5.0)
	elif ab_id == "oryn_r" and target_entity != null:
		TetherManagerClass.create_tether(caster, target_entity, TetherManagerClass.TetherType.SOUL_LINK, 0.40, 6.0)
	elif ab_id == "auron_r" and target_entity != null:
		TetherManagerClass.create_tether(caster, target_entity, TetherManagerClass.TetherType.IRON_TETHER, 0.30, 4.5)
	elif ab_id == "tharos_w" and target_entity != null:
		TetherManagerClass.create_tether(caster, target_entity, TetherManagerClass.TetherType.COLOSSUS_GUARD, 0.35, 4.0)

func _move_caster_to(caster: BaseCombatEntity, destination: Vector3, leap_height: float = 0.0) -> void:
	if caster == null:
		return
	if not caster.is_inside_tree() or leap_height <= 0.0:
		if caster.is_inside_tree():
			caster.global_position = destination
		else:
			caster.position = destination
		return
	# A short two-part arc makes leap skills readable without changing the final
	# movement contract used by controllers and headless combat tests.
	var start = caster.global_position
	var apex = start.lerp(destination, 0.5)
	apex.y = maxf(start.y, destination.y) + leap_height
	var leap_tween = caster.create_tween()
	leap_tween.tween_property(caster, "global_position", apex, 0.14).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	leap_tween.tween_property(caster, "global_position", destination, 0.16).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

func _stop_dash_at_first_enemy(caster: BaseCombatEntity, start: Vector3, desired_destination: Vector3) -> Vector3:
	var path = desired_destination - start
	path.y = 0.0
	var path_length = path.length()
	if path_length <= 0.01:
		return desired_destination
	var direction = path / path_length
	var first_distance := INF
	for candidate in _get_active_combat_entities():
		if not caster.is_enemy_with(candidate) or not candidate.is_targetable:
			continue
		var candidate_pos = candidate.global_position if candidate.is_inside_tree() else candidate.position
		var relative = candidate_pos - start
		relative.y = 0.0
		var along = relative.dot(direction)
		if along <= 0.0 or along > path_length:
			continue
		var lateral = (relative - direction * along).length()
		if lateral <= 0.9 and along < first_distance:
			first_distance = along
	if first_distance == INF:
		return desired_destination
	var stop_distance = maxf(0.0, first_distance - 0.85)
	var result = start + direction * stop_distance
	result.y = desired_destination.y
	return result

func _get_active_combat_entities() -> Array[BaseCombatEntity]:
	var result: Array[BaseCombatEntity] = []
	for hero in HeroEntity.active_heroes:
		if is_instance_valid(hero) and hero.is_alive():
			result.append(hero)
	for creep in CreepEntity.active_creeps:
		if is_instance_valid(creep) and creep.is_alive():
			result.append(creep)
	return result

const BESPOKE_ABILITY_VFX: Dictionary = {
	"aethon_q": "res://scenes/effects/aethon_summon_ring_3d.gd",
	"aethon_w": "res://scenes/effects/aethon_summon_ring_3d.gd",
	"aethon_e": "res://scenes/effects/aethon_reconfigure_burst_3d.gd",
	"aethon_r": "res://scenes/effects/aethon_siege_slam_3d.gd",
	"durn_q": "res://scenes/effects/durn_concussion_blast_3d.gd",
	"durn_w": "res://scenes/effects/durn_mortar_impact_3d.gd",
	"durn_e": "res://scenes/effects/durn_siege_deploy_3d.gd",
	"durn_r": "res://scenes/effects/durn_orbital_barrage_3d.gd",
	"geras_q": "res://scenes/effects/geras_tectonic_fissure_3d.gd",
	"geras_w": "res://scenes/effects/geras_granite_wall_3d.gd",
	"geras_e": "res://scenes/effects/geras_quicksand_3d.gd",
	"geras_r": "res://scenes/effects/geras_tectonic_fissure_3d.gd",
	"grom_q": "res://scenes/effects/grom_claw_slash_3d.gd",
	"grom_w": "res://scenes/effects/grom_dread_roar_3d.gd",
	"grom_r": "res://scenes/effects/grom_apex_hunt_aura_3d.gd",
	"kaelgor_q": "res://scenes/effects/kaelgor_molten_fist_3d.gd",
	"kaelgor_w": "res://scenes/effects/kaelgor_vent_blast_3d.gd",
	"kaelgor_r": "res://scenes/effects/kaelgor_overheat_aura_3d.gd",
	"kaeli_q": "res://scenes/effects/kaeli_twin_slice_3d.gd",
	"kaeli_w": "res://scenes/effects/kaeli_tempo_burst_3d.gd",
	"lyra_w": "res://scenes/effects/lyra_tether_beam_3d.gd",
	"lyra_r": "res://scenes/effects/lyra_cosmic_portal_3d.gd",
	"neris_q": "res://scenes/effects/neris_arcane_pylon_3d.gd",
	"neris_w": "res://scenes/effects/neris_energy_wall_3d.gd",
	"neris_e": "res://scenes/effects/neris_prism_prison_3d.gd",
	"neris_r": "res://scenes/effects/neris_wormhole_gate_3d.gd",
	"nixe_q": "res://scenes/effects/nixe_acid_web_3d.gd",
	"nixe_r": "res://scenes/effects/nixe_toxic_cocoon_3d.gd",
	"noctis_q": "res://scenes/effects/noctis_shadow_strike_3d.gd",
	"noctis_r": "res://scenes/effects/noctis_total_eclipse_3d.gd",
	"nymera_w": "res://scenes/effects/nymera_time_bubble_3d.gd",
	"nymera_e": "res://scenes/effects/nymera_rewind_trail_3d.gd",
	"nymera_r": "res://scenes/effects/nymera_temporal_collapse_3d.gd",
	"rivena_q": "res://scenes/effects/rivena_shadow_slash_3d.gd",
	"rivena_w": "res://scenes/effects/rivena_echo_step_burst_3d.gd",
	"rivena_e": "res://scenes/effects/rivena_shadow_slash_3d.gd",
	"rivena_r": "res://scenes/effects/rivena_nightfall_shroud_3d.gd",
	"selka_w": "res://scenes/effects/selka_ember_ring_3d.gd",
	"selka_e": "res://scenes/effects/selka_curse_detonate_3d.gd",
	"selka_r": "res://scenes/effects/selka_cataclysm_beam_3d.gd",
	"sera_q": "res://scenes/effects/sera_astral_surge_3d.gd",
	"sera_r": "res://scenes/effects/sera_astral_surge_3d.gd",
	"seris_w": "res://scenes/effects/seris_razor_mine_3d.gd",
	"seris_e": "res://scenes/effects/seris_trap_explosion_3d.gd",
	"seris_r": "res://scenes/effects/seris_hunting_ground_3d.gd",
	"veylin_q": "res://scenes/effects/veylin_adaptation_cone_3d.gd",
	"veylin_w": "res://scenes/effects/veylin_counterspell_barrier_3d.gd",
	"zin_q": "res://scenes/effects/zin_glass_shatter_3d.gd",
	"zin_w": "res://scenes/effects/zin_mirror_clone_3d.gd",
	"zin_r": "res://scenes/effects/zin_hall_of_mirrors_3d.gd",
}

func _spawn_ability_visuals(slot: AbilityResource.Slot, ab: AbilityResource, target_entity: BaseCombatEntity, target_point: Vector3) -> void:
	var caster = get_parent()
	if caster == null or not caster.is_inside_tree() or get_tree() == null:
		return
	var m_root = caster.get_parent()
	if m_root == null:
		return
		
	var c_pos = caster.global_position + Vector3(0, 1.2, 0)
	var spawn_pos = target_point if target_point != Vector3.ZERO else (target_entity.global_position if (target_entity != null and is_instance_valid(target_entity) and target_entity.is_inside_tree()) else caster.global_position)
	var ab_id = ab.id.to_lower()
	
	# 1. Check for Bespoke Hero-Specific 3D VFX
	if BESPOKE_ABILITY_VFX.has(ab_id):
		var vfx_path = BESPOKE_ABILITY_VFX[ab_id]
		if ResourceLoader.exists(vfx_path):
			var vfx_res = load(vfx_path)
			if vfx_res != null:
				var vfx_node = vfx_res.new()
				m_root.add_child(vfx_node)
				if vfx_node.has_method("setup"):
					vfx_node.setup(c_pos, spawn_pos)
				else:
					vfx_node.global_position = spawn_pos
				return

	# 2. Thematic Archetype-Based Fallback
	var v_col = _get_ability_vfx_color(ab)
	var ab_desc = (ab.ability_name + " " + ab.description).to_lower()
	var forward_dir = -caster.global_transform.basis.z
	if target_point != Vector3.ZERO:
		forward_dir = (target_point - caster.global_position).normalized()
	forward_dir.y = 0.0
	forward_dir = forward_dir.normalized()
	
	# A. Slashing / Melee Blade (Grom, Rivena, Talon, Kaeli, etc.)
	if ab_desc.contains("kesme") or ab_desc.contains("kılıç") or ab_desc.contains("pençe") or ab_desc.contains("slash") or ab_desc.contains("blade") or ab_desc.contains("rend") or ab_desc.contains("cleave"):
		SpellVisualFX3DClass.spawn_slash_arc(m_root, c_pos, forward_dir, maxf(2.5, ab.aoe_radius if ab.aoe_radius > 0 else 3.0), v_col)
		return
		
	# B. Lightning / Thunder / Electric (Astran, Lyra, Kaelen, etc.)
	if ab_desc.contains("yıldırım") or ab_desc.contains("şimşek") or ab_desc.contains("elektrik") or ab_desc.contains("lightning") or ab_desc.contains("thunder") or ab_desc.contains("bolt") or ab_desc.contains("shock"):
		SpellVisualFX3DClass.spawn_lightning_strike(m_root, spawn_pos, v_col)
		return
		
	# C. Shadow / Curse / Void / Poison (Noctis, Selka, Nixe, Mora, Mordren, etc.)
	if ab_desc.contains("gölge") or ab_desc.contains("lanet") or ab_desc.contains("zehir") or ab_desc.contains("karanlık") or ab_desc.contains("shadow") or ab_desc.contains("curse") or ab_desc.contains("void") or ab_desc.contains("poison") or ab_desc.contains("abyss"):
		SpellVisualFX3DClass.spawn_shadow_vortex(m_root, spawn_pos, maxf(2.5, ab.aoe_radius if ab.aoe_radius > 0 else 3.5), 2.5, v_col)
		return
		
	# D. Shield / Barrier / Defense (Veylin, Sera, Neris, etc.)
	if ab.target_type == AbilityResource.TargetType.SELF and ("is_shielding_ability" in ab and ab.is_shielding_ability or ab_desc.contains("kalkan") or ab_desc.contains("zırh") or ab_desc.contains("barrier") or ab_desc.contains("shield")):
		SpellVisualFX3DClass.spawn_shield_bubble(caster, ab.effect_duration if ab.effect_duration > 0 else 3.0, v_col)
		return
		
	# E. Earth / Slam / Quake (Brakka, Gorak, Geras, etc.)
	if ab.damage_type == DamageRequest.DamageType.PHYSICAL or ab_desc.contains("ezme") or ab_desc.contains("deprem") or ab_desc.contains("çarpma") or ab_desc.contains("slam") or ab_desc.contains("smash") or ab_desc.contains("quake") or ab_desc.contains("crush"):
		SpellVisualFX3DClass.spawn_ground_slam(m_root, spawn_pos, maxf(2.5, ab.aoe_radius if ab.aoe_radius > 0 else 4.0), v_col)
		return

	# F. Standard Target-Type Resolution
	match ab.target_type:
		AbilityResource.TargetType.SINGLE_TARGET:
			if target_entity != null and is_instance_valid(target_entity):
				HomingSpellProjectile3DClass.launch(m_root, c_pos, target_entity, 22.0, v_col, 2.5)
			else:
				SpellVisualFX3DClass.spawn_arcane_burst(m_root, spawn_pos, 2.5, v_col)
				
		AbilityResource.TargetType.DIRECTIONAL:
			var range_val = ab.get_cast_range(1)
			if range_val > 50.0: range_val = range_val / 100.0
			range_val = maxf(6.0, range_val)
			SkillshotProjectile3DClass.launch(m_root, c_pos, forward_dir, 24.0, range_val, v_col, 2.5)
			
		AbilityResource.TargetType.GROUND_AOE:
			var aoe_r = ab.aoe_radius if ab.aoe_radius > 0.0 else 3.5
			if aoe_r > 50.0: aoe_r = aoe_r / 100.0
			aoe_r = maxf(2.0, aoe_r)
			SpellVisualFX3DClass.spawn_orbital_starfall(m_root, spawn_pos, aoe_r, v_col)
			
		AbilityResource.TargetType.SELF:
			SpellVisualFX3DClass.spawn_arcane_burst(m_root, caster.global_position, 3.0, v_col)
			
		_:
			SpellVisualFX3DClass.spawn_arcane_burst(m_root, spawn_pos, 2.5, v_col)

func _get_ability_vfx_color(ab: AbilityResource) -> Color:
	var desc = (ab.ability_name + " " + ab.description).to_lower()
	if desc.contains("güneş") or desc.contains("solar") or desc.contains("fire") or desc.contains("ateş") or desc.contains("lav") or desc.contains("magma"):
		return Color(1.0, 0.55, 0.1) # Solar Flame Orange
	elif desc.contains("zehir") or desc.contains("toxic") or desc.contains("asit") or desc.contains("acid"):
		return Color(0.35, 0.95, 0.25) # Acid Green
	elif desc.contains("gölge") or desc.contains("karanlık") or desc.contains("shadow") or desc.contains("void") or desc.contains("eclipse"):
		return Color(0.65, 0.20, 0.85) # Shadow Violet
	elif desc.contains("yıldız") or desc.contains("astral") or desc.contains("kozmik") or desc.contains("star"):
		return Color(0.50, 0.85, 1.0) # Astral Blue
	elif desc.contains("şimşek") or desc.contains("yıldırım") or desc.contains("lightning") or desc.contains("thunder"):
		return Color(0.30, 0.90, 1.0) # Lightning Cyan
	elif desc.contains("kan") or desc.contains("crimson") or desc.contains("blood"):
		return Color(0.95, 0.15, 0.15) # Blood Red
		
	if ab.damage_type == DamageRequest.DamageType.PHYSICAL:
		return Color(1.0, 0.45, 0.15) # Warm Orange / Ember
	elif ab.damage_type == DamageRequest.DamageType.TRUE_DAMAGE:
		return Color(1.0, 0.88, 0.25) # Holy Gold
	elif ab.scaling_stat == StatModifier.TargetStat.ABILITY_POWER:
		return Color(0.3, 0.75, 1.0) # Arcane Cyan
	else:
		return Color(0.65, 0.35, 1.0) # Astral Purple
