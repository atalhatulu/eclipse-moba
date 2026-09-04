class_name VeylinHero
extends HeroEntity

## Implementation of Veylin (The Spell Mimic / INT Arcane Adaptation Mage)

signal study_stack_changed(new_stacks: int)
signal spell_countered()
signal spell_rewritten()
signal adaptation_unleashed(target_pos: Vector3, enemies_hit: int)

var study_stacks: int = 0
const MAX_STUDY_STACKS: int = 5
const AP_PER_STUDY_STACK: float = 8.0

var is_rewrite_buff_active: bool = false

func _ready() -> void:
	entity_name = "Veylin"
	hero_resource = VeylinDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_veylin_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.46
		shape.height = 1.80
		col.shape = shape
		col.position.y = 0.90
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("VeylinVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "VeylinVisual"
		add_child(root_vis)
		
		# Mimic Mage Indigo Robes (1.80m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.42
		body_capsule.height = 1.80
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.90
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.25, 0.2, 0.55, 1.0) # Deep Mimic Indigo
		mat.roughness = 0.35
		body_inst.material_override = mat
		root_vis.add_child(body_inst)
		
		# Prismatic Floating Spell Tome
		var book = MeshInstance3D.new()
		var box = BoxMesh.new()
		box.size = Vector3(0.35, 0.08, 0.45)
		book.mesh = box
		book.position = Vector3(0.5, 1.2, 0.3)
		var book_mat = StandardMaterial3D.new()
		book_mat.albedo_color = Color(0.8, 0.3, 0.9, 1.0) # Arcane Prismatic
		book_mat.emission_enabled = true
		book_mat.emission = Color(0.8, 0.3, 0.9)
		book.material_override = book_mat
		root_vis.add_child(book)

func _apply_veylin_definition() -> void:
	if hero_resource == null:
		hero_resource = VeylinDefinition.create_resource()
		
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

# --- PASSIVE: STUDY ENGINE ---

func add_study_stack(amount: int = 1) -> int:
	study_stacks = clampi(study_stacks + amount, 0, MAX_STUDY_STACKS)
	_sync_study_buff()
	study_stack_changed.emit(study_stacks)
	return study_stacks

func _sync_study_buff() -> void:
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("veylin_study_ap")
		if study_stacks > 0:
			var bonus_ap = float(study_stacks) * AP_PER_STUDY_STACK
			var mod = StatModifier.new(StatModifier.TargetStat.ABILITY_POWER, StatModifier.Type.FLAT, bonus_ap, "veylin_study_ap")
			attribute_system.add_modifier(mod)

# --- Q: MIMIC (ADAPTIVE BOLT) ---

func cast_veylin_q(target: BaseCombatEntity) -> DamageResult:
	if target == null or not is_instance_valid(target) or not target.is_alive() or not is_enemy_with(target):
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1) if ability_container != null else 1
	var base_dmg = q_res.get_base_damage(lvl) if q_res != null else 80.0
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) if attribute_system != null else 0.0
	
	# Stacks amplify Q damage by +10% per stack
	var stack_amp = 1.0 + (float(study_stacks) * 0.10)
	var rewrite_bonus = 1.30 if is_rewrite_buff_active else 1.0
	is_rewrite_buff_active = false
	
	var total_dmg = (base_dmg + (ap * 0.60)) * stack_amp * rewrite_bonus
	
	add_study_stack(1) # Gain study on spell cast
	
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.MAGICAL, "Mimic Bolt")
	var res = CombatCalculator.execute_damage(req)
	
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("VEYLIN: TAKLİT OKU VURDU (%d Hasar)" % int(total_dmg))
	return res

# --- W: COUNTERSPELL (SPELL BARRIER) ---

