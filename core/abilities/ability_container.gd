class_name AbilityContainer
extends Node

## Manages active ability slots, cooldown timers, level progression, and spellcasting

signal ability_casted(slot: AbilityResource.Slot, ability: AbilityResource)
signal ability_learned(slot: AbilityResource.Slot, ability: AbilityResource)
signal ability_leveled(slot: AbilityResource.Slot, new_level: int)
signal cooldown_ticked(slot: AbilityResource.Slot, remaining: float, total: float)
signal skill_points_updated(points: int)

@export var available_skill_points: int = 1

var abilities: Dictionary = {} # AbilityResource.Slot -> AbilityResource
var ability_levels: Dictionary = {} # AbilityResource.Slot -> int
var cooldown_timers: Dictionary = {} # AbilityResource.Slot -> float
var max_cooldown_timers: Dictionary = {} # AbilityResource.Slot -> float

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
	for s in cooldown_timers.keys():
		if cooldown_timers[s] > 0.0:
			cooldown_timers[s] = maxf(0.0, cooldown_timers[s] - delta)
			cooldown_ticked.emit(s, cooldown_timers[s], max_cooldown_timers[s])

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
	_resolve_parent_references()
	var ab: AbilityResource = abilities.get(slot)
	if ab == null or ab.is_passive:
		return false
	var lvl = ability_levels.get(slot, 0)
	if lvl <= 0:
		return false
	if not is_free_spells_active:
		if cooldown_timers.get(slot, 0.0) > 0.0:
			return false
		if effect_container != null and effect_container.is_silenced():
			return false
		if attribute_system != null:
			var cost = ab.get_mana_cost(lvl)
			if attribute_system.current_mana < cost:
				return false
	return true

func cast_ability(slot: AbilityResource.Slot, target_entity: BaseCombatEntity = null, _target_point: Vector3 = Vector3.ZERO) -> bool:
	if not can_cast(slot):
		return false
		
	_resolve_parent_references()
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
			
	ability_casted.emit(slot, ab)
	return true
