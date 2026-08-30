class_name FastForwardMatchSimulator
extends RefCounted

## Deterministic Fast-Forward Match Simulation Engine for Eclipse Front
## Simulates 5v5 / 1v1 matches across multiple horizons (10m, 20m, 30m, 45m, 60m)

const HeroBuildMatrixClass = preload("res://data/hero_build_matrix.gd")
const ItemEventEngineClass = preload("res://systems/items/item_event_engine.gd")

## Simulates a match over target duration and returns full timeline telemetry
static func simulate_match(radiant_hero_ids: Array[String], dire_hero_ids: Array[String], target_duration_seconds: float = 1800.0, step_delta: float = 1.0) -> Dictionary:
	var timeline_checkpoints: Dictionary = {
		"10m": {},
		"20m": {},
		"30m": {},
		"45m": {},
		"60m": {}
	}
	
	var radiant_team: Array[Dictionary] = []
	var dire_team: Array[Dictionary] = []
	
	# Instantiate radiant agents
	for hid in radiant_hero_ids:
		radiant_team.append(_create_simulated_hero(hid, 0))
		
	# Instantiate dire agents
	for hid in dire_hero_ids:
		dire_team.append(_create_simulated_hero(hid, 1))
		
	var current_time: float = 0.0
	var radiant_score: int = 0
	var dire_score: int = 0
	var radiant_gold_total: int = 0
	var dire_gold_total: int = 0
	
	while current_time < target_duration_seconds:
		current_time += step_delta
		
		# 1. Passive Gold & XP Gain (2 gold/sec, 5 XP/sec baseline + farm)
		for h in radiant_team:
			_tick_hero_economy(h, step_delta)
		for h in dire_team:
			_tick_hero_economy(h, step_delta)
			
		# 2. Combat Resolution Encounter
		if int(current_time) % 15 == 0: # Encounter every 15s
			var rad_h = radiant_team[randi() % radiant_team.size()]
			var dir_h = dire_team[randi() % dire_team.size()]
			_resolve_skirmish(rad_h, dir_h)
			
		# 3. Objective Encounter (River Runes every 120s, Boss every 300s)
		if int(current_time) % 120 == 0:
			var rune_taker = radiant_team[0] if randf() > 0.5 else dire_team[0]
			rune_taker["runes_collected"] += 1
			rune_taker["gold"] += 100
			
		if int(current_time) % 300 == 0:
			var boss_taker = radiant_team[0] if randf() > 0.5 else dire_team[0]
			boss_taker["boss_kills"] += 1
			boss_taker["gold"] += 450
			
		# 4. Checkpoint Recording
		if absf(current_time - 600.0) < step_delta:
			timeline_checkpoints["10m"] = _capture_checkpoint_state(radiant_team, dire_team, current_time)
		elif absf(current_time - 1200.0) < step_delta:
			timeline_checkpoints["20m"] = _capture_checkpoint_state(radiant_team, dire_team, current_time)
		elif absf(current_time - 1800.0) < step_delta:
			timeline_checkpoints["30m"] = _capture_checkpoint_state(radiant_team, dire_team, current_time)
		elif absf(current_time - 2700.0) < step_delta:
			timeline_checkpoints["45m"] = _capture_checkpoint_state(radiant_team, dire_team, current_time)
		elif absf(current_time - 3600.0) < step_delta:
			timeline_checkpoints["60m"] = _capture_checkpoint_state(radiant_team, dire_team, current_time)
			
	# Summarize match
	for h in radiant_team:
		radiant_gold_total += h["gold_earned"]
		radiant_score += h["kills"]
	for h in dire_team:
		dire_gold_total += h["gold_earned"]
		dire_score += h["kills"]
		
	var winning_team = 0 if radiant_gold_total >= dire_gold_total else 1
	var all_heroes_data: Array = []
	all_heroes_data.append_array(radiant_team)
	all_heroes_data.append_array(dire_team)
	
	var match_summary = {
		"duration": current_time,
		"winning_team": winning_team,
		"radiant_score": radiant_score,
		"dire_score": dire_score,
		"radiant_gold": radiant_gold_total,
		"dire_gold": dire_gold_total,
		"snowball_lead": abs(radiant_gold_total - dire_gold_total),
		"timeline": timeline_checkpoints,
		"heroes": all_heroes_data
	}
	
	# Automatically record to Telemetry
	MatchTelemetrySystem.record_match_result(match_summary)
	return match_summary

