class_name AstrisHero
extends HeroEntity

const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")

## Implementation of Astris (The Temporal Weaver / INT Mage)
## Weaves time and mana: Arcane Bolt, Temporal Stasis, Mana Barrier, and Astral Rupture.

signal arcane_bolt_fired(target: BaseCombatEntity, damage: float)
signal temporal_stasis_triggered(center_pos: Vector3, enemies_trapped: int)
signal mana_barrier_activated(shield_amount: float)
signal astral_rupture_detonated(center_pos: Vector3, enemies_hit: int)

var astris_visual_root: Node3D = null
var temporal_crystals: Array[MeshInstance3D] = []
var crystal_float_timer: float = 0.0

var is_overcharged: bool = false
var overcharge_bonus_ap_ratio: float = 0.25

func _ready() -> void:
	entity_name = "Astris"
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
		astris_visual_root = Node3D.new()
		astris_visual_root.name = "AstrisVisual"
		add_child(astris_visual_root)
		
		# Arcane Robed Body
		var mesh_inst = MeshInstance3D.new()
		var cyl = CylinderMesh.new()
		cyl.top_radius = 0.42
		cyl.bottom_radius = 0.62
		cyl.height = 1.95
		mesh_inst.mesh = cyl
		mesh_inst.position.y = 0.98
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.25, 0.40, 0.90, 1.0) # Deep Arcane Blue
		mat.emission_enabled = true
		mat.emission = Color(0.18, 0.35, 0.85, 1.0)
		mat.emission_energy_multiplier = 0.9
		mesh_inst.material_override = mat
		astris_visual_root.add_child(mesh_inst)
		
		# 3 Floating Temporal Chrono-Crystals
		temporal_crystals.clear()
		for i in range(3):
			var crystal = MeshInstance3D.new()
			var prism = PrismMesh.new()
			prism.size = Vector3(0.20, 0.45, 0.20)
			crystal.mesh = prism
			
			var c_mat = StandardMaterial3D.new()
			c_mat.albedo_color = Color(0.65, 0.85, 1.0, 1.0)
			c_mat.emission_enabled = true
			c_mat.emission = Color(0.4, 0.8, 1.0)
			c_mat.emission_energy_multiplier = 2.5
			crystal.material_override = c_mat
			astris_visual_root.add_child(crystal)
			temporal_crystals.append(crystal)
	else:
		astris_visual_root = get_node_or_null("AstrisVisual")

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_update_passive_overcharge_check()
	_update_floating_crystals(delta)

func _update_floating_crystals(delta: float) -> void:
	crystal_float_timer += delta * 2.5
	for i in range(temporal_crystals.size()):
		var c = temporal_crystals[i]
		if c != null and is_instance_valid(c):
			var angle = crystal_float_timer + (i * TAU / 3.0)
			c.position = Vector3(cos(angle) * 0.75, 1.85 + sin(crystal_float_timer * 2.0 + i) * 0.12, sin(angle) * 0.75)
			c.rotation_degrees.y += delta * 60.0

func _apply_passive_mana_affinity() -> void:
	if attribute_system == null:
		return
	attribute_system.remove_modifiers_by_source("astris_mana_affinity")
	var max_mp = attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
	if max_mp > 0.0 and (attribute_system.current_mana / max_mp) >= 0.50:
		var pen_mod = StatModifier.new(StatModifier.TargetStat.MAGIC_PEN_PERCENT, StatModifier.Type.FLAT, 0.15, "astris_mana_affinity")
		attribute_system.add_modifier(pen_mod)

func _update_passive_overcharge_check() -> void:
	_apply_passive_mana_affinity()

