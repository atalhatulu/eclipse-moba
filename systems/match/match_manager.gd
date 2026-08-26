class_name MatchManager
extends Node

## Central Deterministic Match State Machine & Flow Controller for Eclipse Front

enum MatchState {
	PRE_GAME,
	PLAYING,
	HERO_DEAD,
	VICTORY,
	DEFEAT,
	MATCH_COMPLETE
}

signal match_state_changed(old_state: MatchState, new_state: MatchState)
signal match_ended(is_victory: bool, stats: Dictionary)
signal hero_respawn_started(hero: HeroEntity, duration: float)
signal hero_respawned(hero: HeroEntity)
signal score_updated(radiant_kills: int, dire_kills: int, radiant_towers_destroyed: int, dire_towers_destroyed: int)

var current_state: MatchState = MatchState.PRE_GAME
var match_time: float = 0.0
var is_match_concluded: bool = false

# Score & Statistics
var radiant_kills: int = 0
var dire_kills: int = 0
var radiant_towers_destroyed: int = 0
var dire_towers_destroyed: int = 0

# Entities References
var radiant_hero: HeroEntity = null
var dire_hero: HeroEntity = null
var radiant_ancient: ObjectiveEntity = null
var dire_ancient: ObjectiveEntity = null

# Respawn Tracking
var radiant_respawn_timer: float = 0.0
var dire_respawn_timer: float = 0.0
var is_radiant_respawning: bool = false
var is_dire_respawning: bool = false

func _ready() -> void:
	GameEvents.entity_killed.connect(_on_entity_killed)
	GameEvents.combat_log_generated.connect(_on_combat_log)

func start_match(p_radiant_hero: HeroEntity, p_dire_hero: HeroEntity, p_rad_ancient: ObjectiveEntity, p_dire_ancient: ObjectiveEntity) -> void:
	radiant_hero = p_radiant_hero
	dire_hero = p_dire_hero
	radiant_ancient = p_rad_ancient
	dire_ancient = p_dire_ancient
	
	radiant_kills = 0
	dire_kills = 0
	radiant_towers_destroyed = 0
	dire_towers_destroyed = 0
	match_time = 0.0
	if radiant_ancient != null and radiant_ancient.attribute_system != null:
		if not radiant_ancient.attribute_system.health_depleted.is_connected(_on_radiant_ancient_depleted):
			radiant_ancient.attribute_system.health_depleted.connect(_on_radiant_ancient_depleted)
	if dire_ancient != null and dire_ancient.attribute_system != null:
		if not dire_ancient.attribute_system.health_depleted.is_connected(_on_dire_ancient_depleted):
			dire_ancient.attribute_system.health_depleted.connect(_on_dire_ancient_depleted)
		
	set_state(MatchState.PLAYING)

func _on_radiant_ancient_depleted() -> void:
	_on_ancient_destroyed(TeamDefinitions.Team.RADIANT)

func _on_dire_ancient_depleted() -> void:
	_on_ancient_destroyed(TeamDefinitions.Team.DIRE)

func set_state(new_state: MatchState) -> void:
	if current_state == new_state:
		return
	var old_state = current_state
	current_state = new_state
	match_state_changed.emit(old_state, new_state)

func _process(delta: float) -> void:
	if current_state == MatchState.PLAYING or current_state == MatchState.HERO_DEAD:
		match_time += delta
		GameEvents.match_time_updated.emit(match_time)
		_process_respawns(delta)

func _process_respawns(delta: float) -> void:
	# Radiant Hero Respawn
	if is_radiant_respawning:
		radiant_respawn_timer -= delta
		if radiant_respawn_timer <= 0.0:
			_respawn_hero(radiant_hero, TeamDefinitions.Team.RADIANT)
			is_radiant_respawning = false
			if not is_dire_respawning and current_state == MatchState.HERO_DEAD:
				set_state(MatchState.PLAYING)
				
	# Dire Hero Respawn
	if is_dire_respawning:
		dire_respawn_timer -= delta
		if dire_respawn_timer <= 0.0:
			_respawn_hero(dire_hero, TeamDefinitions.Team.DIRE)
			is_dire_respawning = false
			if not is_radiant_respawning and current_state == MatchState.HERO_DEAD:
				set_state(MatchState.PLAYING)

func trigger_hero_death(hero: HeroEntity) -> void:
	if hero == null or not is_instance_valid(hero):
		return
		
	var lvl = hero.attribute_system.level if hero.attribute_system != null else 1
	var duration = 4.0 + (float(lvl) * 2.0)
	
	if hero.team == TeamDefinitions.Team.RADIANT:
		is_radiant_respawning = true
		radiant_respawn_timer = duration
		dire_kills += 1
	else:
		is_dire_respawning = true
		dire_respawn_timer = duration
		radiant_kills += 1
		
	score_updated.emit(radiant_kills, dire_kills, radiant_towers_destroyed, dire_towers_destroyed)
	hero_respawn_started.emit(hero, duration)
	
	if current_state == MatchState.PLAYING:
		set_state(MatchState.HERO_DEAD)

func _respawn_hero(hero: HeroEntity, team: TeamDefinitions.Team) -> void:
	if hero == null or not is_instance_valid(hero):
		return
		
	var spawn_pos = Vector3(-90.0, 1.5, 90.0) if team == TeamDefinitions.Team.RADIANT else Vector3(90.0, 1.5, -90.0)
	hero.global_position = spawn_pos
	hero.velocity = Vector3.ZERO
	hero.is_navigating = false
	hero.is_targetable = true
	
	if hero.attribute_system != null:
		hero.attribute_system.is_alive = true
		hero.attribute_system.heal(hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
		hero.attribute_system.restore_mana(hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA))
		
	if hero.effect_container != null:
		hero.effect_container.clear_all_effects()
		
	hero.visible = true
	hero_respawned.emit(hero)

