class_name RivenaHero
extends HeroEntity

## Implementation of Rivena (The Shadow Illusionist / AGI Assassin)
## Commands Shadow Echo Clones (Shades) for burst damage, position swaps, and synchronized assassination slashes.

signal shade_spawned(pos: Vector3, total_shades: int)
signal shadow_cut_struck(target: BaseCombatEntity, total_damage: float, shade_hits: int)
signal echo_step_executed(from_pos: Vector3, to_pos: Vector3)
signal shade_command_struck(target: BaseCombatEntity, shades_used: int, damage_dealt: float)
signal nightfall_activated()
signal nightfall_ended()

const RivenaShadeScript = preload("res://core/entities/heroes/rivena/rivena_shade_entity.gd")

# Passive Echo State (Tracking positions for tests + real 3D entity nodes)
var active_shades: Array[Vector3] = []
var shade_timers: Array[float] = []
var active_shade_entities: Array[Node3D] = []
const MAX_SHADES: int = 3

# R: Nightfall State
var is_nightfall_active: bool = false
var nightfall_timer: float = 0.0

var rivena_visual_root: Node3D = null

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
		rivena_visual_root = Node3D.new()
		rivena_visual_root.name = "RivenaVisual"
		add_child(rivena_visual_root)
		
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
		rivena_visual_root.add_child(body_inst)
		
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
			s_mat.emission_energy_multiplier = 1.2
			scythe.material_override = s_mat
			rivena_visual_root.add_child(scythe)
	else:
		rivena_visual_root = get_node_or_null("RivenaVisual")

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
	
	ability_container.set_ability(AbilityResource.Slot.PASSIVE, def.passive_ability)
	ability_container.set_ability(AbilityResource.Slot.Q, def.q_ability)
	ability_container.set_ability(AbilityResource.Slot.W, def.w_ability)
	ability_container.set_ability(AbilityResource.Slot.E, def.e_ability)
	ability_container.set_ability(AbilityResource.Slot.R, def.r_ability)

func _process(delta: float) -> void:
	super._process(delta)
	_process_shades(delta)
	_process_nightfall(delta)

# --- PASSIVE: ECHO (SHADOW CLONE SPAWNING) ---

func spawn_shade(pos: Vector3) -> void:
	if active_shades.size() >= MAX_SHADES:
		active_shades.pop_front()
		shade_timers.pop_front()
		if not active_shade_entities.is_empty():
			var old_ent = active_shade_entities.pop_front()
			if old_ent != null and is_instance_valid(old_ent):
				old_ent.queue_free()
		
	active_shades.append(pos)
	shade_timers.append(5.0)
	
	# Spawn 3D Shade Entity in tree
	if is_inside_tree() and RivenaShadeScript != null:
		var shade_node = RivenaShadeScript.new()
		get_tree().root.add_child(shade_node)
		shade_node.global_position = pos
		shade_node.setup_shade(self, 5.0)
		active_shade_entities.append(shade_node)
		
	SummonManager.spawn_shade(self, pos, 5.0)
	shade_spawned.emit(pos, active_shades.size())
	
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("RIVENA: GÖLGE YANKISI (SHADE) OLUŞTURULDU (%d AKTİF)" % active_shades.size())

func _process_shades(delta: float) -> void:
	var to_remove: Array = []
	for i in range(shade_timers.size()):
		shade_timers[i] -= delta
		if shade_timers[i] <= 0.0:
			to_remove.append(i)
			
	to_remove.reverse()
	for idx in to_remove:
		if idx < active_shades.size():
			active_shades.remove_at(idx)
			shade_timers.remove_at(idx)
		if idx < active_shade_entities.size():
			var ent = active_shade_entities[idx]
			if ent != null and is_instance_valid(ent):
				ent.queue_free()
			active_shade_entities.remove_at(idx)

func _play_attack_motion(target: BaseCombatEntity, _req: DamageRequest) -> void:
	if rivena_visual_root != null and is_inside_tree():
		var tw = create_tween()
		if tw != null:
			tw.tween_property(rivena_visual_root, "rotation:y", rotation.y + 0.35, 0.08).set_trans(Tween.TRANS_QUAD)
			tw.tween_property(rivena_visual_root, "rotation:y", rotation.y, 0.12).set_trans(Tween.TRANS_QUAD)
	super._play_attack_motion(target, _req)

# --- Q: SHADOW CUT ---

func cast_rivena_q(target: BaseCombatEntity) -> DamageResult:
	if target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1) if ability_container != null else 1
	var base_dmg = q_res.get_base_damage(lvl) if q_res != null else 85.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 50.0
	var main_dmg = base_dmg + (ad * (q_res.scaling_ratio if q_res != null else 0.80))
	
	var shade_count = active_shades.size()
	var shade_bonus = shade_count * (main_dmg * 0.50)
	var total_dmg = main_dmg + shade_bonus
	
	var t_pos = target.global_position if target.is_inside_tree() else target.position
	
	# Synchronized slash animation on all 3D shades
	for ent in active_shade_entities:
		if ent != null and is_instance_valid(ent) and ent.has_method("play_synchronized_slash"):
			ent.play_synchronized_slash(t_pos)
			
	# Spawn Shadow Slash VFX
	if is_inside_tree():
		var slash_script = load("res://scenes/effects/rivena_shadow_slash_3d.gd")
		if slash_script != null:
			var slash = slash_script.new()
			get_tree().root.add_child(slash)
			slash.global_position = t_pos
			
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Shadow Cut")
	var res = CombatCalculator.execute_damage(req)
	
	var cur_pos = global_position if is_inside_tree() else position
	spawn_shade(cur_pos)
	
	shadow_cut_struck.emit(target, total_dmg, shade_count)
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("RIVENA: GÖLGE KESİSİ VURDU (%d HASAR, %d GÖLGE KATILDI)" % [int(total_dmg), shade_count])
	return res

