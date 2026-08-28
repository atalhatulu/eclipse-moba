class_name MiraDefinition
extends RefCounted

## Static data definition and archetype resource for Mira (AGI Mobility Carry / Velocity & Sonic Run)

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "mira"
	hero.id = "mira"
	hero.hero_name = "Mira"
	hero.role = "Hızlı Taşıyıcı / Koşucu"
	hero.role_description = "Mobility Carry / Kinetic Sprinter (AGI)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.AGILITY
	hero.attack_type = HeroResource.AttackType.RANGED
	
	# Base Attributes & Growths
	hero.base_agility = 27.0
	hero.agility_growth = 3.3
	hero.base_strength = 17.0
	hero.strength_growth = 1.6
	hero.base_intelligence = 16.0
	hero.intelligence_growth = 1.4
	
	# Base Combat Stats
	hero.base_health = 540.0
	hero.base_health_regen = 1.8
	hero.base_mana = 260.0
	hero.base_mana_regen = 1.4
	hero.base_attack_damage = 46.0
	hero.base_ability_power = 0.0
	hero.base_armor = 21.0
	hero.base_magic_resist = 28.0
	hero.base_attack_speed = 0.74
	hero.base_move_speed = 330.0 # High base speed
	hero.base_attack_range = 525.0
	
	# Projectile
	hero.projectile_speed = 28.0
	hero.projectile_color = Color(0.95, 0.85, 0.20, 1.0)
	hero.projectile_radius = 0.25
	
	# Passive: Velocity (Innate)
	var passive = AbilityDefinition.new()
	passive.id = "mira_passive"
	passive.ability_name = "Sürat (Velocity)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Mira'nın Hareket Hızı arttıkça Saldırı Gücü artar. 330 temel hızın üzerindeki her +10 Hareket Hızı +2.5 Saldırı Gücü kazandırır."
	hero.passive_ability = passive
	
	# Q: Dash Strike
	var q = AbilityDefinition.new()
	q.id = "mira_q"
	q.ability_name = "Koşu Darbesi (Dash Strike)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Hedefe doğru hızla 4.5m atılarak fiziksel hasar verir ve Mira'nın bir sonraki normal saldırısını anında sıfırlar."
	q.cooldowns.assign([6.0, 5.5, 5.0, 4.5])
	q.mana_costs.assign([45.0, 50.0, 55.0, 60.0])
	q.base_damage.assign([75.0, 120.0, 165.0, 210.0])
	q.cast_range = 550.0
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.70
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.q_ability = q
	
	# W: Slip
	var w = AbilityDefinition.new()
	w.id = "mira_w"
	w.ability_name = "Kayıp Kaçış (Slip)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SELF
	w.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	w.description = "0.6 saniye boyunca gelen tüm hasarlardan kaçınır (Evade) ve 2.0 saniye boyunca +%25 Hareket Hızı kazanır."
	w.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	w.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	w.base_damage.assign([0.0, 0.0, 0.0, 0.0])
	w.cast_range = 0.0
	hero.w_ability = w
	
	# E: Accelerate
	var e = AbilityDefinition.new()
	e.id = "mira_e"
	e.ability_name = "Hızlanma (Accelerate)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SELF
	e.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	e.description = "4.0 saniye boyunca +%40 Hareket Hızı ve +%30 Saldırı Hızı kazanır. Bu sırada yavaşlatma etkilerini %50 azaltır."
	e.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	e.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	e.base_damage.assign([0.0, 0.0, 0.0, 0.0])
	e.cast_range = 0.0
	hero.e_ability = e
	
	# R: Sonic Run (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "mira_r"
	r.ability_name = "Ses Hızı Koşusu (Sonic Run)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.SELF
	r.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	r.description = "5.0 saniye boyunca +%80 Hareket Hızı kazanır, birimlerin içinden geçebilir (Phasing) ve temas ettiği düşmanlara fiziksel hasar verir."
	r.cooldowns.assign([75.0, 65.0, 55.0])
	r.mana_costs.assign([90.0, 105.0, 120.0])
	r.base_damage.assign([150.0, 230.0, 310.0])
	r.cast_range = 0.0
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 0.60
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
