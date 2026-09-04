class_name GerasTectonicFissure3D
extends Node3D

## 14m Long Jagged Tectonic Fault Line Ravine on R (Tectonic Fissure)

var duration: float = 5.0
var timer: float = 5.0

func setup(start_pos: Vector3, end_pos: Vector3, dur: float = 5.0) -> void:
	duration = dur
	timer = dur
	global_position = (start_pos + end_pos) * 0.5
	var diff = end_pos - start_pos
	var length = diff.length()
	if length > 0.1:
		rotation.y = atan2(diff.x, diff.z)
		
	# 14m long stone fault line
	var fissure = MeshInstance3D.new()
	var box = BoxMesh.new()
	box.size = Vector3(1.8, 0.4, length)
	fissure.mesh = box
	fissure.position.y = 0.2
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.30, 0.20, 0.15, 0.95)
	mat.emission_enabled = true
	mat.emission = Color(0.95, 0.45, 0.10) # Molten Earth Glow
	mat.emission_energy_multiplier = 3.5
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	fissure.material_override = mat
	add_child(fissure)
	
	var tw = create_tween()
	if tw != null:
		tw.tween_interval(dur - 0.8)
		tw.parallel().tween_property(mat, "albedo_color:a", 0.0, 0.8)
		tw.chain().tween_callback(queue_free)

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0.0:
		queue_free()
