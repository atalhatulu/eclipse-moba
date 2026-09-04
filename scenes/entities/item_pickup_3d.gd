class_name ItemPickup3D
extends Area3D

## 3D World Drop / Pickup Item Entity for Eclipse Front
## Renders floating glowing item crystal/box with label and handles hero pickup interactions.

signal picked_up(by_entity: BaseCombatEntity)

@export var item_data: ItemResource = null
@export var pickup_radius: float = 2.5
@export var auto_pickup_distance: float = 2.0

var _visual_mesh: MeshInstance3D = null
var _label_3d: Label3D = null
var _omni_light: OmniLight3D = null
var _base_y: float = 0.0
var _anim_time: float = 0.0

func _ready() -> void:
	# Pickups need a layer to be selectable by the player's Area3D ray query.
	collision_layer = 1
	collision_mask = 2 # Hero layer
	monitoring = true
	monitorable = true
	add_to_group("world_item_pickups")
	
	if get_child_count() == 0 or not has_node("CollisionShape3D"):
		var col = CollisionShape3D.new()
		col.name = "CollisionShape3D"
		var shape = SphereShape3D.new()
		shape.radius = pickup_radius
		col.shape = shape
		add_child(col)
		
	body_entered.connect(_on_body_entered)
	_build_visuals()
	_base_y = position.y

func _build_visuals() -> void:
	if _visual_mesh != null:
		_visual_mesh.queue_free()
	if _omni_light != null:
		_omni_light.queue_free()
	if _label_3d != null:
		_label_3d.queue_free()

	# 1. Hovering Crystal Mesh
	_visual_mesh = MeshInstance3D.new()
	var prism = BoxMesh.new()
	prism.size = Vector3(0.6, 0.6, 0.6)
	_visual_mesh.mesh = prism
	_visual_mesh.position.y = 0.6
	
	var mat = StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	var col = Color(0.0, 0.86, 0.95) # Cyan default
	if item_data != null:
		if item_data.cost >= 3000:
			col = Color(1.0, 0.73, 0.13) # Solar Gold
		elif item_data.cost >= 1500:
			col = Color(0.7, 0.3, 1.0) # Purple Tier
	mat.albedo_color = col
	mat.emission_enabled = true
	mat.emission = col
	mat.emission_energy_multiplier = 3.0
	_visual_mesh.material_override = mat
	add_child(_visual_mesh)
	
	# 2. Glowing Light
	_omni_light = OmniLight3D.new()
	_omni_light.light_color = col
	_omni_light.light_energy = 2.5
	_omni_light.omni_range = 4.0
	_omni_light.position.y = 0.6
	add_child(_omni_light)
	
	# 3. 3D Floating Nameplate
	_label_3d = Label3D.new()
	_label_3d.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	_label_3d.no_depth_test = true
	_label_3d.font_size = 18
	_label_3d.modulate = col
	_label_3d.outline_modulate = Color(0, 0, 0, 1)
	_label_3d.outline_size = 4
	_label_3d.position.y = 1.3
	if item_data != null:
		_label_3d.text = "%s\n(%d Altın)" % [item_data.item_name, item_data.cost]
	else:
		_label_3d.text = "Eşya"
	add_child(_label_3d)

func init_item(p_item: ItemResource, p_pos: Vector3) -> void:
	item_data = p_item
	position = p_pos
	_base_y = p_pos.y
	_build_visuals()

func _process(delta: float) -> void:
	_anim_time += delta
	# Floating bob and rotation
	if _visual_mesh != null:
		_visual_mesh.rotation.y += delta * 1.5
		_visual_mesh.rotation.x += delta * 0.8
		_visual_mesh.position.y = 0.6 + sin(_anim_time * 3.0) * 0.15
	if _label_3d != null:
		_label_3d.position.y = 1.3 + sin(_anim_time * 3.0) * 0.05

func _on_body_entered(body: Node) -> void:
	if body is BaseCombatEntity and body.is_alive():
		try_pickup(body)

func try_pickup(hero: BaseCombatEntity) -> bool:
	if hero == null or item_data == null:
		return false
	if hero.inventory_manager == null:
		return false
		
	var inv: InventoryManager = hero.inventory_manager
	if not inv.has_empty_normal_slot() and not (item_data.is_boots() and inv.boots_slot == null):
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("ENVANTER DOLU: %s ALINAMADI" % item_data.item_name.to_upper())
		return false
		
	var success = inv.equip_item(item_data)
	if success:
		picked_up.emit(hero)
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("EŞYA YERDEN ALINDI: %s" % item_data.item_name.to_upper())
		queue_free()
		return true
	return false
