class_name SpellVisualFX3D
extends Node3D

## Punchy 3D visual FX generator for Spells, Explosions, Shockwaves, and Shields

static func spawn_arcane_burst(parent: Node, world_pos: Vector3, radius: float = 3.0, color: Color = Color(0.2, 0.6, 1.0)) -> void:
	if parent == null or not parent.is_inside_tree():
		return
	var root = Node3D.new()
	parent.add_child(root)
	root.global_position = world_pos
	
	# Expanding Energy Ring
	var ring_mesh = TorusMesh.new()
	ring_mesh.inner_radius = radius * 0.8
	ring_mesh.outer_radius = radius
	var ring_inst = MeshInstance3D.new()
	ring_inst.mesh = ring_mesh
	ring_inst.position.y = 0.1
	
	var mat = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = color
	mat.emission_enabled = true
	mat.emission = color
	mat.emission_energy_multiplier = 4.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring_inst.material_override = mat
	root.add_child(ring_inst)
	
	# Central Light
	var light = OmniLight3D.new()
	light.light_color = color
	light.light_energy = 5.0
	light.omni_range = radius * 2.5
	root.add_child(light)
	
	# Quick Animate and Auto Free
	var tween = root.create_tween()
	if tween != null:
		tween.tween_property(ring_inst, "scale", Vector3(1.4, 1.4, 1.4), 0.45)
		tween.parallel().tween_property(mat, "albedo_color:a", 0.0, 0.45)
		tween.parallel().tween_property(light, "light_energy", 0.0, 0.45)
		tween.tween_callback(root.queue_free)
	else:
		root.queue_free()

static func spawn_shield_bubble(target_hero: Node3D, duration: float = 4.0, color: Color = Color(0.3, 0.75, 1.0, 0.5)) -> void:
	if target_hero == null or not target_hero.is_inside_tree():
		return
		
	var bubble = MeshInstance3D.new()
	var sphere = SphereMesh.new()
	sphere.radius = 1.3
	sphere.height = 2.6
	bubble.mesh = sphere
	bubble.position.y = 1.1
	
	var mat = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = color
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	bubble.material_override = mat
	target_hero.add_child(bubble)
	
	var tween = bubble.create_tween()
	if tween != null:
		tween.tween_interval(duration)
		tween.tween_property(mat, "albedo_color:a", 0.0, 0.3)
		tween.tween_callback(bubble.queue_free)
	else:
		bubble.queue_free()

static func spawn_orbital_starfall(parent: Node, world_pos: Vector3, radius: float = 8.0, color: Color = Color(0.6, 0.3, 1.0)) -> void:
	if parent == null or not parent.is_inside_tree():
		return
	var root = Node3D.new()
	parent.add_child(root)
	root.global_position = world_pos
	
	# Pillar of Light
	var cyl = CylinderMesh.new()
	cyl.top_radius = radius * 0.9
	cyl.bottom_radius = radius
	cyl.height = 14.0
	var pillar = MeshInstance3D.new()
	pillar.mesh = cyl
	pillar.position.y = 7.0
	
	var mat = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = Color(color.r, color.g, color.b, 0.7)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	pillar.material_override = mat
	root.add_child(pillar)
	
	var light = OmniLight3D.new()
	light.light_color = color
	light.light_energy = 8.0
	light.omni_range = radius * 3.0
	root.add_child(light)
	
	var tween = root.create_tween()
	tween.tween_property(pillar, "scale", Vector3(1.2, 1.0, 1.2), 0.6)
	tween.parallel().tween_property(mat, "albedo_color:a", 0.0, 0.6)
	tween.parallel().tween_property(light, "light_energy", 0.0, 0.6)
	tween.tween_callback(root.queue_free)

## --- MOBA TOWER VISUAL FX & DESTRUCTION SEQUENCE ---

