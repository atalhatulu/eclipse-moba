class_name SpatialManager
extends RefCounted

## Spatial Architect & Zone Placement Engine for Eclipse Front
## Manages Neris Arcane Nodes, Energy Walls, Spatial Gates, and Seris Razor Traps.

enum SpatialType {
	NODE,
	WALL,
	GATE,
	TRAP
}

# Registry: owner_id -> Array of SpatialEntry
# SpatialEntry: {id: String, type: int, pos_a: Vector3, pos_b: Vector3, radius: float, timer: float, dps: float, owner: BaseCombatEntity}
static var _active_objects: Dictionary = {}

static func create_node(owner: BaseCombatEntity, pos: Vector3, lifetime: float = 45.0) -> Dictionary:
	if owner == null: return {}
	var key = owner.get_instance_id()
	if not _active_objects.has(key): _active_objects[key] = []
	
	var list: Array = _active_objects[key]
	var node_count = 0
	for obj in list:
		if obj.get("type") == SpatialType.NODE: node_count += 1
	if node_count >= 6:
		for i in range(list.size()):
			if list[i].get("type") == SpatialType.NODE:
				list.remove_at(i)
				break
				
	var entry = {
		"id": "node_" + str(randi()),
		"type": SpatialType.NODE,
		"pos_a": pos,
		"pos_b": Vector3.ZERO,
		"radius": 1.5,
		"timer": lifetime,
		"dps": 0.0,
		"owner": owner
	}
	list.append(entry)
	return entry

static func create_wall(owner: BaseCombatEntity, pos_a: Vector3, pos_b: Vector3, lifetime: float = 8.0, dps: float = 120.0) -> Dictionary:
	if owner == null: return {}
	var key = owner.get_instance_id()
	if not _active_objects.has(key): _active_objects[key] = []
	
	var entry = {
		"id": "wall_" + str(randi()),
		"type": SpatialType.WALL,
		"pos_a": pos_a,
		"pos_b": pos_b,
		"radius": 1.0,
		"timer": lifetime,
		"dps": dps,
		"damage_accumulator": 0.0,
		"owner": owner
	}
	_active_objects[key].append(entry)
	return entry

static func create_gate(owner: BaseCombatEntity, pos_a: Vector3, pos_b: Vector3, lifetime: float = 10.0) -> Dictionary:
	if owner == null: return {}
	var key = owner.get_instance_id()
	if not _active_objects.has(key): _active_objects[key] = []
	
	var entry = {
		"id": "gate_" + str(randi()),
		"type": SpatialType.GATE,
		"pos_a": pos_a,
		"pos_b": pos_b,
		"radius": 2.0,
		"timer": lifetime,
		"dps": 0.0,
		"recent_teleports": {},
		"owner": owner
	}
	_active_objects[key].append(entry)
	return entry

static func place_trap(owner: BaseCombatEntity, pos: Vector3, lifetime: float = 60.0, trigger_radius: float = 2.5, damage: float = 140.0) -> Dictionary:
	if owner == null: return {}
	var key = owner.get_instance_id()
	if not _active_objects.has(key): _active_objects[key] = []
	
	var list: Array = _active_objects[key]
	var trap_count = 0
	for obj in list:
		if obj.get("type") == SpatialType.TRAP: trap_count += 1
	if trap_count >= 4:
		for i in range(list.size()):
			if list[i].get("type") == SpatialType.TRAP:
				list.remove_at(i)
				break
				
	var entry = {
		"id": "trap_" + str(randi()),
		"type": SpatialType.TRAP,
		"pos_a": pos,
		"pos_b": Vector3.ZERO,
		"radius": trigger_radius,
		"timer": lifetime,
		"dps": damage,
		"owner": owner
	}
	list.append(entry)
	return entry

static func get_owner_objects(owner: BaseCombatEntity, type_filter: int = -1) -> Array:
	if owner == null: return []
	var key = owner.get_instance_id()
	var list: Array = _active_objects.get(key, [])
	if type_filter < 0: return list
	
	var filtered: Array = []
	for obj in list:
		if obj.get("type") == type_filter:
			filtered.append(obj)
	return filtered

static func detonate_all_traps(owner: BaseCombatEntity) -> int:
	if owner == null: return 0
	var key = owner.get_instance_id()
	var list: Array = _active_objects.get(key, [])
	var detonated = 0
	for i in range(list.size() - 1, -1, -1):
		if list[i].get("type") == SpatialType.TRAP:
			detonated += 1
			list.remove_at(i)
	return detonated

static func tick(delta: float) -> void:
	for key in _active_objects.keys():
		var list: Array = _active_objects[key]
		for i in range(list.size() - 1, -1, -1):
			var obj = list[i]
			obj["timer"] -= delta
			if obj["timer"] <= 0.0:
				list.remove_at(i)
				continue
			_process_object(obj, delta, list, i)
		if list.is_empty():
			_active_objects.erase(key)

