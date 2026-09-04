class_name StatusEffect
extends RefCounted

## Extensible base class for all status effects and buffs/debuffs in Eclipse Front

enum EffectType {
	STUN,
	SLOW,
	SILENCE,
	ROOT,
	KNOCKBACK,
	SHIELD,
	DAMAGE_OVER_TIME,
	HEAL_OVER_TIME,
	STAT_MODIFIER,
	DAMAGE_AMPLIFICATION,
	DAMAGE_REDUCTION,
	INVULNERABILITY,
	BUFF,
	DEBUFF,
	DISARM,
	BLIND
}

var effect_id: String = "generic_effect"
var effect_type: EffectType = EffectType.STAT_MODIFIER
var duration: float = 1.0 # Negative means permanent
var remaining_time: float = 1.0
var tick_interval: float = 0.5
var elapsed_tick_time: float = 0.0

var intensity: float = 0.0 # Slow amount (0-1), Shield HP, DoT damage per tick, etc.
var stacks: int = 1
var max_stacks: int = 1
var is_debuff: bool = true

var source_entity: Node = null
var target_entity: Node = null

var had_tick_this_frame: bool = false

# For Stat Modifier effects
var target_stat: StatModifier.TargetStat = StatModifier.TargetStat.MOVE_SPEED
var stat_mod_type: StatModifier.Type = StatModifier.Type.FLAT

func _init(p_id: String, p_type: EffectType, p_dur: float, p_intensity: float = 0.0, p_is_debuff: bool = true) -> void:
	effect_id = p_id
	effect_type = p_type
	duration = p_dur
	remaining_time = p_dur
	intensity = p_intensity
	is_debuff = p_is_debuff

func refresh_duration(new_duration: float = -1.0) -> void:
	if new_duration > 0.0:
		duration = new_duration
	remaining_time = duration

func add_stack(amount: int = 1) -> void:
	stacks = clampi(stacks + amount, 1, max_stacks)
	refresh_duration()

func tick(delta: float) -> bool:
	had_tick_this_frame = false
	if duration >= 0.0:
		remaining_time -= delta
		if remaining_time <= 0.0:
			return true # Expired
			
	if tick_interval > 0.0:
		elapsed_tick_time += delta
		if elapsed_tick_time >= tick_interval:
			elapsed_tick_time -= tick_interval
			had_tick_this_frame = true
			_on_tick()
			
	return false

func _on_applied() -> void:
	pass

func _on_tick() -> void:
	pass

func _on_removed() -> void:
	pass
