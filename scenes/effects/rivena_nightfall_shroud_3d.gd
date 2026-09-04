class_name RivenaNightfallShroud3D
extends Node3D

## Orbiting shadow wisps and dark mist aura during R (Nightfall)

var duration: float = 6.0
var timer: float = 6.0
var ring_1: MeshInstance3D = null
var ring_2: MeshInstance3D = null

func _ready() -> void:
	_build_shroud()

func _build_shroud() -> void:
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.4, 0.05, 0.6, 0.75)
	mat.emission_enabled = true
	mat.emission = Color(0.6, 0.15, 0.9)
	mat.emission_energy_multiplier = 2.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	
	ring_1 = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 1.1
	torus.outer_radius = 1.3
	ring_1.mesh = torus
	ring_1.position.y = 0.5
	ring_1.material_override = mat
	add_child(ring_1)
	
	ring_2 = MeshInstance3D.new()
	ring_2.mesh = torus
	ring_2.position.y = 1.2
	ring_2.rotation_degrees = Vector3(30, 45, 0)
	ring_2.material_override = mat
	add_child(ring_2)

func _process(delta: float) -> void:
	timer -= delta
	if ring_1 != null:
		ring_1.rotate_y(3.5 * delta)
	if ring_2 != null:
		ring_2.rotate_y(-2.8 * delta)
	if timer <= 0.0:
		queue_free()
