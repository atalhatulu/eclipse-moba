class_name IlyraHero
extends HeroEntity

## Implementation of Ilyra (INT Battlemage / Weave & Grand Weave)

signal weave_stacked(current_stacks: int, bonus_ap_pct: float, bonus_ms_pct: float)
signal ember_thread_struck(target: BaseCombatEntity, damage: float)
signal frost_thread_cast(position: Vector3, slow_duration: float)
signal arc_thread_chained(primary_target: BaseCombatEntity, bounces: int)
signal grand_weave_unleashed(position: Vector3, element_count: int, final_damage: float)

# State
var weave_stacks: int = 0
var weave_timer: float = 0.0
var spell_history: Array[String] = [] # Recent spell IDs (e.g. ["Q", "W", "E"])
const MAX_WEAVE_STACKS: int = 4
const WEAVE_DURATION: float = 6.0

func _ready() -> void:
	entity_name = "Ilyra"
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_ilyra_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.45
		shape.height = 1.9
		col.shape = shape
		col.position.y = 0.95
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("IlyraVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "IlyraVisual"
		add_child(root_vis)
		
		# Mystic Weaver Robed Silhouette
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.42
		body_capsule.height = 1.9
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.95
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.20, 0.12, 0.32, 1.0) # Arcane Silk Robes
		body_mat.metallic = 0.3
		body_mat.roughness = 0.5
		body_mat.emission_enabled = true
		body_mat.emission = Color(0.85, 0.35, 0.85, 1.0)
		body_mat.emission_energy_multiplier = 1.1
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
		# Floating Elemental Weaving Loom Rings
		var loom = MeshInstance3D.new()
		var torus_loom = TorusMesh.new()
		torus_loom.inner_radius = 0.55
		torus_loom.outer_radius = 0.60
		loom.mesh = torus_loom
		loom.position = Vector3(0.0, 1.45, 0.0)
		loom.rotation_degrees = Vector3(45, 0, 45)
		
		var loom_mat = StandardMaterial3D.new()
		loom_mat.albedo_color = Color(0.4, 0.8, 1.0, 1.0)
		loom_mat.emission_enabled = true
		loom_mat.emission = Color(0.4, 0.8, 1.0, 1.0)
		loom_mat.emission_energy_multiplier = 1.5
		loom.material_override = loom_mat
		root_vis.add_child(loom)
		
		# Selection Base Ring
		var ring = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.85
		torus.outer_radius = 0.90
		ring.mesh = torus
		ring.position.y = 0.03
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var ring_color = Color(0.95, 0.3, 0.3, 0.85) if team == TeamDefinitions.Team.DIRE else Color(0.92, 0.96, 1.0, 0.85)
		ring_mat.albedo_color = ring_color
		ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		ring.material_override = ring_mat
		root_vis.add_child(ring)

func _apply_ilyra_definition() -> void:
	if hero_resource == null:
		hero_resource = IlyraDefinition.create_resource()
		
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
	_process_weave(delta)

# --- PASSIVE: WEAVE ---

func _record_spell_cast(spell_type: String) -> void:
	var is_different = spell_history.is_empty() or spell_history.back() != spell_type
	spell_history.append(spell_type)
	if spell_history.size() > 3:
		spell_history.pop_front()
		
	if is_different:
		weave_stacks = mini(MAX_WEAVE_STACKS, weave_stacks + 1)
	else:
		weave_stacks = 1 # Reset to 1 on repeat
		
	weave_timer = WEAVE_DURATION
	_apply_weave_modifiers()

func _apply_weave_modifiers() -> void:
	if attribute_system == null:
		return
		
	attribute_system.remove_modifiers_by_source("ilyra_weave_ap")
	attribute_system.remove_modifiers_by_source("ilyra_weave_ms")
	
	if weave_stacks > 0:
		var bonus_ap_pct = weave_stacks * 0.08
		var bonus_ms_pct = weave_stacks * 0.05
		var ap_mod = StatModifier.new(StatModifier.TargetStat.DAMAGE_AMPLIFICATION, StatModifier.Type.PERCENT_ADD, bonus_ap_pct, "ilyra_weave_ap")
		var ms_mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, bonus_ms_pct, "ilyra_weave_ms")
		attribute_system.add_modifier(ap_mod)
		attribute_system.add_modifier(ms_mod)
		weave_stacked.emit(weave_stacks, bonus_ap_pct, bonus_ms_pct)

func _process_weave(delta: float) -> void:
	if weave_timer > 0.0:
		weave_timer -= delta
		if weave_timer <= 0.0:
			weave_stacks = 0
			_apply_weave_modifiers()

