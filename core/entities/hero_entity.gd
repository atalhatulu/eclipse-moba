class_name HeroEntity
extends BaseCombatEntity

## Playable hero unit combining state machine, movement, inventory, ability container, and leveling

enum HeroState {
	IDLE,
	MOVING,
	ATTACKING,
	DEAD
}

signal hero_leveled_up(new_level: int)
signal hero_respawned()
signal state_changed(old_state: HeroState, new_state: HeroState)

@export var hero_resource: HeroResource = null

var hero_id: String:
	get:
		if hero_resource != null and not hero_resource.hero_id.is_empty():
			return hero_resource.hero_id
		if not entity_name.is_empty():
			return entity_name.to_lower()
		return name.to_lower().replace("hero", "")
	set(val):
		if hero_resource != null:
			hero_resource.hero_id = val

var hero_name: String:
	get:
		if hero_resource != null and not hero_resource.hero_name.is_empty():
			return hero_resource.hero_name
		if not entity_name.is_empty():
			return entity_name
		return name.replace("Hero", "").capitalize()
	set(val):
		entity_name = val
		if hero_resource != null:
			hero_resource.hero_name = val

var ability_container: AbilityContainer = null
var inventory_manager: InventoryManager = null

var destination_point: Vector3 = Vector3.ZERO
var spawn_origin: Vector3 = Vector3.ZERO
var is_navigating: bool = false
var respawn_timer: float = 0.0
var current_state: HeroState = HeroState.IDLE

static var active_heroes: Array[HeroEntity] = []

func _init() -> void:
	active_heroes.append(self)

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		active_heroes.erase(self)

# Playable map limits
const MAP_BOUNDS_X: float = 115.0
const MAP_BOUNDS_Z: float = 115.0

func _ready() -> void:
	super._ready()
	if spawn_origin == Vector3.ZERO:
		spawn_origin = global_position if is_inside_tree() else position
	
	if has_node("AbilityContainer"):
		ability_container = $AbilityContainer
	else:
		ability_container = AbilityContainer.new()
		ability_container.name = "AbilityContainer"
		add_child(ability_container)
	if not is_inside_tree() and ability_container != null:
		ability_container._ready()
		
	if has_node("InventoryManager"):
		inventory_manager = $InventoryManager
	else:
		inventory_manager = InventoryManager.new()
		inventory_manager.name = "InventoryManager"
		add_child(inventory_manager)
	if not is_inside_tree() and inventory_manager != null:
		inventory_manager._ready()
	if inventory_manager != null:
		inventory_manager.host_entity = self
		
	if not has_node("HeroAnimator3D"):
		var anim = (load("res://core/entities/heroes/components/hero_animator_3d.gd") as GDScript).new()
		anim.name = "HeroAnimator3D"
		add_child(anim)
		
	if hero_resource != null:
		_apply_hero_resource(hero_resource)
	else:
		attribute_system.base_health = 600.0
		attribute_system.current_health = 600.0
		attribute_system.base_mana = 300.0
		attribute_system.current_mana = 300.0
		attribute_system.recalculate_all_stats()
		
	attribute_system.level_changed.connect(_on_level_changed)

func _apply_hero_resource(res: HeroResource) -> void:
	entity_name = res.hero_name
	
	attribute_system.primary_attribute = res.primary_attribute
	attribute_system.base_strength = res.base_strength
	attribute_system.strength_growth = res.strength_growth
	attribute_system.base_agility = res.base_agility
	attribute_system.agility_growth = res.agility_growth
	attribute_system.base_intelligence = res.base_intelligence
	attribute_system.intelligence_growth = res.intelligence_growth
	
	attribute_system.base_health = res.base_health
	attribute_system.base_health_regen = res.base_health_regen
	attribute_system.base_mana = res.base_mana
	attribute_system.base_mana_regen = res.base_mana_regen
	attribute_system.base_attack_damage = res.base_attack_damage
	attribute_system.base_ability_power = res.base_ability_power
	attribute_system.base_armor = res.base_armor
	attribute_system.base_magic_resist = res.base_magic_resist
	attribute_system.base_attack_speed = res.base_attack_speed
	attribute_system.base_move_speed = res.base_move_speed
	attribute_system.base_attack_range = res.base_attack_range
	
	attribute_system.recalculate_all_stats()
	attribute_system.heal(attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
	attribute_system.restore_mana(attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA))
	
	for ab in res.abilities:
		if ab != null:
			ability_container.set_ability(ab.slot, ab)
			
	if res.passive_ability != null:
		ability_container.set_ability(AbilityResource.Slot.PASSIVE, res.passive_ability)
	if res.q_ability != null:
		ability_container.set_ability(AbilityResource.Slot.Q, res.q_ability)
	if res.w_ability != null:
		ability_container.set_ability(AbilityResource.Slot.W, res.w_ability)
	if res.e_ability != null:
		ability_container.set_ability(AbilityResource.Slot.E, res.e_ability)
	if res.r_ability != null:
		ability_container.set_ability(AbilityResource.Slot.R, res.r_ability)

