class_name TargetRelationSystem
extends RefCounted

## Centralized Target Relation & Validation System for Eclipse Front (Task 09)

enum TargetRelation {
	ALLY,
	ENEMY_HERO,
	ENEMY_CREEP,
	ENEMY_TOWER,
	NEUTRAL_MONSTER,
	OBJECTIVE,
	UNKNOWN
}

## Determines the exact combat relationship of target relative to source
static func get_relation(source: BaseCombatEntity, target: BaseCombatEntity) -> TargetRelation:
	if source == null or target == null or not is_instance_valid(source) or not is_instance_valid(target):
		return TargetRelation.UNKNOWN
		
	# Neutral Jungle Camps / Monsters
	if target.team == TeamDefinitions.Team.NEUTRAL or target is NeutralCreepEntity:
		return TargetRelation.NEUTRAL_MONSTER
		
	# Allied Units (Same Team)
	if source.team == target.team:
		return TargetRelation.ALLY
		
	# Opposing Team Classifications
	if target is HeroEntity:
		return TargetRelation.ENEMY_HERO
	elif target is TowerEntity:
		return TargetRelation.ENEMY_TOWER
	elif target is ObjectiveEntity:
		return TargetRelation.OBJECTIVE
	elif target is CreepEntity:
		return TargetRelation.ENEMY_CREEP
		
	# Default Enemy fallback (e.g. TargetDummy or generic combat entity)
	return TargetRelation.ENEMY_CREEP

## Checks if entity is instantiated and alive
static func is_alive(entity: BaseCombatEntity) -> bool:
	return entity != null and is_instance_valid(entity) and entity.is_alive()

## Checks if entity is alive and can be selected/targeted
static func is_targetable(entity: BaseCombatEntity) -> bool:
	return is_alive(entity) and entity.is_targetable

## Returns true if target is considered hostile/attackable by source
static func is_enemy(source: BaseCombatEntity, target: BaseCombatEntity) -> bool:
	var rel = get_relation(source, target)
	return rel in [
		TargetRelation.ENEMY_HERO,
		TargetRelation.ENEMY_CREEP,
		TargetRelation.ENEMY_TOWER,
		TargetRelation.NEUTRAL_MONSTER,
		TargetRelation.OBJECTIVE
	]

## Returns true if target is an ally of source
static func is_ally(source: BaseCombatEntity, target: BaseCombatEntity) -> bool:
	return get_relation(source, target) == TargetRelation.ALLY

## Central Euclidean range check in 3D world space
static func is_in_range(source: BaseCombatEntity, target: BaseCombatEntity, range_m: float) -> bool:
	if not is_alive(source) or not is_alive(target):
		return false
	var s_pos = source.global_position if source.is_inside_tree() else source.position
	var t_pos = target.global_position if target.is_inside_tree() else target.position
	return s_pos.distance_to(t_pos) <= range_m

## Returns true if an allied entity is eligible for a deny attack (Creep <= 50% HP, Tower <= 10% HP)
static func is_eligible_for_deny(source: BaseCombatEntity, target: BaseCombatEntity) -> bool:
	if not is_targetable(source) or not is_targetable(target):
		return false
	if source == target or source.team != target.team:
		return false
		
	if target.attribute_system == null:
		return false
		
	var max_hp = target.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	var cur_hp = target.attribute_system.current_health
	if max_hp <= 0.0:
		return false
		
	# Tower deny: friendly tower under 10% max HP
	if target is TowerEntity:
		return (cur_hp / max_hp) <= 0.10
		
	# Creep deny: friendly creep under 50% max HP
	if target is CreepEntity:
		return (cur_hp / max_hp) <= 0.50
		
	return false

## Strict validation rule for basic attacks
static func is_valid_basic_attack_target(source: BaseCombatEntity, target: BaseCombatEntity) -> bool:
	if not is_targetable(source) or not is_targetable(target):
		return false
	if source == target:
		return false
		
	# Check deny condition first for allies
	if source.team == target.team:
		return is_eligible_for_deny(source, target)
		
	var rel = get_relation(source, target)
	# Basic Attack allows: Enemy Hero, Enemy Creep, Neutral Monster, Enemy Tower, Objective
	return rel in [
		TargetRelation.ENEMY_HERO,
		TargetRelation.ENEMY_CREEP,
		TargetRelation.ENEMY_TOWER,
		TargetRelation.NEUTRAL_MONSTER,
		TargetRelation.OBJECTIVE
	]

## Generic relation filter for future abilities and custom spells
static func validate_target_type(source: BaseCombatEntity, target: BaseCombatEntity, allowed_relations: Array[TargetRelation]) -> bool:
	if not is_targetable(source) or not is_targetable(target):
		return false
	var rel = get_relation(source, target)
	return rel in allowed_relations
