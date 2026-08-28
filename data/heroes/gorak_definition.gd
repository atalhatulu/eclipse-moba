class_name GorakDefinition
extends RefCounted

## Static data definition and archetype resource for Gorak (STR Anti-Carry / Stat Drainer)

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "gorak"
	hero.id = "gorak"
	hero.hero_name = "Gorak"
	hero.role = "Anti-Taşıyıcı / Dövüşçü"
	hero.role_description = "Anti-Carry / Stat Drainer (STR)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	hero.attack_type = HeroResource.AttackType.MELEE
	
	# Base Attributes & Growths
	hero.base_strength = 26.0
	hero.strength_growth = 3.3
	hero.base_agility = 16.0
	hero.agility_growth = 1.6
	hero.base_intelligence = 16.0
	hero.intelligence_growth = 1.4
	
	# Base Combat Stats
	hero.base_health = 620.0
	hero.base_health_regen = 2.5
	hero.base_mana = 260.0
	hero.base_mana_regen = 1.2
	hero.base_attack_damage = 46.0
	hero.base_ability_power = 0.0
	hero.base_armor = 24.0
	hero.base_magic_resist = 30.0
	hero.base_attack_speed = 0.66
	hero.base_move_speed = 310.0
	hero.base_attack_range = 175.0
	
	# Passive: Leeching Might (Innate)
	var passive = AbilityDefinition.new()
	passive.id = "gorak_passive"
	passive.ability_name = "Sömürücü Kudret (Leeching Might)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Temel saldırılar hedef düşmanın Saldırı Gücünü (AD) %15 azaltır ve çalınan değeri 4 saniye boyunca Gorak'a aktarır."
	hero.passive_ability = passive
	
	# Q: Rend
	var q = AbilityDefinition.new()
	q.id = "gorak_q"
	q.ability_name = "Parçala (Rend)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Hedefe güçlü bir darbe indirir. Çalınan veya hedefin sahip olduğu bonus saldırı gücüne göre ek hasar verir."
	q.cooldowns.assign([7.0, 6.5, 6.0, 5.5])
	q.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	q.base_damage.assign([85.0, 135.0, 185.0, 235.0])
	q.cast_range = 250.0
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.80
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.q_ability = q
	
	# W: Drain Strength
	var w = AbilityDefinition.new()
	w.id = "gorak_w"
	w.ability_name = "Güç Sömürüsü (Drain Strength)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SINGLE_TARGET
	w.target_filter = AbilityResource.TargetFilter.ENEMY_HEROES_ONLY
	w.description = "Hedef düşman kahramanın Saldırı Gücünü 5 saniye boyunca %30 azaltır ve aynı miktarı Gorak'a bonus AD olarak verir."
	w.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	w.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	w.cast_range = 400.0
	hero.w_ability = w
	
	# E: Feed
	var e = AbilityDefinition.new()
	e.id = "gorak_e"
	e.ability_name = "Beslen (Feed)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SELF
	e.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	e.description = "Çalınan saldırı gücünü ve sömürülen enerjiyi tüketerek Gorak'ın canını anında yeniler (Taban + Çalınan AD * 2.5)."
	e.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	e.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	hero.e_ability = e
	
	# R: Devour Champion (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "gorak_r"
	r.ability_name = "Şampiyonu Yut (Devour Champion)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.SINGLE_TARGET
	r.target_filter = AbilityResource.TargetFilter.ENEMY_HEROES_ONLY
	r.max_level = 3
	r.description = "Yalnızca düşman kahramanlara kullanılabilir. 6 saniye boyunca hedefin Saldırı Gücünün ve Zırhının %40'ını çalar ve hedefe ağır hasar verir."
	r.cooldowns.assign([80.0, 70.0, 60.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	r.base_damage.assign([200.0, 320.0, 440.0])
	r.cast_range = 350.0
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.00
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
