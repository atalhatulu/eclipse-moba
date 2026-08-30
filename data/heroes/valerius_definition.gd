class_name ValeriusDefinition
extends RefCounted

## Valerius - The Inquisitor

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "valerius"
	res.hero_name = "Valerius"
	res.title = "The Inquisitor"
	res.lore = "A ruthless judge of the sacred order who pins mobility champions to the ground with gravity chains and courtroom arenas."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.INTELLIGENCE
	
	res.base_strength = 22.0
	res.strength_growth = 2.5
	res.base_agility = 14.0
	res.agility_growth = 1.4
	res.base_intelligence = 26.0
	res.intelligence_growth = 3.3
	
	res.base_health = 630.0
	res.base_health_regen = 2.8
	res.base_mana = 350.0
	res.base_mana_regen = 2.2
	res.base_attack_damage = 50.0
	res.base_ability_power = 15.0
	res.base_armor = 28.0
	res.base_magic_resist = 32.0
	res.base_attack_speed = 0.82
	res.base_move_speed = 305.0
	res.base_attack_range = 500.0
	
	# Q: Shackles
	var q = AbilityResource.new()
	q.id = "valerius_q"
	q.ability_name = "Shackles"
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.damage_type = DamageRequest.DamageType.MAGICAL
	q.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	q.scaling_ratio = 0.75
	q.base_damage.assign([80.0, 125.0, 170.0, 215.0])
	q.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	q.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	q.cast_range = 400.0
	res.q_ability = q
	
	# W: Heavy Gravity
	var w = AbilityResource.new()
	w.id = "valerius_w"
	w.ability_name = "Heavy Gravity"
	w.target_type = AbilityResource.TargetType.GROUND_AOE
	w.damage_type = DamageRequest.DamageType.MAGICAL
	w.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	w.scaling_ratio = 0.7
	w.base_damage.assign([70.0, 115.0, 160.0, 205.0])
	w.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	w.mana_costs.assign([65.0, 70.0, 75.0, 80.0])
	res.w_ability = w
	
	# E: Confess
	var e = AbilityResource.new()
	e.id = "valerius_e"
	e.ability_name = "Confess"
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.damage_type = DamageRequest.DamageType.MAGICAL
	e.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	e.scaling_ratio = 0.6
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.cooldowns.assign([13.0, 12.0, 11.0, 10.0])
	e.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	res.e_ability = e
	
	# R: Court of Law
	var r = AbilityResource.new()
	r.id = "valerius_r"
	r.ability_name = "Court of Law"
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.damage_type = DamageRequest.DamageType.MAGICAL
	r.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	r.scaling_ratio = 1.2
	r.base_damage.assign([260.0, 390.0, 520.0])
	r.cooldowns.assign([90.0, 75.0, 60.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
