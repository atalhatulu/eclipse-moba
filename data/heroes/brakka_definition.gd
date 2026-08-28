class_name BrakkaDefinition
extends RefCounted

## Static data definition and archetype resource for Brakka (STR Tank / Retaliation Core)

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "brakka"
	hero.id = "brakka"
	hero.hero_name = "Brakka"
	hero.role = "Tank / Savunmacı"
	hero.role_description = "Tank / Retaliation Defender (STR)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	hero.attack_type = HeroResource.AttackType.MELEE
	
	# Base Attributes & Growths
	hero.base_strength = 27.0
	hero.strength_growth = 3.5
	hero.base_agility = 14.0
	hero.agility_growth = 1.3
	hero.base_intelligence = 16.0
	hero.intelligence_growth = 1.5
	
	# Base Combat Stats
	hero.base_health = 640.0
	hero.base_health_regen = 2.8
	hero.base_mana = 260.0
	hero.base_mana_regen = 1.2
	hero.base_attack_damage = 44.0
	hero.base_ability_power = 0.0
	hero.base_armor = 26.0
	hero.base_magic_resist = 32.0
	hero.base_attack_speed = 0.64
	hero.base_move_speed = 305.0
	hero.base_attack_range = 175.0
	
	# Passive: Retaliation Core (Innate)
	var passive = AbilityDefinition.new()
	passive.id = "brakka_passive"
	passive.ability_name = "Misilleme Çekirdeği (Retaliation Core)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Alınan hasarın %20'sini Misilleme Enerjisi olarak depolar. Depolanan enerji maksimum canın %50'si ile sınırlıdır ve savaştan çıkınca erir."
	hero.passive_ability = passive
	
	# Q: Shield Ram
	var q = AbilityDefinition.new()
	q.id = "brakka_q"
	q.ability_name = "Kalkan Hücumu (Shield Ram)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "İleri hücum ederek ilk düşman hedefe çarpar, fiziksel hasar verir ve hedefi geriye savurur."
	q.cooldowns.assign([9.0, 8.5, 8.0, 7.5])
	q.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	q.base_damage.assign([80.0, 130.0, 180.0, 230.0])
	q.cast_range = 450.0
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.70
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.q_ability = q
	
	# W: Fortress
	var w = AbilityDefinition.new()
	w.id = "brakka_w"
	w.ability_name = "Hisar (Fortress)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SELF
	w.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	w.description = "4 saniye boyunca Brakka'nın zırhını büyük ölçüde artırır (+40/60/80/100 Zırh), ancak hareket hızını %25 azaltır."
	w.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	w.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	hero.w_ability = w
	
	# E: Rebound
	var e = AbilityDefinition.new()
	e.id = "brakka_e"
	e.ability_name = "Misilleme Patlaması (Rebound)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	e.description = "Depolanan tüm Misilleme hasarını hedef düşmana geri püskürtür ve Misilleme sayacını sıfırlar."
	e.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	e.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	e.base_damage.assign([50.0, 80.0, 110.0, 140.0])
	e.cast_range = 300.0
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.e_ability = e
	
	# R: Immovable (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "brakka_r"
	r.ability_name = "Sarsılmaz (Immovable)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.SELF
	r.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	r.max_level = 3
	r.description = "5 saniye boyunca kitle kontrol bağışıklığı kazanır ve çevredeki tüm düşman kahramanları Brakka'ya doğru çekerek hasar verir."
	r.cooldowns.assign([80.0, 70.0, 60.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	r.base_damage.assign([200.0, 320.0, 440.0])
	r.cast_range = 550.0
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
