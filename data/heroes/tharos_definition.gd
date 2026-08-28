class_name TharosDefinition
extends RefCounted

## Static data definition and archetype resource for Tharos (STR Juggernaut)

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "tharos"
	hero.id = "tharos"
	hero.hero_name = "Tharos"
	hero.role = "Juggernaut / Dayanıklı Savaşçı"
	hero.role_description = "Juggernaut (STR Tank / Fighter)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	hero.attack_type = HeroResource.AttackType.MELEE
	
	# Base Attributes & Growths
	hero.base_strength = 27.0
	hero.strength_growth = 3.6
	hero.base_agility = 14.0
	hero.agility_growth = 1.3
	hero.base_intelligence = 15.0
	hero.intelligence_growth = 1.4
	
	# Base Combat Stats
	hero.base_health = 640.0
	hero.base_health_regen = 3.0
	hero.base_mana = 260.0
	hero.base_mana_regen = 1.5
	hero.base_attack_damage = 44.0
	hero.base_ability_power = 0.0
	hero.base_armor = 22.0
	hero.base_magic_resist = 28.0
	hero.base_attack_speed = 0.64
	hero.base_move_speed = 305.0
	hero.base_attack_range = 160.0
	
	# Passive: Living Mass (Innate)
	var passive = AbilityDefinition.new()
	passive.id = "tharos_passive"
	passive.ability_name = "Canlı Kütle (Living Mass)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Tharos, sahip olduğu her bonus Can puanının %2.5'ini Saldırı Gücüne (AD) dönüştürür."
	hero.passive_ability = passive
	
	# Q: Groundbreaker
	var q = AbilityDefinition.new()
	q.id = "tharos_q"
	q.ability_name = "Yerkıran (Groundbreaker)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.GROUND_AOE
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Yakın çevredeki tüm düşmanlara fiziksel hasar verir. Tharos'un Canı azaldıkça sersemletme süresi 1.75 saniyeye kadar uzar."
	q.cooldowns.assign([8.0, 7.5, 7.0, 6.5])
	q.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	q.base_damage.assign([80.0, 130.0, 180.0, 230.0])
	q.cast_range = 320.0
	q.aoe_radius = 320.0
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.70
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.q_ability = q
	
	# W: Bulkhead
	var w = AbilityDefinition.new()
	w.id = "tharos_w"
	w.ability_name = "Gövde Kalkanı (Bulkhead)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SELF
	w.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	w.description = "4 saniye boyunca gelen tüm hasarları %35 azaltır, ancak hareket hızı %20 düşer."
	w.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	w.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	hero.w_ability = w
	
	# E: Crushing Step
	var e = AbilityDefinition.new()
	e.id = "tharos_e"
	e.ability_name = "Ezici Adım (Crushing Step)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.GROUND_AOE
	e.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	e.description = "Hedef konuma güçlü bir sıçrayış yapar. İniş anında etraftaki düşmanlara fiziksel hasar verir ve onları 1.5 saniye %40 yavaşlatır."
	e.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	e.mana_costs.assign([65.0, 70.0, 75.0, 80.0])
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.cast_range = 600.0
	e.aoe_radius = 300.0
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.50
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	e.applies_status_effect = true
	e.effect_type = StatusEffect.EffectType.SLOW
	e.effect_duration = 1.5
	e.effect_intensity = 0.40
	hero.e_ability = e
	
	# R: Colossus (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "tharos_r"
	r.ability_name = "Devleşme (Colossus)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.SELF
	r.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	r.max_level = 3
	r.description = "Tharos 10 saniye devasa boyuta ulaşır: Maksimum Canı (+500/+800/+1100) ve saldırı menzili (+75) artar, hareket hızı %15 azalır."
	r.cooldowns.assign([90.0, 80.0, 70.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
