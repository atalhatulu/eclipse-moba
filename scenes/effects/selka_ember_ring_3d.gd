class_name SelkaEmberRing3D
extends Node3D

## Expanding dark violet hex-fire ring on W (Ember Ring)

func _ready() -> void:
	_create_ring()

func _create_ring() -> void:
	var ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 4.0
	torus.outer_radius = 4.8
	ring.mesh = torus
	ring.position.y = 0.15
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.6, 0.1, 0.7, 0.9)
	mat.emission_enabled = true
	mat.emission = Color(0.8, 0.2, 0.9)
	mat.emission_energy_multiplier = 3.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring.material_override = mat
	add_child(ring)
	
	var tw = create_tween()
	if tw != null:
		tw.set_parallel(true)
		tw.tween_property(ring, "scale", Vector3(1.3, 1.0, 1.3), 0.30).set_trans(Tween.TRANS_QUAD)
		tw.tween_property(mat, "albedo_color:a", 0.0, 0.30)
		tw.chain().tween_callback(queue_free)
	else:
		queue_free()
