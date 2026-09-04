class_name GerasHero
extends HeroEntity

## Implementation of Geras

const DefScript = preload("res://data/heroes/geras_definition.gd")

func _ready() -> void:
	entity_name = "Geras"
	super._ready()
	_setup_collision()
	_create_visual_mesh()
	_apply_def()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.60
		shape.height = 2.1
		col.shape = shape
		col.position.y = 1.05
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("GerasVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "GerasVisual"
		add_child(root_vis)
		
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.52
		body_capsule.height = 2.0
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.0
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.45, 0.38, 0.28)
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)

func _apply_def() -> void:
	var def = DefScript.create_resource()
	_apply_hero_resource(def)
	hero_resource = def
	
	ability_container.set_ability(AbilityResource.Slot.PASSIVE, def.passive_ability)
	ability_container.set_ability(AbilityResource.Slot.Q, def.q_ability)
	ability_container.set_ability(AbilityResource.Slot.W, def.w_ability)
	ability_container.set_ability(AbilityResource.Slot.E, def.e_ability)
	ability_container.set_ability(AbilityResource.Slot.R, def.r_ability)

func _grant_granite_shield() -> void:
	if effect_container != null and attribute_system != null:
		var max_hp = attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
		var shield_amount = max_hp * 0.15
		var shield_eff = StatusEffect.new("geras_granite_shield", StatusEffect.EffectType.SHIELD, 4.0, shield_amount, false)
		shield_eff.source_entity = self
		effect_container.apply_effect(shield_eff)

# --- Q: RAISE EARTH (GRANITE WALL) ---

func cast_geras_q(target_pos: Vector3, targets: Array = []) -> DamageResult:
	_grant_granite_shield()
	
	# Spawn 3D Physical Granite Wall
	if is_inside_tree():
		var wall_script = load("res://scenes/effects/geras_granite_wall_3d.gd")
		if wall_script != null:
			var wall = wall_script.new()
			get_tree().root.add_child(wall)
			wall.setup(target_pos)
			
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1) if ability_container != null else 1
	var base_dmg = q_res.get_base_damage(lvl) if q_res != null else 80.0
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) if attribute_system != null else 20.0
	var total_dmg = base_dmg + (ap * 0.80)
	
	var enemies = targets.duplicate()
	if enemies.is_empty():
		if is_inside_tree() and get_tree() != null:
			enemies = get_tree().get_nodes_in_group("combat_entities")
		else:
			enemies.append_array(HeroEntity.active_heroes)
			enemies.append_array(CreepEntity.active_creeps)
			
	var primary_res: DamageResult = null
	for e in enemies:
		if e is BaseCombatEntity and is_instance_valid(e) and e != self and e.is_alive() and is_enemy_with(e) and e.is_targetable:
			var e_pos = e.global_position if e.is_inside_tree() else e.position
			if target_pos.distance_to(e_pos) <= 3.5:
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.MAGICAL, "Raise Earth")
				var res = CombatCalculator.execute_damage(req)
				if primary_res == null:
					primary_res = res
				if e.effect_container != null:
					var stun_eff = StatusEffect.new("geras_knockup_stun", StatusEffect.EffectType.STUN, 0.8, 0.0, true)
					stun_eff.source_entity = self
					e.effect_container.apply_effect(stun_eff)
					
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("GERAS: TOPRAK DUVARI YÜKSELTİLDİ! (Fiziksel Engel + Savurma)")
	return primary_res

# --- W: TECTONIC COLLAPSE ---

func cast_geras_w(target_pos: Vector3, targets: Array = []) -> DamageResult:
	_grant_granite_shield()
	
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1) if ability_container != null else 1
	var base_dmg = w_res.get_base_damage(lvl) if w_res != null else 90.0
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) if attribute_system != null else 20.0
	var total_dmg = base_dmg + (ap * 0.85)
	
	var enemies = targets.duplicate()
	if enemies.is_empty():
		if is_inside_tree() and get_tree() != null:
			enemies = get_tree().get_nodes_in_group("combat_entities")
		else:
			enemies.append_array(HeroEntity.active_heroes)
			enemies.append_array(CreepEntity.active_creeps)
			
	var primary_res: DamageResult = null
	for e in enemies:
		if e is BaseCombatEntity and is_instance_valid(e) and e != self and e.is_alive() and is_enemy_with(e) and e.is_targetable:
			var e_pos = e.global_position if e.is_inside_tree() else e.position
			if target_pos.distance_to(e_pos) <= 4.0:
				# Pull toward center
				var pull_dir = (target_pos - e_pos).normalized()
				var new_pos = e_pos + (pull_dir * 2.0)
				if e.is_inside_tree():
					e.global_position = new_pos
				else:
					e.position = new_pos
					
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.MAGICAL, "Tectonic Collapse")
				var res = CombatCalculator.execute_damage(req)
				if primary_res == null:
					primary_res = res
				if e.effect_container != null:
					var stun_eff = StatusEffect.new("geras_collapse_stun", StatusEffect.EffectType.STUN, 1.2, 0.0, true)
					stun_eff.source_entity = self
					e.effect_container.apply_effect(stun_eff)
					
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("GERAS: TEKTONİK ÇÖKÜŞ! (Düşmanlar Merkeze Çekildi ve 1.2s Kilitlendi)")
	return primary_res

