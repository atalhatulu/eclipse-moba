class_name SerisRazorMine3D
extends Node3D

## 3D Armed Razor Landmine placed in terrain on W (Razor Trap)

var lifetime: float = 60.0
var timer: float = 60.0
var mine_mesh: MeshInstance3D = null
var pulse_ring: MeshInstance3D = null
var is_armed: bool = true

func _ready() -> void:
	_build_mine()

func _build_mine() -> void:
	# Steel Spiked Base (0.6m diameter)
	mine_mesh = MeshInstance3D.new()
	var cyl = CylinderMesh.new()
	cyl.top_radius = 0.30
	cyl.bottom_radius = 0.40
	cyl.height = 0.15
	mine_mesh.mesh = cyl
	mine_mesh.position.y = 0.08
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.18, 0.22, 0.20, 1.0)
	mat.metallic = 0.85
	mat.roughness = 0.40
	mine_mesh.material_override = mat
	add_child(mine_mesh)
	
	# Emerald Laser Sensor Core
	pulse_ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 0.25
	torus.outer_radius = 0.32
	pulse_ring.mesh = torus
	pulse_ring.position.y = 0.16
	
	var p_mat = StandardMaterial3D.new()
	p_mat.albedo_color = Color(0.15, 0.90, 0.60, 0.85)
	p_mat.emission_enabled = true
	p_mat.emission = Color(0.20, 0.95, 0.65)
	p_mat.emission_energy_multiplier = 2.5
	p_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	pulse_ring.material_override = p_mat
	add_child(pulse_ring)

func _process(delta: float) -> void:
	timer -= delta
	if pulse_ring != null:
		var pulse = (sin(Time.get_ticks_msec() * 0.005) + 1.0) * 0.5
		pulse_ring.scale = Vector3(1.0 + pulse * 0.15, 1.0, 1.0 + pulse * 0.15)
		
	if timer <= 0.0:
		queue_free()

func detonate() -> void:
	if not is_armed:
		return
	is_armed = false
	var exp_script = load("res://scenes/effects/seris_trap_explosion_3d.gd")
	if exp_script != null and is_inside_tree():
		var exp_inst = exp_script.new()
		get_tree().root.add_child(exp_inst)
		exp_inst.global_position = global_position
	queue_free()
