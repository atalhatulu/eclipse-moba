class_name DurnMortarImpact3D
extends Node3D

## Explosive crater burst on Q (Mortar Shell)

func _ready() -> void:
	_create_explosion()

func _create_explosion() -> void:
	var sphere = MeshInstance3D.new()
	var s_mesh = SphereMesh.new()
	s_mesh.radius = 3.5
	s_mesh.height = 7.0
	sphere.mesh = s_mesh
	sphere.position.y = 0.5
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(1.0, 0.45, 0.1, 0.85)
	mat.emission_enabled = true
	mat.emission = Color(1.0, 0.4, 0.05)
	mat.emission_energy_multiplier = 4.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	sphere.material_override = mat
	add_child(sphere)
	
	var tw = create_tween()
	if tw != null:
		tw.set_parallel(true)
		tw.tween_property(sphere, "scale", Vector3(1.5, 0.4, 1.5), 0.30).set_trans(Tween.TRANS_QUAD)
		tw.tween_property(mat, "albedo_color:a", 0.0, 0.30)
		tw.chain().tween_callback(queue_free)
	else:
		queue_free()
