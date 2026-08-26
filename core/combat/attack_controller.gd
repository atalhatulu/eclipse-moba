class_name AttackController
extends RefCounted

## Centralized Basic Attack Controller for Eclipse Front (Task 09)
## Manages Wind-up, Hit Delivery (Melee/Ranged Projectile), Recovery, and Cooldown

enum AttackState {
	IDLE,
	WINDUP,
	RECOVERY
}

var source_entity: BaseCombatEntity = null
var current_target: BaseCombatEntity = null
var current_state: AttackState = AttackState.IDLE

var windup_duration: float = 0.20
var recovery_duration: float = 0.30
var state_timer: float = 0.0
var cooldown_timer: float = 0.0

func _init(p_source: BaseCombatEntity = null) -> void:
	source_entity = p_source

func set_source(p_source: BaseCombatEntity) -> void:
	source_entity = p_source

func update(delta: float) -> void:
	if cooldown_timer > 0.0:
		cooldown_timer -= delta
		
	if current_state == AttackState.IDLE:
		return
		
	# Target validity check during attack cycle
	if not TargetRelationSystem.is_valid_basic_attack_target(source_entity, current_target):
		cancel_attack()
		return
		
	state_timer -= delta
	
	match current_state:
		AttackState.WINDUP:
			if state_timer <= 0.0:
				_deliver_attack_hit()
				current_state = AttackState.RECOVERY
				state_timer = recovery_duration
				
		AttackState.RECOVERY:
			if state_timer <= 0.0:
				current_state = AttackState.IDLE
				current_target = null

func can_attack_target(target: BaseCombatEntity) -> bool:
	if source_entity == null or not is_instance_valid(source_entity) or not source_entity.is_alive():
		return false
	if not source_entity.can_attack():
		return false
	if cooldown_timer > 0.0:
		return false
	if not TargetRelationSystem.is_valid_basic_attack_target(source_entity, target):
		return false
	var atk_range = source_entity.get_attack_range()
	return TargetRelationSystem.is_in_range(source_entity, target, atk_range)

func start_attack(target: BaseCombatEntity) -> bool:
	if not can_attack_target(target):
		return false
		
	current_target = target
	current_state = AttackState.WINDUP
	
	var interval = source_entity.get_attack_interval()
	windup_duration = clampf(interval * 0.22, 0.10, 0.40)
	recovery_duration = clampf(interval * 0.30, 0.12, 0.60)
	state_timer = windup_duration
	cooldown_timer = interval
	
	# Global Event: Attack Started
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.attack_started.emit(source_entity, current_target)
		
	# Visual Motion Trigger
	_play_visual_attack_motion(current_target)
	return true

func cancel_attack() -> void:
	current_state = AttackState.IDLE
	current_target = null
	state_timer = 0.0

func _deliver_attack_hit() -> void:
	if not TargetRelationSystem.is_valid_basic_attack_target(source_entity, current_target):
		return
		
	var ad = source_entity.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if source_entity.attribute_system != null else 30.0
	var req = DamageRequest.create_basic_attack(source_entity, current_target, ad)
	req.source_name = source_entity.entity_name
	
	var atk_range = source_entity.get_attack_range()
	if atk_range <= 3.5:
		# Melee: Immediate hit application
		var res = current_target.receive_damage(req)
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.attack_hit.emit(source_entity, current_target, res)
			GameEvents.attack_landed.emit(source_entity, current_target, res)
			GameEvents.damage_dealt.emit(res, source_entity, current_target)
	else:
		# Ranged: Launch homing projectile
		if source_entity.is_inside_tree():
			var proj_script = load("res://scenes/effects/basic_attack_projectile_3d.gd")
			if proj_script != null:
				var proj = proj_script.new()
				source_entity.get_tree().root.add_child(proj)
				var p_color = Color(0.3, 0.6, 1.0) if source_entity.team == TeamDefinitions.Team.RADIANT else Color(1.0, 0.3, 0.3)
				proj.setup(source_entity, current_target, req, p_color, 34.0, 0.3)

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
		tween.tween_property(visual, "rotation:x", -0.22, windup_duration * 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(visual, "rotation:x", 0.0, recovery_duration * 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
