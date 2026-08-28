class_name OrynDefinition
extends RefCounted

## Static data definition and archetype resource for Oryn (INT Resonant Enchanter / Debuff Purger)

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "oryn"
	hero.id = "oryn"
	hero.hero_name = "Oryn"
	hero.role = "Destek / Rezonans Büyücüsü"
	hero.role_description = "Resonant Enchanter / Debuff Purger (INT)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.INTELLIGENCE
	hero.attack_type = HeroResource.AttackType.RANGED
	
	# Base Attributes & Growths
	hero.base_intelligence = 25.0
	hero.intelligence_growth = 2.8
	hero.base_strength = 22.0
	hero.strength_growth = 2.3
	hero.base_agility = 16.0
	hero.agility_growth = 1.5
	
	# Base Combat Stats
	hero.base_health = 610.0
	hero.base_health_regen = 2.5
	hero.base_mana = 340.0
	hero.base_mana_regen = 1.8
	hero.base_attack_damage = 52.0
	hero.base_ability_power = 0.0
	hero.base_armor = 23.0
	hero.base_magic_resist = 30.0
	hero.base_attack_speed = 0.66
	hero.base_move_speed = 320.0
	hero.base_attack_range = 550.0
	
	# Passive: Resonance
	var passive = AbilityDefinition.new()
	passive.id = "oryn_passive"
	passive.ability_name = "Rezonans (Resonance)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Dost birimleri iyileştirmek veya kalkanlamak Rezonans yükü kazandırır (azami 5 yük). Her yük +6 YG ve +%3 iyileştirme/kalkan gücü sağlar."
	hero.passive_ability = passive
	
	# Q: Mend (Harmonic Mend)
	var q = AbilityDefinition.new()
	q.id = "oryn_q"
	q.ability_name = "Uyumlu İyileştirme (Mend)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ALLIES_ONLY
	q.description = "Hedef dost birimi iyileştirir ve 1 Rezonans yükü kazandırır."
	q.cooldowns.assign([8.0, 7.5, 7.0, 6.5])
	q.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	q.base_damage.assign([80.0, 140.0, 200.0, 260.0]) # Heal value
	q.cast_range = 600.0
	q.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	q.scaling_ratio = 0.60
	hero.q_ability = q
	
	# W: Empower (Harmonic Surge)
	var w = AbilityDefinition.new()
	w.id = "oryn_w"
	w.ability_name = "Güçlendirme (Empower)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SINGLE_TARGET
	w.target_filter = AbilityResource.TargetFilter.ALLIES_ONLY
	w.description = "Hedef dost birime 4 saniye boyunca ilave Saldırı Gücü/Yetenek Gücü ve +%20 Saldırı Hızı sağlar."
	w.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	w.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	w.cast_range = 600.0
	hero.w_ability = w
	
	# E: Transfer (Purge & Inflict)
	var e = AbilityDefinition.new()
	e.id = "oryn_e"
	e.ability_name = "Aktarım (Transfer)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.target_filter = AbilityResource.TargetFilter.ALLIES_ONLY
	e.description = "Hedef dost birimdeki bir zayıflatmayı (debuff) temizler ve en yakındaki düşman birime büyü hasarıyla birlikte aktarır."
	e.cooldowns.assign([13.0, 12.0, 11.0, 10.0])
	e.mana_costs.assign([70.0, 75.0, 80.0, 85.0])
	e.base_damage.assign([60.0, 100.0, 140.0, 180.0])
	e.cast_range = 600.0
	e.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	e.scaling_ratio = 0.50
	e.damage_type = DamageRequest.DamageType.MAGICAL
	hero.e_ability = e
	
	# R: Resonant Bond (Harmonic Link - Ultimate)
	var r = AbilityDefinition.new()
	r.id = "oryn_r"
	r.ability_name = "Rezonans Bağı (Resonant Bond)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.SINGLE_TARGET
	r.target_filter = AbilityResource.TargetFilter.ALLIES_ONLY
	r.max_level = 3
	r.description = "Hedef dost kahraman ile 7 saniyelik bağ kurar. Hedefin aldığı hasarın %25'ini Oryn üstlenir ve her iki hedefin aldığı iyileştirmeler %60 verimle paylaşılır."
	r.cooldowns.assign([80.0, 70.0, 60.0])
	r.mana_costs.assign([100.0, 100.0, 100.0])
	r.cast_range = 650.0
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
