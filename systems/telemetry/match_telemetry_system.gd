class_name MatchTelemetrySystem
extends RefCounted

## Automated Balance & Performance Telemetry System for Eclipse Front
## Aggregates Win Rates, KDA, GPM, DPM, Item Pick/Win Rates, and Objective Metrics.

static var hero_stats: Dictionary = {}
static var item_stats: Dictionary = {}
static var build_stats: Dictionary = {}
static var matches_recorded: int = 0
static var total_match_duration: float = 0.0

static func reset_telemetry() -> void:
	hero_stats.clear()
	item_stats.clear()
	build_stats.clear()
	matches_recorded = 0
	total_match_duration = 0.0

static func record_match_result(match_summary: Dictionary) -> void:
	matches_recorded += 1
	var duration = match_summary.get("duration", 1800.0)
	total_match_duration += duration
	var winning_team = match_summary.get("winning_team", 0) # 0: Radiant, 1: Dire
	
	var heroes_data: Array = match_summary.get("heroes", [])
	for h in heroes_data:
		var hero_id = h.get("hero_id", "unknown").to_lower()
		var team = h.get("team", 0)
		var is_winner = (team == winning_team)
		var kills = h.get("kills", 0)
		var deaths = h.get("deaths", 0)
		var assists = h.get("assists", 0)
		var total_damage = h.get("damage_dealt", 0.0)
		var total_gold = h.get("gold_earned", 0)
		var items: Array = h.get("items", [])
		var build_idx = h.get("build_index", 0)
		
		# 1. Update Hero Stats
		if not hero_stats.has(hero_id):
			hero_stats[hero_id] = {
				"matches": 0,
				"wins": 0,
				"kills": 0,
				"deaths": 0,
				"assists": 0,
				"total_damage": 0.0,
				"total_gold": 0,
				"total_playtime": 0.0
			}
		var hs = hero_stats[hero_id]
		hs["matches"] += 1
		if is_winner:
			hs["wins"] += 1
		hs["kills"] += kills
		hs["deaths"] += deaths
		hs["assists"] += assists
		hs["total_damage"] += total_damage
		hs["total_gold"] += total_gold
		hs["total_playtime"] += duration
		
		# 2. Update Build Stats
		var build_key = "%s_build_%d" % [hero_id, build_idx]
		if not build_stats.has(build_key):
			build_stats[build_key] = { "picks": 0, "wins": 0 }
		build_stats[build_key]["picks"] += 1
		if is_winner:
			build_stats[build_key]["wins"] += 1
			
		# 3. Update Item Stats
		for it in items:
			var item_id = it.id if it is ItemResource else int(it)
			if not item_stats.has(item_id):
				item_stats[item_id] = { "picks": 0, "wins": 0 }
			item_stats[item_id]["picks"] += 1
			if is_winner:
				item_stats[item_id]["wins"] += 1

static func get_hero_telemetry(hero_id: String) -> Dictionary:
	hero_id = hero_id.to_lower()
	if not hero_stats.has(hero_id):
		return { "win_rate": 0.0, "kda": 0.0, "dpm": 0.0, "gpm": 0.0, "matches": 0 }
		
	var s = hero_stats[hero_id]
	var m = float(s["matches"])
	var mins = maxf(1.0, s["total_playtime"] / 60.0)
	var deaths = maxf(1.0, float(s["deaths"]))
	
	return {
		"matches": s["matches"],
		"wins": s["wins"],
		"win_rate": float(s["wins"]) / m,
		"kda": (float(s["kills"]) + float(s["assists"])) / deaths,
		"dpm": s["total_damage"] / mins,
		"gpm": float(s["total_gold"]) / mins
	}

static func get_item_telemetry(item_id: int) -> Dictionary:
	if not item_stats.has(item_id):
		return { "picks": 0, "wins": 0, "win_rate": 0.0 }
	var s = item_stats[item_id]
	var p = float(s["picks"])
	return {
		"picks": s["picks"],
		"wins": s["wins"],
		"win_rate": (float(s["wins"]) / p) if p > 0 else 0.0
	}

static func get_balance_report() -> Dictionary:
	var avg_len = (total_match_duration / float(matches_recorded)) if matches_recorded > 0 else 0.0
	return {
		"total_matches": matches_recorded,
		"average_game_length_seconds": avg_len,
		"tracked_heroes": hero_stats.size(),
		"tracked_items": item_stats.size(),
		"tracked_builds": build_stats.size()
	}
