class_name AstrisHero
extends HeroEntity

## Astris - Ranged Intelligence Mage & Temporal Weaver

var is_overcharged: bool = false
var overcharge_bonus_ap_ratio: float = 0.25

func _ready() -> void:
	hero_resource = AstrisDefinition.create_astris_resource()
	super._ready()
	_setup_collision()
	_create_astris_visual()
	_apply_passive_mana_affinity()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.55
		shape.height = 2.0
		col.shape = shape
		col.position.y = 1.0
		add_child(col)

func _create_astris_visual() -> void:
	if not has_node("AstrisVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "AstrisVisual"
		add_child(root_vis)
		
		var mesh_inst = MeshInstance3D.new()
		var cyl = CylinderMesh.new()
		cyl.top_radius = 0.45
		cyl.bottom_radius = 0.65
		cyl.height = 2.0
		mesh_inst.mesh = cyl
		mesh_inst.position.y = 1.0
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.3, 0.45, 0.95, 1.0) # Arcane Blue
		mat.emission_enabled = true
		mat.emission = Color(0.15, 0.3, 0.8, 1.0)
		mat.emission_energy_multiplier = 0.8
		mesh_inst.material_override = mat
		root_vis.add_child(mesh_inst)
		
		# Selection Ring (Thin crisp white/cyan ring, kulevehero.png reference)
		var ring = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.90
		torus.outer_radius = 0.95
		ring.mesh = torus
		ring.position.y = 0.03
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var ring_color = Color(0.92, 0.96, 1.0, 0.85) if team == TeamDefinitions.Team.RADIANT else Color(0.95, 0.3, 0.3, 0.85)
		ring_mat.albedo_color = ring_color
		ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		ring.material_override = ring_mat
		root_vis.add_child(ring)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_update_passive_overcharge_check()

func _apply_passive_mana_affinity() -> void:
	# Passive bonus: High mana (>50%) grants +15% Magic Penetration
	attribute_system.remove_modifiers_by_source("astris_mana_affinity")
	var max_mp = attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
	if max_mp > 0.0 and (attribute_system.current_mana / max_mp) >= 0.50:
		var pen_mod = StatModifier.new(StatModifier.TargetStat.MAGIC_PEN_PERCENT, StatModifier.Type.FLAT, 0.15, "astris_mana_affinity")
		attribute_system.add_modifier(pen_mod)

func _update_passive_overcharge_check() -> void:
	_apply_passive_mana_affinity()

# --- Q: ARCANE BOLT ---
func cast_astris_q(target: BaseCombatEntity, target_pos: Vector3 = Vector3.ZERO) -> DamageResult:
	if not can_cast():
		return null
		
	var success = ability_container.cast_ability(AbilityResource.Slot.Q)
	if not success:
		return null
		
	var q_res = ability_container.get_ability(AbilityResource.Slot.Q)
	var q_lvl = ability_container.get_ability_level(AbilityResource.Slot.Q)
	var base_dmg = q_res.get_base_damage(q_lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var total_dmg = base_dmg + (ap * q_res.scaling_ratio)
	
	if is_overcharged:
		total_dmg += (ap * overcharge_bonus_ap_ratio)
		is_overcharged = false
		attribute_system.restore_mana(20.0)
	else:
		is_overcharged = true
		
	if target != null and is_instance_valid(target) and target.is_alive():
		var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.MAGICAL, "Arcane Bolt")
		req.magic_pen_percent = attribute_system.get_stat(StatModifier.TargetStat.MAGIC_PEN_PERCENT)
		
		# Spawn glowing 3D homing missile
		var proj = BasicAttackProjectile3D.new()
		if get_parent() != null:
			get_parent().add_child(proj)
			proj.setup(self, target, req, Color(0.2, 0.7, 1.0), 38.0, 0.4, global_position + Vector3(0, 1.3, 0))
		else:
			return target.receive_damage(req)
	else:
		# Ground burst at cursor position
		var burst_pos = target_pos if target_pos != Vector3.ZERO else (global_position - global_transform.basis.z * 6.0)
		SpellVisualFX3D.spawn_arcane_burst(get_parent(), burst_pos, 2.5, Color(0.2, 0.7, 1.0))
		
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("ASTRIS: ARCANE BOLT (Q) FIRLATILDI")
	return null

