class_name SelkaHero
extends HeroEntity

const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")

## Implementation of Selka (The Cursesmith / INT Hex Burst Mage)

signal hex_applied(target: BaseCombatEntity, stacks: int)
signal hex_detonated(targets_hit: int, total_damage: float)
signal cataclysm_linked(targets: Array)

# Hex Mark storage: target -> {stacks: int, timer: float}
var hex_marks: Dictionary = {}
const MAX_HEX_STACKS: int = 3
const HEX_DURATION: float = 6.0

# Cataclysm Fate Links: Array of BaseCombatEntity, timer: float
var linked_targets: Array[BaseCombatEntity] = []
var cataclysm_timer: float = 0.0
const CATACLYSM_DURATION: float = 5.0

func _ready() -> void:
	entity_name = "Selka"
	hero_resource = SelkaDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_selka_definition()

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
	if not has_node("SelkaVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "SelkaVisual"
		add_child(root_vis)
		
		# Cursesmith Dark Robes Body (1.9m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.46
		body_capsule.height = 1.90
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.95
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.35, 0.15, 0.45, 1.0) # Dark Hex Violet
		mat.roughness = 0.45
		body_inst.material_override = mat
		root_vis.add_child(body_inst)
		
		# Floating Hex Fire Lantern
		var lantern = MeshInstance3D.new()
		var box = BoxMesh.new()
		box.size = Vector3(0.25, 0.35, 0.25)
		lantern.mesh = box
		lantern.position = Vector3(0.65, 1.3, 0.2)
		
		var l_mat = StandardMaterial3D.new()
		l_mat.albedo_color = Color(0.85, 0.25, 0.95, 1.0)
		l_mat.emission_enabled = true
		l_mat.emission = Color(0.90, 0.20, 1.0, 1.0)
		l_mat.emission_energy_multiplier = 1.4
		lantern.material_override = l_mat
		root_vis.add_child(lantern)
		
		# Selection Base Ring
		var ring = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.85
		torus.outer_radius = 0.90
		ring.mesh = torus
		ring.position.y = 0.03
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var ring_color = Color(0.95, 0.3, 0.3, 0.85) if team == TeamDefinitions.Team.DIRE else Color(0.7, 0.3, 0.9, 0.85)
		ring_mat.albedo_color = ring_color
		ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		ring.material_override = ring_mat
		root_vis.add_child(ring)

func _apply_selka_definition() -> void:
	if hero_resource == null:
		hero_resource = SelkaDefinition.create_resource()
		
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
	_process_hex_marks(delta)
	_process_cataclysm(delta)

# --- PASSIVE: HEX MARKS ---

func apply_hex_mark(target: BaseCombatEntity) -> int:
	if target == null or not is_instance_valid(target) or not target.is_alive() or target.team == team:
		return 0
		
	var cur_stacks = 0
	if hex_marks.has(target):
		cur_stacks = hex_marks[target].get("stacks", 0)
		
	var new_stacks = CombatMechanicsClass.apply_mark(self, target, "selka_hex", "Lanet Damgası", HEX_DURATION, MAX_HEX_STACKS, "☠")
	hex_marks[target] = {"stacks": new_stacks, "timer": HEX_DURATION}
	
	# Reduce MR on target by 6% per stack
	if target.attribute_system != null:
		target.attribute_system.remove_modifiers_by_source("selka_hex_mr_shred")
		var shred_pct = float(new_stacks) * -0.06
		var mod = StatModifier.new(StatModifier.TargetStat.MAGIC_RESIST, StatModifier.Type.PERCENT_ADD, shred_pct, "selka_hex_mr_shred")
		target.attribute_system.add_modifier(mod)
		
	hex_applied.emit(target, new_stacks)
	return new_stacks

func get_hex_stacks(target: BaseCombatEntity) -> int:
	if hex_marks.has(target):
		return hex_marks[target].get("stacks", 0)
	return 0

func clear_hex_marks(target: BaseCombatEntity) -> void:
	if hex_marks.has(target):
		if target != null and is_instance_valid(target) and target.attribute_system != null:
			target.attribute_system.remove_modifiers_by_source("selka_hex_mr_shred")
		hex_marks.erase(target)
	CombatMechanicsClass.consume_marks(target, "selka_hex")

