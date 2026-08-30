class_name NoctisDefinition
extends RefCounted

## Noctis - The Sensory Thief

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "noctis"
	res.hero_name = "Noctis"
	res.title = "The Sensory Thief"
	res.lore = "A faceless wraith who absorbs surrounding starlight to blind enemy vision and plunge teams into total eclipse."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.AGILITY
	
	res.base_strength = 18.0
	res.strength_growth = 2.0
	res.base_agility = 26.0
	res.agility_growth = 3.4
	res.base_intelligence = 16.0
	res.intelligence_growth = 1.8
	
	res.base_health = 560.0
	res.base_health_regen = 2.0
	res.base_mana = 280.0
	res.base_mana_regen = 1.6
	res.base_attack_damage = 55.0
	res.base_ability_power = 0.0
	res.base_armor = 24.0
	res.base_magic_resist = 25.0
	res.base_attack_speed = 1.08
	res.base_move_speed = 325.0
	res.base_attack_range = 160.0
	
	# Q: Blind Spot
	var q = AbilityResource.new()
	q.id = "noctis_q"
	q.ability_name = "Blind Spot"
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 1.0
	q.base_damage.assign([85.0, 135.0, 185.0, 235.0])
	q.cooldowns.assign([8.0, 7.0, 6.0, 5.0])
	q.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	q.cast_range = 400.0
	res.q_ability = q
	
	# W: False Ping
	var w = AbilityResource.new()
	w.id = "noctis_w"
	w.ability_name = "False Ping"
	w.target_type = AbilityResource.TargetType.SELF
	w.damage_type = DamageRequest.DamageType.PHYSICAL
	w.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.scaling_ratio = 0.6
	w.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	w.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	w.mana_costs.assign([45.0, 50.0, 55.0, 60.0])
	res.w_ability = w
	
	# E: Shadow Swap
	var e = AbilityResource.new()
	e.id = "noctis_e"
	e.ability_name = "Shadow Swap"
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.6
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	e.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	res.e_ability = e
	
	# R: Total Eclipse
	var r = AbilityResource.new()
	r.id = "noctis_r"
	r.ability_name = "Total Eclipse"
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
