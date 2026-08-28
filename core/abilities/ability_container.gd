class_name AbilityContainer
extends Node

const HomingSpellProjectile3DClass = preload("res://scenes/effects/homing_spell_projectile_3d.gd")
const SkillshotProjectile3DClass = preload("res://scenes/effects/skillshot_projectile_3d.gd")
const SpellVisualFX3DClass = preload("res://scenes/effects/spell_visual_fx_3d.gd")

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
	var caster_pos = caster.global_position if (caster != null and (caster.is_inside_tree() or caster.global_position != Vector3.ZERO)) else (caster.position if caster != null else Vector3.ZERO)
	
	# Target validations
	match ab.target_type:
		AbilityResource.TargetType.SELF:
			if target_entity != null and target_entity != caster:
				return CastValidationResult.INVALID_TARGET
				
		AbilityResource.TargetType.SINGLE_TARGET:
			if target_entity != null:
				if not is_instance_valid(target_entity) or not target_entity.is_alive():
					return CastValidationResult.TARGET_DEAD
				if not target_entity.is_targetable:
					return CastValidationResult.TARGET_NOT_TARGETABLE
				if not ab.is_valid_target(caster, target_entity):
					return CastValidationResult.INVALID_TARGET
				var target_pos = target_entity.global_position if (target_entity.is_inside_tree() or target_entity.global_position != Vector3.ZERO) else target_entity.position
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

func start_cast(slot: AbilityResource.Slot, target_entity: BaseCombatEntity = null, target_point: Vector3 = Vector3.ZERO) -> bool:
	var validation = validate_cast(slot, target_entity, target_point)
	if validation != CastValidationResult.OK:
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
	current_cast_state = CastState.IDLE
	current_cast_time_remaining = 0.0
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
			var n_pos = n.global_position if (n.is_inside_tree() or n.global_position != Vector3.ZERO) else n.position
			if center_pos.distance_to(n_pos) <= radius:
				if ab.is_valid_target(caster, n):
					affected.append(n)
					
	return affected

func cast_ability(slot: AbilityResource.Slot, target_entity: BaseCombatEntity = null, target_point: Vector3 = Vector3.ZERO) -> bool:
	var validation = validate_cast(slot, target_entity, target_point)
	if validation != CastValidationResult.OK:
		return false
		
	_execute_ability(slot, target_entity, target_point)
	return true

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
		
	var cur_pos = caster.global_position if (caster.is_inside_tree() or caster.global_position != Vector3.ZERO) else caster.position
	var dir = -caster.transform.basis.z.normalized()
	if target_point != Vector3.ZERO:
		dir = (target_point - cur_pos).normalized()
		dir.y = 0.0
		
	var dest = cur_pos + (dir * dist)
	if caster.is_inside_tree():
		caster.global_position = dest
	else:
		caster.position = dest
		
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
		
	var cur_pos = caster.global_position if (caster.is_inside_tree() or caster.global_position != Vector3.ZERO) else caster.position
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
		target.attribute_system.heal(heal_amt)
	return heal_amt

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
		var eff = StatusEffect.new(ab.id + "_shield", StatusEffect.EffectType.SHIELD, dur, shield_amt)
		target.effect_container.apply_effect(eff)
	return shield_amt

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
	
	# If ability targets an entity and deals damage
	if target_entity != null and target_entity.is_alive():
		var base_dmg = ab.get_base_damage(lvl)
		var scaling_val = attribute_system.get_stat(ab.scaling_stat) if attribute_system != null else 0.0
		var total_raw = base_dmg + (scaling_val * ab.scaling_ratio)
		
		var req = DamageRequest.create_spell_damage(get_parent(), target_entity, total_raw, ab.damage_type, ab.ability_name)
		var dmg_res = CombatCalculator.execute_damage(req)
		
		# Status effect application
		if ab.applies_status_effect and target_entity.effect_container != null:
			var eff = StatusEffect.new(ab.id + "_effect", ab.effect_type, ab.effect_duration, ab.effect_intensity)
			eff.source_entity = get_parent()
			target_entity.effect_container.apply_effect(eff)
			
		var t_pos = target_entity.global_position if (target_entity.is_inside_tree() or target_entity.global_position != Vector3.ZERO) else target_entity.position
		ab.on_projectile_hit(caster, target_entity, t_pos)
		ability_target_hit.emit(slot, ab, target_entity, dmg_res)
		
	if target_point != Vector3.ZERO or ab.target_type == AbilityResource.TargetType.GROUND_AOE:
		var center = target_point if target_point != Vector3.ZERO else (caster.global_position if (caster != null and caster.is_inside_tree()) else Vector3.ZERO)
		var affected = execute_aoe_spell(slot, center)
		ab.on_aoe_triggered(caster, center, affected)
			
	ability_casted.emit(slot, ab)
	ability_cast_completed.emit(slot, ab)
	ability_executed.emit(slot, ab, target_entity, target_point)
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.ability_cast.emit(caster, ab, target_point, target_entity)
		
	_spawn_ability_visuals(slot, ab, target_entity, target_point)

