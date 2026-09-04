class_name CombatMechanics
extends RefCounted

## Shared gameplay primitives used by items and hero skills.  These methods
## keep numbers, state icons and combat feedback in the same pipeline.

static func apply_mark(source: BaseCombatEntity, target: BaseCombatEntity, mark_id: String, display_name: String, duration: float = 6.0, max_stacks: int = 3, symbol: String = "◆") -> int:
	if target == null or not is_instance_valid(target) or target.effect_container == null:
		return 0
	var effect_id := "mark_" + mark_id.to_lower()
	var existing = target.effect_container.get_effect(effect_id)
	if existing != null:
		existing.refresh_duration(duration)
		existing.stacks = mini(existing.max_stacks, existing.stacks + 1)
		return existing.stacks
	var mark = StatusEffect.new(effect_id, StatusEffect.EffectType.DEBUFF, duration, 0.0, true)
	mark.max_stacks = maxi(1, max_stacks)
	mark.source_entity = source
	mark.set_meta("display_name", display_name)
	mark.set_meta("description", "%s yükü. Azami %d yük; süre yenilendiğinde yük korunur." % [display_name, mark.max_stacks])
	mark.set_meta("symbol", symbol)
	target.effect_container.apply_effect(mark)
	return mark.stacks

static func consume_marks(target: BaseCombatEntity, mark_id: String, amount: int = -1) -> int:
	if target == null or not is_instance_valid(target) or target.effect_container == null:
		return 0
	var effect = target.effect_container.get_effect("mark_" + mark_id.to_lower())
	if effect == null:
		return 0
	var consumed: int = effect.stacks if amount < 0 else mini(effect.stacks, amount)
	effect.stacks -= consumed
	if effect.stacks <= 0:
		target.effect_container.remove_effect_by_id(effect.effect_id)
	return consumed

static func execute_missing_health_damage(source: BaseCombatEntity, target: BaseCombatEntity, base_damage: float, missing_health_ratio: float, source_name: String, damage_type: DamageRequest.DamageType = DamageRequest.DamageType.TRUE_DAMAGE) -> DamageResult:
	if target == null or not is_instance_valid(target) or target.attribute_system == null:
		return DamageResult.new()
	var max_hp = target.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	var missing_hp = maxf(0.0, max_hp - target.attribute_system.current_health)
	var req = DamageRequest.create_spell_damage(source, target, base_damage + (missing_hp * missing_health_ratio), damage_type, source_name)
	return CombatCalculator.execute_damage(req)

static func health_ratio(target: BaseCombatEntity) -> float:
	if target == null or not is_instance_valid(target) or target.attribute_system == null:
		return 1.0
	var max_hp = target.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	return clampf(target.attribute_system.current_health / maxf(1.0, max_hp), 0.0, 1.0)

static func is_below_health_threshold(target: BaseCombatEntity, threshold: float) -> bool:
	return health_ratio(target) <= clampf(threshold, 0.0, 1.0)

static func announce_execution(source: BaseCombatEntity, target: BaseCombatEntity, threshold: float, bonus_damage: float, source_name: String) -> void:
	if bonus_damage <= 0.01 or not (Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents)):
		return
	GameEvents.execution_triggered.emit(source, target, threshold, bonus_damage, source_name)

static func heal(source: BaseCombatEntity, target: BaseCombatEntity, amount: float, source_name: String = "İyileştirme") -> float:
	if target == null or not is_instance_valid(target) or target.attribute_system == null or amount <= 0.0:
		return 0.0
	var before = target.attribute_system.current_health
	target.attribute_system.heal(amount)
	var actual = target.attribute_system.current_health - before
	if actual > 0.0 and (Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents)):
		GameEvents.combat_healed.emit(source, target, actual, source_name)
	return actual

static func apply_shield(source: BaseCombatEntity, target: BaseCombatEntity, shield_id: String, display_name: String, amount: float, duration: float) -> float:
	if target == null or not is_instance_valid(target) or target.effect_container == null or amount <= 0.0:
		return 0.0
	var existing = target.effect_container.get_effect(shield_id)
	if existing != null:
		existing.intensity += amount
		existing.refresh_duration(duration)
		return existing.intensity
	var shield = StatusEffect.new(shield_id, StatusEffect.EffectType.SHIELD, duration, amount, false)
	shield.source_entity = source
	shield.set_meta("display_name", display_name)
	shield.set_meta("description", "%.0f hasar emer. Tekrar uygulandığında kapasite eklenir." % amount)
	shield.set_meta("symbol", "🛡")
	target.effect_container.apply_effect(shield)
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.shield_granted.emit(source, target, amount, display_name)
	return amount

static func burn_mana(source: BaseCombatEntity, target: BaseCombatEntity, amount: float, damage_per_mana: float = 1.0, source_name: String = "Mana Yakma") -> Dictionary:
	if target == null or not is_instance_valid(target) or target.attribute_system == null:
		return {"mana_burned": 0.0, "damage": 0.0}
	var burned = minf(maxf(0.0, amount), target.attribute_system.current_mana)
	if burned <= 0.0:
		return {"mana_burned": 0.0, "damage": 0.0}
	target.attribute_system.current_mana -= burned
	target.attribute_system.mana_changed.emit(target.attribute_system.current_mana, target.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA))
	var damage: float = burned * maxf(0.0, damage_per_mana)
	if damage > 0.0:
		CombatCalculator.execute_damage(DamageRequest.create_spell_damage(source, target, damage, DamageRequest.DamageType.MAGICAL, source_name))
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.mana_burned.emit(source, target, burned, damage, source_name)
	return {"mana_burned": burned, "damage": damage}

static func apply_damage_modifier(source: BaseCombatEntity, target: BaseCombatEntity, modifier_id: String, display_name: String, value: float, duration: float, amplify: bool) -> void:
	if target == null or not is_instance_valid(target) or target.effect_container == null:
		return
	var effect = StatusEffect.new(modifier_id, StatusEffect.EffectType.STAT_MODIFIER, duration, value, not amplify)
	effect.source_entity = source
	effect.target_stat = StatModifier.TargetStat.DAMAGE_AMPLIFICATION if amplify else StatModifier.TargetStat.DAMAGE_REDUCTION
	# These combat stats start at zero; use FLAT so +10% means 0.10 rather
	# than a percentage of zero.
	effect.stat_mod_type = StatModifier.Type.FLAT
	effect.set_meta("display_name", display_name)
	effect.set_meta("description", ("Verilen hasar +%%%d." if amplify else "Alınan hasar -%%%d.") % int(value * 100.0))
	effect.set_meta("symbol", "▲" if amplify else "▼")
	target.effect_container.apply_effect(effect)

static func apply_lifesteal(source: BaseCombatEntity, target: BaseCombatEntity, modifier_id: String, display_name: String, value: float, duration: float = -1.0) -> void:
	if target == null or not is_instance_valid(target) or target.effect_container == null:
		return
	var effect = StatusEffect.new(modifier_id, StatusEffect.EffectType.STAT_MODIFIER, duration, value, false)
	effect.source_entity = source
	effect.target_stat = StatModifier.TargetStat.LIFESTEAL
	effect.stat_mod_type = StatModifier.Type.FLAT
	effect.set_meta("display_name", display_name)
	effect.set_meta("description", "Normal saldırı hasarının %%%d kadarı can olarak geri kazanılır." % int(value * 100.0))
	effect.set_meta("symbol", "♥")
	target.effect_container.apply_effect(effect)
