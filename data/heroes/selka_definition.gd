class_name SelkaDefinition
extends RefCounted

## Static data definition and archetype resource for Selka (INT Cursesmith / Hex Burst Mage)

const AbilityDefinition = preload("res://core/abilities/ability_definition.gd")

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "selka"
	hero.id = "selka"
	hero.hero_name = "Selka"
	hero.role = "Büyücü / Lanet Uzmanı"
	hero.role_description = "Cursesmith / Hex Burst Mage (INT)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.INTELLIGENCE
	hero.attack_type = HeroResource.AttackType.RANGED
	
	# Base Attributes & Growths
	hero.base_intelligence = 28.0
	hero.intelligence_growth = 3.5
	hero.base_strength = 17.0
	hero.strength_growth = 1.7
	hero.base_agility = 18.0
	hero.agility_growth = 1.8
	
	# Base Combat Stats
	hero.base_health = 530.0
	hero.base_health_regen = 1.7
	hero.base_mana = 390.0
	hero.base_mana_regen = 2.1
	hero.base_attack_damage = 46.0
	hero.base_ability_power = 0.0
	hero.base_armor = 19.0
	hero.base_magic_resist = 30.0
	hero.base_attack_speed = 0.67
	hero.base_move_speed = 315.0
	hero.base_attack_range = 600.0
	
	# Passive: Hex Marks
	var passive = AbilityDefinition.new()
	passive.id = "selka_passive"
	passive.ability_name = "Lanet Damgaları (Hex Marks)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Yetenek hasarı alan düşmanlara Lanet yükü eklenir (azami 3 yük, 6 saniye kalır). Her yük hedefin büyü direncini %6 kırar."
	hero.passive_ability = passive
	
	# Q: Hex Bolt
	var q = AbilityDefinition.new()
	q.id = "selka_q"
	q.ability_name = "Lanet Oku (Hex Bolt)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Hedefe fırlatılan lanetli ok büyü hasarı verir ve 1 Lanet yükü ekler."
	q.cooldowns.assign([6.5, 6.0, 5.5, 5.0])
	q.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	q.base_damage.assign([75.0, 125.0, 175.0, 225.0])
	q.cast_range = 650.0
	q.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	q.scaling_ratio = 0.70
	q.damage_type = DamageRequest.DamageType.MAGICAL
	hero.q_ability = q
	
	# W: Ember Ring
	var w = AbilityDefinition.new()
	w.id = "selka_w"
	w.ability_name = "Lanet Halkası (Ember Ring)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.GROUND_AOE
	w.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	w.description = "Hedef alanda genişleyen lanet alevi çemberi oluşturarak tüm düşmanlara büyü hasarı vurur ve 1 Lanet yükü ekler."
	w.cooldowns.assign([9.0, 8.5, 8.0, 7.5])
	w.mana_costs.assign([65.0, 70.0, 75.0, 80.0])
	w.base_damage.assign([70.0, 115.0, 160.0, 205.0])
	w.cast_range = 600.0
	w.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	w.scaling_ratio = 0.65
	w.damage_type = DamageRequest.DamageType.MAGICAL
	hero.w_ability = w
	
	# E: Detonate (Curse Rupture)
	var e = AbilityDefinition.new()
	e.id = "selka_e"
	e.ability_name = "Lanet Patlaması (Detonate)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SELF
	e.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	e.description = "Etraftaki tüm düşmanların Lanet yüklerini tüketerek patlatır; tüketilen yük başına büyü hasarı verir ve yavaşlatır."
	e.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	e.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	e.base_damage.assign([40.0, 70.0, 100.0, 130.0]) # Per stack
	e.cast_range = 700.0
	e.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	e.scaling_ratio = 0.35
	e.damage_type = DamageRequest.DamageType.MAGICAL
	hero.e_ability = e
	
	# R: Cataclysm (Fate Link - Ultimate)
	var r = AbilityDefinition.new()
	r.id = "selka_r"
	r.ability_name = "Kader Bağı (Cataclysm)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	r.max_level = 3
	r.description = "3 düşman kahramana kadar lanetli zincirle bağlar (5 saniye). Bağlı hedeflerden birine vurulan hasarın %40'ı diğer tüm bağlı düşmanlara büyü hasarı olarak yansır."
	r.cooldowns.assign([85.0, 70.0, 55.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	r.cast_range = 750.0
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
