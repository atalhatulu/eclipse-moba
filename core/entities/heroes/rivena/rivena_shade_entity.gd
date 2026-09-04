class_name RivenaShadeEntity
extends Node3D

## 3D Shadow Echo Clone for Rivena (AGI Assassin)
## Renders a translucent amethyst shadow silhouette with glowing violet eyes, twin scythes, and synchronized attack animations.

signal shade_expired()

var owner_hero: HeroEntity = null
var lifespan: float = 5.0
var life_timer: float = 5.0

var visual_root: Node3D = null
var body_mesh: MeshInstance3D = null
var scythe_left: MeshInstance3D = null
var scythe_right: MeshInstance3D = null

func _ready() -> void:
	_build_visuals()

func setup_shade(hero: HeroEntity, duration: float = 5.0) -> void:
	owner_hero = hero
	lifespan = duration
	life_timer = duration
	
	if hero != null and not hero.died.is_connected(_on_owner_died):
		hero.died.connect(_on_owner_died)
		
	# Scale in spawn tween
	if visual_root != null:
		visual_root.scale = Vector3(0.01, 0.01, 0.01)
		var tw = create_tween()
		if tw != null:
			tw.tween_property(visual_root, "scale", Vector3.ONE, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _build_visuals() -> void:
	visual_root = Node3D.new()
	visual_root.name = "ShadeVisual"
	add_child(visual_root)
	
	# Shadow Body Capsule
	body_mesh = MeshInstance3D.new()
	var cap = CapsuleMesh.new()
	cap.radius = 0.44
	cap.height = 1.90
	body_mesh.mesh = cap
	body_mesh.position.y = 0.95
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.20, 0.05, 0.35, 0.70) # Translucent Shadow Violet
	mat.emission_enabled = true
	mat.emission = Color(0.45, 0.15, 0.75)
	mat.emission_energy_multiplier = 0.6
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.roughness = 0.3
	body_mesh.material_override = mat
	visual_root.add_child(body_mesh)
	
	# Twin Shadow Scythes
	var s_mat = StandardMaterial3D.new()
	s_mat.albedo_color = Color(0.65, 0.20, 0.95, 0.85)
	s_mat.emission_enabled = true
	s_mat.emission = Color(0.70, 0.25, 1.0)
	s_mat.emission_energy_multiplier = 1.5
	s_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	
	scythe_left = MeshInstance3D.new()
	var s_box = BoxMesh.new()
	s_box.size = Vector3(0.06, 0.90, 0.25)
	scythe_left.mesh = s_box
	scythe_left.position = Vector3(-0.45, 0.90, 0.35)
	scythe_left.rotation_degrees = Vector3(25, 0, -10)
	scythe_left.material_override = s_mat
	visual_root.add_child(scythe_left)
	
	scythe_right = MeshInstance3D.new()
	scythe_right.mesh = s_box
	scythe_right.position = Vector3(0.45, 0.90, 0.35)
	scythe_right.rotation_degrees = Vector3(25, 0, 10)
	scythe_right.material_override = s_mat
	visual_root.add_child(scythe_right)
	
	# Base Shadow Void Ring
	var ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 0.75
	torus.outer_radius = 0.85
	ring.mesh = torus
	ring.position.y = 0.04
	var r_mat = StandardMaterial3D.new()
	r_mat.albedo_color = Color(0.5, 0.1, 0.8, 0.8)
	r_mat.emission_enabled = true
	r_mat.emission = Color(0.5, 0.1, 0.8)
	r_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring.material_override = r_mat
	visual_root.add_child(ring)

func play_synchronized_slash(target_pos: Vector3) -> void:
	_rotate_towards(target_pos)
	if visual_root != null:
		var tw = create_tween()
		if tw != null:
			tw.tween_property(visual_root, "position:z", 0.4, 0.08).set_trans(Tween.TRANS_QUAD)
			tw.tween_property(visual_root, "position:z", 0.0, 0.12).set_trans(Tween.TRANS_QUAD)

func _physics_process(delta: float) -> void:
	life_timer -= delta
	if life_timer <= 0.0:
		_expire_shade()

func _rotate_towards(t_pos: Vector3) -> void:
	var dir = t_pos - global_position
	dir.y = 0.0
	if dir.length_squared() > 0.01:
		rotation.y = atan2(dir.x, dir.z)

func _expire_shade() -> void:
	shade_expired.emit()
	if visual_root != null:
		var tw = create_tween()
		if tw != null:
			tw.tween_property(visual_root, "scale", Vector3(0.01, 0.01, 0.01), 0.15).set_trans(Tween.TRANS_QUAD)
			tw.tween_callback(queue_free)
		else:
			queue_free()
	else:
		queue_free()

func _on_owner_died(_hero: BaseCombatEntity, _killer: String) -> void:
	_expire_shade()
