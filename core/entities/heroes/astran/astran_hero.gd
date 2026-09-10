class_name AstranHero
extends HeroEntity

const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")

## Implementation of Astran (The Cosmic Titan / STR Tank & Initiator)
## Controls gravitational singularities, orbiting meteorite shields, seismic craters, and orbital meteor strikes.

signal singularity_formed(center_pos: Vector3, enemies_pulled: int)
signal meteorite_shield_activated(shield_amount: float)
signal crater_impact(center_pos: Vector3, enemies_hit: int)
signal orbital_strike_impact(center_pos: Vector3, enemies_hit: int)

var astran_visual_root: Node3D = null
var orbiting_meteors: Array[MeshInstance3D] = []
var orbit_angle: float = 0.0
var orbit_speed: float = 2.0

# W: Meteorite Shield State
var is_shield_active: bool = false
var shield_timer: float = 0.0
var shield_pulse_timer: float = 0.0

func _ready() -> void:
	entity_name = "Astran"
	hero_resource = AstranDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_astran_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.65
		shape.height = 2.2
		col.shape = shape
		col.position.y = 1.10
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("AstranVisual"):
		astran_visual_root = Node3D.new()
		astran_visual_root.name = "AstranVisual"
		add_child(astran_visual_root)
		
		# Massive Cosmic Titan Body
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.58
		body_capsule.height = 2.20
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.10
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.10, 0.15, 0.35, 1.0) # Celestial Midnight Stardust
		mat.metallic = 0.7
		mat.roughness = 0.4
		mat.emission_enabled = true
		mat.emission = Color(0.2, 0.5, 0.9)
		mat.emission_energy_multiplier = 0.8
		body_inst.material_override = mat
		astran_visual_root.add_child(body_inst)
		
		# 3 Orbiting Meteorite Spheres
		orbiting_meteors.clear()
		for i in range(3):
			var meteor = MeshInstance3D.new()
			var sphere = SphereMesh.new()
			sphere.radius = 0.18
			sphere.height = 0.36
			meteor.mesh = sphere
			
			var m_mat = StandardMaterial3D.new()
			m_mat.albedo_color = Color(0.85, 0.65, 0.25, 1.0) # Fiery Cosmic Stone
			m_mat.emission_enabled = true
			m_mat.emission = Color(1.0, 0.6, 0.1)
			m_mat.emission_energy_multiplier = 2.0
			meteor.material_override = m_mat
			astran_visual_root.add_child(meteor)
			orbiting_meteors.append(meteor)
	else:
		astran_visual_root = get_node_or_null("AstranVisual")

func _apply_astran_definition() -> void:
	if hero_resource == null:
		hero_resource = AstranDefinition.create_resource()
		
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
	_update_orbiting_meteors(delta)
	_process_shield(delta)

func _update_orbiting_meteors(delta: float) -> void:
	orbit_angle += delta * orbit_speed
	var radius = 1.6 if is_shield_active else 1.1
	for i in range(orbiting_meteors.size()):
		var meteor = orbiting_meteors[i]
		if meteor != null and is_instance_valid(meteor):
			var a = orbit_angle + (i * TAU / 3.0)
			meteor.position = Vector3(cos(a) * radius, 1.1 + sin(a * 2.0) * 0.15, sin(a) * radius)

func _process_shield(delta: float) -> void:
	if not is_shield_active:
		return
	shield_timer -= delta
	shield_pulse_timer -= delta
	
	# Orbiting damage pulse every 0.6s
	if shield_pulse_timer <= 0.0:
		shield_pulse_timer = 0.6
		_pulse_orbit_damage()
		
	if shield_timer <= 0.0:
		is_shield_active = false
		orbit_speed = 2.0

func _pulse_orbit_damage() -> void:
	if not is_inside_tree():
		return
	var cur_pos = global_position
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var base_dmg = (w_res.get_base_damage(lvl) if w_res != null else 70.0) * 0.35
	
	for entity in get_tree().get_nodes_in_group("combat_entities"):
		if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
			if cur_pos.distance_to(entity.global_position) <= 4.0:
				var req = DamageRequest.create_ability_damage(self, entity, base_dmg, DamageRequest.DamageType.PHYSICAL, "Meteor Orbit Pulse")
				CombatCalculator.execute_damage(req)

# --- Q: GRAVITY PULL (GROUND AOE SINGULARITY) ---
func cast_astran_q(target_point: Vector3) -> bool:
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
		
	# Pull enemies within 6.5m towards target_point and apply slow
	var pulled_count := 0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				var dist = target_point.distance_to(entity.global_position)
				if dist <= 6.5:
					var pull_dir = (target_point - entity.global_position).normalized()
					var pull_dist = minf(dist * 0.65, 3.5)
					entity.global_position += pull_dir * pull_dist
					
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.MAGICAL, "Gravity Pull")
					CombatCalculator.execute_damage(req)
					if "effect_container" in entity and entity.effect_container != null:
						entity.effect_container.apply_slow(0.40, 2.0)
					pulled_count += 1
					
	singularity_formed.emit(target_point, pulled_count)
	return true

# --- W: METEORITE SHIELD (SELF ORBIT BARRIER) ---
func cast_astran_w() -> bool:
	if not can_cast():
		return false
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var base_dmg = w_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var shield_val = 150.0 + (lvl * 60.0) + (ad * 0.60)
	
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	is_shield_active = true
	shield_timer = 5.0
	shield_pulse_timer = 0.2
	orbit_speed = 6.0
	
	CombatMechanicsClass.apply_shield(self, self, "astran_meteorite_shield", "Göktaşı Kalkanı", shield_val, 5.0)
	meteorite_shield_activated.emit(shield_val)
	return true

# --- E: CRATER (GROUND AOE SLAM + STUN) ---
func cast_astran_e(target_point: Vector3) -> bool:
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
		
	# Leap / Slam to point
	if is_inside_tree():
		global_position = target_point
	else:
		position = target_point
		
	var hit_count := 0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if target_point.distance_to(entity.global_position) <= 5.0:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.PHYSICAL, "Crater")
					CombatCalculator.execute_damage(req)
					if "effect_container" in entity and entity.effect_container != null:
						entity.effect_container.apply_stun(1.3)
					hit_count += 1
					
	crater_impact.emit(target_point, hit_count)
	return true

# --- R: ORBITAL STRIKE (CATACLYSMIC CELESTIAL METEOR) ---
func cast_astran_r(target_point: Vector3) -> bool:
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
		
	var hit_count := 0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if target_point.distance_to(entity.global_position) <= 7.5:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.MAGICAL, "Orbital Strike")
					CombatCalculator.execute_damage(req)
					# Apply heavy slow and armor shred
					if "effect_container" in entity and entity.effect_container != null:
						entity.effect_container.apply_slow(0.60, 3.5)
						var armor_shred = StatModifier.new(StatModifier.TargetStat.ARMOR, StatModifier.Type.PERCENT_ADD, -0.30, "astran_orbital_shred")
						entity.attribute_system.add_modifier(armor_shred)
					hit_count += 1
					
	orbital_strike_impact.emit(target_point, hit_count)
	return true
