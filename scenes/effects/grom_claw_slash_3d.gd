class_name GromClawSlash3D
extends Node3D

## Crimson claw slash VFX on Q (Savage Rend)

func _ready() -> void:
	_create_slash()

func _create_slash() -> void:
	var slash = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 0.8
	torus.outer_radius = 1.2
	slash.mesh = torus
	slash.position.y = 0.9
	slash.rotation_degrees = Vector3(45, 0, 0)
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.9, 0.1, 0.1, 0.9)
	mat.emission_enabled = true
	mat.emission = Color(1.0, 0.2, 0.1)
	mat.emission_energy_multiplier = 3.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	slash.material_override = mat
	add_child(slash)
	
	var tw = create_tween()
	if tw != null:
		tw.set_parallel(true)
		tw.tween_property(slash, "scale", Vector3(1.6, 1.6, 1.6), 0.20).set_trans(Tween.TRANS_QUAD)
		tw.tween_property(mat, "albedo_color:a", 0.0, 0.20)
		tw.chain().tween_callback(queue_free)
	else:
		queue_free()
