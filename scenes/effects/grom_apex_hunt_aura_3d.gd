class_name GromApexHuntAura3D
extends Node3D

## Blood mist and glowing crimson predator eyes during R (Apex Hunt)

var duration: float = 10.0
var timer: float = 10.0
var ring: MeshInstance3D = null

func _ready() -> void:
	_create_aura()

func _create_aura() -> void:
	ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 1.2
	torus.outer_radius = 1.4
	ring.mesh = torus
	ring.position.y = 0.4
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.95, 0.1, 0.05, 0.9)
	mat.emission_enabled = true
	mat.emission = Color(1.0, 0.15, 0.05)
	mat.emission_energy_multiplier = 3.5
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring.material_override = mat
	add_child(ring)

func _process(delta: float) -> void:
	timer -= delta
	if ring != null:
		ring.rotate_y(3.5 * delta)
	if timer <= 0.0:
		queue_free()
