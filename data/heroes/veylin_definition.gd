class_name VeylinDefinition
extends RefCounted

## Static data definition and archetype resource for Veylin (INT Spell Mimic / Arcane Adaptation)

const AbilityDefinition = preload("res://core/abilities/ability_definition.gd")

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "veylin"
	hero.id = "veylin"
	hero.hero_name = "Veylin"
	hero.role = "Büyücü / Taklit Ustası"
	hero.role_description = "Spell Mimic / Arcane Adaptation (INT)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.INTELLIGENCE
	hero.attack_type = HeroResource.AttackType.RANGED
	
	# Base Attributes & Growths
	hero.base_intelligence = 29.0
	hero.intelligence_growth = 3.6
	hero.base_agility = 18.0
	hero.agility_growth = 1.9
	hero.base_strength = 16.0
	hero.strength_growth = 1.6
	
	# Base Combat Stats
	hero.base_health = 520.0
	hero.base_health_regen = 1.6
	hero.base_mana = 440.0
	hero.base_mana_regen = 2.5
	hero.base_attack_damage = 45.0
	hero.base_ability_power = 0.0
	hero.base_armor = 18.0
	hero.base_magic_resist = 30.0
	hero.base_attack_speed = 0.68
	hero.base_move_speed = 315.0
	hero.base_attack_range = 600.0
	
	# Passive: Study (Arcane Observation)
	var passive = AbilityDefinition.new()
	passive.id = "veylin_passive"
	passive.ability_name = "Büyü İnceleme (Study)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Veylin yetenekleri gözlemledikçe İnceleme (Study) yükü kazanır (azami 5 yük). Her yük +8 Yetenek Gücü kazandırır."
	hero.passive_ability = passive
	
	# Q: Mimic (Adaptive Bolt)
	var q = AbilityDefinition.new()
	q.id = "veylin_q"
	q.ability_name = "Taklit Oku (Mimic)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Hedefe uyarlanabilir element oku fırlatır; büyü hasarı verir ve mevcut İnceleme yükü başına hasarı %10 artar."
	q.cooldowns.assign([6.0, 5.5, 5.0, 4.5])
	q.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	q.base_damage.assign([80.0, 130.0, 180.0, 230.0])
	q.cast_range = 650.0
	q.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	q.scaling_ratio = 0.60
	q.damage_type = DamageRequest.DamageType.MAGICAL
	hero.q_ability = q
	
	# W: Counterspell (Spell Barrier)
	var w = AbilityDefinition.new()
	w.id = "veylin_w"
	w.ability_name = "Büyü Bozma (Counterspell)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SELF
	w.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	w.description = "Veylin 2 saniye süren koruyucu büyü kalkanı açar (250 HP). Kalkan hasar emerse Veylin anında 2 İnceleme yükü kazanır."
	w.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	w.mana_costs.assign([65.0, 70.0, 75.0, 80.0])
	w.base_damage.assign([150.0, 220.0, 290.0, 360.0]) # Shield amount
	hero.w_ability = w
	
	# E: Rewrite (Matrix Transmutation)
	var e = AbilityDefinition.new()
	e.id = "veylin_e"
	e.ability_name = "Büyü Dönüşümü (Rewrite)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SELF
	e.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	e.description = "Veylin büyü matrisini yeniden yazar; Q Taklit Oku bekleme süresini sıfırlar ve sonraki yeteneğine %30 ilave AP çarpanı ekler."
	e.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	e.mana_costs.assign([45.0, 50.0, 55.0, 60.0])
	hero.e_ability = e
	
	# R: Adaptation (Arcane Surge - Ultimate)
	var r = AbilityDefinition.new()
	r.id = "veylin_r"
	r.ability_name = "Nihai Uyumlanma (Adaptation)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	r.max_level = 3
	r.description = "Önündeki koni alana güçlü bir uyarlanmış büyü patlaması saçar; ağır büyü hasarı verir, 6 saniye %30 Büyü Vampiri ve %25 Hareket Hızı kazanır."
	r.cooldowns.assign([80.0, 65.0, 50.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	r.base_damage.assign([220.0, 340.0, 460.0])
	r.cast_range = 700.0
	r.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	r.scaling_ratio = 0.85
	r.damage_type = DamageRequest.DamageType.MAGICAL
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
