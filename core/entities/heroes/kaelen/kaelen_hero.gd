class_name KaelenHero
extends HeroEntity

const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")

## Implementation of Kaelen (The Tower Bulwark / STR Interceptor Tank)
## Intercepts lethal damage for allies with Shield Slam, Body Block, Unbreakable, and Phalanx.

signal shield_slam_struck(target: BaseCombatEntity)
signal body_block_intercepted(ally: BaseCombatEntity)
signal unbreakable_activated(duration: float)
signal phalanx_deployed(shield_amount: float)

var kaelen_visual_root: Node3D = null
var tower_shield: MeshInstance3D = null

# E: Unbreakable State
var is_unbreakable: bool = false
var unbreakable_timer: float = 0.0

func _ready() -> void:
	entity_name = "Kaelen"
	hero_resource = KaelenDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_kaelen_definition()

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
	if not has_node("KaelenVisual"):
		kaelen_visual_root = Node3D.new()
		kaelen_visual_root.name = "KaelenVisual"
		add_child(kaelen_visual_root)
		
		# Towering Armored Knight Body
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.58
		body_capsule.height = 2.15
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.08
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.22, 0.28, 0.38, 1.0) # Steel Blue Heavy Plate
		mat.metallic = 0.85
		mat.roughness = 0.35
		body_inst.material_override = mat
		kaelen_visual_root.add_child(body_inst)
		
		# Door-sized Tower Bulwark Shield
		tower_shield = MeshInstance3D.new()
		var s_box = BoxMesh.new()
		s_box.size = Vector3(1.1, 1.7, 0.18)
		tower_shield.mesh = s_box
		tower_shield.position = Vector3(0.0, 1.0, 0.65)
		
		var s_mat = StandardMaterial3D.new()
		s_mat.albedo_color = Color(0.35, 0.42, 0.55, 1.0)
		s_mat.metallic = 0.90
		tower_shield.material_override = s_mat
		kaelen_visual_root.add_child(tower_shield)
	else:
		kaelen_visual_root = get_node_or_null("KaelenVisual")

func _apply_kaelen_definition() -> void:
	if hero_resource == null:
		hero_resource = KaelenDefinition.create_resource()
		
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
	_process_unbreakable(delta)

func _process_unbreakable(delta: float) -> void:
	if not is_unbreakable:
		return
	unbreakable_timer -= delta
	if unbreakable_timer <= 0.0:
		is_unbreakable = false
		attribute_system.remove_modifiers_by_source("kaelen_unbreakable")

# --- Q: SHIELD SLAM (DIRECTIONAL STUN SLAM) ---
func cast_kaelen_q(target_point: Vector3) -> bool:
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
		
	var hit_target: BaseCombatEntity = null
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if cur_pos.distance_to(entity.global_position) <= 3.8:
					var to_e = (entity.global_position - cur_pos).normalized()
					if dir.dot(to_e) > 0.6:
						var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.PHYSICAL, "Shield Slam")
						CombatCalculator.execute_damage(req)
						if "effect_container" in entity and entity.effect_container != null:
							entity.effect_container.apply_stun(1.3)
						hit_target = entity
						break
						
	shield_slam_struck.emit(hit_target)
	return true

# --- W: BODY BLOCK (TARGET ALLY INTERCEPT & SHIELD) ---
func cast_kaelen_w(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive():
		return false
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.W, target):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var shield_amount = 150.0 + (lvl * 60.0)
	
	if not ability_container.cast_ability(AbilityResource.Slot.W, target):
		return false
		
	# Dash to target position
	if is_inside_tree():
		global_position = target.global_position + Vector3(0.5, 0, 0.5)
	else:
		position = target.position + Vector3(0.5, 0, 0.5)
		
	# Apply shield to ally (or self if enemy target)
	var ally = target if target.team == team else self
	CombatMechanicsClass.apply_shield(self, ally, "kaelen_body_block", "Gövde Siperi", shield_amount, 3.5)
	
	body_block_intercepted.emit(ally)
	return true

# --- E: UNBREAKABLE (SELF FORTIFIED BULWARK) ---
func cast_kaelen_e() -> bool:
	if not can_cast():
		return false
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return false
		
	is_unbreakable = true
	unbreakable_timer = 4.0
	
	var res_mod = StatModifier.new(StatModifier.TargetStat.ARMOR, StatModifier.Type.FLAT, 45.0, "kaelen_unbreakable")
	attribute_system.add_modifier(res_mod)
	CombatMechanicsClass.apply_shield(self, self, "kaelen_unbreakable_shield", "Yıkılmaz Duruş", 250.0, 4.0)
	
	unbreakable_activated.emit(4.0)
	return true

# --- R: PHALANX (ALLIED AREA BARRICADE & SHIELDS) ---
func cast_kaelen_r() -> bool:
	if not can_cast():
		return false
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast(AbilityResource.Slot.R):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var shield_val = 300.0 + (lvl * 120.0) + (ad * 0.80)
	
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return false
		
	# Shield all nearby allies within 8m and knockback enemies
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive():
				if global_position.distance_to(entity.global_position) <= 8.0:
					if entity.team == team:
						CombatMechanicsClass.apply_shield(self, entity, "kaelen_phalanx_shield", "Falanks Kalkanı", shield_val, 5.0)
					else:
						var knock_dir = (entity.global_position - global_position).normalized()
						entity.global_position += knock_dir * 3.0
						var req = DamageRequest.create_ability_damage(self, entity, base_dmg, DamageRequest.DamageType.PHYSICAL, "Phalanx Repel")
						CombatCalculator.execute_damage(req)
						
	phalanx_deployed.emit(shield_val)
	return true
