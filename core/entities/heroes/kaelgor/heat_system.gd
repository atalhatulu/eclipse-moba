class_name HeatSystem
extends Node

## Reusable Hero Resource System managing Kaelgor's Heat generation, decay, and stat scaling

signal heat_changed(current_heat: float, max_heat: float)
signal heat_decay_started()
signal heat_decay_stopped()

@export var max_heat: float = 100.0
@export var decay_delay: float = 4.0 # Time out of combat before decay begins
@export var decay_rate: float = 10.0 # Heat lost per second during decay
@export var attack_speed_per_heat: float = 0.003 # +30% Attack Speed at 100 Heat

var current_heat: float = 0.0
var combat_timer: float = 0.0
var is_decaying: bool = false
var is_decay_locked: bool = false # True during Overheat (prevents decay)

var attribute_system: AttributeSystem = null

func _ready() -> void:
	if get_parent() != null:
		attribute_system = get_parent().get_node_or_null("AttributeSystem")

func _process(delta: float) -> void:
	# Combat decay timer
	if combat_timer > 0.0:
		combat_timer = maxf(0.0, combat_timer - delta)
		if is_decaying:
			is_decaying = false
			heat_decay_stopped.emit()
	elif not is_decay_locked and current_heat > 0.0:
		if not is_decaying:
			is_decaying = true
			heat_decay_started.emit()
			
		var decayed = decay_rate * delta
		set_heat(maxf(0.0, current_heat - decayed))
	elif current_heat <= 0.0 and is_decaying:
		is_decaying = false
		heat_decay_stopped.emit()

func add_heat(amount: float) -> float:
	if amount <= 0.0:
		return current_heat
		
	notify_combat_activity()
	var new_heat = clampf(current_heat + amount, 0.0, max_heat)
	var added = new_heat - current_heat
	set_heat(new_heat)
	return added

func consume_heat(amount: float) -> float:
	if amount <= 0.0 or current_heat <= 0.0:
		return 0.0
		
	var actual_consumed = minf(current_heat, amount)
	set_heat(current_heat - actual_consumed)
	return actual_consumed

func set_heat(value: float) -> void:
	var clamped_value = clampf(value, 0.0, max_heat)
	if absf(current_heat - clamped_value) > 0.0001:
		current_heat = clamped_value
		_update_heat_stat_modifiers()
		heat_changed.emit(current_heat, max_heat)

func get_heat() -> float:
	return current_heat

func get_heat_percent() -> float:
	return (current_heat / max_heat) if max_heat > 0.0 else 0.0

func notify_combat_activity() -> void:
	combat_timer = decay_delay

func reset_heat() -> void:
	is_decaying = false
	is_decay_locked = false
	combat_timer = 0.0
	set_heat(0.0)

func _update_heat_stat_modifiers() -> void:
	if attribute_system == null:
		return
		
	attribute_system.remove_modifiers_by_source("kaelgor_furnace_heat")
	
	if current_heat > 0.0:
		var as_bonus = current_heat * attack_speed_per_heat
		var mod = StatModifier.new(
			StatModifier.TargetStat.ATTACK_SPEED,
			StatModifier.Type.PERCENT_ADD,
			as_bonus,
			"kaelgor_furnace_heat"
		)
		attribute_system.add_modifier(mod)
