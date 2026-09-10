class_name OkarHero
extends HeroEntity

const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")
const DefScript = preload("res://data/heroes/okar_definition.gd")

## Implementation of Okar (The Rhythm Master / Blind Monk Martial Artist)
## Channels immense patience into devastating focus strikes, flowing stances, and lethal single-strike dashes.

signal focus_strike_executed(hit_count: int)
signal flowing_water_entered(duration: float)
signal deep_breath_focused(heal_amount: float)
signal one_strike_unleashed(origin: Vector3, dest: Vector3, enemies_hit: int)

var okar_visual_root: Node3D = null
var monk_blindfold: MeshInstance3D = null

# W: Flowing Water State
var is_flowing_water: bool = false
var flowing_water_timer: float = 0.0

func _ready() -> void:
	entity_name = "Okar"
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
	if not has_node("OkarVisual"):
		okar_visual_root = Node3D.new()
		okar_visual_root.name = "OkarVisual"
		add_child(okar_visual_root)
		
		# Martial Monk Robes (Amber / Ochre)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.52
		body_capsule.height = 2.0
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.0
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.82, 0.58, 0.22, 1.0) # Saffron Ochre Monk Robes
		body_mat.roughness = 0.7
		body_inst.material_override = body_mat
		okar_visual_root.add_child(body_inst)
		
		# Monk Blindfold
		monk_blindfold = MeshInstance3D.new()
		var band = BoxMesh.new()
		band.size = Vector3(0.65, 0.18, 0.65)
		monk_blindfold.mesh = band
		monk_blindfold.position = Vector3(0.0, 1.65, 0.05)
		
		var band_mat = StandardMaterial3D.new()
		band_mat.albedo_color = Color(0.95, 0.20, 0.15, 1.0) # Crimson Blindfold
		monk_blindfold.material_override = band_mat
		okar_visual_root.add_child(monk_blindfold)
	else:
		okar_visual_root = get_node_or_null("OkarVisual")

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
	_process_flowing_water(delta)

func _process_flowing_water(delta: float) -> void:
	if not is_flowing_water:
		return
	flowing_water_timer -= delta
	if flowing_water_timer <= 0.0:
		is_flowing_water = false
		attribute_system.remove_modifiers_by_source("okar_flowing_water")

# --- Q: FOCUS STRIKE (DIRECTIONAL LINE PUNCH & STUN) ---
func cast_okar_q(target_point: Vector3) -> bool:
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
		
	var hits := 0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if cur_pos.distance_to(entity.global_position) <= 4.2:
					var to_e = (entity.global_position - cur_pos).normalized()
					if dir.dot(to_e) > 0.5:
						var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.PHYSICAL, "Focus Strike")
						CombatCalculator.execute_damage(req)
						if "effect_container" in entity and entity.effect_container != null:
							entity.effect_container.apply_stun(1.2)
						hits += 1
						
	focus_strike_executed.emit(hits)
	return true

# --- W: FLOWING WATER (DAMAGE REDUCTION & CLEANSING STANCE) ---
func cast_okar_w() -> bool:
	if not can_cast():
		return false
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	is_flowing_water = true
	flowing_water_timer = 3.5
	
	var armor_mod = StatModifier.new(StatModifier.TargetStat.ARMOR, StatModifier.Type.FLAT, 35.0, "okar_flowing_water")
	var mr_mod = StatModifier.new(StatModifier.TargetStat.MAGIC_RESIST, StatModifier.Type.FLAT, 30.0, "okar_flowing_water")
	attribute_system.add_modifier(armor_mod)
	attribute_system.add_modifier(mr_mod)
	
	CombatMechanicsClass.apply_shield(self, self, "okar_flowing_shield", "Akan Su Kalkanı", 180.0, 3.5)
	flowing_water_entered.emit(3.5)
	return true

# --- E: DEEP BREATH (INNER FOCUS HEAL & SPEED) ---
func cast_okar_e() -> bool:
	if not can_cast():
		return false
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var max_hp = attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	var heal_amt = (max_hp * 0.15) + (lvl * 35.0)
	attribute_system.heal(heal_amt)
	
	if attack_controller != null:
		attack_controller.attack_cooldown_timer = 0.0
		
	deep_breath_focused.emit(heal_amt)
	return true

# --- R: ONE STRIKE (INSTANT DASH EXECUTION & SILENCE) ---
func cast_okar_r(target_point: Vector3) -> bool:
	if not can_cast():
		return false
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.R, null, target_point):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * r_res.scaling_ratio)
	
	var cur_pos = global_position if is_inside_tree() else position
	var dir = (target_point - cur_pos).normalized()
	dir.y = 0.0
	if dir.length_squared() < 0.001:
		dir = -transform.basis.z.normalized()
		
	var dash_dest = cur_pos + (dir * 6.5)
	
	if not ability_container.cast_ability(AbilityResource.Slot.R, null, target_point):
		return false
		
	var enemies_hit := 0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				var dist_to_line = _dist_to_segment(entity.global_position, cur_pos, dash_dest)
				if dist_to_line <= 1.8:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.PHYSICAL, "One Strike")
					CombatCalculator.execute_damage(req)
					if "effect_container" in entity and entity.effect_container != null:
						entity.effect_container.apply_silence(1.8)
					enemies_hit += 1
					
		global_position = dash_dest
	else:
		position = dash_dest
		
	one_strike_unleashed.emit(cur_pos, dash_dest, enemies_hit)
	return true

func _dist_to_segment(p: Vector3, a: Vector3, b: Vector3) -> float:
	var ab = b - a
	var ap = p - a
	var ab_len_sq = ab.length_squared()
	if ab_len_sq < 0.0001:
		return p.distance_to(a)
	var t = clamp(ap.dot(ab) / ab_len_sq, 0.0, 1.0)
	var closest = a + (ab * t)
	return p.distance_to(closest)
