class_name SpellVisualFX3D
extends Node3D

## Punchy 3D visual FX generator for Spells, Explosions, Shockwaves, Beams, Slashes and Shields

static func spawn_arcane_burst(parent: Node, world_pos: Vector3, radius: float = 3.0, color: Color = Color(0.2, 0.6, 1.0)) -> void:
	if parent == null:
		return
	var root = Node3D.new()
	parent.add_child(root)
	root.position = world_pos
	
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
	
	# Quick Animate and Auto Free if inside tree
	if root.is_inside_tree():
		var tween = root.create_tween()
		if tween != null:
			tween.tween_property(ring_inst, "scale", Vector3(1.4, 1.4, 1.4), 0.45)
			tween.parallel().tween_property(mat, "albedo_color:a", 0.0, 0.45)
			tween.parallel().tween_property(light, "light_energy", 0.0, 0.45)
			tween.tween_callback(root.queue_free)

static func spawn_shield_bubble(target_hero: Node3D, duration: float = 4.0, color: Color = Color(0.3, 0.75, 1.0, 0.5)) -> void:
	if target_hero == null:
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
	
	if bubble.is_inside_tree():
		var tween = bubble.create_tween()
		if tween != null:
			tween.tween_interval(duration)
			tween.tween_property(mat, "albedo_color:a", 0.0, 0.3)
			tween.tween_callback(bubble.queue_free)

static func spawn_orbital_starfall(parent: Node, world_pos: Vector3, radius: float = 8.0, color: Color = Color(0.6, 0.3, 1.0)) -> void:
	if parent == null:
		return
	var root = Node3D.new()
	parent.add_child(root)
	root.position = world_pos
	
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
	
	if root.is_inside_tree():
		var tween = root.create_tween()
		if tween != null:
			tween.tween_property(pillar, "scale", Vector3(1.2, 1.0, 1.2), 0.6)
			tween.parallel().tween_property(mat, "albedo_color:a", 0.0, 0.6)
			tween.parallel().tween_property(light, "light_energy", 0.0, 0.6)
			tween.tween_callback(root.queue_free)

