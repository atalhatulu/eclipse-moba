class_name EffectContainer
extends Node

## Manages active status effects, crowd control flags, shields, and DoTs on a combat entity

signal effect_applied(effect: StatusEffect)
signal effect_removed(effect: StatusEffect)
signal shield_absorbed(amount: float, remaining_shield: float)
signal crowd_control_state_changed()

var active_effects: Array[StatusEffect] = []
var attribute_system: AttributeSystem = null

func _ready() -> void:
	_resolve_attribute_system()

func _resolve_attribute_system() -> void:
	if attribute_system == null and get_parent() != null:
		if "attribute_system" in get_parent() and get_parent().attribute_system != null:
			attribute_system = get_parent().attribute_system
		else:
			attribute_system = get_parent().get_node_or_null("AttributeSystem")

func _process(delta: float) -> void:
	_resolve_attribute_system()
	var expired_indices: Array[int] = []
	
	for i in range(active_effects.size()):
		var eff = active_effects[i]
		var expired = eff.tick(delta)
		
		# Process DoT / HoT ticks
		if eff.effect_type == StatusEffect.EffectType.DAMAGE_OVER_TIME and eff.elapsed_tick_time == 0.0:
			if attribute_system != null:
				attribute_system.apply_damage_to_health(eff.intensity * float(eff.stacks), eff.effect_id)
		elif eff.effect_type == StatusEffect.EffectType.HEAL_OVER_TIME and eff.elapsed_tick_time == 0.0:
			if attribute_system != null:
				attribute_system.heal(eff.intensity * float(eff.stacks))
				
		if expired:
			expired_indices.append(i)
			
	# Remove expired in reverse order
	for idx in range(expired_indices.size() - 1, -1, -1):
		var i = expired_indices[idx]
		_remove_effect_internal(i)

func apply_effect(effect: StatusEffect) -> void:
	if effect == null:
		return
		
	# If target is invulnerable, reject negative debuffs
	if is_invulnerable() and effect.is_debuff and effect.effect_type != StatusEffect.EffectType.INVULNERABILITY:
		return
		
	effect.target_entity = get_parent()
	
	# Check if effect already exists to refresh or stack
	for existing in active_effects:
		if existing.effect_id == effect.effect_id:
			existing.refresh_duration(effect.duration)
			if existing.max_stacks > 1:
				existing.add_stack(1)
			return
			
	active_effects.append(effect)
	effect._on_applied()
	
	# Apply stat modifiers if applicable
	if effect.effect_type == StatusEffect.EffectType.SLOW:
		_apply_slow_modifier(effect)
	elif effect.effect_type == StatusEffect.EffectType.STAT_MODIFIER:
		_apply_stat_modifier(effect)
		
	effect_applied.emit(effect)
	crowd_control_state_changed.emit()

func remove_effect_by_id(effect_id: String) -> void:
	for i in range(active_effects.size() - 1, -1, -1):
		if active_effects[i].effect_id == effect_id:
			_remove_effect_internal(i)

func _remove_effect_internal(index: int) -> void:
	if index < 0 or index >= active_effects.size():
		return
		
	var eff = active_effects[index]
	active_effects.remove_at(index)
	eff._on_removed()
	
	# Clean up any stat modifiers associated with this effect
	_resolve_attribute_system()
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("effect_" + eff.effect_id)
		
	effect_removed.emit(eff)
	crowd_control_state_changed.emit()

## Absorbs incoming damage using active shields. Returns unabsorbed damage.
func absorb_damage_with_shields(damage: float) -> float:
	var remaining_damage = damage
	
	for i in range(active_effects.size() - 1, -1, -1):
		var eff = active_effects[i]
		if eff.effect_type == StatusEffect.EffectType.SHIELD and eff.intensity > 0.0:
			if eff.intensity >= remaining_damage:
				eff.intensity -= remaining_damage
				shield_absorbed.emit(remaining_damage, eff.intensity)
				remaining_damage = 0.0
				if eff.intensity <= 0.0:
					_remove_effect_internal(i)
				break
			else:
				remaining_damage -= eff.intensity
				shield_absorbed.emit(eff.intensity, 0.0)
				eff.intensity = 0.0
				_remove_effect_internal(i)
				
	return remaining_damage

func is_stunned() -> bool:
	return has_effect_type(StatusEffect.EffectType.STUN)

func is_silenced() -> bool:
	return has_effect_type(StatusEffect.EffectType.SILENCE) or is_stunned()

func is_rooted() -> bool:
	return has_effect_type(StatusEffect.EffectType.ROOT) or is_stunned()

func is_invulnerable() -> bool:
	return has_effect_type(StatusEffect.EffectType.INVULNERABILITY)