# --- W: ECHO STEP (INSTANT SHADOW SWAP) ---

func cast_rivena_w(preferred_target_pos: Vector3 = Vector3.ZERO) -> bool:
	if active_shades.is_empty():
		return false
		
	var cur_pos = global_position if is_inside_tree() else position
	
	# Select closest shade to target pos or most recent
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
	if best_idx < active_shade_entities.size():
		var ent = active_shade_entities[best_idx]
		if ent != null and is_instance_valid(ent):
			ent.queue_free()
		active_shade_entities.remove_at(best_idx)
		
	# Spawn Implosion VFX at origin and destination
	if is_inside_tree():
		var burst_script = load("res://scenes/effects/rivena_echo_step_burst_3d.gd")
		if burst_script != null:
			var b1 = burst_script.new()
			get_tree().root.add_child(b1)
			b1.global_position = cur_pos
			var b2 = burst_script.new()
			get_tree().root.add_child(b2)
			b2.global_position = target_shade_pos
			
	if is_inside_tree():
		global_position = target_shade_pos
	else:
		position = target_shade_pos
		
	# Leave a new shade at former position
	spawn_shade(cur_pos)
	
	# Short Agility Sprint Buff (+20% for 1.5s)
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("rivena_echo_sprint")
		attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.20, "rivena_echo_sprint", 1.5))
		
	echo_step_executed.emit(cur_pos, target_shade_pos)
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("RIVENA: YANKI ADIMI UYGULANDI (GÖLGE İLE YER DEĞİŞTİRİLDİ)")
	return true

# --- E: SHADE COMMAND (SHADOW CHARGE & BURST) ---

func cast_rivena_e(target: BaseCombatEntity) -> DamageResult:
	if target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1) if ability_container != null else 1
	var base_dmg = e_res.get_base_damage(lvl) if e_res != null else 60.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 50.0
	var per_shade_dmg = base_dmg + (ad * (e_res.scaling_ratio if e_res != null else 0.50))
	
	var shade_count = maxi(1, active_shades.size())
	var total_dmg = per_shade_dmg * shade_count
	var t_pos = target.global_position if target.is_inside_tree() else target.position
	
	# Animate all shades rushing target
	for ent in active_shade_entities:
		if ent != null and is_instance_valid(ent):
			var tw = create_tween()
			if tw != null:
				tw.tween_property(ent, "global_position", t_pos, 0.15).set_trans(Tween.TRANS_QUAD)
				tw.tween_callback(ent.queue_free)
	active_shade_entities.clear()
	active_shades.clear()
	shade_timers.clear()
	
	# Spawn Shadow Slash Impact VFX
	if is_inside_tree():
		var slash_script = load("res://scenes/effects/rivena_shadow_slash_3d.gd")
		if slash_script != null:
			var slash = slash_script.new()
			get_tree().root.add_child(slash)
			slash.global_position = t_pos
			
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Shade Command")
	var res = CombatCalculator.execute_damage(req)
	
	var cur_pos = global_position if is_inside_tree() else position
	spawn_shade(cur_pos)
	
	shade_command_struck.emit(target, shade_count, total_dmg)
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("RIVENA: GÖLGE EMRİ PATLADI (%d GÖLGE, %d TOPLAM HASAR)" % [shade_count, int(total_dmg)])
	return res

# --- R: NIGHTFALL (ULTIMATE SHROUD) ---

func cast_rivena_r() -> bool:
	var cur_pos = global_position if is_inside_tree() else position
	spawn_shade(cur_pos + Vector3(2.5, 0, 0))
	spawn_shade(cur_pos + Vector3(-2.5, 0, 0))
	
	is_nightfall_active = true
	nightfall_timer = 6.0
	
	# Attach Orbiting Nightfall Shroud VFX
	if is_inside_tree():
		var shroud_script = load("res://scenes/effects/rivena_nightfall_shroud_3d.gd")
		if shroud_script != null:
			var shroud = shroud_script.new()
			add_child(shroud)
			shroud.position = Vector3.ZERO
			
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("rivena_nightfall_ms")
		attribute_system.remove_modifiers_by_source("rivena_nightfall_ad")
		attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.35, "rivena_nightfall_ms", 6.0))
		attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ATTACK_DAMAGE, StatModifier.Type.FLAT, 30.0, "rivena_nightfall_ad", 6.0))
		
	nightfall_activated.emit()
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("RIVENA: GECE ÇÖKÜŞÜ (NIGHTFALL) BAŞLADI (+%35 HIZ, +30 AD, 2 GÖLGE)")
	return true

func _process_nightfall(delta: float) -> void:
	if is_nightfall_active:
		nightfall_timer -= delta
		if nightfall_timer <= 0.0:
			is_nightfall_active = false
			nightfall_timer = 0.0
			nightfall_ended.emit()

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	for ent in active_shade_entities:
		if ent != null and is_instance_valid(ent):
			ent.queue_free()
	active_shade_entities.clear()
	active_shades.clear()
	shade_timers.clear()
	is_nightfall_active = false
	nightfall_timer = 0.0

func respawn() -> void:
	super.respawn()
	for ent in active_shade_entities:
		if ent != null and is_instance_valid(ent):
			ent.queue_free()
	active_shade_entities.clear()
	active_shades.clear()
	shade_timers.clear()
	is_nightfall_active = false
	nightfall_timer = 0.0
