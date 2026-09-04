class_name SerisHero
extends HeroEntity

## Implementation of Seris (AGI Trapper / Razor Traps & Precision Shot)

signal needle_shot_fired(target: BaseCombatEntity, damage: float, was_precision: bool)
signal razor_trap_placed(position: Vector3, total_traps: int)
signal razor_trap_triggered(position: Vector3, victim: BaseCombatEntity)
signal trigger_wire_activated(traps_detonated: int)
signal hunting_ground_cast(target_pos: Vector3, traps_created: int)

# State data
var active_traps: Array[Dictionary] = [] # [{pos: Vector3, timer: float, node_instance: Node3D}]
const MAX_ACTIVE_TRAPS: int = 6
const TRAP_DURATION: float = 60.0
const TRAP_TRIGGER_RADIUS: float = 2.5

# Precision tracking
var trapped_targets: Dictionary = {} # target: duration
var trigger_wire_ms_timer: float = 0.0

func _ready() -> void:
	entity_name = "Seris"
	hero_resource = SerisDefinition.create_resource()
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

func is_target_trapped(target: BaseCombatEntity) -> bool:
	if target == null or not is_instance_valid(target):
		return false
	return trapped_targets.has(target)

func _process_traps(delta: float) -> void:
	var enemies: Array = []
	if is_inside_tree() and get_tree() != null:
		enemies = get_tree().get_nodes_in_group("combat_entities")
	else:
		enemies.append_array(HeroEntity.active_heroes)
		enemies.append_array(CreepEntity.active_creeps)
		
	for i in range(active_traps.size() - 1, -1, -1):
		active_traps[i]["timer"] -= delta
		var t_pos: Vector3 = active_traps[i]["pos"]
		
		# Check proximity trigger by enemy
		var triggered_victim: BaseCombatEntity = null
		for e in enemies:
			if e is BaseCombatEntity and is_instance_valid(e) and e.is_alive() and is_enemy_with(e) and e.is_targetable:
				var e_pos = e.global_position if e.is_inside_tree() else e.position
				if t_pos.distance_to(e_pos) <= TRAP_TRIGGER_RADIUS:
					triggered_victim = e
					break
					
		if triggered_victim != null:
			trigger_trap_at(i, triggered_victim)
		elif active_traps[i]["timer"] <= 0.0:
			var inst = active_traps[i].get("node_instance")
			if is_instance_valid(inst):
				inst.queue_free()
			active_traps.remove_at(i)

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
	if target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or is_enemy_with(target) == false:
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1) if ability_container != null else 1
	var base_dmg = q_res.get_base_damage(lvl) if q_res != null else 80.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 50.0
	var is_trapped = is_target_trapped(target)
	var precision_multiplier = 1.30 if is_trapped else 1.0
	var total_dmg = (base_dmg + (ad * 0.75)) * precision_multiplier
	
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Needle Shot")
	if is_trapped:
		req.armor_pen_percent = 0.25 # 25% Armor Pen on trapped targets
	var res = CombatCalculator.execute_damage(req)
	
	needle_shot_fired.emit(target, total_dmg, is_trapped)
	return res

# --- W: RAZOR TRAP ---

func cast_seris_w(target_position: Vector3) -> bool:
	place_trap(target_position)
	return true

func place_trap(trap_pos: Vector3) -> void:
	if active_traps.size() >= MAX_ACTIVE_TRAPS:
		var old = active_traps.pop_front()
		var old_inst = old.get("node_instance")
		if is_instance_valid(old_inst):
			old_inst.queue_free()
		
	# Spawn 3D Armed Razor Landmine in World
	var mine_inst: Node3D = null
	if is_inside_tree():
		var mine_script = load("res://scenes/effects/seris_razor_mine_3d.gd")
		if mine_script != null:
			mine_inst = mine_script.new()
			get_tree().root.add_child(mine_inst)
			mine_inst.global_position = trap_pos
			
	active_traps.append({
		"pos": trap_pos,
		"timer": TRAP_DURATION,
		"node_instance": mine_inst
	})
	razor_trap_placed.emit(trap_pos, active_traps.size())
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("SERIS: JİLETLİ MAYIN DÖŞENDİ! (60s Gizli Tuzak)")

func trigger_trap_at(index: int, victim: BaseCombatEntity) -> DamageResult:
	if index < 0 or index >= active_traps.size():
		return null
		
	var trap_data = active_traps[index]
	var trap_pos = trap_data["pos"]
	var inst = trap_data.get("node_instance")
	if is_instance_valid(inst) and inst.has_method("detonate"):
		inst.detonate()
	elif is_instance_valid(inst):
		inst.queue_free()
		
	active_traps.remove_at(index)
	
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1) if ability_container != null else 1
	var base_dmg = w_res.get_base_damage(lvl) if w_res != null else 70.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 50.0
	var total_dmg = base_dmg + (ad * 0.60)
	
	var res: DamageResult = null
	if victim != null and is_instance_valid(victim) and victim.is_alive():
		var req = DamageRequest.create_ability_damage(self, victim, total_dmg, DamageRequest.DamageType.PHYSICAL, "Razor Trap")
		res = CombatCalculator.execute_damage(req)
		
		# Apply Slow & Trapped Mark
		trapped_targets[victim] = 4.0
		if victim.effect_container != null:
			var slow_eff = StatusEffect.new("seris_trap_slow", StatusEffect.EffectType.SLOW, 2.5, 0.40)
			slow_eff.source_entity = self
			victim.effect_container.apply_effect(slow_eff)
			
	razor_trap_triggered.emit(trap_pos, victim)
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("SERIS: JİLETLİ MAYIN PATLADI! (%s Tuzağa Düştü)" % (victim.entity_name if victim != null else "Düşman"))
	return res

