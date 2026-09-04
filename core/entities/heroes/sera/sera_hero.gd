class_name SeraHero
extends HeroEntity

## Implementation of Sera - The Astral Weaver (INT Enchanter / Cleanse & Momentum Support)

signal astral_surge_activated()
signal ally_purified(ally: BaseCombatEntity)

const DefScript = preload("res://data/heroes/sera_definition.gd")

var sera_visual_root: Node3D = null

func _ready() -> void:
	entity_name = "Sera"
	hero_resource = DefScript.create_resource()
	super._ready()
	_setup_collision()
	_create_visual_mesh()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.50
		shape.height = 1.95
		col.shape = shape
		col.position.y = 0.975
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("SeraVisual"):
		sera_visual_root = Node3D.new()
		sera_visual_root.name = "SeraVisual"
		add_child(sera_visual_root)
		
		# Priestess Robe / Body (1.95m Tall)
		var body_inst = MeshInstance3D.new()
		var body_cyl = CylinderMesh.new()
		body_cyl.top_radius = 0.35
		body_cyl.bottom_radius = 0.55
		body_cyl.height = 1.95
		body_inst.mesh = body_cyl
		body_inst.position.y = 0.975
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.92, 0.88, 0.96, 1.0) # Radiant Silk & Astral Gold
		body_mat.metallic = 0.4
		body_mat.roughness = 0.3
		body_mat.emission_enabled = true
		body_mat.emission = Color(0.3, 0.85, 0.9)
		body_mat.emission_energy_multiplier = 0.7
		body_inst.material_override = body_mat
		sera_visual_root.add_child(body_inst)
		
		# Floating Astral Halo / Crown
		var halo = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.35
		torus.outer_radius = 0.42
		halo.mesh = torus
		halo.position = Vector3(0.0, 2.15, 0.0)
		halo.rotation_degrees = Vector3(25, 0, 0)
		
		var h_mat = StandardMaterial3D.new()
		h_mat.albedo_color = Color(0.95, 0.85, 0.3, 1.0)
		h_mat.emission_enabled = true
		h_mat.emission = Color(1.0, 0.9, 0.4)
		h_mat.emission_energy_multiplier = 2.5
		halo.material_override = h_mat
		sera_visual_root.add_child(halo)
		
		# Selection Base Ring
		var ring = MeshInstance3D.new()
		var torus_b = TorusMesh.new()
		torus_b.inner_radius = 0.85
		torus_b.outer_radius = 0.90
		ring.mesh = torus_b
		ring.position.y = 0.03
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var ring_color = Color(0.95, 0.3, 0.3, 0.85) if team == TeamDefinitions.Team.DIRE else Color(0.92, 0.96, 1.0, 0.85)
		ring_mat.albedo_color = ring_color
		ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		ring.material_override = ring_mat
		sera_visual_root.add_child(ring)
	else:
		sera_visual_root = get_node_or_null("SeraVisual")

func _apply_def() -> void:
	var def = DefScript.create_resource()
	_apply_hero_resource(def)
	hero_resource = def

func _apply_karmic_flow_passive(target: BaseCombatEntity) -> void:
	if target != null and target.attribute_system != null:
		target.attribute_system.remove_modifiers_by_source("sera_karmic_as")
		target.attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ATTACK_SPEED, StatModifier.Type.PERCENT_ADD, 0.15, "sera_karmic_as", 3.0))

# --- Q: THREAD OF FATE ---

func cast_sera_q(target: BaseCombatEntity) -> DamageResult:
	if target == null or not is_instance_valid(target) or not target.is_alive():
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1) if ability_container != null else 1
	var base_dmg = q_res.get_base_damage(lvl) if q_res != null else 75.0
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) if attribute_system != null else 0.0
	var total_dmg = base_dmg + (ap * 0.65)
	
	if is_enemy_with(target):
		var req = DamageRequest.create_spell_damage(self, target, total_dmg, DamageRequest.DamageType.MAGICAL, "Thread of Fate")
		var res = CombatCalculator.execute_damage(req)
		if target.effect_container != null:
			var slow = StatusEffect.new("sera_slow", StatusEffect.EffectType.SLOW, 2.0, 0.35)
			slow.source_entity = self
			target.effect_container.apply_effect(slow)
		return res
	else:
		_apply_karmic_flow_passive(target)
		if target.attribute_system != null:
			target.attribute_system.remove_modifiers_by_source("sera_fate_ms")
			target.attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.25, "sera_fate_ms", 2.5))
		return null

