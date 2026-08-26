class_name AbilityContainer
extends Node

## Manages active ability slots, cooldown timers, level progression, and spellcasting

signal ability_casted(slot: AbilityResource.Slot, ability: AbilityResource)
signal ability_learned(slot: AbilityResource.Slot, ability: AbilityResource)
signal ability_leveled(slot: AbilityResource.Slot, new_level: int)
signal cooldown_ticked(slot: AbilityResource.Slot, remaining: float, total: float)
signal skill_points_updated(points: int)
signal ability_cast_started(slot: AbilityResource.Slot, ability: AbilityResource, cast_time: float)
signal ability_cast_interrupted(slot: AbilityResource.Slot, reason: String)
signal ability_cast_completed(slot: AbilityResource.Slot, ability: AbilityResource)

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

func _init_slot_structures() -> void:
	for s in [AbilityResource.Slot.PASSIVE, AbilityResource.Slot.Q, AbilityResource.Slot.W, AbilityResource.Slot.E, AbilityResource.Slot.R]:
		if not abilities.has(s):
			abilities[s] = null
			ability_levels[s] = 1 if s == AbilityResource.Slot.PASSIVE else 0
			cooldown_timers[s] = 0.0
			max_cooldown_timers[s] = 0.0

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

func add_ability(slot: AbilityResource.Slot, res: AbilityResource) -> void:
	abilities[slot] = res
	if not ability_levels.has(slot):
		ability_levels[slot] = 1 if slot == AbilityResource.Slot.PASSIVE else 0
	cooldown_timers[slot] = 0.0
	max_cooldown_timers[slot] = 0.0
	ability_learned.emit(slot, res)

func set_ability(slot: AbilityResource.Slot, ability: AbilityResource) -> void:
	abilities[slot] = ability
	if ability != null and ability.is_passive:
		ability_levels[slot] = 1

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

func level_up_ability(slot: AbilityResource.Slot) -> bool:
	var ab: AbilityResource = abilities.get(slot)
	if ab == null or available_skill_points <= 0:
		return false
		
	var cur_lvl = ability_levels.get(slot, 0)
	if cur_lvl >= ab.max_level:
		return false
		
	ability_levels[slot] = cur_lvl + 1
	available_skill_points -= 1
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
	
	# If ability targets an entity and deals damage
	if target_entity != null and target_entity.is_alive():
		var base_dmg = ab.get_base_damage(lvl)
		var scaling_val = attribute_system.get_stat(ab.scaling_stat) if attribute_system != null else 0.0
		var total_raw = base_dmg + (scaling_val * ab.scaling_ratio)
		
		var req = DamageRequest.create_spell_damage(get_parent(), target_entity, total_raw, ab.damage_type, ab.ability_name)
		CombatCalculator.execute_damage(req)
		
		# Status effect application
		if ab.applies_status_effect and target_entity.effect_container != null:
			var eff = StatusEffect.new(ab.id + "_effect", ab.effect_type, ab.effect_duration, ab.effect_intensity)
			eff.source_entity = get_parent()
			target_entity.effect_container.apply_effect(eff)
			
		var t_pos = target_entity.global_position if (target_entity.is_inside_tree() or target_entity.global_position != Vector3.ZERO) else target_entity.position
		ab.on_projectile_hit(caster, target_entity, t_pos)
		
	if target_point != Vector3.ZERO or ab.target_type == AbilityResource.TargetType.GROUND_AOE:
		var center = target_point if target_point != Vector3.ZERO else (caster.global_position if (caster != null and caster.is_inside_tree()) else Vector3.ZERO)
		var affected = execute_aoe_spell(slot, center)
		ab.on_aoe_triggered(caster, center, affected)
			
	ability_casted.emit(slot, ab)
	ability_cast_completed.emit(slot, ab)
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.ability_cast.emit(caster, ab, target_point, target_entity)
