class_name CreepEntity
extends BaseCombatEntity

## Intelligent Lane Minion with Task 09 Combat Pipeline, Siege Tower Bonus, Hero Aggro Call, and Last-Hit Economics

enum CreepType {
	MELEE,
	RANGED,
	SIEGE
}

@export var creep_type: CreepType = CreepType.MELEE
@export var gold_bounty: int = 38
@export var xp_bounty: int = 60

var waypoints: Array[Vector3] = []
var current_waypoint_idx: int = 0
var aggro_target: BaseCombatEntity = null
var aggro_range: float = 14.0 # 14 meters in 3D
var attack_timer: float = 0.0
var aggro_switch_cooldown: float = 0.0
var hero_aggro_timer: float = 0.0 # Time remaining pursuing a hero before reverting

var nav_agent: NavigationAgent3D = null

static var active_creeps: Array[CreepEntity] = []

func _init() -> void:
	active_creeps.append(self)

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		active_creeps.erase(self)

# Anti-stuck & Obstacle avoidance state
var _stuck_timer: float = 0.0
var _slide_offset_dir: float = 1.0 # 1.0 = right, -1.0 = left

func _ready() -> void:
	super._ready()
	_apply_creep_archetype()
	_create_visual_mesh()
	_setup_nav_agent()
	_slide_offset_dir = 1.0 if (randi() % 2 == 0) else -1.0

func _apply_creep_archetype() -> void:
	attribute_system.base_strength = 0.0
	attribute_system.strength_growth = 0.0
	attribute_system.base_agility = 0.0
	attribute_system.agility_growth = 0.0
	attribute_system.base_intelligence = 0.0
	attribute_system.intelligence_growth = 0.0
	
	match creep_type:
		CreepType.MELEE:
			attribute_system.base_health = 550.0
			attribute_system.base_attack_damage = 22.0
			attribute_system.base_armor = 2.0
			attribute_system.base_magic_resist = 0.0
			attribute_system.base_attack_range = 160.0 # 1.6m Melee
			attribute_system.base_attack_speed = 0.90
			attribute_system.base_move_speed = 325.0
			gold_bounty = 38
			xp_bounty = 60
		CreepType.RANGED:
			attribute_system.base_health = 300.0
			attribute_system.base_attack_damage = 32.0
			attribute_system.base_armor = 0.0
			attribute_system.base_magic_resist = 0.0
			attribute_system.base_attack_range = 450.0 # 4.5m Ranged
			attribute_system.base_attack_speed = 0.80
			attribute_system.base_move_speed = 290.0
			gold_bounty = 45
			xp_bounty = 75
		CreepType.SIEGE:
			attribute_system.base_health = 800.0
			attribute_system.base_attack_damage = 45.0 # Extra 1.5x against towers = 67.5
			attribute_system.base_armor = 5.0
			attribute_system.base_magic_resist = 0.0
			attribute_system.base_attack_range = 700.0 # 7.0m Siege Range
			attribute_system.base_attack_speed = 0.65
			attribute_system.base_move_speed = 290.0
			gold_bounty = 70
			xp_bounty = 110
			
	attribute_system.recalculate_all_stats()
	attribute_system.heal(attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))

