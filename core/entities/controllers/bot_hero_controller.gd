class_name BotHeroController
extends Node

const CourierManagerClass = preload("res://systems/courier/courier_manager.gd")

## Modular Evaluator-Based AI Controller for Astris (Dire Bot)

enum BotState {
	LANE,
	FARM,
	HARASS,
	ATTACK,
	RETREAT,
	DEFEND_TOWER,
	OBJECTIVE_BOSS,
	CONTEST_RUNE,
	GANK_ROAM,
	DEAD,
	RESPAWN
}

enum LaneRole {
	POS_1_CARRY,
	POS_2_MID,
	POS_3_OFFLANE,
	POS_4_SOFT_SUPPORT,
	POS_5_HARD_SUPPORT
}

enum AssignedLane {
	TOP,
	MID,
	BOT,
	ROAM
}

@export var bot_hero: HeroEntity = null
@export var opponent_hero: HeroEntity = null
@export var friendly_tower: TowerEntity = null
@export var enemy_tower: TowerEntity = null
@export var assigned_lane: AssignedLane = AssignedLane.MID
@export var assigned_role: LaneRole = LaneRole.POS_2_MID

var current_state: BotState = BotState.LANE
var current_target: BaseCombatEntity = null
var current_objective_target: BaseCombatEntity = null
var current_rune_target: Node3D = null

const TOP_WAYPOINTS_RADIANT: Array[Vector3] = [
	Vector3(-70.0, 0.0, 70.0),
	Vector3(-65.0, 0.0, 10.0),
	Vector3(-60.0, 0.0, -45.0),
	Vector3(-40.0, 0.0, -60.0),
	Vector3(10.0, 0.0, -65.0),
	Vector3(70.0, 0.0, -70.0)
]

const MID_WAYPOINTS_RADIANT: Array[Vector3] = [
	Vector3(-70.0, 0.0, 70.0),
	Vector3(-45.0, 0.0, 45.0),
	Vector3(-25.0, 0.0, 25.0),
	Vector3(0.0, 0.0, 0.0),
	Vector3(25.0, 0.0, -25.0),
	Vector3(45.0, 0.0, -45.0),
	Vector3(70.0, 0.0, -70.0)
]

const BOT_WAYPOINTS_RADIANT: Array[Vector3] = [
	Vector3(-70.0, 0.0, 70.0),
	Vector3(-10.0, 0.0, 65.0),
	Vector3(40.0, 0.0, 60.0),
	Vector3(60.0, 0.0, 45.0),
	Vector3(65.0, 0.0, -10.0),
	Vector3(70.0, 0.0, -70.0)
]

var lane_waypoints: Array[Vector3] = [
	Vector3(70.0, 1.5, -70.0),
	Vector3(45.0, 0.0, -45.0),
	Vector3(25.0, 0.0, -25.0),
	Vector3(0.0, -1.0, 0.0),
	Vector3(-25.0, 0.0, 25.0),
	Vector3(-45.0, 0.0, 45.0)
]
var current_waypoint_idx: int = 1

# Decision Timers
var decision_tick_timer: float = 0.0
const DECISION_INTERVAL: float = 0.25 # Evaluates every 250ms

# Attack pacing
var attack_cooldown_timer: float = 0.0
var combo_cooldown_timer: float = 0.0
var item_purchase_timer: float = 0.0
var current_gank_target: HeroEntity = null
var last_state: BotState = BotState.LANE

func _ready() -> void:
	if bot_hero == null and get_parent() is HeroEntity:
		bot_hero = get_parent() as HeroEntity
	_initialize_waypoints()

func setup_lane(lane: AssignedLane, role: LaneRole = LaneRole.POS_2_MID) -> void:
	assigned_lane = lane
	assigned_role = role
	_initialize_waypoints()

func _initialize_waypoints() -> void:
	var base_pts: Array[Vector3] = []
	match assigned_lane:
		AssignedLane.TOP:
			base_pts = TOP_WAYPOINTS_RADIANT.duplicate()
		AssignedLane.BOT:
			base_pts = BOT_WAYPOINTS_RADIANT.duplicate()
		AssignedLane.ROAM:
			base_pts = [Vector3(0, 0, 15), Vector3(15, 0, 0), Vector3(0, 0, -15), Vector3(-15, 0, 0)]
		_:
			base_pts = MID_WAYPOINTS_RADIANT.duplicate()
			
	if bot_hero != null and bot_hero.team == TeamDefinitions.Team.DIRE:
		base_pts.reverse()
		
	lane_waypoints = base_pts
	current_waypoint_idx = 1

