class_name MatchResultUI
extends Control

## Victory / Defeat Match End Summary Modal for Eclipse Front

signal play_again_requested()
signal main_menu_requested()

@onready var title_label: Label = null
@onready var subtitle_label: Label = null
@onready var stats_container: VBoxContainer = null

var btn_play_again: Button = null
var btn_main_menu: Button = null

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	visible = false
	_build_ui()

func _build_ui() -> void:
	# Dark semi-transparent background overlay
	var bg = ColorRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.color = Color(0.02, 0.03, 0.05, 0.88)
	add_child(bg)
	
	# Center Card Panel
	var center_panel = PanelContainer.new()
	center_panel.set_anchors_preset(Control.PRESET_CENTER)
	center_panel.custom_minimum_size = Vector2(480, 420)
	center_panel.offset_left = -240
	center_panel.offset_right = 240
	center_panel.offset_top = -210
	center_panel.offset_bottom = 210
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.10, 0.14, 0.98)
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.25, 0.30, 0.40, 1.0)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 24
	style.content_margin_right = 24
	style.content_margin_top = 24
	style.content_margin_bottom = 24
	center_panel.add_theme_stylebox_override("panel", style)
	add_child(center_panel)
	
	var vbox = VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 16)
	center_panel.add_child(vbox)
	
	# Title
	title_label = Label.new()
	title_label.text = "VICTORY"
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.add_theme_font_size_override("font_size", 32)
	title_label.add_theme_color_override("font_color", Color(0.2, 0.9, 0.4))
	vbox.add_child(title_label)
	
	# Subtitle
	subtitle_label = Label.new()
	subtitle_label.text = "Ancient Core Destroyed"
	subtitle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle_label.add_theme_font_size_override("font_size", 14)
	subtitle_label.add_theme_color_override("font_color", Color(0.7, 0.75, 0.85))
	vbox.add_child(subtitle_label)
	
	# Stats Grid Container
	stats_container = VBoxContainer.new()
	stats_container.add_theme_constant_override("separation", 6)
	vbox.add_child(stats_container)
	
	# Buttons HBox
	var btn_hbox = HBoxContainer.new()
	btn_hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	btn_hbox.add_theme_constant_override("separation", 16)
	vbox.add_child(btn_hbox)
	
	btn_play_again = Button.new()
	btn_play_again.text = "[ YENİDEN OYNA ]"
	btn_play_again.custom_minimum_size = Vector2(160, 40)
	btn_play_again.pressed.connect(func(): play_again_requested.emit())
	btn_hbox.add_child(btn_play_again)
	
	btn_main_menu = Button.new()
	btn_main_menu.text = "[ ÇIKIŞ ]"
	btn_main_menu.custom_minimum_size = Vector2(120, 40)
	btn_main_menu.pressed.connect(func(): main_menu_requested.emit())
	btn_hbox.add_child(btn_main_menu)

func show_match_result(stats: Dictionary) -> void:
	var is_victory = stats.get("is_victory", true)
	if is_victory:
		title_label.text = "ZAFER (VICTORY)"
		title_label.add_theme_color_override("font_color", Color(0.25, 0.95, 0.45))
		subtitle_label.text = "Düşman Kadim Çekirdeği Yok Edildi!"
	else:
		title_label.text = "YENİLGİ (DEFEAT)"
		title_label.add_theme_color_override("font_color", Color(0.95, 0.25, 0.25))
		subtitle_label.text = "Kadim Çekirdeğiniz Yok Edildi!"
		
	# Clear old stats
	for child in stats_container.get_children():
		child.queue_free()
		
	var match_secs = int(stats.get("match_time", 0.0))
	var mins = match_secs / 60
	var secs = match_secs % 60
	
	_add_stat_row("Maç Süresi:", "%02d:%02d" % [mins, secs])
	_add_stat_row("Skor (Leş / Ölüm):", "%d / %d" % [stats.get("kills", 0), stats.get("deaths", 0)])
	_add_stat_row("Kazanılan Altın:", "%dg" % stats.get("gold_earned", 600))
	_add_stat_row("Kahraman Seviyesi:", "Lv. %d" % stats.get("hero_level", 1))
	_add_stat_row("Yıkılan Kuleler:", "%d / 6" % stats.get("towers_destroyed", 0))
	
	visible = true

func _add_stat_row(label_text: String, value_text: String) -> void:
	var hbox = HBoxContainer.new()
	
	var lbl = Label.new()
	lbl.text = label_text
	lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lbl.add_theme_font_size_override("font_size", 13)
	lbl.add_theme_color_override("font_color", Color(0.7, 0.75, 0.8))
	hbox.add_child(lbl)
	
	var val = Label.new()
	val.text = value_text
	val.add_theme_font_size_override("font_size", 13)
	val.add_theme_color_override("font_color", Color(1.0, 0.9, 0.3))
	hbox.add_child(val)
	
	stats_container.add_child(hbox)
