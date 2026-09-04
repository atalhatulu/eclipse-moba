class_name ShopInventoryUI
extends Control

## Authentic Cyber-Fantasy 3-Column MOBA Shop Modal (Design 1 reference)
## Left Column: Role Guide | Middle Column: Categorized Item Grid | Right Column: Item Inspect & Buy Card

signal item_purchased(item: ItemResource)
signal quick_buy_queued(item: ItemResource)

@export var target_hero: HeroEntity = null

var shop_panel: PanelContainer = null
var search_edit: LineEdit = null
var current_tab: String = "TEMEL" # "TEMEL", "YUKSELTME", "TARAFSIZ"
var search_query: String = ""

var items_grid_container: VBoxContainer = null
var guide_vbox: VBoxContainer = null
var recipe_tree_vbox: VBoxContainer = null
var selected_item: ItemResource = null
var item_tooltip: DotaItemTooltip = null

# Inspect Panel Elements (Right Column - Design 1)
var inspect_panel: PanelContainer = null
var inspect_title_label: Label = null
var inspect_tag_label: Label = null
var inspect_icon_texture: TextureRect = null
var inspect_cost_label: Label = null
var inspect_stats_vbox: VBoxContainer = null
var inspect_passive_box: PanelContainer = null
var inspect_passive_title: Label = null
var inspect_passive_desc: Label = null
var inspect_components_vbox: VBoxContainer = null
var inspect_buy_btn: Button = null
var inspect_quickbuy_btn: Button = null

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
	shop_panel.custom_minimum_size = Vector2(1180, 680)
	shop_panel.offset_left = -590
	shop_panel.offset_right = 590
	shop_panel.offset_top = -340
	shop_panel.offset_bottom = 340
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.06, 0.08, 0.11, 0.96) # Deep Obsidian Night
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color(0.0, 0.86, 0.95, 0.4) # Electric Cyan Glow
	style.corner_radius_top_left = 12
	style.corner_radius_top_right = 12
	style.corner_radius_bottom_left = 12
	style.corner_radius_bottom_right = 12
	style.shadow_size = 18
	style.shadow_color = Color(0, 0, 0, 0.85)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	shop_panel.add_theme_stylebox_override("panel", style)
	add_child(shop_panel)
	
	var main_v = VBoxContainer.new()
	main_v.add_theme_constant_override("separation", 10)
	shop_panel.add_child(main_v)
	
	# =========================================================================
	# 1. TOP HEADER (Design 1 reference)
	# =========================================================================
	var top_h = HBoxContainer.new()
	top_h.add_theme_constant_override("separation", 12)
	main_v.add_child(top_h)
	
	var guide_btn = Button.new()
	guide_btn.text = "BÜTÜN REHBERLERE GÖZ AT ≫"
	guide_btn.add_theme_font_size_override("font_size", 11)
	guide_btn.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	guide_btn.pressed.connect(func(): select_item(null))
	top_h.add_child(guide_btn)
	
	search_edit = LineEdit.new()
	search_edit.placeholder_text = "Eşya Ara..."
	search_edit.custom_minimum_size = Vector2(240, 32)
	search_edit.size_flags_horizontal = SIZE_EXPAND_FILL
	search_edit.add_theme_font_size_override("font_size", 11)
	search_edit.text_changed.connect(_on_search_changed)
	top_h.add_child(search_edit)
	
	# Tabs: TEMEL | YÜKSELTME | TARAFSIZ
	var tabs_h = HBoxContainer.new()
	tabs_h.add_theme_constant_override("separation", 6)
	top_h.add_child(tabs_h)
	
	var btn_temel = _create_tab_button(tabs_h, "TEMEL", true)
	var btn_yukselt = _create_tab_button(tabs_h, "YÜKSELTME", false)
	var btn_tarafsiz = _create_tab_button(tabs_h, "TARAFSIZ", false)
	
	btn_temel.pressed.connect(func(): _select_tab("TEMEL", [btn_temel, btn_yukselt, btn_tarafsiz]))
	btn_yukselt.pressed.connect(func(): _select_tab("YÜKSELTME", [btn_temel, btn_yukselt, btn_tarafsiz]))
	btn_tarafsiz.pressed.connect(func(): _select_tab("TARAFSIZ", [btn_temel, btn_yukselt, btn_tarafsiz]))
	
	var close_btn = Button.new()
	close_btn.text = "✕"
	close_btn.custom_minimum_size = Vector2(32, 32)
	close_btn.pressed.connect(func(): visible = false)
	top_h.add_child(close_btn)
	
	var sep1 = ColorRect.new()
	sep1.custom_minimum_size = Vector2(0, 1)
	sep1.color = Color(0.18, 0.25, 0.35, 0.6)
	main_v.add_child(sep1)
	
	# =========================================================================
	# 2. MAIN 3-COLUMN CONTENT (Left: Guide, Center: Grid, Right: Inspect Card)
	# =========================================================================
	var content_h = HBoxContainer.new()
	content_h.add_theme_constant_override("separation", 12)
	content_h.size_flags_vertical = SIZE_EXPAND_FILL
	main_v.add_child(content_h)
	
	# --- Column 1: Left Guide & Recommended Panel (260px) ---
	var left_panel = PanelContainer.new()
	left_panel.custom_minimum_size = Vector2(260, 0)
	var l_style = StyleBoxFlat.new()
	l_style.bg_color = Color(0.04, 0.05, 0.08, 0.95)
	l_style.border_width_right = 1
	l_style.border_color = Color(0.18, 0.24, 0.32)
	l_style.corner_radius_top_left = 6
	l_style.corner_radius_bottom_left = 6
	l_style.content_margin_left = 8
	l_style.content_margin_right = 8
	l_style.content_margin_top = 8
	l_style.content_margin_bottom = 8
	left_panel.add_theme_stylebox_override("panel", l_style)
	content_h.add_child(left_panel)
	
	var left_scroll = ScrollContainer.new()
	left_scroll.size_flags_vertical = SIZE_EXPAND_FILL
	left_panel.add_child(left_scroll)
	
	var left_vbox = VBoxContainer.new()
	left_vbox.size_flags_horizontal = SIZE_EXPAND_FILL
	left_vbox.size_flags_vertical = SIZE_EXPAND_FILL
	left_vbox.add_theme_constant_override("separation", 8)
	left_scroll.add_child(left_vbox)
	
	guide_vbox = VBoxContainer.new()
	guide_vbox.size_flags_horizontal = SIZE_EXPAND_FILL
	guide_vbox.add_theme_constant_override("separation", 8)
	left_vbox.add_child(guide_vbox)
	
	recipe_tree_vbox = VBoxContainer.new()
	recipe_tree_vbox.size_flags_horizontal = SIZE_EXPAND_FILL
	recipe_tree_vbox.add_theme_constant_override("separation", 6)
	recipe_tree_vbox.visible = false
	left_vbox.add_child(recipe_tree_vbox)
	
	# --- Column 2: Center Categorized Item Grid (Expanded) ---
	var right_scroll = ScrollContainer.new()
	right_scroll.size_flags_horizontal = SIZE_EXPAND_FILL
	right_scroll.size_flags_vertical = SIZE_EXPAND_FILL
	content_h.add_child(right_scroll)
	
	items_grid_container = VBoxContainer.new()
	items_grid_container.size_flags_horizontal = SIZE_EXPAND_FILL
	items_grid_container.add_theme_constant_override("separation", 10)
	right_scroll.add_child(items_grid_container)
	
	# --- Column 3: Right Item Inspect & Action Panel (320px - Design 1 reference) ---
	_build_inspect_column(content_h)
	
	# =========================================================================
	# 3. BOTTOM PINNED ITEMS
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
	hint_lbl.text = "SAĞ TIK: Satın Al | SOL TIK: İncele / Hızlı Alım"
	hint_lbl.size_flags_horizontal = SIZE_EXPAND_FILL
	hint_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	hint_lbl.add_theme_font_size_override("font_size", 9)
	hint_lbl.add_theme_color_override("font_color", Color(0.4, 0.85, 1.0))
	bot_h.add_child(hint_lbl)
	
	# Floating Item Tooltip (Highest z-index floating card)
	item_tooltip = DotaItemTooltip.new()
	add_child(item_tooltip)

