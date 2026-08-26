class_name ObjectiveEntity
extends BaseCombatEntity

## Boss or team base ancient core objective (e.g. Ancient Core, Roshan Boss)

enum ObjectiveType {
	ANCIENT_CORE,
	ROSHAN_BOSS,
	TOWER,
	OUTPOST
}

@export var objective_type: ObjectiveType = ObjectiveType.ROSHAN_BOSS
@export var objective_name: String = "Aegis Guardian"
@export var team_global_gold: int = 300
@export var team_global_xp: int = 500

func _ready() -> void:
	super._ready()
	_apply_stats_by_type()
	_setup_visuals_and_collision()

func _apply_stats_by_type() -> void:
	attribute_system.base_strength = 0.0
	attribute_system.strength_growth = 0.0
	attribute_system.base_agility = 0.0
	attribute_system.agility_growth = 0.0
	attribute_system.base_intelligence = 0.0
	attribute_system.intelligence_growth = 0.0
	
	match objective_type:
		ObjectiveType.ANCIENT_CORE:
			entity_name = "Ancient Core" if entity_name == "Unit" else entity_name
			attribute_system.base_health = 8000.0
			attribute_system.base_health_regen = 20.0
			attribute_system.base_attack_damage = 0.0
			attribute_system.base_armor = 25.0
			attribute_system.base_magic_resist = 30.0
			attribute_system.base_attack_range = 0.0
			attribute_system.base_attack_speed = 0.0
			team_global_gold = 500
			team_global_xp = 1000
		ObjectiveType.ROSHAN_BOSS:
			entity_name = "Roshan the Immortal" if entity_name == "Unit" else entity_name
			team = TeamDefinitions.Team.NEUTRAL
			attribute_system.base_health = 6500.0
			attribute_system.base_health_regen = 15.0
			attribute_system.base_attack_damage = 125.0
			attribute_system.base_armor = 20.0
			attribute_system.base_magic_resist = 35.0
			attribute_system.base_attack_range = 250.0
			attribute_system.base_attack_speed = 0.75
			team_global_gold = 350
			team_global_xp = 750
		_:
			attribute_system.base_health = 5000.0
			attribute_system.base_armor = 15.0
			attribute_system.base_magic_resist = 20.0
			
	attribute_system.recalculate_all_stats()
	attribute_system.heal(attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))

func _setup_visuals_and_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CylinderShape3D.new()
		shape.radius = 2.0 if objective_type == ObjectiveType.ANCIENT_CORE else 1.5
		shape.height = 4.0
		col.shape = shape
		col.position.y = 2.0
		add_child(col)
		
	if not has_node("ObjectiveVisual"):
		var mesh_inst = MeshInstance3D.new()
		mesh_inst.name = "ObjectiveVisual"
		
		if objective_type == ObjectiveType.ANCIENT_CORE:
			var prism = BoxMesh.new()
			prism.size = Vector3(3.5, 5.0, 3.5)
			mesh_inst.mesh = prism
			mesh_inst.position.y = 2.5
			
			var mat = StandardMaterial3D.new()
			if team == TeamDefinitions.Team.RADIANT:
				mat.albedo_color = Color(0.2, 0.8, 0.4, 1.0)
				mat.emission = Color(0.1, 0.6, 0.3, 1.0)
			else:
				mat.albedo_color = Color(0.85, 0.25, 0.25, 1.0)
				mat.emission = Color(0.7, 0.15, 0.15, 1.0)
			mat.emission_enabled = true
			mat.emission_energy_multiplier = 1.0
			mesh_inst.material_override = mat
		else: # ROSHAN BOSS
			var cyl = CylinderMesh.new()
			cyl.top_radius = 1.2
			cyl.bottom_radius = 1.8
			cyl.height = 3.5
			mesh_inst.mesh = cyl
			mesh_inst.position.y = 1.75
			
			var mat = StandardMaterial3D.new()
			mat.albedo_color = Color(0.35, 0.25, 0.2, 1.0) # Stone/Molten Golem
			mat.emission_enabled = true
			mat.emission = Color(0.9, 0.3, 0.05, 1.0)
			mat.emission_energy_multiplier = 0.8
			mesh_inst.material_override = mat
			
		add_child(mesh_inst)
