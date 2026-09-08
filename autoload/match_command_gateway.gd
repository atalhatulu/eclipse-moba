class_name MatchCommandGateway
extends Node

## Authority boundary for player intentions.  Offline mode treats peer 1 as the
## local host; online code can forward the same normalized dictionaries to a
## server without changing controller rules.

signal command_accepted(command: Dictionary)
signal command_rejected(actor: Node, kind: String, reason: String)

const LOCAL_HOST_PEER := 1
const MIN_COMMAND_INTERVAL := 0.035
var entity_owners: Dictionary = {} # instance id -> peer id
var last_command_at: Dictionary = {} # instance id -> seconds

func claim_entity(entity: BaseCombatEntity, peer_id: int = LOCAL_HOST_PEER) -> void:
	if entity != null and is_instance_valid(entity):
		entity_owners[entity.get_instance_id()] = peer_id

func release_entity(entity: BaseCombatEntity) -> void:
	if entity != null and is_instance_valid(entity):
		entity_owners.erase(entity.get_instance_id())
		last_command_at.erase(entity.get_instance_id())

func reset() -> void:
	entity_owners.clear()
	last_command_at.clear()

func authorize(actor: BaseCombatEntity, kind: String, payload: Dictionary = {}, peer_id: int = LOCAL_HOST_PEER) -> bool:
	if actor == null or not is_instance_valid(actor) or not actor.is_alive():
		return _reject(actor, kind, "Geçersiz veya ölü komut sahibi")
	var id = actor.get_instance_id()
	if not entity_owners.has(id):
		claim_entity(actor, peer_id) # local/offline first ownership claim
	if entity_owners[id] != peer_id:
		return _reject(actor, kind, "Bu birim başka bir oyuncuya ait")
	var now: float = float(Time.get_ticks_msec()) / 1000.0
	var actor_commands: Dictionary = last_command_at.get(id, {})
	if now - float(actor_commands.get(kind, -100.0)) < MIN_COMMAND_INTERVAL:
		return _reject(actor, kind, "Komut hızı sınırı")
	if not _validate_payload(actor, kind, payload):
		return false
	if not last_command_at.has(id):
		last_command_at[id] = {}
	last_command_at[id][kind] = now
	command_accepted.emit({"actor_id": id, "peer_id": peer_id, "kind": kind, "payload": payload.duplicate(), "time": now})
	return true

func _validate_payload(actor: BaseCombatEntity, kind: String, payload: Dictionary) -> bool:
	match kind:
		"move":
			var point: Vector3 = payload.get("point", Vector3.INF)
			if not is_finite(point.x) or not is_finite(point.y) or not is_finite(point.z):
				return _reject(actor, kind, "Geçersiz hareket konumu")
			if absf(point.x) > 150.0 or absf(point.z) > 150.0:
				return _reject(actor, kind, "Hareket noktası harita dışı")
		"attack":
			var target = payload.get("target", null)
			if not (target is BaseCombatEntity) or not is_instance_valid(target) or not TargetRelationSystem.is_valid_basic_attack_target(actor, target):
				return _reject(actor, kind, "Geçersiz saldırı hedefi")
		"cast":
			var slot = payload.get("slot", -1)
			if not (slot is int) or slot < 0 or slot > int(AbilityResource.Slot.PASSIVE):
				return _reject(actor, kind, "Geçersiz yetenek yuvası")
		"item":
			var item_slot = payload.get("slot", -1)
			if not (item_slot is int) or item_slot < 0 or item_slot >= InventoryManager.MAX_NORMAL_SLOTS:
				return _reject(actor, kind, "Geçersiz eşya yuvası")
	return true

func _reject(actor: Node, kind: String, reason: String) -> bool:
	command_rejected.emit(actor, kind, reason)
	return false
