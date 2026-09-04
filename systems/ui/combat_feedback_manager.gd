class_name CombatFeedbackManager
extends Node

## Covers important combat outcomes that normal damage numbers do not explain:
## misses, shield blocks, hard CC application and kills.

const FloatingCombatTextClass = preload("res://scenes/ui/floating_combat_text_3d.gd")

func _ready() -> void:
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		if not GameEvents.damage_dealt.is_connected(_on_damage_dealt):
			GameEvents.damage_dealt.connect(_on_damage_dealt)
		if not GameEvents.status_effect_applied.is_connected(_on_status_effect_applied):
			GameEvents.status_effect_applied.connect(_on_status_effect_applied)
		if not GameEvents.entity_killed.is_connected(_on_entity_killed):
			GameEvents.entity_killed.connect(_on_entity_killed)
		if not GameEvents.combat_healed.is_connected(_on_combat_healed):
			GameEvents.combat_healed.connect(_on_combat_healed)
		if not GameEvents.mana_burned.is_connected(_on_mana_burned):
			GameEvents.mana_burned.connect(_on_mana_burned)
		if not GameEvents.shield_granted.is_connected(_on_shield_granted):
			GameEvents.shield_granted.connect(_on_shield_granted)
		if not GameEvents.execution_triggered.is_connected(_on_execution_triggered):
			GameEvents.execution_triggered.connect(_on_execution_triggered)

func _on_damage_dealt(result: DamageResult, _attacker: Node, target: Node) -> void:
	if result == null or not (target is Node3D):
		return
	if result.shield_absorbed > 0.01:
		_spawn_feedback(target as Node3D, "KALKAN -%d" % int(result.shield_absorbed), Color(0.35, 0.85, 1.0), false)
	if result.raw_damage > 0.0 and result.final_health_damage <= 0.01 and result.shield_absorbed <= 0.01:
		_spawn_feedback(target as Node3D, "ISKA", Color(0.82, 0.82, 0.72), false)

func _on_status_effect_applied(target: Node, effect: StatusEffect) -> void:
	if effect == null or not (target is Node3D) or not effect.is_debuff:
		return
	var label := ""
	var color := Color(1.0, 0.72, 0.22)
	if effect.get_meta("airborne", false):
		label = "HAVADA"
	elif effect.effect_type == StatusEffect.EffectType.STUN:
		label = "SERSEMLETİLDİ"
	elif effect.effect_type == StatusEffect.EffectType.ROOT:
		label = "KÖKLENDİ"
	elif effect.effect_type == StatusEffect.EffectType.SILENCE:
		label = "SUSTURULDU"
	elif effect.effect_type == StatusEffect.EffectType.DISARM:
		label = "SİLAHSIZ"
	elif effect.effect_type == StatusEffect.EffectType.BLIND:
		label = "KÖR"
	elif effect.effect_type == StatusEffect.EffectType.KNOCKBACK:
		label = "İTİLDİ"
	if not label.is_empty():
		_spawn_feedback(target as Node3D, label, color, false)

func _on_entity_killed(victim: Node, _killer: Node) -> void:
	if victim is Node3D:
		_spawn_feedback(victim as Node3D, "ÖLDÜRÜLDÜ", Color(1.0, 0.25, 0.20), true)

func _on_combat_healed(_source: Node, target: Node, amount: float, _source_name: String) -> void:
	if target is Node3D and amount > 0.01:
		_spawn_feedback(target as Node3D, "+%d" % int(amount), Color(0.30, 1.0, 0.48), false)

func _on_mana_burned(_source: Node, target: Node, amount: float, _damage: float, _source_name: String) -> void:
	if target is Node3D and amount > 0.01:
		_spawn_feedback(target as Node3D, "MANA -%d" % int(amount), Color(0.42, 0.72, 1.0), false)

func _on_shield_granted(_source: Node, target: Node, amount: float, _source_name: String) -> void:
	if target is Node3D and amount > 0.01:
		_spawn_feedback(target as Node3D, "KALKAN +%d" % int(amount), Color(0.35, 0.85, 1.0), false)

func _on_execution_triggered(_source: Node, target: Node, threshold: float, bonus_damage: float, _source_name: String) -> void:
	if target is Node3D and bonus_damage > 0.01:
		var label = "İMHA +%d" % int(bonus_damage)
		if threshold >= 0.0:
			label = "İNFAZ! +%d" % int(bonus_damage)
		_spawn_feedback(target as Node3D, label, Color(1.0, 0.30, 0.18), true)

func _spawn_feedback(target: Node3D, text: String, color: Color, emphatic: bool) -> void:
	if not target.is_inside_tree() or get_tree() == null:
		return
	var feedback = FloatingCombatTextClass.new()
	get_tree().root.add_child(feedback)
	feedback.setup(text, color, target.global_position, emphatic)
