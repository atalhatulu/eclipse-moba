class_name DotaMapBuilder3D
extends RefCounted

## Procedural builder for full-scale 240m x 240m Dota 2 MOBA map with 4 elevation tiers,
## authentic ramps, high-ground advantage, 3 lanes, 22 towers, and symmetric objectives.

const MAP_SIZE = 240.0
const HALF_MAP = 120.0

const ELEVATION_RIVER = 0.0
const ELEVATION_GROUND = 0.0
const ELEVATION_BASE = 0.0
const ELEVATION_CLIFF = 0.0

# Entity & System Preloads
const TowerEntityClass = preload("res://core/entities/tower_entity.gd")
const ObjectiveEntityClass = preload("res://core/entities/objective_entity.gd")
const LaneMinionSpawnerClass = preload("res://scenes/map/lane_minion_spawner.gd")
const FountainHealingAreaClass = preload("res://scenes/map/fountain_healing_area.gd")
const NeutralCampSpawnerClass = preload("res://scenes/map/neutral_camp_spawner.gd")
const RiverRuneSpawnerClass = preload("res://scenes/map/rune_spawner.gd")
const OutpostObjectiveClass = preload("res://scenes/map/outpost_objective.gd")
const SecretShopAreaClass = preload("res://scenes/map/secret_shop_area.gd")
const BushArea3DClass = preload("res://scenes/map/bush_area_3d.gd")
const EpicBossEntityClass = preload("res://core/entities/boss/epic_boss_entity.gd")

# Materials
static var _mat_rad_ground: StandardMaterial3D
static var _mat_dire_ground: StandardMaterial3D
static var _mat_rad_highground: StandardMaterial3D
static var _mat_dire_highground: StandardMaterial3D
static var _mat_river_water: StandardMaterial3D
static var _mat_lane_stone: StandardMaterial3D
static var _mat_cliff_rock: StandardMaterial3D
static var _mat_ramp_stone: StandardMaterial3D

static func _init_materials() -> void:
	if _mat_rad_ground != null:
		return
		
	# Radiant Low Ground (Lush green forest)
	_mat_rad_ground = StandardMaterial3D.new()
	_mat_rad_ground.albedo_color = Color(0.18, 0.38, 0.20)
	_mat_rad_ground.roughness = 0.88
	
	# Dire Low Ground (Scorched volcanic earth)
	_mat_dire_ground = StandardMaterial3D.new()
	_mat_dire_ground.albedo_color = Color(0.28, 0.18, 0.16)
	_mat_dire_ground.roughness = 0.88
	
	# Radiant High Ground Base Plateau (Polished stone / emerald grass)
	_mat_rad_highground = StandardMaterial3D.new()
	_mat_rad_highground.albedo_color = Color(0.22, 0.44, 0.25)
	_mat_rad_highground.roughness = 0.80
	
	# Dire High Ground Base Plateau (Dark obsidian / volcanic rock)
	_mat_dire_highground = StandardMaterial3D.new()
	_mat_dire_highground.albedo_color = Color(0.20, 0.12, 0.14)
	_mat_dire_highground.roughness = 0.80
	
	# River Water (Reflective translucent blue)
	_mat_river_water = StandardMaterial3D.new()
	_mat_river_water.albedo_color = Color(0.10, 0.35, 0.60, 0.82)
	_mat_river_water.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_mat_river_water.roughness = 0.15
	_mat_river_water.metallic = 0.1
	
	# Lane Cobblestone Paving
	_mat_lane_stone = StandardMaterial3D.new()
	_mat_lane_stone.albedo_color = Color(0.50, 0.46, 0.40)
	_mat_lane_stone.roughness = 0.85
	
	# Cliff Granite Rocks
	_mat_cliff_rock = StandardMaterial3D.new()
	_mat_cliff_rock.albedo_color = Color(0.24, 0.22, 0.20)
	_mat_cliff_rock.roughness = 0.92
	
	# Ramp Stone
	_mat_ramp_stone = StandardMaterial3D.new()
	_mat_ramp_stone.albedo_color = Color(0.42, 0.40, 0.36)
	_mat_ramp_stone.roughness = 0.80

