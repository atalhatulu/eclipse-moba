class_name DurnHero
extends HeroEntity

## Implementation of Durn (The Iron Colossus / STR Siege Artillery)

const DurnDefinition = preload("res://data/heroes/durn_definition.gd")

signal siege_stance_changed(is_active: bool)
signal fortify_activated()
signal fortify_ended()
signal mine_placed(location: Vector3)
signal mine_detonated(location: Vector3)
signal grand_barrage_fired(location: Vector3)

# Siege Stance State
var is_siege_stance: bool = false
var standstill_timer: float = 0.0
var last_pos: Vector3 = Vector3.ZERO

# Fortify State
var is_fortified: bool = false
var fortify_timer: float = 0.0

# Shock Mines State
var active_mines: Array[Dictionary] = []

func _ready() -> void:
	entity_name = "Durn"
	hero_resource = DurnDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_durn_definition()
	last_pos = global_position if is_inside_tree() else position

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.70
		shape.height = 2.2
		col.shape = shape
		col.position.y = 1.10
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("DurnVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "DurnVisual"
		add_child(root_vis)
		
		# Heavy Fortified Iron Hull (2.2m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.65
		body_capsule.height = 2.2
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.10
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.32, 0.28, 0.25, 1.0) # Siege Iron / Granite
		body_mat.metallic = 0.85
		body_mat.roughness = 0.45
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
		# Rear Mortar / Cannon Mesh
		var cannon = MeshInstance3D.new()
		var cyl = CylinderMesh.new()
		cyl.top_radius = 0.20
		cyl.bottom_radius = 0.25
		cyl.height = 1.2
		cannon.mesh = cyl
		cannon.position = Vector3(0.0, 1.7, -0.4)
		cannon.rotation_degrees = Vector3(-35, 0, 0)
		
		var can_mat = StandardMaterial3D.new()
		can_mat.albedo_color = Color(0.20, 0.20, 0.22, 1.0)
		can_mat.metallic = 0.90
		cannon.material_override = can_mat
		root_vis.add_child(cannon)
		
		# Selection Base Ring
		var ring = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.95
		torus.outer_radius = 1.00
		ring.mesh = torus
		ring.position.y = 0.03
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var ring_color = Color(0.95, 0.3, 0.3, 0.85) if team == TeamDefinitions.Team.DIRE else Color(0.92, 0.96, 1.0, 0.85)
		ring_mat.albedo_color = ring_color
		ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		ring.material_override = ring_mat
		root_vis.add_child(ring)

func _apply_durn_definition() -> void:
	if hero_resource == null:
		hero_resource = DurnDefinition.create_resource()
		
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
	
	_process_siege_stance(delta)
	_process_fortify(delta)
	_process_mines(delta)

# --- PASSIVE: SIEGE STANCE ---

func _process_siege_stance(delta: float) -> void:
	if not is_alive():
		_exit_siege_stance()
		return
		
	var cur_pos = global_position if is_inside_tree() else position
	var dist = cur_pos.distance_to(last_pos)
	last_pos = cur_pos
	
	if dist > 0.05:
		standstill_timer = 0.0
		if is_siege_stance:
			_exit_siege_stance()
	else:
		standstill_timer += delta
		if standstill_timer >= 1.5 and not is_siege_stance:
			_enter_siege_stance()

func _enter_siege_stance() -> void:
	is_siege_stance = true
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("durn_siege_range")
		attribute_system.remove_modifiers_by_source("durn_siege_ad")
		
		var range_mod = StatModifier.new(
			StatModifier.TargetStat.ATTACK_RANGE,
			StatModifier.Type.FLAT,
			200.0,
			"durn_siege_range"
		)
		var ad_mod = StatModifier.new(
			StatModifier.TargetStat.ATTACK_DAMAGE,
			StatModifier.Type.PERCENT_ADD,
			0.25,
			"durn_siege_ad"
		)
		attribute_system.add_modifier(range_mod)
		attribute_system.add_modifier(ad_mod)
		
	siege_stance_changed.emit(true)

func _exit_siege_stance() -> void:
	is_siege_stance = false
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("durn_siege_range")
		attribute_system.remove_modifiers_by_source("durn_siege_ad")
	siege_stance_changed.emit(false)

# --- Q: BOULDER SHOT ---

func cast_durn_q(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * q_res.scaling_ratio)
	
	if is_siege_stance:
		total_dmg *= 1.20 # +20% damage in Siege Stance
		
	if not ability_container.cast_ability(AbilityResource.Slot.Q, target):
		return null
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Boulder Shot")
	return CombatCalculator.execute_damage(req)

# --- W: FORTIFY ---

