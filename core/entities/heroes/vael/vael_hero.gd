class_name VaelHero
extends HeroEntity

## Implementation of Vael (INT Artillery / Calibration & Falling Star)

signal calibration_stacked(stacks: int, bonus_dmg_pct: float, bonus_range_pct: float)
signal star_lance_fired(target: BaseCombatEntity, damage: float, cast_range: float)
signal astral_marker_applied(target: BaseCombatEntity, duration: float)
signal warp_sight_activated(bonus_range: float)
signal falling_star_impact(position: Vector3, enemies_hit: int, total_damage: float)

# State
var calibration_stacks: int = 0
var calibration_timer: float = 0.0
var last_aim_direction: Vector3 = Vector3.FORWARD
const MAX_CALIBRATION_STACKS: int = 3
const CALIBRATION_DURATION: float = 5.0

var warp_sight_timer: float = 0.0
var marked_targets: Dictionary = {} # target: duration

func _ready() -> void:
	entity_name = "Vael"
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_vael_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.45
		shape.height = 1.95
		col.shape = shape
		col.position.y = 0.97
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("VaelVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "VaelVisual"
		add_child(root_vis)
		
		# Star Telescope Mage Silhouette
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.40
		body_capsule.height = 1.95
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.97
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.08, 0.15, 0.28, 1.0) # Deep Astral Navy
		body_mat.metallic = 0.5
		body_mat.roughness = 0.3
		body_mat.emission_enabled = true
		body_mat.emission = Color(0.15, 0.65, 1.0, 1.0)
		body_mat.emission_energy_multiplier = 1.2
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
		# Heavy Astral Lens Staff on back
		var staff = MeshInstance3D.new()
		var s_cyl = CylinderMesh.new()
		s_cyl.top_radius = 0.08
		s_cyl.bottom_radius = 0.08
		s_cyl.height = 2.2
		staff.mesh = s_cyl
		staff.position = Vector3(0.0, 1.35, -0.25)
		staff.rotation_degrees = Vector3(15, 0, 0)
		
		var s_mat = StandardMaterial3D.new()
		s_mat.albedo_color = Color(0.4, 0.85, 1.0, 1.0)
		s_mat.emission_enabled = true
		s_mat.emission = Color(0.4, 0.85, 1.0, 1.0)
		s_mat.emission_energy_multiplier = 1.5
		staff.material_override = s_mat
		root_vis.add_child(staff)
		
		# Selection Base Ring
		var ring = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.85
		torus.outer_radius = 0.90
		ring.mesh = torus
		ring.position.y = 0.03
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var ring_color = Color(0.95, 0.3, 0.3, 0.85) if team == TeamDefinitions.Team.DIRE else Color(0.92, 0.96, 1.0, 0.85)
		ring_mat.albedo_color = ring_color
		ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		ring.material_override = ring_mat
		root_vis.add_child(ring)

func _apply_vael_definition() -> void:
	if hero_resource == null:
		hero_resource = VaelDefinition.create_resource()
		
	var def = hero_resource
	attribute_system.primary_attribute = def.primary_attribute
	attribute_system.base_strength = def.base_strength
	attribute_system.strength_growth = def.strength_growth
	attribute_system.base_agility = def.base_agility
	attribute_system.agility_growth = def.agility_growth
	attribute_system.base_intelligence = def.base_intelligence
	attribute_system.intelligence_growth = def.intelligence_growth
	
	attribute_system.base_health = def.base_health
	attribute_system.base_health_regen = def.base_health_regen
	attribute_system.base_mana = def.base_mana
	attribute_system.base_mana_regen = def.base_mana_regen
	attribute_system.base_attack_damage = def.base_attack_damage
	attribute_system.base_ability_power = def.base_ability_power
	attribute_system.base_armor = def.base_armor
	attribute_system.base_magic_resist = def.base_magic_resist
	attribute_system.base_attack_speed = def.base_attack_speed
	attribute_system.base_move_speed = def.base_move_speed
	attribute_system.base_attack_range = def.base_attack_range
	
	attribute_system.recalculate_all_stats()
	attribute_system.heal(attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
	attribute_system.restore_mana(attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA))
	
	# Assign abilities
	ability_container.set_ability(AbilityResource.Slot.PASSIVE, def.passive_ability)
	ability_container.set_ability(AbilityResource.Slot.Q, def.q_ability)
	ability_container.set_ability(AbilityResource.Slot.W, def.w_ability)
	ability_container.set_ability(AbilityResource.Slot.E, def.e_ability)
	ability_container.set_ability(AbilityResource.Slot.R, def.r_ability)

func _process(delta: float) -> void:
	super._process(delta)
	_process_calibration(delta)
	_process_warp_sight(delta)
	_process_marked_targets(delta)

# --- PASSIVE: CALIBRATION ---

