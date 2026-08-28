class_name HeroSelectionUI
extends Control

## Comprehensive Hero Selection & Testing Dashboard for Eclipse Front
## Supports full 31-hero roster browsing, attribute/search filtering, detailed ability inspection, and instant play/swap.

signal hero_selected(hero_id: String, as_player: bool)
signal game_started(player_hero_id: String, bot_hero_id: String)
signal close_requested()

enum FilterCategory {
	ALL,
	STRENGTH,
	AGILITY,
	INTELLIGENCE
}

@export var is_modal_mode: bool = false
@export var target_moba_map: Node3D = null

var current_filter: FilterCategory = FilterCategory.ALL
var current_search_query: String = ""
var inspected_hero_id: String = "kaelgor"

# UI Node References
var grid_container: GridContainer = null
var search_input: LineEdit = null
var filter_buttons: Dictionary = {} # FilterCategory -> Button
var hero_card_buttons: Dictionary = {} # hero_id -> Button

# Detail Panel Elements
var hero_title_label: Label = null
var hero_role_label: Label = null
var hero_desc_label: Label = null
var hero_stats_rich_text: RichTextLabel = null
var abilities_vbox: VBoxContainer = null

var btn_play_hero: Button = null
var btn_set_bot: Button = null
var btn_open_sandbox: Button = null
var btn_close: Button = null
var status_banner: Label = null

func _ready() -> void:
	Database.initialize()
	set_anchors_preset(PRESET_FULL_RECT)
	_build_ui()
	_populate_hero_grid()
	inspect_hero(GlobalHeroSelection.get_player_hero_id())

