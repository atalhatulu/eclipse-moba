class_name KaeliDefinition
extends RefCounted

## Static data definition and archetype resource for Kaeli (AGI Carry / Rhythm Weaver)

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "kaeli"
	hero.id = "kaeli"
	hero.hero_name = "Kaeli"
	hero.role = "Taşıyıcı / Ritim Bıçağı"
	hero.role_description = "Carry / Rhythm Weaver (AGI)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.AGILITY
	hero.attack_type = HeroResource.AttackType.MELEE
	
	# Base Attributes & Growths
	hero.base_agility = 26.0
	hero.agility_growth = 3.3
	hero.base_strength = 18.0
	hero.strength_growth = 1.8
	hero.base_intelligence = 16.0
	hero.intelligence_growth = 1.4
	
	# Base Combat Stats
	hero.base_health = 570.0
	hero.base_health_regen = 2.0
	hero.base_mana = 260.0
	hero.base_mana_regen = 1.2
	hero.base_attack_damage = 51.0
	hero.base_ability_power = 0.0
	hero.base_armor = 23.0
	hero.base_magic_resist = 28.0
	hero.base_attack_speed = 0.72
	hero.base_move_speed = 320.0
	hero.base_attack_range = 175.0
	
	# Passive: Rhythm (Innate)
	var passive = AbilityDefinition.new()
	passive.id = "kaeli_passive"
	passive.ability_name = "Ritim (Rhythm)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Farklı yetenekler sırayla kullanıldığında Ritim yükü biriktirir (azami 4). Her yük +%8 Saldırı Hızı ve +%4 Hareket Hızı sağlar."
	hero.passive_ability = passive
	
	# Q: Twin Cut
	var q = AbilityDefinition.new()
	q.id = "kaeli_q"
	q.ability_name = "Çift Kesik (Twin Cut)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Hedefe iki hızlı fiziksel darbe indirir. Farklı bir yetenekten sonra kullanılırsa Ritim yükü kazandırır."
	q.cooldowns.assign([5.0, 4.5, 4.0, 3.5])
	q.mana_costs.assign([35.0, 40.0, 45.0, 50.0])
	q.base_damage.assign([45.0, 75.0, 105.0, 135.0])
	q.cast_range = 225.0
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.45
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.q_ability = q
	
	# W: Slipstream
	var w = AbilityDefinition.new()
	w.id = "kaeli_w"
	w.ability_name = "Akıntı (Slipstream)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SELF
	w.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	w.description = "Hedeflenen yöne doğru kısa ve çevik bir atılma gerçekleştirir. Ritim zincirini devam ettirir."
	w.cooldowns.assign([8.0, 7.0, 6.0, 5.0])
	w.mana_costs.assign([40.0, 45.0, 50.0, 55.0])
	hero.w_ability = w
	
	# E: Crossfire
	var e = AbilityDefinition.new()
	e.id = "kaeli_e"
	e.ability_name = "Çapraz Ateş (Crossfire)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SELF
	e.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	e.description = "Bir sonraki temel saldırıyı güçlendirerek hedefin arkasındaki koni alana ilave fiziksel hasar saçar."
	e.cooldowns.assign([9.0, 8.0, 7.0, 6.0])
	e.mana_costs.assign([45.0, 50.0, 55.0, 60.0])
	e.base_damage.assign([60.0, 95.0, 130.0, 165.0])
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.60
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.e_ability = e
	
	# R: Perfect Tempo (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "kaeli_r"
	r.ability_name = "Mükemmel Tempo (Perfect Tempo)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.SELF
	r.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	r.max_level = 3
	r.description = "6 saniye boyunca +%60 Saldırı Hızı, +%20 Hareket Hızı kazanır ve temel yeteneklerin bekleme sürelerini anında %50 azaltır."
	r.cooldowns.assign([70.0, 60.0, 50.0])
	r.mana_costs.assign([100.0, 100.0, 100.0])
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
