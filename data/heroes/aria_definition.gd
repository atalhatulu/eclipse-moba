class_name AriaDefinition
extends RefCounted

## Aria - The Flawless Duelist

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "aria"
	res.hero_name = "Aria"
	res.title = "The Flawless Duelist"
	res.lore = "A haughty noble fencer wielding a luminous rapier whose mastery of parry transforms fragile defense into instant lethality."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.AGILITY
	
	res.base_strength = 15.0
	res.strength_growth = 1.6
	res.base_agility = 28.0
	res.agility_growth = 3.7
	res.base_intelligence = 15.0
	res.intelligence_growth = 1.5
	
	res.base_health = 520.0
	res.base_health_regen = 1.8
	res.base_mana = 270.0
	res.base_mana_regen = 1.5
	res.base_attack_damage = 58.0
	res.base_ability_power = 0.0
	res.base_armor = 21.0
	res.base_magic_resist = 23.0
	res.base_attack_speed = 1.15
	res.base_move_speed = 330.0
	res.base_attack_range = 175.0
	
	# Q: Lunge
	var q = AbilityResource.new()
	q.id = "aria_q"
	q.ability_name = "Lunge"
	q.target_type = AbilityResource.TargetType.DIRECTIONAL
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 1.05
	q.base_damage.assign([85.0, 135.0, 185.0, 235.0])
	q.cooldowns.assign([6.0, 5.5, 5.0, 4.5])
	q.mana_costs.assign([40.0, 45.0, 50.0, 55.0])
	q.cast_range = 400.0
	res.q_ability = q
	
	# W: Riposte
	var w = AbilityResource.new()
	w.id = "aria_w"
	w.ability_name = "Riposte"
	w.target_type = AbilityResource.TargetType.SELF
	w.damage_type = DamageRequest.DamageType.PHYSICAL
	w.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.scaling_ratio = 0.6
	w.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	w.cooldowns.assign([13.0, 11.5, 10.0, 8.5])
	w.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	res.w_ability = w
	
	# E: Disarm
	var e = AbilityResource.new()
	e.id = "aria_e"
	e.ability_name = "Disarm"
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.6
	e.base_damage.assign([60.0, 95.0, 130.0, 165.0])
	e.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	e.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	res.e_ability = e
	
	# R: Dance of Death
	var r = AbilityResource.new()
	r.id = "aria_r"
	r.ability_name = "Dance of Death"
	r.target_type = AbilityResource.TargetType.SINGLE_TARGET
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.8
	r.base_damage.assign([300.0, 475.0, 650.0])
	r.cooldowns.assign([70.0, 55.0, 40.0])
	r.mana_costs.assign([100.0, 100.0, 100.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
