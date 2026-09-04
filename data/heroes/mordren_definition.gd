class_name MordrenDefinition
extends RefCounted

## Static data definition and archetype resource for Mordren (STR Fighter / Executioner)

static func create_resource() -> HeroResource:
	var hero = HeroResource.new()
	hero.hero_id = "mordren"
	hero.id = "mordren"
	hero.hero_name = "Mordren"
	hero.role = "Dövüşçü / Suikastçı"
	hero.role_description = "Fighter / Executioner (STR / AD)"
	hero.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	hero.attack_type = HeroResource.AttackType.MELEE
	
	# Base Attributes & Growths
	hero.base_strength = 25.0
	hero.strength_growth = 3.2
	hero.base_agility = 19.0
	hero.agility_growth = 2.0
	hero.base_intelligence = 15.0
	hero.intelligence_growth = 1.3
	
	# Base Combat Stats
	hero.base_health = 590.0
	hero.base_health_regen = 2.2
	hero.base_mana = 270.0
	hero.base_mana_regen = 1.4
	hero.base_attack_damage = 46.0
	hero.base_ability_power = 0.0
	hero.base_armor = 23.0
	hero.base_magic_resist = 28.0
	hero.base_attack_speed = 0.69
	hero.base_move_speed = 315.0
	hero.base_attack_range = 175.0
	
	# Passive: Hunt Mark (Innate)
	var passive = AbilityDefinition.new()
	passive.id = "mordren_passive"
	passive.ability_name = "Av Damgası (Hunt Mark)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	passive.description = "Düşman kahramanlara hasar verildiğinde üzerlerine 5 saniyelik Av Damgası bırakır. Yeniden hasar vermek süreyi tazeler."
	hero.passive_ability = passive
	
	# Q: Cleaver
	var q = AbilityDefinition.new()
	q.id = "mordren_q"
	q.ability_name = "Satır (Cleaver)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	q.description = "Hedefe güçlü bir satır darbesi indirir. Hedefte Av Damgası varsa %50 fazladan hasar verir."
	q.cooldowns.assign([6.0, 5.5, 5.0, 4.5])
	q.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	q.base_damage.assign([85.0, 135.0, 185.0, 235.0])
	q.cast_range = 250.0
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.75
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.q_ability = q
	
	# W: Blood Trail
	var w = AbilityDefinition.new()
	w.id = "mordren_w"
	w.ability_name = "Kan İzi (Blood Trail)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SELF
	w.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	w.description = "Av Damgası taşıyan düşmanlara doğru ilerlerken hareket hızını %25 artırır. Aktif edildiğinde 3 saniye ani hız patlaması sağlar."
	w.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	w.mana_costs.assign([55.0, 60.0, 65.0, 70.0])
	hero.w_ability = w
	
	# E: Relentless
	var e = AbilityDefinition.new()
	e.id = "mordren_e"
	e.ability_name = "Aman Vermez (Relentless)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SELF
	e.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	e.description = "Damgalı düşmana hasar verildiğinde Mordren 4 saniye süren kalkan kazanır. Üst üste binmez, süresi yenilenir."
	e.cooldowns.assign([12.0, 11.0, 10.0, 9.0])
	e.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	hero.e_ability = e
	
	# R: Final Hunt (Ultimate)
	var r = AbilityDefinition.new()
	r.id = "mordren_r"
	r.ability_name = "Son Av (Final Hunt)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.SINGLE_TARGET
	r.target_filter = AbilityResource.TargetFilter.ENEMY_HEROES_ONLY
	r.max_level = 3
	r.description = "Yalnızca %35 veya altı cana sahip Damgalı düşman kahramanlara kullanılabilir. Hedefe atılır; fiziksel darbeye ek olarak eksik canın %20/%25/%30'u kadar saf infaz hasarı verir."
	r.cooldowns.assign([75.0, 65.0, 55.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	r.base_damage.assign([250.0, 400.0, 550.0])
	r.cast_range = 650.0
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.20
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	hero.r_ability = r
	
	hero.abilities.assign([passive, q, w, e, r])
	return hero
