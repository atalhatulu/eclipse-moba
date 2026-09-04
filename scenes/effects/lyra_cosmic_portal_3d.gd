class_name LyraCosmicPortal3D
extends Node3D

## Swirling Celestial Portal on R (Cosmic Relocate)

var duration: float = 3.5
var timer: float = 3.5

func setup(pos: Vector3, dur: float = 3.5) -> void:
	duration = dur
	timer = dur
	global_position = pos
	
	var ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 1.8
	torus.outer_radius = 2.2
	ring.mesh = torus
	ring.position.y = 0.1
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.30, 0.95, 0.80, 0.85)
	mat.emission_enabled = true
	mat.emission = Color(0.40, 1.0, 0.85)
	mat.emission_energy_multiplier = 3.5
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring.material_override = mat
	add_child(ring)
	
	var tw = create_tween()
	if tw != null:
		tw.tween_interval(dur - 0.5)
		tw.parallel().tween_property(mat, "albedo_color:a", 0.0, 0.5)
		tw.chain().tween_callback(queue_free)

func _process(delta: float) -> void:
	timer -= delta
	rotate_y(2.0 * delta)
	if timer <= 0.0:
		queue_free()
