class_name NixeToxicCocoon3D
extends Node3D

## 3D Wrapped Spider Web Cocoon on R (Toxic Cocoon)

var duration: float = 2.0
var timer: float = 2.0

func setup(victim_pos: Vector3, dur: float = 2.0) -> void:
	duration = dur
	timer = dur
	global_position = victim_pos
	
	var cocoon = MeshInstance3D.new()
	var capsule = CapsuleMesh.new()
	capsule.radius = 0.70
	capsule.height = 2.2
	cocoon.mesh = capsule
	cocoon.position.y = 1.0
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.85, 0.90, 0.75, 0.85)
	mat.emission_enabled = true
	mat.emission = Color(0.40, 0.85, 0.30)
	mat.emission_energy_multiplier = 2.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	cocoon.material_override = mat
	add_child(cocoon)
	
	var tw = create_tween()
	if tw != null:
		tw.tween_interval(dur - 0.4)
		tw.parallel().tween_property(mat, "albedo_color:a", 0.0, 0.4)
		tw.chain().tween_callback(queue_free)

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0.0:
		queue_free()
