class_name DotaHUD
extends CanvasLayer

## Authentic Dota 2 Style Game Dashboard & Combat Interface (hud.png reference)
## Features Centered Health/Mana Bars, 2x3 Inventory, Hero Portrait, Attributes & Top Match Clock

signal play_again_clicked()
signal main_menu_clicked()

@export var target_hero: HeroEntity = null:
	set(val):
		if target_hero == val:
			return
		target_hero = val
		if is_inside_tree() and shop_ui != null and val != null:
			shop_ui.bind_hero(val)

@export var camera: MobaCamera3D = null
@export var match_manager: MatchManager = null

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

var heat_container: Control = null
var heat_bar: ProgressBar = null
var heat_text_label: Label = null

# Inventory & Gold
var inventory_slot_buttons: Array[Button] = []
var inventory_slot_textures: Array[TextureRect] = []
var inventory_slot_cooldown_overlays: Array[ColorRect] = []
var inventory_slot_cooldown_labels: Array[Label] = []
var inventory_slot_hotkey_labels: Array[Label] = []
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

func _ready() -> void:
	layer = 10
	_build_dota_interface()
	
	if target_hero != null:
		_bind_hero(target_hero)
		
	if match_manager != null:
		_bind_match_manager(match_manager)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_ALT:
			is_alt_down = event.pressed
			_set_alt_info_mode(is_alt_down)
		elif event.pressed and not event.echo:
			if event.keycode == KEY_B or event.keycode == KEY_P:
				_toggle_shop()
			elif event.keycode == KEY_ESCAPE:
				if shop_ui != null and shop_ui.shop_panel.visible:
					shop_ui.shop_panel.visible = false

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
	if overhead_health_bar_manager != null and camera != null:
		overhead_health_bar_manager.camera = camera

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
	
	_build_top_bar(root)
	_build_bottom_dashboard(root)
	_build_minimap(root)
	_build_gold_and_shop_trigger(root)
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
	stats_popup.offset_left = 500
	stats_popup.offset_top = -560
	stats_popup.offset_right = 840
	stats_popup.offset_bottom = -190
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

# ==============================================================================
# 1. TOP MATCH BAR & SCOREBOARD (Radiant Kills vs Dire Kills & Day/Night Clock)
# ==============================================================================
func _build_top_bar(parent: Control) -> void:
	var top_panel = PanelContainer.new()
	top_panel.set_anchors_preset(Control.PRESET_TOP_WIDE)
	top_panel.offset_left = 440
	top_panel.offset_right = -440
	top_panel.offset_top = 0
	top_panel.offset_bottom = 46
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.04, 0.05, 0.08, 0.96)
	style.border_width_bottom = 2
	style.border_width_left = 1
	style.border_width_right = 1
	style.border_color = Color(0.68, 0.54, 0.22, 0.9)
	style.corner_radius_bottom_left = 12
	style.corner_radius_bottom_right = 12
	style.shadow_size = 8
	style.shadow_color = Color(0.0, 0.0, 0.0, 0.6)
	style.content_margin_left = 18
	style.content_margin_right = 18
	top_panel.add_theme_stylebox_override("panel", style)
	parent.add_child(top_panel)
	
	var hbox = HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 24)
	top_panel.add_child(hbox)
	
	# Radiant Score with Crest
	var rad_box = HBoxContainer.new()
	rad_box.add_theme_constant_override("separation", 8)
	hbox.add_child(rad_box)
	
	var rad_tag = Label.new()
	rad_tag.text = "RADIANT"
	rad_tag.add_theme_font_size_override("font_size", 12)
	rad_tag.add_theme_color_override("font_color", Color(0.4, 0.85, 0.5))
	rad_box.add_child(rad_tag)
	
	radiant_score_label = Label.new()
	radiant_score_label.text = "0"
	radiant_score_label.add_theme_font_size_override("font_size", 18)
	radiant_score_label.add_theme_color_override("font_color", Color(0.3, 1.0, 0.45))
	rad_box.add_child(radiant_score_label)
	
	# Match Clock Medallion
	var clock_panel = PanelContainer.new()
	clock_panel.custom_minimum_size = Vector2(76, 28)
	var clk_s = StyleBoxFlat.new()
	clk_s.bg_color = Color(0.08, 0.10, 0.14, 0.95)
	clk_s.border_width_left = 1
	clk_s.border_width_right = 1
	clk_s.border_width_top = 1
	clk_s.border_width_bottom = 1
	clk_s.border_color = Color(0.68, 0.54, 0.22, 0.8)
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
	match_timer_label.add_theme_font_size_override("font_size", 14)
	match_timer_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.25))
	clock_panel.add_child(match_timer_label)
	
	# Dire Score with Crest
	var dire_box = HBoxContainer.new()
	dire_box.add_theme_constant_override("separation", 8)
	hbox.add_child(dire_box)
	
	dire_score_label = Label.new()
	dire_score_label.text = "0"
	dire_score_label.add_theme_font_size_override("font_size", 18)
	dire_score_label.add_theme_color_override("font_color", Color(1.0, 0.35, 0.35))
	dire_box.add_child(dire_score_label)
	
	var dire_tag = Label.new()
	dire_tag.text = "DIRE"
	dire_tag.add_theme_font_size_override("font_size", 12)
	dire_tag.add_theme_color_override("font_color", Color(0.95, 0.45, 0.45))
	dire_box.add_child(dire_tag)
	
	# Top Left: KDA scoreboard
	var kda_box = PanelContainer.new()
	kda_box.set_anchors_preset(Control.PRESET_TOP_LEFT)
	kda_box.offset_left = 12
	kda_box.offset_top = 10
	kda_box.offset_right = 165
	kda_box.offset_bottom = 44
	
	var kda_style = StyleBoxFlat.new()
	kda_style.bg_color = Color(0.04, 0.05, 0.08, 0.95)
	kda_style.border_width_bottom = 2
	kda_style.border_width_right = 2
	kda_style.border_color = Color(0.68, 0.54, 0.22, 0.7)
	kda_style.corner_radius_bottom_right = 8
	kda_style.corner_radius_top_right = 8
	kda_box.add_theme_stylebox_override("panel", kda_style)
	parent.add_child(kda_box)
	
	kill_death_label = Label.new()
	kill_death_label.text = "K: 0  D: 0  A: 0"
	kill_death_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	kill_death_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	kill_death_label.add_theme_font_size_override("font_size", 12)
	kill_death_label.add_theme_color_override("font_color", Color(0.92, 0.94, 0.98))
	kda_box.add_child(kill_death_label)

