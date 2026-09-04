class_name SeraAstralSurge3D
extends Node3D

## Giant golden-cyan astral cleanse and speed momentum shockwave on R (Astral Surge)

func _ready() -> void:
	_create_surge()

func _create_surge() -> void:
	var ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 3.5
	torus.outer_radius = 4.0
	ring.mesh = torus
	ring.position.y = 0.2
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.2, 0.9, 0.85, 0.9) # Radiant Cyan-Gold
	mat.emission_enabled = true
	mat.emission = Color(0.4, 1.0, 0.9)
	mat.emission_energy_multiplier = 3.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring.material_override = mat
	add_child(ring)
	
	var tw = create_tween()
	if tw != null:
		tw.set_parallel(true)
		tw.tween_property(ring, "scale", Vector3(2.2, 1.0, 2.2), 0.40).set_trans(Tween.TRANS_QUAD)
		tw.tween_property(mat, "albedo_color:a", 0.0, 0.40)
		tw.chain().tween_callback(queue_free)
	else:
		queue_free()
