class_name HeroAnimator3D
extends Node

## Procedural 3D Skeletal & Locomotion Animation System for MOBA Heroes
## Controls Idle breathing, Run step bobbing & torso lean, Attack lunges, Spell casts & Death collapse.

@export var is_floating_hero: bool = false
@export var run_frequency: float = 12.0
@export var run_bob_height: float = 0.08
@export var lean_amount: float = 0.12

var hero: HeroEntity = null
var visual_root: Node3D = null

var _anim_time: float = 0.0
var _is_attacking: bool = false
var _is_casting: bool = false
var _is_dead: bool = false
var _initial_visual_y: float = 0.0

func _ready() -> void:
	var parent = get_parent()
	if parent is HeroEntity:
		hero = parent
		_find_or_bind_visual_root()
		
		# Connect to combat events
		if hero.has_signal("died"):
			hero.died.connect(_on_hero_died)
		if hero.has_signal("hero_respawned"):
			hero.hero_respawned.connect(_on_hero_respawned)

func _find_or_bind_visual_root() -> void:
	if hero == null:
		return
	# Search for any visual node or create one
	for child in hero.get_children():
		if child is Node3D and child.name.ends_with("Visual"):
			visual_root = child
			_initial_visual_y = visual_root.position.y
			break
			
	if visual_root == null:
		# Fallback to first Node3D child that is not a collision shape or camera
		for child in hero.get_children():
			if child is Node3D and not (child is CollisionShape3D or child is Camera3D or child is Marker3D):
				visual_root = child
				_initial_visual_y = visual_root.position.y
				break

func _process(delta: float) -> void:
	if hero == null or _is_dead:
		return
		
	if visual_root == null or not is_instance_valid(visual_root):
		_find_or_bind_visual_root()
		if visual_root == null:
			return
			
	_anim_time += delta
	
	if _is_attacking or _is_casting:
		return
		
	var speed = hero.velocity.length()
	
	if speed > 0.2:
		# --- RUNNING LOCOMOTION ANIMATION ---
		var move_ratio = clampf(speed / 7.0, 0.5, 1.5)
		var bob = absf(sin(_anim_time * run_frequency * move_ratio)) * run_bob_height
		visual_root.position.y = _initial_visual_y + bob
		
		# Lean forward in moving direction
		visual_root.rotation.x = -lean_amount * move_ratio
		visual_root.rotation.z = sin(_anim_time * (run_frequency * 0.5) * move_ratio) * 0.05
	else:
		# --- IDLE BREATHING / FLOATING ANIMATION ---
		if is_floating_hero:
			var hover = sin(_anim_time * 2.5) * 0.15 + 0.2
			visual_root.position.y = _initial_visual_y + hover
			visual_root.rotation.z = sin(_anim_time * 1.2) * 0.03
			visual_root.rotation.x = sin(_anim_time * 1.5) * 0.02
		else:
			var breath = sin(_anim_time * 2.2) * 0.03
			visual_root.position.y = _initial_visual_y + breath
			visual_root.rotation.x = lerpf(visual_root.rotation.x, 0.0, delta * 8.0)
			visual_root.rotation.z = lerpf(visual_root.rotation.z, 0.0, delta * 8.0)

## Play melee slash or ranged thrust attack animation
func play_attack_motion(target_world_pos: Vector3, duration: float = 0.35) -> void:
	if visual_root == null or not is_instance_valid(visual_root) or _is_dead:
		return
		
	_is_attacking = true
	var forward_dir = Vector3.FORWARD
	if hero != null:
		forward_dir = -hero.global_transform.basis.z
		
	var tween = create_tween()
	if tween != null:
		# Lunge forward
		var orig_pos = visual_root.position
		var lunge_offset = Vector3(0, 0, -0.4)
		tween.tween_property(visual_root, "position", orig_pos + lunge_offset, duration * 0.4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(visual_root, "rotation:x", -0.2, duration * 0.4)
		# Recover
		tween.tween_property(visual_root, "position", orig_pos, duration * 0.6).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween.parallel().tween_property(visual_root, "rotation:x", 0.0, duration * 0.6)
		tween.tween_callback(func(): _is_attacking = false)
	else:
		_is_attacking = false

## Play spell casting animation (raise arms / glow)
func play_cast_motion(duration: float = 0.4) -> void:
	if visual_root == null or not is_instance_valid(visual_root) or _is_dead:
		return
		
	_is_casting = true
	var orig_pos = visual_root.position
	var tween = create_tween()
	if tween != null:
		# Jump up / levitate slightly during cast
		tween.tween_property(visual_root, "position:y", orig_pos.y + 0.35, duration * 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(visual_root, "position:y", orig_pos.y, duration * 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween.tween_callback(func(): _is_casting = false)
	else:
		_is_casting = false

## Play death animation
func _on_hero_died() -> void:
	_is_dead = true
	if visual_root == null or not is_instance_valid(visual_root):
		return
		
	var tween = create_tween()
	if tween != null:
		# Fall backward and collapse
		tween.tween_property(visual_root, "rotation:x", PI * 0.45, 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(visual_root, "position:y", -0.3, 0.5)

## Reset on respawn
func _on_hero_respawned() -> void:
	_is_dead = false
	_is_attacking = false
	_is_casting = false
	if visual_root != null and is_instance_valid(visual_root):
		visual_root.position.y = _initial_visual_y
		visual_root.rotation = Vector3.ZERO
