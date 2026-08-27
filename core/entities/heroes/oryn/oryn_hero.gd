class_name OrynHero
extends HeroEntity

## Implementation of Oryn (The Resonant Enchanter / INT Debuff Purger)

const OrynDefinition = preload("res://data/heroes/oryn_definition.gd")

signal resonance_updated(stacks: int, bonus_ap: float, heal_power_pct: float)
signal mend_applied(target: BaseCombatEntity, amount_healed: float)
signal empower_applied(target: BaseCombatEntity, stat_buff: float)
signal transfer_executed(source_ally: BaseCombatEntity, target_enemy: BaseCombatEntity, debuff_name: String)
signal resonant_bond_formed(bonded_ally: BaseCombatEntity)
signal resonant_bond_broken()

# Passive: Resonance
var resonance_stacks: int = 0
const MAX_RESONANCE: int = 5
var resonance_decay_timer: float = 0.0
const RESONANCE_DURATION: float = 8.0

# R: Resonant Bond
var bonded_ally: BaseCombatEntity = null
var bond_timer: float = 0.0
const BOND_DURATION: float = 7.0

func _ready() -> void:
	entity_name = "Oryn"
	hero_resource = OrynDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_oryn_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.52
		shape.height = 1.95
		col.shape = shape
		col.position.y = 0.98
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("OrynVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "OrynVisual"
		add_child(root_vis)
		
		# Resonant Robes Body (1.95m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.48
		body_capsule.height = 1.95
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.98
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.15, 0.65, 0.55, 1.0) # Harmonic Jade Green
		mat.roughness = 0.40
		body_inst.material_override = mat
		root_vis.add_child(body_inst)
		
		# Resonant Halo Ring
		var halo = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.45
		torus.outer_radius = 0.50
		halo.mesh = torus
		halo.position.y = 2.05
		halo.rotation.x = PI / 6.0
		
		var h_mat = StandardMaterial3D.new()
		h_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		h_mat.albedo_color = Color(0.40, 0.95, 0.75, 0.9)
		halo.material_override = h_mat
		root_vis.add_child(halo)
		
		# Selection Base Ring
		var ring = MeshInstance3D.new()
		var b_torus = TorusMesh.new()
		b_torus.inner_radius = 0.85
		b_torus.outer_radius = 0.90
		ring.mesh = b_torus
		ring.position.y = 0.03
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var ring_color = Color(0.95, 0.3, 0.3, 0.85) if team == TeamDefinitions.Team.DIRE else Color(0.2, 0.9, 0.6, 0.85)
		ring_mat.albedo_color = ring_color
		ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		ring.material_override = ring_mat
		root_vis.add_child(ring)

func _apply_oryn_definition() -> void:
	if hero_resource == null:
		hero_resource = OrynDefinition.create_resource()
		
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
	_process_resonance(delta)
	_process_bond(delta)

# --- PASSIVE: RESONANCE ---

func add_resonance_stack() -> void:
	resonance_stacks = clampi(resonance_stacks + 1, 0, MAX_RESONANCE)
	resonance_decay_timer = RESONANCE_DURATION
	_sync_resonance_buffs()

func _sync_resonance_buffs() -> void:
	if attribute_system == null:
		return
	var bonus_ap = float(resonance_stacks) * 6.0
	var heal_power = float(resonance_stacks) * 0.03
	
	attribute_system.remove_modifiers_by_source("oryn_resonance_ap")
	if bonus_ap > 0.1:
		attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ABILITY_POWER, StatModifier.Type.FLAT, bonus_ap, "oryn_resonance_ap"))
		
	resonance_updated.emit(resonance_stacks, bonus_ap, heal_power)

func _process_resonance(delta: float) -> void:
	if resonance_stacks > 0:
		resonance_decay_timer -= delta
		if resonance_decay_timer <= 0.0:
			resonance_stacks = 0
			_sync_resonance_buffs()

# --- Q: MEND (HARMONIC MEND) ---

func cast_oryn_q(target: BaseCombatEntity) -> float:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or target.team != team:
		return 0.0
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast(AbilityResource.Slot.Q):
		return 0.0
		
	if not ability_container.cast_ability(AbilityResource.Slot.Q):
		return 0.0
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_heal = q_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var heal_power_mult = 1.0 + (float(resonance_stacks) * 0.03)
	var total_heal = (base_heal + (ap * q_res.scaling_ratio)) * heal_power_mult
	
	if target == self:
		total_heal *= 0.70 # 70% self heal penalty
		
	if target.attribute_system != null:
		target.attribute_system.heal(total_heal)
		
	# Resonant Bond shared healing
	if is_bonded() and target == bonded_ally:
		attribute_system.heal(total_heal * 0.60)
	elif is_bonded() and target == self and is_instance_valid(bonded_ally) and bonded_ally.attribute_system != null:
		bonded_ally.attribute_system.heal(total_heal * 0.60)
		
	add_resonance_stack()
	mend_applied.emit(target, total_heal)
	return total_heal

# --- W: EMPOWER (HARMONIC SURGE) ---

func cast_oryn_w(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or target.team != team:
		return false
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var stat_boost = 20.0 + (float(lvl - 1) * 15.0) # 20, 35, 50, 65
	
	if target.attribute_system != null:
		target.attribute_system.remove_modifiers_by_source("oryn_empower_stat")
		target.attribute_system.remove_modifiers_by_source("oryn_empower_as")
		
		# Adaptive: boost AD if primary AGI/STR, boost AP if INT
		var stat_type = StatModifier.TargetStat.ATTACK_DAMAGE
		if "hero_resource" in target and target.hero_resource != null and target.hero_resource.primary_attribute == AttributeSystem.PrimaryAttributeType.INTELLIGENCE:
			stat_type = StatModifier.TargetStat.ABILITY_POWER
			
		target.attribute_system.add_modifier(StatModifier.new(stat_type, StatModifier.Type.FLAT, stat_boost, "oryn_empower_stat"))
		target.attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ATTACK_SPEED, StatModifier.Type.PERCENT_ADD, 0.20, "oryn_empower_as"))
		
	add_resonance_stack()
	empower_applied.emit(target, stat_boost)
	return true

