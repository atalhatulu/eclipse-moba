class_name NyxaraDefinition
extends RefCounted

## Static data definition and archetype resource for Nyxara (AGI Assassin / Veil Marks & Vanish)

const AbilityDefinition = preload("res://core/abilities/ability_definition.gd")

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "nyxara"
	hero.id = "nyxara"
	hero.hero_name = "Nyxara"
	hero.role = "Suikastçı / Gölge Bıçağı"
	hero.role_description = "Assassin / Veil Marks & Vanish (AGI)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.AGILITY
	hero.attack_type = HeroResource.AttackType.MELEE
	
	# Base Attributes & Growths
	hero.base_agility = 25.0
	hero.agility_growth = 3.2
	hero.base_strength = 18.0
	hero.strength_growth = 1.8
	hero.base_intelligence = 18.0
	hero.intelligence_growth = 1.8
	
	# Base Combat Stats
	hero.base_health = 560.0
	hero.base_health_regen = 1.8
	hero.base_mana = 290.0
	hero.base_mana_regen = 1.5
	hero.base_attack_damage = 52.0
	hero.base_ability_power = 0.0
	hero.base_armor = 22.0
	hero.base_magic_resist = 28.0
	hero.base_attack_speed = 0.72
	hero.base_move_speed = 325.0
	hero.base_attack_range = 175.0
	
	# Passive: Veil Marks (Innate)
	var passive = AbilityDefinition.new()
	passive.id = "nyxara_passive"
	passive.ability_name = "Gölge Damgası (Veil Marks)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Yetenek hasarları düşmanlara 6 saniye süren Gölge Damgası bırakır (azami 3 yük). Her yük hedefin zırhını %5 azaltır."
	hero.passive_ability = passive
	
	# Q: Needle
	var q = AbilityDefinition.new()
	q.id = "nyxara_q"
	q.ability_name = "Gölge İğnesi (Needle)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Uzun menzilli ince bir gölge iğnesi fırlatarak fiziksel hasar verir ve hedefe 1 Gölge Damgası bırakır."
	q.cooldowns.assign([6.5, 6.0, 5.5, 5.0])
	q.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	q.base_damage.assign([80.0, 130.0, 180.0, 230.0])
	q.cast_range = 800.0
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.85
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.q_ability = q
	
	# W: Fade Step
	var w = AbilityDefinition.new()
	w.id = "nyxara_w"
	w.ability_name = "Gölge Adımı (Fade Step)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SINGLE_TARGET
	w.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	w.description = "Hedef düşmanın doğrudan arkasına ışınlanır, saldırı zamanlayıcısını sıfırlar ve 1 ek Gölge Damgası uygular."
	w.cooldowns.assign([11.0, 10.0, 9.0, 8.0])
	w.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	w.cast_range = 650.0
	hero.w_ability = w
	
	# E: Sever Thread
	var e = AbilityDefinition.new()
	e.id = "nyxara_e"
	e.ability_name = "Bağları Kopar (Sever Thread)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	e.description = "Hedefteki tüm Gölge Damgalarını patlatarak taban hasar ve hedefin eksik canına oranla infaz hasarı verir."
	e.cooldowns.assign([9.0, 8.0, 7.0, 6.0])
	e.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.cast_range = 350.0
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.60
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.e_ability = e
	
	# R: Vanish (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "nyxara_r"
	r.ability_name = "Gözden Kaybol (Vanish)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.SELF
	r.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	r.max_level = 3
	r.description = "4 saniye boyunca görünmezlik ve +%40 Hareket Hızı kazanır. Görünmezlikten yapılan ilk saldırı hedefe anında 3 Gölge Damgası uygular."
	r.cooldowns.assign([75.0, 65.0, 55.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
