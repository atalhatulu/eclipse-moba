class_name ClickMarker3D
extends Node3D

## Visual 3D feedback ring for MOBA right-click movement and attack commands

var lifetime: float = 0.5
var timer: float = 0.0
var ring_mesh: MeshInstance3D = null
var mat: StandardMaterial3D = null

func setup(color: Color, is_attack: bool = false) -> void:
	ring_mesh = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 0.4 if not is_attack else 0.5
	torus.outer_radius = 0.55 if not is_attack else 0.7
	ring_mesh.mesh = torus
	
	mat = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = color
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	ring_mesh.material_override = mat
	
	add_child(ring_mesh)
	position.y += 0.05

func _process(delta: float) -> void:
	timer += delta
	var progress = timer / lifetime
	if progress >= 1.0:
		queue_free()
		return
		
	# Expand and fade
	var scale_factor = 1.0 + (progress * 0.4)
	scale = Vector3(scale_factor, 1.0, scale_factor)
	if mat != null:
		mat.albedo_color.a = 1.0 - progress
