class_name SummonManager
extends RefCounted

## Centralized Summon Lifecycle, AI & Clone Management System for Eclipse Front
## Supports Aethon Constructs (Guardian/Cannon/Siege) and Rivena Shadow Shades.

enum ConstructType {
	GUARDIAN, # Melee Tanky Construct
	CANNON,   # Ranged Magic Construct
	SIEGE     # Merged Siege Construct
}

# Active summons registry: owner_id -> Array of SummonEntry
# SummonEntry: {id: String, type: int, pos: Vector3, health: float, max_health: float, damage: float, timer: float, attack_timer: float, is_shade: bool}
static var _active_summons: Dictionary = {}

static func spawn_construct(owner: BaseCombatEntity, type: ConstructType, pos: Vector3, hp: float, dmg: float, lifetime: float = 15.0) -> Dictionary:
	if owner == null:
		return {}
		
	var owner_key = owner.get_instance_id()
	if not _active_summons.has(owner_key):
		_active_summons[owner_key] = []
		
	var summons: Array = _active_summons[owner_key]
	if summons.size() >= 4:
		summons.remove_at(0) # FIFO clamp
		
	var entry = {
		"id": "construct_" + str(randi()),
		"type": type,
		"pos": pos,
		"health": hp,
		"max_health": hp,
		"damage": dmg,
		"timer": lifetime,
		"attack_timer": 0.0,
		"is_shade": false,
		"owner": owner
	}
	summons.append(entry)
	
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("SUMMON: %s construct spawned at %s" % [ConstructType.keys()[type], str(pos)])
		
	return entry

static func spawn_shade(owner: BaseCombatEntity, pos: Vector3, lifetime: float = 5.0) -> Dictionary:
	if owner == null:
		return {}
		
	var owner_key = owner.get_instance_id()
	if not _active_summons.has(owner_key):
		_active_summons[owner_key] = []
		
	var summons: Array = _active_summons[owner_key]
	if summons.size() >= 3:
		summons.remove_at(0)
		
	var entry = {
		"id": "shade_" + str(randi()),
		"type": -1,
		"pos": pos,
		"health": 1.0,
		"max_health": 1.0,
		"damage": 0.0,
		"timer": lifetime,
		"attack_timer": 0.0,
		"is_shade": true,
		"owner": owner
	}
	summons.append(entry)
	return entry

static func get_owner_summons(owner: BaseCombatEntity) -> Array:
	if owner == null:
		return []
	var owner_key = owner.get_instance_id()
	return _active_summons.get(owner_key, [])

static func get_construct_count(owner: BaseCombatEntity) -> int:
	var list = get_owner_summons(owner)
	var count = 0
	for s in list:
		if not s.get("is_shade", false):
			count += 1
	return count

static func get_shade_count(owner: BaseCombatEntity) -> int:
	var list = get_owner_summons(owner)
	var count = 0
	for s in list:
		if s.get("is_shade", false):
			count += 1
	return count

static func reconfigure_constructs(owner: BaseCombatEntity) -> int:
	var list = get_owner_summons(owner)
	var count = 0
	for c in list:
		if not c.get("is_shade", false):
			count += 1
			if c.get("type", ConstructType.GUARDIAN) == ConstructType.GUARDIAN:
				c["type"] = ConstructType.CANNON
				c["damage"] = c.get("damage", 30.0) * 1.30
			elif c.get("type", ConstructType.GUARDIAN) == ConstructType.CANNON:
				c["type"] = ConstructType.GUARDIAN
				c["health"] = c.get("health", 100.0) + (c.get("max_health", 100.0) * 0.50)
	return count

static func assemble_siege_construct(owner: BaseCombatEntity, pos: Vector3) -> Dictionary:
	var list = get_owner_summons(owner)
	var count = 0
	var combined_hp = 650.0
	var combined_dmg = 90.0
	
	for i in range(list.size() - 1, -1, -1):
		if not list[i].get("is_shade", false):
			count += 1
			combined_hp += list[i].get("health", 0.0) * 0.75
			combined_dmg += list[i].get("damage", 0.0) * 0.50
			list.remove_at(i)
			
	if count == 0:
		return {}
		
	return spawn_construct(owner, ConstructType.SIEGE, pos, combined_hp, combined_dmg, 20.0)

static func swap_with_shade(owner: BaseCombatEntity, target_pos: Vector3 = Vector3.ZERO) -> Vector3:
	var list = get_owner_summons(owner)
	var best_idx = -1
	var min_dist = INF
	
	for i in range(list.size()):
		if list[i].get("is_shade", false):
			var s_pos: Vector3 = list[i].get("pos", Vector3.ZERO)
			if target_pos == Vector3.ZERO:
				best_idx = i # Pick newest or latest
			else:
				var d = s_pos.distance_squared_to(target_pos)
				if d < min_dist:
					min_dist = d
					best_idx = i
					
	if best_idx >= 0:
		var target_loc = list[best_idx].get("pos", Vector3.ZERO)
		list.remove_at(best_idx)
		return target_loc
	return Vector3.ZERO

static func tick(delta: float) -> void:
	for owner_key in _active_summons.keys():
		var list: Array = _active_summons[owner_key]
		for i in range(list.size() - 1, -1, -1):
			var s = list[i]
			s["timer"] -= delta
			if s["timer"] <= 0.0 or s["health"] <= 0.0:
				list.remove_at(i)
			elif not s.get("is_shade", false):
				# Process construct auto-attack
				s["attack_timer"] -= delta
				if s["attack_timer"] <= 0.0:
					s["attack_timer"] = 1.4 # Attack interval
					# Attack nearest enemy
					_process_summon_attack(s)
		if list.is_empty():
			_active_summons.erase(owner_key)

static func _process_summon_attack(summon: Dictionary) -> void:
	var owner: BaseCombatEntity = summon.get("owner", null)
	if owner == null or not is_instance_valid(owner) or not owner.is_alive():
		return
		
	var pos: Vector3 = summon.get("pos", Vector3.ZERO)
	var dmg: float = summon.get("damage", 0.0)
	var type: ConstructType = summon.get("type", ConstructType.GUARDIAN)
	var max_range = 2.5 if type == ConstructType.GUARDIAN else (8.5 if type == ConstructType.CANNON else 5.0)
	
	var target: BaseCombatEntity = null
	var nearest_distance := INF
	for candidate in _get_combat_entities():
		if not owner.is_enemy_with(candidate) or not candidate.is_targetable:
			continue
		var candidate_pos = candidate.global_position if candidate.is_inside_tree() else candidate.position
		var distance = pos.distance_to(candidate_pos)
		if distance <= max_range and distance < nearest_distance:
			nearest_distance = distance
			target = candidate
	if target != null:
		var damage_type = DamageRequest.DamageType.PHYSICAL if type == ConstructType.GUARDIAN else DamageRequest.DamageType.MAGICAL
		CombatCalculator.execute_damage(DamageRequest.create_ability_damage(owner, target, dmg, damage_type, "Construct Attack"))

static func _get_combat_entities() -> Array[BaseCombatEntity]:
	var entities: Array[BaseCombatEntity] = []
	for hero in HeroEntity.active_heroes:
		if is_instance_valid(hero) and hero.is_alive():
			entities.append(hero)
	for creep in CreepEntity.active_creeps:
		if is_instance_valid(creep) and creep.is_alive():
			entities.append(creep)
	return entities

static func cleanup_owner_summons(owner: BaseCombatEntity) -> void:
	if owner != null:
		_active_summons.erase(owner.get_instance_id())

static func clear_all() -> void:
	_active_summons.clear()
