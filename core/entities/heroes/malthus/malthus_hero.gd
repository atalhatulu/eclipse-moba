class_name MalthusHero
extends HeroEntity

const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")

## Implementation of Malthus (The Soul Reaper / AGI Carry)
## Reaps souls from fallen foes: Soul Reap, Ghost Walk, Decay aura, and The Inevitable.

signal soul_reaped(enemies_hit: int, souls_gained: int)
signal ghost_walk_activated(duration: float)
signal decay_toggled(active: bool)
signal inevitable_struck(target: BaseCombatEntity, total_damage: float)

var malthus_visual_root: Node3D = null
var scythe_blade: MeshInstance3D = null

# Passive: Harvested Souls
var soul_count: int = 0

# W: Ghost Walk State
var is_ghost_walking: bool = false
var ghost_walk_timer: float = 0.0

# E: Decay State
var is_decay_active: bool = false
var decay_timer: float = 0.0
var decay_pulse_timer: float = 0.0

func _ready() -> void:
	entity_name = "Malthus"
	hero_resource = MalthusDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_malthus_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.50
		shape.height = 2.0
		col.shape = shape
		col.position.y = 1.0
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("MalthusVisual"):
		malthus_visual_root = Node3D.new()
		malthus_visual_root.name = "MalthusVisual"
		add_child(malthus_visual_root)
		
		# Withered Hooded Reaper Body
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.44
		body_capsule.height = 1.95
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.98
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.12, 0.16, 0.14, 1.0) # Obsidian Shroud
		mat.metallic = 0.3
		mat.roughness = 0.7
		mat.emission_enabled = true
		mat.emission = Color(0.1, 0.35, 0.2)
		mat.emission_energy_multiplier = 0.6
		body_inst.material_override = mat
		malthus_visual_root.add_child(body_inst)
		
		# Heavy Soul Scythe
		scythe_blade = MeshInstance3D.new()
		var s_mesh = CylinderMesh.new()
		s_mesh.top_radius = 0.04
		s_mesh.bottom_radius = 0.08
		s_mesh.height = 2.2
		scythe_blade.mesh = s_mesh
		scythe_blade.position = Vector3(0.55, 1.1, 0.2)
		scythe_blade.rotation_degrees = Vector3(15, 0, -25)
		
		var scythe_mat = StandardMaterial3D.new()
		scythe_mat.albedo_color = Color(0.3, 0.8, 0.5, 1.0) # Spectral Emerald
		scythe_mat.emission_enabled = true
		scythe_mat.emission = Color(0.2, 0.8, 0.4)
		scythe_mat.emission_energy_multiplier = 1.8
		scythe_blade.material_override = scythe_mat
		malthus_visual_root.add_child(scythe_blade)
	else:
		malthus_visual_root = get_node_or_null("MalthusVisual")

func _apply_malthus_definition() -> void:
	if hero_resource == null:
		hero_resource = MalthusDefinition.create_resource()
		
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
	
	attribute_system.current_health = def.base_health
	attribute_system.current_mana = def.base_mana
	attribute_system.recalculate_all_stats()
	
	ability_container.set_ability(AbilityResource.Slot.Q, def.q_ability)
	ability_container.set_ability(AbilityResource.Slot.W, def.w_ability)
	ability_container.set_ability(AbilityResource.Slot.E, def.e_ability)
	ability_container.set_ability(AbilityResource.Slot.R, def.r_ability)

func _process(delta: float) -> void:
	super._process(delta)
	_process_ghost_walk(delta)
	_process_decay(delta)

func _process_ghost_walk(delta: float) -> void:
	if not is_ghost_walking:
		return
	ghost_walk_timer -= delta
	if ghost_walk_timer <= 0.0:
		is_ghost_walking = false
		attribute_system.remove_modifiers_by_source("malthus_ghost_walk")

func _process_decay(delta: float) -> void:
	if not is_decay_active:
		return
	decay_timer -= delta
	decay_pulse_timer -= delta
	
	if decay_pulse_timer <= 0.0:
		decay_pulse_timer = 0.5
		_pulse_decay_damage()
		
	if decay_timer <= 0.0:
		is_decay_active = false
		decay_toggled.emit(false)

func _pulse_decay_damage() -> void:
	if not is_inside_tree():
		return
	var cur_pos = global_position
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var pulse_dmg = (e_res.get_base_damage(lvl) if e_res != null else 70.0) * 0.25
	
	for entity in get_tree().get_nodes_in_group("combat_entities"):
		if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
			if cur_pos.distance_to(entity.global_position) <= 4.5:
				var req = DamageRequest.create_ability_damage(self, entity, pulse_dmg, DamageRequest.DamageType.PHYSICAL, "Decay Pulse")
				var res = CombatCalculator.execute_damage(req)
				if res != null and res.final_health_damage > 0.0:
					attribute_system.heal(res.final_health_damage * 0.30)

# --- Q: SOUL REAP (GROUND AOE / CONIC SCYTHE CLEAVE) ---
func cast_malthus_q(target_point: Vector3) -> bool:
	if not can_cast():
		return false
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, null, target_point):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * q_res.scaling_ratio)
	
	var cur_pos = global_position if is_inside_tree() else position
	var dir = (target_point - cur_pos).normalized()
	dir.y = 0.0
	if dir.length_squared() < 0.001:
		dir = -transform.basis.z.normalized()
		
	if not ability_container.cast_ability(AbilityResource.Slot.Q, null, target_point):
		return false
		
	var hit_count := 0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				var diff = entity.global_position - cur_pos
				if diff.length() <= 4.8 and dir.dot(diff.normalized()) > 0.1:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.PHYSICAL, "Soul Reap")
					CombatCalculator.execute_damage(req)
					hit_count += 1
					
	soul_count += hit_count
	soul_reaped.emit(hit_count, hit_count)
	return true

# --- W: GHOST WALK (SELF PHASE STATE) ---
func cast_malthus_w() -> bool:
	if not can_cast():
		return false
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	is_ghost_walking = true
	ghost_walk_timer = 3.5
	
	var ms_mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.35, "malthus_ghost_walk")
	attribute_system.add_modifier(ms_mod)
	if effect_container != null:
		effect_container.clear_all_debuffs()
		
	ghost_walk_activated.emit(3.5)
	return true

# --- E: DECAY (SELF ROT AURA) ---
func cast_malthus_e() -> bool:
	if not can_cast():
		return false
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return false
		
	is_decay_active = true
	decay_timer = 5.0
	decay_pulse_timer = 0.1
	decay_toggled.emit(true)
	return true

# --- R: THE INEVITABLE (SINGLE TARGET EXECUTION STRIKE) ---
func cast_malthus_r(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or target.team == team:
		return false
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.R, target):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * r_res.scaling_ratio)
	
	# Scale by missing health
	var missing_ratio = 0.0
	if target.attribute_system != null:
		var max_hp = target.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
		if max_hp > 0.0:
			missing_ratio = 1.0 - clampf(target.attribute_system.current_health / max_hp, 0.0, 1.0)
	var mult = 1.0 + (missing_ratio * 0.50)
	total_dmg *= mult
	
	if not ability_container.cast_ability(AbilityResource.Slot.R, target):
		return false
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "The Inevitable")
	CombatCalculator.execute_damage(req)
	
	inevitable_struck.emit(target, total_dmg)
	return true
