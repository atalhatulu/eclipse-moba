class_name DotaItemTooltip
extends PanelContainer

## Authentic Dota 2 Item Tooltip Floating Card (market.png reference)
## Shows item icon, name, cost, category, attribute bonuses, active/passive effects, and recipe parts.

var item_name_label: Label = null
var item_cost_label: Label = null
var category_label: Label = null

var stats_vbox: VBoxContainer = null
var desc_label: Label = null
var recipe_vbox: VBoxContainer = null

func _init() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	custom_minimum_size = Vector2(290, 0)
	visible = false
	_build_ui()

func _build_ui() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.06, 0.08, 0.12, 0.98) # Deep Obsidian
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.3, 0.45, 0.62, 1.0) # Steel Slate Blue
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_left = 6
	style.corner_radius_bottom_right = 6
	style.shadow_size = 8
	style.shadow_color = Color(0, 0, 0, 0.7)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	add_theme_stylebox_override("panel", style)
	
	var main_v = VBoxContainer.new()
	main_v.add_theme_constant_override("separation", 6)
	add_child(main_v)
	
	# 1. Header (Name, Category, Gold Cost)
	var header_h = HBoxContainer.new()
	header_h.add_theme_constant_override("separation", 8)
	main_v.add_child(header_h)
	
	var title_vbox = VBoxContainer.new()
	title_vbox.size_flags_horizontal = SIZE_EXPAND_FILL
	title_vbox.add_theme_constant_override("separation", 1)
	header_h.add_child(title_vbox)
	
	item_name_label = Label.new()
	item_name_label.text = "ITEM NAME"
	item_name_label.add_theme_font_size_override("font_size", 13)
	item_name_label.add_theme_color_override("font_color", Color(1.0, 0.95, 0.85))
	title_vbox.add_child(item_name_label)
	
	category_label = Label.new()
	category_label.text = "TEMEL EŞYA"
	category_label.add_theme_font_size_override("font_size", 9)
	category_label.add_theme_color_override("font_color", Color(0.55, 0.65, 0.75))
	title_vbox.add_child(category_label)
	
	item_cost_label = Label.new()
	item_cost_label.text = "💰 450"
	item_cost_label.add_theme_font_size_override("font_size", 13)
	item_cost_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.25))
	header_h.add_child(item_cost_label)
	
	var sep1 = ColorRect.new()
	sep1.custom_minimum_size = Vector2(0, 1)
	sep1.color = Color(0.25, 0.35, 0.45, 0.6)
	main_v.add_child(sep1)
	
	# 2. Stat Bonuses List
	stats_vbox = VBoxContainer.new()
	stats_vbox.add_theme_constant_override("separation", 2)
	main_v.add_child(stats_vbox)
	
	# 3. Active / Passive Description
	desc_label = Label.new()
	desc_label.text = ""
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_label.add_theme_font_size_override("font_size", 10)
	desc_label.add_theme_color_override("font_color", Color(0.85, 0.90, 0.95))
	main_v.add_child(desc_label)
	
	# 4. Recipe Components (if any)
	recipe_vbox = VBoxContainer.new()
	recipe_vbox.add_theme_constant_override("separation", 2)
	main_v.add_child(recipe_vbox)

