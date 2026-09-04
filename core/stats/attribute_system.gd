@warning_ignore("unused_signal")
class_name AttributeSystem
extends Node

## Comprehensive Attribute and Stat management component for Eclipse Front

signal health_changed(current: float, max_val: float)
signal mana_changed(current: float, max_val: float)
signal stat_recalculated(stat: StatModifier.TargetStat, value: float)
signal level_changed(new_level: int)
signal xp_changed(current_xp: int, target_xp: int)
signal entity_died(killer_source: String)
signal health_depleted()

enum PrimaryAttributeType {
	NONE,
	STRENGTH,
	AGILITY,
	INTELLIGENCE
}

@export var balance_config: BalanceConfig = null
@export var primary_attribute: PrimaryAttributeType = PrimaryAttributeType.NONE
@export var level: int = 1

# Base values
var base_strength: float = 20.0
var strength_growth: float = 2.0
var base_agility: float = 20.0
var agility_growth: float = 2.0
var base_intelligence: float = 20.0
var intelligence_growth: float = 2.0

# Base stat growth per level (in addition to attribute growth)
var health_growth: float = 0.0
var health_regen_growth: float = 0.0
var mana_growth: float = 0.0
var mana_regen_growth: float = 0.0
var attack_damage_growth: float = 0.0
var armor_growth: float = 0.0
var magic_resist_growth: float = 0.0
var attack_speed_growth: float = 0.0

# Base core stats (before attribute additions)
var base_health: float = 200.0
var base_health_regen: float = 1.5
var base_mana: float = 100.0
var base_mana_regen: float = 1.0
var base_attack_damage: float = 25.0
var base_ability_power: float = 0.0
var base_armor: float = 2.0
var base_magic_resist: float = 25.0
var base_attack_speed: float = 0.65 # Attacks per second
var base_move_speed: float = 300.0
var base_attack_range: float = 150.0

# Current dynamic pools
var current_health: float = 1000.0
var current_mana: float = 500.0
var is_alive: bool = true

# Progression
var current_xp: int = 0
var xp_to_next_level: int = 200

# Cached final stats
var _final_stats: Dictionary = {}

# Active modifiers
var _modifiers: Array[StatModifier] = []

func _ready() -> void:
	if balance_config == null:
		balance_config = BalanceConfig.get_default()
		
	xp_to_next_level = balance_config.base_xp_requirement
	recalculate_all_stats()
	current_health = get_stat(StatModifier.TargetStat.MAX_HEALTH)
	current_mana = get_stat(StatModifier.TargetStat.MAX_MANA)

func _process(delta: float) -> void:
	if not is_alive:
		return
		
	# Tick modifiers
	var had_expired = false
	for i in range(_modifiers.size() - 1, -1, -1):
		if _modifiers[i].tick(delta):
			_modifiers.remove_at(i)
			had_expired = true
			
	if had_expired:
		recalculate_all_stats()
		
	# Regeneration
	var hp_regen = get_stat(StatModifier.TargetStat.HEALTH_REGEN)
	var max_hp = get_stat(StatModifier.TargetStat.MAX_HEALTH)
	if hp_regen > 0.0 and current_health < max_hp:
		heal(hp_regen * delta)
		
	var mp_regen = get_stat(StatModifier.TargetStat.MANA_REGEN)
	var max_mp = get_stat(StatModifier.TargetStat.MAX_MANA)
	if mp_regen > 0.0 and current_mana < max_mp:
		restore_mana(mp_regen * delta)

func add_modifier(modifier: StatModifier) -> void:
	_modifiers.append(modifier)
	recalculate_all_stats()

func remove_modifiers_by_source(source_id: String) -> void:
	var modified = false
	for i in range(_modifiers.size() - 1, -1, -1):
		if _modifiers[i].source_id == source_id:
			_modifiers.remove_at(i)
			modified = true
	if modified:
		recalculate_all_stats()

func remove_modifier_by_source(source_id: String) -> void:
	remove_modifiers_by_source(source_id)

