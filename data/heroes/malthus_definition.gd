class_name MalthusDefinition
extends RefCounted

## Malthus - The Soul Reaper

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "malthus"
	res.hero_name = "Malthus"
	res.title = "The Soul Reaper"
	res.lore = "A withered reaper whose rusty scythe harvests souls from fallen foes, permanently scaling his combat range and attack power."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.AGILITY
	
	res.base_strength = 19.0
	res.strength_growth = 2.2
	res.base_agility = 24.0
	res.agility_growth = 3.1
	res.base_intelligence = 17.0
	res.intelligence_growth = 1.8
	
	res.base_health = 570.0
	res.base_health_regen = 2.2
	res.base_mana = 290.0
	res.base_mana_regen = 1.7
	res.base_attack_damage = 54.0
	res.base_ability_power = 0.0
	res.base_armor = 26.0
	res.base_magic_resist = 26.0
	res.base_attack_speed = 0.96
	res.base_move_speed = 315.0
	res.base_attack_range = 200.0
	
	# Q: Soul Reap
	var q = AbilityResource.new()
	q.id = "malthus_q"
	q.ability_name = "Soul Reap"
	q.target_type = AbilityResource.TargetType.GROUND_AOE
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.85
	q.base_damage.assign([80.0, 130.0, 180.0, 230.0])
	q.cooldowns.assign([7.0, 6.5, 6.0, 5.5])
	q.mana_costs.assign([45.0, 50.0, 55.0, 60.0])
	q.cast_range = 400.0
	res.q_ability = q
	
	# W: Ghost Walk
	var w = AbilityResource.new()
	w.id = "malthus_w"
	w.ability_name = "Ghost Walk"
	w.target_type = AbilityResource.TargetType.SELF
	w.damage_type = DamageRequest.DamageType.PHYSICAL
	w.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.scaling_ratio = 0.6
	w.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	w.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	w.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	res.w_ability = w
	
	# E: Decay
	var e = AbilityResource.new()
	e.id = "malthus_e"
	e.ability_name = "Decay"
	e.target_type = AbilityResource.TargetType.SELF
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.6
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	e.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	res.e_ability = e
	
	# R: The Inevitable
	var r = AbilityResource.new()
	r.id = "malthus_r"
	r.ability_name = "The Inevitable"
	r.target_type = AbilityResource.TargetType.SINGLE_TARGET
	r.damage_type = DamageRequest.DamageType.TRUE_DAMAGE
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.5
	r.base_damage.assign([250.0, 400.0, 550.0])
	r.cooldowns.assign([90.0, 75.0, 60.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
