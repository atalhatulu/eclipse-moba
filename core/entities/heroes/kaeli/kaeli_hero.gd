class_name KaeliHero
extends HeroEntity

## Implementation of Kaeli (The Rhythm Blade / AGI Carry)

signal rhythm_updated(current_stacks: int)
signal twin_cut_struck(target: BaseCombatEntity, total_damage: float)
signal slipstream_executed()
signal crossfire_armed()
signal crossfire_triggered(target: BaseCombatEntity, bonus_damage: float)
signal perfect_tempo_activated()
signal perfect_tempo_ended()

# Passive Rhythm State
var rhythm_stacks: int = 0
var rhythm_timer: float = 0.0
var last_ability_slot: int = -1

# E: Crossfire State
var is_crossfire_armed: bool = false
var crossfire_timer: float = 0.0

# R: Perfect Tempo State
var is_perfect_tempo_active: bool = false
var perfect_tempo_timer: float = 0.0

func _ready() -> void:
	entity_name = "Kaeli"
	hero_resource = KaeliDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_kaeli_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.50
		shape.height = 1.95
		col.shape = shape
		col.position.y = 0.98
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("KaeliVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "KaeliVisual"
		add_child(root_vis)
		
		# Swift Duelist Body (1.95m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.48
		body_capsule.height = 1.95
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.98
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.20, 0.65, 0.85, 1.0) # Vibrant Cerulean & Silver
		body_mat.metallic = 0.75
		body_mat.roughness = 0.25
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
		# Twin Rhythmic Sabers Mesh
		for side in [-0.48, 0.48]:
			var saber = MeshInstance3D.new()
			var s_box = BoxMesh.new()
			s_box.size = Vector3(0.08, 1.10, 0.18)
			saber.mesh = s_box
			saber.position = Vector3(side, 0.90, 0.35)
			saber.rotation_degrees = Vector3(20, 0, 0)
			
			var s_mat = StandardMaterial3D.new()
			s_mat.albedo_color = Color(0.35, 0.85, 1.0, 1.0)
			s_mat.emission_enabled = true
			s_mat.emission = Color(0.4, 0.9, 1.0, 1.0)
			s_mat.emission_energy_multiplier = 0.8
			saber.material_override = s_mat
			root_vis.add_child(saber)
			
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

func _apply_kaeli_definition() -> void:
	if hero_resource == null:
		hero_resource = KaeliDefinition.create_resource()
		
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
	
	_process_rhythm(delta)
	_process_crossfire(delta)
	_process_perfect_tempo(delta)

# --- PASSIVE: RHYTHM ---

func _trigger_rhythm(slot: int) -> void:
	if slot != last_ability_slot:
		rhythm_stacks = mini(4, rhythm_stacks + 1)
	else:
		rhythm_stacks = 1
		
	last_ability_slot = slot
	rhythm_timer = 5.0
	_sync_rhythm_buffs()
	rhythm_updated.emit(rhythm_stacks)

func _sync_rhythm_buffs() -> void:
	if attribute_system == null:
		return
		
	attribute_system.remove_modifiers_by_source("kaeli_rhythm_as")
	attribute_system.remove_modifiers_by_source("kaeli_rhythm_ms")
	
	if rhythm_stacks > 0:
		var bonus_as = rhythm_stacks * 0.08
		var bonus_ms = rhythm_stacks * 0.04
		attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ATTACK_SPEED, StatModifier.Type.PERCENT_ADD, bonus_as, "kaeli_rhythm_as"))
		attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, bonus_ms, "kaeli_rhythm_ms"))

func _process_rhythm(delta: float) -> void:
	if rhythm_timer > 0.0:
		rhythm_timer -= delta
		if rhythm_timer <= 0.0:
			rhythm_stacks = 0
			last_ability_slot = -1
			_sync_rhythm_buffs()
			rhythm_updated.emit(0)

# --- Q: TWIN CUT ---

func cast_kaeli_q(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, target):
		return null
		
	# Spawn 3D Twin Slice VFX
	if is_inside_tree():
		var slice_script = load("res://scenes/effects/kaeli_twin_slice_3d.gd")
		if slice_script != null:
			var slice = slice_script.new()
			get_tree().root.add_child(slice)
			slice.global_position = target.global_position if target.is_inside_tree() else target.position
			
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var single_strike_dmg = base_dmg + (ad * q_res.scaling_ratio)
	var total_dmg = single_strike_dmg * 2.0
	
	if not ability_container.cast_ability(AbilityResource.Slot.Q, target):
		return null
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Twin Cut")
	var res = CombatCalculator.execute_damage(req)
	
	_trigger_rhythm(AbilityResource.Slot.Q)
	twin_cut_struck.emit(target, total_dmg)
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("KAELI: ÇİFT KESİK VURULDU! (%d Hasar, Ritim Yükü: %d)" % [int(total_dmg), rhythm_stacks])
	return res

# --- W: SLIPSTREAM ---

