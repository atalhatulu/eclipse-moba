class_name AethonSiegeSlam3D
extends Node3D

## Massive crater impact and golden arcane shockwave when Siege Construct lands / assembles

func _ready() -> void:
	_create_slam()

func _create_slam() -> void:
	# Gold Runic Crater Ring
	var ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 2.0
	torus.outer_radius = 2.6
	ring.mesh = torus
	ring.position.y = 0.08
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(1.0, 0.8, 0.2, 0.95)
	mat.emission_enabled = true
	mat.emission = Color(1.0, 0.8, 0.2)
	mat.emission_energy_multiplier = 4.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring.material_override = mat
	add_child(ring)
	
	# Expanding Blast Dome
	var dome = MeshInstance3D.new()
	var s_mesh = SphereMesh.new()
	s_mesh.radius = 1.0
	s_mesh.height = 2.0
	dome.mesh = s_mesh
	dome.position.y = 0.5
	var d_mat = StandardMaterial3D.new()
	d_mat.albedo_color = Color(1.0, 0.9, 0.5, 0.6)
	d_mat.emission_enabled = true
	d_mat.emission = Color(1.0, 0.9, 0.5)
	d_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	dome.material_override = d_mat
	add_child(dome)
	
	var tw = create_tween()
	if tw != null:
		tw.set_parallel(true)
		tw.tween_property(ring, "scale", Vector3(3.2, 1.0, 3.2), 0.55).set_trans(Tween.TRANS_EXPO)
		tw.tween_property(dome, "scale", Vector3(6.5, 1.8, 6.5), 0.40).set_trans(Tween.TRANS_QUAD)
		tw.tween_property(mat, "albedo_color:a", 0.0, 0.55)
		tw.tween_property(d_mat, "albedo_color:a", 0.0, 0.40)
		tw.chain().tween_callback(queue_free)
	else:
		queue_free()
