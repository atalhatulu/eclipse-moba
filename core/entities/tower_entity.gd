class_name TowerEntity
extends BaseCombatEntity

## Defensive lane structure providing true sight, heavy projectile fire and target priority

@export var tier: int = 1
@export var team_bounty_gold: int = 150
@export var aggro_range: float = 12.0 # 12.0 meters in 3D world space

var attack_cooldown_timer: float = 0.0
var is_destroyed: bool = false
var range_indicator: MeshInstance3D = null

func set_range_indicator_visible(p_visible: bool) -> void:
	if range_indicator == null:
		range_indicator = find_child("RangeIndicator", true, false) as MeshInstance3D
	if range_indicator != null:
		range_indicator.visible = p_visible

func _ready() -> void:
	super._ready()
	_apply_tower_stats()
	_create_visual_mesh()
	_setup_range_indicator()

func _setup_range_indicator() -> void:
	if range_indicator == null:
		range_indicator = find_child("RangeIndicator", true, false) as MeshInstance3D
	if range_indicator != null:
		range_indicator.visible = false

func _apply_tower_stats() -> void:
	attribute_system.base_health = 2500.0 + (float(tier - 1) * 1000.0)
	attribute_system.base_attack_damage = 120.0 + (float(tier - 1) * 40.0)
	attribute_system.base_armor = 18.0 + (float(tier - 1) * 6.0)
	attribute_system.base_magic_resist = 25.0
	attribute_system.base_attack_range = aggro_range * 100.0
	attribute_system.base_attack_speed = 0.85
	attribute_system.base_move_speed = 0.0 # Immobile
	
	attribute_system.recalculate_all_stats()
	attribute_system.heal(attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))

func _create_visual_mesh() -> void:
	if not has_node("TowerVisual"):
		var root_visual = Node3D.new()
		root_visual.name = "TowerVisual"
		add_child(root_visual)
		
		# 1. Base Pedestal (0.8m)
		var pedestal = MeshInstance3D.new()
		var base_cyl = CylinderMesh.new()
		base_cyl.top_radius = 1.4
		base_cyl.bottom_radius = 1.7
		base_cyl.height = 0.8
		pedestal.mesh = base_cyl
		pedestal.position.y = 0.4
		var stone_mat = StandardMaterial3D.new()
		stone_mat.albedo_color = Color(0.22, 0.24, 0.26, 1.0)
		pedestal.material_override = stone_mat
		root_visual.add_child(pedestal)
		
		# 2. Main Pillar (3.6m -> Top reaches 4.4m)
		var pillar = MeshInstance3D.new()
		var cyl = CylinderMesh.new()
		cyl.top_radius = 0.85
		cyl.bottom_radius = 1.2
		cyl.height = 3.6
		pillar.mesh = cyl
		pillar.position.y = 0.8 + 1.8 # 2.6m
		
		var team_mat = StandardMaterial3D.new()
		if team == TeamDefinitions.Team.RADIANT:
			team_mat.albedo_color = Color(0.18, 0.45, 0.25, 1.0)
			team_mat.metallic = 0.3
		else:
			team_mat.albedo_color = Color(0.48, 0.18, 0.18, 1.0)
			team_mat.metallic = 0.3
		pillar.material_override = team_mat
		root_visual.add_child(pillar)
		
		# 3. Glowing Energy Crystal on Top (Reaches 5.0m)
		var crystal = MeshInstance3D.new()
		var prism = SphereMesh.new()
		prism.radius = 0.50
		prism.height = 1.0
		crystal.mesh = prism
		crystal.position.y = 0.8 + 3.6 + 0.5 # 4.9m
		
		var crystal_mat = StandardMaterial3D.new()
		if team == TeamDefinitions.Team.RADIANT:
			crystal_mat.albedo_color = Color(0.2, 0.95, 0.4, 1.0)
			crystal_mat.emission_enabled = true
			crystal_mat.emission = Color(0.1, 0.85, 0.3, 1.0)
			crystal_mat.emission_energy_multiplier = 2.0
		else:
			crystal_mat.albedo_color = Color(0.95, 0.2, 0.2, 1.0)
			crystal_mat.emission_enabled = true
			crystal_mat.emission = Color(0.85, 0.1, 0.1, 1.0)
			crystal_mat.emission_energy_multiplier = 2.0
		crystal.material_override = crystal_mat
		root_visual.add_child(crystal)
		
		# 4. Effective Attack Range Indicator Ring on Ground (12.0m Radius)
		var range_ring = MeshInstance3D.new()
		range_ring.name = "RangeIndicator"
		var torus = TorusMesh.new()
		torus.inner_radius = aggro_range - 0.12
		torus.outer_radius = aggro_range + 0.12
		torus.rings = 64
		torus.ring_segments = 32
		range_ring.mesh = torus
		range_ring.position.y = 0.05 # Slightly above floor
		range_ring.visible = false
		range_indicator = range_ring
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var r_color = Color(0.2, 0.95, 0.4, 0.40) if team == TeamDefinitions.Team.RADIANT else Color(0.95, 0.2, 0.2, 0.40)
		ring_mat.albedo_color = r_color
		ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		range_ring.material_override = ring_mat
		root_visual.add_child(range_ring)
		
	if not has_node("TowerCollision"):
		var col = CollisionShape3D.new()
		col.name = "TowerCollision"
		var cyl_shape = CylinderShape3D.new()
		cyl_shape.radius = 1.4
		cyl_shape.height = 5.0
		col.shape = cyl_shape
		col.position.y = 2.5
		add_child(col)