# ==============================================================================
# 2. DOTA 2 BOTTOM DASHBOARD CONSOLE (hud.png layout)
# ==============================================================================
func _build_bottom_dashboard(parent: Control) -> void:
	var dashboard = PanelContainer.new()
	dashboard.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	dashboard.offset_left = 280
	dashboard.offset_right = -230
	dashboard.offset_bottom = 0
	dashboard.offset_top = -180
	
	var dash_style = StyleBoxFlat.new()
	dash_style.bg_color = Color(0.04, 0.05, 0.07, 0.97)
	dash_style.border_width_top = 3
	dash_style.border_color = Color(0.68, 0.54, 0.22, 0.95)
	dash_style.corner_radius_top_left = 12
	dash_style.corner_radius_top_right = 12
	dash_style.shadow_size = 12
	dash_style.shadow_color = Color(0.0, 0.0, 0.0, 0.75)
	dash_style.content_margin_left = 14
	dash_style.content_margin_right = 14
	dash_style.content_margin_top = 8
	dash_style.content_margin_bottom = 8
	dashboard.add_theme_stylebox_override("panel", dash_style)
	parent.add_child(dashboard)
	
	var main_h = HBoxContainer.new()
	main_h.add_theme_constant_override("separation", 16)
	main_h.alignment = BoxContainer.ALIGNMENT_CENTER
	dashboard.add_child(main_h)
	
	_build_hero_portrait_and_stats(main_h)
	_build_abilities_and_centered_bars(main_h)
	_build_inventory_box(main_h)

# --- Hero Portrait & Stats Block (Left of Dashboard) ---
func _build_hero_portrait_and_stats(parent: Control) -> void:
	var h_block = HBoxContainer.new()
	h_block.add_theme_constant_override("separation", 10)
	parent.add_child(h_block)
	
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
	p_container.custom_minimum_size = Vector2(88, 102)
	var p_style = StyleBoxFlat.new()
	p_style.bg_color = Color(0.12, 0.14, 0.18, 1.0)
	p_style.border_width_left = 2
	p_style.border_width_top = 2
	p_style.border_width_right = 2
	p_style.border_width_bottom = 2
	p_style.border_color = Color(0.35, 0.40, 0.50, 1.0)
	p_container.add_theme_stylebox_override("panel", p_style)
	p_vbox.add_child(p_container)
	
	portrait_rect = ColorRect.new()
	portrait_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	portrait_rect.color = Color(0.2, 0.30, 0.48, 1.0)
	p_container.add_child(portrait_rect)
	
	# Circular Level badge in bottom-left corner of portrait (info.png reference)
	var lvl_panel = PanelContainer.new()
	lvl_panel.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	lvl_panel.offset_left = -6
	lvl_panel.offset_bottom = 6
	lvl_panel.custom_minimum_size = Vector2(26, 26)
	var lvl_s = StyleBoxFlat.new()
	lvl_s.bg_color = Color(0.08, 0.1, 0.14, 0.98)
	lvl_s.border_width_left = 2
	lvl_s.border_width_top = 2
	lvl_s.border_width_right = 2
	lvl_s.border_width_bottom = 2
	lvl_s.border_color = Color(1.0, 0.75, 0.2)
	lvl_s.corner_radius_bottom_left = 13
	lvl_s.corner_radius_bottom_right = 13
	lvl_s.corner_radius_top_left = 13
	lvl_s.corner_radius_top_right = 13
	lvl_panel.add_theme_stylebox_override("panel", lvl_s)
	p_container.add_child(lvl_panel)
	
	hero_level_label = Label.new()
	hero_level_label.text = "1"
	hero_level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hero_level_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hero_level_label.add_theme_font_size_override("font_size", 12)
	hero_level_label.add_theme_color_override("font_color", Color(1, 0.88, 0.3))
	lvl_panel.add_child(hero_level_label)
	
	# Attributes & Combat Stats
	var stats_vbox = VBoxContainer.new()
	stats_vbox.custom_minimum_size = Vector2(115, 0)
	stats_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	stats_vbox.add_theme_constant_override("separation", 3)
	h_block.add_child(stats_vbox)
	
	# Combat stats grid (Damage, Attack Speed, Armor, Magic Resist, Move Speed)
	var grid = GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 2)
	stats_vbox.add_child(grid)
	
	ad_val_label = _create_grid_stat(grid, "⚔", "58")
	_create_grid_stat(grid, "🖐", "132")
	armor_val_label = _create_grid_stat(grid, "🛡", "4.0")
	mr_val_label = _create_grid_stat(grid, "🔘", "26%")
	ms_val_label = _create_grid_stat(grid, "👟", "310")
	
	# Attributes row: STR (Red), AGI (Green), INT (Blue)
	var attr_hbox = HBoxContainer.new()
	attr_hbox.add_theme_constant_override("separation", 5)
	stats_vbox.add_child(attr_hbox)
	
	str_val_label = _create_stat_badge(attr_hbox, "🔴", "19", Color(0.95, 0.3, 0.25))
	agi_val_label = _create_stat_badge(attr_hbox, "🟢", "22", Color(0.25, 0.88, 0.35))
	int_val_label = _create_stat_badge(attr_hbox, "🔵", "15", Color(0.3, 0.65, 1.0))
	
	# Mouse Hover Triggers for Stats Popup (stats.png)
	p_container.mouse_filter = Control.MOUSE_FILTER_PASS
	p_container.mouse_entered.connect(func(): _set_stats_popup_visible(true))
	p_container.mouse_exited.connect(func(): if not is_alt_down: _set_stats_popup_visible(false))
	
	stats_vbox.mouse_filter = Control.MOUSE_FILTER_PASS
	stats_vbox.mouse_entered.connect(func(): _set_stats_popup_visible(true))
	stats_vbox.mouse_exited.connect(func(): if not is_alt_down: _set_stats_popup_visible(false))

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

