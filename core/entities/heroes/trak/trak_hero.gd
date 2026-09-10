class_name TrakHero
extends HeroEntity

const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")
const DefScript = preload("res://data/heroes/trak_definition.gd")

## Implementation of Trak (The Kinetic Brawler)
## Punches enemies with hydraulic spring power, ricocheting and triggering shockwaves.

signal spring_punched(target: BaseCombatEntity)
signal ricochet_activated(duration: float)
signal shockwave_slammed(center: Vector3, enemies_hit: int)
signal pinball_bounced(bounces: int)

var trak_visual_root: Node3D = null
var hydraulic_gauntlets: MeshInstance3D = null

# W: Ricochet Buff State
var is_ricocheting: bool = false
var ricochet_timer: float = 0.0

func _ready() -> void:
	entity_name = "Trak"
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_def()

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
	if not has_node("TrakVisual"):
		trak_visual_root = Node3D.new()
		trak_visual_root.name = "TrakVisual"
		add_child(trak_visual_root)
		
		# Street Brawler Body (Rust Orange)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.52
		body_capsule.height = 2.0
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.0
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.85, 0.45, 0.10, 1.0) # Rust Industrial Orange
		body_mat.metallic = 0.4
		body_inst.material_override = body_mat
		trak_visual_root.add_child(body_inst)
		
		# Hydraulic Kinetic Gauntlets
		hydraulic_gauntlets = MeshInstance3D.new()
		var fist_box = BoxMesh.new()
		fist_box.size = Vector3(0.40, 0.40, 0.55)
		hydraulic_gauntlets.mesh = fist_box
		hydraulic_gauntlets.position = Vector3(0.55, 1.0, 0.45)
		
		var fist_mat = StandardMaterial3D.new()
		fist_mat.albedo_color = Color(0.30, 0.32, 0.35, 1.0) # Heavy Steel
		fist_mat.metallic = 0.9
		hydraulic_gauntlets.material_override = fist_mat
		trak_visual_root.add_child(hydraulic_gauntlets)
	else:
		trak_visual_root = get_node_or_null("TrakVisual")

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
	_process_ricochet(delta)

func _process_ricochet(delta: float) -> void:
	if not is_ricocheting:
		return
	ricochet_timer -= delta
	if ricochet_timer <= 0.0:
		is_ricocheting = false
		attribute_system.remove_modifiers_by_source("trak_ricochet")

# --- Q: SPRING PUNCH (DIRECTIONAL PUNCH & KNOCKBACK) ---
func cast_trak_q(target_point: Vector3) -> bool:
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
		
	if not ability_container.cast_ability(AbilityResource.Slot.Q, null, target_point):
		return false
		
	var hit_ent: BaseCombatEntity = null
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if cur_pos.distance_to(entity.global_position) <= 4.5:
					var to_e = (entity.global_position - cur_pos).normalized()
					if dir.dot(to_e) > 0.5:
						var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.PHYSICAL, "Spring Punch")
						CombatCalculator.execute_damage(req)
						entity.global_position += dir * 3.0
						if "effect_container" in entity and entity.effect_container != null:
							entity.effect_container.apply_stun(0.8)
						hit_ent = entity
						break
						
	spring_punched.emit(hit_ent)
	return true

# --- W: RICOCHET (SELF SPEED & HYDRAULIC OVERCHARGE) ---
func cast_trak_w() -> bool:
	if not can_cast():
		return false
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	is_ricocheting = true
	ricochet_timer = 4.0
	
	var ms_mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.30, "trak_ricochet")
	var as_mod = StatModifier.new(StatModifier.TargetStat.ATTACK_SPEED, StatModifier.Type.PERCENT_ADD, 0.30, "trak_ricochet")
	attribute_system.add_modifier(ms_mod)
	attribute_system.add_modifier(as_mod)
	
	ricochet_activated.emit(4.0)
	return true

# --- E: SHOCKWAVE (GROUND AOE SLAM & SLOW) ---
func cast_trak_e(target_point: Vector3) -> bool:
	if not can_cast():
		return false
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.E, null, target_point):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var base_dmg = e_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * e_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.E, null, target_point):
		return false
		
	var hits := 0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if target_point.distance_to(entity.global_position) <= 3.8:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.PHYSICAL, "Shockwave")
					CombatCalculator.execute_damage(req)
					if "effect_container" in entity and entity.effect_container != null:
						entity.effect_container.apply_slow(0.50, 2.0)
					hits += 1
					
	shockwave_slammed.emit(target_point, hits)
	return true

# --- R: PINBALL (KINETIC RICOCHET BOUNCES) ---
func cast_trak_r() -> bool:
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
		
	var bounces := 0
	var cur_center = global_position if is_inside_tree() else position
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if bounces >= 4:
				break
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if cur_center.distance_to(entity.global_position) <= 6.5:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.PHYSICAL, "Pinball")
					CombatCalculator.execute_damage(req)
					if "effect_container" in entity and entity.effect_container != null:
						entity.effect_container.apply_stun(0.4)
					cur_center = entity.global_position
					bounces += 1
					
	pinball_bounced.emit(bounces)
	return true