# --- E: TRANSFER (PURGE & INFLICT) ---

func cast_oryn_e(target_ally: BaseCombatEntity, target_enemy: BaseCombatEntity = null) -> DamageResult:
	if not can_cast() or target_ally == null or not is_instance_valid(target_ally) or not target_ally.is_alive() or target_ally.team != team:
		return null
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return null
		
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return null
		
	# Find and purge debuff from target ally
	var purged_debuff_name = ""
	if target_ally.effect_container != null:
		if target_ally.effect_container.is_stunned():
			purged_debuff_name = "stun"
		elif target_ally.effect_container.is_silenced():
			purged_debuff_name = "silence"
		elif target_ally.effect_container.is_rooted():
			purged_debuff_name = "root"
		elif target_ally.effect_container.has_effect_type(StatusEffect.EffectType.SLOW):
			purged_debuff_name = "slow"
		target_ally.effect_container.clear_all_debuffs()
		
	# Find closest enemy if target_enemy was not provided
	if target_enemy == null or not is_instance_valid(target_enemy) or not target_enemy.is_alive():
		var ally_pos = target_ally.global_position if target_ally.is_inside_tree() else target_ally.position
		var enemies: Array = []
		if is_inside_tree() and get_tree() != null:
			enemies = get_tree().get_nodes_in_group("combat_entities")
		else:
			enemies.append_array(HeroEntity.active_heroes)
			enemies.append_array(CreepEntity.active_creeps)
		var min_dist = 999.0
		for e in enemies:
			if e is BaseCombatEntity and is_instance_valid(e) and e.is_alive() and e.team != team and e.is_targetable:
				var e_pos = e.global_position if e.is_inside_tree() else e.position
				var dist = ally_pos.distance_to(e_pos)
				if dist < min_dist and dist <= 6.0:
					min_dist = dist
					target_enemy = e
					
	var res: DamageResult = null
	if target_enemy != null and is_instance_valid(target_enemy) and target_enemy.is_alive():
		var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
		var base_dmg = e_res.get_base_damage(lvl)
		var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
		var total_dmg = base_dmg + (ap * e_res.scaling_ratio)
		
		var req = DamageRequest.create_ability_damage(self, target_enemy, total_dmg, DamageRequest.DamageType.MAGICAL, "Transfer")
		res = CombatCalculator.execute_damage(req)
		
		if not purged_debuff_name.is_empty() and target_enemy.effect_container != null:
			var eff_type = StatusEffect.EffectType.SLOW
			if purged_debuff_name == "stun": eff_type = StatusEffect.EffectType.STUN
			elif purged_debuff_name == "silence": eff_type = StatusEffect.EffectType.SILENCE
			elif purged_debuff_name == "root": eff_type = StatusEffect.EffectType.ROOT
			var debuff = StatusEffect.new("transferred_" + purged_debuff_name, eff_type, 1.5)
			target_enemy.effect_container.apply_effect(debuff)
			
	add_resonance_stack()
	transfer_executed.emit(target_ally, target_enemy, purged_debuff_name)
	return res

# --- R: RESONANT BOND (HARMONIC LINK - ULTIMATE) ---

func cast_oryn_r(target: BaseCombatEntity) -> bool:
	if not is_alive() or target == null or not is_instance_valid(target) or not target.is_alive() or target.team != team or target == self:
		return false
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null:
		return false
		
	if ability_container.ability_levels.get(AbilityResource.Slot.R, 0) <= 0:
		ability_container.ability_levels[AbilityResource.Slot.R] = 1
		
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return false
		
	bonded_ally = target
	bond_timer = BOND_DURATION
	
	# Give both units +15% Move Speed and +20 Armor/MR
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("oryn_bond_defense")
		attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ARMOR, StatModifier.Type.FLAT, 20.0, "oryn_bond_defense"))
		attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.MAGIC_RESIST, StatModifier.Type.FLAT, 20.0, "oryn_bond_defense"))
		
	if bonded_ally.attribute_system != null:
		bonded_ally.attribute_system.remove_modifiers_by_source("oryn_bond_defense")
		bonded_ally.attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ARMOR, StatModifier.Type.FLAT, 20.0, "oryn_bond_defense"))
		bonded_ally.attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.MAGIC_RESIST, StatModifier.Type.FLAT, 20.0, "oryn_bond_defense"))
		
	add_resonance_stack()
	add_resonance_stack()
	resonant_bond_formed.emit(bonded_ally)
	return true

func is_bonded() -> bool:
	return bonded_ally != null and is_instance_valid(bonded_ally) and bonded_ally.is_alive() and bond_timer > 0.0

func _process_bond(delta: float) -> void:
	if is_bonded():
		bond_timer -= delta
		if bond_timer <= 0.0 or not bonded_ally.is_alive():
			_break_bond()

func _break_bond() -> void:
	if bonded_ally != null and is_instance_valid(bonded_ally) and bonded_ally.attribute_system != null:
		bonded_ally.attribute_system.remove_modifiers_by_source("oryn_bond_defense")
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("oryn_bond_defense")
	bonded_ally = null
	bond_timer = 0.0
	resonant_bond_broken.emit()

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	_break_bond()
	resonance_stacks = 0
	_sync_resonance_buffs()

func respawn() -> void:
	super.respawn()
	_break_bond()
	resonance_stacks = 0
	_sync_resonance_buffs()
