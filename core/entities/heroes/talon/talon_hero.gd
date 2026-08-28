class_name TalonHero
extends HeroEntity

## Implementation of Talon (The Relentless Stalker / AGI Diver)

signal predator_stacks_updated(target: BaseCombatEntity, stacks: int)
signal hookblade_struck(target: BaseCombatEntity, damage_dealt: float)
signal pursuit_executed(target: BaseCombatEntity)
signal tear_away_executed(target: BaseCombatEntity, damage_dealt: float)
signal tether_broken(reason: String)
signal no_escape_activated()
signal no_escape_ended()

# Passive Predator State
var predator_target: BaseCombatEntity = null
var predator_stacks: int = 0
const MAX_PREDATOR_STACKS: int = 5

# Q: Tether State
var tethered_target: BaseCombatEntity = null
var tether_timer: float = 0.0
const BASE_TETHER_MAX_RANGE: float = 8.0

# R: No Escape State
var is_no_escape_active: bool = false
var no_escape_timer: float = 0.0

func _ready() -> void:
	entity_name = "Talon"
	hero_resource = TalonDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_talon_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.54
		shape.height = 1.96
		col.shape = shape
		col.position.y = 0.98
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("TalonVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "TalonVisual"
		add_child(root_vis)
		
		# Armored Predator Stalker Body (1.96m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.50
		body_capsule.height = 1.96
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.98
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.22, 0.25, 0.28, 1.0) # Shadow Iron & Blood Crimson
		body_mat.metallic = 0.80
		body_mat.roughness = 0.25
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
		# Heavy Hookblade Weapon Mesh
		var blade = MeshInstance3D.new()
		var b_box = BoxMesh.new()
		b_box.size = Vector3(0.15, 1.20, 0.35)
		blade.mesh = b_box
		blade.position = Vector3(0.55, 0.95, 0.45)
		blade.rotation_degrees = Vector3(35, 10, 0)
		
		var b_mat = StandardMaterial3D.new()
		b_mat.albedo_color = Color(0.85, 0.15, 0.15, 1.0)
		b_mat.metallic = 0.90
		blade.material_override = b_mat
		root_vis.add_child(blade)
		
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

func _apply_talon_definition() -> void:
	if hero_resource == null:
		hero_resource = TalonDefinition.create_resource()
		
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
	
	_process_tether(delta)
	_process_no_escape(delta)

# --- PASSIVE: PREDATOR'S PACE ---

func add_predator_stack(target: BaseCombatEntity) -> void:
	if target == null or not is_instance_valid(target) or not target.is_alive() or target.team == team:
		return
		
	if predator_target != target:
		predator_target = target
		predator_stacks = 0
		
	predator_stacks = mini(MAX_PREDATOR_STACKS, predator_stacks + 1)
	_sync_predator_buffs()

func _sync_predator_buffs() -> void:
	if attribute_system == null:
		return
		
	var bonus_ad = predator_stacks * 3.0
	var bonus_ms = predator_stacks * 0.04
	
	attribute_system.remove_modifiers_by_source("talon_predator_ad")
	attribute_system.remove_modifiers_by_source("talon_predator_ms")
	
	if bonus_ad > 0.0:
		attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ATTACK_DAMAGE, StatModifier.Type.FLAT, bonus_ad, "talon_predator_ad"))
	if bonus_ms > 0.0:
		attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, bonus_ms, "talon_predator_ms"))
		
	predator_stacks_updated.emit(predator_target, predator_stacks)

# --- Q: HOOKBLADE ---

func cast_talon_q(target: BaseCombatEntity) -> DamageResult:
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
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Hookblade")
	var res = CombatCalculator.execute_damage(req)
	
	# Attach Tether & add Predator stack
	tethered_target = target
	tether_timer = 5.0
	add_predator_stack(target)
	
	hookblade_struck.emit(target, total_dmg)
	return res