func _build_inspect_column(parent: Control) -> void:
	inspect_panel = PanelContainer.new()
	inspect_panel.custom_minimum_size = Vector2(310, 0)
	var r_style = StyleBoxFlat.new()
	r_style.bg_color = Color(0.04, 0.05, 0.08, 0.98)
	r_style.border_width_left = 1
	r_style.border_color = Color(0.18, 0.24, 0.32)
	r_style.corner_radius_top_right = 8
	r_style.corner_radius_bottom_right = 8
	r_style.content_margin_left = 12
	r_style.content_margin_right = 12
	r_style.content_margin_top = 10
	r_style.content_margin_bottom = 10
	inspect_panel.add_theme_stylebox_override("panel", r_style)
	parent.add_child(inspect_panel)
	
	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = SIZE_EXPAND_FILL
	inspect_panel.add_child(scroll)
	
	var v_box = VBoxContainer.new()
	v_box.size_flags_horizontal = SIZE_EXPAND_FILL
	v_box.add_theme_constant_override("separation", 8)
	scroll.add_child(v_box)
	
	# Top: Title & Tag
	inspect_title_label = Label.new()
	inspect_title_label.text = "EŞYA SEÇİNİZ"
	inspect_title_label.add_theme_font_size_override("font_size", 13)
	inspect_title_label.add_theme_color_override("font_color", Color(1.0, 0.95, 0.9))
	v_box.add_child(inspect_title_label)
	
	inspect_tag_label = Label.new()
	inspect_tag_label.text = "Bir eşyaya tıklayarak özelliklerini görebilirsiniz"
	inspect_tag_label.add_theme_font_size_override("font_size", 9)
	inspect_tag_label.add_theme_color_override("font_color", Color(0.65, 0.75, 0.85))
	v_box.add_child(inspect_tag_label)
	
	# Middle: Icon & Cost Card
	var icon_h = HBoxContainer.new()
	icon_h.add_theme_constant_override("separation", 10)
	v_box.add_child(icon_h)
	
	var icon_box = PanelContainer.new()
	icon_box.custom_minimum_size = Vector2(56, 56)
	var ib_style = StyleBoxFlat.new()
	ib_style.bg_color = Color(0.08, 0.10, 0.15, 1.0)
	ib_style.border_width_left = 1
	ib_style.border_width_top = 1
	ib_style.border_width_right = 1
	ib_style.border_width_bottom = 1
	ib_style.border_color = Color(0.0, 0.86, 0.95, 0.5)
	ib_style.corner_radius_top_left = 6
	ib_style.corner_radius_top_right = 6
	ib_style.corner_radius_bottom_left = 6
	ib_style.corner_radius_bottom_right = 6
	icon_box.add_theme_stylebox_override("panel", ib_style)
	icon_h.add_child(icon_box)
	
	inspect_icon_texture = TextureRect.new()
	inspect_icon_texture.set_anchors_preset(Control.PRESET_FULL_RECT)
	inspect_icon_texture.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	inspect_icon_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	icon_box.add_child(inspect_icon_texture)
	
	var cost_vbox = VBoxContainer.new()
	cost_vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	cost_vbox.add_theme_constant_override("separation", 2)
	icon_h.add_child(cost_vbox)
	
	inspect_cost_label = Label.new()
	inspect_cost_label.text = "Fiyat: --"
	inspect_cost_label.add_theme_font_size_override("font_size", 12)
	inspect_cost_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.25))
	cost_vbox.add_child(inspect_cost_label)
	
	# Stats List
	inspect_stats_vbox = VBoxContainer.new()
	inspect_stats_vbox.add_theme_constant_override("separation", 3)
	v_box.add_child(inspect_stats_vbox)
	
	# Passive / Active Box
	inspect_passive_box = PanelContainer.new()
	var pb_style = StyleBoxFlat.new()
	pb_style.bg_color = Color(0.08, 0.10, 0.14, 0.9)
	pb_style.border_width_left = 2
	pb_style.border_color = Color(0.0, 0.86, 0.95, 0.5)
	pb_style.content_margin_left = 8
	pb_style.content_margin_right = 8
	pb_style.content_margin_top = 6
	pb_style.content_margin_bottom = 6
	inspect_passive_box.add_theme_stylebox_override("panel", pb_style)
	inspect_passive_box.visible = false
	v_box.add_child(inspect_passive_box)
	
	var pb_v = VBoxContainer.new()
	pb_v.add_theme_constant_override("separation", 3)
	inspect_passive_box.add_child(pb_v)
	
	inspect_passive_title = Label.new()
	inspect_passive_title.text = "ÖZEL MEKANİK"
	inspect_passive_title.add_theme_font_size_override("font_size", 10)
	inspect_passive_title.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	pb_v.add_child(inspect_passive_title)
	
	inspect_passive_desc = Label.new()
	inspect_passive_desc.text = ""
	inspect_passive_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	inspect_passive_desc.add_theme_font_size_override("font_size", 9)
	inspect_passive_desc.add_theme_color_override("font_color", Color(0.85, 0.88, 0.92))
	pb_v.add_child(inspect_passive_desc)
	
	# Components Breakdown
	inspect_components_vbox = VBoxContainer.new()
	inspect_components_vbox.add_theme_constant_override("separation", 3)
	v_box.add_child(inspect_components_vbox)
	
	# CTA Buttons
	inspect_buy_btn = Button.new()
	inspect_buy_btn.text = "EŞYAYI SATIN AL"
	inspect_buy_btn.custom_minimum_size = Vector2(0, 32)
	inspect_buy_btn.add_theme_font_size_override("font_size", 11)
	var buy_s = StyleBoxFlat.new()
	buy_s.bg_color = Color(0.2, 0.16, 0.04, 0.95)
	buy_s.border_width_left = 1
	buy_s.border_width_top = 1
	buy_s.border_width_right = 1
	buy_s.border_width_bottom = 1
	buy_s.border_color = Color(1.0, 0.73, 0.13, 0.9)
	buy_s.corner_radius_top_left = 4
	buy_s.corner_radius_top_right = 4
	buy_s.corner_radius_bottom_left = 4
	buy_s.corner_radius_bottom_right = 4
	inspect_buy_btn.add_theme_stylebox_override("normal", buy_s)
	inspect_buy_btn.add_theme_color_override("font_color", Color(1.0, 0.85, 0.25))
	inspect_buy_btn.disabled = true
	inspect_buy_btn.pressed.connect(func(): if selected_item != null: _buy_item(selected_item))
	v_box.add_child(inspect_buy_btn)
	
	inspect_quickbuy_btn = Button.new()
	inspect_quickbuy_btn.text = "HIZLI ALIMA EKLE"
	inspect_quickbuy_btn.custom_minimum_size = Vector2(0, 26)
	inspect_quickbuy_btn.add_theme_font_size_override("font_size", 10)
	inspect_quickbuy_btn.disabled = true
	inspect_quickbuy_btn.pressed.connect(func():
		if selected_item != null:
			quick_buy_queued.emit(selected_item)
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("HIZLI ALIM: %s EKLENDİ" % selected_item.item_name.to_upper())
	)
	v_box.add_child(inspect_quickbuy_btn)

