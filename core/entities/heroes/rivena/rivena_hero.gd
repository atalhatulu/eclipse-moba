class_name RivenaHero
extends HeroEntity

## Implementation of Rivena (The Shadow Illusionist / AGI Assassin)

signal shade_spawned(pos: Vector3, total_shades: int)
signal shadow_cut_struck(target: BaseCombatEntity, total_damage: float, shade_hits: int)
signal echo_step_executed(from_pos: Vector3, to_pos: Vector3)
signal shade_command_struck(target: BaseCombatEntity, shades_used: int, damage_dealt: float)
signal nightfall_activated()
signal nightfall_ended()

# Passive Echo State
var active_shades: Array[Vector3] = []
var shade_timers: Array[float] = []
const MAX_SHADES: int = 3

# R: Nightfall State
var is_nightfall_active: bool = false
var nightfall_timer: float = 0.0

func _ready() -> void:
	entity_name = "Rivena"
	hero_resource = RivenaDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_rivena_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.48
		shape.height = 1.92
		col.shape = shape
		col.position.y = 0.96
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("RivenaVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "RivenaVisual"
		add_child(root_vis)
		
		# Shadow Weaver Body (1.92m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.45
		body_capsule.height = 1.92
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.96
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.18, 0.12, 0.28, 1.0) # Shadow Amethyst & Midnight Blue
		body_mat.metallic = 0.65
		body_mat.roughness = 0.35
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
		# Twin Shadow Scythes Mesh
		for side in [-0.48, 0.48]:
			var scythe = MeshInstance3D.new()
			var s_box = BoxMesh.new()
			s_box.size = Vector3(0.08, 0.95, 0.30)
			scythe.mesh = s_box
			scythe.position = Vector3(side, 0.90, 0.40)
			scythe.rotation_degrees = Vector3(30, 0, 0)
			
			var s_mat = StandardMaterial3D.new()
			s_mat.albedo_color = Color(0.60, 0.25, 0.90, 1.0)
			s_mat.emission_enabled = true
			s_mat.emission = Color(0.7, 0.3, 1.0, 1.0)
			s_mat.emission_energy_multiplier = 0.8
			scythe.material_override = s_mat
			root_vis.add_child(scythe)
			
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

func _apply_rivena_definition() -> void:
	if hero_resource == null:
		hero_resource = RivenaDefinition.create_resource()
		
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
	
	_process_shades(delta)
	_process_nightfall(delta)

# --- PASSIVE: ECHO ---

func spawn_shade(pos: Vector3) -> void:
	if active_shades.size() >= MAX_SHADES:
		active_shades.pop_front()
		shade_timers.pop_front()
		
	active_shades.append(pos)
	shade_timers.append(5.0)
	shade_spawned.emit(pos, active_shades.size())

func _process_shades(delta: float) -> void:
	var to_remove: Array = []
	for i in range(shade_timers.size()):
		shade_timers[i] -= delta
		if shade_timers[i] <= 0.0:
			to_remove.append(i)
			
	# Remove in reverse order
	to_remove.reverse()
	for idx in to_remove:
		if idx < active_shades.size():
			active_shades.remove_at(idx)
			shade_timers.remove_at(idx)

# --- Q: SHADOW CUT ---

func cast_rivena_q(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var main_dmg = base_dmg + (ad * q_res.scaling_ratio)
	
	var shade_count = active_shades.size()
	var shade_bonus = shade_count * (main_dmg * 0.50)
	var total_dmg = main_dmg + shade_bonus
	
	if not ability_container.cast_ability(AbilityResource.Slot.Q, target):
		return null
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Shadow Cut")
	var res = CombatCalculator.execute_damage(req)
	
	var cur_pos = global_position if is_inside_tree() else position
	spawn_shade(cur_pos)
	
	shadow_cut_struck.emit(target, total_dmg, shade_count)
	return res

# --- W: ECHO STEP ---

func cast_rivena_w(preferred_target_pos: Vector3 = Vector3.ZERO) -> bool:
	if not can_cast():
		return false
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return false
		
	if active_shades.is_empty():
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	var cur_pos = global_position if is_inside_tree() else position
	
	# Select best shade (closest to preferred_target_pos or most recent)
	var best_idx = active_shades.size() - 1
	if preferred_target_pos != Vector3.ZERO:
		var min_dist = INF
		for i in range(active_shades.size()):
			var d = active_shades[i].distance_squared_to(preferred_target_pos)
			if d < min_dist:
				min_dist = d
				best_idx = i
				
	var target_shade_pos = active_shades[best_idx]
	active_shades.remove_at(best_idx)
	shade_timers.remove_at(best_idx)
	
	if is_inside_tree():
		global_position = target_shade_pos
	else:
		position = target_shade_pos
		
	# Leave a new shade at former position
	spawn_shade(cur_pos)
	
	echo_step_executed.emit(cur_pos, target_shade_pos)
	return true

# --- E: SHADE COMMAND ---

func cast_rivena_e(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.E, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var base_dmg = e_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var per_shade_dmg = base_dmg + (ad * e_res.scaling_ratio)
	
	var shade_count = maxi(1, active_shades.size())
	var total_dmg = per_shade_dmg * shade_count
	
	if not ability_container.cast_ability(AbilityResource.Slot.E, target):
		return null
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Shade Command")
	var res = CombatCalculator.execute_damage(req)
	
	var cur_pos = global_position if is_inside_tree() else position
	spawn_shade(cur_pos)
	
	shade_command_struck.emit(target, shade_count, total_dmg)
	return res

# --- R: NIGHTFALL (ULTIMATE) ---

func cast_rivena_r() -> bool:
	if not can_cast():
		return false
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast(AbilityResource.Slot.R):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return false
		
	var cur_pos = global_position if is_inside_tree() else position
	spawn_shade(cur_pos + Vector3(2.0, 0, 0))
	spawn_shade(cur_pos + Vector3(-2.0, 0, 0))
	
	is_nightfall_active = true
	nightfall_timer = 6.0
	
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("rivena_nightfall_ms")
		attribute_system.remove_modifiers_by_source("rivena_nightfall_ad")
		attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.35, "rivena_nightfall_ms"))
		attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ATTACK_DAMAGE, StatModifier.Type.FLAT, 30.0, "rivena_nightfall_ad"))
		
	nightfall_activated.emit()
	return true

func _process_nightfall(delta: float) -> void:
	if is_nightfall_active:
		nightfall_timer -= delta
		if nightfall_timer <= 0.0:
			is_nightfall_active = false
			nightfall_timer = 0.0
			if attribute_system != null:
				attribute_system.remove_modifiers_by_source("rivena_nightfall_ms")
				attribute_system.remove_modifiers_by_source("rivena_nightfall_ad")
			nightfall_ended.emit()

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	active_shades.clear()
	shade_timers.clear()
	is_nightfall_active = false
	nightfall_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("rivena_nightfall_ms")
		attribute_system.remove_modifiers_by_source("rivena_nightfall_ad")

func respawn() -> void:
	super.respawn()
	active_shades.clear()
	shade_timers.clear()
	is_nightfall_active = false
	nightfall_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("rivena_nightfall_ms")
		attribute_system.remove_modifiers_by_source("rivena_nightfall_ad")
