class_name KaelgorMoltenFist3D
extends Node3D

## Magma fist impact explosion and embers on Q (Molten Fist)

func _ready() -> void:
	_create_fist_burst()

func _create_fist_burst() -> void:
	var sphere = MeshInstance3D.new()
	var s_mesh = SphereMesh.new()
	s_mesh.radius = 0.5
	s_mesh.height = 1.0
	sphere.mesh = s_mesh
	sphere.position.y = 0.8
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(1.0, 0.35, 0.05, 0.95) # Intense Molten Orange
	mat.emission_enabled = true
	mat.emission = Color(1.0, 0.5, 0.1)
	mat.emission_energy_multiplier = 3.5
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	sphere.material_override = mat
	add_child(sphere)
	
	var tw = create_tween()
	if tw != null:
		tw.set_parallel(true)
		tw.tween_property(sphere, "scale", Vector3(2.2, 0.4, 2.2), 0.22).set_trans(Tween.TRANS_EXPO)
		tw.tween_property(mat, "albedo_color:a", 0.0, 0.22)
		tw.chain().tween_callback(queue_free)
	else:
		queue_free()
