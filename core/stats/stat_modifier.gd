class_name StatModifier
extends RefCounted

## Represents a modification to an attribute or combat stat

enum Type {
	FLAT,
	PERCENT_ADD,
	PERCENT_MULT
}

enum TargetStat {
	# Primary Attributes
	STRENGTH,
	AGILITY,
	INTELLIGENCE,
	
	# Derived & Core Stats
	MAX_HEALTH,
	HEALTH_REGEN,
	MAX_MANA,
	MANA_REGEN,
	ATTACK_DAMAGE,
	ABILITY_POWER,
	ARMOR,
	MAGIC_RESIST,
	ATTACK_SPEED,
	MOVE_SPEED,
	ATTACK_RANGE,
	CRIT_CHANCE,
	CRIT_DAMAGE,
	ARMOR_PEN_FLAT,
	ARMOR_PEN_PERCENT,
	MAGIC_PEN_FLAT,
	MAGIC_PEN_PERCENT,
	COOLDOWN_REDUCTION,
	LIFESTEAL,
	SPELL_VAMP,
	DAMAGE_AMPLIFICATION,
	DAMAGE_REDUCTION,
	TENACITY
}

var target_stat: TargetStat
var modifier_type: Type
var value: float
var source_id: String
var duration: float = -1.0 # Negative means permanent until explicitly removed
var elapsed_time: float = 0.0

func _init(p_stat: TargetStat, p_type: Type, p_val: float, p_source: String = "", p_duration: float = -1.0) -> void:
	target_stat = p_stat
	modifier_type = p_type
	value = p_val
	source_id = p_source
	duration = p_duration

func is_expired() -> bool:
	if duration < 0.0:
		return false
	return elapsed_time >= duration

func tick(delta: float) -> bool:
	if duration < 0.0:
		return false
	elapsed_time += delta
	return is_expired()