func _update_inspect_panel(item: ItemResource) -> void:
	if inspect_panel == null:
		return
	if item == null:
		inspect_title_label.text = "EŞYA SEÇİNİZ"
		inspect_tag_label.text = "Bir eşyaya tıklayarak özelliklerini görebilirsiniz"
		inspect_cost_label.text = "Fiyat: --"
		inspect_icon_texture.texture = null
		inspect_passive_box.visible = false
		for c in inspect_stats_vbox.get_children():
			c.queue_free()
		for c in inspect_components_vbox.get_children():
			c.queue_free()
		inspect_buy_btn.disabled = true
		inspect_buy_btn.text = "EŞYAYI SATIN AL"
		inspect_quickbuy_btn.disabled = true
		return
		
	inspect_buy_btn.disabled = false
	inspect_quickbuy_btn.disabled = false
	inspect_title_label.text = item.item_name.to_upper()
	inspect_tag_label.text = "Kategori: %s" % str(item.category if "category" in item else "Genel").to_upper()
	inspect_cost_label.text = "Fiyat: %d Altın" % item.cost
	inspect_buy_btn.text = "SATIN AL (%d Altın)" % item.cost
	
	var icon_path = "res://assets/icons/items/item_%d.png" % item.id
	if ResourceLoader.exists(icon_path):
		inspect_icon_texture.texture = load(icon_path)
	else:
		inspect_icon_texture.texture = null
		
	for c in inspect_stats_vbox.get_children():
		c.queue_free()
		
	if not item.stat_bonuses.is_empty():
		for stat_type in item.stat_bonuses.keys():
			var val = item.stat_bonuses[stat_type]
			var s_lbl = Label.new()
			s_lbl.text = "+ %s %s" % [str(val), _get_stat_name(stat_type)]
			s_lbl.add_theme_font_size_override("font_size", 10)
			s_lbl.add_theme_color_override("font_color", Color(0.4, 0.85, 1.0))
			inspect_stats_vbox.add_child(s_lbl)
			
	if not item.description.is_empty():
		inspect_passive_box.visible = true
		inspect_passive_desc.text = item.description
	else:
		inspect_passive_box.visible = false
		
	for c in inspect_components_vbox.get_children():
		c.queue_free()
		
	if item.is_recipe():
		var c_hdr = Label.new()
		c_hdr.text = "Bileşenler:"
		c_hdr.add_theme_font_size_override("font_size", 9)
		c_hdr.add_theme_color_override("font_color", Color(0.7, 0.8, 0.9))
		inspect_components_vbox.add_child(c_hdr)
		for cid in item.recipe_components:
			var c_it = Database.get_item(cid) if is_instance_valid(Database) else null
			if c_it != null:
				var c_lbl = Label.new()
				c_lbl.text = "  • %s (%dg)" % [c_it.item_name, c_it.cost]
				c_lbl.add_theme_font_size_override("font_size", 9)
				c_lbl.add_theme_color_override("font_color", Color(0.75, 0.85, 0.75))
				inspect_components_vbox.add_child(c_lbl)

