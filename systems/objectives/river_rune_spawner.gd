class_name RiverRuneSpawner
extends Node3D

## Spawns Power Runes (Double Damage, Haste, Invisibility, Arcane, Regen) every 120 seconds in the river.

enum RuneType {
	DOUBLE_DAMAGE,
	HASTE,
	INVISIBILITY,
	ARCANE,
	REGENERATION
}

signal rune_spawned(type: RuneType, location: Vector3)
signal rune_collected(hero: HeroEntity, type: RuneType)

@export var spawn_interval_sec: float = 120.0 # 2 minutes
@export var current_rune_type: int = -1 # -1 if unspawned
var active_rune_node: Area3D = null

func _ready() -> void:
	_spawn_random_rune()

func _spawn_random_rune() -> void:
	if active_rune_node != null and is_instance_valid(active_rune_node):
		active_rune_node.queue_free()
		
	var r_type = randi() % 5 as RuneType
	current_rune_type = r_type
	
	active_rune_node = Area3D.new()
	active_rune_node.name = "ActiveRune"
	
	var col = CollisionShape3D.new()
	var sphere = SphereShape3D.new()
	sphere.radius = 1.8
	col.shape = sphere
	active_rune_node.add_child(col)
	
	var mesh_inst = MeshInstance3D.new()
	var prism = PrismMesh.new()
	prism.size = Vector3(0.8, 1.2, 0.8)
	mesh_inst.mesh = prism
	
	var mat = StandardMaterial3D.new()
	match r_type:
		RuneType.DOUBLE_DAMAGE: mat.albedo_color = Color(0.2, 0.4, 0.95) # Royal Blue
		RuneType.HASTE: mat.albedo_color = Color(0.95, 0.2, 0.2) # Crimson Red
		RuneType.INVISIBILITY: mat.albedo_color = Color(0.7, 0.2, 0.95) # Violet
		RuneType.ARCANE: mat.albedo_color = Color(0.95, 0.4, 0.8) # Arcane Magenta
		RuneType.REGENERATION: mat.albedo_color = Color(0.2, 0.95, 0.3) # Emerald Green
		
	mat.emission_enabled = true
	mat.emission = mat.albedo_color
	mat.emission_energy_multiplier = 2.0
	mesh_inst.material_override = mat
	active_rune_node.add_child(mesh_inst)
	
	add_child(active_rune_node)
	active_rune_node.body_entered.connect(_on_body_entered)
	rune_spawned.emit(r_type, global_position)

func _on_body_entered(body: Node3D) -> void:
	if body is HeroEntity and is_instance_valid(body) and body.is_alive():
		consume_rune(body)

func consume_rune(hero: HeroEntity) -> void:
	if current_rune_type == -1:
		return
		
	var r_type = current_rune_type as RuneType
	current_rune_type = -1
	
	if active_rune_node != null and is_instance_valid(active_rune_node):
		active_rune_node.queue_free()
		active_rune_node = null
		
	_apply_rune_buff(hero, r_type)
	rune_collected.emit(hero, r_type)
	
	# Schedule next spawn
	var tree = get_tree()
	if tree != null:
		tree.create_timer(spawn_interval_sec).timeout.connect(_spawn_random_rune)

func _apply_rune_buff(hero: HeroEntity, r_type: RuneType) -> void:
	if hero.attribute_system == null:
		return
		
	match r_type:
		RuneType.DOUBLE_DAMAGE:
			var mod = StatModifier.new(StatModifier.TargetStat.ATTACK_DAMAGE, StatModifier.Type.PERCENT_ADD, 1.0, "rune_double_damage")
			hero.attribute_system.add_modifier(mod)
			_schedule_buff_removal(hero, "rune_double_damage", 45.0)
			
		RuneType.HASTE:
			var mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.PERCENT_ADD, 0.70, "rune_haste")
			hero.attribute_system.add_modifier(mod)
			_schedule_buff_removal(hero, "rune_haste", 30.0)
			
		RuneType.INVISIBILITY:
			hero.visible = false
			_schedule_buff_removal(hero, "rune_invisibility", 45.0, func(): if is_instance_valid(hero): hero.visible = true)
			
		RuneType.ARCANE:
			var mod = StatModifier.new(StatModifier.TargetStat.COOLDOWN_REDUCTION, StatModifier.Type.FLAT, 0.30, "rune_arcane")
			hero.attribute_system.add_modifier(mod)
			_schedule_buff_removal(hero, "rune_arcane", 50.0)
			
		RuneType.REGENERATION:
			hero.attribute_system.heal(hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH) * 0.50)
			hero.attribute_system.restore_mana(hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA) * 0.50)

func _schedule_buff_removal(hero: HeroEntity, source_tag: String, duration: float, on_remove: Callable = Callable()) -> void:
	var tree = get_tree()
	if tree != null:
		tree.create_timer(duration).timeout.connect(func():
			if is_instance_valid(hero) and hero.attribute_system != null:
				hero.attribute_system.remove_modifiers_by_source(source_tag)
			if on_remove.is_valid():
				on_remove.call()
		)
