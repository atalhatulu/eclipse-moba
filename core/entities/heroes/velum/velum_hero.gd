class_name VelumHero
extends HeroEntity

const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")
const DefScript = preload("res://data/heroes/velum_definition.gd")

## Implementation of Velum (The Symbiote / Psionic Ooze)
## Infuses hosts with protective psionic shells and disrupts enemy nervous systems.

signal parasitic_bolt_fired(hit_target: BaseCombatEntity)
signal host_mutated(target: BaseCombatEntity)
signal deflect_shielded(target: BaseCombatEntity)
signal neural_disruption_cast(target: BaseCombatEntity)

var velum_visual_root: Node3D = null
var symbiote_core: MeshInstance3D = null

func _ready() -> void:
	entity_name = "Velum"
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_def()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.55
		shape.height = 1.9
		col.shape = shape
		col.position.y = 0.95
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("VelumVisual"):
		velum_visual_root = Node3D.new()
		velum_visual_root.name = "VelumVisual"
		add_child(velum_visual_root)
		
		# Symbiotic Bio-Slime Body (Eerie Bio-Teal)
		var body_inst = MeshInstance3D.new()
		var body_sphere = SphereMesh.new()
		body_sphere.radius = 0.55
		body_sphere.height = 1.6
		body_inst.mesh = body_sphere
		body_inst.position.y = 0.85
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.12, 0.75, 0.65, 0.85) # Bioluminescent Teal Ooze
		body_mat.roughness = 0.1
		body_mat.emission_enabled = true
		body_mat.emission = Color(0.1, 0.6, 0.5, 1.0)
		body_mat.emission_energy_multiplier = 0.8
		body_inst.material_override = body_mat
		velum_visual_root.add_child(body_inst)
		
		# Pulsing Symbiote Core
		symbiote_core = MeshInstance3D.new()
		var core_sphere = SphereMesh.new()
		core_sphere.radius = 0.28
		core_sphere.height = 0.56
		symbiote_core.mesh = core_sphere
		symbiote_core.position = Vector3(0.0, 0.90, 0.0)
		
		var core_mat = StandardMaterial3D.new()
		core_mat.albedo_color = Color(0.85, 0.98, 0.95, 1.0) # Bright Neural Nucleus
		core_mat.emission_enabled = true
		core_mat.emission = Color(0.8, 1.0, 0.9, 1.0)
		core_mat.emission_energy_multiplier = 1.8
		symbiote_core.material_override = core_mat
		velum_visual_root.add_child(symbiote_core)
	else:
		velum_visual_root = get_node_or_null("VelumVisual")

func _apply_def() -> void:
	var def = DefScript.create_resource()
	hero_resource = def
	_apply_hero_resource(def)
	
	ability_container.set_ability(AbilityResource.Slot.Q, def.q_ability)
	ability_container.set_ability(AbilityResource.Slot.W, def.w_ability)
	ability_container.set_ability(AbilityResource.Slot.E, def.e_ability)
	ability_container.set_ability(AbilityResource.Slot.R, def.r_ability)

# --- Q: PARASITIC BOLT (DIRECTIONAL SKILLSHOT & SLOW) ---
func cast_velum_q(target_point: Vector3) -> bool:
	if not can_cast():
		return false
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, null, target_point):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var total_dmg = base_dmg + (ap * q_res.scaling_ratio)
	
	var cur_pos = global_position if is_inside_tree() else position
	var dir = (target_point - cur_pos).normalized()
	dir.y = 0.0
	if dir.length_squared() < 0.001:
		dir = -transform.basis.z.normalized()
		
	if not ability_container.cast_ability(AbilityResource.Slot.Q, null, target_point):
		return false
		
	var hit: BaseCombatEntity = null
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if cur_pos.distance_to(entity.global_position) <= 7.5:
					var to_e = (entity.global_position - cur_pos).normalized()
					if dir.dot(to_e) > 0.7:
						var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.MAGICAL, "Parasitic Bolt")
						CombatCalculator.execute_damage(req)
						if "effect_container" in entity and entity.effect_container != null:
							entity.effect_container.apply_slow(0.40, 2.0)
						hit = entity
						break
						
	parasitic_bolt_fired.emit(hit)
	return true

# --- W: MUTATE HOST (SINGLE TARGET SYMBIOSIS / INFEST) ---
func cast_velum_w(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive():
		return false
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.W, target):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	
	if not ability_container.cast_ability(AbilityResource.Slot.W, target):
		return false
		
	if target.team == team:
		var shield_val = 160.0 + (lvl * 50.0) + (ap * 0.50)
		CombatMechanicsClass.apply_shield(self, target, "velum_mutate_host", "Simbiyot Kalkan", shield_val, 4.0)
	else:
		var base_dmg = w_res.get_base_damage(lvl)
		var total_dmg = base_dmg + (ap * w_res.scaling_ratio)
		var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.MAGICAL, "Mutate Host")
		CombatCalculator.execute_damage(req)
		
	host_mutated.emit(target)
	return true

# --- E: DEFLECT (TARGET DEFLECTIVE BARRIER) ---
func cast_velum_e(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive():
		return false
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.E, target):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var shield_amt = 180.0 + (lvl * 60.0) + (ap * 0.60)
	
	if not ability_container.cast_ability(AbilityResource.Slot.E, target):
		return false
		
	CombatMechanicsClass.apply_shield(self, target, "velum_deflect", "Saptırma Bariyeri", shield_amt, 3.5)
	deflect_shielded.emit(target)
	return true

# --- R: NEURAL DISRUPTION (SINGLE TARGET OVERLOAD & SUPPRESSION) ---
func cast_velum_r(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive():
		return false
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.R, target):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var total_dmg = base_dmg + (ap * r_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.R, target):
		return false
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.MAGICAL, "Neural Disruption")
	CombatCalculator.execute_damage(req)
	if "effect_container" in target and target.effect_container != null:
		target.effect_container.apply_silence(2.5)
		target.effect_container.apply_slow(0.50, 2.5)
		
	neural_disruption_cast.emit(target)
	return true
