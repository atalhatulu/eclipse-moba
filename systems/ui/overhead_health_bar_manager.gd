class_name OverheadHealthBarManager
extends Control

## Compact Dota 2 style Overhead Floating Healthbars
## Reference: res://Desktop/health.png (Symmetrically Centered, Segmented 250 HP ticks, Level Badge, Mana Bar, Name Header)

@export var camera: Camera3D = null

var is_alt_down: bool = false

# Active entity -> OverheadWidget instance
var active_bars: Dictionary = {} # BaseCombatEntity -> Control
var _sync_timer: float = 0.0

func _ready() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	set_anchors_preset(PRESET_FULL_RECT)

func _process(delta: float) -> void:
	if camera == null:
		camera = get_viewport().get_camera_3d()
	if camera == null:
		return
		
	_sync_timer += delta
	if _sync_timer >= 0.25:
		_sync_timer = 0.0
		_sync_entities()
		
	_update_bar_positions()

func _sync_entities() -> void:
	var nodes = get_tree().get_nodes_in_group("combat_entities") if get_tree() != null else []
	
	# Register new entities
	for node in nodes:
		if is_instance_valid(node) and node is BaseCombatEntity and not active_bars.has(node):
			_create_bar_for_entity(node as BaseCombatEntity)
			
	# Clean up dead / freed / removed entities
	var to_remove = []
	for ent in active_bars.keys():
		if not is_instance_valid(ent):
			to_remove.append(ent)
		elif not (ent as Node).is_inside_tree():
			to_remove.append(ent)
			
	for dead_key in to_remove:
		var widget = active_bars.get(dead_key, null)
		if is_instance_valid(widget):
			widget.queue_free()
		active_bars.erase(dead_key)

func _create_bar_for_entity(ent: BaseCombatEntity) -> void:
	var widget = OverheadUnitWidget.new(ent, self)
	add_child(widget)
	active_bars[ent] = widget

func _update_bar_positions() -> void:
	var vp = get_viewport()
	var vp_size = vp.get_visible_rect().size if vp != null else Vector2(1920, 1080)
	var screen_rect = Rect2(Vector2(-60, -60), vp_size + Vector2(120, 120))
	var cam_pos = camera.global_position if camera.is_inside_tree() else camera.position
	
	for ent in active_bars.keys():
		var widget = active_bars[ent] as OverheadUnitWidget
		if not is_instance_valid(ent) or not is_instance_valid(widget):
			continue
			
		if not ent.is_alive() or not ent.visible:
			if widget.visible:
				widget.visible = false
			continue
			
		var height_offset = _get_entity_height_offset(ent)
		var ent_pos = ent.global_position if ent.is_inside_tree() else ent.position
		var world_head_pos = ent_pos + Vector3(0, height_offset, 0)
		
		# 1. Distance Culling (LOD): If further than 55m from camera, don't draw overhead bar
		if cam_pos.distance_squared_to(world_head_pos) > 3025.0:
			if widget.visible:
				widget.visible = false
			continue
		
		# 2. Behind Camera Frustum Culling
		if camera.is_position_behind(world_head_pos):
			if widget.visible:
				widget.visible = false
			continue
			
		# 3. Viewport Screen Rect Culling
		var screen_pos = camera.unproject_position(world_head_pos)
		if not screen_rect.has_point(screen_pos):
			if widget.visible:
				widget.visible = false
			continue
			
		widget.position = screen_pos
		if not widget.visible:
			widget.visible = true
		widget.update_stats()

func _get_entity_height_offset(ent: BaseCombatEntity) -> float:
	if ent is TowerEntity:
		return 5.6 # Cleanly floating above 5.0m tower
	elif ent is ObjectiveEntity:
		return 5.5
	elif ent is HeroEntity:
		return 2.7 # Cleanly floating above 2.0m hero
	elif ent is CreepEntity:
		return 1.55 # Cleanly floating above 1.0m minion
	return 2.2