func _physics_process(delta: float) -> void:
	if not is_alive():
		_set_state(HeroState.DEAD)
		if respawn_timer > 0.0:
			respawn_timer -= delta
			if respawn_timer <= 0.0:
				respawn()
		return
		
	if is_navigating and can_move():
		var dir = destination_point - global_position
		dir.y = 0.0
		var dist = dir.length()
		
		if dist < 0.6:
			is_navigating = false
			velocity = Vector3.ZERO
			_set_state(HeroState.IDLE)
		else:
			_set_state(HeroState.MOVING)
			var ms = attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
			var speed = ms * 0.035 # e.g. 315 ms -> 11 m/s
			velocity = dir.normalized() * speed
			
			# Smoothly orient towards movement direction
			var target_angle = atan2(dir.x, dir.z)
			rotation.y = lerp_angle(rotation.y, target_angle, 16.0 * delta)
			
			move_and_slide()
			_clamp_hero_bounds()
	else:
		velocity = Vector3.ZERO
		if current_state == HeroState.MOVING:
			_set_state(HeroState.IDLE)

func _clamp_hero_bounds() -> void:
	global_position.x = clampf(global_position.x, -MAP_BOUNDS_X, MAP_BOUNDS_X)
	global_position.z = clampf(global_position.z, -MAP_BOUNDS_Z, MAP_BOUNDS_Z)

func _set_state(new_st: HeroState) -> void:
	if current_state != new_st:
		var old_st = current_state
		current_state = new_st
		state_changed.emit(old_st, new_st)

func set_attacking_state() -> void:
	if is_alive():
		_set_state(HeroState.ATTACKING)

func issue_attack_target(target: BaseCombatEntity) -> bool:
	if attack_controller != null:
		return attack_controller.issue_attack_command(target)
	return false

func cancel_attack_command() -> void:
	if attack_controller != null:
		attack_controller.cancel_attack_command()

func move_to_location(target_pos: Vector3) -> void:
	if not is_alive() or not can_move():
		return
	destination_point = Vector3(
		clampf(target_pos.x, -MAP_BOUNDS_X, MAP_BOUNDS_X),
		target_pos.y,
		clampf(target_pos.z, -MAP_BOUNDS_Z, MAP_BOUNDS_Z)
	)
	is_navigating = true
	_set_state(HeroState.MOVING)

func stop_movement() -> void:
	is_navigating = false
	velocity = Vector3.ZERO
	if is_alive() and current_state == HeroState.MOVING:
		_set_state(HeroState.IDLE)

func _on_level_changed(new_lvl: int) -> void:
	if ability_container != null:
		ability_container.add_skill_point()
	hero_leveled_up.emit(new_lvl)

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	is_navigating = false
	velocity = Vector3.ZERO
	is_targetable = false
	visible = false
	_set_state(HeroState.DEAD)
	if effect_container != null:
		effect_container.clear_all_effects()
	respawn_timer = 4.0 + (float(attribute_system.level) * 2.0)
	
	# Award Hero Kill XP and Gold to enemy team
	var enemy_team = TeamDefinitions.Team.DIRE if team == TeamDefinitions.Team.RADIANT else TeamDefinitions.Team.RADIANT
	var hero_xp_bounty = 140 + (attribute_system.level * 60)
	var killer_h = last_attacker as HeroEntity
	_distribute_area_xp(hero_xp_bounty, enemy_team, killer_h)
	_distribute_kill_and_assist_gold(enemy_team, killer_h)
	
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.hero_died.emit(self, last_attacker, respawn_timer)

