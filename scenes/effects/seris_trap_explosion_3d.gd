class_name SerisTrapExplosion3D
extends Node3D

## Emerald shrapnel burst on mine trigger or remote wire detonation

func _ready() -> void:
	_create_explosion()

func _create_explosion() -> void:
	var ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 2.4
	torus.outer_radius = 2.8
	ring.mesh = torus
	ring.position.y = 0.2
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.15, 0.95, 0.60, 0.9)
	mat.emission_enabled = true
	mat.emission = Color(0.20, 1.0, 0.65)
	mat.emission_energy_multiplier = 4.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring.material_override = mat
	add_child(ring)
	
	var tw = create_tween()
	if tw != null:
		tw.set_parallel(true)
		tw.tween_property(ring, "scale", Vector3(1.5, 1.0, 1.5), 0.25).set_trans(Tween.TRANS_QUAD)
		tw.tween_property(mat, "albedo_color:a", 0.0, 0.25)
		tw.chain().tween_callback(queue_free)
	else:
		queue_free()
