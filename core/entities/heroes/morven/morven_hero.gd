class_name MorvenHero
extends HeroEntity

const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")

## Implementation of Morven (The Toxic Skirmisher / AGI Rogue)
## Corrodes enemy healing and defences: Venom Slash, Plague Step, Corrupt, and Reverse Life.

signal venom_slashed(target: BaseCombatEntity, poison_applied: bool)
signal plague_stepped(origin: Vector3, dest: Vector3)
signal target_corrupted(target: BaseCombatEntity)
signal life_reversed(target: BaseCombatEntity, total_damage: float)

var morven_visual_root: Node3D = null
var toxic_daggers: Array[MeshInstance3D] = []

func _ready() -> void:
	entity_name = "Morven"
	hero_resource = MorvenDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_morven_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.48
		shape.height = 1.95
		col.shape = shape
		col.position.y = 0.98
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("MorvenVisual"):
		morven_visual_root = Node3D.new()
		morven_visual_root.name = "MorvenVisual"
		add_child(morven_visual_root)
		
		# Slender Toxic Rogue Body
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.42
		body_capsule.height = 1.90
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.95
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.18, 0.32, 0.22, 1.0) # Poison Moss & Charcoal
		mat.metallic = 0.4
		mat.roughness = 0.4
		body_inst.material_override = mat
		morven_visual_root.add_child(body_inst)
		
		# Twin Toxic Daggers
		toxic_daggers.clear()
		for side in [-0.42, 0.42]:
			var dagger = MeshInstance3D.new()
			var d_mesh = CylinderMesh.new()
			d_mesh.top_radius = 0.02
			d_mesh.bottom_radius = 0.05
			d_mesh.height = 0.85
			dagger.mesh = d_mesh
			dagger.position = Vector3(side, 0.75, 0.35)
			dagger.rotation_degrees = Vector3(-65, side * 20.0, 0)
			
			var d_mat = StandardMaterial3D.new()
			d_mat.albedo_color = Color(0.3, 0.9, 0.2, 1.0) # Toxic Green
			d_mat.emission_enabled = true
			d_mat.emission = Color(0.2, 0.9, 0.1)
			d_mat.emission_energy_multiplier = 2.0
			dagger.material_override = d_mat
			morven_visual_root.add_child(dagger)
			toxic_daggers.append(dagger)
	else:
		morven_visual_root = get_node_or_null("MorvenVisual")

func _apply_morven_definition() -> void:
	if hero_resource == null:
		hero_resource = MorvenDefinition.create_resource()
		
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

# --- Q: VENOM SLASH (SINGLE TARGET POISON STRIKE) ---
func cast_morven_q(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or target.team == team:
		return false
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, target):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * q_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.Q, target):
		return false
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Venom Slash")
	CombatCalculator.execute_damage(req)
	
	if "effect_container" in target and target.effect_container != null:
		var poison = StatusEffect.new("morven_venom", StatusEffect.EffectType.DAMAGE_OVER_TIME, 3.0, 20.0, true)
		target.effect_container.apply_effect(poison)
		
	venom_slashed.emit(target, true)
	return true

# --- W: PLAGUE STEP (DIRECTIONAL TOXIC DASH) ---
func cast_morven_w(target_point: Vector3) -> bool:
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
		
	var dash_dist = minf(5.5, cur_pos.distance_to(target_point))
	if dash_dist < 1.0:
		dash_dist = 5.0
	var dest = cur_pos + dir * dash_dist
	
	if not ability_container.cast_ability(AbilityResource.Slot.W, null, target_point):
		return false
		
	if is_inside_tree():
		global_position = dest
	else:
		position = dest
		
	# Slow enemies passed through
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				var dist_to_line = (entity.global_position - cur_pos).cross(dir).length()
				if dist_to_line <= 2.0:
					if "effect_container" in entity and entity.effect_container != null:
						entity.effect_container.apply_slow(0.40, 2.0)
						
	plague_stepped.emit(cur_pos, dest)
	return true

# --- E: CORRUPT (SINGLE TARGET HEAL REDUCTION) ---
func cast_morven_e(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or target.team == team:
		return false
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.E, target):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var base_dmg = e_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * e_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.E, target):
		return false
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Corrupt")
	CombatCalculator.execute_damage(req)
	
	if "effect_container" in target and target.effect_container != null:
		var corrupt = StatusEffect.new("morven_corrupt_heal", StatusEffect.EffectType.DEBUFF, 4.0, 1.0, false)
		target.effect_container.apply_effect(corrupt)
		
	target_corrupted.emit(target)
	return true

# --- R: REVERSE LIFE (SINGLE TARGET LETHAL CATALYST) ---
func cast_morven_r(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or target.team == team:
		return false
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.R, target):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * r_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.R, target):
		return false
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Reverse Life")
	CombatCalculator.execute_damage(req)
	
	if "effect_container" in target and target.effect_container != null:
		var rot = StatusEffect.new("morven_reverse_rot", StatusEffect.EffectType.DAMAGE_OVER_TIME, 4.0, 35.0, true)
		target.effect_container.apply_effect(rot)
		
	life_reversed.emit(target, total_dmg)
	return true
