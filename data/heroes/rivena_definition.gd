class_name RivenaDefinition
extends RefCounted

## Static data definition and archetype resource for Rivena (AGI Assassin / Shadow Echo Duelist)

const AbilityDefinition = preload("res://core/abilities/ability_definition.gd")

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "rivena"
	hero.id = "rivena"
	hero.hero_name = "Rivena"
	hero.role = "Suikastçı / Gölge İllüzyonisti"
	hero.role_description = "Assassin / Shadow Echo Duelist (AGI)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.AGILITY
	hero.attack_type = HeroResource.AttackType.MELEE
	
	# Base Attributes & Growths
	hero.base_agility = 26.0
	hero.agility_growth = 3.3
	hero.base_strength = 18.0
	hero.strength_growth = 1.8
	hero.base_intelligence = 19.0
	hero.intelligence_growth = 1.8
	
	# Base Combat Stats
	hero.base_health = 560.0
	hero.base_health_regen = 1.8
	hero.base_mana = 300.0
	hero.base_mana_regen = 1.6
	hero.base_attack_damage = 52.0
	hero.base_ability_power = 0.0
	hero.base_armor = 22.0
	hero.base_magic_resist = 28.0
	hero.base_attack_speed = 0.72
	hero.base_move_speed = 320.0
	hero.base_attack_range = 175.0
	
	# Passive: Echo (Innate)
	var passive = AbilityDefinition.new()
	passive.id = "rivena_passive"
	passive.ability_name = "Gölge Yankısı (Echo)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Yetenek kullanımlarında 5 saniye süren Gölge Yankıları (Shade) oluşturur (azami 3)."
	hero.passive_ability = passive
	
	# Q: Shadow Cut
	var q = AbilityDefinition.new()
	q.id = "rivena_q"
	q.ability_name = "Gölge Kesisi (Shadow Cut)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Hedefe fiziksel hasar verir. Sahadaki tüm aktif Gölgeler de hedefe %50 ilave darbe vurur."
	q.cooldowns.assign([6.0, 5.5, 5.0, 4.5])
	q.mana_costs.assign([45.0, 50.0, 55.0, 60.0])
	q.base_damage.assign([85.0, 135.0, 185.0, 235.0])
	q.cast_range = 350.0
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.80
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.q_ability = q
	
	# W: Echo Step
	var w = AbilityDefinition.new()
	w.id = "rivena_w"
	w.ability_name = "Yankı Adımı (Echo Step)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SELF
	w.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	w.description = "En yakındaki aktif Gölgenin konumuna ışınlanır ve eski yerinde yeni bir Gölge bırakır."
	w.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	w.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	hero.w_ability = w
	
	# E: Shade Command
	var e = AbilityDefinition.new()
	e.id = "rivena_e"
	e.ability_name = "Gölge Emri (Shade Command)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	e.description = "Tüm aktif Gölgeleri hedef düşmana doğru hücuma geçirerek Gölge başına fiziksel hasar verir."
	e.cooldowns.assign([9.0, 8.0, 7.0, 6.0])
	e.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	e.base_damage.assign([60.0, 95.0, 130.0, 165.0])
	e.cast_range = 550.0
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.50
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.e_ability = e
	
	# R: Nightfall (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "rivena_r"
	r.ability_name = "Gece Çöküşü (Nightfall)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.SELF
	r.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	r.max_level = 3
	r.description = "Anında 2 ek Gölge yaratır, 6 saniye boyunca +%35 Hareket Hızı ve +30 Saldırı Gücü kazanır."
	r.cooldowns.assign([75.0, 65.0, 55.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
