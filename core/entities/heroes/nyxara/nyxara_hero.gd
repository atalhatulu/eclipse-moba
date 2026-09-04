class_name NyxaraHero
extends HeroEntity

const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")

## Implementation of Nyxara (The Veil Blade / AGI Assassin)

signal veil_mark_applied(target: BaseCombatEntity, current_stacks: int)
signal needle_struck(target: BaseCombatEntity)
signal fade_step_executed(target: BaseCombatEntity)
signal sever_thread_executed(target: BaseCombatEntity, marks_consumed: int, damage_dealt: float)
signal vanish_entered()
signal vanish_broken()

# Veil Marks State: { target_instance_id: { "stacks": int, "timer": float, "target": BaseCombatEntity } }
var active_marks: Dictionary = {}

# Vanish State
var is_vanished: bool = false
var vanish_timer: float = 0.0

func _ready() -> void:
	entity_name = "Nyxara"
	hero_resource = NyxaraDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_nyxara_definition()

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
	if not has_node("NyxaraVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "NyxaraVisual"
		add_child(root_vis)
		
		# Slender Shadow Silk Body (1.9m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.45
		body_capsule.height = 1.9
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.95
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.12, 0.08, 0.18, 1.0) # Deep Void Violet
		body_mat.metallic = 0.60
		body_mat.roughness = 0.30
		body_mat.emission_enabled = true
		body_mat.emission = Color(0.6, 0.2, 0.9, 1.0)
		body_mat.emission_energy_multiplier = 0.6
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
		# Shadow Daggers Mesh
		for side in [-0.45, 0.45]:
			var dag = MeshInstance3D.new()
			var d_box = BoxMesh.new()
			d_box.size = Vector3(0.08, 0.80, 0.15)
			dag.mesh = d_box
			dag.position = Vector3(side, 0.85, 0.35)
			dag.rotation_degrees = Vector3(30, 0, 0)
			
			var d_mat = StandardMaterial3D.new()
			d_mat.albedo_color = Color(0.70, 0.20, 0.95, 1.0)
			d_mat.emission_enabled = true
			d_mat.emission = Color(0.8, 0.3, 1.0, 1.0)
			d_mat.emission_energy_multiplier = 1.0
			dag.material_override = d_mat
			root_vis.add_child(dag)
			
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

func _apply_nyxara_definition() -> void:
	if hero_resource == null:
		hero_resource = NyxaraDefinition.create_resource()
		
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
	
	_process_veil_marks(delta)
	_process_vanish(delta)

# --- PASSIVE: VEIL MARKS ---

func apply_veil_mark(target: BaseCombatEntity, count: int = 1) -> void:
	if target == null or not is_instance_valid(target) or not target.is_alive() or target.team == team:
		return
		
	var id = target.get_instance_id()
	var cur_stacks = 0
	if active_marks.has(id):
		cur_stacks = active_marks[id]["stacks"]
		
	var new_stacks := 0
	for _i in range(maxi(1, count)):
		new_stacks = CombatMechanicsClass.apply_mark(self, target, "nyxara_veil", "Gölge Damgası", 6.0, 3, "◈")
	active_marks[id] = {
		"stacks": new_stacks,
		"timer": 6.0,
		"target": target
	}
	
	# Apply Armor Reduction Debuff (-5% per stack)
	if target.attribute_system != null:
		target.attribute_system.remove_modifiers_by_source("nyxara_veil_mark_shred")
		var mod = StatModifier.new(
			StatModifier.TargetStat.ARMOR,
			StatModifier.Type.PERCENT_ADD,
			- (new_stacks * 0.05),
			"nyxara_veil_mark_shred"
		)
		target.attribute_system.add_modifier(mod)
		
	veil_mark_applied.emit(target, new_stacks)

func get_veil_marks(target: BaseCombatEntity) -> int:
	if target == null or not is_instance_valid(target):
		return 0
	var id = target.get_instance_id()
	if active_marks.has(id):
		return active_marks[id]["stacks"]
	return 0

