class_name TrakDefinition
extends RefCounted

## Trak - The Kinetic Brawler

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "trak"
	res.hero_name = "Trak"
	res.title = "The Kinetic Brawler"
	res.lore = "A street brawler fitted with hydraulic kinetic gauntlets who gains extreme momentum by ricocheting off terrain."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	
	res.base_strength = 25.0
	res.strength_growth = 3.2
	res.base_agility = 18.0
	res.agility_growth = 2.2
	res.base_intelligence = 11.0
	res.intelligence_growth = 1.1
	
	res.base_health = 650.0
	res.base_health_regen = 3.0
	res.base_mana = 230.0
	res.base_mana_regen = 1.1
	res.base_attack_damage = 61.0
	res.base_ability_power = 0.0
	res.base_armor = 30.0
	res.base_magic_resist = 26.0
	res.base_attack_speed = 0.92
	res.base_move_speed = 315.0
	res.base_attack_range = 150.0
	
	# Q: Spring Punch
	var q = AbilityResource.new()
	q.id = "trak_q"
	q.ability_name = "Spring Punch"
	q.target_type = AbilityResource.TargetType.DIRECTIONAL
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.85
	q.base_damage.assign([85.0, 135.0, 185.0, 235.0])
	q.cooldowns.assign([7.0, 6.5, 6.0, 5.5])
	q.mana_costs.assign([45.0, 50.0, 55.0, 60.0])
	q.cast_range = 450.0
	res.q_ability = q
	
	# W: Ricochet
	var w = AbilityResource.new()
	w.id = "trak_w"
	w.ability_name = "Ricochet"
	w.target_type = AbilityResource.TargetType.SELF
	w.damage_type = DamageRequest.DamageType.PHYSICAL
	w.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.scaling_ratio = 0.6
	w.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	w.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	w.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	res.w_ability = w
	
	# E: Shockwave
	var e = AbilityResource.new()
	e.id = "trak_e"
	e.ability_name = "Shockwave"
	e.target_type = AbilityResource.TargetType.GROUND_AOE
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.7
	e.base_damage.assign([70.0, 115.0, 160.0, 205.0])
	e.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	e.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	res.e_ability = e
	
	# R: Pinball
	var r = AbilityResource.new()
	r.id = "trak_r"
	r.ability_name = "Pinball"
	r.target_type = AbilityResource.TargetType.SELF
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.2
	r.base_damage.assign([250.0, 375.0, 500.0])
	r.cooldowns.assign([75.0, 65.0, 55.0])
	r.mana_costs.assign([100.0, 115.0, 130.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
