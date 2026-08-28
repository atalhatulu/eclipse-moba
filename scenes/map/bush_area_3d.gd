class_name BushArea3D
extends Area3D

## MOBA Bush / Brush Area for Stealth & Fog of War Ambush Mechanics
## Units inside are concealed unless an enemy enters the same bush or True Sight is present.

@export var bush_radius: float = 4.0
@export var bush_height: float = 2.5
@export var foliage_color: Color = Color(0.12, 0.38, 0.16, 0.85)

var units_inside: Array[BaseCombatEntity] = []

func _ready() -> void:
	collision_layer = 0
	collision_mask = 2 # Detect entities on layer 2 (combat entities)
	
	_setup_collision_shape()
	_create_procedural_foliage()
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	add_to_group("bushes")

func _setup_collision_shape() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var cyl = CylinderShape3D.new()
		cyl.radius = bush_radius
		cyl.height = bush_height
		col.shape = cyl
		col.position.y = bush_height * 0.5
		add_child(col)

func _create_procedural_foliage() -> void:
	if not has_node("BushFoliage"):
		var root_foliage = Node3D.new()
		root_foliage.name = "BushFoliage"
		add_child(root_foliage)
		
		# Generate a cluster of decorative stylized foliage clumps
		var clump_count = 6
		for i in range(clump_count):
			var clump = MeshInstance3D.new()
			var sphere = SphereMesh.new()
			var r = randf_range(1.1, 1.6)
			sphere.radius = r
			sphere.height = r * 1.8
			clump.mesh = sphere
			
			var angle = (float(i) / float(clump_count)) * TAU
			var dist = randf_range(0.5, bush_radius * 0.7)
			clump.position = Vector3(cos(angle) * dist, r * 0.7, sin(angle) * dist)
			
			var mat = StandardMaterial3D.new()
			mat.albedo_color = foliage_color
			mat.roughness = 0.8
			mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
			mat.cull_mode = BaseMaterial3D.CULL_DISABLED
			clump.material_override = mat
			root_foliage.add_child(clump)

func _on_body_entered(body: Node) -> void:
	if body is BaseCombatEntity and is_instance_valid(body):
		if not units_inside.has(body):
			units_inside.append(body)
			body.set_meta("current_bush", self)

func _on_body_exited(body: Node) -> void:
	if body is BaseCombatEntity:
		units_inside.erase(body)
		if body.has_meta("current_bush") and body.get_meta("current_bush") == self:
			body.remove_meta("current_bush")

func has_team_member(team: TeamDefinitions.Team) -> bool:
	for u in units_inside:
		if is_instance_valid(u) and u.team == team:
			if u.attribute_system != null and not u.is_alive():
				continue
			if u.lifecycle_state != BaseCombatEntity.LifecycleState.ALIVE:
				continue
			return true
	return false
