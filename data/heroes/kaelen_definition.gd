class_name KaelenDefinition
extends RefCounted

## Kaelen - The Tower Bulwark

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "kaelen"
	res.hero_name = "Kaelen"
	res.title = "The Tower Bulwark"
	res.lore = "A towering armored knight with a door-sized bulwark shield dedicated to intercepting all lethal strikes."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	
	res.base_strength = 28.0
	res.strength_growth = 3.8
	res.base_agility = 10.0
	res.agility_growth = 1.0
	res.base_intelligence = 12.0
	res.intelligence_growth = 1.2
	
	res.base_health = 740.0
	res.base_health_regen = 4.0
	res.base_mana = 240.0
	res.base_mana_regen = 1.0
	res.base_attack_damage = 54.0
	res.base_ability_power = 0.0
	res.base_armor = 36.0
	res.base_magic_resist = 30.0
	res.base_attack_speed = 0.75
	res.base_move_speed = 295.0
	res.base_attack_range = 150.0
	
	# Q: Shield Slam
	var q = AbilityResource.new()
	q.id = "kaelen_q"
	q.ability_name = "Shield Slam"
	q.target_type = AbilityResource.TargetType.DIRECTIONAL
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.7
	q.base_damage.assign([80.0, 130.0, 180.0, 230.0])
	q.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	q.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	q.cast_range = 350.0
	res.q_ability = q
	
	# W: Body Block
	var w = AbilityResource.new()
	w.id = "kaelen_w"
	w.ability_name = "Body Block"
	w.target_type = AbilityResource.TargetType.SINGLE_TARGET
	w.damage_type = DamageRequest.DamageType.PHYSICAL
	w.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.scaling_ratio = 0.6
	w.base_damage.assign([150.0, 250.0, 350.0, 450.0])
	w.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	w.mana_costs.assign([70.0, 75.0, 80.0, 85.0])
	res.w_ability = w
	
	# E: Unbreakable
	var e = AbilityResource.new()
	e.id = "kaelen_e"
	e.ability_name = "Unbreakable"
	e.target_type = AbilityResource.TargetType.SELF
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.6
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.cooldowns.assign([16.0, 15.0, 14.0, 13.0])
	e.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	res.e_ability = e
	
	# R: Phalanx
	var r = AbilityResource.new()
	r.id = "kaelen_r"
	r.ability_name = "Phalanx"
	r.target_type = AbilityResource.TargetType.SELF
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.2
	r.base_damage.assign([250.0, 375.0, 500.0])
	r.cooldowns.assign([90.0, 75.0, 60.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
