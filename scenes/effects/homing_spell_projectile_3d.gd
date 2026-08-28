class_name HomingSpellProjectile3D
extends Node3D

## 3D Targeted Spell Missile that seeks an enemy/ally entity
## Plays glowing sphere mesh, light, homing movement, and impact explosion on arrival.

var target_node: Node3D = null
var target_offset: Vector3 = Vector3(0, 1.0, 0)
var speed: float = 16.0
var impact_color: Color = Color(0.9, 0.3, 1.0) # Violet/Purple default
var impact_radius: float = 2.0
var on_hit_callback: Callable = Callable()

var mesh_inst: MeshInstance3D = null
var light: OmniLight3D = null

func _ready() -> void:
	mesh_inst = MeshInstance3D.new()
	var sphere = SphereMesh.new()
	sphere.radius = 0.3
	sphere.height = 0.6
	mesh_inst.mesh = sphere
	
	var mat = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = impact_color
	mat.emission_enabled = true
	mat.emission = impact_color
	mat.emission_energy_multiplier = 5.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mesh_inst.material_override = mat
	add_child(mesh_inst)
	
	light = OmniLight3D.new()
	light.light_color = impact_color
	light.light_energy = 4.5
	light.omni_range = 6.0
	add_child(light)

func _process(delta: float) -> void:
	if target_node == null or not is_instance_valid(target_node):
		_trigger_impact()
		return
		
	var target_pos = target_node.global_position if target_node.is_inside_tree() else target_node.position
	var cur_pos = global_position if is_inside_tree() else position
	var diff = target_pos - cur_pos
	var dist = diff.length()
	var step = speed * delta
	
	if dist <= step or dist < 0.6:
		position = target_pos
		if is_inside_tree(): global_position = target_pos
		_trigger_impact()
	else:
		position += diff.normalized() * step
		if is_inside_tree(): global_position += diff.normalized() * step

func _trigger_impact() -> void:
	if on_hit_callback.is_valid():
		on_hit_callback.call(global_position)
		
	if get_parent() != null and is_inside_tree():
		SpellVisualFX3D.spawn_arcane_burst(get_parent(), global_position, impact_radius, impact_color)
		
	queue_free()

static func launch(parent: Node, spawn_pos: Vector3, target: Node3D, p_speed: float, p_color: Color, p_radius: float = 2.0, p_callback: Callable = Callable()) -> Node3D:
	if parent == null or not parent.is_inside_tree() or target == null:
		return null
	var missile = (load("res://scenes/effects/homing_spell_projectile_3d.gd") as GDScript).new()
	missile.target_node = target
	missile.speed = p_speed
	missile.impact_color = p_color
	missile.impact_radius = p_radius
	missile.on_hit_callback = p_callback
	parent.add_child(missile)
	missile.global_position = spawn_pos
	return missile