# --- E: TRIGGER WIRE ---

func cast_seris_e() -> int:
	var count = active_traps.size()
	
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1) if ability_container != null else 1
	var base_dmg = w_res.get_base_damage(lvl) if w_res != null else 70.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 50.0
	var total_dmg = (base_dmg + (ad * 0.60)) * 0.85
	
	var enemies: Array = []
	if is_inside_tree() and get_tree() != null:
		enemies = get_tree().get_nodes_in_group("combat_entities")
	else:
		enemies.append_array(HeroEntity.active_heroes)
		enemies.append_array(CreepEntity.active_creeps)
		
	# Remotely detonate all active mines with AOE damage
	for trap in active_traps:
		var t_pos: Vector3 = trap["pos"]
		var inst = trap.get("node_instance")
		if is_instance_valid(inst) and inst.has_method("detonate"):
			inst.detonate()
		elif is_instance_valid(inst):
			inst.queue_free()
			
		for e in enemies:
			if e is BaseCombatEntity and is_instance_valid(e) and e.is_alive() and is_enemy_with(e) and e.is_targetable:
				var e_pos = e.global_position if e.is_inside_tree() else e.position
				if t_pos.distance_to(e_pos) <= 3.5:
					var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.PHYSICAL, "Trigger Wire Detonation")
					CombatCalculator.execute_damage(req)
					trapped_targets[e] = 4.0
					if e.effect_container != null:
						var slow_eff = StatusEffect.new("seris_wire_slow", StatusEffect.EffectType.SLOW, 2.0, 0.40)
						slow_eff.source_entity = self
						e.effect_container.apply_effect(slow_eff)
						
	active_traps.clear()
	
	# Apply MS Buff (+30% MS for 3.0s)
	trigger_wire_ms_timer = 3.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("seris_trigger_wire_ms")
		var mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.30, "seris_trigger_wire_ms", 3.0)
		attribute_system.add_modifier(mod)
		
	trigger_wire_activated.emit(count)
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("SERIS: TETİK TELİ ÇEKİLDİ! (%d Mayın Uzaktan Patlatıldı)" % count)
	return count

# --- R: HUNTING GROUND (ULTIMATE) ---

func cast_seris_r(center_pos: Vector3, enemies_in_area: Array = []) -> bool:
	# Spawn 3D Hunting Ground Snare Matrix
	if is_inside_tree():
		var hg_script = load("res://scenes/effects/seris_hunting_ground_3d.gd")
		if hg_script != null:
			var hg = hg_script.new()
			get_tree().root.add_child(hg)
			hg.setup(center_pos, 6.0)
			
	# Spawn 3 traps around center
	place_trap(center_pos)
	place_trap(center_pos + Vector3(2.5, 0, 0))
	place_trap(center_pos + Vector3(-2.5, 0, 0))
	
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1) if ability_container != null else 1
	var base_dmg = r_res.get_base_damage(lvl) if r_res != null else 180.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 50.0
	var total_dmg = base_dmg + (ad * 0.90)
	
	var enemies = enemies_in_area.duplicate()
	if enemies.is_empty():
		if is_inside_tree() and get_tree() != null:
			enemies = get_tree().get_nodes_in_group("combat_entities")
		else:
			enemies.append_array(HeroEntity.active_heroes)
			enemies.append_array(CreepEntity.active_creeps)
			
	var hit_count = 0
	for enemy in enemies:
		if enemy is BaseCombatEntity and is_instance_valid(enemy) and enemy.is_alive() and is_enemy_with(enemy) and enemy.is_targetable:
			var e_pos = enemy.global_position if enemy.is_inside_tree() else enemy.position
			if center_pos.distance_to(e_pos) <= 6.0:
				var req = DamageRequest.create_ability_damage(self, enemy, total_dmg, DamageRequest.DamageType.PHYSICAL, "Hunting Ground")
				CombatCalculator.execute_damage(req)
				trapped_targets[enemy] = 5.0
				hit_count += 1
				if enemy.effect_container != null:
					var root_eff = StatusEffect.new("seris_hg_root", StatusEffect.EffectType.ROOT, 1.5, 0.0)
					root_eff.source_entity = self
					enemy.effect_container.apply_effect(root_eff)
					
	hunting_ground_cast.emit(center_pos, 3)
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("SERIS: AV SAHASI KURULDU! (%d Düşman Ağlara Yakalandı)" % hit_count)
	return true

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	for t in active_traps:
		var inst = t.get("node_instance")
		if is_instance_valid(inst):
			inst.queue_free()
	active_traps.clear()
	trapped_targets.clear()
	trigger_wire_ms_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("seris_trigger_wire_ms")

func respawn() -> void:
	super.respawn()
	for t in active_traps:
		var inst = t.get("node_instance")
		if is_instance_valid(inst):
			inst.queue_free()
	active_traps.clear()
	trapped_targets.clear()
	trigger_wire_ms_timer = 0.0