## Builds the complete 3D terrain hierarchy with collision and materials
static func build_dota_terrain(parent: Node3D) -> StaticBody3D:
	_init_materials()
	
	var terrain = StaticBody3D.new()
	terrain.name = "DotaTerrain"
	terrain.add_to_group("terrain")
	parent.add_child(terrain)
	
	# 1. Base Main Ground (Flat Y = 0.0)
	_create_box_ground(terrain, "RadiantLowGround", Vector3(-60, -0.5, 0), Vector3(120, 1.0, 240), _mat_rad_ground)
	_create_box_ground(terrain, "DireLowGround", Vector3(60, -0.5, 0), Vector3(120, 1.0, 240), _mat_dire_ground)
	
	# 2. Diagonal River Visual (Flat flush water strip at Y = 0.01)
	var river_root = Node3D.new()
	river_root.name = "RiverSystem"
	terrain.add_child(river_root)
	
	var water_mesh = MeshInstance3D.new()
	water_mesh.name = "RiverWaterSurface"
	var p_mesh = BoxMesh.new()
	p_mesh.size = Vector3(24.0, 0.02, 260.0)
	water_mesh.mesh = p_mesh
	water_mesh.material_override = _mat_river_water
	water_mesh.position = Vector3(0, 0.01, 0)
	water_mesh.rotation_degrees.y = -45.0
	river_root.add_child(water_mesh)
	
	# 3. Leviathan / Roshan Pit (Flat arena at Y = 0.0)
	_create_roshan_pit(terrain, Vector3(-22, 0.0, -35))
	
	# 4. Strategic Cliff Ward Pads (Flat circular stone pads at Y = 0.02)
	_create_cliff_pillar(terrain, "Cliff_Rad_Jungle", Vector3(-35, 0.02, 10), 3.5, 0.04)
	_create_cliff_pillar(terrain, "Cliff_Dire_Jungle", Vector3(35, 0.02, -10), 3.5, 0.04)
	_create_cliff_pillar(terrain, "Cliff_Roshan_Watch", Vector3(-6, 0.02, -45), 3.0, 0.04)
	_create_cliff_pillar(terrain, "Cliff_Bot_Watch", Vector3(6, 0.02, 45), 3.0, 0.04)
	
	# 5. Lane Stone Roads (Flat stone paving at Y = 0.02)
	_create_lane_roads(terrain)
	
	# 6. Outer Boundary Mountain Walls
	_create_outer_boundary_walls(terrain)
	
	return terrain

static func _create_box_ground(parent: Node3D, p_name: String, pos: Vector3, size: Vector3, mat: StandardMaterial3D) -> StaticBody3D:
	var body = StaticBody3D.new()
	body.name = p_name
	body.add_to_group("terrain")
	parent.add_child(body)
	
	var col = CollisionShape3D.new()
	col.name = "CollisionShape3D"
	var shape = BoxShape3D.new()
	shape.size = size
	col.shape = shape
	col.position = pos
	body.add_child(col)
	
	var mi = MeshInstance3D.new()
	mi.name = "MeshInstance3D"
	var mesh = BoxMesh.new()
	mesh.size = size
	mi.mesh = mesh
	mi.material_override = mat
	mi.position = pos
	body.add_child(mi)
	
	return body

static func _create_ramp(parent: Node3D, p_name: String, center_pos: Vector3, size: Vector3, yaw_deg: float, pitch_deg: float) -> StaticBody3D:
	var body = StaticBody3D.new()
	body.name = p_name
	body.add_to_group("terrain")
	body.add_to_group("ramps")
	parent.add_child(body)
	
	body.position = center_pos
	body.rotation_degrees = Vector3(pitch_deg, yaw_deg, 0)
	
	var col = CollisionShape3D.new()
	col.name = "CollisionShape3D"
	var shape = BoxShape3D.new()
	shape.size = size
	col.shape = shape
	body.add_child(col)
	
	var mi = MeshInstance3D.new()
	mi.name = "MeshInstance3D"
	var mesh = BoxMesh.new()
	mesh.size = size
	mi.mesh = mesh
	mi.material_override = _mat_ramp_stone
	body.add_child(mi)
	
	return body

