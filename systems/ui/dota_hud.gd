class_name DotaHUD
extends CanvasLayer

const CourierEntityClass = preload("res://systems/courier/courier_entity.gd")
const CourierManagerClass = preload("res://systems/courier/courier_manager.gd")
const DotaScoreboardClass = preload("res://systems/ui/dota_scoreboard.gd")

## Authentic Dota 2 Style Game Dashboard & Combat Interface (hud.png reference)
## Features Centered Health/Mana Bars, 2x3 Inventory, Hero Portrait, Attributes & Top Match Clock

signal play_again_clicked()
signal main_menu_clicked()

@export var target_hero: HeroEntity = null:
	set(val):
		if target_hero == val:
			return
		target_hero = val
		if dota_scoreboard != null:
			dota_scoreboard.player_hero = val
		if is_inside_tree() and shop_ui != null and val != null:
			shop_ui.bind_hero(val)

@export var camera: MobaCamera3D = null
@export var match_manager: MatchManager = null:
	set(val):
		match_manager = val
		if dota_scoreboard != null:
			dota_scoreboard.match_manager = val

# Top Match Bar
var match_timer_label: Label = null
var radiant_score_label: Label = null
var dire_score_label: Label = null
var kill_death_label: Label = null
var match_elapsed_time: float = 0.0

# Hero Identity & Portrait
var hero_name_label: Label = null
var hero_level_label: Label = null
var portrait_rect: ColorRect = null
var hero_portrait_texture: TextureRect = null
var primary_attr_icon: Label = null

# Attributes & Stats
var str_val_label: Label = null
var agi_val_label: Label = null
var int_val_label: Label = null
var ad_val_label: Label = null
var armor_val_label: Label = null
var mr_val_label: Label = null
var ms_val_label: Label = null

# Abilities UI Elements
var ability_buttons: Dictionary = {} # Slot -> Button
var ability_cooldown_overlays: Dictionary = {} # Slot -> ColorRect
var ability_cooldown_labels: Dictionary = {} # Slot -> Label
var ability_mana_labels: Dictionary = {} # Slot -> Label
var ability_levelup_buttons: Dictionary = {} # Slot -> Button
var ability_pip_containers: Dictionary = {} # Slot -> HBoxContainer

# Health, Mana & Resource Bars
var status_effect_bar: DotaStatusEffectBar = null
var buffs_container: HBoxContainer = null
var hp_bar: ProgressBar = null
var hp_text_label: Label = null
var hp_regen_label: Label = null

var mp_bar: ProgressBar = null
var mp_text_label: Label = null
var mp_regen_label: Label = null

var xp_bar: ProgressBar = null

var heat_container: Control = null
var heat_bar: ProgressBar = null
var heat_text_label: Label = null

# Inventory & Gold
var inventory_slot_buttons: Array[Button] = []
var inventory_slot_textures: Array[TextureRect] = []
var inventory_slot_cooldown_overlays: Array[ColorRect] = []
var inventory_slot_cooldown_labels: Array[Label] = []
var inventory_slot_hotkey_labels: Array[Label] = []
var inventory_slot_target_labels: Array[Label] = []
var boots_slot_button: Button = null
var boots_slot_texture: TextureRect = null
var gold_label: Label = null
var shop_toggle_button: Button = null
var shop_ui: ShopInventoryUI = null

# Minimap
var minimap_rect: Control = null
var minimap_hero_dot: Control = null

# Respawn & Match Result Overlays
var respawn_overlay: PanelContainer = null
var respawn_timer_label: Label = null
var overhead_health_bar_manager: OverheadHealthBarManager = null
var match_result_ui: MatchResultUI = null
var demo_panel: DemoHeroPanel = null
var stats_popup: DotaStatsPopup = null
var ability_tooltip: DotaAbilityTooltip = null
var hud_item_tooltip: DotaItemTooltip = null
var is_alt_down: bool = false
var _is_hovering_portrait: bool = false
var _is_hovering_stats_vbox: bool = false
var inspected_unit: Node = null
var pending_world_drop_item: ItemResource = null
var pending_world_drop_position: Vector3 = Vector3.ZERO
var dota_scoreboard: Control = null
var _scoreboard_refresh_timer: float = 0.0

func _ready() -> void:
	layer = 10
	_build_dota_interface()
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		if not GameEvents.world_item_selected.is_connected(_on_world_item_selected):
			GameEvents.world_item_selected.connect(_on_world_item_selected)
	
	if target_hero != null:
		_bind_hero(target_hero)
		inspected_unit = target_hero
		
	if match_manager != null:
		_bind_match_manager(match_manager)
		
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		if not GameEvents.target_selected.is_connected(_on_unit_inspected):
			GameEvents.target_selected.connect(_on_unit_inspected)
		if not GameEvents.target_cleared.is_connected(_on_unit_inspection_cleared):
			GameEvents.target_cleared.connect(_on_unit_inspection_cleared)

func _on_unit_inspected(unit: Node) -> void:
	if unit != null and is_instance_valid(unit):
		if unit.has_method("is_alive") and not unit.is_alive():
			inspected_unit = target_hero
		else:
			inspected_unit = unit
	else:
		inspected_unit = target_hero
	_update_hero_portrait(inspected_unit)
	_sync_inspected_status_effects()

func _on_unit_inspection_cleared() -> void:
	inspected_unit = target_hero
	_update_hero_portrait(target_hero)
	_sync_inspected_status_effects()

func _sync_inspected_status_effects() -> void:
	if status_effect_bar == null:
		return
	if inspected_unit is HeroEntity and is_instance_valid(inspected_unit):
		status_effect_bar.target_hero = inspected_unit as HeroEntity
	else:
		status_effect_bar.target_hero = target_hero

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ALT:
			is_alt_down = event.pressed
			_set_alt_info_mode(is_alt_down)
			_set_stats_popup_visible(is_alt_down or _is_hovering_portrait or _is_hovering_stats_vbox)
		elif event.keycode == KEY_TAB:
			if dota_scoreboard != null:
				dota_scoreboard.visible = event.pressed
				if event.pressed:
					dota_scoreboard.update_scoreboard()
					_scoreboard_refresh_timer = 0.0
		elif event.pressed and not event.echo:
			if event.keycode == KEY_B or event.keycode == KEY_P:
				_toggle_shop()
			elif event.keycode == KEY_F3 or event.keycode == KEY_K:
				if target_hero != null:
					CourierManagerClass.deliver_for_hero(target_hero)
			elif event.keycode == KEY_F4:
				if target_hero != null:
					CourierManagerClass.speed_burst_for_hero(target_hero)
			elif event.keycode >= KEY_1 and event.keycode <= KEY_6:
				# HeroController3D owns number-key targeting; it must not be consumed
				# by the HUD before a target cursor is displayed.
				pass
			elif event.keycode == KEY_ESCAPE:
				if shop_ui != null and shop_ui.shop_panel.visible:
					shop_ui.shop_panel.visible = false
				if stats_popup != null and stats_popup.visible:
					_set_stats_popup_visible(false)
	elif event is InputEventMouseButton and event.pressed:
		if stats_popup != null and stats_popup.visible and not is_alt_down:
			if not _is_hovering_portrait and not _is_hovering_stats_vbox:
				_set_stats_popup_visible(false)

func _set_alt_info_mode(is_vis: bool) -> void:
	is_alt_down = is_vis
	
	if overhead_health_bar_manager != null:
		overhead_health_bar_manager.is_alt_down = is_vis
		
	if target_hero != null and target_hero.has_method("set_alt_range_visible"):
		target_hero.set_alt_range_visible(is_vis)

func _set_stats_popup_visible(is_vis: bool) -> void:
	if stats_popup != null:
		stats_popup.visible = is_vis
		if is_vis and target_hero != null:
			stats_popup.update_stats(target_hero)

func _process(delta: float) -> void:
	match_elapsed_time += delta
	_update_match_clock()
	_update_dota_hud_values()
	_update_respawn_display()
	_update_stats_popup_liveness()
	_update_pending_world_drop()
	if dota_scoreboard != null and dota_scoreboard.visible:
		_scoreboard_refresh_timer += delta
		if _scoreboard_refresh_timer >= 0.5:
			_scoreboard_refresh_timer = 0.0
			dota_scoreboard.update_scoreboard()
	if overhead_health_bar_manager != null and camera != null:
		overhead_health_bar_manager.camera = camera

func _update_stats_popup_liveness() -> void:
	if stats_popup != null and stats_popup.visible:
		if not is_alt_down and not _is_hovering_portrait and not _is_hovering_stats_vbox:
			_set_stats_popup_visible(false)

func _update_match_clock() -> void:
	if match_timer_label != null:
		var mins = int(match_elapsed_time) / 60
		var secs = int(match_elapsed_time) % 60
		match_timer_label.text = "%02d:%02d" % [mins, secs]

func _update_respawn_display() -> void:
	if respawn_overlay != null:
		if target_hero != null and (not target_hero.is_alive() or target_hero.respawn_timer > 0.0):
			respawn_overlay.visible = true
			if respawn_timer_label != null:
				respawn_timer_label.text = "RESPAWN: %.1fs" % maxf(0.0, target_hero.respawn_timer)
		elif match_manager != null and match_manager.is_radiant_respawning and target_hero != null and target_hero.team == TeamDefinitions.Team.RADIANT:
			respawn_overlay.visible = true
			if respawn_timer_label != null:
				respawn_timer_label.text = "RESPAWN: %.1fs" % maxf(0.0, match_manager.radiant_respawn_timer)
		else:
			respawn_overlay.visible = false

func _build_dota_interface() -> void:
	# Root Container
	var root = Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)
	
	# Overhead Floating Health Bars (health.png)
	overhead_health_bar_manager = OverheadHealthBarManager.new()
	overhead_health_bar_manager.camera = camera
	root.add_child(overhead_health_bar_manager)
	
	_build_hud_backplate(root)
	_build_top_bar(root)
	_build_bottom_dashboard(root)
	_build_minimap(root)
	_setup_shop_modal(root)
	_setup_respawn_overlay(root)
	_setup_match_result_modal(root)
	
	# 8. Demo Hero Tool Panel (test.png reference)
	demo_panel = DemoHeroPanel.new()
	demo_panel.target_hero = target_hero
	demo_panel.map_root = get_parent()
	root.add_child(demo_panel)
	
	# 9. Detailed Stats Popup Card (stats.png reference, triggered via ALT or hover)
	stats_popup = DotaStatsPopup.new()
	stats_popup.visible = false
	stats_popup.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	stats_popup.offset_left = 460
	stats_popup.offset_top = -430
	stats_popup.offset_right = 800
	stats_popup.offset_bottom = -150
	root.add_child(stats_popup)
	
	# 10. Ability Tooltip Floating Card (Dota 2 Hover Info Card)
	ability_tooltip = DotaAbilityTooltip.new()
	ability_tooltip.visible = false
	ability_tooltip.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	ability_tooltip.offset_left = 600
	ability_tooltip.offset_top = -520
	ability_tooltip.offset_right = 950
	ability_tooltip.offset_bottom = -190
	root.add_child(ability_tooltip)
	
	# 11. Item Tooltip Floating Card (Dota 2 Inventory Item Hover Card)
	hud_item_tooltip = DotaItemTooltip.new()
	hud_item_tooltip.visible = false
	root.add_child(hud_item_tooltip)
	
	# 12. Scoreboard Overlay (TAB hold)
	dota_scoreboard = DotaScoreboardClass.new()
	dota_scoreboard.player_hero = target_hero
	dota_scoreboard.match_manager = match_manager
	root.add_child(dota_scoreboard)