# --- Abilities & Centered Health / Mana Bars (Center of Dashboard) ---
func _build_abilities_and_centered_bars(parent: Control) -> void:
	var v_center = VBoxContainer.new()
	v_center.custom_minimum_size = Vector2(490, 0)
	v_center.alignment = BoxContainer.ALIGNMENT_CENTER
	v_center.add_theme_constant_override("separation", 6)
	parent.add_child(v_center)
	
	# Top Abilities Row (Talent Tree + Facet + Abilities + Shard/Scepter)
	var top_row = HBoxContainer.new()
	top_row.alignment = BoxContainer.ALIGNMENT_CENTER
	top_row.add_theme_constant_override("separation", 8)
	v_center.add_child(top_row)
	
	# 1. Talent Tree Emblem (info.png reference)
	var talent_btn = Button.new()
	talent_btn.text = "🌳"
	talent_btn.custom_minimum_size = Vector2(36, 48)
	talent_btn.add_theme_font_size_override("font_size", 14)
	talent_btn.mouse_entered.connect(func(): _on_talent_hover(true, talent_btn))
	talent_btn.mouse_exited.connect(func(): _on_talent_hover(false))
	top_row.add_child(talent_btn)
	
	# 2. Innate / Facet Passive Icon
	var facet_btn = Button.new()
	facet_btn.text = "💧"
	facet_btn.custom_minimum_size = Vector2(28, 48)
	facet_btn.add_theme_font_size_override("font_size", 12)
	facet_btn.mouse_entered.connect(func(): _on_ability_button_hover(AbilityResource.Slot.PASSIVE, true, facet_btn))
	facet_btn.mouse_exited.connect(func(): _on_ability_button_hover(AbilityResource.Slot.PASSIVE, false))
	top_row.add_child(facet_btn)
	
	var slots = [
		{"slot": AbilityResource.Slot.Q, "key": "Q", "name": "Q", "pips": 4},
		{"slot": AbilityResource.Slot.W, "key": "W", "name": "W", "pips": 4},
		{"slot": AbilityResource.Slot.E, "key": "E", "name": "E", "pips": 4},
		{"slot": AbilityResource.Slot.PASSIVE, "key": "D", "name": "D", "pips": 1},
		{"slot": AbilityResource.Slot.R, "key": "R", "name": "R", "pips": 3}
	]
	
	for s_info in slots:
		var slot_vbox = VBoxContainer.new()
		slot_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		slot_vbox.add_theme_constant_override("separation", 2)
		top_row.add_child(slot_vbox)
		
		# [+] Level Up Button (Golden Arrow)
		var lvl_btn = Button.new()
		lvl_btn.text = "▲"
		lvl_btn.custom_minimum_size = Vector2(56, 18)
		lvl_btn.visible = false
		lvl_btn.add_theme_font_size_override("font_size", 11)
		var lvl_style = StyleBoxFlat.new()
		lvl_style.bg_color = Color(0.85, 0.68, 0.15, 0.95)
		lvl_style.corner_radius_top_left = 4
		lvl_style.corner_radius_top_right = 4
		lvl_style.corner_radius_bottom_left = 4
		lvl_style.corner_radius_bottom_right = 4
		lvl_btn.add_theme_stylebox_override("normal", lvl_style)
		lvl_btn.add_theme_color_override("font_color", Color(0.05, 0.05, 0.05))
		lvl_btn.pressed.connect(func(): _on_levelup_clicked(s_info.slot))
		slot_vbox.add_child(lvl_btn)
		ability_levelup_buttons[s_info.slot] = lvl_btn
		
		# Ability Icon Box with Engraved Beveled Frame
		var btn_container = PanelContainer.new()
		btn_container.custom_minimum_size = Vector2(56, 56)
		var b_box_style = StyleBoxFlat.new()
		b_box_style.bg_color = Color(0.08, 0.10, 0.15, 1.0)
		b_box_style.border_width_left = 2
		b_box_style.border_width_top = 2
		b_box_style.border_width_right = 2
		b_box_style.border_width_bottom = 2
		b_box_style.border_color = Color(0.35, 0.42, 0.55, 1.0)
		b_box_style.corner_radius_top_left = 6
		b_box_style.corner_radius_top_right = 6
		b_box_style.corner_radius_bottom_left = 6
		b_box_style.corner_radius_bottom_right = 6
		btn_container.add_theme_stylebox_override("panel", b_box_style)
		slot_vbox.add_child(btn_container)
		
		var ab_btn = Button.new()
		ab_btn.text = s_info.key
		ab_btn.set_anchors_preset(Control.PRESET_FULL_RECT)
		ab_btn.add_theme_font_size_override("font_size", 14)
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
		cd_lbl.add_theme_font_size_override("font_size", 14)
		cd_overlay.add_child(cd_lbl)
		ability_cooldown_labels[s_info.slot] = cd_lbl
		
		# Mana Cost label (Cyan Pill Chip)
		var mana_lbl = Label.new()
		mana_lbl.text = ""
		mana_lbl.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
		mana_lbl.offset_left = -28
		mana_lbl.offset_top = -16
		mana_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		mana_lbl.add_theme_font_size_override("font_size", 10)
		mana_lbl.add_theme_color_override("font_color", Color(0.4, 0.85, 1.0))
		btn_container.add_child(mana_lbl)
		ability_mana_labels[s_info.slot] = mana_lbl
		
		# Level pips
		var pip_hbox = HBoxContainer.new()
		pip_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
		pip_hbox.add_theme_constant_override("separation", 3)
		slot_vbox.add_child(pip_hbox)
		
		for p in range(s_info.pips):
			var pip = ColorRect.new()
			pip.custom_minimum_size = Vector2(8, 4)
			pip.color = Color(0.2, 0.24, 0.28)
			pip_hbox.add_child(pip)
			
		ability_pip_containers[s_info.slot] = pip_hbox
		
	_build_status_bars(v_center)