static func _create_cliff_pillar(parent: Node3D, p_name: String, pos: Vector3, radius: float, height: float) -> StaticBody3D:
	var body = StaticBody3D.new()
	body.name = p_name
	body.add_to_group("terrain")
	body.add_to_group("cliffs")
	parent.add_child(body)
	
	body.position = pos
	
	var col = CollisionShape3D.new()
	col.name = "CollisionShape3D"
	var shape = CylinderShape3D.new()
	shape.radius = radius
	shape.height = height
	col.shape = shape
	body.add_child(col)
	
	var mi = MeshInstance3D.new()
	mi.name = "MeshInstance3D"
	var mesh = CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius * 1.15
	mesh.height = height
	mi.mesh = mesh
	mi.material_override = _mat_cliff_rock
	body.add_child(mi)
	
	return body

static func _create_roshan_pit(parent: Node3D, pos: Vector3) -> void:
	var pit_root = Node3D.new()
	pit_root.name = "LeviathanPit"
	parent.add_child(pit_root)
	pit_root.position = pos
	
	var floor_body = StaticBody3D.new()
	floor_body.name = "PitFloor"
	floor_body.add_to_group("terrain")
	pit_root.add_child(floor_body)
	
	var f_col = CollisionShape3D.new()
	f_col.name = "CollisionShape3D"
	var f_shape = CylinderShape3D.new()
	f_shape.radius = 8.5
	f_shape.height = 0.5
	f_col.shape = f_shape
	f_col.position.y = -0.25
	floor_body.add_child(f_col)
	
	var f_mesh = MeshInstance3D.new()
	f_mesh.name = "MeshInstance3D"
	var cyl_mesh = CylinderMesh.new()
	cyl_mesh.top_radius = 8.5
	cyl_mesh.bottom_radius = 8.5
	cyl_mesh.height = 0.5
	f_mesh.mesh = cyl_mesh
	var pit_mat = StandardMaterial3D.new()
	pit_mat.albedo_color = Color(0.14, 0.12, 0.15)
	pit_mat.roughness = 0.95
	f_mesh.material_override = pit_mat
	f_mesh.position.y = -0.25
	floor_body.add_child(f_mesh)
	
	for i in range(12):
		var angle = deg_to_rad(45.0 + (float(i) * 22.5))
		var w_pos = Vector3(cos(angle) * 8.8, 2.0, sin(angle) * 8.8)
		var rock = StaticBody3D.new()
		rock.name = "PitWall_%d" % i
		rock.position = w_pos
		pit_root.add_child(rock)
		
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var box = BoxShape3D.new()
		box.size = Vector3(3.0, 5.0, 3.0)
		col.shape = box
		rock.add_child(col)
		
		var mi = MeshInstance3D.new()
		mi.name = "MeshInstance3D"
		var b_mesh = BoxMesh.new()
		b_mesh.size = Vector3(3.0, 5.0, 3.0)
		mi.mesh = b_mesh
		mi.material_override = _mat_cliff_rock
		rock.add_child(mi)

static func _create_lane_roads(parent: Node3D) -> void:
	var roads = Node3D.new()
	roads.name = "LaneRoadPaving"
	parent.add_child(roads)
	
	# Mid Lane (Diagonal from -75, +75 to +75, -75)
	_create_road_segment(roads, Vector3(-35, 0.02, 35), Vector3(8.0, 0.04, 55.0), -45.0)
	_create_road_segment(roads, Vector3(35, 0.02, -35), Vector3(8.0, 0.04, 55.0), -45.0)
	
	# Top Lane (Radiant up to north, then east to Dire)
	_create_road_segment(roads, Vector3(-75, 0.02, -10), Vector3(8.0, 0.04, 75.0), 0.0)
	_create_road_segment(roads, Vector3(-10, 0.02, -75), Vector3(8.0, 0.04, 75.0), 90.0)
	
	# Bot Lane (Radiant east along south, then north to Dire)
	_create_road_segment(roads, Vector3(10, 0.02, 75), Vector3(8.0, 0.04, 75.0), 90.0)
	_create_road_segment(roads, Vector3(75, 0.02, 10), Vector3(8.0, 0.04, 75.0), 0.0)

static func _create_road_segment(parent: Node3D, pos: Vector3, size: Vector3, yaw_deg: float) -> void:
	var mi = MeshInstance3D.new()
	mi.name = "RoadSegment_%d" % parent.get_child_count()
	var mesh = BoxMesh.new()
	mesh.size = size
	mi.mesh = mesh
	mi.material_override = _mat_lane_stone
	mi.position = pos
	mi.rotation_degrees.y = yaw_deg
	parent.add_child(mi)

