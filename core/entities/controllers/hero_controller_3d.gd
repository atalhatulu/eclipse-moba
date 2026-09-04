class_name HeroController3D
extends Node

## Enhanced MOBA Player Controller: Movement, Spells, Ground Targeting Indicators, and Active Items (1-6)

enum CommandType {
	NONE,
	MOVE,
	ATTACK_TARGET,
	INTERACT
}

class PlayerCommand extends RefCounted:
	var type: CommandType = CommandType.NONE
	var target_position: Vector3 = Vector3.ZERO
	var target_entity: BaseCombatEntity = null
	var is_completed: bool = false
	
	func _init(p_type: CommandType = CommandType.NONE, p_pos: Vector3 = Vector3.ZERO, p_target: BaseCombatEntity = null) -> void:
		type = p_type
		target_position = p_pos
		target_entity = p_target

class PendingSpellCast extends RefCounted:
	var is_item: bool = false
	var slot_id: int = 0
	var target_entity: BaseCombatEntity = null
	var target_point: Vector3 = Vector3.ZERO
	var cast_range: float = 10.0

signal target_selected(target: BaseCombatEntity, is_enemy: bool)
signal selection_cleared()
signal command_issued(command: PlayerCommand)

@export var hero: HeroEntity = null
@export var camera: Camera3D = null

var targeted_enemy: BaseCombatEntity = null
var selected_unit: BaseCombatEntity = null
var is_moving_to_attack: bool = false
var current_command: PlayerCommand = null
var pending_spell: PendingSpellCast = null
var pending_item_pickup: ItemPickup3D = null

# Targeting Indicator System
var targeting_indicator: TargetingIndicator3D = null
var is_targeting_active: bool = false
var pending_spell_slot: int = -1 # -1 None, 0-4 QWERD, 10-15 Item Slots 0-5
var locked_target_unit: BaseCombatEntity = null
var active_held_key_slot: int = -1

# Visual Decal
const ClickMarkerClass = preload("res://scenes/ui/click_marker_3d.gd")

func _ready() -> void:
	if hero == null and get_parent() is HeroEntity:
		hero = get_parent() as HeroEntity
		
	targeting_indicator = TargetingIndicator3D.new()
	targeting_indicator.name = "TargetingIndicator3D"
	add_child(targeting_indicator)

func _physics_process(delta: float) -> void:
	if hero == null or not hero.is_alive() or not hero.can_move():
		return
	if pending_item_pickup != null:
		if not is_instance_valid(pending_item_pickup) or pending_item_pickup.item_data == null:
			pending_item_pickup = null
		else:
			var pickup_distance = hero.global_position.distance_to(pending_item_pickup.global_position)
			if pickup_distance <= pending_item_pickup.auto_pickup_distance:
				if pending_item_pickup.try_pickup(hero):
					hero.stop_movement()
				pending_item_pickup = null
			else:
				hero.move_to_location(pending_item_pickup.global_position)
				return
		
	# 1. Tracking and Attacking an Enemy Target
	if is_moving_to_attack:
		if targeted_enemy == null or not is_instance_valid(targeted_enemy) or not targeted_enemy.is_alive() or not targeted_enemy.is_targetable:
			# Auto-acquire next valid target (Creep died -> chain to next creep / enemy)
			var next_enemy = _find_nearest_enemy_in_range(hero.get_attack_range() + 5.0)
			if next_enemy != null:
				targeted_enemy = next_enemy
				hero.set_combat_target(next_enemy)
				is_moving_to_attack = true
				if hero.attack_controller != null:
					hero.attack_controller.issue_attack_command(next_enemy)
			else:
				targeted_enemy = null
				is_moving_to_attack = false
				if hero != null:
					hero.clear_combat_target()
					hero.stop_movement()
					if hero.attack_controller != null:
						hero.attack_controller.cancel_attack_command()
				if current_command != null:
					current_command.is_completed = true
				return
			
		var h_pos = hero.global_position if hero.is_inside_tree() else hero.position
		var t_pos = targeted_enemy.global_position if targeted_enemy.is_inside_tree() else targeted_enemy.position
		var dist = h_pos.distance_to(t_pos)
		var attack_range = hero.get_attack_range()
		
		if dist <= attack_range:
			hero.stop_movement()
			_rotate_hero_towards(t_pos, delta)
			if hero.can_attack():
				hero.set_attacking_state()
				hero.execute_basic_attack(targeted_enemy)
			if hero.attack_controller != null and hero.attack_controller.attack_target == null:
				hero.attack_controller.issue_attack_command(targeted_enemy)
		else:
			hero.move_to_location(t_pos)
			
	# 2. Tracking and Moving into Spell Cast Range
	elif pending_spell != null:
		var target_pos = pending_spell.target_point
		if pending_spell.target_entity != null:
			if not is_instance_valid(pending_spell.target_entity) or not pending_spell.target_entity.is_alive():
				pending_spell = null
				hero.stop_movement()
				return
			target_pos = pending_spell.target_entity.global_position
			hero.move_to_location(target_pos)
			
		var dist = hero.global_position.distance_to(target_pos)
		if dist <= pending_spell.cast_range:
			# REACHED EFFECTIVE RANGE -> STOP AND CAST!
			hero.stop_movement()
			_rotate_hero_towards(target_pos, delta)
			if pending_spell.is_item:
				if hero.inventory_manager != null:
					hero.inventory_manager.use_active_item(pending_spell.slot_id, pending_spell.target_entity, pending_spell.target_point)
			else:
				_execute_spell(pending_spell.slot_id as AbilityResource.Slot, pending_spell.target_entity, pending_spell.target_point)
			pending_spell = null