func get_stat(stat: StatModifier.TargetStat) -> float:
	if _final_stats.is_empty():
		recalculate_all_stats()
	return _final_stats.get(stat, 0.0)

## Central mathematical computation deriving final combat stats from attributes and modifiers
func recalculate_all_stats() -> void:
	if balance_config == null:
		balance_config = BalanceConfig.get_default()
		
	var lvl_scale = float(max(0, level - 1))
	
	# 1. Primary Attributes Calculation
	var raw_str = base_strength + (strength_growth * lvl_scale)
	var raw_agi = base_agility + (agility_growth * lvl_scale)
	var raw_int = base_intelligence + (intelligence_growth * lvl_scale)
	
	var final_str = _apply_modifiers_to_raw(StatModifier.TargetStat.STRENGTH, raw_str)
	var final_agi = _apply_modifiers_to_raw(StatModifier.TargetStat.AGILITY, raw_agi)
	var final_int = _apply_modifiers_to_raw(StatModifier.TargetStat.INTELLIGENCE, raw_int)
	
	_final_stats[StatModifier.TargetStat.STRENGTH] = final_str
	_final_stats[StatModifier.TargetStat.AGILITY] = final_agi
	_final_stats[StatModifier.TargetStat.INTELLIGENCE] = final_int
	
	# 2. Derived Base Stats from Primary Attributes
	var derived_hp = base_health + (health_growth * lvl_scale) + (final_str * balance_config.str_to_hp)
	var derived_hp_regen = base_health_regen + (health_regen_growth * lvl_scale) + (final_str * balance_config.str_to_hp_regen)
	
	var derived_mana = base_mana + (mana_growth * lvl_scale) + (final_int * balance_config.int_to_mana)
	var derived_mana_regen = base_mana_regen + (mana_regen_growth * lvl_scale) + (final_int * balance_config.int_to_mana_regen)
	var derived_magic_amp = (final_int * balance_config.int_to_magic_amp_pct)
	
	var derived_armor = base_armor + (armor_growth * lvl_scale) + (final_agi * balance_config.agi_to_armor)
	var derived_as_bonus = (final_agi * balance_config.agi_to_attack_speed_pct) + (attack_speed_growth * lvl_scale)
	var derived_ms_bonus = (final_agi * balance_config.agi_to_move_speed_flat)
	var derived_mr = base_magic_resist + (magic_resist_growth * lvl_scale)
	
	# Primary Attribute Bonus Attack Damage
	var primary_ad_bonus = 0.0
	match primary_attribute:
		PrimaryAttributeType.STRENGTH:
			primary_ad_bonus = final_str * balance_config.str_to_primary_ad
		PrimaryAttributeType.AGILITY:
			primary_ad_bonus = final_agi * balance_config.agi_to_primary_ad
		PrimaryAttributeType.INTELLIGENCE:
			primary_ad_bonus = final_int * balance_config.int_to_primary_ad
			
	var derived_ad = base_attack_damage + (attack_damage_growth * lvl_scale) + primary_ad_bonus
	
	# 3. Apply Modifiers to Derived Stats
	_final_stats[StatModifier.TargetStat.MAX_HEALTH] = _apply_modifiers_to_raw(StatModifier.TargetStat.MAX_HEALTH, derived_hp)
	_final_stats[StatModifier.TargetStat.HEALTH_REGEN] = _apply_modifiers_to_raw(StatModifier.TargetStat.HEALTH_REGEN, derived_hp_regen)
	_final_stats[StatModifier.TargetStat.MAX_MANA] = _apply_modifiers_to_raw(StatModifier.TargetStat.MAX_MANA, derived_mana)
	_final_stats[StatModifier.TargetStat.MANA_REGEN] = _apply_modifiers_to_raw(StatModifier.TargetStat.MANA_REGEN, derived_mana_regen)
	_final_stats[StatModifier.TargetStat.ATTACK_DAMAGE] = _apply_modifiers_to_raw(StatModifier.TargetStat.ATTACK_DAMAGE, derived_ad)
	_final_stats[StatModifier.TargetStat.ABILITY_POWER] = _apply_modifiers_to_raw(StatModifier.TargetStat.ABILITY_POWER, base_ability_power)
	_final_stats[StatModifier.TargetStat.ARMOR] = _apply_modifiers_to_raw(StatModifier.TargetStat.ARMOR, derived_armor)
	_final_stats[StatModifier.TargetStat.MAGIC_RESIST] = _apply_modifiers_to_raw(StatModifier.TargetStat.MAGIC_RESIST, derived_mr)
	
	var calculated_as = (base_attack_speed * (1.0 + derived_as_bonus))
	_final_stats[StatModifier.TargetStat.ATTACK_SPEED] = _apply_modifiers_to_raw(StatModifier.TargetStat.ATTACK_SPEED, calculated_as)
	
	var raw_ms = base_move_speed + derived_ms_bonus
	var final_ms = clampf(_apply_modifiers_to_raw(StatModifier.TargetStat.MOVE_SPEED, raw_ms), balance_config.min_move_speed, balance_config.max_move_speed)
	_final_stats[StatModifier.TargetStat.MOVE_SPEED] = final_ms
	
	_final_stats[StatModifier.TargetStat.ATTACK_RANGE] = _apply_modifiers_to_raw(StatModifier.TargetStat.ATTACK_RANGE, base_attack_range)
	
	# Specialized Combat Stats
	_final_stats[StatModifier.TargetStat.CRIT_CHANCE] = clampf(_apply_modifiers_to_raw(StatModifier.TargetStat.CRIT_CHANCE, 0.0), 0.0, 1.0)
	_final_stats[StatModifier.TargetStat.CRIT_DAMAGE] = _apply_modifiers_to_raw(StatModifier.TargetStat.CRIT_DAMAGE, balance_config.base_crit_damage_multiplier)
	_final_stats[StatModifier.TargetStat.ARMOR_PEN_FLAT] = _apply_modifiers_to_raw(StatModifier.TargetStat.ARMOR_PEN_FLAT, 0.0)
	_final_stats[StatModifier.TargetStat.ARMOR_PEN_PERCENT] = clampf(_apply_modifiers_to_raw(StatModifier.TargetStat.ARMOR_PEN_PERCENT, 0.0), 0.0, 1.0)
	_final_stats[StatModifier.TargetStat.MAGIC_PEN_FLAT] = _apply_modifiers_to_raw(StatModifier.TargetStat.MAGIC_PEN_FLAT, 0.0)
	_final_stats[StatModifier.TargetStat.MAGIC_PEN_PERCENT] = clampf(_apply_modifiers_to_raw(StatModifier.TargetStat.MAGIC_PEN_PERCENT, 0.0), 0.0, 1.0)
	_final_stats[StatModifier.TargetStat.COOLDOWN_REDUCTION] = clampf(_apply_modifiers_to_raw(StatModifier.TargetStat.COOLDOWN_REDUCTION, 0.0), 0.0, balance_config.max_cooldown_reduction)
	_final_stats[StatModifier.TargetStat.LIFESTEAL] = _apply_modifiers_to_raw(StatModifier.TargetStat.LIFESTEAL, 0.0)
	_final_stats[StatModifier.TargetStat.SPELL_VAMP] = _apply_modifiers_to_raw(StatModifier.TargetStat.SPELL_VAMP, 0.0)
	_final_stats[StatModifier.TargetStat.DAMAGE_AMPLIFICATION] = _apply_modifiers_to_raw(StatModifier.TargetStat.DAMAGE_AMPLIFICATION, derived_magic_amp)
	_final_stats[StatModifier.TargetStat.DAMAGE_REDUCTION] = _apply_modifiers_to_raw(StatModifier.TargetStat.DAMAGE_REDUCTION, 0.0)
	_final_stats[StatModifier.TargetStat.TENACITY] = _apply_modifiers_to_raw(StatModifier.TargetStat.TENACITY, 0.0)
	
	# Clamp health/mana
	var max_hp = _final_stats[StatModifier.TargetStat.MAX_HEALTH]
	var max_mp = _final_stats[StatModifier.TargetStat.MAX_MANA]
	current_health = minf(current_health, max_hp)
	current_mana = minf(current_mana, max_mp)
	health_changed.emit(current_health, max_hp)
	mana_changed.emit(current_mana, max_mp)

