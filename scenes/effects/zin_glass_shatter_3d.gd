class_name ZinGlassShatter3D
extends Node3D

## Shattered glass shards burst on W / E

func _ready() -> void:
	_create_shards()

func _create_shards() -> void:
	for i in range(6):
		var shard = MeshInstance3D.new()
		var box = BoxMesh.new()
		box.size = Vector3(0.20, 0.45, 0.05)
		shard.mesh = box
		var angle = (float(i) / 6.0) * TAU
		shard.position = Vector3(cos(angle) * 1.5, 0.8, sin(angle) * 1.5)
		shard.rotation.y = angle
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.85, 0.95, 1.0, 0.9)
		mat.metallic = 0.90
		mat.emission_enabled = true
		mat.emission = Color(0.6, 0.9, 1.0)
		mat.emission_energy_multiplier = 3.0
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		shard.material_override = mat
		add_child(shard)
		
		var tw = create_tween()
		if tw != null:
			tw.set_parallel(true)
			tw.tween_property(shard, "position", Vector3(cos(angle) * 3.5, 0.4, sin(angle) * 3.5), 0.25)
			tw.tween_property(mat, "albedo_color:a", 0.0, 0.25)
			
	var end_tw = create_tween()
	if end_tw != null:
		end_tw.tween_interval(0.30)
		end_tw.tween_callback(queue_free)
	else:
		queue_free()
