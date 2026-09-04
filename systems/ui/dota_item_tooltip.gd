class_name DotaItemTooltip
extends PanelContainer

## Compact & Sleek MOBA Item Tooltip Floating Card
## Shows item name, cost, category, stats, active/passive effects, and recipe parts concisely.

var item_name_label: Label = null
var item_cost_label: Label = null
var category_label: Label = null

var stats_vbox: VBoxContainer = null
var active_vbox: VBoxContainer = null
var passive_vbox: VBoxContainer = null
var desc_label: Label = null
var recipe_vbox: VBoxContainer = null

func _init() -> void:
	mouse_filter = MOUSE_FILTER_IGNORE
	custom_minimum_size = Vector2(240, 0)
	z_index = 60
	visible = false
	_build_ui()

func _build_ui() -> void:
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.06, 0.08, 0.11, 0.95) # Deep Obsidian Night
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color(0.0, 0.86, 0.95, 0.35) # Electric Cyan Glow
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.shadow_size = 10
	style.shadow_color = Color(0, 0, 0, 0.8)
	style.content_margin_left = 10
	style.content_margin_right = 10
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	add_theme_stylebox_override("panel", style)
	
	var main_v = VBoxContainer.new()
	main_v.add_theme_constant_override("separation", 4)
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
	item_name_label.add_theme_font_size_override("font_size", 12)
	item_name_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
	title_vbox.add_child(item_name_label)
	
	category_label = Label.new()
	category_label.text = "TEMEL EŞYA"
	category_label.add_theme_font_size_override("font_size", 9)
	category_label.add_theme_color_override("font_color", Color(0.55, 0.65, 0.75))
	title_vbox.add_child(category_label)
	
	item_cost_label = Label.new()
	item_cost_label.text = "450g"
	item_cost_label.add_theme_font_size_override("font_size", 12)
	item_cost_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.25))
	header_h.add_child(item_cost_label)
	
	var sep1 = ColorRect.new()
	sep1.custom_minimum_size = Vector2(0, 1)
	sep1.color = Color(0.18, 0.25, 0.35, 0.5)
	main_v.add_child(sep1)
	
	# 2. Stat Bonuses List
	stats_vbox = VBoxContainer.new()
	stats_vbox.add_theme_constant_override("separation", 2)
	main_v.add_child(stats_vbox)
	
	# 3. Active Ability Block
	active_vbox = VBoxContainer.new()
	active_vbox.add_theme_constant_override("separation", 2)
	main_v.add_child(active_vbox)
	
	# 4. Passive Effects Block
	passive_vbox = VBoxContainer.new()
	passive_vbox.add_theme_constant_override("separation", 2)
	main_v.add_child(passive_vbox)
	
	# 5. Description / Flavor Text
	desc_label = Label.new()
	desc_label.text = ""
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_label.add_theme_font_size_override("font_size", 9)
	desc_label.add_theme_color_override("font_color", Color(0.75, 0.82, 0.90))
	main_v.add_child(desc_label)
	
	# 6. Recipe Components (if any)
	recipe_vbox = VBoxContainer.new()
	recipe_vbox.add_theme_constant_override("separation", 2)
	main_v.add_child(recipe_vbox)