func _apply_modifiers_to_raw(stat: StatModifier.TargetStat, raw_value: float) -> float:
	var flat = 0.0
	var pct_add = 0.0
	var pct_mult = 1.0
	
	for mod in _modifiers:
		if mod.target_stat == stat:
			match mod.modifier_type:
				StatModifier.Type.FLAT:
					flat += mod.value
				StatModifier.Type.PERCENT_ADD:
					pct_add += mod.value
				StatModifier.Type.PERCENT_MULT:
					pct_mult *= (1.0 + mod.value)
					
	return (raw_value + flat) * (1.0 + pct_add) * pct_mult

func apply_damage_to_health(amount: float, source_id: String = "") -> void:
	if not is_alive or amount <= 0.0:
		return
		
	current_health = maxf(0.0, current_health - amount)
	var max_hp = get_stat(StatModifier.TargetStat.MAX_HEALTH)
	health_changed.emit(current_health, max_hp)
	
	if current_health <= 0.0:
		is_alive = false
		health_depleted.emit()
		entity_died.emit(source_id)

func heal(amount: float) -> void:
	if not is_alive or amount <= 0.0:
		return
	var max_hp = get_stat(StatModifier.TargetStat.MAX_HEALTH)
	current_health = minf(max_hp, current_health + amount)
	health_changed.emit(current_health, max_hp)

