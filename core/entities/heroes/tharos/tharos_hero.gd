class_name TharosHero
extends HeroEntity

## Implementation of Tharos (The Living Colossus / STR Juggernaut)

const TharosDefinition = preload("res://data/heroes/tharos_definition.gd")

signal bulkhead_activated()
signal bulkhead_ended()
signal colossus_activated()
signal colossus_ended()
signal living_mass_updated(bonus_hp: float, bonus_ad: float)

# Passive: Living Mass
const BONUS_HP_TO_AD_RATIO: float = 0.025 # 2.5% Bonus HP -> AD
var current_living_mass_ad: float = 0.0
var base_hp_threshold: float = 640.0

# W: Bulkhead state
var is_bulkhead_active: bool = false
var bulkhead_timer: float = 0.0
const BULKHEAD_DAMAGE_REDUCTION: float = 0.35 # 35% damage reduction

# R: Colossus state
var is_colossus_active: bool = false
var colossus_timer: float = 0.0

func _ready() -> void:
	entity_name = "Tharos"
	hero_resource = TharosDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_tharos_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.70
		shape.height = 2.3
		col.shape = shape
		col.position.y = 1.15
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("TharosVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "TharosVisual"
		add_child(root_vis)
		
		# Massive Juggernaut Body (2.3m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.65
		body_capsule.height = 2.3
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.15
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.28, 0.22, 0.16, 1.0) # Heavy Brown/Bronze Stone
		body_mat.metallic = 0.60
		body_mat.roughness = 0.65
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
		# Selection Base Ring
		var ring = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.95
		torus.outer_radius = 1.02
		ring.mesh = torus
		ring.position.y = 0.03
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var ring_color = Color(0.95, 0.3, 0.3, 0.85) if team == TeamDefinitions.Team.DIRE else Color(0.92, 0.96, 1.0, 0.85)
		ring_mat.albedo_color = ring_color
		ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		ring.material_override = ring_mat
		root_vis.add_child(ring)

func _apply_tharos_definition() -> void:
	if hero_resource == null:
		hero_resource = TharosDefinition.create_resource()
		
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
	
	base_hp_threshold = attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	
	# Assign abilities
	ability_container.set_ability(AbilityResource.Slot.PASSIVE, def.passive_ability)
	ability_container.set_ability(AbilityResource.Slot.Q, def.q_ability)
	ability_container.set_ability(AbilityResource.Slot.W, def.w_ability)
	ability_container.set_ability(AbilityResource.Slot.E, def.e_ability)
	ability_container.set_ability(AbilityResource.Slot.R, def.r_ability)
	
	_update_living_mass()

func _process(delta: float) -> void:
	super._process(delta)
	
	# Process Bulkhead timer
	if is_bulkhead_active:
		bulkhead_timer -= delta
		if bulkhead_timer <= 0.0:
			_end_bulkhead()
			
	# Process Colossus timer
	if is_colossus_active:
		colossus_timer -= delta
		if colossus_timer <= 0.0:
			_end_colossus()
			
	_update_living_mass()

# --- PASSIVE: LIVING MASS ---

func _update_living_mass() -> void:
	if attribute_system == null:
		return
		
	var cur_max_hp = attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	# Bonus HP is health beyond the base initial level-1 health
	var bonus_hp = maxf(0.0, cur_max_hp - base_hp_threshold)
	var target_ad = bonus_hp * BONUS_HP_TO_AD_RATIO
	
	if absf(current_living_mass_ad - target_ad) > 0.01:
		current_living_mass_ad = target_ad
		attribute_system.remove_modifiers_by_source("tharos_living_mass")
		if current_living_mass_ad > 0.0:
			var mod = StatModifier.new(
				StatModifier.TargetStat.ATTACK_DAMAGE,
				StatModifier.Type.FLAT,
				current_living_mass_ad,
				"tharos_living_mass"
			)
			attribute_system.add_modifier(mod)
		living_mass_updated.emit(bonus_hp, current_living_mass_ad)

# --- DAMAGE RECEIVING & BULKHEAD MITIGATION ---

func receive_damage(request: DamageRequest) -> DamageResult:
	if not is_alive() or request == null:
		return null
		
	if is_bulkhead_active and request.damage_type != DamageRequest.DamageType.TRUE_DAMAGE:
		request.base_damage = maxf(0.0, request.base_damage * (1.0 - BULKHEAD_DAMAGE_REDUCTION))
		
	return super.receive_damage(request)

# --- ABILITY IMPLEMENTATIONS ---

func cast_tharos_q(specific_targets: Array = []) -> Array[DamageResult]:
	if not can_cast():
		return []
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast(AbilityResource.Slot.Q):
		return []
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * q_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.Q):
		return []
		
	var my_pos = global_position if (is_inside_tree() or global_position != Vector3.ZERO) else position
	var targets_to_hit = specific_targets.duplicate()
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
				if my_pos.distance_to(n_pos) <= 4.0 or my_pos.distance_to(n_pos) <= 400.0:
					targets_to_hit.append(n)
					
	# Calculate missing health scaling stun duration (0.75s to 1.75s)
	var cur_hp = attribute_system.current_health
	var max_hp = attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	var hp_ratio = clampf(cur_hp / maxf(1.0, max_hp), 0.0, 1.0)
	var stun_duration = 0.75 + ((1.0 - hp_ratio) * 1.0)
	
	var results: Array[DamageResult] = []
	for t in targets_to_hit:
		if t != null and is_instance_valid(t) and t.is_alive() and t.team != team:
			var req = DamageRequest.create_ability_damage(self, t, total_dmg, DamageRequest.DamageType.PHYSICAL, "Groundbreaker")
			var res = CombatCalculator.execute_damage(req)
			results.append(res)
			
			if t.effect_container != null:
				var stun_eff = StatusEffect.new("tharos_groundbreaker_stun", StatusEffect.EffectType.STUN, stun_duration, 0.0, true)
				t.effect_container.apply_effect(stun_eff)
				
	return results