func _get_stat_name(target_stat) -> String:
	match target_stat:
		StatModifier.TargetStat.ATTACK_DAMAGE: return "Saldırı Gücü"
		StatModifier.TargetStat.ABILITY_POWER: return "Yetenek Gücü"
		StatModifier.TargetStat.ARMOR: return "Zırh"
		StatModifier.TargetStat.MAGIC_RESIST: return "Büyü Direnci"
		StatModifier.TargetStat.MAX_HEALTH: return "Azami Can"
		StatModifier.TargetStat.MAX_MANA: return "Azami Mana"
		StatModifier.TargetStat.HEALTH_REGEN: return "Can Yenileme / sn"
		StatModifier.TargetStat.MANA_REGEN: return "Mana Yenileme / sn"
		StatModifier.TargetStat.ATTACK_SPEED: return "Saldırı Hızı"
		StatModifier.TargetStat.MOVE_SPEED: return "Hareket Hızı"
		StatModifier.TargetStat.CRIT_CHANCE: return "% Kritik Şansı"
		StatModifier.TargetStat.CRIT_DAMAGE: return "% Kritik Hasarı"
		StatModifier.TargetStat.LIFESTEAL: return "% Can Çalma"
		StatModifier.TargetStat.SPELL_VAMP: return "% Büyü Vampiri"
		StatModifier.TargetStat.COOLDOWN_REDUCTION: return "% Bekleme Süresi Azaltma"
		_: return str(target_stat)

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

