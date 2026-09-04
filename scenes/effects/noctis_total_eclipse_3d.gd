class_name NoctisTotalEclipse3D
extends Node3D

## Pitch-black spherical shadow dome covering the area on R (Total Eclipse)

var duration: float = 5.0
var timer: float = 5.0

func setup(center_pos: Vector3, dur: float = 5.0) -> void:
	duration = dur
	timer = dur
	global_position = center_pos
	
	# Expanding Darkness Dome (14m radius)
	var dome = MeshInstance3D.new()
	var sphere = SphereMesh.new()
	sphere.radius = 14.0
	sphere.height = 28.0
	dome.mesh = sphere
	dome.position.y = 2.0
	
	var mat = StandardMaterial3D.new()
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	mat.albedo_color = Color(0.02, 0.01, 0.05, 0.75)
	mat.emission_enabled = true
	mat.emission = Color(0.15, 0.05, 0.25)
	mat.emission_energy_multiplier = 1.2
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	dome.material_override = mat
	add_child(dome)
	
	var tw = create_tween()
	if tw != null:
		tw.tween_interval(dur - 0.8)
		tw.parallel().tween_property(mat, "albedo_color:a", 0.0, 0.8)
		tw.chain().tween_callback(queue_free)

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0.0:
		queue_free()