# --- Q: EMBER THREAD ---

func cast_ilyra_q(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var intel = attribute_system.get_stat(StatModifier.TargetStat.INTELLIGENCE)
	var total_dmg = base_dmg + (intel * q_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.Q, target):
		return null
		
	_record_spell_cast("EMBER")
	
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.MAGICAL, "Ember Thread")
	var res = CombatCalculator.execute_damage(req)
	
	ember_thread_struck.emit(target, total_dmg)
	return res

# --- W: FROST THREAD ---

func cast_ilyra_w(target_pos: Vector3, enemies_in_area: Array[BaseCombatEntity] = []) -> bool:
	if not can_cast():
		return false
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	_record_spell_cast("FROST")
	
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var base_dmg = w_res.get_base_damage(lvl)
	var intel = attribute_system.get_stat(StatModifier.TargetStat.INTELLIGENCE)
	var total_dmg = base_dmg + (intel * w_res.scaling_ratio)
	
	for enemy in enemies_in_area:
		if enemy != null and is_instance_valid(enemy) and enemy.is_alive() and enemy.team != team:
			var req = DamageRequest.create_ability_damage(self, enemy, total_dmg, DamageRequest.DamageType.MAGICAL, "Frost Thread")
			CombatCalculator.execute_damage(req)
			if enemy.status_effect_manager != null:
				enemy.status_effect_manager.apply_slow(0.35, 2.5)
				
	frost_thread_cast.emit(target_pos, 2.5)
	return true

# --- E: ARC THREAD ---

func cast_ilyra_e(primary_target: BaseCombatEntity, secondary_targets: Array[BaseCombatEntity] = []) -> DamageResult:
	if not can_cast() or primary_target == null or not is_instance_valid(primary_target) or not primary_target.is_alive() or not primary_target.is_targetable or primary_target.team == team:
		return null
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.E, primary_target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var base_dmg = e_res.get_base_damage(lvl)
	var intel = attribute_system.get_stat(StatModifier.TargetStat.INTELLIGENCE)
	var total_dmg = base_dmg + (intel * e_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.E, primary_target):
		return null
		
	_record_spell_cast("ARC")
	
	var req = DamageRequest.create_ability_damage(self, primary_target, total_dmg, DamageRequest.DamageType.MAGICAL, "Arc Thread")
	var res = CombatCalculator.execute_damage(req)
	
	# Chain to up to 3 secondary targets
	var bounces = 0
	for sec in secondary_targets:
		if bounces >= 3:
			break
		if sec != null and is_instance_valid(sec) and sec.is_alive() and sec != primary_target and sec.team != team:
			var sec_req = DamageRequest.create_ability_damage(self, sec, total_dmg * 0.70, DamageRequest.DamageType.MAGICAL, "Arc Thread Chain")
			CombatCalculator.execute_damage(sec_req)
			bounces += 1
			
	arc_thread_chained.emit(primary_target, bounces)
	return res

# --- R: GRAND WEAVE (ULTIMATE) ---

func cast_ilyra_r(target_pos: Vector3, enemies_in_area: Array[BaseCombatEntity] = []) -> bool:
	if not can_cast():
		return false
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast(AbilityResource.Slot.R):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var intel = attribute_system.get_stat(StatModifier.TargetStat.INTELLIGENCE)
	
	# Grand Weave multiplier based on weave stacks
	var stack_multiplier = 1.0 + (weave_stacks * 0.25)
	var total_dmg = (base_dmg + (intel * r_res.scaling_ratio)) * stack_multiplier
	
	# Element synergy from history
	var unique_elements = {}
	for el in spell_history:
		unique_elements[el] = true
	var element_count = unique_elements.size()
	
	for enemy in enemies_in_area:
		if enemy != null and is_instance_valid(enemy) and enemy.is_alive() and enemy.team != team:
			var req = DamageRequest.create_ability_damage(self, enemy, total_dmg, DamageRequest.DamageType.MAGICAL, "Grand Weave")
			CombatCalculator.execute_damage(req)
			if enemy.status_effect_manager != null:
				enemy.status_effect_manager.apply_slow(0.50, 3.0)
				
	grand_weave_unleashed.emit(target_pos, element_count, total_dmg)
	
	# Consume stacks
	weave_stacks = 0
	spell_history.clear()
	_apply_weave_modifiers()
	return true

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	weave_stacks = 0
	weave_timer = 0.0
	spell_history.clear()
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("ilyra_weave_ap")
		attribute_system.remove_modifiers_by_source("ilyra_weave_ms")

func respawn() -> void:
	super.respawn()
	weave_stacks = 0
	weave_timer = 0.0
	spell_history.clear()