func _process(_delta: float) -> void:
	if is_targeting_active and targeting_indicator != null and hero != null:
		var mouse_world = _get_mouse_world_position()
		locked_target_unit = _find_soft_lock_unit(mouse_world, 3.2)
		targeting_indicator.update_cursor_position(hero.global_position, mouse_world, locked_target_unit)

func _find_soft_lock_unit(mouse_world: Vector3, snap_radius: float = 3.2) -> BaseCombatEntity:
	var ab: AbilityResource = null
	if pending_spell_slot >= 0 and pending_spell_slot <= 4 and hero != null and hero.ability_container != null:
		ab = hero.ability_container.get_ability(pending_spell_slot as AbilityResource.Slot)
		
	# 1. Check direct ray hit under cursor first
	var under_cursor = _get_unit_under_cursor()
	if under_cursor != null and is_instance_valid(under_cursor) and under_cursor.is_alive():
		if ab == null or ab.is_valid_target(hero, under_cursor):
			return under_cursor
		
	# 2. Check nearby combat entities within magnetic snap radius
	var nodes = get_tree().get_nodes_in_group("combat_entities") if get_tree() != null else []
	var closest: BaseCombatEntity = null
	var closest_dist: float = snap_radius
	
	for n in nodes:
		if is_instance_valid(n) and n is BaseCombatEntity and n.is_alive():
			if ab == null or ab.is_valid_target(hero, n):
				var d = mouse_world.distance_to(n.global_position)
				if d < closest_dist:
					closest_dist = d
					closest = n
	return closest

func _find_nearest_enemy_in_range(max_range: float) -> BaseCombatEntity:
	if hero == null or not hero.is_alive():
		return null
	var tree = get_tree()
	if tree == null:
		return null
		
	var h_pos = hero.global_position if hero.is_inside_tree() else hero.position
	var candidates = tree.get_nodes_in_group("combat_entities")
	var best_target: BaseCombatEntity = null
	var best_score: float = 999999.0
	
	for node in candidates:
		if node is BaseCombatEntity and is_instance_valid(node) and node != hero:
			if node.is_alive() and node.is_targetable and TargetRelationSystem.is_valid_basic_attack_target(hero, node):
				var n_pos = node.global_position if node.is_inside_tree() else node.position
				var dist = h_pos.distance_to(n_pos)
				if dist <= max_range:
					var hp_pct = 1.0
					if node.attribute_system != null:
						var cur_h = node.attribute_system.current_health
						var max_h = node.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
						hp_pct = cur_h / maxf(1.0, max_h)
					var is_creep = (node is CreepEntity)
					# Prioritize creeps with lowest HP for smooth minion wave clearing
					var score = dist + (hp_pct * 8.0) - (40.0 if is_creep else 0.0)
					if score < best_score:
						best_score = score
						best_target = node
						
	return best_target

