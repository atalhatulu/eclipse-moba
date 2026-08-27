class_name VaelDefinition
extends RefCounted

## Static data definition and archetype resource for Vael (INT Artillery / Calibration & Falling Star)

const AbilityDefinition = preload("res://core/abilities/ability_definition.gd")

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "vael"
	hero.id = "vael"
	hero.hero_name = "Vael"
	hero.role = "Ağır Büyü Topçusu / Yıldız Nişancısı"
	hero.role_description = "Artillery Mage / Starfall Bombardier (INT)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.INTELLIGENCE
	hero.attack_type = HeroResource.AttackType.RANGED
	
	# Base Attributes & Growths
	hero.base_intelligence = 28.0
	hero.intelligence_growth = 3.4
	hero.base_strength = 17.0
	hero.strength_growth = 1.6
	hero.base_agility = 15.0
	hero.agility_growth = 1.4
	
	# Base Combat Stats
	hero.base_health = 510.0
	hero.base_health_regen = 1.8
	hero.base_mana = 460.0
	hero.base_mana_regen = 3.5
	hero.base_attack_damage = 40.0
	hero.base_ability_power = 0.0
	hero.base_armor = 15.0
	hero.base_magic_resist = 26.0
	hero.base_attack_speed = 0.65
	hero.base_move_speed = 310.0
	hero.base_attack_range = 600.0 # Long baseline range
	
	# Projectile
	hero.projectile_speed = 28.0
	hero.projectile_color = Color(0.2, 0.6, 1.0, 1.0)
	hero.projectile_radius = 0.30
	
	# Passive: Calibration (Innate)
	var passive = AbilityDefinition.new()
	passive.id = "vael_passive"
	passive.ability_name = "Kalibrasyon (Calibration)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Aynı yönde yetenek kullanıldıkça Kalibrasyon yükü kazanır (azami 3). Her yük büyü menzilini +%15 ve büyü hasarını +%10 artırır."
	hero.passive_ability = passive
	
	# Q: Star Lance
	var q = AbilityDefinition.new()
	q.id = "vael_q"
	q.ability_name = "Yıldız Mızrağı (Star Lance)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "850.0 menzile kadar uzanan dar hat yıldız ışını fırlatarak ağır büyüsel hasar verir."
	q.cooldowns.assign([6.0, 5.5, 5.0, 4.5])
	q.mana_costs.assign([60.0, 70.0, 80.0, 90.0])
	q.base_damage.assign([90.0, 145.0, 200.0, 255.0])
	q.cast_range = 850.0
	q.scaling_stat = StatModifier.TargetStat.INTELLIGENCE
	q.scaling_ratio = 0.80
	q.damage_type = DamageRequest.DamageType.MAGICAL
	hero.q_ability = q
	
	# W: Astral Marker
	var w = AbilityDefinition.new()
	w.id = "vael_w"
	w.ability_name = "Astral İşaret (Astral Marker)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SINGLE_TARGET
	w.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	w.description = "Uzak mesafedeki hedefi 6 saniyeliğine işaretler, görüşünü açar ve büyü direncini %20 kırar."
	w.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	w.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	w.base_damage.assign([50.0, 80.0, 110.0, 140.0])
	w.cast_range = 800.0
	w.scaling_stat = StatModifier.TargetStat.INTELLIGENCE
	w.scaling_ratio = 0.40
	w.damage_type = DamageRequest.DamageType.MAGICAL
	hero.w_ability = w
	
	# E: Warp Sight
	var e = AbilityDefinition.new()
	e.id = "vael_e"
	e.ability_name = "Büküm Görüşü (Warp Sight)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SELF
	e.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	e.description = "5.0 saniye boyunca Vael'e +300 Görüş Alanı ve tüm yeteneklerine +200 Atış Menzili kazandırır."
	e.cooldowns.assign([15.0, 14.0, 13.0, 12.0])
	e.mana_costs.assign([60.0, 65.0, 70.0, 70.0])
	e.base_damage.assign([0.0, 0.0, 0.0, 0.0])
	e.cast_range = 0.0
	hero.e_ability = e
	
	# R: Falling Star (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "vael_r"
	r.ability_name = "Düşen Yıldız (Falling Star)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	r.description = "1400.0 menzile kadar hedef dairesel alana dev bir yıldız meteoru yağdırır. Merkezdeki düşmanlara +%50 hasar verir."
	r.cooldowns.assign([85.0, 75.0, 65.0])
	r.mana_costs.assign([120.0, 140.0, 160.0])
	r.base_damage.assign([250.0, 380.0, 510.0])
	r.cast_range = 1400.0
	r.scaling_stat = StatModifier.TargetStat.INTELLIGENCE
	r.scaling_ratio = 0.90
	r.damage_type = DamageRequest.DamageType.MAGICAL
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
