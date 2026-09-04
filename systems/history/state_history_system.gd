class_name StateHistorySystem
extends RefCounted

## State Snapshot & Temporal Rewind Engine for Eclipse Front
## Maintains ring-buffer snapshots of entity position, health, mana, and damage windows.

const MAX_HISTORY_SECONDS: float = 5.0
const SNAPSHOT_INTERVAL: float = 0.20

# Registry: entity_id -> Array of Snapshot
# Snapshot: {time: float, pos: Vector3, health: float, mana: float, damage_taken_total: float}
static var _history: Dictionary = {}
static var _last_snapshot_time: Dictionary = {}

static func record_snapshot(entity: BaseCombatEntity, current_time: float) -> void:
	if entity == null or not is_instance_valid(entity):
		return
		
	var key = entity.get_instance_id()
	var last_t = _last_snapshot_time.get(key, -1.0)
	if last_t >= 0.0 and (current_time - last_t) < SNAPSHOT_INTERVAL:
		return
		
	_last_snapshot_time[key] = current_time
	if not _history.has(key):
		_history[key] = []
		
	var snapshots: Array = _history[key]
	var pos = entity.global_position if entity.is_inside_tree() else entity.position
	var hp = entity.attribute_system.current_health if entity.attribute_system != null else 0.0
	var mp = entity.attribute_system.current_mana if entity.attribute_system != null else 0.0
	
	snapshots.append({
		"time": current_time,
		"pos": pos,
		"health": hp,
		"mana": mp
	})
	
	# Prune snapshots older than MAX_HISTORY_SECONDS
	while not snapshots.is_empty() and (current_time - snapshots[0]["time"]) > MAX_HISTORY_SECONDS:
		snapshots.pop_front()

static func get_state_at_time_ago(entity: BaseCombatEntity, seconds_ago: float, current_time: float) -> Dictionary:
	if entity == null or not is_instance_valid(entity):
		return {}
		
	var key = entity.get_instance_id()
	var snapshots: Array = _history.get(key, [])
	if snapshots.is_empty():
		var p = entity.global_position if entity.is_inside_tree() else entity.position
		var h = entity.attribute_system.current_health if entity.attribute_system != null else 0.0
		var m = entity.attribute_system.current_mana if entity.attribute_system != null else 0.0
		return {"pos": p, "health": h, "mana": m, "time": current_time}
		
	var target_time = current_time - seconds_ago
	var best_snapshot = snapshots[0]
	var min_diff = INF
	
	for s in snapshots:
		var diff = absf(s["time"] - target_time)
		if diff < min_diff:
			min_diff = diff
			best_snapshot = s
			
	return best_snapshot

static func rewind_entity(entity: BaseCombatEntity, seconds_ago: float, current_time: float) -> Dictionary:
	if entity == null or not is_instance_valid(entity):
		return {}
		
	var past_state = get_state_at_time_ago(entity, seconds_ago, current_time)
	if past_state.is_empty():
		return {}
		
	var old_pos = entity.global_position if entity.is_inside_tree() else entity.position
	var target_pos: Vector3 = past_state.get("pos", old_pos)
	
	if entity.is_inside_tree():
		entity.global_position = target_pos
	else:
		entity.position = target_pos
		
	if entity.attribute_system != null:
		var past_hp: float = past_state.get("health", entity.attribute_system.current_health)
		# Temporal rule: restore health to past value if past was higher
		if past_hp > entity.attribute_system.current_health:
			entity.attribute_system.heal(past_hp - entity.attribute_system.current_health)
			
		var past_mp: float = past_state.get("mana", entity.attribute_system.current_mana)
		if past_mp > entity.attribute_system.current_mana:
			entity.attribute_system.restore_mana(past_mp - entity.attribute_system.current_mana)
			
	return {
		"from_pos": old_pos,
		"to_pos": target_pos,
		"health": past_state.get("health", 0.0),
		"mana": past_state.get("mana", 0.0)
	}

static func get_damage_taken_in_window(entity: BaseCombatEntity, window_seconds: float, current_time: float) -> float:
	if entity == null or not is_instance_valid(entity):
		return 0.0
		
	var past_state = get_state_at_time_ago(entity, window_seconds, current_time)
	if past_state.is_empty():
		return 0.0
		
	var past_hp: float = past_state.get("health", entity.attribute_system.current_health)
	var current_hp: float = entity.attribute_system.current_health if entity.attribute_system != null else 0.0
	return maxf(0.0, past_hp - current_hp)

static func clear_entity_history(entity: BaseCombatEntity) -> void:
	if entity != null:
		var key = entity.get_instance_id()
		_history.erase(key)
		_last_snapshot_time.erase(key)

static func clear_all() -> void:
	_history.clear()
	_last_snapshot_time.clear()
