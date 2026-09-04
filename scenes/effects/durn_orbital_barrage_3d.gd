class_name DurnOrbitalBarrage3D
extends Node3D

## Sequential massive seismic shell impacts on R (Orbital Siege Devastation)

func setup(impact_center: Vector3) -> void:
	global_position = impact_center
	
	# Spawn 3 sequential seismic craters
	var offsets = [Vector3.ZERO, Vector3(-3, 0, -2), Vector3(3, 0, 2)]
	for i in range(offsets.size()):
		var ring = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 5.0
		torus.outer_radius = 6.0
		ring.mesh = torus
		ring.position = offsets[i] + Vector3(0, 0.2, 0)
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(1.0, 0.35, 0.05, 0.95)
		mat.emission_enabled = true
		mat.emission = Color(1.0, 0.4, 0.1)
		mat.emission_energy_multiplier = 4.5
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		ring.material_override = mat
		add_child(ring)
		
		var tw = create_tween()
		if tw != null:
			tw.tween_interval(float(i) * 0.25)
			tw.parallel().tween_property(ring, "scale", Vector3(1.4, 1.0, 1.4), 0.35).set_trans(Tween.TRANS_QUAD)
			tw.parallel().tween_property(mat, "albedo_color:a", 0.0, 0.50)
			
	var end_tw = create_tween()
	if end_tw != null:
		end_tw.tween_interval(1.5)
		end_tw.tween_callback(queue_free)
	else:
		queue_free()
