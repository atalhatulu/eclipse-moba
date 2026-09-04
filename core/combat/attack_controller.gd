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
			
			var next_t = _find_next_auto_attack_target()
			if next_t != null:
				issue_attack_command(next_t)
			else:
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
				
		AttackState.WINDUP, AttackState.ATTACKING:
			# Turn towards target using turn_rate
			if source_entity.has_method("turn_towards_point"):
				source_entity.turn_towards_point(t_pos, delta)
			state_timer -= delta
			if state_timer <= 0.0:
				_deliver_attack_hit()
				current_state = AttackState.RECOVERY
				state_timer = recovery_duration
				var interval = source_entity.get_attack_interval()
				cooldown_timer = maxf(0.15, interval - windup_duration)
				
		AttackState.RECOVERY:
			state_timer -= delta
			if state_timer <= 0.0:
				current_state = AttackState.COOLDOWN
				
		AttackState.COOLDOWN:
			if dist > atk_range:
				# Target moved out of range during cooldown -> pursue
				current_state = AttackState.MOVING_TO_TARGET
				_navigate_towards_target()
			elif cooldown_timer <= 0.0:
				# Cooldown finished while in range -> start next attack
				_start_attack_cycle()

func notify_move_command_issued() -> bool:
	if current_state == AttackState.RECOVERY:
		# Attack animation cancel (Stutter-Step / Orb-Walking)
		# Recovery backswing is skipped, but cooldown_timer remains ticking
		current_state = AttackState.IDLE
		attack_target = null
		state_timer = 0.0
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("%s saldırı animasyonunu iptal etti (Stutter-step/Backswing Cancel)" % source_entity.entity_name)
		return true
	elif current_state == AttackState.WINDUP or current_state == AttackState.ATTACKING:
		# Cancel before hit lands -> abort attack completely
		cancel_attack_command()
		return true
	return false

