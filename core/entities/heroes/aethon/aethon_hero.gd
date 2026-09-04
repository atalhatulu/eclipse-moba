class_name AethonHero
extends HeroEntity

## Implementation of Aethon (The Arcane Construct Builder / INT Siege Summoner)
## Commands Guardian (Melee Tank), Cannon (Ranged Mortar), and Siege (Composite Engine) constructs.

signal construct_spawned(construct_type: String, position: Vector3)
signal constructs_reconfigured(count: int)
signal siege_assembled(position: Vector3, component_count: int)

const AethonConstructScript = preload("res://core/entities/heroes/aethon/aethon_construct_entity.gd")

enum ConstructType {
	GUARDIAN, # Melee Tanky
	CANNON,   # Ranged Magic
	SIEGE     # Massive Combined Boss
}

# Construct representation for backward/test compatibility + active 3D entities
var active_constructs: Array[Dictionary] = []
var active_construct_entities: Array[BaseCombatEntity] = []
const MAX_CONSTRUCTS: int = 4
const CONSTRUCT_LIFESPAN: float = 15.0
const SIEGE_LIFESPAN: float = 20.0

var aethon_visual_root: Node3D = null
var staff_orb: MeshInstance3D = null

func _ready() -> void:
	entity_name = "Aethon"
	hero_resource = AethonDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_aethon_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.50
		shape.height = 1.90
		col.shape = shape
		col.position.y = 0.95
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("AethonVisual"):
		aethon_visual_root = Node3D.new()
		aethon_visual_root.name = "AethonVisual"
		add_child(aethon_visual_root)
		
		# Arcane Engineer Body (1.9m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.46
		body_capsule.height = 1.90
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.95
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.2, 0.45, 0.7, 1.0) # Construct Bronze / Arcane Cyan
		mat.metallic = 0.6
		mat.roughness = 0.35
		body_inst.material_override = mat
		aethon_visual_root.add_child(body_inst)
		
		# Arcane Core Orb on staff
		staff_orb = MeshInstance3D.new()
		var s_mesh = SphereMesh.new()
		s_mesh.radius = 0.22
		s_mesh.height = 0.44
		staff_orb.mesh = s_mesh
		staff_orb.position = Vector3(0.5, 1.6, 0.2)
		var orb_mat = StandardMaterial3D.new()
		orb_mat.albedo_color = Color(0.3, 0.85, 1.0, 1.0)
		orb_mat.emission_enabled = true
		orb_mat.emission = Color(0.3, 0.85, 1.0)
		orb_mat.emission_energy_multiplier = 2.0
		staff_orb.material_override = orb_mat
		aethon_visual_root.add_child(staff_orb)
	else:
		aethon_visual_root = get_node_or_null("AethonVisual")

func _apply_aethon_definition() -> void:
	if hero_resource == null:
		hero_resource = AethonDefinition.create_resource()
		
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
	_process_constructs(delta)

# --- PASSIVE: CONSTRUCT LIFECYCLE MANAGEMENT ---

func spawn_construct(type: ConstructType, spawn_pos: Vector3, hp: float = 300.0, dmg: float = 40.0) -> Dictionary:
	# 1. Enforce FIFO limit
	if active_construct_entities.size() >= MAX_CONSTRUCTS:
		var oldest_ent = active_construct_entities.pop_front()
		if oldest_ent != null and is_instance_valid(oldest_ent):
			oldest_ent._expire_construct()
	if active_constructs.size() >= MAX_CONSTRUCTS:
		active_constructs.remove_at(0)
		
	var lifespan = SIEGE_LIFESPAN if type == ConstructType.SIEGE else CONSTRUCT_LIFESPAN
	
	# 2. Dictionary tracking (For headless/regression tests)
	var c = {
		"type": type,
		"pos": spawn_pos,
		"health": hp,
		"max_health": hp,
		"damage": dmg,
		"timer": lifespan,
		"attack_timer": 0.0
	}
	active_constructs.append(c)
	
	# 3. Real 3D World Entity Spawning
	if is_inside_tree():
		if AethonConstructScript != null:
			var construct_ent = AethonConstructScript.new()
			get_tree().root.add_child(construct_ent)
			construct_ent.global_position = spawn_pos
			var c_type = AethonConstructScript.ConstructType.GUARDIAN if type == ConstructType.GUARDIAN else (AethonConstructScript.ConstructType.CANNON if type == ConstructType.CANNON else AethonConstructScript.ConstructType.SIEGE)
			construct_ent.setup_construct(self, c_type, hp, dmg, lifespan)
			active_construct_entities.append(construct_ent)
			
			# VFX Spawn Ring
			var ring_script = load("res://scenes/effects/aethon_summon_ring_3d.gd")
			if ring_script != null:
				var ring = ring_script.new()
				get_tree().root.add_child(ring)
				ring.global_position = spawn_pos
				
	# 4. Central SummonManager Registration
	SummonManager.spawn_construct(self, type as int as SummonManager.ConstructType, spawn_pos, hp, dmg, lifespan)
	
	var type_str = "Guardian" if type == ConstructType.GUARDIAN else ("Cannon" if type == ConstructType.CANNON else "Siege")
	construct_spawned.emit(type_str, spawn_pos)
	
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("AETHON: %s YAPISI ÇAĞRILDI (%s)" % [type_str.to_upper(), str(spawn_pos)])
		
	return c