func _spawn_ability_visuals(slot: AbilityResource.Slot, ab: AbilityResource, target_entity: BaseCombatEntity, target_point: Vector3) -> void:
	var caster = get_parent()
	if caster == null or not caster.is_inside_tree() or get_tree() == null:
		return
	var m_root = caster.get_parent()
	if m_root == null:
		return
		
	var c_pos = caster.global_position + Vector3(0, 1.2, 0)
	var v_col = _get_ability_vfx_color(ab)
	
	match ab.target_type:
		AbilityResource.TargetType.SINGLE_TARGET:
			if target_entity != null and is_instance_valid(target_entity):
				HomingSpellProjectile3DClass.launch(m_root, c_pos, target_entity, 20.0, v_col, 2.5)
			else:
				SpellVisualFX3DClass.spawn_arcane_burst(m_root, c_pos, 2.5, v_col)
				
		AbilityResource.TargetType.DIRECTIONAL:
			var dir = (target_point - caster.global_position).normalized() if target_point != Vector3.ZERO else -caster.global_transform.basis.z
			dir.y = 0.0
			dir = dir.normalized()
			var range_val = ab.get_cast_range(1)
			if range_val > 50.0: range_val = range_val / 100.0
			range_val = maxf(6.0, range_val)
			SkillshotProjectile3DClass.launch(m_root, c_pos, dir, 22.0, range_val, v_col, 2.5)
			
		AbilityResource.TargetType.GROUND_AOE:
			var center = target_point if target_point != Vector3.ZERO else caster.global_position
			var aoe_r = ab.aoe_radius if ab.aoe_radius > 0.0 else 3.5
			if aoe_r > 50.0: aoe_r = aoe_r / 100.0
			aoe_r = maxf(2.0, aoe_r)
			if ab.damage_type == DamageRequest.DamageType.PHYSICAL:
				SpellVisualFX3DClass.spawn_ground_slam(m_root, center, aoe_r, v_col)
			else:
				SpellVisualFX3DClass.spawn_orbital_starfall(m_root, center, aoe_r, v_col)
				
		AbilityResource.TargetType.SELF:
			if "is_shielding_ability" in ab and ab.is_shielding_ability:
				SpellVisualFX3DClass.spawn_shield_bubble(caster, ab.effect_duration if ab.effect_duration > 0 else 3.0, v_col)
			else:
				SpellVisualFX3DClass.spawn_arcane_burst(m_root, caster.global_position, 3.0, v_col)
				
		_:
			SpellVisualFX3DClass.spawn_arcane_burst(m_root, caster.global_position, 2.0, v_col)

func _get_ability_vfx_color(ab: AbilityResource) -> Color:
	if ab.damage_type == DamageRequest.DamageType.PHYSICAL:
		return Color(1.0, 0.45, 0.15) # Warm Orange / Ember
	elif ab.damage_type == DamageRequest.DamageType.TRUE_DAMAGE:
		return Color(1.0, 0.88, 0.25) # Holy Gold
	elif ab.scaling_stat == StatModifier.TargetStat.ABILITY_POWER:
		return Color(0.3, 0.75, 1.0) # Arcane Cyan
	else:
		return Color(0.65, 0.35, 1.0) # Astral Purple