func _build_hud_backplate(parent: Control) -> void:
	# A restrained lower-third backplate visually groups hero, abilities and
	# inventory without covering gameplay space.
	var backplate = PanelContainer.new()
	backplate.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	backplate.offset_left = 190
	backplate.offset_right = -8
	backplate.offset_top = -178
	backplate.offset_bottom = -8
	backplate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var plate_style = StyleBoxFlat.new()
	plate_style.bg_color = Color(0.015, 0.025, 0.045, 0.93)
	plate_style.border_width_left = 1
	plate_style.border_width_top = 2
	plate_style.border_width_right = 1
	plate_style.border_width_bottom = 1
	plate_style.border_color = Color(0.12, 0.78, 0.92, 0.34)
	plate_style.corner_radius_top_left = 16
	plate_style.corner_radius_top_right = 16
	plate_style.corner_radius_bottom_left = 16
	plate_style.corner_radius_bottom_right = 16
	plate_style.shadow_size = 20
	plate_style.shadow_color = Color(0.0, 0.0, 0.0, 0.82)
	backplate.add_theme_stylebox_override("panel", plate_style)
	parent.add_child(backplate)
	
	var accent_root = Control.new()
	accent_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	backplate.add_child(accent_root)
	var top_accent = ColorRect.new()
	top_accent.set_anchors_preset(Control.PRESET_TOP_WIDE)
	top_accent.offset_left = 34
	top_accent.offset_right = -34
	top_accent.offset_top = 7
	top_accent.offset_bottom = 9
	top_accent.color = Color(1.0, 0.66, 0.18, 0.72)
	accent_root.add_child(top_accent)
	var left_accent = ColorRect.new()
	left_accent.set_anchors_preset(Control.PRESET_LEFT_WIDE)
	left_accent.offset_left = 8
	left_accent.offset_right = 10
	left_accent.offset_top = 28
	left_accent.offset_bottom = -28
	left_accent.color = Color(0.18, 0.82, 1.0, 0.52)
	accent_root.add_child(left_accent)

# ==============================================================================
# 1. TOP MATCH BAR & SCOREBOARD (Radiant Kills vs Dire Kills & Match Clock)
# ==============================================================================
func _build_top_bar(parent: Control) -> void:
	var top_panel = PanelContainer.new()
	top_panel.set_anchors_preset(Control.PRESET_TOP_WIDE)
	top_panel.offset_left = 430
	top_panel.offset_right = -430
	top_panel.offset_top = 8
	top_panel.offset_bottom = 52
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.025, 0.04, 0.07, 0.94) # Obsidian Night
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color(1.0, 0.73, 0.13, 0.62) # Solar Gold Subtle Glow
	style.corner_radius_top_left = 16
	style.corner_radius_top_right = 16
	style.corner_radius_bottom_left = 16
	style.corner_radius_bottom_right = 16
	style.shadow_size = 14
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.6)
	style.content_margin_left = 20
	style.content_margin_right = 20
	style.content_margin_top = 4
	style.content_margin_bottom = 4
	top_panel.add_theme_stylebox_override("panel", style)
	parent.add_child(top_panel)
	
	var hbox = HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 28)
	top_panel.add_child(hbox)
	
	# Radiant Score with Cyan Theme
	var rad_box = HBoxContainer.new()
	rad_box.add_theme_constant_override("separation", 8)
	hbox.add_child(rad_box)
	
	var rad_tag = Label.new()
	rad_tag.text = "RADIANT"
	rad_tag.add_theme_font_size_override("font_size", 12)
	rad_tag.add_theme_color_override("font_color", Color(0.72, 0.79, 0.80))
	rad_box.add_child(rad_tag)
	
	radiant_score_label = Label.new()
	radiant_score_label.text = "0"
	radiant_score_label.add_theme_font_size_override("font_size", 20)
	radiant_score_label.add_theme_color_override("font_color", Color(0.49, 0.96, 1.0)) # Cyan
	rad_box.add_child(radiant_score_label)
	
	# Match Clock Capsule
	var clock_panel = PanelContainer.new()
	clock_panel.custom_minimum_size = Vector2(88, 30)
	var clk_s = StyleBoxFlat.new()
	clk_s.bg_color = Color(0.10, 0.13, 0.20, 1.0)
	clk_s.border_width_left = 1
	clk_s.border_width_top = 1
	clk_s.border_width_right = 1
	clk_s.border_width_bottom = 1
	clk_s.border_color = Color(0.95, 0.72, 0.28, 0.52)
	clk_s.corner_radius_bottom_left = 6
	clk_s.corner_radius_bottom_right = 6
	clk_s.corner_radius_top_left = 6
	clk_s.corner_radius_top_right = 6
	clock_panel.add_theme_stylebox_override("panel", clk_s)
	hbox.add_child(clock_panel)
	
	match_timer_label = Label.new()
	match_timer_label.text = "00:00"
	match_timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	match_timer_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	match_timer_label.add_theme_font_size_override("font_size", 15)
	match_timer_label.add_theme_color_override("font_color", Color(1.0, 0.86, 0.62)) # Gold
	clock_panel.add_child(match_timer_label)
	
	# Dire Score with Soft Red Theme
	var dire_box = HBoxContainer.new()
	dire_box.add_theme_constant_override("separation", 8)
	hbox.add_child(dire_box)
	
	dire_score_label = Label.new()
	dire_score_label.text = "0"
	dire_score_label.add_theme_font_size_override("font_size", 20)
	dire_score_label.add_theme_color_override("font_color", Color(1.0, 0.71, 0.67)) # Soft Red
	dire_box.add_child(dire_score_label)
	
	var dire_tag = Label.new()
	dire_tag.text = "DIRE"
	dire_tag.add_theme_font_size_override("font_size", 12)
	dire_tag.add_theme_color_override("font_color", Color(0.72, 0.79, 0.80))
	dire_box.add_child(dire_tag)
	
	# Top Left: KDA Scoreboard Pill
	var kda_box = PanelContainer.new()
	kda_box.set_anchors_preset(Control.PRESET_TOP_LEFT)
	kda_box.offset_left = 16
	kda_box.offset_top = 12
	kda_box.offset_right = 160
	kda_box.offset_bottom = 44
	
	var kda_style = StyleBoxFlat.new()
	kda_style.bg_color = Color(0.06, 0.08, 0.11, 0.85)
	kda_style.border_width_left = 1
	kda_style.border_width_top = 1
	kda_style.border_width_right = 1
	kda_style.border_width_bottom = 1
	kda_style.border_color = Color(0.0, 0.86, 0.95, 0.3)
	kda_style.corner_radius_top_left = 8
	kda_style.corner_radius_top_right = 8
	kda_style.corner_radius_bottom_left = 8
	kda_style.corner_radius_bottom_right = 8
	kda_box.add_theme_stylebox_override("panel", kda_style)
	parent.add_child(kda_box)
	
	kill_death_label = Label.new()
	kill_death_label.text = "K: 0  D: 0  A: 0"
	kill_death_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	kill_death_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	kill_death_label.add_theme_font_size_override("font_size", 12)
	kill_death_label.add_theme_color_override("font_color", Color(0.88, 0.90, 0.94))
	kda_box.add_child(kill_death_label)

# ==============================================================================
# 2. CYBER-FANTASY FLOATING BOTTOM DASHBOARD (Design 2 reference)
# ==============================================================================
func _build_bottom_dashboard(parent: Control) -> void:
	var dashboard = MarginContainer.new()
	dashboard.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	dashboard.offset_left = 220
	dashboard.offset_right = -20
	dashboard.offset_top = -145
	dashboard.offset_bottom = -14
	dashboard.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(dashboard)
	
	var main_h = HBoxContainer.new()
	main_h.add_theme_constant_override("separation", 20)
	main_h.alignment = BoxContainer.ALIGNMENT_CENTER
	main_h.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dashboard.add_child(main_h)
	
	_build_hero_portrait_and_stats(main_h)
	_build_abilities_and_centered_bars(main_h)
	_build_inventory_box(main_h)

# --- Hero Portrait & Stats Floating Card (Left of Bottom Cluster) ---
func _build_hero_portrait_and_stats(parent: Control) -> void:
	var portrait_card = PanelContainer.new()
	portrait_card.custom_minimum_size = Vector2(240, 95)
	var card_style = StyleBoxFlat.new()
	card_style.bg_color = Color(0.035, 0.055, 0.09, 0.96)
	card_style.border_width_top = 2
	card_style.border_width_left = 1
	card_style.border_width_right = 1
	card_style.border_width_bottom = 1
	card_style.border_color = Color(1.0, 0.73, 0.13, 0.82) # Solar Gold Glow
	card_style.corner_radius_top_left = 10
	card_style.corner_radius_top_right = 10
	card_style.corner_radius_bottom_left = 10
	card_style.corner_radius_bottom_right = 10
	card_style.shadow_size = 18
	card_style.shadow_color = Color(0, 0, 0, 0.75)
	card_style.content_margin_left = 12
	card_style.content_margin_right = 12
	card_style.content_margin_top = 8
	card_style.content_margin_bottom = 8
	portrait_card.add_theme_stylebox_override("panel", card_style)
	parent.add_child(portrait_card)
	
	var h_block = HBoxContainer.new()
	h_block.add_theme_constant_override("separation", 12)
	portrait_card.add_child(h_block)
	
	# Portrait Box with Name & Circular Level Badge
	var p_vbox = VBoxContainer.new()
	p_vbox.add_theme_constant_override("separation", 3)
	h_block.add_child(p_vbox)
	
	hero_name_label = Label.new()
	hero_name_label.text = "ASTRIS"
	hero_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hero_name_label.add_theme_font_size_override("font_size", 12)
	hero_name_label.add_theme_color_override("font_color", Color(0.92, 0.94, 0.98))
	p_vbox.add_child(hero_name_label)
	
	var p_container = PanelContainer.new()
	p_container.custom_minimum_size = Vector2(72, 72)
	var p_style = StyleBoxFlat.new()
	p_style.bg_color = Color(0.08, 0.10, 0.14, 1.0)
	p_style.border_width_left = 2
	p_style.border_width_top = 2
	p_style.border_width_right = 2
	p_style.border_width_bottom = 2
	p_style.border_color = Color(1.0, 0.73, 0.13, 0.8) # Solar Gold Glow
	p_style.corner_radius_top_left = 36
	p_style.corner_radius_top_right = 36
	p_style.corner_radius_bottom_left = 36
	p_style.corner_radius_bottom_right = 36
	p_container.add_theme_stylebox_override("panel", p_style)
	p_vbox.add_child(p_container)
	
	portrait_rect = ColorRect.new()
	portrait_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	portrait_rect.color = Color(0.12, 0.18, 0.28, 1.0)
	p_container.add_child(portrait_rect)
	
	hero_portrait_texture = TextureRect.new()
	hero_portrait_texture.set_anchors_preset(Control.PRESET_FULL_RECT)
	hero_portrait_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	hero_portrait_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	hero_portrait_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	p_container.add_child(hero_portrait_texture)
	
	# Circular Level badge in bottom-right corner of portrait (Design 2 reference)
	var lvl_panel = PanelContainer.new()
	lvl_panel.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	lvl_panel.offset_left = -22
	lvl_panel.offset_top = -22
	lvl_panel.offset_right = 2
	lvl_panel.offset_bottom = 2
	lvl_panel.custom_minimum_size = Vector2(24, 24)
	var lvl_s = StyleBoxFlat.new()
	lvl_s.bg_color = Color(0.06, 0.08, 0.11, 0.98)
	lvl_s.border_width_left = 1
	lvl_s.border_width_top = 1
	lvl_s.border_width_right = 1
	lvl_s.border_width_bottom = 1
	lvl_s.border_color = Color(1.0, 0.75, 0.2)
	lvl_s.corner_radius_bottom_left = 6
	lvl_s.corner_radius_bottom_right = 6
	lvl_s.corner_radius_top_left = 6
	lvl_s.corner_radius_top_right = 6
	lvl_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lvl_panel.add_theme_stylebox_override("panel", lvl_s)
	p_container.add_child(lvl_panel)
	
	hero_level_label = Label.new()
	hero_level_label.text = "1"
	hero_level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hero_level_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hero_level_label.add_theme_font_size_override("font_size", 11)
	hero_level_label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.3))
	hero_level_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lvl_panel.add_child(hero_level_label)
	
	_update_hero_portrait(target_hero)
	
	# Attributes & Combat Stats
	var stats_vbox = VBoxContainer.new()
	stats_vbox.custom_minimum_size = Vector2(115, 0)
	stats_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	stats_vbox.add_theme_constant_override("separation", 3)
	h_block.add_child(stats_vbox)
	
	# Combat stats grid (Damage, Armor, Magic Resist, Move Speed)
	var grid = GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 2)
	stats_vbox.add_child(grid)
	
	ad_val_label = _create_grid_stat(grid, "SG", "58")
	armor_val_label = _create_grid_stat(grid, "ZR", "4.0")
	mr_val_label = _create_grid_stat(grid, "BD", "25%")
	ms_val_label = _create_grid_stat(grid, "HH", "310")
	
	# Attributes row: STR (Red), AGI (Green), INT (Blue)
	var attr_hbox = HBoxContainer.new()
	attr_hbox.add_theme_constant_override("separation", 6)
	stats_vbox.add_child(attr_hbox)
	
	str_val_label = _create_stat_badge(attr_hbox, "GÜÇ", "19", Color(0.95, 0.35, 0.35))
	agi_val_label = _create_stat_badge(attr_hbox, "ÇEV", "22", Color(0.35, 0.90, 0.45))
	int_val_label = _create_stat_badge(attr_hbox, "ZEK", "15", Color(0.35, 0.75, 1.0))
	
	grid.mouse_filter = Control.MOUSE_FILTER_IGNORE
	attr_hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Mouse Hover Triggers for Stats Popup
	p_container.mouse_filter = Control.MOUSE_FILTER_PASS
	p_container.mouse_entered.connect(func():
		_is_hovering_portrait = true
		_set_stats_popup_visible(true)
	)
	p_container.mouse_exited.connect(func():
		_is_hovering_portrait = false
		if not is_alt_down and not _is_hovering_stats_vbox:
			_set_stats_popup_visible(false)
	)
	
	stats_vbox.mouse_filter = Control.MOUSE_FILTER_PASS
	stats_vbox.mouse_entered.connect(func():
		_is_hovering_stats_vbox = true
		_set_stats_popup_visible(true)
	)
	stats_vbox.mouse_exited.connect(func():
		_is_hovering_stats_vbox = false
		if not is_alt_down and not _is_hovering_portrait:
			_set_stats_popup_visible(false)
	)