func _build_ui() -> void:
	# Main Background
	var bg = ColorRect.new()
	bg.color = Color(0.04, 0.06, 0.09, 0.98 if is_modal_mode else 1.0)
	bg.set_anchors_preset(PRESET_FULL_RECT)
	add_child(bg)
	
	var main_margin = MarginContainer.new()
	main_margin.set_anchors_preset(PRESET_FULL_RECT)
	main_margin.add_theme_constant_override("margin_left", 24)
	main_margin.add_theme_constant_override("margin_top", 18)
	main_margin.add_theme_constant_override("margin_right", 24)
	main_margin.add_theme_constant_override("margin_bottom", 18)
	add_child(main_margin)
	
	var root_vbox = VBoxContainer.new()
	root_vbox.add_theme_constant_override("separation", 14)
	main_margin.add_child(root_vbox)
	
	# --- TOP HEADER BAR ---
	var top_bar = HBoxContainer.new()
	top_bar.add_theme_constant_override("separation", 16)
	root_vbox.add_child(top_bar)
	
	var title_vbox = VBoxContainer.new()
	var title_lbl = Label.new()
	title_lbl.text = "ECLIPSE FRONT — KAHRAMAN SEÇİM VE DENEME MERKEZİ"
	title_lbl.add_theme_font_size_override("font_size", 20)
	title_lbl.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	title_vbox.add_child(title_lbl)
	
	var subtitle_lbl = Label.new()
	subtitle_lbl.text = "31 Özgün Kahraman — Nitelikler, Yetenekler ve Canlı Test"
	subtitle_lbl.add_theme_font_size_override("font_size", 12)
	subtitle_lbl.add_theme_color_override("font_color", Color(0.65, 0.75, 0.85))
	title_vbox.add_child(subtitle_lbl)
	top_bar.add_child(title_vbox)
	
	top_bar.add_spacer(false)
	
	# Attribute Filter Tabs
	var filters_hbox = HBoxContainer.new()
	filters_hbox.add_theme_constant_override("separation", 8)
	top_bar.add_child(filters_hbox)
	
	_add_filter_btn(filters_hbox, FilterCategory.ALL, "TÜMÜ (31)", Color(0.8, 0.85, 0.9))
	_add_filter_btn(filters_hbox, FilterCategory.STRENGTH, "🔴 GÜÇ / STR (8)", Color(0.95, 0.35, 0.35))
	_add_filter_btn(filters_hbox, FilterCategory.AGILITY, "🟢 ÇEVİKLİK / AGI (8)", Color(0.35, 0.9, 0.45))
	_add_filter_btn(filters_hbox, FilterCategory.INTELLIGENCE, "🔵 ZEKA / INT (15)", Color(0.35, 0.75, 1.0))
	
	# Search Box
	search_input = LineEdit.new()
	search_input.placeholder_text = "🔍 Kahraman veya Rol Ara..."
	search_input.custom_minimum_size = Vector2(220, 36)
	search_input.text_changed.connect(_on_search_text_changed)
	top_bar.add_child(search_input)
	
	if is_modal_mode:
		btn_close = Button.new()
		btn_close.text = "✖ KAPAT"
		btn_close.custom_minimum_size = Vector2(90, 36)
		btn_close.pressed.connect(_on_close_clicked)
		top_bar.add_child(btn_close)
		
	# Separator
	var sep = HSeparator.new()
	root_vbox.add_child(sep)
	
	# --- MAIN CONTENT AREA: SPLIT (GRID ON LEFT, DETAILS ON RIGHT) ---
	var content_split = HBoxContainer.new()
	content_split.size_flags_vertical = SIZE_EXPAND_FILL
	content_split.add_theme_constant_override("separation", 20)
	root_vbox.add_child(content_split)
	
	# LEFT: HERO CARDS SCROLLABLE GRID
	var grid_panel = PanelContainer.new()
	grid_panel.size_flags_horizontal = SIZE_EXPAND_FILL
	grid_panel.size_flags_vertical = SIZE_EXPAND_FILL
	var gp_style = StyleBoxFlat.new()
	gp_style.bg_color = Color(0.06, 0.08, 0.12, 0.7)
	gp_style.border_width_left = 1
	gp_style.border_width_right = 1
	gp_style.border_width_top = 1
	gp_style.border_width_bottom = 1
	gp_style.border_color = Color(0.2, 0.25, 0.35)
	gp_style.corner_radius_top_left = 6
	gp_style.corner_radius_top_right = 6
	gp_style.corner_radius_bottom_left = 6
	gp_style.corner_radius_bottom_right = 6
	gp_style.content_margin_left = 12
	gp_style.content_margin_top = 12
	gp_style.content_margin_right = 12
	gp_style.content_margin_bottom = 12
	grid_panel.add_theme_stylebox_override("panel", gp_style)
	content_split.add_child(grid_panel)
	
	var grid_scroll = ScrollContainer.new()
	grid_scroll.size_flags_horizontal = SIZE_EXPAND_FILL
	grid_scroll.size_flags_vertical = SIZE_EXPAND_FILL
	grid_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	grid_panel.add_child(grid_scroll)
	
	grid_container = GridContainer.new()
	grid_container.columns = 4
	grid_container.size_flags_horizontal = SIZE_EXPAND_FILL
	grid_container.add_theme_constant_override("h_separation", 10)
	grid_container.add_theme_constant_override("v_separation", 10)
	grid_scroll.add_child(grid_container)
	
	# RIGHT: HERO INSPECTION & DETAILS PANEL
	var detail_panel = PanelContainer.new()
	detail_panel.custom_minimum_size = Vector2(460, 0)
	detail_panel.size_flags_vertical = SIZE_EXPAND_FILL
	var dp_style = StyleBoxFlat.new()
	dp_style.bg_color = Color(0.07, 0.09, 0.14, 0.95)
	dp_style.border_width_left = 2
	dp_style.border_width_right = 2
	dp_style.border_width_top = 2
	dp_style.border_width_bottom = 2
	dp_style.border_color = Color(0.3, 0.4, 0.55)
	dp_style.corner_radius_top_left = 8
	dp_style.corner_radius_top_right = 8
	dp_style.corner_radius_bottom_left = 8
	dp_style.corner_radius_bottom_right = 8
	dp_style.content_margin_left = 16
	dp_style.content_margin_top = 16
	dp_style.content_margin_right = 16
	dp_style.content_margin_bottom = 16
	detail_panel.add_theme_stylebox_override("panel", dp_style)
	content_split.add_child(detail_panel)
	
	var detail_vbox = VBoxContainer.new()
	detail_vbox.size_flags_horizontal = SIZE_EXPAND_FILL
	detail_vbox.size_flags_vertical = SIZE_EXPAND_FILL
	detail_vbox.add_theme_constant_override("separation", 10)
	detail_panel.add_child(detail_vbox)
	
	# Hero Title Header
	hero_title_label = Label.new()
	hero_title_label.text = "Karakter Adı"
	hero_title_label.add_theme_font_size_override("font_size", 22)
	hero_title_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	detail_vbox.add_child(hero_title_label)
	
	hero_role_label = Label.new()
	hero_role_label.text = "Rol ve Nitelik Bilgisi"
	hero_role_label.add_theme_font_size_override("font_size", 13)
	hero_role_label.add_theme_color_override("font_color", Color(0.7, 0.8, 0.9))
	detail_vbox.add_child(hero_role_label)
	
	hero_desc_label = Label.new()
	hero_desc_label.text = "Karakter konsept açıklaması..."
	hero_desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hero_desc_label.add_theme_font_size_override("font_size", 11)
	hero_desc_label.add_theme_color_override("font_color", Color(0.6, 0.7, 0.8))
	detail_vbox.add_child(hero_desc_label)
	
	var stats_sep = HSeparator.new()
	detail_vbox.add_child(stats_sep)
	
	# Stats Rich Text Box
	hero_stats_rich_text = RichTextLabel.new()
	hero_stats_rich_text.custom_minimum_size = Vector2(0, 95)
	hero_stats_rich_text.bbcode_enabled = true
	hero_stats_rich_text.fit_content = false
	hero_stats_rich_text.text = "Stats Yükleniyor..."
	detail_vbox.add_child(hero_stats_rich_text)
	
	var abilities_header = Label.new()
	abilities_header.text = "YETENEKLER & BECERİLER"
	abilities_header.add_theme_font_size_override("font_size", 13)
	abilities_header.add_theme_color_override("font_color", Color(0.9, 0.8, 0.4))
	detail_vbox.add_child(abilities_header)
	
	# Abilities Scroll
	var ab_scroll = ScrollContainer.new()
	ab_scroll.size_flags_vertical = SIZE_EXPAND_FILL
	ab_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	detail_vbox.add_child(ab_scroll)
	
	abilities_vbox = VBoxContainer.new()
	abilities_vbox.size_flags_horizontal = SIZE_EXPAND_FILL
	abilities_vbox.add_theme_constant_override("separation", 8)
	ab_scroll.add_child(abilities_vbox)
	
	# Status Banner
	status_banner = Label.new()
	status_banner.text = "Seçim Yapıldı: Oyuncu: %s | Bot: %s" % [GlobalHeroSelection.get_player_hero_id().to_upper(), GlobalHeroSelection.get_bot_hero_id().to_upper()]
	status_banner.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status_banner.add_theme_font_size_override("font_size", 11)
	status_banner.add_theme_color_override("font_color", Color(0.5, 0.9, 0.7))
	detail_vbox.add_child(status_banner)
	
	# Action Buttons
	var act_vbox = VBoxContainer.new()
	act_vbox.add_theme_constant_override("separation", 6)
	detail_vbox.add_child(act_vbox)
	
	btn_play_hero = Button.new()
	btn_play_hero.text = "⚔️ BU KAHRAMANLA OYNA / DÖNÜŞ"
	btn_play_hero.custom_minimum_size = Vector2(0, 42)
	var play_style = StyleBoxFlat.new()
	play_style.bg_color = Color(0.85, 0.65, 0.15, 0.95)
	play_style.corner_radius_top_left = 6
	play_style.corner_radius_top_right = 6
	play_style.corner_radius_bottom_left = 6
	play_style.corner_radius_bottom_right = 6
	btn_play_hero.add_theme_stylebox_override("normal", play_style)
	btn_play_hero.add_theme_color_override("font_color", Color(0.05, 0.05, 0.05))
	btn_play_hero.add_theme_font_size_override("font_size", 14)
	btn_play_hero.pressed.connect(_on_btn_play_hero_clicked)
	act_vbox.add_child(btn_play_hero)
	
	var dual_hbox = HBoxContainer.new()
	dual_hbox.add_theme_constant_override("separation", 6)
	act_vbox.add_child(dual_hbox)
	
	btn_set_bot = Button.new()
	btn_set_bot.text = "🤖 RAKİP / BOT OLARAK SEÇ"
	btn_set_bot.size_flags_horizontal = SIZE_EXPAND_FILL
	btn_set_bot.custom_minimum_size = Vector2(0, 34)
	btn_set_bot.pressed.connect(_on_btn_set_bot_clicked)
	dual_hbox.add_child(btn_set_bot)
	
	btn_open_sandbox = Button.new()
	btn_open_sandbox.text = "⚡ TEST ARENASI"
	btn_open_sandbox.size_flags_horizontal = SIZE_EXPAND_FILL
	btn_open_sandbox.custom_minimum_size = Vector2(0, 34)
	btn_open_sandbox.pressed.connect(_on_btn_sandbox_clicked)
	dual_hbox.add_child(btn_open_sandbox)