# --- Health & Mana Bars (Spans whole center width directly under abilities) ---
func _build_status_bars(parent: Control) -> void:
	# 0. Passives & Buffs / Debuffs Status Row (not.png reference)
	status_effect_bar = DotaStatusEffectBar.new()
	status_effect_bar.target_hero = target_hero
	parent.add_child(status_effect_bar)
	buffs_container = status_effect_bar

	# 1. Health Bar (Dota Green #549e29 with Centered HP and Right-aligned Regen)
	var hp_box = PanelContainer.new()
	hp_box.custom_minimum_size = Vector2(500, 24)
	var hp_box_style = StyleBoxFlat.new()
	hp_box_style.bg_color = Color(0.06, 0.08, 0.10, 1.0)
	hp_box_style.border_width_left = 1
	hp_box_style.border_width_top = 1
	hp_box_style.border_width_right = 1
	hp_box_style.border_width_bottom = 1
	hp_box_style.border_color = Color(0.25, 0.32, 0.40, 1.0)
	hp_box_style.corner_radius_top_left = 4
	hp_box_style.corner_radius_top_right = 4
	hp_box.add_theme_stylebox_override("panel", hp_box_style)
	parent.add_child(hp_box)
	
	hp_bar = ProgressBar.new()
	hp_bar.set_anchors_preset(Control.PRESET_FULL_RECT)
	hp_bar.show_percentage = false
	var hp_fill = StyleBoxFlat.new()
	hp_fill.bg_color = Color(0.22, 0.68, 0.28, 1.0)
	hp_fill.corner_radius_top_left = 3
	hp_fill.corner_radius_top_right = 3
	hp_bar.add_theme_stylebox_override("fill", hp_fill)
	hp_box.add_child(hp_bar)
	
	hp_text_label = Label.new()
	hp_text_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	hp_text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hp_text_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hp_text_label.add_theme_font_size_override("font_size", 12)
	hp_text_label.text = "538 / 538"
	hp_box.add_child(hp_text_label)
	
	hp_regen_label = Label.new()
	hp_regen_label.set_anchors_preset(Control.PRESET_RIGHT_WIDE)
	hp_regen_label.offset_right = -10
	hp_regen_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	hp_regen_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hp_regen_label.add_theme_font_size_override("font_size", 11)
	hp_regen_label.add_theme_color_override("font_color", Color(0.55, 0.95, 0.45))
	hp_regen_label.text = "+2.9"
	hp_box.add_child(hp_regen_label)
	
	# 2. Mana Bar (Dota Blue #3d6ee8 with Centered MP and Right-aligned Regen)
	var mp_box = PanelContainer.new()
	mp_box.custom_minimum_size = Vector2(500, 18)
	var mp_box_style = StyleBoxFlat.new()
	mp_box_style.bg_color = Color(0.05, 0.07, 0.10, 1.0)
	mp_box_style.border_width_left = 1
	mp_box_style.border_width_bottom = 1
	mp_box_style.border_width_right = 1
	mp_box_style.border_color = Color(0.20, 0.28, 0.38, 1.0)
	mp_box_style.corner_radius_bottom_left = 4
	mp_box_style.corner_radius_bottom_right = 4
	mp_box.add_theme_stylebox_override("panel", mp_box_style)
	parent.add_child(mp_box)
	
	mp_bar = ProgressBar.new()
	mp_bar.set_anchors_preset(Control.PRESET_FULL_RECT)
	mp_bar.show_percentage = false
	var mp_fill = StyleBoxFlat.new()
	mp_fill.bg_color = Color(0.18, 0.44, 0.90, 1.0)
	mp_fill.corner_radius_bottom_left = 3
	mp_fill.corner_radius_bottom_right = 3
	mp_bar.add_theme_stylebox_override("fill", mp_fill)
	mp_box.add_child(mp_bar)
	
	mp_text_label = Label.new()
	mp_text_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	mp_text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	mp_text_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	mp_text_label.add_theme_font_size_override("font_size", 11)
	mp_text_label.text = "255 / 255"
	mp_box.add_child(mp_text_label)
	
	mp_regen_label = Label.new()
	mp_regen_label.set_anchors_preset(Control.PRESET_RIGHT_WIDE)
	mp_regen_label.offset_right = -10
	mp_regen_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	mp_regen_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	mp_regen_label.add_theme_font_size_override("font_size", 10)
	mp_regen_label.add_theme_color_override("font_color", Color(0.45, 0.80, 1.0))
	mp_regen_label.text = "+1.5"
	mp_box.add_child(mp_regen_label)
	
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

