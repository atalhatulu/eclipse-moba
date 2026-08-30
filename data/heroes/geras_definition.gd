class_name GerasDefinition
extends RefCounted

## Geras - The Tectonic Architect

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "geras"
	res.hero_name = "Geras"
	res.title = "The Tectonic Architect"
	res.lore = "A scholar earth mage with hands of tectonic granite who constructs impassable walls and opens deep tectonic rift fault lines dividing the battlefield."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.INTELLIGENCE
	
	res.base_strength = 23.0
	res.strength_growth = 2.6
	res.base_agility = 12.0
	res.agility_growth = 1.2
	res.base_intelligence = 27.0
	res.intelligence_growth = 3.4
	
	res.base_health = 640.0
	res.base_health_regen = 2.8
	res.base_mana = 360.0
	res.base_mana_regen = 2.4
	res.base_attack_damage = 52.0
	res.base_ability_power = 20.0
	res.base_armor = 30.0
	res.base_magic_resist = 30.0
	res.base_attack_speed = 0.8
	res.base_move_speed = 300.0
	res.base_attack_range = 500.0
	
	# Q: Raise Earth
	var q = AbilityResource.new()
	q.id = "geras_q"
	q.ability_name = "Raise Earth"
	q.target_type = AbilityResource.TargetType.DIRECTIONAL
	q.damage_type = DamageRequest.DamageType.MAGICAL
	q.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	q.scaling_ratio = 0.8
	q.base_damage.assign([80.0, 130.0, 180.0, 230.0])
	q.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	q.mana_costs.assign([65.0, 70.0, 75.0, 80.0])
	q.cast_range = 650.0
	res.q_ability = q
	
	# W: Collapse
	var w = AbilityResource.new()
	w.id = "geras_w"
	w.ability_name = "Collapse"
	w.target_type = AbilityResource.TargetType.GROUND_AOE
	w.damage_type = DamageRequest.DamageType.MAGICAL
	w.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	w.scaling_ratio = 0.85
	w.base_damage.assign([90.0, 140.0, 190.0, 240.0])
	w.cooldowns.assign([9.0, 8.0, 7.0, 6.0])
	w.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	res.w_ability = w
	
	# E: Quicksand
	var e = AbilityResource.new()
	e.id = "geras_e"
	e.ability_name = "Quicksand"
	e.target_type = AbilityResource.TargetType.GROUND_AOE
	e.damage_type = DamageRequest.DamageType.MAGICAL
	e.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	e.scaling_ratio = 0.6
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.cooldowns.assign([13.0, 12.0, 11.0, 10.0])
	e.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	res.e_ability = e
	
	# R: Shifting Plates
	var r = AbilityResource.new()
	r.id = "geras_r"
	r.ability_name = "Tectonic Fissure"
	r.description = "Rips open a massive tectonic fault line in the earth, knocking enemies to opposite sides and slowing passage across the rift by 70%."
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.damage_type = DamageRequest.DamageType.MAGICAL
	r.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	r.scaling_ratio = 1.1
	r.base_damage.assign([240.0, 360.0, 480.0])
	r.cooldowns.assign([100.0, 85.0, 70.0])
	r.mana_costs.assign([120.0, 145.0, 170.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
