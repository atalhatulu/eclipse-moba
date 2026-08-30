class_name AurikDefinition
extends RefCounted

## Aurik - The Sight Weaver

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "aurik"
	res.hero_name = "Aurik"
	res.title = "The Sight Weaver"
	res.lore = "An ethereal visionary who manipulates the Fog of War, weaving false signals, revealing hidden traps and providing global battlefield intelligence."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.INTELLIGENCE
	
	res.base_strength = 18.0
	res.strength_growth = 1.9
	res.base_agility = 17.0
	res.agility_growth = 1.7
	res.base_intelligence = 28.0
	res.intelligence_growth = 3.7
	
	res.base_health = 550.0
	res.base_health_regen = 2.2
	res.base_mana = 400.0
	res.base_mana_regen = 3.0
	res.base_attack_damage = 45.0
	res.base_ability_power = 20.0
	res.base_armor = 23.0
	res.base_magic_resist = 29.0
	res.base_attack_speed = 0.88
	res.base_move_speed = 315.0
	res.base_attack_range = 575.0
	
	# Q: Mirage Beacon
	var q = AbilityResource.new()
	q.id = "aurik_q"
	q.ability_name = "Mirage Beacon"
	q.target_type = AbilityResource.TargetType.GROUND_AOE
	q.damage_type = DamageRequest.DamageType.MAGICAL
	q.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	q.scaling_ratio = 0.6
	q.base_damage.assign([60.0, 100.0, 140.0, 180.0])
	q.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	q.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	q.cast_range = 400.0
	res.q_ability = q
	
	# W: Blindfold Shroud
	var w = AbilityResource.new()
	w.id = "aurik_w"
	w.ability_name = "Blindfold Shroud"
	w.target_type = AbilityResource.TargetType.GROUND_AOE
	w.damage_type = DamageRequest.DamageType.PHYSICAL
	w.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.scaling_ratio = 0.6
	w.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	w.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	w.mana_costs.assign([65.0, 70.0, 75.0, 80.0])
	res.w_ability = w
	
	# E: Ghost Pulse
	var e = AbilityResource.new()
	e.id = "aurik_e"
	e.ability_name = "Ghost Pulse"
	e.target_type = AbilityResource.TargetType.DIRECTIONAL
	e.damage_type = DamageRequest.DamageType.MAGICAL
	e.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	e.scaling_ratio = 0.7
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	e.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	res.e_ability = e
	
	# R: Clairvoyance
	var r = AbilityResource.new()
	r.id = "aurik_r"
	r.ability_name = "Clairvoyance"
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.damage_type = DamageRequest.DamageType.MAGICAL
	r.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	r.scaling_ratio = 1.0
	r.base_damage.assign([200.0, 300.0, 400.0])
	r.cooldowns.assign([90.0, 75.0, 60.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