# --- E: QUICKSAND ---

func cast_geras_e(target_pos: Vector3) -> bool:
	_grant_granite_shield()
	
	# Spawn 3D Quicksand Vortex
	if is_inside_tree():
		var quicksand_script = load("res://scenes/effects/geras_quicksand_3d.gd")
		if quicksand_script != null:
			var sand = quicksand_script.new()
			get_tree().root.add_child(sand)
			sand.setup(target_pos, 5.0)
			
	var enemies: Array = []
	if is_inside_tree() and get_tree() != null:
		enemies = get_tree().get_nodes_in_group("combat_entities")
	else:
		enemies.append_array(HeroEntity.active_heroes)
		enemies.append_array(CreepEntity.active_creeps)
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1) if ability_container != null else 1
	var base_dmg = e_res.get_base_damage(lvl) if e_res != null else 70.0
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) if attribute_system != null else 20.0
	var total_dmg = base_dmg + (ap * 0.60)
	
	for e in enemies:
		if e is BaseCombatEntity and is_instance_valid(e) and e != self and e.is_alive() and is_enemy_with(e) and e.is_targetable:
			var e_pos = e.global_position if e.is_inside_tree() else e.position
			if target_pos.distance_to(e_pos) <= 5.0:
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.MAGICAL, "Quicksand")
				CombatCalculator.execute_damage(req)
				if e.effect_container != null:
					var slow_eff = StatusEffect.new("geras_sand_slow", StatusEffect.EffectType.SLOW, 3.5, 0.50, true)
					slow_eff.source_entity = self
					e.effect_container.apply_effect(slow_eff)
					
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("GERAS: BATAKLIK KUMU SERİLDİ! (%%50 Yavaşlatma Girdabı)")
	return true

# --- R: TECTONIC FISSURE (ULTIMATE) ---

func cast_geras_r(target_location: Vector3, enemies_in_area: Array = []) -> bool:
	_grant_granite_shield()
	var my_pos = global_position if is_inside_tree() else position
	var dir = (target_location - my_pos).normalized()
	if dir.length_squared() < 0.01:
		dir = Vector3(0, 0, -1)
	var end_pos = my_pos + (dir * 14.0)
	
	# Spawn 3D Tectonic Fissure Ravine
	if is_inside_tree():
		var fissure_script = load("res://scenes/effects/geras_tectonic_fissure_3d.gd")
		if fissure_script != null:
			var rift = fissure_script.new()
			get_tree().root.add_child(rift)
			rift.setup(my_pos, end_pos, 5.0)
			
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1) if ability_container != null else 1
	var base_dmg = r_res.get_base_damage(lvl) if r_res != null else 240.0
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) if attribute_system != null else 20.0
	var total_dmg = base_dmg + (ap * 1.20)
	
	var enemies = enemies_in_area.duplicate()
	if enemies.is_empty():
		if is_inside_tree() and get_tree() != null:
			enemies = get_tree().get_nodes_in_group("combat_entities")
		else:
			enemies.append_array(HeroEntity.active_heroes)
			enemies.append_array(CreepEntity.active_creeps)
			
	for e in enemies:
		if e is BaseCombatEntity and is_instance_valid(e) and e != self and e.is_alive() and is_enemy_with(e) and e.is_targetable:
			var e_pos = e.global_position if e.is_inside_tree() else e.position
			var mid_point = (my_pos + end_pos) * 0.5
			if e_pos.distance_to(mid_point) <= 8.0 or target_location.distance_to(e_pos) <= 6.0:
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.MAGICAL, "Tectonic Fissure")
				CombatCalculator.execute_damage(req)
				if e.effect_container != null:
					var slow_eff = StatusEffect.new("geras_fissure_slow", StatusEffect.EffectType.SLOW, 4.0, 0.70, true)
					slow_eff.source_entity = self
					e.effect_container.apply_effect(slow_eff)
					
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("GERAS: 14 METRE TEKTONİK FAY HATTI YARDI! (%%70 Yavaşlatma Yarığı)")
	return true