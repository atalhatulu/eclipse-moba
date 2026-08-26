class_name CombatCalculator
extends RefCounted

## Centralized damage calculation and combat resolution engine for Eclipse Front

## Resolves a DamageRequest and applies changes to attacker and target entities
static func execute_damage(request: DamageRequest) -> DamageResult:
	var result = DamageResult.new()
	result.damage_type = request.damage_type
	result.source_name = request.source_name
	
	if request.target == null:
		return result
		
	var target_effects: EffectContainer = null
	if "effect_container" in request.target and request.target.effect_container != null:
		target_effects = request.target.effect_container
	elif request.target is Node:
		target_effects = request.target.get_node_or_null("EffectContainer")
		
	var target_stats: AttributeSystem = null
	if "attribute_system" in request.target and request.target.attribute_system != null:
		target_stats = request.target.attribute_system
	elif request.target is Node:
		target_stats = request.target.get_node_or_null("AttributeSystem")
		
	var attacker_stats: AttributeSystem = null
	if request.attacker != null:
		if "attribute_system" in request.attacker and request.attacker.attribute_system != null:
			attacker_stats = request.attacker.attribute_system
		elif request.attacker is Node:
			attacker_stats = request.attacker.get_node_or_null("AttributeSystem")
	
	# 1. Check Invulnerability
	if target_effects != null and target_effects.is_invulnerable():
		result.raw_damage = request.base_damage
		result.mitigated_damage = request.base_damage
		result.final_health_damage = 0.0
		return result
		
	# 2. Critical Strike Evaluation (Basic attacks or explicit critical flags)
	var current_damage = request.base_damage
	if not request.is_ability and attacker_stats != null:
		var crit_chance = attacker_stats.get_stat(StatModifier.TargetStat.CRIT_CHANCE)
		if request.is_critical or (crit_chance > 0.0 and randf() < crit_chance):
			result.is_critical = true
			var crit_mult = attacker_stats.get_stat(StatModifier.TargetStat.CRIT_DAMAGE)
			current_damage *= (crit_mult if crit_mult > 1.0 else 1.75)
	else:
		result.is_critical = request.is_critical
		
	result.raw_damage = current_damage
	
	# 3. Pull Attacker Penetration & Amplification
	var armor_pen_pct = request.armor_pen_percent
	var armor_pen_flat = request.armor_pen_flat
	var magic_pen_pct = request.magic_pen_percent
	var magic_pen_flat = request.magic_pen_flat
	var dmg_amp = request.damage_amplification
	
	if attacker_stats != null:
		armor_pen_pct = maxf(armor_pen_pct, attacker_stats.get_stat(StatModifier.TargetStat.ARMOR_PEN_PERCENT))
		armor_pen_flat += attacker_stats.get_stat(StatModifier.TargetStat.ARMOR_PEN_FLAT)
		magic_pen_pct = maxf(magic_pen_pct, attacker_stats.get_stat(StatModifier.TargetStat.MAGIC_PEN_PERCENT))
		magic_pen_flat += attacker_stats.get_stat(StatModifier.TargetStat.MAGIC_PEN_FLAT)
		dmg_amp += attacker_stats.get_stat(StatModifier.TargetStat.DAMAGE_AMPLIFICATION)
		
	# 4. Pull Target Reductions
	var target_reduction = request.damage_reduction
	if target_stats != null:
		target_reduction += target_stats.get_stat(StatModifier.TargetStat.DAMAGE_REDUCTION)
		
	# 5. Apply Amplification and Reductions
	current_damage *= (1.0 + dmg_amp)
	current_damage *= maxf(0.0, 1.0 - target_reduction)
	
	# 6. Apply Resistance Mitigations based on Damage Type
	var post_mitigation_damage = current_damage
	match request.damage_type:
		DamageRequest.DamageType.TRUE_DAMAGE:
			post_mitigation_damage = current_damage
			
		DamageRequest.DamageType.PHYSICAL:
			if target_stats != null:
				var raw_armor = target_stats.get_stat(StatModifier.TargetStat.ARMOR)
				var eff_armor = _calculate_effective_resistance(raw_armor, armor_pen_pct, armor_pen_flat)
				var multiplier = _get_resistance_multiplier(eff_armor)
				post_mitigation_damage = current_damage * multiplier
				
		DamageRequest.DamageType.MAGICAL:
			if target_stats != null:
				var raw_mr = target_stats.get_stat(StatModifier.TargetStat.MAGIC_RESIST)
				var eff_mr = _calculate_effective_resistance(raw_mr, magic_pen_pct, magic_pen_flat)
				var multiplier = _get_resistance_multiplier(eff_mr)
				post_mitigation_damage = current_damage * multiplier
				
	result.mitigated_damage = maxf(0.0, result.raw_damage - post_mitigation_damage)
	
	# 7. Shield Absorption
	var health_damage = post_mitigation_damage
	if target_effects != null and health_damage > 0.0:
		var unabsorbed = target_effects.absorb_damage_with_shields(health_damage)
		result.shield_absorbed = health_damage - unabsorbed
		health_damage = unabsorbed
		
	result.final_health_damage = maxf(0.0, health_damage)
	
	# 8. Apply Damage to Target Health
	if target_stats != null and result.final_health_damage > 0.0:
		var prev_alive = target_stats.is_alive
		target_stats.apply_damage_to_health(result.final_health_damage, result.source_name)
		result.is_fatal = prev_alive and not target_stats.is_alive
		
	# 9. Lifesteal & Spell Vamp Processing
	if attacker_stats != null and result.final_health_damage > 0.0:
		if request.is_ability:
			var vamp_rate = maxf(request.spell_vamp, attacker_stats.get_stat(StatModifier.TargetStat.SPELL_VAMP))
			if vamp_rate > 0.0:
				result.spell_vamp_healed = result.final_health_damage * vamp_rate
				attacker_stats.heal(result.spell_vamp_healed)
		else:
			var ls_rate = maxf(request.lifesteal, attacker_stats.get_stat(StatModifier.TargetStat.LIFESTEAL))
			if ls_rate > 0.0:
				result.lifesteal_healed = result.final_health_damage * ls_rate
				attacker_stats.heal(result.lifesteal_healed)
				
	# 10. Global Event Dispatch
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.damage_dealt.emit(result, request.attacker, request.target)
		if result.is_fatal:
			GameEvents.entity_killed.emit(request.target, request.attacker)
			GameEvents.entity_died.emit(request.target, request.attacker)
					
	return result

static func _calculate_effective_resistance(raw_res: float, pct_pen: float, flat_pen: float) -> float:
	var res = raw_res
	if res > 0.0:
		res *= (1.0 - clampf(pct_pen, 0.0, 1.0))
		res -= flat_pen
	return res

static func _get_resistance_multiplier(effective_res: float) -> float:
	if effective_res >= 0.0:
		return 100.0 / (100.0 + effective_res)
	else:
		return 2.0 - (100.0 / (100.0 - effective_res))
