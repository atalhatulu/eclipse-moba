class_name NeutralCreepEntity
extends BaseCombatEntity

## Autonomous Neutral / Jungle Creep with Camp Leashing, Shared Aggro, and Rapid Reset

enum NeutralType {
	KOBOLD,      # Small camp melee
	FOREST_MAGE, # Small camp ranged
	WOLF,        # Medium camp fast melee
	MUD_GOLEM,   # Medium camp tanky
	CENTAUR,     # Large camp heavy bruiser
	DRAGON       # Ancient camp flying boss
}

enum AIState {
	IDLE,
	ALERT,
	COMBAT,
	PURSUIT,
	LEASH,
	RETURNING,
	DEAD
}

@export var neutral_type: NeutralType = NeutralType.WOLF
@export var gold_bounty: int = 55
@export var xp_bounty: int = 75
@export var leash_distance: float = 14.0

const XP_SHARE_RADIUS: float = 16.0
var reward_distributed: bool = false
var ai_state: AIState = AIState.IDLE

var spawn_origin: Vector3 = Vector3.ZERO
var aggro_target: BaseCombatEntity = null
var aggro_proximity_range: float = 3.5
var is_leashing_back: bool = false
var camp_spawner: Node = null
var attack_timer: float = 0.0

func _init() -> void:
	team = TeamDefinitions.Team.NEUTRAL

func _ready() -> void:
	team = TeamDefinitions.Team.NEUTRAL
	super._ready()
	if spawn_origin == Vector3.ZERO:
		spawn_origin = global_position if is_inside_tree() else position
		
	_apply_neutral_archetype()
	_create_visual_mesh()

func _apply_neutral_archetype() -> void:
	match neutral_type:
		NeutralType.KOBOLD:
			entity_name = "Kobold Scout"
			attribute_system.base_health = 280.0
			attribute_system.base_attack_damage = 15.0
			attribute_system.base_armor = 1.0
			attribute_system.base_magic_resist = 0.0
			attribute_system.base_attack_range = 150.0
			attribute_system.base_attack_speed = 0.95
			attribute_system.base_move_speed = 320.0
			gold_bounty = 24
			xp_bounty = 32
		NeutralType.FOREST_MAGE:
			entity_name = "Forest Shaman"
			attribute_system.base_health = 320.0
			attribute_system.base_attack_damage = 20.0
			attribute_system.base_armor = 0.0
			attribute_system.base_magic_resist = 20.0
			attribute_system.base_attack_range = 500.0
			attribute_system.base_attack_speed = 0.80
			attribute_system.base_move_speed = 290.0
			gold_bounty = 34
			xp_bounty = 45
		NeutralType.WOLF:
			entity_name = "Alpha Wolf"
			attribute_system.base_health = 520.0
			attribute_system.base_attack_damage = 28.0
			attribute_system.base_armor = 3.0
			attribute_system.base_magic_resist = 10.0
			attribute_system.base_attack_range = 160.0
			attribute_system.base_attack_speed = 1.10
			attribute_system.base_move_speed = 340.0
			gold_bounty = 48
			xp_bounty = 65
		NeutralType.MUD_GOLEM:
			entity_name = "Mud Golem"
			attribute_system.base_health = 680.0
			attribute_system.base_attack_damage = 32.0
			attribute_system.base_armor = 6.0
			attribute_system.base_magic_resist = 50.0 # High magic resistance
			attribute_system.base_attack_range = 160.0
			attribute_system.base_attack_speed = 0.75
			attribute_system.base_move_speed = 280.0
			gold_bounty = 58
			xp_bounty = 80
		NeutralType.CENTAUR:
			entity_name = "Centaur Conqueror"
			attribute_system.base_health = 950.0
			attribute_system.base_attack_damage = 46.0
			attribute_system.base_armor = 7.0
			attribute_system.base_magic_resist = 25.0
			attribute_system.base_attack_range = 180.0
			attribute_system.base_attack_speed = 0.85
			attribute_system.base_move_speed = 310.0
			gold_bounty = 85
			xp_bounty = 115
		NeutralType.DRAGON:
			entity_name = "Ancient Black Dragon"
			attribute_system.base_health = 1600.0
			attribute_system.base_attack_damage = 75.0
			attribute_system.base_armor = 11.0
			attribute_system.base_magic_resist = 70.0 # Ancient spell immunity
			attribute_system.base_attack_range = 350.0
			attribute_system.base_attack_speed = 0.90
			attribute_system.base_move_speed = 300.0
			gold_bounty = 165
			xp_bounty = 220
			
	attribute_system.recalculate_all_stats()
	attribute_system.heal(attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))

