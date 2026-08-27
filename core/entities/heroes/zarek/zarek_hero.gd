class_name ZarekHero
extends HeroEntity

## Implementation of Zarek (AGI Anti-Mage / Mana Hunter & Null Field)

signal mana_burned(target: BaseCombatEntity, amount_burned: float, bonus_damage: float)
signal drain_edge_struck(target: BaseCombatEntity, mana_drained: float)
signal phase_cut_executed(target: BaseCombatEntity)
signal silence_mark_applied(target: BaseCombatEntity, duration: float)
signal null_field_activated(position: Vector3, radius: float)

# State
var null_field_active: bool = false
var null_field_pos: Vector3 = Vector3.ZERO
var null_field_timer: float = 0.0
const NULL_FIELD_RADIUS: float = 6.0

func _ready() -> void:
	entity_name = "Zarek"
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_zarek_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.50
		shape.height = 2.0
		col.shape = shape
		col.position.y = 1.0
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("ZarekVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "ZarekVisual"
		add_child(root_vis)
		
		# Anti-Mage Void Assassin Body
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.45
		body_capsule.height = 2.0
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.0
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.12, 0.08, 0.22, 1.0) # Deep Void Purple
		body_mat.metallic = 0.8
		body_mat.roughness = 0.3
		body_mat.emission_enabled = true
		body_mat.emission = Color(0.65, 0.15, 0.95, 1.0)
		body_mat.emission_energy_multiplier = 1.2
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
		# Mana-Cleaving Curved Blades on wrists
		for side in [-0.55, 0.55]:
			var blade = MeshInstance3D.new()
			var b_box = BoxMesh.new()
			b_box.size = Vector3(0.08, 0.75, 0.22)
			blade.mesh = b_box
			blade.position = Vector3(side, 0.90, 0.25)
			
			var b_mat = StandardMaterial3D.new()
			b_mat.albedo_color = Color(0.85, 0.25, 1.0, 1.0)
			b_mat.emission_enabled = true
			b_mat.emission = Color(0.85, 0.25, 1.0, 1.0)
			b_mat.emission_energy_multiplier = 1.5
			blade.material_override = b_mat
			root_vis.add_child(blade)
			
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

func _apply_zarek_definition() -> void:
	if hero_resource == null:
		hero_resource = ZarekDefinition.create_resource()
		
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
	_process_null_field(delta)

# --- PASSIVE: MANA HUNTER ---

func execute_basic_attack(target: BaseCombatEntity) -> DamageResult:
	var res = super.execute_basic_attack(target)
	if res != null and target != null and is_instance_valid(target) and target.is_alive():
		_apply_mana_burn(target)
	return res

func _apply_mana_burn(target: BaseCombatEntity) -> void:
	if target.attribute_system != null and target.attribute_system.current_mana > 0.0:
		var burn_amt = maxf(20.0, target.attribute_system.current_mana * 0.06)
		target.attribute_system.spend_mana(burn_amt)
		
		# Bonus magical damage from mana burn
		var req = DamageRequest.create_ability_damage(self, target, burn_amt * 0.80, DamageRequest.DamageType.MAGICAL, "Mana Hunter")
		CombatCalculator.execute_damage(req)
		mana_burned.emit(target, burn_amt, burn_amt * 0.80)

# --- Q: DRAIN EDGE ---

func cast_zarek_q(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * q_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.Q, target):
		return null
		
	var drain_mana_amount = 50.0 + (lvl * 25.0)
	if target.attribute_system != null:
		var actual_drained = minf(target.attribute_system.current_mana, drain_mana_amount)
		target.attribute_system.spend_mana(actual_drained)
		attribute_system.restore_mana(actual_drained)
		drain_edge_struck.emit(target, actual_drained)
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Drain Edge")
	return CombatCalculator.execute_damage(req)

# --- W: PHASE CUT ---

func cast_zarek_w(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.W, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var base_dmg = w_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * w_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.W, target):
		return null
		
	# Blink behind target
	var behind_offset = Vector3(0, 0, 1.5)
	if target.is_inside_tree() and is_inside_tree():
		global_position = target.global_position + behind_offset
	else:
		position = target.position + behind_offset
		
	phase_cut_executed.emit(target)
	
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Phase Cut")
	return CombatCalculator.execute_damage(req)

# --- E: SILENCE MARK ---

func cast_zarek_e(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.E, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var base_dmg = e_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * e_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.E, target):
		return null
		
	# Apply Silence Status Effect (2.0s)
	if target.effect_container != null:
		var sil = StatusEffect.new("zarek_silence", StatusEffect.EffectType.SILENCE, 2.0)
		target.effect_container.apply_effect(sil)
		
	silence_mark_applied.emit(target, 2.0)
	
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.MAGICAL, "Silence Mark")
	return CombatCalculator.execute_damage(req)

# --- R: NULL FIELD (ULTIMATE) ---

func cast_zarek_r(target_pos: Vector3, enemies_in_field: Array[BaseCombatEntity] = []) -> bool:
	if not can_cast():
		return false
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast(AbilityResource.Slot.R):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return false
		
	null_field_active = true
	null_field_pos = target_pos
	null_field_timer = 6.0
	
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	
	for enemy in enemies_in_field:
		if enemy != null and is_instance_valid(enemy) and enemy.is_alive() and enemy.team != team:
			var missing_mana = 0.0
			if enemy.attribute_system != null:
				var max_mp = enemy.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
				missing_mana = maxf(0.0, max_mp - enemy.attribute_system.current_mana)
				
			var total_dmg = base_dmg + (missing_mana * 0.40) # Bonus damage based on missing mana
			var req = DamageRequest.create_ability_damage(self, enemy, total_dmg, DamageRequest.DamageType.MAGICAL, "Null Field")
			CombatCalculator.execute_damage(req)
			
	null_field_activated.emit(target_pos, NULL_FIELD_RADIUS)
	return true

func _process_null_field(delta: float) -> void:
	if null_field_active:
		null_field_timer -= delta
		if null_field_timer <= 0.0:
			null_field_active = false

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	null_field_active = false
	null_field_timer = 0.0

func respawn() -> void:
	super.respawn()
	null_field_active = false
	null_field_timer = 0.0