func cast_kaeli_w() -> bool:
	if not can_cast():
		return false
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	# Dash forward 4.0m
	var forward_dir = -transform.basis.z.normalized() if is_inside_tree() else Vector3(1, 0, 0)
	if forward_dir.length_squared() < 0.1:
		forward_dir = Vector3(1, 0, 0)
	if is_inside_tree():
		global_position += forward_dir * 4.0
	else:
		position += forward_dir * 4.0
		
	_trigger_rhythm(AbilityResource.Slot.W)
	slipstream_executed.emit()
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("KAELI: AKINTI ATILMASI (Ritim Yükü: %d)" % rhythm_stacks)
	return true

# --- E: CROSSFIRE ---

func cast_kaeli_e() -> bool:
	if not can_cast():
		return false
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return false
		
	is_crossfire_armed = true
	crossfire_timer = 4.0
	
	_trigger_rhythm(AbilityResource.Slot.E)
	crossfire_armed.emit()
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("KAELI: ÇAPRAZ ATEŞ HAZIRLANDI (Ritim Yükü: %d)" % rhythm_stacks)
	return true

func _process_crossfire(delta: float) -> void:
	if crossfire_timer > 0.0:
		crossfire_timer -= delta
		if crossfire_timer <= 0.0:
			is_crossfire_armed = false

func execute_basic_attack(target: BaseCombatEntity) -> DamageResult:
	var res = super.execute_basic_attack(target)
	if is_crossfire_armed and target != null and is_instance_valid(target) and target.is_alive() and target.team != team:
		is_crossfire_armed = false
		crossfire_timer = 0.0
		
		var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
		var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
		var base_dmg = e_res.get_base_damage(lvl) if e_res != null else 60.0
		var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
		var bonus_dmg = base_dmg + (ad * 0.60)
		
		var req = DamageRequest.create_ability_damage(self, target, bonus_dmg, DamageRequest.DamageType.PHYSICAL, "Crossfire Burst")
		CombatCalculator.execute_damage(req)
		crossfire_triggered.emit(target, bonus_dmg)
		
	return res

# --- R: PERFECT TEMPO (ULTIMATE) ---

func cast_kaeli_r() -> bool:
	if not can_cast():
		return false
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null:
		return false
		
	if ability_container.ability_levels.get(AbilityResource.Slot.R, 0) <= 0:
		ability_container.ability_levels[AbilityResource.Slot.R] = 1
		
	ability_container.cast_ability(AbilityResource.Slot.R)
	
	# Spawn 3D Tempo Burst VFX
	if is_inside_tree():
		var burst_script = load("res://scenes/effects/kaeli_tempo_burst_3d.gd")
		if burst_script != null:
			var burst = burst_script.new()
			get_tree().root.add_child(burst)
			burst.global_position = global_position
		
	is_perfect_tempo_active = true
	perfect_tempo_timer = 6.0
	rhythm_stacks = 4
	rhythm_timer = 6.0
	_sync_rhythm_buffs()
	
	# Ultimate Buffs
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("kaeli_perfect_tempo_as")
		attribute_system.remove_modifiers_by_source("kaeli_perfect_tempo_ms")
		attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ATTACK_SPEED, StatModifier.Type.PERCENT_ADD, 0.60, "kaeli_perfect_tempo_as"))
		attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.20, "kaeli_perfect_tempo_ms"))
		
	# 50% Cooldown Reduction on active basic abilities
	for slot in [AbilityResource.Slot.Q, AbilityResource.Slot.W, AbilityResource.Slot.E]:
		if ability_container.cooldown_timers.has(slot) and ability_container.cooldown_timers[slot] > 0.0:
			ability_container.cooldown_timers[slot] *= 0.50
			
	perfect_tempo_activated.emit()
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("KAELI: MÜKEMMEL TEMPO! (Azami 4 Yük, +%%60 Saldırı Hızı, CD Sıfırlama)")
	return true

func _process_perfect_tempo(delta: float) -> void:
	if is_perfect_tempo_active:
		perfect_tempo_timer -= delta
		if perfect_tempo_timer <= 0.0:
			is_perfect_tempo_active = false
			perfect_tempo_timer = 0.0
			if attribute_system != null:
				attribute_system.remove_modifiers_by_source("kaeli_perfect_tempo_as")
				attribute_system.remove_modifiers_by_source("kaeli_perfect_tempo_ms")
			perfect_tempo_ended.emit()

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	rhythm_stacks = 0
	rhythm_timer = 0.0
	last_ability_slot = -1
	is_crossfire_armed = false
	crossfire_timer = 0.0
	is_perfect_tempo_active = false
	perfect_tempo_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("kaeli_rhythm_as")
		attribute_system.remove_modifiers_by_source("kaeli_rhythm_ms")
		attribute_system.remove_modifiers_by_source("kaeli_perfect_tempo_as")
		attribute_system.remove_modifiers_by_source("kaeli_perfect_tempo_ms")

func respawn() -> void:
	super.respawn()
	rhythm_stacks = 0
	rhythm_timer = 0.0
	last_ability_slot = -1
	is_crossfire_armed = false
	crossfire_timer = 0.0
	is_perfect_tempo_active = false
	perfect_tempo_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("kaeli_rhythm_as")
		attribute_system.remove_modifiers_by_source("kaeli_rhythm_ms")
		attribute_system.remove_modifiers_by_source("kaeli_perfect_tempo_as")
		attribute_system.remove_modifiers_by_source("kaeli_perfect_tempo_ms")
