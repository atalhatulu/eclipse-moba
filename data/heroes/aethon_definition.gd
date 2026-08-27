class_name AethonDefinition
extends RefCounted

## Static data definition and archetype resource for Aethon (INT Arcane Construct Builder / Siege Assembly)

const AbilityDefinition = preload("res://core/abilities/ability_definition.gd")

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "aethon"
	hero.id = "aethon"
	hero.hero_name = "Aethon"
	hero.role = "Büyücü / Yapı Ustası"
	hero.role_description = "Construct Builder / Siege Summoner (INT)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.INTELLIGENCE
	hero.attack_type = HeroResource.AttackType.RANGED
	
	# Base Attributes & Growths
	hero.base_intelligence = 27.0
	hero.intelligence_growth = 3.2
	hero.base_strength = 19.0
	hero.strength_growth = 2.0
	hero.base_agility = 16.0
	hero.agility_growth = 1.5
	
	# Base Combat Stats
	hero.base_health = 560.0
	hero.base_health_regen = 1.9
	hero.base_mana = 400.0
	hero.base_mana_regen = 2.2
	hero.base_attack_damage = 48.0
	hero.base_ability_power = 0.0
	hero.base_armor = 21.0
	hero.base_magic_resist = 30.0
	hero.base_attack_speed = 0.65
	hero.base_move_speed = 310.0
	hero.base_attack_range = 575.0
	
	# Passive: Constructs (Arcane Architecture)
	var passive = AbilityDefinition.new()
	passive.id = "aethon_passive"
	passive.ability_name = "Büyülü Yapılar (Arcane Constructs)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Aethon yetenekleriyle savaş alanında savaşan yapay muhafızlar ve toplar çağırır (azami 4 aktif yapı, 15 saniye ömür)."
	hero.passive_ability = passive
	
	# Q: Guardian Construct
	var q = AbilityDefinition.new()
	q.id = "aethon_q"
	q.ability_name = "Muhafız Yapı (Guardian Construct)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.GROUND_AOE
	q.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	q.description = "Hedef noktada yakın dövüşçü, yüksek zırhlı Muhafız Yapı çağırır. Düşmanlara saldırır ve yakınındaki müttefikleri korur."
	q.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	q.mana_costs.assign([65.0, 70.0, 75.0, 80.0])
	q.base_damage.assign([35.0, 55.0, 75.0, 95.0]) # Attack power
	q.cast_range = 650.0
	q.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	q.scaling_ratio = 0.40
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.q_ability = q
	
	# W: Cannon Construct
	var w = AbilityDefinition.new()
	w.id = "aethon_w"
	w.ability_name = "Büyü Topu Yapısı (Cannon Construct)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.GROUND_AOE
	w.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	w.description = "Hedef noktada menzilli atış yapan Büyü Topu çağırır. Uzak hedeflere büyü enerjisi fırlatır."
	w.cooldowns.assign([13.0, 12.0, 11.0, 10.0])
	w.mana_costs.assign([70.0, 75.0, 80.0, 85.0])
	w.base_damage.assign([45.0, 70.0, 95.0, 120.0]) # Shot damage
	w.cast_range = 700.0
	w.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	w.scaling_ratio = 0.50
	w.damage_type = DamageRequest.DamageType.MAGICAL
	hero.w_ability = w
	
	# E: Reconfigure
	var e = AbilityDefinition.new()
	e.id = "aethon_e"
	e.ability_name = "Yeniden Yapılandır (Reconfigure)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SELF
	e.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	e.description = "Tüm aktif yapıların rollerini dönüştürür (Muhafız <-> Top), canlarını %50 yeniler ve 4 saniye %30 saldırı hızı verir."
	e.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	e.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	e.base_damage.assign([50.0, 60.0, 70.0, 80.0]) # Heal/overcharge percentage
	e.cast_range = 800.0
	hero.e_ability = e
	
	# R: Assembly (Siege Assembly - Ultimate)
	var r = AbilityDefinition.new()
	r.id = "aethon_r"
	r.ability_name = "Büyük Birleştirme (Siege Assembly)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	r.max_level = 3
	r.description = "Mevcut tüm yapıları birleştirerek devasa bir Kuşatma Kolosu (Siege Construct) oluşturur. Ağır alan hasarı ve yapı hasarı verir."
	r.cooldowns.assign([100.0, 85.0, 70.0])
	r.mana_costs.assign([120.0, 150.0, 180.0])
	r.base_damage.assign([180.0, 280.0, 380.0])
	r.cast_range = 750.0
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