## Turns placed spatial objects into gameplay rules.  Keeping this here means
## every hero can use walls, traps and gates without a custom scene script.
static func _process_object(obj: Dictionary, delta: float, list: Array, index: int) -> void:
	var owner = obj.get("owner") as BaseCombatEntity
	if owner == null or not is_instance_valid(owner):
		list.remove_at(index)
		return
	match obj.get("type", -1):
		SpatialType.WALL:
			_process_wall(obj, owner, delta)
		SpatialType.TRAP:
			if _process_trap(obj, owner):
				list.remove_at(index)
		SpatialType.GATE:
			_process_gate(obj, owner, delta)

static func _process_wall(obj: Dictionary, owner: BaseCombatEntity, delta: float) -> void:
	obj["damage_accumulator"] = float(obj.get("damage_accumulator", 0.0)) + delta
	var should_damage := float(obj["damage_accumulator"]) >= 0.5
	if should_damage:
		obj["damage_accumulator"] = 0.0
	for entity in _get_combat_entities():
		if not owner.is_enemy_with(entity):
			continue
		var closest := _closest_point_on_segment(_entity_position(entity), obj["pos_a"], obj["pos_b"])
		if _horizontal_distance(_entity_position(entity), closest) > float(obj["radius"]):
			continue
		# A wall is both a soft blocker and a hazardous boundary.
		if entity.effect_container != null:
			entity.effect_container.apply_knockback(closest, 0.8, 0.15, str(obj["id"]) + "_push")
			entity.effect_container.apply_slow(0.35, 0.6)
		if should_damage:
			_deal_magic_damage(owner, entity, float(obj["dps"]) * 0.5, "Energy Wall")

static func _process_trap(obj: Dictionary, owner: BaseCombatEntity) -> bool:
	for entity in _get_combat_entities():
		if owner.is_enemy_with(entity) and _horizontal_distance(_entity_position(entity), obj["pos_a"]) <= float(obj["radius"]):
			_deal_magic_damage(owner, entity, float(obj["dps"]), "Razor Trap")
			if entity.effect_container != null:
				entity.effect_container.apply_slow(0.55, 2.0)
			return true
	return false

static func _process_gate(obj: Dictionary, owner: BaseCombatEntity, delta: float) -> void:
	var recent: Dictionary = obj.get("recent_teleports", {})
	for entity_id in recent.keys():
		recent[entity_id] = float(recent[entity_id]) - delta
		if recent[entity_id] <= 0.0:
			recent.erase(entity_id)
	obj["recent_teleports"] = recent
	for entity in _get_combat_entities():
		if not owner.is_ally_with(entity):
			continue
		var entity_id := entity.get_instance_id()
		if recent.has(entity_id):
			continue
		var pos := _entity_position(entity)
		var destination := Vector3.ZERO
		if _horizontal_distance(pos, obj["pos_a"]) <= float(obj["radius"]):
			destination = obj["pos_b"]
		elif _horizontal_distance(pos, obj["pos_b"]) <= float(obj["radius"]):
			destination = obj["pos_a"]
		else:
			continue
		entity.position = destination
		recent[entity_id] = 0.35

static func _get_combat_entities() -> Array[BaseCombatEntity]:
	var entities: Array[BaseCombatEntity] = []
	for hero in HeroEntity.active_heroes:
		if is_instance_valid(hero) and hero.is_alive():
			entities.append(hero)
	for creep in CreepEntity.active_creeps:
		if is_instance_valid(creep) and creep.is_alive():
			entities.append(creep)
	return entities

static func _deal_magic_damage(owner: BaseCombatEntity, target: BaseCombatEntity, amount: float, source: String) -> void:
	if amount <= 0.0:
		return
	target.receive_damage(DamageRequest.create_spell_damage(owner, target, amount, DamageRequest.DamageType.MAGICAL, source))

static func _entity_position(entity: BaseCombatEntity) -> Vector3:
	return entity.global_position if entity.is_inside_tree() else entity.position

static func _horizontal_distance(a: Vector3, b: Vector3) -> float:
	return Vector2(a.x - b.x, a.z - b.z).length()

static func _closest_point_on_segment(point: Vector3, a: Vector3, b: Vector3) -> Vector3:
	var segment := Vector2(b.x - a.x, b.z - a.z)
	var length_squared := segment.length_squared()
	if length_squared <= 0.0001:
		return a
	var relative := Vector2(point.x - a.x, point.z - a.z)
	var t := clampf(relative.dot(segment) / length_squared, 0.0, 1.0)
	return Vector3(a.x + segment.x * t, a.y + (b.y - a.y) * t, a.z + segment.y * t)

static func cleanup_owner_objects(owner: BaseCombatEntity) -> void:
	if owner != null:
		_active_objects.erase(owner.get_instance_id())

static func clear_all() -> void:
	_active_objects.clear()
