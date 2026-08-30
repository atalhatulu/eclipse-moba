class_name VelumDefinition
extends RefCounted

## Velum - The Symbiote

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "velum"
	res.hero_name = "Velum"
	res.title = "The Symbiote"
	res.lore = "A sentient magical ooze who infuses within allied hosts to amplify their power or neural-hijacks enemy champions."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.INTELLIGENCE
	
	res.base_strength = 15.0
	res.strength_growth = 1.5
	res.base_agility = 16.0
	res.agility_growth = 1.6
	res.base_intelligence = 28.0
	res.intelligence_growth = 3.8
	
	res.base_health = 500.0
	res.base_health_regen = 2.5
	res.base_mana = 420.0
	res.base_mana_regen = 3.2
	res.base_attack_damage = 42.0
	res.base_ability_power = 25.0
	res.base_armor = 20.0
	res.base_magic_resist = 28.0
	res.base_attack_speed = 0.85
	res.base_move_speed = 320.0
	res.base_attack_range = 500.0
	
	# Q: Parasitic Bolt
	var q = AbilityResource.new()
	q.id = "velum_q"
	q.ability_name = "Parasitic Bolt"
	q.target_type = AbilityResource.TargetType.DIRECTIONAL
	q.damage_type = DamageRequest.DamageType.MAGICAL
	q.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	q.scaling_ratio = 0.85
	q.base_damage.assign([85.0, 135.0, 185.0, 235.0])
	q.cooldowns.assign([6.0, 5.5, 5.0, 4.5])
	q.mana_costs.assign([45.0, 50.0, 55.0, 60.0])
	q.cast_range = 750.0
	res.q_ability = q
	
	# W: Mutate Host
	var w = AbilityResource.new()
	w.id = "velum_w"
	w.ability_name = "Mutate Host"
	w.target_type = AbilityResource.TargetType.SINGLE_TARGET
	w.damage_type = DamageRequest.DamageType.MAGICAL
	w.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	w.scaling_ratio = 0.6
	w.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	w.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	w.mana_costs.assign([65.0, 70.0, 75.0, 80.0])
	res.w_ability = w
	
	# E: Deflect
	var e = AbilityResource.new()
	e.id = "velum_e"
	e.ability_name = "Deflect"
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.damage_type = DamageRequest.DamageType.MAGICAL
	e.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	e.scaling_ratio = 0.6
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.cooldowns.assign([15.0, 14.0, 13.0, 12.0])
	e.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	res.e_ability = e
	
	# R: Neural Hijack
	var r = AbilityResource.new()
	r.id = "velum_r"
	r.ability_name = "Neural Hijack"
	r.target_type = AbilityResource.TargetType.SINGLE_TARGET
	r.damage_type = DamageRequest.DamageType.MAGICAL
	r.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	r.scaling_ratio = 1.2
	r.base_damage.assign([250.0, 375.0, 500.0])
	r.cooldowns.assign([100.0, 85.0, 70.0])
	r.mana_costs.assign([125.0, 150.0, 175.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