static func spawn_tower_destruction_sequence(parent: Node, tower_pos: Vector3, is_radiant: bool) -> void:
	if parent == null or not parent.is_inside_tree():
		return
		
	var root = Node3D.new()
	root.name = "TowerExplosionFX"
	parent.add_child(root)
	root.global_position = tower_pos
	
	var crystal_color = Color(0.2, 0.95, 0.4) if is_radiant else Color(0.95, 0.2, 0.2)
	
	# 1. Central Core Shockwave Flash
	var shockwave = MeshInstance3D.new()
	var s_mesh = SphereMesh.new()
	s_mesh.radius = 2.0
	s_mesh.height = 4.0
	shockwave.mesh = s_mesh
	shockwave.position.y = 3.0
	
	var s_mat = StandardMaterial3D.new()
	s_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	s_mat.albedo_color = crystal_color
	s_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	shockwave.material_override = s_mat
	root.add_child(shockwave)
	
	# 2. Flash Light
	var light = OmniLight3D.new()
	light.light_color = crystal_color
	light.light_energy = 15.0
	light.omni_range = 18.0
	light.position.y = 3.5
	root.add_child(light)
	
	# 3. Ground Dust Ring
	var dust = MeshInstance3D.new()
	var d_mesh = TorusMesh.new()
	d_mesh.inner_radius = 2.0
	d_mesh.outer_radius = 3.5
	dust.mesh = d_mesh
	dust.position.y = 0.1
	
	var d_mat = StandardMaterial3D.new()
	d_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	d_mat.albedo_color = Color(0.45, 0.42, 0.38, 0.7)
	d_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	dust.material_override = d_mat
	root.add_child(dust)
	
	# 4. Tumbling Rubble Chunks (Procedural Debris)
	var debris_count = 10
	var debris_nodes: Array[MeshInstance3D] = []
	var velocities: Array[Vector3] = []
	
	for i in range(debris_count):
		var chunk = MeshInstance3D.new()
		var box = BoxMesh.new()
		var s = randf_range(0.35, 0.75)
		box.size = Vector3(s, s * randf_range(1.0, 1.8), s)
		chunk.mesh = box
		chunk.position = Vector3(randf_range(-0.8, 0.8), randf_range(1.5, 4.0), randf_range(-0.8, 0.8))
		
		var stone_mat = StandardMaterial3D.new()
		stone_mat.albedo_color = Color(0.24, 0.25, 0.27, 1.0)
		chunk.material_override = stone_mat
		root.add_child(chunk)
		debris_nodes.append(chunk)
		
		var angle = randf() * TAU
		var h_speed = randf_range(4.0, 9.0)
		var v_speed = randf_range(6.0, 12.0)
		velocities.append(Vector3(cos(angle) * h_speed, v_speed, sin(angle) * h_speed))
		
	# Animate Shockwave & Dust with Tween
	var tween = root.create_tween()
	tween.tween_property(shockwave, "scale", Vector3(3.5, 3.5, 3.5), 0.55).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(s_mat, "albedo_color:a", 0.0, 0.55)
	tween.parallel().tween_property(light, "light_energy", 0.0, 0.6)
	tween.parallel().tween_property(dust, "scale", Vector3(3.0, 1.0, 3.0), 0.8)
	tween.parallel().tween_property(d_mat, "albedo_color:a", 0.0, 0.8)
	
	# Animate Tumbling Debris over 1.2s
	for i in range(debris_nodes.size()):
		var chunk = debris_nodes[i]
		var vel = velocities[i]
		var end_pos = chunk.position + Vector3(vel.x * 0.8, -chunk.position.y + 0.2, vel.z * 0.8)
		tween.parallel().tween_property(chunk, "position", end_pos, 0.9).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween.parallel().tween_property(chunk, "rotation", Vector3(randf_range(-3, 3), randf_range(-3, 3), randf_range(-3, 3)), 0.9)
		
	tween.tween_interval(0.4)
	tween.tween_callback(root.queue_free)