# --- 2x3 Inventory Grid & Specialized Slots (Right of Dashboard - info.png) ---
func _build_inventory_box(parent: Control) -> void:
	var h_inv = HBoxContainer.new()
	h_inv.alignment = BoxContainer.ALIGNMENT_CENTER
	h_inv.add_theme_constant_override("separation", 6)
	parent.add_child(h_inv)
	
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
	
	var hotkeys = ["1", "2", "3", "4", "5", "6"]
	for i in range(6):
		var slot_container = PanelContainer.new()
		slot_container.custom_minimum_size = Vector2(46, 44)
		var s_style = StyleBoxFlat.new()
		s_style.bg_color = Color(0.06, 0.08, 0.12, 0.98)
		s_style.border_width_left = 1
		s_style.border_width_top = 1
		s_style.border_width_right = 1
		s_style.border_width_bottom = 1
		s_style.border_color = Color(0.25, 0.32, 0.42, 1.0)
		s_style.corner_radius_top_left = 4
		s_style.corner_radius_top_right = 4
		s_style.corner_radius_bottom_left = 4
		s_style.corner_radius_bottom_right = 4
		slot_container.add_theme_stylebox_override("panel", s_style)
		grid.add_child(slot_container)
		
		var tex_rect = TextureRect.new()
		tex_rect.custom_minimum_size = Vector2(34, 34)
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
		cd_lbl.add_theme_font_size_override("font_size", 12)
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
		
		var btn = Button.new()
		btn.set_anchors_preset(Control.PRESET_FULL_RECT)
		btn.flat = true
		btn.gui_input.connect(func(ev): _on_inventory_slot_gui_input(ev, i))
		btn.mouse_entered.connect(func(): _on_item_slot_hover(i, true, slot_container))
		btn.mouse_exited.connect(func(): _on_item_slot_hover(i, false))
		slot_container.add_child(btn)
		inventory_slot_buttons.append(btn)
		
	# Vertical Special Slots: Neutral Slot (Top) & TP Scroll (Bottom)
	var special_vbox = VBoxContainer.new()
	special_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	special_vbox.add_theme_constant_override("separation", 3)
	h_inv.add_child(special_vbox)
	
	var neutral_btn = Button.new()
	neutral_btn.text = "0/16"
	neutral_btn.tooltip_text = "Tarafsız Eşya Yuvası (Neutral Item Slot)"
	neutral_btn.custom_minimum_size = Vector2(42, 44)
	neutral_btn.add_theme_font_size_override("font_size", 10)
	neutral_btn.add_theme_color_override("font_color", Color(0.7, 0.75, 0.85))
	special_vbox.add_child(neutral_btn)
	
	var boot_container = PanelContainer.new()
	boot_container.custom_minimum_size = Vector2(42, 44)
	var b_style = StyleBoxFlat.new()
	b_style.bg_color = Color(0.06, 0.08, 0.12, 0.98)
	b_style.border_width_left = 1
	b_style.border_width_top = 1
	b_style.border_width_right = 1
	b_style.border_width_bottom = 1
	b_style.border_color = Color(0.85, 0.70, 0.25)
	b_style.corner_radius_top_left = 4
	b_style.corner_radius_top_right = 4
	b_style.corner_radius_bottom_left = 4
	b_style.corner_radius_bottom_right = 4
	boot_container.add_theme_stylebox_override("panel", b_style)
	special_vbox.add_child(boot_container)
	
	boots_slot_texture = TextureRect.new()
	boots_slot_texture.custom_minimum_size = Vector2(32, 32)
	boots_slot_texture.set_anchors_preset(Control.PRESET_CENTER)
	boots_slot_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	boots_slot_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	boots_slot_texture.mouse_filter = Control.MOUSE_FILTER_IGNORE
	boots_slot_texture.modulate = Color(1.0, 1.0, 1.0, 1.0)
	boots_slot_texture.visible = false
	boot_container.add_child(boots_slot_texture)
	
	boots_slot_button = Button.new()
	boots_slot_button.set_anchors_preset(Control.PRESET_FULL_RECT)
	boots_slot_button.flat = true
	boots_slot_button.tooltip_text = "Özel Çizme Slotu"
	boots_slot_button.pressed.connect(_on_boots_slot_clicked)
	boot_container.add_child(boots_slot_button)

