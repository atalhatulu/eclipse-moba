class_name BrakkaHero
extends HeroEntity

## Implementation of Brakka (The Bulwark / STR Tank & Retaliation Core)

signal retaliation_updated(current_retaliation: float, max_retaliation: float)
signal fortress_activated()
signal fortress_ended()
signal immovable_activated()
signal immovable_ended()
signal shield_ram_hit(target: BaseCombatEntity)
signal rebound_discharged(target: BaseCombatEntity, amount: float)

# Passive Retaliation Core State
var stored_retaliation: float = 0.0
var max_retaliation_cap: float = 400.0
var decay_timer: float = 0.0
var is_decay_locked: bool = false
const RETALIATION_CONVERSION_RATIO: float = 0.20 # 20% of damage taken is stored
const COMBAT_DECAY_DELAY: float = 5.0 # Seconds before retaliation starts decaying
const DECAY_RATE_PER_SECOND: float = 0.10 # 10% of max capacity per second

# W: Fortress State
var is_fortress_active: bool = false
var fortress_timer: float = 0.0

# R: Immovable State
var is_immovable_active: bool = false
var immovable_timer: float = 0.0

func _ready() -> void:
	entity_name = "Brakka"
	hero_resource = BrakkaDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_brakka_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.70
		shape.height = 2.2
		col.shape = shape
		col.position.y = 1.10
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("BrakkaVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "BrakkaVisual"
		add_child(root_vis)
		
		# Massive Bulwark Armored Body (2.2m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.65
		body_capsule.height = 2.2
		body_inst.mesh = body_capsule
		body_inst.position.y = 1.10
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.22, 0.28, 0.24, 1.0) # Heavy Bastion Slate Green / Iron
		body_mat.metallic = 0.85
		body_mat.roughness = 0.40
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
		# Front Tower Shield Mesh
		var shield_inst = MeshInstance3D.new()
		var shield_box = BoxMesh.new()
		shield_box.size = Vector3(0.90, 1.40, 0.25)
		shield_inst.mesh = shield_box
		shield_inst.position = Vector3(0.0, 1.10, 0.55)
		
		var shield_mat = StandardMaterial3D.new()
		shield_mat.albedo_color = Color(0.40, 0.45, 0.42, 1.0)
		shield_mat.metallic = 0.90
		shield_mat.roughness = 0.30
		shield_inst.material_override = shield_mat
		root_vis.add_child(shield_inst)
		
		# Selection Base Ring
		var ring = MeshInstance3D.new()
		var torus = TorusMesh.new()
		torus.inner_radius = 0.95
		torus.outer_radius = 1.00
		ring.mesh = torus
		ring.position.y = 0.03
		
		var ring_mat = StandardMaterial3D.new()
		ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		var ring_color = Color(0.95, 0.3, 0.3, 0.85) if team == TeamDefinitions.Team.DIRE else Color(0.92, 0.96, 1.0, 0.85)
		ring_mat.albedo_color = ring_color
		ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		ring.material_override = ring_mat
		root_vis.add_child(ring)

func _apply_brakka_definition() -> void:
	if hero_resource == null:
		hero_resource = BrakkaDefinition.create_resource()
		
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
	
	_update_retaliation_cap()
	
	# Assign abilities
	ability_container.set_ability(AbilityResource.Slot.PASSIVE, def.passive_ability)
	ability_container.set_ability(AbilityResource.Slot.Q, def.q_ability)
	ability_container.set_ability(AbilityResource.Slot.W, def.w_ability)
	ability_container.set_ability(AbilityResource.Slot.E, def.e_ability)
	ability_container.set_ability(AbilityResource.Slot.R, def.r_ability)

func _process(delta: float) -> void:
	super._process(delta)
	
	_update_retaliation_cap()
	_process_retaliation_decay(delta)
	
	# Process Fortress timer
	if is_fortress_active:
		fortress_timer -= delta
		if fortress_timer <= 0.0:
			_end_fortress()
			
	# Process Immovable timer
	if is_immovable_active:
		immovable_timer -= delta
		if immovable_timer <= 0.0:
			_end_immovable()

# --- PASSIVE: RETALIATION CORE ---

func _update_retaliation_cap() -> void:
	if attribute_system != null:
		var max_hp = attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
		max_retaliation_cap = maxf(200.0, max_hp * 0.50)

func get_retaliation() -> float:
	return stored_retaliation

