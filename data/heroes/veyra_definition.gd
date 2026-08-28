class_name VeyraDefinition
extends RefCounted

## Static data definition and archetype resource for Veyra (STR Diver / Momentum & Crash Landing)

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "veyra"
	hero.id = "veyra"
	hero.hero_name = "Veyra"
	hero.role = "Dalgıç / Savaşçı"
	hero.role_description = "Diver / Kinetic Initiator (STR)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	hero.attack_type = HeroResource.AttackType.MELEE
	
	# Base Attributes & Growths
	hero.base_strength = 25.0
	hero.strength_growth = 3.1
	hero.base_agility = 20.0
	hero.agility_growth = 2.2
	hero.base_intelligence = 15.0
	hero.intelligence_growth = 1.4
	
	# Base Combat Stats
	hero.base_health = 600.0
	hero.base_health_regen = 2.4
	hero.base_mana = 270.0
	hero.base_mana_regen = 1.3
	hero.base_attack_damage = 48.0
	hero.base_ability_power = 0.0
	hero.base_armor = 23.0
	hero.base_magic_resist = 29.0
	hero.base_attack_speed = 0.68
	hero.base_move_speed = 320.0
	hero.base_attack_range = 175.0
	
	# Passive: Momentum (Innate)
	var passive = AbilityDefinition.new()
	passive.id = "veyra_passive"
	passive.ability_name = "Devinim (Momentum)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Hareket ettikçe 100'e kadar Devinim biriktirir. Devinim hareket hızını artırır ve yetenekleri güçlendirir. Hareketsiz kalınca erir."
	hero.passive_ability = passive
	
	# Q: Shoulder Break
	var q = AbilityDefinition.new()
	q.id = "veyra_q"
	q.ability_name = "Omuz Darbesi (Shoulder Break)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "İleriye atılarak ilk düşmana çarpar, fiziksel hasar verir ve hedefi geriye savurur. Devinim ile hasarı artar."
	q.cooldowns.assign([8.0, 7.5, 7.0, 6.5])
	q.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	q.base_damage.assign([80.0, 130.0, 180.0, 230.0])
	q.cast_range = 450.0
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.75
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.q_ability = q
	
	# W: Impact Zone
	var w = AbilityDefinition.new()
	w.id = "veyra_w"
	w.ability_name = "Darbe Alanı (Impact Zone)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SELF
	w.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	w.description = "Sıçrayıp yere sertçe vurarak çevredeki tüm düşmanlara alan hasarı verir ve 2 saniye boyunca %30 yavaşlatır."
	w.cooldowns.assign([11.0, 10.0, 9.0, 8.0])
	w.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	w.base_damage.assign([70.0, 115.0, 160.0, 205.0])
	w.cast_range = 400.0
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.scaling_ratio = 0.60
	w.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.w_ability = w
	
	# E: Second Wind
	var e = AbilityDefinition.new()
	e.id = "veyra_e"
	e.ability_name = "İkinci Nefes (Second Wind)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SELF
	e.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	e.description = "Düşman kahramana vurulduğunda 3 saniye boyunca %30 hareket hızı ve anında +30 Devinim kazandırır."
	e.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	e.mana_costs.assign([40.0, 45.0, 50.0, 55.0])
	hero.e_ability = e
	
	# R: Crash Landing (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "veyra_r"
	r.ability_name = "Sert İniş (Crash Landing)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	r.max_level = 3
	r.description = "Hedeflenen konuma devasa bir sıçrama gerçekleştirir. İnişteki tüm düşmanlara ağır hasar verir ve onları 0.8 saniye havaya savurur."
	r.cooldowns.assign([85.0, 75.0, 65.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	r.base_damage.assign([220.0, 350.0, 480.0])
	r.cast_range = 750.0
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.10
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