func _add_filter_btn(parent: Control, cat: FilterCategory, txt: String, col: Color) -> void:
	var btn = Button.new()
	btn.text = txt
	btn.custom_minimum_size = Vector2(110, 36)
	btn.add_theme_font_size_override("font_size", 11)
	btn.add_theme_color_override("font_color", col)
	btn.pressed.connect(func(): _set_filter(cat))
	parent.add_child(btn)
	filter_buttons[cat] = btn

func _set_filter(cat: FilterCategory) -> void:
	current_filter = cat
	_update_grid_filter()

func _on_search_text_changed(new_text: String) -> void:
	current_search_query = new_text.strip_edges().to_lower()
	_update_grid_filter()

func _populate_hero_grid() -> void:
	for child in grid_container.get_children():
		child.queue_free()
	hero_card_buttons.clear()
	
	var all_defs = HeroDefinition.get_all_definitions()
	# Sort alphabetically by hero name
	all_defs.sort_custom(func(a, b): return a.hero_name < b.hero_name)
	
	for def in all_defs:
		var card = _create_hero_card(def)
		grid_container.add_child(card)
		hero_card_buttons[def.hero_id] = card
		
	_update_grid_filter()

func _create_hero_card(def: HeroResource) -> Button:
	var btn = Button.new()
	btn.custom_minimum_size = Vector2(230, 95)
	btn.size_flags_horizontal = SIZE_EXPAND_FILL
	
	var attr_color = Color(0.9, 0.3, 0.3) # STR Red
	var attr_name = "GÜÇ (STR)"
	if def.primary_attribute == AttributeSystem.PrimaryAttributeType.AGILITY:
		attr_color = Color(0.3, 0.85, 0.4) # AGI Green
		attr_name = "ÇEVİKLİK (AGI)"
	elif def.primary_attribute == AttributeSystem.PrimaryAttributeType.INTELLIGENCE:
		attr_color = Color(0.3, 0.7, 1.0) # INT Blue
		attr_name = "ZEKA (INT)"
		
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.09, 0.12, 0.17, 0.95)
	style.border_width_left = 4
	style.border_width_right = 1
	style.border_width_top = 1
	style.border_width_bottom = 1
	style.border_color = attr_color
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_left = 6
	style.corner_radius_bottom_right = 6
	style.content_margin_left = 10
	style.content_margin_top = 8
	style.content_margin_right = 10
	style.content_margin_bottom = 8
	btn.add_theme_stylebox_override("normal", style)
	
	var card_vbox = VBoxContainer.new()
	card_vbox.set_anchors_preset(PRESET_FULL_RECT)
	card_vbox.mouse_filter = MOUSE_FILTER_IGNORE
	btn.add_child(card_vbox)
	
	var name_lbl = Label.new()
	name_lbl.text = def.hero_name
	name_lbl.add_theme_font_size_override("font_size", 14)
	name_lbl.add_theme_color_override("font_color", Color(1.0, 0.95, 0.8))
	card_vbox.add_child(name_lbl)
	
	var role_lbl = Label.new()
	role_lbl.text = def.role
	role_lbl.add_theme_font_size_override("font_size", 10)
	role_lbl.add_theme_color_override("font_color", Color(0.7, 0.8, 0.9))
	card_vbox.add_child(role_lbl)
	
	var bot_hbox = HBoxContainer.new()
	var tag_attr = Label.new()
	tag_attr.text = attr_name
	tag_attr.add_theme_font_size_override("font_size", 9)
	tag_attr.add_theme_color_override("font_color", attr_color)
	bot_hbox.add_child(tag_attr)
	
	bot_hbox.add_spacer(false)
	
	var tag_atk = Label.new()
	tag_atk.text = "🏹 Menzilli" if def.attack_type == HeroResource.AttackType.RANGED else "⚔️ Yakın"
	tag_atk.add_theme_font_size_override("font_size", 9)
	tag_atk.add_theme_color_override("font_color", Color(0.75, 0.8, 0.85))
	bot_hbox.add_child(tag_atk)
	
	card_vbox.add_child(bot_hbox)
	
	btn.pressed.connect(func(): inspect_hero(def.hero_id))
	return btn

