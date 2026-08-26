class_name AstrisDefinition
extends RefCounted

## Static data definition and archetype resource for Astris (Ranged INT Mage)

const HeroRes = preload("res://core/entities/hero_resource.gd")

static func create_astris_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.id = "astris"
	hero.hero_name = "Astris"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.INTELLIGENCE
	hero.attack_type = HeroRes.AttackType.RANGED
	hero.role_description = "Menzilli Büyücü / Alan Kontrolü"
	
	# Base Stats
	hero.base_health = 500.0
	hero.base_mana = 450.0
	hero.base_health_regen = 2.0
	hero.base_mana_regen = 3.5
	
	hero.base_strength = 17.0
	hero.base_agility = 15.0
	hero.base_intelligence = 27.0
	
	hero.strength_growth = 1.6
	hero.agility_growth = 1.4
	hero.intelligence_growth = 3.2
	
	hero.base_attack_damage = 44.0
	hero.base_armor = 14.0
	hero.base_magic_resist = 25.0
	hero.base_attack_speed = 0.68
	hero.base_move_speed = 315.0
	hero.base_attack_range = 575.0
	
	# Passive: Mana Affinity (Innate)
	var passive = AbilityResource.new()
	passive.id = "astris_passive"
	passive.ability_name = "Mana Uyumu (Mana Affinity)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Astris'in manası %50'nin üzerindeyken tüm büyüleri +%15 Büyü Nüfuzu kazanır. Büyü kullandıktan sonraki ilk Q atışı aşırı yüklenerek ekstra mana yeniler."
	hero.passive_ability = passive
	
	# Abilities Setup
	var q = _create_q_ability()
	var w = _create_w_ability()
	var e = _create_e_ability()
	var r = _create_r_ability()
	hero.q_ability = q
	hero.w_ability = w
	hero.e_ability = e
	hero.r_ability = r
	hero.abilities.assign([passive, q, w, e, r])
	
	return hero

static func _create_q_ability() -> AbilityResource:
	var q = AbilityResource.new()
	q.id = "astris_q"
	q.ability_name = "Gizemli Ok (Arcane Bolt)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Hedeflenen düşmana veya orman yaratığına yoğunlaştırılmış saf gizem oku fırlatır. Aşırı yüklenme aktifse ilave hasar verir ve mana yeniler."
	q.cooldowns.assign([5.0, 4.5, 4.0, 3.5])
	q.mana_costs.assign([50.0, 60.0, 70.0, 80.0])
	q.base_damage.assign([80.0, 140.0, 200.0, 260.0])
	q.cast_range = 1100.0
	q.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	q.scaling_ratio = 0.80
	q.damage_type = DamageRequest.DamageType.MAGICAL
	return q

static func _create_w_ability() -> AbilityResource:
	var w = AbilityResource.new()
	w.id = "astris_w"
	w.ability_name = "Zamansal Durgunluk (Temporal Stasis)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.GROUND_AOE
	w.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	w.description = "Hedef zemin alanında uzay-zamanı bükerek patlama yaratır. Alandaki tüm düşmanlara büyüsel hasar verir ve onları 1.5 saniye yere sabitler (Root)."
	w.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	w.mana_costs.assign([70.0, 80.0, 90.0, 100.0])
	w.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	w.cast_range = 1200.0
	q_scaling_ap(w, 0.55)
	w.damage_type = DamageRequest.DamageType.MAGICAL
	w.applies_status_effect = true
	w.effect_type = StatusEffect.EffectType.ROOT
	w.effect_duration = 1.5
	return w

static func _create_e_ability() -> AbilityResource:
	var e = AbilityResource.new()
	e.id = "astris_e"
	e.ability_name = "Mana Kalkanı (Mana Barrier)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SELF
	e.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	e.description = "Astris'in etrafında koruyucu bir enerji kalkanı oluşturur. 4 saniye boyunca gelen hasarı emer ve saldırı savuşturma şansı kazandırır."
	e.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	e.mana_costs.assign([60.0, 70.0, 80.0, 90.0])
	e.base_damage.assign([0.0, 0.0, 0.0, 0.0])
	e.cast_range = 0.0
	return e

static func _create_r_ability() -> AbilityResource:
	var r = AbilityResource.new()
	r.id = "astris_r"
	r.ability_name = "Astral Yırtılma (Astral Rupture)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	r.description = "Geniş bir alana gökyüzünden astral enerji yağdırır. Çarpışma anında devasa büyüsel hasar verir ve alandaki düşmanları %50 yavaşlatır."
	r.max_level = 3
	r.cooldowns.assign([90.0, 75.0, 60.0])
	r.mana_costs.assign([150.0, 200.0, 250.0])
	r.base_damage.assign([250.0, 400.0, 550.0])
	r.cast_range = 1500.0
	q_scaling_ap(r, 1.0)
	r.damage_type = DamageRequest.DamageType.MAGICAL
	r.applies_status_effect = true
	r.effect_type = StatusEffect.EffectType.SLOW
	r.effect_duration = 2.0
	r.effect_intensity = 0.50
	return r

static func q_scaling_ap(ab: AbilityResource, ratio: float) -> void:
	ab.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	ab.scaling_ratio = ratio
