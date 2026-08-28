class_name ElyraHero
extends HeroEntity

## Implementation of Elyra (The High-Roller / AGI Crit Carry)

signal fortune_updated(current_stacks: int)
signal double_down_armed()
signal roll_away_executed()
signal marked_fortune_applied(target: BaseCombatEntity)
signal jackpot_activated()
signal jackpot_ended()
signal jackpot_crit_struck(target: BaseCombatEntity, damage: float)

# Passive Fortune State
var fortune_stacks: int = 0
const MAX_FORTUNE: int = 5

# Q: Double Down State
var is_double_down_armed: bool = false
var double_down_timer: float = 0.0

# W: Roll Away Evade State
var is_evading: bool = false
var evade_timer: float = 0.0

# E: Marked Fortune State
var marked_target: BaseCombatEntity = null
var marked_timer: float = 0.0

# R: Jackpot State
var is_jackpot_active: bool = false
var jackpot_timer: float = 0.0

func _ready() -> void:
	entity_name = "Elyra"
	hero_resource = ElyraDefinition.create_resource()
	super._ready()
	
	_setup_collision()
	_create_visual_mesh()
	_apply_elyra_definition()

func _setup_collision() -> void:
	if not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = CapsuleShape3D.new()
		shape.radius = 0.48
		shape.height = 1.90
		col.shape = shape
		col.position.y = 0.95
		add_child(col)

func _create_visual_mesh() -> void:
	if not has_node("ElyraVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "ElyraVisual"
		add_child(root_vis)
		
		# Golden Gambler Marksman Body (1.90m Tall)
		var body_inst = MeshInstance3D.new()
		var body_capsule = CapsuleMesh.new()
		body_capsule.radius = 0.45
		body_capsule.height = 1.90
		body_inst.mesh = body_capsule
		body_inst.position.y = 0.95
		
		var body_mat = StandardMaterial3D.new()
		body_mat.albedo_color = Color(0.85, 0.65, 0.15, 1.0) # Gilded Gold & Crimson Velvet
		body_mat.metallic = 0.85
		body_mat.roughness = 0.20
		body_inst.material_override = body_mat
		root_vis.add_child(body_inst)
		
		# Twin Gold Hand-Cannons Mesh
		for side in [-0.45, 0.45]:
			var gun = MeshInstance3D.new()
			var g_box = BoxMesh.new()
			g_box.size = Vector3(0.10, 0.25, 0.60)
			gun.mesh = g_box
			gun.position = Vector3(side, 0.85, 0.40)
			
			var g_mat = StandardMaterial3D.new()
			g_mat.albedo_color = Color(0.95, 0.80, 0.30, 1.0)
			g_mat.metallic = 0.90
			gun.material_override = g_mat
			root_vis.add_child(gun)
			
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

func _apply_elyra_definition() -> void:
	if hero_resource == null:
		hero_resource = ElyraDefinition.create_resource()
		
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
	
	_process_double_down(delta)
	_process_evade(delta)
	_process_marked(delta)
	_process_jackpot(delta)

# --- PASSIVE: LOADED DICE ---

func add_fortune(amount: int) -> void:
	fortune_stacks = mini(MAX_FORTUNE, fortune_stacks + amount)
	fortune_updated.emit(fortune_stacks)

# --- Q: DOUBLE DOWN ---

func cast_elyra_q() -> bool:
	if not can_cast():
		return false
		
	var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
	if q_res == null or not ability_container.can_cast(AbilityResource.Slot.Q):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.Q):
		return false
		
	is_double_down_armed = true
	double_down_timer = 5.0
	double_down_armed.emit()
	return true

func _process_double_down(delta: float) -> void:
	if double_down_timer > 0.0:
		double_down_timer -= delta
		if double_down_timer <= 0.0:
			is_double_down_armed = false

# --- W: ROLL AWAY ---

func cast_elyra_w() -> bool:
	if not can_cast():
		return false
		
	var w_res = ability_container.abilities.get(AbilityResource.Slot.W, null)
	if w_res == null or not ability_container.can_cast(AbilityResource.Slot.W):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.W):
		return false
		
	# Roll 4.5m
	var forward_dir = -transform.basis.z.normalized() if is_inside_tree() else Vector3(1, 0, 0)
	if forward_dir.length_squared() < 0.1:
		forward_dir = Vector3(1, 0, 0)
	if is_inside_tree():
		global_position += forward_dir * 4.5
	else:
		position += forward_dir * 4.5
		
	is_evading = true
	evade_timer = 0.75
	roll_away_executed.emit()
	return true