func _physics_process(delta: float) -> void:
	if bot_hero == null or not is_instance_valid(bot_hero):
		return
		
	if not bot_hero.is_alive():
		current_state = BotState.DEAD
		return
		
	if attack_cooldown_timer > 0.0:
		attack_cooldown_timer -= delta
	if combo_cooldown_timer > 0.0:
		combo_cooldown_timer -= delta
		
	item_purchase_timer += delta
	if item_purchase_timer >= 4.0:
		item_purchase_timer = 0.0
		_evaluate_and_purchase_items()

	decision_tick_timer += delta
	if decision_tick_timer >= DECISION_INTERVAL:
		decision_tick_timer = 0.0
		_evaluate_and_update_state()
		
	_execute_current_state(delta)

# ==============================================================================
# 1. MODULAR EVALUATORS & WEIGHTED SCORING
# ==============================================================================
func _evaluate_and_update_state() -> void:
	if not bot_hero.is_alive():
		current_state = BotState.DEAD
		return
		
	var hp_ratio = eval_health_ratio()
	var mp_ratio = eval_mana_ratio()
	# Do not rely on a single inspector-assigned opponent.  This lets the same
	# controller work in ARAM, custom matches and future multi-hero modes.
	opponent_hero = _find_priority_enemy_hero()
	var enemy_dist = eval_enemy_distance()
	var enemy_hp_ratio = eval_enemy_health_ratio()
	var nearby_allied_creeps = eval_allied_minion_count()
	var nearby_enemy_creeps = eval_enemy_minion_count()
	var under_tower = eval_is_under_enemy_tower()
	
	# Score Accumulators
	var retreat_score: float = 0.0
	var defend_score: float = 0.0
	var attack_score: float = 0.0
	var harass_score: float = 0.0
	var farm_score: float = 0.0
	var rune_score: float = 0.0
	var objective_score: float = 0.0
	var gank_score: float = 0.0
	var lane_score: float = 20.0 # Baseline score

	# Gank Opportunity Evaluation
	current_gank_target = _find_gank_opportunity()
	if current_gank_target != null and hp_ratio > 0.65:
		gank_score += 46.0

	# Rune Contest Evaluation
	current_rune_target = eval_nearby_rune()
	if current_rune_target != null:
		rune_score += 48.0

	# Boss / Objective Evaluation
	current_objective_target = eval_nearby_boss_objective()
	if current_objective_target != null:
		objective_score += 52.0
	
	# 1. RETREAT EVALUATION
	if hp_ratio < 0.30:
		retreat_score += 90.0
	elif hp_ratio < 0.50 and enemy_dist < 6.0:
		retreat_score += 65.0
	if under_tower:
		retreat_score += 85.0
		
	# 2. DEFEND TOWER EVALUATION
	if friendly_tower != null and is_instance_valid(friendly_tower) and friendly_tower.is_alive():
		var dist_to_friendly_tower = bot_hero.global_position.distance_to(friendly_tower.global_position)
		if dist_to_friendly_tower < 15.0 and nearby_enemy_creeps > 2:
			defend_score += 55.0
			
	# 3. ATTACK (KILL COMBO) EVALUATION
	if opponent_hero != null and is_instance_valid(opponent_hero) and opponent_hero.is_alive():
		if enemy_dist < 8.0:
			if enemy_hp_ratio < 0.35 and mp_ratio > 0.30:
				attack_score += 85.0 # Execute opportunity
			elif enemy_hp_ratio < 0.60 and hp_ratio > 0.60 and mp_ratio > 0.50:
				attack_score += 60.0
				
	# 4. HARASS EVALUATION
	if opponent_hero != null and is_instance_valid(opponent_hero) and opponent_hero.is_alive():
		if enemy_dist >= 4.0 and enemy_dist <= 7.5 and hp_ratio > 0.40 and mp_ratio > 0.25:
			harass_score += 45.0
			
	# 5. FARM EVALUATION
	if nearby_enemy_creeps > 0:
		farm_score += 35.0
		if eval_has_lasthit_opportunity():
			farm_score += 30.0
			
	# Pick state with highest score
	var max_score = retreat_score
	var chosen_state = BotState.RETREAT
	
	if defend_score > max_score:
		max_score = defend_score
		chosen_state = BotState.DEFEND_TOWER
	if attack_score > max_score:
		max_score = attack_score
		chosen_state = BotState.ATTACK
	if harass_score > max_score:
		max_score = harass_score
		chosen_state = BotState.HARASS
	if farm_score > max_score:
		max_score = farm_score
		chosen_state = BotState.FARM
	if rune_score > max_score:
		max_score = rune_score
		chosen_state = BotState.CONTEST_RUNE
	if objective_score > max_score:
		max_score = objective_score
		chosen_state = BotState.OBJECTIVE_BOSS
	if gank_score > max_score:
		max_score = gank_score
		chosen_state = BotState.GANK_ROAM
	if lane_score > max_score:
		chosen_state = BotState.LANE
		
	last_state = current_state
	current_state = chosen_state