func _create_stat_badge(parent: Control, tag: String, val: String, col: Color) -> Label:
	var l = Label.new()
	l.text = "%s %s" % [tag, val]
	l.add_theme_color_override("font_color", col)
	l.add_theme_font_size_override("font_size", 11)
	parent.add_child(l)
	return l

func _create_grid_stat(parent: Control, icon: String, val: String) -> Label:
	var l = Label.new()
	l.text = "%s %s" % [icon, val]
	l.add_theme_font_size_override("font_size", 11)
	l.add_theme_color_override("font_color", Color(0.88, 0.90, 0.95))
	parent.add_child(l)
	return l

# --- Abilities & Centered Health / Mana / XP Bars ---
func _build_abilities_and_centered_bars(parent: Control) -> void:
	var v_center = VBoxContainer.new()
	v_center.custom_minimum_size = Vector2(490, 0)
	v_center.alignment = BoxContainer.ALIGNMENT_CENTER
	v_center.add_theme_constant_override("separation", 8)
	parent.add_child(v_center)
	
	# Top Abilities Row (Q, W, E, R)
	var top_row = HBoxContainer.new()
	top_row.alignment = BoxContainer.ALIGNMENT_CENTER
	top_row.add_theme_constant_override("separation", 12)
	v_center.add_child(top_row)
	
	var slots = [
		{"slot": AbilityResource.Slot.Q, "key": "Q", "name": "Q", "pips": 4, "is_ulti": false},
		{"slot": AbilityResource.Slot.W, "key": "W", "name": "W", "pips": 4, "is_ulti": false},
		{"slot": AbilityResource.Slot.E, "key": "E", "name": "E", "pips": 4, "is_ulti": false},
		{"slot": AbilityResource.Slot.R, "key": "R", "name": "R", "pips": 3, "is_ulti": true}
	]
	
	for s_info in slots:
		var slot_vbox = VBoxContainer.new()
		slot_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		slot_vbox.add_theme_constant_override("separation", 2)
		top_row.add_child(slot_vbox)
		
		# [+] Level Up Button
		var lvl_btn = Button.new()
		lvl_btn.text = "+"
		lvl_btn.custom_minimum_size = Vector2(52, 16)
		lvl_btn.visible = false
		lvl_btn.add_theme_font_size_override("font_size", 12)
		var lvl_style = StyleBoxFlat.new()
		lvl_style.bg_color = Color(1.0, 0.73, 0.13, 0.95)
		lvl_style.corner_radius_top_left = 3
		lvl_style.corner_radius_top_right = 3
		lvl_style.corner_radius_bottom_left = 3
		lvl_style.corner_radius_bottom_right = 3
		lvl_btn.add_theme_stylebox_override("normal", lvl_style)
		lvl_btn.add_theme_color_override("font_color", Color(0.05, 0.05, 0.05))
		lvl_btn.pressed.connect(func(): _on_levelup_clicked(s_info.slot))
		slot_vbox.add_child(lvl_btn)
		ability_levelup_buttons[s_info.slot] = lvl_btn
		
		# Ability Icon Box with Cyber-Fantasy Frame
		var btn_container = PanelContainer.new()
		var box_size = 56 if s_info.is_ulti else 50
		btn_container.custom_minimum_size = Vector2(box_size, box_size)
		var b_box_style = StyleBoxFlat.new()
		b_box_style.bg_color = Color(0.08, 0.10, 0.15, 0.95)
		b_box_style.border_width_left = 2 if s_info.is_ulti else 1
		b_box_style.border_width_top = 2 if s_info.is_ulti else 1
		b_box_style.border_width_right = 2 if s_info.is_ulti else 1
		b_box_style.border_width_bottom = 2 if s_info.is_ulti else 1
		b_box_style.border_color = Color(1.0, 0.73, 0.13, 0.9) if s_info.is_ulti else Color(0.0, 0.86, 0.95, 0.45)
		b_box_style.corner_radius_top_left = 8
		b_box_style.corner_radius_top_right = 8
		b_box_style.corner_radius_bottom_left = 8
		b_box_style.corner_radius_bottom_right = 8
		b_box_style.shadow_size = 6 if s_info.is_ulti else 0
		b_box_style.shadow_color = Color(1.0, 0.73, 0.13, 0.3) if s_info.is_ulti else Color(0,0,0,0)
		btn_container.add_theme_stylebox_override("panel", b_box_style)
		slot_vbox.add_child(btn_container)
		
		var ab_btn = Button.new()
		ab_btn.text = s_info.key
		ab_btn.set_anchors_preset(Control.PRESET_FULL_RECT)
		ab_btn.flat = true
		ab_btn.add_theme_font_size_override("font_size", 13)
		var ab_hover_style = StyleBoxFlat.new()
		ab_hover_style.bg_color = Color(0.08, 0.32, 0.42, 0.72) if not s_info.is_ulti else Color(0.42, 0.20, 0.08, 0.74)
		ab_hover_style.border_width_left = 1
		ab_hover_style.border_width_top = 1
		ab_hover_style.border_width_right = 1
		ab_hover_style.border_width_bottom = 1
		ab_hover_style.border_color = Color(0.25, 0.92, 1.0, 0.9) if not s_info.is_ulti else Color(1.0, 0.76, 0.25, 0.95)
		ab_hover_style.corner_radius_top_left = 7
		ab_hover_style.corner_radius_top_right = 7
		ab_hover_style.corner_radius_bottom_left = 7
		ab_hover_style.corner_radius_bottom_right = 7
		ab_btn.add_theme_stylebox_override("hover", ab_hover_style)
		ab_btn.add_theme_stylebox_override("pressed", ab_hover_style)
		ab_btn.add_theme_color_override("font_hover_color", Color(1.0, 1.0, 1.0))
		ab_btn.pressed.connect(func(): _on_ability_button_clicked(s_info.slot))
		ab_btn.mouse_entered.connect(func(): _on_ability_button_hover(s_info.slot, true, btn_container))
		ab_btn.mouse_exited.connect(func(): _on_ability_button_hover(s_info.slot, false))
		btn_container.add_child(ab_btn)
		ability_buttons[s_info.slot] = ab_btn
		
		# Cooldown countdown overlay
		var cd_overlay = ColorRect.new()
		cd_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
		cd_overlay.color = Color(0.0, 0.0, 0.0, 0.78)
		cd_overlay.visible = false
		btn_container.add_child(cd_overlay)
		ability_cooldown_overlays[s_info.slot] = cd_overlay
		
		var cd_lbl = Label.new()
		cd_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
		cd_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cd_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		cd_lbl.add_theme_font_size_override("font_size", 13)
		cd_overlay.add_child(cd_lbl)
		ability_cooldown_labels[s_info.slot] = cd_lbl
		
		# Mana Cost label (Cyan text)
		var mana_lbl = Label.new()
		mana_lbl.text = ""
		mana_lbl.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
		mana_lbl.offset_left = -26
		mana_lbl.offset_top = -14
		mana_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		mana_lbl.add_theme_font_size_override("font_size", 9)
		mana_lbl.add_theme_color_override("font_color", Color(0.49, 0.96, 1.0))
		btn_container.add_child(mana_lbl)
		ability_mana_labels[s_info.slot] = mana_lbl
		
		# Level pips
		var pip_hbox = HBoxContainer.new()
		pip_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		pip_hbox.add_theme_constant_override("separation", 2)
		slot_vbox.add_child(pip_hbox)
		
		for p in range(s_info.pips):
			var pip = ColorRect.new()
			pip.custom_minimum_size = Vector2(s_info.is_ulti and 12 or 8, 3)
			pip.color = Color(0.20, 0.22, 0.26)
			pip_hbox.add_child(pip)
			
		ability_pip_containers[s_info.slot] = pip_hbox
		
	_build_status_bars(v_center)