static func _create_outer_boundary_walls(parent: Node3D) -> void:
	var walls = Node3D.new()
	walls.name = "OuterMapBoundaryWalls"
	parent.add_child(walls)
	
	var wall_size_x = Vector3(250.0, 10.0, 8.0)
	var wall_size_z = Vector3(8.0, 10.0, 250.0)
	
	_create_box_ground(walls, "NorthWall", Vector3(0, 5.0, -122), wall_size_x, _mat_cliff_rock)
	_create_box_ground(walls, "SouthWall", Vector3(0, 5.0, 122), wall_size_x, _mat_cliff_rock)
	_create_box_ground(walls, "WestWall", Vector3(-122, 5.0, 0), wall_size_z, _mat_cliff_rock)
	_create_box_ground(walls, "EastWall", Vector3(122, 5.0, 0), wall_size_z, _mat_cliff_rock)

## Populates all 22 towers, 2 ancients, 6 barracks, outposts, neutral camps, and objectives
static func populate_map_structures(parent_map: Node3D) -> Dictionary:
	var result = {
		"towers": [],
		"spawners": [],
		"ancients": [],
		"fountains": []
	}
	
	var struct_root = parent_map.get_node_or_null("Structures")
	if struct_root == null:
		struct_root = Node3D.new()
		struct_root.name = "Structures"
		parent_map.add_child(struct_root)
		
	var tower_container = struct_root.get_node_or_null("Towers")
	if tower_container == null:
		tower_container = Node3D.new()
		tower_container.name = "Towers"
		struct_root.add_child(tower_container)
		
	var obj_container = struct_root.get_node_or_null("Objectives")
	if obj_container == null:
		obj_container = Node3D.new()
		obj_container.name = "Objectives"
		struct_root.add_child(obj_container)
		
	var spawner_container = parent_map.get_node_or_null("Spawners")
	if spawner_container == null:
		spawner_container = Node3D.new()
		spawner_container.name = "Spawners"
		parent_map.add_child(spawner_container)
		
	var camp_container = parent_map.get_node_or_null("NeutralCamps")
	if camp_container == null:
		camp_container = Node3D.new()
		camp_container.name = "NeutralCamps"
		parent_map.add_child(camp_container)
		
	var interactables = parent_map.get_node_or_null("MapInteractables")
	if interactables == null:
		interactables = Node3D.new()
		interactables.name = "MapInteractables"
		parent_map.add_child(interactables)
		
	for child in tower_container.get_children():
		child.queue_free()
	for child in obj_container.get_children():
		child.queue_free()
	for child in spawner_container.get_children():
		child.queue_free()
	for child in camp_container.get_children():
		child.queue_free()
	for child in interactables.get_children():
		child.queue_free()
		
	# 1. ANCIENT CORES
	var rad_ancient = _spawn_ancient(obj_container, "Radiant_Ancient_Core", TeamDefinitions.Team.RADIANT, Vector3(-85, ELEVATION_BASE, 85))
	var dire_ancient = _spawn_ancient(obj_container, "Dire_Ancient_Core", TeamDefinitions.Team.DIRE, Vector3(85, ELEVATION_BASE, -85))
	result["ancients"].append(rad_ancient)
	result["ancients"].append(dire_ancient)
	
	# 2. TOWERS (11 Radiant, 11 Dire = 22 Towers Total)
	var tower_configs = [
		# RADIANT TOWERS
		{"name": "Radiant_T1", "alias": "Radiant_T1", "team": 0, "tier": 1, "pos": Vector3(-16, ELEVATION_GROUND, 16)},
		{"name": "Radiant_T2", "alias": "Radiant_T2", "team": 0, "tier": 2, "pos": Vector3(-38, ELEVATION_GROUND, 38)},
		{"name": "Radiant_T3_Mid", "alias": "Radiant_T3_Mid", "team": 0, "tier": 3, "pos": Vector3(-60, ELEVATION_BASE, 60)},
		
		{"name": "Radiant_T1_Top", "alias": "Radiant_T1_Top", "team": 0, "tier": 1, "pos": Vector3(-75, ELEVATION_GROUND, -35)},
		{"name": "Radiant_T2_Top", "alias": "Radiant_T2_Top", "team": 0, "tier": 2, "pos": Vector3(-75, ELEVATION_GROUND, 10)},
		{"name": "Radiant_T3_Top", "alias": "Radiant_T3_Top", "team": 0, "tier": 3, "pos": Vector3(-72, ELEVATION_BASE, 48)},
		
		{"name": "Radiant_T1_Bot", "alias": "Radiant_T1_Bot", "team": 0, "tier": 1, "pos": Vector3(35, ELEVATION_GROUND, 75)},
		{"name": "Radiant_T2_Bot", "alias": "Radiant_T2_Bot", "team": 0, "tier": 2, "pos": Vector3(-10, ELEVATION_GROUND, 75)},
		{"name": "Radiant_T3_Bot", "alias": "Radiant_T3_Bot", "team": 0, "tier": 3, "pos": Vector3(-48, ELEVATION_BASE, 72)},
		
		{"name": "Radiant_T4_1", "alias": "Radiant_T4_1", "team": 0, "tier": 4, "pos": Vector3(-78, ELEVATION_BASE, 83)},
		{"name": "Radiant_T4_2", "alias": "Radiant_T4_2", "team": 0, "tier": 4, "pos": Vector3(-83, ELEVATION_BASE, 78)},
		
		# DIRE TOWERS (Exact 180-deg Anti-Symmetry: -pos_radiant)
		{"name": "Dire_T1", "alias": "Dire_T1", "team": 1, "tier": 1, "pos": Vector3(16, ELEVATION_GROUND, -16)},
		{"name": "Dire_T2", "alias": "Dire_T2", "team": 1, "tier": 2, "pos": Vector3(38, ELEVATION_GROUND, -38)},
		{"name": "Dire_T3_Mid", "alias": "Dire_T3_Mid", "team": 1, "tier": 3, "pos": Vector3(60, ELEVATION_BASE, -60)},
		
		{"name": "Dire_T1_Top", "alias": "Dire_T1_Top", "team": 1, "tier": 1, "pos": Vector3(-35, ELEVATION_GROUND, -75)},
		{"name": "Dire_T2_Top", "alias": "Dire_T2_Top", "team": 1, "tier": 2, "pos": Vector3(10, ELEVATION_GROUND, -75)},
		{"name": "Dire_T3_Top", "alias": "Dire_T3_Top", "team": 1, "tier": 3, "pos": Vector3(48, ELEVATION_BASE, -72)},
		
		{"name": "Dire_T1_Bot", "alias": "Dire_T1_Bot", "team": 1, "tier": 1, "pos": Vector3(75, ELEVATION_GROUND, 35)},
		{"name": "Dire_T2_Bot", "alias": "Dire_T2_Bot", "team": 1, "tier": 2, "pos": Vector3(75, ELEVATION_GROUND, -10)},
		{"name": "Dire_T3_Bot", "alias": "Dire_T3_Bot", "team": 1, "tier": 3, "pos": Vector3(72, ELEVATION_BASE, -48)},
		
		{"name": "Dire_T4_1", "alias": "Dire_T4_1", "team": 1, "tier": 4, "pos": Vector3(78, ELEVATION_BASE, -83)},
		{"name": "Dire_T4_2", "alias": "Dire_T4_2", "team": 1, "tier": 4, "pos": Vector3(83, ELEVATION_BASE, -78)}
	]
	
	for cfg in tower_configs:
		var t = TowerEntityClass.new()
		t.name = cfg["name"]
		t.entity_name = cfg["alias"]
		t.team = cfg["team"] as TeamDefinitions.Team
		t.tier = cfg["tier"]
		tower_container.add_child(t)
		t.position = cfg["pos"]
		t.add_to_group("combat_entities")
		t.add_to_group("towers")
		result["towers"].append(t)
		
	# 3. LANE MINION SPAWNERS
	_spawn_spawner(spawner_container, "Radiant_Spawner_Mid", TeamDefinitions.Team.RADIANT, LaneMinionSpawner.Lane.MID, Vector3(-66, ELEVATION_BASE, 66), result["spawners"])
	_spawn_spawner(spawner_container, "Radiant_Spawner_Top", TeamDefinitions.Team.RADIANT, LaneMinionSpawner.Lane.TOP, Vector3(-76, ELEVATION_BASE, 54), result["spawners"])
	_spawn_spawner(spawner_container, "Radiant_Spawner_Bot", TeamDefinitions.Team.RADIANT, LaneMinionSpawner.Lane.BOT, Vector3(-54, ELEVATION_BASE, 76), result["spawners"])
	
	_spawn_spawner(spawner_container, "Dire_Spawner_Mid", TeamDefinitions.Team.DIRE, LaneMinionSpawner.Lane.MID, Vector3(66, ELEVATION_BASE, -66), result["spawners"])
	_spawn_spawner(spawner_container, "Dire_Spawner_Top", TeamDefinitions.Team.DIRE, LaneMinionSpawner.Lane.TOP, Vector3(54, ELEVATION_BASE, -76), result["spawners"])
	_spawn_spawner(spawner_container, "Dire_Spawner_Bot", TeamDefinitions.Team.DIRE, LaneMinionSpawner.Lane.BOT, Vector3(76, ELEVATION_BASE, -54), result["spawners"])
	
	# 4. FOUNTAINS & BASE HEALING
	var rad_fountain = FountainHealingAreaClass.new()
	rad_fountain.name = "RadiantFountainArea"
	rad_fountain.team = TeamDefinitions.Team.RADIANT
	interactables.add_child(rad_fountain)
	rad_fountain.position = Vector3(-95, ELEVATION_BASE, 95)
	result["fountains"].append(rad_fountain)
	
	var dire_fountain = FountainHealingAreaClass.new()
	dire_fountain.name = "DireFountainArea"
	dire_fountain.team = TeamDefinitions.Team.DIRE
	interactables.add_child(dire_fountain)
	dire_fountain.position = Vector3(95, ELEVATION_BASE, -95)
	result["fountains"].append(dire_fountain)
	
	# 5. OUTPOSTS & SECRET SHOPS
	var rad_outpost = OutpostObjectiveClass.new()
	rad_outpost.name = "RadiantOutpost"
	rad_outpost.outpost_name = "Radiant Jungle Outpost"
	rad_outpost.controlling_team = TeamDefinitions.Team.RADIANT
	interactables.add_child(rad_outpost)
	rad_outpost.position = Vector3(-40, ELEVATION_GROUND, -10)
	
	var dire_outpost = OutpostObjectiveClass.new()
	dire_outpost.name = "DireOutpost"
	dire_outpost.outpost_name = "Dire Jungle Outpost"
	dire_outpost.controlling_team = TeamDefinitions.Team.DIRE
	interactables.add_child(dire_outpost)
	dire_outpost.position = Vector3(40, ELEVATION_GROUND, 10)
	
	var rad_shop = SecretShopAreaClass.new()
	rad_shop.name = "RadiantSecretShop"
	rad_shop.shop_name = "Radiant Secret Shop"
	interactables.add_child(rad_shop)
	rad_shop.position = Vector3(-55, ELEVATION_GROUND, -40)
	
	var dire_shop = SecretShopAreaClass.new()
	dire_shop.name = "DireSecretShop"
	dire_shop.shop_name = "Dire Secret Shop"
	interactables.add_child(dire_shop)
	dire_shop.position = Vector3(55, ELEVATION_GROUND, 40)
	
	# 6. NEUTRAL JUNGLE CAMPS
	_spawn_camp(camp_container, "Radiant_Small_Camp", "Radiant Small Camp", 0, Vector3(-45, ELEVATION_GROUND, 25))
	_spawn_camp(camp_container, "Radiant_Medium_Camp", "Radiant Medium Camp", 1, Vector3(-30, ELEVATION_GROUND, 48))
	_spawn_camp(camp_container, "Radiant_Large_Camp", "Radiant Large Camp", 2, Vector3(-50, ELEVATION_GROUND, 55))
	_spawn_camp(camp_container, "Radiant_Ancient_Camp", "Radiant Ancient Camp", 3, Vector3(-60, ELEVATION_GROUND, 15))
	
	_spawn_camp(camp_container, "Dire_Small_Camp", "Dire Small Camp", 0, Vector3(45, ELEVATION_GROUND, -25))
	_spawn_camp(camp_container, "Dire_Medium_Camp", "Dire Medium Camp", 1, Vector3(30, ELEVATION_GROUND, -48))
	_spawn_camp(camp_container, "Dire_Large_Camp", "Dire Large Camp", 2, Vector3(50, ELEVATION_GROUND, -55))
	_spawn_camp(camp_container, "Dire_Ancient_Camp", "Dire Ancient Camp", 3, Vector3(60, ELEVATION_GROUND, -15))
	
	# 7. RIVER RUNES & BOSS
	var obj_root = parent_map.get_node_or_null("ObjectivesRoot")
	if obj_root == null:
		obj_root = Node3D.new()
		obj_root.name = "ObjectivesRoot"
		parent_map.add_child(obj_root)
		
	for child in obj_root.get_children():
		obj_root.remove_child(child)
		child.free()
		
	var rune_top = RiverRuneSpawnerClass.new()
	rune_top.name = "RuneSpawnerTop"
	obj_root.add_child(rune_top)
	rune_top.position = Vector3(-20, ELEVATION_RIVER + 0.1, -20)
	
	var rune_bot = RiverRuneSpawnerClass.new()
	rune_bot.name = "RuneSpawnerBot"
	obj_root.add_child(rune_bot)
	rune_bot.position = Vector3(20, ELEVATION_RIVER + 0.1, 20)
	
	var boss = EpicBossEntityClass.new()
	boss.name = "EclipseLeviathan"
	obj_root.add_child(boss)
	boss.position = Vector3(-22, ELEVATION_RIVER - 0.2, -35)
	boss.add_to_group("combat_entities")
	
	# 8. BUSHES
	var bush_root = parent_map.get_node_or_null("Bushes")
	if bush_root == null:
		bush_root = Node3D.new()
		bush_root.name = "Bushes"
		parent_map.add_child(bush_root)
	for child in bush_root.get_children():
		bush_root.remove_child(child)
		child.free()
		
	var bush_positions = [
		Vector3(-14, ELEVATION_RIVER, -14),
		Vector3(14, ELEVATION_RIVER, 14),
		Vector3(-28, ELEVATION_GROUND, -5),
		Vector3(28, ELEVATION_GROUND, 5),
		Vector3(-65, ELEVATION_GROUND, -30),
		Vector3(65, ELEVATION_GROUND, 30),
		Vector3(-10, ELEVATION_GROUND, 65),
		Vector3(10, ELEVATION_GROUND, -65)
	]
	for i in range(bush_positions.size()):
		var b_pos = bush_positions[i]
		var b = BushArea3DClass.new()
		b.name = "Bush_%d" % i
		b.bush_radius = 4.0
		bush_root.add_child(b)
		b.position = b_pos
		
	return result

