class_name GromDefinition
extends RefCounted

## Grom - The Apex Stalker (STR Melee Hunter / Primal Assassin Bruiser)

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "grom"
	res.id = "grom"
	res.hero_name = "Grom"
	res.title = "Vahşi Avcı (The Apex Stalker)"
	res.role = "Dövüşçü / Avcı"
	res.role_description = "Primal Hunter / Apex Stalker (STR)"
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	res.attack_type = HeroResource.AttackType.MELEE
	
	# Base Attributes & Growths
	res.base_strength = 26.0
	res.strength_growth = 3.4
	res.base_agility = 18.0
	res.agility_growth = 2.0
	res.base_intelligence = 14.0
	res.intelligence_growth = 1.3
	
	# Combat Stats
	res.base_health = 620.0
	res.base_health_regen = 2.8
	res.base_mana = 260.0
	res.base_mana_regen = 1.3
	res.base_attack_damage = 56.0
	res.base_ability_power = 0.0
	res.base_armor = 25.0
	res.base_magic_resist = 28.0
	res.base_attack_speed = 0.74
	res.base_move_speed = 325.0
	res.base_attack_range = 175.0
	
	# Passive: Scent of Blood (Innate)
	var passive = AbilityResource.new()
	passive.id = "grom_passive"
	passive.ability_name = "Kan Kokusu (Scent of Blood)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Canı %40'ın altındaki görünmeyen yaralı düşmanları algılar ve onlara doğru hareket ederken +%30 Hareket Hızı kazanır."
	res.passive_ability = passive
	
	# Q: Savage Rend
	var q = AbilityResource.new()
	q.id = "grom_q"
	q.ability_name = "Vahşi Pençe (Savage Rend)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Hedefe pençeleriyle atılarak fiziksel hasar vurur ve 3 saniye boyunca derin kanama uygular."
	q.cooldowns.assign([6.0, 5.5, 5.0, 4.5])
	q.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	q.base_damage.assign([85.0, 135.0, 185.0, 235.0])
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.80
	q.cast_range = 350.0
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	res.q_ability = q
	
	# W: Dread Roar
	var w = AbilityResource.new()
	w.id = "grom_w"
	w.ability_name = "Korkunç Kükreme (Dread Roar)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.GROUND_AOE
	w.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	w.description = "4.5 metre çevresindeki tüm düşmanları 1.5 saniye susturur (Silence) ve saldırı güçlerini %25 azaltır."
	w.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	w.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	w.base_damage.assign([60.0, 100.0, 140.0, 180.0])
	w.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.aoe_radius = 4.5
	q_stat_w(w)
	res.w_ability = w
	
	# E: Predatory Pounce
	var e = AbilityResource.new()
	e.id = "grom_e"
	e.ability_name = "Av Atılışı (Predatory Pounce)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.DIRECTIONAL
	e.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	e.description = "Hedef yöne 6 metre sıçrar. Çarptığı ilk düşmana hasar vererek onu 1.2 saniye yere sabitler (Root)."
	e.cooldowns.assign([11.0, 10.0, 9.0, 8.0])
	e.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	e.base_damage.assign([75.0, 120.0, 165.0, 210.0])
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.65
	e.cast_range = 600.0
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	res.e_ability = e
	
	# R: Apex Hunt (Ultimate)
	var r = AbilityResource.new()
	r.id = "grom_r"
	r.ability_name = "Vahşi Av (Apex Hunt)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.SINGLE_TARGET
	r.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	r.max_level = 3
	r.description = "10 saniyeliğine Vahşi Canavar formuna girer: +%50 Hareket Hızı, +%40 Saldırı Hızı kazanır ve hedef düşmanın üstüne atılarak onu 1.8 saniye yere çiviler (Mutilate/Disarm)."
	r.cooldowns.assign([80.0, 70.0, 60.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	r.base_damage.assign([200.0, 325.0, 450.0])
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.0
	r.cast_range = 650.0
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	res.r_ability = r
	
	res.abilities.assign([passive, q, w, e, r])
	return res

static func q_stat_w(w: AbilityResource) -> void:
	w.scaling_ratio = 0.50
	w.cast_range = 450.0
	w.damage_type = DamageRequest.DamageType.PHYSICAL
	w.applies_status_effect = true
	w.effect_type = StatusEffect.EffectType.SILENCE
	w.effect_duration = 1.5
