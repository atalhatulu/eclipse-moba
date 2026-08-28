class_name ShopInventoryUI
extends Control

## Authentic Dota 2 Market & Shop Modal (market.png reference)
## Right-click to purchase directly, Shift+Left-click to queue to Quick-Buy, Mouse hover shows full item stats tooltip

signal item_purchased(item: ItemResource)
signal quick_buy_queued(item: ItemResource)

@export var target_hero: HeroEntity = null

var shop_panel: PanelContainer = null
var search_edit: LineEdit = null
var current_tab: String = "TEMEL" # "TEMEL", "YUKSELTME", "TARAFSIZ"
var search_query: String = ""

var items_grid_container: VBoxContainer = null
var guide_vbox: VBoxContainer = null
var item_tooltip: DotaItemTooltip = null

func _init() -> void:
	set_anchors_preset(PRESET_FULL_RECT)
	mouse_filter = MOUSE_FILTER_IGNORE
	_build_ui()

func _ready() -> void:
	Database.initialize()
	if target_hero == null and get_parent() is HeroEntity:
		bind_hero(get_parent() as HeroEntity)
	visible = false

func bind_hero(hero: HeroEntity) -> void:
	target_hero = hero
	if target_hero != null and target_hero.inventory_manager != null:
		_refresh_shop_view()

func toggle_shop() -> void:
	visible = not visible
	if visible:
		_refresh_shop_view()

