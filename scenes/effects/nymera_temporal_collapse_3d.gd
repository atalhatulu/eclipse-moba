class_name NymeraTemporalCollapse3D
extends Node3D

## Imploding golden clock dial that shatters outwards on R (Temporal Collapse)

func _ready() -> void:
	_create_collapse()

func _create_collapse() -> void:
	var ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 4.5
	torus.outer_radius = 5.2
	ring.mesh = torus
	ring.position.y = 0.2
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(1.0, 0.85, 0.2, 0.95)
	mat.emission_enabled = true
	mat.emission = Color(1.0, 0.9, 0.3)
	mat.emission_energy_multiplier = 3.5
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring.material_override = mat
	add_child(ring)
	
	var tw = create_tween()
	if tw != null:
		# Implode then shatter outwards
		tw.tween_property(ring, "scale", Vector3(0.1, 1.0, 0.1), 0.20).set_trans(Tween.TRANS_QUAD)
		tw.chain().tween_property(ring, "scale", Vector3(2.5, 1.0, 2.5), 0.25).set_trans(Tween.TRANS_EXPO)
		tw.parallel().tween_property(mat, "albedo_color:a", 0.0, 0.25)
		tw.chain().tween_callback(queue_free)
	else:
		queue_free()
