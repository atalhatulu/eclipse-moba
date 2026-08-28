class_name MoraDefinition
extends RefCounted

## Static data definition and archetype resource for Mora (STR/INT Life Weaver / Martyr Guardian)

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "mora"
	hero.id = "mora"
	hero.hero_name = "Mora"
	hero.role = "Destek / Yaşam Koruyucusu"
	hero.role_description = "Life Weaver / Martyr Guardian (STR)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	hero.attack_type = HeroResource.AttackType.MELEE
	
	# Base Attributes & Growths
	hero.base_strength = 26.0
	hero.strength_growth = 3.2
	hero.base_intelligence = 21.0
	hero.intelligence_growth = 2.2
	hero.base_agility = 15.0
	hero.agility_growth = 1.4
	
	# Base Combat Stats
	hero.base_health = 660.0
	hero.base_health_regen = 3.2
	hero.base_mana = 290.0
	hero.base_mana_regen = 1.4
	hero.base_attack_damage = 56.0
	hero.base_ability_power = 0.0
	hero.base_armor = 26.0
	hero.base_magic_resist = 31.0
	hero.base_attack_speed = 0.65
	hero.base_move_speed = 315.0
	hero.base_attack_range = 175.0
	
	# Passive: Life Reserve
	var passive = AbilityDefinition.new()
	passive.id = "mora_passive"
	passive.ability_name = "Yaşam Rezervi (Life Reserve)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Dost birimleri iyileştirdikçe yapılan iyileştirmenin %25'ini Rezerv olarak biriktirir (azami 400 Can). Her 50 Rezerv Mora'ya +0.5 Can Yenilenmesi kazandırır."
	hero.passive_ability = passive
	
	# Q: Restore (Soothing Touch)
	var q = AbilityDefinition.new()
	q.id = "mora_q"
	q.ability_name = "Yenilenme (Restore)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ALLIES_ONLY
	q.description = "Hedef dost birimi 3 saniye boyunca kademeli olarak iyileştirir (Mora Azami Canı ile ölçeklenir)."
	q.cooldowns.assign([8.0, 7.5, 7.0, 6.5])
	q.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	q.base_damage.assign([70.0, 120.0, 170.0, 220.0]) # Total heal value
	q.cast_range = 550.0
	hero.q_ability = q
	
	# W: Safeguard (Aegis of Devotion)
	var w = AbilityDefinition.new()
	w.id = "mora_w"
	w.ability_name = "Koruma Kalkanı (Safeguard)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SINGLE_TARGET
	w.target_filter = AbilityResource.TargetFilter.ALLIES_ONLY
	w.description = "Hedef dost birime 4 saniye süren koruma kalkanı kazandırır (Mora Azami Canının %12'si kadar güçlenir)."
	w.cooldowns.assign([11.0, 10.0, 9.0, 8.0])
	w.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	q.base_damage.assign([90.0, 160.0, 230.0, 300.0]) # Shield amount
	w.cast_range = 550.0
	hero.w_ability = w
	
	# E: Transfer Life (Martyr's Exchange)
	var e = AbilityDefinition.new()
	e.id = "mora_e"
	e.ability_name = "Yaşam Takası (Transfer Life)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.target_filter = AbilityResource.TargetFilter.ALLIES_ONLY
	e.description = "Mora mevcut canının %12'sini feda ederek hedef dost birimi anında feda edilen miktarın %120'si + sabit can ile iyileştirir."
	e.cooldowns.assign([9.0, 8.0, 7.0, 6.0])
	e.mana_costs.assign([40.0, 45.0, 50.0, 55.0])
	e.base_damage.assign([50.0, 90.0, 130.0, 170.0])
	e.cast_range = 500.0
	hero.e_ability = e
	
	# R: Rebirth Field (Defy Death - Ultimate)
	var r = AbilityDefinition.new()
	r.id = "mora_r"
	r.ability_name = "Yeniden Doğuş Alanı (Rebirth Field)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.SELF
	r.target_filter = AbilityResource.TargetFilter.ALLIES_ONLY
	r.max_level = 3
	r.description = "4.5 saniye boyunca etrafında 6.0m yarıçapında kutsal alan açar. Alandaki dost birimlerin canı %15'in altına düşürülemez (ölüm engelleme) ve +%30 ilave iyileştirme alırlar."
	r.cooldowns.assign([95.0, 80.0, 65.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	r.cast_range = 600.0
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