func show_item(item: ItemResource, slot_hotkey: String = "", cooldown_remaining: float = 0.0) -> void:
	if item == null:
		hide_tooltip()
		return
		
	visible = true
	item_name_label.text = item.item_name.to_upper()
	item_cost_label.text = "%dg" % item.cost
	
	match item.category:
		ItemResource.Category.BASE:
			category_label.text = "TEMEL EŞYA"
		ItemResource.Category.BOOTS:
			category_label.text = "ÇİZME"
		ItemResource.Category.INTERMEDIATE:
			category_label.text = "GELİŞMİŞ EŞYA"
		ItemResource.Category.LEGENDARY:
			category_label.text = "EFSANEVİ"
		ItemResource.Category.SUPPORT:
			category_label.text = "DESTEK"
		_:
			category_label.text = "EŞYA"
			
	# Clear old stat list
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
				lbl.add_theme_font_size_override("font_size", 9)
				lbl.add_theme_color_override("font_color", Color(0.35, 0.95, 0.60))
				stats_vbox.add_child(lbl)
				
	# Clear & populate Active block
	for c in active_vbox.get_children():
		c.queue_free()
		
	var has_active = _has_usable_active(item)
	if has_active:
		var act_hdr = Label.new()
		var aname = item.active_name if not item.active_name.is_empty() else "Aktif"
		var cd_str = " (%ds)" % int(item.active_cooldown) if item.active_cooldown > 0 else ""
		var action = _format_active_tag(item.active_action_tag, item.id)
		var target = _format_target_mode(_get_target_mode(item))
		var key_hint = " [%s]" % slot_hotkey if not slot_hotkey.is_empty() else ""
		var state = "Hazır" if cooldown_remaining <= 0.0 else "%.1fs bekleme" % cooldown_remaining
		act_hdr.text = "[AKTİF%s] %s%s\nHedef: %s • %s\n%s" % [key_hint, aname, cd_str, target, state, action]
		act_hdr.add_theme_font_size_override("font_size", 9)
		act_hdr.add_theme_color_override("font_color", Color(1.0, 0.82, 0.30))
		act_hdr.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		active_vbox.add_child(act_hdr)
		var use_hint = Label.new()
		use_hint.text = "Sağ tık / kısayol: kullan • Hedefte sol tık onay, sağ tık iptal"
		use_hint.add_theme_font_size_override("font_size", 8)
		use_hint.add_theme_color_override("font_color", Color(0.62, 0.72, 0.82))
		use_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		active_vbox.add_child(use_hint)
		
	# Clear & populate Passive block
	for c in passive_vbox.get_children():
		c.queue_free()
		
	var has_passives = not item.item_tags.is_empty()
	if has_passives:
		for tag in item.item_tags:
			var p_lbl = Label.new()
			p_lbl.text = "[Pasif] %s" % _format_passive_tag(tag)
			p_lbl.add_theme_font_size_override("font_size", 9)
			p_lbl.add_theme_color_override("font_color", Color(0.45, 0.85, 1.0))
			p_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			passive_vbox.add_child(p_lbl)
				
	if item.description != "":
		desc_label.text = item.description
		desc_label.visible = true
	else:
		desc_label.text = ""
		desc_label.visible = false
	
	# Clear old recipe
	for c in recipe_vbox.get_children():
		c.queue_free()
		
	if item.is_recipe():
		var r_hdr = Label.new()
		r_hdr.text = "Bileşenler:"
		r_hdr.add_theme_font_size_override("font_size", 9)
		r_hdr.add_theme_color_override("font_color", Color(0.70, 0.80, 0.90))
		recipe_vbox.add_child(r_hdr)
		
		for sub_id in item.recipe_components:
			var sub_item = Database.get_item(sub_id) if is_instance_valid(Database) else null
			var sub_lbl = Label.new()
			if sub_item != null:
				sub_lbl.text = "  + %s (%dg)" % [sub_item.item_name, sub_item.cost]
			else:
				sub_lbl.text = "  + Parça #%d" % sub_id
			sub_lbl.add_theme_font_size_override("font_size", 9)
			sub_lbl.add_theme_color_override("font_color", Color(0.80, 0.85, 0.90))
			recipe_vbox.add_child(sub_lbl)

func hide_tooltip() -> void:
	visible = false

func _has_usable_active(item: ItemResource) -> bool:
	return not item.active_action_tag.is_empty() or item.id in [73, 74, 83, 114, 115, 118, 119]

func _get_target_mode(item: ItemResource) -> String:
	match item.active_action_tag:
		"ACTIVE_BLINK": return "ground"
		"ACTIVE_CYCLONE", "ACTIVE_HEX", "ACTIVE_EXECUTION", "ACTIVE_SILENCE": return "enemy"
		"ACTIVE_BARRIER", "ACTIVE_BURST_HEAL", "ACTIVE_HEAL": return "ally"
		"ACTIVE_FORCE_STAFF": return "unit"
	match item.id:
		74: return "enemy"
		114, 115: return "ally"
		118: return "ground"
	return "self"

func _format_target_mode(mode: String) -> String:
	match mode:
		"enemy": return "Düşman"
		"ally": return "Dost"
		"unit": return "Birim"
		"ground": return "Zemin"
		_: return "Kendin"

