class_name AttackController
extends RefCounted

## Universal MOBA Basic Attack & Combat Targeting Controller (Task 13)
## Manages Target Validation, Pursuit, Melee/Ranged Execution, Attack Intervals, Cooldown, and Cancellation

enum AttackState {
	IDLE,
	MOVING_TO_TARGET,
	ATTACKING,
	WINDUP,
	RECOVERY,
	COOLDOWN,
	DEAD
}

enum AttackType {
	MELEE,
	RANGED
}

var source_entity: BaseCombatEntity = null
var attack_target: BaseCombatEntity = null
var current_state: AttackState = AttackState.IDLE
var attack_type: AttackType = AttackType.MELEE

# Deterministic Timing & Intervals
var windup_duration: float = 0.20
var recovery_duration: float = 0.25
var state_timer: float = 0.0
var cooldown_timer: float = 0.0
var last_attack_time: float = 0.0

# Aliases for backward compatibility
var current_target: BaseCombatEntity:
	get:
		return attack_target
	set(val):
		attack_target = val

var attack_state: AttackState:
	get:
		return current_state
	set(val):
		current_state = val

func _init(p_source: BaseCombatEntity = null) -> void:
	source_entity = p_source

func set_source(p_source: BaseCombatEntity) -> void:
	source_entity = p_source

func get_attack_type() -> AttackType:
	if source_entity == null:
		return AttackType.MELEE
	var atk_range = source_entity.get_attack_range()
	return AttackType.RANGED if atk_range > 3.5 else AttackType.MELEE

func can_attack_target(target: BaseCombatEntity) -> bool:
	if source_entity == null or not is_instance_valid(source_entity) or not source_entity.is_alive():
		return false
	if not source_entity.can_attack():
		return false
	if not TargetRelationSystem.is_valid_basic_attack_target(source_entity, target):
		return false
	return true

func issue_attack_command(target: BaseCombatEntity) -> bool:
	if source_entity == null or not is_instance_valid(source_entity) or not source_entity.is_alive():
		return false
	if target == null or not is_instance_valid(target) or not target.is_alive():
		cancel_attack_command()
		return false
		
	# Strict Target Rule Check (No Friendly Fire / Self Targeting)
	if not TargetRelationSystem.is_valid_basic_attack_target(source_entity, target):
		return false
		
	attack_target = target
	attack_type = get_attack_type()
	
	var atk_range = source_entity.get_attack_range()
	var in_range = TargetRelationSystem.is_in_range(source_entity, attack_target, atk_range)
	
	if in_range:
		if cooldown_timer <= 0.0:
			_start_attack_cycle()
		else:
			current_state = AttackState.COOLDOWN
	else:
		current_state = AttackState.MOVING_TO_TARGET
		_navigate_towards_target()
		
	return true

# Legacy alias
func start_attack(target: BaseCombatEntity) -> bool:
	return issue_attack_command(target)

func cancel_attack_command() -> void:
	current_state = AttackState.IDLE
	attack_target = null
	state_timer = 0.0

# Legacy alias
func cancel_attack() -> void:
	cancel_attack_command()

func update(delta: float) -> void:
	if source_entity == null or not is_instance_valid(source_entity):
		return
		
	if not source_entity.is_alive():
		current_state = AttackState.DEAD
		attack_target = null
		return
		
	if cooldown_timer > 0.0:
		cooldown_timer = maxf(0.0, cooldown_timer - delta)
		
	if attack_target == null or not is_instance_valid(attack_target) or not attack_target.is_alive():
		if current_state != AttackState.IDLE and current_state != AttackState.DEAD:
			if attack_target != null and Engine.has_singleton("GameEvents"):
				GameEvents.target_died.emit(attack_target, source_entity)
			cancel_attack_command()
		return
		
	var atk_range = source_entity.get_attack_range()
	var s_pos = source_entity.global_position if source_entity.is_inside_tree() else source_entity.position
	var t_pos = attack_target.global_position if attack_target.is_inside_tree() else attack_target.position
	var dist = s_pos.distance_to(t_pos)
	
	match current_state:
		AttackState.IDLE:
			pass
			
		AttackState.MOVING_TO_TARGET:
			if dist <= atk_range:
				# Entered attack range -> Stop movement and attack
				_stop_movement()
				if cooldown_timer <= 0.0:
					_start_attack_cycle()
				else:
					current_state = AttackState.COOLDOWN
			else:
				# Continue pursuit
				_navigate_towards_target()
				
		AttackState.ATTACKING:
			state_timer -= delta
			if state_timer <= 0.0:
				_deliver_attack_hit()
				current_state = AttackState.COOLDOWN
				var interval = source_entity.get_attack_interval()
				cooldown_timer = maxf(0.15, interval - windup_duration)
				
		AttackState.COOLDOWN:
			if dist > atk_range:
				# Target moved out of range during cooldown -> pursue
				current_state = AttackState.MOVING_TO_TARGET
				_navigate_towards_target()
			elif cooldown_timer <= 0.0:
				# Cooldown finished while in range -> start next attack
				_start_attack_cycle()

