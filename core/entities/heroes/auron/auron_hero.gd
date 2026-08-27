class_name AuronHero
extends HeroEntity

## Implementation of Auron (The Bulwark Guardian / STR Support Tank)

const AuronDefinition = preload("res://data/heroes/auron_definition.gd")

signal resolve_updated(current_resolve: float, max_resolve: float)
signal guarding_blow_struck(target: BaseCombatEntity, shielded_unit: BaseCombatEntity)
signal interpose_executed(ally: HeroEntity)
signal rally_executed()
signal guardian_bond_formed(ally: HeroEntity)
signal oath_save_triggered(ally: HeroEntity, heal_amount: float)

# Passive Resolve State
var stored_resolve: float = 0.0
const MAX_RESOLVE: float = 100.0

# W: Interpose State
var interpose_target: HeroEntity = null
var interpose_timer: float = 0.0

# R: Guardian's Oath State
var bonded_ally: HeroEntity = null
var bonded_timer: float = 0.0

func _ready() -> void:
	entity_name = "Auron"
	hero_resource = AuronDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_auron_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.65
		shape.height = 2.1
		col.shape = shape
		col.position.y = 1.05
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("AuronVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "AuronVisual"
		add_child(root_vis)
		
		# Golden Aegis Guardian Armored Body (2.1m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.60
		body_capsule.height = 2.1
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.05
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.85, 0.72, 0.35, 1.0) # Radiant Gold & Platinum
		body_mat.metallic = 0.90
		body_mat.roughness = 0.25
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
		# Tower Shield Mesh on Left Arm
		var shield = MeshInstance3D.new()
		var s_box = BoxMesh.new()
		s_box.size = Vector3(0.20, 1.40, 0.80)
		shield.mesh = s_box
		shield.position = Vector3(-0.65, 1.05, 0.35)
		
		var s_mat = StandardMaterial3D.new()
		s_mat.albedo_color = Color(0.95, 0.85, 0.45, 1.0)
		s_mat.metallic = 0.95
		shield.material_override = s_mat
		root_vis.add_child(shield)
		
		# Selection Base Ring
		var ring = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.90
		torus.outer_radius = 0.95
		ring.mesh = torus
		ring.position.y = 0.03
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var ring_color = Color(0.95, 0.3, 0.3, 0.85) if team == TeamDefinitions.Team.DIRE else Color(0.92, 0.96, 1.0, 0.85)
		ring_mat.albedo_color = ring_color
		ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		ring.material_override = ring_mat
		root_vis.add_child(ring)

func _apply_auron_definition() -> void:
	if hero_resource == null:
		hero_resource = AuronDefinition.create_resource()
		
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
	
	attribute_system.recalculate_all_stats()
	attribute_system.heal(attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
	attribute_system.restore_mana(attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA))
	
	# Assign abilities
	ability_container.set_ability(AbilityResource.Slot.PASSIVE, def.passive_ability)
	ability_container.set_ability(AbilityResource.Slot.Q, def.q_ability)
	ability_container.set_ability(AbilityResource.Slot.W, def.w_ability)
	ability_container.set_ability(AbilityResource.Slot.E, def.e_ability)
	ability_container.set_ability(AbilityResource.Slot.R, def.r_ability)

func _process(delta: float) -> void:
	super._process(delta)
	
	_process_interpose(delta)
	_process_guardian_bond(delta)

# --- PASSIVE: SHARED RESOLVE ---

func get_resolve() -> float:
	return stored_resolve

func add_resolve(amount: float) -> void:
	if amount <= 0.0:
		return
	stored_resolve = clampf(stored_resolve + amount, 0.0, MAX_RESOLVE)
	_sync_resolve_regen()
	resolve_updated.emit(stored_resolve, MAX_RESOLVE)

func _sync_resolve_regen() -> void:
	if attribute_system == null:
		return
	var regen_bonus = stored_resolve * 0.08
	attribute_system.remove_modifiers_by_source("auron_resolve_regen")
	if regen_bonus > 0.01:
		var mod = StatModifier.new(
			StatModifier.TargetStat.HEALTH_REGEN,
			StatModifier.Type.FLAT,
			regen_bonus,
			"auron_resolve_regen"
		)
		attribute_system.add_modifier(mod)

# --- Q: GUARDING BLOW ---

func cast_auron_q(target: BaseCombatEntity, ally_to_shield: HeroEntity = null) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * q_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.Q, target):
		return null
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Guarding Blow")
	var res = CombatCalculator.execute_damage(req)
	
	# Grant Shield to recipient
	var recipient = ally_to_shield if (ally_to_shield != null and is_instance_valid(ally_to_shield) and ally_to_shield.is_alive() and ally_to_shield.team == team) else self
	var shield_val = 80.0 + (lvl * 30.0) + (stored_resolve * 0.80)
	if recipient.effect_container != null:
		var shield_eff = StatusEffect.new("auron_guarding_shield", StatusEffect.EffectType.SHIELD, 3.5, shield_val)
		recipient.effect_container.apply_effect(shield_eff)
		
	guarding_blow_struck.emit(target, recipient)
	return res

