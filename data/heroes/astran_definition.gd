class_name AstranDefinition
extends RefCounted

## Astran - The Cosmic Titan

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "astran"
	res.hero_name = "Astran"
	res.title = "The Cosmic Titan"
	res.lore = "A celestial titan woven from stardust and orbiting meteors who bends gravitational pull across the map."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	
	res.base_strength = 27.0
	res.strength_growth = 3.7
	res.base_agility = 11.0
	res.agility_growth = 1.1
	res.base_intelligence = 18.0
	res.intelligence_growth = 2.0
	
	res.base_health = 710.0
	res.base_health_regen = 3.8
	res.base_mana = 320.0
	res.base_mana_regen = 1.8
	res.base_attack_damage = 56.0
	res.base_ability_power = 0.0
	res.base_armor = 32.0
	res.base_magic_resist = 34.0
	res.base_attack_speed = 0.8
	res.base_move_speed = 300.0
	res.base_attack_range = 160.0
	
	# Q: Gravity Pull
	var q = AbilityResource.new()
	q.id = "astran_q"
	q.ability_name = "Gravity Pull"
	q.target_type = AbilityResource.TargetType.GROUND_AOE
	q.damage_type = DamageRequest.DamageType.MAGICAL
	q.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	q.scaling_ratio = 0.7
	q.base_damage.assign([80.0, 130.0, 180.0, 230.0])
	q.cooldowns.assign([11.0, 10.0, 9.0, 8.0])
	q.mana_costs.assign([70.0, 80.0, 90.0, 100.0])
	q.cast_range = 400.0
	res.q_ability = q
	
	# W: Meteorite Shield
	var w = AbilityResource.new()
	w.id = "astran_w"
	w.ability_name = "Meteorite Shield"
	w.target_type = AbilityResource.TargetType.SINGLE_TARGET
	w.damage_type = DamageRequest.DamageType.PHYSICAL
	w.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.scaling_ratio = 0.6
	w.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	w.cooldowns.assign([13.0, 12.0, 11.0, 10.0])
	w.mana_costs.assign([65.0, 75.0, 85.0, 95.0])
	res.w_ability = w
	
	# E: Crater
	var e = AbilityResource.new()
	e.id = "astran_e"
	e.ability_name = "Crater"
	e.target_type = AbilityResource.TargetType.GROUND_AOE
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.75
	e.base_damage.assign([75.0, 120.0, 165.0, 210.0])
	e.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	e.mana_costs.assign([60.0, 70.0, 80.0, 90.0])
	res.e_ability = e
	
	# R: Orbital Strike
	var r = AbilityResource.new()
	r.id = "astran_r"
	r.ability_name = "Orbital Strike"
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.damage_type = DamageRequest.DamageType.MAGICAL
	r.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	r.scaling_ratio = 1.3
	r.base_damage.assign([280.0, 420.0, 560.0])
	r.cooldowns.assign([110.0, 95.0, 80.0])
	r.mana_costs.assign([120.0, 150.0, 180.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
