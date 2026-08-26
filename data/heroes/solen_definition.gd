class_name SolenDefinition
extends RefCounted

## Static data definition and archetype resource for Solen - The Solar Archer (Ranged AGI Marksman)

const HeroRes = preload("res://core/entities/hero_resource.gd")

static func create_resource() -> HeroResource:
	return create_solen_resource()

static func create_solen_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.id = "solen"
	hero.hero_name = "Solen"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.AGILITY
	hero.attack_type = HeroRes.AttackType.RANGED
	hero.role_description = "Menzilli Nişancı / Fiziksel Taşıyıcı (Marksman Carry)"
	
	# Base Stats
	hero.base_health = 540.0
	hero.base_mana = 280.0
	hero.base_health_regen = 2.2
	hero.base_mana_regen = 1.6
	
	hero.base_strength = 18.0
	hero.base_agility = 24.0
	hero.base_intelligence = 15.0
	
	hero.strength_growth = 1.9
	hero.agility_growth = 3.2
	hero.intelligence_growth = 1.4
	
	hero.base_attack_damage = 54.0
	hero.base_armor = 18.0
	hero.base_magic_resist = 25.0
	hero.base_attack_speed = 0.95 # Fast snappy auto-attack cadence
	hero.base_move_speed = 320.0
	hero.base_attack_range = 625.0 # 6.25m Long Range
	
	# Passive: Solar Charge (Innate)
	var passive = AbilityResource.new()
	passive.id = "solen_passive"
	passive.ability_name = "Güneş Yükü (Solar Charge)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Solen'in her normal saldırısı 1 Güneş Yükü biriktirir. 5. vuruşta yükler patlayarak hedefe ilave 60/100/140/180 saf güneş hasarı verir ve %40 Zırh Deler."
	hero.passive_ability = passive
	
	# Abilities Setup
	var q = _create_q_ability()
	var w = _create_w_ability()
	var e = _create_e_ability()
	var r = _create_r_ability()
	hero.q_ability = q
	hero.w_ability = w
	hero.e_ability = e
	hero.r_ability = r
	hero.abilities.assign([passive, q, w, e, r])
	
	return hero

static func _create_q_ability() -> AbilityResource:
	var q = AbilityResource.new()
	q.id = "solen_q"
	q.ability_name = "Delici Güneş Oku (Piercing Arrow)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.DIRECTIONAL
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Hedef doğrultuya 13 metre boyunca tüm düşman ve minyonları delip geçen yoğunlaştırılmış bir güneş oku fırlatır. Delinen her hedefe fiziksel hasar uygular."
	q.cooldowns.assign([7.0, 6.5, 6.0, 5.5])
	q.mana_costs.assign([60.0, 70.0, 80.0, 90.0])
	q.base_damage.assign([90.0, 160.0, 230.0, 300.0])
	q.cast_range = 1300.0
	q.aoe_radius = 1.4
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.90
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	return q

static func _create_w_ability() -> AbilityResource:
	var w = AbilityResource.new()
	w.id = "solen_w"
	w.ability_name = "Kör Edici Işık (Blinding Flash)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SELF
	w.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	w.description = "Solen çevresine parlak bir güneş patlaması yayar. 4.5 metre içindeki tüm düşmanları 3.5 metre geriye iter, 2 saniye kör eder ve hasar verir."
	w.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	w.mana_costs.assign([75.0, 85.0, 95.0, 105.0])
	w.base_damage.assign([70.0, 120.0, 170.0, 220.0])
	w.cast_range = 450.0
	w.aoe_radius = 4.5
	q_stat(w)
	return w

static func q_stat(w: AbilityResource) -> void:
	w.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.scaling_ratio = 0.50
	w.damage_type = DamageRequest.DamageType.PHYSICAL

static func _create_e_ability() -> AbilityResource:
	var e = AbilityResource.new()
	e.id = "solen_e"
	e.ability_name = "Çevik Takla (Solar Vault)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SELF
	e.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	e.description = "Solen baktığı yönün tersine doğru 5 metre çevik bir takla atarak kaçar ve 4 saniyeliğine +%40/+55/+70/+85 Saldırı Hızı ve +%20 Hareket Hızı kazanır."
	e.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	e.mana_costs.assign([50.0, 50.0, 50.0, 50.0])
	e.base_damage.assign([0.0, 0.0, 0.0, 0.0])
	e.cast_range = 500.0
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.0
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	return e

static func _create_r_ability() -> AbilityResource:
	var r = AbilityResource.new()
	r.id = "solen_r"
	r.ability_name = "Süpernova Yağmuru (Supernova Barrage)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	r.description = "Hedeflenen 6 metre çapındaki alana 2.5 saniye boyunca güneş okları yağdırır. Alandaki tüm düşmanları %40 yavaşlatır ve ağır fiziksel hasar verir."
	r.cooldowns.assign([75.0, 65.0, 55.0])
	r.mana_costs.assign([120.0, 150.0, 180.0])
	r.base_damage.assign([350.0, 550.0, 750.0])
	r.cast_range = 1200.0
	r.aoe_radius = 6.0
	r.max_level = 3
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.10
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	return r
