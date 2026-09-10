class_name ValeriusHero
extends HeroEntity

const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")
const DefScript = preload("res://data/heroes/valerius_definition.gd")

## Implementation of Valerius (The Inquisitor / Sacred Magistrate)
## Pins mobility champions with gravity chains, confessions, and courthouse arenas.

signal shackles_applied(target: BaseCombatEntity)
signal heavy_gravity_cast(point: Vector3, enemies_hit: int)
signal confess_forced(target: BaseCombatEntity)
signal court_of_law_convened(center: Vector3, count: int)

var valerius_visual_root: Node3D = null
var inquisitor_cowl: MeshInstance3D = null

func _ready() -> void:
	entity_name = "Valerius"
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
	if not has_node("ValeriusVisual"):
		valerius_visual_root = Node3D.new()
		valerius_visual_root.name = "ValeriusVisual"
		add_child(valerius_visual_root)
		
		# Sacred Magistrate Robes (Midnight Velvet & Ivory)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.50
		body_capsule.height = 2.0
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.0
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.15, 0.15, 0.22, 1.0) # Midnight Inquisition
		body_inst.material_override = body_mat
		valerius_visual_root.add_child(body_inst)
		
		# Gilded Scale / Cowl
		inquisitor_cowl = MeshInstance3D.new()
		var cowl = TorusMesh.new()
		cowl.inner_radius = 0.35
		cowl.outer_radius = 0.55
		inquisitor_cowl.mesh = cowl
		inquisitor_cowl.position = Vector3(0.0, 1.60, 0.0)
		
		var c_mat = StandardMaterial3D.new()
		c_mat.albedo_color = Color(0.95, 0.85, 0.40, 1.0) # Sacred Gold
		inquisitor_cowl.material_override = c_mat
		valerius_visual_root.add_child(inquisitor_cowl)
	else:
		valerius_visual_root = get_node_or_null("ValeriusVisual")

func _apply_def() -> void:
	var def = DefScript.create_resource()
	hero_resource = def
	_apply_hero_resource(def)
	
	ability_container.set_ability(AbilityResource.Slot.Q, def.q_ability)
	ability_container.set_ability(AbilityResource.Slot.W, def.w_ability)
	ability_container.set_ability(AbilityResource.Slot.E, def.e_ability)
	ability_container.set_ability(AbilityResource.Slot.R, def.r_ability)

# --- Q: SHACKLES (SINGLE TARGET ROOT & DAMAGE) ---
func cast_valerius_q(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive():
		return false
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, target):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var total_dmg = base_dmg + (ap * q_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.Q, target):
		return false
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.MAGICAL, "Shackles")
	CombatCalculator.execute_damage(req)
	if "effect_container" in target and target.effect_container != null:
		target.effect_container.apply_root(1.8)
		
	shackles_applied.emit(target)
	return true

# --- W: HEAVY GRAVITY (GROUND AOE SLOW & CRUSH) ---
func cast_valerius_w(target_point: Vector3) -> bool:
	if not can_cast():
		return false
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.W, null, target_point):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var base_dmg = w_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var total_dmg = base_dmg + (ap * w_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.W, null, target_point):
		return false
		
	var hits := 0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if target_point.distance_to(entity.global_position) <= 4.5:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.MAGICAL, "Heavy Gravity")
					CombatCalculator.execute_damage(req)
					if "effect_container" in entity and entity.effect_container != null:
						entity.effect_container.apply_slow(0.60, 2.5)
					hits += 1
					
	heavy_gravity_cast.emit(target_point, hits)
	return true

# --- E: CONFESS (SINGLE TARGET SILENCE & INTERROGATION) ---
func cast_valerius_e(target: BaseCombatEntity) -> bool:
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
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.MAGICAL, "Confess")
	CombatCalculator.execute_damage(req)
	if "effect_container" in target and target.effect_container != null:
		target.effect_container.apply_silence(2.0)
		
	confess_forced.emit(target)
	return true

# --- R: COURT OF LAW (ARENA RETRIBUTION) ---
func cast_valerius_r(target_point: Vector3) -> bool:
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
		
	var count := 0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if target_point.distance_to(entity.global_position) <= 6.0:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.MAGICAL, "Court of Law")
					CombatCalculator.execute_damage(req)
					if "effect_container" in entity and entity.effect_container != null:
						entity.effect_container.apply_slow(0.70, 3.0)
					count += 1
					
	court_of_law_convened.emit(target_point, count)
	return true
