class_name GerasGraniteWall3D
extends Node3D

## 3D Physical Granite Wall on Q (Raise Earth)

var lifetime: float = 6.0
var timer: float = 6.0

func setup(pos: Vector3, rot_y: float = 0.0) -> void:
	global_position = pos
	rotation.y = rot_y
	
	# Visual Stone Pillar Mesh
	var wall_mesh = MeshInstance3D.new()
	var box = BoxMesh.new()
	box.size = Vector3(5.0, 3.2, 0.8)
	wall_mesh.mesh = box
	wall_mesh.position.y = 1.6
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.40, 0.35, 0.28, 1.0) # Granite Stone
	mat.roughness = 0.85
	mat.metallic = 0.10
	mat.emission_enabled = true
	mat.emission = Color(0.60, 0.45, 0.20)
	mat.emission_energy_multiplier = 0.6
	wall_mesh.material_override = mat
	add_child(wall_mesh)
	
	# Physical Collision Shape
	var static_body = StaticBody3D.new()
	static_body.name = "GraniteWallCollider"
	var col_shape = CollisionShape3D.new()
	var box_shape = BoxShape3D.new()
	box_shape.size = Vector3(5.0, 3.2, 0.8)
	col_shape.shape = box_shape
	col_shape.position.y = 1.6
	static_body.add_child(col_shape)
	add_child(static_body)

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0.0:
		queue_free()
