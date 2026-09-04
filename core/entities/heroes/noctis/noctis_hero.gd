class_name NoctisHero
extends HeroEntity

## Implementation of Noctis

const DefScript = preload("res://data/heroes/noctis_definition.gd")

func _ready() -> void:
	entity_name = "Noctis"
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
	if not has_node("NoctisVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "NoctisVisual"
		add_child(root_vis)
		
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.52
		body_capsule.height = 2.0
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.0
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.10, 0.08, 0.18)
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

# --- Q: BLIND SPOT ---

func cast_noctis_q(target: BaseCombatEntity) -> DamageResult:
	if target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or is_enemy_with(target) == false:
		return null
		
	# Teleport behind target (1.2m behind target direction)
	var t_pos = target.global_position if target.is_inside_tree() else target.position
	var behind_pos = t_pos + Vector3(0, 0, 1.2)
	behind_pos.x = clampf(behind_pos.x, -115.0, 115.0)
	behind_pos.z = clampf(behind_pos.z, -115.0, 115.0)
	if is_inside_tree():
		global_position = behind_pos
	else:
		position = behind_pos
		
	# Spawn 3D Shadow Strike VFX
	if is_inside_tree():
		var strike_script = load("res://scenes/effects/noctis_shadow_strike_3d.gd")
		if strike_script != null:
			var strike = strike_script.new()
			get_tree().root.add_child(strike)
			strike.global_position = t_pos
			
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1) if ability_container != null else 1
	var base_dmg = q_res.get_base_damage(lvl) if q_res != null else 85.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 55.0
	var total_dmg = base_dmg + (ad * 0.90)
	
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Blind Spot")
	var res = CombatCalculator.execute_damage(req)
	
	# Apply 1.5s Blind Effect
	if target.effect_container != null:
		target.effect_container.apply_blind(0.50, 1.5, "noctis_blind")
		
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("NOCTIS: KÖR NOKTA SALDIRISI! (%s 1.5s Kör Edildi)" % target.entity_name)
	return res

# --- W: SHADOW SHROUD / FALSE PING ---

func cast_noctis_w() -> bool:
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("noctis_shroud_ms")
		var mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.35, "noctis_shroud_ms", 2.5)
		attribute_system.add_modifier(mod)
		
	if effect_container != null:
		effect_container.apply_invisibility(2.5, "noctis_invis")
		
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("NOCTIS: GÖLGEYE SAKLANDI (Kamuflaj +%%35 Hız)")
	return true

# --- E: SENSORY SEVER ---

func cast_noctis_e(target: BaseCombatEntity) -> DamageResult:
	if target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or is_enemy_with(target) == false:
		return null
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1) if ability_container != null else 1
	var base_dmg = e_res.get_base_damage(lvl) if e_res != null else 75.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 55.0
	var total_dmg = base_dmg + (ad * 0.75)
	
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Sensory Sever")
	var res = CombatCalculator.execute_damage(req)
	
	# Apply 1.2s Silence
	if target.effect_container != null:
		var sil_eff = StatusEffect.new("noctis_silence", StatusEffect.EffectType.SILENCE, 1.2, 0.0, true)
		sil_eff.source_entity = self
		target.effect_container.apply_effect(sil_eff)
		
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("NOCTIS: DUYU YUTMA! (%s 1.2s Susturuldu)" % target.entity_name)
	return res

# --- R: TOTAL ECLIPSE (ULTIMATE) ---

func cast_noctis_r(target_location: Vector3, enemies_in_area: Array = []) -> bool:
	var my_pos = global_position if is_inside_tree() else position
	
	# Spawn 3D Global Total Eclipse Dome
	if is_inside_tree():
		var eclipse_script = load("res://scenes/effects/noctis_total_eclipse_3d.gd")
		if eclipse_script != null:
			var dome = eclipse_script.new()
			get_tree().root.add_child(dome)
			dome.setup(my_pos, 5.0)
			
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1) if ability_container != null else 1
	var base_dmg = r_res.get_base_damage(lvl) if r_res != null else 220.0
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) if attribute_system != null else 55.0
	var total_dmg = base_dmg + (ad * 1.20)
	
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
			if my_pos.distance_to(e_pos) <= 14.0 or target_location.distance_to(e_pos) <= 14.0:
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.PHYSICAL, "Total Eclipse")
				CombatCalculator.execute_damage(req)
				if e.effect_container != null:
					e.effect_container.apply_blind(0.50, 3.0, "noctis_eclipse_blind")
					
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("NOCTIS: TAM GÜNEŞ TUTULMASI! (Tüm Harita Zifiri Karanlığa Boğuldu)")
	return true
