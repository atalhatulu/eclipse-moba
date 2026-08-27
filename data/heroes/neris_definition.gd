class_name NerisDefinition
extends RefCounted

## Static data definition and archetype resource for Neris (INT Arcane Architect / Spatial Controller)

const AbilityDefinition = preload("res://core/abilities/ability_definition.gd")

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "neris"
	hero.id = "neris"
	hero.hero_name = "Neris"
	hero.role = "Büyücü / Mekansal Mimar"
	hero.role_description = "Spatial Architect / Area Controller (INT)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.INTELLIGENCE
	hero.attack_type = HeroResource.AttackType.RANGED
	
	# Base Attributes & Growths
	hero.base_intelligence = 27.0
	hero.intelligence_growth = 3.3
	hero.base_strength = 18.0
	hero.strength_growth = 1.8
	hero.base_agility = 17.0
	hero.agility_growth = 1.6
	
	# Base Combat Stats
	hero.base_health = 540.0
	hero.base_health_regen = 1.8
	hero.base_mana = 380.0
	hero.base_mana_regen = 2.2
	hero.base_attack_damage = 45.0
	hero.base_ability_power = 0.0
	hero.base_armor = 20.0
	hero.base_magic_resist = 30.0
	hero.base_attack_speed = 0.65
	hero.base_move_speed = 310.0
	hero.base_attack_range = 600.0
	
	# Passive: Construct (Arcane Nodes)
	var passive = AbilityDefinition.new()
	passive.id = "neris_passive"
	passive.ability_name = "Yapı (Construct)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Yetenek kullanımları sahada 45 saniye kalıcı Gizemli Düğümler (Arcane Nodes) oluşturur (azami 6 düğüm). Düğümler tetiklendiğinde etraflarına enerji saçar."
	hero.passive_ability = passive
	
	# Q: Wall (Resonance Wall)
	var q = AbilityDefinition.new()
	q.id = "neris_q"
	q.ability_name = "Rezonans Duvarı (Wall)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.AOE_CIRCLE
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "İki düğüm arasında 4 saniye süren enerji duvarı kurar. İçinden geçen düşmanlar hasar alır ve %40 yavaşlar."
	q.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	q.mana_costs.assign([65.0, 70.0, 75.0, 80.0])
	q.base_damage.assign([70.0, 120.0, 170.0, 220.0])
	q.cast_range = 750.0
	q.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	q.scaling_ratio = 0.60
	q.damage_type = DamageRequest.DamageType.MAGICAL
	hero.q_ability = q
	
	# W: Pulse (Arcane Resonance)
	var w = AbilityDefinition.new()
	w.id = "neris_w"
	w.ability_name = "Titreşim (Pulse)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SELF
	w.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	w.description = "Tüm aktif düğümleri tetikleyerek etraflarına büyü hasarı dalgası yayar."
	w.cooldowns.assign([8.0, 7.5, 7.0, 6.5])
	w.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	w.base_damage.assign([60.0, 100.0, 140.0, 180.0])
	w.cast_range = 800.0
	w.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	w.scaling_ratio = 0.50
	w.damage_type = DamageRequest.DamageType.MAGICAL
	hero.w_ability = w
	
	# E: Gate (Spatial Bridge)
	var e = AbilityDefinition.new()
	e.id = "neris_e"
	e.ability_name = "Geçit (Gate)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.POINT
	e.target_filter = AbilityResource.TargetFilter.ALLIES_ONLY
	e.description = "İki düğüm arasında geçici uzamsal köprü kurar. Kullanan dost birimlere +%40 Hareket Hızı sağlar ve diğer düğüme ışınlar."
	e.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	e.mana_costs.assign([70.0, 75.0, 80.0, 85.0])
	e.cast_range = 700.0
	hero.e_ability = e
	
	# R: Grand Design (Matrix Collapse - Ultimate)
	var r = AbilityDefinition.new()
	r.id = "neris_r"
	r.ability_name = "Büyük Tasarım (Grand Design)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.AOE_CIRCLE
	r.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	r.max_level = 3
	r.description = "Hedef alanda anında 4 düğümlü bir matris kurar ve patlatarak alandaki tüm düşmanlara ağır büyü hasarı vurur ve onları 1.2 saniye sersemletir."
	r.cooldowns.assign([90.0, 75.0, 60.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	r.base_damage.assign([220.0, 350.0, 480.0])
	r.cast_range = 900.0
	r.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	r.scaling_ratio = 0.85
	r.damage_type = DamageRequest.DamageType.MAGICAL
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
