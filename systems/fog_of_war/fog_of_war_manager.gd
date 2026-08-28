class_name FogOfWarManager
extends Node

## Authentic Dota 2 Fog of War System
## Features: 3-State Vision (Visible, Explored Grey Fog, Unexplored Black), Day/Night Cycle, 3D Plane Shader, and Minimap Shroud.

const BushArea3DClass = preload("res://scenes/map/bush_area_3d.gd")

@export var player_team: TeamDefinitions.Team = TeamDefinitions.Team.RADIANT
@export var update_interval: float = 0.08 # 12.5 Hz refresh

# World Map Coordinate Bounds
var map_bounds: Rect2 = Rect2(-65.0, -40.0, 130.0, 80.0)
var grid_size: Vector2i = Vector2i(128, 80) # High-res grid texture

# Day / Night Cycle (Dota 2: 4-minute cycles)
var is_daytime: bool = true
var day_night_timer: float = 0.0
const CYCLE_DURATION: float = 240.0 # 4 minutes

# Dynamic Vision Radii (Day vs Night)
var hero_vision_radius_day: float = 15.0
var hero_vision_radius_night: float = 9.0
var tower_vision_radius: float = 16.0
var creep_vision_radius: float = 8.5
var objective_vision_radius: float = 18.0

# 2D Texture Buffers for 3D Shader & Minimap
var fog_image: Image = null
var fog_texture: ImageTexture = null
var fog_mesh_instance: MeshInstance3D = null
var fog_material: ShaderMaterial = null

var _timer: float = 0.0

func _ready() -> void:
	add_to_group("fog_of_war")
	_init_texture_buffers()
	_create_3d_fog_overlay()

func _init_texture_buffers() -> void:
	fog_image = Image.create(grid_size.x, grid_size.y, false, Image.FORMAT_RGBA8)
	fog_image.fill(Color(0, 0, 0, 1)) # All black unexplored
	fog_texture = ImageTexture.create_from_image(fog_image)

func _create_3d_fog_overlay() -> void:
	if not is_inside_tree() or get_parent() == null:
		return
		
	var parent_node = get_parent()
	if parent_node.has_node("Dota3DFogOverlay"):
		fog_mesh_instance = parent_node.get_node("Dota3DFogOverlay")
		return
		
	fog_mesh_instance = MeshInstance3D.new()
	fog_mesh_instance.name = "Dota3DFogOverlay"
	
	var plane = PlaneMesh.new()
	plane.size = Vector2(map_bounds.size.x, map_bounds.size.y)
	fog_mesh_instance.mesh = plane
	fog_mesh_instance.position = Vector3(map_bounds.position.x + map_bounds.size.x * 0.5, 0.06, map_bounds.position.y + map_bounds.size.y * 0.5)
	
	var shader = load("res://systems/fog_of_war/dota_fog_shader.gdshader")
	if shader != null:
		fog_material = ShaderMaterial.new()
		fog_material.shader = shader
		fog_material.set_shader_parameter("fog_texture", fog_texture)
		fog_mesh_instance.material_override = fog_material
		
	parent_node.add_child(fog_mesh_instance)

func _process(delta: float) -> void:
	_update_day_night_cycle(delta)
	
	_timer += delta
	if _timer >= update_interval:
		_timer = 0.0
		_update_fog_grid_and_visibility()

func _update_day_night_cycle(delta: float) -> void:
	day_night_timer += delta
	if day_night_timer >= CYCLE_DURATION:
		day_night_timer = 0.0
		is_daytime = not is_daytime
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.game_time_updated.emit(day_night_timer)

func get_current_hero_vision_radius() -> float:
	return hero_vision_radius_day if is_daytime else hero_vision_radius_night

