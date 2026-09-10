class_name XeranaHero
extends HeroEntity

const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")
const DefScript = preload("res://data/heroes/xerana_definition.gd")

## Implementation of Xerana (The Chakram Queen / Ethereal Mage)
## Commands hovering golden chakrams and discharges leaping chain lightning.

signal disc_recalled(point: Vector3, hits: int)
signal energy_treaded(dest: Vector3)
signal chain_lightning_struck(primary: BaseCombatEntity, bounces: int)
signal chakram_storm_unleashed(duration: float)

var xerana_visual_root: Node3D = null
var chakram_orbit_node: Node3D = null

# R: Chakram Storm State
var is_storm_active: bool = false
var storm_timer: float = 0.0

func _ready() -> void:
	entity_name = "Xerana"
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_def()

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
	if not has_node("XeranaVisual"):
		xerana_visual_root = Node3D.new()
		xerana_visual_root.name = "XeranaVisual"
		add_child(xerana_visual_root)
		
		# Ethereal Queen Body (Amethyst & Violet)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.46
		body_capsule.height = 1.95
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.98
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.55, 0.20, 0.75, 1.0) # Radiant Violet
		body_mat.metallic = 0.3
		body_mat.emission_enabled = true
		body_mat.emission = Color(0.4, 0.1, 0.6, 1.0)
		body_mat.emission_energy_multiplier = 0.5
		body_inst.material_override = body_mat
		xerana_visual_root.add_child(body_inst)
		
		# Orbiting Golden Chakram
		chakram_orbit_node = Node3D.new()
		chakram_orbit_node.name = "ChakramOrbit"
		chakram_orbit_node.position.y = 1.2
		xerana_visual_root.add_child(chakram_orbit_node)
		
		for i in range(3):
			var chakram = MeshInstance3D.new()
			var torus = TorusMesh.new()
			torus.inner_radius = 0.18
			torus.outer_radius = 0.28
			chakram.mesh = torus
			var angle = i * (PI * 2.0 / 3.0)
			chakram.position = Vector3(cos(angle) * 0.85, 0.0, sin(angle) * 0.85)
			chakram.rotation_degrees = Vector3(90, 0, 0)
			
			var c_mat = StandardMaterial3D.new()
			c_mat.albedo_color = Color(1.0, 0.85, 0.2, 1.0) # Pure Gold
			c_mat.metallic = 0.95
			chakram.material_override = c_mat
			chakram_orbit_node.add_child(chakram)
	else:
		xerana_visual_root = get_node_or_null("XeranaVisual")
		chakram_orbit_node = xerana_visual_root.get_node_or_null("ChakramOrbit")

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
	if chakram_orbit_node != null:
		chakram_orbit_node.rotate_y(delta * (6.0 if is_storm_active else 2.0))
		
	if is_storm_active:
		storm_timer -= delta
		if storm_timer <= 0.0:
			is_storm_active = false

# --- Q: DISC RECALL (GROUND AOE SLICE & RECALL) ---
func cast_xerana_q(target_point: Vector3) -> bool:
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
		
	var hits := 0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if target_point.distance_to(entity.global_position) <= 3.8:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.MAGICAL, "Disc Recall")
					CombatCalculator.execute_damage(req)
					hits += 1
					
	disc_recalled.emit(target_point, hits)
	return true

# --- W: ENERGY TREAD (DIRECTIONAL WARP GLIDE) ---
func cast_xerana_w(target_point: Vector3) -> bool:
	if not can_cast():
		return false
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.W, null, target_point):
		return false
		
	var cur_pos = global_position if is_inside_tree() else position
	var dir = (target_point - cur_pos).normalized()
	dir.y = 0.0
	if dir.length_squared() < 0.001:
		dir = -transform.basis.z.normalized()
		
	var dest = cur_pos + (dir * 5.5)
	
	if not ability_container.cast_ability(AbilityResource.Slot.W, null, target_point):
		return false
		
	if is_inside_tree():
		global_position = dest
	else:
		position = dest
		
	energy_treaded.emit(dest)
	return true

# --- E: CHAIN LIGHTNING (BOUNCING LIGHTNING BOLT) ---
func cast_xerana_e(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive():
		return false
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.E, target):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var base_dmg = e_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var total_dmg = base_dmg + (ap * e_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.E, target):
		return false
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.MAGICAL, "Chain Lightning")
	CombatCalculator.execute_damage(req)
	
	var bounces := 0
	var last_pos = target.global_position if is_inside_tree() else target.position
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if bounces >= 3:
				break
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity != target and entity.team != team:
				if last_pos.distance_to(entity.global_position) <= 6.0:
					var bounce_req = DamageRequest.create_ability_damage(self, entity, total_dmg * 0.75, DamageRequest.DamageType.MAGICAL, "Chain Lightning Bounce")
					CombatCalculator.execute_damage(bounce_req)
					last_pos = entity.global_position
					bounces += 1
					
	chain_lightning_struck.emit(target, bounces)
	return true

# --- R: CHAKRAM STORM (ORBITAL CHAKRAM SHRED) ---
func cast_xerana_r() -> bool:
	if not can_cast():
		return false
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast(AbilityResource.Slot.R):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var total_dmg = base_dmg + (ap * r_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return false
		
	is_storm_active = true
	storm_timer = 6.0
	
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if global_position.distance_to(entity.global_position) <= 5.5:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.MAGICAL, "Chakram Storm")
					CombatCalculator.execute_damage(req)
					
	chakram_storm_unleashed.emit(6.0)
	return true
