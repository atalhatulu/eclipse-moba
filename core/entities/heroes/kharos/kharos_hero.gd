class_name KharosHero
extends HeroEntity

## Implementation of Kharos (The Bloodsoaked Berserker / STR Duelist)

const KharosDefinition = preload("res://data/heroes/kharos_definition.gd")

signal bloodrage_updated(missing_hp_pct: float, bonus_ad: float, bonus_as: float)
signal frenzy_stacked(stacks: int)
signal blood_rush_executed()
signal rage_reversal_struck(target: BaseCombatEntity, reflected_damage: float)
signal red_fury_activated()
signal red_fury_ended()

# Passive Bloodrage Stats
var last_calculated_ad: float = 0.0
var last_calculated_as: float = 0.0

# Q: Frenzy Slash State
var frenzy_stacks: int = 0
var frenzy_timer: float = 0.0

# W: Blood Rush State
var blood_rush_timer: float = 0.0

# E: Rage Reversal Damage Buffer
var recent_damage_taken: float = 0.0
var damage_history_timer: float = 0.0

# R: Red Fury State
var is_red_fury_active: bool = false
var red_fury_timer: float = 0.0

func _ready() -> void:
	entity_name = "Kharos"
	hero_resource = KharosDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_kharos_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.60
		shape.height = 2.0
		col.shape = shape
		col.position.y = 1.00
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("KharosVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "KharosVisual"
		add_child(root_vis)
		
		# Crimson Berserker Body (2.0m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.55
		body_capsule.height = 2.0
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.00
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.55, 0.12, 0.12, 1.0) # Blood Crimson & Dark Iron
		body_mat.metallic = 0.70
		body_mat.roughness = 0.40
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
		# Twin Crimson Blades Mesh
		for side in [-0.55, 0.55]:
			var blade = MeshInstance3D.new()
			var b_box = BoxMesh.new()
			b_box.size = Vector3(0.10, 1.20, 0.25)
			blade.mesh = b_box
			blade.position = Vector3(side, 0.90, 0.45)
			blade.rotation_degrees = Vector3(25, 0, 0)
			
			var b_mat = StandardMaterial3D.new()
			b_mat.albedo_color = Color(0.85, 0.15, 0.15, 1.0)
			b_mat.emission_enabled = true
			b_mat.emission = Color(1.0, 0.2, 0.2, 1.0)
			b_mat.emission_energy_multiplier = 0.8
			blade.material_override = b_mat
			root_vis.add_child(blade)
			
		# Selection Base Ring
		var ring = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.90
		torus.outer_radius = 0.95
		ring.mesh = torus
		ring.position.y = 0.03
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var ring_color = Color(0.95, 0.3, 0.3, 0.85) if team == TeamDefinitions.Team.DIRE else Color(0.92, 0.96, 1.0, 0.85)
		ring_mat.albedo_color = ring_color
		ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		ring.material_override = ring_mat
		root_vis.add_child(ring)

func _apply_kharos_definition() -> void:
	if hero_resource == null:
		hero_resource = KharosDefinition.create_resource()
		
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
	
	_process_bloodrage()
	_process_frenzy(delta)
	_process_blood_rush(delta)
	_process_damage_history(delta)
	_process_red_fury(delta)

# --- PASSIVE: BLOODRAGE ---

func _process_bloodrage() -> void:
	if not is_alive() or attribute_system == null:
		return
		
	var max_hp = attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	if max_hp <= 0.0:
		return
		
	var missing_pct = clampf(1.0 - (attribute_system.current_health / max_hp), 0.0, 1.0)
	var mult = 2.0 if is_red_fury_active else 1.0
	var bonus_ad = (missing_pct * 60.0) * mult
	var bonus_as = (missing_pct * 0.60) * mult
	
	if absf(bonus_ad - last_calculated_ad) > 0.5 or absf(bonus_as - last_calculated_as) > 0.01:
		last_calculated_ad = bonus_ad
		last_calculated_as = bonus_as
		
		attribute_system.remove_modifiers_by_source("kharos_bloodrage_ad")
		attribute_system.remove_modifiers_by_source("kharos_bloodrage_as")
		
		if bonus_ad > 0.1:
			attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ATTACK_DAMAGE, StatModifier.Type.FLAT, bonus_ad, "kharos_bloodrage_ad"))
		if bonus_as > 0.01:
			attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ATTACK_SPEED, StatModifier.Type.PERCENT_ADD, bonus_as, "kharos_bloodrage_as"))
			
		bloodrage_updated.emit(missing_pct, bonus_ad, bonus_as)

# --- Q: FRENZY SLASH ---