# --- Q: ARCANE BOLT (SINGLE TARGET BURST) ---
func cast_astris_q(target: BaseCombatEntity, _target_pos: Vector3 = Vector3.ZERO) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or target.team == team:
		return false
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, target):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var bonus_mult = 1.25 if is_overcharged else 1.0
	var total_dmg = (base_dmg + (ap * q_res.scaling_ratio)) * bonus_mult
	
	if is_overcharged:
		is_overcharged = false
		attribute_system.restore_mana(25.0)
	else:
		is_overcharged = true
		
	if not ability_container.cast_ability(AbilityResource.Slot.Q, target):
		return false
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.MAGICAL, "Arcane Bolt")
	CombatCalculator.execute_damage(req)
	
	arcane_bolt_fired.emit(target, total_dmg)
	return true

# --- W: TEMPORAL STASIS (GROUND AOE ROOT + TIME LOCK) ---
func cast_astris_w(center_pos: Vector3 = Vector3.ZERO) -> bool:
	if not can_cast():
		return false
	var pos = center_pos if center_pos != Vector3.ZERO else (global_position if is_inside_tree() else position)
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.W, null, pos):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var base_dmg = w_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var total_dmg = base_dmg + (ap * w_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.W, null, pos):
		return false
		
	var trapped_count := 0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if pos.distance_to(entity.global_position) <= 4.5:
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg, DamageRequest.DamageType.MAGICAL, "Temporal Stasis")
					CombatCalculator.execute_damage(req)
					if "effect_container" in entity and entity.effect_container != null:
						entity.effect_container.apply_root(1.8)
						entity.effect_container.apply_slow(0.50, 3.0)
					trapped_count += 1
					
	temporal_stasis_triggered.emit(pos, trapped_count)
	return true

# --- E: MANA BARRIER (SELF SHIELD + SPEED SURGE) ---
func cast_astris_e() -> bool:
	if not can_cast():
		return false
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var max_mp = attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
	var shield_val = 120.0 + (lvl * 50.0) + (ap * 0.50) + (max_mp * 0.12)
	
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return false
		
	CombatMechanicsClass.apply_shield(self, self, "astris_mana_barrier", "Mana Kalkanı", shield_val, 4.0)
	if effect_container != null:
		var speed_buff = StatusEffect.new("astris_chrono_haste", StatusEffect.EffectType.STAT_MODIFIER, 3.0, 45.0, false)
		speed_buff.target_stat = StatModifier.TargetStat.MOVE_SPEED
		speed_buff.stat_mod_type = StatModifier.Type.FLAT
		effect_container.apply_effect(speed_buff)
		
	mana_barrier_activated.emit(shield_val)
	return true

# --- R: ASTRAL RUPTURE (GROUND AOE EXECUTE DETONATION) ---
func cast_astris_r(center_pos: Vector3 = Vector3.ZERO) -> bool:
	if not can_cast():
		return false
	var pos = center_pos if center_pos != Vector3.ZERO else (global_position if is_inside_tree() else position)
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.R, null, pos):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var total_dmg = base_dmg + (ap * r_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.R, null, pos):
		return false
		
	var hit_count := 0
	if is_inside_tree():
		for entity in get_tree().get_nodes_in_group("combat_entities"):
			if entity is BaseCombatEntity and is_instance_valid(entity) and entity.is_alive() and entity.team != team:
				if pos.distance_to(entity.global_position) <= 6.0:
					# Deal damage amplified by target missing health
					var hp_ratio = 1.0
					if entity.attribute_system != null:
						var max_h = entity.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
						if max_h > 0.0:
							hp_ratio = clampf(entity.attribute_system.current_health / max_h, 0.1, 1.0)
					var missing_mult = 1.0 + (1.0 - hp_ratio) * 0.60
					var req = DamageRequest.create_ability_damage(self, entity, total_dmg * missing_mult, DamageRequest.DamageType.MAGICAL, "Astral Rupture")
					CombatCalculator.execute_damage(req)
					if "effect_container" in entity and entity.effect_container != null:
						entity.effect_container.apply_slow(0.55, 3.5)
					hit_count += 1
					
	astral_rupture_detonated.emit(pos, hit_count)
	return true
