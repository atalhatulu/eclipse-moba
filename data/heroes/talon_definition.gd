class_name TalonDefinition
extends RefCounted

## Static data definition and archetype resource for Talon (AGI Diver / Relentless Tether Hunter)

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "talon"
	hero.id = "talon"
	hero.hero_name = "Talon"
	hero.role = "Hücumcu / Amansız Avcı"
	hero.role_description = "Diver / Relentless Tether Hunter (AGI)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.AGILITY
	hero.attack_type = HeroResource.AttackType.MELEE
	
	# Base Attributes & Growths
	hero.base_agility = 25.0
	hero.agility_growth = 3.0
	hero.base_strength = 22.0
	hero.strength_growth = 2.3
	hero.base_intelligence = 14.0
	hero.intelligence_growth = 1.2
	
	# Base Combat Stats
	hero.base_health = 600.0
	hero.base_health_regen = 2.2
	hero.base_mana = 240.0
	hero.base_mana_regen = 1.0
	hero.base_attack_damage = 54.0
	hero.base_ability_power = 0.0
	hero.base_armor = 25.0
	hero.base_magic_resist = 30.0
	hero.base_attack_speed = 0.70
	hero.base_move_speed = 325.0
	hero.base_attack_range = 175.0
	
	# Passive: Predator's Pace (Innate)
	var passive = AbilityDefinition.new()
	passive.id = "talon_passive"
	passive.ability_name = "Avcı Hızı (Predator's Pace)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Aynı hedefe vuruldukça Avcı yükü biriktirir (azami 5). Her yük hedefe doğru +%4 Hareket Hızı ve +3 Saldırı Gücü verir."
	hero.passive_ability = passive
	
	# Q: Hookblade
	var q = AbilityDefinition.new()
	q.id = "talon_q"
	q.ability_name = "Kancalı Bıçak (Hookblade)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Hedef düşmana kancalı zincir fırlatarak hasar verir ve 5 saniye süren bir Bağ iliştirir."
	q.cooldowns.assign([8.0, 7.5, 7.0, 6.5])
	q.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	q.base_damage.assign([80.0, 125.0, 170.0, 215.0])
	q.cast_range = 600.0
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.75
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.q_ability = q
	
	# W: Pursuit
	var w = AbilityDefinition.new()
	w.id = "talon_w"
	w.ability_name = "Amansız Takip (Pursuit)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SELF
	w.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	w.description = "Bağlı hedefe doğru hızla atılır, hedefe varışta %35 yavaşlatır ve 1 Avcı yükü ekler."
	w.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	w.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	hero.w_ability = w
	
	# E: Tear Away
	var e = AbilityDefinition.new()
	e.id = "talon_e"
	e.ability_name = "Koparma (Tear Away)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SELF
	e.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	e.description = "Bağlı hedefteki kancayı kopararak yüksek fiziksel hasar ve Avcı yükü başına +%20 ek hasar verir."
	e.cooldowns.assign([9.0, 8.0, 7.0, 6.0])
	e.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	e.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.70
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.e_ability = e
	
	# R: No Escape (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "talon_r"
	r.ability_name = "Kaçış Yok (No Escape)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.SELF
	r.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	r.max_level = 3
	r.description = "6 saniye boyunca +%30 Hareket Hızı kazanır, yavaşlatmaları yok sayar ve bağ mesafesini iki katına çıkarır."
	r.cooldowns.assign([80.0, 70.0, 60.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