# --- W: TEMPORAL STASIS (AOE ROOT + DAMAGE) ---
func cast_astris_w(targets: Array[BaseCombatEntity], center_pos: Vector3 = Vector3.ZERO) -> Array[DamageResult]:
	var results: Array[DamageResult] = []
	if not can_cast():
		return results
		
	var success = ability_container.cast_ability(AbilityResource.Slot.W)
	if not success:
		return results
		
	var w_res = ability_container.get_ability(AbilityResource.Slot.W)
	var w_lvl = ability_container.get_ability_level(AbilityResource.Slot.W)
	var base_dmg = w_res.get_base_damage(w_lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var total_dmg = base_dmg + (ap * w_res.scaling_ratio)
	
	var fx_pos = center_pos if center_pos != Vector3.ZERO else global_position
	SpellVisualFX3D.spawn_arcane_burst(get_parent(), fx_pos, 6.0, Color(0.1, 0.85, 0.95))
	
	for target in targets:
		if target != null and is_instance_valid(target) and target.is_alive() and is_enemy_with(target):
			var root_effect = StatusEffect.new("astris_stasis_root", StatusEffect.EffectType.ROOT, 1.5)
			target.effect_container.apply_effect(root_effect)
			
			var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.MAGICAL, "Temporal Stasis")
			req.magic_pen_percent = attribute_system.get_stat(StatModifier.TargetStat.MAGIC_PEN_PERCENT)
			var res = CombatCalculator.execute_damage(req)
			results.append(res)
			
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("ASTRIS: TEMPORAL STASIS (W) ALANI DONDURDU")
	is_overcharged = true
	return results

# --- E: MANA BARRIER (SELF SHIELD + SPEED) ---
func cast_astris_e() -> bool:
	if not can_cast():
		return false
		
	var success = ability_container.cast_ability(AbilityResource.Slot.E)
	if not success:
		return false
		
	var e_lvl = ability_container.get_ability_level(AbilityResource.Slot.E)
	var base_shield = 120.0 + (float(e_lvl - 1) * 80.0)
	var max_mp = attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
	var total_shield = base_shield + (max_mp * 0.20)
	
	var shield_effect = StatusEffect.new("mana_barrier_shield", StatusEffect.EffectType.SHIELD, 4.0, total_shield, false)
	effect_container.apply_effect(shield_effect)
	
	# Spawn 3D shield bubble around hero
	SpellVisualFX3D.spawn_shield_bubble(self, 4.0, Color(0.3, 0.75, 1.0, 0.45))
	
	var speed_mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.25, "astris_barrier_speed")
	attribute_system.add_modifier(speed_mod)
	
	if get_tree() != null:
		get_tree().create_timer(4.0).timeout.connect(func():
			if is_instance_valid(self) and attribute_system != null:
				attribute_system.remove_modifiers_by_source("astris_barrier_speed")
		)
		
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("ASTRIS: MANA KALKANI (E) AÇILDI (+%.0f Kalkan)" % total_shield)
	is_overcharged = true
	return true

# --- R: ASTRAL RUPTURE (MASSIVE AOE BURST + SLOW) ---
func cast_astris_r(targets: Array[BaseCombatEntity], center_pos: Vector3 = Vector3.ZERO) -> Array[DamageResult]:
	var results: Array[DamageResult] = []
	if not can_cast():
		return results
		
	var success = ability_container.cast_ability(AbilityResource.Slot.R)
	if not success:
		return results
		
	var r_res = ability_container.get_ability(AbilityResource.Slot.R)
	var r_lvl = ability_container.get_ability_level(AbilityResource.Slot.R)
	var base_dmg = r_res.get_base_damage(r_lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	
	var fx_pos = center_pos if center_pos != Vector3.ZERO else global_position
	SpellVisualFX3D.spawn_orbital_starfall(get_parent(), fx_pos, 8.0, Color(0.65, 0.35, 1.0))
	
	for target in targets:
		if target != null and is_instance_valid(target) and target.is_alive() and is_enemy_with(target):
			var max_hp = target.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
			var missing_hp = maxf(0.0, max_hp - target.attribute_system.current_health)
			var total_dmg = base_dmg + (ap * 1.0) + (missing_hp * 0.15)
			
			var slow_effect = StatusEffect.new("astris_astral_slow", StatusEffect.EffectType.SLOW, 2.5, 0.50)
			target.effect_container.apply_effect(slow_effect)
			
			var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.MAGICAL, "Astral Rupture")
			req.magic_pen_percent = attribute_system.get_stat(StatModifier.TargetStat.MAGIC_PEN_PERCENT)
			var res = CombatCalculator.execute_damage(req)
			results.append(res)
			
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("ASTRIS: ASTRAL RUPTURE (R) GÖK PATLAMASI GERÇEKLEŞTİ")
	is_overcharged = true
	return results