# --- Health, Mana & XP Bars (Spans whole center width) ---
func _build_status_bars(parent: Control) -> void:
	# 0. Passives & Buffs / Debuffs Status Row
	status_effect_bar = DotaStatusEffectBar.new()
	status_effect_bar.target_hero = target_hero
	parent.add_child(status_effect_bar)
	buffs_container = status_effect_bar

	# 1. Health Bar (Emerald Green Gradient)
	var hp_box = PanelContainer.new()
	hp_box.custom_minimum_size = Vector2(500, 24)
	var hp_box_style = StyleBoxFlat.new()
	hp_box_style.bg_color = Color(0.06, 0.08, 0.10, 1.0)
	hp_box_style.border_width_left = 1
	hp_box_style.border_width_top = 1
	hp_box_style.border_width_right = 1
	hp_box_style.border_width_bottom = 1
	hp_box_style.border_color = Color(0.18, 0.72, 0.52, 0.74)
	hp_box_style.corner_radius_top_left = 4
	hp_box_style.corner_radius_top_right = 4
	hp_box.add_theme_stylebox_override("panel", hp_box_style)
	parent.add_child(hp_box)
	
	hp_bar = ProgressBar.new()
	hp_bar.set_anchors_preset(Control.PRESET_FULL_RECT)
	hp_bar.show_percentage = false
	var hp_fill = StyleBoxFlat.new()
	hp_fill.bg_color = Color(0.05, 0.82, 0.48, 1.0) # Emerald Green
	hp_fill.corner_radius_top_left = 3
	hp_fill.corner_radius_top_right = 3
	hp_bar.add_theme_stylebox_override("fill", hp_fill)
	hp_box.add_child(hp_bar)
	
	hp_text_label = Label.new()
	hp_text_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	hp_text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hp_text_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hp_text_label.add_theme_font_size_override("font_size", 11)
	hp_text_label.text = "538 / 538"
	hp_box.add_child(hp_text_label)
	
	hp_regen_label = Label.new()
	hp_regen_label.set_anchors_preset(Control.PRESET_RIGHT_WIDE)
	hp_regen_label.offset_right = -8
	hp_regen_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	hp_regen_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hp_regen_label.add_theme_font_size_override("font_size", 10)
	hp_regen_label.add_theme_color_override("font_color", Color(0.6, 0.98, 0.6))
	hp_regen_label.text = "+2.9"
	hp_box.add_child(hp_regen_label)
	
	# 2. Mana Bar (Sapphire Blue Gradient)
	var mp_box = PanelContainer.new()
	mp_box.custom_minimum_size = Vector2(500, 16)
	var mp_box_style = StyleBoxFlat.new()
	mp_box_style.bg_color = Color(0.05, 0.07, 0.10, 1.0)
	mp_box_style.border_width_left = 1
	mp_box_style.border_width_bottom = 1
	mp_box_style.border_width_right = 1
	mp_box_style.border_color = Color(0.20, 0.48, 0.95, 0.70)
	mp_box_style.corner_radius_bottom_left = 4
	mp_box_style.corner_radius_bottom_right = 4
	mp_box.add_theme_stylebox_override("panel", mp_box_style)
	parent.add_child(mp_box)
	
	mp_bar = ProgressBar.new()
	mp_bar.set_anchors_preset(Control.PRESET_FULL_RECT)
	mp_bar.show_percentage = false
	var mp_fill = StyleBoxFlat.new()
	mp_fill.bg_color = Color(0.18, 0.54, 1.0, 1.0) # Sapphire Blue
	mp_fill.corner_radius_bottom_left = 3
	mp_fill.corner_radius_bottom_right = 3
	mp_bar.add_theme_stylebox_override("fill", mp_fill)
	mp_box.add_child(mp_bar)
	
	mp_text_label = Label.new()
	mp_text_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	mp_text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mp_text_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	mp_text_label.add_theme_font_size_override("font_size", 10)
	mp_text_label.text = "255 / 255"
	mp_box.add_child(mp_text_label)
	
	mp_regen_label = Label.new()
	mp_regen_label.set_anchors_preset(Control.PRESET_RIGHT_WIDE)
	mp_regen_label.offset_right = -8
	mp_regen_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	mp_regen_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	mp_regen_label.add_theme_font_size_override("font_size", 9)
	mp_regen_label.add_theme_color_override("font_color", Color(0.55, 0.85, 1.0))
	mp_regen_label.text = "+1.5"
	mp_box.add_child(mp_regen_label)
	
	# 3. Experience (XP) Bar (Thin Void Purple Gradient)
	var xp_box = PanelContainer.new()
	xp_box.custom_minimum_size = Vector2(500, 4)
	var xp_b_style = StyleBoxFlat.new()
	xp_b_style.bg_color = Color(0.04, 0.05, 0.08, 0.9)
	xp_box.add_theme_stylebox_override("panel", xp_b_style)
	parent.add_child(xp_box)
	
	xp_bar = ProgressBar.new()
	xp_bar.set_anchors_preset(Control.PRESET_FULL_RECT)
	xp_bar.show_percentage = false
	var xp_fill = StyleBoxFlat.new()
	xp_fill.bg_color = Color(0.58, 0.20, 0.92, 1.0) # Void Purple
	xp_bar.add_theme_stylebox_override("fill", xp_fill)
	xp_box.add_child(xp_bar)
	
	# 3. Heat Bar (For Heat-resource heroes like Kaelgor)
	heat_container = PanelContainer.new()
	heat_container.custom_minimum_size = Vector2(490, 14)
	heat_container.visible = false
	parent.add_child(heat_container)
	
	heat_bar = ProgressBar.new()
	heat_bar.set_anchors_preset(Control.PRESET_FULL_RECT)
	heat_bar.show_percentage = false
	var heat_fill = StyleBoxFlat.new()
	heat_fill.bg_color = Color(1.0, 0.45, 0.1, 1.0)
	heat_bar.add_theme_stylebox_override("fill", heat_fill)
	heat_container.add_child(heat_bar)
	
	heat_text_label = Label.new()
	heat_text_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	heat_text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	heat_text_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	heat_text_label.add_theme_font_size_override("font_size", 10)
	heat_text_label.add_theme_color_override("font_color", Color(1.0, 0.9, 0.6))
	heat_text_label.text = "0 / 100 ISI"
	heat_container.add_child(heat_text_label)

# --- 2x3 Inventory Grid & Shop Floating Card (Right of Bottom Cluster) ---
class InventoryDragSlotButton extends Button:
	signal item_drag_dropped(from_slot: int, to_slot: int)
	signal item_drag_ended(slot_index: int, was_accepted: bool)

	var slot_index: int = -1
	var has_item: bool = false
	var drop_was_accepted: bool = false

	func _get_drag_data(_at_position: Vector2) -> Variant:
		if not has_item or slot_index < 0:
			return null
		drop_was_accepted = false
		var preview = Label.new()
		preview.text = "EŞYA"
		preview.add_theme_font_size_override("font_size", 10)
		preview.add_theme_color_override("font_color", Color(1.0, 0.88, 0.35))
		preview.modulate = Color(1.0, 1.0, 1.0, 0.9)
		set_drag_preview(preview)
		return {"eclipse_inventory_slot": slot_index}

	func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
		return data is Dictionary and data.has("eclipse_inventory_slot") and int(data["eclipse_inventory_slot"]) != slot_index

	func _drop_data(_at_position: Vector2, data: Variant) -> void:
		drop_was_accepted = true
		item_drag_dropped.emit(int(data["eclipse_inventory_slot"]), slot_index)

	func _notification(what: int) -> void:
		if what == NOTIFICATION_DRAG_END:
			item_drag_ended.emit(slot_index, drop_was_accepted)

func _build_inventory_box(parent: Control) -> void:
	var inv_card = PanelContainer.new()
	var card_style = StyleBoxFlat.new()
	card_style.bg_color = Color(0.035, 0.055, 0.09, 0.96)
	card_style.border_width_left = 1
	card_style.border_width_top = 1
	card_style.border_width_right = 1
	card_style.border_width_bottom = 1
	card_style.border_color = Color(0.0, 0.86, 0.95, 0.66) # Electric Cyan Glow
	card_style.corner_radius_top_left = 10
	card_style.corner_radius_top_right = 10
	card_style.corner_radius_bottom_left = 10
	card_style.corner_radius_bottom_right = 10
	card_style.shadow_size = 14
	card_style.shadow_color = Color(0, 0, 0, 0.75)
	card_style.content_margin_left = 10
	card_style.content_margin_right = 10
	card_style.content_margin_top = 8
	card_style.content_margin_bottom = 8
	inv_card.add_theme_stylebox_override("panel", card_style)
	parent.add_child(inv_card)
	
	var h_inv = HBoxContainer.new()
	h_inv.alignment = BoxContainer.ALIGNMENT_CENTER
	h_inv.add_theme_constant_override("separation", 10)
	inv_card.add_child(h_inv)
	
	# 2x3 Item Grid
	var grid = GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 4)
	grid.add_theme_constant_override("v_separation", 4)
	h_inv.add_child(grid)
	
	inventory_slot_buttons.clear()
	inventory_slot_textures.clear()
	inventory_slot_cooldown_overlays.clear()
	inventory_slot_cooldown_labels.clear()
	inventory_slot_hotkey_labels.clear()
	inventory_slot_target_labels.clear()
	
	var hotkeys = ["1", "2", "3", "4", "5", "6"]
	for i in range(6):
		var slot_container = PanelContainer.new()
		slot_container.custom_minimum_size = Vector2(44, 42)
		var s_style = StyleBoxFlat.new()
		s_style.bg_color = Color(0.08, 0.10, 0.14, 0.98)
		s_style.border_width_left = 1
		s_style.border_width_top = 1
		s_style.border_width_right = 1
		s_style.border_width_bottom = 1
		s_style.border_color = Color(0.22, 0.28, 0.38, 1.0)
		s_style.corner_radius_top_left = 4
		s_style.corner_radius_top_right = 4
		s_style.corner_radius_bottom_left = 4
		s_style.corner_radius_bottom_right = 4
		slot_container.add_theme_stylebox_override("panel", s_style)
		grid.add_child(slot_container)
		
		var tex_rect = TextureRect.new()
		tex_rect.custom_minimum_size = Vector2(32, 32)
		tex_rect.set_anchors_preset(Control.PRESET_CENTER)
		tex_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tex_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		tex_rect.modulate = Color(1.0, 1.0, 1.0, 1.0)
		tex_rect.visible = false
		slot_container.add_child(tex_rect)
		inventory_slot_textures.append(tex_rect)
		
		var cd_overlay = ColorRect.new()
		cd_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
		cd_overlay.color = Color(0.0, 0.0, 0.0, 0.78)
		cd_overlay.visible = false
		slot_container.add_child(cd_overlay)
		inventory_slot_cooldown_overlays.append(cd_overlay)
		
		var cd_lbl = Label.new()
		cd_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
		cd_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cd_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		cd_lbl.add_theme_font_size_override("font_size", 11)
		cd_lbl.add_theme_color_override("font_color", Color(1.0, 0.9, 0.3))
		cd_overlay.add_child(cd_lbl)
		inventory_slot_cooldown_labels.append(cd_lbl)
		
		var hk_lbl = Label.new()
		hk_lbl.text = hotkeys[i]
		hk_lbl.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
		hk_lbl.offset_left = 3
		hk_lbl.offset_top = -14
		hk_lbl.add_theme_font_size_override("font_size", 9)
		hk_lbl.add_theme_color_override("font_color", Color(0.75, 0.82, 0.92))
		slot_container.add_child(hk_lbl)
		inventory_slot_hotkey_labels.append(hk_lbl)

		var target_lbl = Label.new()
		target_lbl.text = ""
		target_lbl.set_anchors_preset(Control.PRESET_TOP_RIGHT)
		target_lbl.offset_left = -30
		target_lbl.offset_top = 2
		target_lbl.offset_right = -2
		target_lbl.offset_bottom = 14
		target_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		target_lbl.add_theme_font_size_override("font_size", 7)
		target_lbl.add_theme_color_override("font_color", Color(0.35, 0.92, 1.0, 0.95))
		target_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		target_lbl.visible = false
		slot_container.add_child(target_lbl)
		inventory_slot_target_labels.append(target_lbl)
		
		var btn = InventoryDragSlotButton.new()
		btn.slot_index = i
		btn.set_anchors_preset(Control.PRESET_FULL_RECT)
		btn.flat = true
		btn.gui_input.connect(func(ev): _on_inventory_slot_gui_input(ev, i))
		btn.item_drag_dropped.connect(_on_inventory_item_dropped)
		btn.item_drag_ended.connect(_on_inventory_drag_ended)
		btn.mouse_entered.connect(func(): _on_item_slot_hover(i, true, slot_container))
		btn.mouse_exited.connect(func(): _on_item_slot_hover(i, false))
		slot_container.add_child(btn)
		inventory_slot_buttons.append(btn)

	# Right side of inventory card: Gold + Shop Button
	var shop_vbox = VBoxContainer.new()
	shop_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	shop_vbox.add_theme_constant_override("separation", 4)
	h_inv.add_child(shop_vbox)
	
	var gold_panel = PanelContainer.new()
	var g_style = StyleBoxFlat.new()
	g_style.bg_color = Color(0.10, 0.12, 0.16, 0.95)
	g_style.border_width_left = 1
	g_style.border_width_top = 1
	g_style.border_width_right = 1
	g_style.border_width_bottom = 1
	g_style.border_color = Color(1.0, 0.73, 0.13, 0.6)
	g_style.corner_radius_top_left = 4
	g_style.corner_radius_top_right = 4
	g_style.corner_radius_bottom_left = 4
	g_style.corner_radius_bottom_right = 4
	g_style.content_margin_left = 6
	g_style.content_margin_right = 6
	g_style.content_margin_top = 2
	g_style.content_margin_bottom = 2
	gold_panel.add_theme_stylebox_override("panel", g_style)
	shop_vbox.add_child(gold_panel)
	
	gold_label = Label.new()
	gold_label.text = "600g"
	gold_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	gold_label.add_theme_font_size_override("font_size", 12)
	gold_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.25))
	gold_panel.add_child(gold_label)
	
	shop_toggle_button = Button.new()
	shop_toggle_button.text = "DÜKKAN [B]"
	shop_toggle_button.custom_minimum_size = Vector2(82, 28)
	shop_toggle_button.add_theme_font_size_override("font_size", 10)
	var s_btn_style = StyleBoxFlat.new()
	s_btn_style.bg_color = Color(0.18, 0.14, 0.05, 0.95)
	s_btn_style.border_width_left = 1
	s_btn_style.border_width_top = 1
	s_btn_style.border_width_right = 1
	s_btn_style.border_width_bottom = 1
	s_btn_style.border_color = Color(1.0, 0.73, 0.13, 0.9)
	s_btn_style.corner_radius_top_left = 4
	s_btn_style.corner_radius_top_right = 4
	s_btn_style.corner_radius_bottom_left = 4
	s_btn_style.corner_radius_bottom_right = 4
	shop_toggle_button.add_theme_stylebox_override("normal", s_btn_style)
	shop_toggle_button.add_theme_color_override("font_color", Color(1.0, 0.85, 0.25))
	shop_toggle_button.pressed.connect(_toggle_shop)
	shop_vbox.add_child(shop_toggle_button)

	var usage_hint = Label.new()
	usage_hint.text = "Sağ tık: kullan  •  Sol: bilgi  •  Sürükle: taşı  •  Shift+Sağ: yere bırak"
	usage_hint.add_theme_font_size_override("font_size", 8)
	usage_hint.add_theme_color_override("font_color", Color(0.53, 0.65, 0.76, 0.9))
	usage_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	usage_hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	usage_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	shop_vbox.add_child(usage_hint)

