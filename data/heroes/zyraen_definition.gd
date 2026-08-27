class_name ZyraenDefinition
extends RefCounted

## Static data definition and archetype resource for Zyraen (STR/INT Equilibrium Mystic / Dual Resource Balance)

const AbilityDefinition = preload("res://core/abilities/ability_definition.gd")

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "zyraen"
	hero.id = "zyraen"
	hero.hero_name = "Zyraen"
	hero.role = "Dövüşçü / Denge Mistiği"
	hero.role_description = "Equilibrium Mystic / Dual Resource Controller (STR/INT)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	hero.attack_type = HeroResource.AttackType.MELEE
	
	# Base Attributes & Growths
	hero.base_strength = 24.0
	hero.strength_growth = 2.8
	hero.base_intelligence = 24.0
	hero.intelligence_growth = 2.8
	hero.base_agility = 16.0
	hero.agility_growth = 1.6
	
	# Base Combat Stats
	hero.base_health = 620.0
	hero.base_health_regen = 2.2
	hero.base_mana = 380.0
	hero.base_mana_regen = 2.0
	hero.base_attack_damage = 52.0
	hero.base_ability_power = 0.0
	hero.base_armor = 24.0
	hero.base_magic_resist = 30.0
	hero.base_attack_speed = 0.66
	hero.base_move_speed = 315.0
	hero.base_attack_range = 175.0
	
	# Passive: Equilibrium (Dual Resource Harmonic)
	var passive = AbilityDefinition.new()
	passive.id = "zyraen_passive"
	passive.ability_name = "Kusursuz Denge (Equilibrium)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Can ve Mana oranları birbirine %10 yakın olduğunda Denge durumuna girer; +35 Yetenek Gücü ve %15 Hasar Azaltma kazanır."
	hero.passive_ability = passive
	
	# Q: Life Spark (Essence Bolt)
	var q = AbilityDefinition.new()
	q.id = "zyraen_q"
	q.ability_name = "Öz Kıvılcımı (Life Spark)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Hedefe büyü hasarı vurur; Zyraen Denge durumundaysa hedefin %10 mevcut canı kadar ilave büyü hasarı eklenir."
	q.cooldowns.assign([7.0, 6.5, 6.0, 5.5])
	q.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	q.base_damage.assign([75.0, 120.0, 165.0, 210.0])
	q.cast_range = 550.0
	q.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	q.scaling_ratio = 0.55
	q.damage_type = DamageRequest.DamageType.MAGICAL
	hero.q_ability = q
	
	# W: Mana Siphon (Essence Drain)
	var w = AbilityDefinition.new()
	w.id = "zyraen_w"
	w.ability_name = "Mana Çekimi (Mana Siphon)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SINGLE_TARGET
	w.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	w.description = "Hedef düşmandan mana çalar ve çalınan miktarın %120'si kadar Zyraen'in canını yeniler."
	w.cooldowns.assign([10.0, 9.5, 9.0, 8.5])
	w.mana_costs.assign([30.0, 35.0, 40.0, 45.0])
	w.base_damage.assign([60.0, 90.0, 120.0, 150.0]) # Mana drain amount
	w.cast_range = 500.0
	w.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	w.scaling_ratio = 0.40
	w.damage_type = DamageRequest.DamageType.MAGICAL
	hero.w_ability = w
	
	# E: Exchange (Resource Transmutation)
	var e = AbilityDefinition.new()
	e.id = "zyraen_e"
	e.ability_name = "Öz Takası (Exchange)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SELF
	e.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	e.description = "Can ve Mana havuzlarını birbirine dönüştürerek dengeler (Can yüksekse Can feda edip Mana doldurur, tersi durumda Mana harcayıp Can doldurur)."
	e.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	e.mana_costs.assign([0.0, 0.0, 0.0, 0.0]) # Dynamic cost handled in code
	e.base_damage.assign([80.0, 130.0, 180.0, 230.0]) # Transmuted pool amount
	hero.e_ability = e
	
	# R: Perfect Balance (Dual Harmonic Surge - Ultimate)
	var r = AbilityDefinition.new()
	r.id = "zyraen_r"
	r.ability_name = "Mutlak Denge (Perfect Balance)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.SELF
	r.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	r.max_level = 3
	r.description = "Can ve Mana oranlarını anında eşitler; 400 HP kalkan kazanır, 6 saniye koşulsuz Denge durumu aktif olur ve etrafındaki tüm düşmanlara büyü hasarı vurur."
	r.cooldowns.assign([80.0, 65.0, 50.0])
	r.mana_costs.assign([0.0, 0.0, 0.0])
	r.base_damage.assign([180.0, 280.0, 380.0])
	r.cast_range = 550.0
	r.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	r.scaling_ratio = 0.70
	r.damage_type = DamageRequest.DamageType.MAGICAL
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
