class_name ZinMirrorClone3D
extends Node3D

## 3D Holographic Mirror Twin Clone for Zin on Q (Mirror Mirage)

var lifetime: float = 6.0
var timer: float = 6.0
var body_mesh: MeshInstance3D = null

func _ready() -> void:
	_build_clone()

func _build_clone() -> void:
	body_mesh = MeshInstance3D.new()
	var cap = CapsuleMesh.new()
	cap.radius = 0.50
	cap.height = 2.0
	body_mesh.mesh = cap
	body_mesh.position.y = 1.0
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.70, 0.90, 1.0, 0.65)
	mat.metallic = 0.95
	mat.roughness = 0.10
	mat.emission_enabled = true
	mat.emission = Color(0.50, 0.85, 1.0)
	mat.emission_energy_multiplier = 2.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	body_mesh.material_override = mat
	add_child(body_mesh)

func _process(delta: float) -> void:
	timer -= delta
	if body_mesh != null:
		body_mesh.rotate_y(0.8 * delta)
	if timer <= 0.0:
		queue_free()
