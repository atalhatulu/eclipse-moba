class_name FogOfWarManager
extends Node

const BushArea3DClass = preload("res://scenes/map/bush_area_3d.gd")

## High-performance MOBA Fog of War and Vision Management System
## Evaluates Team Line-of-Sight, Bush Concealment, Invisibility, True Sight and Minimap Culling.

@export var player_team: TeamDefinitions.Team = TeamDefinitions.Team.RADIANT
@export var update_interval: float = 0.08 # 12.5 Hz update frequency (smooth & lightweight)

const HERO_VISION_RADIUS: float = 14.0
const TOWER_VISION_RADIUS: float = 16.0
const CREEP_VISION_RADIUS: float = 8.5
const OBJECTIVE_VISION_RADIUS: float = 18.0

var _timer: float = 0.0

func _process(delta: float) -> void:
	_timer += delta
	if _timer >= update_interval:
		_timer = 0.0
		_update_world_entities_visibility()

func _update_world_entities_visibility() -> void:
	if not is_inside_tree() or get_tree() == null:
		return
		
	var combat_ents = get_tree().get_nodes_in_group("combat_entities")
	for ent in combat_ents:
		if ent is BaseCombatEntity and is_instance_valid(ent) and ent.is_alive():
			if ent.team != player_team:
				var is_vis = is_entity_visible_to_team(ent, player_team)
				# Update entity 3D visibility
				if ent.visible != is_vis:
					ent.visible = is_vis

func _is_alive(ent: BaseCombatEntity) -> bool:
	if ent == null or not is_instance_valid(ent):
		return false
	if ent.attribute_system != null:
		return ent.is_alive()
	return ent.lifecycle_state == BaseCombatEntity.LifecycleState.ALIVE

func is_entity_visible_to_team(target: BaseCombatEntity, viewer_team: TeamDefinitions.Team) -> bool:
	if not _is_alive(target):
		return false
		
	# Friendly units and major structures are always visible
	if target.team == viewer_team or target is TowerEntity or target is ObjectiveEntity:
		return true
		
	var t_pos = target.global_position if (target.is_inside_tree() or target.global_position != Vector3.ZERO) else target.position
	
	# 1. Bush Concealment Check
	if target.has_meta("current_bush"):
		var bush = target.get_meta("current_bush")
		if is_instance_valid(bush) and (bush is BushArea3DClass or bush.has_method("has_team_member")):
			# Only visible if viewer_team has someone in the SAME bush or True Sight
			if not bush.has_team_member(viewer_team) and not is_point_in_true_sight(t_pos, viewer_team):
				return false
				
	# 2. Invisibility / Stealth Status Check
	if "is_invisible" in target and target.is_invisible:
		if not is_point_in_true_sight(t_pos, viewer_team):
			return false
			
	# 3. Vision Range Check against all viewer_team units
	return is_point_visible_to_team(t_pos, viewer_team)

func is_point_visible_to_team(point: Vector3, viewer_team: TeamDefinitions.Team) -> bool:
	# Check Heroes
	for h in HeroEntity.active_heroes:
		if _is_alive(h) and h.team == viewer_team:
			var h_pos = h.global_position if (h.is_inside_tree() or h.global_position != Vector3.ZERO) else h.position
			if h_pos.distance_to(point) <= HERO_VISION_RADIUS:
				return true
				
	# Check Towers
	for tw in TowerEntity.active_towers:
		if _is_alive(tw) and tw.team == viewer_team:
			var tw_pos = tw.global_position if (tw.is_inside_tree() or tw.global_position != Vector3.ZERO) else tw.position
			if tw_pos.distance_to(point) <= TOWER_VISION_RADIUS:
				return true
				
	# Check Creeps
	for c in CreepEntity.active_creeps:
		if _is_alive(c) and c.team == viewer_team:
			var c_pos = c.global_position if (c.is_inside_tree() or c.global_position != Vector3.ZERO) else c.position
			if c_pos.distance_to(point) <= CREEP_VISION_RADIUS:
				return true
				
	return false

func is_point_in_true_sight(point: Vector3, viewer_team: TeamDefinitions.Team) -> bool:
	for tw in TowerEntity.active_towers:
		if _is_alive(tw) and tw.team == viewer_team:
			var tw_pos = tw.global_position if (tw.is_inside_tree() or tw.global_position != Vector3.ZERO) else tw.position
			if tw_pos.distance_to(point) <= TOWER_VISION_RADIUS:
				return true
	return false