func _process_tether(delta: float) -> void:
	if tethered_target == null:
		return
		
	if not is_instance_valid(tethered_target) or not tethered_target.is_alive():
		tethered_target = null
		tether_timer = 0.0
		tether_broken.emit("target_dead")
		return
		
	tether_timer -= delta
	if tether_timer <= 0.0:
		tethered_target = null
		tether_timer = 0.0
		tether_broken.emit("duration_expired")
		return
		
	var my_pos = global_position if is_inside_tree() else position
	var t_pos = tethered_target.global_position if is_inside_tree() else tethered_target.position
	var dist = my_pos.distance_to(t_pos)
	var max_range = BASE_TETHER_MAX_RANGE * (2.0 if is_no_escape_active else 1.0)
	
	if dist > max_range:
		tethered_target = null
		tether_timer = 0.0
		tether_broken.emit("range_exceeded")

# --- W: PURSUIT ---

func cast_talon_w() -> bool:
	if not can_cast() or tethered_target == null or not is_instance_valid(tethered_target) or not tethered_target.is_alive():
		return false
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	# Dash to tethered target position
	var t_pos = tethered_target.global_position if is_inside_tree() else tethered_target.position
	if is_inside_tree():
		global_position = t_pos + Vector3(0.5, 0, 0.5)
	else:
		position = t_pos + Vector3(0.5, 0, 0.5)
		
	# Apply 35% slow to target
	if tethered_target.attribute_system != null:
		var slow_mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, -0.35, "talon_pursuit_slow")
		tethered_target.attribute_system.add_modifier(slow_mod)
		
	add_predator_stack(tethered_target)
	pursuit_executed.emit(tethered_target)
	return true

# --- E: TEAR AWAY ---

func cast_talon_e() -> DamageResult:
	if not can_cast() or tethered_target == null or not is_instance_valid(tethered_target) or not tethered_target.is_alive():
		return null
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var base_dmg = e_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var raw_dmg = base_dmg + (ad * e_res.scaling_ratio)
	
	# Avcı yükü başına +%20 ek hasar
	var multiplier = 1.0 + (predator_stacks * 0.20)
	var total_dmg = raw_dmg * multiplier
	
	var target = tethered_target
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return null
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Tear Away")
	var res = CombatCalculator.execute_damage(req)
	
	# Break tether upon tearing
	tethered_target = null
	tether_timer = 0.0
	
	tear_away_executed.emit(target, total_dmg)
	return res

# --- R: NO ESCAPE (ULTIMATE) ---

func cast_talon_r() -> bool:
	if not can_cast():
		return false
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast(AbilityResource.Slot.R):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return false
		
	is_no_escape_active = true
	no_escape_timer = 6.0
	
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("talon_no_escape_ms")
		attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.30, "talon_no_escape_ms"))
		
	no_escape_activated.emit()
	return true

func _process_no_escape(delta: float) -> void:
	if is_no_escape_active:
		no_escape_timer -= delta
		if no_escape_timer <= 0.0:
			is_no_escape_active = false
			no_escape_timer = 0.0
			if attribute_system != null:
				attribute_system.remove_modifiers_by_source("talon_no_escape_ms")
			no_escape_ended.emit()

# --- BASIC ATTACK OVERRIDE ---

func execute_basic_attack(target: BaseCombatEntity) -> DamageResult:
	var res = super.execute_basic_attack(target)
	if res != null and target != null:
		add_predator_stack(target)
	return res

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	predator_target = null
	predator_stacks = 0
	tethered_target = null
	tether_timer = 0.0
	is_no_escape_active = false
	no_escape_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("talon_predator_ad")
		attribute_system.remove_modifiers_by_source("talon_predator_ms")
		attribute_system.remove_modifiers_by_source("talon_no_escape_ms")

func respawn() -> void:
	super.respawn()
	predator_target = null
	predator_stacks = 0
	tethered_target = null
	tether_timer = 0.0
	is_no_escape_active = false
	no_escape_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("talon_predator_ad")
		attribute_system.remove_modifiers_by_source("talon_predator_ms")
		attribute_system.remove_modifiers_by_source("talon_no_escape_ms")
