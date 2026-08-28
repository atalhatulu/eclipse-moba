class_name KharosDefinition
extends RefCounted

## Static data definition and archetype resource for Kharos (STR Berserker / Low-HP Duelist)

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "kharos"
	hero.id = "kharos"
	hero.hero_name = "Kharos"
	hero.role = "Hiddetli / Berserker"
	hero.role_description = "Berserker / Low-HP Duelist (STR)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	hero.attack_type = HeroResource.AttackType.MELEE
	
	# Base Attributes & Growths
	hero.base_strength = 25.0
	hero.strength_growth = 3.2
	hero.base_agility = 20.0
	hero.agility_growth = 2.2
	hero.base_intelligence = 14.0
	hero.intelligence_growth = 1.2
	
	# Base Combat Stats
	hero.base_health = 590.0
	hero.base_health_regen = 2.2
	hero.base_mana = 240.0
	hero.base_mana_regen = 1.0
	hero.base_attack_damage = 50.0
	hero.base_ability_power = 0.0
	hero.base_armor = 23.0
	hero.base_magic_resist = 29.0
	hero.base_attack_speed = 0.70
	hero.base_move_speed = 320.0
	hero.base_attack_range = 175.0
	
	# Passive: Bloodrage (Innate)
	var passive = AbilityDefinition.new()
	passive.id = "kharos_passive"
	passive.ability_name = "Kan Öfkesi (Bloodrage)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Can azaldıkça güçlenir. Eksik can yüzdesine bağlı olarak +60'a kadar Saldırı Gücü ve +%60 Saldırı Hızı kazanır."
	hero.passive_ability = passive
	
	# Q: Frenzy Slash
	var q = AbilityDefinition.new()
	q.id = "kharos_q"
	q.ability_name = "Çılgınlık Kesisi (Frenzy Slash)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Hedefe ardışık darbeler indirir. Her vuruş Çılgınlık yükü biriktirerek bir sonraki darbeyi güçlendirir."
	q.cooldowns.assign([6.0, 5.5, 5.0, 4.5])
	q.mana_costs.assign([40.0, 45.0, 50.0, 55.0])
	q.base_damage.assign([75.0, 120.0, 165.0, 210.0])
	q.cast_range = 225.0
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.75
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.q_ability = q
	
	# W: Blood Rush
	var w = AbilityDefinition.new()
	w.id = "kharos_w"
	w.ability_name = "Kan Hücumu (Blood Rush)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SELF
	w.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	w.description = "Mevcut canının %8'ini feda ederek ileri doğru atılır ve 3.5 saniye boyunca %30 Hareket Hızı kazanır."
	w.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	w.mana_costs.assign([0.0, 0.0, 0.0, 0.0]) # Free mana, costs HP
	hero.w_ability = w
	
	# E: Rage Reversal
	var e = AbilityDefinition.new()
	e.id = "kharos_e"
	e.ability_name = "Öfke Yansıması (Rage Reversal)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	e.description = "Son 2.5 saniye içinde alınan hasarın %35'ini hedef düşmana fiziksel hasar olarak geri yansıtır."
	e.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	e.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	e.base_damage.assign([60.0, 100.0, 140.0, 180.0])
	e.cast_range = 250.0
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.50
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.e_ability = e
	
	# R: Red Fury (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "kharos_r"
	r.ability_name = "Kızıl Gazap (Red Fury)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.SELF
	r.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	r.max_level = 3
	r.description = "4 saniye boyunca canı 1'in altına düşemez ve Kan Öfkesi bonusları 2 katına çıkar."
	r.cooldowns.assign([80.0, 70.0, 60.0])
	r.mana_costs.assign([100.0, 100.0, 100.0])
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
