class_name GerasDefinition
extends RefCounted

## Geras - The Tectonic Architect

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "geras"
	res.hero_name = "Geras"
	res.title = "The Tectonic Architect"
	res.lore = "A scholar earth mage with hands of tectonic granite who constructs impassable walls and opens deep tectonic rift fault lines dividing the battlefield."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.INTELLIGENCE
	
	res.base_strength = 23.0
	res.strength_growth = 2.6
	res.base_agility = 12.0
	res.agility_growth = 1.2
	res.base_intelligence = 27.0
	res.intelligence_growth = 3.4
	
	res.base_health = 640.0
	res.base_health_regen = 2.8
	res.base_mana = 360.0
	res.base_mana_regen = 2.4
	res.base_attack_damage = 52.0
	res.base_ability_power = 20.0
	res.base_armor = 30.0
	res.base_magic_resist = 30.0
	res.base_attack_speed = 0.8
	res.base_move_speed = 300.0
	res.base_attack_range = 500.0
	
	# Passive: Granite Core
	var passive = AbilityResource.new()
	passive.id = "geras_passive"
	passive.ability_name = "Granit Çekirdek (Granite Core)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.description = "Geras yer büyüleri kullandığında 4 saniyeliğine %15 azami canına denk Granit Kalkanı kazanır ve etrafındaki zemini sarsar."
	res.passive_ability = passive
	
	# Q: Raise Earth (Granite Wall)
	var q = AbilityResource.new()
	q.id = "geras_q"
	q.ability_name = "Toprak Duvarı Yükselt (Raise Earth)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.GROUND_AOE
	q.damage_type = DamageRequest.DamageType.MAGICAL
	q.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	q.scaling_ratio = 0.80
	q.base_damage.assign([80.0, 130.0, 180.0, 230.0])
	q.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	q.mana_costs.assign([65.0, 70.0, 75.0, 80.0])
	q.cast_range = 650.0
	q.description = "Hedef noktada 5.0m genişliğinde fiziksel Granit Taş Duvarı diker (6s); düşman geçişini ve atışlarını engeller, altındakileri havaya savurur."
	res.q_ability = q
	
	# W: Tectonic Collapse
	var w = AbilityResource.new()
	w.id = "geras_w"
	w.ability_name = "Tektonik Çöküş (Tectonic Collapse)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.GROUND_AOE
	w.damage_type = DamageRequest.DamageType.MAGICAL
	w.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	w.scaling_ratio = 0.85
	w.base_damage.assign([90.0, 140.0, 190.0, 240.0])
	w.cooldowns.assign([9.0, 8.0, 7.0, 6.0])
	w.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	w.cast_range = 600.0
	w.description = "Hedef alandaki zemini çökerterek 4.0m alandaki düşmanları merkeze çeker, hasar verir ve 1.2s sersemletir."
	res.w_ability = w
	
	# E: Quicksand
	var e = AbilityResource.new()
	e.id = "geras_e"
	e.ability_name = "Bataklık Kumu (Quicksand)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.GROUND_AOE
	e.damage_type = DamageRequest.DamageType.MAGICAL
	e.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	e.scaling_ratio = 0.60
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.cooldowns.assign([13.0, 12.0, 11.0, 10.0])
	e.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	e.cast_range = 600.0
	e.description = "Yere 5.0m genişliğinde dönen kum girdabı serer; içindeki düşmanları %50 yavaşlatır ve hasar verir."
	res.e_ability = e
	
	# R: Tectonic Fissure (Ultimate)
	var r = AbilityResource.new()
	r.id = "geras_r"
	r.ability_name = "Tektonik Fay Hattı (Tectonic Fissure)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.damage_type = DamageRequest.DamageType.MAGICAL
	r.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	r.scaling_ratio = 1.20
	r.base_damage.assign([240.0, 360.0, 480.0])
	r.cooldowns.assign([90.0, 75.0, 60.0])
	r.mana_costs.assign([120.0, 145.0, 170.0])
	r.cast_range = 1400.0
	r.description = "Savaş alanını 14 metre boyunca ikiye bölen devasa bir Fay Hattı açar; düşmanları savurur, hasar verir ve geçişi %70 yavaşlatır."
	res.r_ability = r
	res.abilities.assign([passive, q, w, e, r])
	
	return res
