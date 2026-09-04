class_name GerasQuicksand3D
extends Node3D

## 3D Swirling Quicksand Vortex on E

var lifetime: float = 5.0
var timer: float = 5.0
var disc: MeshInstance3D = null

func setup(pos: Vector3, radius: float = 5.0) -> void:
	global_position = pos
	
	disc = MeshInstance3D.new()
	var cyl = CylinderMesh.new()
	cyl.top_radius = radius
	cyl.bottom_radius = radius
	cyl.height = 0.08
	disc.mesh = cyl
	disc.position.y = 0.04
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.65, 0.52, 0.32, 0.80)
	mat.roughness = 0.9
	mat.emission_enabled = true
	mat.emission = Color(0.55, 0.40, 0.20)
	mat.emission_energy_multiplier = 1.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	disc.material_override = mat
	add_child(disc)

func _process(delta: float) -> void:
	timer -= delta
	if disc != null:
		disc.rotate_y(1.2 * delta)
	if timer <= 0.0:
		queue_free()
