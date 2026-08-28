class_name MoraHero
extends HeroEntity

## Implementation of Mora (The Life Weaver / STR Martyr Guardian)

signal life_reserve_updated(current_reserve: float, max_reserve: float)
signal restore_applied(target: BaseCombatEntity, total_healed: float)
signal safeguard_applied(target: BaseCombatEntity, shield_amount: float)
signal martyr_transfer_executed(sacrificed_hp: float, healed_amount: float, target: BaseCombatEntity)
signal rebirth_field_activated(duration: float)
signal rebirth_field_ended()

# Passive: Life Reserve
var stored_reserve: float = 0.0
const MAX_RESERVE: float = 400.0

# R: Rebirth Field (Death Prevention Aura)
var is_rebirth_field_active: bool = false
var rebirth_field_timer: float = 0.0
const REBIRTH_DURATION: float = 4.5
const REBIRTH_RADIUS: float = 6.0

func _ready() -> void:
	entity_name = "Mora"
	hero_resource = MoraDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_mora_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.55
		shape.height = 2.05
		col.shape = shape
		col.position.y = 1.02
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("MoraVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "MoraVisual"
		add_child(root_vis)
		
		# Paladin/Guardian Heavy Armor Body (2.05m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.52
		body_capsule.height = 2.05
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.02
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.85, 0.70, 0.30, 1.0) # Golden Martyr Armor
		mat.metallic = 0.65
		mat.roughness = 0.30
		body_inst.material_override = mat
		root_vis.add_child(body_inst)
		
		# Tower Shield on Left Arm
		var shield = MeshInstance3D.new()
		var s_box = BoxMesh.new()
		s_box.size = Vector3(0.18, 1.4, 0.65)
		shield.mesh = s_box
		shield.position = Vector3(-0.65, 1.1, 0.3)
		
		var s_mat = StandardMaterial3D.new()
		s_mat.albedo_color = Color(0.95, 0.85, 0.45, 1.0)
		s_mat.emission_enabled = true
		s_mat.emission = Color(0.90, 0.75, 0.20, 1.0)
		s_mat.emission_energy_multiplier = 0.8
		shield.material_override = s_mat
		root_vis.add_child(shield)
		
		# Selection Base Ring
		var ring = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.90
		torus.outer_radius = 0.95
		ring.mesh = torus
		ring.position.y = 0.03
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var ring_color = Color(0.95, 0.3, 0.3, 0.85) if team == TeamDefinitions.Team.DIRE else Color(1.0, 0.8, 0.2, 0.85)
		ring_mat.albedo_color = ring_color
		ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		ring.material_override = ring_mat
		root_vis.add_child(ring)

func _apply_mora_definition() -> void:
	if hero_resource == null:
		hero_resource = MoraDefinition.create_resource()
		
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
	_process_rebirth_field(delta)

# --- PASSIVE: LIFE RESERVE ---

func add_reserve(amount: float) -> void:
	if amount <= 0.0:
		return
	stored_reserve = clampf(stored_reserve + amount, 0.0, MAX_RESERVE)
	_sync_reserve_regen()
	life_reserve_updated.emit(stored_reserve, MAX_RESERVE)

func consume_reserve(amount: float) -> float:
	var consumed = minf(stored_reserve, amount)
	stored_reserve = maxf(0.0, stored_reserve - consumed)
	_sync_reserve_regen()
	life_reserve_updated.emit(stored_reserve, MAX_RESERVE)
	return consumed

func _sync_reserve_regen() -> void:
	if attribute_system == null:
		return
	var bonus_regen = (stored_reserve / 50.0) * 0.50 # +0.5 HP regen per 50 stored
	attribute_system.remove_modifiers_by_source("mora_reserve_regen")
	if bonus_regen > 0.05:
		attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.HEALTH_REGEN, StatModifier.Type.FLAT, bonus_regen, "mora_reserve_regen"))

# --- Q: RESTORE (SOOTHING TOUCH) ---

