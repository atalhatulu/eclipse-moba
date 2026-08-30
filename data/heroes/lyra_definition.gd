class_name LyraDefinition
extends RefCounted

## Lyra - The Bounty Tracker

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "lyra"
	res.hero_name = "Lyra"
	res.title = "The Bounty Tracker"
	res.lore = "A tactical recon scout armed with dual mini-crossbows and grappling hooks who marks high-priority targets for team bounty."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.AGILITY
	
	res.base_strength = 17.0
	res.strength_growth = 1.9
	res.base_agility = 24.0
	res.agility_growth = 3.0
	res.base_intelligence = 19.0
	res.intelligence_growth = 2.2
	
	res.base_health = 580.0
	res.base_health_regen = 2.2
	res.base_mana = 320.0
	res.base_mana_regen = 2.0
	res.base_attack_damage = 50.0
	res.base_ability_power = 0.0
	res.base_armor = 25.0
	res.base_magic_resist = 26.0
	res.base_attack_speed = 1.05
	res.base_move_speed = 320.0
	res.base_attack_range = 575.0
	
	# Q: Tracker Dart
	var q = AbilityResource.new()
	q.id = "lyra_q"
	q.ability_name = "Tracker Dart"
	q.target_type = AbilityResource.TargetType.DIRECTIONAL
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.8
	q.base_damage.assign([75.0, 120.0, 165.0, 210.0])
	q.cooldowns.assign([8.0, 7.5, 7.0, 6.5])
	q.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	q.cast_range = 750.0
	res.q_ability = q
	
	# W: Smoke Bomb
	var w = AbilityResource.new()
	w.id = "lyra_w"
	w.ability_name = "Smoke Bomb"
	w.target_type = AbilityResource.TargetType.SELF
	w.damage_type = DamageRequest.DamageType.PHYSICAL
	w.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.scaling_ratio = 0.6
	w.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	w.cooldowns.assign([15.0, 14.0, 13.0, 12.0])
	w.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	res.w_ability = w
	
	# E: Grappling Hook
	var e = AbilityResource.new()
	e.id = "lyra_e"
	e.ability_name = "Grappling Hook"
	e.target_type = AbilityResource.TargetType.DIRECTIONAL
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.6
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	e.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	res.e_ability = e
	
	# R: Marked for Death
	var r = AbilityResource.new()
	r.id = "lyra_r"
	r.ability_name = "Marked for Death"
	r.target_type = AbilityResource.TargetType.SINGLE_TARGET
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.2
	r.base_damage.assign([250.0, 375.0, 500.0])
	r.cooldowns.assign([70.0, 60.0, 50.0])
	r.mana_costs.assign([100.0, 100.0, 100.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
