class_name NixeDefinition
extends RefCounted

## Nixe - The Wall-Crawler

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "nixe"
	res.hero_name = "Nixe"
	res.title = "The Wall-Crawler"
	res.lore = "A feral arachnid ambusher who scales natural cliffs and pounces from high walls upon unsuspecting prey."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.AGILITY
	
	res.base_strength = 19.0
	res.strength_growth = 2.1
	res.base_agility = 25.0
	res.agility_growth = 3.3
	res.base_intelligence = 16.0
	res.intelligence_growth = 1.6
	
	res.base_health = 580.0
	res.base_health_regen = 2.4
	res.base_mana = 280.0
	res.base_mana_regen = 1.6
	res.base_attack_damage = 56.0
	res.base_ability_power = 0.0
	res.base_armor = 27.0
	res.base_magic_resist = 25.0
	res.base_attack_speed = 1.06
	res.base_move_speed = 320.0
	res.base_attack_range = 160.0
	
	# Q: Pounce
	var q = AbilityResource.new()
	q.id = "nixe_q"
	q.ability_name = "Pounce"
	q.target_type = AbilityResource.TargetType.DIRECTIONAL
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.95
	q.base_damage.assign([85.0, 135.0, 185.0, 235.0])
	q.cooldowns.assign([8.0, 7.5, 7.0, 6.5])
	q.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	q.cast_range = 500.0
	res.q_ability = q
	
	# W: Acid Spit
	var w = AbilityResource.new()
	w.id = "nixe_w"
	w.ability_name = "Acid Spit"
	w.target_type = AbilityResource.TargetType.DIRECTIONAL
	w.damage_type = DamageRequest.DamageType.MAGICAL
	w.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	w.scaling_ratio = 0.65
	w.base_damage.assign([70.0, 115.0, 160.0, 205.0])
	w.cooldowns.assign([9.0, 8.0, 7.0, 6.0])
	w.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	res.w_ability = w
	
	# E: Skitter
	var e = AbilityResource.new()
	e.id = "nixe_e"
	e.ability_name = "Skitter"
	e.target_type = AbilityResource.TargetType.SELF
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.6
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	e.mana_costs.assign([45.0, 50.0, 55.0, 60.0])
	res.e_ability = e
	
	# R: Apex Predator
	var r = AbilityResource.new()
	r.id = "nixe_r"
	r.ability_name = "Apex Predator"
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.25
	r.base_damage.assign([240.0, 360.0, 480.0])
	r.cooldowns.assign([85.0, 70.0, 55.0])
	r.mana_costs.assign([100.0, 120.0, 140.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