func _process_evade(delta: float) -> void:
	if evade_timer > 0.0:
		evade_timer -= delta
		if evade_timer <= 0.0:
			is_evading = false

# --- E: MARKED FORTUNE ---

func cast_elyra_e(target: BaseCombatEntity) -> bool:
	if not can_cast() or target == null or not is_instance_valid(target) or not target.is_alive() or target.team == team:
		return false
		
	var e_res = ability_container.abilities.get(AbilityResource.Slot.E, null)
	if e_res == null or not ability_container.can_cast_on_target(AbilityResource.Slot.E, target):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.E, target):
		return false
		
	marked_target = target
	marked_timer = 5.0
	marked_fortune_applied.emit(target)
	return true

func _process_marked(delta: float) -> void:
	if marked_timer > 0.0:
		marked_timer -= delta
		if marked_timer <= 0.0 or marked_target == null or not is_instance_valid(marked_target) or not marked_target.is_alive():
			marked_target = null
			marked_timer = 0.0

# --- R: JACKPOT (ULTIMATE) ---

func cast_elyra_r() -> bool:
	if not can_cast():
		return false
		
	var r_res = ability_container.abilities.get(AbilityResource.Slot.R, null)
	if r_res == null or not ability_container.can_cast(AbilityResource.Slot.R):
		return false
		
	if not ability_container.cast_ability(AbilityResource.Slot.R):
		return false
		
	is_jackpot_active = true
	jackpot_timer = 6.0
	jackpot_activated.emit()
	return true

func _process_jackpot(delta: float) -> void:
	if is_jackpot_active:
		jackpot_timer -= delta
		if jackpot_timer <= 0.0:
			is_jackpot_active = false
			jackpot_timer = 0.0
			jackpot_ended.emit()

# --- BASIC ATTACK OVERRIDE ---

func execute_basic_attack(target: BaseCombatEntity) -> DamageResult:
	if not can_attack() or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable or target.team == team:
		return null
		
	var is_guaranteed_crit = (fortune_stacks >= MAX_FORTUNE)
	var q_bonus_damage = 0.0
	if is_double_down_armed:
		is_double_down_armed = false
		double_down_timer = 0.0
		var lvl = ability_container.ability_levels.get(AbilityResource.Slot.Q, 1)
		var q_res = ability_container.abilities.get(AbilityResource.Slot.Q, null)
		var base_dmg = q_res.get_base_damage(lvl) if q_res != null else 60.0
		var ad = attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
		q_bonus_damage = base_dmg + (ad * 0.65)
		
	# Execute standard attack
	var res = super.execute_basic_attack(target)
	
	if is_guaranteed_crit:
		fortune_stacks = 0
		fortune_updated.emit(0)
	else:
		add_fortune(1)
		
	if is_jackpot_active:
		add_fortune(2)
		
	# Apply Q Bonus Damage
	if q_bonus_damage > 0.0 and target.is_alive():
		var q_req = DamageRequest.create_ability_damage(self, target, q_bonus_damage, DamageRequest.DamageType.PHYSICAL, "Double Down Strike")
		CombatCalculator.execute_damage(q_req)
		
	# Apply E Marked Bonus Damage on Crit
	if target == marked_target and (is_guaranteed_crit or is_jackpot_active) and target.is_alive():
		var e_lvl = ability_container.ability_levels.get(AbilityResource.Slot.E, 1)
		var marked_bonus = 30.0 + (e_lvl * 15.0)
		var e_req = DamageRequest.create_ability_damage(self, target, marked_bonus, DamageRequest.DamageType.PHYSICAL, "Marked Fortune Crit")
		CombatCalculator.execute_damage(e_req)
		jackpot_crit_struck.emit(target, marked_bonus)
		
	return res

# --- DEATH & RESPAWN LIFECYCLE ---

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	fortune_stacks = 0
	is_double_down_armed = false
	double_down_timer = 0.0
	is_evading = false
	evade_timer = 0.0
	marked_target = null
	marked_timer = 0.0
	is_jackpot_active = false
	jackpot_timer = 0.0

func respawn() -> void:
	super.respawn()
	fortune_stacks = 0
	is_double_down_armed = false
	double_down_timer = 0.0
	is_evading = false
	evade_timer = 0.0
	marked_target = null
	marked_timer = 0.0
	is_jackpot_active = false
	jackpot_timer = 0.0