# ==============================================================================
# 2. EVALUATOR HELPER FUNCTIONS
# ==============================================================================
func eval_health_ratio() -> float:
	if bot_hero == null or bot_hero.attribute_system == null:
		return 1.0
	var max_hp = bot_hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	return clampf(bot_hero.attribute_system.current_health / maxf(1.0, max_hp), 0.0, 1.0)

func eval_mana_ratio() -> float:
	if bot_hero == null or bot_hero.attribute_system == null:
		return 1.0
	var max_mp = bot_hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
	return clampf(bot_hero.attribute_system.current_mana / maxf(1.0, max_mp), 0.0, 1.0)

func eval_enemy_distance() -> float:
	if opponent_hero == null or not is_instance_valid(opponent_hero) or not opponent_hero.is_alive():
		return 999.0
	var b_pos = bot_hero.global_position if bot_hero.is_inside_tree() else bot_hero.position
	var o_pos = opponent_hero.global_position if opponent_hero.is_inside_tree() else opponent_hero.position
	return b_pos.distance_to(o_pos)

func eval_enemy_health_ratio() -> float:
	if opponent_hero == null or not is_instance_valid(opponent_hero) or not opponent_hero.is_alive():
		return 1.0
	var max_hp = opponent_hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	return clampf(opponent_hero.attribute_system.current_health / maxf(1.0, max_hp), 0.0, 1.0)

func eval_allied_minion_count() -> int:
	var count = 0
	var b_pos = bot_hero.global_position if bot_hero.is_inside_tree() else bot_hero.position
	for n in CreepEntity.active_creeps:
		if is_instance_valid(n) and n.is_alive() and n.team == bot_hero.team:
			var n_pos = n.global_position if n.is_inside_tree() else n.position
			if b_pos.distance_to(n_pos) <= 12.0:
				count += 1
	return count

func eval_enemy_minion_count() -> int:
	var count = 0
	var b_pos = bot_hero.global_position if bot_hero.is_inside_tree() else bot_hero.position
	for n in CreepEntity.active_creeps:
		if is_instance_valid(n) and n.is_alive() and n.team != bot_hero.team:
			var n_pos = n.global_position if n.is_inside_tree() else n.position
			if b_pos.distance_to(n_pos) <= 12.0:
				count += 1
	return count

func eval_is_under_enemy_tower() -> bool:
	if enemy_tower == null or not is_instance_valid(enemy_tower) or not enemy_tower.is_alive():
		return false
	var dist = bot_hero.global_position.distance_to(enemy_tower.global_position)
	return dist <= enemy_tower.aggro_range

func eval_has_lasthit_opportunity() -> bool:
	var bot_ad = bot_hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if bot_hero.attribute_system != null else 45.0
	var nodes = get_tree().get_nodes_in_group("combat_entities") if get_tree() != null else []
	for n in nodes:
		if n is CreepEntity and is_instance_valid(n) and n.is_alive() and n.team != bot_hero.team:
			if bot_hero.global_position.distance_to(n.global_position) <= 8.0:
				if n.attribute_system.current_health <= (bot_ad * 1.3):
					return true
	return false

# ==============================================================================
# 3. STATE EXECUTION & MOVEMENT
# ==============================================================================
func _execute_current_state(delta: float) -> void:
	match current_state:
		BotState.RETREAT:
			_execute_retreat()
		BotState.DEFEND_TOWER:
			_execute_defend_tower()
		BotState.ATTACK:
			_execute_attack_combat(delta)
		BotState.HARASS:
			_execute_harass_combat(delta)
		BotState.FARM:
			_execute_farm_minions(delta)
		BotState.CONTEST_RUNE:
			_execute_contest_rune(delta)
		BotState.OBJECTIVE_BOSS:
			_execute_objective_boss(delta)
		BotState.GANK_ROAM:
			_execute_gank_roam(delta)
		BotState.LANE:
			_execute_lane_advancement()
		BotState.DEAD:
			bot_hero.velocity = Vector3.ZERO
			bot_hero.is_navigating = false

