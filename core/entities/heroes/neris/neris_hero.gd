class_name NerisHero
extends HeroEntity

## Implementation of Neris (The Spatial Architect / INT Area Controller)

signal node_created(node_pos: Vector3, total_nodes: int)
signal wall_created(node_a: Vector3, node_b: Vector3)
signal pulse_triggered(hit_count: int, total_damage: float)
signal gate_created(gate_pos_a: Vector3, gate_pos_b: Vector3)
signal grand_design_executed(center_pos: Vector3, nodes_spawned: int)

# Active Arcane Nodes: [{pos: Vector3, timer: float}]
var active_nodes: Array[Dictionary] = []
const MAX_NODES: int = 6
const NODE_LIFETIME: float = 45.0

# Active Walls: [{pos_a: Vector3, pos_b: Vector3, timer: float, damage: float}]
var active_walls: Array[Dictionary] = []

# Active Gates: [{pos_a: Vector3, pos_b: Vector3, timer: float}]
var active_gates: Array[Dictionary] = []

func _ready() -> void:
	entity_name = "Neris"
	hero_resource = NerisDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_neris_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.50
		shape.height = 1.90
		col.shape = shape
		col.position.y = 0.95
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("NerisVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "NerisVisual"
		add_child(root_vis)
		
		# Arcane Robes Body (1.9m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.46
		body_capsule.height = 1.90
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.95
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.20, 0.45, 0.85, 1.0) # Arcane Sapphire Blue
		mat.roughness = 0.35
		body_inst.material_override = mat
		root_vis.add_child(body_inst)
		
		# Floating Geometric Crystals
		for i in range(3):
			var crystal = MeshInstance3D.new()
			var prism = BoxMesh.new()
			prism.size = Vector3(0.18, 0.35, 0.18)
			crystal.mesh = prism
			var angle = (float(i) / 3.0) * TAU
			crystal.position = Vector3(cos(angle) * 0.75, 1.4 + (sin(angle) * 0.2), sin(angle) * 0.75)
			
			var c_mat = StandardMaterial3D.new()
			c_mat.albedo_color = Color(0.40, 0.80, 1.0, 1.0)
			c_mat.emission_enabled = true
			c_mat.emission = Color(0.35, 0.85, 1.0, 1.0)
			c_mat.emission_energy_multiplier = 1.2
			crystal.material_override = c_mat
			root_vis.add_child(crystal)
			
		# Selection Base Ring
		var ring = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.85
		torus.outer_radius = 0.90
		ring.mesh = torus
		ring.position.y = 0.03
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var ring_color = Color(0.95, 0.3, 0.3, 0.85) if team == TeamDefinitions.Team.DIRE else Color(0.3, 0.7, 1.0, 0.85)
		ring_mat.albedo_color = ring_color
		ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		ring.material_override = ring_mat
		root_vis.add_child(ring)

func _apply_neris_definition() -> void:
	if hero_resource == null:
		hero_resource = NerisDefinition.create_resource()
		
	var def = hero_resource
	attribute_system.primary_attribute = def.primary_attribute
	attribute_system.base_strength = def.base_strength
	attribute_system.strength_growth = def.strength_growth
	attribute_system.base_agility = def.base_agility
	attribute_system.agility_growth = def.agility_growth
	attribute_system.base_intelligence = def.base_intelligence
	attribute_system.intelligence_growth = def.intelligence_growth
	
	attribute_system.base_health = def.base_health
	attribute_system.base_health_regen = def.base_health_regen
	attribute_system.base_mana = def.base_mana
	attribute_system.base_mana_regen = def.base_mana_regen
	attribute_system.base_attack_damage = def.base_attack_damage
	attribute_system.base_ability_power = def.base_ability_power
	attribute_system.base_armor = def.base_armor
	attribute_system.base_magic_resist = def.base_magic_resist
	attribute_system.base_attack_speed = def.base_attack_speed
	attribute_system.base_move_speed = def.base_move_speed
	attribute_system.base_attack_range = def.base_attack_range
	
	attribute_system.recalculate_all_stats()
	attribute_system.heal(attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
	attribute_system.restore_mana(attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA))
	
	# Assign abilities
	ability_container.set_ability(AbilityResource.Slot.PASSIVE, def.passive_ability)
	ability_container.set_ability(AbilityResource.Slot.Q, def.q_ability)
	ability_container.set_ability(AbilityResource.Slot.W, def.w_ability)
	ability_container.set_ability(AbilityResource.Slot.E, def.e_ability)
	ability_container.set_ability(AbilityResource.Slot.R, def.r_ability)