func _rotate_hero_towards(target_pos: Vector3, delta: float) -> void:
	var look_dir = target_pos - hero.global_position
	look_dir.y = 0.0
	if look_dir.length_squared() > 0.01:
		var target_rot_y = atan2(look_dir.x, look_dir.z)
		hero.rotation.y = lerp_angle(hero.rotation.y, target_rot_y, 16.0 * delta)

func _input(event: InputEvent) -> void:
	if hero == null or not hero.is_alive():
		return
		
	# Mouse Motion updates targeting indicator
	if event is InputEventMouseMotion and is_targeting_active and targeting_indicator != null:
		var mouse_world = _get_mouse_world_position()
		locked_target_unit = _find_soft_lock_unit(mouse_world, 3.2)
		targeting_indicator.update_cursor_position(hero.global_position, mouse_world, locked_target_unit)
		
	# Left Click: Confirm spell targeting or select unit
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if is_targeting_active:
			_confirm_targeting_cast()
		else:
			_handle_left_click(event.position)
		
	# Right Click: Cancel targeting or Move/Attack
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if is_targeting_active:
			_cancel_targeting()
		else:
			_handle_right_click(event.position)
		
	# Keyboard Hotkeys
	if event is InputEventKey:
		var is_ctrl = Input.is_key_pressed(KEY_CTRL)
		if event.pressed and not event.echo:
			match event.keycode:
				KEY_ESCAPE:
					if is_targeting_active:
						_cancel_targeting()
				KEY_F1, KEY_SPACE:
					select_unit(hero)
				KEY_B, KEY_P:
					var hud = get_tree().root.find_child("DotaHUD", true, false)
					if hud != null and hud.has_method("_toggle_shop"):
						hud._toggle_shop()
				KEY_Q:
					if is_ctrl: _level_up_ability(AbilityResource.Slot.Q)
					else:
						active_held_key_slot = AbilityResource.Slot.Q
						_cast_spell(AbilityResource.Slot.Q)
				KEY_W:
					if is_ctrl: _level_up_ability(AbilityResource.Slot.W)
					else:
						active_held_key_slot = AbilityResource.Slot.W
						_cast_spell(AbilityResource.Slot.W)
				KEY_E:
					if is_ctrl: _level_up_ability(AbilityResource.Slot.E)
					else:
						active_held_key_slot = AbilityResource.Slot.E
						_cast_spell(AbilityResource.Slot.E)
				KEY_R:
					if is_ctrl: _level_up_ability(AbilityResource.Slot.R)
					else:
						active_held_key_slot = AbilityResource.Slot.R
						_cast_spell(AbilityResource.Slot.R)
				KEY_1: _use_item_slot(0)
				KEY_2: _use_item_slot(1)
				KEY_3: _use_item_slot(2)
				KEY_4: _use_item_slot(3)
				KEY_5: _use_item_slot(4)
				KEY_6: _use_item_slot(5)
				KEY_S: _stop_command()
		elif not event.pressed:
			# Key Released! If player released Q/W/E/R while targeting, cancel targeting indicator
			match event.keycode:
				KEY_Q:
					if is_targeting_active and pending_spell_slot == AbilityResource.Slot.Q:
						_cancel_targeting()
				KEY_W:
					if is_targeting_active and pending_spell_slot == AbilityResource.Slot.W:
						_cancel_targeting()
				KEY_E:
					if is_targeting_active and pending_spell_slot == AbilityResource.Slot.E:
						_cancel_targeting()
				KEY_R:
					if is_targeting_active and pending_spell_slot == AbilityResource.Slot.R:
						_cancel_targeting()

func _stop_command() -> void:
	_cancel_targeting()
	pending_spell = null
	targeted_enemy = null
	is_moving_to_attack = false
	if hero != null:
		hero.clear_combat_target()
		hero.stop_movement()
	if current_command != null:
		current_command.is_completed = true
	current_command = PlayerCommand.new(CommandType.NONE)

func _level_up_ability(slot: AbilityResource.Slot) -> void:
	if hero != null and hero.ability_container != null:
		hero.ability_container.level_up_ability(slot)

