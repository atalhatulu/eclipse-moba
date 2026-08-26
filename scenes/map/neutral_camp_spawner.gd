class_name NeutralCampSpawner
extends Node3D

## Spawns and manages jungle neutral creeps with a deterministic State Machine (AVAILABLE, ACTIVE, CLEARED, RESPAWNING)

enum CampType {
	SMALL,
	MEDIUM,
	LARGE,
	ANCIENT
}

enum CampState {
	AVAILABLE,
	ACTIVE,
	CLEARED,
	RESPAWNING
}

@export var camp_name: String = "Jungle Camp"
@export var camp_type: CampType = CampType.MEDIUM
@export var respawn_interval: float = 60.0 # 60 seconds respawn timer
@export var camp_stack_box_radius: float = 8.5 # Distance to trigger stacking if pulled away

var current_state: CampState = CampState.AVAILABLE
var active_neutrals: Array[NeutralCreepEntity] = []
var respawn_timer: float = 0.0

func _ready() -> void:
	if not has_node("CampAltar") and not has_node("AltarPad"):
		_create_camp_altar_visual()
	spawn_camp()

func _create_camp_altar_visual() -> void:
	if not has_node("CampAltar"):
		var altar = Node3D.new()
		altar.name = "CampAltar"
		add_child(altar)
		
		# Base Stone Pad
		var pad = MeshInstance3D.new()
		var cyl = CylinderMesh.new()
		cyl.top_radius = 2.2
		cyl.bottom_radius = 2.4
		cyl.height = 0.08
		pad.mesh = cyl
		pad.position.y = 0.04
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.18, 0.16, 0.14, 1.0)
		if camp_type == CampType.ANCIENT:
			mat.albedo_color = Color(0.14, 0.10, 0.18, 1.0)
			mat.emission_enabled = true
			mat.emission = Color(0.4, 0.1, 0.5, 1.0)
			mat.emission_energy_multiplier = 0.4
		pad.material_override = mat
		altar.add_child(pad)
		
		# Center Campfire / Runestone
		var fire = MeshInstance3D.new()
		var f_mesh = CylinderMesh.new()
		f_mesh.top_radius = 0.3
		f_mesh.bottom_radius = 0.4
		f_mesh.height = 0.4
		fire.mesh = f_mesh
		fire.position.y = 0.20
		
		var f_mat = StandardMaterial3D.new()
		f_mat.albedo_color = Color(0.85, 0.45, 0.1, 1.0)
		f_mat.emission_enabled = true
		f_mat.emission = Color(0.95, 0.5, 0.1, 1.0)
		f_mat.emission_energy_multiplier = 1.5
		fire.material_override = f_mat
		altar.add_child(fire)

func _process(delta: float) -> void:
	# 1. Clean up dead neutrals from tracking list
	for i in range(active_neutrals.size() - 1, -1, -1):
		var n = active_neutrals[i]
		if n == null or not is_instance_valid(n) or not n.is_alive():
			active_neutrals.remove_at(i)
			
	# 2. State Machine Transitions
	match current_state:
		CampState.AVAILABLE:
			if active_neutrals.is_empty():
				current_state = CampState.RESPAWNING
				respawn_timer = respawn_interval
			else:
				for n in active_neutrals:
					if is_instance_valid(n) and n.aggro_target != null:
						current_state = CampState.ACTIVE
						break
						
		CampState.ACTIVE:
			if active_neutrals.is_empty():
				current_state = CampState.CLEARED
			else:
				var still_active = false
				for n in active_neutrals:
					if is_instance_valid(n) and n.aggro_target != null:
						still_active = true
						break
				if not still_active:
					current_state = CampState.AVAILABLE
					
		CampState.CLEARED:
			current_state = CampState.RESPAWNING
			respawn_timer = respawn_interval
			
		CampState.RESPAWNING:
			respawn_timer -= delta
			if respawn_timer <= 0.0:
				spawn_camp()

func spawn_camp() -> void:
	# If creeps are present inside camp box, do not stack/spawn unless pulled out
	var has_creeps_inside_box = false
	for n in active_neutrals:
		if is_instance_valid(n) and n.is_alive():
			has_creeps_inside_box = true
			break
				
	if has_creeps_inside_box:
		return
		
	var creep_types: Array[NeutralCreepEntity.NeutralType] = []
	match camp_type:
		CampType.SMALL:
			creep_types = [
				NeutralCreepEntity.NeutralType.KOBOLD,
				NeutralCreepEntity.NeutralType.KOBOLD,
				NeutralCreepEntity.NeutralType.FOREST_MAGE
			]
		CampType.MEDIUM:
			creep_types = [
				NeutralCreepEntity.NeutralType.WOLF,
				NeutralCreepEntity.NeutralType.WOLF,
				NeutralCreepEntity.NeutralType.MUD_GOLEM
			]
		CampType.LARGE:
			creep_types = [
				NeutralCreepEntity.NeutralType.CENTAUR,
				NeutralCreepEntity.NeutralType.MUD_GOLEM,
				NeutralCreepEntity.NeutralType.MUD_GOLEM,
				NeutralCreepEntity.NeutralType.CENTAUR
			]
		CampType.ANCIENT:
			creep_types = [
				NeutralCreepEntity.NeutralType.DRAGON,
				NeutralCreepEntity.NeutralType.DRAGON,
				NeutralCreepEntity.NeutralType.CENTAUR
			]
			
	var count = creep_types.size()
	for i in range(count):
		var angle = (float(i) / float(count)) * TAU
		var offset = Vector3(cos(angle) * 1.8, 0.0, sin(angle) * 1.8)
		
		var neutral = NeutralCreepEntity.new()
		neutral.neutral_type = creep_types[i]
		neutral.camp_spawner = self
		neutral.spawn_origin = global_position + offset
		neutral._ready()
		neutral.add_to_group("combat_entities")
		add_child(neutral)
		neutral.global_position = neutral.spawn_origin
		
		active_neutrals.append(neutral)
		
	current_state = CampState.AVAILABLE

func notify_camp_aggro(target: BaseCombatEntity) -> void:
	for n in active_neutrals:
		if is_instance_valid(n) and n.is_alive():
			n.alert_aggro(target)

func notify_camp_leash_reset() -> void:
	for n in active_neutrals:
		if is_instance_valid(n) and n.is_alive() and not n.is_leashing_back:
			n._trigger_leash_reset()