# ==============================================================================
# 3. BOTTOM-RIGHT STASH, QUICK-BUY & GOLD (market.png reference)
# ==============================================================================
var quick_buy_item: ItemResource = null
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
	tp_btn.text = "📜 1"
	tp_btn.custom_minimum_size = Vector2(36, 30)
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
	gold_label.text = "💰 99999"
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
	
	_add_action_mini_btn(courier_h, "🐻 F2", "Kurye Seç (F2)")
	_add_action_mini_btn(courier_h, "⏩", "Hızlı Teslimat")
	_add_action_mini_btn(courier_h, "🛡", "Kule Tahkimatı")
	_add_action_mini_btn(courier_h, "➡ F3", "Kurye Gönder (F3)")

func _add_action_mini_btn(parent: Control, txt: String, tip: String) -> Button:
	var btn = Button.new()
	btn.text = txt
	btn.tooltip_text = tip
	btn.custom_minimum_size = Vector2(46, 24)
	btn.add_theme_font_size_override("font_size", 8)
	parent.add_child(btn)
	return btn

func _on_quick_buy_queued(item: ItemResource) -> void:
	quick_buy_item = item
	if quick_buy_btn != null and item != null:
		quick_buy_btn.text = "%s (💰 %d)" % [item.item_name.substr(0, 5), item.cost]

func _on_quick_buy_clicked() -> void:
	if quick_buy_item == null:
		var all_items = Database.get_all_items() if is_instance_valid(Database) else []
		if all_items.size() > 15:
			quick_buy_item = all_items[15]
			
	if quick_buy_item != null and target_hero != null and target_hero.inventory_manager != null:
		var ok = target_hero.inventory_manager.buy_item(quick_buy_item, func(id): return Database.get_item(id))
		if ok and Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("HIZLI ALIM: %s SATIN ALINDI!" % quick_buy_item.item_name.to_upper())

func _on_take_all_stash_clicked() -> void:
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("ZULA: TÜM EŞYALAR ENVANTERE ALINDI")

var dota_minimap: DotaMinimap = null

