class_name NerisArcanePylon3D
extends Node3D

## 3D Standing Arcane Pylon / Crystal Obelisk for Neris (Passive: Construct)

var lifetime: float = 45.0
var timer: float = 45.0
var crystal_mesh: MeshInstance3D = null
var base_pillar: MeshInstance3D = null

func _ready() -> void:
	_build_pylon()

func _build_pylon() -> void:
	# Base Stone Pillar (1.2m tall)
	base_pillar = MeshInstance3D.new()
	var cyl = CylinderMesh.new()
	cyl.top_radius = 0.25
	cyl.bottom_radius = 0.40
	cyl.height = 1.20
	base_pillar.mesh = cyl
	base_pillar.position.y = 0.60
	
	var stone_mat = StandardMaterial3D.new()
	stone_mat.albedo_color = Color(0.15, 0.18, 0.25, 1.0)
	stone_mat.metallic = 0.5
	stone_mat.roughness = 0.4
	base_pillar.material_override = stone_mat
	add_child(base_pillar)
	
	# Floating Arcane Sapphire Crystal (1.8m height)
	crystal_mesh = MeshInstance3D.new()
	var prism = BoxMesh.new()
	prism.size = Vector3(0.35, 0.75, 0.35)
	crystal_mesh.mesh = prism
	crystal_mesh.position.y = 1.70
	crystal_mesh.rotation.y = deg_to_rad(45.0)
	crystal_mesh.rotation.x = deg_to_rad(15.0)
	
	var crystal_mat = StandardMaterial3D.new()
	crystal_mat.albedo_color = Color(0.20, 0.65, 1.0, 0.9)
	crystal_mat.emission_enabled = true
	crystal_mat.emission = Color(0.30, 0.80, 1.0)
	crystal_mat.emission_energy_multiplier = 3.0
	crystal_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	crystal_mesh.material_override = crystal_mat
	add_child(crystal_mesh)
	
	# Ground Energy Beacon Ring
	var ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 0.70
	torus.outer_radius = 0.85
	ring.mesh = torus
	ring.position.y = 0.05
	
	var ring_mat = StandardMaterial3D.new()
	ring_mat.albedo_color = Color(0.25, 0.75, 1.0, 0.6)
	ring_mat.emission_enabled = true
	ring_mat.emission = Color(0.3, 0.8, 1.0)
	ring_mat.emission_energy_multiplier = 2.0
	ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring.material_override = ring_mat
	add_child(ring)

func _process(delta: float) -> void:
	timer -= delta
	if crystal_mesh != null:
		crystal_mesh.rotate_y(1.8 * delta)
		crystal_mesh.position.y = 1.70 + sin(Time.get_ticks_msec() * 0.003) * 0.12
		
	if timer <= 0.0:
		queue_free()

func pulse_energy() -> void:
	# Visual flare when W (Pulse) is triggered
	if crystal_mesh != null and crystal_mesh.material_override is StandardMaterial3D:
		var mat: StandardMaterial3D = crystal_mesh.material_override
		var tw = create_tween()
		if tw != null:
			tw.tween_property(mat, "emission_energy_multiplier", 8.0, 0.1)
			tw.tween_property(mat, "emission_energy_multiplier", 3.0, 0.3)
