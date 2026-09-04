class_name MordrenHero
extends HeroEntity

const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")

## Implementation of Mordren (The Bloodcleaver / STR Fighter & Executioner)

signal hunt_mark_applied(target: BaseCombatEntity)
signal shield_granted(amount: float)
signal final_hunt_executed(target: BaseCombatEntity)

# Passive & State tracking
var is_blood_trail_active: bool = false
var blood_trail_burst_timer: float = 0.0

func _ready() -> void:
	entity_name = "Mordren"
	hero_resource = MordrenDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_mordren_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.60
		shape.height = 2.1
		col.shape = shape
		col.position.y = 1.05
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("MordrenVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "MordrenVisual"
		add_child(root_vis)
		
		# Lean & Menacing Armored Body (2.1m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.55
		body_capsule.height = 2.1
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.05
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.35, 0.12, 0.12, 1.0) # Blood Red / Dark Crimson
		body_mat.metallic = 0.70
		body_mat.roughness = 0.45
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
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

func _apply_mordren_definition() -> void:
	if hero_resource == null:
		hero_resource = MordrenDefinition.create_resource()
		
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
	
	# Process Blood Trail speed tracking
	_process_blood_trail(delta)

# --- PASSIVE: HUNT MARK & BASIC ATTACK INTERACTION ---

func has_hunt_mark(target: BaseCombatEntity) -> bool:
	if target == null or not is_instance_valid(target) or target.effect_container == null:
		return false
	return target.effect_container.has_effect("mark_mordren_hunt")

func apply_hunt_mark(target: BaseCombatEntity) -> void:
	if target == null or not is_instance_valid(target) or not target.is_alive() or target.team == team:
		return
		
	CombatMechanicsClass.apply_mark(self, target, "mordren_hunt", "Av Damgası", 5.0, 1, "✣")
	hunt_mark_applied.emit(target)

func execute_basic_attack(target: BaseCombatEntity) -> DamageResult:
	var res = super.execute_basic_attack(target)
	if res != null and target != null and is_instance_valid(target):
		var was_marked = has_hunt_mark(target)
		apply_hunt_mark(target)
		if was_marked:
			_trigger_relentless_shield()
	return res

# --- W: BLOOD TRAIL PASSIVE & ACTIVE ---

func _process_blood_trail(delta: float) -> void:
	if not is_alive():
		_clear_blood_trail_modifiers()
		return
		
	if blood_trail_burst_timer > 0.0:
		blood_trail_burst_timer -= delta
		if blood_trail_burst_timer <= 0.0:
			attribute_system.remove_modifiers_by_source("mordren_blood_trail_burst")
			
	var has_nearby_marked = false
	var my_pos = global_position if (is_inside_tree() or global_position != Vector3.ZERO) else position
	
	for h in HeroEntity.active_heroes:
		if is_instance_valid(h) and h.is_alive() and h.team != team and has_hunt_mark(h):
			var h_pos = h.global_position if (h.is_inside_tree() or h.global_position != Vector3.ZERO) else h.position
			if my_pos.distance_to(h_pos) <= 12.0:
				has_nearby_marked = true
				break
				
	if has_nearby_marked:
		if not is_blood_trail_active:
			is_blood_trail_active = true
			attribute_system.remove_modifiers_by_source("mordren_blood_trail")
			var mod = StatModifier.new(
				StatModifier.TargetStat.MOVE_SPEED,
				StatModifier.Type.PERCENT_ADD,
				0.25, # +25% Move Speed
				"mordren_blood_trail"
			)
			attribute_system.add_modifier(mod)
	else:
		if is_blood_trail_active:
			is_blood_trail_active = false
			attribute_system.remove_modifiers_by_source("mordren_blood_trail")

func _clear_blood_trail_modifiers() -> void:
	is_blood_trail_active = false
	blood_trail_burst_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("mordren_blood_trail")
		attribute_system.remove_modifiers_by_source("mordren_blood_trail_burst")

func cast_mordren_w() -> bool:
	if not can_cast():
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	blood_trail_burst_timer = 3.0
	attribute_system.remove_modifiers_by_source("mordren_blood_trail_burst")
	var burst_mod = StatModifier.new(
		StatModifier.TargetStat.MOVE_SPEED,
		StatModifier.Type.PERCENT_ADD,
		0.40, # +40% Burst Move Speed
		"mordren_blood_trail_burst"
	)
	attribute_system.add_modifier(burst_mod)
	return true

# --- E: RELENTLESS SHIELD ---

func _trigger_relentless_shield() -> void:
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var shield_amounts = [120.0, 180.0, 240.0, 300.0]
	var shield_val = shield_amounts[clamp(lvl - 1, 0, 3)]
	
	if effect_container != null:
		var shield_eff = StatusEffect.new("mordren_relentless_shield", StatusEffect.EffectType.SHIELD, 4.0, shield_val, false)
		effect_container.apply_effect(shield_eff)
		shield_granted.emit(shield_val)

func cast_mordren_e() -> bool:
	if not can_cast():
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return false
		
	_trigger_relentless_shield()
	return true

# --- Q: CLEAVER ---

func cast_mordren_q(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * q_res.scaling_ratio)
	
	var is_marked = has_hunt_mark(target)
	if is_marked:
		total_dmg *= 1.50 # +50% Bonus Damage on Marked Targets
		
	if not ability_container.cast_ability(AbilityResource.Slot.Q, target):
		return null
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Cleaver")
	var res = CombatCalculator.execute_damage(req)
	
	apply_hunt_mark(target)
	if is_marked:
		_trigger_relentless_shield()
		
	return res

# --- R: FINAL HUNT (EXECUTION ULTIMATE) ---

func cast_mordren_r(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	# Validation: Target MUST have Hunt Mark AND HP <= 35%
	if not has_hunt_mark(target):
		return null
		
	if not CombatMechanicsClass.is_below_health_threshold(target, 0.35):
		return null # Reject if target HP > 35%
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.R, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * r_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.R, target):
		return null
		
	# Dash Mordren directly to target position
	var t_pos = target.global_position if target.is_inside_tree() else target.position
	if is_inside_tree():
		global_position = t_pos
	else:
		position = t_pos
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Final Hunt")
	var res = CombatCalculator.execute_damage(req)
	# The marked health threshold is the permission to cast; the missing-health
	# portion is a separate true-damage finisher so armor cannot hide the execute.
	if target.is_alive():
		var execute_ratio = 0.15 + (0.05 * lvl)
		var execute_res = CombatMechanicsClass.execute_missing_health_damage(self, target, 0.0, execute_ratio, "Final Hunt Execute")
		CombatMechanicsClass.announce_execution(self, target, 0.35, execute_res.raw_damage, "Final Hunt")
	
	final_hunt_executed.emit(target)
	return res

# --- DEATH & RESPAWN OVERRIDES ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	_clear_blood_trail_modifiers()

func respawn() -> void:
	super.respawn()
	_clear_blood_trail_modifiers()
