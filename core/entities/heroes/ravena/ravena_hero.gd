class_name RavenaHero
extends HeroEntity

## Implementation of Ravena (The Iron Anchor / STR Tank & Initiator)

signal anchored_stacks_changed(current_stacks: int, bonus_armor: float)
signal chain_lance_hit(target: BaseCombatEntity)
signal lockdown_applied(target: BaseCombatEntity)

# Passive: Anchored state
var anchor_timer: float = 0.0
var anchor_position: Vector3 = Vector3.ZERO
var current_anchor_armor: float = 0.0
const MAX_ANCHOR_ARMOR: float = 25.0
const ARMOR_PER_SECOND: float = 5.0

func _ready() -> void:
	entity_name = "Ravena"
	hero_resource = RavenaDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_ravena_definition()

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
	if not has_node("RavenaVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "RavenaVisual"
		add_child(root_vis)
		
		# Heavy Iron Armored Body (2.1m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.58
		body_capsule.height = 2.1
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.05
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.20, 0.25, 0.32, 1.0) # Deep Navy Iron
		body_mat.metallic = 0.90
		body_mat.roughness = 0.40
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
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

func _apply_ravena_definition() -> void:
	if hero_resource == null:
		hero_resource = RavenaDefinition.create_resource()
		
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
	_process_anchored_passive(delta)

# --- PASSIVE: ANCHORED ---

func _process_anchored_passive(delta: float) -> void:
	if not is_alive():
		_set_anchor_armor(0.0)
		return
		
	var cur_pos = global_position if (is_inside_tree() or global_position != Vector3.ZERO) else position
	if anchor_position == Vector3.ZERO:
		anchor_position = cur_pos
		
	# If hero moved or is currently walking
	if velocity.length_squared() > 0.04 or cur_pos.distance_to(anchor_position) > 0.50:
		anchor_position = cur_pos
		anchor_timer = 0.0
		_set_anchor_armor(0.0)
	else:
		anchor_timer += delta
		var stacks = int(minf(MAX_ANCHOR_ARMOR / ARMOR_PER_SECOND, floorf(anchor_timer)))
		var target_armor = float(stacks) * ARMOR_PER_SECOND
		_set_anchor_armor(target_armor)

func _set_anchor_armor(val: float) -> void:
	if absf(current_anchor_armor - val) > 0.01:
		current_anchor_armor = val
		if attribute_system != null:
			attribute_system.remove_modifiers_by_source("ravena_anchored_armor")
			if current_anchor_armor > 0.0:
				var mod = StatModifier.new(
					StatModifier.TargetStat.ARMOR,
					StatModifier.Type.FLAT,
					current_anchor_armor,
					"ravena_anchored_armor"
				)
				attribute_system.add_modifier(mod)
		anchored_stacks_changed.emit(int(current_anchor_armor / ARMOR_PER_SECOND), current_anchor_armor)

# --- ABILITY IMPLEMENTATIONS ---

func cast_ravena_q(target: BaseCombatEntity) -> DamageResult:
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
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Chain Lance")
	var res = CombatCalculator.execute_damage(req)
	
	# Pull target toward Ravena
	var my_pos = global_position if (is_inside_tree() or global_position != Vector3.ZERO) else position
	var t_pos = target.global_position if (target.is_inside_tree() or target.global_position != Vector3.ZERO) else target.position
	var pull_dir = (my_pos - t_pos).normalized()
	pull_dir.y = 0.0
	var dist = t_pos.distance_to(my_pos)
	var pull_dist = minf(3.5, dist * 0.50)
	var dest = t_pos + (pull_dir * pull_dist)
	if target.is_inside_tree():
		target.global_position = dest
	else:
		target.position = dest
		
	chain_lance_hit.emit(target)
	return res

func cast_ravena_w(center_point: Vector3 = Vector3.ZERO, specific_targets: Array = []) -> Array[DamageResult]:
	if not can_cast():
		return []
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return []
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var base_dmg = w_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * w_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.W, null, center_point):
		return []
		
	var my_pos = global_position if (is_inside_tree() or global_position != Vector3.ZERO) else position
	var center = center_point if center_point != Vector3.ZERO else my_pos
	
	var targets_to_hit = specific_targets.duplicate()
	if targets_to_hit.is_empty():
		var all_nodes: Array = []
		if is_inside_tree() and get_tree() != null:
			all_nodes = get_tree().get_nodes_in_group("combat_entities")
		else:
			all_nodes.append_array(HeroEntity.active_heroes)
			all_nodes.append_array(CreepEntity.active_creeps)
			
		for n in all_nodes:
			if n is BaseCombatEntity and is_instance_valid(n) and n != self and n.is_alive() and n.team != team and n.is_targetable:
				var n_pos = n.global_position if (n.is_inside_tree() or n.global_position != Vector3.ZERO) else n.position
				if center.distance_to(n_pos) <= 4.5 or center.distance_to(n_pos) <= 450.0:
					targets_to_hit.append(n)
					
	var results: Array[DamageResult] = []
	for t in targets_to_hit:
		if t != null and is_instance_valid(t) and t.is_alive() and t.team != team:
			var req = DamageRequest.create_ability_damage(self, t, total_dmg, DamageRequest.DamageType.PHYSICAL, "Anchor Field")
			var res = CombatCalculator.execute_damage(req)
			results.append(res)
			
			if t.effect_container != null:
				var slow_eff = StatusEffect.new("ravena_anchor_slow", StatusEffect.EffectType.SLOW, w_res.effect_duration, w_res.effect_intensity)
				t.effect_container.apply_effect(slow_eff)
				
	return results

func cast_ravena_e(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target == self:
		return false
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.E, target):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.E, target):
		return false
		
	var my_pos = global_position if (is_inside_tree() or global_position != Vector3.ZERO) else position
	var t_pos = target.global_position if (target.is_inside_tree() or target.global_position != Vector3.ZERO) else target.position
	
	if target.team != team:
		# Enemy target: Deal damage and pull enemy towards Ravena
		var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
		var base_dmg = e_res.get_base_damage(lvl)
		var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
		var total_dmg = base_dmg + (ad * e_res.scaling_ratio)
		var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Reposition")
		CombatCalculator.execute_damage(req)
		
		var pull_dir = (my_pos - t_pos).normalized()
		pull_dir.y = 0.0
		var pull_dist = minf(4.0, t_pos.distance_to(my_pos) * 0.60)
		var dest = t_pos + (pull_dir * pull_dist)
		if target.is_inside_tree():
			target.global_position = dest
		else:
			target.position = dest
	else:
		# Ally target: Pull/Dash Ravena towards ally
		var move_dir = (t_pos - my_pos).normalized()
		move_dir.y = 0.0
		var move_dist = minf(5.0, my_pos.distance_to(t_pos) * 0.80)
		var dest = my_pos + (move_dir * move_dist)
		if is_inside_tree():
			global_position = dest
		else:
			position = dest
			
	return true

func cast_ravena_r(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.R, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * r_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.R, target):
		return null
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Lockdown")
	var res = CombatCalculator.execute_damage(req)
	
	if target.effect_container != null:
		var stun_eff = StatusEffect.new("ravena_lockdown_stun", StatusEffect.EffectType.STUN, r_res.effect_duration, 0.0, true)
		target.effect_container.apply_effect(stun_eff)
		
	lockdown_applied.emit(target)
	return res

# --- DEATH & RESPAWN OVERRIDES ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	anchor_timer = 0.0
	_set_anchor_armor(0.0)

func respawn() -> void:
	super.respawn()
	anchor_timer = 0.0
	_set_anchor_armor(0.0)
