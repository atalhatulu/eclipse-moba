class_name NoctisShadowStrike3D
extends Node3D

## Pitch-black void shadow strike on Q (Blind Spot)

func _ready() -> void:
	_create_strike()

func _create_strike() -> void:
	var blade = MeshInstance3D.new()
	var prism = BoxMesh.new()
	prism.size = Vector3(0.15, 2.4, 0.45)
	blade.mesh = prism
	blade.position.y = 1.0
	blade.rotation.z = deg_to_rad(45.0)
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.05, 0.02, 0.08, 0.95) # Pitch Black Void
	mat.emission_enabled = true
	mat.emission = Color(0.35, 0.10, 0.50)
	mat.emission_energy_multiplier = 2.5
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	blade.material_override = mat
	add_child(blade)
	
	var tw = create_tween()
	if tw != null:
		tw.set_parallel(true)
		tw.tween_property(blade, "scale", Vector3(1.6, 1.2, 1.6), 0.22).set_trans(Tween.TRANS_QUAD)
		tw.tween_property(mat, "albedo_color:a", 0.0, 0.22)
		tw.chain().tween_callback(queue_free)
	else:
		queue_free()
