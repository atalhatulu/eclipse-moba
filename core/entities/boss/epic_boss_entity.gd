class_name EpicBossEntity
extends BaseCombatEntity

## Eclipse Leviathan (Roshan-style Epic Objective Boss)
## Spawns in River Pit, cleaves in an arc, drops Aegis of the Immortal and Cheese upon death.

signal boss_slain(killer_hero: HeroEntity, drop_items: Array[ItemResource])

@export var base_boss_health: float = 6500.0
@export var base_boss_attack: float = 140.0
@export var base_boss_armor: float = 35.0
@export var base_boss_mr: float = 45.0
@export var respawn_time_sec: float = 300.0 # 5 minutes

var is_in_pit: bool = true
var pit_origin: Vector3 = Vector3(0.0, -0.5, -22.0)
var leash_range: float = 12.0

func _ready() -> void:
	entity_name = "Eclipse Leviathan"
	team = TeamDefinitions.Team.NEUTRAL
	super._ready()
	_setup_boss_stats()
	_create_visuals()

func _setup_boss_stats() -> void:
	if attribute_system != null:
		var hp_mod = StatModifier.new(StatModifier.TargetStat.MAX_HEALTH, StatModifier.Type.FLAT, base_boss_health, "boss_base_hp")
		var ad_mod = StatModifier.new(StatModifier.TargetStat.ATTACK_DAMAGE, StatModifier.Type.FLAT, base_boss_attack, "boss_base_ad")
		var ar_mod = StatModifier.new(StatModifier.TargetStat.ARMOR, StatModifier.Type.FLAT, base_boss_armor, "boss_base_ar")
		var mr_mod = StatModifier.new(StatModifier.TargetStat.MAGIC_RESIST, StatModifier.Type.FLAT, base_boss_mr, "boss_base_mr")
		
		attribute_system.add_modifier(hp_mod)
		attribute_system.add_modifier(ad_mod)
		attribute_system.add_modifier(ar_mod)
		attribute_system.add_modifier(mr_mod)
		attribute_system.current_health = attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)

func _create_visuals() -> void:
	if not has_node("BossVisual"):
		var root = Node3D.new()
		root.name = "BossVisual"
		add_child(root)
		
		var mesh_inst = MeshInstance3D.new()
		var box = BoxMesh.new()
		box.size = Vector3(3.2, 3.5, 3.2)
		mesh_inst.mesh = box
		mesh_inst.position.y = 1.75
		
		var mat = StandardMaterial3D.new()
		mat.albedo_color = Color(0.15, 0.45, 0.65) # Leviathan Deep Azure
		mat.metallic = 0.6
		mat.roughness = 0.3
		mesh_inst.material_override = mat
		root.add_child(mesh_inst)

func _on_death(killer_name: String) -> void:
	super._on_death(killer_name)
	_spawn_boss_rewards()

func _spawn_boss_rewards() -> void:
	var aegis = ItemResource.new()
	aegis.id = 120
	aegis.item_name = "Aegis of the Immortal"
	aegis.active_name = "Immortal Rebirth"
	aegis.active_action_tag = "ACTIVE_AEGIS_REBIRTH"
	aegis.description = "Brings bearer back to life with 100% Health and Mana after 4s upon death."
	
	var cheese = ItemResource.new()
	cheese.id = 114
	cheese.item_name = "Eclipse Cheese"
	cheese.active_name = "Vitality Feast"
	cheese.active_action_tag = "ACTIVE_BURST_HEAL"
	cheese.active_cooldown = 40.0
	cheese.description = "Instantly restores 2500 Health and 1500 Mana."
	
	boss_slain.emit(last_attacker as HeroEntity, [aegis, cheese])
	
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("ECLIPSE LEVIATHAN KATLEDİLDİ! Ölümsüzlük Kalkanı düştü!")