func get_max_retaliation() -> float:
	return max_retaliation_cap

func add_retaliation(amount: float) -> void:
	if amount <= 0.0:
		return
	_update_retaliation_cap()
	stored_retaliation = clampf(stored_retaliation + amount, 0.0, max_retaliation_cap)
	decay_timer = COMBAT_DECAY_DELAY
	retaliation_updated.emit(stored_retaliation, max_retaliation_cap)

func consume_retaliation() -> float:
	var val = stored_retaliation
	stored_retaliation = 0.0
	retaliation_updated.emit(0.0, max_retaliation_cap)
	return val

func reset_retaliation() -> void:
	stored_retaliation = 0.0
	decay_timer = 0.0
	retaliation_updated.emit(0.0, max_retaliation_cap)

func _process_retaliation_decay(delta: float) -> void:
	if not is_alive():
		return
	if is_decay_locked:
		return
		
	if decay_timer > 0.0:
		var elapsed_past = delta - decay_timer
		decay_timer -= delta
		if elapsed_past > 0.0 and stored_retaliation > 0.0:
			var decay_amount = max_retaliation_cap * DECAY_RATE_PER_SECOND * elapsed_past
			stored_retaliation = maxf(0.0, stored_retaliation - decay_amount)
			retaliation_updated.emit(stored_retaliation, max_retaliation_cap)
	else:
		if stored_retaliation > 0.0:
			var decay_amount = max_retaliation_cap * DECAY_RATE_PER_SECOND * delta
			stored_retaliation = maxf(0.0, stored_retaliation - decay_amount)
			retaliation_updated.emit(stored_retaliation, max_retaliation_cap)

func receive_damage(request: DamageRequest) -> DamageResult:
	if not is_alive():
		return null
		
	# Immovable CC / Tenacity protection
	if is_immovable_active and effect_container != null:
		effect_container.remove_effect_by_id("stun")
		effect_container.remove_effect_by_id("silence")
		effect_container.remove_effect_by_id("root")
		effect_container.remove_effect_by_id("slow")
		
	var result = super.receive_damage(request)
	
	# Retaliation Core: Store 20% of net damage taken (ignore reflected/rebound damage)
	if result != null and (result.final_health_damage > 0.0 or result.shield_absorbed > 0.0):
		var src = request.source_name if ("source_name" in request) else ""
		if src != "Rebound":
			var total_taken = result.final_health_damage + result.shield_absorbed
			add_retaliation(total_taken * RETALIATION_CONVERSION_RATIO)
			
	return result

# --- Q: SHIELD RAM ---

func cast_brakka_q(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.Q, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
	var base_dmg = q_res.get_base_damage(lvl)
	var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var armor = attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	var total_dmg = base_dmg + (ad * q_res.scaling_ratio) + (armor * 0.40)
	
	if not ability_container.cast_ability(AbilityResource.Slot.Q, target):
		return null
		
	# Forward Dash to target location
	var t_pos = target.global_position if (target.is_inside_tree() or target.global_position != Vector3.ZERO) else target.position
	var my_pos = global_position if (is_inside_tree() or global_position != Vector3.ZERO) else position
	var dir = (t_pos - my_pos).normalized()
	if dir.length_squared() > 0.001:
		var charge_dest = t_pos - (dir * 1.0)
		if is_inside_tree():
			global_position = charge_dest
		else:
			position = charge_dest
			
		# Knockback target away from Brakka
		var knock_pos = t_pos + (dir * 2.5)
		if target.is_inside_tree():
			target.global_position = knock_pos
		else:
			target.position = knock_pos
			
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Shield Ram")
	var res = CombatCalculator.execute_damage(req)
	
	shield_ram_hit.emit(target)
	return res

# --- W: FORTRESS ---

func cast_brakka_w() -> bool:
	if not can_cast():
		return false
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return false
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.W, 1)
	var bonus_armors = [40.0, 60.0, 80.0, 100.0]
	var bonus_armor = bonus_armors[clamp(lvl - 1, 0, 3)]
	
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	is_fortress_active = true
	fortress_timer = 4.0
	
	# Apply Armor buff and self-slow debuff
	attribute_system.remove_modifiers_by_source("brakka_fortress_armor")
	attribute_system.remove_modifiers_by_source("brakka_fortress_slow")
	
	var armor_mod = StatModifier.new(
		StatModifier.TargetStat.ARMOR,
		StatModifier.Type.FLAT,
		bonus_armor,
		"brakka_fortress_armor"
	)
	var slow_mod = StatModifier.new(
		StatModifier.TargetStat.MOVE_SPEED,
		StatModifier.Type.PERCENT_ADD,
		-0.25, # -25% Move Speed
		"brakka_fortress_slow"
	)
	
	attribute_system.add_modifier(armor_mod)
	attribute_system.add_modifier(slow_mod)
	
	fortress_activated.emit()
	return true