func get_total_shield_amount() -> float:
	var total = 0.0
	for eff in active_effects:
		if eff.effect_type == StatusEffect.EffectType.SHIELD and eff.intensity > 0.0:
			total += eff.intensity
	return total

func get_primary_crowd_control() -> Dictionary:
	var max_dur = 0.0
	var cc_type = -1
	
	# Priority 1: STUN
	for eff in active_effects:
		if eff.effect_type == StatusEffect.EffectType.STUN and eff.remaining_time > max_dur:
			max_dur = eff.remaining_time
			cc_type = StatusEffect.EffectType.STUN
	if cc_type != -1:
		return {"type": "STUNNED", "duration": max_dur, "color": Color(1.0, 0.25, 0.25)}
		
	# Priority 2: ROOT
	for eff in active_effects:
		if eff.effect_type == StatusEffect.EffectType.ROOT and eff.remaining_time > max_dur:
			max_dur = eff.remaining_time
			cc_type = StatusEffect.EffectType.ROOT
	if cc_type != -1:
		return {"type": "ROOTED", "duration": max_dur, "color": Color(0.3, 0.85, 1.0)}
		
	# Priority 3: SILENCE
	for eff in active_effects:
		if eff.effect_type == StatusEffect.EffectType.SILENCE and eff.remaining_time > max_dur:
			max_dur = eff.remaining_time
			cc_type = StatusEffect.EffectType.SILENCE
	if cc_type != -1:
		return {"type": "SILENCED", "duration": max_dur, "color": Color(0.85, 0.35, 1.0)}
		
	# Priority 4: SLOW
	for eff in active_effects:
		if eff.effect_type == StatusEffect.EffectType.SLOW and eff.remaining_time > max_dur:
			max_dur = eff.remaining_time
			cc_type = StatusEffect.EffectType.SLOW
	if cc_type != -1:
		return {"type": "SLOWED", "duration": max_dur, "color": Color(1.0, 0.75, 0.2)}
		
	return {"type": "", "duration": 0.0, "color": Color.WHITE}

func has_effect_type(type: StatusEffect.EffectType) -> bool:
	for eff in active_effects:
		if eff.effect_type == type:
			return true
	return false

func has_effect_id(id: String) -> bool:
	for eff in active_effects:
		if eff.effect_id == id:
			return true
	return false

func has_effect(id: String) -> bool:
	return has_effect_id(id)

func get_effect(id: String) -> StatusEffect:
	for eff in active_effects:
		if eff.effect_id == id:
			return eff
	return null

func process_effects(delta: float) -> void:
	_process(delta)

func get_total_shield() -> float:
	var total = 0.0
	for eff in active_effects:
		if eff.effect_type == StatusEffect.EffectType.SHIELD and eff.intensity > 0.0:
			total += eff.intensity
	return total

func clear_all_debuffs() -> void:
	for i in range(active_effects.size() - 1, -1, -1):
		var eff = active_effects[i]
		if eff.is_debuff:
			_remove_effect_internal(i)

func clear_all_effects() -> void:
	for i in range(active_effects.size() - 1, -1, -1):
		_remove_effect_internal(i)

func _apply_slow_modifier(effect: StatusEffect) -> void:
	_resolve_attribute_system()
	if attribute_system != null:
		# Slow is a negative percent add to Move Speed
		var slow_val = -absf(effect.intensity)
		var mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, slow_val, "effect_" + effect.effect_id, effect.duration)
		attribute_system.add_modifier(mod)

func _apply_stat_modifier(effect: StatusEffect) -> void:
	_resolve_attribute_system()
	if attribute_system != null:
		var mod = StatModifier.new(effect.target_stat, effect.stat_mod_type, effect.intensity, "effect_" + effect.effect_id, effect.duration)
		attribute_system.add_modifier(mod)

func apply_spell_immunity(p_dur: float = 5.0) -> void:
	var eff = StatusEffect.new("spell_immunity", StatusEffect.EffectType.BUFF, p_dur, 0.0, false)
	apply_effect(eff)

func apply_hex(p_dur: float = 2.5) -> void:
	var eff = StatusEffect.new("hex_disruption", StatusEffect.EffectType.SILENCE, p_dur, 0.0, true)
	apply_effect(eff)

func apply_cyclone_lift(p_dur: float = 2.5) -> void:
	var eff = StatusEffect.new("cyclone_lift", StatusEffect.EffectType.STUN, p_dur, 0.0, true)
	apply_effect(eff)

func apply_slow(amount: float = 0.3, p_dur: float = 2.0) -> void:
	var eff = StatusEffect.new("generic_slow", StatusEffect.EffectType.SLOW, p_dur, amount, true)
	apply_effect(eff)

func apply_silence(p_dur: float = 2.0) -> void:
	var eff = StatusEffect.new("generic_silence", StatusEffect.EffectType.SILENCE, p_dur, 0.0, true)
	apply_effect(eff)