# ==============================================================================
# SUB-WIDGET: OverheadUnitWidget (Symmetrically Centered Dota 2 Bar)
# ==============================================================================
class OverheadUnitWidget extends Control:
	var entity: BaseCombatEntity = null
	
	var name_label: Label = null
	var status_label: Label = null
	var hero_icon_badge: PanelContainer = null
	var hero_icon_rect: ColorRect = null
	var hp_bar: ProgressBar = null
	var shield_bar: ProgressBar = null
	var ghost_bar: ProgressBar = null
	var segments_overlay: Control = null
	var level_badge: Label = null
	var mp_bar: ProgressBar = null
	var hp_number_label: Label = null
	var manager: OverheadHealthBarManager = null
	
	var is_hero: bool = false
	var is_tower: bool = false
	var is_creep: bool = false
	
	func _init(p_entity: BaseCombatEntity, p_mgr: OverheadHealthBarManager = null) -> void:
		entity = p_entity
		manager = p_mgr
		is_hero = (entity is HeroEntity)
		is_tower = (entity is TowerEntity or entity is ObjectiveEntity)
		is_creep = (entity is CreepEntity)
		mouse_filter = MOUSE_FILTER_IGNORE
		_build_ui()
		
	func _build_ui() -> void:
		var bar_width = 82.0 if is_hero else (100.0 if is_tower else 44.0)
		var bar_height = 6.5 if is_hero else (7.5 if is_tower else 4.5)
		var badge_width = 13.0 if is_hero else 0.0
		var icon_width = 13.0 if is_hero else 0.0
		var total_width = bar_width + (badge_width + icon_width + 4.0 if is_hero else 0.0)
		
		# 0. Status Effect Label (Above bar for Stun, Root, Silence, Shield)
		status_label = Label.new()
		status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		status_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		status_label.add_theme_font_size_override("font_size", 9)
		status_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.2))
		status_label.add_theme_color_override("font_outline_color", Color.BLACK)
		status_label.add_theme_constant_override("outline_size", 2)
		status_label.position = Vector2(-total_width * 0.5, -bar_height * 0.5 - 20.0)
		status_label.size = Vector2(total_width, 12.0)
		status_label.visible = false
		add_child(status_label)
		
		# 0.5 Exact HP Numbers Overlay (Visible on ALT key hold)
		hp_number_label = Label.new()
		hp_number_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		hp_number_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		hp_number_label.add_theme_font_size_override("font_size", 9)
		hp_number_label.add_theme_color_override("font_color", Color.WHITE)
		hp_number_label.add_theme_color_override("font_outline_color", Color.BLACK)
		hp_number_label.add_theme_constant_override("outline_size", 2)
		hp_number_label.position = Vector2(-total_width * 0.5, -bar_height * 0.5 - 13.0)
		hp_number_label.size = Vector2(total_width, 12.0)
		hp_number_label.visible = false
		add_child(hp_number_label)
		
		# 1. Mini Hero Icon Badge on the Left (creeps.png reference)
		if is_hero:
			hero_icon_badge = PanelContainer.new()
			hero_icon_badge.custom_minimum_size = Vector2(12, 10)
			hero_icon_badge.position = Vector2(-bar_width * 0.5 - 15.0, -bar_height * 0.5 - 1.5)
			hero_icon_badge.size = Vector2(12, 10)
			var icon_style = StyleBoxFlat.new()
			icon_style.bg_color = Color(0.12, 0.15, 0.20, 1.0)
			icon_style.border_width_left = 1
			icon_style.border_width_top = 1
			icon_style.border_width_right = 1
			icon_style.border_width_bottom = 1
			icon_style.border_color = Color.BLACK
			hero_icon_badge.add_theme_stylebox_override("panel", icon_style)
			add_child(hero_icon_badge)
			
			hero_icon_rect = ColorRect.new()
			hero_icon_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
			hero_icon_rect.color = Color(0.25, 0.55, 0.75) if entity.team == TeamDefinitions.Team.RADIANT else Color(0.75, 0.25, 0.25)
			hero_icon_badge.add_child(hero_icon_rect)
		
		# 2. HP Bar Container (Centered at origin)
		var hp_container = Control.new()
		hp_container.position = Vector2(-bar_width * 0.5, -bar_height * 0.5)
		hp_container.size = Vector2(bar_width, bar_height)
		add_child(hp_container)
		
		# Ghost Damage Lag Bar (White)
		ghost_bar = ProgressBar.new()
		ghost_bar.show_percentage = false
		ghost_bar.size = Vector2(bar_width, bar_height)
		var ghost_fill = StyleBoxFlat.new()
		ghost_fill.bg_color = Color(0.95, 0.9, 0.85, 0.9)
		var ghost_bg = StyleBoxFlat.new()
		ghost_bg.bg_color = Color(0.06, 0.07, 0.08, 0.95)
		ghost_bg.border_width_left = 1
		ghost_bg.border_width_top = 1
		ghost_bg.border_width_right = 1
		ghost_bg.border_width_bottom = 1
		ghost_bg.border_color = Color.BLACK
		ghost_bar.add_theme_stylebox_override("fill", ghost_fill)
		ghost_bar.add_theme_stylebox_override("background", ghost_bg)
		hp_container.add_child(ghost_bar)
		
		# Actual HP Bar (Dota Green #3b8526 / Dota Red #a83232)
		hp_bar = ProgressBar.new()
		hp_bar.show_percentage = false
		hp_bar.size = Vector2(bar_width, bar_height)
		var hp_fill = StyleBoxFlat.new()
		hp_fill.bg_color = _get_team_hp_color()
		var hp_empty_bg = StyleBoxFlat.new()
		hp_empty_bg.bg_color = Color.TRANSPARENT
		hp_bar.add_theme_stylebox_override("fill", hp_fill)
		hp_bar.add_theme_stylebox_override("background", hp_empty_bg)
		hp_container.add_child(hp_bar)
		
		# Shield Overlay Bar (White / Cyan)
		shield_bar = ProgressBar.new()
		shield_bar.show_percentage = false
		shield_bar.size = Vector2(bar_width, bar_height)
		var shield_fill = StyleBoxFlat.new()
		shield_fill.bg_color = Color(0.9, 0.95, 1.0, 0.75)
		var shield_bg = StyleBoxFlat.new()
		shield_bg.bg_color = Color.TRANSPARENT
		shield_bar.add_theme_stylebox_override("fill", shield_fill)
		shield_bar.add_theme_stylebox_override("background", shield_bg)
		shield_bar.visible = false
		hp_container.add_child(shield_bar)
		
		# 250 HP Segment Overlay Lines (Heroes & Towers only)
		if not is_creep:
			segments_overlay = Control.new()
			segments_overlay.size = Vector2(bar_width, bar_height)
			segments_overlay.draw.connect(_draw_segments)
			hp_container.add_child(segments_overlay)
		
		# 3. Level Badge on the Right (Attached for heroes)
		if is_hero:
			level_badge = Label.new()
			level_badge.text = "1"
			level_badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			level_badge.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
			level_badge.add_theme_font_size_override("font_size", 8)
			level_badge.add_theme_color_override("font_color", Color.WHITE)
			level_badge.add_theme_color_override("font_outline_color", Color.BLACK)
			level_badge.add_theme_constant_override("outline_size", 2)
			
			var badge_bg = StyleBoxFlat.new()
			badge_bg.bg_color = Color(0.10, 0.12, 0.15, 1.0)
			badge_bg.border_width_left = 1
			badge_bg.border_width_top = 1
			badge_bg.border_width_right = 1
			badge_bg.border_width_bottom = 1
			badge_bg.border_color = Color.BLACK
			level_badge.add_theme_stylebox_override("normal", badge_bg)
			
			level_badge.position = Vector2(bar_width * 0.5 + 2.0, -bar_height * 0.5)
			level_badge.size = Vector2(badge_width, bar_height)
			add_child(level_badge)

	func _get_team_hp_color() -> Color:
		if entity.team == TeamDefinitions.Team.RADIANT:
			return Color(0.23, 0.52, 0.15, 1.0) if is_creep else Color(0.33, 0.65, 0.18, 1.0)
		elif entity.team == TeamDefinitions.Team.DIRE:
			return Color(0.66, 0.20, 0.20, 1.0)
		return Color(0.85, 0.70, 0.20, 1.0)

	func update_stats() -> void:
		if entity == null or entity.attribute_system == null:
			return
			
		var max_hp = maxf(1.0, entity.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
		var cur_hp = clampf(entity.attribute_system.current_health, 0.0, max_hp)
		
		hp_bar.max_value = max_hp
		hp_bar.value = cur_hp
		
		ghost_bar.max_value = max_hp
		if ghost_bar.value > cur_hp:
			ghost_bar.value = lerpf(ghost_bar.value, cur_hp, 0.12)
		else:
			ghost_bar.value = cur_hp
			
		# Shield Update
		if entity.effect_container != null:
			var total_shield = entity.effect_container.get_total_shield()
			if total_shield > 0.0:
				shield_bar.visible = true
				shield_bar.max_value = max_hp
				shield_bar.value = clampf(cur_hp + total_shield, 0.0, max_hp)
			else:
				shield_bar.visible = false
				
			# CC Status Text
			if entity.effect_container.is_stunned():
				status_label.text = "[SERSEMLETİLDİ]"
				status_label.add_theme_color_override("font_color", Color(1.0, 0.8, 0.2))
				status_label.visible = true
			elif entity.effect_container.is_rooted():
				status_label.text = "[SABİTLENDİ]"
				status_label.add_theme_color_override("font_color", Color(0.3, 0.8, 1.0))
				status_label.visible = true
			elif entity.effect_container.is_silenced():
				status_label.text = "[SUSTURULDU]"
				status_label.add_theme_color_override("font_color", Color(0.9, 0.3, 0.9))
				status_label.visible = true
			elif total_shield > 0.0:
				status_label.text = "[KALKAN: %.0f]" % total_shield
				status_label.add_theme_color_override("font_color", Color(0.7, 0.9, 1.0))
				status_label.visible = true
			else:
				status_label.visible = false
		else:
			status_label.visible = false
			
		if is_hero and level_badge != null:
			level_badge.text = str(entity.attribute_system.level)
			
		if hp_number_label != null:
			if manager != null and manager.is_alt_down and (is_hero or is_tower):
				hp_number_label.text = "%d / %d" % [int(cur_hp), int(max_hp)]
				hp_number_label.visible = true
			else:
				hp_number_label.visible = false
			
		if segments_overlay != null:
			segments_overlay.queue_redraw()

	func _draw_segments() -> void:
		if entity == null or entity.attribute_system == null:
			return
		var max_hp = entity.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
		var segment_hp = 250.0 if not is_tower else 500.0
		var segment_count = int(max_hp / segment_hp)
		var bar_w = segments_overlay.size.x
		var bar_h = segments_overlay.size.y
		
		for i in range(1, segment_count):
			var x_pos = (float(i) * segment_hp / max_hp) * bar_w
			var line_color = Color(0.0, 0.0, 0.0, 0.85)
			var thickness = 2.0 if (i % 4 == 0) else 1.0
			segments_overlay.draw_line(Vector2(x_pos, 0), Vector2(x_pos, bar_h), line_color, thickness)
