class_name ZyraenHero
extends HeroEntity

## Implementation of Zyraen (The Equilibrium Mystic / STR-INT Dual Resource Controller)

signal equilibrium_changed(is_active: bool)
signal resources_exchanged(hp_change: float, mana_change: float)
signal perfect_balance_achieved(shield_applied: float, damage_dealt: float)

var is_equilibrium_active: bool = false
var forced_equilibrium_timer: float = 0.0

func _ready() -> void:
	entity_name = "Zyraen"
	hero_resource = ZyraenDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_zyraen_definition()

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
	if not has_node("ZyraenVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "ZyraenVisual"
		add_child(root_vis)
		
		# Dual Mystic Balanced Body (1.95m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.48
		body_capsule.height = 1.95
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.98
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.4, 0.45, 0.55, 1.0) # Yin-Yang Platinum Slate
		mat.metallic = 0.5
		mat.roughness = 0.3
		body_inst.material_override = mat
		root_vis.add_child(body_inst)
		
		# Dual Harmonic Balance Orbs (Red & Blue)
		var orb_left = MeshInstance3D.new()
		var s_mesh = SphereMesh.new()
		s_mesh.radius = 0.18
		s_mesh.height = 0.36
		orb_left.mesh = s_mesh
		orb_left.position = Vector3(-0.5, 1.5, 0.2)
		var left_mat = StandardMaterial3D.new()
		left_mat.albedo_color = Color(0.9, 0.25, 0.25, 1.0) # Crimson Life
		left_mat.emission_enabled = true
		left_mat.emission = Color(0.9, 0.25, 0.25)
		orb_left.material_override = left_mat
		root_vis.add_child(orb_left)
		
		var orb_right = MeshInstance3D.new()
		orb_right.mesh = s_mesh
		orb_right.position = Vector3(0.5, 1.5, 0.2)
		var right_mat = StandardMaterial3D.new()
		right_mat.albedo_color = Color(0.25, 0.45, 0.95, 1.0) # Azure Mana
		right_mat.emission_enabled = true
		right_mat.emission = Color(0.25, 0.45, 0.95)
		orb_right.material_override = right_mat
		root_vis.add_child(orb_right)

func _apply_zyraen_definition() -> void:
	if hero_resource == null:
		hero_resource = ZyraenDefinition.create_resource()
		
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
	
	ability_container.set_ability(AbilityResource.Slot.PASSIVE, def.passive_ability)
	ability_container.set_ability(AbilityResource.Slot.Q, def.q_ability)
	ability_container.set_ability(AbilityResource.Slot.W, def.w_ability)
	ability_container.set_ability(AbilityResource.Slot.E, def.e_ability)
	ability_container.set_ability(AbilityResource.Slot.R, def.r_ability)

func _process(delta: float) -> void:
	super._process(delta)
	_update_equilibrium(delta)

# --- PASSIVE: EQUILIBRIUM STATE CHECK ---

func is_in_equilibrium() -> bool:
	return is_equilibrium_active or forced_equilibrium_timer > 0.0

func _update_equilibrium(delta: float) -> void:
	if forced_equilibrium_timer > 0.0:
		forced_equilibrium_timer -= delta
		
	if attribute_system == null or not is_alive():
		return
		
	var max_hp = attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	var max_mp = attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
	if max_hp <= 0.0 or max_mp <= 0.0:
		return
		
	var hp_ratio = attribute_system.current_health / max_hp
	var mp_ratio = attribute_system.current_mana / max_mp
	var diff = absf(hp_ratio - mp_ratio)
	
	var active_now = (diff <= 0.10) or (forced_equilibrium_timer > 0.0)
	if active_now != is_equilibrium_active:
		is_equilibrium_active = active_now
		_sync_equilibrium_buffs()
		equilibrium_changed.emit(is_equilibrium_active)

func _sync_equilibrium_buffs() -> void:
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("zyraen_equilibrium_buff")
		if is_in_equilibrium():
			var ap_mod = StatModifier.new(StatModifier.TargetStat.ABILITY_POWER, StatModifier.Type.FLAT, 35.0, "zyraen_equilibrium_buff")
			var dr_mod = StatModifier.new(StatModifier.TargetStat.DAMAGE_REDUCTION, StatModifier.Type.FLAT, 0.15, "zyraen_equilibrium_buff")
			attribute_system.add_modifier(ap_mod)
			attribute_system.add_modifier(dr_mod)

# --- Q: LIFE SPARK ---

