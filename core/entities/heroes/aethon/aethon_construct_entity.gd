class_name AethonConstructEntity
extends BaseCombatEntity

## 3D Battlefield Construct Entity summoned by Aethon (Guardian, Cannon, Siege)
## Features distinct procedural chassis, independent AI targeting, combat stats, health bars, and VFX/SFX.

enum ConstructType {
	GUARDIAN, # Melee frontline tank with high armor and ground slam
	CANNON,   # Ranged arcane mortar with rotating barrel and explosive shots
	SIEGE     # Massive composite boss unit with cleaving slams
}

signal construct_morphed(new_type: ConstructType)
signal construct_attacked(target: BaseCombatEntity, damage: float)
signal construct_expired()

@export var construct_type: ConstructType = ConstructType.GUARDIAN
var summoner_hero: HeroEntity = null

var lifespan: float = 15.0
var life_timer: float = 15.0
var attack_dmg: float = 40.0
var attack_cooldown_max: float = 1.2
var attack_cooldown_cur: float = 0.0

var is_overcharged: bool = false
var overcharge_timer: float = 0.0

# 3D Visual Nodes
var visual_root: Node3D = null
var chassis_mesh: MeshInstance3D = null
var weapon_mesh: MeshInstance3D = null
var core_glow: MeshInstance3D = null

func _ready() -> void:
	entity_name = "Arcane Construct"
	lifecycle_state = LifecycleState.ALIVE
	super._ready()
	
	_build_visuals()
	_setup_collision()