func _process(delta: float) -> void:
	super._process(delta)
	_process_nodes(delta)
	_process_walls(delta)
	_process_gates(delta)

# --- PASSIVE: ARCANE NODES ---

func spawn_node(pos: Vector3) -> void:
	if active_nodes.size() >= MAX_NODES:
		active_nodes.pop_front()
	active_nodes.append({"pos": pos, "timer": NODE_LIFETIME})
	node_created.emit(pos, active_nodes.size())

func get_node_count() -> int:
	return active_nodes.size()

func clear_all_nodes() -> void:
	active_nodes.clear()
	active_walls.clear()
	active_gates.clear()

func _process_nodes(delta: float) -> void:
	for i in range(active_nodes.size() - 1, -1, -1):
		active_nodes[i]["timer"] -= delta
		if active_nodes[i]["timer"] <= 0.0:
			active_nodes.remove_at(i)

# --- Q: WALL (RESONANCE WALL) ---

func cast_neris_q(pos_a: Vector3, pos_b: Vector3, targets: Array = []) -> bool:
	if not can_cast():
		return false
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast(AbilityResource.Slot.Q):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.Q):
		return false
		
	spawn_node(pos_a)
	spawn_node(pos_b)
	
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var dmg = base_dmg + (ap * q_res.scaling_ratio)
	
	active_walls.append({
		"pos_a": pos_a,
		"pos_b": pos_b,
		"timer": 4.0,
		"damage": dmg
	})
	
	# Damage and slow any enemy near the line
	_apply_wall_effects(pos_a, pos_b, dmg, targets)
	
	wall_created.emit(pos_a, pos_b)
	return true

func _apply_wall_effects(pos_a: Vector3, pos_b: Vector3, dmg: float, targets: Array = []) -> void:
	var enemies: Array = targets.duplicate()
	if enemies.is_empty():
		if is_inside_tree() and get_tree() != null:
			enemies = get_tree().get_nodes_in_group("combat_entities")
		else:
			enemies.append_array(HeroEntity.active_heroes)
			enemies.append_array(CreepEntity.active_creeps)
		
	for e in enemies:
		if e is BaseCombatEntity and is_instance_valid(e) and e != self and e.is_alive() and e.team != team and e.is_targetable:
			var e_pos = e.global_position if is_inside_tree() else e.position
			var dist = _distance_point_to_segment(e_pos, pos_a, pos_b)
			if dist <= 2.5:
				var req = DamageRequest.create_ability_damage(self, e, dmg, DamageRequest.DamageType.MAGICAL, "Resonance Wall")
				CombatCalculator.execute_damage(req)
				if e.effect_container != null:
					var slow_eff = StatusEffect.new("neris_wall_slow", StatusEffect.EffectType.SLOW, 2.0, 0.40)
					e.effect_container.apply_effect(slow_eff)

func _process_walls(delta: float) -> void:
	for i in range(active_walls.size() - 1, -1, -1):
		active_walls[i]["timer"] -= delta
		if active_walls[i]["timer"] <= 0.0:
			active_walls.remove_at(i)

# --- W: PULSE (ARCANE RESONANCE) ---

func cast_neris_w(targets: Array = []) -> int:
	if not can_cast():
		return 0
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return 0
		
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return 0
		
	var my_pos = global_position if is_inside_tree() else position
	spawn_node(my_pos)
	
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var base_dmg = w_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var pulse_dmg = base_dmg + (ap * w_res.scaling_ratio)
	
	var enemies: Array = targets.duplicate()
	if enemies.is_empty():
		if is_inside_tree() and get_tree() != null:
			enemies = get_tree().get_nodes_in_group("combat_entities")
		else:
			enemies.append_array(HeroEntity.active_heroes)
			enemies.append_array(CreepEntity.active_creeps)
		
	var hit_count = 0
	var total_dealt = 0.0
	
	for e in enemies:
		if e is BaseCombatEntity and is_instance_valid(e) and e != self and e.is_alive() and e.team != team and e.is_targetable:
			var e_pos = e.global_position if is_inside_tree() else e.position
			var node_hits = 0
			for node in active_nodes:
				if e_pos.distance_to(node["pos"]) <= 4.0:
					node_hits += 1
			if node_hits > 0:
				var mult = 1.0 + (float(node_hits - 1) * 0.50)
				var final_dmg = pulse_dmg * mult
				var req = DamageRequest.create_ability_damage(self, e, final_dmg, DamageRequest.DamageType.MAGICAL, "Arcane Pulse")
				var res = CombatCalculator.execute_damage(req)
				if res != null:
					hit_count += 1
					total_dealt += res.final_health_damage
					
	pulse_triggered.emit(hit_count, total_dealt)
	return hit_count

