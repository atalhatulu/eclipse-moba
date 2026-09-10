class_name ValgorHero
extends HeroEntity

const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")
const DefScript = preload("res://data/heroes/valgor_definition.gd")

## Implementation of Valgor (The Dual Sovereign / Tactical Gladiator)
## Shifts stances between heavy melee brutality and rapid dual blade surges.

signal stance_shifted(dest: Vector3)
signal twin_discipline_cleaved(hits: int)
signal tactical_surge_activated(duration: float)
signal dual_equilibrium_entered(duration: float)

var valgor_visual_root: Node3D = null
var twin_blade_left: MeshInstance3D = null
var twin_blade_right: MeshInstance3D = null

# E: Tactical Surge State
var is_tactical_surge: bool = false
var tactical_surge_timer: float = 0.0

# R: Dual Equilibrium State
var is_equilibrium: bool = false
var equilibrium_timer: float = 0.0

func _ready() -> void:
	entity_name = "Valgor"
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_def()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.58
		shape.height = 2.1
		col.shape = shape
		col.position.y = 1.05
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("ValgorVisual"):
		valgor_visual_root = Node3D.new()
		valgor_visual_root.name = "ValgorVisual"
		add_child(valgor_visual_root)
		
		# Gladiator Armor (Dark Steel & Crimson)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.52
		body_capsule.height = 2.0
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.0
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.25, 0.25, 0.28, 1.0) # Gunmetal Gladiator Plate
		body_mat.metallic = 0.85
		body_inst.material_override = body_mat
		valgor_visual_root.add_child(body_inst)
		
		# Twin Sovereign Blades
		twin_blade_left = MeshInstance3D.new()
		var b_box = BoxMesh.new()
		b_box.size = Vector3(0.12, 1.2, 0.22)
		twin_blade_left.mesh = b_box
		twin_blade_left.position = Vector3(-0.65, 1.0, 0.3)
		
		var b_mat = StandardMaterial3D.new()
		b_mat.albedo_color = Color(0.85, 0.15, 0.15, 1.0) # Blood Red Blade Edge
		b_mat.metallic = 0.95
		twin_blade_left.material_override = b_mat
		valgor_visual_root.add_child(twin_blade_left)
		
		twin_blade_right = MeshInstance3D.new()
		twin_blade_right.mesh = b_box
		twin_blade_right.position = Vector3(0.65, 1.0, 0.3)
		twin_blade_right.material_override = b_mat
		valgor_visual_root.add_child(twin_blade_right)
	else:
		valgor_visual_root = get_node_or_null("ValgorVisual")

func _apply_def() -> void:
	var def = DefScript.create_resource()
	hero_resource = def
	_apply_hero_resource(def)
	
	ability_container.set_ability(AbilityResource.Slot.Q, def.q_ability)
	ability_container.set_ability(AbilityResource.Slot.W, def.w_ability)
	ability_container.set_ability(AbilityResource.Slot.E, def.e_ability)
	ability_container.set_ability(AbilityResource.Slot.R, def.r_ability)

func _process(delta: float) -> void:
	super._process(delta)
	_process_buffs(delta)

func _process_buffs(delta: float) -> void:
	if is_tactical_surge:
		tactical_surge_timer -= delta
		if tactical_surge_timer <= 0.0:
			is_tactical_surge = false
			attribute_system.remove_modifiers_by_source("valgor_tactical_surge")
			
	if is_equilibrium:
		equilibrium_timer -= delta
		if equilibrium_timer <= 0.0:
			is_equilibrium = false
			attribute_system.remove_modifiers_by_source("valgor_equilibrium")

# --- Q: STANCE SHIFT (DIRECTIONAL DASH & STRIKE) ---
func cast_valgor_q(target_point: Vector3) -> bool:
	if not can_cast():
		return false
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, null, target_point):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * q_res.scaling_ratio)
	
	var cur_pos = global_position if is_inside_tree() else position
	var dir = (target_point - cur_pos).normalized()
	dir.y = 0.0
	if dir.length_squared() < 0.001:
		dir = -transform.basis.z.normalized()
		
	var dest = cur_pos + (dir * 5.0)
	
	if not ability_container.cast_ability(AbilityResource.Slot.Q, null, target_point):
		return false
		
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if entity.global_position.distance_to(dest) <= 2.5:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.PHYSICAL, "Stance Shift")
					CombatCalculator.execute_damage(req)
		global_position = dest
	else:
		position = dest
		
	stance_shifted.emit(dest)
	return true

# --- W: TWIN DISCIPLINE (DIRECTIONAL DUAL BLADE CLEAVE) ---
func cast_valgor_w(target_point: Vector3) -> bool:
	if not can_cast():
		return false
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.W, null, target_point):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var base_dmg = w_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * w_res.scaling_ratio)
	
	var cur_pos = global_position if is_inside_tree() else position
	var dir = (target_point - cur_pos).normalized()
	dir.y = 0.0
	if dir.length_squared() < 0.001:
		dir = -transform.basis.z.normalized()
		
	if not ability_container.cast_ability(AbilityResource.Slot.W, null, target_point):
		return false
		
	var hits := 0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if cur_pos.distance_to(entity.global_position) <= 4.5:
					var to_e = (entity.global_position - cur_pos).normalized()
					if dir.dot(to_e) > 0.4:
						var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.PHYSICAL, "Twin Discipline")
						CombatCalculator.execute_damage(req)
						hits += 1
						
	twin_discipline_cleaved.emit(hits)
	return true

# --- E: TACTICAL SURGE (SELF COMBAT STEROID) ---
func cast_valgor_e() -> bool:
	if not can_cast():
		return false
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return false
		
	is_tactical_surge = true
	tactical_surge_timer = 4.0
	
	var as_mod = StatModifier.new(StatModifier.TargetStat.ATTACK_SPEED, StatModifier.Type.PERCENT_ADD, 0.40, "valgor_tactical_surge")
	var ms_mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.25, "valgor_tactical_surge")
	attribute_system.add_modifier(as_mod)
	attribute_system.add_modifier(ms_mod)
	
	tactical_surge_activated.emit(4.0)
	return true

# --- R: DUAL EQUILIBRIUM (DUAL SOVEREIGN TRANCE) ---
func cast_valgor_r() -> bool:
	if not can_cast():
		return false
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast(AbilityResource.Slot.R):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * r_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return false
		
	is_equilibrium = true
	equilibrium_timer = 6.0
	
	var ad_mod = StatModifier.new(StatModifier.TargetStat.ATTACK_DAMAGE, StatModifier.Type.FLAT, 35.0, "valgor_equilibrium")
	attribute_system.add_modifier(ad_mod)
	
	# Burst around self upon activating
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if global_position.distance_to(entity.global_position) <= 5.0:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.PHYSICAL, "Dual Equilibrium")
					CombatCalculator.execute_damage(req)
					
	dual_equilibrium_entered.emit(6.0)
	return true
