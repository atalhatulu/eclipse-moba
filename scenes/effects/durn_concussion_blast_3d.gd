class_name DurnConcussionBlast3D
extends Node3D

## Point-blank recoil shockwave on E (Concussion Blast)

func _ready() -> void:
	_create_blast()

func _create_blast() -> void:
	var ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 4.0
	torus.outer_radius = 4.8
	ring.mesh = torus
	ring.position.y = 0.3
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(1.0, 0.7, 0.2, 0.9)
	mat.emission_enabled = true
	mat.emission = Color(1.0, 0.6, 0.1)
	mat.emission_energy_multiplier = 3.5
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring.material_override = mat
	add_child(ring)
	
	var tw = create_tween()
	if tw != null:
		tw.set_parallel(true)
		tw.tween_property(ring, "scale", Vector3(1.6, 1.0, 1.6), 0.25).set_trans(Tween.TRANS_QUAD)
		tw.tween_property(mat, "albedo_color:a", 0.0, 0.25)
		tw.chain().tween_callback(queue_free)
	else:
		queue_free()
