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
