class_name GorakHero
extends HeroEntity

## Implementation of Gorak (The Devourer / STR Anti-Carry)

const GorakDefinition = preload("res://data/heroes/gorak_definition.gd")

signal stat_drained(target: BaseCombatEntity, amount: float)
signal feed_executed(heal_amount: float)
signal devour_executed(target: BaseCombatEntity)

# Stat Draining States
var passive_stolen_ad: float = 0.0
var passive_drain_timer: float = 0.0
var w_stolen_ad: float = 0.0
var w_drain_timer: float = 0.0
var r_stolen_ad: float = 0.0
var r_stolen_armor: float = 0.0
var r_devour_timer: float = 0.0
var current_drained_target: BaseCombatEntity = null

func _ready() -> void:
	entity_name = "Gorak"
	hero_resource = GorakDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_gorak_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.65
		shape.height = 2.1
		col.shape = shape
		col.position.y = 1.05
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("GorakVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "GorakVisual"
		add_child(root_vis)
		
		# Beastly Predatory Armor Body (2.1m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.60
		body_capsule.height = 2.1
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.05
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.28, 0.18, 0.12, 1.0) # Veral Savage Bronze/Rust
		body_mat.metallic = 0.75
		body_mat.roughness = 0.50
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
		# Selection Base Ring
		var ring = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.90
		torus.outer_radius = 0.95
		ring.mesh = torus
		ring.position.y = 0.03
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var ring_color = Color(0.95, 0.3, 0.3, 0.85) if team == TeamDefinitions.Team.DIRE else Color(0.92, 0.96, 1.0, 0.85)
		ring_mat.albedo_color = ring_color
		ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		ring.material_override = ring_mat
		root_vis.add_child(ring)

func _apply_gorak_definition() -> void:
	if hero_resource == null:
		hero_resource = GorakDefinition.create_resource()
		
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
	
	_process_drain_timers(delta)

func get_total_stolen_ad() -> float:
	return passive_stolen_ad + w_stolen_ad + r_stolen_ad

# --- PASSIVE: LEECHING MIGHT ---

func execute_basic_attack(target: BaseCombatEntity) -> DamageResult:
	var res = super.execute_basic_attack(target)
	if res != null and target != null and is_instance_valid(target) and target.team != team:
		_apply_passive_drain(target)
	return res

func _apply_passive_drain(target: BaseCombatEntity) -> void:
	if not is_alive() or target == null or not is_instance_valid(target):
		return
		
	var drain_amount = 12.0
	passive_stolen_ad = minf(60.0, passive_stolen_ad + drain_amount)
	passive_drain_timer = 4.0
	
	attribute_system.remove_modifiers_by_source("gorak_passive_ad")
	var mod = StatModifier.new(
		StatModifier.TargetStat.ATTACK_DAMAGE,
		StatModifier.Type.FLAT,
		passive_stolen_ad,
		"gorak_passive_ad"
	)
	attribute_system.add_modifier(mod)
	stat_drained.emit(target, drain_amount)

# --- Q: REND ---

func cast_gorak_q(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * q_res.scaling_ratio) + (get_total_stolen_ad() * 1.50)
	
	if not ability_container.cast_ability(AbilityResource.Slot.Q, target):
		return null
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Rend")
	var res = CombatCalculator.execute_damage(req)
	
	_apply_passive_drain(target)
	return res

# --- W: DRAIN STRENGTH ---

func cast_gorak_w(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team or not (target is HeroEntity):
		return false
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.W, target):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.W, target):
		return false
		
	var target_ad = target.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	w_stolen_ad = maxf(15.0, target_ad * 0.30)
	w_drain_timer = 5.0
	current_drained_target = target
	
	# Apply Debuff to target
	target.attribute_system.remove_modifiers_by_source("gorak_w_drain_debuff")
	var debuff = StatModifier.new(
		StatModifier.TargetStat.ATTACK_DAMAGE,
		StatModifier.Type.FLAT,
		-w_stolen_ad,
		"gorak_w_drain_debuff"
	)
	target.attribute_system.add_modifier(debuff)
	
	# Apply Buff to Gorak
	attribute_system.remove_modifiers_by_source("gorak_w_drain_buff")
	var buff = StatModifier.new(
		StatModifier.TargetStat.ATTACK_DAMAGE,
		StatModifier.Type.FLAT,
		w_stolen_ad,
		"gorak_w_drain_buff"
	)
	attribute_system.add_modifier(buff)
	
	stat_drained.emit(target, w_stolen_ad)
	return true

