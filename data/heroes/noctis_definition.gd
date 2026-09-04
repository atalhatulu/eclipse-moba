class_name NoctisDefinition
extends RefCounted

## Noctis - The Sensory Thief

static func create_resource() -> HeroResource:
	var res = HeroResource.new()
	res.hero_id = "noctis"
	res.hero_name = "Noctis"
	res.title = "The Sensory Thief"
	res.lore = "A faceless wraith who absorbs surrounding starlight to blind enemy vision and plunge teams into total eclipse."
	res.primary_attribute = AttributeSystem.PrimaryAttributeType.AGILITY
	
	res.base_strength = 18.0
	res.strength_growth = 2.0
	res.base_agility = 26.0
	res.agility_growth = 3.4
	res.base_intelligence = 16.0
	res.intelligence_growth = 1.8
	
	res.base_health = 560.0
	res.base_health_regen = 2.0
	res.base_mana = 280.0
	res.base_mana_regen = 1.6
	res.base_attack_damage = 55.0
	res.base_ability_power = 0.0
	res.base_armor = 24.0
	res.base_magic_resist = 25.0
	res.base_attack_speed = 1.08
	res.base_move_speed = 325.0
	res.base_attack_range = 160.0
	
	# Passive: Sensory Siphon
	var passive = AbilityResource.new()
	passive.id = "noctis_passive"
	passive.ability_name = "Duyu Hırsızı (Sensory Siphon)"
	passive.slot = AbilityResource.Slot.PASSIVE
	passive.is_passive = true
	passive.target_type = AbilityResource.TargetType.PASSIVE
	passive.description = "Noctis'in arkadan vurduğu darbeler hedefin görüş menzilini %50 daraltır ve müttefiklerinin harita konumlarını 3 saniyeliğine karartır (İzole Görüş)."
	res.passive_ability = passive
	
	# Q: Blind Spot
	var q = AbilityResource.new()
	q.id = "noctis_q"
	q.ability_name = "Kör Nokta (Blind Spot)"
	q.slot = AbilityResource.Slot.Q
	q.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q.damage_type = DamageRequest.DamageType.PHYSICAL
	q.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q.scaling_ratio = 0.90
	q.base_damage.assign([85.0, 135.0, 185.0, 235.0])
	q.cooldowns.assign([8.0, 7.0, 6.0, 5.0])
	q.mana_costs.assign([50.0, 55.0, 60.0, 65.0])
	q.cast_range = 550.0
	q.description = "Hedef düşmanın arkasına ışınlanır; kritik fiziksel hasar vurur ve hedefi 1.5 saniyeliğine kör eder (saldırıları ıskalar)."
	res.q_ability = q
	
	# W: False Ping / Shadow Shroud
	var w = AbilityResource.new()
	w.id = "noctis_w"
	w.ability_name = "Gölge Örtüsü ve Sahte Ses (Shadow Shroud)"
	w.slot = AbilityResource.Slot.W
	w.target_type = AbilityResource.TargetType.SELF
	w.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	w.mana_costs.assign([45.0, 50.0, 55.0, 60.0])
	w.description = "Noctis 2.5 saniyeliğine kamuflaj (görünmezlik) ve +%35 Hareket Hızı kazanır; düşman haritasında sahte yanıltıcı pingler oluşturur."
	res.w_ability = w
	
	# E: Sensory Sever
	var e = AbilityResource.new()
	e.id = "noctis_e"
	e.ability_name = "Duyu Yutma (Sensory Sever)"
	e.slot = AbilityResource.Slot.E
	e.target_type = AbilityResource.TargetType.SINGLE_TARGET
	e.damage_type = DamageRequest.DamageType.PHYSICAL
	e.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	e.scaling_ratio = 0.75
	e.base_damage.assign([75.0, 120.0, 165.0, 210.0])
	e.cooldowns.assign([11.0, 10.0, 9.0, 8.0])
	e.mana_costs.assign([60.0, 65.0, 70.0, 75.0])
	e.cast_range = 450.0
	e.description = "Hedefe gölge pençesi saplar; fiziksel hasar vurur, hedefin yeteneklerini 1.2 saniye ve tüm seslerini 3 saniyeliğine susturur."
	res.e_ability = e
	
	# R: Total Eclipse (Ultimate)
	var r = AbilityResource.new()
	r.id = "noctis_r"
	r.ability_name = "Tam Güneş Tutulması (Total Eclipse)"
	r.slot = AbilityResource.Slot.R
	r.target_type = AbilityResource.TargetType.GROUND_AOE
	r.damage_type = DamageRequest.DamageType.PHYSICAL
	r.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	r.scaling_ratio = 1.20
	r.base_damage.assign([220.0, 340.0, 460.0])
	r.cooldowns.assign([85.0, 70.0, 55.0])
	r.mana_costs.assign([100.0, 125.0, 150.0])
	r.cast_range = 1400.0
	r.description = "Savaş alanını 5 saniyeliğine zifiri karanlığa boğar; tüm düşmanların görüşünü 2 metreye indirir. Noctis hedefine sınırsız menzilden gölge atılması yapabilir."
	res.r_ability = r
	res.abilities.assign([passive, q, w, e, r])
	
	return res
