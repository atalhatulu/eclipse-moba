class_name VulkorHero
extends HeroEntity

const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")
const DefScript = preload("res://data/heroes/vulkor_definition.gd")

## Implementation of Vulkor (The Armor Breaker / Savage Gladiator)
## Smashes enemies with twin dragon-forged crushing maces, shattering armor and stunning crowds.

signal bone_crushed(target: BaseCombatEntity)
signal armor_pierced(center: Vector3, enemies_hit: int)
signal relentless_marched(duration: float)
signal shatter_slammed(center: Vector3, count: int)

var vulkor_visual_root: Node3D = null
var left_crusher_mace: MeshInstance3D = null
var right_crusher_mace: MeshInstance3D = null

# E: Relentless March State
var is_relentless: bool = false
var relentless_timer: float = 0.0

func _ready() -> void:
	entity_name = "Vulkor"
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_def()

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
	if not has_node("VulkorVisual"):
		vulkor_visual_root = Node3D.new()
		vulkor_visual_root.name = "VulkorVisual"
		add_child(vulkor_visual_root)
		
		# Heavy Spiked Gladiator Body (Iron Ash)
		var body_inst = MeshInstance3D.new()
		var body_box = BoxMesh.new()
		body_box.size = Vector3(1.2, 1.9, 1.1)
		body_inst.mesh = body_box
		body_inst.position.y = 1.05
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.20, 0.18, 0.18, 1.0) # Ash Blackened Iron
		body_mat.metallic = 0.9
		body_mat.roughness = 0.4
		body_inst.material_override = body_mat
		vulkor_visual_root.add_child(body_inst)
		
		# Twin Heavy Crushing Maces
		left_crusher_mace = MeshInstance3D.new()
		var mace_mesh = CylinderMesh.new()
		mace_mesh.top_radius = 0.30
		mace_mesh.bottom_radius = 0.20
		mace_mesh.height = 1.1
		left_crusher_mace.mesh = mace_mesh
		left_crusher_mace.position = Vector3(-0.75, 1.1, 0.35)
		
		var m_mat = StandardMaterial3D.new()
		m_mat.albedo_color = Color(0.65, 0.22, 0.15, 1.0) # Blood Rust Metal
		m_mat.metallic = 0.8
		left_crusher_mace.material_override = m_mat
		vulkor_visual_root.add_child(left_crusher_mace)
		
		right_crusher_mace = MeshInstance3D.new()
		right_crusher_mace.mesh = mace_mesh
		right_crusher_mace.position = Vector3(0.75, 1.1, 0.35)
		right_crusher_mace.material_override = m_mat
		vulkor_visual_root.add_child(right_crusher_mace)
	else:
		vulkor_visual_root = get_node_or_null("VulkorVisual")

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
	_process_relentless(delta)

func _process_relentless(delta: float) -> void:
	if not is_relentless:
		return
	relentless_timer -= delta
	if relentless_timer <= 0.0:
		is_relentless = false
		attribute_system.remove_modifiers_by_source("vulkor_relentless")

# --- Q: BONE CRUSHER (SINGLE TARGET STRIKE & ARMOR SHRED) ---
func cast_vulkor_q(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive():
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
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Bone Crusher")
	CombatCalculator.execute_damage(req)
	
	if target.attribute_system != null:
		var shred = StatModifier.new(StatModifier.TargetStat.ARMOR, StatModifier.Type.FLAT, -25.0, "vulkor_shred")
		target.attribute_system.add_modifier(shred)
		
	bone_crushed.emit(target)
	return true

# --- W: ARMOR PIERCE (GROUND AOE MACE SLAM) ---
func cast_vulkor_w(target_point: Vector3) -> bool:
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
		
	var hits := 0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if target_point.distance_to(entity.global_position) <= 4.8:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.PHYSICAL, "Armor Pierce")
					CombatCalculator.execute_damage(req)
					hits += 1
					
	armor_pierced.emit(target_point, hits)
	return true

# --- E: RELENTLESS MARCH (UNSTOPPABLE FURY BUFF) ---
func cast_vulkor_e() -> bool:
	if not can_cast():
		return false
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return false
		
	is_relentless = true
	relentless_timer = 4.0
	
	var ms_mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.30, "vulkor_relentless")
	var ar_mod = StatModifier.new(StatModifier.TargetStat.ARMOR, StatModifier.Type.FLAT, 35.0, "vulkor_relentless")
	attribute_system.add_modifier(ms_mod)
	attribute_system.add_modifier(ar_mod)
	
	relentless_marched.emit(4.0)
	return true

# --- R: SHATTER (CRUSHING IMPACT LEAP & STUN) ---
func cast_vulkor_r(target_point: Vector3) -> bool:
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
		
	var count := 0
	if is_inside_tree():
		global_position = target_point
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if target_point.distance_to(entity.global_position) <= 5.5:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.PHYSICAL, "Shatter")
					CombatCalculator.execute_damage(req)
					if "effect_container" in entity and entity.effect_container != null:
						entity.effect_container.apply_stun(1.5)
					count += 1
	else:
		position = target_point
		
	shatter_slammed.emit(target_point, count)
	return true
