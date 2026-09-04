class_name SeraDefinition
extends RefCounted

## Sera - The Astral Weaver (INT Enchanter / Cleanse & Momentum Support)

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "sera"
	res.id = "sera"
	res.hero_name = "Sera"
	res.title = "Karmik Efsuncu (The Astral Weaver)"
	res.role = "Destek / Efsuncu"
	res.role_description = "Astral Enchanter / Cleanse & Momentum Support (INT)"
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.INTELLIGENCE
	res.attack_type = HeroResource.AttackType.RANGED
	
	# Base Attributes & Growths
	res.base_strength = 18.0
	res.strength_growth = 1.9
	res.base_agility = 16.0
	res.agility_growth = 1.5
	res.base_intelligence = 28.0
	res.intelligence_growth = 3.6
	
	# Combat Stats
	res.base_health = 540.0
	res.base_health_regen = 2.0
	res.base_mana = 420.0
	res.base_mana_regen = 2.8
	res.base_attack_damage = 44.0
	res.base_ability_power = 0.0
	res.base_armor = 21.0
	res.base_magic_resist = 28.0
	res.base_attack_speed = 0.68
	res.base_move_speed = 315.0
	res.base_attack_range = 575.0
	
	# Passive: Karmic Flow (Innate)
	var passive = AbilityResource.new()
	passive.id = "sera_passive"
	passive.ability_name = "Karmik Akış (Karmic Flow)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Sera müttefiklerine yetenek uyguladığında onlara 3 saniye boyunca +%15 Saldırı Hızı kazandırır."
	res.passive_ability = passive
	
	# Q: Thread of Fate
	var q = AbilityResource.new()
	q.id = "sera_q"
	q.ability_name = "Kader Bağı (Thread of Fate)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ALL_UNITS
	q.description = "Düşmana büyü hasarı vurarak %35 yavaşlatır; dost birime kullanılırsa +%25 Hareket Hızı kazandırır."
	q.cooldowns.assign([7.0, 6.5, 6.0, 5.5])
	q.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	q.base_damage.assign([75.0, 120.0, 165.0, 210.0])
	q.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	q.scaling_ratio = 0.65
	q.cast_range = 600.0
	q.damage_type = DamageRequest.DamageType.MAGICAL
	res.q_ability = q
	
	# W: Astral Ward
	var w = AbilityResource.new()
	w.id = "sera_w"
	w.ability_name = "Yıldız Kalkanı (Astral Ward)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SINGLE_TARGET
	w.target_filter = AbilityResource.TargetFilter.ALLIES_ONLY
	w.description = "Hedef dosta 3.5 saniye süren 100/160/220/280 (+%60 AP) büyü kalkanı kazandırır."
	w.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	w.mana_costs.assign([60.0, 70.0, 80.0, 90.0])
	w.base_damage.assign([100.0, 160.0, 220.0, 280.0])
	w.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	w.scaling_ratio = 0.60
	w.cast_range = 650.0
	w.damage_type = DamageRequest.DamageType.MAGICAL
	res.w_ability = w
	
	# E: Purify
	var e = AbilityResource.new()
	e.id = "sera_e"
	e.ability_name = "Arındırma (Purify)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.target_filter = AbilityResource.TargetFilter.ALLIES_ONLY
	e.description = "Hedef dostun üzerindeki tüm sersemletme, susturma ve yavaşlatma etkilerini anında temizler ve onu iyileştirir."
	e.cooldowns.assign([13.0, 12.0, 11.0, 10.0])
	e.mana_costs.assign([65.0, 75.0, 85.0, 95.0])
	e.base_damage.assign([80.0, 130.0, 180.0, 230.0])
	e.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	e.scaling_ratio = 0.50
	e.cast_range = 650.0
	e.damage_type = DamageRequest.DamageType.MAGICAL
	res.e_ability = e
	
	# R: Astral Surge (Ultimate)
	var r = AbilityResource.new()
	r.id = "sera_r"
	r.ability_name = "Yıldız Dalgası (Astral Surge)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.SELF
	r.target_filter = AbilityResource.TargetFilter.ALLIES_ONLY
	r.max_level = 3
	r.description = "8 metre çapındaki alanda tüm müttefiklerin kitle kontrollerini anında temizler, 2.5 saniye kitle kontrolü bağışıklığı ve +%45 Hareket Hızı aurası yayar."
	r.cooldowns.assign([85.0, 75.0, 65.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	r.base_damage.assign([0.0, 0.0, 0.0])
	r.cast_range = 800.0
	r.damage_type = DamageRequest.DamageType.MAGICAL
	res.r_ability = r
	
	res.abilities.assign([passive, q, w, e, r])
	return res
