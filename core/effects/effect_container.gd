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
		if eff.had_tick_this_frame:
			if eff.effect_type == StatusEffect.EffectType.DAMAGE_OVER_TIME:
				if attribute_system != null:
					attribute_system.apply_damage_to_health(eff.intensity * float(eff.stacks), eff.effect_id)
			elif eff.effect_type == StatusEffect.EffectType.HEAL_OVER_TIME:
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
	elif effect.effect_type == StatusEffect.EffectType.KNOCKBACK:
		_apply_knockback_motion(effect)
	if effect.get_meta("grants_invisibility", false):
		_refresh_invisibility_state()
		
	effect_applied.emit(effect)
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.status_effect_applied.emit(get_parent(), effect)
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
	if eff.get_meta("grants_invisibility", false):
		_refresh_invisibility_state()
		
	effect_removed.emit(eff)
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.status_effect_removed.emit(get_parent(), eff)
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

func is_disarmed() -> bool:
	return has_effect_type(StatusEffect.EffectType.DISARM)

func is_blinded() -> bool:
	return has_effect_type(StatusEffect.EffectType.BLIND)

func get_blind_miss_chance() -> float:
	var chance := 0.0
	for eff in active_effects:
		if eff.effect_type == StatusEffect.EffectType.BLIND:
			chance = maxf(chance, clampf(eff.intensity, 0.0, 1.0))
	return chance

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

	# Priority 4: DISARM
	for eff in active_effects:
		if eff.effect_type == StatusEffect.EffectType.DISARM and eff.remaining_time > max_dur:
			max_dur = eff.remaining_time
			cc_type = StatusEffect.EffectType.DISARM
	if cc_type != -1:
		return {"type": "DISARMED", "duration": max_dur, "color": Color(0.95, 0.55, 0.20)}

	# Priority 5: BLIND
	for eff in active_effects:
		if eff.effect_type == StatusEffect.EffectType.BLIND and eff.remaining_time > max_dur:
			max_dur = eff.remaining_time
			cc_type = StatusEffect.EffectType.BLIND
	if cc_type != -1:
		return {"type": "BLINDED", "duration": max_dur, "color": Color(0.75, 0.75, 0.35)}
		
	# Priority 6: SLOW
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
	apply_airborne(p_dur, 1.6, "cyclone_lift")

## Applies a short forced displacement away from an origin. The status effect
## prevents movement while the unit is being pushed and works in headless tests.
func apply_knockback(origin: Vector3, distance: float = 3.0, p_dur: float = 0.25, effect_id: String = "knockback") -> void:
	var eff = StatusEffect.new(effect_id, StatusEffect.EffectType.KNOCKBACK, p_dur, maxf(0.0, distance), true)
	eff.source_entity = get_parent()
	eff.set_meta("knockback_origin", origin)
	apply_effect(eff)

## Lifts a unit visually while also applying a stun. This is used by cyclone,
## knock-up and launch mechanics without requiring a physics-only implementation.
func apply_airborne(p_dur: float = 1.0, height: float = 1.4, effect_id: String = "airborne") -> void:
	var eff = StatusEffect.new(effect_id, StatusEffect.EffectType.STUN, p_dur, height, true)
	eff.set_meta("airborne", true)
	apply_effect(eff)
	var entity = get_parent() as Node3D
	if entity == null:
		return
	var start_pos = entity.global_position if entity.is_inside_tree() else entity.position
	if entity.is_inside_tree():
		var tween = entity.create_tween()
		tween.tween_property(entity, "global_position:y", start_pos.y + height, p_dur * 0.45).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(entity, "global_position:y", start_pos.y, p_dur * 0.55).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func _apply_knockback_motion(effect: StatusEffect) -> void:
	var entity = get_parent() as Node3D
	if entity == null:
		return
	var default_origin = entity.global_position if entity.is_inside_tree() else entity.position
	var origin: Vector3 = effect.get_meta("knockback_origin", default_origin)
	var start_pos = entity.global_position if entity.is_inside_tree() else entity.position
	var direction = start_pos - origin
	direction.y = 0.0
	if direction.length_squared() < 0.001:
		direction = Vector3.FORWARD
	direction = direction.normalized()
	var destination = start_pos + (direction * effect.intensity)
	if entity.is_inside_tree():
		var tween = entity.create_tween()
		tween.tween_property(entity, "global_position", destination, maxf(0.05, effect.duration)).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	else:
		entity.position = destination

func apply_slow(amount: float = 0.3, p_dur: float = 2.0) -> void:
	var eff = StatusEffect.new("generic_slow", StatusEffect.EffectType.SLOW, p_dur, amount, true)
	apply_effect(eff)

func apply_silence(p_dur: float = 2.0) -> void:
	var eff = StatusEffect.new("generic_silence", StatusEffect.EffectType.SILENCE, p_dur, 0.0, true)
	apply_effect(eff)

func apply_disarm(p_dur: float = 2.0, effect_id: String = "generic_disarm") -> void:
	apply_effect(StatusEffect.new(effect_id, StatusEffect.EffectType.DISARM, p_dur, 0.0, true))

func apply_blind(miss_chance: float = 0.5, p_dur: float = 1.5, effect_id: String = "generic_blind") -> void:
	apply_effect(StatusEffect.new(effect_id, StatusEffect.EffectType.BLIND, p_dur, miss_chance, true))

func apply_invisibility(p_dur: float = 2.5, effect_id: String = "generic_invisibility") -> void:
	var effect = StatusEffect.new(effect_id, StatusEffect.EffectType.BUFF, p_dur, 0.0, false)
	effect.set_meta("grants_invisibility", true)
	apply_effect(effect)

func _refresh_invisibility_state() -> void:
	var entity = get_parent() as BaseCombatEntity
	if entity == null:
		return
	var active = false
	for eff in active_effects:
		if eff.get_meta("grants_invisibility", false):
			active = true
			break
	entity.is_invisible = active
	if entity.is_alive():
		entity.is_targetable = not active