# ==============================================================================
# TARGETING INDICATORS & CONFIRMATION
# ==============================================================================
func _show_targeting(slot_id: int, max_range: float, aoe_radius: float, col: Color) -> void:
	is_targeting_active = true
	pending_spell_slot = slot_id
	if targeting_indicator != null and hero != null:
		targeting_indicator.show_indicator(hero.global_position, max_range, aoe_radius, col)
		var mouse_world = _get_mouse_world_position()
		targeting_indicator.update_cursor_position(hero.global_position, mouse_world)

func _confirm_targeting_cast() -> void:
	if not is_targeting_active:
		return
		
	var mouse_world = _get_mouse_world_position()
	var target_ent = locked_target_unit
	if target_ent == null:
		target_ent = _get_unit_under_cursor()
	if target_ent == null:
		target_ent = _get_enemy_under_cursor()
		
	if pending_spell_slot >= 0 and pending_spell_slot <= 4:
		var slot = pending_spell_slot as AbilityResource.Slot
		_queue_or_execute_spell(slot, target_ent, mouse_world)
	elif pending_spell_slot >= 10 and pending_spell_slot <= 15:
		var slot_idx = pending_spell_slot - 10
		_queue_or_execute_item(slot_idx, target_ent, mouse_world)
			
	_cancel_targeting()

func _cancel_targeting() -> void:
	is_targeting_active = false
	pending_spell_slot = -1
	active_held_key_slot = -1
	locked_target_unit = null
	if targeting_indicator != null:
		targeting_indicator.hide_indicator()

# ==============================================================================
# ACTIVE ITEM HOTKEYS (1-6)
# ==============================================================================
func _use_item_slot(slot_idx: int) -> void:
	if hero == null or not hero.is_alive() or hero.inventory_manager == null:
		return
		
	var item = hero.inventory_manager.slots[slot_idx] if slot_idx < hero.inventory_manager.slots.size() else null
	if item == null:
		return
		
	var mode := hero.inventory_manager.get_active_item_target_mode(slot_idx)
	if mode == "self":
		hero.inventory_manager.use_active_item(slot_idx)
		return
	var item_range := 12.0 if mode == "ground" else 8.0
	var indicator_color := Color(0.25, 0.78, 1.0, 0.5) if mode == "ally" else Color(0.95, 0.65, 0.15, 0.5)
	_show_targeting(10 + slot_idx, item_range, 2.0 if mode == "ground" else 1.2, indicator_color)
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("%s: %s hedefi seç • Sol tık onay, sağ tık iptal" % [item.item_name.to_upper(), _get_item_target_prompt(mode)])

func _get_item_target_prompt(mode: String) -> String:
	match mode:
		"enemy": return "DÜŞMAN"
		"ally": return "DOST"
		"unit": return "BİRİM"
		"ground": return "ZEMİN"
		_: return "HEDEF"

# ==============================================================================
# SELECTION SYSTEM
# ==============================================================================
func select_unit(unit: BaseCombatEntity) -> void:
	if selected_unit != null and selected_unit != unit:
		clear_selection()
		
	selected_unit = unit
	if selected_unit != null:
		var is_enemy = TargetRelationSystem.is_enemy(hero, selected_unit)
		target_selected.emit(selected_unit, is_enemy)
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.target_selected.emit(selected_unit)
	else:
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.target_cleared.emit()

func clear_selection() -> void:
	selected_unit = null
	selection_cleared.emit()
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.target_cleared.emit()

func is_friendly_selected() -> bool:
	return selected_unit != null and hero != null and TargetRelationSystem.is_ally(hero, selected_unit)

func is_enemy_selected() -> bool:
	return selected_unit != null and hero != null and TargetRelationSystem.is_enemy(hero, selected_unit)

var selected_courier: CharacterBody3D = null

func select_courier(courier: CharacterBody3D) -> void:
	if selected_courier != null and is_instance_valid(selected_courier) and selected_courier.has_method("set_selected"):
		selected_courier.set_selected(false)
	selected_courier = courier
	if selected_courier != null and is_instance_valid(selected_courier):
		if selected_courier.has_method("set_selected"):
			selected_courier.set_selected(true)
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.target_selected.emit(selected_courier)
			GameEvents.combat_log_generated.emit("KURYE KONTROLÜ SEÇİLDİ (Sağ Tıkla Yönlendirin)")
		selected_unit = null
		target_selected.emit(null, false)
	else:
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.target_selected.emit(hero)

