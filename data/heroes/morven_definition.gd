class_name MorvenDefinition
extends RefCounted

## Morven - The Toxic Skirmisher

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "morven"
	res.hero_name = "Morven"
	res.title = "The Toxic Skirmisher"
	res.lore = "A venomous rogue who corrodes enemy healing into deadly acid and feeds on broken defensive shields."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.AGILITY
	
	res.base_strength = 18.0
	res.strength_growth = 2.0
	res.base_agility = 27.0
	res.agility_growth = 3.5
	res.base_intelligence = 14.0
	res.intelligence_growth = 1.4
	
	res.base_health = 560.0
	res.base_health_regen = 2.0
	res.base_mana = 260.0
	res.base_mana_regen = 1.4
	res.base_attack_damage = 57.0
	res.base_ability_power = 0.0
	res.base_armor = 25.0
	res.base_magic_resist = 25.0
	res.base_attack_speed = 1.1
	res.base_move_speed = 325.0
	res.base_attack_range = 150.0
	
	# Q: Venom Slash
	var q = AbilityResource.new()
	q.id = "morven_q"
	q.ability_name = "Venom Slash"
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.9
	q.base_damage.assign([75.0, 120.0, 165.0, 210.0])
	q.cooldowns.assign([7.0, 6.0, 5.0, 4.0])
	q.mana_costs.assign([40.0, 45.0, 50.0, 55.0])
	q.cast_range = 400.0
	res.q_ability = q
	
	# W: Plague Step
	var w = AbilityResource.new()
	w.id = "morven_w"
	w.ability_name = "Plague Step"
	w.target_type = AbilityResource.TargetType.DIRECTIONAL
	w.damage_type = DamageRequest.DamageType.PHYSICAL
	w.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.scaling_ratio = 0.6
	w.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	w.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	w.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	res.w_ability = w
	
	# E: Corrupt
	var e = AbilityResource.new()
	e.id = "morven_e"
	e.ability_name = "Corrupt"
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.damage_type = DamageRequest.DamageType.MAGICAL
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.7
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.cooldowns.assign([11.0, 10.0, 9.0, 8.0])
	e.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	res.e_ability = e
	
	# R: Reverse Life
	var r = AbilityResource.new()
	r.id = "morven_r"
	r.ability_name = "Reverse Life"
	r.target_type = AbilityResource.TargetType.SINGLE_TARGET
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.2
	r.base_damage.assign([250.0, 375.0, 500.0])
	r.cooldowns.assign([80.0, 65.0, 50.0])
	r.mana_costs.assign([100.0, 120.0, 140.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
