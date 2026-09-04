class_name DotaScoreboard
extends Control

## Authentic Dota 2 / MOBA TAB Scoreboard Overlay
## Triggered by holding the TAB key. Shows real-time hero levels, KDA, LH/DN, Net Worth, and Items.

@export var player_hero: HeroEntity = null
@export var bot_hero: HeroEntity = null
@export var match_manager: MatchManager = null

var panel_container: PanelContainer = null
var radiant_vbox: VBoxContainer = null
var dire_vbox: VBoxContainer = null
var match_clock_label: Label = null
var score_label: Label = null

func _init() -> void:
	name = "DotaScoreboard"
	visible = false
	set_anchors_preset(PRESET_FULL_RECT)
	mouse_filter = MOUSE_FILTER_IGNORE

func _ready() -> void:
	_build_ui()

func _build_ui() -> void:
	# 1. Dark Backdrop
	var bg = ColorRect.new()
	bg.color = Color(0.02, 0.03, 0.05, 0.75)
	bg.set_anchors_preset(PRESET_FULL_RECT)
	bg.mouse_filter = MOUSE_FILTER_IGNORE
	add_child(bg)
	
	# 2. Main Center Modal
	panel_container = PanelContainer.new()
	panel_container.custom_minimum_size = Vector2(980, 480)
	panel_container.set_anchors_preset(PRESET_CENTER)
	panel_container.offset_left = -490
	panel_container.offset_top = -240
	panel_container.offset_right = 490
	panel_container.offset_bottom = 240
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.06, 0.08, 0.12, 0.95)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.28, 0.35, 0.48, 0.9)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 20
	style.content_margin_right = 20
	style.content_margin_top = 16
	style.content_margin_bottom = 16
	panel_container.add_theme_stylebox_override("panel", style)
	add_child(panel_container)
	
	var main_vbox = VBoxContainer.new()
	main_vbox.add_theme_constant_override("separation", 12)
	panel_container.add_child(main_vbox)
	
	# Top Header Bar: Title, Clock & Kills
	var top_bar = HBoxContainer.new()
	main_vbox.add_child(top_bar)
	
	var title = Label.new()
	title.text = "ECLIPSE FRONT — SKOR TABLOSU"
	title.add_theme_font_size_override("font_size", 16)
	title.add_theme_color_override("font_color", Color(1.0, 0.82, 0.3))
	top_bar.add_child(title)
	
	var spacer = Control.new()
	spacer.size_flags_horizontal = SIZE_EXPAND_FILL
	top_bar.add_child(spacer)
	
	score_label = Label.new()
	score_label.text = "0 — 0"
	score_label.add_theme_font_size_override("font_size", 16)
	score_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
	top_bar.add_child(score_label)
	
	var spacer2 = Control.new()
	spacer2.custom_minimum_size = Vector2(24, 0)
	top_bar.add_child(spacer2)
	
	match_clock_label = Label.new()
	match_clock_label.text = "00:00"
	match_clock_label.add_theme_font_size_override("font_size", 14)
	match_clock_label.add_theme_color_override("font_color", Color(0.7, 0.75, 0.85))
	top_bar.add_child(match_clock_label)
	
	var sep1 = HSeparator.new()
	main_vbox.add_child(sep1)
	
	# Column Headers
	var col_header = HBoxContainer.new()
	col_header.add_theme_constant_override("separation", 8)
	main_vbox.add_child(col_header)
	
	_create_col_header(col_header, "KAHRAMAN", 240)
	_create_col_header(col_header, "SVY", 50)
	_create_col_header(col_header, "K / D / A", 90)
	_create_col_header(col_header, "LH / DN", 80)
	_create_col_header(col_header, "NET DEĞER", 100)
	_create_col_header(col_header, "ENVANTER (EŞYALAR)", 320)
	
	# RADIANT TEAM SECTION
	var rad_header = Label.new()
	rad_header.text = "RADIANT (AYDINLIK TAKIM)"
	rad_header.add_theme_font_size_override("font_size", 13)
	rad_header.add_theme_color_override("font_color", Color(0.2, 0.85, 0.45))
	main_vbox.add_child(rad_header)
	
	radiant_vbox = VBoxContainer.new()
	radiant_vbox.add_theme_constant_override("separation", 6)
	main_vbox.add_child(radiant_vbox)
	
	var sep2 = HSeparator.new()
	main_vbox.add_child(sep2)
	
	# DIRE TEAM SECTION
	var dire_header = Label.new()
	dire_header.text = "DIRE (KARANLIK TAKIM)"
	dire_header.add_theme_font_size_override("font_size", 13)
	dire_header.add_theme_color_override("font_color", Color(0.95, 0.35, 0.35))
	main_vbox.add_child(dire_header)
	
	dire_vbox = VBoxContainer.new()
	dire_vbox.add_theme_constant_override("separation", 6)
	main_vbox.add_child(dire_vbox)

func _create_col_header(parent: Control, txt: String, width: float) -> Label:
	var lbl = Label.new()
	lbl.text = txt
	lbl.custom_minimum_size = Vector2(width, 20)
	lbl.add_theme_font_size_override("font_size", 11)
	lbl.add_theme_color_override("font_color", Color(0.55, 0.62, 0.72))
	parent.add_child(lbl)
	return lbl

func update_scoreboard() -> void:
	if match_manager != null:
		var mins = int(match_manager.match_time / 60.0)
		var secs = int(match_manager.match_time) % 60
		match_clock_label.text = "%02d:%02d" % [mins, secs]
		score_label.text = "%d — %d" % [match_manager.radiant_kills, match_manager.dire_kills]
		
	_refresh_team_vbox(radiant_vbox, TeamDefinitions.Team.RADIANT)
	_refresh_team_vbox(dire_vbox, TeamDefinitions.Team.DIRE)

