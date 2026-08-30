class_name ZinDefinition
extends RefCounted

## Zin - The Mirror Dancer

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "zin"
	res.hero_name = "Zin"
	res.title = "The Mirror Dancer"
	res.lore = "An aristocratic illusionist draped in shattered mirror shards who bewilders foes with deceptive clone reflections."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.AGILITY
	
	res.base_strength = 16.0
	res.strength_growth = 1.8
	res.base_agility = 25.0
	res.agility_growth = 3.2
	res.base_intelligence = 18.0
	res.intelligence_growth = 2.0
	
	res.base_health = 550.0
	res.base_health_regen = 2.1
	res.base_mana = 300.0
	res.base_mana_regen = 1.8
	res.base_attack_damage = 52.0
	res.base_ability_power = 0.0
	res.base_armor = 22.0
	res.base_magic_resist = 24.0
	res.base_attack_speed = 1.02
	res.base_move_speed = 320.0
	res.base_attack_range = 175.0
	
	# Q: Reflection
	var q = AbilityResource.new()
	q.id = "zin_q"
	q.ability_name = "Reflection"
	q.target_type = AbilityResource.TargetType.DIRECTIONAL
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.8
	q.base_damage.assign([80.0, 130.0, 180.0, 230.0])
	q.cooldowns.assign([11.0, 10.0, 9.0, 8.0])
	q.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	q.cast_range = 600.0
	res.q_ability = q
	
	# W: Swap
	var w = AbilityResource.new()
	w.id = "zin_w"
	w.ability_name = "Swap"
	w.target_type = AbilityResource.TargetType.SELF
	w.damage_type = DamageRequest.DamageType.PHYSICAL
	w.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.scaling_ratio = 0.6
	w.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	w.cooldowns.assign([9.0, 8.0, 7.0, 6.0])
	w.mana_costs.assign([40.0, 45.0, 50.0, 55.0])
	res.w_ability = w
	
	# E: Glass Shards
	var e = AbilityResource.new()
	e.id = "zin_e"
	e.ability_name = "Glass Shards"
	e.target_type = AbilityResource.TargetType.GROUND_AOE
	e.damage_type = DamageRequest.DamageType.MAGICAL
	e.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	e.scaling_ratio = 0.75
	e.base_damage.assign([80.0, 125.0, 170.0, 215.0])
	e.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	e.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	res.e_ability = e
	
	# R: Hall of Mirrors
	var r = AbilityResource.new()
	r.id = "zin_r"
	r.ability_name = "Hall of Mirrors"
	r.target_type = AbilityResource.TargetType.SELF
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.2
	r.base_damage.assign([250.0, 375.0, 500.0])
	r.cooldowns.assign([80.0, 68.0, 56.0])
	r.mana_costs.assign([100.0, 120.0, 140.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
