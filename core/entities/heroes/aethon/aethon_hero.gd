class_name AethonHero
extends HeroEntity

## Implementation of Aethon (The Arcane Construct Builder / INT Siege Summoner)

signal construct_spawned(construct_type: String, position: Vector3)
signal constructs_reconfigured(count: int)
signal siege_assembled(position: Vector3, component_count: int)

enum ConstructType {
	GUARDIAN, # Melee Tanky
	CANNON,   # Ranged Magic
	SIEGE     # Massive Combined Boss
}

# Construct representation: {type: ConstructType, pos: Vector3, health: float, max_health: float, damage: float, timer: float, attack_timer: float}
var active_constructs: Array[Dictionary] = []
const MAX_CONSTRUCTS: int = 4
const CONSTRUCT_LIFESPAN: float = 15.0
const SIEGE_LIFESPAN: float = 20.0

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
		var root_vis = Node3D.new()
		root_vis.name = "AethonVisual"
		add_child(root_vis)
		
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
		root_vis.add_child(body_inst)
		
		# Arcane Core Orb on staff
		var orb = MeshInstance3D.new()
		var s_mesh = SphereMesh.new()
		s_mesh.radius = 0.22
		s_mesh.height = 0.44
		orb.mesh = s_mesh
		orb.position = Vector3(0.5, 1.6, 0.2)
		var orb_mat = StandardMaterial3D.new()
		orb_mat.albedo_color = Color(0.3, 0.85, 1.0, 1.0)
		orb_mat.emission_enabled = true
		orb_mat.emission = Color(0.3, 0.85, 1.0)
		orb.material_override = orb_mat
		root_vis.add_child(orb)

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
	if active_constructs.size() >= MAX_CONSTRUCTS:
		active_constructs.remove_at(0) # FIFO clamp
		
	var lifespan = SIEGE_LIFESPAN if type == ConstructType.SIEGE else CONSTRUCT_LIFESPAN
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
	var type_str = "Guardian" if type == ConstructType.GUARDIAN else ("Cannon" if type == ConstructType.CANNON else "Siege")
	construct_spawned.emit(type_str, spawn_pos)
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
	active_constructs.clear()

func _process_constructs(delta: float) -> void:
	for i in range(active_constructs.size() - 1, -1, -1):
		active_constructs[i]["timer"] -= delta
		if active_constructs[i]["timer"] <= 0.0 or active_constructs[i]["health"] <= 0.0:
			active_constructs.remove_at(i)

# --- Q: GUARDIAN CONSTRUCT (MELEE TANKY) ---

func cast_aethon_q(target_pos: Vector3) -> bool:
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
	var dmg = base_dmg + (ap * q_res.scaling_ratio)
	var hp = 320.0 + (float(lvl) * 60.0) + (ap * 0.50)
	
	spawn_construct(ConstructType.GUARDIAN, target_pos, hp, dmg)
	return true

# --- W: CANNON CONSTRUCT (RANGED MAGIC) ---

func cast_aethon_w(target_pos: Vector3) -> bool:
	if not can_cast():
		return false
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var base_dmg = w_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var dmg = base_dmg + (ap * w_res.scaling_ratio)
	var hp = 240.0 + (float(lvl) * 45.0) + (ap * 0.35)
	
	spawn_construct(ConstructType.CANNON, target_pos, hp, dmg)
	return true

# --- E: RECONFIGURE ---

func cast_aethon_e() -> int:
	if not can_cast():
		return 0
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return 0
		
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return 0
		
	var count = 0
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
		count += 1
		
	constructs_reconfigured.emit(count)
	return count

# --- R: ASSEMBLY (SIEGE CONSTRUCT - ULTIMATE) ---

func cast_aethon_r(center_pos: Vector3, enemies: Array = []) -> DamageResult:
	if not can_cast():
		return null
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null:
		return null
		
	if ability_container.ability_levels.get(AbilityResource.Slot.R, 0) <= 0:
		ability_container.ability_levels[AbilityResource.Slot.R] = 1
		
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return null
		
	var comp_count = active_constructs.size()
	var total_comp_hp = 0.0
	for c in active_constructs:
		total_comp_hp += c.get("health", 0.0)
	clear_all_constructs()
	
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var bonus_dmg = float(comp_count) * 40.0
	var total_dmg = base_dmg + (ap * r_res.scaling_ratio) + bonus_dmg
	var siege_hp = 600.0 + total_comp_hp + (float(lvl) * 150.0)
	
	spawn_construct(ConstructType.SIEGE, center_pos, siege_hp, total_dmg * 0.40)
	siege_assembled.emit(center_pos, comp_count)
	
	# Execute initial assembly shockwave damage
	var res: DamageResult = null
	for e in enemies:
		if e is BaseCombatEntity and is_instance_valid(e) and e.is_alive() and e.team != team and e.is_targetable:
			var e_pos = e.global_position if is_inside_tree() else e.position
			if center_pos.distance_to(e_pos) <= 6.0:
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
