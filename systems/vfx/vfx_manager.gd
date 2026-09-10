class_name VFXManager
extends Node

## Centralized Modular VFX and Combat Particle Spawner for Eclipse Front
## Creates lightweight, zero-hitch visual feedback for hits, spells, tree chops, and heals.

static var _instance: VFXManager = null

static func get_instance() -> VFXManager:
	return _instance

func _ready() -> void:
	_instance = self
	_connect_game_events()

func _connect_game_events() -> void:
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		if not GameEvents.damage_dealt.is_connected(_on_damage_dealt):
			GameEvents.damage_dealt.connect(_on_damage_dealt)
		if not GameEvents.combat_healed.is_connected(_on_combat_healed):
			GameEvents.combat_healed.connect(_on_combat_healed)

func _on_damage_dealt(result: DamageResult, _attacker: Node, target: Node) -> void:
	if result == null or target == null or not (target is Node3D) or not target.is_inside_tree():
		return
	var pos = (target as Node3D).global_position + Vector3(0, 1.2, 0)
	var color = Color(1.0, 0.4, 0.1) if result.is_critical else Color(1.0, 0.85, 0.3)
	spawn_hit_spark(target.get_parent() if target.get_parent() != null else target, pos, color)

func _on_combat_healed(_source: Node, target: Node, amount: float, _source_name: String) -> void:
	if target == null or not (target is Node3D) or not target.is_inside_tree() or amount <= 0.1:
		return
	var pos = (target as Node3D).global_position + Vector3(0, 0.5, 0)
	spawn_heal_aura(target.get_parent() if target.get_parent() != null else target, pos)

# ==============================================================================
# PARAMETRIC PARTICLE SPAWNERS
# ==============================================================================

static func spawn_hit_spark(parent: Node, world_pos: Vector3, spark_color: Color = Color(1.0, 0.8, 0.2)) -> CPUParticles3D:
	if parent == null:
		return null
	var p = CPUParticles3D.new()
	p.name = "HitSparkVFX"
	p.emitting = false
	p.one_shot = true
	p.amount = 14
	p.lifetime = 0.35
	p.explosiveness = 0.95
	p.spread = 180.0
	p.initial_velocity_min = 2.5
	p.initial_velocity_max = 5.0
	p.scale_amount_min = 0.08
	p.scale_amount_max = 0.18
	p.color = spark_color
	
	var mat = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = spark_color
	mat.emission_enabled = true
	mat.emission = spark_color
	mat.emission_energy_multiplier = 2.0
	
	var mesh = BoxMesh.new()
	mesh.size = Vector3(0.12, 0.12, 0.12)
	mesh.material = mat
	p.mesh = mesh
	
	parent.add_child(p)
	_set_position(p, world_pos)
	if p.is_inside_tree():
		p.emitting = true
	
	_schedule_free(p, 0.5)
	return p

static func spawn_ground_blast(parent: Node, world_pos: Vector3, color: Color = Color(0.2, 0.6, 1.0), radius: float = 3.0) -> CPUParticles3D:
	if parent == null:
		return null
	var p = CPUParticles3D.new()
	p.name = "GroundBlastVFX"
	p.emitting = false
	p.one_shot = true
	p.amount = 22
	p.lifetime = 0.55
	p.explosiveness = 0.9
	p.emission_shape = CPUParticles3D.EMISSION_SHAPE_SPHERE
	p.emission_sphere_radius = radius * 0.4
	p.direction = Vector3(0, 1, 0)
	p.spread = 45.0
	p.initial_velocity_min = 3.0
	p.initial_velocity_max = 6.0
	p.scale_amount_min = 0.15
	p.scale_amount_max = 0.35
	p.color = color
	
	var mat = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = color
	mat.emission_enabled = true
	mat.emission = color
	mat.emission_energy_multiplier = 2.5
	
	var mesh = SphereMesh.new()
	mesh.radius = 0.15
	mesh.height = 0.30
	mesh.material = mat
	p.mesh = mesh
	
	parent.add_child(p)
	_set_position(p, world_pos + Vector3(0, 0.2, 0))
	if p.is_inside_tree():
		p.emitting = true
	
	_schedule_free(p, 0.75)
	return p

