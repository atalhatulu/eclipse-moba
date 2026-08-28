class_name VeyraHero
extends HeroEntity

## Implementation of Veyra (The Kinetic Juggernaut / STR Diver)

signal momentum_updated(current_momentum: float, max_momentum: float)
signal shoulder_break_hit(target: BaseCombatEntity)
signal impact_zone_executed()
signal second_wind_activated()
signal crash_landing_executed(location: Vector3)

# Passive Momentum State
var stored_momentum: float = 0.0
const MAX_MOMENTUM: float = 100.0
var last_known_pos: Vector3 = Vector3.ZERO
var standstill_timer: float = 0.0
var prev_ms_bonus_percent: float = -1.0

# E: Second Wind State
var second_wind_timer: float = 0.0

func _ready() -> void:
	entity_name = "Veyra"
	hero_resource = VeyraDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_veyra_definition()
	last_known_pos = global_position if is_inside_tree() else position

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.60
		shape.height = 2.1
		col.shape = shape
		col.position.y = 1.05
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("VeyraVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "VeyraVisual"
		add_child(root_vis)
		
		# Streamlined Kinetic Armored Body (2.1m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.55
		body_capsule.height = 2.1
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.05
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.18, 0.22, 0.35, 1.0) # Cobalt Kinetic Steel
		body_mat.metallic = 0.85
		body_mat.roughness = 0.30
		body_mat.emission_enabled = true
		body_mat.emission = Color(0.2, 0.6, 1.0, 1.0)
		body_mat.emission_energy_multiplier = 0.8
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
		# Kinetic Thruster Pauldrons
		for side in [-0.65, 0.65]:
			var thruster = MeshInstance3D.new()
			var th_box = BoxMesh.new()
			th_box.size = Vector3(0.35, 0.40, 0.50)
			thruster.mesh = th_box
			thruster.position = Vector3(side, 1.65, -0.1)
			
			var th_mat = StandardMaterial3D.new()
			th_mat.albedo_color = Color(0.25, 0.35, 0.55, 1.0)
			th_mat.emission_enabled = true
			th_mat.emission = Color(0.3, 0.7, 1.0, 1.0)
			th_mat.emission_energy_multiplier = 1.2
			thruster.material_override = th_mat
			root_vis.add_child(thruster)
			
		# Selection Base Ring
		var ring = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.90
		torus.outer_radius = 0.95
		ring.mesh = torus
		ring.position.y = 0.03
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var ring_color = Color(0.95, 0.3, 0.3, 0.85) if team == TeamDefinitions.Team.DIRE else Color(0.92, 0.96, 1.0, 0.85)
		ring_mat.albedo_color = ring_color
		ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		ring.material_override = ring_mat
		root_vis.add_child(ring)

func _apply_veyra_definition() -> void:
	if hero_resource == null:
		hero_resource = VeyraDefinition.create_resource()
		
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
	
	_process_momentum_movement(delta)
	_process_second_wind(delta)

# --- PASSIVE: MOMENTUM SYSTEM ---

func get_momentum() -> float:
	return stored_momentum

func add_momentum(amount: float) -> void:
	if amount <= 0.0:
		return
	stored_momentum = clampf(stored_momentum + amount, 0.0, MAX_MOMENTUM)
	standstill_timer = 2.0
	_sync_momentum_speed_modifier()
	momentum_updated.emit(stored_momentum, MAX_MOMENTUM)

func consume_momentum(amount: float) -> float:
	var consumed = minf(stored_momentum, amount)
	stored_momentum = maxf(0.0, stored_momentum - consumed)
	_sync_momentum_speed_modifier()
	momentum_updated.emit(stored_momentum, MAX_MOMENTUM)
	return consumed

func reset_momentum() -> void:
	stored_momentum = 0.0
	standstill_timer = 0.0
	_sync_momentum_speed_modifier()
	momentum_updated.emit(0.0, MAX_MOMENTUM)

