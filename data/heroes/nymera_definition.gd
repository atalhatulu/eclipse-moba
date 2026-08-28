class_name NymeraDefinition
extends RefCounted

## Static data definition and archetype resource for Nymera (INT/AGI Chrono Weaver / Temporal Rewind)

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "nymera"
	hero.id = "nymera"
	hero.hero_name = "Nymera"
	hero.role = "Büyücü / Zaman Dokuyucusu"
	hero.role_description = "Chrono Weaver / Temporal Controller (INT/AGI)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.INTELLIGENCE
	hero.attack_type = HeroResource.AttackType.RANGED
	
	# Base Attributes & Growths
	hero.base_intelligence = 26.0
	hero.intelligence_growth = 3.1
	hero.base_agility = 22.0
	hero.agility_growth = 2.4
	hero.base_strength = 17.0
	hero.strength_growth = 1.7
	
	# Base Combat Stats
	hero.base_health = 540.0
	hero.base_health_regen = 1.8
	hero.base_mana = 420.0
	hero.base_mana_regen = 2.4
	hero.base_attack_damage = 47.0
	hero.base_ability_power = 0.0
	hero.base_armor = 18.0
	hero.base_magic_resist = 30.0
	hero.base_attack_speed = 0.70
	hero.base_move_speed = 320.0
	hero.base_attack_range = 575.0
	
	# Passive: Echo Time (Timeline Recording)
	var passive = AbilityDefinition.new()
	passive.id = "nymera_passive"
	passive.ability_name = "Zaman Yankısı (Echo Time)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Nymera savaş alanındaki tüm kahramanların son 4 saniyelik konum ve durum izlerini zaman çizgisine kaydeder."
	hero.passive_ability = passive
	
	# Q: Slow Field (Temporal Distortion)
	var q = AbilityDefinition.new()
	q.id = "nymera_q"
	q.ability_name = "Zaman Bükümü (Slow Field)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.GROUND_AOE
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Hedef alanda 3.5 saniye süren 5.0m zaman bükümü açar. Düşmanları %35 yavaşlatır ve saniye başı büyü hasarı vurur."
	q.cooldowns.assign([10.0, 9.5, 9.0, 8.5])
	q.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	q.base_damage.assign([30.0, 50.0, 70.0, 90.0]) # Per sec
	q.cast_range = 650.0
	q.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	q.scaling_ratio = 0.30
	q.damage_type = DamageRequest.DamageType.MAGICAL
	hero.q_ability = q
	
	# W: Rewind (Temporal Reversal)
	var w = AbilityDefinition.new()
	w.id = "nymera_w"
	w.ability_name = "Zamanı Geri Sar (Rewind)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SINGLE_TARGET
	w.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	w.description = "Hedef düşman kahramanı 3 saniye önceki konumuna geri fırlatır, büyü hasarı verir ve odaklanmasını bozar."
	w.cooldowns.assign([16.0, 14.5, 13.0, 11.5])
	w.mana_costs.assign([80.0, 85.0, 90.0, 95.0])
	w.base_damage.assign([80.0, 130.0, 180.0, 230.0])
	w.cast_range = 600.0
	w.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	w.scaling_ratio = 0.65
	w.damage_type = DamageRequest.DamageType.MAGICAL
	hero.w_ability = w
	
	# E: Accelerate (Time Haste)
	var e = AbilityDefinition.new()
	e.id = "nymera_e"
	e.ability_name = "Zaman İvmesi (Accelerate)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.target_filter = AbilityResource.TargetFilter.ALLIES_ONLY
	e.description = "Hedef dosta 4 saniye boyunca %30 Hareket Hızı, %25 Saldırı Hızı ve yetenek bekleme sürelerinde anlık 2.0 saniye hızlanma sağlar."
	e.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	e.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	e.cast_range = 650.0
	hero.e_ability = e
	
	# R: Temporal Collapse (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "nymera_r"
	r.ability_name = "Zaman Çöküşü (Temporal Collapse)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	r.max_level = 3
	r.description = "Hedef 6.0m alandaki zamanı çökerterek tüm düşmanları 3 saniye önceki konumlarına geri sarar, ağır büyü hasarı vurur ve 1.2 saniye yere sabitler (Root)."
	r.cooldowns.assign([90.0, 75.0, 60.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	r.base_damage.assign([200.0, 320.0, 440.0])
	r.cast_range = 750.0
	r.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	r.scaling_ratio = 0.80
	r.damage_type = DamageRequest.DamageType.MAGICAL
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
