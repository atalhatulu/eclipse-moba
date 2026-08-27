class_name IlyraDefinition
extends RefCounted

## Static data definition and archetype resource for Ilyra (INT Battlemage / Weave & Grand Weave)

const AbilityDefinition = preload("res://core/abilities/ability_definition.gd")

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "ilyra"
	hero.id = "ilyra"
	hero.hero_name = "Ilyra"
	hero.role = "Savaş Büyücüsü / Örücü"
	hero.role_description = "Battlemage / Element Weaver (INT)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.INTELLIGENCE
	hero.attack_type = HeroResource.AttackType.RANGED
	
	# Base Attributes & Growths
	hero.base_intelligence = 27.0
	hero.intelligence_growth = 3.3
	hero.base_strength = 18.0
	hero.strength_growth = 1.7
	hero.base_agility = 16.0
	hero.agility_growth = 1.5
	
	# Base Combat Stats
	hero.base_health = 540.0
	hero.base_health_regen = 2.0
	hero.base_mana = 420.0
	hero.base_mana_regen = 3.2
	hero.base_attack_damage = 44.0
	hero.base_ability_power = 0.0
	hero.base_armor = 17.0
	hero.base_magic_resist = 27.0
	hero.base_attack_speed = 0.68
	hero.base_move_speed = 315.0
	hero.base_attack_range = 550.0
	
	# Projectile
	hero.projectile_speed = 24.0
	hero.projectile_color = Color(0.9, 0.4, 0.9, 1.0)
	hero.projectile_radius = 0.28
	
	# Passive: Weave (Innate)
	var passive = AbilityDefinition.new()
	passive.id = "ilyra_passive"
	passive.ability_name = "Örgü (Weave)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Farklı element büyüleri ardışık kullanıldığında Örgü yükü kazanır (azami 4). Her yük +%8 Büyü Gücü ve +%5 Hareket Hızı sağlar."
	hero.passive_ability = passive
	
	# Q: Ember Thread
	var q = AbilityDefinition.new()
	q.id = "ilyra_q"
	q.ability_name = "Köz İpliği (Ember Thread)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Ateş ipliği fırlatarak büyüsel hasar verir ve hedefi 3 saniye boyunca yakar."
	q.cooldowns.assign([5.5, 5.0, 4.5, 4.0])
	q.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	q.base_damage.assign([85.0, 135.0, 185.0, 235.0])
	q.cast_range = 600.0
	q.scaling_stat = StatModifier.TargetStat.INTELLIGENCE
	q.scaling_ratio = 0.70
	q.damage_type = DamageRequest.DamageType.MAGICAL
	hero.q_ability = q
	
	# W: Frost Thread
	var w = AbilityDefinition.new()
	w.id = "ilyra_w"
	w.ability_name = "Buz İpliği (Frost Thread)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.GROUND_AOE
	w.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	w.description = "Hedef alana don ipliği örerek büyüsel hasar verir ve düşmanları 2.5 saniye boyunca %35 yavaşlatır."
	w.cooldowns.assign([9.0, 8.0, 7.0, 6.0])
	w.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	w.base_damage.assign([65.0, 105.0, 145.0, 185.0])
	w.cast_range = 550.0
	w.scaling_stat = StatModifier.TargetStat.INTELLIGENCE
	w.scaling_ratio = 0.55
	w.damage_type = DamageRequest.DamageType.MAGICAL
	w.applies_status_effect = true
	w.effect_type = StatusEffect.EffectType.SLOW
	w.effect_duration = 2.5
	w.effect_intensity = 0.35
	hero.w_ability = w
	
	# E: Arc Thread
	var e = AbilityDefinition.new()
	e.id = "ilyra_e"
	e.ability_name = "Kıvılcım İpliği (Arc Thread)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	e.description = "Elektrik ipliği fırlatır; hedefe ve 3 yakındaki düşmana sekerek büyüsel hasar verir."
	e.cooldowns.assign([8.0, 7.5, 7.0, 6.5])
	e.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	e.base_damage.assign([75.0, 115.0, 155.0, 195.0])
	e.cast_range = 550.0
	e.scaling_stat = StatModifier.TargetStat.INTELLIGENCE
	e.scaling_ratio = 0.60
	e.damage_type = DamageRequest.DamageType.MAGICAL
	hero.e_ability = e
	
	# R: Grand Weave (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "ilyra_r"
	r.ability_name = "Büyük Örgü (Grand Weave)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	r.description = "Son kullanılan farklı büyülerin elementlerini birleştirerek devasa büyü patlaması yaratır. Örgü yükü başına hasarı %25 katlanır."
	r.cooldowns.assign([70.0, 60.0, 50.0])
	r.mana_costs.assign([100.0, 120.0, 140.0])
	r.base_damage.assign([200.0, 320.0, 440.0])
	r.cast_range = 650.0
	r.scaling_stat = StatModifier.TargetStat.INTELLIGENCE
	r.scaling_ratio = 0.85
	r.damage_type = DamageRequest.DamageType.MAGICAL
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
