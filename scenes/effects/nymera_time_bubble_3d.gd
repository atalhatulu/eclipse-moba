class_name NymeraTimeBubble3D
extends Node3D

## 3D Translucent time-distortion sphere with rotating clock rings on Q (Slow Field)

var radius: float = 5.0
var duration: float = 3.5
var timer: float = 3.5
var clock_ring: MeshInstance3D = null

func _ready() -> void:
	_create_bubble()

func _create_bubble() -> void:
	# Outer Sphere Bubble
	var sphere = MeshInstance3D.new()
	var s_mesh = SphereMesh.new()
	s_mesh.radius = radius
	s_mesh.height = radius * 2.0
	sphere.mesh = s_mesh
	sphere.position.y = 0.5
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.2, 0.8, 0.95, 0.25) # Translucent Cyan
	mat.emission_enabled = true
	mat.emission = Color(0.3, 0.9, 1.0)
	mat.emission_energy_multiplier = 1.2
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	sphere.material_override = mat
	add_child(sphere)
	
	# Rotating Golden Clock Dial Ring
	clock_ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = radius * 0.85
	torus.outer_radius = radius * 0.95
	clock_ring.mesh = torus
	clock_ring.position.y = 0.1
	
	var r_mat = StandardMaterial3D.new()
	r_mat.albedo_color = Color(0.95, 0.85, 0.25, 0.8)
	r_mat.emission_enabled = true
	r_mat.emission = Color(1.0, 0.9, 0.3)
	r_mat.emission_energy_multiplier = 2.0
	r_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	clock_ring.material_override = r_mat
	add_child(clock_ring)

func _process(delta: float) -> void:
	timer -= delta
	if clock_ring != null:
		clock_ring.rotate_y(1.5 * delta)
	if timer <= 0.0:
		queue_free()