func select_item(item: ItemResource) -> void:
	selected_item = item
	_update_inspect_panel(item)
	if item != null:
		if recipe_tree_vbox != null:
			recipe_tree_vbox.visible = true
			_populate_recipe_tree(item)
	else:
		if recipe_tree_vbox != null:
			recipe_tree_vbox.visible = false
		_populate_guide_items()

func _is_item_owned(item_id: int) -> bool:
	if target_hero == null or target_hero.inventory_manager == null:
		return false
	var inv: InventoryManager = target_hero.inventory_manager
	if inv.boots_slot != null and inv.boots_slot.id == item_id:
		return true
	for s in inv.slots:
		if s != null and s.id == item_id:
			return true
	return false

func _populate_recipe_tree(item: ItemResource) -> void:
	if recipe_tree_vbox == null or item == null:
		return
	for c in recipe_tree_vbox.get_children():
		c.queue_free()
		
	# 1. Back to Guide Button
	var back_btn = Button.new()
	back_btn.text = "≪ REHBERE DÖN"
	back_btn.add_theme_font_size_override("font_size", 9)
	back_btn.add_theme_color_override("font_color", Color(0.65, 0.75, 0.90))
	back_btn.pressed.connect(func(): select_item(null))
	recipe_tree_vbox.add_child(back_btn)
	
	# 2. Section Header
	var tree_title = Label.new()
	tree_title.text = "EŞYA YAPIM AĞACI"
	tree_title.add_theme_font_size_override("font_size", 11)
	tree_title.add_theme_color_override("font_color", Color(1.0, 0.85, 0.30))
	recipe_tree_vbox.add_child(tree_title)
	
	# 3. Target Item Root Card
	var root_card = PanelContainer.new()
	var rc_style = StyleBoxFlat.new()
	rc_style.bg_color = Color(0.08, 0.12, 0.18, 0.98)
	rc_style.border_width_left = 2
	rc_style.border_width_top = 2
	rc_style.border_width_right = 2
	rc_style.border_width_bottom = 2
	rc_style.border_color = Color(1.0, 0.80, 0.25)
	rc_style.corner_radius_top_left = 6
	rc_style.corner_radius_top_right = 6
	rc_style.corner_radius_bottom_left = 6
	rc_style.corner_radius_bottom_right = 6
	rc_style.content_margin_left = 8
	rc_style.content_margin_right = 8
	rc_style.content_margin_top = 8
	rc_style.content_margin_bottom = 8
	root_card.add_theme_stylebox_override("panel", rc_style)
	recipe_tree_vbox.add_child(root_card)
	
	var rc_v = VBoxContainer.new()
	rc_v.add_theme_constant_override("separation", 4)
	root_card.add_child(rc_v)
	
	var rc_top_h = HBoxContainer.new()
	rc_top_h.add_theme_constant_override("separation", 8)
	rc_v.add_child(rc_top_h)
	
	var icon_path = "res://assets/icons/items/item_%d.png" % item.id
	if ResourceLoader.exists(icon_path):
		var tr = TextureRect.new()
		tr.custom_minimum_size = Vector2(36, 36)
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		tr.texture = load(icon_path)
		rc_top_h.add_child(tr)
	else:
		var glyph = Label.new()
		glyph.text = "[EŞYA]"
		glyph.add_theme_font_size_override("font_size", 11)
		rc_top_h.add_child(glyph)
		
	var info_v = VBoxContainer.new()
	info_v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info_v.add_theme_constant_override("separation", 1)
	rc_top_h.add_child(info_v)
	
	var name_lbl = Label.new()
	name_lbl.text = item.item_name.to_upper()
	name_lbl.add_theme_font_size_override("font_size", 12)
	name_lbl.add_theme_color_override("font_color", Color(1.0, 0.95, 0.85))
	info_v.add_child(name_lbl)
	
	var cost_lbl = Label.new()
	cost_lbl.text = "Toplam: %d Altın" % item.cost
	cost_lbl.add_theme_font_size_override("font_size", 10)
	cost_lbl.add_theme_color_override("font_color", Color(1.0, 0.85, 0.25))
	info_v.add_child(cost_lbl)
	
	# Discount info
	if target_hero != null and target_hero.inventory_manager != null:
		var inv: InventoryManager = target_hero.inventory_manager
		var sol = ItemTreeResolver.resolve_crafting(item, inv.gold, inv.slots, inv.boots_slot, func(id): return Database.get_item(id))
		if sol.components_owned_value > 0:
			var disc_lbl = Label.new()
			disc_lbl.text = "Kalan: %d (İndirim: -%d)" % [sol.final_gold_cost, sol.components_owned_value]
			disc_lbl.add_theme_font_size_override("font_size", 9)
			disc_lbl.add_theme_color_override("font_color", Color(0.4, 0.95, 0.6))
			rc_v.add_child(disc_lbl)
			
	var act_btn_h = HBoxContainer.new()
	act_btn_h.add_theme_constant_override("separation", 4)
	rc_v.add_child(act_btn_h)
	
	var buy_btn = Button.new()
	buy_btn.text = "Satın Al"
	buy_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	buy_btn.add_theme_font_size_override("font_size", 10)
	buy_btn.pressed.connect(func(): _buy_item(item))
	act_btn_h.add_child(buy_btn)
	
	var qb_btn = Button.new()
	qb_btn.text = "Hızlı Alım"
	qb_btn.add_theme_font_size_override("font_size", 10)
	qb_btn.pressed.connect(func():
		quick_buy_queued.emit(item)
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("HIZLI ALIM KUYRUĞUNA EKLENDİ: %s" % item.item_name.to_upper())
	)
	act_btn_h.add_child(qb_btn)
	
	# 4. Hierarchical Recipe Tree
	if item.is_recipe():
		var branch_hdr = Label.new()
		branch_hdr.text = "BİLEŞENLER (AĞAÇ YAPISI):"
		branch_hdr.add_theme_font_size_override("font_size", 10)
		branch_hdr.add_theme_color_override("font_color", Color(0.70, 0.85, 1.0))
		recipe_tree_vbox.add_child(branch_hdr)
		
		_build_recursive_tree_nodes(item, recipe_tree_vbox, 0)
	else:
		# Base Item: Show what it builds into!
		var base_hdr = Label.new()
		base_hdr.text = "TEMEL BİLEŞEN (Alt parçası yoktur)"
		base_hdr.add_theme_font_size_override("font_size", 9)
		base_hdr.add_theme_color_override("font_color", Color(0.55, 0.75, 0.60))
		recipe_tree_vbox.add_child(base_hdr)
		
		var builds_into_hdr = Label.new()
		builds_into_hdr.text = "BU EŞYADAN ÜRETİLENLER (Builds Into):"
		builds_into_hdr.add_theme_font_size_override("font_size", 10)
		builds_into_hdr.add_theme_color_override("font_color", Color(0.85, 0.80, 0.35))
		recipe_tree_vbox.add_child(builds_into_hdr)
		
		var all_items = Database.get_all_items() if is_instance_valid(Database) else []
		var count = 0
		for up_item in all_items:
			if up_item.recipe_components.has(item.id):
				_create_builds_into_card(recipe_tree_vbox, up_item)
				count += 1
				if count >= 8:
					break

