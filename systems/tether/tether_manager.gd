class_name TetherManager
extends RefCounted

## Combat Tether, Soul Link & Damage Redirection Engine for Eclipse Front
## Manages links between entities with recursion loop protection and distance tether breaks.

enum TetherType {
	SOUL_LINK,      # Oryn: Heals/protects ally, shares portion of damage
	LIFE_LINK,      # Selka: Redirects incoming damage to tethered enemy
	IRON_TETHER,    # Auron: Slows enemy and shares damage
	COLOSSUS_GUARD  # Tharos: Absorbs damage for tethered ally
}

# Registry: tether_id -> TetherEntry
# TetherEntry: {id: String, source: BaseCombatEntity, target: BaseCombatEntity, type: int, ratio: float, timer: float, max_dist: float}
static var _active_tethers: Dictionary = {}

static func create_tether(source: BaseCombatEntity, target: BaseCombatEntity, type: TetherType, ratio: float = 0.35, duration: float = 6.0, max_dist: float = 12.0) -> Dictionary:
	if source == null or target == null or source == target:
		return {}
		
	var tether_id = "tether_%d_%d_%d" % [source.get_instance_id(), target.get_instance_id(), int(type)]
	var entry = {
		"id": tether_id,
		"source": source,
		"target": target,
		"type": type,
		"ratio": clampf(ratio, 0.0, 0.80),
		"timer": duration,
		"max_dist": max_dist
	}
	_active_tethers[tether_id] = entry
	return entry

static func process_damage_redirection(victim: BaseCombatEntity, original_damage: float, damage_type: DamageRequest.DamageType) -> float:
	if victim == null or original_damage <= 0.0 or _active_tethers.is_empty():
		return 0.0
		
	var redirected_total = 0.0
	
	for tid in _active_tethers.keys():
		var t = _active_tethers[tid]
		var raw_src = t.get("source")
		var raw_tgt = t.get("target")
		
		if not is_instance_valid(raw_src) or not is_instance_valid(raw_tgt):
			_active_tethers.erase(tid)
			continue
			
		var src: BaseCombatEntity = raw_src as BaseCombatEntity
		var tgt: BaseCombatEntity = raw_tgt as BaseCombatEntity
		if not src.is_alive() or not tgt.is_alive():
			_active_tethers.erase(tid)
			continue
			
		var ratio: float = t.get("ratio", 0.0)
		var type: TetherType = t.get("type", TetherType.SOUL_LINK)
		
		# Selka Life Link: Selka takes damage -> redirects ratio to target enemy
		if type == TetherType.LIFE_LINK and victim == src:
			var split_dmg = original_damage * ratio
			redirected_total += split_dmg
			_apply_redirected_damage(tgt, src, split_dmg, damage_type, "Life Link")
			
		# Tharos Colossus Guard: Ally takes damage -> Tharos absorbs ratio
		elif type == TetherType.COLOSSUS_GUARD and victim == tgt:
			var absorbed_dmg = original_damage * ratio
			redirected_total += absorbed_dmg
			_apply_redirected_damage(src, tgt, absorbed_dmg, damage_type, "Colossus Guard")
			
		# Oryn Soul Link: Ally takes damage -> Oryn splits damage
		elif type == TetherType.SOUL_LINK and victim == tgt:
			var split_dmg = original_damage * ratio
			redirected_total += split_dmg
			_apply_redirected_damage(src, tgt, split_dmg, damage_type, "Soul Link")
			
	return redirected_total

static func _apply_redirected_damage(destination: BaseCombatEntity, original_victim: BaseCombatEntity, amount: float, damage_type: DamageRequest.DamageType, source_label: String) -> void:
	if not is_instance_valid(destination) or not destination.is_alive():
		return
		
	var req = DamageRequest.new()
	req.attacker = original_victim
	req.target = destination
	req.base_damage = amount
	req.damage_type = damage_type
	req.source_name = source_label
	req.is_ability = true
	req.is_redirected = true # Loop protection: prevents recursive redirect
	CombatCalculator.execute_damage(req)

static func get_tethers_for_entity(entity: BaseCombatEntity) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	if not is_instance_valid(entity):
		return result
	for tid in _active_tethers.keys():
		var t = _active_tethers[tid]
		if t.get("source") == entity or t.get("target") == entity:
			result.append(t)
	return result

static func break_tether(tether_id: String) -> void:
	_active_tethers.erase(tether_id)

static func tick(delta: float) -> void:
	for tid in _active_tethers.keys():
		var t = _active_tethers[tid]
		var raw_src = t.get("source")
		var raw_tgt = t.get("target")
		
		if not is_instance_valid(raw_src) or not is_instance_valid(raw_tgt):
			_active_tethers.erase(tid)
			continue
			
		var src: BaseCombatEntity = raw_src as BaseCombatEntity
		var tgt: BaseCombatEntity = raw_tgt as BaseCombatEntity
		if not src.is_alive() or not tgt.is_alive():
			_active_tethers.erase(tid)
			continue
			
		t["timer"] -= delta
		if t["timer"] <= 0.0:
			_active_tethers.erase(tid)
			continue
			
		var src_pos = src.global_position if src.is_inside_tree() else src.position
		var tgt_pos = tgt.global_position if tgt.is_inside_tree() else tgt.position
		var max_d: float = t.get("max_dist", 12.0)
		if src_pos.distance_to(tgt_pos) > max_d:
			_active_tethers.erase(tid)

static func clear_all() -> void:
	_active_tethers.clear()