func _build_ui() -> void:
	# Modal overlay
	shop_panel = PanelContainer.new()
	shop_panel.name = "ShopPanel"
	shop_panel.set_anchors_preset(Control.PRESET_CENTER)
	shop_panel.custom_minimum_size = Vector2(860, 580)
	shop_panel.offset_left = -430
	shop_panel.offset_right = 430
	shop_panel.offset_top = -320
	shop_panel.offset_bottom = 260
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.06, 0.08, 0.11, 0.98) # Deep Obsidian
	style.border_width_left = 2
	style.border_width_top = 3
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.26, 0.38, 0.50, 1.0)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.shadow_size = 14
	style.shadow_color = Color(0, 0, 0, 0.8)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	shop_panel.add_theme_stylebox_override("panel", style)
	add_child(shop_panel)
	
	var main_v = VBoxContainer.new()
	main_v.add_theme_constant_override("separation", 8)
	shop_panel.add_child(main_v)
	
	# =========================================================================
	# 1. TOP HEADER (market.png reference)
	# =========================================================================
	var top_h = HBoxContainer.new()
	top_h.add_theme_constant_override("separation", 12)
	main_v.add_child(top_h)
	
	var guide_btn = Button.new()
	guide_btn.text = "BÜTÜN REHBERLERE GÖZ AT ≫"
	guide_btn.add_theme_font_size_override("font_size", 10)
	guide_btn.add_theme_color_override("font_color", Color(0.65, 0.75, 0.85))
	top_h.add_child(guide_btn)
	
	search_edit = LineEdit.new()
	search_edit.placeholder_text = "🔍 Arama..."
	search_edit.custom_minimum_size = Vector2(220, 28)
	search_edit.size_flags_horizontal = SIZE_EXPAND_FILL
	search_edit.add_theme_font_size_override("font_size", 11)
	search_edit.text_changed.connect(_on_search_changed)
	top_h.add_child(search_edit)
	
	# Tabs: TEMEL | YÜKSELTME | TARAFSIZ
	var tabs_h = HBoxContainer.new()
	tabs_h.add_theme_constant_override("separation", 4)
	top_h.add_child(tabs_h)
	
	var btn_temel = _create_tab_button(tabs_h, "TEMEL", true)
	var btn_yukselt = _create_tab_button(tabs_h, "YÜKSELTME", false)
	var btn_tarafsiz = _create_tab_button(tabs_h, "TARAFSIZ", false)
	
	btn_temel.pressed.connect(func(): _select_tab("TEMEL", [btn_temel, btn_yukselt, btn_tarafsiz]))
	btn_yukselt.pressed.connect(func(): _select_tab("YÜKSELTME", [btn_temel, btn_yukselt, btn_tarafsiz]))
	btn_tarafsiz.pressed.connect(func(): _select_tab("TARAFSIZ", [btn_temel, btn_yukselt, btn_tarafsiz]))
	
	var close_btn = Button.new()
	close_btn.text = "✕"
	close_btn.custom_minimum_size = Vector2(28, 28)
	close_btn.pressed.connect(func(): visible = false)
	top_h.add_child(close_btn)
	
	var sep1 = ColorRect.new()
	sep1.custom_minimum_size = Vector2(0, 1)
	sep1.color = Color(0.24, 0.32, 0.42, 0.7)
	main_v.add_child(sep1)
	
	# =========================================================================
	# 2. MAIN CONTENT (Left: Guide Column, Right: Category Grid)
	# =========================================================================
	var content_h = HBoxContainer.new()
	content_h.add_theme_constant_override("separation", 12)
	content_h.size_flags_vertical = SIZE_EXPAND_FILL
	main_v.add_child(content_h)
	
	# Left: Guide Panel
	var left_panel = PanelContainer.new()
	left_panel.custom_minimum_size = Vector2(210, 0)
	var l_style = StyleBoxFlat.new()
	l_style.bg_color = Color(0.05, 0.06, 0.08, 0.95)
	l_style.border_width_right = 1
	l_style.border_color = Color(0.2, 0.26, 0.34)
	l_style.content_margin_left = 6
	l_style.content_margin_right = 6
	l_style.content_margin_top = 6
	l_style.content_margin_bottom = 6
	left_panel.add_theme_stylebox_override("panel", l_style)
	content_h.add_child(left_panel)
	
	var left_scroll = ScrollContainer.new()
	left_scroll.size_flags_vertical = SIZE_EXPAND_FILL
	left_panel.add_child(left_scroll)
	
	guide_vbox = VBoxContainer.new()
	guide_vbox.size_flags_horizontal = SIZE_EXPAND_FILL
	guide_vbox.add_theme_constant_override("separation", 8)
	left_scroll.add_child(guide_vbox)
	
	# Right: Categories & Grid
	var right_scroll = ScrollContainer.new()
	right_scroll.size_flags_horizontal = SIZE_EXPAND_FILL
	right_scroll.size_flags_vertical = SIZE_EXPAND_FILL
	content_h.add_child(right_scroll)
	
	items_grid_container = VBoxContainer.new()
	items_grid_container.size_flags_horizontal = SIZE_EXPAND_FILL
	items_grid_container.add_theme_constant_override("separation", 10)
	right_scroll.add_child(items_grid_container)
	
	# =========================================================================
	# 3. BOTTOM PINNED ITEMS (Pin Bar: market.png reference)
	# =========================================================================
	var bot_h = HBoxContainer.new()
	bot_h.add_theme_constant_override("separation", 12)
	main_v.add_child(bot_h)
	
	var pin_title = Label.new()
	pin_title.text = "SABİTLENMİŞ EŞYALAR:"
	pin_title.add_theme_font_size_override("font_size", 9)
	pin_title.add_theme_color_override("font_color", Color(0.65, 0.70, 0.80))
	bot_h.add_child(pin_title)
	
	var pin_grid = HBoxContainer.new()
	pin_grid.add_theme_constant_override("separation", 4)
	bot_h.add_child(pin_grid)
	_build_pin_bar(pin_grid)
	
	var hint_lbl = Label.new()
	hint_lbl.text = "💡 SAĞ TIK: Satın Al | SOL TIK: Hızlı Alıma Ekle"
	hint_lbl.size_flags_horizontal = SIZE_EXPAND_FILL
	hint_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	hint_lbl.add_theme_font_size_override("font_size", 9)
	hint_lbl.add_theme_color_override("font_color", Color(0.4, 0.85, 1.0))
	bot_h.add_child(hint_lbl)
	
	# Floating Item Tooltip (Highest z-index floating card)
	item_tooltip = DotaItemTooltip.new()
	add_child(item_tooltip)

func _create_tab_button(parent: Control, tab_name: String, is_active: bool) -> Button:
	var btn = Button.new()
	btn.text = tab_name
	btn.custom_minimum_size = Vector2(80, 26)
	btn.add_theme_font_size_override("font_size", 10)
	if is_active:
		btn.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	else:
		btn.add_theme_color_override("font_color", Color(0.65, 0.72, 0.80))
	parent.add_child(btn)
	return btn