# ==============================================================================
# 3. BOTTOM-RIGHT STASH, QUICK-BUY & GOLD (market.png reference)
# ==============================================================================
var quick_buy_item: ItemResource = null # Queue head; kept for existing HUD bindings.
var quick_buy_queue: Array[ItemResource] = []
var quick_buy_btn: Button = null
var stash_slot_buttons: Array[Button] = []

func _build_gold_and_shop_trigger(parent: Control) -> void:
	var container = VBoxContainer.new()
	container.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	container.offset_left = -230
	container.offset_top = -225
	container.offset_right = -8
	container.offset_bottom = -8
	container.add_theme_constant_override("separation", 5)
	parent.add_child(container)
	
	# 1. ZULA (Stash Box: 6 slots + HEPSİNİ AL)
	var stash_panel = PanelContainer.new()
	var s_style = StyleBoxFlat.new()
	s_style.bg_color = Color(0.06, 0.08, 0.11, 0.95)
	s_style.border_width_left = 1
	s_style.border_width_top = 1
	s_style.border_width_right = 1
	s_style.border_width_bottom = 1
	s_style.border_color = Color(0.25, 0.32, 0.42)
	s_style.content_margin_left = 6
	s_style.content_margin_right = 6
	s_style.content_margin_top = 4
	s_style.content_margin_bottom = 4
	s_style.corner_radius_top_left = 6
	s_style.corner_radius_top_right = 6
	stash_panel.add_theme_stylebox_override("panel", s_style)
	container.add_child(stash_panel)
	
	var stash_vbox = VBoxContainer.new()
	stash_vbox.add_theme_constant_override("separation", 3)
	stash_panel.add_child(stash_vbox)
	
	var stash_hdr = HBoxContainer.new()
	stash_vbox.add_child(stash_hdr)
	
	var take_all_btn = Button.new()
	take_all_btn.text = "HEPSİNİ AL"
	take_all_btn.add_theme_font_size_override("font_size", 9)
	take_all_btn.custom_minimum_size = Vector2(70, 18)
	take_all_btn.pressed.connect(_on_take_all_stash_clicked)
	stash_hdr.add_child(take_all_btn)
	
	var stash_lbl = Label.new()
	stash_lbl.text = "ZULA"
	stash_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stash_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	stash_lbl.add_theme_font_size_override("font_size", 9)
	stash_lbl.add_theme_color_override("font_color", Color(0.65, 0.72, 0.82))
	stash_hdr.add_child(stash_lbl)
	
	var stash_grid = HBoxContainer.new()
	stash_grid.add_theme_constant_override("separation", 3)
	stash_vbox.add_child(stash_grid)
	
	stash_slot_buttons.clear()
	for i in range(6):
		var s_btn = Button.new()
		s_btn.custom_minimum_size = Vector2(32, 26)
		s_btn.add_theme_font_size_override("font_size", 8)
		s_btn.text = ""
		stash_grid.add_child(s_btn)
		stash_slot_buttons.append(s_btn)
		
	# 2. QUICK-BUY & GOLD BOX (market.png reference)
	var qb_panel = PanelContainer.new()
	var q_style = StyleBoxFlat.new()
	q_style.bg_color = Color(0.06, 0.08, 0.10, 0.98)
	q_style.border_width_left = 2
	q_style.border_width_top = 2
	q_style.border_width_right = 2
	q_style.border_width_bottom = 2
	q_style.border_color = Color(0.3, 0.4, 0.52)
	q_style.content_margin_left = 6
	q_style.content_margin_right = 6
	q_style.content_margin_top = 5
	q_style.content_margin_bottom = 5
	q_style.corner_radius_bottom_left = 6
	q_style.corner_radius_bottom_right = 6
	qb_panel.add_theme_stylebox_override("panel", q_style)
	container.add_child(qb_panel)
	
	var qb_vbox = VBoxContainer.new()
	qb_vbox.add_theme_constant_override("separation", 4)
	qb_panel.add_child(qb_vbox)
	
	# Top: Quick-Buy slot & TP slot
	var qb_top_h = HBoxContainer.new()
	qb_top_h.add_theme_constant_override("separation", 6)
	qb_vbox.add_child(qb_top_h)
	
	quick_buy_btn = Button.new()
	quick_buy_btn.text = "DESO (💰 4500)"
	quick_buy_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	quick_buy_btn.custom_minimum_size = Vector2(0, 30)
	quick_buy_btn.add_theme_font_size_override("font_size", 10)
	quick_buy_btn.add_theme_color_override("font_color", Color(1.0, 0.9, 0.4))
	quick_buy_btn.pressed.connect(_on_quick_buy_clicked)
	qb_top_h.add_child(quick_buy_btn)
	
	var tp_btn = Button.new()
	tp_btn.text = "TP: 1"
	tp_btn.custom_minimum_size = Vector2(40, 30)
	tp_btn.add_theme_font_size_override("font_size", 10)
	tp_btn.tooltip_text = "Işınlanma Parşömeni (TP Scroll - 100g)"
	qb_top_h.add_child(tp_btn)
	
	# Middle: Gold Label & Shop Open Button
	shop_toggle_button = Button.new()
	shop_toggle_button.custom_minimum_size = Vector2(0, 32)
	shop_toggle_button.pressed.connect(_toggle_shop)
	qb_vbox.add_child(shop_toggle_button)
	
	var g_hbox = HBoxContainer.new()
	g_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	g_hbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	shop_toggle_button.add_child(g_hbox)
	
	gold_label = Label.new()
	gold_label.text = "99999g"
	gold_label.add_theme_color_override("font_color", Color(1.0, 0.88, 0.25))
	gold_label.add_theme_font_size_override("font_size", 13)
	g_hbox.add_child(gold_label)
	
	var shop_hint = Label.new()
	shop_hint.text = " [B] DÜKKAN"
	shop_hint.add_theme_color_override("font_color", Color(0.7, 0.78, 0.88))
	shop_hint.add_theme_font_size_override("font_size", 9)
	g_hbox.add_child(shop_hint)
	
	# Bottom: Courier & Action Bar
	var courier_h = HBoxContainer.new()
	courier_h.add_theme_constant_override("separation", 4)
	courier_h.alignment = BoxContainer.ALIGNMENT_CENTER
	qb_vbox.add_child(courier_h)
	
	var btn_courier = _add_action_mini_btn(courier_h, "Kurye F2", "Kurye Seç (F2)")
	btn_courier.pressed.connect(func():
		var team_id = target_hero.team if target_hero != null else TeamDefinitions.Team.RADIANT
		var c = CourierManagerClass.get_courier_for_team(team_id)
		if c != null and Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("KURYE SEÇİLDİ (Durum: %s)" % CourierEntityClass.CourierState.keys()[c.state])
	)
	
	var btn_burst = _add_action_mini_btn(courier_h, "Hızlı F4", "Hızlı Teslimat (F4)")
	btn_burst.pressed.connect(func():
		if target_hero != null:
			CourierManagerClass.speed_burst_for_hero(target_hero)
	)
	
	var btn_deliver = _add_action_mini_btn(courier_h, "Gönder F3", "Kurye Eşyaları Getir (F3)")
	btn_deliver.pressed.connect(func():
		if target_hero != null:
			CourierManagerClass.deliver_for_hero(target_hero)
	)

func _add_action_mini_btn(parent: Control, txt: String, tip: String) -> Button:
	var btn = Button.new()
	btn.text = txt
	btn.tooltip_text = tip
	btn.custom_minimum_size = Vector2(50, 24)
	btn.add_theme_font_size_override("font_size", 8)
	parent.add_child(btn)
	return btn

func _on_quick_buy_queued(item: ItemResource) -> void:
	if item == null:
		return
	quick_buy_queue.append(item)
	_refresh_quick_buy_button()

func _refresh_quick_buy_button() -> void:
	quick_buy_item = quick_buy_queue.front() if not quick_buy_queue.is_empty() else null
	if quick_buy_btn == null:
		return
	if quick_buy_item == null:
		quick_buy_btn.text = "HIZLI ALIM"
		quick_buy_btn.tooltip_text = "Mağazada bir eşyaya sol tıklayarak sıraya ekleyin."
		return
	var queued_suffix = " +%d" % (quick_buy_queue.size() - 1) if quick_buy_queue.size() > 1 else ""
	quick_buy_btn.text = "%s (%dg)%s" % [quick_buy_item.item_name.substr(0, 10), quick_buy_item.cost, queued_suffix]
	quick_buy_btn.tooltip_text = "Sıradaki: %s\nKuyrukta %d eşya var." % [quick_buy_item.item_name, quick_buy_queue.size()]

func _on_quick_buy_clicked() -> void:
	if quick_buy_item == null:
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("HIZLI ALIM: Kuyruk boş.")
		return
	if quick_buy_item != null and target_hero != null and target_hero.inventory_manager != null:
		var ok = target_hero.inventory_manager.buy_item(quick_buy_item, func(id): return Database.get_item(id))
		if ok:
			var purchased_item = quick_buy_item
			quick_buy_queue.pop_front()
			_refresh_quick_buy_button()
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("HIZLI ALIM: %s SATIN ALINDI!" % purchased_item.item_name.to_upper())
		elif Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("HIZLI ALIM BAŞARISIZ: %s" % target_hero.inventory_manager.last_purchase_failure_reason)

func _on_take_all_stash_clicked() -> void:
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("ZULA: TÜM EŞYALAR ENVANTERE ALINDI")

var dota_minimap: DotaMinimap = null