func _build_recursive_tree_nodes(parent_item: ItemResource, container: Control, depth: int) -> void:
	if parent_item == null or not parent_item.is_recipe() or depth >= 4:
		return
		
	var num_comps = parent_item.recipe_components.size()
	for i in range(num_comps):
		var cid = parent_item.recipe_components[i]
		var c_item = Database.get_item(cid) if is_instance_valid(Database) else null
		if c_item == null:
			continue
			
		var is_last = (i == num_comps - 1)
		var is_owned = _is_item_owned(cid)
		
		var row_h = HBoxContainer.new()
		row_h.add_theme_constant_override("separation", 4)
		container.add_child(row_h)
		
		# Indent & Branch Symbols
		var indent_str = ""
		for _d in range(depth):
			indent_str += "   "
		var branch_sym = "└── " if is_last else "├── "
		
		var branch_lbl = Label.new()
		branch_lbl.text = indent_str + branch_sym
		branch_lbl.add_theme_font_size_override("font_size", 11)
		branch_lbl.add_theme_color_override("font_color", Color(0.45, 0.60, 0.75))
		row_h.add_child(branch_lbl)
		
		# Node Panel Button
		var node_box = PanelContainer.new()
		node_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var nb_style = StyleBoxFlat.new()
		if is_owned:
			nb_style.bg_color = Color(0.08, 0.18, 0.12, 0.95)
			nb_style.border_color = Color(0.3, 0.9, 0.4)
		else:
			nb_style.bg_color = Color(0.07, 0.09, 0.13, 0.95)
			nb_style.border_color = Color(0.25, 0.35, 0.45)
		nb_style.border_width_left = 1
		nb_style.border_width_top = 1
		nb_style.border_width_right = 1
		nb_style.border_width_bottom = 1
		nb_style.corner_radius_top_left = 4
		nb_style.corner_radius_top_right = 4
		nb_style.corner_radius_bottom_left = 4
		nb_style.corner_radius_bottom_right = 4
		nb_style.content_margin_left = 4
		nb_style.content_margin_right = 4
		nb_style.content_margin_top = 3
		nb_style.content_margin_bottom = 3
		node_box.add_theme_stylebox_override("panel", nb_style)
		row_h.add_child(node_box)
		
		var node_h = HBoxContainer.new()
		node_h.add_theme_constant_override("separation", 6)
		node_box.add_child(node_h)
		
		var icon_path = "res://assets/icons/items/item_%d.png" % c_item.id
		if ResourceLoader.exists(icon_path):
			var tr = TextureRect.new()
			tr.custom_minimum_size = Vector2(20, 20)
			tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
			tr.texture = load(icon_path)
			node_h.add_child(tr)
			
		var name_lbl = Label.new()
		name_lbl.text = c_item.item_name
		name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_lbl.add_theme_font_size_override("font_size", 9)
		name_lbl.add_theme_color_override("font_color", Color(0.9, 0.95, 1.0) if not is_owned else Color(0.5, 1.0, 0.6))
		node_h.add_child(name_lbl)
		
		var cost_lbl = Label.new()
		cost_lbl.text = "%d" % c_item.cost
		cost_lbl.add_theme_font_size_override("font_size", 9)
		cost_lbl.add_theme_color_override("font_color", Color(1.0, 0.85, 0.25))
		node_h.add_child(cost_lbl)
		
		if is_owned:
			var ow_lbl = Label.new()
			ow_lbl.text = "✓"
			ow_lbl.add_theme_font_size_override("font_size", 9)
			ow_lbl.add_theme_color_override("font_color", Color(0.3, 1.0, 0.4))
			node_h.add_child(ow_lbl)
			
		var click_btn = Button.new()
		click_btn.set_anchors_preset(Control.PRESET_FULL_RECT)
		click_btn.flat = true
		node_box.add_child(click_btn)
		
		click_btn.mouse_entered.connect(func(): _on_item_hover(c_item, true, node_box))
		click_btn.mouse_exited.connect(func(): _on_item_hover(c_item, false))
		click_btn.gui_input.connect(func(ev): _on_item_gui_input(ev, c_item))
		
		# Recursive children
		if c_item.is_recipe():
			_build_recursive_tree_nodes(c_item, container, depth + 1)

