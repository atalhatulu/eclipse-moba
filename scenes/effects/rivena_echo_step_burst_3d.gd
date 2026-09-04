class_name RivenaEchoStepBurst3D
extends Node3D

## Instant shadow smoke puff and flash at teleport origin/destination for W (Echo Step)

func _ready() -> void:
	_create_burst()

func _create_burst() -> void:
	var sphere = MeshInstance3D.new()
	var s_mesh = SphereMesh.new()
	s_mesh.radius = 0.6
	s_mesh.height = 1.2
	sphere.mesh = s_mesh
	sphere.position.y = 0.9
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.3, 0.05, 0.5, 0.85) # Shadow Implosion
	mat.emission_enabled = true
	mat.emission = Color(0.7, 0.2, 1.0)
	mat.emission_energy_multiplier = 2.5
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	sphere.material_override = mat
	add_child(sphere)
	
	var tw = create_tween()
	if tw != null:
		tw.set_parallel(true)
		tw.tween_property(sphere, "scale", Vector3(2.5, 0.3, 2.5), 0.25).set_trans(Tween.TRANS_EXPO)
		tw.tween_property(mat, "albedo_color:a", 0.0, 0.25)
		tw.chain().tween_callback(queue_free)
	else:
		queue_free()