static func _spawn_ancient(parent: Node3D, p_name: String, p_team: TeamDefinitions.Team, pos: Vector3) -> ObjectiveEntity:
	var anc = ObjectiveEntityClass.new()
	anc.name = p_name
	anc.entity_name = p_name
	anc.team = p_team
	anc.objective_type = ObjectiveEntity.ObjectiveType.ANCIENT_CORE
	parent.add_child(anc)
	anc.position = pos
	anc.add_to_group("combat_entities")
	anc.add_to_group("objectives")
	return anc

static func _spawn_spawner(parent: Node3D, p_name: String, p_team: TeamDefinitions.Team, p_lane: LaneMinionSpawner.Lane, pos: Vector3, container: Array) -> LaneMinionSpawner:
	var spawner = LaneMinionSpawnerClass.new()
	spawner.name = p_name
	spawner.team = p_team
	spawner.lane = p_lane
	spawner.lane_waypoints.assign(get_dota_lane_waypoints(p_team, p_lane))
	parent.add_child(spawner)
	spawner.position = pos
	container.append(spawner)
	return spawner

static func _spawn_camp(parent: Node3D, p_name: String, display_name: String, camp_type: int, pos: Vector3) -> void:
	var camp = NeutralCampSpawnerClass.new()
	camp.name = p_name
	camp.camp_name = display_name
	camp.camp_type = camp_type
	parent.add_child(camp)
	camp.position = pos

