class_name SelkaCataclysmBeam3D
extends Node3D

## Dark violet tether chain linking cursed enemies together on R (Cataclysm)

var duration: float = 5.0
var timer: float = 5.0
var target_a: BaseCombatEntity = null
var target_b: BaseCombatEntity = null
var beam_mesh: MeshInstance3D = null

func setup(a: BaseCombatEntity, b: BaseCombatEntity, dur: float = 5.0) -> void:
	target_a = a
	target_b = b
	duration = dur
	timer = dur
	
	beam_mesh = MeshInstance3D.new()
	var cyl = CylinderMesh.new()
	cyl.top_radius = 0.12
	cyl.bottom_radius = 0.12
	beam_mesh.mesh = cyl
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.7, 0.15, 0.85, 0.85)
	mat.emission_enabled = true
	mat.emission = Color(0.85, 0.2, 1.0)
	mat.emission_energy_multiplier = 3.0
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	beam_mesh.material_override = mat
	add_child(beam_mesh)

func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0.0 or not is_instance_valid(target_a) or not is_instance_valid(target_b) or not target_a.is_alive() or not target_b.is_alive():
		queue_free()
		return
		
	var pos_a = target_a.global_position if target_a.is_inside_tree() else target_a.position
	var pos_b = target_b.global_position if target_b.is_inside_tree() else target_b.position
	var dist = pos_a.distance_to(pos_b)
	
	global_position = (pos_a + pos_b) * 0.5
	if beam_mesh != null and beam_mesh.mesh is CylinderMesh:
		(beam_mesh.mesh as CylinderMesh).height = dist
		if dist > 0.01:
			look_at(pos_b, Vector3.UP)
			rotate_object_local(Vector3.RIGHT, deg_to_rad(90.0))