# ==============================================================================
# 4. MINIMAP (Bottom Left, Design 2 reference)
# ==============================================================================
func _build_minimap(parent: Control) -> void:
	var h_box = HBoxContainer.new()
	h_box.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	h_box.offset_left = 16
	h_box.offset_bottom = -16
	h_box.offset_right = 260
	h_box.offset_top = -210
	h_box.add_theme_constant_override("separation", 6)
	parent.add_child(h_box)
	
	# 1. Minimap Panel
	var mini_panel = PanelContainer.new()
	mini_panel.custom_minimum_size = Vector2(192, 192)
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.06, 0.08, 0.11, 0.88)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.0, 0.86, 0.95, 0.4) # Electric Cyan Glow
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10
	style.shadow_size = 14
	style.shadow_color = Color(0, 0, 0, 0.75)
	mini_panel.add_theme_stylebox_override("panel", style)
	h_box.add_child(mini_panel)
	
	dota_minimap = DotaMinimap.new()
	dota_minimap.camera = camera
	dota_minimap.target_hero = target_hero
	mini_panel.add_child(dota_minimap)
	
	# 2. Radar Scan & Glyph Fortification Side Buttons
	var side_vbox = VBoxContainer.new()
	side_vbox.alignment = BoxContainer.ALIGNMENT_BEGIN
	side_vbox.add_theme_constant_override("separation", 6)
	h_box.add_child(side_vbox)
	
	var scan_btn = Button.new()
	scan_btn.text = "TARA"
	scan_btn.tooltip_text = "Radar Taraması (Scan - 60s Bekleme)"
	scan_btn.custom_minimum_size = Vector2(44, 32)
	scan_btn.add_theme_font_size_override("font_size", 9)
	var s_style = StyleBoxFlat.new()
	s_style.bg_color = Color(0.08, 0.10, 0.14, 0.9)
	s_style.border_width_left = 1
	s_style.border_width_top = 1
	s_style.border_width_right = 1
	s_style.border_width_bottom = 1
	s_style.border_color = Color(0.0, 0.86, 0.95, 0.4)
	s_style.corner_radius_top_left = 4
	s_style.corner_radius_top_right = 4
	s_style.corner_radius_bottom_left = 4
	s_style.corner_radius_bottom_right = 4
	scan_btn.add_theme_stylebox_override("normal", s_style)
	scan_btn.add_theme_color_override("font_color", Color(0.49, 0.96, 1.0))
	scan_btn.pressed.connect(func(): if dota_minimap != null: dota_minimap.trigger_radar_scan())
	side_vbox.add_child(scan_btn)
	
	var glyph_btn = Button.new()
	glyph_btn.text = "KORU"
	glyph_btn.tooltip_text = "Kule Tahkimatı (Glyph of Fortification - 6s Dokunulmazlık)"
	glyph_btn.custom_minimum_size = Vector2(44, 32)
	glyph_btn.add_theme_font_size_override("font_size", 9)
	var g_style = StyleBoxFlat.new()
	g_style.bg_color = Color(0.12, 0.10, 0.06, 0.9)
	g_style.border_width_left = 1
	g_style.border_width_top = 1
	g_style.border_width_right = 1
	g_style.border_width_bottom = 1
	g_style.border_color = Color(1.0, 0.73, 0.13, 0.5)
	g_style.corner_radius_top_left = 4
	g_style.corner_radius_top_right = 4
	g_style.corner_radius_bottom_left = 4
	g_style.corner_radius_bottom_right = 4
	glyph_btn.add_theme_stylebox_override("normal", g_style)
	glyph_btn.add_theme_color_override("font_color", Color(1.0, 0.85, 0.25))
	glyph_btn.pressed.connect(func(): if dota_minimap != null: dota_minimap.trigger_glyph_fortification())
	side_vbox.add_child(glyph_btn)

func _setup_shop_modal(parent: Control) -> void:
	shop_ui = ShopInventoryUI.new()
	shop_ui.visible = false
	parent.add_child(shop_ui)
	if target_hero != null:
		shop_ui.bind_hero(target_hero)
	shop_ui.quick_buy_queued.connect(_on_quick_buy_queued)

func _toggle_shop() -> void:
	if shop_ui != null:
		shop_ui.toggle_shop()

func _bind_hero(hero: HeroEntity) -> void:
	if target_hero != hero:
		target_hero = hero
	if shop_ui != null and hero != null:
		shop_ui.bind_hero(hero)
	if demo_panel != null and hero != null:
		demo_panel.target_hero = hero
	if dota_minimap != null and hero != null:
		dota_minimap.target_hero = hero
	if status_effect_bar != null:
		status_effect_bar.target_hero = hero
	if dota_scoreboard != null and hero != null:
		dota_scoreboard.player_hero = hero
		
	if hero != null:
		_update_hero_portrait(hero)
		if hero_name_label != null:
			hero_name_label.text = hero.entity_name.to_upper()

func _update_hero_portrait(hero: Node) -> void:
	if hero_portrait_texture == null:
		return
	var raw_name = "solen"
	if hero != null:
		if hero is HeroEntity:
			if "entity_name" in hero and not str(hero.entity_name).is_empty():
				raw_name = str(hero.entity_name)
			elif "hero_name" in hero and not str(hero.hero_name).is_empty():
				raw_name = str(hero.hero_name)
			elif hero.hero_resource != null and not hero.hero_resource.hero_name.is_empty():
				raw_name = hero.hero_resource.hero_name
			else:
				raw_name = hero.name.replace("Hero", "").replace("@", "")
		elif hero is TowerEntity:
			raw_name = "tower"
		elif hero is CreepEntity:
			raw_name = "creep"
		elif hero is ObjectiveEntity or hero.name.contains("Leviathan"):
			raw_name = "leviathan"
		elif hero.is_in_group("couriers") or hero.name.contains("Courier"):
			raw_name = "courier"
		elif "entity_name" in hero:
			raw_name = hero.entity_name.to_lower().replace(" ", "_")
		else:
			raw_name = hero.name.to_lower()
			
	raw_name = raw_name.strip_edges().to_lower()
	var p_path = "res://assets/icons/heroes/%s.png" % raw_name
	var card_path = "res://assets/icons/heroes/cards/%s_card.png" % raw_name
	
	if ResourceLoader.exists(p_path):
		hero_portrait_texture.texture = load(p_path)
		hero_portrait_texture.visible = true
		if portrait_rect != null:
			portrait_rect.visible = false
	elif ResourceLoader.exists(card_path):
		hero_portrait_texture.texture = load(card_path)
		hero_portrait_texture.visible = true
		if portrait_rect != null:
			portrait_rect.visible = false
	else:
		var fallback_path = "res://assets/icons/heroes/solen.png"
		if ResourceLoader.exists(fallback_path):
			hero_portrait_texture.texture = load(fallback_path)
			hero_portrait_texture.visible = true
			if portrait_rect != null:
				portrait_rect.visible = false
		else:
			hero_portrait_texture.visible = false
			if portrait_rect != null:
				portrait_rect.visible = true

func _bind_match_manager(p_mgr: MatchManager) -> void:
	match_manager = p_mgr
	match_manager.score_updated.connect(func(rad_k, dire_k, _rt, _dt):
		if radiant_score_label != null: radiant_score_label.text = str(rad_k)
		if dire_score_label != null: dire_score_label.text = str(dire_k)
		if kill_death_label != null: kill_death_label.text = "K: %d  D: %d" % [rad_k, dire_k]
	)
	match_manager.match_ended.connect(func(_is_vic, stats):
		if match_result_ui != null:
			match_result_ui.show_match_result(stats)
	)

