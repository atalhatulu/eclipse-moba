class_name KaeliTwinSlice3D
extends Node3D

## Dynamic Cerulean Cross Slash VFX on Q (Twin Cut)

func _ready() -> void:
	_create_cross_slash()

func _create_cross_slash() -> void:
	for angle in [-35.0, 35.0]:
		var slash = MeshInstance3D.new()
		var prism = BoxMesh.new()
		prism.size = Vector3(0.12, 2.2, 0.40)
		slash.mesh = prism
		slash.position.y = 1.0
		slash.rotation.z = deg_to_rad(angle)
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.20, 0.80, 1.0, 0.90)
		mat.emission_enabled = true
		mat.emission = Color(0.30, 0.90, 1.0)
		mat.emission_energy_multiplier = 3.5
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		slash.material_override = mat
		add_child(slash)
		
		var tw = create_tween()
		if tw != null:
			tw.set_parallel(true)
			tw.tween_property(slash, "scale", Vector3(1.5, 1.2, 1.5), 0.20).set_trans(Tween.TRANS_QUAD)
			tw.tween_property(mat, "albedo_color:a", 0.0, 0.20)
			
	var end_tw = create_tween()
	if end_tw != null:
		end_tw.tween_interval(0.25)
		end_tw.tween_callback(queue_free)
	else:
		queue_free()