func _handle_left_click(screen_pos: Vector2) -> void:
	if camera == null:
		camera = get_viewport().get_camera_3d()
	if camera == null or hero == null:
		return
		
	var ray_origin = camera.project_ray_origin(screen_pos)
	var ray_dir = camera.project_ray_normal(screen_pos)
	var space_state = hero.get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + (ray_dir * 1000.0))
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	
	if not result.is_empty():
		var collider = result.get("collider")
		var pickup = _get_item_pickup_from_collider(collider)
		if pickup != null and is_instance_valid(pickup) and pickup.item_data != null:
			_inspect_world_item(pickup)
			return
		
		# 1. Check if clicked on Courier
		if collider is CharacterBody3D and collider.is_in_group("couriers"):
			select_courier(collider as CharacterBody3D)
			return
		elif collider != null and collider.get_parent() is CharacterBody3D and collider.get_parent().is_in_group("couriers"):
			select_courier(collider.get_parent() as CharacterBody3D)
			return
			
		# 2. Check if clicked on Combat Entity
		var target_ent: BaseCombatEntity = null
		if collider is BaseCombatEntity:
			target_ent = collider as BaseCombatEntity
		elif collider != null and collider.get_parent() is BaseCombatEntity:
			target_ent = collider.get_parent() as BaseCombatEntity
		elif collider != null and collider.owner is BaseCombatEntity:
			target_ent = collider.owner as BaseCombatEntity
			
		if target_ent != null and is_instance_valid(target_ent) and target_ent.is_alive():
			select_courier(null)
			select_unit(target_ent)
			return
			
	select_courier(null)
	select_unit(hero)

func _get_item_pickup_from_collider(collider: Node) -> ItemPickup3D:
	if collider is ItemPickup3D:
		return collider as ItemPickup3D
	if collider != null and collider.get_parent() is ItemPickup3D:
		return collider.get_parent() as ItemPickup3D
	return null

func _inspect_world_item(pickup: ItemPickup3D) -> void:
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.world_item_selected.emit(pickup)
		GameEvents.combat_log_generated.emit("YERDEKİ EŞYA SEÇİLDİ: %s" % pickup.item_data.item_name.to_upper())

func _command_pickup_world_item(pickup: ItemPickup3D) -> void:
	pending_item_pickup = pickup
	hero.move_to_location(pickup.global_position)
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("EŞYA TOPLAMA EMRİ: %s" % pickup.item_data.item_name.to_upper())

# ==============================================================================
# COMMAND SYSTEM
# ==============================================================================
func _handle_right_click(screen_pos: Vector2) -> void:
	if camera == null:
		camera = get_viewport().get_camera_3d()
	if camera == null or hero == null or not hero.is_alive():
		return
		
	var ray_origin = camera.project_ray_origin(screen_pos)
	var ray_dir = camera.project_ray_normal(screen_pos)
	var space_state = hero.get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + (ray_dir * 1000.0))
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	
	var target_dest: Vector3 = Vector3.ZERO
	if not result.is_empty():
		target_dest = result.get("position", Vector3.ZERO)
	else:
		if absf(ray_dir.y) > 0.0001:
			var t = -ray_origin.y / ray_dir.y
			target_dest = ray_origin + (ray_dir * t)
			
	# If courier is actively selected -> Direct courier movement!
	if selected_courier != null and is_instance_valid(selected_courier):
		if selected_courier.has_method("move_to_point"):
			selected_courier.move_to_point(target_dest)
		_spawn_click_decal(target_dest, Color(0.2, 0.9, 0.4), false)
		return
		
	if not result.is_empty():
		var collider = result.get("collider")
		var pickup = _get_item_pickup_from_collider(collider)
		if pickup != null and is_instance_valid(pickup) and pickup.item_data != null:
			_command_pickup_world_item(pickup)
			return
		if collider is BaseCombatEntity and collider != hero:
			var target_ent = collider as BaseCombatEntity
			if TargetRelationSystem.is_valid_basic_attack_target(hero, target_ent):
				issue_attack_command(target_ent)
				return
			elif TargetRelationSystem.is_ally(hero, target_ent):
				issue_interact_command(target_ent)
				return
				
		issue_move_command(target_dest)
	else:
		if target_dest != Vector3.ZERO:
			issue_move_command(target_dest)