func _record_aim_direction(dir: Vector3) -> void:
	var norm_dir = dir.normalized()
	var angle_diff = last_aim_direction.angle_to(norm_dir)
	
	# If shooting within ~30 degrees of last direction, gain Calibration stack
	if angle_diff < 0.52:
		calibration_stacks = mini(MAX_CALIBRATION_STACKS, calibration_stacks + 1)
	else:
		calibration_stacks = 1 # Reset to 1 on big redirection
		
	last_aim_direction = norm_dir
	calibration_timer = CALIBRATION_DURATION
	
	var bonus_dmg_pct = calibration_stacks * 0.10
	var bonus_range_pct = calibration_stacks * 0.15
	calibration_stacked.emit(calibration_stacks, bonus_dmg_pct, bonus_range_pct)

func _process_calibration(delta: float) -> void:
	if calibration_timer > 0.0:
		calibration_timer -= delta
		if calibration_timer <= 0.0:
			calibration_stacks = 0

func _process_marked_targets(delta: float) -> void:
	var keys = marked_targets.keys()
	for k in keys:
		if not is_instance_valid(k) or not k.is_alive():
			marked_targets.erase(k)
			continue
		marked_targets[k] -= delta
		if marked_targets[k] <= 0.0:
			marked_targets.erase(k)

# --- Q: STAR LANCE ---

func cast_vael_q(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, target):
		return null
		
	var dir = (target.global_position - global_position).normalized() if is_inside_tree() else (target.position - position).normalized()
	_record_aim_direction(dir)
	
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var intel = attribute_system.get_stat(StatModifier.TargetStat.INTELLIGENCE)
	var calib_mult = 1.0 + (calibration_stacks * 0.10)
	var is_marked = marked_targets.has(target)
	var mark_mult = 1.20 if is_marked else 1.0
	var total_dmg = (base_dmg + (intel * q_res.scaling_ratio)) * calib_mult * mark_mult
	
	if not ability_container.cast_ability(AbilityResource.Slot.Q, target):
		return null
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.MAGICAL, "Star Lance")
	if is_marked:
		req.magic_pen_percent = 0.20 # 20% Magic Pen on marked targets
	var res = CombatCalculator.execute_damage(req)
	
	star_lance_fired.emit(target, total_dmg, q_res.cast_range)
	return res

# --- W: ASTRAL MARKER ---

func cast_vael_w(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.W, target):
		return null
		
	var dir = (target.global_position - global_position).normalized() if is_inside_tree() else (target.position - position).normalized()
	_record_aim_direction(dir)
	
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var base_dmg = w_res.get_base_damage(lvl)
	var intel = attribute_system.get_stat(StatModifier.TargetStat.INTELLIGENCE)
	var total_dmg = base_dmg + (intel * w_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.W, target):
		return null
		
	marked_targets[target] = 6.0
	astral_marker_applied.emit(target, 6.0)
	
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.MAGICAL, "Astral Marker")
	return CombatCalculator.execute_damage(req)

# --- E: WARP SIGHT ---

func cast_vael_e() -> bool:
	if not can_cast():
		return false
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return false
		
	warp_sight_timer = 5.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("vael_warp_sight_range")
		var mod = StatModifier.new(StatModifier.TargetStat.ATTACK_RANGE, StatModifier.Type.FLAT, 200.0, "vael_warp_sight_range")
		attribute_system.add_modifier(mod)
		
	warp_sight_activated.emit(200.0)
	return true

func _process_warp_sight(delta: float) -> void:
	if warp_sight_timer > 0.0:
		warp_sight_timer -= delta
		if warp_sight_timer <= 0.0:
			if attribute_system != null:
				attribute_system.remove_modifiers_by_source("vael_warp_sight_range")

# --- R: FALLING STAR (ULTIMATE) ---

func cast_vael_r(target_pos: Vector3, enemies_in_radius: Array[BaseCombatEntity] = []) -> bool:
	if not can_cast():
		return false
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast(AbilityResource.Slot.R):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return false
		
	var dir = (target_pos - global_position).normalized() if is_inside_tree() else (target_pos - position).normalized()
	_record_aim_direction(dir)
	
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var intel = attribute_system.get_stat(StatModifier.TargetStat.INTELLIGENCE)
	var calib_mult = 1.0 + (calibration_stacks * 0.10)
	var base_total = (base_dmg + (intel * r_res.scaling_ratio)) * calib_mult
	
	var hits = 0
	var sum_damage = 0.0
	for enemy in enemies_in_radius:
		if enemy != null and is_instance_valid(enemy) and enemy.is_alive() and enemy.team != team:
			var enemy_pos = enemy.global_position if enemy.is_inside_tree() else enemy.position
			var dist = enemy_pos.distance_to(target_pos)
			var center_bonus = 1.50 if dist <= 2.5 else 1.0 # +50% in center
			var final_dmg = base_total * center_bonus
			
			var req = DamageRequest.create_ability_damage(self, enemy, final_dmg, DamageRequest.DamageType.MAGICAL, "Falling Star")
			CombatCalculator.execute_damage(req)
			hits += 1
			sum_damage += final_dmg
			
	falling_star_impact.emit(target_pos, hits, sum_damage)
	return true

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	calibration_stacks = 0
	calibration_timer = 0.0
	warp_sight_timer = 0.0
	marked_targets.clear()
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("vael_warp_sight_range")

func respawn() -> void:
	super.respawn()
	calibration_stacks = 0
	calibration_timer = 0.0
	warp_sight_timer = 0.0
	marked_targets.clear()
