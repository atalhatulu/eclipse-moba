class_name NixeDefinition
extends RefCounted

## Nixe - The Wall-Crawler

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "nixe"
	res.hero_name = "Nixe"
	res.title = "The Wall-Crawler"
	res.lore = "A feral arachnid ambusher who scales natural cliffs and pounces from high walls upon unsuspecting prey."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.AGILITY
	
	res.base_strength = 19.0
	res.strength_growth = 2.1
	res.base_agility = 25.0
	res.agility_growth = 3.3
	res.base_intelligence = 16.0
	res.intelligence_growth = 1.6
	
	res.base_health = 580.0
	res.base_health_regen = 2.4
	res.base_mana = 280.0
	res.base_mana_regen = 1.6
	res.base_attack_damage = 56.0
	res.base_ability_power = 0.0
	res.base_armor = 27.0
	res.base_magic_resist = 25.0
	res.base_attack_speed = 1.06
	res.base_move_speed = 320.0
	res.base_attack_range = 160.0
	
	# Passive: Wall Climber
	var passive = AbilityResource.new()
	passive.id = "nixe_passive"
	passive.ability_name = "Duvar Tırmanıcısı (Wall Climber)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.description = "Nixe harita sınırlarında ve arazilerde +%35 Hareket Hızı kazanır ve pusu saldırılarında fazladan %25 hasar vurur."
	res.passive_ability = passive
	
	# Q: Pounce & Ambush
	var q = AbilityResource.new()
	q.id = "nixe_q"
	q.ability_name = "Pusu Atılışı (Pounce)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.GROUND_AOE
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.95
	q.base_damage.assign([85.0, 135.0, 185.0, 235.0])
	q.cooldowns.assign([8.0, 7.5, 7.0, 6.5])
	q.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	q.cast_range = 700.0
	q.description = "Hedef noktaya 7 metre şiddetli atılma yapar; alandaki düşmanları yere çalar ve 1.0 saniye sersemletir."
	res.q_ability = q
	
	# W: Acid Web
	var w = AbilityResource.new()
	w.id = "nixe_w"
	w.ability_name = "Asit Ağı (Acid Web)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.GROUND_AOE
	w.damage_type = DamageRequest.DamageType.MAGICAL
	w.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	w.scaling_ratio = 0.65
	w.base_damage.assign([70.0, 115.0, 160.0, 205.0])
	w.cooldowns.assign([9.0, 8.0, 7.0, 6.0])
	w.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	w.cast_range = 650.0
	w.description = "Hedef alana 4.5m genişliğinde asitli örümcek ağı serer; içindeki düşmanları %50 yavaşlatır ve zırhlarını %25 eritir."
	res.w_ability = w
	
	# E: Skitter & Evasion
	var e = AbilityResource.new()
	e.id = "nixe_e"
	e.ability_name = "Hızlı Tırmanış (Skitter)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SELF
	e.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	e.mana_costs.assign([45.0, 50.0, 55.0, 60.0])
	e.description = "Nixe 2 saniyeliğine +%45 Hareket Hızı kazanır ve kitle kontrolü etkilerini üzerinden siler."
	res.e_ability = e
	
	# R: Toxic Cocoon (Ultimate)
	var r = AbilityResource.new()
	r.id = "nixe_r"
	r.ability_name = "Zehirli Koza (Toxic Cocoon)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.SINGLE_TARGET
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.25
	r.base_damage.assign([240.0, 360.0, 480.0])
	r.cooldowns.assign([85.0, 70.0, 55.0])
	r.mana_costs.assign([100.0, 120.0, 140.0])
	r.cast_range = 600.0
	r.description = "Hedef düşmanı zehirli koza ağına hapsederek 2.0 saniye tamamen kilitler (Stun + DoT) ve Nixe'ye doğru çeker."
	res.r_ability = r
	res.abilities.assign([passive, q, w, e, r])
	
	return res