func _create_visual_mesh() -> void:
	if not has_node("NeutralVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "NeutralVisual"
		add_child(root_vis)
		
		var mesh_inst = MeshInstance3D.new()
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.85, 0.65, 0.25, 1.0) # Earth Gold
		mat.emission_enabled = true
		mat.emission = Color(0.4, 0.3, 0.1, 1.0)
		mat.emission_energy_multiplier = 0.4
		
		if neutral_type == NeutralType.KOBOLD or neutral_type == NeutralType.FOREST_MAGE:
			var capsule = CapsuleMesh.new()
			capsule.radius = 0.30
			capsule.height = 0.9
			mesh_inst.mesh = capsule
			mesh_inst.position.y = 0.45
		elif neutral_type == NeutralType.WOLF:
			var box = BoxMesh.new()
			box.size = Vector3(0.5, 0.6, 1.0)
			mesh_inst.mesh = box
			mesh_inst.position.y = 0.30
			mat.albedo_color = Color(0.65, 0.55, 0.45, 1.0)
		elif neutral_type == NeutralType.MUD_GOLEM or neutral_type == NeutralType.CENTAUR:
			var cyl = CylinderMesh.new()
			cyl.top_radius = 0.45
			cyl.bottom_radius = 0.55
			cyl.height = 1.3
			mesh_inst.mesh = cyl
			mesh_inst.position.y = 0.65
			mat.albedo_color = Color(0.55, 0.45, 0.35, 1.0)
		else: # Ancient Dragon
			var sphere = SphereMesh.new()
			sphere.radius = 0.85
			sphere.height = 1.7
			mesh_inst.mesh = sphere
			mesh_inst.position.y = 1.2
			mat.albedo_color = Color(0.35, 0.25, 0.45, 1.0)
			mat.emission = Color(0.6, 0.2, 0.6, 1.0)
			mat.emission_energy_multiplier = 0.8
			
		mesh_inst.material_override = mat
		root_vis.add_child(mesh_inst)
		
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.40
		shape.height = 1.2
		col.shape = shape
		col.position.y = 0.60
		add_child(col)

func _physics_process(delta: float) -> void:
	if not is_alive() or not can_move():
		ai_state = AIState.DEAD
		return
		
	if attack_timer > 0.0:
		attack_timer -= delta
		
	# 1. Leash Reset Returning State
	if is_leashing_back:
		ai_state = AIState.RETURNING
		var cur_pos = global_position if (is_inside_tree() or global_position != Vector3.ZERO) else position
		var dist_to_home = cur_pos.distance_to(spawn_origin)
		if dist_to_home <= 0.6:
			# Arrived home
			if is_inside_tree():
				global_position = spawn_origin
			else:
				position = spawn_origin
			velocity = Vector3.ZERO
			is_leashing_back = false
			is_targetable = true
			ai_state = AIState.IDLE
			attribute_system.heal(attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
		else:
			# Sprint home and rapidly regenerate
			var dir = (spawn_origin - cur_pos).normalized()
			dir.y = 0.0
			var speed = attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED) * 0.035
			velocity = dir * speed
			_rotate_towards(spawn_origin, delta)
			move_and_slide()
			attribute_system.heal(attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH) * 0.35 * delta)
		return
		
	# 2. Aggro Evaluation
	if aggro_target == null or not is_instance_valid(aggro_target) or not aggro_target.is_alive():
		aggro_target = _evaluate_proximity_aggro()
		
	# 3. Combat / Pursuit
	if aggro_target != null and is_instance_valid(aggro_target) and aggro_target.is_alive():
		var cur_pos = global_position if (is_inside_tree() or global_position != Vector3.ZERO) else position
		var dist_from_spawn = cur_pos.distance_to(spawn_origin)
		if dist_from_spawn > leash_distance:
			# Exceeded leash threshold -> Reset camp!
			ai_state = AIState.LEASH
			_trigger_leash_reset()
			return
			
		var t_pos = aggro_target.global_position if (aggro_target.is_inside_tree() or aggro_target.global_position != Vector3.ZERO) else aggro_target.position
		var dist_to_target = cur_pos.distance_to(t_pos)
		var atk_range = get_attack_range()
		
		if dist_to_target <= atk_range:
			ai_state = AIState.COMBAT
			velocity = Vector3.ZERO
			_rotate_towards(t_pos, delta)
			if attack_timer <= 0.0 and can_attack():
				var atk_speed = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
				attack_timer = 1.0 / maxf(atk_speed, 0.2)
				execute_basic_attack(aggro_target)
		else:
			ai_state = AIState.PURSUIT
			var dir = (t_pos - cur_pos).normalized()
			dir.y = 0.0
			var speed = attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED) * 0.024
			velocity = dir * speed
			_rotate_towards(t_pos, delta)
			move_and_slide()
	else:
		# Idle at home
		var cur_pos = global_position if (is_inside_tree() or global_position != Vector3.ZERO) else position
		var dist_to_home = cur_pos.distance_to(spawn_origin)
		if dist_to_home > 0.8:
			ai_state = AIState.RETURNING
			var dir = (spawn_origin - cur_pos).normalized()
			dir.y = 0.0
			velocity = dir * (attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED) * 0.018)
			_rotate_towards(spawn_origin, delta)
			move_and_slide()
		else:
			ai_state = AIState.IDLE
			velocity = Vector3.ZERO