func issue_move_command(target_pos: Vector3) -> PlayerCommand:
	if hero == null or not hero.is_alive():
		return null
		
	targeted_enemy = null
	pending_spell = null
	is_moving_to_attack = false
	hero.clear_combat_target()
	if hero.attack_controller != null:
		hero.attack_controller.notify_move_command_issued()
	
	current_command = PlayerCommand.new(CommandType.MOVE, target_pos)
	hero.move_to_location(target_pos)
	
	_spawn_click_decal(target_pos, Color(0.2, 0.9, 0.3, 0.9), false)
	command_issued.emit(current_command)
	return current_command

func issue_attack_command(target_ent: BaseCombatEntity) -> PlayerCommand:
	if hero == null or not hero.is_alive() or target_ent == null or not target_ent.is_alive():
		return null
	if not TargetRelationSystem.is_valid_basic_attack_target(hero, target_ent):
		return null
		
	pending_spell = null
	targeted_enemy = target_ent
	hero.set_combat_target(target_ent)
	is_moving_to_attack = true
	
	if hero.attack_controller != null:
		hero.attack_controller.issue_attack_command(target_ent)
	
	var target_pos = target_ent.global_position if target_ent.is_inside_tree() else target_ent.position
	current_command = PlayerCommand.new(CommandType.ATTACK_TARGET, target_pos, target_ent)
	
	var is_deny = (target_ent.team == hero.team)
	var decal_color = Color(0.2, 0.85, 1.0, 0.95) if is_deny else Color(0.95, 0.2, 0.2, 0.9)
	_spawn_click_decal(target_pos, decal_color, true)
	command_issued.emit(current_command)
	return current_command

func issue_interact_command(target_ent: BaseCombatEntity) -> PlayerCommand:
	if hero == null or not hero.is_alive() or target_ent == null:
		return null
		
	pending_spell = null
	targeted_enemy = null
	is_moving_to_attack = false
	hero.clear_combat_target()
	
	current_command = PlayerCommand.new(CommandType.INTERACT, target_ent.global_position, target_ent)
	select_unit(target_ent)
	hero.move_to_location(target_ent.global_position)
		
	_spawn_click_decal(target_ent.global_position, Color(0.3, 0.6, 0.95, 0.9), false)
	command_issued.emit(current_command)
	return current_command

func _spawn_click_decal(pos: Vector3, color: Color, is_attack: bool) -> void:
	if get_tree() != null and get_tree().root != null:
		var marker = ClickMarkerClass.new()
		get_tree().root.add_child(marker)
		marker.global_position = pos
		marker.setup(color, is_attack)

