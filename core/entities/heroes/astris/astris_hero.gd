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
func cast_astris_q(target: BaseCombatEntity, target_pos: Vector3 = Vector3.ZERO) -> bool:
	if not can_cast():
		return false
		
	if is_overcharged:
		is_overcharged = false
		attribute_system.restore_mana(20.0)
	else:
		is_overcharged = true
		
	return ability_container.cast_ability(AbilityResource.Slot.Q, target, target_pos)

# --- W: TEMPORAL STASIS (AOE ROOT + DAMAGE) ---
func cast_astris_w(targets: Array[BaseCombatEntity] = [], center_pos: Vector3 = Vector3.ZERO) -> bool:
	if not can_cast():
		return false
	var pos = center_pos if center_pos != Vector3.ZERO else (global_position if is_inside_tree() else position)
	return ability_container.cast_ability(AbilityResource.Slot.W, null, pos)

# --- E: MANA BARRIER (MANA-SCALED SHIELD + MS BUFF) ---
func cast_astris_e() -> bool:
	if not can_cast():
		return false
	return ability_container.cast_ability(AbilityResource.Slot.E)

# --- R: ASTRAL RUPTURE (EXECUTE AOE + SLOW) ---
func cast_astris_r(targets: Array[BaseCombatEntity] = [], center_pos: Vector3 = Vector3.ZERO) -> bool:
	if not can_cast():
		return false
	var pos = center_pos if center_pos != Vector3.ZERO else (global_position if is_inside_tree() else position)
	return ability_container.cast_ability(AbilityResource.Slot.R, null, pos)
