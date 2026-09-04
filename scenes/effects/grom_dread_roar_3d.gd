class_name GromDreadRoar3D
extends Node3D

## Dark crimson sonic roar shockwave on W (Dread Roar)

func _ready() -> void:
	_create_roar()

func _create_roar() -> void:
	var ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 2.0
	torus.outer_radius = 2.4
	ring.mesh = torus
	ring.position.y = 0.2
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.8, 0.05, 0.1, 0.85)
	mat.emission_enabled = true
	mat.emission = Color(0.9, 0.1, 0.15)
	mat.emission_energy_multiplier = 2.5
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring.material_override = mat
	add_child(ring)
	
	var tw = create_tween()
	if tw != null:
		tw.set_parallel(true)
		tw.tween_property(ring, "scale", Vector3(2.4, 1.0, 2.4), 0.30).set_trans(Tween.TRANS_QUAD)
		tw.tween_property(mat, "albedo_color:a", 0.0, 0.30)
		tw.chain().tween_callback(queue_free)
	else:
		queue_free()