func _evaluate_proximity_aggro() -> BaseCombatEntity:
	var nodes: Array = []
	if is_inside_tree() and get_tree() != null:
		nodes = get_tree().get_nodes_in_group("combat_entities")
	else:
		nodes.append_array(HeroEntity.active_heroes)
		
	var self_pos = global_position if (is_inside_tree() or global_position != Vector3.ZERO) else position
	for n in nodes:
		if is_instance_valid(n) and n is BaseCombatEntity and n.is_alive() and n != self:
			if n.team != TeamDefinitions.Team.NEUTRAL:
				var n_pos = n.global_position if (n.is_inside_tree() or n.global_position != Vector3.ZERO) else n.position
				var d = self_pos.distance_to(n_pos)
				if d <= aggro_proximity_range:
					ai_state = AIState.ALERT
					return n
	return null

func receive_damage(request: DamageRequest) -> DamageResult:
	if request.attacker is BaseCombatEntity and is_instance_valid(request.attacker) and request.attacker.is_alive():
		last_attacker = request.attacker as BaseCombatEntity
		aggro_target = last_attacker
		ai_state = AIState.COMBAT
		# Wake up siblings in camp
		if camp_spawner != null and camp_spawner.has_method("notify_camp_aggro"):
			camp_spawner.notify_camp_aggro(aggro_target)
	var res = super.receive_damage(request)
	return res

func alert_aggro(target: BaseCombatEntity) -> void:
	if not is_leashing_back and (aggro_target == null or not is_instance_valid(aggro_target)):
		aggro_target = target
		ai_state = AIState.ALERT

func _trigger_leash_reset() -> void:
	aggro_target = null
	is_leashing_back = true
	is_targetable = false
	ai_state = AIState.RETURNING
	if camp_spawner != null and camp_spawner.has_method("notify_camp_leash_reset"):
		camp_spawner.notify_camp_leash_reset()

func die(killer: BaseCombatEntity = null) -> void:
	if killer != null and is_instance_valid(killer):
		last_attacker = killer
	super.die(killer)

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	ai_state = AIState.DEAD
	
	if reward_distributed:
		return
	reward_distributed = true
	
	var killer_hero: HeroEntity = null
	if last_attacker is HeroEntity and is_instance_valid(last_attacker) and last_attacker.is_alive():
		killer_hero = last_attacker as HeroEntity
	else:
		for h in HeroEntity.active_heroes:
			if is_instance_valid(h) and h.is_alive():
				if h.entity_name == killer_name or h.entity_name.begins_with(killer_name) or killer_name.begins_with(h.entity_name):
					killer_hero = h
					break
					
	if killer_hero != null:
		if killer_hero.inventory_manager != null:
			killer_hero.inventory_manager.add_gold(gold_bounty)
		killer_hero.attribute_system.add_xp(xp_bounty)
		
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.gold_awarded.emit(killer_hero, gold_bounty, "Jungle Monster Kill")
			GameEvents.xp_awarded.emit(killer_hero, xp_bounty)
			GameEvents.combat_log_generated.emit("%s orman yaratığını kesti (+%dg, +%d XP)" % [killer_hero.entity_name, gold_bounty, xp_bounty])
			
		if is_inside_tree():
			var text_script = load("res://scenes/ui/floating_combat_text_3d.gd")
			if text_script != null:
				var gold_text = text_script.new()
				get_tree().root.add_child(gold_text)
				gold_text.setup("+%dG" % gold_bounty, Color(1.0, 0.85, 0.2), global_position + Vector3(0, 0.8, 0), false)
				
		_distribute_area_xp(xp_bounty, killer_hero.team, killer_hero)
		
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.neutral_died.emit(self, last_attacker)
		
	var tween = create_tween()
	if tween != null:
		tween.tween_interval(0.3)
		tween.tween_callback(queue_free)
	else:
		queue_free()

func _distribute_area_xp(total_xp: int, target_team: TeamDefinitions.Team, exclude_hero: HeroEntity = null) -> void:
	var self_pos = global_position if is_inside_tree() else position
	var assist_xp = int(float(total_xp) * 0.50)
	
	for h in HeroEntity.active_heroes:
		if is_instance_valid(h) and h.is_alive() and h != exclude_hero and h.team == target_team:
			var h_pos = h.global_position if h.is_inside_tree() else h.position
			if self_pos.distance_to(h_pos) <= XP_SHARE_RADIUS:
				h.attribute_system.add_xp(assist_xp)
				if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
					GameEvents.xp_awarded.emit(h, assist_xp)

func _rotate_towards(target_pos: Vector3, delta: float) -> void:
	var cur_pos = global_position if (is_inside_tree() or global_position != Vector3.ZERO) else position
	var look_dir = target_pos - cur_pos
	look_dir.y = 0.0
	if look_dir.length_squared() > 0.01:
		var target_rot_y = atan2(look_dir.x, look_dir.z)
		rotation.y = lerp_angle(rotation.y, target_rot_y, 14.0 * delta)