func _end_fortress() -> void:
	is_fortress_active = false
	fortress_timer = 0.0
	if attribute_system != null:
		attribute_system.remove_modifiers_by_source("brakka_fortress_armor")
		attribute_system.remove_modifiers_by_source("brakka_fortress_slow")
	fortress_ended.emit()

# --- E: REBOUND ---

func cast_brakka_e(target: BaseCombatEntity) -> DamageResult:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.E, target):
		return null
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
	var base_dmg = e_res.get_base_damage(lvl)
	var released_retaliation = consume_retaliation()
	var total_dmg = base_dmg + released_retaliation
	
	if not ability_container.cast_ability(AbilityResource.Slot.E, target):
		return null
		
	var req = DamageRequest.create_ability_damage(self, target, total_dmg, DamageRequest.DamageType.PHYSICAL, "Rebound")
	var res = CombatCalculator.execute_damage(req)
	
	rebound_discharged.emit(target, released_retaliation)
	return res

# --- R: IMMOVABLE (ULTIMATE) ---

func cast_brakka_r() -> bool:
	if not is_alive():
		return false
		
	# Cleanse crowd control effects immediately (Immovable breaks CC)
	if effect_container != null:
		effect_container.remove_effect_by_id("stun")
		effect_container.remove_effect_by_id("silence")
		effect_container.remove_effect_by_id("root")
		effect_container.remove_effect_by_id("slow")
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null:
		return false
		
	if ability_container.ability_levels.get(AbilityResource.Slot.R, 0) <= 0:
		ability_container.ability_levels[AbilityResource.Slot.R] = 1
		
	var lvl = ability_container.ability_levels.get(AbilityResource.Slot.R, 1)
	var base_dmg = r_res.get_base_damage(lvl)
	var max_hp = attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	var total_dmg = base_dmg + (max_hp * 0.08)
	
	ability_container.cast_ability(AbilityResource.Slot.R)
		
	is_immovable_active = true
	immovable_timer = 5.0
	
	# Find and Pull nearby enemy heroes within 5.5m (550.0 units)
	var my_pos = global_position if (is_inside_tree() or global_position != Vector3.ZERO) else position
	var enemies: Array = []
	if is_inside_tree() and get_tree() != null:
		enemies = get_tree().get_nodes_in_group("combat_entities")
	else:
		enemies.append_array(HeroEntity.active_heroes)
		
	for h in enemies:
		if h is BaseCombatEntity and is_instance_valid(h) and h != self and h.is_alive() and h.team != team and h.is_targetable:
			var h_pos = h.global_position if (h.is_inside_tree() or h.global_position != Vector3.ZERO) else h.position
			var dist = my_pos.distance_to(h_pos)
			if dist <= 5.5 or dist <= 550.0:
				# Pull enemy towards Brakka
				var pull_dest = my_pos + (h_pos - my_pos).normalized() * 1.5
				if h.is_inside_tree():
					h.global_position = pull_dest
				else:
					h.position = pull_dest
					
				# Apply damage
				var req = DamageRequest.create_ability_damage(self, h, total_dmg, DamageRequest.DamageType.PHYSICAL, "Immovable")
				CombatCalculator.execute_damage(req)
				
				# Apply 50% Slow for 1.5s
				if h.effect_container != null:
					var slow_eff = StatusEffect.new("brakka_immovable_slow", StatusEffect.EffectType.SLOW, 1.5, 0.50)
					h.effect_container.apply_effect(slow_eff)
					
	immovable_activated.emit()
	return true

func _end_immovable() -> void:
	is_immovable_active = false
	immovable_timer = 0.0
	immovable_ended.emit()

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	reset_retaliation()
	_end_fortress()
	_end_immovable()

func respawn() -> void:
	super.respawn()
	reset_retaliation()
	_end_fortress()
	_end_immovable()
