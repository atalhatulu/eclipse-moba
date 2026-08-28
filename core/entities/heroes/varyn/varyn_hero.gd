class_name VarynHero
extends HeroEntity

## Implementation of Varyn (The Tempest Skirmisher / AGI Mobile Fighter)

signal flow_updated(current_flow: float, bonus_ad: float, bonus_ms: float)
signal razor_leap_struck(target: BaseCombatEntity, damage_dealt: float)
signal spin_cut_executed(hits: int, total_damage: float)
signal rebound_executed(is_free_charge: bool)
signal endless_motion_activated()
signal endless_motion_ended()

# Passive Flow State
var flow: float = 0.0
const MAX_FLOW: float = 100.0

# E: Rebound State
var has_rebound_free_charge: bool = false
var recent_hit_timer: float = 0.0

# R: Endless Motion State
var is_endless_motion_active: bool = false
var endless_motion_timer: float = 0.0

func _ready() -> void:
	entity_name = "Varyn"
	hero_resource = VarynDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_varyn_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.52
		shape.height = 1.95
		col.shape = shape
		col.position.y = 0.98
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("VarynVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "VarynVisual"
		add_child(root_vis)
		
		# Wind-Cloaked Agile Body (1.95m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.48
		body_capsule.height = 1.95
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.98
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.15, 0.75, 0.65, 1.0) # Tempest Jade & Platinum
		body_mat.metallic = 0.70
		body_mat.roughness = 0.30
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
		# Curved Crescent Claws Mesh
		for side in [-0.50, 0.50]:
			var claw = MeshInstance3D.new()
			var c_box = BoxMesh.new()
			c_box.size = Vector3(0.12, 0.90, 0.20)
			claw.mesh = c_box
			claw.position = Vector3(side, 0.85, 0.35)
			claw.rotation_degrees = Vector3(25, 0, 0)
			
			var c_mat = StandardMaterial3D.new()
			c_mat.albedo_color = Color(0.40, 0.95, 0.85, 1.0)
			c_mat.emission_enabled = true
			c_mat.emission = Color(0.3, 0.9, 0.8, 1.0)
			c_mat.emission_energy_multiplier = 0.8
			claw.material_override = c_mat
			root_vis.add_child(claw)
			
		# Selection Base Ring
		var ring = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.85
		torus.outer_radius = 0.90
		ring.mesh = torus
		ring.position.y = 0.03
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var ring_color = Color(0.95, 0.3, 0.3, 0.85) if team == TeamDefinitions.Team.DIRE else Color(0.92, 0.96, 1.0, 0.85)
		ring_mat.albedo_color = ring_color
		ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		ring.material_override = ring_mat
		root_vis.add_child(ring)

func _apply_varyn_definition() -> void:
	if hero_resource == null:
		hero_resource = VarynDefinition.create_resource()
		
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
	
	_process_recent_hit(delta)
	_process_endless_motion(delta)

# --- PASSIVE: FLOW ---

func add_flow(amount: float) -> void:
	if amount <= 0.0:
		return
	var mult = 2.0 if is_endless_motion_active else 1.0
	flow = clampf(flow + (amount * mult), 0.0, MAX_FLOW)
	_sync_flow_buffs()

func _sync_flow_buffs() -> void:
	if attribute_system == null:
		return
		
	var bonus_ad = (flow / 10.0) * 3.0
	var bonus_ms = (flow / 100.0) * 0.10
	
	attribute_system.remove_modifiers_by_source("varyn_flow_ad")
	attribute_system.remove_modifiers_by_source("varyn_flow_ms")
	
	if bonus_ad > 0.1:
		attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ATTACK_DAMAGE, StatModifier.Type.FLAT, bonus_ad, "varyn_flow_ad"))
	if bonus_ms > 0.005:
		attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, bonus_ms, "varyn_flow_ms"))
		
	flow_updated.emit(flow, bonus_ad, bonus_ms)

func _process_recent_hit(delta: float) -> void:
	if recent_hit_timer > 0.0:
		recent_hit_timer -= delta

# --- Q: RAZOR LEAP ---

