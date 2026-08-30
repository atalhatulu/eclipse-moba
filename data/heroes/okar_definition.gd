class_name OkarDefinition
extends RefCounted

## Okar - The Rhythm Master

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "okar"
	res.hero_name = "Okar"
	res.title = "The Rhythm Master"
	res.lore = "A blindfolded martial monk who channels immense patience into devastating focus strikes and perfect parries."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	
	res.base_strength = 26.0
	res.strength_growth = 3.5
	res.base_agility = 16.0
	res.agility_growth = 2.0
	res.base_intelligence = 15.0
	res.intelligence_growth = 1.5
	
	res.base_health = 690.0
	res.base_health_regen = 3.6
	res.base_mana = 260.0
	res.base_mana_regen = 1.4
	res.base_attack_damage = 63.0
	res.base_ability_power = 0.0
	res.base_armor = 33.0
	res.base_magic_resist = 29.0
	res.base_attack_speed = 0.82
	res.base_move_speed = 310.0
	res.base_attack_range = 160.0
	
	# Q: Focus Strike
	var q = AbilityResource.new()
	q.id = "okar_q"
	q.ability_name = "Focus Strike"
	q.target_type = AbilityResource.TargetType.DIRECTIONAL
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 1.15
	q.base_damage.assign([95.0, 155.0, 215.0, 275.0])
	q.cooldowns.assign([9.0, 8.0, 7.0, 6.0])
	q.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	q.cast_range = 400.0
	res.q_ability = q
	
	# W: Flowing Water
	var w = AbilityResource.new()
	w.id = "okar_w"
	w.ability_name = "Flowing Water"
	w.target_type = AbilityResource.TargetType.SELF
	w.damage_type = DamageRequest.DamageType.PHYSICAL
	w.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.scaling_ratio = 0.6
	w.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	w.cooldowns.assign([14.0, 12.5, 11.0, 9.5])
	w.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	res.w_ability = w
	
	# E: Deep Breath
	var e = AbilityResource.new()
	e.id = "okar_e"
	e.ability_name = "Deep Breath"
	e.target_type = AbilityResource.TargetType.SELF
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.6
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.cooldowns.assign([15.0, 14.0, 13.0, 12.0])
	e.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	res.e_ability = e
	
	# R: One Strike
	var r = AbilityResource.new()
	r.id = "okar_r"
	r.ability_name = "One Strike"
	r.target_type = AbilityResource.TargetType.DIRECTIONAL
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 2.2
	r.base_damage.assign([400.0, 600.0, 800.0])
	r.cooldowns.assign([100.0, 85.0, 70.0])
	r.mana_costs.assign([120.0, 140.0, 160.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