func _distribute_kill_and_assist_gold(target_team: TeamDefinitions.Team, killer_hero: HeroEntity = null) -> void:
	var self_pos = global_position if is_inside_tree() else position
	var kill_bounty = 240 + (attribute_system.level * 20)
	var assist_pool = 120 + (attribute_system.level * 10)
	
	if killer_hero != null and is_instance_valid(killer_hero) and killer_hero.is_alive() and killer_hero.team == target_team:
		if killer_hero.inventory_manager != null:
			killer_hero.inventory_manager.add_gold(kill_bounty)
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.hero_kill_gold_awarded.emit(killer_hero, kill_bounty, self)
			GameEvents.gold_awarded.emit(killer_hero, kill_bounty, "Hero Kill")
			
		# Floating gold text feedback
		if is_inside_tree() and get_tree() != null and get_tree().root != null:
			var text_script = load("res://scenes/ui/floating_combat_text_3d.gd")
			if text_script != null:
				var gold_text = text_script.new()
				get_tree().root.add_child(gold_text)
				gold_text.setup("+%dG" % kill_bounty, Color(1.0, 0.85, 0.2), killer_hero.global_position + Vector3(0, 1.2, 0), false)
				
		# Distribute assist gold to nearby teammates
		var assisters: Array[HeroEntity] = []
		for h in HeroEntity.active_heroes:
			if is_instance_valid(h) and h.is_alive() and h.team == target_team and h != killer_hero:
				var h_pos = h.global_position if h.is_inside_tree() else h.position
				if self_pos.distance_to(h_pos) <= 16.0:
					assisters.append(h)
					
		if not assisters.is_empty():
			var gold_per_assister = max(1, int(float(assist_pool) / float(assisters.size())))
			for a in assisters:
				if a.inventory_manager != null:
					a.inventory_manager.add_gold(gold_per_assister)
				if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
					GameEvents.assist_gold_awarded.emit(a, gold_per_assister, self)
					GameEvents.gold_awarded.emit(a, gold_per_assister, "Hero Assist")
	else:
		# Non-Hero kill (e.g. Tower/Creep): Split bounty among nearby enemy heroes
		var nearby_heroes: Array[HeroEntity] = []
		for h in HeroEntity.active_heroes:
			if is_instance_valid(h) and h.is_alive() and h.team == target_team:
				var h_pos = h.global_position if h.is_inside_tree() else h.position
				if self_pos.distance_to(h_pos) <= 16.0:
					nearby_heroes.append(h)
		if not nearby_heroes.is_empty():
			var split_gold = max(1, int(float(kill_bounty) / float(nearby_heroes.size())))
			for h in nearby_heroes:
				if h.inventory_manager != null:
					h.inventory_manager.add_gold(split_gold)
				if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
					GameEvents.gold_awarded.emit(h, split_gold, "Hero Area Bounty")

func _distribute_area_xp(total_xp: int, target_team: TeamDefinitions.Team, killer_hero: HeroEntity = null) -> void:
	var self_pos = global_position if is_inside_tree() else position
	var eligible_heroes: Array[HeroEntity] = []
	
	for h in HeroEntity.active_heroes:
		if is_instance_valid(h) and h.is_alive() and h.team == target_team:
			var h_pos = h.global_position if h.is_inside_tree() else h.position
			if self_pos.distance_to(h_pos) <= 16.0:
				eligible_heroes.append(h)
				
	if eligible_heroes.is_empty() and killer_hero != null and is_instance_valid(killer_hero) and killer_hero.is_alive() and killer_hero.team == target_team:
		eligible_heroes.append(killer_hero)
		
	if eligible_heroes.is_empty():
		return
		
	var count = eligible_heroes.size()
	var xp_per_hero = total_xp
	if count == 2:
		xp_per_hero = int(float(total_xp) * 0.60)
	elif count == 3:
		xp_per_hero = int(float(total_xp) * 0.45)
	elif count > 3:
		xp_per_hero = int(float(total_xp) / float(count))
		
	for h in eligible_heroes:
		h.attribute_system.add_xp(xp_per_hero)
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.xp_awarded.emit(h, xp_per_hero)
			GameEvents.hero_kill_xp_awarded.emit(h, xp_per_hero, self)

