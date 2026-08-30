class_name DrogasDefinition
extends RefCounted

## Drogas - The Siege Ram

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "drogas"
	res.hero_name = "Drogas"
	res.title = "The Siege Ram"
	res.lore = "A colossal stone-and-iron golem beast built solely to shatter fortress walls and crush tower defenses."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	
	res.base_strength = 29.0
	res.strength_growth = 4.0
	res.base_agility = 8.0
	res.agility_growth = 0.8
	res.base_intelligence = 11.0
	res.intelligence_growth = 1.0
	
	res.base_health = 760.0
	res.base_health_regen = 4.5
	res.base_mana = 200.0
	res.base_mana_regen = 0.9
	res.base_attack_damage = 60.0
	res.base_ability_power = 0.0
	res.base_armor = 38.0
	res.base_magic_resist = 28.0
	res.base_attack_speed = 0.7
	res.base_move_speed = 290.0
	res.base_attack_range = 150.0
	
	# Q: Ram Charge
	var q = AbilityResource.new()
	q.id = "drogas_q"
	q.ability_name = "Ram Charge"
	q.target_type = AbilityResource.TargetType.DIRECTIONAL
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.9
	q.base_damage.assign([100.0, 160.0, 220.0, 280.0])
	q.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	q.mana_costs.assign([60.0, 70.0, 80.0, 90.0])
	q.cast_range = 600.0
	res.q_ability = q
	
	# W: Trench
	var w = AbilityResource.new()
	w.id = "drogas_w"
	w.ability_name = "Trench"
	w.target_type = AbilityResource.TargetType.SELF
	w.damage_type = DamageRequest.DamageType.PHYSICAL
	w.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.scaling_ratio = 0.6
	w.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	w.cooldowns.assign([15.0, 14.0, 13.0, 12.0])
	w.mana_costs.assign([50.0, 60.0, 70.0, 80.0])
	res.w_ability = w
	
	# E: Rubble Toss
	var e = AbilityResource.new()
	e.id = "drogas_e"
	e.ability_name = "Rubble Toss"
	e.target_type = AbilityResource.TargetType.DIRECTIONAL
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.8
	e.base_damage.assign([85.0, 135.0, 185.0, 235.0])
	e.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	e.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	res.e_ability = e
	
	# R: Living Catapult
	var r = AbilityResource.new()
	r.id = "drogas_r"
	r.ability_name = "Living Catapult"
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.4
	r.base_damage.assign([300.0, 450.0, 600.0])
	r.cooldowns.assign([100.0, 85.0, 70.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