static func spawn_tree_splinters(parent: Node, world_pos: Vector3) -> CPUParticles3D:
	if parent == null:
		return null
	var p = CPUParticles3D.new()
	p.name = "TreeSplintersVFX"
	p.emitting = false
	p.one_shot = true
	p.amount = 20
	p.lifetime = 0.6
	p.explosiveness = 0.95
	p.direction = Vector3(0, 1, 0)
	p.spread = 75.0
	p.initial_velocity_min = 3.0
	p.initial_velocity_max = 6.5
	p.gravity = Vector3(0, -9.8, 0)
	p.scale_amount_min = 0.1
	p.scale_amount_max = 0.25
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.42, 0.28, 0.16) # Wood splinters
	mat.roughness = 0.9
	
	var mesh = BoxMesh.new()
	mesh.size = Vector3(0.18, 0.24, 0.08)
	mesh.material = mat
	p.mesh = mesh
	
	parent.add_child(p)
	_set_position(p, world_pos + Vector3(0, 1.2, 0))
	if p.is_inside_tree():
		p.emitting = true
	
	_schedule_free(p, 0.8)
	return p

static func spawn_heal_aura(parent: Node, world_pos: Vector3) -> CPUParticles3D:
	if parent == null:
		return null
	var p = CPUParticles3D.new()
	p.name = "HealAuraVFX"
	p.emitting = false
	p.one_shot = true
	p.amount = 16
	p.lifetime = 0.65
	p.explosiveness = 0.4
	p.emission_shape = CPUParticles3D.EMISSION_SHAPE_RING
	p.emission_ring_radius = 1.0
	p.emission_ring_inner_radius = 0.5
	p.direction = Vector3(0, 1, 0)
	p.spread = 15.0
	p.initial_velocity_min = 1.8
	p.initial_velocity_max = 3.2
	p.color = Color(0.2, 0.95, 0.4) # Emerald Heal
	
	var mat = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = Color(0.3, 1.0, 0.45)
	mat.emission_enabled = true
	mat.emission = Color(0.2, 1.0, 0.4)
	mat.emission_energy_multiplier = 1.8
	
	var mesh = SphereMesh.new()
	mesh.radius = 0.12
	mesh.height = 0.24
	mesh.material = mat
	p.mesh = mesh
	
	parent.add_child(p)
	_set_position(p, world_pos)
	if p.is_inside_tree():
		p.emitting = true
	
	_schedule_free(p, 0.9)
	return p

static func spawn_level_up(parent: Node, world_pos: Vector3) -> CPUParticles3D:
	if parent == null:
		return null
	var p = CPUParticles3D.new()
	p.name = "LevelUpVFX"
	p.emitting = false
	p.one_shot = true
	p.amount = 28
	p.lifetime = 0.9
	p.explosiveness = 0.7
	p.direction = Vector3(0, 1, 0)
	p.spread = 25.0
	p.initial_velocity_min = 4.0
	p.initial_velocity_max = 7.0
	p.gravity = Vector3(0, -2.0, 0)
	p.color = Color(1.0, 0.9, 0.3)
	
	var mat = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = Color(1.0, 0.9, 0.2)
	mat.emission_enabled = true
	mat.emission = Color(1.0, 0.85, 0.2)
	mat.emission_energy_multiplier = 3.0
	
	var mesh = BoxMesh.new()
	mesh.size = Vector3(0.15, 0.15, 0.15)
	mesh.material = mat
	p.mesh = mesh
	
	parent.add_child(p)
	_set_position(p, world_pos)
	if p.is_inside_tree():
		p.emitting = true
	
	_schedule_free(p, 1.2)
	return p

static func _schedule_free(node: Node, delay: float) -> void:
	if node == null:
		return
	if node.is_inside_tree():
		var tree = node.get_tree()
		if tree != null:
			var timer = tree.create_timer(delay)
			timer.timeout.connect(node.queue_free)

static func _set_position(node: Node3D, pos: Vector3) -> void:
	if node == null:
		return
	if node.is_inside_tree():
		node.global_position = pos
	else:
		node.position = pos
