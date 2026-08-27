class_name DurnDefinition
extends RefCounted

## Static data definition and archetype resource for Durn (STR Siege Fighter / Heavy Artillery)

const AbilityDefinition = preload("res://core/abilities/ability_definition.gd")

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "durn"
	hero.id = "durn"
	hero.hero_name = "Durn"
	hero.role = "Kuşatma Savaşçısı / Ağır Topçu"
	hero.role_description = "Siege Fighter / Stationary Artillery (STR)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	hero.attack_type = HeroResource.AttackType.RANGED
	
	# Base Attributes & Growths
	hero.base_strength = 27.0
	hero.strength_growth = 3.4
	hero.base_agility = 15.0
	hero.agility_growth = 1.5
	hero.base_intelligence = 17.0
	hero.intelligence_growth = 1.5
	
	# Base Combat Stats
	hero.base_health = 630.0
	hero.base_health_regen = 2.6
	hero.base_mana = 280.0
	hero.base_mana_regen = 1.4
	hero.base_attack_damage = 52.0
	hero.base_ability_power = 0.0
	hero.base_armor = 25.0
	hero.base_magic_resist = 30.0
	hero.base_attack_speed = 0.62
	hero.base_move_speed = 295.0
	hero.base_attack_range = 500.0
	
	# Projectile
	hero.projectile_speed = 22.0
	hero.projectile_color = Color(0.85, 0.45, 0.20, 1.0)
	hero.projectile_radius = 0.35
	
	# Passive: Siege Stance (Innate)
	var passive = AbilityDefinition.new()
	passive.id = "durn_passive"
	passive.ability_name = "Kuşatma Pozisyonu (Siege Stance)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "1.5 saniye boyunca hareket etmeden durulduğunda +200 Saldırı Menzili ve +%25 Saldırı Gücü kazanır. Hareket edildiğinde bonus anında kaybolur."
	hero.passive_ability = passive
	
	# Q: Boulder Shot
	var q = AbilityDefinition.new()
	q.id = "durn_q"
	q.ability_name = "Kaya Atışı (Boulder Shot)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Uzun menzilden ağır bir kaya güllesi fırlatarak fiziksel hasar verir. Kuşatma pozisyonundayken fazladan %20 hasar uygular."
	q.cooldowns.assign([7.5, 7.0, 6.5, 6.0])
	q.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	q.base_damage.assign([90.0, 145.0, 200.0, 255.0])
	q.cast_range = 750.0
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.85
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.q_ability = q
	
	# W: Fortify
	var w = AbilityDefinition.new()
	w.id = "durn_w"
	w.ability_name = "Tahkimat (Fortify)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SELF
	w.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	w.description = "5 saniye boyunca Durn'e +35/50/65/80 Zırh ve Büyü Direnci sağlar."
	w.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	w.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	hero.w_ability = w
	
	# E: Shock Mine
	var e = AbilityDefinition.new()
	e.id = "durn_e"
	e.ability_name = "Şok Mayını (Shock Mine)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.GROUND_AOE
	e.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	e.description = "Hedef konuma gizli bir şok mayını bırakır. Yaklaşan düşmanlar mayını tetikleyerek alan hasarı alır ve 2 saniye %40 yavaşlar."
	e.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	e.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	e.base_damage.assign([75.0, 120.0, 165.0, 210.0])
	e.cast_range = 500.0
	e.damage_type = DamageRequest.DamageType.MAGICAL
	hero.e_ability = e
	
	# R: Grand Barrage (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "durn_r"
	r.ability_name = "Büyük Bombardıman (Grand Barrage)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	r.max_level = 3
	r.description = "Geniş hedef bölgeye 3 dalga halinde ağır top mermisi yağdırarak yıkıcı alan hasarı verir."
	r.cooldowns.assign([85.0, 75.0, 65.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	r.base_damage.assign([240.0, 380.0, 520.0])
	r.cast_range = 900.0
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.20
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
