class_name ElarionDefinition
extends RefCounted

## Elarion - The Spellblade

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "elarion"
	res.hero_name = "Elarion"
	res.title = "The Spellblade"
	res.lore = "An unarmored warrior etched with glowing arcane runes who converts ability power into magic-infused melee slashes and protective shields."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.INTELLIGENCE
	
	res.base_strength = 20.0
	res.strength_growth = 2.2
	res.base_agility = 17.0
	res.agility_growth = 1.9
	res.base_intelligence = 25.0
	res.intelligence_growth = 3.2
	
	res.base_health = 610.0
	res.base_health_regen = 2.6
	res.base_mana = 360.0
	res.base_mana_regen = 2.4
	res.base_attack_damage = 48.0
	res.base_ability_power = 20.0
	res.base_armor = 26.0
	res.base_magic_resist = 30.0
	res.base_attack_speed = 0.95
	res.base_move_speed = 315.0
	res.base_attack_range = 175.0
	
	# Q: Runic Slash
	var q = AbilityResource.new()
	q.id = "elarion_q"
	q.ability_name = "Runic Slash"
	q.target_type = AbilityResource.TargetType.DIRECTIONAL
	q.damage_type = DamageRequest.DamageType.MAGICAL
	q.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	q.scaling_ratio = 0.85
	q.base_damage.assign([85.0, 135.0, 185.0, 235.0])
	q.cooldowns.assign([6.0, 5.5, 5.0, 4.5])
	q.mana_costs.assign([45.0, 50.0, 55.0, 60.0])
	q.cast_range = 450.0
	res.q_ability = q
	
	# W: Arcane Step
	var w = AbilityResource.new()
	w.id = "elarion_w"
	w.ability_name = "Arcane Step"
	w.target_type = AbilityResource.TargetType.SINGLE_TARGET
	w.damage_type = DamageRequest.DamageType.MAGICAL
	w.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	w.scaling_ratio = 0.75
	w.base_damage.assign([70.0, 115.0, 160.0, 205.0])
	w.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	w.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	res.w_ability = w
	
	# E: Mana Drain
	var e = AbilityResource.new()
	e.id = "elarion_e"
	e.ability_name = "Mana Drain"
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.damage_type = DamageRequest.DamageType.MAGICAL
	e.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	e.scaling_ratio = 0.6
	e.base_damage.assign([60.0, 95.0, 130.0, 165.0])
	e.cooldowns.assign([11.0, 10.0, 9.0, 8.0])
	e.mana_costs.assign([30.0, 35.0, 40.0, 45.0])
	res.e_ability = e
	
	# R: Overload
	var r = AbilityResource.new()
	r.id = "elarion_r"
	r.ability_name = "Overload"
	r.target_type = AbilityResource.TargetType.SELF
	r.damage_type = DamageRequest.DamageType.MAGICAL
	r.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	r.scaling_ratio = 1.2
	r.base_damage.assign([250.0, 375.0, 500.0])
	r.cooldowns.assign([75.0, 60.0, 45.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