func get_construct_count() -> int:
	return active_constructs.size()

func get_constructs_of_type(type: ConstructType) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for c in active_constructs:
		if c.get("type", ConstructType.GUARDIAN) == type:
			result.append(c)
	return result

func clear_all_constructs() -> void:
	for ent in active_construct_entities:
		if ent != null and is_instance_valid(ent):
			ent.queue_free()
	active_construct_entities.clear()
	active_constructs.clear()

func _process_constructs(delta: float) -> void:
	# Clean dead/expired 3D entities
	for i in range(active_construct_entities.size() - 1, -1, -1):
		var ent = active_construct_entities[i]
		if ent == null or not is_instance_valid(ent) or not ent.is_alive():
			active_construct_entities.remove_at(i)
			
	# Update dictionary trackers
	for i in range(active_constructs.size() - 1, -1, -1):
		active_constructs[i]["timer"] -= delta
		if active_constructs[i]["timer"] <= 0.0 or active_constructs[i]["health"] <= 0.0:
			active_constructs.remove_at(i)

func _play_cast_motion(target_pos: Vector3) -> void:
	if aethon_visual_root == null or not is_inside_tree():
		return
	var tw = create_tween()
	if tw != null:
		tw.tween_property(aethon_visual_root, "position:y", 0.3, 0.10).set_trans(Tween.TRANS_QUAD)
		tw.tween_property(aethon_visual_root, "position:y", 0.0, 0.15).set_trans(Tween.TRANS_BOUNCE)
		
	if staff_orb != null and staff_orb.material_override is StandardMaterial3D:
		var mat = staff_orb.material_override as StandardMaterial3D
		mat.emission_energy_multiplier = 4.0
		var tw_glow = create_tween()
		if tw_glow != null:
			tw_glow.tween_property(mat, "emission_energy_multiplier", 2.0, 0.3)

# --- Q: GUARDIAN CONSTRUCT (MELEE TANKY) ---

func cast_aethon_q(target_pos: Vector3) -> bool:
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1) if ability_container != null else 1
	var base_dmg = q_res.get_base_damage(lvl) if q_res != null else 35.0
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) if attribute_system != null else 0.0
	var dmg = base_dmg + (ap * (q_res.scaling_ratio if q_res != null else 0.40))
	var hp = 320.0 + (float(lvl) * 60.0) + (ap * 0.50)
	
	_play_cast_motion(target_pos)
	spawn_construct(ConstructType.GUARDIAN, target_pos, hp, dmg)
	return true

# --- W: CANNON CONSTRUCT (RANGED MAGIC) ---

func cast_aethon_w(target_pos: Vector3) -> bool:
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1) if ability_container != null else 1
	var base_dmg = w_res.get_base_damage(lvl) if w_res != null else 45.0
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) if attribute_system != null else 0.0
	var dmg = base_dmg + (ap * (w_res.scaling_ratio if w_res != null else 0.50))
	var hp = 240.0 + (float(lvl) * 45.0) + (ap * 0.35)
	
	_play_cast_motion(target_pos)
	spawn_construct(ConstructType.CANNON, target_pos, hp, dmg)
	return true