# ==============================================================================
# 4. MINIMAP (Bottom Left, map.png reference)
# ==============================================================================
func _build_minimap(parent: Control) -> void:
	var h_box = HBoxContainer.new()
	h_box.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	h_box.offset_left = 12
	h_box.offset_bottom = -12
	h_box.offset_right = 320
	h_box.offset_top = -272
	h_box.add_theme_constant_override("separation", 6)
	parent.add_child(h_box)
	
	# 1. Minimap Panel
	var mini_panel = PanelContainer.new()
	mini_panel.custom_minimum_size = Vector2(260, 260)
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.1, 0.12, 0.96)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.28, 0.32, 0.40)
	style.corner_radius_top_right = 6
	mini_panel.add_theme_stylebox_override("panel", style)
	h_box.add_child(mini_panel)
	
	dota_minimap = DotaMinimap.new()
	dota_minimap.camera = camera
	dota_minimap.target_hero = target_hero
	mini_panel.add_child(dota_minimap)
	
	# 2. Radar Scan & Glyph Fortification Side Buttons (map.png reference)
	var side_vbox = VBoxContainer.new()
	side_vbox.alignment = BoxContainer.ALIGNMENT_BEGIN
	side_vbox.add_theme_constant_override("separation", 6)
	h_box.add_child(side_vbox)
	
	var scan_btn = Button.new()
	scan_btn.text = "📡"
	scan_btn.tooltip_text = "Radar Taraması (Scan - 60s Bekleme)"
	scan_btn.custom_minimum_size = Vector2(34, 34)
	scan_btn.pressed.connect(func(): if dota_minimap != null: dota_minimap.trigger_radar_scan())
	side_vbox.add_child(scan_btn)
	
	var glyph_btn = Button.new()
	glyph_btn.text = "🛡"
	glyph_btn.tooltip_text = "Kule Tahkimatı (Glyph of Fortification - 6s Dokunulmazlık)"
	glyph_btn.custom_minimum_size = Vector2(34, 34)
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
	if target_hero == null or not is_instance_valid(target_hero):
		return
		
	var stats = target_hero.attribute_system
	if stats == null:
		return
		
	if hero_name_label != null:
		hero_name_label.text = target_hero.entity_name.to_upper()
	if hero_level_label != null:
		hero_level_label.text = str(stats.level)
	
	# Dynamic HP & Mana Bars
	var cur_hp = stats.current_health
	var max_hp = stats.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	var hp_regen = stats.get_stat(StatModifier.TargetStat.HEALTH_REGEN)
	
	if hp_bar != null:
		hp_bar.max_value = max_hp
		hp_bar.value = cur_hp
	if hp_text_label != null:
		hp_text_label.text = "%d / %d" % [int(cur_hp), int(max_hp)]
	if hp_regen_label != null:
		hp_regen_label.text = "+%.1f" % hp_regen
	
	var cur_mp = stats.current_mana
	var max_mp = stats.get_stat(StatModifier.TargetStat.MAX_MANA)
	var mp_regen = stats.get_stat(StatModifier.TargetStat.MANA_REGEN)
	
	if mp_bar != null:
		mp_bar.max_value = max_mp
		mp_bar.value = cur_mp
	if mp_text_label != null:
		mp_text_label.text = "%d / %d" % [int(cur_mp), int(max_mp)]
	if mp_regen_label != null:
		mp_regen_label.text = "+%.1f" % mp_regen
		
	# Heat Bar Update
	if heat_container != null:
		var has_heat = (target_hero is KaelgorHero) or ("heat_system" in target_hero and target_hero.heat_system != null)
		heat_container.visible = has_heat
		if has_heat and "heat_system" in target_hero and target_hero.heat_system != null:
			var cur_h = target_hero.heat_system.get_heat()
			var max_h = target_hero.heat_system.max_heat
			if heat_bar != null:
				heat_bar.max_value = max_h
				heat_bar.value = cur_h
			if heat_text_label != null:
				heat_text_label.text = "%d / %d ISI" % [int(cur_h), int(max_h)]
	
	if str_val_label != null:
		str_val_label.text = "STR %d" % int(stats.get_stat(StatModifier.TargetStat.STRENGTH))
	if agi_val_label != null:
		agi_val_label.text = "AGI %d" % int(stats.get_stat(StatModifier.TargetStat.AGILITY))
	if int_val_label != null:
		int_val_label.text = "INT %d" % int(stats.get_stat(StatModifier.TargetStat.INTELLIGENCE))
	
	if ad_val_label != null:
		ad_val_label.text = "⚔ %d" % int(stats.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE))
	if armor_val_label != null:
		armor_val_label.text = "🛡 %.1f" % stats.get_stat(StatModifier.TargetStat.ARMOR)
	if mr_val_label != null:
		mr_val_label.text = "✨ %d%%" % int(stats.get_stat(StatModifier.TargetStat.MAGIC_RESIST))
	if ms_val_label != null:
		ms_val_label.text = "👟 %d" % int(stats.get_stat(StatModifier.TargetStat.MOVE_SPEED))
	
	var ab_cont = target_hero.ability_container
	if ab_cont != null:
		var has_pts = ab_cont.available_skill_points > 0
		for s in [AbilityResource.Slot.PASSIVE, AbilityResource.Slot.Q, AbilityResource.Slot.W, AbilityResource.Slot.E, AbilityResource.Slot.R]:
			var ab: AbilityResource = ab_cont.abilities.get(s)
			var lvl = ab_cont.ability_levels.get(s, 0)
			
			if ability_buttons.has(s):
				var btn: Button = ability_buttons[s]
				if ab != null:
					btn.tooltip_text = "%s (Seviye %d)\n%s" % [ab.ability_name, lvl, ab.description]
					var is_silenced = target_hero.effect_container != null and target_hero.effect_container.is_silenced()
					var is_no_mana = lvl > 0 and stats.current_mana < ab.get_mana_cost(lvl)
					var on_cd = ab_cont.cooldown_timers.get(s, 0.0) > 0.0
					btn.disabled = (lvl <= 0) or on_cd or is_silenced or is_no_mana
					
			if ability_levelup_buttons.has(s):
				var lvl_btn: Button = ability_levelup_buttons[s]
				lvl_btn.visible = has_pts and ab != null and ab_cont.can_level_up_ability(s, true)
				
			if ability_cooldown_overlays.has(s):
				var overlay: ColorRect = ability_cooldown_overlays[s]
				var cd_lbl: Label = ability_cooldown_labels[s]
				var remaining_cd = ab_cont.cooldown_timers.get(s, 0.0)
				var is_silenced = target_hero.effect_container != null and target_hero.effect_container.is_silenced()
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
						
	var inv = target_hero.inventory_manager
	if inv != null:
		gold_label.text = "💰 %d" % inv.gold
		for i in range(6):
			var slot_item = inv.slots[i]
			if inventory_slot_buttons.size() > i and inventory_slot_textures.size() > i:
				var btn = inventory_slot_buttons[i]
				var tex_rect = inventory_slot_textures[i]
				var cd_overlay = inventory_slot_cooldown_overlays[i]
				var cd_lbl = inventory_slot_cooldown_labels[i]
				var hk_lbl = inventory_slot_hotkey_labels[i]
				var s_panel = btn.get_parent() as PanelContainer
				
				var tier_col = Color(0.20, 0.25, 0.32, 0.8)
				if slot_item != null:
					var icon_path = "res://assets/icons/items/item_%d.png" % slot_item.id
					if ResourceLoader.exists(icon_path):
						tex_rect.texture = load(icon_path)
						tex_rect.visible = true
					else:
						tex_rect.visible = false
						
					var cd = inv.active_cooldowns.get(i, 0.0)
					if cd > 0.0:
						cd_overlay.visible = true
						cd_lbl.text = "%.1f" % cd
					else:
						cd_overlay.visible = false
						
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
						
					btn.tooltip_text = "%s (💰%d)" % [slot_item.item_name, slot_item.cost]
					hk_lbl.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 0.95))
				else:
					tex_rect.visible = false
					cd_overlay.visible = false
					btn.tooltip_text = "Boş Yuva [%d]" % (i + 1)
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
					
		if boots_slot_button != null and boots_slot_texture != null:
			var b_panel = boots_slot_button.get_parent() as PanelContainer
			if inv.boots_slot != null:
				var boot_icon_path = "res://assets/icons/items/item_%d.png" % inv.boots_slot.id
				if ResourceLoader.exists(boot_icon_path):
					boots_slot_texture.texture = load(boot_icon_path)
					boots_slot_texture.visible = true
				else:
					boots_slot_texture.visible = false
				boots_slot_button.tooltip_text = "%s (💰%d)" % [inv.boots_slot.item_name, inv.boots_slot.cost]
				if b_panel != null:
					var b_style = StyleBoxFlat.new()
					b_style.bg_color = Color(0.06, 0.08, 0.12, 0.98)
					b_style.border_width_left = 1
					b_style.border_width_top = 1
					b_style.border_width_right = 1
					b_style.border_width_bottom = 1
					b_style.border_color = Color(0.85, 0.70, 0.25)
					b_style.corner_radius_top_left = 4
					b_style.corner_radius_top_right = 4
					b_style.corner_radius_bottom_left = 4
					b_style.corner_radius_bottom_right = 4
					b_panel.add_theme_stylebox_override("panel", b_style)
			else:
				boots_slot_texture.visible = false
				boots_slot_button.tooltip_text = "Özel Çizme Slotu"
				if b_panel != null:
					var b_style = StyleBoxFlat.new()
					b_style.bg_color = Color(0.06, 0.08, 0.12, 0.98)
					b_style.border_width_left = 1
					b_style.border_width_top = 1
					b_style.border_width_right = 1
					b_style.border_width_bottom = 1
					b_style.border_color = Color(0.25, 0.32, 0.42, 1.0)
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
			if shop_ui != null and shop_ui.visible and target_hero != null and target_hero.inventory_manager != null:
				var refund_val = target_hero.inventory_manager.get_item_refund_value(slot_idx)
				var is_full = target_hero.inventory_manager.is_item_in_full_refund_window(slot_idx)
				var sold_item = target_hero.inventory_manager.slots[slot_idx]
				if sold_item != null:
					target_hero.inventory_manager.sell_item(slot_idx)
					if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
						var txt = "EŞYA SATILDI: %s (+💰%d %s)" % [sold_item.item_name.to_upper(), refund_val, "%100 İade" if is_full else "%50 İade"]
						GameEvents.combat_log_generated.emit(txt)
			else:
				# Use active item
				if target_hero != null and target_hero.inventory_manager != null:
					target_hero.inventory_manager.use_active_item(slot_idx)
		elif event.button_index == MOUSE_BUTTON_LEFT:
			if target_hero != null and target_hero.inventory_manager != null:
				var it = target_hero.inventory_manager.slots[slot_idx]
				if it != null and not it.active_action_tag.is_empty():
					target_hero.inventory_manager.use_active_item(slot_idx)
				else:
					_toggle_shop()

func _on_inventory_slot_clicked(_slot_idx: int) -> void:
	if target_hero != null and target_hero.inventory_manager != null:
		_toggle_shop()

func _on_item_slot_hover(slot_idx: int, is_hovered: bool, btn_control: Control = null) -> void:
	if target_hero != null and target_hero.inventory_manager != null:
		if is_hovered:
			if slot_idx < target_hero.inventory_manager.slots.size():
				var it = target_hero.inventory_manager.slots[slot_idx]
				if it != null and hud_item_tooltip != null:
					hud_item_tooltip.show_item(it)
					if btn_control != null and is_instance_valid(btn_control):
						var g_pos = btn_control.global_position
						hud_item_tooltip.global_position = Vector2(clampf(g_pos.x - 120, 20, 1500), clampf(g_pos.y - 200, 20, 800))
				if target_hero.has_method("preview_skill_range"):
					target_hero.preview_skill_range(6.0, Color(0.9, 0.75, 0.25, 0.5))
		else:
			if hud_item_tooltip != null:
				hud_item_tooltip.hide_tooltip()
			if target_hero.has_method("preview_skill_range"):
				target_hero.preview_skill_range(0.0)

func _on_boots_slot_clicked() -> void:
	_toggle_shop()

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