# --- E: GATE (SPATIAL BRIDGE) ---

func cast_neris_e(pos_a: Vector3, pos_b: Vector3) -> bool:
	if not can_cast():
		return false
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return false
		
	spawn_node(pos_a)
	spawn_node(pos_b)
	
	active_gates.append({
		"pos_a": pos_a,
		"pos_b": pos_b,
		"timer": 6.0
	})
	
	gate_created.emit(pos_a, pos_b)
	return true

func teleport_through_gate(ally: BaseCombatEntity, from_pos: Vector3) -> bool:
	if ally == null or not is_instance_valid(ally) or not ally.is_alive() or ally.team != team:
		return false
		
	for g in active_gates:
		if from_pos.distance_to(g["pos_a"]) <= 2.5:
			if ally.is_inside_tree():
				ally.global_position = g["pos_b"]
			else:
				ally.position = g["pos_b"]
			if ally.attribute_system != null:
				var mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.40, "neris_gate_ms")
				ally.attribute_system.add_modifier(mod)
			return true
		elif from_pos.distance_to(g["pos_b"]) <= 2.5:
			if ally.is_inside_tree():
				ally.global_position = g["pos_a"]
			else:
				ally.position = g["pos_a"]
			if ally.attribute_system != null:
				var mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.40, "neris_gate_ms")
				ally.attribute_system.add_modifier(mod)
			return true
			
	return false

func _process_gates(delta: float) -> void:
	for i in range(active_gates.size() - 1, -1, -1):
		active_gates[i]["timer"] -= delta
		if active_gates[i]["timer"] <= 0.0:
			active_gates.remove_at(i)

# --- R: GRAND DESIGN (MATRIX COLLAPSE - ULTIMATE) ---

func cast_neris_r(target_center: Vector3, targets: Array = []) -> Array[DamageResult]:
	if not can_cast():
		return []
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null:
		return []
		
	if ability_container.ability_levels.get(AbilityResource.Slot.R, 0) <= 0:
		ability_container.ability_levels[AbilityResource.Slot.R] = 1
		
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return []
		
	# Spawn 4 matrix nodes in tetrahedron layout around target center (radius 4.0m)
	var offsets = [
		Vector3(-3.0, 0, -3.0),
		Vector3(3.0, 0, -3.0),
		Vector3(3.0, 0, 3.0),
		Vector3(-3.0, 0, 3.0)
	]
	for off in offsets:
		spawn_node(target_center + off)
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var total_dmg = base_dmg + (ap * r_res.scaling_ratio)
	
	var enemies: Array = targets.duplicate()
	if enemies.is_empty():
		if is_inside_tree() and get_tree() != null:
			enemies = get_tree().get_nodes_in_group("combat_entities")
		else:
			enemies.append_array(HeroEntity.active_heroes)
			enemies.append_array(CreepEntity.active_creeps)
		
	var results: Array[DamageResult] = []
	for e in enemies:
		if e is BaseCombatEntity and is_instance_valid(e) and e != self and e.is_alive() and e.team != team and e.is_targetable:
			var e_pos = e.global_position if is_inside_tree() else e.position
			if target_center.distance_to(e_pos) <= 5.5:
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.MAGICAL, "Grand Design")
				var res = CombatCalculator.execute_damage(req)
				results.append(res)
				
				# Stun for 1.2s
				if e.effect_container != null:
					var stun_eff = StatusEffect.new("neris_matrix_stun", StatusEffect.EffectType.STUN, 1.2)
					e.effect_container.apply_effect(stun_eff)
					
	grand_design_executed.emit(target_center, 4)
	return results

# Helper: Distance from 2D/3D point to line segment
func _distance_point_to_segment(p: Vector3, a: Vector3, b: Vector3) -> float:
	var ab = b - a
	var ap = p - a
	var ab_len_sq = ab.length_squared()
	if ab_len_sq < 0.0001:
		return p.distance_to(a)
	var t = clampf(ap.dot(ab) / ab_len_sq, 0.0, 1.0)
	var proj = a + (ab * t)
	return p.distance_to(proj)

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	clear_all_nodes()

func respawn() -> void:
	super.respawn()
	clear_all_nodes()
