class_name TacticalPingSystem
extends Node

## Tactical MOBA Ping System for map communication (Danger, On My Way, Retreat, Missing)

enum PingType {
	DANGER,
	ON_MY_WAY,
	RETREAT,
	MISSING
}

signal ping_triggered(type: PingType, position: Vector3, sender: String)

static var _instance: TacticalPingSystem = null

static func get_instance() -> TacticalPingSystem:
	return _instance

func _ready() -> void:
	_instance = self

static func trigger_ping(parent: Node3D, world_pos: Vector3, type: PingType = PingType.DANGER, sender_name: String = "Oyuncu") -> Node3D:
	if parent == null:
		return null
		
	var ping_node = Node3D.new()
	ping_node.name = "TacticalPingMarker"
	ping_node.position = world_pos + Vector3(0, 0.1, 0)
	parent.add_child(ping_node)
	
	var col: Color = Color(0.95, 0.20, 0.20)
	var type_name = "TEHLİKE"
	
	match type:
		PingType.DANGER:
			col = Color(0.95, 0.20, 0.20)
			type_name = "TEHLİKE!"
		PingType.ON_MY_WAY:
			col = Color(0.25, 0.65, 1.0)
			type_name = "YOLDAYIM"
		PingType.RETREAT:
			col = Color(1.0, 0.85, 0.20)
			type_name = "GERİ ÇEKİL"
		PingType.MISSING:
			col = Color(0.75, 0.35, 0.95)
			type_name = "KAYIP DÜŞMAN (SS)"
			
	# 1. Pulsing Ground Ring
	var ring = MeshInstance3D.new()
	var torus = TorusMesh.new()
	torus.inner_radius = 1.2
	torus.outer_radius = 1.5
	ring.mesh = torus
	ring.rotation_degrees.x = 90.0
	
	var mat = StandardMaterial3D.new()
	mat.albedo_color = col
	mat.emission_enabled = true
	mat.emission = col
	mat.emission_energy_multiplier = 2.0
	ring.material_override = mat
	ping_node.add_child(ring)
	
	# 2. Vertical Light Pillar
	var pillar = MeshInstance3D.new()
	var cyl = CylinderMesh.new()
	cyl.top_radius = 0.15
	cyl.bottom_radius = 0.4
	cyl.height = 4.0
	pillar.mesh = cyl
	pillar.position.y = 2.0
	pillar.material_override = mat
	ping_node.add_child(pillar)
	
	# Auto remove after 3.5 seconds
	if ping_node.is_inside_tree():
		var tree = ping_node.get_tree()
		if tree != null:
			var timer = tree.create_timer(3.5)
			timer.timeout.connect(ping_node.queue_free)
		
	if Engine.has_singleton("SoundManager") or is_instance_valid(SoundManager):
		var sfx_key = "ping_danger" if type == PingType.DANGER or type == PingType.RETREAT else "ping_on_my_way"
		SoundManager.play_3d_sfx(sfx_key, world_pos)
		
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("[%s]: %s (%.0f, %.0f)" % [sender_name, type_name, world_pos.x, world_pos.z])
		
	return ping_node
