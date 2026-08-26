class_name DotaMinimap
extends Control

## Authentic Dota 2 Minimap with Camera View Frustum Cone, River, Towers, Creeps, Heroes & Radar (map.png reference)

@export var camera: Camera3D = null
@export var target_hero: HeroEntity = null

var map_size_world: Vector2 = Vector2(130.0, 80.0) # World map bounds: X [-65, +65], Z [-40, +40]
var map_pixel_size: Vector2 = Vector2(260.0, 260.0)

var is_scanning: bool = false
var scan_cooldown: float = 0.0
var glyph_cooldown: float = 0.0

func _ready() -> void:
	custom_minimum_size = map_pixel_size
	mouse_filter = MOUSE_FILTER_PASS
	gui_input.connect(_on_minimap_gui_input)

func _process(delta: float) -> void:
	if scan_cooldown > 0.0:
		scan_cooldown = maxf(0.0, scan_cooldown - delta)
	if glyph_cooldown > 0.0:
		glyph_cooldown = maxf(0.0, glyph_cooldown - delta)
		
	queue_redraw()

func _draw() -> void:
	var w = map_pixel_size.x
	var h = map_pixel_size.y
	
	# 1. Background (Dark Terrain)
	draw_rect(Rect2(0, 0, w, h), Color(0.05, 0.07, 0.08, 0.98))
	
	# 2. Diagonal River (map.png reference)
	var river_color = Color(0.12, 0.22, 0.32, 0.85)
	var river_points = PackedVector2Array([
		Vector2(0, h * 0.70),
		Vector2(w * 0.70, 0),
		Vector2(w * 0.85, 0),
		Vector2(0, h * 0.85)
	])
	draw_colored_polygon(river_points, river_color)
	
	# Radiant Terrain (Top-Left)
	var rad_base_color = Color(0.15, 0.25, 0.16, 0.4)
	draw_colored_polygon(PackedVector2Array([Vector2(0, 0), Vector2(w * 0.45, 0), Vector2(0, h * 0.45)]), rad_base_color)
	
	# Dire Terrain (Bottom-Right)
	var dire_base_color = Color(0.25, 0.14, 0.14, 0.4)
	draw_colored_polygon(PackedVector2Array([Vector2(w, h), Vector2(w * 0.55, h), Vector2(w, h * 0.55)]), dire_base_color)
	
	# Lanes (Top, Mid, Bot subtle guide paths)
	var lane_color = Color(0.20, 0.24, 0.28, 0.5)
	draw_line(Vector2(20, h - 20), Vector2(w - 20, 20), lane_color, 2.0) # Mid
	draw_line(Vector2(20, h - 20), Vector2(20, 20), lane_color, 1.5) # Top Left
	draw_line(Vector2(20, 20), Vector2(w - 20, 20), lane_color, 1.5) # Top Right
	draw_line(Vector2(20, h - 20), Vector2(w - 20, h - 20), lane_color, 1.5) # Bot
	draw_line(Vector2(w - 20, h - 20), Vector2(w - 20, 20), lane_color, 1.5) # Bot Right
	
	# 3. Towers & Objectives
	if get_tree() != null:
		var towers = get_tree().get_nodes_in_group("towers")
		for tw in towers:
			if tw is TowerEntity and tw.is_alive():
				var t_pos = _world_to_minimap(tw.global_position)
				var t_col = Color(0.2, 0.85, 0.3) if tw.team == TeamDefinitions.Team.RADIANT else Color(0.9, 0.25, 0.25)
				draw_rect(Rect2(t_pos.x - 3.5, t_pos.y - 3.5, 7, 7), t_col)
				draw_rect(Rect2(t_pos.x - 3.5, t_pos.y - 3.5, 7, 7), Color.BLACK, false, 1.0)
				
		# 4. Creeps (Lane Minions & Neutral Jungle Camps)
		var combat_ents = get_tree().get_nodes_in_group("combat_entities")
		for c in combat_ents:
			if (c is CreepEntity or c is NeutralCreepEntity) and c.is_alive():
				var c_pos = _world_to_minimap(c.global_position)
				var c_col = Color(0.3, 0.8, 0.25)
				if c.team == TeamDefinitions.Team.DIRE:
					c_col = Color(0.85, 0.2, 0.2)
				elif c.team == TeamDefinitions.Team.NEUTRAL:
					c_col = Color(0.95, 0.80, 0.25) # Gold for Neutrals
				draw_circle(c_pos, 2.0, c_col)
				
		# 5. Heroes
		var heroes = get_tree().get_nodes_in_group("heroes")
		for hero_node in heroes:
			if hero_node is HeroEntity and hero_node.is_alive():
				var h_pos = _world_to_minimap(hero_node.global_position)
				var is_player = (hero_node == target_hero)
				var h_col = Color(0.2, 0.9, 1.0) if is_player else (Color(0.3, 0.85, 0.3) if hero_node.team == TeamDefinitions.Team.RADIANT else Color(0.95, 0.25, 0.25))
				
				# Hero Circle Badge
				draw_circle(h_pos, 5.0, Color.BLACK)
				draw_circle(h_pos, 4.0, h_col)
				
				# Facing Direction Arrow (map.png reference)
				var forward = -hero_node.global_transform.basis.z
				var dir_2d = Vector2(forward.x, forward.z).normalized()
				var tip = h_pos + dir_2d * 8.0
				var right = dir_2d.orthogonal() * 3.0
				draw_line(h_pos, tip, Color.WHITE if is_player else Color.BLACK, 1.5)
				draw_colored_polygon(PackedVector2Array([tip, tip - dir_2d * 3.0 + right, tip - dir_2d * 3.0 - right]), h_col)
	
	# 6. Camera View Frustum Cone (Mavi Saydam Görüş Yamuğu - map.png reference)
	_draw_camera_frustum()
	
	# 7. Map Border (Crisp outer frame)
	draw_rect(Rect2(0, 0, w, h), Color(0.35, 0.40, 0.50), false, 2.0)

