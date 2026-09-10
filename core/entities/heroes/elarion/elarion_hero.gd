class_name ElarionHero
extends HeroEntity

const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")

## Implementation of Elarion (The Spellblade / INT Arcane Striker)
## Infuses melee strikes with raw arcane power: Runic Slash, Arcane Step, Mana Drain, and Overload.

signal runic_slash_struck(direction: Vector3, enemies_hit: int)
signal arcane_step_blinked(target: BaseCombatEntity)
signal mana_siphoned(target: BaseCombatEntity, amount: float)
signal overload_detonated(shield_amount: float)

var elarion_visual_root: Node3D = null
var runic_blade_left: MeshInstance3D = null
var runic_blade_right: MeshInstance3D = null

# R: Overload State
var is_overloaded: bool = false
var overload_timer: float = 0.0

func _ready() -> void:
	entity_name = "Elarion"
	hero_resource = ElarionDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_elarion_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.50
		shape.height = 2.0
		col.shape = shape
		col.position.y = 1.0
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("ElarionVisual"):
		elarion_visual_root = Node3D.new()
		elarion_visual_root.name = "ElarionVisual"
		add_child(elarion_visual_root)
		
		# Slender Elven Rune-Etched Body
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.44
		body_capsule.height = 1.95
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.98
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.15, 0.45, 0.65, 1.0) # Arcane Cerulean Silk
		mat.metallic = 0.4
		mat.roughness = 0.3
		mat.emission_enabled = true
		mat.emission = Color(0.2, 0.6, 0.9)
		mat.emission_energy_multiplier = 0.8
		body_inst.material_override = mat
		elarion_visual_root.add_child(body_inst)
		
		# Twin Glowing Runic Blades
		for side in [-0.50, 0.50]:
			var blade = MeshInstance3D.new()
			var b_mesh = CylinderMesh.new()
			b_mesh.top_radius = 0.03
			b_mesh.bottom_radius = 0.08
			b_mesh.height = 1.3
			blade.mesh = b_mesh
			blade.position = Vector3(side, 0.85, 0.35)
			blade.rotation_degrees = Vector3(-60, side * 30.0, 0)
			
			var b_mat = StandardMaterial3D.new()
			b_mat.albedo_color = Color(0.3, 0.85, 1.0, 1.0)
			b_mat.emission_enabled = true
			b_mat.emission = Color(0.3, 0.85, 1.0)
			b_mat.emission_energy_multiplier = 2.5
			blade.material_override = b_mat
			elarion_visual_root.add_child(blade)
			if side < 0:
				runic_blade_left = blade
			else:
				runic_blade_right = blade
	else:
		elarion_visual_root = get_node_or_null("ElarionVisual")

func _apply_elarion_definition() -> void:
	if hero_resource == null:
		hero_resource = ElarionDefinition.create_resource()
		
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
	_process_overload(delta)

func _process_overload(delta: float) -> void:
	if not is_overloaded:
		return
	overload_timer -= delta
	if overload_timer <= 0.0:
		is_overloaded = false
		attribute_system.remove_modifiers_by_source("elarion_overload")

# --- Q: RUNIC SLASH (DIRECTIONAL CRESCENT WAVE) ---
func cast_elarion_q(target_point: Vector3) -> bool:
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
		
	var hit_count := 0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				var diff = entity.global_position - cur_pos
				if diff.length() <= 4.5 and dir.dot(diff.normalized()) > 0.3:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.MAGICAL, "Runic Slash")
					CombatCalculator.execute_damage(req)
					hit_count += 1
					
	runic_slash_struck.emit(dir, hit_count)
	return true

# --- W: ARCANE STEP (TARGETED BLINK + SLOW) ---
func cast_elarion_w(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or target.team == team:
		return false
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.W, target):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var base_dmg = w_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var total_dmg = base_dmg + (ap * w_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.W, target):
		return false
		
	# Blink behind target
	if is_inside_tree():
		global_position = target.global_position + target.transform.basis.z.normalized() * 1.5
	else:
		position = target.position + Vector3(0, 0, 1.5)
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.MAGICAL, "Arcane Step")
	CombatCalculator.execute_damage(req)
	if "effect_container" in target and target.effect_container != null:
		target.effect_container.apply_slow(0.50, 2.0)
		
	arcane_step_blinked.emit(target)
	return true

# --- E: MANA DRAIN (TARGETED MANA BURN & SIPHON) ---
func cast_elarion_e(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or target.team == team:
		return false
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.E, target):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var base_dmg = e_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var total_dmg = base_dmg + (ap * e_res.scaling_ratio)
	var burn_amount = 40.0 + (lvl * 25.0)
	
	if not ability_container.cast_ability(AbilityResource.Slot.E, target):
		return false
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.MAGICAL, "Mana Drain")
	CombatCalculator.execute_damage(req)
	
	if "attribute_system" in target and target.attribute_system != null:
		CombatMechanicsClass.burn_mana(self, target, burn_amount, 0.8, "Mana Siphon")
	attribute_system.restore_mana(burn_amount)
	
	mana_siphoned.emit(target, burn_amount)
	return true

# --- R: OVERLOAD (SELF BUFF + AOE DETONATION) ---
func cast_elarion_r() -> bool:
	if not can_cast():
		return false
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast(AbilityResource.Slot.R):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var total_dmg = base_dmg + (ap * r_res.scaling_ratio)
	var shield_val = 200.0 + (lvl * 80.0) + (ap * 0.60)
	
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return false
		
	is_overloaded = true
	overload_timer = 6.0
	
	var as_buff = StatModifier.new(StatModifier.TargetStat.ATTACK_SPEED, StatModifier.Type.PERCENT_ADD, 0.45, "elarion_overload")
	attribute_system.add_modifier(as_buff)
	CombatMechanicsClass.apply_shield(self, self, "elarion_overload_shield", "Aşırı Yükleme", shield_val, 6.0)
	
	# Blast nearby enemies
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if global_position.distance_to(entity.global_position) <= 5.5:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.MAGICAL, "Overload Detonation")
					CombatCalculator.execute_damage(req)
					
	overload_detonated.emit(shield_val)
	return true
