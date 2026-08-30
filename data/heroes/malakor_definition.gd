class_name MalakorDefinition
extends RefCounted

## Malakor - The High Tactician

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "malakor"
	res.hero_name = "Malakor"
	res.title = "The High Tactician"
	res.lore = "A master field marshal who commands allied minion formations, issuing tactical advance, fortify and focus-fire orders to dismantle enemy defenses."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	
	res.base_strength = 27.0
	res.strength_growth = 3.6
	res.base_agility = 14.0
	res.agility_growth = 1.4
	res.base_intelligence = 19.0
	res.intelligence_growth = 2.0
	
	res.base_health = 700.0
	res.base_health_regen = 3.5
	res.base_mana = 300.0
	res.base_mana_regen = 1.8
	res.base_attack_damage = 58.0
	res.base_ability_power = 0.0
	res.base_armor = 34.0
	res.base_magic_resist = 28.0
	res.base_attack_speed = 0.82
	res.base_move_speed = 305.0
	res.base_attack_range = 160.0
	
	# Q: Advance & Charge
	var q = AbilityResource.new()
	q.id = "malakor_q"
	q.ability_name = "Advance & Charge"
	q.target_type = AbilityResource.TargetType.DIRECTIONAL
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.85
	q.base_damage.assign([90.0, 140.0, 190.0, 240.0])
	q.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	q.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	q.cast_range = 600.0
	res.q_ability = q
	
	# W: Hold the Line
	var w = AbilityResource.new()
	w.id = "malakor_w"
	w.ability_name = "Hold the Line"
	w.target_type = AbilityResource.TargetType.SELF
	w.damage_type = DamageRequest.DamageType.PHYSICAL
	w.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.scaling_ratio = 0.6
	w.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	w.cooldowns.assign([13.0, 12.0, 11.0, 10.0])
	w.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	res.w_ability = w
	
	# E: Focus Fire
	var e = AbilityResource.new()
	e.id = "malakor_e"
	e.ability_name = "Focus Fire"
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.7
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.cooldowns.assign([8.0, 7.5, 7.0, 6.5])
	e.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	res.e_ability = e
	
	# R: Royal Vanguard
	var r = AbilityResource.new()
	r.id = "malakor_r"
	r.ability_name = "Royal Vanguard"
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.2
	r.base_damage.assign([250.0, 375.0, 500.0])
	r.cooldowns.assign([120.0, 105.0, 90.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