func _update_dota_hud_values() -> void:
	var display_unit: Node = inspected_unit if (inspected_unit != null and is_instance_valid(inspected_unit)) else target_hero
	if display_unit == null or not is_instance_valid(display_unit):
		return
		
	var is_courier = display_unit.is_in_group("couriers") or display_unit.name.contains("Courier")
	var is_hero = display_unit is HeroEntity
	var is_player_hero = (display_unit == target_hero)
	
	var stats: AttributeSystem = null
	if display_unit.has_node("AttributeSystem"):
		stats = display_unit.get_node("AttributeSystem") as AttributeSystem
	elif "attribute_system" in display_unit and display_unit.attribute_system != null:
		stats = display_unit.attribute_system
		
	# Name & Level
	if hero_name_label != null:
		if is_courier:
			hero_name_label.text = "[ UÇAN KURYE ]"
		elif "entity_name" in display_unit and not str(display_unit.entity_name).is_empty():
			hero_name_label.text = ("[ " + display_unit.entity_name.to_upper() + " ]") if not is_player_hero else display_unit.entity_name.to_upper()
		else:
			hero_name_label.text = ("[ " + display_unit.name.to_upper() + " ]") if not is_player_hero else display_unit.name.to_upper()
			
	if hero_level_label != null:
		if is_hero and stats != null:
			hero_level_label.text = str(stats.level)
			hero_level_label.visible = true
		elif is_courier:
			hero_level_label.text = "1"
			hero_level_label.visible = true
		else:
			hero_level_label.visible = false
			
	# HP / Mana
	var cur_hp: float = 150.0
	var max_hp: float = 150.0
	var hp_regen: float = 0.0
	var cur_mp: float = 0.0
	var max_mp: float = 0.0
	var mp_regen: float = 0.0
	
	if stats != null:
		cur_hp = stats.current_health
		max_hp = maxf(1.0, stats.get_stat(StatModifier.TargetStat.MAX_HEALTH))
		hp_regen = stats.get_stat(StatModifier.TargetStat.HEALTH_REGEN)
		cur_mp = stats.current_mana
		max_mp = stats.get_stat(StatModifier.TargetStat.MAX_MANA)
		mp_regen = stats.get_stat(StatModifier.TargetStat.MANA_REGEN)
	elif "health" in display_unit:
		cur_hp = display_unit.health
		max_hp = display_unit.max_health if "max_health" in display_unit else 150.0
		
	if hp_bar != null:
		hp_bar.max_value = max_hp
		hp_bar.value = cur_hp
	if hp_text_label != null:
		hp_text_label.text = "%d / %d" % [int(cur_hp), int(max_hp)]
	if hp_regen_label != null:
		hp_regen_label.text = "+%.1f" % hp_regen
		
	if mp_bar != null:
		if max_mp > 0.0:
			mp_bar.visible = true
			mp_bar.max_value = max_mp
			mp_bar.value = cur_mp
		else:
			mp_bar.visible = false
			
	if mp_text_label != null:
		if max_mp > 0.0:
			mp_text_label.visible = true
			mp_text_label.text = "%d / %d" % [int(cur_mp), int(max_mp)]
		else:
			mp_text_label.visible = false
			
	if mp_regen_label != null:
		mp_regen_label.visible = (max_mp > 0.0)
		mp_regen_label.text = "+%.1f" % mp_regen
		
	if xp_bar != null:
		if is_player_hero and stats != null and stats.xp_to_next_level > 0:
			xp_bar.max_value = stats.xp_to_next_level
			xp_bar.value = stats.current_xp
			xp_bar.visible = true
		else:
			xp_bar.visible = false
			
	# Attributes (Str/Agi/Int)
	if str_val_label != null:
		str_val_label.text = "GÜÇ %d" % int(stats.get_stat(StatModifier.TargetStat.STRENGTH)) if (is_hero and stats != null) else "GÜÇ --"
	if agi_val_label != null:
		agi_val_label.text = "ÇEV %d" % int(stats.get_stat(StatModifier.TargetStat.AGILITY)) if (is_hero and stats != null) else "ÇEV --"
	if int_val_label != null:
		int_val_label.text = "ZEK %d" % int(stats.get_stat(StatModifier.TargetStat.INTELLIGENCE)) if (is_hero and stats != null) else "ZEK --"
		
	# Combat stats (AD / Armor / MR / MS)
	if ad_val_label != null:
		ad_val_label.text = "SG %d" % int(stats.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)) if stats != null else "SG 0"
	if armor_val_label != null:
		armor_val_label.text = "ZR %.1f" % stats.get_stat(StatModifier.TargetStat.ARMOR) if stats != null else "ZR 0.0"
	if mr_val_label != null:
		mr_val_label.text = "BD %d%%" % int(stats.get_stat(StatModifier.TargetStat.MAGIC_RESIST)) if stats != null else "BD 0%"
	if ms_val_label != null:
		if stats != null:
			ms_val_label.text = "HH %d" % int(stats.get_stat(StatModifier.TargetStat.MOVE_SPEED))
		elif is_courier:
			var spd = int(display_unit.burst_flight_speed if display_unit.is_burst_active else display_unit.base_flight_speed) * 50
			ms_val_label.text = "HH %d" % spd
		else:
			ms_val_label.text = "HH 300"
			
	# Abilities rendering
	if is_hero:
		var ab_cont = display_unit.ability_container
		var has_pts = is_player_hero and ab_cont != null and (ab_cont.available_skill_points > 0)
		for s in [AbilityResource.Slot.Q, AbilityResource.Slot.W, AbilityResource.Slot.E, AbilityResource.Slot.R]:
			var ab: AbilityResource = ab_cont.abilities.get(s) if ab_cont != null else null
			var lvl = ab_cont.ability_levels.get(s, 0) if ab_cont != null else 0
			
			if ability_buttons.has(s):
				var btn: Button = ability_buttons[s]
				if ab != null:
					btn.tooltip_text = "%s (Seviye %d)\n%s" % [ab.ability_name, lvl, ab.description]
					var is_silenced = display_unit.effect_container != null and display_unit.effect_container.is_silenced()
					var is_no_mana = lvl > 0 and stats != null and stats.current_mana < ab.get_mana_cost(lvl)
					var on_cd = ab_cont != null and ab_cont.cooldown_timers.get(s, 0.0) > 0.0
					btn.disabled = (not is_player_hero) or (lvl <= 0) or on_cd or is_silenced or is_no_mana
				else:
					btn.tooltip_text = ""
					btn.disabled = true
					
			if ability_levelup_buttons.has(s):
				var lvl_btn: Button = ability_levelup_buttons[s]
				lvl_btn.visible = has_pts and ab != null and ab_cont.can_level_up_ability(s, true)
				
			if ability_cooldown_overlays.has(s):
				var overlay: ColorRect = ability_cooldown_overlays[s]
				var cd_lbl: Label = ability_cooldown_labels[s]
				var remaining_cd = ab_cont.cooldown_timers.get(s, 0.0) if ab_cont != null else 0.0
				var is_silenced = display_unit.effect_container != null and display_unit.effect_container.is_silenced()
				if remaining_cd > 0.0:
					overlay.visible = true
					cd_lbl.text = "%.1f" % remaining_cd
					overlay.color = Color(0.0, 0.0, 0.0, 0.78)
				elif is_silenced:
					overlay.visible = true
					cd_lbl.text = "SUSTUR"
					overlay.color = Color(0.35, 0.05, 0.35, 0.75)
				else:
					overlay.visible = false
					
			if ability_mana_labels.has(s):
				var m_lbl: Label = ability_mana_labels[s]
				if ab != null and lvl > 0:
					var cost = ab.get_mana_cost(lvl)
					m_lbl.text = "%d" % int(cost) if cost > 0 else ""
				else:
					m_lbl.text = ""
					
			if ability_pip_containers.has(s):
				var pips_box: HBoxContainer = ability_pip_containers[s]
				var children = pips_box.get_children()
				for idx in range(children.size()):
					var pip_rect = children[idx] as ColorRect
					if idx < lvl:
						pip_rect.color = Color(1.0, 0.85, 0.2)
					else:
						pip_rect.color = Color(0.2, 0.25, 0.3)
	elif is_courier:
		var courier_tips = ["Kurye Seç (F2)", "Eşyaları Kahramana Getir (F3)", "Hızlı Uçuş Modu (F4)", "Üsse Geri Dön"]
		var s_slots = [AbilityResource.Slot.Q, AbilityResource.Slot.W, AbilityResource.Slot.E, AbilityResource.Slot.R]
		for idx in range(4):
			var s = s_slots[idx]
			if ability_buttons.has(s):
				var btn: Button = ability_buttons[s]
				btn.tooltip_text = courier_tips[idx]
				btn.disabled = false
			if ability_levelup_buttons.has(s):
				ability_levelup_buttons[s].visible = false
			if ability_cooldown_overlays.has(s):
				var overlay: ColorRect = ability_cooldown_overlays[s]
				var cd_lbl: Label = ability_cooldown_labels[s]
				if idx == 2 and display_unit.burst_cooldown_remaining > 0.0:
					overlay.visible = true
					cd_lbl.text = "%.1f" % display_unit.burst_cooldown_remaining
				else:
					overlay.visible = false
			if ability_mana_labels.has(s):
				ability_mana_labels[s].text = ""
			if ability_pip_containers.has(s):
				for pip in ability_pip_containers[s].get_children():
					(pip as ColorRect).color = Color(0.2, 0.25, 0.3)
	else:
		# Creep / Tower / Boss: empty abilities
		for s in [AbilityResource.Slot.Q, AbilityResource.Slot.W, AbilityResource.Slot.E, AbilityResource.Slot.R]:
			if ability_buttons.has(s):
				ability_buttons[s].tooltip_text = "Yetenek Yok"
				ability_buttons[s].disabled = true
			if ability_levelup_buttons.has(s):
				ability_levelup_buttons[s].visible = false
			if ability_cooldown_overlays.has(s):
				ability_cooldown_overlays[s].visible = false
			if ability_mana_labels.has(s):
				ability_mana_labels[s].text = ""
			if ability_pip_containers.has(s):
				for pip in ability_pip_containers[s].get_children():
					(pip as ColorRect).color = Color(0.2, 0.25, 0.3)
					
	# Inventory rendering
	var inv_slots_source: Array = []
	var inv_manager_source: InventoryManager = null
	if is_hero and display_unit.inventory_manager != null:
		inv_manager_source = display_unit.inventory_manager
		inv_slots_source = display_unit.inventory_manager.slots
	elif is_courier:
		inv_slots_source = display_unit.courier_slots
		
	if gold_label != null and target_hero != null and target_hero.inventory_manager != null:
		gold_label.text = "%dg" % target_hero.inventory_manager.gold
		
	for i in range(6):
		var slot_item: ItemResource = (inv_slots_source[i] if i < inv_slots_source.size() else null)
		if inventory_slot_buttons.size() > i and inventory_slot_textures.size() > i:
			var btn = inventory_slot_buttons[i]
			if btn is InventoryDragSlotButton:
				(btn as InventoryDragSlotButton).has_item = slot_item != null
			var tex_rect = inventory_slot_textures[i]
			var cd_overlay = inventory_slot_cooldown_overlays[i]
			var cd_lbl = inventory_slot_cooldown_labels[i]
			var hk_lbl = inventory_slot_hotkey_labels[i]
			var target_lbl = inventory_slot_target_labels[i]
			var s_panel = btn.get_parent() as PanelContainer
			
			var tier_col = Color(0.20, 0.25, 0.32, 0.8)
			if slot_item != null:
				var icon_path = "res://assets/icons/items/item_%d.png" % slot_item.id
				if ResourceLoader.exists(icon_path):
					tex_rect.texture = load(icon_path)
					tex_rect.visible = true
				else:
					tex_rect.visible = false
					
				var cd = inv_manager_source.active_cooldowns.get(i, 0.0) if inv_manager_source != null else 0.0
				if cd > 0.0:
					cd_overlay.visible = true
					cd_lbl.text = "%.1f" % cd
				else:
					cd_overlay.visible = false
				var target_mode = inv_manager_source.get_active_item_target_mode(i) if inv_manager_source != null else "self"
				var target_short = _get_item_target_badge(target_mode)
				target_lbl.text = target_short
				target_lbl.visible = not target_short.is_empty()
					
				if slot_item.cost >= 5000:
					tier_col = Color(1.0, 0.82, 0.20)
				elif slot_item.cost >= 3800:
					tier_col = Color(0.80, 0.35, 0.95)
				elif slot_item.cost >= 2200:
					tier_col = Color(0.25, 0.65, 1.0)
				elif slot_item.cost >= 1000:
					tier_col = Color(0.25, 0.85, 0.45)
				else:
					tier_col = Color(0.5, 0.55, 0.65)
					
				var active_hint = ""
				if inv_manager_source != null and inv_manager_source.get_active_item_target_mode(i) != "self":
					active_hint = "\nAktif hedefi: %s" % _get_item_target_name(target_mode)
				btn.tooltip_text = "%s (💰%d)%s\nSağ tık: Kullan | Sürükle: Taşı | Shift + Sağ: Yere bırak" % [slot_item.item_name, slot_item.cost, active_hint]
				hk_lbl.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 0.95))
			else:
				tex_rect.visible = false
				cd_overlay.visible = false
				target_lbl.visible = false
				btn.tooltip_text = ("Boş Yuva [%d]" % (i + 1)) if (is_hero or is_courier) else "[Envanter Yok]"
				hk_lbl.add_theme_color_override("font_color", Color(0.45, 0.52, 0.62, 0.7))
				
			if s_panel != null:
				var p_style = StyleBoxFlat.new()
				p_style.bg_color = Color(0.06, 0.08, 0.12, 0.98)
				p_style.border_width_left = 1
				p_style.border_width_top = 1
				p_style.border_width_right = 1
				p_style.border_width_bottom = 1
				p_style.border_color = tier_col
				p_style.corner_radius_top_left = 4
				p_style.corner_radius_top_right = 4
				p_style.corner_radius_bottom_left = 4
				p_style.corner_radius_bottom_right = 4
				s_panel.add_theme_stylebox_override("panel", p_style)
				
	# Boots slot
	if boots_slot_button != null and boots_slot_texture != null:
		var b_panel = boots_slot_button.get_parent() as PanelContainer
		if is_hero and inv_manager_source != null and inv_manager_source.boots_slot != null:
			var boot_icon_path = "res://assets/icons/items/item_%d.png" % inv_manager_source.boots_slot.id
			if ResourceLoader.exists(boot_icon_path):
				boots_slot_texture.texture = load(boot_icon_path)
				boots_slot_texture.visible = true
			else:
				boots_slot_texture.visible = false
			boots_slot_button.tooltip_text = "%s (💰%d)" % [inv_manager_source.boots_slot.item_name, inv_manager_source.boots_slot.cost]
		else:
			boots_slot_texture.visible = false
			boots_slot_button.tooltip_text = "Çizme Yuvası (Boş)" if is_hero else "[Çizme Yuvası Yok]"
		if b_panel != null:
			var b_style = StyleBoxFlat.new()
			b_style.bg_color = Color(0.06, 0.08, 0.12, 0.98)
			b_style.border_width_left = 1
			b_style.border_width_top = 1
			b_style.border_width_right = 1
			b_style.border_width_bottom = 1
			b_style.border_color = Color(0.85, 0.70, 0.25) if (is_hero and inv_manager_source != null and inv_manager_source.boots_slot != null) else Color(0.25, 0.32, 0.42, 1.0)
			b_style.corner_radius_top_left = 4
			b_style.corner_radius_top_right = 4
			b_style.corner_radius_bottom_left = 4
			b_style.corner_radius_bottom_right = 4
			b_panel.add_theme_stylebox_override("panel", b_style)
				
	if stats_popup != null and stats_popup.visible:
		stats_popup.update_stats(target_hero)

func _on_ability_button_clicked(slot: AbilityResource.Slot) -> void:
	if target_hero != null and target_hero.ability_container != null:
		var controller = target_hero.get_node_or_null("HeroController3D") as HeroController3D
		if controller != null:
			controller._cast_spell(slot)

