class_name SkillshotProjectile3D
extends Node3D

## High-performance 3D Skillshot & Linear Projectile for MOBA Abilities
## Moves along a direction vector with glowing mesh, light, trail and impact burst.

var direction: Vector3 = Vector3.FORWARD
var speed: float = 18.0
var max_range: float = 12.0
var traveled_distance: float = 0.0
var impact_color: Color = Color(0.2, 0.7, 1.0)
var impact_radius: float = 2.5
var on_hit_callback: Callable = Callable()

var projectile_mesh: MeshInstance3D = null
var light: OmniLight3D = null

func _ready() -> void:
	# Orient towards direction
	if direction.length_squared() > 0.001:
		direction = direction.normalized()
		look_at(global_position + direction, Vector3.UP)
		
	_setup_visuals()

func _setup_visuals() -> void:
	projectile_mesh = MeshInstance3D.new()
	var cap = CapsuleMesh.new()
	cap.radius = 0.22
	cap.height = 0.8
	projectile_mesh.mesh = cap
	projectile_mesh.rotation.x = PI * 0.5 # Point capsule forward
	
	var mat = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = impact_color
	mat.emission_enabled = true
	mat.emission = impact_color
	mat.emission_energy_multiplier = 4.5
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	projectile_mesh.material_override = mat
	add_child(projectile_mesh)
	
	light = OmniLight3D.new()
	light.light_color = impact_color
	light.light_energy = 4.0
	light.omni_range = 5.0
	add_child(light)

func _process(delta: float) -> void:
	var move_step = speed * delta
	global_position += direction * move_step
	traveled_distance += move_step
	
	if traveled_distance >= max_range:
		_trigger_impact()

func _trigger_impact() -> void:
	if on_hit_callback.is_valid():
		on_hit_callback.call(global_position)
		
	if get_parent() != null and is_inside_tree():
		SpellVisualFX3D.spawn_arcane_burst(get_parent(), global_position, impact_radius, impact_color)
		
	queue_free()

static func launch(parent: Node, spawn_pos: Vector3, dir: Vector3, p_speed: float, p_range: float, p_color: Color, p_radius: float = 2.5, p_callback: Callable = Callable()) -> Node3D:
	if parent == null or not parent.is_inside_tree():
		return null
	var proj = (load("res://scenes/effects/skillshot_projectile_3d.gd") as GDScript).new()
	proj.direction = dir
	proj.speed = p_speed
	proj.max_range = p_range
	proj.impact_color = p_color
	proj.impact_radius = p_radius
	proj.on_hit_callback = p_callback
	parent.add_child(proj)
	proj.global_position = spawn_pos
	return proj
