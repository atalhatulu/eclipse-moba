class_name OutpostObjective
extends Area3D

## Capturable Outpost / Teleport anchor providing map control and vision

signal outpost_captured(new_team: TeamDefinitions.Team)

@export var outpost_name: String = "Jungle Outpost"
@export var controlling_team: TeamDefinitions.Team = TeamDefinitions.Team.NEUTRAL
@export var capture_time_required: float = 6.0

var current_channeler: HeroEntity = null
var channel_time: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _process(delta: float) -> void:
	if current_channeler != null and current_channeler.is_alive():
		channel_time += delta
		if channel_time >= capture_time_required:
			controlling_team = current_channeler.team
			channel_time = 0.0
			outpost_captured.emit(controlling_team)
	else:
		channel_time = 0.0

func _on_body_entered(body: Node3D) -> void:
	if body is HeroEntity and (body as HeroEntity).team != controlling_team:
		current_channeler = body as HeroEntity

func _on_body_exited(body: Node3D) -> void:
	if body == current_channeler:
		current_channeler = null
		channel_time = 0.0