func _create_visual_mesh() -> void:
	if not has_node("CreepVisual"):
		var mesh_inst = MeshInstance3D.new()
		mesh_inst.name = "CreepVisual"
		
		var mat = StandardMaterial3D.new()
		if team == TeamDefinitions.Team.RADIANT:
			mat.albedo_color = Color(0.2, 0.85, 0.35, 1.0)
			mat.emission_enabled = true
			mat.emission = Color(0.1, 0.5, 0.2, 1.0)
			mat.emission_energy_multiplier = 0.5
		elif team == TeamDefinitions.Team.DIRE:
			mat.albedo_color = Color(0.95, 0.25, 0.25, 1.0)
			mat.emission_enabled = true
			mat.emission = Color(0.85, 0.2, 0.2, 1.0)
			mat.emission_energy_multiplier = 0.7
		else:
			mat.albedo_color = Color(0.85, 0.75, 0.3, 1.0)
			
		if creep_type == CreepType.MELEE:
			var capsule = CapsuleMesh.new()
			capsule.radius = 0.32
			capsule.height = 1.0
			mesh_inst.mesh = capsule
			mesh_inst.position.y = 0.50
			mesh_inst.material_override = mat
			add_child(mesh_inst)
		elif creep_type == CreepType.RANGED:
			var cyl = CylinderMesh.new()
			cyl.top_radius = 0.22
			cyl.bottom_radius = 0.35
			cyl.height = 0.95
			mesh_inst.mesh = cyl
			mesh_inst.position.y = 0.475
			mesh_inst.material_override = mat
			add_child(mesh_inst)
			
			# Floating Arcane Orb on Top of Mage
			var orb = MeshInstance3D.new()
			var sphere = SphereMesh.new()
			sphere.radius = 0.16
			sphere.height = 0.32
			orb.mesh = sphere
			orb.position = Vector3(0, 1.08, 0)
			
			var orb_mat = StandardMaterial3D.new()
			orb_mat.albedo_color = Color(0.4, 0.9, 1.0) if team == TeamDefinitions.Team.RADIANT else Color(1.0, 0.35, 0.35)
			orb_mat.emission_enabled = true
			orb_mat.emission = orb_mat.albedo_color
			orb_mat.emission_energy_multiplier = 1.5
			orb.material_override = orb_mat
			add_child(orb)
		elif creep_type == CreepType.SIEGE:
			# Siege Engine: Heavy Armored Box Chassis + Cannon Cylinder
			var box = BoxMesh.new()
			box.size = Vector3(0.9, 0.65, 1.1)
			mesh_inst.mesh = box
			mesh_inst.position.y = 0.35
			mesh_inst.material_override = mat
			add_child(mesh_inst)
			
			var cannon = MeshInstance3D.new()
			var c_mesh = CylinderMesh.new()
			c_mesh.top_radius = 0.18
			c_mesh.bottom_radius = 0.22
			c_mesh.height = 0.8
			cannon.mesh = c_mesh
			cannon.position = Vector3(0, 0.65, 0.2)
			cannon.rotation_degrees = Vector3(-35, 0, 0)
			
			var c_mat = StandardMaterial3D.new()
			c_mat.albedo_color = Color(0.15, 0.15, 0.18, 1.0)
			c_mat.metallic = 0.8
			cannon.material_override = c_mat
			add_child(cannon)

	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.35
		shape.height = 1.0
		col.shape = shape
		col.position.y = 0.50
		add_child(col)

func _setup_nav_agent() -> void:
	if not has_node("NavigationAgent3D"):
		nav_agent = NavigationAgent3D.new()
		nav_agent.name = "NavigationAgent3D"
		nav_agent.path_desired_distance = 1.8
		nav_agent.target_desired_distance = 1.8
		add_child(nav_agent)
	else:
		nav_agent = get_node("NavigationAgent3D") as NavigationAgent3D