func get_crystal_launch_position() -> Vector3:
	return global_position + Vector3(0.0, 4.9, 0.0)

func _physics_process(delta: float) -> void:
	if not is_alive() or is_destroyed:
		return
		
	if attack_cooldown_timer > 0.0:
		attack_cooldown_timer -= delta
		
	_update_target()
	
	if current_target != null and attack_cooldown_timer <= 0.0:
		_execute_tower_attack(current_target)

func _update_target() -> void:
	# Check if current target is still valid and in range
	if current_target != null:
		if not is_instance_valid(current_target) or not current_target.is_alive() or global_position.distance_to(current_target.global_position) > aggro_range:
			current_target = null
			
	if current_target == null:
		current_target = _find_highest_priority_target()

func _find_highest_priority_target() -> BaseCombatEntity:
	var nodes = get_tree().get_nodes_in_group("combat_entities") if get_tree() != null else []
	var closest_creep: BaseCombatEntity = null
	var min_creep_dist: float = aggro_range
	var closest_hero: BaseCombatEntity = null
	var min_hero_dist: float = aggro_range
	
	for n in nodes:
		if n is BaseCombatEntity and n != self and n.is_alive() and n.team != team and n.team != TeamDefinitions.Team.NEUTRAL:
			var d = global_position.distance_to(n.global_position)
			if d <= aggro_range:
				if n is CreepEntity:
					if d < min_creep_dist:
						min_creep_dist = d
						closest_creep = n
				elif n is HeroEntity:
					if d < min_hero_dist:
						min_hero_dist = d
						closest_hero = n
						
	# Priority: Creeps first to protect heroes, then heroes
	if closest_creep != null:
		return closest_creep
	return closest_hero

func _execute_tower_attack(target: BaseCombatEntity) -> DamageResult:
	var atk_speed = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	attack_cooldown_timer = 1.0 / maxf(atk_speed, 0.1)
	
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var req = DamageRequest.create_basic_attack(self, target, ad)
	
	# Launch Tower Projectile directly from top Crystal
	if is_inside_tree():
		var proj_script = load("res://scenes/effects/basic_attack_projectile_3d.gd")
		if proj_script != null:
			var proj = proj_script.new()
			get_tree().root.add_child(proj)
			var p_color = Color(0.2, 0.95, 0.4) if team == TeamDefinitions.Team.RADIANT else Color(0.95, 0.2, 0.2)
			var launch_pos = get_crystal_launch_position()
			proj.setup(self, target, req, p_color, 26.0, 0.5, launch_pos)
		else:
			return target.receive_damage(req)
	else:
		return target.receive_damage(req)
		
	return null

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	is_destroyed = true
	
	# Award team gold to enemy heroes
	var enemy_team = TeamDefinitions.Team.DIRE if team == TeamDefinitions.Team.RADIANT else TeamDefinitions.Team.RADIANT
	var nodes = get_tree().get_nodes_in_group("combat_entities") if get_tree() != null else []
	for n in nodes:
		if n is HeroEntity and n.team == enemy_team and n.inventory_manager != null:
			n.inventory_manager.add_gold(team_bounty_gold * tier)
			
	GameEvents.combat_log_generated.emit("KULE YIKILDI: %s yok edildi! %s takımına %dg altın verildi." % [entity_name, ("Radiant" if enemy_team == TeamDefinitions.Team.RADIANT else "Dire"), team_bounty_gold * tier])
	
	# Disable collision
	if has_node("TowerCollision"):
		var col = get_node("TowerCollision") as CollisionShape3D
		col.set_deferred("disabled", true)
		
	visible = false

func can_move() -> bool:
	return false