func _update_grid_filter() -> void:
	var all_defs = HeroDefinition.get_all_definitions()
	for def in all_defs:
		var card = hero_card_buttons.get(def.hero_id, null)
		if card == null:
			continue
			
		var match_attr = true
		if current_filter == FilterCategory.STRENGTH:
			match_attr = (def.primary_attribute == AttributeSystem.PrimaryAttributeType.STRENGTH)
		elif current_filter == FilterCategory.AGILITY:
			match_attr = (def.primary_attribute == AttributeSystem.PrimaryAttributeType.AGILITY)
		elif current_filter == FilterCategory.INTELLIGENCE:
			match_attr = (def.primary_attribute == AttributeSystem.PrimaryAttributeType.INTELLIGENCE)
			
		var match_search = true
		if not current_search_query.is_empty():
			var q = current_search_query
			match_search = (def.hero_name.to_lower().contains(q) or def.role.to_lower().contains(q) or def.role_description.to_lower().contains(q))
			
		card.visible = match_attr and match_search

func inspect_hero(hero_id: String) -> void:
	inspected_hero_id = hero_id.to_lower()
	var def = HeroDefinition.get_definition(inspected_hero_id)
	if def == null:
		return
		
	# Highlight selected card border
	for h_id in hero_card_buttons.keys():
		var btn = hero_card_buttons[h_id]
		var style: StyleBoxFlat = btn.get_theme_stylebox("normal")
		if style != null:
			if h_id == inspected_hero_id:
				style.border_width_right = 3
				style.border_width_top = 3
				style.border_width_bottom = 3
			else:
				style.border_width_right = 1
				style.border_width_top = 1
				style.border_width_bottom = 1
				
	# Populate Details
	var attr_name = "GÜÇ (STR)"
	if def.primary_attribute == AttributeSystem.PrimaryAttributeType.AGILITY:
		attr_name = "ÇEVİKLİK (AGI)"
	elif def.primary_attribute == AttributeSystem.PrimaryAttributeType.INTELLIGENCE:
		attr_name = "ZEKA (INT)"
		
	hero_title_label.text = "%s" % def.hero_name
	hero_role_label.text = "• Rol: %s  |  Birincil Nitelik: %s" % [def.role, attr_name]
	hero_desc_label.text = def.role_description
	
	# Stats BBCode
	var atk_type = "Menzilli" if def.attack_type == HeroResource.AttackType.RANGED else "Yakın Dövüşçü"
	var stats_txt = "[b]Nitelikler:[/b] STR: %.0f (+%.1f) | AGI: %.0f (+%.1f) | INT: %.0f (+%.1f)\n" % [
		def.base_strength, def.strength_growth,
		def.base_agility, def.agility_growth,
		def.base_intelligence, def.intelligence_growth
	]
	stats_txt += "[b]Muharebe:[/b] Can: [color=lime]%.0f[/color] (+%.1f/s) | Mana: [color=cyan]%.0f[/color] (+%.1f/s)\n" % [
		def.base_health, def.base_health_regen,
		def.base_mana, def.base_mana_regen
	]
	stats_txt += "[b]Saldırı:[/b] Hasar: %.0f (%s) | Menzil: %.0f | Hız: %.2f | Zırh: %.0f | MR: %.0f | Hız: %.0f" % [
		def.base_attack_damage, atk_type, def.base_attack_range, def.base_attack_speed,
		def.base_armor, def.base_magic_resist, def.base_move_speed
	]
	hero_stats_rich_text.text = stats_txt
	
	# Populate Abilities
	for child in abilities_vbox.get_children():
		child.queue_free()
		
	_add_ability_entry(def.passive_ability, "PASİF", Color(0.95, 0.8, 0.3))
	_add_ability_entry(def.q_ability, "Q YETENEĞİ", Color(0.4, 0.75, 1.0))
	_add_ability_entry(def.w_ability, "W YETENEĞİ", Color(0.4, 0.9, 0.5))
	_add_ability_entry(def.e_ability, "E YETENEĞİ", Color(0.9, 0.5, 0.9))
	_add_ability_entry(def.r_ability, "R (ULTIMATE)", Color(1.0, 0.4, 0.3))
	
	_update_status_banner()

