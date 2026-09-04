class_name AuronDefinition
extends RefCounted

## Static data definition and archetype resource for Auron (STR Support Tank / Guardian)

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "auron"
	hero.id = "auron"
	hero.hero_name = "Aurelian"
	hero.role = "Destek Tankı / Muhafız"
	hero.role_description = "Support Tank / Sun-Bond Guardian (STR)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	hero.attack_type = HeroResource.AttackType.MELEE
	
	# Base Attributes & Growths
	hero.base_strength = 26.0
	hero.strength_growth = 3.2
	hero.base_agility = 15.0
	hero.agility_growth = 1.5
	hero.base_intelligence = 19.0
	hero.intelligence_growth = 1.8
	
	# Base Combat Stats
	hero.base_health = 610.0
	hero.base_health_regen = 2.8
	hero.base_mana = 300.0
	hero.base_mana_regen = 1.6
	hero.base_attack_damage = 45.0
	hero.base_ability_power = 0.0
	hero.base_armor = 26.0
	hero.base_magic_resist = 30.0
	hero.base_attack_speed = 0.64
	hero.base_move_speed = 310.0
	hero.base_attack_range = 175.0
	
	# Passive: Shared Resolve (Innate)
	var passive = AbilityDefinition.new()
	passive.id = "auron_passive"
	passive.ability_name = "Ortak Kararlılık (Shared Resolve)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Yakındaki müttefikler hasar aldığında Kararlılık biriktirir (azami 100). Kararlılık Auron'un can yenilenmesini ve sağladığı kalkanların gücünü artırır."
	hero.passive_ability = passive
	
	# Q: Guarding Blow
	var q = AbilityDefinition.new()
	q.id = "auron_q"
	q.ability_name = "Muhafız Darbesi (Guarding Blow)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Düşmana fiziksel hasar verir ve en yakındaki yaralı dost kahramana veya Auron'a 3.5 saniye kalkan kazandırır."
	q.cooldowns.assign([8.0, 7.5, 7.0, 6.5])
	q.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	q.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	q.cast_range = 250.0
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.70
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.q_ability = q
	
	# W: Interpose
	var w = AbilityDefinition.new()
	w.id = "auron_w"
	w.ability_name = "Araya Gir (Interpose)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SINGLE_TARGET
	w.target_filter = AbilityResource.TargetFilter.ALLIES_ONLY
	w.description = "Hedef müttefikin yanına atılarak her ikisine de kalkan kazandırır ve 4 saniye boyunca müttefikin aldığı hasarın %30'unu Auron üstlenir."
	w.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	w.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	w.cast_range = 600.0
	hero.w_ability = w
	
	# E: Rally
	var e = AbilityDefinition.new()
	e.id = "auron_e"
	e.ability_name = "Toplanma Çağrısı (Rally)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SELF
	e.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	e.description = "Çevredeki tüm dost kahramanlara 4 saniye boyunca +20/30/40/50 Zırh ve Tenacity kazandırır."
	e.cooldowns.assign([15.0, 14.0, 13.0, 12.0])
	e.mana_costs.assign([65.0, 70.0, 75.0, 80.0])
	hero.e_ability = e
	
	# R: Guardian's Oath (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "auron_r"
	r.ability_name = "Muhafız Yemini (Guardian's Oath)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.SINGLE_TARGET
	r.target_filter = AbilityResource.TargetFilter.ALLIES_ONLY
	r.max_level = 3
	r.description = "Hedef müttefikle 6 saniye süren kutsal bağ kurar. Müttefik ölümcül hasar aldığında ölümü engellenir ve anında büyük miktarda can yenilenir."
	r.cooldowns.assign([90.0, 80.0, 70.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	r.cast_range = 700.0
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