func _update_fog_grid_and_visibility() -> void:
	if fog_image == null:
		return
		
	# Gather all active vision sources for player_team
	var vision_sources: Array[Dictionary] = [] # [{pos: Vector3, radius: float}]
	
	var h_radius = get_current_hero_vision_radius()
	for h in HeroEntity.active_heroes:
		if _is_alive(h) and h.team == player_team:
			var p = h.global_position if (h.is_inside_tree() or h.global_position != Vector3.ZERO) else h.position
			vision_sources.append({"pos": p, "radius": h_radius})
			
	for tw in TowerEntity.active_towers:
		if _is_alive(tw) and tw.team == player_team:
			var p = tw.global_position if (tw.is_inside_tree() or tw.global_position != Vector3.ZERO) else tw.position
			vision_sources.append({"pos": p, "radius": tower_vision_radius})
			
	for c in CreepEntity.active_creeps:
		if _is_alive(c) and c.team == player_team:
			var p = c.global_position if (c.is_inside_tree() or c.global_position != Vector3.ZERO) else c.position
			vision_sources.append({"pos": p, "radius": creep_vision_radius})
			
	# Update Texture Buffer
	for y in range(grid_size.y):
		var norm_y = float(y) / float(grid_size.y)
		var world_z = map_bounds.position.y + norm_y * map_bounds.size.y
		
		for x in range(grid_size.x):
			var norm_x = float(x) / float(grid_size.x)
			var world_x = map_bounds.position.x + norm_x * map_bounds.size.x
			var pt = Vector3(world_x, 0, world_z)
			
			var is_live_vis = false
			for src in vision_sources:
				if pt.distance_to(src.pos) <= src.radius:
					is_live_vis = true
					break
					
			var cur_col = fog_image.get_pixel(x, y)
			var explored_val = cur_col.g
			if is_live_vis:
				explored_val = 1.0 # Mark explored permanently
				fog_image.set_pixel(x, y, Color(1.0, explored_val, 0.0, 1.0))
			else:
				# 0 live vision, keep explored state
				fog_image.set_pixel(x, y, Color(0.0, explored_val, 0.0, 1.0))
				
	fog_texture.update(fog_image)
	
	# Update 3D Entity Visibility in World
	_update_world_entities_visibility()

func _update_world_entities_visibility() -> void:
	if not is_inside_tree() or get_tree() == null:
		return
		
	var combat_ents = get_tree().get_nodes_in_group("combat_entities")
	for ent in combat_ents:
		if ent is BaseCombatEntity and is_instance_valid(ent) and ent.is_alive():
			if ent.team != player_team and not (ent is TowerEntity or ent is ObjectiveEntity):
				var is_vis = is_entity_visible_to_team(ent, player_team)
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
		
	if target.team == viewer_team or target is TowerEntity or target is ObjectiveEntity:
		return true
		
	var t_pos = target.global_position if (target.is_inside_tree() or target.global_position != Vector3.ZERO) else target.position
	
	# 1. Bush Concealment Check
	if target.has_meta("current_bush"):
		var bush = target.get_meta("current_bush")
		if is_instance_valid(bush) and (bush is BushArea3DClass or bush.has_method("has_team_member")):
			if not bush.has_team_member(viewer_team) and not is_point_in_true_sight(t_pos, viewer_team):
				return false
				
	# 2. Invisibility / Stealth Check
	if "is_invisible" in target and target.is_invisible:
		if not is_point_in_true_sight(t_pos, viewer_team):
			return false
			
	# 3. Line of Sight Check
	return is_point_visible_to_team(t_pos, viewer_team)

func is_point_visible_to_team(point: Vector3, viewer_team: TeamDefinitions.Team) -> bool:
	var h_radius = get_current_hero_vision_radius()
	for h in HeroEntity.active_heroes:
		if _is_alive(h) and h.team == viewer_team:
			var h_pos = h.global_position if (h.is_inside_tree() or h.global_position != Vector3.ZERO) else h.position
			if h_pos.distance_to(point) <= h_radius:
				return true
				
	for tw in TowerEntity.active_towers:
		if _is_alive(tw) and tw.team == viewer_team:
			var tw_pos = tw.global_position if (tw.is_inside_tree() or tw.global_position != Vector3.ZERO) else tw.position
			if tw_pos.distance_to(point) <= tower_vision_radius:
				return true
				
	for c in CreepEntity.active_creeps:
		if _is_alive(c) and c.team == viewer_team:
			var c_pos = c.global_position if (c.is_inside_tree() or c.global_position != Vector3.ZERO) else c.position
			if c_pos.distance_to(point) <= creep_vision_radius:
				return true
				
	return false

func is_point_in_true_sight(point: Vector3, viewer_team: TeamDefinitions.Team) -> bool:
	for tw in TowerEntity.active_towers:
		if _is_alive(tw) and tw.team == viewer_team:
			var tw_pos = tw.global_position if (tw.is_inside_tree() or tw.global_position != Vector3.ZERO) else tw.position
			if tw_pos.distance_to(point) <= tower_vision_radius:
				return true
	return false