func _refresh_team_vbox(vbox: VBoxContainer, team: TeamDefinitions.Team) -> void:
	if vbox == null:
		return
		
	# Clear old rows
	for child in vbox.get_children():
		child.queue_free()
		
	var heroes: Array[HeroEntity] = []
	if player_hero != null and is_instance_valid(player_hero) and player_hero.team == team:
		heroes.append(player_hero)
	if bot_hero != null and is_instance_valid(bot_hero) and bot_hero.team == team:
		heroes.append(bot_hero)
		
	# Also find any other spawned heroes
	for h in HeroEntity.active_heroes:
		if is_instance_valid(h) and h.team == team and not heroes.has(h):
			heroes.append(h)
			
	if is_inside_tree() and get_tree() != null:
		var all_heroes = get_tree().get_nodes_in_group("heroes")
		for h in all_heroes:
			if h is HeroEntity and is_instance_valid(h) and h.team == team and not heroes.has(h):
				heroes.append(h)
				
	for hero in heroes:
		var row = _build_hero_row(hero)
		vbox.add_child(row)

func _build_hero_row(hero: HeroEntity) -> HBoxContainer:
	var row = HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	
	# 1. Hero Name / Icon (240px)
	var hero_name_lbl = Label.new()
	hero_name_lbl.text = hero.entity_name.to_upper()
	hero_name_lbl.custom_minimum_size = Vector2(240, 32)
	hero_name_lbl.add_theme_font_size_override("font_size", 12)
	hero_name_lbl.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
	row.add_child(hero_name_lbl)
	
	# 2. Level (50px)
	var lvl_lbl = Label.new()
	var lvl = hero.attribute_system.level if hero.attribute_system != null else 1
	lvl_lbl.text = "%d" % lvl
	lvl_lbl.custom_minimum_size = Vector2(50, 32)
	lvl_lbl.add_theme_font_size_override("font_size", 12)
	lvl_lbl.add_theme_color_override("font_color", Color(0.85, 0.85, 0.85))
	row.add_child(lvl_lbl)
	
	# 3. K / D / A (90px)
	var kda_lbl = Label.new()
	var k = hero.get("kills") if "kills" in hero else 0
	var d = hero.get("deaths") if "deaths" in hero else 0
	var a = hero.get("assists") if "assists" in hero else 0
	kda_lbl.text = "%d / %d / %d" % [k, d, a]
	kda_lbl.custom_minimum_size = Vector2(90, 32)
	kda_lbl.add_theme_font_size_override("font_size", 12)
	kda_lbl.add_theme_color_override("font_color", Color(0.9, 0.85, 0.4))
	row.add_child(kda_lbl)
	
	# 4. LH / DN (80px)
	var cs_lbl = Label.new()
	var cs = hero.get("last_hits") if "last_hits" in hero else 0
	var dn = hero.get("denies") if "denies" in hero else 0
	cs_lbl.text = "%d / %d" % [cs, dn]
	cs_lbl.custom_minimum_size = Vector2(80, 32)
	cs_lbl.add_theme_font_size_override("font_size", 12)
	cs_lbl.add_theme_color_override("font_color", Color(0.4, 0.85, 1.0))
	row.add_child(cs_lbl)
	
	# 5. Net Worth (Gold) (100px)
	var gold_lbl = Label.new()
	var g = hero.inventory_manager.gold if hero.inventory_manager != null else 0
	gold_lbl.text = "💰 %d" % g
	gold_lbl.custom_minimum_size = Vector2(100, 32)
	gold_lbl.add_theme_font_size_override("font_size", 12)
	gold_lbl.add_theme_color_override("font_color", Color(1.0, 0.8, 0.2))
	row.add_child(gold_lbl)
	
	# 6. Items (6 slots + boots) (320px)
	var items_hbox = HBoxContainer.new()
	items_hbox.custom_minimum_size = Vector2(320, 32)
	items_hbox.add_theme_constant_override("separation", 4)
	row.add_child(items_hbox)
	
	if hero.inventory_manager != null:
		# 6 normal slots
		for slot_idx in range(6):
			var item = hero.inventory_manager.get_item_in_slot(slot_idx)
			var slot_panel = _create_mini_item_slot(item)
			items_hbox.add_child(slot_panel)
		# Boots slot
		var boot_item = hero.inventory_manager.boots_slot
		var boot_panel = _create_mini_item_slot(boot_item, true)
		items_hbox.add_child(boot_panel)
		
	return row

func _create_mini_item_slot(item: ItemResource, is_boots: bool = false) -> PanelContainer:
	var panel = PanelContainer.new()
	panel.custom_minimum_size = Vector2(28, 28)
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.10, 0.14, 0.95)
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color(0.85, 0.70, 0.25) if is_boots else Color(0.25, 0.32, 0.42)
	style.corner_radius_top_left = 3
	style.corner_radius_top_right = 3
	style.corner_radius_bottom_left = 3
	style.corner_radius_bottom_right = 3
	panel.add_theme_stylebox_override("panel", style)
	
	if item != null:
		var tex = TextureRect.new()
		tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tex.custom_minimum_size = Vector2(24, 24)
		var icon_path = "res://assets/icons/items/item_%d.png" % item.id
		if ResourceLoader.exists(icon_path):
			tex.texture = load(icon_path)
		panel.add_child(tex)
		panel.tooltip_text = "%s (💰 %d)" % [item.item_name, item.cost]
	else:
		panel.tooltip_text = "Çizme Yuvası (Boş)" if is_boots else "Boş Yuva"
		
	return panel
