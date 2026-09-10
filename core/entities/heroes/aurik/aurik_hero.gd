class_name AurikHero
extends HeroEntity

const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")
const WardEntityClass = preload("res://systems/fog_of_war/ward_entity.gd")

## Implementation of Aurik (The Sight Weaver / INT Vision Manipulator)
## Controls battlefield vision, Fog of War, mirage beacons, blinding shrouds, and Clairvoyance.

signal mirage_beacon_planted(pos: Vector3)
signal blindfold_shroud_cast(pos: Vector3, enemies_blinded: int)
signal ghost_pulse_emitted(origin: Vector3, dir: Vector3, enemies_revealed: int)
signal clairvoyance_channeled(pos: Vector3, enemies_revealed: int)

var aurik_visual_root: Node3D = null
var psychic_eye: MeshInstance3D = null
var eye_hover_timer: float = 0.0

func _ready() -> void:
	entity_name = "Aurik"
	hero_resource = AurikDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_aurik_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.52
		shape.height = 2.0
		col.shape = shape
		col.position.y = 1.0
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("AurikVisual"):
		aurik_visual_root = Node3D.new()
		aurik_visual_root.name = "AurikVisual"
		add_child(aurik_visual_root)
		
		# Mystic Robed Body
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.46
		body_capsule.height = 1.95
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.98
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.18, 0.65, 0.72, 1.0) # Ethereal Mystic Turquoise
		mat.metallic = 0.2
		mat.roughness = 0.4
		mat.emission_enabled = true
		mat.emission = Color(0.1, 0.4, 0.5)
		mat.emission_energy_multiplier = 0.6
		body_inst.material_override = mat
		aurik_visual_root.add_child(body_inst)
		
		# Floating Third Eye Orb above head
		psychic_eye = MeshInstance3D.new()
		var eye_mesh = SphereMesh.new()
		eye_mesh.radius = 0.22
		eye_mesh.height = 0.44
		psychic_eye.mesh = eye_mesh
		psychic_eye.position = Vector3(0.0, 2.25, 0.0)
		
		var eye_mat = StandardMaterial3D.new()
		eye_mat.albedo_color = Color(0.3, 1.0, 0.85, 1.0)
		eye_mat.emission_enabled = true
		eye_mat.emission = Color(0.3, 1.0, 0.85)
		eye_mat.emission_energy_multiplier = 3.0
		psychic_eye.material_override = eye_mat
		aurik_visual_root.add_child(psychic_eye)
	else:
		aurik_visual_root = get_node_or_null("AurikVisual")

func _apply_aurik_definition() -> void:
	if hero_resource == null:
		hero_resource = AurikDefinition.create_resource()
		
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
	_update_floating_eye(delta)

func _update_floating_eye(delta: float) -> void:
	if psychic_eye == null or not is_instance_valid(psychic_eye):
		return
	eye_hover_timer += delta * 3.0
	psychic_eye.position.y = 2.25 + sin(eye_hover_timer) * 0.12

# --- Q: MIRAGE BEACON (GROUND AOE VISION WARD + TRAP) ---
func cast_aurik_q(target_point: Vector3) -> bool:
	if not can_cast():
		return false
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, null, target_point):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var total_dmg = base_dmg + (ap * q_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.Q, null, target_point):
		return false
		
	# Spawn Vision Beacon / Ward
	if is_inside_tree():
		var beacon = WardEntityClass.new()
		beacon.team = team
		beacon.placed_by = self
		beacon.ward_name = "Mirage Beacon"
		beacon.vision_radius = 12.0
		beacon.true_sight_radius = 6.0
		beacon.duration = 15.0
		var root = get_tree().current_scene if get_tree().current_scene != null else get_tree().root
		root.add_child(beacon)
		beacon.global_position = target_point
		
		# Detonate damage & slow on enemies at target_point
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if target_point.distance_to(entity.global_position) <= 4.5:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.MAGICAL, "Mirage Beacon")
					CombatCalculator.execute_damage(req)
					if "effect_container" in entity and entity.effect_container != null:
						entity.effect_container.apply_slow(0.35, 2.5)
						
	mirage_beacon_planted.emit(target_point)
	return true

# --- W: BLINDFOLD SHROUD (GROUND AOE SENSORY BLIND & SILENCE) ---
func cast_aurik_w(target_point: Vector3) -> bool:
	if not can_cast():
		return false
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.W, null, target_point):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var base_dmg = w_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * w_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.W, null, target_point):
		return false
		
	var blinded_count := 0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if target_point.distance_to(entity.global_position) <= 5.0:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.PHYSICAL, "Blindfold Shroud")
					CombatCalculator.execute_damage(req)
					if "effect_container" in entity and entity.effect_container != null:
						entity.effect_container.apply_silence(2.0)
						entity.effect_container.apply_slow(0.30, 2.5)
					blinded_count += 1
					
	blindfold_shroud_cast.emit(target_point, blinded_count)
	return true

# --- E: GHOST PULSE (DIRECTIONAL PSYCHIC BEAM + TRUE SIGHT) ---
func cast_aurik_e(target_point: Vector3) -> bool:
	if not can_cast():
		return false
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.E, null, target_point):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var base_dmg = e_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var total_dmg = base_dmg + (ap * e_res.scaling_ratio)
	
	var cur_pos = global_position if is_inside_tree() else position
	var dir = (target_point - cur_pos).normalized()
	dir.y = 0.0
	if dir.length_squared() < 0.001:
		dir = -transform.basis.z.normalized()
		
	if not ability_container.cast_ability(AbilityResource.Slot.E, null, target_point):
		return false
		
	var revealed_count := 0
	var beam_length := 12.0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				var to_ent = entity.global_position - cur_pos
				var forward_dist = to_ent.dot(dir)
				var perp_dist = to_ent.cross(dir).length()
				if forward_dist >= 0.0 and forward_dist <= beam_length and perp_dist <= 2.2:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.MAGICAL, "Ghost Pulse")
					CombatCalculator.execute_damage(req)
					entity.set_meta("reveal_until_msec", Time.get_ticks_msec() + 6000)
					revealed_count += 1
					
	ghost_pulse_emitted.emit(cur_pos, dir, revealed_count)
	return true

# --- R: CLAIRVOYANCE (GLOBAL VISION SCAN + PSYCHIC CASCADE) ---
func cast_aurik_r(target_point: Vector3) -> bool:
	if not can_cast():
		return false
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.R, null, target_point):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var total_dmg = base_dmg + (ap * r_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.R, null, target_point):
		return false
		
	var revealed_count := 0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				# Global reveal for all enemy heroes
				if entity is HeroEntity:
					entity.set_meta("reveal_until_msec", Time.get_ticks_msec() + 8000)
					revealed_count += 1
				# Damage and slow within 9m of cast center
				if target_point.distance_to(entity.global_position) <= 9.0:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.MAGICAL, "Clairvoyance")
					CombatCalculator.execute_damage(req)
					if "effect_container" in entity and entity.effect_container != null:
						entity.effect_container.apply_slow(0.40, 3.0)
						
	clairvoyance_channeled.emit(target_point, revealed_count)
	return true