func consume_veil_marks(target: BaseCombatEntity) -> int:
	if target == null or not is_instance_valid(target):
		return 0
	var id = target.get_instance_id()
	if not active_marks.has(id):
		return 0
		
	var stacks = active_marks[id]["stacks"]
	active_marks.erase(id)
	CombatMechanicsClass.consume_marks(target, "nyxara_veil")
	if target.attribute_system != null:
		target.attribute_system.remove_modifiers_by_source("nyxara_veil_mark_shred")
	return stacks

func _process_veil_marks(delta: float) -> void:
	if active_marks.is_empty():
		return
		
	var to_erase: Array = []
	for id in active_marks.keys():
		var entry = active_marks[id]
		entry["timer"] -= delta
		var t = entry["target"]
		if entry["timer"] <= 0.0 or t == null or not is_instance_valid(t) or not t.is_alive():
			to_erase.append(id)
			if t != null and is_instance_valid(t) and t.attribute_system != null:
				t.attribute_system.remove_modifiers_by_source("nyxara_veil_mark_shred")
				
	for id in to_erase:
		active_marks.erase(id)

# --- Q: NEEDLE ---

func cast_nyxara_q(target: BaseCombatEntity) -> DamageResult:
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
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Needle")
	var res = CombatCalculator.execute_damage(req)
	
	apply_veil_mark(target, 1)
	needle_struck.emit(target)
	return res

# --- W: FADE STEP ---

func cast_nyxara_w(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return false
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.W, target):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.W, target):
		return false
		
	# Blink behind target
	var t_pos = target.global_position if is_inside_tree() else target.position
	var my_pos = global_position if is_inside_tree() else position
	var dir = (t_pos - my_pos).normalized()
	if dir.length_squared() < 0.1:
		dir = Vector3(0, 0, -1)
		
	var dest = t_pos + (dir * 0.8)
	if is_inside_tree():
		global_position = dest
	else:
		position = dest
		
	apply_veil_mark(target, 1)
	fade_step_executed.emit(target)
	return true

# --- E: SEVER THREAD ---

func cast_nyxara_e(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.E, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var base_dmg = e_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	
	var marks = consume_veil_marks(target)
	var exec_pct = 0.12 + (lvl * 0.03)
	var total_dmg = base_dmg + (ad * e_res.scaling_ratio) + (marks * 40.0)
	
	if not ability_container.cast_ability(AbilityResource.Slot.E, target):
		return null
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Sever Thread")
	var res = CombatCalculator.execute_damage(req)
	var execute_dmg := 0.0
	if target.is_alive():
		var execute_res = CombatMechanicsClass.execute_missing_health_damage(self, target, 0.0, exec_pct, "Sever Thread Execute")
		execute_dmg = execute_res.raw_damage
		CombatMechanicsClass.announce_execution(self, target, -1.0, execute_dmg, "Sever Thread")
	
	sever_thread_executed.emit(target, marks, total_dmg + execute_dmg)
	return res

# --- R: VANISH (ULTIMATE) ---

func cast_nyxara_r() -> bool:
	if not can_cast():
		return false
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast(AbilityResource.Slot.R):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return false
		
	is_vanished = true
	vanish_timer = 4.0
	
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("nyxara_vanish_ms")
		var mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.40, "nyxara_vanish_ms")
		attribute_system.add_modifier(mod)
		
	vanish_entered.emit()
	return true

func _process_vanish(delta: float) -> void:
	if is_vanished:
		vanish_timer -= delta
		if vanish_timer <= 0.0:
			_break_vanish()

func _break_vanish() -> void:
	is_vanished = false
	vanish_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("nyxara_vanish_ms")
	vanish_broken.emit()

func execute_basic_attack(target: BaseCombatEntity) -> DamageResult:
	var was_vanished = is_vanished
	if was_vanished:
		_break_vanish()
		if target != null and is_instance_valid(target) and target.team != team:
			apply_veil_mark(target, 3)
			
	var res = super.execute_basic_attack(target)
	return res

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	_break_vanish()
	active_marks.clear()

func respawn() -> void:
	super.respawn()
	_break_vanish()
	active_marks.clear()