# --- E: FEED ---

func cast_gorak_e() -> bool:
	if not can_cast():
		return false
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast(AbilityResource.Slot.E):
		return false
		
	var stolen = get_total_stolen_ad()
	var heal_val = 80.0 + (stolen * 2.50)
	
	if not ability_container.cast_ability(AbilityResource.Slot.E):
		return false
		
	attribute_system.heal(heal_val)
	_clear_all_stolen_stats()
	
	feed_executed.emit(heal_val)
	return true

# --- R: DEVOUR CHAMPION (ULTIMATE) ---

func cast_gorak_r(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team or not (target is HeroEntity):
		return null
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.R, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var total_dmg = base_dmg + (ad * r_res.scaling_ratio)
	
	if not ability_container.cast_ability(AbilityResource.Slot.R, target):
		return null
		
	var target_ad = target.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var target_armor = target.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	
	r_stolen_ad = target_ad * 0.40
	r_stolen_armor = target_armor * 0.40
	r_devour_timer = 6.0
	
	# Apply Debuffs to Target
	target.attribute_system.remove_modifiers_by_source("gorak_r_devour_debuff_ad")
	target.attribute_system.remove_modifiers_by_source("gorak_r_devour_debuff_armor")
	target.attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ATTACK_DAMAGE, StatModifier.Type.FLAT, -r_stolen_ad, "gorak_r_devour_debuff_ad"))
	target.attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ARMOR, StatModifier.Type.FLAT, -r_stolen_armor, "gorak_r_devour_debuff_armor"))
	
	# Apply Buffs to Gorak
	attribute_system.remove_modifiers_by_source("gorak_r_devour_buff_ad")
	attribute_system.remove_modifiers_by_source("gorak_r_devour_buff_armor")
	attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ATTACK_DAMAGE, StatModifier.Type.FLAT, r_stolen_ad, "gorak_r_devour_buff_ad"))
	attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ARMOR, StatModifier.Type.FLAT, r_stolen_armor, "gorak_r_devour_buff_armor"))
	
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Devour Champion")
	var res = CombatCalculator.execute_damage(req)
	
	devour_executed.emit(target)
	return res

# --- DRAIN TIMERS & CLEANUP ---

func _process_drain_timers(delta: float) -> void:
	if passive_drain_timer > 0.0:
		passive_drain_timer -= delta
		if passive_drain_timer <= 0.0:
			passive_stolen_ad = 0.0
			if attribute_system != null:
				attribute_system.remove_modifiers_by_source("gorak_passive_ad")
				
	if w_drain_timer > 0.0:
		w_drain_timer -= delta
		if w_drain_timer <= 0.0:
			_clear_w_drain()
			
	if r_devour_timer > 0.0:
		r_devour_timer -= delta
		if r_devour_timer <= 0.0:
			_clear_r_devour()

func _clear_w_drain() -> void:
	w_stolen_ad = 0.0
	w_drain_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("gorak_w_drain_buff")
	if current_drained_target != null and is_instance_valid(current_drained_target) and current_drained_target.attribute_system != null:
		current_drained_target.attribute_system.remove_modifiers_by_source("gorak_w_drain_debuff")
	current_drained_target = null

func _clear_r_devour() -> void:
	r_stolen_ad = 0.0
	r_stolen_armor = 0.0
	r_devour_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("gorak_r_devour_buff_ad")
		attribute_system.remove_modifiers_by_source("gorak_r_devour_buff_armor")

func _clear_all_stolen_stats() -> void:
	passive_stolen_ad = 0.0
	passive_drain_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("gorak_passive_ad")
	_clear_w_drain()
	_clear_r_devour()

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	_clear_all_stolen_stats()

func respawn() -> void:
	super.respawn()
	_clear_all_stolen_stats()
