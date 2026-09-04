class_name BasicAttackProjectile3D
extends Node3D

## Visual 3D homing projectile for ranged basic attacks (Astris, Ranged Creeps, Towers)

var target: Node3D = null
var source: Node3D = null
var speed: float = 32.0
var damage_request: RefCounted = null
var projectile_color: Color = Color(0.3, 0.6, 1.0, 1.0)
var size_radius: float = 0.35

var _mesh_instance: MeshInstance3D = null
var _omni_light: OmniLight3D = null

func _ready() -> void:
	_create_visuals()

func setup(p_source: Node3D, p_target: Node3D, p_req: RefCounted, p_color: Color, p_speed: float = 32.0, p_radius: float = 0.35, p_spawn_pos: Vector3 = Vector3.ZERO) -> void:
	source = p_source
	target = p_target
	damage_request = p_req
	projectile_color = p_color
	speed = p_speed
	size_radius = p_radius
	
	if p_spawn_pos != Vector3.ZERO:
		global_position = p_spawn_pos
	elif source != null and is_instance_valid(source):
		global_position = source.global_position + Vector3(0, 1.4, 0)
	_update_material()

func _create_visuals() -> void:
	_mesh_instance = MeshInstance3D.new()
	var sphere = SphereMesh.new()
	sphere.radius = size_radius
	sphere.height = size_radius * 2.0
	_mesh_instance.mesh = sphere
	add_child(_mesh_instance)
	
	_omni_light = OmniLight3D.new()
	_omni_light.light_energy = 2.0
	_omni_light.omni_range = 3.0
	add_child(_omni_light)
	_update_material()

func _update_material() -> void:
	if _mesh_instance != null:
		var mat = StandardMaterial3D.new()
		mat.albedo_color = projectile_color
		mat.emission_enabled = true
		mat.emission = projectile_color
		mat.emission_energy_multiplier = 3.5
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		_mesh_instance.material_override = mat
	if _omni_light != null:
		_omni_light.light_color = projectile_color

func _physics_process(delta: float) -> void:
	if target == null or not is_instance_valid(target):
		queue_free()
		return
	if target.has_method("is_alive") and not target.is_alive():
		queue_free()
		return
		
	var target_pos = target.global_position + Vector3(0, 1.0, 0)
	var dir = (target_pos - global_position)
	var dist = dir.length()
	
	if dist <= (speed * delta) or dist < 0.6:
		_on_impact()
		return
		
	global_position += dir.normalized() * speed * delta

func _on_impact() -> void:
	if target != null and is_instance_valid(target) and damage_request != null:
		if target.has_method("is_alive") and target.is_alive():
			if target.has_method("receive_damage"):
				var res = target.receive_damage(damage_request)
				if source != null and is_instance_valid(source) and source.has_signal("basic_attack_performed"):
					source.basic_attack_performed.emit(target, res)
				if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
					GameEvents.attack_hit.emit(source, target, res)
					GameEvents.attack_landed.emit(source, target, res)
					GameEvents.damage_dealt.emit(res, source, target)
		_spawn_impact_spark()
	queue_free()

func _spawn_impact_spark() -> void:
	if not is_inside_tree():
		return
	var m_parent = get_parent()
	if m_parent == null:
		return
		
	var spark = MeshInstance3D.new()
	var s_mesh = SphereMesh.new()
	s_mesh.radius = size_radius * 1.6
	s_mesh.height = size_radius * 3.2
	spark.mesh = s_mesh
	spark.global_position = global_position
	
	var mat = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = projectile_color
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	spark.material_override = mat
	m_parent.add_child(spark)
	
	var tw = spark.create_tween()
	if tw != null:
		tw.set_parallel(true)
		tw.tween_property(spark, "scale", Vector3(1.8, 1.8, 1.8), 0.15).set_trans(Tween.TRANS_QUAD)
		tw.tween_property(mat, "albedo_color:a", 0.0, 0.15)
		tw.chain().tween_callback(spark.queue_free)
	else:
		spark.queue_free()