func cast_kharos_q(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var multiplier = 1.0 + (frenzy_stacks * 0.15)
	var total_dmg = (base_dmg + (ad * q_res.scaling_ratio)) * multiplier
	
	if not ability_container.cast_ability(AbilityResource.Slot.Q, target):
		return null
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Frenzy Slash")
	var res = CombatCalculator.execute_damage(req)
	
	frenzy_stacks = mini(5, frenzy_stacks + 1)
	frenzy_timer = 4.0
	frenzy_stacked.emit(frenzy_stacks)
	
	return res

func _process_frenzy(delta: float) -> void:
	if frenzy_timer > 0.0:
		frenzy_timer -= delta
		if frenzy_timer <= 0.0:
			frenzy_stacks = 0

# --- W: BLOOD RUSH ---

func cast_kharos_w() -> bool:
	if not can_cast():
		return false
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	# Pay 8% current HP cost
	var hp_cost = attribute_system.current_health * 0.08
	attribute_system.current_health = maxf(1.0, attribute_system.current_health - hp_cost)
	
	# Dash forward 4.5m
	var forward_dir = -transform.basis.z.normalized() if is_inside_tree() else Vector3(1, 0, 0)
	if forward_dir.length_squared() < 0.1:
		forward_dir = Vector3(1, 0, 0)
	if is_inside_tree():
		global_position += forward_dir * 4.5
	else:
		position += forward_dir * 4.5
		
	# Apply 30% Move Speed for 3.5s
	blood_rush_timer = 3.5
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("kharos_blood_rush_ms")
		var mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.30, "kharos_blood_rush_ms")
		attribute_system.add_modifier(mod)
		
	blood_rush_executed.emit()
	return true

func _process_blood_rush(delta: float) -> void:
	if blood_rush_timer > 0.0:
		blood_rush_timer -= delta
		if blood_rush_timer <= 0.0:
			if attribute_system != null:
				attribute_system.remove_modifiers_by_source("kharos_blood_rush_ms")

# --- E: RAGE REVERSAL ---

func take_damage_recorded(amount: float) -> void:
	recent_damage_taken += amount
	damage_history_timer = 2.5

func _process_damage_history(delta: float) -> void:
	if damage_history_timer > 0.0:
		damage_history_timer -= delta
		if damage_history_timer <= 0.0:
			recent_damage_taken = 0.0

func cast_kharos_e(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.E, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var base_dmg = e_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var reflected = recent_damage_taken * 0.35
	var total_dmg = base_dmg + (ad * e_res.scaling_ratio) + reflected
	
	if not ability_container.cast_ability(AbilityResource.Slot.E, target):
		return null
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Rage Reversal")
	var res = CombatCalculator.execute_damage(req)
	
	rage_reversal_struck.emit(target, reflected)
	recent_damage_taken = 0.0
	return res

# --- R: RED FURY (ULTIMATE) ---

func cast_kharos_r() -> bool:
	if not can_cast():
		return false
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast(AbilityResource.Slot.R):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return false
		
	is_red_fury_active = true
	red_fury_timer = 4.0
	
	_process_bloodrage()
	red_fury_activated.emit()
	return true

func _process_red_fury(delta: float) -> void:
	if is_red_fury_active:
		red_fury_timer -= delta
		
		# Invulnerability clamp: cannot drop below 1 HP during Red Fury
		if attribute_system != null and attribute_system.current_health < 1.0 and is_alive():
			attribute_system.current_health = 1.0
			
		if red_fury_timer <= 0.0:
			is_red_fury_active = false
			red_fury_timer = 0.0
			_process_bloodrage()
			red_fury_ended.emit()

func heal_kharos(amount: float) -> void:
	if attribute_system == null or not is_alive():
		return
	var mult = 0.50 if is_red_fury_active else 1.0
	attribute_system.heal(amount * mult)

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	frenzy_stacks = 0
	frenzy_timer = 0.0
	blood_rush_timer = 0.0
	recent_damage_taken = 0.0
	damage_history_timer = 0.0
	is_red_fury_active = false
	red_fury_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("kharos_bloodrage_ad")
		attribute_system.remove_modifiers_by_source("kharos_bloodrage_as")
		attribute_system.remove_modifiers_by_source("kharos_blood_rush_ms")

func respawn() -> void:
	super.respawn()
	frenzy_stacks = 0
	frenzy_timer = 0.0
	blood_rush_timer = 0.0
	recent_damage_taken = 0.0
	damage_history_timer = 0.0
	is_red_fury_active = false
	red_fury_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("kharos_bloodrage_ad")
		attribute_system.remove_modifiers_by_source("kharos_bloodrage_as")
		attribute_system.remove_modifiers_by_source("kharos_blood_rush_ms")
