class_name MobaCamera3D
extends Camera3D

## Pure RTS/MOBA Camera: Edge Panning, Middle Mouse Drag, Wheel Zoom & Spacebar Focus with Hard Boundary Clamping

@export var target_to_follow: Node3D = null
@export var pan_speed: float = 55.0
@export var edge_margin_pixels: float = 36.0
@export var enable_edge_pan: bool = true

@export var min_height: float = 4.5 # Yakın zoom desteği (Karakter omzuna kadar yaklaşır)
@export var max_height: float = 38.0
@export var zoom_speed: float = 2.5

var is_locked_to_hero: bool = false
var is_permanent_lock: bool = false
var is_middle_dragging: bool = false
var last_mouse_screen_pos: Vector2 = Vector2.ZERO

var camera_offset: Vector3 = Vector3(0.0, 18.0, 14.0)
var min_boundary: Vector2 = Vector2(-140.0, -140.0)
var max_boundary: Vector2 = Vector2(140.0, 140.0)

# Zero-allocation reusable direction vector
var _pan_dir: Vector3 = Vector3.ZERO

func _ready() -> void:
	current = true
	rotation_degrees = Vector3(-55.0, 0.0, 0.0)
	if target_to_follow != null:
		global_position = target_to_follow.global_position + camera_offset
		_clamp_camera_bounds()

func _process(delta: float) -> void:
	_pan_dir = Vector3.ZERO
	
	# Pure Mouse Edge Panning (Screen Corners and Borders)
	if enable_edge_pan and not is_middle_dragging and not is_permanent_lock:
		var vp = get_viewport()
		if vp != null:
			var mouse_pos = vp.get_mouse_position()
			var win_size = vp.get_visible_rect().size
			
			if mouse_pos.x <= edge_margin_pixels:
				_pan_dir.x -= 1.0
			elif mouse_pos.x >= (win_size.x - edge_margin_pixels):
				_pan_dir.x += 1.0
				
			if mouse_pos.y <= edge_margin_pixels:
				_pan_dir.z -= 1.0
			elif mouse_pos.y >= (win_size.y - edge_margin_pixels):
				_pan_dir.z += 1.0
				
	if _pan_dir != Vector3.ZERO:
		is_locked_to_hero = false # Break temporary hero lock on manual edge push
		_pan_dir = _pan_dir.normalized()
		position += _pan_dir * pan_speed * delta
		if is_inside_tree():
			global_position += _pan_dir * pan_speed * delta
		_clamp_camera_bounds()
	elif (is_locked_to_hero or is_permanent_lock) and target_to_follow != null:
		var t_pos = target_to_follow.global_position if target_to_follow.is_inside_tree() else target_to_follow.position
		var target_cam_pos = t_pos + camera_offset
		position = position.lerp(target_cam_pos, 14.0 * delta)
		if is_inside_tree():
			global_position = global_position.lerp(target_cam_pos, 14.0 * delta)
		_clamp_camera_bounds()

func _clamp_camera_bounds() -> void:
	if is_inside_tree():
		global_position.x = clampf(global_position.x, min_boundary.x, max_boundary.x)
		global_position.z = clampf(global_position.z, min_boundary.y, max_boundary.y)
	position.x = clampf(position.x, min_boundary.x, max_boundary.x)
	position.z = clampf(position.z, min_boundary.y, max_boundary.y)

func get_clamped_position(pos: Vector3) -> Vector3:
	return Vector3(
		clampf(pos.x, min_boundary.x, max_boundary.x),
		pos.y,
		clampf(pos.z, min_boundary.y, max_boundary.y)
	)

func _unhandled_input(event: InputEvent) -> void:
	# Y or C or L Key: Toggle Permanent Camera Lock on Hero
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_Y or event.keycode == KEY_C or event.keycode == KEY_L:
			toggle_camera_lock()
			
	# Spacebar: Focus / Hold to Follow Hero
	if event is InputEventKey and event.keycode == KEY_SPACE:
		if event.pressed:
			focus_target()
		else:
			if not is_permanent_lock:
				is_locked_to_hero = false
			
	# Mouse Wheel Zoom (Ultra Smooth & Deep Zoom)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			apply_zoom(-zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			apply_zoom(zoom_speed)
			
		# Middle Mouse Button Drag Panning
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				is_middle_dragging = true
				is_locked_to_hero = false
				is_permanent_lock = false
				last_mouse_screen_pos = event.position
			else:
				is_middle_dragging = false
				
	# Middle Mouse Drag Motion
	if event is InputEventMouseMotion and is_middle_dragging:
		var delta_pos = event.position - last_mouse_screen_pos
		last_mouse_screen_pos = event.position
		global_position.x -= delta_pos.x * 0.05
		global_position.z -= delta_pos.y * 0.05
		position.x -= delta_pos.x * 0.05
		position.z -= delta_pos.y * 0.05
		_clamp_camera_bounds()

func toggle_camera_lock() -> void:
	is_permanent_lock = not is_permanent_lock
	is_locked_to_hero = is_permanent_lock
	if is_permanent_lock and target_to_follow != null:
		focus_target()

func apply_edge_pan(dir: Vector2, delta: float) -> void:
	is_locked_to_hero = false
	is_permanent_lock = false
	var move_vec = Vector3(dir.x, 0.0, dir.y).normalized()
	position += move_vec * pan_speed * delta
	if is_inside_tree():
		global_position += move_vec * pan_speed * delta
	_clamp_camera_bounds()

func apply_zoom(delta_height: float) -> void:
	var old_y = camera_offset.y
	var new_y = clampf(old_y + delta_height, min_height, max_height)
	var ratio = new_y / maxf(old_y, 0.01)
	camera_offset.y = new_y
	camera_offset.z = clampf(camera_offset.z * ratio, 3.5, 30.0)
	
	var base_y = 0.0
	if target_to_follow != null:
		base_y = target_to_follow.global_position.y if target_to_follow.is_inside_tree() else target_to_follow.position.y
	position.y = base_y + camera_offset.y
	if is_inside_tree():
		global_position.y = base_y + camera_offset.y
	_clamp_camera_bounds()

func focus_target() -> void:
	if target_to_follow != null:
		var target_pos = target_to_follow.global_position if target_to_follow.is_inside_tree() else target_to_follow.position
		position = target_pos + camera_offset
		if is_inside_tree():
			global_position = target_pos + camera_offset
		is_locked_to_hero = true
		_clamp_camera_bounds()

func focus_position(world_pos: Vector3) -> void:
	is_locked_to_hero = false
	is_permanent_lock = false
	position = world_pos + camera_offset
	if is_inside_tree():
		global_position = world_pos + camera_offset
	_clamp_camera_bounds()