# --- W: ASTRAL WARD ---

func cast_sera_w(target: BaseCombatEntity) -> bool:
	var ally = target if target != null else self
	if not is_instance_valid(ally) or not ally.is_alive():
		return false
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1) if ability_container != null else 1
	var base_shield = w_res.get_base_damage(lvl) if w_res != null else 100.0
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) if attribute_system != null else 0.0
	var total_shield = base_shield + (ap * 0.60)
	
	if ally.effect_container != null:
		var shield = StatusEffect.new("sera_astral_shield", StatusEffect.EffectType.SHIELD, 3.5, total_shield)
		shield.source_entity = self
		ally.effect_container.apply_effect(shield)
		_apply_karmic_flow_passive(ally)
		
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("SERA: YILDIZ KALKANI UYGULANDI (+%d Kalkan)" % int(total_shield))
	return true

# --- E: PURIFY (CLEANSE & HEAL) ---

func cast_sera_e(target: BaseCombatEntity) -> bool:
	var ally = target if target != null else self
	if not is_instance_valid(ally) or not ally.is_alive():
		return false
		
	# Cleanse all CC debuffs
	if ally.effect_container != null:
		var to_cleanse: Array[String] = []
		for eff in ally.effect_container.active_effects:
			if eff.effect_type in [StatusEffect.EffectType.STUN, StatusEffect.EffectType.SILENCE, StatusEffect.EffectType.SLOW, StatusEffect.EffectType.ROOT, StatusEffect.EffectType.DAMAGE_OVER_TIME]:
				to_cleanse.append(eff.effect_id)
		for c_id in to_cleanse:
			ally.effect_container.remove_effect_by_id(c_id)
			
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1) if ability_container != null else 1
	var base_heal = e_res.get_base_damage(lvl) if e_res != null else 80.0
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) if attribute_system != null else 0.0
	var total_heal = base_heal + (ap * 0.50)
	
	if ally.attribute_system != null:
		ally.attribute_system.heal(total_heal)
		_apply_karmic_flow_passive(ally)
		
	ally_purified.emit(ally)
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("SERA: ARINDIRMA (PURIFY)! (Kitle Kontrolleri Temizlendi +%d Can)" % int(total_heal))
	return true

# --- R: ASTRAL SURGE (MASS CLEANSE & MOMENTUM ULTIMATE) ---

func cast_sera_r() -> bool:
	var my_pos = global_position if is_inside_tree() else position
	
	# Spawn Astral Surge Shockwave VFX
	if is_inside_tree():
		var surge_script = load("res://scenes/effects/sera_astral_surge_3d.gd")
		if surge_script != null:
			var surge = surge_script.new()
			get_tree().root.add_child(surge)
			surge.global_position = my_pos
			
	var allies: Array = []
	if is_inside_tree() and get_tree() != null:
		allies = get_tree().get_nodes_in_group("combat_entities")
	else:
		allies.append_array(HeroEntity.active_heroes)
		
	for a in allies:
		if a is BaseCombatEntity and is_instance_valid(a) and a.is_alive() and not is_enemy_with(a):
			var a_pos = a.global_position if a.is_inside_tree() else a.position
			if my_pos.distance_to(a_pos) <= 8.0:
				# Mass Cleanse
				if a.effect_container != null:
					var to_cleanse: Array[String] = []
					for eff in a.effect_container.active_effects:
						if eff.effect_type in [StatusEffect.EffectType.STUN, StatusEffect.EffectType.SILENCE, StatusEffect.EffectType.SLOW, StatusEffect.EffectType.ROOT]:
							to_cleanse.append(eff.effect_id)
					for c_id in to_cleanse:
						a.effect_container.remove_effect_by_id(c_id)
						
				# Grant +45% MS Momentum Buff for 3.5s
				if a.attribute_system != null:
					a.attribute_system.remove_modifiers_by_source("sera_surge_ms")
					a.attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.45, "sera_surge_ms", 3.5))
					_apply_karmic_flow_passive(a)
					
	astral_surge_activated.emit()
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("SERA: YILDIZ DALGASI (ASTRAL SURGE) PATLADI! (Tüm Takım Arındırıldı +%%45 Hız)")
	return true
