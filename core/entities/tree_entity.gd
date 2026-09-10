class_name TreeEntity
extends StaticBody3D

## Authentic Dota 2 Destructible Tree Entity
## Blocks unit pathing and vision, creates juke paths in forests,
## can be chopped down via Tango / Quelling Blade, and respawns after a timer.

signal tree_chopped(destroyer: Node)
signal tree_respawned()

@export var is_dire_side: bool = false
@export var respawn_time: float = 120.0 # 2 minutes in Dota 2

var is_alive_tree: bool = true
var respawn_timer: float = 0.0

var collision_shape: CollisionShape3D = null
var visual_root: Node3D = null
var trunk_mesh: MeshInstance3D = null
var foliage_mesh: MeshInstance3D = null

func _ready() -> void:
	add_to_group("trees")
	_setup_collision()
	_create_tree_visual()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		collision_shape = CollisionShape3D.new()
		collision_shape.name = "CollisionShape3D"
		var cyl = CylinderShape3D.new()
		cyl.radius = 0.65
		cyl.height = 3.2
		collision_shape.shape = cyl
		collision_shape.position.y = 1.6
		add_child(collision_shape)
	else:
		collision_shape = get_node("CollisionShape3D")

func _create_tree_visual() -> void:
	if not has_node("TreeVisual"):
		visual_root = Node3D.new()
		visual_root.name = "TreeVisual"
		add_child(visual_root)

		# 1. Wood Trunk
		trunk_mesh = MeshInstance3D.new()
		var trunk = CylinderMesh.new()
		trunk.top_radius = 0.35
		trunk.bottom_radius = 0.50
		trunk.height = 2.4
		trunk_mesh.mesh = trunk
		trunk_mesh.position.y = 1.2
		
		var trunk_mat = StandardMaterial3D.new()
		if is_dire_side:
			trunk_mat.albedo_color = Color(0.20, 0.16, 0.14) # Scorched Wood
		else:
			trunk_mat.albedo_color = Color(0.38, 0.24, 0.15) # Pine Oak Wood
		trunk_mat.roughness = 0.9
		trunk_mesh.material_override = trunk_mat
		visual_root.add_child(trunk_mesh)

		# 2. Foliage Canopy
		foliage_mesh = MeshInstance3D.new()
		var canopy = SphereMesh.new()
		canopy.radius = 1.25
		canopy.height = 2.6
		foliage_mesh.mesh = canopy
		foliage_mesh.position.y = 2.8
		
		var foliage_mat = StandardMaterial3D.new()
		if is_dire_side:
			foliage_mat.albedo_color = Color(0.22, 0.12, 0.18) # Volcanic Thorns
		else:
			foliage_mat.albedo_color = Color(0.12, 0.42, 0.18) # Lush Green Canopy
		foliage_mat.roughness = 0.85
		foliage_mesh.material_override = foliage_mat
		visual_root.add_child(foliage_mesh)
	else:
		visual_root = get_node("TreeVisual")

func _process(delta: float) -> void:
	if not is_alive_tree:
		respawn_timer -= delta
		if respawn_timer <= 0.0:
			respawn()

func chop(destroyer: Node = null) -> bool:
	if not is_alive_tree:
		return false
		
	is_alive_tree = false
	respawn_timer = respawn_time
	
	# Disable collision to open pathing
	if collision_shape != null:
		collision_shape.disabled = true
		
	# Hide / shrink visual
	if visual_root != null:
		visual_root.visible = false
		
	var vfx_mgr = load("res://systems/vfx/vfx_manager.gd")
	if vfx_mgr != null and get_parent() != null:
		vfx_mgr.spawn_tree_splinters(get_parent(), global_position if is_inside_tree() else position)
		
	if Engine.has_singleton("SoundManager") or is_instance_valid(SoundManager):
		SoundManager.play_3d_sfx("tree_chop", global_position if is_inside_tree() else position)
		
	tree_chopped.emit(destroyer)
	return true

func respawn() -> void:
	is_alive_tree = true
	respawn_timer = 0.0
	
	# Re-enable collision
	if collision_shape != null:
		collision_shape.disabled = false
		
	# Restore visual
	if visual_root != null:
		visual_root.visible = true
		
	tree_respawned.emit()
