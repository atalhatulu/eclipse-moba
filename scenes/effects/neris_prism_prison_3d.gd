class_name NerisPrismPrison3D
extends Node3D

## 3D Hexagonal Prism Containment Matrix Cage on R (Grand Design)

var duration: float = 2.5
var timer: float = 2.5

func setup(center_pos: Vector3, radius: float = 5.5) -> void:
	global_position = center_pos
	
	# 4 Corner Pillars + Energy Boundary
	for i in range(4):
		var angle = (float(i) / 4.0) * TAU + (PI * 0.25)
		var pylon_pos = Vector3(cos(angle) * radius, 0, sin(angle) * radius)
		
		var pylon = MeshInstance3D.new()
		var cyl = CylinderMesh.new()
		cyl.top_radius = 0.20
		cyl.bottom_radius = 0.35
		cyl.height = 3.5
		pylon.mesh = cyl
		pylon.position = pylon_pos + Vector3(0, 1.75, 0)
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.2, 0.7, 1.0, 0.95)
		mat.emission_enabled = true
		mat.emission = Color(0.3, 0.85, 1.0)
		mat.emission_energy_multiplier = 4.0
		pylon.material_override = mat
		add_child(pylon)
		
	# Ground Hex Grid Ring
	var ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = radius - 0.3
	torus.outer_radius = radius + 0.3
	ring.mesh = torus
	ring.position.y = 0.1
	
	var r_mat = StandardMaterial3D.new()
	r_mat.albedo_color = Color(0.3, 0.8, 1.0, 0.8)
	r_mat.emission_enabled = true
	r_mat.emission = Color(0.4, 0.9, 1.0)
	r_mat.emission_energy_multiplier = 3.5
	r_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring.material_override = r_mat
	add_child(ring)
	
	# Implosion animation
	var tw = create_tween()
	if tw != null:
		tw.tween_interval(1.8)
		tw.parallel().tween_property(r_mat, "albedo_color:a", 0.0, 0.7)
		tw.chain().tween_callback(queue_free)

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0.0:
		queue_free()
