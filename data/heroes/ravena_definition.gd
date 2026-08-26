class_name RavenaDefinition
extends RefCounted

## Static data definition and archetype resource for Ravena (STR Tank / Initiator)

const AbilityDefinition = preload("res://core/abilities/ability_definition.gd")

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "ravena"
	hero.id = "ravena"
	hero.hero_name = "Ravena"
	hero.role = "Tank / Başlatıcı"
	hero.role_description = "Tank / Başlatıcı (Initiator)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	hero.attack_type = HeroResource.AttackType.MELEE
	
	# Base Attributes & Growths
	hero.base_strength = 26.0
	hero.strength_growth = 3.4
	hero.base_agility = 15.0
	hero.agility_growth = 1.4
	hero.base_intelligence = 17.0
	hero.intelligence_growth = 1.6
	
	# Base Combat Stats
	hero.base_health = 620.0
	hero.base_health_regen = 2.5
	hero.base_mana = 290.0
	hero.base_mana_regen = 1.8
	hero.base_attack_damage = 42.0
	hero.base_ability_power = 0.0
	hero.base_armor = 24.0
	hero.base_magic_resist = 30.0
	hero.base_attack_speed = 0.65
	hero.base_move_speed = 310.0
	hero.base_attack_range = 175.0
	
	# Passive: Anchored (Innate)
	var passive = AbilityDefinition.new()
	passive.id = "ravena_passive"
	passive.ability_name = "Demirlenmiş (Anchored)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Aynı bölgede kaldıkça saniye başına +5 Zırh (maks +25) kazanır. Hareket edildiğinde bonus sıfırlanır."
	hero.passive_ability = passive
	
	# Q: Chain Lance
	var q = AbilityDefinition.new()
	q.id = "ravena_q"
	q.ability_name = "Zincir Mızrak (Chain Lance)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Hedef düşman birime zincirli mızrak fırlatarak fiziksel hasar verir ve hedefi Ravena'ya doğru çeker."
	q.cooldowns.assign([8.0, 7.5, 7.0, 6.5])
	q.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	q.base_damage.assign([75.0, 125.0, 175.0, 225.0])
	q.cast_range = 750.0
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.60
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.q_ability = q
	
	# W: Anchor Field
	var w = AbilityDefinition.new()
	w.id = "ravena_w"
	w.ability_name = "Çapa Alanı (Anchor Field)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.GROUND_AOE
	w.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	w.description = "Hedef alana ağır çapa bırakır. Alandaki tüm düşmanlara hasar verir ve onları %35 yavaşlatır."
	w.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	w.mana_costs.assign([70.0, 80.0, 90.0, 100.0])
	w.base_damage.assign([60.0, 100.0, 140.0, 180.0])
	w.cast_range = 650.0
	w.aoe_radius = 350.0
	w.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.scaling_ratio = 0.40
	w.damage_type = DamageRequest.DamageType.PHYSICAL
	w.applies_status_effect = true
	w.effect_type = StatusEffect.EffectType.SLOW
	w.effect_duration = 2.5
	w.effect_intensity = 0.35
	hero.w_ability = w
	
	# E: Reposition
	var e = AbilityDefinition.new()
	e.id = "ravena_e"
	e.ability_name = "Yeniden Konumlan (Reposition)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.target_filter = AbilityResource.TargetFilter.ALL_EXCEPT_SELF
	e.description = "Düşman hedeflendiğinde onu kendine çeker; müttefik hedeflendiğinde Ravena kendini müttefiğe doğru çeker."
	e.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	e.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	e.base_damage.assign([40.0, 70.0, 100.0, 130.0])
	e.cast_range = 700.0
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.30
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.e_ability = e
	
	# R: Lockdown (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "ravena_r"
	r.ability_name = "Karantina (Lockdown)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.SINGLE_TARGET
	r.target_filter = AbilityResource.TargetFilter.ENEMY_HEROES_ONLY
	r.max_level = 3
	r.description = "Hedef düşman kahramanı ağır zincirlerle bağlayarak yüksek fiziksel hasar verir ve 2.0 saniye sersemletir/sabitler."
	r.cooldowns.assign([80.0, 70.0, 60.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	r.base_damage.assign([175.0, 275.0, 375.0])
	r.cast_range = 600.0
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 0.80
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	r.applies_status_effect = true
	r.effect_type = StatusEffect.EffectType.STUN
	r.effect_duration = 2.0
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