# --- E: RECONFIGURE (OVERCHARGE & MORPH) ---

func cast_aethon_e() -> int:
	var count = 0
	# Morph 3D entities
	for ent in active_construct_entities:
		if ent != null and is_instance_valid(ent) and ent.is_alive():
			var new_type = AethonConstructScript.ConstructType.CANNON if ent.get("construct_type") == AethonConstructScript.ConstructType.GUARDIAN else AethonConstructScript.ConstructType.GUARDIAN
			if ent.has_method("morph_to_type"):
				ent.morph_to_type(new_type)
			if ent.attribute_system != null:
				var max_h = ent.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
				ent.attribute_system.heal(max_h * 0.50)
			if ent.has_method("apply_overcharge"):
				ent.apply_overcharge(1.40, 4.0)
			count += 1
			
	# Update dictionary representation
	for c in active_constructs:
		if c.get("type", ConstructType.GUARDIAN) == ConstructType.GUARDIAN:
			c["type"] = ConstructType.CANNON
			c["damage"] = c["damage"] * 1.30
		elif c.get("type", ConstructType.GUARDIAN) == ConstructType.CANNON:
			c["type"] = ConstructType.GUARDIAN
			c["health"] = c["health"] + (c["max_health"] * 0.50)
			c["max_health"] = c["max_health"] * 1.30
			
		c["health"] = minf(c["max_health"], c["health"] + (c["max_health"] * 0.50))
		c["timer"] = minf(CONSTRUCT_LIFESPAN, c["timer"] + 5.0)
		
	# Spawn Reconfigure Shockwave VFX
	if is_inside_tree():
		var burst_script = load("res://scenes/effects/aethon_reconfigure_burst_3d.gd")
		if burst_script != null:
			var burst = burst_script.new()
			get_tree().root.add_child(burst)
			burst.global_position = global_position
			
	constructs_reconfigured.emit(count)
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("AETHON: RECONFIGURE UYGULANDI (%d YAPI DÖNÜŞTÜRÜLDÜ VE GÜÇLENDİRİLDİ)" % count)
	return count

# --- R: ASSEMBLY (SIEGE CONSTRUCT - ULTIMATE) ---

func cast_aethon_r(center_pos: Vector3, enemies: Array = []) -> DamageResult:
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1) if ability_container != null else 1
	var base_dmg = r_res.get_base_damage(lvl) if r_res != null else 150.0
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) if attribute_system != null else 0.0
	
	var comp_count = active_constructs.size()
	var total_comp_hp = 0.0
	for c in active_constructs:
		total_comp_hp += c.get("health", 0.0)
	clear_all_constructs()
	
	var bonus_dmg = float(comp_count) * 40.0
	var total_dmg = base_dmg + (ap * (r_res.scaling_ratio if r_res != null else 0.60)) + bonus_dmg
	var siege_hp = 600.0 + total_comp_hp + (float(lvl) * 150.0)
	
	_play_cast_motion(center_pos)
	spawn_construct(ConstructType.SIEGE, center_pos, siege_hp, total_dmg * 0.40)
	siege_assembled.emit(center_pos, comp_count)
	
	# Spawn Ultimate Slam Crater Shockwave VFX
	if is_inside_tree():
		var slam_script = load("res://scenes/effects/aethon_siege_slam_3d.gd")
		if slam_script != null:
			var slam = slam_script.new()
			get_tree().root.add_child(slam)
			slam.global_position = center_pos
			
	# Execute initial assembly shockwave damage
	var res: DamageResult = null
	var target_list = enemies
	if target_list.is_empty() and is_inside_tree():
		for ent in get_tree().get_nodes_in_group("combat_entities"):
			if ent is BaseCombatEntity and ent != self and ent.team != team:
				target_list.append(ent)
				
	for e in target_list:
		if e is BaseCombatEntity and is_instance_valid(e) and e.is_alive() and e.team != team and e.is_targetable:
			var e_pos = e.global_position if is_inside_tree() else e.position
			if center_pos.distance_to(e_pos) <= 6.5:
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.MAGICAL, "Siege Assembly")
				res = CombatCalculator.execute_damage(req)
				
	return res

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	clear_all_constructs()

func respawn() -> void:
	super.respawn()
	clear_all_constructs()