func _execute_retreat() -> void:
	# Use E Mana Barrier if available for shield and +20% move speed
	_try_use_defensive_items()
	_try_cast_e()
	
	# Bush / Forest Juking: If low HP, look for nearby bush within 14m to break sight
	if is_inside_tree() and get_tree() != null:
		var b_pos = bot_hero.global_position
		for b in get_tree().get_nodes_in_group("bushes"):
			if is_instance_valid(b) and b is Node3D:
				var d = b_pos.distance_to(b.global_position)
				if d <= 14.0 and d > 2.0:
					bot_hero.move_to_location(b.global_position)
					return

	# Retreat towards friendly fountain spawn
	var fountain_pos = Vector3(90.0, 1.5, -90.0)
	if friendly_tower != null and is_instance_valid(friendly_tower) and friendly_tower.is_alive():
		var dist = bot_hero.global_position.distance_to(friendly_tower.global_position)
		if dist > 4.0:
			bot_hero.move_to_location(friendly_tower.global_position + Vector3(2, 0, -2))
			return
			
	bot_hero.move_to_location(fountain_pos)

func _execute_defend_tower() -> void:
	if friendly_tower != null and is_instance_valid(friendly_tower) and friendly_tower.is_alive():
		var defend_spot = friendly_tower.global_position + Vector3(3, 0, -3)
		if bot_hero.global_position.distance_to(defend_spot) > 2.5:
			bot_hero.move_to_location(defend_spot)
		else:
			_target_and_attack_closest_creep()

func _execute_attack_combat(_delta: float) -> void:
	if opponent_hero == null or not is_instance_valid(opponent_hero) or not opponent_hero.is_alive():
		current_state = BotState.FARM
		return
		
	var dist = eval_enemy_distance()
	var enemy_hp = eval_enemy_health_ratio()
	
	# Hero-specific combos are rate-limited: abilities remain deliberate rather
	# than being requested every AI tick and work for every routed hero.
	if dist <= 8.5 and combo_cooldown_timer <= 0.0:
		execute_hero_combo(opponent_hero)
		combo_cooldown_timer = 0.7 if enemy_hp <= 0.45 else 1.15
		
	# Attack or maintain spacing
	if dist <= 5.5:
		bot_hero.is_navigating = false
		bot_hero.velocity = Vector3.ZERO
		_rotate_bot_towards(opponent_hero.global_position)
		if bot_hero.can_attack() and attack_cooldown_timer <= 0.0:
			bot_hero.execute_basic_attack(opponent_hero)
			attack_cooldown_timer = 0.9
	else:
		bot_hero.move_to_location(opponent_hero.global_position)

func _execute_harass_combat(_delta: float) -> void:
	if opponent_hero == null or not is_instance_valid(opponent_hero) or not opponent_hero.is_alive():
		current_state = BotState.FARM
		return
		
	var dist = eval_enemy_distance()
	
	# If Kaelgor rushes too close (<3.5m), root him with W and step back (Kiting)
	if dist < 3.8:
		_try_cast_w(opponent_hero)
		_try_cast_e()
		var step_back = bot_hero.global_position + (bot_hero.global_position - opponent_hero.global_position).normalized() * 4.0
		bot_hero.move_to_location(step_back)
		return
		
	# Poke only once per decision window, then keep a safe spacing band.
	if combo_cooldown_timer <= 0.0:
		_try_cast_q(opponent_hero)
		combo_cooldown_timer = 1.0
	
	# Basic Attack from 4.5m - 5.5m
	if dist <= 5.75:
		bot_hero.is_navigating = false
		bot_hero.velocity = Vector3.ZERO
		_rotate_bot_towards(opponent_hero.global_position)
		if bot_hero.can_attack() and attack_cooldown_timer <= 0.0:
			bot_hero.execute_basic_attack(opponent_hero)
			attack_cooldown_timer = 0.95
	else:
		bot_hero.move_to_location(opponent_hero.global_position)