func _process_hex_marks(delta: float) -> void:
	var to_remove = []
	for target in hex_marks.keys():
		if not is_instance_valid(target) or not target.is_alive():
			to_remove.append(target)
			continue
		hex_marks[target]["timer"] -= delta
		if hex_marks[target]["timer"] <= 0.0:
			to_remove.append(target)
			
	for target in to_remove:
		clear_hex_marks(target)

# --- Q: HEX BOLT ---

func cast_selka_q(target: BaseCombatEntity) -> DamageResult:
	if target == null or not is_instance_valid(target) or not target.is_alive() or not is_enemy_with(target):
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1) if ability_container != null else 1
	var base_dmg = q_res.get_base_damage(lvl) if q_res != null else 75.0
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) if attribute_system != null else 0.0
	var total_dmg = base_dmg + (ap * 0.70)
	
	apply_hex_mark(target)
	
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.MAGICAL, "Hex Bolt")
	var res = CombatCalculator.execute_damage(req)
	_propagate_cataclysm_damage(target, total_dmg)
	
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("SELKA: LANET OKU VURDU (%d Hasar + 1 Damga)" % int(total_dmg))
	return res

# --- W: EMBER RING ---

func cast_selka_w(center_pos: Vector3, targets: Array = []) -> Array[DamageResult]:
	# Spawn 3D Expanding Ember Ring VFX
	if is_inside_tree():
		var ring_script = load("res://scenes/effects/selka_ember_ring_3d.gd")
		if ring_script != null:
			var ring = ring_script.new()
			get_tree().root.add_child(ring)
			ring.global_position = center_pos
			
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1) if ability_container != null else 1
	var base_dmg = w_res.get_base_damage(lvl) if w_res != null else 70.0
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) if attribute_system != null else 0.0
	var total_dmg = base_dmg + (ap * 0.65)
	
	var enemies: Array = []
	if not targets.is_empty():
		enemies = targets
	elif is_inside_tree() and get_tree() != null:
		enemies = get_tree().get_nodes_in_group("combat_entities")
	else:
		enemies.append_array(HeroEntity.active_heroes)
		enemies.append_array(CreepEntity.active_creeps)
		
	var results: Array[DamageResult] = []
	for e in enemies:
		if e is BaseCombatEntity and is_instance_valid(e) and e != self and e.is_alive() and is_enemy_with(e) and e.is_targetable:
			var e_pos = e.global_position if e.is_inside_tree() else e.position
			if center_pos.distance_to(e_pos) <= 5.0:
				apply_hex_mark(e)
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.MAGICAL, "Ember Ring")
				var res = CombatCalculator.execute_damage(req)
				results.append(res)
				_propagate_cataclysm_damage(e, total_dmg)
				
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("SELKA: LANET HALKASI AÇILDI (%d Düşman Vuruldu)" % results.size())
	return results

# --- E: DETONATE (CURSE RUPTURE) ---

