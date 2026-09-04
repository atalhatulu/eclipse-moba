extends SceneTree

func _init() -> void:
	call_deferred("_bake_map")

func _bake_map() -> void:
	print("Baking physical 240x240m Dota map into moba_map_3d.tscn...")
	
	var DotaMapBuilder3DClass = load("res://systems/map/dota_map_builder_3d.gd")
	if DotaMapBuilder3DClass == null:
		printerr("Failed to load DotaMapBuilder3D")
		quit(1)
		return
		
	var scene_res = ResourceLoader.load("res://scenes/map/moba_map_3d.tscn")
	if scene_res == null:
		printerr("Failed to load moba_map_3d.tscn")
		quit(1)
		return
		
	var map_root: Node = scene_res.instantiate()
	if map_root == null:
		printerr("Failed to instantiate moba_map_3d.tscn")
		quit(1)
		return
		
	var nav_region = map_root.get_node_or_null("NavigationRegion3D")
	if nav_region == null:
		printerr("NavigationRegion3D not found!")
		quit(1)
		return
		
	# 1. Clean obsolete demo terrain nodes
	var old_terrain = nav_region.get_node_or_null("Terrain")
	if old_terrain != null:
		nav_region.remove_child(old_terrain)
		old_terrain.free()
		
	var old_csg = nav_region.get_node_or_null("TerrainCSG")
	if old_csg != null:
		nav_region.remove_child(old_csg)
		old_csg.free()
		
	var old_dota_terrain = nav_region.get_node_or_null("DotaTerrain")
	if old_dota_terrain != null:
		nav_region.remove_child(old_dota_terrain)
		old_dota_terrain.free()
		
	# 2. Build 3D Terrain
	DotaMapBuilder3DClass.build_dota_terrain(nav_region)
	
	# 3. Clean and Populate Structures
	var struct_root = map_root.get_node_or_null("Structures")
	if struct_root != null:
		var towers = struct_root.get_node_or_null("Towers")
		if towers != null:
			for c in towers.get_children():
				towers.remove_child(c)
				c.free()
		var objs = struct_root.get_node_or_null("Objectives")
		if objs != null:
			for c in objs.get_children():
				objs.remove_child(c)
				c.free()
				
	var spawners = map_root.get_node_or_null("Spawners")
	if spawners != null:
		for c in spawners.get_children():
			spawners.remove_child(c)
			c.free()
			
	var camps = map_root.get_node_or_null("NeutralCamps")
	if camps != null:
		for c in camps.get_children():
			camps.remove_child(c)
			c.free()
			
	var interactables = map_root.get_node_or_null("MapInteractables")
	if interactables != null:
		for c in interactables.get_children():
			interactables.remove_child(c)
			c.free()
			
	var obj_root = map_root.get_node_or_null("ObjectivesRoot")
	if obj_root != null:
		for c in obj_root.get_children():
			obj_root.remove_child(c)
			c.free()
			
	var bushes = map_root.get_node_or_null("Bushes")
	if bushes != null:
		for c in bushes.get_children():
			bushes.remove_child(c)
			c.free()
			
	DotaMapBuilder3DClass.populate_map_structures(map_root)
	
	# Update Solen player spawn position
	var player_hero = map_root.get_node_or_null("Heroes/PlayerHero")
	if player_hero != null:
		player_hero.position = Vector3(-18.0, 0.0, 18.0)
		
	# Configure DirectionalLight3D shadow distance and LOD
	var dir_light = map_root.get_node_or_null("DirectionalLight3D") as DirectionalLight3D
	if dir_light != null:
		dir_light.directional_shadow_max_distance = 65.0
		dir_light.directional_shadow_fade_start = 0.85
		dir_light.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_4_SPLITS
		
	# Configure Camera3D Far plane and LOD
	var cam = map_root.get_node_or_null("MobaCamera3D") as Camera3D
	if cam != null:
		cam.far = 95.0
		cam.near = 0.5
		
	# 4. Set owner recursively so Godot packs 3D nodes into the scene file
	_set_owner_recursive(map_root, map_root)
	
	var packed = PackedScene.new()
	var pack_err = packed.pack(map_root)
	if pack_err != OK:
		printerr("Failed to pack scene! Error: ", pack_err)
		quit(1)
		return
		
	var save_err = ResourceSaver.save(packed, "res://scenes/map/moba_map_3d.tscn")
	if save_err != OK:
		printerr("Failed to save moba_map_3d.tscn! Error: ", save_err)
		quit(1)
		return
		
	print("SUCCESS: 240x240m Physical Dota Map successfully baked into moba_map_3d.tscn!")
	map_root.free()
	quit(0)

func _set_owner_recursive(node: Node, scene_owner: Node) -> void:
	if node != scene_owner:
		node.owner = scene_owner
	for child in node.get_children():
		_set_owner_recursive(child, scene_owner)
