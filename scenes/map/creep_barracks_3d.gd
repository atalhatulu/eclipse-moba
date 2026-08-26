class_name CreepBarracks3D
extends LaneMinionSpawner

## Physical 3D In-World Barracks / Portal Structure that spawns and marshals lane minion waves

var _portal_mesh: MeshInstance3D = null
var _crystal_light: OmniLight3D = null

func _ready() -> void:
	if has_node("PortalGate"):
		_portal_mesh = get_node("PortalGate") as MeshInstance3D
	elif has_node("BarracksVisual/PortalGate"):
		_portal_mesh = get_node("BarracksVisual/PortalGate") as MeshInstance3D
	if has_node("OmniLight3D"):
		_crystal_light = get_node("OmniLight3D") as OmniLight3D
	super._ready()

func _create_barracks_visuals() -> void:
	if not has_node("BarracksVisual"):
		var root_vis = Node3D.new()
		root_vis.name = "BarracksVisual"
		add_child(root_vis)
		
		# 1. Base Stone Foundation (Kışla Taş Temeli)
		var base = MeshInstance3D.new()
		var b_box = BoxMesh.new()
		b_box.size = Vector3(4.5, 0.4, 3.5)
		base.mesh = b_box
		base.position.y = 0.2
		
		var stone_mat = StandardMaterial3D.new()
		stone_mat.albedo_color = Color(0.16, 0.18, 0.20, 1.0) if team == TeamDefinitions.Team.RADIANT else Color(0.22, 0.14, 0.14, 1.0)
		stone_mat.roughness = 0.85
		base.material_override = stone_mat
		root_vis.add_child(base)
		
		# 2. Left and Right Guard Pillars (Nöbetçi Sütunları)
		for side in [-1.8, 1.8]:
			var pillar = MeshInstance3D.new()
			var p_cyl = CylinderMesh.new()
			p_cyl.top_radius = 0.45
			p_cyl.bottom_radius = 0.55
			p_cyl.height = 3.2
			pillar.mesh = p_cyl
			pillar.position = Vector3(0.0, 1.6, side)
			pillar.material_override = stone_mat
			root_vis.add_child(pillar)
			
			# Pillar Capstone Gem
			var gem = MeshInstance3D.new()
			var g_sphere = SphereMesh.new()
			g_sphere.radius = 0.25
			g_sphere.height = 0.5
			gem.mesh = g_sphere
			gem.position = Vector3(0.0, 3.3, side)
			
			var gem_mat = StandardMaterial3D.new()
			gem_mat.albedo_color = Color(0.2, 0.85, 0.4) if team == TeamDefinitions.Team.RADIANT else Color(0.95, 0.25, 0.25)
			gem_mat.emission_enabled = true
			gem_mat.emission = gem_mat.albedo_color
			gem_mat.emission_energy_multiplier = 2.0
			gem.material_override = gem_mat
			root_vis.add_child(gem)
			
		# 3. Center Arch & Glowing Portal Gate (Sihirli Minyon Kapısı)
		_portal_mesh = MeshInstance3D.new()
		var gate_box = BoxMesh.new()
		gate_box.size = Vector3(0.3, 2.6, 2.6)
		_portal_mesh.mesh = gate_box
		_portal_mesh.position = Vector3(0.0, 1.5, 0.0)
		
		var portal_mat = StandardMaterial3D.new()
		var p_color = Color(0.25, 0.90, 0.45, 0.85) if team == TeamDefinitions.Team.RADIANT else Color(0.95, 0.30, 0.25, 0.85)
		portal_mat.albedo_color = p_color
		portal_mat.emission_enabled = true
		portal_mat.emission = p_color
		portal_mat.emission_energy_multiplier = 2.5
		portal_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		_portal_mesh.material_override = portal_mat
		root_vis.add_child(_portal_mesh)
		
		# 4. Portal Ambient Light
		_crystal_light = OmniLight3D.new()
		_crystal_light.light_color = p_color
		_crystal_light.light_energy = 2.0
		_crystal_light.omni_range = 6.0
		_crystal_light.position = Vector3(0.0, 1.8, 0.0)
		root_vis.add_child(_crystal_light)

func spawn_wave() -> void:
	# Visual Spawn Gate Pulse on Wave Departure
	_play_spawn_pulse()
	super.spawn_wave()

func _play_spawn_pulse() -> void:
	if _portal_mesh != null and is_inside_tree():
		var tween = create_tween()
		tween.tween_property(_portal_mesh, "scale", Vector3(1.2, 1.25, 1.2), 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(_portal_mesh, "scale", Vector3.ONE, 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
