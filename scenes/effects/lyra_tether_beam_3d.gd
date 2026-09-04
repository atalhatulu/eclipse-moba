class_name LyraTetherBeam3D
extends Node3D

## Dynamic glowing cyan/emerald beam line connecting Lyra to Tethered Ally

var target_node: Node3D = null
var source_node: Node3D = null
var line_mesh: MeshInstance3D = null

func setup(src: Node3D, tgt: Node3D) -> void:
	source_node = src
	target_node = tgt
	
	line_mesh = MeshInstance3D.new()
	var cyl = CylinderMesh.new()
	cyl.top_radius = 0.08
	cyl.bottom_radius = 0.08
	cyl.height = 1.0
	line_mesh.mesh = cyl
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.20, 0.95, 0.85, 0.90) # Astral Cyan
	mat.emission_enabled = true
	mat.emission = Color(0.30, 1.0, 0.90)
	mat.emission_energy_multiplier = 4.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	line_mesh.material_override = mat
	add_child(line_mesh)

func _process(_delta: float) -> void:
	if source_node == null or target_node == null or not is_instance_valid(source_node) or not is_instance_valid(target_node):
		queue_free()
		return
		
	var s_pos = source_node.global_position if source_node.is_inside_tree() else source_node.position
	var t_pos = target_node.global_position if target_node.is_inside_tree() else target_node.position
	s_pos.y += 1.0
	t_pos.y += 1.0
	
	var diff = t_pos - s_pos
	var dist = diff.length()
	if dist < 0.1 or dist > 18.0:
		queue_free()
		return
		
	global_position = (s_pos + t_pos) * 0.5
	line_mesh.scale.y = dist
	
	var up = Vector3.UP
	if absf(diff.normalized().dot(up)) > 0.99:
		up = Vector3.RIGHT
	look_at(t_pos, up)
	rotate_object_local(Vector3.RIGHT, deg_to_rad(90))
