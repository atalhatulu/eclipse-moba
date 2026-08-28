class_name NymeraHero
extends HeroEntity

## Implementation of Nymera (The Chrono Weaver / INT-AGI Temporal Controller)

signal temporal_rewound(target: BaseCombatEntity, from_pos: Vector3, to_pos: Vector3)
signal temporal_accelerated(target: BaseCombatEntity)
signal temporal_collapse_executed(center_pos: Vector3, targets_affected: int)

# Snapshot tracking: target_entity -> Array of {timestamp: float, pos: Vector3, hp: float}
var position_history: Dictionary = {}
var history_timer: float = 0.0
const SNAPSHOT_INTERVAL: float = 0.25
const MAX_HISTORY_TIME: float = 4.0

# Active Slow Fields: [{pos: Vector3, radius: float, timer: float, dps: float}]
var active_slow_fields: Array[Dictionary] = []

func _ready() -> void:
	entity_name = "Nymera"
	hero_resource = NymeraDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_nymera_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.48
		shape.height = 1.85
		col.shape = shape
		col.position.y = 0.92
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("NymeraVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "NymeraVisual"
		add_child(root_vis)
		
		# Chrono Weaver Astral Robes (1.85m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.44
		body_capsule.height = 1.85
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.92
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.3, 0.75, 0.85, 1.0) # Chrono Cyan
		mat.metallic = 0.3
		mat.roughness = 0.25
		body_inst.material_override = mat
		root_vis.add_child(body_inst)
		
		# Hourglass Floating Halo Ring
		var halo = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.55
		torus.outer_radius = 0.60
		halo.mesh = torus
		halo.position.y = 1.80
		halo.rotation.x = deg_to_rad(45.0)
		var halo_mat = StandardMaterial3D.new()
		halo_mat.albedo_color = Color(0.85, 0.9, 0.3, 0.8) # Golden Temporal
		halo_mat.emission_enabled = true
		halo_mat.emission = Color(0.85, 0.9, 0.3)
		halo.material_override = halo_mat
		root_vis.add_child(halo)

func _apply_nymera_definition() -> void:
	if hero_resource == null:
		hero_resource = NymeraDefinition.create_resource()
		
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

func _process(delta: float) -> void:
	super._process(delta)
	_record_timeline_snapshots(delta)
	_process_slow_fields(delta)

# --- PASSIVE: TIMELINE SNAPSHOT ENGINE ---

func record_entity_snapshot(entity: BaseCombatEntity, pos: Vector3) -> void:
	if not position_history.has(entity):
		position_history[entity] = []
	var history: Array = position_history[entity]
	var current_time = Time.get_ticks_msec() / 1000.0
	history.append({"time": current_time, "pos": pos})
	
	# Purge records older than 4.0s
	while not history.is_empty() and (current_time - history[0]["time"]) > MAX_HISTORY_TIME:
		history.remove_at(0)

func get_rewind_position(entity: BaseCombatEntity, seconds_ago: float = 3.0) -> Vector3:
	var cur_pos = entity.global_position if entity.is_inside_tree() else entity.position
	if not position_history.has(entity) or position_history[entity].is_empty():
		return cur_pos
		
	var history: Array = position_history[entity]
	var current_time = Time.get_ticks_msec() / 1000.0
	var target_time = current_time - seconds_ago
	
	var best_pos = history[0]["pos"]
	var min_diff = 999.0
	for entry in history:
		var diff = absf(entry["time"] - target_time)
		if diff < min_diff:
			min_diff = diff
			best_pos = entry["pos"]
			
	return best_pos

func _record_timeline_snapshots(delta: float) -> void:
	history_timer += delta
	if history_timer >= SNAPSHOT_INTERVAL:
		history_timer = 0.0
		# Record self
		var my_pos = global_position if is_inside_tree() else position
		record_entity_snapshot(self, my_pos)
		
		# Record active heroes
		for h in HeroEntity.active_heroes:
			if is_instance_valid(h) and h.is_alive():
				var h_pos = h.global_position if h.is_inside_tree() else h.position
				record_entity_snapshot(h, h_pos)

# --- Q: SLOW FIELD (TEMPORAL DISTORTION) ---