func _on_levelup_clicked(slot: AbilityResource.Slot) -> void:
	if target_hero != null and target_hero.ability_container != null:
		target_hero.ability_container.level_up_ability(slot, true)

func _on_ability_button_hover(slot: AbilityResource.Slot, is_hovered: bool, btn_control: Control = null) -> void:
	if target_hero != null and target_hero.ability_container != null:
		if is_hovered:
			var ab = target_hero.ability_container.get_ability(slot)
			if ab != null:
				var lvl = max(1, target_hero.ability_container.ability_levels.get(slot, 1))
				var r: float = 0.0
				if ab.has_method("get_cast_range"):
					r = ab.get_cast_range(lvl)
				elif "cast_range" in ab:
					r = ab.cast_range / 100.0 if ab.cast_range > 50.0 else ab.cast_range
				var color = Color(0.25, 0.85, 1.0, 0.55) if slot != AbilityResource.Slot.R else Color(1.0, 0.3, 0.65, 0.6)
				if target_hero.has_method("preview_skill_range"):
					target_hero.preview_skill_range(r, color)
				
				if ability_tooltip != null:
					var slot_key = "Q"
					match slot:
						AbilityResource.Slot.Q: slot_key = "Q"
						AbilityResource.Slot.W: slot_key = "W"
						AbilityResource.Slot.E: slot_key = "E"
						AbilityResource.Slot.R: slot_key = "R"
						AbilityResource.Slot.PASSIVE: slot_key = "DOĞUŞTAN"
					ability_tooltip.show_ability(ab, lvl, slot_key)
					if btn_control != null and is_instance_valid(btn_control):
						var g_pos = btn_control.global_position
						var tooltip_h = maxf(ability_tooltip.size.y, 340.0)
						ability_tooltip.global_position = Vector2(clampf(g_pos.x - 130, 200, 1500), g_pos.y - tooltip_h - 14)
		else:
			if target_hero.has_method("preview_skill_range"):
				target_hero.preview_skill_range(0.0)
			if ability_tooltip != null:
				ability_tooltip.hide_tooltip()

func _on_talent_hover(is_hovered: bool, btn_control: Control = null) -> void:
	if ability_tooltip != null:
		if is_hovered:
			ability_tooltip.show_talent_tree_tooltip()
			if btn_control != null and is_instance_valid(btn_control):
				var g_pos = btn_control.global_position
				var tooltip_h = maxf(ability_tooltip.size.y, 340.0)
				ability_tooltip.global_position = Vector2(clampf(g_pos.x - 130, 200, 1500), g_pos.y - tooltip_h - 14)
		else:
			ability_tooltip.hide_tooltip()

func _on_inventory_slot_gui_input(event: InputEvent, slot_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if Input.is_key_pressed(KEY_SHIFT):
				# Shift + Right Click: Drop item from slot into 3D world
				if target_hero != null and target_hero.inventory_manager != null:
					target_hero.inventory_manager.drop_item_to_world(slot_idx)
			elif shop_ui != null and shop_ui.visible and target_hero != null and target_hero.inventory_manager != null:
				var refund_val = target_hero.inventory_manager.get_item_refund_value(slot_idx)
				var is_full = target_hero.inventory_manager.is_item_in_full_refund_window(slot_idx)
				var sold_item = target_hero.inventory_manager.slots[slot_idx]
				if sold_item != null:
					target_hero.inventory_manager.sell_item(slot_idx)
					if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
						var txt = "EŞYA SATILDI: %s (+%d Altın %s)" % [sold_item.item_name.to_upper(), refund_val, "%100 İade" if is_full else "%50 İade"]
						GameEvents.combat_log_generated.emit(txt)
			else:
				# Normal Right Click: Use active item
				_request_active_item(slot_idx)
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if is_alt_down and target_hero != null and target_hero.inventory_manager != null:
				var it = target_hero.inventory_manager.slots[slot_idx]
				if shop_ui != null:
					if not shop_ui.visible:
						_toggle_shop()
					if it != null:
						shop_ui.select_item(it)

func _request_active_item(slot_idx: int) -> void:
	if target_hero == null or target_hero.inventory_manager == null:
		return
	var controller = target_hero.find_child("HeroController3D", true, false)
	if controller != null and controller.has_method("_use_item_slot"):
		controller._use_item_slot(slot_idx)
	else:
		target_hero.inventory_manager.use_active_item(slot_idx)

func _on_inventory_item_dropped(from_slot: int, to_slot: int) -> void:
	if target_hero == null or target_hero.inventory_manager == null:
		return
	if target_hero.inventory_manager.swap_slots(from_slot, to_slot):
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("ENVANTER DÜZENLENDİ: Yuva %d <-> Yuva %d" % [from_slot + 1, to_slot + 1])

func _on_inventory_drag_ended(slot_idx: int, was_accepted: bool) -> void:
	if was_accepted or target_hero == null or target_hero.inventory_manager == null:
		return
	if slot_idx < 0 or slot_idx >= target_hero.inventory_manager.slots.size():
		return
	var item = target_hero.inventory_manager.slots[slot_idx]
	if item == null:
		return
	var drop_position = _screen_to_world_drop_position(get_viewport().get_mouse_position())
	if drop_position == Vector3.ZERO:
		return
	pending_world_drop_item = item
	pending_world_drop_position = drop_position
	target_hero.move_to_location(drop_position)
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("EŞYA BIRAKMA EMRİ: %s" % item.item_name.to_upper())

func _screen_to_world_drop_position(screen_position: Vector2) -> Vector3:
	var active_camera = camera if camera != null else get_viewport().get_camera_3d()
	if active_camera == null or target_hero == null:
		return Vector3.ZERO
	var ray_origin = active_camera.project_ray_origin(screen_position)
	var ray_direction = active_camera.project_ray_normal(screen_position)
	if absf(ray_direction.y) < 0.0001:
		return Vector3.ZERO
	var hero_pos = target_hero.global_position if target_hero.is_inside_tree() else target_hero.position
	var distance_to_ground = (hero_pos.y - ray_origin.y) / ray_direction.y
	if distance_to_ground < 0.0:
		return Vector3.ZERO
	return ray_origin + (ray_direction * distance_to_ground)

func _update_pending_world_drop() -> void:
	if pending_world_drop_item == null:
		return
	if target_hero == null or not target_hero.is_alive() or target_hero.inventory_manager == null:
		pending_world_drop_item = null
		return
	var hero_pos = target_hero.global_position if target_hero.is_inside_tree() else target_hero.position
	if hero_pos.distance_to(pending_world_drop_position) > 1.5:
		return
	for slot_idx in range(target_hero.inventory_manager.slots.size()):
		if target_hero.inventory_manager.slots[slot_idx] == pending_world_drop_item:
			target_hero.inventory_manager.drop_item_to_world(slot_idx, pending_world_drop_position)
			break
	pending_world_drop_item = null

func _on_inventory_slot_clicked(_slot_idx: int) -> void:
	if target_hero != null and target_hero.inventory_manager != null:
		_toggle_shop()

func _on_world_item_selected(pickup: Node) -> void:
	if not is_instance_valid(pickup) or not (pickup is ItemPickup3D):
		return
	var world_item = pickup as ItemPickup3D
	if world_item.item_data == null or hud_item_tooltip == null:
		return
	hud_item_tooltip.show_item(world_item.item_data)
	var mouse_position = get_viewport().get_mouse_position() + Vector2(18, 18)
	hud_item_tooltip.global_position = Vector2(clampf(mouse_position.x, 20, 1600), clampf(mouse_position.y, 20, 900))

func _get_item_target_badge(mode: String) -> String:
	match mode:
		"enemy": return "DÜŞ"
		"ally": return "DOST"
		"unit": return "BİRİM"
		"ground": return "ZEMİN"
		_: return ""

func _get_item_target_name(mode: String) -> String:
	match mode:
		"enemy": return "Düşman"
		"ally": return "Dost"
		"unit": return "Herhangi bir birim"
		"ground": return "Zemin"
		_: return "Kendin"

func _on_item_slot_hover(slot_idx: int, is_hovered: bool, btn_control: Control = null) -> void:
	if target_hero != null and target_hero.inventory_manager != null:
		if is_hovered:
			if slot_idx < target_hero.inventory_manager.slots.size():
				var it = target_hero.inventory_manager.slots[slot_idx]
				if it != null and hud_item_tooltip != null:
					var cd = target_hero.inventory_manager.active_cooldowns.get(slot_idx, 0.0)
					hud_item_tooltip.show_item(it, str(slot_idx + 1), cd)
					if btn_control != null and is_instance_valid(btn_control):
						var g_pos = btn_control.global_position
						var tt_h = hud_item_tooltip.size.y if hud_item_tooltip.size.y > 0 else 120.0
						hud_item_tooltip.global_position = Vector2(clampf(g_pos.x - 40, 20, 1600), clampf(g_pos.y - tt_h - 10, 20, 950))
				if target_hero.has_method("preview_skill_range"):
					target_hero.preview_skill_range(6.0, Color(0.9, 0.75, 0.25, 0.5))
		else:
			if hud_item_tooltip != null:
				hud_item_tooltip.hide_tooltip()
			if target_hero.has_method("preview_skill_range"):
				target_hero.preview_skill_range(0.0)

func _on_boots_slot_hover(is_hovered: bool, btn_control: Control = null) -> void:
	if target_hero != null and target_hero.inventory_manager != null:
		if is_hovered:
			var it = target_hero.inventory_manager.boots_slot
			if it != null and hud_item_tooltip != null:
				hud_item_tooltip.show_item(it)
				if btn_control != null and is_instance_valid(btn_control):
					var g_pos = btn_control.global_position
					var tt_h = hud_item_tooltip.size.y if hud_item_tooltip.size.y > 0 else 120.0
					hud_item_tooltip.global_position = Vector2(clampf(g_pos.x - 40, 20, 1600), clampf(g_pos.y - tt_h - 10, 20, 950))
		else:
			if hud_item_tooltip != null:
				hud_item_tooltip.hide_tooltip()

func _on_boots_slot_clicked() -> void:
	if shop_ui != null:
		if not shop_ui.visible:
			_toggle_shop()
		if target_hero != null and target_hero.inventory_manager != null and target_hero.inventory_manager.boots_slot != null:
			shop_ui.select_item(target_hero.inventory_manager.boots_slot)

func _setup_respawn_overlay(parent: Control) -> void:
	respawn_overlay = PanelContainer.new()
	respawn_overlay.set_anchors_preset(Control.PRESET_CENTER)
	respawn_overlay.custom_minimum_size = Vector2(300, 60)
	respawn_overlay.offset_left = -150
	respawn_overlay.offset_right = 150
	respawn_overlay.offset_top = -180
	respawn_overlay.offset_bottom = -120
	respawn_overlay.visible = false
	
	var r_style = StyleBoxFlat.new()
	r_style.bg_color = Color(0.1, 0.05, 0.05, 0.9)
	r_style.border_width_left = 2
	r_style.border_width_top = 2
	r_style.border_width_right = 2
	r_style.border_width_bottom = 2
	r_style.border_color = Color(0.9, 0.2, 0.2)
	respawn_overlay.add_theme_stylebox_override("panel", r_style)
	parent.add_child(respawn_overlay)
	
	respawn_timer_label = Label.new()
	respawn_timer_label.text = "YENİDEN DOĞUŞ: 5.0s"
	respawn_timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	respawn_timer_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	respawn_timer_label.add_theme_font_size_override("font_size", 16)
	respawn_timer_label.add_theme_color_override("font_color", Color(1, 0.4, 0.4))
	respawn_overlay.add_child(respawn_timer_label)

func _setup_match_result_modal(parent: Control) -> void:
	match_result_ui = MatchResultUI.new()
	parent.add_child(match_result_ui)
	match_result_ui.play_again_requested.connect(func(): play_again_clicked.emit())
	match_result_ui.main_menu_requested.connect(func(): main_menu_clicked.emit())