func _start_attack_cycle() -> void:
	if attack_target == null or not is_instance_valid(attack_target) or not attack_target.is_alive():
		cancel_attack_command()
		return
		
	current_state = AttackState.ATTACKING
	var interval = source_entity.get_attack_interval()
	windup_duration = clampf(interval * 0.20, 0.06, 0.25)
	recovery_duration = clampf(interval * 0.25, 0.08, 0.35)
	state_timer = windup_duration
	last_attack_time = Time.get_ticks_msec() * 0.001
	
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.attack_started.emit(source_entity, attack_target)
		
	_play_visual_attack_motion(attack_target)

func _navigate_towards_target() -> void:
	if source_entity == null or attack_target == null or not is_instance_valid(attack_target):
		return
	var t_pos = attack_target.global_position if attack_target.is_inside_tree() else attack_target.position
	if source_entity.has_method("move_to_location"):
		source_entity.move_to_location(t_pos)

func _stop_movement() -> void:
	if source_entity == null:
		return
	if source_entity.has_method("stop_movement"):
		source_entity.stop_movement()

func _deliver_attack_hit() -> void:
	if attack_target == null or not is_instance_valid(attack_target) or not attack_target.is_alive():
		return
		
	if not TargetRelationSystem.is_valid_basic_attack_target(source_entity, attack_target):
		return
		
	var ad = 30.0
	if source_entity.attribute_system != null:
		ad = source_entity.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	ad = maxf(1.0, ad)
	
	var req = DamageRequest.create_basic_attack(source_entity, attack_target, ad)
	req.source_name = source_entity.entity_name
	
	attack_type = get_attack_type()
	if attack_type == AttackType.MELEE:
		# Direct Melee Application via CombatCalculator / receive_damage
		var res = attack_target.receive_damage(req)
		if source_entity.has_signal("basic_attack_performed"):
			source_entity.basic_attack_performed.emit(attack_target, res)
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.attack_hit.emit(source_entity, attack_target, res)
			GameEvents.attack_landed.emit(source_entity, attack_target, res)
			GameEvents.damage_dealt.emit(res, source_entity, attack_target)
			GameEvents.damage_received.emit(res, attack_target, source_entity)
	else:
		# Ranged Proj Delivery
		if source_entity.is_inside_tree():
			var proj_script = load("res://scenes/effects/basic_attack_projectile_3d.gd")
			if proj_script != null:
				var proj = proj_script.new()
				source_entity.get_tree().root.add_child(proj)
				var p_color = Color(0.3, 0.6, 1.0) if source_entity.team == TeamDefinitions.Team.RADIANT else Color(1.0, 0.3, 0.3)
				if source_entity.team == TeamDefinitions.Team.NEUTRAL:
					p_color = Color(1.0, 0.8, 0.2)
				proj.setup(source_entity, attack_target, req, p_color, 34.0, 0.3)
		else:
			# Headless fallback
			var res = attack_target.receive_damage(req)
			if source_entity.has_signal("basic_attack_performed"):
				source_entity.basic_attack_performed.emit(attack_target, res)
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.attack_hit.emit(source_entity, attack_target, res)
				GameEvents.attack_landed.emit(source_entity, attack_target, res)
				GameEvents.damage_dealt.emit(res, source_entity, attack_target)
				GameEvents.damage_received.emit(res, attack_target, source_entity)

func _play_visual_attack_motion(target: BaseCombatEntity) -> void:
	if source_entity == null or not is_instance_valid(source_entity) or not source_entity.is_inside_tree():
		return
	var visual = source_entity.get_node_or_null("Visual")
	if visual == null: visual = source_entity.get_node_or_null("HeroVisual")
	if visual == null: visual = source_entity.get_node_or_null("CreepVisual")
	if visual == null: visual = source_entity.get_node_or_null("KaelgorVisual")
	if visual == null: visual = source_entity.get_node_or_null("AstrisVisual")
	if visual == null: visual = source_entity.get_node_or_null("TowerVisual")
	
	if visual != null:
		var tween = source_entity.create_tween()
		if tween != null:
			tween.tween_property(visual, "rotation:x", -0.22, windup_duration * 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			tween.tween_property(visual, "rotation:x", 0.0, recovery_duration * 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
