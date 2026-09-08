class_name WardEntity
extends Node3D

## A lightweight, network-friendly vision object.  Wards deliberately are not
## combat entities: they grant information, can be revealed by true sight and
## expire, without accidentally taking lane aggro or damage events.

@export var team: TeamDefinitions.Team = TeamDefinitions.Team.RADIANT
@export var vision_radius: float = 15.0
@export var true_sight_radius: float = 0.0
@export var duration: float = 180.0
@export var ward_name: String = "Observer Ward"

var placed_by: BaseCombatEntity = null
var remaining_duration: float = 0.0
var is_active: bool = true
var is_revealed: bool = false

func _ready() -> void:
	remaining_duration = duration
	add_to_group("vision_sources")
	if true_sight_radius > 0.0:
		add_to_group("true_sight_sources")
	_create_visual()

func _process(delta: float) -> void:
	if not is_active:
		return
	remaining_duration -= delta
	if remaining_duration <= 0.0:
		expire()

func expire() -> void:
	if not is_active:
		return
	is_active = false
	queue_free()

func is_vision_active() -> bool:
	return is_active and remaining_duration > 0.0

func _create_visual() -> void:
	# Kept procedural so a ward is usable on every generated/test map.
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "WardTotem"
	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.12
	mesh.bottom_radius = 0.20
	mesh.height = 0.72
	mesh_instance.mesh = mesh
	mesh_instance.position.y = 0.38
	var material := StandardMaterial3D.new()
	material.albedo_color = Color(0.20, 0.90, 0.56, 1.0) if true_sight_radius <= 0.0 else Color(1.0, 0.66, 0.18, 1.0)
	material.emission_enabled = true
	material.emission = material.albedo_color * 0.35
	mesh_instance.material_override = material
	add_child(mesh_instance)
