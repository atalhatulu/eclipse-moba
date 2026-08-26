class_name LaneMinionSpawner
extends Node3D

## Manages periodic minion wave spawning for TOP, MID, and BOT lanes with 30s intervals, Siege waves, and data-driven composition

enum Lane {
	TOP,
	MID,
	BOT
}

signal wave_spawned(wave_number: int, lane: Lane, team: TeamDefinitions.Team)

@export var team: TeamDefinitions.Team = TeamDefinitions.Team.RADIANT
@export var lane: Lane = Lane.MID
@export var wave_interval: float = 30.0 # 30 seconds per wave
@export var lane_waypoints: Array[Vector3] = []
@export var enable_siege_creeps: bool = true

var wave_timer: float = 28.5 # First wave spawns 1.5s after match start
var current_wave_number: int = 0
var is_spawning_active: bool = true

func _ready() -> void:
	if lane_waypoints.is_empty():
		lane_waypoints.assign(get_default_waypoints(team, lane))

func _process(delta: float) -> void:
	if not is_spawning_active:
		return
		
	wave_timer += delta
	if wave_timer >= wave_interval:
		wave_timer -= wave_interval
		spawn_wave()

static func get_wave_composition(wave_num: int, has_siege: bool = true) -> Array[CreepEntity.CreepType]:
	var comp: Array[CreepEntity.CreepType] = [
		CreepEntity.CreepType.MELEE,
		CreepEntity.CreepType.MELEE,
		CreepEntity.CreepType.MELEE,
		CreepEntity.CreepType.RANGED
	]
	if has_siege and (wave_num % 3 == 0):
		comp.append(CreepEntity.CreepType.SIEGE)
	return comp

static func get_default_waypoints(p_team: TeamDefinitions.Team, p_lane: Lane) -> Array[Vector3]:
	var pts: Array[Vector3] = []
	if p_team == TeamDefinitions.Team.RADIANT:
		match p_lane:
			Lane.MID:
				pts = [Vector3(-55, 0, 0), Vector3(-25, 0, 0), Vector3(0, 0, 0), Vector3(25, 0, 0), Vector3(55, 0, 0)]
			Lane.TOP:
				pts = [Vector3(-55, 0, 0), Vector3(-50, 0, -30), Vector3(0, 0, -32), Vector3(50, 0, -30), Vector3(55, 0, 0)]
			Lane.BOT:
				pts = [Vector3(-55, 0, 0), Vector3(-50, 0, 30), Vector3(0, 0, 32), Vector3(50, 0, 30), Vector3(55, 0, 0)]
	else:
		match p_lane:
			Lane.MID:
				pts = [Vector3(55, 0, 0), Vector3(25, 0, 0), Vector3(0, 0, 0), Vector3(-25, 0, 0), Vector3(-55, 0, 0)]
			Lane.TOP:
				pts = [Vector3(55, 0, 0), Vector3(50, 0, -30), Vector3(0, 0, -32), Vector3(-50, 0, -30), Vector3(-55, 0, 0)]
			Lane.BOT:
				pts = [Vector3(55, 0, 0), Vector3(50, 0, 30), Vector3(0, 0, 32), Vector3(-50, 0, 30), Vector3(-55, 0, 0)]
	return pts

func spawn_wave() -> void:
	current_wave_number += 1
	var comp = get_wave_composition(current_wave_number, enable_siege_creeps)
	var forward_sign = 1.0 if team == TeamDefinitions.Team.RADIANT else -1.0
	
	# Spawn offsets: Melee 1, 2, 3 in triangle front, Ranged in center back, Siege in rear center
	var offsets: Array[Vector3] = [
		Vector3(forward_sign * 2.2, 0.5, -1.2), # Melee Left
		Vector3(forward_sign * 3.0, 0.5, 0.0),  # Melee Center
		Vector3(forward_sign * 2.2, 0.5, 1.2),  # Melee Right
		Vector3(forward_sign * 0.5, 0.5, 0.0),  # Ranged Center
		Vector3(forward_sign * -1.0, 0.5, 0.0)  # Siege Rear
	]
	
	for i in range(comp.size()):
		var off = offsets[i] if i < offsets.size() else Vector3(forward_sign * (float(i) * 0.8), 0.5, 0.0)
		_spawn_creep(comp[i], off)
		
	wave_spawned.emit(current_wave_number, lane, team)

func _spawn_creep(type: CreepEntity.CreepType, offset: Vector3) -> CreepEntity:
	var creep = CreepEntity.new()
	creep.team = team
	creep.creep_type = type
	var type_name = "Melee" if type == CreepEntity.CreepType.MELEE else ("Ranged" if type == CreepEntity.CreepType.RANGED else "Siege")
	var lane_name = "Top" if lane == Lane.TOP else ("Mid" if lane == Lane.MID else "Bot")
	creep.entity_name = "%s %s %s Minion" % [("Radiant" if team == TeamDefinitions.Team.RADIANT else "Dire"), lane_name, type_name]
	creep.waypoints.assign(lane_waypoints)
	if get_parent() != null:
		get_parent().add_child(creep)
	else:
		add_child(creep)
	creep.global_position = global_position + offset
	creep.add_to_group("combat_entities")
	return creep
