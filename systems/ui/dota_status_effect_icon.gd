class_name DotaStatusEffectIcon
extends Control

## Authentic Dota 2 Status Effect & Passive Badge Icon (not.png reference)
## Features circular dark badge, colored glowing status ring (Green=Buff, Red=Debuff, Cyan=Passive),
## radial duration arc, centered/bottom stack counter number (e.g. 4), and rich hover tooltip.

var effect_id: String = ""
var display_name: String = ""
var description_text: String = ""
var is_debuff: bool = false
var is_passive: bool = false
var duration: float = -1.0
var remaining_time: float = -1.0
var stacks: int = 1
var icon_symbol: String = "✦"
var ring_color: Color = Color(0.25, 0.85, 0.35) # Green by default

var tooltip_panel: PanelContainer = null
var stack_label: Label = null
var symbol_label: Label = null

func _init() -> void:
	custom_minimum_size = Vector2(34, 34)
	mouse_filter = MOUSE_FILTER_PASS
	_setup_stack_label()

func _setup_stack_label() -> void:
	symbol_label = Label.new()
	symbol_label.set_anchors_preset(PRESET_FULL_RECT)
	symbol_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	symbol_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	symbol_label.add_theme_font_size_override("font_size", 17)
	symbol_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	symbol_label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 1.0))
	symbol_label.add_theme_constant_override("outline_size", 4)
	symbol_label.mouse_filter = MOUSE_FILTER_IGNORE
	add_child(symbol_label)

	stack_label = Label.new()
	stack_label.set_anchors_preset(PRESET_BOTTOM_RIGHT)
	stack_label.offset_left = -16
	stack_label.offset_top = -15
	stack_label.offset_right = -1
	stack_label.offset_bottom = -1
	stack_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stack_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	stack_label.add_theme_font_size_override("font_size", 11)
	stack_label.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
	stack_label.add_theme_color_override("font_outline_color", Color(0.0, 0.0, 0.0, 1.0))
	stack_label.add_theme_constant_override("outline_size", 3)
	stack_label.mouse_filter = MOUSE_FILTER_IGNORE
	add_child(stack_label)

func configure(p_id: String, p_name: String, p_desc: String, p_is_debuff: bool, p_dur: float, p_rem: float, p_stacks: int, p_symbol: String = "", p_is_passive: bool = false) -> void:
	effect_id = p_id
	display_name = p_name
	description_text = p_desc
	is_debuff = p_is_debuff
	is_passive = p_is_passive
	duration = p_dur
	remaining_time = p_rem
	stacks = p_stacks
	icon_symbol = p_symbol if p_symbol != "" else ("▼" if is_debuff else "▲")
	
	if is_debuff:
		ring_color = Color(0.95, 0.25, 0.25, 1.0) # Red
	elif is_passive:
		ring_color = Color(0.35, 0.85, 1.0, 1.0) # Cyan/Blue
	else:
		ring_color = Color(0.28, 0.90, 0.35, 1.0) # Green (as in not.png)
		
	# The center glyph is always visible. Stacks sit above it without hiding the
	# icon, which matters most for short-lived combat controls.
	symbol_label.text = icon_symbol
	# Stacks text
	if stacks > 1:
		stack_label.text = "x" + str(stacks)
	else:
		stack_label.text = ""
		
	_update_tooltip()
	queue_redraw()

func play_entry_animation() -> void:
	if not is_inside_tree():
		return
	var intro = create_tween()
	intro.set_parallel(true)
	intro.tween_property(self, "modulate:a", 1.0, 0.16).from(0.0)
	intro.tween_property(self, "scale", Vector2.ONE, 0.18).from(Vector2(0.55, 0.55)).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _update_tooltip() -> void:
	var type_str = "OLUMSUZ ETKİ (DEBUFF)" if is_debuff else ("PASİF ETKİ" if is_passive else "GÜÇLENDİRME (BUFF)")
	var dur_str = "Süre: %.1fs" % maxf(0.0, remaining_time) if duration > 0.0 else "Kalıcı / Pasif"
	var stack_str = " | Yığın: %d" % stacks if stacks > 1 else ""
	
	tooltip_text = "%s [%s]\n%s%s\n\n%s" % [display_name, type_str, dur_str, stack_str, description_text]

func _draw() -> void:
	var center = size * 0.5
	var radius = (minf(size.x, size.y) * 0.5) - 2.0
	
	# 1. Dark circular background
	draw_circle(center, radius, Color(0.06, 0.08, 0.11, 0.95))
	
	# 2. Inner subtle glow
	draw_circle(center, radius - 2.0, Color(ring_color.r * 0.15, ring_color.g * 0.15, ring_color.b * 0.15, 0.8))
	
	# 3. Outer ring border
	if duration > 0.0 and remaining_time > 0.0:
		# Draw radial sweep arc based on remaining time percentage
		var pct = clampf(remaining_time / duration, 0.0, 1.0)
		var start_angle = -PI * 0.5
		var end_angle = start_angle + (TAU * pct)
		draw_arc(center, radius, 0.0, TAU, 32, Color(0.15, 0.18, 0.22, 0.8), 2.0, true)
		draw_arc(center, radius, start_angle, end_angle, 32, ring_color, 2.5, true)
	else:
		# Full solid glowing ring
		draw_arc(center, radius, 0.0, TAU, 32, ring_color, 2.2, true)
		
	# Outer subtle dark bevel
	draw_arc(center, radius + 1.0, 0.0, TAU, 32, Color(0.0, 0.0, 0.0, 0.8), 1.0, true)
	# Stack badge remains readable without covering the central effect symbol.
	if stacks > 1:
		var badge_center = Vector2(size.x - 7.0, size.y - 7.0)
		draw_circle(badge_center, 8.0, Color(0.04, 0.05, 0.07, 0.96))
		draw_arc(badge_center, 8.0, 0.0, TAU, 16, ring_color, 1.2, true)
