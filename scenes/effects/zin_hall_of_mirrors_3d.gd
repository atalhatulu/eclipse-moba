class_name ZinHallOfMirrors3D
extends Node3D

## 3-Prism Converging Holographic Mirror Vortex on R (Hall of Mirrors)

func setup(center_pos: Vector3, radius: float = 6.0) -> void:
	global_position = center_pos
	
	# 3 Triangular Mirror Portals
	for i in range(3):
		var mirror = MeshInstance3D.new()
		var box = BoxMesh.new()
		box.size = Vector3(0.15, 2.8, 1.4)
		mirror.mesh = box
		var angle = (float(i) / 3.0) * TAU
		mirror.position = Vector3(cos(angle) * radius, 1.4, sin(angle) * radius)
		mirror.rotation.y = angle + PI * 0.5
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.80, 0.92, 1.0, 0.85)
		mat.metallic = 0.98
		mat.emission_enabled = true
		mat.emission = Color(0.60, 0.90, 1.0)
		mat.emission_energy_multiplier = 4.0
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mirror.material_override = mat
		add_child(mirror)
		
		# Converge into center
		var tw = create_tween()
		if tw != null:
			tw.tween_property(mirror, "position", Vector3(0, 1.4, 0), 0.35).set_trans(Tween.TRANS_QUAD)
			tw.parallel().tween_property(mat, "albedo_color:a", 0.0, 0.40)
			
	var end_tw = create_tween()
	if end_tw != null:
		end_tw.tween_interval(0.50)
		end_tw.tween_callback(queue_free)
	else:
		queue_free()