func cast_durn_w() -> bool:
	if not can_cast():
		return false
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var armor_bonuses = [35.0, 50.0, 65.0, 80.0]
	var bonus_def = armor_bonuses[clamp(lvl - 1, 0, 3)]
	
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	is_fortified = true
	fortify_timer = 5.0
	
	attribute_system.remove_modifiers_by_source("durn_fortify_armor")
	attribute_system.remove_modifiers_by_source("durn_fortify_mr")
	
	attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ARMOR, StatModifier.Type.FLAT, bonus_def, "durn_fortify_armor"))
	attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.MAGIC_RESIST, StatModifier.Type.FLAT, bonus_def, "durn_fortify_mr"))
	
	fortify_activated.emit()
	return true

func _process_fortify(delta: float) -> void:
	if is_fortified:
		fortify_timer -= delta
		if fortify_timer <= 0.0:
			_end_fortify()

func _end_fortify() -> void:
	is_fortified = false
	fortify_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("durn_fortify_armor")
		attribute_system.remove_modifiers_by_source("durn_fortify_mr")
	fortify_ended.emit()

# --- E: SHOCK MINE ---

func cast_durn_e(target_location: Vector3) -> bool:
	if not can_cast():
		return false
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var base_dmg = e_res.get_base_damage(lvl)
	
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return false
		
	var mine_data = {
		"position": target_location,
		"damage": base_dmg,
		"is_active": true
	}
	active_mines.append(mine_data)
	mine_placed.emit(target_location)
	return true

func _process_mines(delta: float) -> void:
	if active_mines.is_empty():
		return
		
	var enemies: Array = []
	if is_inside_tree() and get_tree() != null:
		enemies = get_tree().get_nodes_in_group("combat_entities")
	else:
		enemies.append_array(HeroEntity.active_heroes)
		enemies.append_array(CreepEntity.active_creeps)
		
	for i in range(active_mines.size() - 1, -1, -1):
		var mine = active_mines[i]
		var m_pos: Vector3 = mine["position"]
		var triggered = false
		
		for e in enemies:
			if e is BaseCombatEntity and is_instance_valid(e) and e.is_alive() and e.team != team and e.is_targetable:
				var e_pos = e.global_position if is_inside_tree() else e.position
				if m_pos.distance_to(e_pos) <= 2.5 or m_pos.distance_to(e_pos) <= 250.0:
					triggered = true
					break
					
		if triggered:
			_detonate_mine(i, enemies)

func _detonate_mine(mine_idx: int, potential_targets: Array) -> void:
	if mine_idx < 0 or mine_idx >= active_mines.size():
		return
	var mine = active_mines[mine_idx]
	var m_pos: Vector3 = mine["position"]
	var dmg: float = mine["damage"]
	active_mines.remove_at(mine_idx)
	
	for e in potential_targets:
		if e is BaseCombatEntity and is_instance_valid(e) and e.is_alive() and e.team != team and e.is_targetable:
			var e_pos = e.global_position if is_inside_tree() else e.position
			if m_pos.distance_to(e_pos) <= 3.5 or m_pos.distance_to(e_pos) <= 350.0:
				var req = DamageRequest.create_ability_damage(self, e, dmg, DamageRequest.DamageType.MAGICAL, "Shock Mine")
				CombatCalculator.execute_damage(req)
				if e.effect_container != null:
					e.effect_container.apply_effect(StatusEffect.new("durn_mine_slow", StatusEffect.EffectType.SLOW, 2.0, 0.40))
					
	mine_detonated.emit(m_pos)

# --- R: GRAND BARRAGE (ULTIMATE) ---

func cast_durn_r(target_location: Vector3, nearby_targets: Array = []) -> Array[DamageResult]:
	if not can_cast():
		return []
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast(AbilityResource.Slot.R):
		return []
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * r_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return []
		
	var targets_to_hit = nearby_targets.duplicate()
	if targets_to_hit.is_empty():
		var all_nodes: Array = []
		if is_inside_tree() and get_tree() != null:
			all_nodes = get_tree().get_nodes_in_group("combat_entities")
		else:
			all_nodes.append_array(HeroEntity.active_heroes)
			all_nodes.append_array(CreepEntity.active_creeps)
			
		for n in all_nodes:
			if n is BaseCombatEntity and is_instance_valid(n) and n != self and n.is_alive() and n.team != team and n.is_targetable:
				var n_pos = n.global_position if is_inside_tree() else n.position
				if target_location.distance_to(n_pos) <= 5.5 or target_location.distance_to(n_pos) <= 550.0:
					targets_to_hit.append(n)
					
	var results: Array[DamageResult] = []
	for t in targets_to_hit:
		var req = DamageRequest.create_ability_damage(self, t, total_dmg, DamageRequest.DamageType.PHYSICAL, "Grand Barrage")
		var res = CombatCalculator.execute_damage(req)
		results.append(res)
		
	grand_barrage_fired.emit(target_location)
	return results

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	_exit_siege_stance()
	_end_fortify()
	active_mines.clear()

func respawn() -> void:
	super.respawn()
	_exit_siege_stance()
	_end_fortify()
	active_mines.clear()
