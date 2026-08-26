class_name BaseCombatEntity
extends CharacterBody3D

## Common combat-capable foundation for all interactive battlefield units in Eclipse Front

signal died(entity: BaseCombatEntity, killer_name: String)
signal basic_attack_performed(target: BaseCombatEntity, result: DamageResult)
signal target_acquired(target: BaseCombatEntity)
signal target_cleared()

@export var entity_name: String = "Unit"
@export var team: TeamDefinitions.Team = TeamDefinitions.Team.RADIANT
@export var is_targetable: bool = true

var attribute_system: AttributeSystem = null
var effect_container: EffectContainer = null
var attack_controller: AttackController = null

var current_target: BaseCombatEntity = null
var attack_cooldown: float = 0.0

func _ready() -> void:
	if has_node("AttributeSystem"):
		attribute_system = $AttributeSystem
	else:
		attribute_system = AttributeSystem.new()
		attribute_system.name = "AttributeSystem"
		add_child(attribute_system)
		
	if has_node("EffectContainer"):
		effect_container = $EffectContainer
	else:
		effect_container = EffectContainer.new()
		effect_container.name = "EffectContainer"
		add_child(effect_container)
		
	attack_controller = AttackController.new(self)
	attribute_system.entity_died.connect(_on_death)

func _process(delta: float) -> void:
	if attack_cooldown > 0.0:
		attack_cooldown = maxf(0.0, attack_cooldown - delta)
	if attack_controller != null:
		attack_controller.update(delta)

func is_alive() -> bool:
	return attribute_system != null and attribute_system.is_alive

func is_enemy_with(other: BaseCombatEntity) -> bool:
	return TargetRelationSystem.is_enemy(self, other)

func is_ally_with(other: BaseCombatEntity) -> bool:
	return TargetRelationSystem.is_ally(self, other)

func can_act() -> bool:
	if not is_alive():
		return false
	if effect_container != null and effect_container.is_stunned():
		return false
	return true

func can_move() -> bool:
	if not can_act():
		return false
	if effect_container != null and effect_container.is_rooted():
		return false
	return true

func can_cast() -> bool:
	if not can_act():
		return false
	if effect_container != null and effect_container.is_silenced():
		return false
	return true

func can_attack() -> bool:
	return can_act() and attack_cooldown <= 0.0

func get_attack_range() -> float:
	if attribute_system == null:
		return 2.0
	var range_cm = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_RANGE)
	return maxf(1.8, (range_cm * 0.01) + 0.8)

func get_attack_interval() -> float:
	if attribute_system == null:
		return 1.0
	var as_stat = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	return 1.0 / maxf(0.1, as_stat)

func set_combat_target(target: BaseCombatEntity) -> bool:
	if not is_alive() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable:
		clear_combat_target()
		return false
	if not is_enemy_with(target):
		clear_combat_target()
		return false
		
	current_target = target
	target_acquired.emit(current_target)
	return true

func clear_combat_target() -> void:
	if current_target != null:
		current_target = null
		target_cleared.emit()

func execute_basic_attack(target: BaseCombatEntity) -> DamageResult:
	if not TargetRelationSystem.is_valid_basic_attack_target(self, target):
		return null
	if not can_attack():
		return null
		
	# Global Event: Attack Started
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.attack_started.emit(self, target)
			
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 30.0
	var req = DamageRequest.create_basic_attack(self, target, ad)
	req.source_name = entity_name
	
	# Attack Cooldown Interval Calculation
	attack_cooldown = get_attack_interval()
	
	# Play Visual Attack Motion / Projectile
	_play_attack_motion(target, req)
	
	var res: DamageResult = null
	if get_attack_range() <= 3.5:
		# Melee: Immediate damage delivery on strike
		res = target.receive_damage(req)
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.attack_hit.emit(self, target, res)
			GameEvents.attack_landed.emit(self, target, res)
			GameEvents.damage_dealt.emit(res, self, target)
		basic_attack_performed.emit(target, res)
		
	return res

func _play_attack_motion(target: BaseCombatEntity, req: DamageRequest) -> void:
	var range_m = get_attack_range()
	
	if range_m > 3.5:
		# Ranged Attack: Launch Energy Projectile
		if is_inside_tree():
			var proj_script = load("res://scenes/effects/basic_attack_projectile_3d.gd")
			if proj_script != null:
				var proj = proj_script.new()
				get_tree().root.add_child(proj)
				var p_color = Color(0.3, 0.6, 1.0) if team == TeamDefinitions.Team.RADIANT else Color(1.0, 0.3, 0.3)
				proj.setup(self, target, req, p_color, 34.0, 0.3)
	else:
		# Melee Attack: Forward Punch/Swing Tilt Animation (Rotation based, never moves position into void)
		var visual = get_node_or_null("Visual")
		if visual == null: visual = get_node_or_null("HeroVisual")
		if visual == null: visual = get_node_or_null("CreepVisual")
		if visual == null: visual = get_node_or_null("KaelgorVisual")
		if visual == null: visual = get_node_or_null("AstrisVisual")
			
		if visual != null and is_inside_tree():
			var tween = create_tween()
			tween.tween_property(visual, "rotation:x", -0.22, 0.08).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			tween.tween_property(visual, "rotation:x", 0.0, 0.12).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

func receive_damage(request: DamageRequest) -> DamageResult:
	request.target = self
	var res = CombatCalculator.execute_damage(request)
	
	# Visual Feedback: Floating Damage Number
	if res.final_health_damage > 0.0 and is_inside_tree():
		var text_color = Color(0.95, 0.25, 0.25) # Physical Red
		if request.damage_type == DamageRequest.DamageType.MAGICAL:
			text_color = Color(0.3, 0.75, 1.0) # Magical Cyan
		elif request.damage_type == DamageRequest.DamageType.TRUE_DAMAGE:
			text_color = Color(1.0, 0.9, 0.2) # True Gold
			
		var text_str = "-%d" % int(res.final_health_damage)
		if res.is_critical:
			text_str = "CRIT! " + text_str
			text_color = Color(1.0, 0.8, 0.1)
			
		var text_script = load("res://scenes/ui/floating_combat_text_3d.gd")
		if text_script != null:
			var combat_text = text_script.new()
			get_tree().root.add_child(combat_text)
			combat_text.setup(text_str, text_color, global_position, res.is_critical)
		
		# Hit Flinch Shake
		_play_hit_flinch()
		
	return res

func _play_hit_flinch() -> void:
	var visual = get_node_or_null("Visual")
	if visual == null: visual = get_node_or_null("HeroVisual")
	if visual == null: visual = get_node_or_null("CreepVisual")
	if visual == null: visual = get_node_or_null("TowerVisual")
	if visual == null: visual = get_node_or_null("KaelgorVisual")
	if visual == null: visual = get_node_or_null("AstrisVisual")
	
	if visual != null and is_inside_tree():
		# Reset to base scale to prevent compounding / zero collapse
		visual.scale = Vector3.ONE
		var tween = create_tween()
		tween.tween_property(visual, "scale", Vector3(1.08, 1.08, 1.08), 0.04)
		tween.tween_property(visual, "scale", Vector3.ONE, 0.06)

func die(killer: BaseCombatEntity = null) -> void:
	var k_name = killer.entity_name if (killer != null and is_instance_valid(killer)) else ""
	_on_death(k_name)

func _on_death(killer_name: String) -> void:
	attack_cooldown = 0.0
	current_target = null
	is_targetable = false
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.entity_died.emit(self, null)
	died.emit(self, killer_name)