func cast_nymera_q(center_pos: Vector3, targets: Array = []) -> bool:
	if not can_cast():
		return false
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast(AbilityResource.Slot.Q):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.Q):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var dps = base_dmg + (ap * q_res.scaling_ratio)
	
	active_slow_fields.append({
		"pos": center_pos,
		"radius": 5.0,
		"timer": 3.5,
		"dps": dps
	})
	
	# Apply initial slow & damage to targets in range
	var enemies = targets if not targets.is_empty() else HeroEntity.active_heroes
	for e in enemies:
		if e is BaseCombatEntity and is_instance_valid(e) and e.is_alive() and e.team != team:
			var e_pos = e.global_position if e.is_inside_tree() else e.position
			if center_pos.distance_to(e_pos) <= 5.0:
				if e.effect_container != null:
					var slow_eff = StatusEffect.new("nymera_time_slow", StatusEffect.EffectType.SLOW, 3.5, 0.35)
					e.effect_container.apply_effect(slow_eff)
				var req = DamageRequest.create_ability_damage(self, e, dps, DamageRequest.DamageType.MAGICAL, "Slow Field")
				CombatCalculator.execute_damage(req)
				
	return true

func _process_slow_fields(delta: float) -> void:
	for i in range(active_slow_fields.size() - 1, -1, -1):
		active_slow_fields[i]["timer"] -= delta
		if active_slow_fields[i]["timer"] <= 0.0:
			active_slow_fields.remove_at(i)

# --- W: REWIND (TEMPORAL REVERSAL) ---

func cast_nymera_w(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or target.team == team:
		return null
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return null
		
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return null
		
	var from_pos = target.global_position if target.is_inside_tree() else target.position
	var rewind_pos = get_rewind_position(target, 3.0)
	
	# Teleport back to rewind position
	if target.is_inside_tree():
		target.global_position = rewind_pos
	else:
		target.position = rewind_pos
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var base_dmg = w_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var total_dmg = base_dmg + (ap * w_res.scaling_ratio)
	
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.MAGICAL, "Rewind")
	var res = CombatCalculator.execute_damage(req)
	
	temporal_rewound.emit(target, from_pos, rewind_pos)
	return res

# --- E: ACCELERATE (TIME HASTE) ---

func cast_nymera_e(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or target.team != team:
		return false
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return false
		
	if target.attribute_system != null:
		target.attribute_system.remove_modifiers_by_source("nymera_accelerate_buff")
		var ms_mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.30, "nymera_accelerate_buff", 4.0)
		var as_mod = StatModifier.new(StatModifier.TargetStat.ATTACK_SPEED, StatModifier.Type.PERCENT_ADD, 0.25, "nymera_accelerate_buff", 4.0)
		target.attribute_system.add_modifier(ms_mod)
		target.attribute_system.add_modifier(as_mod)
		
	temporal_accelerated.emit(target)
	return true

# --- R: TEMPORAL COLLAPSE (ULTIMATE) ---

func cast_nymera_r(center_pos: Vector3, targets: Array = []) -> Array[DamageResult]:
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
	
	var enemies = targets if not targets.is_empty() else HeroEntity.active_heroes
	var results: Array[DamageResult] = []
	var hit_count = 0
	
	for e in enemies:
		if e is BaseCombatEntity and is_instance_valid(e) and e.is_alive() and e.team != team and e.is_targetable:
			var e_pos = e.global_position if e.is_inside_tree() else e.position
			if center_pos.distance_to(e_pos) <= 6.0:
				var rewind_pos = get_rewind_position(e, 3.0)
				if e.is_inside_tree():
					e.global_position = rewind_pos
				else:
					e.position = rewind_pos
					
				# Apply Root CC for 1.2s
				if e.effect_container != null:
					var root_eff = StatusEffect.new("nymera_collapse_root", StatusEffect.EffectType.ROOT, 1.2)
					e.effect_container.apply_effect(root_eff)
					
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.MAGICAL, "Temporal Collapse")
				var res = CombatCalculator.execute_damage(req)
				results.append(res)
				hit_count += 1
				
	temporal_collapse_executed.emit(center_pos, hit_count)
	return results

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	position_history.clear()
	active_slow_fields.clear()

func respawn() -> void:
	super.respawn()
	position_history.clear()
	active_slow_fields.clear()