func respawn() -> void:
	lifecycle_state = LifecycleState.ALIVE
	attribute_system.is_alive = true
	is_targetable = true
	visible = true
	if is_inside_tree():
		global_position = spawn_origin
	else:
		position = spawn_origin
	attribute_system.heal(attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
	attribute_system.restore_mana(attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA))
	if effect_container != null:
		effect_container.clear_all_effects()
	if attack_controller != null:
		attack_controller.cancel_attack_command()
	if status_bar != null:
		status_bar.visible = true
	_set_state(HeroState.IDLE)
	hero_respawned.emit()
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.hero_respawned.emit(self)

var alt_attack_range_mesh: MeshInstance3D = null
var alt_skill_range_mesh: MeshInstance3D = null

func _create_alt_range_indicators() -> void:
	if not has_node("AltRangeRoot"):
		var root = Node3D.new()
		root.name = "AltRangeRoot"
		add_child(root)
		
		# 1. Attack Range Ring (Gold / White)
		alt_attack_range_mesh = MeshInstance3D.new()
		alt_attack_range_mesh.name = "AltAttackRange"
		var torus = TorusMesh.new()
		torus.inner_radius = 0.97
		torus.outer_radius = 1.0
		torus.rings = 48
		torus.ring_segments = 3
		alt_attack_range_mesh.mesh = torus
		alt_attack_range_mesh.position.y = 0.04
		
		var mat = StandardMaterial3D.new()
		mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		mat.albedo_color = Color(1.0, 0.85, 0.3, 0.45)
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.cull_mode = BaseMaterial3D.CULL_DISABLED
		alt_attack_range_mesh.material_override = mat
		alt_attack_range_mesh.visible = false
		root.add_child(alt_attack_range_mesh)
		
		# 2. Skill Preview Range Ring (Cyan / Magenta)
		alt_skill_range_mesh = MeshInstance3D.new()
		alt_skill_range_mesh.name = "AltSkillRange"
		var s_torus = TorusMesh.new()
		s_torus.inner_radius = 0.97
		s_torus.outer_radius = 1.0
		s_torus.rings = 48
		s_torus.ring_segments = 3
		alt_skill_range_mesh.mesh = s_torus
		alt_skill_range_mesh.position.y = 0.05
		
		var s_mat = StandardMaterial3D.new()
		s_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		s_mat.albedo_color = Color(0.3, 0.85, 1.0, 0.55)
		s_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		s_mat.cull_mode = BaseMaterial3D.CULL_DISABLED
		alt_skill_range_mesh.material_override = s_mat
		alt_skill_range_mesh.visible = false
		root.add_child(alt_skill_range_mesh)

func set_alt_range_visible(p_visible: bool) -> void:
	if alt_attack_range_mesh == null:
		_create_alt_range_indicators()
	if alt_attack_range_mesh != null:
		var atk_range = get_attack_range()
		alt_attack_range_mesh.scale = Vector3(atk_range, 1.0, atk_range)
		alt_attack_range_mesh.visible = p_visible

func preview_skill_range(range_val: float, color: Color = Color(0.3, 0.85, 1.0, 0.55)) -> void:
	if alt_skill_range_mesh == null:
		_create_alt_range_indicators()
	if alt_skill_range_mesh != null:
		if range_val > 0.0:
			alt_skill_range_mesh.scale = Vector3(range_val, 1.0, range_val)
			var s_mat = alt_skill_range_mesh.material_override as StandardMaterial3D
			if s_mat != null:
				s_mat.albedo_color = color
			alt_skill_range_mesh.visible = true
		else:
			alt_skill_range_mesh.visible = false