func _process_momentum_movement(delta: float) -> void:
	if not is_alive():
		return
		
	var cur_pos = global_position if is_inside_tree() else position
	var dist = cur_pos.distance_to(last_known_pos)
	last_known_pos = cur_pos
	
	# Valid movement step (ignore huge teleport glitches > 4.0m)
	if dist > 0.01 and dist <= 4.0:
		add_momentum(dist * 12.0)
	elif dist <= 0.01:
		if standstill_timer > 0.0:
			var elapsed_past = delta - standstill_timer
			standstill_timer -= delta
			if elapsed_past > 0.0 and stored_momentum > 0.0:
				stored_momentum = maxf(0.0, stored_momentum - (25.0 * elapsed_past))
				_sync_momentum_speed_modifier()
				momentum_updated.emit(stored_momentum, MAX_MOMENTUM)
		else:
			if stored_momentum > 0.0:
				stored_momentum = maxf(0.0, stored_momentum - (25.0 * delta))
				_sync_momentum_speed_modifier()
				momentum_updated.emit(stored_momentum, MAX_MOMENTUM)

func _sync_momentum_speed_modifier() -> void:
	if attribute_system == null:
		return
	var speed_pct = (stored_momentum / MAX_MOMENTUM) * 0.20 # Up to +20% Move Speed
	if absf(speed_pct - prev_ms_bonus_percent) > 0.005:
		prev_ms_bonus_percent = speed_pct
		attribute_system.remove_modifiers_by_source("veyra_momentum_speed")
		if speed_pct > 0.001:
			var mod = StatModifier.new(
				StatModifier.TargetStat.MOVE_SPEED,
				StatModifier.Type.PERCENT_ADD,
				speed_pct,
				"veyra_momentum_speed"
			)
			attribute_system.add_modifier(mod)

# --- E: SECOND WIND ---

func _trigger_second_wind() -> void:
	add_momentum(30.0)
	second_wind_timer = 3.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("veyra_second_wind")
		var mod = StatModifier.new(
			StatModifier.TargetStat.MOVE_SPEED,
			StatModifier.Type.PERCENT_ADD,
			0.30, # +30% Move Speed
			"veyra_second_wind"
		)
		attribute_system.add_modifier(mod)
	second_wind_activated.emit()

func _process_second_wind(delta: float) -> void:
	if second_wind_timer > 0.0:
		second_wind_timer -= delta
		if second_wind_timer <= 0.0:
			if attribute_system != null:
				attribute_system.remove_modifiers_by_source("veyra_second_wind")

func cast_veyra_e() -> bool:
	if not can_cast():
		return false
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return false
	_trigger_second_wind()
	return true

func execute_basic_attack(target: BaseCombatEntity) -> DamageResult:
	var res = super.execute_basic_attack(target)
	if res != null and target != null and is_instance_valid(target) and target is HeroEntity and target.team != team:
		_trigger_second_wind()
	return res

# --- Q: SHOULDER BREAK ---

func cast_veyra_q(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var consumed_mom = consume_momentum(stored_momentum * 0.50)
	var total_dmg = base_dmg + (ad * q_res.scaling_ratio) + (consumed_mom * 0.80)
	
	if not ability_container.cast_ability(AbilityResource.Slot.Q, target):
		return null
		
	# Dash towards target and knockback target
	var t_pos = target.global_position if (target.is_inside_tree() or target.global_position != Vector3.ZERO) else target.position
	var my_pos = global_position if (is_inside_tree() or global_position != Vector3.ZERO) else position
	var dir = (t_pos - my_pos).normalized()
	if dir.length_squared() > 0.001:
		var dash_dest = t_pos - (dir * 0.8)
		if is_inside_tree():
			global_position = dash_dest
		else:
			position = dash_dest
			
		var knock_dest = t_pos + (dir * 2.0)
		if target.is_inside_tree():
			target.global_position = knock_dest
		else:
			target.position = knock_dest
			
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Shoulder Break")
	var res = CombatCalculator.execute_damage(req)
	
	if target is HeroEntity:
		_trigger_second_wind()
		
	shoulder_break_hit.emit(target)
	return res

# --- W: IMPACT ZONE ---

func cast_veyra_w(nearby_targets: Array = []) -> Array[DamageResult]:
	if not can_cast():
		return []
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return []
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var base_dmg = w_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * w_res.scaling_ratio) + (stored_momentum * 0.50)
	
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return []
		
	var targets_to_hit = nearby_targets.duplicate()
	if targets_to_hit.is_empty():
		var all_nodes: Array = []
		if is_inside_tree() and get_tree() != null:
			all_nodes = get_tree().get_nodes_in_group("combat_entities")
		else:
			all_nodes.append_array(HeroEntity.active_heroes)
			all_nodes.append_array(CreepEntity.active_creeps)
			
		var my_pos = global_position if (is_inside_tree() or global_position != Vector3.ZERO) else position
		for n in all_nodes:
			if n is BaseCombatEntity and is_instance_valid(n) and n != self and n.is_alive() and n.team != team and n.is_targetable:
				var n_pos = n.global_position if (n.is_inside_tree() or n.global_position != Vector3.ZERO) else n.position
				if my_pos.distance_to(n_pos) <= 4.0 or my_pos.distance_to(n_pos) <= 400.0:
					targets_to_hit.append(n)
					
	var results: Array[DamageResult] = []
	for t in targets_to_hit:
		var req = DamageRequest.create_ability_damage(self, t, total_dmg, DamageRequest.DamageType.PHYSICAL, "Impact Zone")
		var res = CombatCalculator.execute_damage(req)
		results.append(res)
		
		# Apply 30% Slow for 2.0s
		if t.effect_container != null:
			var slow_eff = StatusEffect.new("veyra_impact_slow", StatusEffect.EffectType.SLOW, 2.0, 0.30)
			t.effect_container.apply_effect(slow_eff)
			
		if t is HeroEntity:
			_trigger_second_wind()
			
	impact_zone_executed.emit()
	return results

