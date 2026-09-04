class_name NerisWormholeGate3D
extends Node3D

## Interactive 3D Wormhole Gateways for Neris on E (Spatial Bridge)

var duration: float = 8.0
var timer: float = 8.0
var linked_gate: NerisWormholeGate3D = null
var ring_mesh: MeshInstance3D = null
var is_active: bool = true
var team: int = 0

func _ready() -> void:
	_build_portal()

func _build_portal() -> void:
	# Vertical Swirling Portal Ring (2.4m tall)
	ring_mesh = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 0.90
	torus.outer_radius = 1.15
	ring_mesh.mesh = torus
	ring_mesh.position.y = 1.30
	ring_mesh.rotation.x = deg_to_rad(90.0)
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.20, 0.85, 1.0, 0.85)
	mat.emission_enabled = true
	mat.emission = Color(0.30, 0.90, 1.0)
	mat.emission_energy_multiplier = 4.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring_mesh.material_override = mat
	add_child(ring_mesh)
	
	# Vortex Core
	var core = MeshInstance3D.new()
	var sphere = SphereMesh.new()
	sphere.radius = 0.80
	sphere.height = 1.60
	core.mesh = sphere
	core.position.y = 1.30
	core.scale = Vector3(1.0, 1.0, 0.1)
	
	var core_mat = StandardMaterial3D.new()
	core_mat.albedo_color = Color(0.1, 0.5, 0.9, 0.6)
	core_mat.emission_enabled = true
	core_mat.emission = Color(0.2, 0.7, 1.0)
	core_mat.emission_energy_multiplier = 2.0
	core_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	core.material_override = core_mat
	add_child(core)

func _process(delta: float) -> void:
	timer -= delta
	if ring_mesh != null:
		ring_mesh.rotate_z(2.5 * delta)
		
	_check_teleport()
	
	if timer <= 0.0:
		queue_free()

func _check_teleport() -> void:
	if not is_active or linked_gate == null or not is_instance_valid(linked_gate):
		return
		
	var my_pos = global_position if is_inside_tree() else position
	for h in HeroEntity.active_heroes:
		if is_instance_valid(h) and h.is_alive() and h.team == team:
			var h_pos = h.global_position if h.is_inside_tree() else h.position
			if my_pos.distance_to(h_pos) <= 1.5:
				_teleport_hero(h)
				break

func _teleport_hero(h: HeroEntity) -> void:
	if linked_gate == null or not is_instance_valid(linked_gate):
		return
		
	var dest_pos = linked_gate.global_position if linked_gate.is_inside_tree() else linked_gate.position
	dest_pos.y = h.position.y
	
	if h.is_inside_tree():
		h.global_position = dest_pos
	else:
		h.position = dest_pos
		
	if h.attribute_system != null:
		h.attribute_system.remove_modifiers_by_source("neris_gate_boost")
		var mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.40, "neris_gate_boost", 3.0)
		h.attribute_system.add_modifier(mod)
		
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("%s UZAMSAL GEÇİTTEN IŞINLANDI! (+%%40 Hız)" % h.hero_name)
		
	# Brief teleport cooldown to prevent infinite loop
	is_active = false
	linked_gate.is_active = false
	var tw = create_tween()
	if tw != null:
		tw.tween_interval(1.5)
		tw.tween_callback(func():
			is_active = true
			if linked_gate != null and is_instance_valid(linked_gate):
				linked_gate.is_active = true
		)
