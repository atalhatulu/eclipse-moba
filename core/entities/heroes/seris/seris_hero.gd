class_name SerisHero
extends HeroEntity

## Implementation of Seris (AGI Trapper / Razor Traps & Precision Shot)

signal needle_shot_fired(target: BaseCombatEntity, damage: float, was_precision: bool)
signal razor_trap_placed(position: Vector3, total_traps: int)
signal razor_trap_triggered(position: Vector3, victim: BaseCombatEntity)
signal trigger_wire_activated(traps_detonated: int)
signal hunting_ground_cast(target_pos: Vector3, traps_created: int)

# State data
var active_traps: Array[Vector3] = []
var trap_timers: Array[float] = []
const MAX_ACTIVE_TRAPS: int = 4
const TRAP_DURATION: float = 60.0
const TRAP_TRIGGER_RADIUS: float = 2.5

# Precision tracking
var trapped_targets: Dictionary = {} # target: duration
var trigger_wire_ms_timer: float = 0.0

func _ready() -> void:
	entity_name = "Seris"
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_seris_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.50
		shape.height = 1.9
		col.shape = shape
		col.position.y = 0.95
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("SerisVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "SerisVisual"
		add_child(root_vis)
		
		# Slender Ranger Body
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.45
		body_capsule.height = 1.9
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.95
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.12, 0.25, 0.22, 1.0) # Forest Camo Green
		body_mat.metallic = 0.4
		body_mat.roughness = 0.4
		body_mat.emission_enabled = true
		body_mat.emission = Color(0.15, 0.75, 0.55, 1.0)
		body_mat.emission_energy_multiplier = 0.8
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
		# Quiver / Trap Harness on back
		var quiver = MeshInstance3D.new()
		var q_box = BoxMesh.new()
		q_box.size = Vector3(0.25, 0.70, 0.20)
		quiver.mesh = q_box
		quiver.position = Vector3(0.0, 1.25, -0.30)
		
		var q_mat = StandardMaterial3D.new()
		q_mat.albedo_color = Color(0.35, 0.20, 0.10, 1.0)
		quiver.material_override = q_mat
		root_vis.add_child(quiver)
		
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

func _apply_seris_definition() -> void:
	if hero_resource == null:
		hero_resource = SerisDefinition.create_resource()
		
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
	_process_traps(delta)
	_process_trapped_targets(delta)
	_process_trigger_wire_ms(delta)

# --- PASSIVE & TRAP LIFECYCLE ---

func is_target_trapped(target: BaseCombatEntity) -> bool:
	if target == null or not is_instance_valid(target):
		return false
	return trapped_targets.has(target)

func _process_traps(delta: float) -> void:
	for i in range(trap_timers.size() - 1, -1, -1):
		trap_timers[i] -= delta
		if trap_timers[i] <= 0.0:
			active_traps.remove_at(i)
			trap_timers.remove_at(i)

func _process_trapped_targets(delta: float) -> void:
	var keys = trapped_targets.keys()
	for k in keys:
		if not is_instance_valid(k) or not k.is_alive():
			trapped_targets.erase(k)
			continue
		trapped_targets[k] -= delta
		if trapped_targets[k] <= 0.0:
			trapped_targets.erase(k)

func _process_trigger_wire_ms(delta: float) -> void:
	if trigger_wire_ms_timer > 0.0:
		trigger_wire_ms_timer -= delta
		if trigger_wire_ms_timer <= 0.0:
			if attribute_system != null:
				attribute_system.remove_modifiers_by_source("seris_trigger_wire_ms")

# --- Q: NEEDLE SHOT ---

func cast_seris_q(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var is_trapped = is_target_trapped(target)
	var precision_multiplier = 1.30 if is_trapped else 1.0
	var total_dmg = (base_dmg + (ad * q_res.scaling_ratio)) * precision_multiplier
	
	if not ability_container.cast_ability(AbilityResource.Slot.Q, target):
		return null
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Needle Shot")
	if is_trapped:
		req.armor_pen_percent = 0.25 # 25% Armor Pen on trapped targets
	var res = CombatCalculator.execute_damage(req)
	
	needle_shot_fired.emit(target, total_dmg, is_trapped)
	return res

# --- W: RAZOR TRAP ---

func cast_seris_w(target_position: Vector3) -> bool:
	if not can_cast():
		return false
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	place_trap(target_position)
	return true

func place_trap(trap_pos: Vector3) -> void:
	if active_traps.size() >= MAX_ACTIVE_TRAPS:
		active_traps.pop_front()
		trap_timers.pop_front()
		
	active_traps.append(trap_pos)
	trap_timers.append(TRAP_DURATION)
	razor_trap_placed.emit(trap_pos, active_traps.size())

func trigger_trap_at(index: int, victim: BaseCombatEntity) -> DamageResult:
	if index < 0 or index >= active_traps.size():
		return null
		
	var trap_pos = active_traps[index]
	active_traps.remove_at(index)
	trap_timers.remove_at(index)
	
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var base_dmg = w_res.get_base_damage(lvl) if w_res != null else 70.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * 0.60)
	
	var res: DamageResult = null
	if victim != null and is_instance_valid(victim) and victim.is_alive():
		var req = DamageRequest.create_ability_damage(self, victim, total_dmg, DamageRequest.DamageType.PHYSICAL, "Razor Trap")
		res = CombatCalculator.execute_damage(req)
		
		# Apply Slow & Trapped Mark
		trapped_targets[victim] = 4.0
		if victim.effect_container != null:
			var slow_eff = StatusEffect.new("seris_trap_slow", StatusEffect.EffectType.SLOW, 2.5, 0.40)
			victim.effect_container.apply_effect(slow_eff)
			
	razor_trap_triggered.emit(trap_pos, victim)
	return res

# --- E: TRIGGER WIRE ---

func cast_seris_e() -> int:
	if not can_cast():
		return 0
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return 0
		
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return 0
		
	var count = active_traps.size()
	active_traps.clear()
	trap_timers.clear()
	
	# Apply MS Buff
	trigger_wire_ms_timer = 3.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("seris_trigger_wire_ms")
		var mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.30, "seris_trigger_wire_ms")
		attribute_system.add_modifier(mod)
		
	trigger_wire_activated.emit(count)
	return count

# --- R: HUNTING GROUND (ULTIMATE) ---

func cast_seris_r(center_pos: Vector3, enemies_in_area: Array[BaseCombatEntity] = []) -> bool:
	if not can_cast():
		return false
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast(AbilityResource.Slot.R):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return false
		
	# Spawn 3 traps around center
	place_trap(center_pos)
	place_trap(center_pos + Vector3(2.5, 0, 0))
	place_trap(center_pos + Vector3(-2.5, 0, 0))
	
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * r_res.scaling_ratio)
	
	for enemy in enemies_in_area:
		if enemy != null and is_instance_valid(enemy) and enemy.is_alive() and enemy.team != team:
			var req = DamageRequest.create_ability_damage(self, enemy, total_dmg, DamageRequest.DamageType.PHYSICAL, "Hunting Ground")
			CombatCalculator.execute_damage(req)
			trapped_targets[enemy] = 5.0
			if enemy.status_effect_manager != null:
				enemy.status_effect_manager.apply_slow(0.60, 2.0)
				
	hunting_ground_cast.emit(center_pos, 3)
	return true

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	active_traps.clear()
	trap_timers.clear()
	trapped_targets.clear()
	trigger_wire_ms_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("seris_trigger_wire_ms")

func respawn() -> void:
	super.respawn()
	active_traps.clear()
	trap_timers.clear()
	trapped_targets.clear()
	trigger_wire_ms_timer = 0.0
