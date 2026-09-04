class_name AreaEffectManager
extends RefCounted

## Runtime zones for delayed explosions, damaging fields and persistent wards.
## They are intentionally data-driven so a hero definition can opt in without
## needing a dedicated scene script for every ground-targeted spell.

static var _active_zones: Array[Dictionary] = []

static func create_zone(owner: BaseCombatEntity, center: Vector3, radius: float, duration: float, tick_interval: float, damage: float, damage_type: DamageRequest.DamageType, applies_effect: bool = false, effect_type: StatusEffect.EffectType = StatusEffect.EffectType.SLOW, effect_duration: float = 0.0, effect_intensity: float = 0.0, source_name: String = "Area Effect") -> Dictionary:
	if owner == null or radius <= 0.0 or duration <= 0.0:
		return {}
	var zone := {
		"id": "area_" + str(randi()),
		"owner": owner,
		"center": center,
		"radius": radius,
		"timer": duration,
		"tick_interval": maxf(0.05, tick_interval),
		"tick_timer": 0.0,
		"damage": maxf(0.0, damage),
		"damage_type": damage_type,
		"applies_effect": applies_effect,
		"effect_type": effect_type,
		"effect_duration": effect_duration,
		"effect_intensity": effect_intensity,
		"source_name": source_name
	}
	_active_zones.append(zone)
	return zone

static func tick(delta: float) -> void:
	for i in range(_active_zones.size() - 1, -1, -1):
		var zone := _active_zones[i]
		var owner = zone.get("owner") as BaseCombatEntity
		if owner == null or not is_instance_valid(owner) or not owner.is_alive():
			_active_zones.remove_at(i)
			continue
		zone["timer"] = float(zone["timer"]) - delta
		zone["tick_timer"] = float(zone["tick_timer"]) - delta
		if float(zone["tick_timer"]) <= 0.0:
			zone["tick_timer"] = float(zone["tick_interval"])
			_apply_zone_pulse(zone, owner)
		if float(zone["timer"]) <= 0.0:
			_active_zones.remove_at(i)

static func _apply_zone_pulse(zone: Dictionary, owner: BaseCombatEntity) -> void:
	var center: Vector3 = zone["center"]
	for target in _get_combat_entities():
		if not owner.is_enemy_with(target):
			continue
		var target_pos = target.global_position if target.is_inside_tree() else target.position
		if Vector2(target_pos.x - center.x, target_pos.z - center.z).length() > float(zone["radius"]):
			continue
		var damage: float = zone["damage"]
		if damage > 0.0:
			CombatCalculator.execute_damage(DamageRequest.create_spell_damage(owner, target, damage, zone["damage_type"], zone["source_name"]))
		if bool(zone["applies_effect"]) and target.effect_container != null:
			var effect := StatusEffect.new(str(zone["id"]) + "_effect", zone["effect_type"], float(zone["effect_duration"]), float(zone["effect_intensity"]), true)
			effect.source_entity = owner
			if zone["effect_type"] == StatusEffect.EffectType.KNOCKBACK:
				effect.set_meta("knockback_origin", center)
			target.effect_container.apply_effect(effect)

static func _get_combat_entities() -> Array[BaseCombatEntity]:
	var entities: Array[BaseCombatEntity] = []
	for hero in HeroEntity.active_heroes:
		if is_instance_valid(hero) and hero.is_alive():
			entities.append(hero)
	for creep in CreepEntity.active_creeps:
		if is_instance_valid(creep) and creep.is_alive():
			entities.append(creep)
	return entities

static func clear_all() -> void:
	_active_zones.clear()
