class_name TargetDummyEntity
extends BaseCombatEntity

## Target Dummy for DPS testing, damage calculation analysis, and item synergy validation
## Features auto-healing, DPS calculation over 3s rolling window, and floating damage metrics.

@export var dps_window_seconds: float = 3.0

var total_damage_taken: float = 0.0
var recent_damage_history: Array[Dictionary] = [] # [{time: float, damage: float}]
var current_dps: float = 0.0
var idle_timer: float = 0.0

var dps_label_3d: Label3D = null

func _init() -> void:
	team = TeamDefinitions.Team.DIRE

func _ready() -> void:
	entity_name = "Target Dummy"
	super._ready()
	
	_apply_dummy_stats()
	_create_visual_mesh()
	_setup_collision()
	_create_dps_display()

func _apply_dummy_stats() -> void:
	attribute_system.base_strength = 0.0
	attribute_system.strength_growth = 0.0
	attribute_system.base_agility = 0.0
	attribute_system.agility_growth = 0.0
	attribute_system.base_intelligence = 0.0
	attribute_system.intelligence_growth = 0.0
	
	attribute_system.base_health = 10000.0
	attribute_system.base_armor = 30.0 # ~23% physical damage reduction
	attribute_system.base_magic_resist = 30.0 # ~23% magical damage reduction
	attribute_system.base_attack_damage = 0.0
	attribute_system.base_move_speed = 0.0 # Immobile
	attribute_system.base_attack_range = 0.0
	
	attribute_system.recalculate_all_stats()
	attribute_system.heal(10000.0)
	attribute_system.current_health = 10000.0

func _create_visual_mesh() -> void:
	if not has_node("DummyVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "DummyVisual"
		add_child(root_vis)
		
		# 1. Wooden Cross Base (0.3m)
		var base_mesh = MeshInstance3D.new()
		var box = BoxMesh.new()
		box.size = Vector3(1.2, 0.2, 1.2)
		base_mesh.mesh = box
		base_mesh.position.y = 0.1
		var wood_mat = StandardMaterial3D.new()
		wood_mat.albedo_color = Color(0.45, 0.30, 0.18, 1.0)
		base_mesh.material_override = wood_mat
		root_vis.add_child(base_mesh)
		
		# 2. Main Post (1.8m)
		var post = MeshInstance3D.new()
		var cyl = CylinderMesh.new()
		cyl.top_radius = 0.15
		cyl.bottom_radius = 0.18
		cyl.height = 1.8
		post.mesh = cyl
		post.position.y = 0.9
		post.material_override = wood_mat
		root_vis.add_child(post)
		
		# 3. Straw Body Torso
		var torso = MeshInstance3D.new()
		var t_capsule = CapsuleMesh.new()
		t_capsule.radius = 0.38
		t_capsule.height = 1.1
		torso.mesh = t_capsule
		torso.position.y = 1.15
		var straw_mat = StandardMaterial3D.new()
		straw_mat.albedo_color = Color(0.78, 0.65, 0.32, 1.0)
		torso.material_override = straw_mat
		root_vis.add_child(torso)
		
		# 4. Red Bullseye Target Emblem on Chest
		var emblem = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.18
		torus.outer_radius = 0.28
		emblem.mesh = torus
		emblem.position = Vector3(0.0, 1.25, 0.32)
		emblem.rotation_degrees = Vector3(90.0, 0.0, 0.0)
		var red_mat = StandardMaterial3D.new()
		red_mat.albedo_color = Color(0.95, 0.2, 0.2, 1.0)
		red_mat.emission_enabled = true
		red_mat.emission = Color(0.8, 0.1, 0.1, 1.0)
		emblem.material_override = red_mat
		root_vis.add_child(emblem)
		
		# 5. Dummy Head with Practice Helmet
		var head = MeshInstance3D.new()
		var s_mesh = SphereMesh.new()
		s_mesh.radius = 0.25
		s_mesh.height = 0.50
		head.mesh = s_mesh
		head.position.y = 1.85
		var iron_mat = StandardMaterial3D.new()
		iron_mat.albedo_color = Color(0.35, 0.38, 0.42, 1.0)
		iron_mat.metallic = 0.8
		head.material_override = iron_mat
		root_vis.add_child(head)

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.45
		shape.height = 2.0
		col.shape = shape
		col.position.y = 1.0
		add_child(col)

func _create_dps_display() -> void:
	if not has_node("DPSDisplay"):
		dps_label_3d = Label3D.new()
		dps_label_3d.name = "DPSDisplay"
		dps_label_3d.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		dps_label_3d.text = "DPS: 0.0\nTotal: 0"
		dps_label_3d.font_size = 32
		dps_label_3d.outline_size = 8
		dps_label_3d.modulate = Color(1.0, 0.85, 0.2, 1.0)
		dps_label_3d.outline_modulate = Color.BLACK
		dps_label_3d.position = Vector3(0, 2.35, 0)
		add_child(dps_label_3d)

func _process(delta: float) -> void:
	super._process(delta)
	
	idle_timer += delta
	var current_time = Time.get_ticks_msec() / 1000.0
	
	# Prune old damage history entries
	var cutoff_time = current_time - dps_window_seconds
	var active_history: Array[Dictionary] = []
	var window_damage: float = 0.0
	
	for entry in recent_damage_history:
		if entry.time >= cutoff_time:
			active_history.append(entry)
			window_damage += entry.damage
			
	recent_damage_history = active_history
	
	# Calculate rolling DPS
	if not recent_damage_history.is_empty():
		current_dps = window_damage / dps_window_seconds
	else:
		current_dps = 0.0
		
	# Auto-heal & reset if idle for 4 seconds
	if idle_timer >= 4.0:
		if attribute_system.current_health < attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH):
			attribute_system.heal(attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
		if total_damage_taken > 0.0:
			total_damage_taken = 0.0
			recent_damage_history.clear()
			current_dps = 0.0
			
	# Update 3D Billboard text
	if dps_label_3d != null:
		if total_damage_taken > 0.0:
			dps_label_3d.text = "DPS: %.1f\nTotal: %d" % [current_dps, int(total_damage_taken)]
			dps_label_3d.visible = true
		else:
			dps_label_3d.text = "Hedef Mankeni\n(Zırh: 30 | MR: 30)"
			dps_label_3d.visible = true

func receive_damage(request: DamageRequest) -> DamageResult:
	idle_timer = 0.0
	var res = super.receive_damage(request)
	
	if res != null and res.final_health_damage > 0.0:
		total_damage_taken += res.final_health_damage
		var current_time = Time.get_ticks_msec() / 1000.0
		recent_damage_history.append({
			"time": current_time,
			"damage": res.final_health_damage
		})
		
	# Ensure dummy never dies (Auto-heal if below 20%)
	var max_hp = attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	if attribute_system.current_health < (max_hp * 0.20):
		attribute_system.heal(max_hp)
		
	return res

func can_move() -> bool:
	return false