func _execute_farm_minions(_delta: float) -> void:
	var target = _find_best_creep_target()
	if target == null:
		_execute_lane_advancement()
		return
		
	current_target = target
	var dist = bot_hero.global_position.distance_to(target.global_position)
	
	if dist <= 5.5:
		bot_hero.is_navigating = false
		bot_hero.velocity = Vector3.ZERO
		_rotate_bot_towards(target.global_position)
		if bot_hero.can_attack() and attack_cooldown_timer <= 0.0:
			bot_hero.execute_basic_attack(target)
			attack_cooldown_timer = 0.95
	else:
		bot_hero.move_to_location(target.global_position)

func _execute_lane_advancement() -> void:
	if current_waypoint_idx < lane_waypoints.size():
		var wp = lane_waypoints[current_waypoint_idx]
		var dist = bot_hero.global_position.distance_to(wp)
		if dist <= 3.0:
			current_waypoint_idx = mini(current_waypoint_idx + 1, lane_waypoints.size() - 1)
		bot_hero.move_to_location(wp)
	else:
		bot_hero.move_to_location(Vector3(-25.0, 0.0, 25.0))

# ==============================================================================
# 4. BOT ABILITY CASTING LOGIC (UNIVERSAL)
# ==============================================================================
func _try_cast_slot(slot: AbilityResource.Slot, target: BaseCombatEntity = null, point: Vector3 = Vector3.ZERO) -> bool:
	if bot_hero == null or bot_hero.ability_container == null:
		return false
	var cast_point = point
	if target != null and is_instance_valid(target):
		cast_point = target.global_position if target.is_inside_tree() else target.position
	# The router invokes bespoke hero mechanics (summons, marks, movement,
	# status effects) and falls back to data-driven abilities for older heroes.
	if HeroSkillRouter.try_cast(bot_hero, slot, target, cast_point):
		return true
	return bot_hero.ability_container.cast_ability(slot, target, cast_point)

func _try_cast_q(target: BaseCombatEntity) -> bool:
	return _try_cast_slot(AbilityResource.Slot.Q, target)

func _try_cast_q_pos(target_pos: Vector3) -> bool:
	return _try_cast_slot(AbilityResource.Slot.Q, null, target_pos)

func _try_cast_w(target: BaseCombatEntity) -> bool:
	return _try_cast_slot(AbilityResource.Slot.W, target)

func _try_cast_w_pos(target_pos: Vector3) -> bool:
	return _try_cast_slot(AbilityResource.Slot.W, null, target_pos)

func _try_cast_e() -> bool:
	return _try_cast_slot(AbilityResource.Slot.E, bot_hero, bot_hero.global_position)

func _try_cast_r(target: BaseCombatEntity) -> bool:
	return _try_cast_slot(AbilityResource.Slot.R, target)

# ==============================================================================
# 5. TARGET SELECTION & HELPERS
# ==============================================================================
func _find_priority_enemy_hero() -> HeroEntity:
	if bot_hero == null:
		return null
	var best: HeroEntity = null
	var best_score := -INF
	var origin = bot_hero.global_position if bot_hero.is_inside_tree() else bot_hero.position
	for hero in HeroEntity.active_heroes:
		if hero == bot_hero or not is_instance_valid(hero) or not hero.is_alive() or hero.team == bot_hero.team:
			continue
		var pos = hero.global_position if hero.is_inside_tree() else hero.position
		var distance = origin.distance_to(pos)
		var health = CombatMechanics.health_ratio(hero)
		# Low-health, nearby threats are worth finishing; far targets cannot pull
		# the bot out of its lane merely because they have little health.
		var score = (1.0 - health) * 55.0 - distance * 3.2
		if hero == current_target:
			score += 8.0 # prevents target thrashing between close heroes
		if score > best_score:
			best_score = score
			best = hero
	return best
