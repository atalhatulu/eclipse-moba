class_name WorldStatusBar
extends Node3D

## Universal 3D World-Space Status Bar for Heroes, Creeps, Siege Units, Neutrals, and Towers
## Provides real-time HP, delayed damage lag bar, mana bar, active shield overlay, and CC status labels

@export var vertical_offset: float = 2.0
@export var bar_width: float = 1.1
@export var bar_height: float = 0.10
@export var is_selected_target: bool = false
@export var debug_mode: bool = false

var owner_entity: CharacterBody3D = null

# Smooth Damage Lag State
var current_hp_ratio: float = 1.0
var delayed_hp_ratio: float = 1.0
var delayed_timer: float = 0.0
var delayed_lag_duration: float = 0.35
var delayed_catchup_speed: float = 3.5

# Visual Nodes
var anchor_root: Node3D = null
var bg_mesh: MeshInstance3D = null
var delayed_mesh: MeshInstance3D = null
var hp_mesh: MeshInstance3D = null
var shield_mesh: MeshInstance3D = null
var mana_bg_mesh: MeshInstance3D = null
var mana_mesh: MeshInstance3D = null
var status_label: Label3D = null
var debug_label: Label3D = null

# Material References
var _hp_material: StandardMaterial3D = null
var _delayed_material: StandardMaterial3D = null
var _shield_material: StandardMaterial3D = null
var _mana_material: StandardMaterial3D = null
var _bg_material: StandardMaterial3D = null

func _init() -> void:
	_create_components()

func _ready() -> void:
	if owner_entity == null and get_parent() is CharacterBody3D:
		setup(get_parent() as CharacterBody3D)
		
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		if not GameEvents.target_selected.is_connected(_on_target_selected):
			GameEvents.target_selected.connect(_on_target_selected)
		if not GameEvents.target_cleared.is_connected(_on_target_cleared):
			GameEvents.target_cleared.connect(_on_target_cleared)

func setup(entity: CharacterBody3D, p_offset: float = -1.0) -> void:
	owner_entity = entity
	if p_offset > 0.0:
		vertical_offset = p_offset
	else:
		vertical_offset = _determine_height_offset(entity)
		
	position.y = vertical_offset
	_apply_team_styling()
	_update_visuals(0.0)

func _determine_height_offset(entity: CharacterBody3D) -> float:
	if entity is TowerEntity:
		bar_width = 1.8
		bar_height = 0.16
		return 4.8
	elif entity is HeroEntity:
		bar_width = 1.2
		bar_height = 0.11
		return 2.2
	elif entity is CreepEntity:
		var c = entity as CreepEntity
		if c.creep_type == CreepEntity.CreepType.SIEGE:
			bar_width = 1.1
			bar_height = 0.10
			return 1.6
		bar_width = 0.85
		bar_height = 0.08
		return 1.2
	elif entity is NeutralCreepEntity:
		bar_width = 1.0
		bar_height = 0.09
		return 1.8
	elif entity is ObjectiveEntity:
		bar_width = 2.0
		bar_height = 0.18
		return 5.2
	return 1.5

