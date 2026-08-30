class_name SeraDefinition
extends RefCounted

## Sera - The Fate Weaver

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "sera"
	res.hero_name = "Sera"
	res.title = "The Fate Weaver"
	res.lore = "A serene temple priestess who weaves golden threads of karma, staggering lethal burst into manageable overtime bleeds."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.INTELLIGENCE
	
	res.base_strength = 17.0
	res.strength_growth = 1.8
	res.base_agility = 16.0
	res.agility_growth = 1.6
	res.base_intelligence = 29.0
	res.intelligence_growth = 3.9
	
	res.base_health = 540.0
	res.base_health_regen = 2.0
	res.base_mana = 400.0
	res.base_mana_regen = 3.0
	res.base_attack_damage = 44.0
	res.base_ability_power = 20.0
	res.base_armor = 22.0
	res.base_magic_resist = 28.0
	res.base_attack_speed = 0.88
	res.base_move_speed = 310.0
	res.base_attack_range = 575.0
	
	# Q: Staggered Fate
	var q = AbilityResource.new()
	q.id = "sera_q"
	q.ability_name = "Staggered Fate"
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.damage_type = DamageRequest.DamageType.MAGICAL
	q.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	q.scaling_ratio = 0.8
	q.base_damage.assign([80.0, 130.0, 180.0, 230.0])
	q.cooldowns.assign([9.0, 8.0, 7.0, 6.0])
	q.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	q.cast_range = 400.0
	res.q_ability = q
	
	# W: Thread of Retribution
	var w = AbilityResource.new()
	w.id = "sera_w"
	w.ability_name = "Thread of Retribution"
	w.target_type = AbilityResource.TargetType.SINGLE_TARGET
	w.damage_type = DamageRequest.DamageType.MAGICAL
	w.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	w.scaling_ratio = 0.8
	w.base_damage.assign([75.0, 120.0, 165.0, 210.0])
	w.cooldowns.assign([11.0, 10.0, 9.0, 8.0])
	w.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	res.w_ability = w
	
	# E: Cleanse
	var e = AbilityResource.new()
	e.id = "sera_e"
	e.ability_name = "Cleanse"
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.damage_type = DamageRequest.DamageType.MAGICAL
	e.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	e.scaling_ratio = 0.6
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	e.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	res.e_ability = e
	
	# R: Reweave
	var r = AbilityResource.new()
	r.id = "sera_r"
	r.ability_name = "Reweave"
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.damage_type = DamageRequest.DamageType.MAGICAL
	r.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	r.scaling_ratio = 1.2
	r.base_damage.assign([250.0, 375.0, 500.0])
	r.cooldowns.assign([90.0, 75.0, 60.0])
	r.mana_costs.assign([100.0, 130.0, 160.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
