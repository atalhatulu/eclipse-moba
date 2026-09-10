class_name DrogasHero
extends HeroEntity

const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")

## Implementation of Drogas (The Siege Ram / STR Battering Behemoth)
## Devastates battlefield structures and infantry with Ram Charge, Trench fortification, Rubble Toss, and Living Catapult.

signal ram_charged(origin: Vector3, dest: Vector3, enemies_hit: int)
signal trench_fortified(active: bool)
signal rubble_thrown(target_point: Vector3, hit: bool)
signal catapult_launched(center: Vector3, hit_count: int)

var drogas_visual_root: Node3D = null
var ram_head: MeshInstance3D = null

# W: Trench Fortify State
var is_trenched: bool = false
var trench_timer: float = 0.0

func _ready() -> void:
	entity_name = "Drogas"
	hero_resource = DrogasDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_drogas_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.70
		shape.height = 2.2
		col.shape = shape
		col.position.y = 1.10
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("DrogasVisual"):
		drogas_visual_root = Node3D.new()
		drogas_visual_root.name = "DrogasVisual"
		add_child(drogas_visual_root)
		
		# Heavy Iron-Stone Battering Body
		var body_inst = MeshInstance3D.new()
		var body_box = BoxMesh.new()
		body_box.size = Vector3(1.3, 1.8, 1.4)
		body_inst.mesh = body_box
		body_inst.position.y = 1.0
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.28, 0.26, 0.24, 1.0) # Weathered Iron Ore
		mat.metallic = 0.8
		mat.roughness = 0.5
		body_inst.material_override = mat
		drogas_visual_root.add_child(body_inst)
		
		# Battering Ram Piston / Horn
		ram_head = MeshInstance3D.new()
		var horn = CylinderMesh.new()
		horn.top_radius = 0.35
		horn.bottom_radius = 0.50
		horn.height = 0.80
		ram_head.mesh = horn
		ram_head.position = Vector3(0.0, 1.1, 0.85)
		ram_head.rotation_degrees = Vector3(90, 0, 0)
		
		var ram_mat = StandardMaterial3D.new()
		ram_mat.albedo_color = Color(0.18, 0.16, 0.15, 1.0)
		ram_mat.metallic = 0.9
		ram_head.material_override = ram_mat
		drogas_visual_root.add_child(ram_head)
	else:
		drogas_visual_root = get_node_or_null("DrogasVisual")

func _apply_drogas_definition() -> void:
	if hero_resource == null:
		hero_resource = DrogasDefinition.create_resource()
		
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
	
	attribute_system.current_health = def.base_health
	attribute_system.current_mana = def.base_mana
	attribute_system.recalculate_all_stats()
	
	ability_container.set_ability(AbilityResource.Slot.Q, def.q_ability)
	ability_container.set_ability(AbilityResource.Slot.W, def.w_ability)
	ability_container.set_ability(AbilityResource.Slot.E, def.e_ability)
	ability_container.set_ability(AbilityResource.Slot.R, def.r_ability)

func _process(delta: float) -> void:
	super._process(delta)
	_process_trench(delta)

func _process_trench(delta: float) -> void:
	if not is_trenched:
		return
	trench_timer -= delta
	if trench_timer <= 0.0:
		is_trenched = false
		attribute_system.remove_modifiers_by_source("drogas_trench")
		trench_fortified.emit(false)

# --- Q: RAM CHARGE (DIRECTIONAL CHARGE + KNOCKBACK) ---
func cast_drogas_q(target_point: Vector3) -> bool:
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
		
	var charge_dist = minf(6.0, cur_pos.distance_to(target_point))
	if charge_dist < 1.0:
		charge_dist = 5.5
	var dest = cur_pos + dir * charge_dist
	
	if not ability_container.cast_ability(AbilityResource.Slot.Q, null, target_point):
		return false
		
	if is_inside_tree():
		global_position = dest
	else:
		position = dest
		
	var hit_count := 0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				var dist_to_line = (entity.global_position - cur_pos).cross(dir).length()
				var dot = (entity.global_position - cur_pos).dot(dir)
				if dot >= 0.0 and dot <= charge_dist and dist_to_line <= 2.2:
					var is_struct = (entity is TowerEntity or entity is ObjectiveEntity)
					var dmg = total_dmg * 1.5 if is_struct else total_dmg
					var req = DamageRequest.create_ability_damage(self, entity, dmg, DamageRequest.DamageType.PHYSICAL, "Ram Charge")
					CombatCalculator.execute_damage(req)
					# Knockback
					entity.global_position += dir * 2.5
					if "effect_container" in entity and entity.effect_container != null:
						entity.effect_container.apply_slow(0.35, 1.8)
					hit_count += 1
					
	ram_charged.emit(cur_pos, dest, hit_count)
	return true

# --- W: TRENCH (SELF FORTIFICATION + SLOW AURA) ---
func cast_drogas_w() -> bool:
	if not can_cast():
		return false
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var shield_val = 150.0 + (lvl * 55.0) + (ad * 0.50)
	
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	is_trenched = true
	trench_timer = 3.5
	
	# Add flat bonus armor
	var armor_mod = StatModifier.new(StatModifier.TargetStat.ARMOR, StatModifier.Type.FLAT, 35.0, "drogas_trench")
	attribute_system.add_modifier(armor_mod)
	CombatMechanicsClass.apply_shield(self, self, "drogas_trench_shield", "Mevzi Kalkanı", shield_val, 3.5)
	
	# Slow nearby enemies
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if global_position.distance_to(entity.global_position) <= 5.0:
					if "effect_container" in entity and entity.effect_container != null:
						entity.effect_container.apply_slow(0.40, 2.5)
						
	trench_fortified.emit(true)
	return true

# --- E: RUBBLE TOSS (DIRECTIONAL BOULDER STUN) ---
func cast_drogas_e(target_point: Vector3) -> bool:
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
		
	var cur_pos = global_position if is_inside_tree() else position
	var dir = (target_point - cur_pos).normalized()
	dir.y = 0.0
	var hit := false
	
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if cur_pos.distance_to(entity.global_position) <= 7.0:
					var to_e = (entity.global_position - cur_pos).normalized()
					if dir.dot(to_e) > 0.85:
						var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.PHYSICAL, "Rubble Toss")
						CombatCalculator.execute_damage(req)
						if "effect_container" in entity and entity.effect_container != null:
							entity.effect_container.apply_stun(1.3)
						hit = true
						break
						
	rubble_thrown.emit(target_point, hit)
	return true

# --- R: LIVING CATAPULT (SIEGE BOMBARDMENT) ---
func cast_drogas_r(target_point: Vector3) -> bool:
	if not can_cast():
		return false
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.R, null, target_point):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * r_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.R, null, target_point):
		return false
		
	var hit_count := 0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if target_point.distance_to(entity.global_position) <= 6.5:
					var is_struct = (entity is TowerEntity or entity is ObjectiveEntity)
					var dmg = total_dmg * 1.6 if is_struct else total_dmg
					var req = DamageRequest.create_ability_damage(self, entity, dmg, DamageRequest.DamageType.PHYSICAL, "Living Catapult")
					CombatCalculator.execute_damage(req)
					if "effect_container" in entity and entity.effect_container != null:
						entity.effect_container.apply_slow(0.50, 3.0)
					hit_count += 1
					
	catapult_launched.emit(target_point, hit_count)
	return true