func _add_ability_entry(ab: AbilityResource, slot_tag: String, header_col: Color) -> void:
	if ab == null:
		return
		
	var entry_panel = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.07, 0.10, 0.85)
	style.border_width_left = 3
	style.border_color = header_col
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_right = 4
	style.content_margin_left = 8
	style.content_margin_top = 6
	style.content_margin_right = 8
	style.content_margin_bottom = 6
	entry_panel.add_theme_stylebox_override("panel", style)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 2)
	entry_panel.add_child(vbox)
	
	var hdr_hbox = HBoxContainer.new()
	var tag_lbl = Label.new()
	tag_lbl.text = "[%s] %s" % [slot_tag, ab.ability_name]
	tag_lbl.add_theme_font_size_override("font_size", 11)
	tag_lbl.add_theme_color_override("font_color", header_col)
	hdr_hbox.add_child(tag_lbl)
	
	hdr_hbox.add_spacer(false)
	
	if not ab.is_passive and not ab.cooldowns.is_empty():
		var cd_lbl = Label.new()
		cd_lbl.text = "⏱ %.1fs | 💧 %.0f" % [ab.cooldowns[0], ab.mana_costs[0] if not ab.mana_costs.is_empty() else 0.0]
		cd_lbl.add_theme_font_size_override("font_size", 10)
		cd_lbl.add_theme_color_override("font_color", Color(0.7, 0.8, 0.9))
		hdr_hbox.add_child(cd_lbl)
		
	vbox.add_child(hdr_hbox)
	
	var desc_lbl = Label.new()
	desc_lbl.text = ab.description
	desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_lbl.add_theme_font_size_override("font_size", 10)
	desc_lbl.add_theme_color_override("font_color", Color(0.75, 0.8, 0.85))
	vbox.add_child(desc_lbl)
	
	abilities_vbox.add_child(entry_panel)

