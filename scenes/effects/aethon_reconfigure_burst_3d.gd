class_name AethonReconfigureBurst3D
extends Node3D

## Expanding radial energy pulse when Aethon casts E (Reconfigure)

func _ready() -> void:
	_create_burst()

func _create_burst() -> void:
	var sphere = MeshInstance3D.new()
	var s_mesh = SphereMesh.new()
	s_mesh.radius = 0.5
	s_mesh.height = 1.0
	sphere.mesh = s_mesh
	sphere.position.y = 0.8
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.9, 0.6, 0.2, 0.85) # Amber Overcharge
	mat.emission_enabled = true
	mat.emission = Color(0.9, 0.6, 0.2)
	mat.emission_energy_multiplier = 3.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	sphere.material_override = mat
	add_child(sphere)
	
	var tw = create_tween()
	if tw != null:
		tw.set_parallel(true)
		tw.tween_property(sphere, "scale", Vector3(10.0, 0.5, 10.0), 0.35).set_trans(Tween.TRANS_EXPO)
		tw.tween_property(mat, "albedo_color:a", 0.0, 0.35)
		tw.chain().tween_callback(queue_free)
	else:
		queue_free()
