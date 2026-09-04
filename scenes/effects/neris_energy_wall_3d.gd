class_name NerisEnergyWall3D
extends Node3D

## 3D Towering Laser Barrier with Physical Collision on Q (Resonance Wall)

var duration: float = 4.0
var timer: float = 4.0
var static_body: StaticBody3D = null
var wall_mesh: MeshInstance3D = null

func setup(pos_a: Vector3, pos_b: Vector3, dur: float = 4.0) -> void:
	duration = dur
	timer = dur
	
	var dist = pos_a.distance_to(pos_b)
	global_position = (pos_a + pos_b) * 0.5
	
	# Visual Towering Laser Fence
	wall_mesh = MeshInstance3D.new()
	var box = BoxMesh.new()
	box.size = Vector3(0.40, 3.2, dist)
	wall_mesh.mesh = box
	wall_mesh.position.y = 1.6
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.25, 0.70, 1.0, 0.70)
	mat.emission_enabled = true
	mat.emission = Color(0.35, 0.85, 1.0)
	mat.emission_energy_multiplier = 3.5
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	wall_mesh.material_override = mat
	add_child(wall_mesh)
	
	# Physical Collision Shape to block paths
	static_body = StaticBody3D.new()
	static_body.name = "NerisWallCollision"
	var col_shape = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	shape.size = Vector3(0.50, 3.2, dist)
	col_shape.shape = shape
	col_shape.position.y = 1.6
	static_body.add_child(col_shape)
	add_child(static_body)
	
	if dist > 0.01:
		look_at(pos_b, Vector3.UP)

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0.0:
		queue_free()
