class_name ValgorDefinition
extends RefCounted

## Valgor - The Dual Sovereign

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "valgor"
	res.hero_name = "Valgor"
	res.title = "The Dual Sovereign"
	res.lore = "A tactical gladiator who dynamically shifts between a durable heavy-armored melee form and a rapid high-range sniper stance."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.AGILITY
	
	res.base_strength = 22.0
	res.strength_growth = 2.4
	res.base_agility = 26.0
	res.agility_growth = 3.3
	res.base_intelligence = 16.0
	res.intelligence_growth = 1.6
	
	res.base_health = 630.0
	res.base_health_regen = 2.6
	res.base_mana = 280.0
	res.base_mana_regen = 1.6
	res.base_attack_damage = 56.0
	res.base_ability_power = 0.0
	res.base_armor = 28.0
	res.base_magic_resist = 26.0
	res.base_attack_speed = 1.02
	res.base_move_speed = 320.0
	res.base_attack_range = 175.0
	
	# Q: Stance Shift
	var q = AbilityResource.new()
	q.id = "valgor_q"
	q.ability_name = "Stance Shift"
	q.target_type = AbilityResource.TargetType.DIRECTIONAL
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.8
	q.base_damage.assign([80.0, 130.0, 180.0, 230.0])
	q.cooldowns.assign([5.0, 4.5, 4.0, 3.5])
	q.mana_costs.assign([30.0, 35.0, 40.0, 45.0])
	q.cast_range = 450.0
	res.q_ability = q
	
	# W: Twin Discipline
	var w = AbilityResource.new()
	w.id = "valgor_w"
	w.ability_name = "Twin Discipline"
	w.target_type = AbilityResource.TargetType.DIRECTIONAL
	w.damage_type = DamageRequest.DamageType.PHYSICAL
	w.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.scaling_ratio = 0.75
	w.base_damage.assign([75.0, 120.0, 165.0, 210.0])
	w.cooldowns.assign([9.0, 8.0, 7.0, 6.0])
	w.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	res.w_ability = w
	
	# E: Tactical Surge
	var e = AbilityResource.new()
	e.id = "valgor_e"
	e.ability_name = "Tactical Surge"
	e.target_type = AbilityResource.TargetType.SELF
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.6
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.cooldowns.assign([11.0, 10.0, 9.0, 8.0])
	e.mana_costs.assign([45.0, 50.0, 55.0, 60.0])
	res.e_ability = e
	
	# R: Dual Equilibrium
	var r = AbilityResource.new()
	r.id = "valgor_r"
	r.ability_name = "Dual Equilibrium"
	r.target_type = AbilityResource.TargetType.SELF
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.2
	r.base_damage.assign([250.0, 375.0, 500.0])
	r.cooldowns.assign([80.0, 65.0, 50.0])
	r.mana_costs.assign([100.0, 115.0, 130.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
