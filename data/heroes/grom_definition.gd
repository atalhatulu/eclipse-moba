class_name GromDefinition
extends RefCounted

## Grom - The Heavy Harpooner (Ranged STR Siege / Anchor)

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "grom"
	res.hero_name = "Grom"
	res.title = "The Heavy Harpooner"
	res.lore = "A scarred whaler from the abyssal tides wielding a massive pneumatic mechanical harpoon."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	
	# Base Attributes & Growths
	res.base_strength = 27.0
	res.strength_growth = 3.6
	res.base_agility = 12.0
	res.agility_growth = 1.2
	res.base_intelligence = 14.0
	res.intelligence_growth = 1.4
	
	# Combat Stats
	res.base_health = 680.0
	res.base_health_regen = 3.5
	res.base_mana = 260.0
	res.base_mana_regen = 1.2
	res.base_attack_damage = 62.0
	res.base_ability_power = 0.0
	res.base_armor = 30.0
	res.base_magic_resist = 27.0
	res.base_attack_speed = 0.85
	res.base_move_speed = 305.0
	res.base_attack_range = 550.0
	
	# Q: Harpoon
	var q = AbilityResource.new()
	q.id = "grom_q"
	q.ability_name = "Harpoon"
	q.description = "Launches a heavy harpoon, dealing physical damage and impaling the enemy, pulling them to an anchor point."
	q.target_type = AbilityResource.TargetType.DIRECTIONAL
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.85
	q.base_damage.assign([90.0, 140.0, 190.0, 240.0])
	q.cooldowns.assign([11.0, 10.0, 9.0, 8.0])
	q.mana_costs.assign([65.0, 75.0, 85.0, 95.0])
	q.cast_range = 750.0
	res.q_ability = q
	
	# W: Barricade
	var w = AbilityResource.new()
	w.id = "grom_w"
	w.ability_name = "Barricade"
	w.description = "Slams the harpoon anchor into the earth, creating a fortified barricade that grants a heavy shield."
	w.target_type = AbilityResource.TargetType.SELF
	w.effect_duration = 4.5
	w.cooldowns.assign([16.0, 15.0, 14.0, 13.0])
	w.mana_costs.assign([60.0, 70.0, 80.0, 90.0])
	res.w_ability = w
	
	# E: Harpoon Vault
	var e = AbilityResource.new()
	e.id = "grom_e"
	e.ability_name = "Harpoon Vault"
	e.description = "Vaults backward with tremendous momentum while firing a concussive shockwave forward."
	e.target_type = AbilityResource.TargetType.DIRECTIONAL
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.60
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.cooldowns.assign([13.0, 12.0, 11.0, 10.0])
	e.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	res.e_ability = e
	
	# R: Leviathan's Catch
	var r = AbilityResource.new()
	r.id = "grom_r"
	r.ability_name = "Leviathan's Catch"
	r.description = "Fires a colossal oceanic dragnet across the battlefield, dragging all enemies within radius to the epicenter and crushing them."
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.25
	r.base_damage.assign([250.0, 375.0, 500.0])
	r.aoe_radius = 450.0
	r.cooldowns.assign([100.0, 85.0, 70.0])
	r.mana_costs.assign([125.0, 150.0, 175.0])
	res.r_ability = r
	res.abilities.assign([q, w, e, r])
	
	return res
