class_name HighGroundSystem
extends RefCounted

## Dota 2 Authentic High Ground Advantage:
## - 25% Uphill Miss Chance when attacking an uphill target from lower elevation (e.g. river to lane, lane to base ramp).
## - Uphill Fog of War vision blocking.

const UPHILL_HEIGHT_THRESHOLD = 0.8 # meters difference
const UPHILL_MISS_CHANCE = 0.25 # 25% chance

static func _get_pos(entity: BaseCombatEntity) -> Vector3:
	if entity == null:
		return Vector3.ZERO
	return entity.global_position if entity.is_inside_tree() else entity.position

static func is_uphill_attack(attacker: BaseCombatEntity, target: BaseCombatEntity) -> bool:
	if attacker == null or target == null:
		return false
	var att_pos = _get_pos(attacker)
	var tgt_pos = _get_pos(target)
	var diff = tgt_pos.y - att_pos.y
	return diff >= UPHILL_HEIGHT_THRESHOLD

static func check_uphill_miss(attacker: BaseCombatEntity, target: BaseCombatEntity) -> bool:
	if is_uphill_attack(attacker, target):
		return randf() < UPHILL_MISS_CHANCE
	return false

static func can_see_target_elevation(viewer: BaseCombatEntity, target: BaseCombatEntity) -> bool:
	if viewer == null or target == null:
		return false
	var v_pos = _get_pos(viewer)
	var t_pos = _get_pos(target)
	
	# If viewer is on high ground looking down, they always have clear line of sight
	if v_pos.y >= t_pos.y - 0.2:
		return true
	# If viewer is on low ground looking uphill, distance must be closer to breach the ramp crest
	var dist = v_pos.distance_to(t_pos)
	return dist <= 6.0