func _update_status_banner() -> void:
	status_banner.text = "Aktif Seçim: Oyuncu: %s | Bot: %s" % [
		GlobalHeroSelection.get_player_hero_id().to_upper(),
		GlobalHeroSelection.get_bot_hero_id().to_upper()
	]

func _on_btn_play_hero_clicked() -> void:
	GlobalHeroSelection.set_player_hero(inspected_hero_id)
	_update_status_banner()
	hero_selected.emit(inspected_hero_id, true)
	
	var m_map = target_moba_map
	if m_map == null and get_tree() != null:
		m_map = get_tree().current_scene
		
	if is_modal_mode and m_map != null and m_map.has_method("switch_player_hero"):
		m_map.switch_player_hero(inspected_hero_id)
		visible = false
	else:
		# Launch or switch main MOBA map
		game_started.emit(GlobalHeroSelection.get_player_hero_id(), GlobalHeroSelection.get_bot_hero_id())
		if get_tree() != null:
			get_tree().change_scene_to_file("res://scenes/map/moba_map_3d.tscn")

func _on_btn_set_bot_clicked() -> void:
	GlobalHeroSelection.set_bot_hero(inspected_hero_id)
	_update_status_banner()
	hero_selected.emit(inspected_hero_id, false)
	
	var m_map = target_moba_map
	if m_map == null and get_tree() != null:
		m_map = get_tree().current_scene
		
	if is_modal_mode and m_map != null and m_map.has_method("switch_bot_hero"):
		m_map.switch_bot_hero(inspected_hero_id)

func _on_btn_sandbox_clicked() -> void:
	GlobalHeroSelection.set_player_hero(inspected_hero_id)
	if get_tree() != null:
		get_tree().change_scene_to_file("res://scenes/test/developer_sandbox.tscn")

func _on_close_clicked() -> void:
	visible = false
	close_requested.emit()