func _create_builds_into_card(container: Control, item: ItemResource) -> void:
	var card = PanelContainer.new()
	var c_style = StyleBoxFlat.new()
	c_style.bg_color = Color(0.08, 0.10, 0.14, 0.95)
	c_style.border_width_left = 1
	c_style.border_width_top = 1
	c_style.border_width_right = 1
	c_style.border_width_bottom = 1
	c_style.border_color = Color(0.30, 0.45, 0.60)
	c_style.corner_radius_top_left = 4
	c_style.corner_radius_top_right = 4
	c_style.corner_radius_bottom_left = 4
	c_style.corner_radius_bottom_right = 4
	c_style.content_margin_left = 6
	c_style.content_margin_right = 6
	c_style.content_margin_top = 4
	c_style.content_margin_bottom = 4
	card.add_theme_stylebox_override("panel", c_style)
	container.add_child(card)
	
	var h = HBoxContainer.new()
	h.add_theme_constant_override("separation", 6)
	card.add_child(h)
	
	var icon_path = "res://assets/icons/items/item_%d.png" % item.id
	if ResourceLoader.exists(icon_path):
		var tr = TextureRect.new()
		tr.custom_minimum_size = Vector2(22, 22)
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		tr.texture = load(icon_path)
		h.add_child(tr)
		
	var name_lbl = Label.new()
	name_lbl.text = item.item_name
	name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_lbl.add_theme_font_size_override("font_size", 9)
	name_lbl.add_theme_color_override("font_color", Color(0.9, 0.95, 1.0))
	h.add_child(name_lbl)
	
	var cost_lbl = Label.new()
	cost_lbl.text = "💰%d" % item.cost
	cost_lbl.add_theme_font_size_override("font_size", 9)
	cost_lbl.add_theme_color_override("font_color", Color(1.0, 0.85, 0.25))
	h.add_child(cost_lbl)
	
	var btn = Button.new()
	btn.set_anchors_preset(Control.PRESET_FULL_RECT)
	btn.flat = true
	card.add_child(btn)
	
	btn.mouse_entered.connect(func(): _on_item_hover(item, true, card))
	btn.mouse_exited.connect(func(): _on_item_hover(item, false))
	btn.gui_input.connect(func(ev): _on_item_gui_input(ev, item))

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
	box.custom_minimum_size = Vector2(58, 54)
	
	var b_style = StyleBoxFlat.new()
	b_style.bg_color = Color(0.08, 0.10, 0.14, 0.98)
	b_style.border_width_left = 1
	b_style.border_width_top = 1
	b_style.border_width_right = 1
	b_style.border_width_bottom = 1
	
	var tier_col = Color(0.5, 0.55, 0.65)
	if item.cost >= 5000:
		tier_col = Color(1.0, 0.82, 0.20)
	elif item.cost >= 3800:
		tier_col = Color(0.80, 0.35, 0.95)
	elif item.cost >= 2200:
		tier_col = Color(0.25, 0.65, 1.0)
	elif item.cost >= 1000:
		tier_col = Color(0.25, 0.85, 0.45)
	b_style.border_color = tier_col
	b_style.corner_radius_top_left = 4
	b_style.corner_radius_top_right = 4
	b_style.corner_radius_bottom_left = 4
	b_style.corner_radius_bottom_right = 4
	box.add_theme_stylebox_override("panel", b_style)
	parent.add_child(box)
	
	var icon_path = "res://assets/icons/items/item_%d.png" % item.id
	if ResourceLoader.exists(icon_path):
		var tex_rect = TextureRect.new()
		tex_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
		tex_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		tex_rect.texture = load(icon_path)
		tex_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		box.add_child(tex_rect)
		
		var cost_bg = PanelContainer.new()
		cost_bg.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
		var c_style = StyleBoxFlat.new()
		c_style.bg_color = Color(0.0, 0.0, 0.0, 0.75)
		cost_bg.add_theme_stylebox_override("panel", c_style)
		box.add_child(cost_bg)
		
		var cost_lbl = Label.new()
		cost_lbl.text = "%d" % item.cost
		cost_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		cost_lbl.add_theme_font_size_override("font_size", 8)
		cost_lbl.add_theme_color_override("font_color", Color(1.0, 0.88, 0.25))
		cost_bg.add_child(cost_lbl)
	else:
		var vbox = VBoxContainer.new()
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		vbox.add_theme_constant_override("separation", 2)
		box.add_child(vbox)
		
		var glyph_lbl = Label.new()
		glyph_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		glyph_lbl.add_theme_font_size_override("font_size", 13)
		if item.is_boots():
			glyph_lbl.text = "👟"
		elif item.cost >= 3500:
			glyph_lbl.text = "⚔️"
		elif item.category == ItemResource.Category.SUPPORT:
			glyph_lbl.text = "🧪"
		else:
			glyph_lbl.text = "🛡️"
		vbox.add_child(glyph_lbl)
		
		var name_lbl = Label.new()
		name_lbl.text = item.item_name.substr(0, 5)
		name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		name_lbl.add_theme_font_size_override("font_size", 8)
		name_lbl.add_theme_color_override("font_color", Color(0.9, 0.95, 1.0))
		vbox.add_child(name_lbl)
		
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
			# LEFT-CLICK: Select and display recipe tree & queue to quick buy
			select_item(item)
			quick_buy_queued.emit(item)
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("AĞAÇ SEÇİLDİ: %s" % item.item_name.to_upper())