# ==============================================================================
# SPELL CASTING
# ==============================================================================
func _cast_spell(slot: AbilityResource.Slot) -> void:
	if hero == null or hero.ability_container == null:
		return
		
	var ab = hero.ability_container.get_ability(slot)
	if ab == null:
		return
		
	var lvl = hero.ability_container.ability_levels.get(slot, 0)
	if lvl <= 0 and not hero.ability_container.is_free_spells_active:
		return
		
	# 1. Instant Self Spells (Astris E, Kaelgor E / R, Passive)
	if ab.target_type == AbilityResource.TargetType.SELF or ab.is_passive or slot == AbilityResource.Slot.PASSIVE:
		_execute_spell(slot, hero, hero.global_position)
		return
		
	if hero is AstrisHero and slot == AbilityResource.Slot.E:
		_execute_spell(slot, hero, hero.global_position)
		return
	if hero is KaelgorHero and (slot == AbilityResource.Slot.E or slot == AbilityResource.Slot.R):
		_execute_spell(slot, hero, hero.global_position)
		return
		
	# 2. Targeted & Ground AOE Spells -> Activate 3D Ground Targeting Indicator
	var max_range = 10.0
	var aoe_radius = 2.0
	var col = Color(0.2, 0.85, 1.0, 0.5)
	
	if hero is AstrisHero:
		match slot:
			AbilityResource.Slot.Q:
				max_range = 11.0
				aoe_radius = 1.2
				col = Color(0.25, 0.85, 1.0, 0.55) # Cyan Lance
			AbilityResource.Slot.W:
				max_range = 12.0
				aoe_radius = 3.5
				col = Color(1.0, 0.82, 0.2, 0.55) # Gold Burst
			AbilityResource.Slot.R:
				max_range = 15.0
				aoe_radius = 6.0
				col = Color(0.85, 0.3, 1.0, 0.6) # Starfall Purple
	elif hero is KaelgorHero:
		match slot:
			AbilityResource.Slot.Q:
				max_range = 5.5
				aoe_radius = 2.0
				col = Color(0.95, 0.3, 0.2, 0.55) # Red Slam
			AbilityResource.Slot.W:
				max_range = 4.5
				aoe_radius = 4.5
				col = Color(1.0, 0.5, 0.1, 0.55) # Fire Roar
	else:
		max_range = maxf(4.0, ab.get_cast_range(lvl))
		aoe_radius = 2.5
		col = Color(0.3, 0.85, 1.0, 0.5)
		
	_show_targeting(slot as int, max_range, aoe_radius, col)

func _get_spell_cast_range(slot: AbilityResource.Slot) -> float:
	if hero is AstrisHero:
		match slot:
			AbilityResource.Slot.Q: return 11.0
			AbilityResource.Slot.W: return 12.0
			AbilityResource.Slot.E: return 0.0 # Self
			AbilityResource.Slot.R: return 15.0
	elif hero is KaelgorHero:
		match slot:
			AbilityResource.Slot.Q: return 5.5
			AbilityResource.Slot.W: return 4.5
			AbilityResource.Slot.E: return 0.0 # Self
			AbilityResource.Slot.R: return 0.0 # Self
	elif hero != null and hero.ability_container != null:
		var ab = hero.ability_container.get_ability(slot)
		if ab != null:
			var lvl = max(1, hero.ability_container.ability_levels.get(slot, 1))
			return maxf(4.0, ab.get_cast_range(lvl))
	return 8.0

func _queue_or_execute_spell(slot: AbilityResource.Slot, target_ent: BaseCombatEntity, mouse_world: Vector3) -> void:
	if hero == null or not hero.is_alive():
		return
		
	var effective_range = _get_spell_cast_range(slot)
	
	# If self-cast spell, execute immediately
	var hero_pos = hero.global_position if hero.is_inside_tree() else hero.position
	if effective_range <= 0.0 or slot == AbilityResource.Slot.PASSIVE:
		_execute_spell(slot, hero, hero_pos)
		return
		
	var target_pos = Vector3.ZERO
	if target_ent != null and is_instance_valid(target_ent):
		target_pos = target_ent.global_position if target_ent.is_inside_tree() else target_ent.position
	else:
		target_pos = mouse_world
		
	var dist = hero_pos.distance_to(target_pos)
	
	if dist <= effective_range:
		# IN RANGE -> CAST IMMEDIATELY
		pending_spell = null
		hero.stop_movement()
		_rotate_hero_towards(target_pos, 1.0)
		_execute_spell(slot, target_ent, mouse_world)
	else:
		# OUT OF RANGE -> NEVER CAST YET! WALK TOWARDS TARGET UNTIL IN RANGE!
		pending_spell = PendingSpellCast.new()
		pending_spell.is_item = false
		pending_spell.slot_id = slot as int
		pending_spell.target_entity = target_ent
		pending_spell.target_point = mouse_world
		pending_spell.cast_range = effective_range
		
		targeted_enemy = null
		is_moving_to_attack = false
		hero.move_to_location(target_pos)
		_spawn_click_decal(target_pos, Color(0.2, 0.85, 1.0, 0.9), false)