func _find_best_creep_target() -> BaseCombatEntity:
	if bot_hero == null:
		return null
	var bot_ad = bot_hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if bot_hero.attribute_system != null else 45.0
	var b_pos = bot_hero.global_position if bot_hero.is_inside_tree() else bot_hero.position
	
	# 1. Look for Creep Deny (DotA Deny: friendly creep <= 50% HP and <= 1.15 * AD)
	for n in CreepEntity.active_creeps:
		if is_instance_valid(n) and n.is_alive() and n.team == bot_hero.team:
			var n_pos = n.global_position if n.is_inside_tree() else n.position
			var d = b_pos.distance_to(n_pos)
			if d <= 8.0 and TargetRelationSystem.is_eligible_for_deny(bot_hero, n):
				if n.attribute_system != null and n.attribute_system.current_health <= (bot_ad * 1.15):
					return n
					
	var best_target: BaseCombatEntity = null
	var lowest_hp: float = 9999.0
	
	# 2. Look for Last-Hit Creep (HP <= 1.3 * AD)
	for n in CreepEntity.active_creeps:
		if is_instance_valid(n) and n.is_alive() and n.team != bot_hero.team:
			var n_pos = n.global_position if n.is_inside_tree() else n.position
			var d = b_pos.distance_to(n_pos)
			if d <= 8.0 and n.attribute_system.current_health <= (bot_ad * 1.3):
				return n
				
	# 2. Look for Lowest HP Creep within 8m
	for n in CreepEntity.active_creeps:
		if is_instance_valid(n) and n.is_alive() and n.team != bot_hero.team:
			var n_pos = n.global_position if n.is_inside_tree() else n.position
			var d = b_pos.distance_to(n_pos)
			if d <= 8.0 and n.attribute_system.current_health < lowest_hp:
				lowest_hp = n.attribute_system.current_health
				best_target = n
				
	return best_target

func _target_and_attack_closest_creep() -> void:
	var target = _find_best_creep_target()
	if target != null:
		_rotate_bot_towards(target.global_position)
		if bot_hero.can_attack() and attack_cooldown_timer <= 0.0:
			bot_hero.execute_basic_attack(target)
			attack_cooldown_timer = 0.95

func _rotate_bot_towards(target_pos: Vector3) -> void:
	var dir = target_pos - bot_hero.global_position
	dir.y = 0.0
	if dir.length_squared() > 0.01:
		bot_hero.rotation.y = atan2(dir.x, dir.z)


# ==============================================================================
# 6. ADVANCED BOT HERO COMBOS & ACTIVE ITEM USAGE
# ==============================================================================
func execute_hero_combo(target: BaseCombatEntity) -> bool:
	if bot_hero == null or target == null or not is_instance_valid(target) or not target.is_alive():
		return false
		
	var h_id = ""
	if bot_hero.hero_resource != null:
		h_id = bot_hero.hero_resource.id.to_lower()
	elif "entity_name" in bot_hero:
		h_id = bot_hero.entity_name.to_lower()
		
	var t_pos = target.global_position if target.is_inside_tree() else target.position
	var b_pos = bot_hero.global_position if bot_hero.is_inside_tree() else bot_hero.position
	var dist = b_pos.distance_to(t_pos)
	
	# 1. First trigger offensive active items
	_try_use_offensive_items(target)
	
	# 2. Hero-specific combo chains
	match h_id:
		"grom", "malgath", "sylph", "morven":
			# Hook / Pull Initiator: Q (Hook) -> W (Point blank AoE / Slow) -> R (Barrage)
			_try_cast_q(target)
			_try_cast_w(target)
			if target.attribute_system != null and target.attribute_system.current_health <= 400.0:
				_try_cast_r(target)
			return true
		"valgor":
			# Stance Shifter: Switch to Melee stance if close, else poke in Ranged
			if dist <= 4.0:
				_try_cast_e() # Stance switch
				_try_cast_q(target) # Whirlwind / Rupture
				_try_cast_w(target)
			else:
				_try_cast_q(target)
				_try_cast_w(target)
			return true
		"valerius", "ignatius", "vorath", "kaelgor":
			# Melee Brawler / Arena Lock: Q (Charge) -> W (Slam / Lock) -> E (Buff/Shield) -> R (Execution)
			_try_cast_q(target)
			_try_cast_w(target)
			_try_cast_e()
			if eval_enemy_health_ratio() <= 0.40:
				_try_cast_r(target)
			return true
		"rivena":
			# Rivena Shadow Assassin:
			# 1. Cast R (Nightfall) if target is low or in combat
			if eval_enemy_health_ratio() <= 0.60 or dist <= 5.0:
				_try_cast_r(target)
			# 2. Q (Shadow Cut) for main damage and shade spawn
			_try_cast_q(target)
			# 3. W (Echo Step) to swap with shade and flank
			if dist > 3.0:
				_try_cast_w_pos(t_pos)
			# 4. E (Shade Command) to detonate all active shades on target
			_try_cast_e()
			return true
		"noctis", "velum", "nyx", "darek":
			# Assassin / Infiltrator: W (Stealth / Blind) -> Q (Shadow Strike) -> R (Execute)
			_try_cast_w(target)
			_try_cast_q(target)
			if eval_enemy_health_ratio() <= 0.45:
				_try_cast_r(target)
			return true
		"aethon":
			# Aethon Construct Architect:
			# 1. Spawn Guardian in front towards enemy
			var g_pos = b_pos.lerp(t_pos, 0.55)
			_try_cast_q_pos(g_pos)
			# 2. Spawn Cannon at backline
			var c_dir = (b_pos - t_pos).normalized()
			if c_dir.length_squared() < 0.01:
				c_dir = Vector3(0, 0, 1)
			var c_pos = b_pos + (c_dir * 2.5)
			_try_cast_w_pos(c_pos)
			# 3. Trigger E (Reconfigure) for overcharge
			_try_cast_e()
			# 4. If enemy within 6.5m, assemble massive Siege Construct
			if dist <= 6.5:
				_try_cast_r(target)
			return true
		"malakor", "nerath":
			# Summoner / Commander: R (Vanguard / Constructs) -> Q (Charge) -> E (Fortify)
			_try_cast_r(target)
			_try_cast_q(target)
			_try_cast_e()
			return true
		"astris", "aurik", "solas", "zephyr", "chronos":
			# Zone Mage: W (Zone / CC) -> Q (Bolt / Stun) -> E (Shield) -> R (Ult)
			_try_cast_w(target)
			_try_cast_q(target)
			_try_cast_e()
			if eval_enemy_health_ratio() <= 0.35:
				_try_cast_r(target)
			return true
		_:
			# Generic fallback combo
			_try_cast_q(target)
			_try_cast_w(target)
			_try_cast_e()
			if eval_enemy_health_ratio() <= 0.30:
				_try_cast_r(target)
			return true
			
	return false

