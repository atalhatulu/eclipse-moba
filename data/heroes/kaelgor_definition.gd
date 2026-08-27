class_name KaelgorDefinition
extends RefCounted

## Central data definition for Kaelgor (The Furnace Heart / Bruiser)

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "kaelgor"
	hero.hero_name = "Kaelgor"
	hero.role = "Dövüşçü / Tank"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	
	# Primary Attributes & Growths
	hero.base_strength = 25.0
	hero.strength_growth = 3.2
	hero.base_agility = 18.0
	hero.agility_growth = 1.8
	hero.base_intelligence = 16.0
	hero.intelligence_growth = 1.5
	
	# Base Combat Stats
	hero.base_health = 580.0
	hero.base_health_regen = 2.4
	hero.base_mana = 260.0
	hero.base_mana_regen = 1.3
	hero.base_attack_damage = 48.0
	hero.base_ability_power = 0.0
	hero.base_armor = 23.0
	hero.base_magic_resist = 29.0
	hero.base_attack_speed = 0.68
	hero.base_move_speed = 315.0
	hero.base_attack_range = 150.0
	
	# Passive: Furnace Heart
	var passive = AbilityResource.new()
	passive.id = "kaelgor_passive"
	passive.ability_name = "Ocak Kalbi (Furnace Heart)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Hasar aldıkça İç Isı (Heat) biriktirir. Biriken Isı saldırı hızını artırır ve yetenekleri güçlendirir."
	hero.passive_ability = passive
	
	# Q: Molten Fist
	var q = AbilityResource.new()
	q.id = "kaelgor_q"
	q.ability_name = "Erimiş Yumruk (Molten Fist)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Hedef düşmana akkor lav gücüyle vurarak fiziksel hasar verir. Mevcut Isı oranına göre hasarı katlanır."
	q.cooldowns.assign([6.0, 5.5, 5.0, 4.5])
	q.mana_costs.assign([50.0, 60.0, 70.0, 80.0])
	q.base_damage.assign([80.0, 130.0, 180.0, 230.0])
	q.cast_range = 550.0
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.70
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.q_ability = q
	
	# W: Vent
	var w = AbilityResource.new()
	w.id = "kaelgor_w"
	w.ability_name = "Buhar Tahliyesi (Vent)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.GROUND_AOE
	w.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	w.description = "Etrafındaki alana kızgın buhar salarak düşmanları yakar, büyüsel hasar verir ve onları %30 yavaşlatır."
	w.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	w.mana_costs.assign([60.0, 70.0, 80.0, 90.0])
	w.base_damage.assign([60.0, 100.0, 140.0, 180.0])
	w.cast_range = 450.0
	w.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	w.scaling_ratio = 0.50
	w.damage_type = DamageRequest.DamageType.MAGICAL
	w.applies_status_effect = true
	w.effect_type = StatusEffect.EffectType.SLOW
	w.effect_duration = 2.5
	w.effect_intensity = 0.30
	hero.w_ability = w
	
	# E: Iron Hide
	var e = AbilityResource.new()
	e.id = "kaelgor_e"
	e.ability_name = "Demir Zırh (Iron Hide)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SELF
	e.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	e.description = "4.0 saniye boyunca zırhını sertleştirerek gelen hasarı %30 azaltır ve engellenen hasardan Isı üretir."
	e.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	e.mana_costs.assign([40.0, 45.0, 50.0, 55.0])
	e.base_damage.assign([0.0, 0.0, 0.0, 0.0])
	e.cast_range = 0.0
	hero.e_ability = e
	
	# R: Overheat (Ultimate)
	var r = AbilityResource.new()
	r.id = "kaelgor_r"
	r.ability_name = "Aşırı Isınma (Overheat)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.SELF
	r.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	r.max_level = 3
	r.description = "Isısını anında maksimuma ulaştırır. 8 saniye boyunca temel saldırıları alana sıçrayan lav patlamaları saçar."
	r.cooldowns.assign([80.0, 70.0, 60.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	r.base_damage.assign([150.0, 250.0, 350.0])
	r.cast_range = 0.0
	hero.r_ability = r
	hero.abilities.assign([passive, q, w, e, r])
	
	return hero