func cast_veylin_w() -> bool:
	# Spawn 3D Counterspell Barrier VFX
	if is_inside_tree():
		var barrier_script = load("res://scenes/effects/veylin_counterspell_barrier_3d.gd")
		if barrier_script != null:
			var barrier = barrier_script.new()
			add_child(barrier)
			barrier.position = Vector3.ZERO
			
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1) if ability_container != null else 1
	var base_shield = w_res.get_base_damage(lvl) if w_res != null else 150.0
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) if attribute_system != null else 0.0
	var shield_amt = base_shield + (ap * 0.50)
	
	if effect_container != null:
		var shield_eff = StatusEffect.new("veylin_counterspell_shield", StatusEffect.EffectType.SHIELD, 2.0, shield_amt)
		shield_eff.source_entity = self
		effect_container.apply_effect(shield_eff)
		
	add_study_stack(2) # Counterspell adds 2 study stacks
	spell_countered.emit()
	
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("VEYLIN: BÜYÜ BOZMA KALKANI AÇILDI (+%d Kalkan, +2 İnceleme Yükü)" % int(shield_amt))
	return true

# --- E: REWRITE (MATRIX TRANSMUTATION) ---

func cast_veylin_e() -> bool:
	# Reset Q cooldown
	if ability_container != null:
		ability_container.cooldown_timers[AbilityResource.Slot.Q] = 0.0
	is_rewrite_buff_active = true
	
	spell_rewritten.emit()
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("VEYLIN: BÜYÜ DÖNÜŞÜMÜ! (Q Bekleme Süresi Sıfırlandı +%%30 Güç)")
	return true

# --- R: ADAPTATION (ARCANE SURGE - ULTIMATE) ---

func cast_veylin_r(target_pos: Vector3, enemies: Array = []) -> Array[DamageResult]:
	var my_pos = global_position if is_inside_tree() else position
	
	# Spawn 3D Arcane Surge Cone VFX
	if is_inside_tree():
		var cone_script = load("res://scenes/effects/veylin_adaptation_cone_3d.gd")
		if cone_script != null:
			var cone = cone_script.new()
			get_tree().root.add_child(cone)
			cone.global_position = my_pos
			
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null) if ability_container != null else null
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1) if ability_container != null else 1
	var base_dmg = r_res.get_base_damage(lvl) if r_res != null else 220.0
	var ap = attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) if attribute_system != null else 0.0
	var total_dmg = base_dmg + (ap * 0.85)
	
	# Grant self buffs: +30% Spell Vamp & +25% Move Speed for 6s
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("veylin_adaptation_buff")
		var sv_mod = StatModifier.new(StatModifier.TargetStat.SPELL_VAMP, StatModifier.Type.FLAT, 0.30, "veylin_adaptation_buff", 6.0)
		var ms_mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.25, "veylin_adaptation_buff", 6.0)
		attribute_system.add_modifier(sv_mod)
		attribute_system.add_modifier(ms_mod)
		
	var results: Array[DamageResult] = []
	var targets: Array = []
	if is_inside_tree() and get_tree() != null:
		targets = get_tree().get_nodes_in_group("combat_entities")
	else:
		targets.append_array(HeroEntity.active_heroes)
		
	for e in targets:
		if e is BaseCombatEntity and e != self and is_instance_valid(e) and e.is_alive() and is_enemy_with(e) and e.is_targetable:
			var e_pos = e.global_position if e.is_inside_tree() else e.position
			if my_pos.distance_to(e_pos) <= 7.0:
				var req = DamageRequest.create_ability_damage(self, e, total_dmg, DamageRequest.DamageType.MAGICAL, "Adaptation")
				var res = CombatCalculator.execute_damage(req)
				results.append(res)
				
	study_stacks = MAX_STUDY_STACKS
	_sync_study_buff()
	
	adaptation_unleashed.emit(target_pos, results.size())
	if Engine.has_singleton("GameEvents"):
		Engine.get_singleton("GameEvents").combat_log_generated.emit("VEYLIN: NİHAİ UYUMLANMA PATLADI! (%d Düşman Vuruldu +%%30 Büyü Vampiri)" % results.size())
	return results

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	study_stacks = 0
	is_rewrite_buff_active = false
	_sync_study_buff()

func respawn() -> void:
	super.respawn()
	study_stacks = 0
	is_rewrite_buff_active = false
	_sync_study_buff()