func cast_tharos_w() -> bool:
	if not can_cast():
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	is_bulkhead_active = true
	bulkhead_timer = 4.0
	
	# Apply -20% Move Speed self-slow
	attribute_system.remove_modifiers_by_source("tharos_bulkhead_slow")
	var slow_mod = StatModifier.new(
		StatModifier.TargetStat.MOVE_SPEED,
		StatModifier.Type.PERCENT_ADD,
		-0.20,
		"tharos_bulkhead_slow"
	)
	attribute_system.add_modifier(slow_mod)
	
	bulkhead_activated.emit()
	return true

func _end_bulkhead() -> void:
	is_bulkhead_active = false
	bulkhead_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("tharos_bulkhead_slow")
	bulkhead_ended.emit()

func cast_tharos_e(target_pos: Vector3, specific_targets: Array = []) -> Array[DamageResult]:
	if not can_cast():
		return []
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return []
		
	var my_pos = global_position if (is_inside_tree() or global_position != Vector3.ZERO) else position
	var dist = my_pos.distance_to(target_pos)
	if dist > (e_res.cast_range + 50.0):
		# Clamp to max range
		var dir = (target_pos - my_pos).normalized()
		target_pos = my_pos + (dir * e_res.cast_range)
		
	if not ability_container.cast_ability(AbilityResource.Slot.E, null, target_pos):
		return []
		
	# Move/Dash Tharos to target location
	if is_inside_tree():
		global_position = target_pos
	else:
		position = target_pos
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var base_dmg = e_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * e_res.scaling_ratio)
	
	var targets_to_hit = specific_targets.duplicate()
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
				if target_pos.distance_to(n_pos) <= 3.8 or target_pos.distance_to(n_pos) <= 380.0:
					targets_to_hit.append(n)
					
	var results: Array[DamageResult] = []
	for t in targets_to_hit:
		if t != null and is_instance_valid(t) and t.is_alive() and t.team != team:
			var req = DamageRequest.create_ability_damage(self, t, total_dmg, DamageRequest.DamageType.PHYSICAL, "Crushing Step")
			var res = CombatCalculator.execute_damage(req)
			results.append(res)
			
			if t.effect_container != null:
				var slow_eff = StatusEffect.new("tharos_crushing_slow", StatusEffect.EffectType.SLOW, e_res.effect_duration, e_res.effect_intensity)
				t.effect_container.apply_effect(slow_eff)
				
	return results

func cast_tharos_r() -> bool:
	if not can_cast():
		return false
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast(AbilityResource.Slot.R):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var hp_bonuses = [500.0, 800.0, 1100.0]
	var bonus_hp = hp_bonuses[clamp(lvl - 1, 0, 2)]
	
	is_colossus_active = true
	colossus_timer = 10.0
	
	# Apply Colossus modifiers: +Max HP, +Attack Range, -15% Move Speed
	attribute_system.remove_modifiers_by_source("tharos_colossus_hp")
	attribute_system.remove_modifiers_by_source("tharos_colossus_range")
	attribute_system.remove_modifiers_by_source("tharos_colossus_slow")
	
	var hp_mod = StatModifier.new(StatModifier.TargetStat.MAX_HEALTH, StatModifier.Type.FLAT, bonus_hp, "tharos_colossus_hp")
	var range_mod = StatModifier.new(StatModifier.TargetStat.ATTACK_RANGE, StatModifier.Type.FLAT, 75.0, "tharos_colossus_range")
	var slow_mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, -0.15, "tharos_colossus_slow")
	
	attribute_system.add_modifier(hp_mod)
	attribute_system.add_modifier(range_mod)
	attribute_system.add_modifier(slow_mod)
	attribute_system.heal(bonus_hp)
	
	_update_living_mass()
	colossus_activated.emit()
	return true

func _end_colossus() -> void:
	is_colossus_active = false
	colossus_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("tharos_colossus_hp")
		attribute_system.remove_modifiers_by_source("tharos_colossus_range")
		attribute_system.remove_modifiers_by_source("tharos_colossus_slow")
		_update_living_mass()
	colossus_ended.emit()

# --- DEATH & RESPAWN OVERRIDES ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	_end_bulkhead()
	_end_colossus()

func respawn() -> void:
	super.respawn()
	is_bulkhead_active = false
	bulkhead_timer = 0.0
	is_colossus_active = false
	colossus_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("tharos_bulkhead_slow")
		attribute_system.remove_modifiers_by_source("tharos_colossus_hp")
		attribute_system.remove_modifiers_by_source("tharos_colossus_range")
		attribute_system.remove_modifiers_by_source("tharos_colossus_slow")
		attribute_system.heal(attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
		_update_living_mass()