func spend_mana(amount: float) -> bool:
	if amount <= 0.0:
		return true
	if current_mana < amount:
		return false
	current_mana -= amount
	var max_mp = get_stat(StatModifier.TargetStat.MAX_MANA)
	mana_changed.emit(current_mana, max_mp)
	return true

func consume_mana(amount: float) -> bool:
	return spend_mana(amount)

func restore_mana(amount: float) -> void:
	if amount <= 0.0:
		return
	var max_mp = get_stat(StatModifier.TargetStat.MAX_MANA)
	current_mana = minf(max_mp, current_mana + amount)
	mana_changed.emit(current_mana, max_mp)

func get_xp_progress() -> float:
	return clampf(float(current_xp) / float(max(1, xp_to_next_level)), 0.0, 1.0)

func get_level() -> int:
	return level

func is_max_level() -> bool:
	var max_lvl = balance_config.max_hero_level if balance_config != null else 18
	return level >= max_lvl

func add_xp(amount: int) -> void:
	if balance_config == null:
		balance_config = BalanceConfig.get_default()
	if level >= balance_config.max_hero_level:
		return
		
	current_xp += amount
	while current_xp >= xp_to_next_level and level < balance_config.max_hero_level:
		current_xp -= xp_to_next_level
		xp_to_next_level = int(float(xp_to_next_level) * balance_config.xp_growth_factor)
		_on_level_up()
		
	xp_changed.emit(current_xp, xp_to_next_level)
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.hero_gained_xp.emit(get_parent(), current_xp, xp_to_next_level)

func grant_experience(amount: float) -> void:
	add_xp(int(amount))

func level_up() -> void:
	_on_level_up()

func _on_level_up() -> void:
	level += 1
	var old_max_hp = get_stat(StatModifier.TargetStat.MAX_HEALTH)
	var old_max_mp = get_stat(StatModifier.TargetStat.MAX_MANA)
	recalculate_all_stats()
	var new_max_hp = get_stat(StatModifier.TargetStat.MAX_HEALTH)
	var new_max_mp = get_stat(StatModifier.TargetStat.MAX_MANA)
	
	heal(new_max_hp - old_max_hp)
	restore_mana(new_max_mp - old_max_mp)
	level_changed.emit(level)
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.hero_leveled_up.emit(get_parent(), level)
