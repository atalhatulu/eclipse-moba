class_name SelkaCurseDetonate3D
extends Node3D

## Hex explosion shockwave around Selka on E (Detonate)

func _ready() -> void:
	_create_shockwave()

func _create_shockwave() -> void:
	var sphere = MeshInstance3D.new()
	var s_mesh = SphereMesh.new()
	s_mesh.radius = 7.0
	s_mesh.height = 14.0
	sphere.mesh = s_mesh
	sphere.position.y = 0.5
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.75, 0.1, 0.85, 0.4)
	mat.emission_enabled = true
	mat.emission = Color(0.9, 0.2, 1.0)
	mat.emission_energy_multiplier = 3.5
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	sphere.material_override = mat
	add_child(sphere)
	
	var tw = create_tween()
	if tw != null:
		tw.set_parallel(true)
		tw.tween_property(sphere, "scale", Vector3(1.2, 0.3, 1.2), 0.25).set_trans(Tween.TRANS_EXPO)
		tw.tween_property(mat, "albedo_color:a", 0.0, 0.25)
		tw.chain().tween_callback(queue_free)
	else:
		queue_free()