func _try_use_defensive_items() -> bool:
	if bot_hero == null or bot_hero.inventory_manager == null:
		return false
		
	var hp_ratio = eval_health_ratio()
	if hp_ratio > 0.40:
		return false
		
	for i in range(bot_hero.inventory_manager.slots.size()):
		var item = bot_hero.inventory_manager.slots[i]
		if item != null and not item.active_action_tag.is_empty():
			match item.active_action_tag:
				"ACTIVE_BARRIER", "ACTIVE_HEAL", "ACTIVE_CLEANSE", "ACTIVE_SPELL_IMMUNITY", "ACTIVE_BLADE_MAIL", "ACTIVE_LOTUS_ORB", "ACTIVE_MANTA", "ACTIVE_TIME_REWIND":
					if bot_hero.inventory_manager.use_active_item(i, bot_hero):
						return true
	return false

func _try_use_offensive_items(target: BaseCombatEntity) -> bool:
	if bot_hero == null or bot_hero.inventory_manager == null or target == null:
		return false
		
	for i in range(bot_hero.inventory_manager.slots.size()):
		var item = bot_hero.inventory_manager.slots[i]
		if item != null and not item.active_action_tag.is_empty():
			match item.active_action_tag:
				"ACTIVE_HEX", "ACTIVE_SILENCE", "ACTIVE_SPELL_IMMUNITY", "ACTIVE_ATTACK_SPEED_BUFF", "ACTIVE_DAGON", "ACTIVE_FROST_NOVA", "ACTIVE_ARMLET", "ACTIVE_REFRESHER":
					if bot_hero.inventory_manager.use_active_item(i, target):
						return true
	return false

func _try_use_mobility_items(target_pos: Vector3) -> bool:
	if bot_hero == null or bot_hero.inventory_manager == null:
		return false
		
	for i in range(bot_hero.inventory_manager.slots.size()):
		var item = bot_hero.inventory_manager.slots[i]
		if item != null and not item.active_action_tag.is_empty():
			match item.active_action_tag:
				"ACTIVE_BLINK", "ACTIVE_FORCE_STAFF":
					if bot_hero.inventory_manager.use_active_item(i, null, target_pos):
						return true
	return false

func eval_nearby_rune() -> Node3D:
	if not is_inside_tree() or get_tree() == null or bot_hero == null:
		return null
	var b_pos = bot_hero.global_position if bot_hero.is_inside_tree() else bot_hero.position
	var runes = get_tree().get_nodes_in_group("runes")
	for r in runes:
		if is_instance_valid(r) and r is Node3D:
			if "is_spawned" in r and not r.is_spawned:
				continue
			var r_pos = r.global_position if r.is_inside_tree() else r.position
			if b_pos.distance_to(r_pos) <= 28.0:
				return r
	return null

