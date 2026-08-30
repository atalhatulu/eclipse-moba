class_name AstranHero
extends HeroEntity

## Implementation of Astran

const DefScript = preload("res://data/heroes/astran_definition.gd")

func _ready() -> void:
	entity_name = "Astran"
	super._ready()
	_setup_collision()
	_create_visual_mesh()
	_apply_def()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.60
		shape.height = 2.1
		col.shape = shape
		col.position.y = 1.05
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("AstranVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "AstranVisual"
		add_child(root_vis)
		
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.52
		body_capsule.height = 2.0
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.0
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.12, 0.20, 0.55)
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)

func _apply_def() -> void:
	var def = DefScript.create_resource()
	_apply_hero_resource(def)
	hero_resource = def
	
	if ability_container != null:
		ability_container.set_ability(AbilityResource.Slot.Q, def.abilities[AbilityResource.Slot.Q])
		ability_container.set_ability(AbilityResource.Slot.W, def.abilities[AbilityResource.Slot.W])
		ability_container.set_ability(AbilityResource.Slot.E, def.abilities[AbilityResource.Slot.E])
		ability_container.set_ability(AbilityResource.Slot.R, def.abilities[AbilityResource.Slot.R])