func _physics_process(delta: float) -> void:
	if not is_alive() or not can_move():
		return
		
	if attack_timer > 0.0:
		attack_timer -= delta
	if aggro_switch_cooldown > 0.0:
		aggro_switch_cooldown -= delta
	if hero_aggro_timer > 0.0:
		hero_aggro_timer -= delta
		if hero_aggro_timer <= 0.0 and aggro_target is HeroEntity:
			aggro_target = null # Revert back to lane priority
		
	# 1. Aggro Target Evaluation
	if aggro_target == null or not is_instance_valid(aggro_target) or not aggro_target.is_alive():
		aggro_target = _evaluate_aggro_target()
	elif aggro_switch_cooldown <= 0.0 and hero_aggro_timer <= 0.0:
		var better_target = _evaluate_aggro_target()
		if better_target != null and better_target != aggro_target:
			aggro_target = better_target
			aggro_switch_cooldown = 1.2
			
	# 2. Combat / Pursuit with Aggro Target
	if aggro_target != null and is_instance_valid(aggro_target) and aggro_target.is_alive():
		var dist = global_position.distance_to(aggro_target.global_position)
		var atk_range = get_attack_range()
		var combat_stop_dist = atk_range if creep_type == CreepType.MELEE else (atk_range * 0.90)
		
		if dist <= combat_stop_dist:
			velocity = Vector3.ZERO
			_rotate_towards(aggro_target.global_position, delta)
			if attack_timer <= 0.0 and can_attack():
				var atk_speed = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
				attack_timer = 1.0 / maxf(atk_speed, 0.2)
				execute_basic_attack(aggro_target)
			return
		elif dist <= (aggro_range * 1.6):
			var base_dir = (aggro_target.global_position - global_position)
			base_dir.y = 0.0
			var move_dir = base_dir.normalized()
			
			var sep = _calculate_separation_force()
			move_dir = (move_dir + (sep * 0.5)).normalized()
			
			var speed = attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED) * 0.022
			velocity = move_dir * speed
			_rotate_towards(aggro_target.global_position, delta)
			move_and_slide()
			_check_stuck_recovery(delta)
			return
		else:
			aggro_target = null
			_realign_to_nearest_forward_waypoint()
			
	# 3. Waypoint Following (Marching Lane)
	if current_waypoint_idx < waypoints.size():
		var target_wp = waypoints[current_waypoint_idx]
		var dist_to_wp = global_position.distance_to(target_wp)
		
		if dist_to_wp < 3.0 or _has_passed_waypoint(target_wp):
			current_waypoint_idx += 1
		else:
			var base_dir = (target_wp - global_position)
			base_dir.y = 0.0
			var move_dir = base_dir.normalized()
			
			var sep = _calculate_separation_force()
			var avoidance = _calculate_obstacle_deflection(move_dir)
			move_dir = (move_dir + (sep * 0.45) + (avoidance * 0.6)).normalized()
			
			var speed_mult = 0.022
			if creep_type == CreepType.RANGED and _is_friendly_melee_ahead():
				speed_mult = 0.019
				
			var speed = attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED) * speed_mult
			velocity = move_dir * speed
			_rotate_towards(global_position + move_dir, delta)
			move_and_slide()
			_check_stuck_recovery(delta)
	else:
		velocity = Vector3.ZERO

func execute_basic_attack(target: BaseCombatEntity) -> DamageResult:
	if not TargetRelationSystem.is_valid_basic_attack_target(self, target):
		return null
	if not can_attack():
		return null
		
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.attack_started.emit(self, target)
			
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 22.0
	
	# Siege Creep 1.5x Bonus Damage against Structures
	if creep_type == CreepType.SIEGE and (target is TowerEntity or target is ObjectiveEntity):
		ad *= 1.5
		
	var req = DamageRequest.create_basic_attack(self, target, ad)
	req.source_name = entity_name
	
	attack_cooldown = get_attack_interval()
	_play_attack_motion(target, req)
	
	var res: DamageResult = null
	if get_attack_range() <= 3.5 or not is_inside_tree():
		res = target.receive_damage(req)
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.attack_hit.emit(self, target, res)
			GameEvents.attack_landed.emit(self, target, res)
			GameEvents.damage_dealt.emit(res, self, target)
		basic_attack_performed.emit(target, res)
		
	return res

func _is_friendly_melee_ahead() -> bool:
	var nodes = get_tree().get_nodes_in_group("combat_entities") if get_tree() != null else []
	for n in nodes:
		if n is CreepEntity and n != self and is_instance_valid(n) and n.is_alive() and n.team == team:
			if (n as CreepEntity).creep_type == CreepType.MELEE:
				var dist = global_position.distance_to(n.global_position)
				if dist < 3.5:
					var forward_sign = 1.0 if team == TeamDefinitions.Team.RADIANT else -1.0
					if (n.global_position.x - global_position.x) * forward_sign > 0.0:
						return true
	return false

