class_name VeylinAdaptationCone3D
extends Node3D

## Wide 7.0m prismatic arcane surge shockwave cone on R (Adaptation)

func _ready() -> void:
	_create_cone()

func _create_cone() -> void:
	var ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 3.5
	torus.outer_radius = 4.2
	ring.mesh = torus
	ring.position.y = 0.2
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.6, 0.2, 0.95, 0.9)
	mat.emission_enabled = true
	mat.emission = Color(0.7, 0.3, 1.0)
	mat.emission_energy_multiplier = 3.2
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring.material_override = mat
	add_child(ring)
	
	var tw = create_tween()
	if tw != null:
		tw.set_parallel(true)
		tw.tween_property(ring, "scale", Vector3(2.4, 1.0, 2.4), 0.35).set_trans(Tween.TRANS_QUAD)
		tw.tween_property(mat, "albedo_color:a", 0.0, 0.35)
		tw.chain().tween_callback(queue_free)
	else:
		queue_free()
