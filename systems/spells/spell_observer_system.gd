class_name SpellObserverSystem
extends RefCounted

## Spell Observation, Counterspell & Arcane Adaptation Engine for Eclipse Front
## Records cast events and enables Veylin to copy enemy spells and counter incoming abilities.

# Cast record: {caster: BaseCombatEntity, ability: AbilityResource, target_point: Vector3, target: BaseCombatEntity, time: float}
static var _cast_history: Array[Dictionary] = []
const MAX_HISTORY: int = 50

static func record_cast(caster: BaseCombatEntity, ability: AbilityResource, target_point: Vector3 = Vector3.ZERO, target_node: Variant = null) -> void:
	if caster == null or ability == null:
		return
		
	var entry = {
		"caster": caster,
		"ability": ability,
		"target_point": target_point,
		"target": target_node as BaseCombatEntity if target_node is BaseCombatEntity else null,
		"time": Time.get_ticks_msec() / 1000.0
	}
	_cast_history.append(entry)
	if _cast_history.size() > MAX_HISTORY:
		_cast_history.pop_front()
		
	# Active Line-of-Sight & Proximity Check for Veylin (Study Passive)
	var c_pos = caster.global_position if caster.is_inside_tree() else caster.position
	for h in HeroEntity.active_heroes:
		if is_instance_valid(h) and h is VeylinHero and h.is_alive() and h.team != caster.team:
			var v_pos = h.global_position if h.is_inside_tree() else h.position
			if v_pos.distance_to(c_pos) <= 14.0 and caster.is_targetable:
				h.add_study_stack(1)

static func get_last_enemy_cast(observer: BaseCombatEntity, max_range: float = 15.0) -> Dictionary:
	if observer == null:
		return {}
		
	var obs_pos = observer.global_position if observer.is_inside_tree() else observer.position
	for i in range(_cast_history.size() - 1, -1, -1):
		var entry = _cast_history[i]
		var raw_caster = entry.get("caster")
		if not is_instance_valid(raw_caster):
			_cast_history.remove_at(i)
			continue
		var caster: BaseCombatEntity = raw_caster as BaseCombatEntity
		if caster.team != observer.team and caster.is_alive():
			var c_pos = caster.global_position if caster.is_inside_tree() else caster.position
			if obs_pos.distance_to(c_pos) <= max_range:
				return entry
	return {}

static func mimic_ability(observer: BaseCombatEntity, target_enemy: BaseCombatEntity = null) -> AbilityResource:
	if observer == null:
		return null
		
	var ab_source: AbilityResource = null
	if target_enemy != null and is_instance_valid(target_enemy):
		ab_source = target_enemy.hero_resource.get_ability_by_slot(AbilityResource.Slot.Q)
	else:
		var last = get_last_enemy_cast(observer)
		if not last.is_empty():
			ab_source = last.get("ability")
			
	if ab_source == null:
		return null
		
	# Duplicate into a safe runtime copy for Veylin
	var copied = ab_source.duplicate() as AbilityResource
	copied.id = "veylin_mimic_" + ab_source.id
	copied.ability_name = "Mimic: " + ab_source.ability_name
	return copied

static func try_counter_spell(observer: BaseCombatEntity, spell_name: String) -> bool:
	if observer == null:
		return false
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("COUNTERSPELL: %s büyü engellendi!" % spell_name)
	return true

static func clear_all() -> void:
	_cast_history.clear()