func _format_active_tag(act: String, item_id: int = -1) -> String:
	match act:
		"ACTIVE_BURST_HEAL": return "300 Can iyileştirir."
		"ACTIVE_BARRIER": return "350 puan kalkan açar."
		"ACTIVE_CYCLONE": return "Hedefi 2.5s havaya kaldırır."
		"ACTIVE_EXECUTION": return "180 + %20 eksik can gerçek hasar vurur."
		"ACTIVE_FORCE_STAFF": return "Hedefi 6m ileri iter."
		"ACTIVE_HEX": return "Hedefi 2.8s yaratığa dönüştürür."
		"ACTIVE_SPELL_IMMUNITY": return "6s büyü bağışıklığı sağlar."
		"ACTIVE_TRUE_SIGHT_DUST": return "Görünmezleri açığa çıkarır."
		_:
			match item_id:
				73: return "5sn boyunca saldırı hızını artırır."
				74: return "Eksik cana göre gerçek hasar verir."
				83: return "Olumsuz etkileri temizler, hız kazandırır."
				114: return "Dostu iyileştirir."
				115: return "Dosta geçici kalkan verir."
				118: return "Seçilen yöne ilerler."
				119: return "Yetenek bekleme sürelerini azaltır."
			return "Aktif etki uygular."

func _format_passive_tag(tag: String) -> String:
	match tag:
		"ON_HIT_BLEED": return "Kanama: Vuruşlar %20 fiziksel DoT uygular."
		"ON_HIT_SLOW": return "Dondurucu: Vuruşlar %25 yavaşlatır."
		"ON_HIT_MANA_BURN": return "Mana Yakma: 35 mana yakar ve hasar verir."
		"ON_HIT_CHAIN_LIGHTNING": return "Şimşek: %25 şansla 140 büyü zincirleme hasar."
		"DEFENSIVE_THORNS": return "Dikenli Zırh: Alınan normal hasarın %20'sini yansıtır."
		"DEFENSIVE_LIFELINE": return "Can Simidi: Can <%30 iken 300 kalkan açar."
		"ON_KILL_HEAL": return "Ruh Sömürüsü: Katletmede 100 + %5 Max HP iyileştirir."
		"HYBRID_HP_TO_AD": return "Dev Gücü: Max Canın %2'sini AD yapar."
		"HYBRID_MANA_TO_AP": return "Zihin Kudreti: Max Mananın %3'ünü AP yapar."
		"HYBRID_ARMOR_TO_REGEN": return "Çelik Beden: Zırhın %10'unu Can Yenilemesi yapar."
		_: return tag

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
			return "%s%d Büyü Direnci" % [prefix, int(val)]
		StatModifier.TargetStat.ATTACK_SPEED:
			return "%s%d%% Saldırı Hızı" % [prefix, int(val * 100)]
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
		StatModifier.TargetStat.CRIT_CHANCE:
			return "%s%d%% Kritik Şansı" % [prefix, int(val * 100)]
		StatModifier.TargetStat.COOLDOWN_REDUCTION:
			return "%s%d%% Bekleme Süresi Azaltma" % [prefix, int(val * 100)]
		StatModifier.TargetStat.LIFESTEAL:
			return "%s%d%% Can Çalma" % [prefix, int(val * 100)]
		StatModifier.TargetStat.SPELL_VAMP:
			return "%s%d%% Büyü Vampirliği" % [prefix, int(val * 100)]
		StatModifier.TargetStat.ARMOR_PEN_FLAT:
			return "%s%d Zırh Delme" % [prefix, int(val)]
		StatModifier.TargetStat.ARMOR_PEN_PERCENT:
			return "%s%d%% Zırh Delme" % [prefix, int(val * 100)]
		StatModifier.TargetStat.MAGIC_PEN_FLAT:
			return "%s%d Büyü Delme" % [prefix, int(val)]
		StatModifier.TargetStat.MAGIC_PEN_PERCENT:
			return "%s%d%% Büyü Delme" % [prefix, int(val * 100)]
		_:
			return "%s%.1f Stat" % [prefix, val]
