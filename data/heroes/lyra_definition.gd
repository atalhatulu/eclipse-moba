class_name LyraDefinition
extends RefCounted

## Lyra - The Bounty Tracker

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "lyra"
	res.hero_name = "Lyra"
	res.title = "The Bounty Tracker"
	res.lore = "A tactical recon scout armed with dual mini-crossbows and grappling hooks who marks high-priority targets for team bounty."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.AGILITY
	
	res.base_strength = 17.0
	res.strength_growth = 1.9
	res.base_agility = 24.0
	res.agility_growth = 3.0
	res.base_intelligence = 19.0
	res.intelligence_growth = 2.2
	
	res.base_health = 580.0
	res.base_health_regen = 2.2
	res.base_mana = 320.0
	res.base_mana_regen = 2.0
	res.base_attack_damage = 50.0
	res.base_ability_power = 0.0
	res.base_armor = 25.0
	res.base_magic_resist = 26.0
	res.base_attack_speed = 1.05
	res.base_move_speed = 320.0
	res.base_attack_range = 575.0
	
	# Passive: Ethereal Symbiosis
	var passive = AbilityResource.new()
	passive.id = "lyra_passive"
	passive.ability_name = "Eterik Ortak Yaşam (Ethereal Symbiosis)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.description = "Lyra bağlı olduğu müttefikle can yenilenmesini paylaşır; kazandığı tüm iyileştirmelerin %150'sini bağlı müttefike aktarır."
	res.passive_ability = passive
	
	# Q: Ethereal Tether
	var q = AbilityResource.new()
	q.id = "lyra_q"
	q.ability_name = "Eterik Bağ (Ethereal Tether)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ALLIES_ONLY
	q.cooldowns.assign([12.0, 10.0, 8.0, 6.0])
	q.mana_costs.assign([40.0, 45.0, 50.0, 55.0])
	q.cast_range = 800.0
	q.description = "Dost bir şampiyona ışık bağı kurar; müttefike +%20 Hız verir, bağ ipinden geçen düşmanları yavaşlatır ve hasar vurur."
	res.q_ability = q
	
	# W: Soul Infusion
	var w = AbilityResource.new()
	w.id = "lyra_w"
	w.ability_name = "Ruh Aşısı (Soul Infusion)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SELF
	w.cooldowns.assign([8.0, 7.0, 6.0, 5.0])
	w.mana_costs.assign([40.0, 45.0, 50.0, 55.0])
	w.description = "Kendi canının %15'ini feda ederek bağlı müttefike anında büyük bir can yenilenmesi ve +%30 Saldırı Hızı aşılar."
	res.w_ability = w
	
	# E: Astral Pull
	var e = AbilityResource.new()
	e.id = "lyra_e"
	e.ability_name = "Astral Çekim (Astral Pull)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SELF
	e.damage_type = DamageRequest.DamageType.MAGICAL
	e.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	e.scaling_ratio = 0.65
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.cooldowns.assign([11.0, 10.0, 9.0, 8.0])
	e.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	e.description = "Lyra bağlı müttefikine doğru hızla fırlar (Dash); vardığı yerdeki düşmanlara hasar verir ve 1.0s sersemletir."
	res.e_ability = e
	
	# R: Cosmic Relocate (Ultimate)
	var r = AbilityResource.new()
	r.id = "lyra_r"
	r.ability_name = "Kozmik Yer Değiştirme (Cosmic Relocate)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.cooldowns.assign([90.0, 75.0, 60.0])
	r.mana_costs.assign([100.0, 100.0, 100.0])
	r.cast_range = 1400.0
	r.description = "Lyra ve bağlı olduğu müttefik 3.5 saniye sonra haritadaki hedef noktaya birlikte ışınlanır; 10 saniye sonra güvenli noktaya geri dönerler."
	res.r_ability = r
	res.abilities.assign([passive, q, w, e, r])
	
	return res
