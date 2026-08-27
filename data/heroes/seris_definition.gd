class_name SerisDefinition
extends RefCounted

## Static data definition and archetype resource for Seris (AGI Trapper / Razor Traps & Precision Shot)

const AbilityDefinition = preload("res://core/abilities/ability_definition.gd")

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "seris"
	hero.id = "seris"
	hero.hero_name = "Seris"
	hero.role = "Tuzakçı / Keskin Nişancı"
	hero.role_description = "Trapper / Precision Sniper (AGI)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.AGILITY
	hero.attack_type = HeroResource.AttackType.RANGED
	
	# Base Attributes & Growths
	hero.base_agility = 26.0
	hero.agility_growth = 3.2
	hero.base_strength = 18.0
	hero.strength_growth = 1.7
	hero.base_intelligence = 18.0
	hero.intelligence_growth = 1.6
	
	# Base Combat Stats
	hero.base_health = 560.0
	hero.base_health_regen = 2.0
	hero.base_mana = 270.0
	hero.base_mana_regen = 1.5
	hero.base_attack_damage = 50.0
	hero.base_ability_power = 0.0
	hero.base_armor = 22.0
	hero.base_magic_resist = 28.0
	hero.base_attack_speed = 0.72
	hero.base_move_speed = 320.0
	hero.base_attack_range = 550.0
	
	# Projectile
	hero.projectile_speed = 26.0
	hero.projectile_color = Color(0.2, 0.85, 0.65, 1.0)
	hero.projectile_radius = 0.25
	
	# Passive: Precision (Innate)
	var passive = AbilityDefinition.new()
	passive.id = "seris_passive"
	passive.ability_name = "Keskin Nişan (Precision)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Tuzak (Razor Trap) alanında veya tetiklenmiş hedeflere karşı normal saldırılar ve yetenekler +%30 ilave fiziksel hasar verir."
	hero.passive_ability = passive
	
	# Q: Needle Shot
	var q = AbilityDefinition.new()
	q.id = "seris_q"
	q.ability_name = "İğne Atışı (Needle Shot)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Uzun menzilli yüksek hızlı bir iğne fırlatarak fiziksel hasar verir. Tuzaklı hedeflere zırh delme uygular."
	q.cooldowns.assign([6.0, 5.5, 5.0, 4.5])
	q.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	q.base_damage.assign([80.0, 130.0, 180.0, 230.0])
	q.cast_range = 650.0
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.75
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.q_ability = q
	
	# W: Razor Trap
	var w = AbilityDefinition.new()
	w.id = "seris_w"
	w.ability_name = "Jiletli Tuzak (Razor Trap)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.GROUND_AOE
	w.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	w.description = "Hedef noktaya 60 saniye kalan gizli tuzak yerleştirir (azami 4). Düşman bastığında patlayarak fiziksel hasar verir ve %40 yavaşlatır."
	w.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	w.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	w.base_damage.assign([70.0, 115.0, 160.0, 205.0])
	w.cast_range = 550.0
	w.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.scaling_ratio = 0.60
	w.damage_type = DamageRequest.DamageType.PHYSICAL
	w.applies_status_effect = true
	w.effect_type = StatusEffect.EffectType.SLOW
	w.effect_duration = 2.5
	w.effect_intensity = 0.40
	hero.w_ability = w
	
	# E: Trigger Wire
	var e = AbilityDefinition.new()
	e.id = "seris_e"
	e.ability_name = "Tetik Teli (Trigger Wire)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SELF
	e.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	e.description = "Tüm aktif tuzakları aynı anda tetikleyerek patlatır ve Seris'e 3 saniye boyunca +%30 Hareket Hızı kazandırır."
	e.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	e.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	e.base_damage.assign([50.0, 80.0, 110.0, 140.0])
	e.cast_range = 0.0
	hero.e_ability = e
	
	# R: Hunting Ground (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "seris_r"
	r.ability_name = "Av Sahası (Hunting Ground)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	r.description = "Geniş bir alana anında 3 adet Jiletli Tuzak fırlatır ve alandaki tüm düşmanları 1.5 saniyeliğine sabitler (Root/Slow)."
	r.cooldowns.assign([80.0, 70.0, 60.0])
	r.mana_costs.assign([100.0, 115.0, 130.0])
	r.base_damage.assign([180.0, 280.0, 380.0])
	r.cast_range = 750.0
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 0.85
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