func cast_mora_q(target: BaseCombatEntity) -> float:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or target.team != team:
		return 0.0
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast(AbilityResource.Slot.Q):
		return 0.0
		
	if not ability_container.cast_ability(AbilityResource.Slot.Q):
		return 0.0
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_heal = q_res.get_base_damage(lvl)
	var max_hp = attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	var total_heal = base_heal + (max_hp * 0.10)
	
	if target.attribute_system != null:
		target.attribute_system.heal(total_heal)
		
	add_reserve(total_heal * 0.25)
	restore_applied.emit(target, total_heal)
	return total_heal

# --- W: SAFEGUARD (AEGIS OF DEVOTION) ---

func cast_mora_w(target: BaseCombatEntity) -> float:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or target.team != team:
		return 0.0
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return 0.0
		
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return 0.0
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var base_shield = 90.0 + (float(lvl - 1) * 70.0) # 90, 160, 230, 300
	var max_hp = attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	var total_shield = base_shield + (max_hp * 0.12)
	
	if target.effect_container != null:
		var shield_eff = StatusEffect.new("mora_safeguard", StatusEffect.EffectType.SHIELD, 4.0, total_shield)
		target.effect_container.apply_effect(shield_eff)
		
	add_reserve(total_shield * 0.20)
	safeguard_applied.emit(target, total_shield)
	return total_shield

# --- E: TRANSFER LIFE (MARTYR'S EXCHANGE) ---

func cast_mora_e(target: BaseCombatEntity) -> float:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or target.team != team or target == self:
		return 0.0
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return 0.0
		
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return 0.0
		
	# Mora sacrifices 12% current HP
	var cur_hp = attribute_system.current_health
	var sacrificed_hp = cur_hp * 0.12
	attribute_system.apply_damage_to_health(sacrificed_hp, "Martyr Sacrifice")
	
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var flat_heal = e_res.get_base_damage(lvl)
	var total_heal = (sacrificed_hp * 1.20) + flat_heal
	
	if target.attribute_system != null:
		target.attribute_system.heal(total_heal)
		
	add_reserve(total_heal * 0.25)
	martyr_transfer_executed.emit(sacrificed_hp, total_heal, target)
	return total_heal

# --- R: REBIRTH FIELD (DEFY DEATH - ULTIMATE) ---

func cast_mora_r() -> bool:
	if not is_alive():
		return false
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null:
		return false
		
	if ability_container.ability_levels.get(AbilityResource.Slot.R, 0) <= 0:
		ability_container.ability_levels[AbilityResource.Slot.R] = 1
		
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return false
		
	is_rebirth_field_active = true
	rebirth_field_timer = REBIRTH_DURATION
	
	_apply_rebirth_aura()
	rebirth_field_activated.emit(REBIRTH_DURATION)
	return true

func _apply_rebirth_aura() -> void:
	var my_pos = global_position if is_inside_tree() else position
	var allies: Array = []
	if is_inside_tree() and get_tree() != null:
		allies = get_tree().get_nodes_in_group("combat_entities")
	else:
		allies.append_array(HeroEntity.active_heroes)
		allies.append_array(CreepEntity.active_creeps)
		
	for a in allies:
		if a is BaseCombatEntity and is_instance_valid(a) and a.is_alive() and a.team == team:
			var a_pos = a.global_position if a.is_inside_tree() else a.position
			if my_pos.distance_to(a_pos) <= REBIRTH_RADIUS:
				# Prevent dropping below 15% Max HP
				if a.attribute_system != null:
					var max_hp = a.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
					var min_hp = max_hp * 0.15
					if a.attribute_system.current_health < min_hp:
						a.attribute_system.current_health = min_hp

func _process_rebirth_field(delta: float) -> void:
	if is_rebirth_field_active:
		rebirth_field_timer -= delta
		_apply_rebirth_aura()
		if rebirth_field_timer <= 0.0:
			is_rebirth_field_active = false
			rebirth_field_timer = 0.0
			rebirth_field_ended.emit()

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	stored_reserve = 0.0
	is_rebirth_field_active = false
	rebirth_field_timer = 0.0
	_sync_reserve_regen()

func respawn() -> void:
	super.respawn()
	stored_reserve = 0.0
	is_rebirth_field_active = false
	rebirth_field_timer = 0.0
	_sync_reserve_regen()