func eval_nearby_boss_objective() -> BaseCombatEntity:
	if not is_inside_tree() or get_tree() == null or bot_hero == null:
		return null
	var b_pos = bot_hero.global_position if bot_hero.is_inside_tree() else bot_hero.position
	for node in get_tree().get_nodes_in_group("combat_entities"):
		if node is BaseCombatEntity and is_instance_valid(node) and node.is_alive() and node.team != bot_hero.team:
			if ("is_epic_boss" in node and node.is_epic_boss) or node is ObjectiveEntity:
				var n_pos = node.global_position if node.is_inside_tree() else node.position
				if b_pos.distance_to(n_pos) <= 24.0:
					return node
	return null

func _execute_contest_rune(_delta: float) -> void:
	if current_rune_target == null or not is_instance_valid(current_rune_target):
		current_state = BotState.LANE
		return
	var r_pos = current_rune_target.global_position if current_rune_target.is_inside_tree() else current_rune_target.position
	var dist = bot_hero.global_position.distance_to(r_pos)
	if dist <= 2.2:
		if current_rune_target.has_method("pickup"):
			current_rune_target.pickup(bot_hero)
		current_rune_target = null
		current_state = BotState.LANE
	else:
		bot_hero.move_to_location(r_pos)

func _execute_objective_boss(_delta: float) -> void:
	if current_objective_target == null or not is_instance_valid(current_objective_target) or not current_objective_target.is_alive():
		current_state = BotState.LANE
		return
	var o_pos = current_objective_target.global_position if current_objective_target.is_inside_tree() else current_objective_target.position
	var dist = bot_hero.global_position.distance_to(o_pos)
	if dist <= 5.5:
		bot_hero.is_navigating = false
		bot_hero.velocity = Vector3.ZERO
		_rotate_bot_towards(o_pos)
		if bot_hero.can_attack() and attack_cooldown_timer <= 0.0:
			bot_hero.execute_basic_attack(current_objective_target)
			attack_cooldown_timer = 0.95
	else:
		bot_hero.move_to_location(o_pos)

func _find_gank_opportunity() -> HeroEntity:
	if bot_hero == null or not is_inside_tree():
		return null
	for ally in HeroEntity.active_heroes:
		if is_instance_valid(ally) and ally != bot_hero and ally.team == bot_hero.team and ally.is_alive():
			for enemy in HeroEntity.active_heroes:
				if is_instance_valid(enemy) and enemy.team != bot_hero.team and enemy.is_alive():
					if ally.global_position.distance_to(enemy.global_position) <= 12.0:
						if bot_hero.global_position.distance_to(ally.global_position) <= 50.0:
							return ally
	return null

func _execute_gank_roam(_delta: float) -> void:
	if current_gank_target == null or not is_instance_valid(current_gank_target) or not current_gank_target.is_alive():
		current_state = BotState.LANE
		return
	var dest = current_gank_target.global_position
	var dist = bot_hero.global_position.distance_to(dest)
	if dist <= 8.0:
		current_state = BotState.ATTACK
	else:
		bot_hero.move_to_location(dest)

func _evaluate_and_purchase_items() -> void:
	if bot_hero == null or bot_hero.inventory_manager == null:
		return
	var current_gold = bot_hero.inventory_manager.gold
	if current_gold < 400:
		return
		
	if bot_hero.inventory_manager.get_empty_slot_count() <= 0:
		return
		
	var enemy_magic_count := 0
	var enemy_phys_count := 0
	for h in HeroEntity.active_heroes:
		if is_instance_valid(h) and h.is_alive() and h.team != bot_hero.team and h.attribute_system != null:
			if h.attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) > 25.0:
				enemy_magic_count += 1
			else:
				enemy_phys_count += 1
				
	var target_item_id: int = 1
	if enemy_magic_count > enemy_phys_count:
		target_item_id = 11 if current_gold >= 1000 else 13
	elif enemy_phys_count > 0:
		target_item_id = 9 if current_gold >= 1000 else 8
	else:
		target_item_id = 2 if current_gold >= 900 else 1
		
	var item_res = Database.get_item(target_item_id) if is_instance_valid(Database) else null
	if item_res != null and current_gold >= item_res.cost:
		var lookup_fn = func(id): return Database.get_item(id) if is_instance_valid(Database) else null
		if bot_hero.inventory_manager.buy_item(item_res, lookup_fn):
			CourierManagerClass.deliver_for_hero(bot_hero)
