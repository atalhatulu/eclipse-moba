class_name ZarekDefinition
extends RefCounted

## Static data definition and archetype resource for Zarek (AGI Anti-Mage / Mana Hunter & Null Field)

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "zarek"
	hero.id = "zarek"
	hero.hero_name = "Zarek"
	hero.role = "Anti-Büyücü / Suikastçı"
	hero.role_description = "Anti-Mage / Spellblade Executioner (AGI)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.AGILITY
	hero.attack_type = HeroResource.AttackType.MELEE
	
	# Base Attributes & Growths
	hero.base_agility = 26.0
	hero.agility_growth = 3.2
	hero.base_strength = 20.0
	hero.strength_growth = 2.0
	hero.base_intelligence = 16.0
	hero.intelligence_growth = 1.5
	
	# Base Combat Stats
	hero.base_health = 580.0
	hero.base_health_regen = 2.2
	hero.base_mana = 270.0
	hero.base_mana_regen = 1.5
	hero.base_attack_damage = 52.0
	hero.base_ability_power = 0.0
	hero.base_armor = 24.0
	hero.base_magic_resist = 34.0 # High MR Anti-Mage
	hero.base_attack_speed = 0.72
	hero.base_move_speed = 320.0
	hero.base_attack_range = 175.0
	
	# Passive: Mana Hunter (Innate)
	var passive = AbilityDefinition.new()
	passive.id = "zarek_passive"
	passive.ability_name = "Mana Avcısı (Mana Hunter)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Normal saldırılar hedefin mevcut manasının %6'sını (en az 20) yakarak büyüsel hasara dönüştürür."
	hero.passive_ability = passive
	
	# Q: Drain Edge
	var q = AbilityDefinition.new()
	q.id = "zarek_q"
	q.ability_name = "Sömürücü Bıçak (Drain Edge)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Hedefe güçlü bir anti-mana darbesi vurur; 50/75/100/125 mana yakar ve yakılan mananın %100'ünü Zarek'e geri doldurur."
	q.cooldowns.assign([6.0, 5.5, 5.0, 4.5])
	q.mana_costs.assign([40.0, 45.0, 50.0, 55.0])
	q.base_damage.assign([80.0, 125.0, 170.0, 215.0])
	q.cast_range = 250.0
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.75
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.q_ability = q
	
	# W: Phase Cut
	var w = AbilityDefinition.new()
	w.id = "zarek_w"
	w.ability_name = "Boyut Kesisi (Phase Cut)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SINGLE_TARGET
	w.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	w.description = "Hedef düşmanın arkasına 5.0m mesafeden anında ışınlanarak fiziksel hasar verir."
	w.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	w.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	w.base_damage.assign([70.0, 110.0, 150.0, 190.0])
	w.cast_range = 550.0
	w.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	w.scaling_ratio = 0.65
	w.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.w_ability = w
	
	# E: Silence Mark
	var e = AbilityDefinition.new()
	e.id = "zarek_e"
	e.ability_name = "Susturma Damgası (Silence Mark)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	e.description = "Hedef büyücüyü 2.0 saniyeliğine susturur (Silence) ve büyü direncini %25 kırar."
	e.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	e.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	e.base_damage.assign([60.0, 95.0, 130.0, 165.0])
	e.cast_range = 350.0
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.50
	e.damage_type = DamageRequest.DamageType.MAGICAL
	e.applies_status_effect = true
	e.effect_type = StatusEffect.EffectType.SILENCE
	e.effect_duration = 2.0
	hero.e_ability = e
	
	# R: Null Field (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "zarek_r"
	r.ability_name = "Hükümsüzlük Alanı (Null Field)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	r.description = "6.0 saniye süren dairesel anti-büyü alanı açar. Alandaki düşmanların mana bedelleri %100 artar ve hedefin eksik manası oranında patlama hasarı verir."
	r.cooldowns.assign([80.0, 70.0, 60.0])
	r.mana_costs.assign([100.0, 115.0, 130.0])
	r.base_damage.assign([200.0, 300.0, 400.0])
	r.cast_range = 600.0
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 0.80
	r.damage_type = DamageRequest.DamageType.MAGICAL
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