func cast_varyn_q(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * q_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.Q, target):
		return null
		
	# Dash to target position
	var t_pos = target.global_position if is_inside_tree() else target.position
	if is_inside_tree():
		global_position = t_pos + Vector3(0.5, 0, 0.5)
	else:
		position = t_pos + Vector3(0.5, 0, 0.5)
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Razor Leap")
	var res = CombatCalculator.execute_damage(req)
	
	add_flow(20.0)
	recent_hit_timer = 3.0
	
	if is_endless_motion_active:
		ability_container.cooldown_timers[AbilityResource.Slot.Q] = 0.0
		
	razor_leap_struck.emit(target, total_dmg)
	return res

# --- W: SPIN CUT ---

func cast_varyn_w(enemies_in_range: Array = []) -> int:
	if not can_cast():
		return 0
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return 0
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var base_dmg = w_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * w_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return 0
		
	var targets = enemies_in_range.duplicate()
	if targets.is_empty():
		var all_nodes: Array = []
		if is_inside_tree() and get_tree() != null:
			all_nodes = get_tree().get_nodes_in_group("combat_entities")
		else:
			all_nodes.append_array(HeroEntity.active_heroes)
			
		var my_pos = global_position if is_inside_tree() else position
		for n in all_nodes:
			if n is BaseCombatEntity and is_instance_valid(n) and n.is_alive() and n.team != team:
				var n_pos = n.global_position if is_inside_tree() else n.position
				if my_pos.distance_to(n_pos) <= 3.5 or my_pos.distance_to(n_pos) <= 350.0:
					targets.append(n)
					
	var hits = 0
	for enemy in targets:
		if enemy is BaseCombatEntity and enemy.is_alive() and enemy.team != team:
			var req = DamageRequest.create_ability_damage(self, enemy, total_dmg, DamageRequest.DamageType.PHYSICAL, "Spin Cut")
			CombatCalculator.execute_damage(req)
			hits += 1
			
	if hits > 0:
		add_flow(15.0 * hits)
		recent_hit_timer = 3.0
		if is_endless_motion_active:
			ability_container.cooldown_timers[AbilityResource.Slot.Q] = 0.0
			
	spin_cut_executed.emit(hits, total_dmg * hits)
	return hits

# --- E: REBOUND ---

func cast_varyn_e() -> bool:
	if not can_cast():
		return false
		
	if has_rebound_free_charge:
		# Free charge consumption
		has_rebound_free_charge = false
		_perform_rebound_dash()
		rebound_executed.emit(true)
		return true
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return false
		
	_perform_rebound_dash()
	add_flow(10.0)
	
	if recent_hit_timer > 0.0:
		has_rebound_free_charge = true
		
	rebound_executed.emit(false)
	return true

func _perform_rebound_dash() -> void:
	var forward_dir = -transform.basis.z.normalized() if is_inside_tree() else Vector3(1, 0, 0)
	if forward_dir.length_squared() < 0.1:
		forward_dir = Vector3(1, 0, 0)
	if is_inside_tree():
		global_position += forward_dir * 4.0
	else:
		position += forward_dir * 4.0

# --- R: ENDLESS MOTION (ULTIMATE) ---

func cast_varyn_r() -> bool:
	if not can_cast():
		return false
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast(AbilityResource.Slot.R):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return false
		
	is_endless_motion_active = true
	endless_motion_timer = 6.0
	
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("varyn_endless_motion_ms")
		var mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.25, "varyn_endless_motion_ms")
		attribute_system.add_modifier(mod)
		
	endless_motion_activated.emit()
	return true

func _process_endless_motion(delta: float) -> void:
	if is_endless_motion_active:
		endless_motion_timer -= delta
		if endless_motion_timer <= 0.0:
			is_endless_motion_active = false
			endless_motion_timer = 0.0
			if attribute_system != null:
				attribute_system.remove_modifiers_by_source("varyn_endless_motion_ms")
			endless_motion_ended.emit()

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	flow = 0.0
	has_rebound_free_charge = false
	recent_hit_timer = 0.0
	is_endless_motion_active = false
	endless_motion_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("varyn_flow_ad")
		attribute_system.remove_modifiers_by_source("varyn_flow_ms")
		attribute_system.remove_modifiers_by_source("varyn_endless_motion_ms")

func respawn() -> void:
	super.respawn()
	flow = 0.0
	has_rebound_free_charge = false
	recent_hit_timer = 0.0
	is_endless_motion_active = false
	endless_motion_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("varyn_flow_ad")
		attribute_system.remove_modifiers_by_source("varyn_flow_ms")
		attribute_system.remove_modifiers_by_source("varyn_endless_motion_ms")