func _on_ancient_destroyed(destroyed_team: TeamDefinitions.Team) -> void:
	if is_match_concluded:
		return
	is_match_concluded = true
	
	var is_victory = (destroyed_team == TeamDefinitions.Team.DIRE)
	set_state(MatchState.VICTORY if is_victory else MatchState.DEFEAT)
	
	var stats = get_match_statistics(is_victory)
	match_ended.emit(is_victory, stats)

func _on_entity_killed(victim: Node, _killer: Node) -> void:
	if is_match_concluded:
		return
	if victim is TowerEntity:
		var tower = victim as TowerEntity
		if tower.team == TeamDefinitions.Team.RADIANT:
			dire_towers_destroyed += 1
		else:
			radiant_towers_destroyed += 1
		score_updated.emit(radiant_kills, dire_kills, radiant_towers_destroyed, dire_towers_destroyed)

func _on_combat_log(_msg: String) -> void:
	pass

func get_match_statistics(is_victory: bool) -> Dictionary:
	var hero_lvl = radiant_hero.attribute_system.level if radiant_hero != null and radiant_hero.attribute_system != null else 1
	var hero_gold = radiant_hero.inventory_manager.gold if radiant_hero != null and radiant_hero.inventory_manager != null else 0
	
	return {
		"is_victory": is_victory,
		"match_time": match_time,
		"kills": radiant_kills,
		"deaths": dire_kills,
		"gold_earned": hero_gold,
		"hero_level": hero_lvl,
		"towers_destroyed": radiant_towers_destroyed,
		"enemy_towers_destroyed": dire_towers_destroyed
	}

func reset_match(spawners: Array[Node], towers: Array[Node]) -> void:
	is_match_concluded = false
	radiant_kills = 0
	dire_kills = 0
	radiant_towers_destroyed = 0
	dire_towers_destroyed = 0
	match_time = 0.0
	radiant_respawn_timer = 0.0
	dire_respawn_timer = 0.0
	is_radiant_respawning = false
	is_dire_respawning = false
	
	# 1. Reset Radiant Hero
	if radiant_hero != null and is_instance_valid(radiant_hero):
		_reset_hero_full(radiant_hero, TeamDefinitions.Team.RADIANT)
		
	# 2. Reset Dire Hero
	if dire_hero != null and is_instance_valid(dire_hero):
		_reset_hero_full(dire_hero, TeamDefinitions.Team.DIRE)
		
	# 3. Reset Ancient Cores
	if radiant_ancient != null and is_instance_valid(radiant_ancient):
		radiant_ancient.attribute_system.heal(radiant_ancient.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
		radiant_ancient.visible = true
	if dire_ancient != null and is_instance_valid(dire_ancient):
		dire_ancient.attribute_system.heal(dire_ancient.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
		dire_ancient.visible = true
		
	# 4. Reset Towers
	for t in towers:
		if t is TowerEntity and is_instance_valid(t):
			var tower = t as TowerEntity
			tower.is_destroyed = false
			tower.visible = true
			tower.attribute_system.is_alive = true
			tower.attribute_system.heal(tower.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
			
	# 5. Clear Creeps & Reset Spawners
	for s in spawners:
		if s is LaneMinionSpawner and is_instance_valid(s):
			var spawner = s as LaneMinionSpawner
			spawner.wave_timer = 25.0
			spawner.current_wave_number = 0
			
	var all_creeps = get_tree().get_nodes_in_group("combat_entities") if get_tree() != null else []
	for c in all_creeps:
		if c is CreepEntity and is_instance_valid(c):
			c.queue_free()
			
	set_state(MatchState.PLAYING)
	score_updated.emit(0, 0, 0, 0)

func _reset_hero_full(hero: HeroEntity, team: TeamDefinitions.Team) -> void:
	var spawn_pos = Vector3(-90.0, 1.5, 90.0) if team == TeamDefinitions.Team.RADIANT else Vector3(90.0, 1.5, -90.0)
	hero.global_position = spawn_pos
	hero.velocity = Vector3.ZERO
	hero.is_navigating = false
	hero.is_targetable = true
	hero.visible = true
	
	if hero.attribute_system != null:
		hero.attribute_system.level = 1
		hero.attribute_system.current_xp = 0
		hero.attribute_system.is_alive = true
		hero.attribute_system.recalculate_all_stats()
		hero.attribute_system.heal(hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
		hero.attribute_system.restore_mana(hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA))
		
	if hero.inventory_manager != null:
		hero.inventory_manager.gold = 600
		for i in range(hero.inventory_manager.slots.size()):
			hero.inventory_manager.slots[i] = null
		hero.inventory_manager.boots_slot = null
		
	if hero.ability_container != null:
		hero.ability_container.available_skill_points = 4
		for s in [AbilityResource.Slot.Q, AbilityResource.Slot.W, AbilityResource.Slot.E, AbilityResource.Slot.R]:
			hero.ability_container.ability_levels[s] = 1
			hero.ability_container.cooldown_timers[s] = 0.0
			
	if hero.effect_container != null:
		hero.effect_container.clear_all_effects()
