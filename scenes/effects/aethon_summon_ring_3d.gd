class_name AethonSummonRing3D
extends Node3D

## Visual runic ring and energy pillar flare when Aethon spawns a construct

func _ready() -> void:
	_create_fx()

func _create_fx() -> void:
	# Ground Runic Ring
	var ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 0.8
	torus.outer_radius = 0.95
	ring.mesh = torus
	ring.position.y = 0.05
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.2, 0.8, 1.0, 0.9)
	mat.emission_enabled = true
	mat.emission = Color(0.2, 0.8, 1.0)
	mat.emission_energy_multiplier = 2.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring.material_override = mat
	add_child(ring)
	
	# Light Pillar
	var pillar = MeshInstance3D.new()
	var cyl = CylinderMesh.new()
	cyl.top_radius = 0.6
	cyl.bottom_radius = 0.8
	cyl.height = 3.5
	pillar.mesh = cyl
	pillar.position.y = 1.75
	var p_mat = StandardMaterial3D.new()
	p_mat.albedo_color = Color(0.3, 0.9, 1.0, 0.4)
	p_mat.emission_enabled = true
	p_mat.emission = Color(0.3, 0.9, 1.0)
	p_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	pillar.material_override = p_mat
	add_child(pillar)
	
	# Scale-up and fade-out tween
	var tw = create_tween()
	if tw != null:
		tw.set_parallel(true)
		tw.tween_property(ring, "scale", Vector3(1.4, 1.0, 1.4), 0.45).set_trans(Tween.TRANS_QUAD)
		tw.tween_property(mat, "albedo_color:a", 0.0, 0.45)
		tw.tween_property(p_mat, "albedo_color:a", 0.0, 0.45)
		tw.chain().tween_callback(queue_free)
	else:
		queue_free()
