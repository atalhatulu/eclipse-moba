class_name KaelgorVentBlast3D
extends Node3D

## Superheated radial steam and flame shockwave on W (Vent)

func _ready() -> void:
	_create_blast()

func _create_blast() -> void:
	var ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 2.0
	torus.outer_radius = 2.5
	ring.mesh = torus
	ring.position.y = 0.1
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(1.0, 0.45, 0.1, 0.85)
	mat.emission_enabled = true
	mat.emission = Color(1.0, 0.5, 0.15)
	mat.emission_energy_multiplier = 3.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring.material_override = mat
	add_child(ring)
	
	var tw = create_tween()
	if tw != null:
		tw.set_parallel(true)
		tw.tween_property(ring, "scale", Vector3(2.5, 1.0, 2.5), 0.35).set_trans(Tween.TRANS_QUAD)
		tw.tween_property(mat, "albedo_color:a", 0.0, 0.35)
		tw.chain().tween_callback(queue_free)
	else:
		queue_free()