func _create_components() -> void:
	if anchor_root != null:
		return
		
	anchor_root = Node3D.new()
	anchor_root.name = "AnchorRoot"
	add_child(anchor_root)
	
	# 1. Background Border
	bg_mesh = MeshInstance3D.new()
	bg_mesh.name = "BgMesh"
	var bg_box = BoxMesh.new()
	bg_box.size = Vector3(bar_width + 0.04, bar_height + 0.03, 0.01)
	bg_mesh.mesh = bg_box
	
	_bg_material = StandardMaterial3D.new()
	_bg_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_bg_material.albedo_color = Color(0.06, 0.08, 0.10, 0.92)
	bg_mesh.material_override = _bg_material
	anchor_root.add_child(bg_mesh)
	
	# 2. Delayed Damage Flash Bar
	delayed_mesh = MeshInstance3D.new()
	delayed_mesh.name = "DelayedHPMesh"
	var del_box = BoxMesh.new()
	del_box.size = Vector3(bar_width, bar_height, 0.015)
	delayed_mesh.mesh = del_box
	
	_delayed_material = StandardMaterial3D.new()
	_delayed_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_delayed_material.albedo_color = Color(1.0, 0.78, 0.25, 1.0) # Golden yellow flash
	delayed_mesh.material_override = _delayed_material
	anchor_root.add_child(delayed_mesh)
	
	# 3. Main Health Bar
	hp_mesh = MeshInstance3D.new()
	hp_mesh.name = "HPMesh"
	var hp_box = BoxMesh.new()
	hp_box.size = Vector3(bar_width, bar_height, 0.02)
	hp_mesh.mesh = hp_box
	
	_hp_material = StandardMaterial3D.new()
	_hp_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_hp_material.albedo_color = Color(0.18, 0.75, 0.32, 1.0) # Radiant Green
	hp_mesh.material_override = _hp_material
	anchor_root.add_child(hp_mesh)
	
	# 4. Shield Overlay Bar
	shield_mesh = MeshInstance3D.new()
	shield_mesh.name = "ShieldMesh"
	var sh_box = BoxMesh.new()
	sh_box.size = Vector3(bar_width, bar_height, 0.025)
	shield_mesh.mesh = sh_box
	
	_shield_material = StandardMaterial3D.new()
	_shield_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_shield_material.albedo_color = Color(0.1, 0.85, 1.0, 0.8) # Shield Cyan
	_shield_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	shield_mesh.material_override = _shield_material
	shield_mesh.visible = false
	anchor_root.add_child(shield_mesh)
	
	# 5. Mana Background & Bar (Directly below HP bar)
	mana_bg_mesh = MeshInstance3D.new()
	mana_bg_mesh.name = "ManaBgMesh"
	var m_bg_box = BoxMesh.new()
	m_bg_box.size = Vector3(bar_width + 0.04, bar_height * 0.45 + 0.02, 0.01)
	mana_bg_mesh.mesh = m_bg_box
	mana_bg_mesh.position.y = -(bar_height * 0.75)
	mana_bg_mesh.material_override = _bg_material
	anchor_root.add_child(mana_bg_mesh)
	
	mana_mesh = MeshInstance3D.new()
	mana_mesh.name = "ManaMesh"
	var m_box = BoxMesh.new()
	m_box.size = Vector3(bar_width, bar_height * 0.45, 0.02)
	mana_mesh.mesh = m_box
	mana_mesh.position.y = -(bar_height * 0.75)
	
	_mana_material = StandardMaterial3D.new()
	_mana_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	_mana_material.albedo_color = Color(0.18, 0.55, 0.95, 1.0) # Mana Blue
	mana_mesh.material_override = _mana_material
	anchor_root.add_child(mana_mesh)
	
	# 6. Status / Crowd Control Label (Centered above bar)
	status_label = Label3D.new()
	status_label.name = "StatusLabel"
	status_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	status_label.font_size = 28
	status_label.outline_size = 8
	status_label.outline_modulate = Color.BLACK
	status_label.modulate = Color(1.0, 0.3, 0.3)
	status_label.position.y = bar_height * 1.5 + 0.12
	status_label.visible = false
	anchor_root.add_child(status_label)
	
	# 7. Debug Info Label
	debug_label = Label3D.new()
	debug_label.name = "DebugLabel"
	debug_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	debug_label.font_size = 20
	debug_label.outline_size = 6
	debug_label.outline_modulate = Color.BLACK
	debug_label.position.y = -(bar_height * 1.8)
	debug_label.visible = false
	anchor_root.add_child(debug_label)

func _apply_team_styling() -> void:
	if owner_entity == null:
		return
		
	if _hp_material != null:
		if owner_entity.team == TeamDefinitions.Team.RADIANT:
			_hp_material.albedo_color = Color(0.18, 0.78, 0.32, 1.0) # Radiant Green
		elif owner_entity.team == TeamDefinitions.Team.DIRE:
			_hp_material.albedo_color = Color(0.92, 0.22, 0.22, 1.0) # Dire Red
		elif owner_entity.team == TeamDefinitions.Team.NEUTRAL:
			_hp_material.albedo_color = Color(0.95, 0.72, 0.15, 1.0) # Neutral Gold
		else:
			_hp_material.albedo_color = Color(0.6, 0.6, 0.6, 1.0)

func _process(delta: float) -> void:
	_update_billboard_rotation()
	_update_visuals(delta)

func _update_billboard_rotation() -> void:
	if not is_inside_tree():
		return
		
	var cam = get_viewport().get_camera_3d() if get_viewport() != null else null
	if cam != null and is_instance_valid(cam):
		anchor_root.global_rotation = cam.global_rotation
		
		# Distance culling (Hide non-selected bars beyond 45m)
		var dist = global_position.distance_to(cam.global_position)
		if dist > 45.0 and not is_selected_target:
			visible = false
			return
		else:
			if owner_entity != null and owner_entity.is_alive():
				visible = true

