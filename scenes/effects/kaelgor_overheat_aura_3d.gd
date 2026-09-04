class_name KaelgorOverheatAura3D
extends Node3D

## Continuous flaming lava spiral and scorched aura during R (Overheat)

var duration: float = 8.0
var timer: float = 8.0
var ring: MeshInstance3D = null

func _ready() -> void:
	_create_aura()

func _create_aura() -> void:
	ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 1.3
	torus.outer_radius = 1.5
	ring.mesh = torus
	ring.position.y = 0.5
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(1.0, 0.3, 0.05, 0.9)
	mat.emission_enabled = true
	mat.emission = Color(1.0, 0.4, 0.1)
	mat.emission_energy_multiplier = 3.5
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring.material_override = mat
	add_child(ring)

func _process(delta: float) -> void:
	timer -= delta
	if ring != null:
		ring.rotate_y(4.0 * delta)
	if timer <= 0.0:
		queue_free()