func setup_construct(owner_hero: HeroEntity, type: ConstructType, hp: float, dmg: float, duration: float = 15.0) -> void:
	summoner_hero = owner_hero
	construct_type = type
	lifespan = duration
	life_timer = duration
	attack_dmg = dmg
	
	if owner_hero != null:
		team = owner_hero.team
		if not owner_hero.died.is_connected(_on_owner_died):
			owner_hero.died.connect(_on_owner_died)
			
	# Configure AttributeSystem & Health
	if attribute_system == null:
		attribute_system = AttributeSystem.new()
		attribute_system.name = "AttributeSystem"
		add_child(attribute_system)
		attribute_system._ready()
		
	attribute_system.base_health = hp
	attribute_system.base_attack_damage = dmg
	attribute_system.base_armor = 25.0 if type == ConstructType.GUARDIAN else (10.0 if type == ConstructType.CANNON else 40.0)
	attribute_system.base_magic_resist = 20.0
	attribute_system.base_move_speed = 0.0 # Stationary fortifications
	attribute_system.recalculate_all_stats()
	attribute_system.current_health = hp
	
	_update_visual_appearance()
	
	# Spawn visual flare / scale-in tween
	if visual_root != null:
		visual_root.scale = Vector3(0.1, 0.1, 0.1)
		var tw = create_tween()
		if tw != null:
			tw.tween_property(visual_root, "scale", Vector3.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("AETHON: %s YAPISI OLUŞTURULDU (HP: %d, Hasar: %d)" % [get_type_name(), int(hp), int(dmg)])

func get_type_name() -> String:
	match construct_type:
		ConstructType.GUARDIAN: return "MUHAFIZ"
		ConstructType.CANNON: return "BÜYÜ TOPU"
		ConstructType.SIEGE: return "BÜYÜK KUŞATMA"
	return "YAPI"

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CylinderShape3D.new()
		shape.radius = 0.65 if construct_type != ConstructType.SIEGE else 1.2
		shape.height = 1.6 if construct_type != ConstructType.SIEGE else 2.5
		col.shape = shape
		col.position.y = shape.height * 0.5
		add_child(col)

func _build_visuals() -> void:
	visual_root = Node3D.new()
	visual_root.name = "ConstructVisual"
	add_child(visual_root)
	
	chassis_mesh = MeshInstance3D.new()
	chassis_mesh.name = "Chassis"
	visual_root.add_child(chassis_mesh)
	
	weapon_mesh = MeshInstance3D.new()
	weapon_mesh.name = "Weapon"
	visual_root.add_child(weapon_mesh)
	
	core_glow = MeshInstance3D.new()
	core_glow.name = "CoreGlow"
	visual_root.add_child(core_glow)
	
	_update_visual_appearance()

func _update_visual_appearance() -> void:
	if chassis_mesh == null:
		return
		
	match construct_type:
		ConstructType.GUARDIAN:
			# Heavy Brass Frontline Golem
			entity_name = "Muhafız Yapı"
			var box = BoxMesh.new()
			box.size = Vector3(0.9, 1.4, 0.7)
			chassis_mesh.mesh = box
			chassis_mesh.position.y = 0.7
			
			var mat = StandardMaterial3D.new()
			mat.albedo_color = Color(0.35, 0.45, 0.55, 1.0) # Steel Slate Blue
			mat.metallic = 0.8
			mat.roughness = 0.3
			chassis_mesh.material_override = mat
			
			# Heavy Shield
			var s_box = BoxMesh.new()
			s_box.size = Vector3(0.8, 1.1, 0.15)
			weapon_mesh.mesh = s_box
			weapon_mesh.position = Vector3(0.0, 0.65, 0.45)
			var s_mat = StandardMaterial3D.new()
			s_mat.albedo_color = Color(0.85, 0.65, 0.25, 1.0) # Gold Ingot Trim
			s_mat.metallic = 0.9
			weapon_mesh.material_override = s_mat
			
			# Cyan Golem Core
			var s_mesh = SphereMesh.new()
			s_mesh.radius = 0.18
			s_mesh.height = 0.36
			core_glow.mesh = s_mesh
			core_glow.position = Vector3(0.0, 0.9, 0.2)
			var c_mat = StandardMaterial3D.new()
			c_mat.albedo_color = Color(0.2, 0.9, 1.0)
			c_mat.emission_enabled = true
			c_mat.emission = Color(0.2, 0.9, 1.0)
			core_glow.material_override = c_mat
			
		ConstructType.CANNON:
			# Arcane Mortar Turret
			entity_name = "Büyü Topu Yapısı"
			var cyl = CylinderMesh.new()
			cyl.top_radius = 0.55
			cyl.bottom_radius = 0.75
			cyl.height = 0.6
			chassis_mesh.mesh = cyl
			chassis_mesh.position.y = 0.3
			
			var mat = StandardMaterial3D.new()
			mat.albedo_color = Color(0.25, 0.30, 0.40, 1.0)
			mat.metallic = 0.7
			chassis_mesh.material_override = mat
			
			# Rotating Mortar Barrel
			var bar = CylinderMesh.new()
			bar.top_radius = 0.22
			bar.bottom_radius = 0.26
			bar.height = 0.9
			weapon_mesh.mesh = bar
			weapon_mesh.position = Vector3(0.0, 0.7, 0.0)
			weapon_mesh.rotation.x = -0.45 # Angled mortar
			var b_mat = StandardMaterial3D.new()
			b_mat.albedo_color = Color(0.85, 0.45, 0.15, 1.0) # Magma Arcane Bronze
			b_mat.metallic = 0.85
			weapon_mesh.material_override = b_mat
			
			# Glowing Orb atop
			var s_mesh = SphereMesh.new()
			s_mesh.radius = 0.20
			s_mesh.height = 0.40
			core_glow.mesh = s_mesh
			core_glow.position = Vector3(0.0, 0.7, 0.0)
			var c_mat = StandardMaterial3D.new()
			c_mat.albedo_color = Color(1.0, 0.5, 0.2)
			c_mat.emission_enabled = true
			c_mat.emission = Color(1.0, 0.5, 0.2)
			core_glow.material_override = c_mat
			
		ConstructType.SIEGE:
			# Colossal Composite Siege Engine
			entity_name = "Büyük Kuşatma Yapısı"
			var box = BoxMesh.new()
			box.size = Vector3(1.8, 2.2, 1.6)
			chassis_mesh.mesh = box
			chassis_mesh.position.y = 1.1
			
			var mat = StandardMaterial3D.new()
			mat.albedo_color = Color(0.18, 0.24, 0.32, 1.0) # Obsidian Dark Alloy
			mat.metallic = 0.9
			mat.roughness = 0.2
			chassis_mesh.material_override = mat
			
			# Dual Cleaving Arm Blades
			var w_box = BoxMesh.new()
			w_box.size = Vector3(2.4, 0.4, 0.6)
			weapon_mesh.mesh = w_box
			weapon_mesh.position = Vector3(0.0, 1.2, 0.6)
			var w_mat = StandardMaterial3D.new()
			w_mat.albedo_color = Color(1.0, 0.8, 0.2, 1.0) # Radiant Solar Gold
			w_mat.metallic = 0.95
			weapon_mesh.material_override = w_mat
			
			# Massive Blazing Sun Core
			var s_mesh = SphereMesh.new()
			s_mesh.radius = 0.42
			s_mesh.height = 0.84
			core_glow.mesh = s_mesh
			core_glow.position = Vector3(0.0, 1.3, 0.2)
			var c_mat = StandardMaterial3D.new()
			c_mat.albedo_color = Color(1.0, 0.85, 0.3)
			c_mat.emission_enabled = true
			c_mat.emission = Color(1.0, 0.85, 0.3)
			core_glow.material_override = c_mat

func morph_to_type(new_type: ConstructType) -> void:
	construct_type = new_type
	_update_visual_appearance()
	construct_morphed.emit(new_type)
	
	# Visual Morph Shockwave / Scale Punch
	if visual_root != null:
		var tw = create_tween()
		if tw != null:
			tw.tween_property(visual_root, "scale", Vector3(1.25, 1.25, 1.25), 0.12).set_trans(Tween.TRANS_QUAD)
			tw.tween_property(visual_root, "scale", Vector3.ONE, 0.18).set_trans(Tween.TRANS_BACK)

func apply_overcharge(speed_mult: float, duration: float) -> void:
	is_overcharged = true
	overcharge_timer = duration
	attack_cooldown_max = 1.2 / maxf(1.0, speed_mult)
	
	if core_glow != null and core_glow.material_override is StandardMaterial3D:
		(core_glow.material_override as StandardMaterial3D).emission_energy_multiplier = 2.5
		
	# Overcharge Floating Pulse
	var tw = create_tween()
	if tw != null:
		tw.tween_property(self, "position:y", position.y + 0.3, 0.15).set_trans(Tween.TRANS_QUAD)
		tw.tween_property(self, "position:y", position.y, 0.15).set_trans(Tween.TRANS_QUAD)

func _physics_process(delta: float) -> void:
	if not is_alive():
		return
		
	# 1. Lifespan Tickdown
	life_timer -= delta
	if life_timer <= 0.0:
		_expire_construct()
		return
		
	# 2. Overcharge Tickdown
	if is_overcharged:
		overcharge_timer -= delta
		if overcharge_timer <= 0.0:
			is_overcharged = false
			attack_cooldown_max = 1.2
			if core_glow != null and core_glow.material_override is StandardMaterial3D:
				(core_glow.material_override as StandardMaterial3D).emission_energy_multiplier = 1.0
				
	# 3. Combat & Attack Cycle AI
	if attack_cooldown_cur > 0.0:
		attack_cooldown_cur -= delta
	else:
		_execute_ai_attack_cycle()

func _execute_ai_attack_cycle() -> void:
	var target = _find_target()
	if target == null or not is_instance_valid(target) or not target.is_alive():
		return
		
	attack_cooldown_cur = attack_cooldown_max
	
	match construct_type:
		ConstructType.GUARDIAN:
			_perform_guardian_melee_slam(target)
		ConstructType.CANNON:
			_perform_cannon_mortar_shot(target)
		ConstructType.SIEGE:
			_perform_siege_cleave_slam(target)

func _find_target() -> BaseCombatEntity:
	var tree = get_tree()
	if tree == null:
		return null
		
	var my_pos = global_position if is_inside_tree() else position
	var max_range = 3.5 if construct_type == ConstructType.GUARDIAN else (9.0 if construct_type == ConstructType.CANNON else 5.0)
	var entities = tree.get_nodes_in_group("combat_entities")
	
	var best_target: BaseCombatEntity = null
	var best_score: float = 999999.0
	
	for ent in entities:
		if ent is BaseCombatEntity and is_instance_valid(ent) and ent != self and ent != summoner_hero:
			if ent.is_alive() and ent.is_targetable and TargetRelationSystem.is_valid_basic_attack_target(self, ent):
				var e_pos = ent.global_position if ent.is_inside_tree() else ent.position
				var dist = my_pos.distance_to(e_pos)
				if dist <= max_range:
					var hp_pct = 1.0
					if ent.attribute_system != null:
						hp_pct = ent.attribute_system.current_health / maxf(1.0, ent.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
					var is_creep = (ent is CreepEntity)
					var score = dist + (hp_pct * 8.0) - (30.0 if is_creep else 0.0)
					if score < best_score:
						best_score = score
						best_target = ent
						
	return best_target

func _perform_guardian_melee_slam(target: BaseCombatEntity) -> void:
	_rotate_towards(target.global_position if target.is_inside_tree() else target.position)
	
	# Punch/Recoil Tween
	if visual_root != null:
		var tw = create_tween()
		if tw != null:
			tw.tween_property(visual_root, "position:z", 0.3, 0.08).set_trans(Tween.TRANS_QUAD)
			tw.tween_property(visual_root, "position:z", 0.0, 0.15).set_trans(Tween.TRANS_QUAD)
		
	var req = DamageRequest.create_basic_attack(self, target, attack_dmg)
	req.source_name = "Muhafız Yapı"
	var res = target.receive_damage(req)
	construct_attacked.emit(target, attack_dmg)
	
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.damage_dealt.emit(res, self, target)

func _perform_cannon_mortar_shot(target: BaseCombatEntity) -> void:
	var t_pos = target.global_position if target.is_inside_tree() else target.position
	_rotate_towards(t_pos)
	
	# Recoil Animation on Barrel
	if weapon_mesh != null:
		var tw = create_tween()
		if tw != null:
			tw.tween_property(weapon_mesh, "position:y", 0.55, 0.06).set_trans(Tween.TRANS_QUAD)
			tw.tween_property(weapon_mesh, "position:y", 0.70, 0.18).set_trans(Tween.TRANS_BACK)
		
	var req = DamageRequest.create_ability_damage(self, target, attack_dmg, DamageRequest.DamageType.MAGICAL, "Büyü Topu")
	
	# Instant Headless or Spawn Projectile
	if is_inside_tree():
		var proj_script = load("res://scenes/effects/basic_attack_projectile_3d.gd")
		if proj_script != null:
			var proj = proj_script.new()
			get_tree().root.add_child(proj)
			proj.setup(self, target, req, Color(1.0, 0.55, 0.2), 24.0, 0.4)
	else:
		var res = target.receive_damage(req)
		construct_attacked.emit(target, attack_dmg)
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.damage_dealt.emit(res, self, target)

func _perform_siege_cleave_slam(target: BaseCombatEntity) -> void:
	var t_pos = target.global_position if target.is_inside_tree() else target.position
	_rotate_towards(t_pos)
	
	# Heavy Dual Slam Animation
	if visual_root != null:
		var tw = create_tween()
		if tw != null:
			tw.tween_property(visual_root, "position:y", 0.4, 0.10).set_trans(Tween.TRANS_QUAD)
			tw.tween_property(visual_root, "position:y", 0.0, 0.14).set_trans(Tween.TRANS_BOUNCE)
		
	var req = DamageRequest.create_ability_damage(self, target, attack_dmg, DamageRequest.DamageType.PHYSICAL, "Kuşatma Darbesi")
	var res = target.receive_damage(req)
	construct_attacked.emit(target, attack_dmg)
	
	# 3.5m Cleave AoE to other adjacent enemies
	var tree = get_tree()
	if tree != null:
		var my_pos = global_position if is_inside_tree() else position
		for ent in tree.get_nodes_in_group("combat_entities"):
			if ent is BaseCombatEntity and ent != self and ent != target and ent.is_alive() and TargetRelationSystem.is_valid_basic_attack_target(self, ent):
				var ep = ent.global_position if ent.is_inside_tree() else ent.position
				if my_pos.distance_to(ep) <= 3.5:
					var cleave_req = DamageRequest.create_ability_damage(self, ent, attack_dmg * 0.50, DamageRequest.DamageType.PHYSICAL, "Kuşatma Yankısı")
					ent.receive_damage(cleave_req)

func _rotate_towards(t_pos: Vector3) -> void:
	if not is_inside_tree():
		return
	var dir = t_pos - global_position
	dir.y = 0.0
	if dir.length_squared() > 0.01:
		rotation.y = atan2(dir.x, dir.z)

func _expire_construct() -> void:
	construct_expired.emit()
	_on_death("Lifespan Expiry")

func _on_death(_killer_name: String) -> void:
	lifecycle_state = LifecycleState.DEAD
	is_targetable = false
	
	# Disintegration Death VFX Tween
	if visual_root != null:
		var tw = create_tween()
		if tw != null:
			tw.tween_property(visual_root, "scale", Vector3(0.01, 0.01, 0.01), 0.20).set_trans(Tween.TRANS_QUAD)
			tw.tween_callback(queue_free)
		else:
			queue_free()
	else:
		queue_free()

func _on_owner_died(_hero: BaseCombatEntity, _killer: String) -> void:
	_expire_construct()
