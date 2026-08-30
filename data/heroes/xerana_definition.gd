class_name XeranaDefinition
extends RefCounted

## Xerana - The Chakram Queen

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "xerana"
	res.hero_name = "Xerana"
	res.title = "The Chakram Queen"
	res.lore = "An ethereal fairy queen commanding four hovering golden chakrams that ricochet infinitely through enemy lines."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.INTELLIGENCE
	
	res.base_strength = 16.0
	res.strength_growth = 1.7
	res.base_agility = 22.0
	res.agility_growth = 2.6
	res.base_intelligence = 27.0
	res.intelligence_growth = 3.6
	
	res.base_health = 540.0
	res.base_health_regen = 2.0
	res.base_mana = 380.0
	res.base_mana_regen = 2.8
	res.base_attack_damage = 46.0
	res.base_ability_power = 15.0
	res.base_armor = 22.0
	res.base_magic_resist = 26.0
	res.base_attack_speed = 1.05
	res.base_move_speed = 315.0
	res.base_attack_range = 600.0
	
	# Q: Disc Recall
	var q = AbilityResource.new()
	q.id = "xerana_q"
	q.ability_name = "Disc Recall"
	q.target_type = AbilityResource.TargetType.GROUND_AOE
	q.damage_type = DamageRequest.DamageType.MAGICAL
	q.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	q.scaling_ratio = 0.8
	q.base_damage.assign([80.0, 130.0, 180.0, 230.0])
	q.cooldowns.assign([7.0, 6.5, 6.0, 5.5])
	q.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	q.cast_range = 400.0
	res.q_ability = q
	
	# W: Energy Tread
	var w = AbilityResource.new()
	w.id = "xerana_w"
	w.ability_name = "Energy Tread"
	w.target_type = AbilityResource.TargetType.DIRECTIONAL
	w.damage_type = DamageRequest.DamageType.MAGICAL
	w.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	w.scaling_ratio = 0.6
	w.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	w.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	w.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	res.w_ability = w
	
	# E: Chain Lightning
	var e = AbilityResource.new()
	e.id = "xerana_e"
	e.ability_name = "Chain Lightning"
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.damage_type = DamageRequest.DamageType.MAGICAL
	e.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	e.scaling_ratio = 0.7
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.cooldowns.assign([9.0, 8.0, 7.0, 6.0])
	e.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	res.e_ability = e
	
	# R: Chakram Storm
	var r = AbilityResource.new()
	r.id = "xerana_r"
	r.ability_name = "Chakram Storm"
	r.target_type = AbilityResource.TargetType.SELF
	r.damage_type = DamageRequest.DamageType.MAGICAL
	r.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	r.scaling_ratio = 1.2
	r.base_damage.assign([250.0, 375.0, 500.0])
	r.cooldowns.assign([85.0, 70.0, 55.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