func _queue_or_execute_item(slot_idx: int, target_ent: BaseCombatEntity, mouse_world: Vector3) -> void:
	if hero == null or not hero.is_alive() or hero.inventory_manager == null:
		return
		
	var target_mode := hero.inventory_manager.get_active_item_target_mode(slot_idx)
	if target_mode == "enemy" and (target_ent == null or target_ent.team == hero.team):
		return
	if target_mode == "ally" and (target_ent == null or target_ent.team != hero.team):
		return
	if target_mode == "unit" and target_ent == null:
		return
	var effective_range = 12.0 if target_mode == "ground" else 8.0
	var hero_pos = hero.global_position if hero.is_inside_tree() else hero.position
	var target_pos = Vector3.ZERO
	if target_ent != null and is_instance_valid(target_ent):
		target_pos = target_ent.global_position if target_ent.is_inside_tree() else target_ent.position
	else:
		target_pos = mouse_world
		
	var dist = hero_pos.distance_to(target_pos)
	
	if dist <= effective_range:
		pending_spell = null
		hero.stop_movement()
		hero.inventory_manager.use_active_item(slot_idx, target_ent, mouse_world)
	else:
		pending_spell = PendingSpellCast.new()
		pending_spell.is_item = true
		pending_spell.slot_id = slot_idx
		pending_spell.target_entity = target_ent
		pending_spell.target_point = mouse_world
		pending_spell.cast_range = effective_range
		
		targeted_enemy = null
		is_moving_to_attack = false
		hero.move_to_location(target_pos)
		_spawn_click_decal(target_pos, Color(0.9, 0.75, 0.2, 0.9), false)

func _execute_spell(slot: AbilityResource.Slot, target_ent: BaseCombatEntity, mouse_world: Vector3) -> void:
	if hero != null and hero.ability_container != null:
		hero.ability_container.cast_ability(slot, target_ent, mouse_world)

func _get_mouse_world_position() -> Vector3:
	if camera == null:
		camera = get_viewport().get_camera_3d()
	if camera == null or hero == null:
		return hero.global_position if hero != null else Vector3.ZERO
		
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_dir = camera.project_ray_normal(mouse_pos)
	
	if absf(ray_dir.y) > 0.0001:
		var t = -ray_origin.y / ray_dir.y
		return ray_origin + ray_dir * t
	return hero.global_position

func _get_unit_under_cursor() -> BaseCombatEntity:
	if camera == null:
		camera = get_viewport().get_camera_3d()
	if camera == null or hero == null:
		return null
		
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_dir = camera.project_ray_normal(mouse_pos)
	var space_state = hero.get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + (ray_dir * 1000.0))
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	
	if not result.is_empty():
		var collider = result.get("collider")
		if collider is BaseCombatEntity and collider.is_alive():
			return collider as BaseCombatEntity
	return null

func _get_enemy_under_cursor() -> BaseCombatEntity:
	if camera == null:
		camera = get_viewport().get_camera_3d()
	if camera == null or hero == null:
		return null
		
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_dir = camera.project_ray_normal(mouse_pos)
	var space_state = hero.get_world_3d().direct_space_state
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_origin + (ray_dir * 1000.0))
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	
	if not result.is_empty():
		var collider = result.get("collider")
		if collider is BaseCombatEntity and collider != hero and collider.team != hero.team and collider.is_alive():
			return collider as BaseCombatEntity
	return null

func _get_closest_enemy_to_cursor() -> BaseCombatEntity:
	var enemies = get_tree().get_nodes_in_group("combat_entities") if get_tree() != null else []
	var closest: BaseCombatEntity = null
	var closest_dist: float = 9999.0
	
	for e in enemies:
		if e is BaseCombatEntity and e != hero and is_instance_valid(e) and e.is_alive() and e.team != hero.team:
			var d = hero.global_position.distance_to(e.global_position)
			if d < closest_dist:
				closest_dist = d
				closest = e
				
	return closest

func _get_all_enemies_in_range(radius_m: float) -> Array[BaseCombatEntity]:
	var result: Array[BaseCombatEntity] = []
	var nodes = get_tree().get_nodes_in_group("combat_entities") if get_tree() != null else []
	
	for n in nodes:
		if n is BaseCombatEntity and n != hero and is_instance_valid(n) and n.is_alive() and n.team != hero.team:
			var d = hero.global_position.distance_to(n.global_position)
			if d <= radius_m:
				result.append(n)
				
	return result