func _calculate_separation_force() -> Vector3:
	var sep_force = Vector3.ZERO
	var nodes = get_tree().get_nodes_in_group("combat_entities") if get_tree() != null else []
	
	for n in nodes:
		if n is BaseCombatEntity and n != self and is_instance_valid(n) and n.is_alive():
			var offset = global_position - n.global_position
			offset.y = 0.0
			var dist = offset.length()
			if dist > 0.01 and dist < 1.6:
				var push_weight = (1.6 - dist) / 1.6
				sep_force += offset.normalized() * push_weight
				
	return sep_force

func _calculate_obstacle_deflection(forward_dir: Vector3) -> Vector3:
	if is_on_wall():
		return Vector3(-forward_dir.z, 0, forward_dir.x) * _slide_offset_dir
	return Vector3.ZERO

func _check_stuck_recovery(delta: float) -> void:
	if get_real_velocity().length() < 0.2:
		_stuck_timer += delta
		if _stuck_timer > 0.35:
			_slide_offset_dir = -_slide_offset_dir
			_stuck_timer = 0.0
	else:
		_stuck_timer = maxf(0.0, _stuck_timer - delta)

func _has_passed_waypoint(wp: Vector3) -> bool:
	var c_pos = global_position if (global_position != Vector3.ZERO or is_inside_tree()) else position
	if team == TeamDefinitions.Team.RADIANT:
		return c_pos.x > (wp.x + 1.0)
	elif team == TeamDefinitions.Team.DIRE:
		return c_pos.x < (wp.x - 1.0)
	return false

func _realign_to_nearest_forward_waypoint() -> void:
	if waypoints.is_empty():
		return
	var best_idx = 0
	var min_dist = 99999.0
	for i in range(waypoints.size()):
		var wp = waypoints[i]
		if not _has_passed_waypoint(wp):
			var d = global_position.distance_to(wp)
			if d < min_dist:
				min_dist = d
				best_idx = i
	current_waypoint_idx = best_idx

func _rotate_towards(target_pos: Vector3, delta: float) -> void:
	var dir = target_pos - global_position
	dir.y = 0.0
	if dir.length_squared() > 0.01:
		var target_rot_y = atan2(dir.x, dir.z)
		rotation.y = lerp_angle(rotation.y, target_rot_y, 14.0 * delta)

func is_enemy_with(other: BaseCombatEntity) -> bool:
	if other == null or other == self or not is_instance_valid(other):
		return false
	if other.team == TeamDefinitions.Team.NEUTRAL or other is NeutralCreepEntity:
		return false # Koridor minyonları orman yaratıklarına karışmaz
	return team != other.team

# ==============================================================================
# AGGRO PRIORITY EVALUATION
# ==============================================================================
func _evaluate_aggro_target() -> BaseCombatEntity:
	# Priority 1: Retaliate against unit that attacked this creep
	if last_attacker != null and is_instance_valid(last_attacker) and last_attacker.is_alive():
		if is_enemy_with(last_attacker) and global_position.distance_to(last_attacker.global_position) <= aggro_range:
			return last_attacker
			
	var nodes = get_tree().get_nodes_in_group("combat_entities") if get_tree() != null else []
	var closest_hero: BaseCombatEntity = null
	var closest_creep: BaseCombatEntity = null
	var closest_tower: BaseCombatEntity = null
	
	var min_hero_dist: float = aggro_range
	var min_creep_dist: float = aggro_range
	var min_tower_dist: float = aggro_range
	
	for n in nodes:
		if n is BaseCombatEntity and n != self and is_instance_valid(n) and n.is_alive() and is_enemy_with(n):
			var d = global_position.distance_to(n.global_position)
			if d <= aggro_range:
				if n is HeroEntity and d < min_hero_dist:
					min_hero_dist = d
					closest_hero = n
				elif n is CreepEntity and not (n is NeutralCreepEntity) and d < min_creep_dist:
					min_creep_dist = d
					closest_creep = n
				elif (n is TowerEntity or n is ObjectiveEntity) and d < min_tower_dist:
					min_tower_dist = d
					closest_tower = n
					
	# Priority 2: Nearby enemy creep / minion
	if closest_creep != null:
		return closest_creep
		
	# Priority 3: Nearby enemy hero
	if closest_hero != null:
		return closest_hero
		
	# Priority 4: Enemy tower in lane
	if closest_tower != null:
		return closest_tower
		
	return null