# --- R: CRASH LANDING (ULTIMATE) ---

func cast_veyra_r(target_location: Vector3, nearby_targets: Array = []) -> Array[DamageResult]:
	if not can_cast():
		return []
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast(AbilityResource.Slot.R):
		return []
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var consumed_mom = consume_momentum(stored_momentum)
	var total_dmg = base_dmg + (ad * r_res.scaling_ratio) + (consumed_mom * 1.50)
	
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return []
		
	# Leap/Jump to clamped target location (max 7.5m / 750 unit)
	var my_pos = global_position if (is_inside_tree() or global_position != Vector3.ZERO) else position
	var to_dest = target_location - my_pos
	var max_dist = 7.5 if to_dest.length() <= 100.0 else 750.0
	if to_dest.length() > max_dist:
		target_location = my_pos + (to_dest.normalized() * max_dist)
		
	if is_inside_tree():
		global_position = target_location
	else:
		position = target_location
		
	var targets_to_hit = nearby_targets.duplicate()
	if targets_to_hit.is_empty():
		var all_nodes: Array = []
		if is_inside_tree() and get_tree() != null:
			all_nodes = get_tree().get_nodes_in_group("combat_entities")
		else:
			all_nodes.append_array(HeroEntity.active_heroes)
			all_nodes.append_array(CreepEntity.active_creeps)
			
		for n in all_nodes:
			if n is BaseCombatEntity and is_instance_valid(n) and n != self and n.is_alive() and n.team != team and n.is_targetable:
				var n_pos = n.global_position if (n.is_inside_tree() or n.global_position != Vector3.ZERO) else n.position
				if target_location.distance_to(n_pos) <= 5.0 or target_location.distance_to(n_pos) <= 500.0:
					targets_to_hit.append(n)
					
	var results: Array[DamageResult] = []
	for t in targets_to_hit:
		var req = DamageRequest.create_ability_damage(self, t, total_dmg, DamageRequest.DamageType.PHYSICAL, "Crash Landing")
		var res = CombatCalculator.execute_damage(req)
		results.append(res)
		
		# Knock-up / Stun for 0.8s
		if t.effect_container != null:
			var stun_eff = StatusEffect.new("veyra_knockup_stun", StatusEffect.EffectType.STUN, 0.8)
			t.effect_container.apply_effect(stun_eff)
			
	crash_landing_executed.emit(target_location)
	return results

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	reset_momentum()
	second_wind_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("veyra_momentum_speed")
		attribute_system.remove_modifiers_by_source("veyra_second_wind")

func respawn() -> void:
	super.respawn()
	reset_momentum()
	second_wind_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("veyra_momentum_speed")
		attribute_system.remove_modifiers_by_source("veyra_second_wind")
