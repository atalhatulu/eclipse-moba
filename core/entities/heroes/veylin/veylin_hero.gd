class_name VeylinHero
extends HeroEntity

## Implementation of Veylin (The Spell Mimic / INT Arcane Adaptation Mage)

signal study_stack_changed(new_stacks: int)
signal spell_countered()
signal spell_rewritten()
signal adaptation_unleashed(target_pos: Vector3, enemies_hit: int)

var study_stacks: int = 0
const MAX_STUDY_STACKS: int = 5
const AP_PER_STUDY_STACK: float = 8.0

var is_rewrite_buff_active: bool = false

func _ready() -> void:
	entity_name = "Veylin"
	hero_resource = VeylinDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_veylin_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.46
		shape.height = 1.80
		col.shape = shape
		col.position.y = 0.90
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("VeylinVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "VeylinVisual"
		add_child(root_vis)
		
		# Mimic Mage Indigo Robes (1.80m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.42
		body_capsule.height = 1.80
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.90
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.25, 0.2, 0.55, 1.0) # Deep Mimic Indigo
		mat.roughness = 0.35
		body_inst.material_override = mat
		root_vis.add_child(body_inst)
		
		# Prismatic Floating Spell Tome
		var book = MeshInstance3D.new()
		var box = BoxMesh.new()
		box.size = Vector3(0.35, 0.08, 0.45)
		book.mesh = box
		book.position = Vector3(0.5, 1.2, 0.3)
		var book_mat = StandardMaterial3D.new()
		book_mat.albedo_color = Color(0.8, 0.3, 0.9, 1.0) # Arcane Prismatic
		book_mat.emission_enabled = true
		book_mat.emission = Color(0.8, 0.3, 0.9)
		book.material_override = book_mat
		root_vis.add_child(book)

func _apply_veylin_definition() -> void:
	if hero_resource == null:
		hero_resource = VeylinDefinition.create_resource()
		
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
	
	ability_container.set_ability(AbilityResource.Slot.PASSIVE, def.passive_ability)
	ability_container.set_ability(AbilityResource.Slot.Q, def.q_ability)
	ability_container.set_ability(AbilityResource.Slot.W, def.w_ability)
	ability_container.set_ability(AbilityResource.Slot.E, def.e_ability)
	ability_container.set_ability(AbilityResource.Slot.R, def.r_ability)

# --- PASSIVE: STUDY ENGINE ---

func add_study_stack(amount: int = 1) -> int:
	study_stacks = clampi(study_stacks + amount, 0, MAX_STUDY_STACKS)
	_sync_study_buff()
	study_stack_changed.emit(study_stacks)
	return study_stacks

func _sync_study_buff() -> void:
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("veylin_study_ap")
		if study_stacks > 0:
			var bonus_ap = float(study_stacks) * AP_PER_STUDY_STACK
			var mod = StatModifier.new(StatModifier.TargetStat.ABILITY_POWER, StatModifier.Type.FLAT, bonus_ap, "veylin_study_ap")
			attribute_system.add_modifier(mod)

# --- Q: MIMIC (ADAPTIVE BOLT) ---

func cast_veylin_q(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or target.team == team:
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast(AbilityResource.Slot.Q):
		return null
		
	if not ability_container.cast_ability(AbilityResource.Slot.Q):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	
	# Stacks amplify Q damage by +10% per stack
	var stack_amp = 1.0 + (float(study_stacks) * 0.10)
	var rewrite_bonus = 1.30 if is_rewrite_buff_active else 1.0
	is_rewrite_buff_active = false
	
	var total_dmg = (base_dmg + (ap * q_res.scaling_ratio)) * stack_amp * rewrite_bonus
	
	add_study_stack(1) # Gain study on spell cast
	
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.MAGICAL, "Mimic Bolt")
	return CombatCalculator.execute_damage(req)

# --- W: COUNTERSPELL (SPELL BARRIER) ---

func cast_veylin_w() -> bool:
	if not can_cast():
		return false
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var shield_amt = w_res.get_base_damage(lvl) + (attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) * 0.50)
	
	if effect_container != null:
		var shield_eff = StatusEffect.new("veylin_counterspell_shield", StatusEffect.EffectType.SHIELD, 2.0, shield_amt)
		effect_container.apply_effect(shield_eff)
		
	add_study_stack(2) # Successful counterspell adds 2 study stacks
	spell_countered.emit()
	return true

# --- E: REWRITE (MATRIX TRANSMUTATION) ---

func cast_veylin_e() -> bool:
	if not can_cast():
		return false
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null:
		return false
		
	if ability_container.ability_levels.get(AbilityResource.Slot.E, 0) <= 0:
		ability_container.ability_levels[AbilityResource.Slot.E] = 1
		
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return false
		
	# Reset Q cooldown
	ability_container.cooldown_timers[AbilityResource.Slot.Q] = 0.0
	is_rewrite_buff_active = true
	
	spell_rewritten.emit()
	return true

# --- R: ADAPTATION (ARCANE SURGE - ULTIMATE) ---

func cast_veylin_r(target_pos: Vector3, enemies: Array = []) -> Array[DamageResult]:
	if not can_cast():
		return []
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null:
		return []
		
	if ability_container.ability_levels.get(AbilityResource.Slot.R, 0) <= 0:
		ability_container.ability_levels[AbilityResource.Slot.R] = 1
		
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return []
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var total_dmg = base_dmg + (ap * r_res.scaling_ratio)
	
	# Grant self buffs: +30% Spell Vamp & +25% Move Speed for 6s
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("veylin_adaptation_buff")
		var sv_mod = StatModifier.new(StatModifier.TargetStat.SPELL_VAMP, StatModifier.Type.FLAT, 0.30, "veylin_adaptation_buff", 6.0)
		var ms_mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.25, "veylin_adaptation_buff", 6.0)
		attribute_system.add_modifier(sv_mod)
		attribute_system.add_modifier(ms_mod)
		
	var results: Array[DamageResult] = []
	var targets = enemies if not enemies.is_empty() else HeroEntity.active_heroes
	var my_pos = global_position if is_inside_tree() else position
	
	for e in targets:
		if e is BaseCombatEntity and is_instance_valid(e) and e.is_alive() and e.team != team and e.is_targetable:
			var e_pos = e.global_position if e.is_inside_tree() else e.position
			if my_pos.distance_to(e_pos) <= 7.0:
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.MAGICAL, "Adaptation")
				var res = CombatCalculator.execute_damage(req)
				results.append(res)
				
	study_stacks = MAX_STUDY_STACKS
	_sync_study_buff()
	
	adaptation_unleashed.emit(target_pos, results.size())
	return results

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	study_stacks = 0
	is_rewrite_buff_active = false
	_sync_study_buff()

func respawn() -> void:
	super.respawn()
	study_stacks = 0
	is_rewrite_buff_active = false
	_sync_study_buff()
