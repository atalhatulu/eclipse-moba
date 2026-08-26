class_name TargetingIndicator3D
extends Node3D

## 3D Ground Range Ring, AOE Cursor Decal and Soft-Lock Target Snapping for MOBA Spells

var range_mesh_instance: MeshInstance3D = null
var aoe_mesh_instance: MeshInstance3D = null
var lock_ring_instance: MeshInstance3D = null

var max_range: float = 8.0
var aoe_radius: float = 2.5
var indicator_color: Color = Color(0.2, 0.7, 1.0, 0.45)
var is_locked_on_target: bool = false

func _init() -> void:
	_create_meshes()
	hide_indicator()

func _ready() -> void:
	pass

func _create_meshes() -> void:
	# 1. Cast Range Ring (Around Hero)
	range_mesh_instance = MeshInstance3D.new()
	range_mesh_instance.name = "CastRangeRing"
	var ring_mesh = TorusMesh.new()
	ring_mesh.inner_radius = 0.96
	ring_mesh.outer_radius = 1.0
	ring_mesh.rings = 48
	ring_mesh.ring_segments = 3
	range_mesh_instance.mesh = ring_mesh
	
	var ring_mat = StandardMaterial3D.new()
	ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	ring_mat.albedo_color = indicator_color
	ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring_mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	range_mesh_instance.material_override = ring_mat
	add_child(range_mesh_instance)
	
	# 2. AOE Cursor Circle (Under Mouse)
	aoe_mesh_instance = MeshInstance3D.new()
	aoe_mesh_instance.name = "AoeDecal"
	var aoe_mesh = CylinderMesh.new()
	aoe_mesh.top_radius = 1.0
	aoe_mesh.bottom_radius = 1.0
	aoe_mesh.height = 0.04
	aoe_mesh.radial_segments = 32
	aoe_mesh_instance.mesh = aoe_mesh
	
	var aoe_mat = StandardMaterial3D.new()
	aoe_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	aoe_mat.albedo_color = Color(indicator_color.r, indicator_color.g, indicator_color.b, 0.3)
	aoe_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	aoe_mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	aoe_mesh_instance.material_override = aoe_mat
	add_child(aoe_mesh_instance)
	
	# 3. Soft-Lock Target Snapping Ring (Snaps onto hovered enemy or ally)
	lock_ring_instance = MeshInstance3D.new()
	lock_ring_instance.name = "LockOnRing"
	var lock_mesh = TorusMesh.new()
	lock_mesh.inner_radius = 1.15
	lock_mesh.outer_radius = 1.25
	lock_mesh.rings = 32
	lock_mesh.ring_segments = 3
	lock_ring_instance.mesh = lock_mesh
	
	var lock_mat = StandardMaterial3D.new()
	lock_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	lock_mat.albedo_color = Color(1.0, 0.2, 0.2, 0.85)
	lock_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	lock_mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	lock_ring_instance.material_override = lock_mat
	lock_ring_instance.visible = false
	add_child(lock_ring_instance)

func show_indicator(hero_pos: Vector3, p_max_range: float, p_aoe_radius: float, color: Color) -> void:
	visible = true
	max_range = p_max_range
	aoe_radius = p_aoe_radius
	indicator_color = color
	
	# Position Range Ring at Hero's position (slightly above ground)
	range_mesh_instance.global_position = Vector3(hero_pos.x, 0.05, hero_pos.z)
	range_mesh_instance.scale = Vector3(max_range, 1.0, max_range)
	
	var r_mat = range_mesh_instance.material_override as StandardMaterial3D
	if r_mat != null:
		r_mat.albedo_color = Color(color.r, color.g, color.b, 0.45)
		
	var a_mat = aoe_mesh_instance.material_override as StandardMaterial3D
	if a_mat != null:
		a_mat.albedo_color = Color(color.r, color.g, color.b, 0.3)
		
	aoe_mesh_instance.scale = Vector3(aoe_radius, 1.0, aoe_radius)
	if lock_ring_instance != null:
		lock_ring_instance.visible = false

func update_cursor_position(hero_pos: Vector3, cursor_world_pos: Vector3, locked_unit: BaseCombatEntity = null) -> void:
	is_locked_on_target = (locked_unit != null and is_instance_valid(locked_unit) and locked_unit.is_alive())
	if not visible:
		return
		
	if range_mesh_instance != null:
		range_mesh_instance.global_position = Vector3(hero_pos.x, 0.05, hero_pos.z)
	
	var target_pos = cursor_world_pos
	
	if is_locked_on_target:
		# Magnetic soft-lock onto unit position
		target_pos = locked_unit.global_position
		if lock_ring_instance != null:
			lock_ring_instance.visible = true
			lock_ring_instance.global_position = Vector3(target_pos.x, 0.08, target_pos.z)
			var lock_mat = lock_ring_instance.material_override as StandardMaterial3D
			if lock_mat != null:
				if locked_unit.team == TeamDefinitions.Team.NEUTRAL:
					lock_mat.albedo_color = Color(1.0, 0.85, 0.2, 0.95) # Gold for Neutral/Jungle
				elif locked_unit.team != TeamDefinitions.Team.RADIANT:
					lock_mat.albedo_color = Color(1.0, 0.25, 0.25, 0.95) # Red for Enemy
				else:
					lock_mat.albedo_color = Color(0.25, 1.0, 0.4, 0.95) # Green for Ally
	else:
		if lock_ring_instance != null:
			lock_ring_instance.visible = false
			
		# Clamp free cursor within max range
		var dir = cursor_world_pos - hero_pos
		dir.y = 0.0
		var dist = dir.length()
		if dist > max_range:
			target_pos = hero_pos + dir.normalized() * max_range
			
	aoe_mesh_instance.global_position = Vector3(target_pos.x, 0.06, target_pos.z)

func hide_indicator() -> void:
	visible = false
	if lock_ring_instance != null:
		lock_ring_instance.visible = false