func cast_zyraen_q(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or target.team == team:
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast(AbilityResource.Slot.Q):
		return null
		
	if not ability_container.cast_ability(AbilityResource.Slot.Q):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var total_dmg = base_dmg + (ap * q_res.scaling_ratio)
	
	# Equilibrium Bonus: +10% current target HP as extra damage
	if is_in_equilibrium() and target.attribute_system != null:
		total_dmg += target.attribute_system.current_health * 0.10
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.MAGICAL, "Life Spark")
	return CombatCalculator.execute_damage(req)

# --- W: MANA SIPHON ---

func cast_zyraen_w(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or target.team == team:
		return null
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return null
		
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var drain_amount = w_res.get_base_damage(lvl) + (attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) * w_res.scaling_ratio)
	
	# Drain mana from target
	if target.attribute_system != null:
		target.attribute_system.spend_mana(drain_amount)
		
	# Restore Zyraen HP
	var heal_amt = drain_amount * 1.20
	attribute_system.heal(heal_amt)
	
	var req = DamageRequest.create_ability_damage(self, target, drain_amount * 0.50, DamageRequest.DamageType.MAGICAL, "Mana Siphon")
	return CombatCalculator.execute_damage(req)

# --- E: EXCHANGE (RESOURCE TRANSMUTATION) ---

func cast_zyraen_e() -> bool:
	if not can_cast():
		return false
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var pool_amt = e_res.get_base_damage(lvl)
	
	var max_hp = attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	var max_mp = attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
	var hp_ratio = attribute_system.current_health / max_hp
	var mp_ratio = attribute_system.current_mana / max_mp
	
	if hp_ratio >= mp_ratio:
		# Convert HP to Mana
		attribute_system.apply_damage_to_health(pool_amt, "zyraen_exchange")
		attribute_system.restore_mana(pool_amt * 1.25)
		resources_exchanged.emit(-pool_amt, pool_amt * 1.25)
	else:
		# Convert Mana to HP
		attribute_system.spend_mana(pool_amt)
		attribute_system.heal(pool_amt * 1.25)
		resources_exchanged.emit(pool_amt * 1.25, -pool_amt)
		
	_update_equilibrium(0.0)
	return true

# --- R: PERFECT BALANCE (DUAL HARMONIC SURGE - ULTIMATE) ---

func cast_zyraen_r(enemies: Array = []) -> DamageResult:
	if not can_cast():
		return null
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null:
		return null
		
	if ability_container.ability_levels.get(AbilityResource.Slot.R, 0) <= 0:
		ability_container.ability_levels[AbilityResource.Slot.R] = 1
		
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return null
		
	# Equalize HP% and Mana% to average
	var max_hp = attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	var max_mp = attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
	var avg_ratio = ((attribute_system.current_health / max_hp) + (attribute_system.current_mana / max_mp)) * 0.50
	
	attribute_system.current_health = max_hp * avg_ratio
	attribute_system.current_mana = max_mp * avg_ratio
	
	# Apply 400 HP Shield
	if effect_container != null:
		var shield_eff = StatusEffect.new("zyraen_balance_shield", StatusEffect.EffectType.SHIELD, 5.0, 400.0)
		effect_container.apply_effect(shield_eff)
		
	# Trigger forced equilibrium for 6.0s
	forced_equilibrium_timer = 6.0
	is_equilibrium_active = true
	_sync_equilibrium_buffs()
	
	# AoE Damage to surrounding enemies
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var total_dmg = base_dmg + (ap * r_res.scaling_ratio)
	
	var my_pos = global_position if is_inside_tree() else position
	var res: DamageResult = null
	var targets = enemies if not enemies.is_empty() else HeroEntity.active_heroes
	
	for e in targets:
		if e is BaseCombatEntity and is_instance_valid(e) and e.is_alive() and e.team != team and e.is_targetable:
			var e_pos = e.global_position if e.is_inside_tree() else e.position
			if my_pos.distance_to(e_pos) <= 5.5:
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.MAGICAL, "Perfect Balance")
				res = CombatCalculator.execute_damage(req)
				
	perfect_balance_achieved.emit(400.0, total_dmg)
	return res

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	forced_equilibrium_timer = 0.0
	is_equilibrium_active = false
	_sync_equilibrium_buffs()

func respawn() -> void:
	super.respawn()
	forced_equilibrium_timer = 0.0
	is_equilibrium_active = false
	_sync_equilibrium_buffs()
