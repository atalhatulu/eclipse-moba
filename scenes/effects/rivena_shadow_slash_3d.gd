class_name RivenaShadowSlash3D
extends Node3D

## Crescent shadow slash blade VFX on Q (Shadow Cut) and E (Shade Command)

func _ready() -> void:
	_create_slash()

func _create_slash() -> void:
	var blade = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 0.9
	torus.outer_radius = 1.3
	blade.mesh = torus
	blade.rotation_degrees = Vector3(60, 0, 0)
	blade.position.y = 0.9
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.75, 0.15, 1.0, 0.9)
	mat.emission_enabled = true
	mat.emission = Color(0.85, 0.25, 1.0)
	mat.emission_energy_multiplier = 3.5
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	blade.material_override = mat
	add_child(blade)
	
	var tw = create_tween()
	if tw != null:
		tw.set_parallel(true)
		tw.tween_property(blade, "scale", Vector3(1.8, 1.8, 1.8), 0.20).set_trans(Tween.TRANS_QUAD)
		tw.tween_property(mat, "albedo_color:a", 0.0, 0.20)
		tw.chain().tween_callback(queue_free)
	else:
		queue_free()