## Returns complete, authentic 3D waypoints for 240x240m Dota map
static func get_dota_lane_waypoints(p_team: TeamDefinitions.Team, p_lane: LaneMinionSpawner.Lane) -> Array[Vector3]:
	var pts: Array[Vector3] = []
	
	if p_team == TeamDefinitions.Team.RADIANT:
		match p_lane:
			LaneMinionSpawner.Lane.MID:
				pts = [
					Vector3(-66, ELEVATION_BASE, 66),
					Vector3(-54, 0.0, 54),
					Vector3(-38, ELEVATION_GROUND, 38),
					Vector3(-16, ELEVATION_GROUND, 16),
					Vector3(-4, ELEVATION_RIVER, 4),
					Vector3(0, ELEVATION_RIVER, 0),
					Vector3(4, ELEVATION_RIVER, -4),
					Vector3(16, ELEVATION_GROUND, -16),
					Vector3(38, ELEVATION_GROUND, -38),
					Vector3(54, 0.0, -54),
					Vector3(66, ELEVATION_BASE, -66),
					Vector3(85, ELEVATION_BASE, -85)
				]
			LaneMinionSpawner.Lane.TOP:
				pts = [
					Vector3(-76, ELEVATION_BASE, 54),
					Vector3(-78, 0.0, 42),
					Vector3(-75, ELEVATION_GROUND, 10),
					Vector3(-75, ELEVATION_GROUND, -35),
					Vector3(-75, ELEVATION_RIVER, -55),
					Vector3(-55, ELEVATION_RIVER, -75),
					Vector3(-35, ELEVATION_GROUND, -75),
					Vector3(10, ELEVATION_GROUND, -75),
					Vector3(42, 0.0, -78),
					Vector3(54, ELEVATION_BASE, -76),
					Vector3(66, ELEVATION_BASE, -66),
					Vector3(85, ELEVATION_BASE, -85)
				]
			LaneMinionSpawner.Lane.BOT:
				pts = [
					Vector3(-54, ELEVATION_BASE, 76),
					Vector3(-42, 0.0, 78),
					Vector3(-10, ELEVATION_GROUND, 75),
					Vector3(35, ELEVATION_GROUND, 75),
					Vector3(55, ELEVATION_RIVER, 75),
					Vector3(75, ELEVATION_RIVER, 55),
					Vector3(75, ELEVATION_GROUND, 35),
					Vector3(75, ELEVATION_GROUND, -10),
					Vector3(78, 0.0, -42),
					Vector3(76, ELEVATION_BASE, -54),
					Vector3(66, ELEVATION_BASE, -66),
					Vector3(85, ELEVATION_BASE, -85)
				]
	else:
		match p_lane:
			LaneMinionSpawner.Lane.MID:
				pts = [
					Vector3(66, ELEVATION_BASE, -66),
					Vector3(54, 0.0, -54),
					Vector3(38, ELEVATION_GROUND, -38),
					Vector3(16, ELEVATION_GROUND, -16),
					Vector3(4, ELEVATION_RIVER, -4),
					Vector3(0, ELEVATION_RIVER, 0),
					Vector3(-4, ELEVATION_RIVER, 4),
					Vector3(-16, ELEVATION_GROUND, 16),
					Vector3(-38, ELEVATION_GROUND, 38),
					Vector3(-54, 0.0, 54),
					Vector3(-66, ELEVATION_BASE, 66),
					Vector3(-85, ELEVATION_BASE, 85)
				]
			LaneMinionSpawner.Lane.TOP:
				pts = [
					Vector3(54, ELEVATION_BASE, -76),
					Vector3(42, 0.0, -78),
					Vector3(10, ELEVATION_GROUND, -75),
					Vector3(-35, ELEVATION_GROUND, -75),
					Vector3(-55, ELEVATION_RIVER, -75),
					Vector3(-75, ELEVATION_RIVER, -55),
					Vector3(-75, ELEVATION_GROUND, -35),
					Vector3(-75, ELEVATION_GROUND, 10),
					Vector3(-78, 0.0, 42),
					Vector3(-76, ELEVATION_BASE, 54),
					Vector3(-66, ELEVATION_BASE, 66),
					Vector3(-85, ELEVATION_BASE, 85)
				]
			LaneMinionSpawner.Lane.BOT:
				pts = [
					Vector3(76, ELEVATION_BASE, -54),
					Vector3(78, 0.0, -42),
					Vector3(75, ELEVATION_GROUND, -10),
					Vector3(75, ELEVATION_GROUND, 35),
					Vector3(75, ELEVATION_RIVER, 55),
					Vector3(55, ELEVATION_RIVER, 75),
					Vector3(35, ELEVATION_GROUND, 75),
					Vector3(-10, ELEVATION_GROUND, 75),
					Vector3(-42, 0.0, 78),
					Vector3(-54, ELEVATION_BASE, 76),
					Vector3(-66, ELEVATION_BASE, 66),
					Vector3(-85, ELEVATION_BASE, 85)
				]
				
	return pts