func _update_visuals(delta: float) -> void:
	if owner_entity == null or not is_instance_valid(owner_entity):
		visible = false
		return
		
	if not owner_entity.is_alive():
		visible = false
		return
		
	visible = true
	
	# 1. Health Bar & Delayed Lag Bar
	var attr = owner_entity.attribute_system
	if attr != null:
		var max_hp = maxf(attr.get_stat(StatModifier.TargetStat.MAX_HEALTH), 1.0)
		var cur_hp = clampf(attr.current_health, 0.0, max_hp)
		var target_hp_ratio = cur_hp / max_hp
		
		if target_hp_ratio < current_hp_ratio:
			# Damage taken -> immediate drop on main bar, start delayed timer
			current_hp_ratio = target_hp_ratio
			delayed_timer = delayed_lag_duration
		elif target_hp_ratio > current_hp_ratio:
			# Healed -> catch up immediately
			current_hp_ratio = target_hp_ratio
			delayed_hp_ratio = target_hp_ratio
			delayed_timer = 0.0
			
		# Process delayed bar catchup
		if delayed_timer > 0.0:
			delayed_timer -= delta
		if delayed_timer <= 0.0:
			delayed_hp_ratio = move_toward(delayed_hp_ratio, current_hp_ratio, delta * delayed_catchup_speed)
			
		# Update HP Mesh Scale and Left Alignment
		_update_bar_mesh(hp_mesh, current_hp_ratio)
		_update_bar_mesh(delayed_mesh, delayed_hp_ratio)
		
		# 2. Mana Bar
		var max_mp = attr.get_stat(StatModifier.TargetStat.MAX_MANA)
		if max_mp > 0.0 and owner_entity is HeroEntity:
			mana_bg_mesh.visible = true
			mana_mesh.visible = true
			var cur_mp = clampf(attr.current_mana, 0.0, max_mp)
			var mp_ratio = cur_mp / max_mp
			_update_bar_mesh(mana_mesh, mp_ratio)
		else:
			mana_bg_mesh.visible = false
			mana_mesh.visible = false
			
		# 3. Shield Bar
		var shield_amount = _get_active_shield_amount()
		if shield_amount > 0.0:
			shield_mesh.visible = true
			var shield_ratio = clampf(shield_amount / max_hp, 0.0, 1.0)
			_update_bar_mesh(shield_mesh, shield_ratio)
		else:
			shield_mesh.visible = false
			
		# 4. Status Effect / Crowd Control Label
		_update_status_effect_display()
		
		# 5. Debug Info
		if debug_mode and debug_label != null:
			debug_label.visible = true
			debug_label.text = "HP: %d/%d | MP: %d/%d | Shield: %d" % [int(cur_hp), int(max_hp), int(attr.current_mana), int(max_mp), int(shield_amount)]
		elif debug_label != null:
			debug_label.visible = false

func _update_bar_mesh(mesh_inst: MeshInstance3D, ratio: float) -> void:
	if mesh_inst == null:
		return
	var clamped_r = clampf(ratio, 0.0, 1.0)
	mesh_inst.scale.x = clamped_r
	# Left-aligned bar: Shift origin so bar expands from left to right
	mesh_inst.position.x = - (bar_width * (1.0 - clamped_r) * 0.5)

func _get_active_shield_amount() -> float:
	if owner_entity == null:
		return 0.0
	if owner_entity.effect_container != null and owner_entity.effect_container.has_method("get_total_shield_amount"):
		return owner_entity.effect_container.get_total_shield_amount()
	return 0.0

func _update_status_effect_display() -> void:
	if status_label == null:
		return
		
	if owner_entity == null or owner_entity.effect_container == null:
		status_label.visible = false
		return
		
	var cc_info = owner_entity.effect_container.get_primary_crowd_control()
	if cc_info.get("duration", 0.0) > 0.0:
		status_label.visible = true
		status_label.text = "[%s] %0.1fs" % [cc_info["type"], cc_info["duration"]]
		status_label.modulate = cc_info.get("color", Color.WHITE)
	else:
		status_label.visible = false
		status_label.text = ""

func set_selected(p_selected: bool) -> void:
	is_selected_target = p_selected
	if anchor_root != null:
		if is_selected_target:
			anchor_root.scale = Vector3(1.18, 1.18, 1.18)
			if _bg_material != null:
				_bg_material.albedo_color = Color(0.95, 0.85, 0.2, 1.0) # Yellow selected highlight border
		else:
			anchor_root.scale = Vector3(1.0, 1.0, 1.0)
			if _bg_material != null:
				_bg_material.albedo_color = Color(0.06, 0.08, 0.10, 0.92)

func _on_target_selected(entity: Node) -> void:
	if entity == owner_entity:
		set_selected(true)
	else:
		set_selected(false)

func _on_target_cleared() -> void:
	set_selected(false)

# Getters for unit tests
func get_health_ratio() -> float:
	return current_hp_ratio

func get_delayed_health_ratio() -> float:
	return delayed_hp_ratio

func get_mana_ratio() -> float:
	if owner_entity == null or owner_entity.attribute_system == null:
		return 0.0
	var max_mp = owner_entity.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
	if max_mp <= 0.0:
		return 0.0
	return clampf(owner_entity.attribute_system.current_mana / max_mp, 0.0, 1.0)

func get_active_status_text() -> String:
	if status_label != null and status_label.visible:
		return status_label.text
	return ""