func _draw_camera_frustum() -> void:
	if camera == null:
		camera = get_viewport().get_camera_3d() if get_viewport() != null else null
	if camera == null:
		return
		
	var vp_size = get_viewport().get_visible_rect().size
	if vp_size.x <= 0 or vp_size.y <= 0:
		return
		
	# Unproject 4 screen corners to ground (Y = 0) plane
	var corners = [
		Vector2(0, 0), # Top-Left
		Vector2(vp_size.x, 0), # Top-Right
		Vector2(vp_size.x, vp_size.y), # Bottom-Right
		Vector2(0, vp_size.y) # Bottom-Left
	]
	
	var ground_points: Array[Vector2] = []
	for sc in corners:
		var ray_origin = camera.project_ray_origin(sc)
		var ray_dir = camera.project_ray_normal(sc)
		if absf(ray_dir.y) > 0.001:
			var t = -ray_origin.y / ray_dir.y
			var world_pt = ray_origin + ray_dir * t
			ground_points.append(_world_to_minimap(world_pt))
			
	if ground_points.size() == 4:
		var poly = PackedVector2Array(ground_points)
		# Transparent blue frustum fill
		draw_colored_polygon(poly, Color(0.20, 0.65, 1.0, 0.18))
		# Sharp cyan boundary line
		poly.append(ground_points[0])
		draw_polyline(poly, Color(0.35, 0.85, 1.0, 0.85), 1.5)

func _world_to_minimap(world_pos: Vector3) -> Vector2:
	var half_x = map_size_world.x * 0.5
	var half_z = map_size_world.y * 0.5
	var norm_x = clampf((world_pos.x + half_x) / map_size_world.x, 0.0, 1.0)
	var norm_z = clampf((world_pos.z + half_z) / map_size_world.y, 0.0, 1.0)
	return Vector2(norm_x * map_pixel_size.x, norm_z * map_pixel_size.y)

func _minimap_to_world(mini_pos: Vector2) -> Vector3:
	var norm_x = clampf(mini_pos.x / map_pixel_size.x, 0.0, 1.0)
	var norm_z = clampf(mini_pos.y / map_pixel_size.y, 0.0, 1.0)
	var world_x = (norm_x * map_size_world.x) - (map_size_world.x * 0.5)
	var world_z = (norm_z * map_size_world.y) - (map_size_world.y * 0.5)
	return Vector3(world_x, 0.0, world_z)

func _on_minimap_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT) and event.pressed:
		var target_world = _minimap_to_world(event.position)
		if camera != null and camera.has_method("focus_position"):
			camera.focus_position(target_world)
		elif target_hero != null:
			# If right click on minimap, order hero to move
			if event.button_index == MOUSE_BUTTON_RIGHT and target_hero.has_method("move_to_position"):
				target_hero.move_to_position(target_world)

# --- Radar Scan & Tower Fortification (map.png buttons) ---

func trigger_radar_scan() -> void:
	if scan_cooldown <= 0.0:
		scan_cooldown = 60.0
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("RADAR: TARAMA BAŞLATILDI (60s Bekleme)")

func trigger_glyph_fortification() -> void:
	if glyph_cooldown <= 0.0:
		glyph_cooldown = 180.0
		if get_tree() != null:
			var towers = get_tree().get_nodes_in_group("towers")
			for tw in towers:
				if tw is TowerEntity and tw.team == TeamDefinitions.Team.RADIANT:
					tw.is_invulnerable_to_damage = true
			get_tree().create_timer(6.0).timeout.connect(func():
				for tw in towers:
					if is_instance_valid(tw) and tw is TowerEntity:
						tw.is_invulnerable_to_damage = false
			)
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("TAHKİMAT: TÜM KULELER 6 SANİYELİĞİNE DOKUNULMAZ OLDU")