func show_item(item: ItemResource) -> void:
	if item == null:
		hide_tooltip()
		return
		
	visible = true
	item_name_label.text = item.item_name.to_upper()
	item_cost_label.text = "💰 %d" % item.cost
	
	match item.category:
		ItemResource.Category.BASE:
			category_label.text = "TEMEL EŞYA"
		ItemResource.Category.BOOTS:
			category_label.text = "ÇİZME / HAREKET"
		ItemResource.Category.INTERMEDIATE:
			category_label.text = "GELİŞMİŞ EŞYA"
		ItemResource.Category.LEGENDARY:
			category_label.text = "EFSANEVİ EŞYA"
		ItemResource.Category.SUPPORT:
			category_label.text = "DESTEK / TÜKETİLEBİLİR"
		_:
			category_label.text = "EŞYA"
			
	# Clear old stats
	for c in stats_vbox.get_children():
		c.queue_free()
		
	# Populate stat bonuses
	if item.stat_bonuses != null and item.stat_bonuses.size() > 0:
		for stat_enum in item.stat_bonuses.keys():
			var val = item.stat_bonuses[stat_enum]
			var stat_str = _format_stat_bonus(stat_enum, val)
			if stat_str != "":
				var lbl = Label.new()
				lbl.text = stat_str
				lbl.add_theme_font_size_override("font_size", 10)
				lbl.add_theme_color_override("font_color", Color(0.4, 0.95, 0.6))
				stats_vbox.add_child(lbl)
				
	desc_label.text = item.description if item.description != "" else ""
	desc_label.visible = (item.description != "")
	
	# Clear old recipe
	for c in recipe_vbox.get_children():
		c.queue_free()
		
	if item.is_recipe():
		var r_hdr = Label.new()
		r_hdr.text = "📦 BİLEŞENLER:"
		r_hdr.add_theme_font_size_override("font_size", 9)
		r_hdr.add_theme_color_override("font_color", Color(0.7, 0.8, 0.9))
		recipe_vbox.add_child(r_hdr)
		
		for sub_id in item.recipe_components:
			var sub_item = Database.get_item(sub_id) if is_instance_valid(Database) else null
			var sub_lbl = Label.new()
			if sub_item != null:
				sub_lbl.text = "  + %s (💰 %d)" % [sub_item.item_name, sub_item.cost]
			else:
				sub_lbl.text = "  + Parça #%d" % sub_id
			sub_lbl.add_theme_font_size_override("font_size", 9)
			sub_lbl.add_theme_color_override("font_color", Color(0.85, 0.88, 0.92))
			recipe_vbox.add_child(sub_lbl)

func hide_tooltip() -> void:
	visible = false

func _format_stat_bonus(stat_enum: StatModifier.TargetStat, val: float) -> String:
	var prefix = "+" if val >= 0 else ""
	match stat_enum:
		StatModifier.TargetStat.ATTACK_DAMAGE:
			return "%s%d Saldırı Gücü" % [prefix, int(val)]
		StatModifier.TargetStat.ABILITY_POWER:
			return "%s%d Yetenek Gücü" % [prefix, int(val)]
		StatModifier.TargetStat.ARMOR:
			return "%s%.1f Zırh" % [prefix, val]
		StatModifier.TargetStat.MAGIC_RESIST:
			return "%s%d%% Büyü Direnci" % [prefix, int(val)]
		StatModifier.TargetStat.ATTACK_SPEED:
			return "%s%d Saldırı Hızı" % [prefix, int(val * 100)]
		StatModifier.TargetStat.MOVE_SPEED:
			return "%s%d Hareket Hızı" % [prefix, int(val)]
		StatModifier.TargetStat.MAX_HEALTH:
			return "%s%d Can" % [prefix, int(val)]
		StatModifier.TargetStat.HEALTH_REGEN:
			return "%s%.1f Can Yenileme" % [prefix, val]
		StatModifier.TargetStat.MAX_MANA:
			return "%s%d Mana" % [prefix, int(val)]
		StatModifier.TargetStat.MANA_REGEN:
			return "%s%.1f Mana Yenileme" % [prefix, val]
		StatModifier.TargetStat.STRENGTH:
			return "%s%d Güç (STR)" % [prefix, int(val)]
		StatModifier.TargetStat.AGILITY:
			return "%s%d Çeviklik (AGI)" % [prefix, int(val)]
		StatModifier.TargetStat.INTELLIGENCE:
			return "%s%d Zeka (INT)" % [prefix, int(val)]
		StatModifier.TargetStat.CRIT_CHANCE:
			return "%s%d%% Kritik Şansı" % [prefix, int(val * 100)]
		StatModifier.TargetStat.LIFESTEAL:
			return "%s%d%% Can Çalma" % [prefix, int(val * 100)]
		_:
			return "%s%.1f Stat" % [prefix, val]
