class_name LyraHero
extends HeroEntity

## Implementation of Lyra

const DefScript = preload("res://data/heroes/lyra_definition.gd")

func _ready() -> void:
	entity_name = "Lyra"
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
	if not has_node("LyraVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "LyraVisual"
		add_child(root_vis)
		
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.52
		body_capsule.height = 2.0
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.0
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.20, 0.45, 0.35)
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)

var tethered_ally: BaseCombatEntity = null
var active_tether_beam: Node3D = null

func _apply_def() -> void:
	var def = DefScript.create_resource()
	_apply_hero_resource(def)
	hero_resource = def
	
	ability_container.set_ability(AbilityResource.Slot.PASSIVE, def.passive_ability)
	ability_container.set_ability(AbilityResource.Slot.Q, def.q_ability)
	ability_container.set_ability(AbilityResource.Slot.W, def.w_ability)
	ability_container.set_ability(AbilityResource.Slot.E, def.e_ability)
	ability_container.set_ability(AbilityResource.Slot.R, def.r_ability)

# --- Q: ETHEREAL TETHER ---

func cast_lyra_q(target_ally: BaseCombatEntity) -> bool:
	if target_ally == null or not is_instance_valid(target_ally) or target_ally == self or not target_ally.is_alive():
		return false
		
	# Disconnect previous tether
	if active_tether_beam != null and is_instance_valid(active_tether_beam):
		active_tether_beam.queue_free()
		active_tether_beam = null
	if tethered_ally != null and is_instance_valid(tethered_ally) and tethered_ally.attribute_system != null:
		tethered_ally.attribute_system.remove_modifiers_by_source("lyra_tether_ms")
		
	tethered_ally = target_ally
	
	# Grant +20% MS to ally
	if tethered_ally.attribute_system != null:
		var mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.20, "lyra_tether_ms")
		tethered_ally.attribute_system.add_modifier(mod)
		
	# Spawn 3D Tether Beam
	if is_inside_tree():
		var beam_script = load("res://scenes/effects/lyra_tether_beam_3d.gd")
		if beam_script != null:
			active_tether_beam = beam_script.new()
			get_tree().root.add_child(active_tether_beam)
			active_tether_beam.setup(self, target_ally)
			
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("LYRA: ETERİK BAĞ KURULDU! (%s ile Yaşam Bağı Kuruldu)" % target_ally.entity_name)
	return true

# --- W: SOUL INFUSION ---

func cast_lyra_w() -> bool:
	if attribute_system == null:
		return false
		
	var cur_hp = attribute_system.current_health
	var sacrifice = cur_hp * 0.15
	attribute_system.apply_damage_to_health(sacrifice, "soul_infusion_cost")
	
	var heal_target = tethered_ally if (tethered_ally != null and is_instance_valid(tethered_ally) and tethered_ally.is_alive()) else self
	if heal_target.attribute_system != null:
		var heal_amount = sacrifice * 1.5 + 80.0
		heal_target.attribute_system.heal(heal_amount)
		heal_target.attribute_system.remove_modifiers_by_source("lyra_infusion_as")
		var as_mod = StatModifier.new(StatModifier.TargetStat.ATTACK_SPEED, StatModifier.Type.PERCENT_ADD, 0.30, "lyra_infusion_as", 4.0)
		heal_target.attribute_system.add_modifier(as_mod)
		
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("LYRA: RUH AŞISI YAPILDI! (%s +%d Can ve +%%30 Saldırı Hızı Kazandı)" % [heal_target.entity_name, int(sacrifice * 1.5 + 80.0)])
	return true

# --- E: ASTRAL PULL ---

func cast_lyra_e(targets: Array = []) -> DamageResult:
	var my_pos = global_position if is_inside_tree() else position
	var dest_pos = my_pos
	
	if tethered_ally != null and is_instance_valid(tethered_ally) and tethered_ally.is_alive():
		dest_pos = tethered_ally.global_position if tethered_ally.is_inside_tree() else tethered_ally.position
		
	if is_inside_tree():
		global_position = dest_pos
	else:
		position = dest_pos
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1) if ability_container != null else 1
	var base_dmg = e_res.get_base_damage(lvl) if e_res != null else 70.0
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) if attribute_system != null else 0.0
	var total_dmg = base_dmg + (ap * 0.65)
	
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
			if dest_pos.distance_to(e_pos) <= 4.0:
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.MAGICAL, "Astral Pull")
				var res = CombatCalculator.execute_damage(req)
				if primary_res == null:
					primary_res = res
				if e.effect_container != null:
					var stun_eff = StatusEffect.new("lyra_pull_stun", StatusEffect.EffectType.STUN, 1.0, 0.0, true)
					stun_eff.source_entity = self
					e.effect_container.apply_effect(stun_eff)
					
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("LYRA: ASTRAL ÇEKİM ATILIŞI! (1.0s Sersemletme)")
	return primary_res

# --- R: COSMIC RELOCATE (ULTIMATE) ---

func cast_lyra_r(dest_point: Vector3) -> bool:
	var my_pos = global_position if is_inside_tree() else position
	
	# Spawn 3D Cosmic Portals at current and target positions
	if is_inside_tree():
		var portal_script = load("res://scenes/effects/lyra_cosmic_portal_3d.gd")
		if portal_script != null:
			var p1 = portal_script.new()
			get_tree().root.add_child(p1)
			p1.setup(my_pos, 3.5)
			
			var p2 = portal_script.new()
			get_tree().root.add_child(p2)
			p2.setup(dest_point, 3.5)
			
	# Teleport Lyra and Tethered Ally
	dest_point.x = clampf(dest_point.x, -115.0, 115.0)
	dest_point.z = clampf(dest_point.z, -115.0, 115.0)
	if is_inside_tree():
		global_position = dest_point
		if tethered_ally != null and is_instance_valid(tethered_ally) and tethered_ally.is_alive():
			tethered_ally.global_position = dest_point + Vector3(1.5, 0, 1.5)
	else:
		position = dest_point
		if tethered_ally != null and is_instance_valid(tethered_ally) and tethered_ally.is_alive():
			tethered_ally.position = dest_point + Vector3(1.5, 0, 1.5)
			
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("LYRA: KOZMİK YER DEĞİŞTİRME! (Müttefikle Birlikte Işınlanıldı)")
	return true