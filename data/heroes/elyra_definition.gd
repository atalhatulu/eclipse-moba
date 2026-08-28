class_name ElyraDefinition
extends RefCounted

## Static data definition and archetype resource for Elyra (AGI Crit Carry / Ranged Gambler)

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "elyra"
	hero.id = "elyra"
	hero.hero_name = "Elyra"
	hero.role = "Nişancı / Kumarbaz"
	hero.role_description = "Ranged Crit Carry / Gambler (AGI)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.AGILITY
	hero.attack_type = HeroResource.AttackType.RANGED
	
	# Base Attributes & Growths
	hero.base_agility = 27.0
	hero.agility_growth = 3.4
	hero.base_strength = 17.0
	hero.strength_growth = 1.6
	hero.base_intelligence = 18.0
	hero.intelligence_growth = 1.6
	
	# Base Combat Stats
	hero.base_health = 550.0
	hero.base_health_regen = 1.7
	hero.base_mana = 280.0
	hero.base_mana_regen = 1.4
	hero.base_attack_damage = 48.0
	hero.base_ability_power = 0.0
	hero.base_armor = 21.0
	hero.base_magic_resist = 28.0
	hero.base_attack_speed = 0.68
	hero.base_move_speed = 315.0
	hero.base_attack_range = 525.0
	
	# Ranged Projectile Configuration
	hero.projectile_speed = 1200.0
	
	# Passive: Loaded Dice (Innate)
	var passive = AbilityDefinition.new()
	passive.id = "elyra_passive"
	passive.ability_name = "Hileli Zar (Loaded Dice)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Temel saldırılar Şans yükü biriktirir (azami 5). 5 yüke ulaşıldığında sonraki saldırı %100 Garantili Kritik Vuruş yapar."
	hero.passive_ability = passive
	
	# Q: Double Down
	var q = AbilityDefinition.new()
	q.id = "elyra_q"
	q.ability_name = "Çifte Bahis (Double Down)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SELF
	q.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	q.description = "Sonraki temel saldırıya +%30/40/50/60 Kritik İhtimali ve ilave fiziksel hasar ekler."
	q.cooldowns.assign([6.0, 5.5, 5.0, 4.5])
	q.mana_costs.assign([40.0, 45.0, 50.0, 55.0])
	q.base_damage.assign([60.0, 95.0, 130.0, 165.0])
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.65
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.q_ability = q
	
	# W: Roll Away
	var w = AbilityDefinition.new()
	w.id = "elyra_w"
	w.ability_name = "Uzaklaşma Yuvarlanması (Roll Away)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SELF
	w.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	w.description = "Hızla 4.5m yuvarlanır ve 0.75 saniye boyunca kaçınma kazanır."
	w.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	w.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	hero.w_ability = w
	
	# E: Marked Fortune
	var e = AbilityDefinition.new()
	e.id = "elyra_e"
	e.ability_name = "Kader İşareti (Marked Fortune)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	e.description = "Hedef düşmanı 5 saniye işaretler. İşaretli hedefe yapılan kritik vuruşlar ilave hasar verir."
	e.cooldowns.assign([11.0, 10.0, 9.0, 8.0])
	e.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	e.cast_range = 650.0
	hero.e_ability = e
	
	# R: Jackpot (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "elyra_r"
	r.ability_name = "Büyük İkramiye (Jackpot)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.SELF
	r.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	r.max_level = 3
	r.description = "6 saniye boyunca Kritik Hasar Çarpanını +%50 artırır ve her kritik vuruş fazladan +2 Şans yükü kazandırır."
	r.cooldowns.assign([80.0, 70.0, 60.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