func _select_tab(tab_name: String, tab_buttons: Array) -> void:
	current_tab = tab_name
	for b in tab_buttons:
		if b is Button:
			if b.text == tab_name:
				b.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
			else:
				b.add_theme_color_override("font_color", Color(0.65, 0.72, 0.80))
	_refresh_shop_view()

func _on_search_changed(new_text: String) -> void:
	search_query = new_text.strip_edges().to_lower()
	_refresh_shop_view()

func _refresh_shop_view() -> void:
	_populate_guide_items()
	_populate_grid_items()

func _populate_guide_items() -> void:
	if guide_vbox == null:
		return
	for c in guide_vbox.get_children():
		c.queue_free()
		
	var h_name = target_hero.entity_name if target_hero != null else "Solen"
	var hdr = Label.new()
	hdr.text = "REHBER: %s Position 1" % h_name.to_upper()
	hdr.add_theme_font_size_override("font_size", 10)
	hdr.add_theme_color_override("font_color", Color(1.0, 0.88, 0.4))
	guide_vbox.add_child(hdr)
	
	_add_guide_section("BAŞLANGIÇ EŞYALARI", [1, 2, 3, 4])
	_add_guide_section("ERKEN OYUN", [8, 9, 10])
	_add_guide_section("ANA EŞYALAR", [15, 20, 25, 30])
	_add_guide_section("LÜKS EŞYALAR", [35, 40, 50, 60])

func _add_guide_section(title: String, sample_ids: Array[int]) -> void:
	var sec_lbl = Label.new()
	sec_lbl.text = title
	sec_lbl.add_theme_font_size_override("font_size", 9)
	sec_lbl.add_theme_color_override("font_color", Color(0.7, 0.75, 0.82))
	guide_vbox.add_child(sec_lbl)
	
	var grid = GridContainer.new()
	grid.columns = 4
	grid.add_theme_constant_override("h_separation", 4)
	grid.add_theme_constant_override("v_separation", 4)
	guide_vbox.add_child(grid)
	
	for id in sample_ids:
		var it = Database.get_item(id) if is_instance_valid(Database) else null
		if it != null:
			_create_item_box(grid, it)

func _populate_grid_items() -> void:
	if items_grid_container == null:
		return
	for c in items_grid_container.get_children():
		c.queue_free()
		
	var all_items = Database.get_all_items() if is_instance_valid(Database) else []
	if all_items.is_empty():
		var empty_lbl = Label.new()
		empty_lbl.text = "Eşya listesi yükleniyor..."
		items_grid_container.add_child(empty_lbl)
		return
		
	if current_tab == "TEMEL":
		_build_category_group("TEMEL BİLEŞENLER (BASE ITEMS - 300g - 900g)", all_items, ItemResource.Category.BASE)
		_build_category_group("ÇİZMELER & HAREKET (BOOTS - 500g - 1350g)", all_items, ItemResource.Category.BOOTS)
	elif current_tab == "YÜKSELTME":
		_build_category_group("ORTA SEVİYE BİRLEŞİMLER (INTERMEDIATE - 1000g - 1700g)", all_items, ItemResource.Category.INTERMEDIATE)
		_build_category_group("EFSANEVİ NİHAİ EŞYALAR (LEGENDARY - 2650g - 3700g)", all_items, ItemResource.Category.LEGENDARY)
		_build_category_group("DESTEK VE AURA EŞYALARI (SUPPORT - 2650g - 3350g)", all_items, ItemResource.Category.SUPPORT)
	else:
		_build_category_group("TÜM BİLEŞENLER (BASE)", all_items, ItemResource.Category.BASE)
		_build_category_group("TÜM EFSANEVİLER (LEGENDARY)", all_items, ItemResource.Category.LEGENDARY)