func cast_selka_e() -> float:
	var my_pos = global_position if is_inside_tree() else position
	
	# Spawn 3D Curse Detonate Shockwave VFX
	if is_inside_tree():
		var det_script = load("res://scenes/effects/selka_curse_detonate_3d.gd")
		if det_script != null:
			var det = det_script.new()
			get_tree().root.add_child(det)
			det.global_position = my_pos
			
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1) if ability_container != null else 1
	var per_stack_dmg = e_res.get_base_damage(lvl) if e_res != null else 40.0
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) if attribute_system != null else 0.0
	var total_per_stack = per_stack_dmg + (ap * 0.35)
	
	var total_dmg_dealt = 0.0
	var hit_count = 0
	var targets_to_clear = []
	
	for target in hex_marks.keys():
		if target != null and is_instance_valid(target) and target.is_alive() and is_enemy_with(target):
			var t_pos = target.global_position if target.is_inside_tree() else target.position
			if my_pos.distance_to(t_pos) <= 7.5:
				var stacks = hex_marks[target].get("stacks", 0)
				if stacks > 0:
					var burst_dmg = total_per_stack * float(stacks)
					var req = DamageRequest.create_ability_damage(self, target, burst_dmg, DamageRequest.DamageType.MAGICAL, "Detonate")
					var res = CombatCalculator.execute_damage(req)
					if res != null:
						total_dmg_dealt += res.final_health_damage
						hit_count += 1
						_propagate_cataclysm_damage(target, burst_dmg)
						
					# Slow by 20% per stack for 2.0s
					if target.effect_container != null:
						var slow_pct = clampf(float(stacks) * 0.20, 0.20, 0.60)
						var slow_eff = StatusEffect.new("selka_detonate_slow", StatusEffect.EffectType.SLOW, 2.0, slow_pct)
						slow_eff.source_entity = self
						target.effect_container.apply_effect(slow_eff)
						
					targets_to_clear.append(target)
					
	for t in targets_to_clear:
		clear_hex_marks(t)
		
	hex_detonated.emit(hit_count, total_dmg_dealt)
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("SELKA: LANETLER PATLATILDI! (%d Düşman, %d Hasar)" % [hit_count, int(total_dmg_dealt)])
	return total_dmg_dealt

# --- R: CATACLYSM (FATE LINK - ULTIMATE) ---

func cast_selka_r(targets: Array = []) -> bool:
	linked_targets.clear()
	
	if not targets.is_empty():
		for t in targets:
			if t is BaseCombatEntity and is_instance_valid(t) and t.is_alive() and is_enemy_with(t) and linked_targets.size() < 3:
				linked_targets.append(t)
				apply_hex_mark(t)
	else:
		var my_pos = global_position if is_inside_tree() else position
		var enemies: Array = []
		if is_inside_tree() and get_tree() != null:
			enemies = get_tree().get_nodes_in_group("combat_entities")
		else:
			enemies.append_array(HeroEntity.active_heroes)
			
		for e in enemies:
			if e is BaseCombatEntity and is_instance_valid(e) and e != self and e.is_alive() and is_enemy_with(e) and e.is_targetable and linked_targets.size() < 3:
				var e_pos = e.global_position if e.is_inside_tree() else e.position
				if my_pos.distance_to(e_pos) <= 7.5:
					linked_targets.append(e)
					apply_hex_mark(e)
					
	# Spawn 3D Cataclysm Beams between linked enemies
	if is_inside_tree() and linked_targets.size() >= 2:
		var beam_script = load("res://scenes/effects/selka_cataclysm_beam_3d.gd")
		if beam_script != null:
			for i in range(linked_targets.size() - 1):
				var beam = beam_script.new()
				get_tree().root.add_child(beam)
				beam.setup(linked_targets[i], linked_targets[i+1], CATACLYSM_DURATION)
				
	cataclysm_timer = CATACLYSM_DURATION
	cataclysm_linked.emit(linked_targets)
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("SELKA: KADER BAĞI (CATACLYSM) KURULDU! (%d Düşman Birbirine Bağlandı)" % linked_targets.size())
	return true

func _propagate_cataclysm_damage(original_target: BaseCombatEntity, dmg: float) -> void:
	if linked_targets.size() <= 1 or not linked_targets.has(original_target) or cataclysm_timer <= 0.0:
		return
		
	var shared_dmg = dmg * 0.40
	for t in linked_targets:
		if t != original_target and is_instance_valid(t) and t.is_alive():
			var req = DamageRequest.create_ability_damage(self, t, shared_dmg, DamageRequest.DamageType.MAGICAL, "Cataclysm Link")
			CombatCalculator.execute_damage(req)

func _process_cataclysm(delta: float) -> void:
	if cataclysm_timer > 0.0:
		cataclysm_timer -= delta
		if cataclysm_timer <= 0.0:
			linked_targets.clear()

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	hex_marks.clear()
	linked_targets.clear()
	cataclysm_timer = 0.0

func respawn() -> void:
	super.respawn()
	hex_marks.clear()
	linked_targets.clear()
	cataclysm_timer = 0.0
