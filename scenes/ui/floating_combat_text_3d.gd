class_name FloatingCombatText3D
extends Node3D

## Visual 3D floating damage and heal numbers popping over units

var text: String = ""
var text_color: Color = Color.WHITE
var is_crit: bool = false
var _label: Label3D = null

func setup(p_text: String, p_color: Color, p_pos: Vector3, p_crit: bool = false) -> void:
	text = p_text
	text_color = p_color
	is_crit = p_crit
	global_position = p_pos + Vector3(randf_range(-0.4, 0.4), 1.6, randf_range(-0.4, 0.4))
	
	_create_label()
	_animate()

func _create_label() -> void:
	_label = Label3D.new()
	_label.text = text
	_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	_label.no_depth_test = true
	_label.font_size = 48 if is_crit else 34
	_label.outline_size = 10
	_label.outline_modulate = Color.BLACK
	_label.modulate = text_color
	add_child(_label)

func _animate() -> void:
	var tween = create_tween()
	tween.set_parallel(true)
	# Rise up smoothly
	tween.tween_property(self, "global_position:y", global_position.y + 1.8, 0.75).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	# Fade out
	tween.tween_property(_label, "modulate:a", 0.0, 0.75).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.chain().tween_callback(queue_free)
