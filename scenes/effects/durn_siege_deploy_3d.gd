class_name DurnSiegeDeploy3D
extends Node3D

## 3D Hydraulic Ground Anchors and Target Range Ring on W (Siege Deploy)

var range_ring: MeshInstance3D = null
var is_active: bool = true

func _ready() -> void:
	_create_anchors()

func _create_anchors() -> void:
	# 4 Heavy Steel Anchors into ground
	for i in range(4):
		var angle = (float(i) / 4.0) * TAU + (PI * 0.25)
		var anchor = MeshInstance3D.new()
		var box = BoxMesh.new()
		box.size = Vector3(0.35, 0.4, 0.7)
		anchor.mesh = box
		anchor.position = Vector3(cos(angle) * 1.1, 0.15, sin(angle) * 1.1)
		anchor.rotation.y = angle
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.25, 0.22, 0.20, 1.0)
		mat.metallic = 0.95
		mat.roughness = 0.3
		anchor.material_override = mat
		add_child(anchor)
		
	# 1600m Siege Perimeter Range Indicator Ring
	range_ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 15.5
	torus.outer_radius = 16.0
	range_ring.mesh = torus
	range_ring.position.y = 0.05
	
	var r_mat = StandardMaterial3D.new()
	r_mat.albedo_color = Color(1.0, 0.55, 0.15, 0.35)
	r_mat.emission_enabled = true
	r_mat.emission = Color(1.0, 0.5, 0.1)
	r_mat.emission_energy_multiplier = 2.0
	r_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	range_ring.material_override = r_mat
	add_child(range_ring)

func _process(delta: float) -> void:
	if range_ring != null:
		range_ring.rotate_y(0.3 * delta)
