class_name KaeliTempoBurst3D
extends Node3D

## Expanding sonic rhythm ring on R (Perfect Tempo)

func _ready() -> void:
	_create_pulse()

func _create_pulse() -> void:
	var ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 2.5
	torus.outer_radius = 3.0
	ring.mesh = torus
	ring.position.y = 0.2
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.25, 0.90, 1.0, 0.85)
	mat.emission_enabled = true
	mat.emission = Color(0.35, 0.95, 1.0)
	mat.emission_energy_multiplier = 4.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring.material_override = mat
	add_child(ring)
	
	var tw = create_tween()
	if tw != null:
		tw.set_parallel(true)
		tw.tween_property(ring, "scale", Vector3(2.0, 1.0, 2.0), 0.35).set_trans(Tween.TRANS_QUAD)
		tw.tween_property(mat, "albedo_color:a", 0.0, 0.35)
		tw.chain().tween_callback(queue_free)
	else:
		queue_free()
