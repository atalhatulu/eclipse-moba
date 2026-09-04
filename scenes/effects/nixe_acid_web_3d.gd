class_name NixeAcidWeb3D
extends Node3D

## 3D Spider Web on W (Acid Web)

var duration: float = 4.0
var timer: float = 4.0

func setup(pos: Vector3, radius: float = 4.5) -> void:
	global_position = pos
	
	var web_ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = radius - 0.3
	torus.outer_radius = radius + 0.3
	web_ring.mesh = torus
	web_ring.position.y = 0.05
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.35, 0.85, 0.20, 0.75)
	mat.emission_enabled = true
	mat.emission = Color(0.40, 0.90, 0.25)
	mat.emission_energy_multiplier = 2.5
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	web_ring.material_override = mat
	add_child(web_ring)
	
	var tw = create_tween()
	if tw != null:
		tw.tween_interval(3.2)
		tw.parallel().tween_property(mat, "albedo_color:a", 0.0, 0.8)
		tw.chain().tween_callback(queue_free)

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0.0:
		queue_free()