func _buy_item(item: ItemResource) -> void:
	if target_hero != null and target_hero.inventory_manager != null:
		var ok = target_hero.inventory_manager.buy_item(item, func(id): return Database.get_item(id))
		if ok:
			item_purchased.emit(item)
			if selected_item != null:
				_populate_recipe_tree(selected_item)
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("MARKET: %s SATIN ALINDI (💰 %d)" % [item.item_name.to_upper(), item.cost])
		elif Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("MARKET: %s SATIN ALINAMADI — %s" % [item.item_name.to_upper(), target_hero.inventory_manager.last_purchase_failure_reason])

func _on_item_hover(item: ItemResource, is_hover: bool, btn_control: Control = null) -> void:
	if item_tooltip != null:
		if is_hover:
			item_tooltip.show_item(item)
			if btn_control != null and is_instance_valid(btn_control):
				var g_pos = btn_control.global_position
				var tt_w = item_tooltip.size.x if item_tooltip.size.x > 0 else 240.0
				var tt_h = item_tooltip.size.y if item_tooltip.size.y > 0 else 140.0
				var target_x = g_pos.x + btn_control.size.x + 8
				if target_x + tt_w > 1880:
					target_x = g_pos.x - tt_w - 8
				var target_y = clampf(g_pos.y - 10, 20, 1080 - tt_h - 20)
				item_tooltip.global_position = Vector2(clampf(target_x, 20, 1600), target_y)
		else:
			item_tooltip.hide_tooltip()

func _build_pin_bar(parent: Control) -> void:
	var pin_ids: Array[int] = [1, 2, 3, 4, 8]
	for id in pin_ids:
		var it = Database.get_item(id) if is_instance_valid(Database) else null
		if it != null:
			_create_item_box(parent, it)