func _build_category_group(title: String, items: Array[ItemResource], cat: ItemResource.Category) -> void:
	var filtered: Array[ItemResource] = []
	for it in items:
		if it.category == cat:
			if search_query == "" or it.item_name.to_lower().contains(search_query):
				filtered.append(it)
				
	if filtered.is_empty():
		return
		
	var sec_title = Label.new()
	sec_title.text = title
	sec_title.add_theme_font_size_override("font_size", 10)
	sec_title.add_theme_color_override("font_color", Color(0.85, 0.75, 0.35))
	items_grid_container.add_child(sec_title)
	
	var grid = GridContainer.new()
	grid.columns = 6
	grid.add_theme_constant_override("h_separation", 6)
	grid.add_theme_constant_override("v_separation", 6)
	items_grid_container.add_child(grid)
	
	for it in filtered:
		_create_item_box(grid, it)

func _create_item_box(parent: Control, item: ItemResource) -> void:
	var box = PanelContainer.new()
	box.custom_minimum_size = Vector2(58, 52)
	
	var b_style = StyleBoxFlat.new()
	b_style.bg_color = Color(0.09, 0.12, 0.16, 0.95)
	b_style.border_width_left = 1
	b_style.border_width_top = 1
	b_style.border_width_right = 1
	b_style.border_width_bottom = 1
	b_style.border_color = Color(0.28, 0.35, 0.45)
	b_style.corner_radius_top_left = 4
	b_style.corner_radius_top_right = 4
	b_style.corner_radius_bottom_left = 4
	b_style.corner_radius_bottom_right = 4
	box.add_theme_stylebox_override("panel", b_style)
	parent.add_child(box)
	
	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 2)
	box.add_child(vbox)
	
	# Icon / Initials
	var name_lbl = Label.new()
	name_lbl.text = item.item_name.substr(0, 5)
	name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_lbl.add_theme_font_size_override("font_size", 9)
	name_lbl.add_theme_color_override("font_color", Color(1.0, 0.95, 0.85))
	vbox.add_child(name_lbl)
	
	# Gold cost
	var cost_lbl = Label.new()
	cost_lbl.text = "💰%d" % item.cost
	cost_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cost_lbl.add_theme_font_size_override("font_size", 8)
	cost_lbl.add_theme_color_override("font_color", Color(1.0, 0.85, 0.25))
	vbox.add_child(cost_lbl)
	
	var click_btn = Button.new()
	click_btn.set_anchors_preset(Control.PRESET_FULL_RECT)
	click_btn.flat = true
	box.add_child(click_btn)
	
	click_btn.mouse_entered.connect(func(): _on_item_hover(item, true, box))
	click_btn.mouse_exited.connect(func(): _on_item_hover(item, false))
	click_btn.gui_input.connect(func(ev): _on_item_gui_input(ev, item))

func _on_item_gui_input(event: InputEvent, item: ItemResource) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			# RIGHT-CLICK: Direct purchase!
			_buy_item(item)
		elif event.button_index == MOUSE_BUTTON_LEFT:
			# LEFT-CLICK or Shift+Click: Queue to Quick-Buy
			quick_buy_queued.emit(item)
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("HIZLI ALIM KUYRUĞUNA EKLENDİ: %s" % item.item_name.to_upper())

func _buy_item(item: ItemResource) -> void:
	if target_hero != null and target_hero.inventory_manager != null:
		var ok = target_hero.inventory_manager.buy_item(item, func(id): return Database.get_item(id))
		if ok:
			item_purchased.emit(item)
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("MARKET: %s SATIN ALINDI (💰 %d)" % [item.item_name.to_upper(), item.cost])

func _on_item_hover(item: ItemResource, is_hover: bool, btn_control: Control = null) -> void:
	if item_tooltip != null:
		if is_hover:
			item_tooltip.show_item(item)
			if btn_control != null and is_instance_valid(btn_control):
				var g_pos = btn_control.global_position
				item_tooltip.global_position = Vector2(clampf(g_pos.x - 140, 20, 1500), clampf(g_pos.y - 220, 20, 800))
		else:
			item_tooltip.hide_tooltip()

func _build_pin_bar(parent: Control) -> void:
	var pin_ids: Array[int] = [1, 2, 3, 4, 8]
	for id in pin_ids:
		var it = Database.get_item(id) if is_instance_valid(Database) else null
		if it != null:
			_create_item_box(parent, it)
