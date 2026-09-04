class_name CourierEntity
extends CharacterBody3D

## High-Performance Flying Courier for Eclipse Front
## Delivers purchased items directly from base to hero across terrain with speed burst & auto-return.

enum CourierState {
	IDLE_AT_BASE,
	DELIVERING_TO_HERO,
	RETURNING_HOME,
	FOLLOWING_HERO,
	MOVING_TO_POINT,
	HOLD_POSITION
}

signal items_delivered(to_hero: BaseCombatEntity, items_count: int)
signal courier_state_changed(new_state: CourierState)

const MAX_COURIER_SLOTS = 6

@export var team: TeamDefinitions.Team = TeamDefinitions.Team.RADIANT
@export var base_flight_speed: float = 9.0
@export var burst_flight_speed: float = 18.0
@export var flight_altitude: float = 3.2
@export var delivery_radius: float = 3.0

var home_position: Vector3 = Vector3(0, 3.2, 0)
var target_hero: BaseCombatEntity = null
var target_move_point: Vector3 = Vector3.ZERO
var courier_slots: Array[ItemResource] = []
var state: CourierState = CourierState.IDLE_AT_BASE
var is_selected: bool = false

var is_burst_active: bool = false
var burst_timer: float = 0.0
var burst_cooldown_remaining: float = 0.0
const BURST_DURATION: float = 4.0
const BURST_COOLDOWN: float = 60.0

var _body_mesh: MeshInstance3D = null
var _left_wing: MeshInstance3D = null
var _right_wing: MeshInstance3D = null
var _propulsion_light: OmniLight3D = null
var _label_3d: Label3D = null
var _selection_ring: MeshInstance3D = null
var _collision_shape: CollisionShape3D = null
var _anim_time: float = 0.0

func _init() -> void:
	courier_slots = []
	courier_slots.resize(MAX_COURIER_SLOTS)
	for i in range(MAX_COURIER_SLOTS):
		courier_slots[i] = null

func _ready() -> void:
	if courier_slots.size() < MAX_COURIER_SLOTS:
		courier_slots.resize(MAX_COURIER_SLOTS)
		for i in range(MAX_COURIER_SLOTS):
			courier_slots[i] = null
			
	collision_layer = 1 | 2
	collision_mask = 0
	
	_build_visuals()
	add_to_group("couriers")
	add_to_group("selectable_units")

func _build_visuals() -> void:
	if _body_mesh != null: _body_mesh.queue_free()
	if _selection_ring != null: _selection_ring.queue_free()
	if _collision_shape != null: _collision_shape.queue_free()

	# 0. Collision Shape for Raycast Mouse Selection
	_collision_shape = CollisionShape3D.new()
	var sphere = SphereShape3D.new()
	sphere.radius = 1.4
	_collision_shape.shape = sphere
	add_child(_collision_shape)

	# 1. Drone Central Core
	_body_mesh = MeshInstance3D.new()
	var body_sphere = SphereMesh.new()
	body_sphere.radius = 0.55
	body_sphere.height = 0.85
	_body_mesh.mesh = body_sphere
	
	var mat = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	var col = Color(0.0, 0.86, 0.95) if team == TeamDefinitions.Team.RADIANT else Color(0.95, 0.35, 0.35)
	mat.albedo_color = col
	mat.emission_enabled = true
	mat.emission = col
	mat.emission_energy_multiplier = 4.0
	_body_mesh.material_override = mat
	add_child(_body_mesh)
	
	# 2. Golden / Cyan Wings
	_left_wing = MeshInstance3D.new()
	var wing_mesh = BoxMesh.new()
	wing_mesh.size = Vector3(1.1, 0.06, 0.45)
	_left_wing.mesh = wing_mesh
	_left_wing.position = Vector3(-0.75, 0.0, 0.0)
	_left_wing.material_override = mat
	add_child(_left_wing)
	
	_right_wing = MeshInstance3D.new()
	_right_wing.mesh = wing_mesh
	_right_wing.position = Vector3(0.75, 0.0, 0.0)
	_right_wing.material_override = mat
	add_child(_right_wing)
	
	# 3. Thruster Light
	_propulsion_light = OmniLight3D.new()
	_propulsion_light.light_color = col
	_propulsion_light.light_energy = 4.0
	_propulsion_light.omni_range = 6.0
	add_child(_propulsion_light)
	
	# 4. Selection Ring
	_selection_ring = MeshInstance3D.new()
	var ring_mesh = TorusMesh.new()
	ring_mesh.inner_radius = 1.2
	ring_mesh.outer_radius = 1.4
	_selection_ring.mesh = ring_mesh
	_selection_ring.position.y = -flight_altitude + 0.1
	var ring_mat = StandardMaterial3D.new()
	ring_mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	ring_mat.albedo_color = Color(1.0, 0.85, 0.2, 0.8)
	ring_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_selection_ring.material_override = ring_mat
	_selection_ring.visible = false
	add_child(_selection_ring)
	
	# 5. Overhead Tag
	_label_3d = Label3D.new()
	_label_3d.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	_label_3d.no_depth_test = true
	_label_3d.font_size = 16
	_label_3d.modulate = Color(1.0, 0.85, 0.3)
	_label_3d.outline_modulate = Color(0, 0, 0, 1)
	_label_3d.outline_size = 4
	_label_3d.position.y = 1.1
	_label_3d.text = "UÇAN KURYE (F2)"
	add_child(_label_3d)

