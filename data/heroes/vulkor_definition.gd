class_name VulkorDefinition
extends RefCounted

## Vulkor - The Armor Breaker

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "vulkor"
	res.hero_name = "Vulkor"
	res.title = "The Armor Breaker"
	res.lore = "A savage gladiator with twin crushing maces forged to shatter thick dragon-plate armor."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	
	res.base_strength = 26.0
	res.strength_growth = 3.4
	res.base_agility = 15.0
	res.agility_growth = 1.8
	res.base_intelligence = 10.0
	res.intelligence_growth = 1.0
	
	res.base_health = 670.0
	res.base_health_regen = 3.2
	res.base_mana = 220.0
	res.base_mana_regen = 1.0
	res.base_attack_damage = 64.0
	res.base_ability_power = 0.0
	res.base_armor = 32.0
	res.base_magic_resist = 26.0
	res.base_attack_speed = 0.88
	res.base_move_speed = 310.0
	res.base_attack_range = 150.0
	
	# Q: Bone Crusher
	var q = AbilityResource.new()
	q.id = "vulkor_q"
	q.ability_name = "Bone Crusher"
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 1.1
	q.base_damage.assign([90.0, 145.0, 200.0, 255.0])
	q.cooldowns.assign([8.0, 7.0, 6.0, 5.0])
	q.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	q.cast_range = 400.0
	res.q_ability = q
	
	# W: Armor Pierce
	var w = AbilityResource.new()
	w.id = "vulkor_w"
	w.ability_name = "Armor Pierce"
	w.target_type = AbilityResource.TargetType.GROUND_AOE
	w.damage_type = DamageRequest.DamageType.PHYSICAL
	w.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.scaling_ratio = 0.6
	w.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	w.cooldowns.assign([11.0, 10.0, 9.0, 8.0])
	w.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	res.w_ability = w
	
	# E: Relentless March
	var e = AbilityResource.new()
	e.id = "vulkor_e"
	e.ability_name = "Relentless March"
	e.target_type = AbilityResource.TargetType.SELF
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.6
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	e.mana_costs.assign([45.0, 50.0, 55.0, 60.0])
	res.e_ability = e
	
	# R: Shatter
	var r = AbilityResource.new()
	r.id = "vulkor_r"
	r.ability_name = "Shatter"
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.damage_type = DamageRequest.DamageType.TRUE_DAMAGE
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.2
	r.base_damage.assign([220.0, 340.0, 460.0])
	r.cooldowns.assign([85.0, 70.0, 55.0])
	r.mana_costs.assign([100.0, 120.0, 140.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
