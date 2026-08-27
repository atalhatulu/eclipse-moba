class_name MiraHero
extends HeroEntity

## Implementation of Mira (AGI Mobility Carry / Velocity & Sonic Run)

signal velocity_updated(bonus_ad: float, total_ms: float)
signal dash_strike_hit(target: BaseCombatEntity, damage: float)
signal slip_activated()
signal accelerate_activated()
signal sonic_run_activated()
signal sonic_run_ended()

# State
var is_evading: bool = false
var slip_timer: float = 0.0
var accelerate_timer: float = 0.0
var is_sonic_running: bool = false
var sonic_run_timer: float = 0.0
var sonic_damaged_targets: Array[BaseCombatEntity] = []

const BASELINE_MOVE_SPEED: float = 330.0
var last_calculated_velocity_ad: float = 0.0

func _ready() -> void:
	entity_name = "Mira"
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_mira_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.45
		shape.height = 1.85
		col.shape = shape
		col.position.y = 0.92
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("MiraVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "MiraVisual"
		add_child(root_vis)
		
		# Aerodynamic Sleek Runner Body
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.40
		body_capsule.height = 1.85
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.92
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.92, 0.78, 0.15, 1.0) # Radiant Golden Yellow
		body_mat.metallic = 0.7
		body_mat.roughness = 0.25
		body_mat.emission_enabled = true
		body_mat.emission = Color(1.0, 0.9, 0.3, 1.0)
		body_mat.emission_energy_multiplier = 1.0
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
		# Streamline Wind Ribbons
		for side in [-0.45, 0.45]:
			var wing = MeshInstance3D.new()
			var w_box = BoxMesh.new()
			w_box.size = Vector3(0.12, 0.35, 0.75)
			wing.mesh = w_box
			wing.position = Vector3(side, 1.1, -0.25)
			
			var w_mat = StandardMaterial3D.new()
			w_mat.albedo_color = Color(0.2, 0.8, 1.0, 1.0) # Wind Trail Cyan
			w_mat.emission_enabled = true
			w_mat.emission = Color(0.2, 0.8, 1.0, 1.0)
			w_mat.emission_energy_multiplier = 1.2
			wing.material_override = w_mat
			root_vis.add_child(wing)
			
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

func _apply_mira_definition() -> void:
	if hero_resource == null:
		hero_resource = MiraDefinition.create_resource()
		
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
	_process_velocity()
	_process_slip(delta)
	_process_accelerate(delta)
	_process_sonic_run(delta)

# --- PASSIVE: VELOCITY ---

func _process_velocity() -> void:
	if attribute_system == null or not is_alive():
		return
		
	var cur_ms = attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	var excess_ms = maxf(0.0, cur_ms - BASELINE_MOVE_SPEED)
	var bonus_ad = (excess_ms / 10.0) * 2.5
	
	if absf(bonus_ad - last_calculated_velocity_ad) > 0.05:
		attribute_system.remove_modifiers_by_source("mira_velocity_ad")
		if bonus_ad > 0.0:
			var mod = StatModifier.new(StatModifier.TargetStat.ATTACK_DAMAGE, StatModifier.Type.FLAT, bonus_ad, "mira_velocity_ad")
			attribute_system.add_modifier(mod)
		last_calculated_velocity_ad = bonus_ad
		velocity_updated.emit(bonus_ad, cur_ms)

# --- Q: DASH STRIKE ---

func cast_mira_q(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * q_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.Q, target):
		return null
		
	# Dash towards target
	var dir = (target.global_position - global_position).normalized() if is_inside_tree() else (target.position - position).normalized()
	if dir.length_squared() < 0.1:
		dir = Vector3(1, 0, 0)
	if is_inside_tree():
		global_position += dir * 4.5
	else:
		position += dir * 4.5
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Dash Strike")
	var res = CombatCalculator.execute_damage(req)
	
	dash_strike_hit.emit(target, total_dmg)
	return res

# --- W: SLIP ---

func cast_mira_w() -> bool:
	if not can_cast():
		return false
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	is_evading = true
	slip_timer = 0.60
	
	# Apply 25% MS for 2.0s
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("mira_slip_ms")
		var mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.25, "mira_slip_ms")
		attribute_system.add_modifier(mod)
		
	slip_activated.emit()
	return true

func _process_slip(delta: float) -> void:
	if slip_timer > 0.0:
		slip_timer -= delta
		if slip_timer <= 0.0:
			is_evading = false
			if attribute_system != null:
				attribute_system.remove_modifiers_by_source("mira_slip_ms")

# --- E: ACCELERATE ---

func cast_mira_e() -> bool:
	if not can_cast():
		return false
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return false
		
	accelerate_timer = 4.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("mira_accel_ms")
		attribute_system.remove_modifiers_by_source("mira_accel_as")
		var ms_mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.40, "mira_accel_ms")
		var as_mod = StatModifier.new(StatModifier.TargetStat.ATTACK_SPEED, StatModifier.Type.PERCENT_ADD, 0.30, "mira_accel_as")
		attribute_system.add_modifier(ms_mod)
		attribute_system.add_modifier(as_mod)
		
	accelerate_activated.emit()
	return true

func _process_accelerate(delta: float) -> void:
	if accelerate_timer > 0.0:
		accelerate_timer -= delta
		if accelerate_timer <= 0.0:
			if attribute_system != null:
				attribute_system.remove_modifiers_by_source("mira_accel_ms")
				attribute_system.remove_modifiers_by_source("mira_accel_as")

# --- R: SONIC RUN (ULTIMATE) ---

func cast_mira_r() -> bool:
	if not can_cast():
		return false
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast(AbilityResource.Slot.R):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return false
		
	is_sonic_running = true
	sonic_run_timer = 5.0
	sonic_damaged_targets.clear()
	
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("mira_sonic_ms")
		var mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.80, "mira_sonic_ms")
		attribute_system.add_modifier(mod)
		
	sonic_run_activated.emit()
	return true

func trigger_sonic_contact_damage(enemy: BaseCombatEntity) -> DamageResult:
	if not is_sonic_running or enemy == null or not is_instance_valid(enemy) or not enemy.is_alive() or enemy.team == team:
		return null
	if sonic_damaged_targets.has(enemy):
		return null
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl) if r_res != null else 150.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * 0.60)
	
	var req = DamageRequest.create_ability_damage(self, enemy, total_dmg, DamageRequest.DamageType.PHYSICAL, "Sonic Run")
	var res = CombatCalculator.execute_damage(req)
	
	sonic_damaged_targets.append(enemy)
	return res

func _process_sonic_run(delta: float) -> void:
	if is_sonic_running:
		sonic_run_timer -= delta
		if sonic_run_timer <= 0.0:
			is_sonic_running = false
			sonic_damaged_targets.clear()
			if attribute_system != null:
				attribute_system.remove_modifiers_by_source("mira_sonic_ms")
			sonic_run_ended.emit()

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	is_evading = false
	slip_timer = 0.0
	accelerate_timer = 0.0
	is_sonic_running = false
	sonic_run_timer = 0.0
	sonic_damaged_targets.clear()
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("mira_velocity_ad")
		attribute_system.remove_modifiers_by_source("mira_slip_ms")
		attribute_system.remove_modifiers_by_source("mira_accel_ms")
		attribute_system.remove_modifiers_by_source("mira_accel_as")
		attribute_system.remove_modifiers_by_source("mira_sonic_ms")

func respawn() -> void:
	super.respawn()
	is_evading = false
	slip_timer = 0.0
	accelerate_timer = 0.0
	is_sonic_running = false
	sonic_run_timer = 0.0
	sonic_damaged_targets.clear()
