class_name VeylinCounterspellBarrier3D
extends Node3D

## Faceted crystalline hex-shield barrier around Veylin on W (Counterspell)

var duration: float = 2.0
var timer: float = 2.0
var shield_mesh: MeshInstance3D = null

func _ready() -> void:
	_create_barrier()

func _create_barrier() -> void:
	shield_mesh = MeshInstance3D.new()
	var s_mesh = SphereMesh.new()
	s_mesh.radius = 0.95
	s_mesh.height = 1.90
	shield_mesh.mesh = s_mesh
	shield_mesh.position.y = 0.90
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.4, 0.2, 0.9, 0.45) # Indigo Hex Prismatic
	mat.emission_enabled = true
	mat.emission = Color(0.6, 0.3, 1.0)
	mat.emission_energy_multiplier = 2.5
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	shield_mesh.material_override = mat
	add_child(shield_mesh)

func _process(delta: float) -> void:
	timer -= delta
	if shield_mesh != null:
		shield_mesh.rotate_y(2.5 * delta)
	if timer <= 0.0:
		queue_free()