func _start_attack_cycle() -> void:
	if attack_target == null or not is_instance_valid(attack_target) or not attack_target.is_alive():
		cancel_attack_command()
		return
		
	current_state = AttackState.WINDUP
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
		
	var s_pos = source_entity.global_position if source_entity.is_inside_tree() else source_entity.position
	var t_pos = attack_target.global_position if attack_target.is_inside_tree() else attack_target.position
	var elevation_diff = t_pos.y - s_pos.y
	attack_type = get_attack_type()
	
	# High Ground Advantage: Uphill Ranged Miss Chance (25%)
	if attack_type == AttackType.RANGED and elevation_diff >= 0.70:
		if randf() < 0.25:
			# Missed due to High Ground disadvantage!
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("ISKALA! %s tepeye saldırdı ve vuruş ıskaladı (Yüksek Zemin Dezavantajı, %0.1fm)" % [source_entity.entity_name, elevation_diff])
			if source_entity.is_inside_tree():
				var text_script = load("res://scenes/ui/floating_combat_text_3d.gd")
				if text_script != null:
					var miss_txt = text_script.new()
					source_entity.get_tree().root.add_child(miss_txt)
					miss_txt.setup("ISKALA", Color(0.7, 0.7, 0.7), t_pos + Vector3(0, 1.2, 0), false)
			return
			
	var ad = 30.0
	if source_entity.attribute_system != null:
		ad = source_entity.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	ad = maxf(1.0, ad)
	
	var is_deny = (source_entity.team == attack_target.team)
	var req = DamageRequest.create_basic_attack(source_entity, attack_target, ad)
	req.source_name = source_entity.entity_name
	
	if attack_type == AttackType.MELEE:
		# Direct Melee Application via CombatCalculator / receive_damage
		var res = attack_target.receive_damage(req)
		if is_deny and (attack_target.get_current_health() <= 0.0 or not attack_target.is_alive()):
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("İNKÂR (DENIED)! %s dost %s birimini inkâr etti!" % [source_entity.entity_name, attack_target.entity_name])
			if source_entity.is_inside_tree():
				var text_script = load("res://scenes/ui/floating_combat_text_3d.gd")
				if text_script != null:
					var deny_txt = text_script.new()
					source_entity.get_tree().root.add_child(deny_txt)
					deny_txt.setup("! İNKÂR", Color(0.2, 0.85, 1.0), t_pos + Vector3(0, 1.4, 0), true)
					
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
				var profile = get_hero_projectile_profile(source_entity, is_deny)
				proj.setup(source_entity, attack_target, req, profile.color, profile.speed, profile.radius)
		else:
			# Headless fallback
			var res = attack_target.receive_damage(req)
			if is_deny and (attack_target.get_current_health() <= 0.0 or not attack_target.is_alive()):
				if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
					GameEvents.combat_log_generated.emit("İNKÂR (DENIED)! %s dost %s birimini inkâr etti!" % [source_entity.entity_name, attack_target.entity_name])
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
		
	if source_entity.has_node("HeroAnimator3D"):
		var anim = source_entity.get_node("HeroAnimator3D")
		var t_pos = target.global_position if (target != null and is_instance_valid(target)) else Vector3.ZERO
		anim.play_attack_motion(t_pos, windup_duration + recovery_duration)
		return
		
	var visual: Node3D = null
	if source_entity.has_method("get_visual_node"):
		visual = source_entity.get_visual_node()
	else:
		visual = source_entity.get_node_or_null("Visual")
	
	if visual != null:
		var tween = source_entity.create_tween()
		if tween != null:
			tween.tween_property(visual, "rotation:x", -0.22, windup_duration * 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			tween.tween_property(visual, "rotation:x", 0.0, recovery_duration * 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

func _find_next_auto_attack_target() -> BaseCombatEntity:
	if source_entity == null or not is_instance_valid(source_entity) or not source_entity.is_alive():
		return null
	if not source_entity.is_inside_tree():
		return null
		
	var s_pos = source_entity.global_position if source_entity.is_inside_tree() else source_entity.position
	var atk_range = source_entity.get_attack_range() + 4.5
	var entities = source_entity.get_tree().get_nodes_in_group("combat_entities")
	
	var best_target: BaseCombatEntity = null
	var best_score: float = 999999.0
	
	for ent in entities:
		if ent is BaseCombatEntity and is_instance_valid(ent) and ent != source_entity:
			if ent.is_alive() and ent.is_targetable and TargetRelationSystem.is_valid_basic_attack_target(source_entity, ent):
				var t_pos = ent.global_position if ent.is_inside_tree() else ent.position
				var d = s_pos.distance_to(t_pos)
				if d <= atk_range:
					var hp_pct = 1.0
					if ent.attribute_system != null:
						var cur_h = ent.attribute_system.current_health
						var max_h = ent.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
						hp_pct = cur_h / maxf(1.0, max_h)
					var is_creep = (ent is CreepEntity)
					# Prefer lowest HP creep for smooth minion wave clearing
					var score = d + (hp_pct * 8.0) - (40.0 if is_creep else 0.0)
					if score < best_score:
						best_score = score
						best_target = ent
						
	return best_target

static func get_hero_projectile_profile(source_entity: BaseCombatEntity, is_deny: bool) -> Dictionary:
	var col = Color(0.9, 0.8, 0.4)
	var spd = 24.0
	var rad = 0.28
	
	if source_entity != null:
		var name_low = source_entity.entity_name.to_lower()
		
		if is_deny:
			col = Color(0.2, 0.85, 1.0) # Deny blue pulse
			spd = 28.0
			rad = 0.25
		elif name_low.contains("solen"):
			col = Color(1.0, 0.85, 0.2) # Solar golden arrow
			spd = 26.0
			rad = 0.26
		elif name_low.contains("astris"):
			col = Color(0.35, 0.8, 1.0) # Astral starlight needle
			spd = 28.0
			rad = 0.22
		elif name_low.contains("aethon"):
			col = Color(1.0, 0.55, 0.2) # Arcane brass spark
			spd = 22.0
			rad = 0.32
		elif name_low.contains("durn"):
			col = Color(1.0, 0.4, 0.1) # Heavy mortar shell
			spd = 20.0
			rad = 0.42
		elif name_low.contains("nixe"):
			col = Color(0.3, 0.95, 0.2) # Toxic venom glob
			spd = 23.0
			rad = 0.34
		elif name_low.contains("noctis"):
			col = Color(0.65, 0.2, 0.95) # Shadow shard
			spd = 25.0
			rad = 0.30
		elif name_low.contains("selka"):
			col = Color(0.9, 0.15, 0.3) # Dark blood curse dart
			spd = 24.0
			rad = 0.26
		elif name_low.contains("lyra"):
			col = Color(0.85, 0.4, 1.0) # Cosmic stellar orb
			spd = 23.0
			rad = 0.34
		elif name_low.contains("neris"):
			col = Color(0.25, 0.6, 1.0) # Arcane prism pulse
			spd = 27.0
			rad = 0.25
		elif name_low.contains("sera"):
			col = Color(1.0, 0.9, 0.35) # Dawn solar flare
			spd = 25.0
			rad = 0.30
		elif name_low.contains("seris"):
			col = Color(0.7, 0.8, 0.4) # Spiked razor dart
			spd = 28.0
			rad = 0.22
		elif name_low.contains("veylin"):
			col = Color(0.4, 0.9, 0.85) # Ether lance
			spd = 26.0
			rad = 0.25
		elif name_low.contains("zin"):
			col = Color(0.6, 0.9, 1.0) # Prismatic mirror shard
			spd = 27.0
			rad = 0.25
		elif "tower" in name_low or "kule" in name_low:
			col = Color(0.25, 0.75, 1.0) if source_entity.team == TeamDefinitions.Team.RADIANT else Color(1.0, 0.3, 0.2)
			spd = 22.0
			rad = 0.40
		elif "creep" in name_low or "minion" in name_low:
			col = Color(0.9, 0.75, 0.35)
			spd = 19.0
			rad = 0.20
		else:
			col = Color(0.35, 0.65, 1.0) if source_entity.team == TeamDefinitions.Team.RADIANT else Color(1.0, 0.4, 0.3)
			spd = 24.0
			rad = 0.28
			
	return {
		"color": col,
		"speed": spd,
		"radius": rad
	}