static func _create_simulated_hero(hero_id: String, team: int) -> Dictionary:
	var build_idx = randi() % 3
	var build_path = HeroBuildMatrixClass.get_build(hero_id, build_idx)
	return {
		"hero_id": hero_id,
		"team": team,
		"level": 1,
		"xp": 0,
		"gold": 600,
		"gold_earned": 600,
		"kills": 0,
		"deaths": 0,
		"assists": 0,
		"damage_dealt": 0.0,
		"runes_collected": 0,
		"boss_kills": 0,
		"build_index": build_idx,
		"build_path": build_path,
		"purchased_items": [],
		"next_item_idx": 0
	}

static func _tick_hero_economy(hero: Dictionary, delta: float) -> void:
	# Gold generation: 2.0/s + minion farming (approx 4.5 gold/s total)
	var g_gain = int(4.5 * delta)
	hero["gold"] += g_gain
	hero["gold_earned"] += g_gain
	
	# XP generation: approx 8 XP/s
	hero["xp"] += int(8.0 * delta)
	var required_xp = hero["level"] * 250
	if hero["xp"] >= required_xp and hero["level"] < 25:
		hero["level"] += 1
		
	# Try purchasing next item from build matrix
	var b_items: Array = hero["build_path"].get("core_items", [])
	if hero["next_item_idx"] < b_items.size():
		var target_item_name = b_items[hero["next_item_idx"]]
		var item_cost = 2200 # Estimated avg item cost
		if hero["gold"] >= item_cost:
			hero["gold"] -= item_cost
			hero["purchased_items"].append(target_item_name)
			hero["next_item_idx"] += 1

static func _resolve_skirmish(rad_hero: Dictionary, dir_hero: Dictionary) -> void:
	var rad_power = rad_hero["level"] * 100 + (rad_hero["purchased_items"].size() * 300) + randf_range(-150, 150)
	var dir_power = dir_hero["level"] * 100 + (dir_hero["purchased_items"].size() * 300) + randf_range(-150, 150)
	
	var dmg = 250.0 + (rad_power * 0.4)
	rad_hero["damage_dealt"] += dmg
	dir_hero["damage_dealt"] += dmg
	
	if rad_power > dir_power:
		rad_hero["kills"] += 1
		rad_hero["gold"] += 300
		rad_hero["gold_earned"] += 300
		dir_hero["deaths"] += 1
	else:
		dir_hero["kills"] += 1
		dir_hero["gold"] += 300
		dir_hero["gold_earned"] += 300
		rad_hero["deaths"] += 1

static func _capture_checkpoint_state(rad_team: Array[Dictionary], dir_team: Array[Dictionary], timestamp: float) -> Dictionary:
	var rad_g = 0
	var dir_g = 0
	var rad_items = 0
	var dir_items = 0
	for h in rad_team:
		rad_g += h["gold_earned"]
		rad_items += h["purchased_items"].size()
	for h in dir_team:
		dir_g += h["gold_earned"]
		dir_items += h["purchased_items"].size()
		
	return {
		"timestamp_minutes": timestamp / 60.0,
		"radiant_gold": rad_g,
		"dire_gold": dir_g,
		"radiant_avg_items": float(rad_items) / maxf(1.0, float(rad_team.size())),
		"dire_avg_items": float(dir_items) / maxf(1.0, float(dir_team.size())),
		"gold_differential": rad_g - dir_g
	}
