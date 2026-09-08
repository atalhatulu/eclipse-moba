class_name CombatEventHistory
extends Node

## Authoritative short-term battle timeline. UI (death recap, kill feed and
## replay controls) reads this data instead of trying to reconstruct combat
## from floating text after the fact.

const MAX_EVENTS := 240
const RECAP_WINDOW_SECONDS := 8.0

var events: Array[Dictionary] = []

func _ready() -> void:
	if not GameEvents.damage_dealt.is_connected(_on_damage_dealt):
		GameEvents.damage_dealt.connect(_on_damage_dealt)
	if not GameEvents.combat_healed.is_connected(_on_healed):
		GameEvents.combat_healed.connect(_on_healed)
	if not GameEvents.status_effect_applied.is_connected(_on_effect_applied):
		GameEvents.status_effect_applied.connect(_on_effect_applied)
	if not GameEvents.ability_cast.is_connected(_on_ability_cast):
		GameEvents.ability_cast.connect(_on_ability_cast)
	if not GameEvents.entity_killed.is_connected(_on_entity_killed):
		GameEvents.entity_killed.connect(_on_entity_killed)

func _record(kind: String, source: Node, target: Node, value: float, label: String) -> void:
	events.append({
		"time": Time.get_ticks_msec() / 1000.0,
		"kind": kind,
		"source": source,
		"target": target,
		"value": value,
		"label": label
	})
	if events.size() > MAX_EVENTS:
		events.pop_front()

func get_recap(target: Node, window_seconds: float = RECAP_WINDOW_SECONDS) -> Array[Dictionary]:
	var now := Time.get_ticks_msec() / 1000.0
	var recap: Array[Dictionary] = []
	for event in events:
		if event.get("target") == target and now - float(event.get("time", 0.0)) <= window_seconds:
			recap.append(event)
	return recap

func _on_damage_dealt(result: DamageResult, attacker: Node, target: Node) -> void:
	if result != null and result.final_health_damage > 0.01:
		_record("damage", attacker, target, result.final_health_damage, result.source_name)

func _on_healed(source: Node, target: Node, amount: float, source_name: String) -> void:
	if amount > 0.01:
		_record("heal", source, target, amount, source_name)

func _on_effect_applied(target: Node, effect: StatusEffect) -> void:
	if effect != null:
		_record("effect", effect.source_entity, target, effect.duration, str(effect.get_meta("display_name", effect.effect_id)))

func _on_ability_cast(caster: Node, ability: AbilityResource, _point: Vector3, target: Variant) -> void:
	_record("cast", caster, target as Node, 0.0, ability.ability_name if ability != null else "Yetenek")

func _on_entity_killed(victim: Node, killer: Node) -> void:
	_record("kill", killer, victim, 0.0, "Öldürme")
