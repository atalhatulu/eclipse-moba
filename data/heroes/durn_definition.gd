class_name DurnDefinition
extends RefCounted

## Static data definition and archetype resource for Durn (STR Siege Fighter / Heavy Artillery)

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
	
	# Passive: Iron Hull (Innate)
	var passive = AbilityDefinition.new()
	passive.id = "durn_passive"
	passive.ability_name = "Ağır Gövde (Iron Hull)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Durn geri savrulmalara (Knockback) bağışıktır ve sabit durduğunda zırhı %30 artar."
	hero.passive_ability = passive
	
	# Q: Mortar Shell
	var q = AbilityDefinition.new()
	q.id = "durn_q"
	q.ability_name = "Havan Topu (Mortar Shell)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.GROUND_AOE
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "1100 metre menzile parabolik ağır havan mermisi fırlatır; alandaki düşmanlara fiziksel hasar verir ve merkezdekileri 0.8 saniye sersemletir."
	q.cooldowns.assign([7.0, 6.5, 6.0, 5.5])
	q.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	q.base_damage.assign([90.0, 145.0, 200.0, 255.0])
	q.cast_range = 1100.0
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.85
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.q_ability = q
	
	# W: Deploy Siege Mode
	var w = AbilityDefinition.new()
	w.id = "durn_w"
	w.ability_name = "Kuşatma Modu (Deploy Siege Mode)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SELF
	w.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	w.description = "Durn hidrolik ayaklarını yere çakarak Kuşatma Moduna geçer: Hareket Hızı 0 olur, Saldırı Menzili 1600m'ye çıkar (+%200 menzil), normal saldırıları alan hasarı vuran havan güllesine dönüşür ve +50 Zırh/Direnç kazanır. Tekrar basıldığında toplanır."
	w.cooldowns.assign([5.0, 4.0, 3.0, 2.0])
	w.mana_costs.assign([30.0, 30.0, 30.0, 30.0])
	hero.w_ability = w
	
	# E: Concussion Blast
	var e = AbilityDefinition.new()
	e.id = "durn_e"
	e.ability_name = "Geri Tepme Şoku (Concussion Blast)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.GROUND_AOE
	e.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	e.description = "Namlu ucundan yıkıcı bir şok dalgası patlatır; yakınındaki tüm düşmanları 5 metre geri savurur ve hasar verirken Durn'ü 2 metre geriye iter."
	e.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	e.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	e.base_damage.assign([80.0, 130.0, 180.0, 230.0])
	e.cast_range = 450.0
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.70
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.e_ability = e
	
	# R: Orbital Siege Devastation (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "durn_r"
	r.ability_name = "Yörüngesel Ağır Bombardıman (Orbital Devastation)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	r.max_level = 3
	r.description = "1500 metre menzile 3 dalga halinde devasa sismik top mermisi yağdırır; yıkıcı fiziksel alan hasarı vurur ve düşmanların zırhını 5 saniyeliğine %35 parçalar."
	r.cooldowns.assign([85.0, 70.0, 55.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	r.base_damage.assign([250.0, 400.0, 550.0])
	r.cast_range = 1500.0
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.25
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
