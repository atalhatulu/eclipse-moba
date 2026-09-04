class_name NymeraRewindTrail3D
extends Node3D

## Reverse time rift streak beam from current to rewind destination on W (Rewind)

func setup(from_pos: Vector3, to_pos: Vector3) -> void:
	global_position = from_pos
	
	# Beam line
	var dist = from_pos.distance_to(to_pos)
	var cyl = MeshInstance3D.new()
	var c_mesh = CylinderMesh.new()
	c_mesh.top_radius = 0.15
	c_mesh.bottom_radius = 0.15
	c_mesh.height = dist
	cyl.mesh = c_mesh
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.3, 0.9, 1.0, 0.9)
	mat.emission_enabled = true
	mat.emission = Color(0.4, 1.0, 1.0)
	mat.emission_energy_multiplier = 3.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	cyl.material_override = mat
	
	add_child(cyl)
	cyl.position = (to_pos - from_pos) * 0.5
	if dist > 0.01:
		cyl.look_at(to_pos, Vector3.UP)
		cyl.rotate_object_local(Vector3.RIGHT, deg_to_rad(90.0))
		
	var tw = create_tween()
	if tw != null:
		tw.tween_property(mat, "albedo_color:a", 0.0, 0.40)
		tw.tween_callback(queue_free)
	else:
		queue_free()
