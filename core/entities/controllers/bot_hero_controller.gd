class_name BotHeroController
extends Node

## Modular Evaluator-Based AI Controller for Astris (Dire Bot)

enum BotState {
	LANE,
	FARM,
	HARASS,
	ATTACK,
	RETREAT,
	DEFEND_TOWER,
	DEAD,
	RESPAWN
}

@export var bot_hero: HeroEntity = null
@export var opponent_hero: HeroEntity = null
@export var friendly_tower: TowerEntity = null
@export var enemy_tower: TowerEntity = null

var current_state: BotState = BotState.LANE
var current_target: BaseCombatEntity = null

# Waypoints along Mid Lane for Dire Bot
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

func _ready() -> void:
	if bot_hero == null and get_parent() is HeroEntity:
		bot_hero = get_parent() as HeroEntity

func _physics_process(delta: float) -> void:
	if bot_hero == null or not is_instance_valid(bot_hero):
		return
		
	if not bot_hero.is_alive():
		current_state = BotState.DEAD
		return
		
	if attack_cooldown_timer > 0.0:
		attack_cooldown_timer -= delta
		
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
	var lane_score: float = 20.0 # Baseline score
	
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
	if lane_score > max_score:
		chosen_state = BotState.LANE
		
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
		BotState.LANE:
			_execute_lane_advancement()
		BotState.DEAD:
			bot_hero.velocity = Vector3.ZERO
			bot_hero.is_navigating = false

func _execute_retreat() -> void:
	# Use E Mana Barrier if available for shield and +20% move speed
	_try_cast_e()
	
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
	
	# Execute combo: W (Root) -> E (Shield) -> R (Execute) -> Q (Bolt) -> Basic Attack
	if dist <= 5.5:
		_try_cast_w(opponent_hero)
		_try_cast_e()
		if enemy_hp <= 0.35:
			_try_cast_r(opponent_hero)
		_try_cast_q(opponent_hero)
		
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
		
	# Poke with Q
	_try_cast_q(opponent_hero)
	
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
func _try_cast_q(target: BaseCombatEntity) -> bool:
	if bot_hero != null and bot_hero.ability_container != null:
		if bot_hero.ability_container.can_cast(AbilityResource.Slot.Q):
			var t_pos = target.global_position if (target != null and is_instance_valid(target)) else Vector3.ZERO
			return bot_hero.ability_container.cast_ability(AbilityResource.Slot.Q, target, t_pos)
	return false

func _try_cast_q_pos(target_pos: Vector3) -> bool:
	if bot_hero != null and bot_hero.ability_container != null:
		if bot_hero.ability_container.can_cast(AbilityResource.Slot.Q):
			return bot_hero.ability_container.cast_ability(AbilityResource.Slot.Q, null, target_pos)
	return false

func _try_cast_w(target: BaseCombatEntity) -> bool:
	if bot_hero != null and bot_hero.ability_container != null:
		if bot_hero.ability_container.can_cast(AbilityResource.Slot.W):
			var t_pos = target.global_position if (target != null and is_instance_valid(target)) else Vector3.ZERO
			return bot_hero.ability_container.cast_ability(AbilityResource.Slot.W, target, t_pos)
	return false

func _try_cast_w_pos(target_pos: Vector3) -> bool:
	if bot_hero != null and bot_hero.ability_container != null:
		if bot_hero.ability_container.can_cast(AbilityResource.Slot.W):
			return bot_hero.ability_container.cast_ability(AbilityResource.Slot.W, null, target_pos)
	return false

func _try_cast_e() -> bool:
	if bot_hero != null and bot_hero.ability_container != null:
		if bot_hero.ability_container.can_cast(AbilityResource.Slot.E):
			return bot_hero.ability_container.cast_ability(AbilityResource.Slot.E, bot_hero, bot_hero.global_position)
	return false

func _try_cast_r(target: BaseCombatEntity) -> bool:
	if bot_hero != null and bot_hero.ability_container != null:
		if bot_hero.ability_container.can_cast(AbilityResource.Slot.R):
			var t_pos = target.global_position if (target != null and is_instance_valid(target)) else Vector3.ZERO
			return bot_hero.ability_container.cast_ability(AbilityResource.Slot.R, target, t_pos)
	return false

# ==============================================================================
# 5. TARGET SELECTION & HELPERS
# ==============================================================================
func _find_best_creep_target() -> BaseCombatEntity:
	var bot_ad = bot_hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if bot_hero.attribute_system != null else 45.0
	var b_pos = bot_hero.global_position if bot_hero.is_inside_tree() else bot_hero.position
	
	var best_target: BaseCombatEntity = null
	var lowest_hp: float = 9999.0
	
	# 1. Look for Last-Hit Creep (HP <= 1.3 * AD)
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
				"ACTIVE_BARRIER", "ACTIVE_HEAL", "ACTIVE_CLEANSE", "ACTIVE_SPELL_IMMUNITY":
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
				"ACTIVE_HEX", "ACTIVE_SILENCE", "ACTIVE_SPELL_IMMUNITY", "ACTIVE_ATTACK_SPEED_BUFF":
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
