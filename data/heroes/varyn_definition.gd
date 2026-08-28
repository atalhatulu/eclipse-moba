class_name VarynDefinition
extends RefCounted

## Static data definition and archetype resource for Varyn (AGI Skirmisher / Mobile Dash Fighter)

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "varyn"
	hero.id = "varyn"
	hero.hero_name = "Varyn"
	hero.role = "Hücumcu / Fırtına Akışçısı"
	hero.role_description = "Skirmisher / Mobile Dash Fighter (AGI)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.AGILITY
	hero.attack_type = HeroResource.AttackType.MELEE
	
	# Base Attributes & Growths
	hero.base_agility = 25.0
	hero.agility_growth = 3.1
	hero.base_strength = 20.0
	hero.strength_growth = 2.0
	hero.base_intelligence = 15.0
	hero.intelligence_growth = 1.3
	
	# Base Combat Stats
	hero.base_health = 580.0
	hero.base_health_regen = 2.1
	hero.base_mana = 250.0
	hero.base_mana_regen = 1.1
	hero.base_attack_damage = 50.0
	hero.base_ability_power = 0.0
	hero.base_armor = 24.0
	hero.base_magic_resist = 29.0
	hero.base_attack_speed = 0.70
	hero.base_move_speed = 325.0
	hero.base_attack_range = 175.0
	
	# Passive: Flow (Innate)
	var passive = AbilityDefinition.new()
	passive.id = "varyn_passive"
	passive.ability_name = "Akış (Flow)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Atılma ve yetenekler kullanıldıkça Akış biriktirir (azami 100). Her 10 Akış +3 Saldırı Gücü ve +%1 Hareket Hızı sağlar."
	hero.passive_ability = passive
	
	# Q: Razor Leap
	var q = AbilityDefinition.new()
	q.id = "varyn_q"
	q.ability_name = "Jilet Sıçrayışı (Razor Leap)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Hedef düşmana doğru atılarak fiziksel hasar verir ve +20 Akış kazandırır."
	q.cooldowns.assign([7.0, 6.5, 6.0, 5.5])
	q.mana_costs.assign([45.0, 50.0, 55.0, 60.0])
	q.base_damage.assign([75.0, 120.0, 165.0, 210.0])
	q.cast_range = 550.0
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.75
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.q_ability = q
	
	# W: Spin Cut
	var w = AbilityDefinition.new()
	w.id = "varyn_w"
	w.ability_name = "Döner Kesik (Spin Cut)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.GROUND_AOE
	w.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	w.description = "Etrafındaki alana dönerek hasar verir ve isabet alan her düşman başına +15 Akış üretir."
	w.cooldowns.assign([8.0, 7.5, 7.0, 6.5])
	w.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	w.base_damage.assign([80.0, 125.0, 170.0, 215.0])
	w.cast_range = 350.0
	w.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.scaling_ratio = 0.70
	w.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.w_ability = w
	
	# E: Rebound
	var e = AbilityDefinition.new()
	e.id = "varyn_e"
	e.ability_name = "Geri Tepme (Rebound)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SELF
	e.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	e.description = "Hızla atılır. Son 3 saniye içinde bir düşmana vurulmuşsa ikinci bir ücretsiz atılma hakkı açılır."
	e.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	e.mana_costs.assign([50.0, 50.0, 50.0, 50.0])
	hero.e_ability = e
	
	# R: Endless Motion (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "varyn_r"
	r.ability_name = "Sonsuz Devinim (Endless Motion)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.SELF
	r.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	r.max_level = 3
	r.description = "6 saniye boyunca +%25 Hareket Hızı kazanır, Akış kazanımı 2 katına çıkar ve yetenek isabetleri Q bekleme süresini anında sıfırlar."
	r.cooldowns.assign([75.0, 65.0, 55.0])
	r.mana_costs.assign([100.0, 100.0, 100.0])
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