func receive_damage(request: DamageRequest) -> DamageResult:
	if request.attacker is BaseCombatEntity and is_instance_valid(request.attacker) and request.attacker.is_alive():
		last_attacker = request.attacker as BaseCombatEntity
		aggro_target = last_attacker
		if last_attacker is HeroEntity:
			hero_aggro_timer = 2.5
		# Call for help to nearby friendly creeps
		_call_nearby_creeps_help(last_attacker)
	return super.receive_damage(request)

func _call_nearby_creeps_help(attacker_unit: BaseCombatEntity) -> void:
	for c in active_creeps:
		if c != self and is_instance_valid(c) and c.is_alive() and c.team == team:
			var self_pos = global_position if is_inside_tree() else position
			var c_pos = c.global_position if c.is_inside_tree() else c.position
			if self_pos.distance_to(c_pos) <= 8.0:
				if c.aggro_target == null or c.aggro_target is TowerEntity:
					c.aggro_target = attacker_unit
					if attacker_unit is HeroEntity:
						c.hero_aggro_timer = 2.5

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	
	# Find killer entity node
	var killer_hero: HeroEntity = null
	if last_attacker is HeroEntity and is_instance_valid(last_attacker) and last_attacker.is_alive():
		killer_hero = last_attacker
	else:
		for h in HeroEntity.active_heroes:
			if is_instance_valid(h) and h.is_alive():
				if h.entity_name == killer_name or h.entity_name.begins_with(killer_name) or killer_name.begins_with(h.entity_name):
					killer_hero = h
					break
				
	# Last Hit Economics
	if killer_hero != null and killer_hero.team != team:
		# Killer Hero receives Gold and XP
		if killer_hero.inventory_manager != null:
			killer_hero.inventory_manager.add_gold(gold_bounty)
		killer_hero.attribute_system.add_xp(xp_bounty)
		
		# Nearby allied heroes to killer also receive 50% assist XP
		for h in HeroEntity.active_heroes:
			if is_instance_valid(h) and h.is_alive() and h != killer_hero and h.team == killer_hero.team:
				var h_pos = h.global_position if h.is_inside_tree() else h.position
				var c_pos = global_position if is_inside_tree() else position
				if c_pos.distance_to(h_pos) <= 15.0:
					h.attribute_system.add_xp(int(float(xp_bounty) * 0.50))
					if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
						GameEvents.xp_awarded.emit(h, int(float(xp_bounty) * 0.50))
		
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.creep_last_hit.emit(self, killer_hero, gold_bounty)
			GameEvents.gold_awarded.emit(killer_hero, gold_bounty, "Creep Last Hit")
			GameEvents.xp_awarded.emit(killer_hero, xp_bounty)
			GameEvents.combat_log_generated.emit("%s son vuruş yaptı (+%dg, +%d XP)" % [killer_hero.entity_name, gold_bounty, xp_bounty])
	else:
		# Non-Hero Last Hit (Creep or Tower kill): Award XP to nearby friendly heroes (15m radius)
		for h in HeroEntity.active_heroes:
			if is_instance_valid(h) and h.is_alive() and h.team != team:
				var h_pos = h.global_position if h.is_inside_tree() else h.position
				var c_pos = global_position if is_inside_tree() else position
				if c_pos.distance_to(h_pos) <= 15.0:
					h.attribute_system.add_xp(int(float(xp_bounty) * 0.75))
					if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
						GameEvents.xp_awarded.emit(h, int(float(xp_bounty) * 0.75))
						
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.creep_killed.emit(self, killer_hero)
		GameEvents.creep_died.emit(self, killer_hero)
				
	# Safe Cleanup
	var tween = create_tween()
	if tween != null:
		tween.tween_interval(0.3)
		tween.tween_callback(queue_free)
	else:
		queue_free()