func set_selected(p_sel: bool) -> void:
	is_selected = p_sel
	if _selection_ring != null:
		_selection_ring.visible = p_sel

func move_to_point(target_pos: Vector3) -> void:
	target_move_point = Vector3(target_pos.x, target_pos.y + flight_altitude, target_pos.z)
	state = CourierState.MOVING_TO_POINT
	courier_state_changed.emit(state)
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("KURYE HAREKET EDİYOR: %s" % str(target_pos))

func _physics_process(delta: float) -> void:
	_anim_time += delta
	# Wing flapping animation
	if _left_wing != null and _right_wing != null:
		var flap = sin(_anim_time * (18.0 if is_burst_active else 9.0)) * 0.45
		_left_wing.rotation.z = flap
		_right_wing.rotation.z = -flap
		
	# Burst timer update
	if burst_cooldown_remaining > 0.0:
		burst_cooldown_remaining = maxf(0.0, burst_cooldown_remaining - delta)
	if is_burst_active:
		burst_timer -= delta
		if burst_timer <= 0.0:
			is_burst_active = false
			
	var current_speed = burst_flight_speed if is_burst_active else base_flight_speed
	
	var current_pos = global_position if is_inside_tree() else position

	match state:
		CourierState.IDLE_AT_BASE:
			velocity = Vector3.ZERO
			# Hover bob at base
			position.y = home_position.y + sin(_anim_time * 2.0) * 0.15
			
		CourierState.MOVING_TO_POINT:
			var dist = current_pos.distance_to(target_move_point)
			if dist <= 1.0:
				velocity = Vector3.ZERO
				state = CourierState.HOLD_POSITION
				courier_state_changed.emit(state)
			else:
				var dir = (target_move_point - current_pos).normalized()
				velocity = dir * current_speed
				if is_inside_tree():
					move_and_slide()
					if velocity.length_squared() > 0.01:
						look_at(global_position + Vector3(velocity.x, 0, velocity.z), Vector3.UP)
				else:
					position += velocity * delta
					
		CourierState.HOLD_POSITION:
			velocity = Vector3.ZERO
			position.y = (home_position.y if home_position.y > 0 else 3.2) + sin(_anim_time * 2.0) * 0.15
			
		CourierState.DELIVERING_TO_HERO:
			if target_hero == null or not is_instance_valid(target_hero) or not target_hero.is_alive():
				return_to_base()
				return
				
			var hero_pos = target_hero.global_position if target_hero.is_inside_tree() else target_hero.position
			var target_flight_pos = Vector3(hero_pos.x, hero_pos.y + flight_altitude, hero_pos.z)
			var dist = current_pos.distance_to(target_flight_pos)
			
			if dist <= delivery_radius:
				_transfer_items_to_hero()
				return_to_base()
			else:
				var dir = (target_flight_pos - current_pos).normalized()
				velocity = dir * current_speed
				if is_inside_tree():
					move_and_slide()
					if velocity.length_squared() > 0.01:
						look_at(global_position + Vector3(velocity.x, 0, velocity.z), Vector3.UP)
				else:
					position += velocity * delta
					
		CourierState.RETURNING_HOME:
			var dist = current_pos.distance_to(home_position)
			if dist <= 1.0:
				if is_inside_tree():
					global_position = home_position
				else:
					position = home_position
				velocity = Vector3.ZERO
				state = CourierState.IDLE_AT_BASE
				courier_state_changed.emit(state)
			else:
				var dir = (home_position - current_pos).normalized()
				velocity = dir * current_speed
				if is_inside_tree():
					move_and_slide()
					if velocity.length_squared() > 0.01:
						look_at(global_position + Vector3(velocity.x, 0, velocity.z), Vector3.UP)
				else:
					position += velocity * delta

func deliver_items_to(hero: BaseCombatEntity) -> void:
	if hero == null or not is_instance_valid(hero):
		return
	target_hero = hero
	state = CourierState.DELIVERING_TO_HERO
	courier_state_changed.emit(state)
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("KURYE YOLA ÇIKTI: EŞYALARI GETİRİYOR")

func return_to_base() -> void:
	state = CourierState.RETURNING_HOME
	courier_state_changed.emit(state)

func activate_burst() -> bool:
	if burst_cooldown_remaining > 0.0:
		return false
	is_burst_active = true
	burst_timer = BURST_DURATION
	burst_cooldown_remaining = BURST_COOLDOWN
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("KURYE HIZLANDIRMA (BURST) AKTİF!")
	return true

func add_item_to_courier(item: ItemResource) -> bool:
	if item == null:
		return false
	for i in range(MAX_COURIER_SLOTS):
		if courier_slots[i] == null:
			courier_slots[i] = item
			return true
	return false

func get_held_items_count() -> int:
	var count = 0
	for s in courier_slots:
		if s != null:
			count += 1
	return count

func _transfer_items_to_hero() -> void:
	if target_hero == null or target_hero.inventory_manager == null:
		return
		
	var inv: InventoryManager = target_hero.inventory_manager
	var delivered_count = 0
	
	for i in range(MAX_COURIER_SLOTS):
		var it = courier_slots[i]
		if it != null:
			if inv.has_empty_normal_slot() or (it.is_boots() and inv.boots_slot == null):
				inv.equip_item(it)
				courier_slots[i] = null
				delivered_count += 1
				
	if delivered_count > 0:
		items_delivered.emit(target_hero, delivered_count)
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("KURYE TESLİMATI TAMAMLADI: %d EŞYA AKTARILDI" % delivered_count)