static func spawn_ground_slam(parent: Node, world_pos: Vector3, radius: float = 4.0, color: Color = Color(0.8, 0.45, 0.15)) -> void:
	if parent == null:
		return
	var root = Node3D.new()
	parent.add_child(root)
	root.position = world_pos
	
	# 1. Ground Crater Ring
	var disc = MeshInstance3D.new()
	var cyl = CylinderMesh.new()
	cyl.top_radius = radius
	cyl.bottom_radius = radius
	cyl.height = 0.08
	disc.mesh = cyl
	disc.position.y = 0.05
	
	var mat = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = color
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	disc.material_override = mat
	root.add_child(disc)
	
	# 2. Expanding Shockwave Ring
	var ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = radius * 0.85
	torus.outer_radius = radius
	ring.mesh = torus
	ring.position.y = 0.15
	ring.material_override = mat
	root.add_child(ring)
	
	var light = OmniLight3D.new()
	light.light_color = color
	light.light_energy = 6.0
	light.omni_range = radius * 2.0
	root.add_child(light)
	
	if root.is_inside_tree():
		var tween = root.create_tween()
		if tween != null:
			tween.tween_property(ring, "scale", Vector3(1.5, 1.0, 1.5), 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(mat, "albedo_color:a", 0.0, 0.5)
			tween.parallel().tween_property(light, "light_energy", 0.0, 0.5)
			tween.tween_callback(root.queue_free)

static func spawn_slash_arc(parent: Node, origin_pos: Vector3, forward_dir: Vector3, radius: float = 3.0, color: Color = Color(1.0, 0.8, 0.2)) -> void:
	if parent == null:
		return
	var root = Node3D.new()
	parent.add_child(root)
	root.position = origin_pos
	if forward_dir.length_squared() > 0.001 and root.is_inside_tree():
		root.look_at(origin_pos + forward_dir, Vector3.UP)
		
	var slash = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = radius * 0.8
	torus.outer_radius = radius
	slash.mesh = torus
	slash.position.y = 1.0
	slash.position.z = -radius * 0.4
	
	var mat = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = color
	mat.emission_enabled = true
	mat.emission = color
	mat.emission_energy_multiplier = 4.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	slash.material_override = mat
	root.add_child(slash)
	
	if root.is_inside_tree():
		var tween = root.create_tween()
		if tween != null:
			tween.tween_property(slash, "scale", Vector3(1.4, 0.1, 1.4), 0.25)
			tween.parallel().tween_property(mat, "albedo_color:a", 0.0, 0.25)
			tween.tween_callback(root.queue_free)

static func spawn_shadow_vortex(parent: Node, world_pos: Vector3, radius: float = 3.5, duration: float = 3.0, color: Color = Color(0.4, 0.1, 0.6)) -> void:
	if parent == null:
		return
	var root = Node3D.new()
	parent.add_child(root)
	root.position = world_pos
	
	var disc = MeshInstance3D.new()
	var cyl = CylinderMesh.new()
	cyl.top_radius = radius
	cyl.bottom_radius = radius
	cyl.height = 0.05
	disc.mesh = cyl
	disc.position.y = 0.08
	
	var mat = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = color
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	disc.material_override = mat
	root.add_child(disc)
	
	var light = OmniLight3D.new()
	light.light_color = color
	light.light_energy = 3.0
	light.omni_range = radius * 2.0
	root.add_child(light)
	
	if root.is_inside_tree():
		var tween = root.create_tween()
		if tween != null:
			tween.tween_property(disc, "rotation:y", TAU * 3.0, duration)
			tween.tween_property(mat, "albedo_color:a", 0.0, 0.4)
			tween.parallel().tween_property(light, "light_energy", 0.0, 0.4)
			tween.tween_callback(root.queue_free)

static func spawn_lightning_strike(parent: Node, target_pos: Vector3, color: Color = Color(0.3, 0.85, 1.0)) -> void:
	if parent == null:
		return
	var root = Node3D.new()
	parent.add_child(root)
	root.position = target_pos
	
	# Vertical Lightning Bolt
	var bolt = MeshInstance3D.new()
	var cyl = CylinderMesh.new()
	cyl.top_radius = 0.15
	cyl.bottom_radius = 0.35
	cyl.height = 16.0
	bolt.mesh = cyl
	bolt.position.y = 8.0
	
	var mat = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = color
	mat.emission_enabled = true
	mat.emission = color
	mat.emission_energy_multiplier = 6.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	bolt.material_override = mat
	root.add_child(bolt)
	
	var light = OmniLight3D.new()
	light.light_color = color
	light.light_energy = 10.0
	light.omni_range = 12.0
	root.add_child(light)
	
	if root.is_inside_tree():
		var tween = root.create_tween()
		if tween != null:
			tween.tween_property(bolt, "scale:x", 0.0, 0.35)
			tween.parallel().tween_property(bolt, "scale:z", 0.0, 0.35)
			tween.parallel().tween_property(mat, "albedo_color:a", 0.0, 0.35)
			tween.parallel().tween_property(light, "light_energy", 0.0, 0.35)
			tween.tween_callback(root.queue_free)

## --- MOBA TOWER VISUAL FX & DESTRUCTION SEQUENCE ---

static func spawn_tower_destruction_sequence(parent: Node, tower_pos: Vector3, is_radiant: bool) -> void:
	if parent == null:
		return
		
	var root = Node3D.new()
	root.name = "TowerExplosionFX"
	parent.add_child(root)
	root.position = tower_pos
	
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
		
	if root.is_inside_tree():
		var tween = root.create_tween()
		if tween != null:
			tween.tween_property(shockwave, "scale", Vector3(3.5, 3.5, 3.5), 0.55).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			tween.parallel().tween_property(s_mat, "albedo_color:a", 0.0, 0.55)
			tween.parallel().tween_property(light, "light_energy", 0.0, 0.6)
			tween.parallel().tween_property(dust, "scale", Vector3(3.0, 1.0, 3.0), 0.8)
			tween.parallel().tween_property(d_mat, "albedo_color:a", 0.0, 0.8)
			
			for i in range(debris_nodes.size()):
				var chunk = debris_nodes[i]
				var vel = velocities[i]
				var end_pos = chunk.position + Vector3(vel.x * 0.8, -chunk.position.y + 0.2, vel.z * 0.8)
				tween.parallel().tween_property(chunk, "position", end_pos, 0.9).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
				tween.parallel().tween_property(chunk, "rotation", Vector3(randf_range(-3, 3), randf_range(-3, 3), randf_range(-3, 3)), 0.9)
				
			tween.tween_interval(0.4)
			tween.tween_callback(root.queue_free)
