class_name SerisHuntingGround3D
extends Node3D

## 3D Emerald Snare Perimeter and Razor Net Matrix on R (Hunting Ground)

func setup(center_pos: Vector3, radius: float = 6.0) -> void:
	global_position = center_pos
	
	var ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = radius - 0.4
	torus.outer_radius = radius + 0.4
	ring.mesh = torus
	ring.position.y = 0.1
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.15, 0.90, 0.55, 0.85)
	mat.emission_enabled = true
	mat.emission = Color(0.20, 0.95, 0.60)
	mat.emission_energy_multiplier = 3.5
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring.material_override = mat
	add_child(ring)
	
	var tw = create_tween()
	if tw != null:
		tw.tween_interval(1.8)
		tw.parallel().tween_property(mat, "albedo_color:a", 0.0, 0.6)
		tw.chain().tween_callback(queue_free)
	else:
		queue_free()