# --- W: INTERPOSE ---

func cast_auron_w(ally: HeroEntity) -> bool:
	if not can_cast() or ally == null or not is_instance_valid(ally) or not ally.is_alive() or ally.team != team or ally == self:
		return false
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.W, ally):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var shield_val = 100.0 + (lvl * 50.0)
	
	if not ability_container.cast_ability(AbilityResource.Slot.W, ally):
		return false
		
	# Dash to ally
	var a_pos = ally.global_position if is_inside_tree() else ally.position
	if is_inside_tree():
		global_position = a_pos + Vector3(0.5, 0, 0.5)
	else:
		position = a_pos + Vector3(0.5, 0, 0.5)
		
	# Apply shield to both
	if effect_container != null:
		effect_container.apply_effect(StatusEffect.new("auron_interpose_shield", StatusEffect.EffectType.SHIELD, 3.0, shield_val))
	if ally.effect_container != null:
		ally.effect_container.apply_effect(StatusEffect.new("auron_interpose_shield", StatusEffect.EffectType.SHIELD, 3.0, shield_val))
		
	interpose_target = ally
	interpose_timer = 4.0
	
	interpose_executed.emit(ally)
	return true

func _process_interpose(delta: float) -> void:
	if interpose_timer > 0.0:
		interpose_timer -= delta
		if interpose_timer <= 0.0 or interpose_target == null or not is_instance_valid(interpose_target) or not interpose_target.is_alive():
			interpose_target = null
			interpose_timer = 0.0

# --- E: RALLY ---

func cast_auron_e(allies_in_range: Array = []) -> bool:
	if not can_cast():
		return false
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var armor_bonuses = [20.0, 30.0, 40.0, 50.0]
	var bonus_armor = armor_bonuses[clamp(lvl - 1, 0, 3)]
	
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return false
		
	var targets = allies_in_range.duplicate()
	if targets.is_empty():
		var all_nodes: Array = []
		if is_inside_tree() and get_tree() != null:
			all_nodes = get_tree().get_nodes_in_group("combat_entities")
		else:
			all_nodes.append_array(HeroEntity.active_heroes)
			
		var my_pos = global_position if is_inside_tree() else position
		for n in all_nodes:
			if n is HeroEntity and is_instance_valid(n) and n.is_alive() and n.team == team:
				var n_pos = n.global_position if is_inside_tree() else n.position
				if my_pos.distance_to(n_pos) <= 8.0 or my_pos.distance_to(n_pos) <= 800.0:
					targets.append(n)
					
	for ally in targets:
		if ally is HeroEntity and ally.attribute_system != null:
			ally.attribute_system.remove_modifiers_by_source("auron_rally_armor")
			var mod = StatModifier.new(StatModifier.TargetStat.ARMOR, StatModifier.Type.FLAT, bonus_armor, "auron_rally_armor")
			ally.attribute_system.add_modifier(mod)
			
	rally_executed.emit()
	return true

# --- R: GUARDIAN'S OATH (ULTIMATE) ---

func cast_auron_r(ally: HeroEntity) -> bool:
	if not can_cast() or ally == null or not is_instance_valid(ally) or not ally.is_alive() or ally.team != team or ally == self:
		return false
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.R, ally):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.R, ally):
		return false
		
	bonded_ally = ally
	bonded_timer = 6.0
	
	guardian_bond_formed.emit(ally)
	return true

func _process_guardian_bond(delta: float) -> void:
	if bonded_timer > 0.0:
		bonded_timer -= delta
		
		# Check if bonded ally took lethal damage and save them
		if bonded_ally != null and is_instance_valid(bonded_ally):
			if bonded_ally.attribute_system.current_health <= 1.0 and bonded_ally.is_alive():
				var str_val = attribute_system.get_stat(StatModifier.TargetStat.STRENGTH)
				var heal_val = 300.0 + (str_val * 3.0)
				bonded_ally.attribute_system.heal(heal_val)
				
				# Auron absorbs self damage equal to half heal
				attribute_system.current_health = maxf(1.0, attribute_system.current_health - (heal_val * 0.50))
				oath_save_triggered.emit(bonded_ally, heal_val)
				
				bonded_ally = null
				bonded_timer = 0.0
		else:
			bonded_ally = null
			bonded_timer = 0.0

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	stored_resolve = 0.0
	interpose_target = null
	interpose_timer = 0.0
	bonded_ally = null
	bonded_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("auron_resolve_regen")

func respawn() -> void:
	super.respawn()
	stored_resolve = 0.0
	interpose_target = null
	interpose_timer = 0.0
	bonded_ally = null
	bonded_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("auron_resolve_regen")
