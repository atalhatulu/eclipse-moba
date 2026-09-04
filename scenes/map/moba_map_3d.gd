class_name MobaMap3D
extends Node3D

const FogOfWarManagerClass = preload("res://systems/fog_of_war/fog_of_war_manager.gd")
const BushArea3DClass = preload("res://scenes/map/bush_area_3d.gd")
const CourierEntityClass = preload("res://systems/courier/courier_entity.gd")
const CourierManagerClass = preload("res://systems/courier/courier_manager.gd")
const CombatFeedbackManagerClass = preload("res://systems/ui/combat_feedback_manager.gd")
const DotaMapBuilder3DClass = preload("res://systems/map/dota_map_builder_3d.gd")

## Dota 2 Demo Mode / Hero Sandbox Map (1 Single Lane, Stone Bridge over River, 2 Pairs of Towers & Ancient Cores)

@onready var nav_region: NavigationRegion3D = $NavigationRegion3D
@onready var camera: MobaCamera3D = $MobaCamera3D
@onready var directional_light: DirectionalLight3D = $DirectionalLight3D

# Hero instances
@onready var player_hero: HeroEntity = get_node_or_null("Heroes/PlayerHero")
@onready var hero_controller: HeroController3D = get_node_or_null("Heroes/PlayerHero/HeroController3D")
@onready var dire_hero: HeroEntity = get_node_or_null("Heroes/DireBotHero")
@onready var bot_controller: BotHeroController = get_node_or_null("Heroes/DireBotHero/BotHeroController")

# Match & UI
@onready var match_manager: MatchManager = get_node_or_null("MatchManager")
@onready var dota_hud: DotaHUD = get_node_or_null("DotaHUD")

# Map Objectives & Structures
@onready var radiant_ancient: ObjectiveEntity = get_node_or_null("Structures/Objectives/Radiant_Ancient_Core")
@onready var dire_ancient: ObjectiveEntity = get_node_or_null("Structures/Objectives/Dire_Ancient_Core")
@onready var radiant_t1: TowerEntity = get_node_or_null("Structures/Towers/Radiant_T1")
@onready var dire_t1: TowerEntity = get_node_or_null("Structures/Towers/Dire_T1")

var all_towers: Array[Node] = []
var all_spawners: Array[Node] = []

func _ready() -> void:
	Database.initialize()
	_build_dota_battlefield()
	_resolve_scene_nodes()
	_apply_global_hero_selections()
	_configure_demo_spawners()
	_bind_controllers_and_ui()
	
	# Start Central Match System
	if match_manager != null:
		match_manager.start_match(player_hero, dire_hero, radiant_ancient, dire_ancient)
	
	# Setup Fog of War, Objectives and Flying Couriers
	_setup_fog_and_bushes()
	_setup_couriers()
	_setup_combat_feedback()
	
	if dota_hud != null:
		dota_hud.play_again_clicked.connect(_on_play_again)
		dota_hud.main_menu_clicked.connect(_on_main_menu)

func _build_dota_battlefield() -> void:
	if nav_region != null:
		var old_terrain = nav_region.get_node_or_null("Terrain")
		if old_terrain != null:
			old_terrain.queue_free()
		var old_csg = nav_region.get_node_or_null("TerrainCSG")
		if old_csg != null:
			old_csg.queue_free()
			
	var terrain_parent = nav_region if nav_region != null else self
	if not terrain_parent.has_node("DotaTerrain"):
		DotaMapBuilder3DClass.build_dota_terrain(terrain_parent)
		
	DotaMapBuilder3DClass.populate_map_structures(self)

func _process(delta: float) -> void:
	# Shared, data-driven battlefield mechanics are not Nodes themselves.  The
	# map owns their frame tick so summons, placed zones and tethers remain live
	# during an actual match as well as in headless tests.
	SummonManager.tick(delta)
	SpatialManager.tick(delta)
	TetherManager.tick(delta)
	AreaEffectManager.tick(delta)
	var now = Time.get_ticks_msec() / 1000.0
	for node in get_tree().get_nodes_in_group("combat_entities"):
		if node is BaseCombatEntity and is_instance_valid(node) and node.is_alive():
			StateHistorySystem.record_snapshot(node, now)

func _setup_couriers() -> void:
	# 1. Radiant Courier (Next to Radiant fountain)
	var rad_courier = CourierEntityClass.new()
	rad_courier.name = "RadiantCourier"
	rad_courier.team = TeamDefinitions.Team.RADIANT # 0
	rad_courier.home_position = Vector3(-90.0, 3.5, 90.0)
	rad_courier.position = rad_courier.home_position
	add_child(rad_courier)
	CourierManagerClass.register_courier(rad_courier)
	
	# 2. Dire Courier (Next to Dire fountain)
	var dire_courier = CourierEntityClass.new()
	dire_courier.name = "DireCourier"
	dire_courier.team = TeamDefinitions.Team.DIRE # 1
	dire_courier.home_position = Vector3(90.0, 3.5, -90.0)
	dire_courier.position = dire_courier.home_position
	add_child(dire_courier)
	CourierManagerClass.register_courier(dire_courier)

func _setup_combat_feedback() -> void:
	if not has_node("CombatFeedbackManager"):
		var feedback = CombatFeedbackManagerClass.new()
		feedback.name = "CombatFeedbackManager"
		add_child(feedback)

func _setup_objectives() -> void:
	if not has_node("ObjectivesRoot"):
		var obj_root = Node3D.new()
		obj_root.name = "ObjectivesRoot"
		add_child(obj_root)
		
		# 1. Epic Boss (Eclipse Leviathan) in River Pit
		var boss = EpicBossEntity.new()
		boss.name = "EclipseLeviathan"
		obj_root.add_child(boss)
		boss.global_position = Vector3(0.0, -0.5, -22.0)
		
		# 2. Top & Bottom River Power Rune Spawners
		var rune_top = RiverRuneSpawner.new()
		rune_top.name = "RuneSpawnerTop"
		obj_root.add_child(rune_top)
		rune_top.global_position = Vector3(0.0, -1.0, -10.0)
		
		var rune_bot = RiverRuneSpawner.new()
		rune_bot.name = "RuneSpawnerBot"
		obj_root.add_child(rune_bot)
		rune_bot.global_position = Vector3(0.0, -1.0, 10.0)

func _setup_fog_and_bushes() -> void:
	if not has_node("FogOfWarManager"):
		var fog = FogOfWarManagerClass.new()
		fog.name = "FogOfWarManager"
		fog.player_team = TeamDefinitions.Team.RADIANT
		add_child(fog)
		
	var bush_root = get_node_or_null("Bushes")
	if bush_root == null:
		bush_root = Node3D.new()
		bush_root.name = "Bushes"
		add_child(bush_root)
		var bush_positions = [
			Vector3(0.0, 0.0, -16.0),
			Vector3(0.0, 0.0, 16.0),
			Vector3(-20.0, 0.0, -9.0),
			Vector3(20.0, 0.0, 9.0)
		]
		for pos in bush_positions:
			var b = BushArea3DClass.new()
			b.bush_radius = 4.5
			bush_root.add_child(b)
			b.global_position = pos

func _apply_global_hero_selections() -> void:
	var desired_player_id = GlobalHeroSelection.get_player_hero_id()
	var desired_bot_id = GlobalHeroSelection.get_bot_hero_id()
	
	if player_hero != null and player_hero.hero_resource != null:
		if player_hero.hero_resource.hero_id != desired_player_id:
			switch_player_hero(desired_player_id)
			
	if dire_hero != null and dire_hero.hero_resource != null:
		if dire_hero.hero_resource.hero_id != desired_bot_id:
			switch_bot_hero(desired_bot_id)

func switch_player_hero(hero_id: String) -> HeroEntity:
	if not HeroDefinition.has_definition(hero_id):
		return player_hero
		
	var spawn_pos = Vector3(-18.0, 0.0, 18.0)
	var spawn_rot = Vector3.ZERO
	if player_hero != null and is_instance_valid(player_hero):
		spawn_pos = player_hero.global_position
		spawn_rot = player_hero.global_rotation
		if hero_controller != null and hero_controller.get_parent() == player_hero:
			player_hero.remove_child(hero_controller)
		player_hero.queue_free()
		
	var new_hero = HeroDefinition.create_hero_instance(hero_id)
	new_hero.name = "PlayerHero"
	new_hero.team = TeamDefinitions.Team.RADIANT
	
	var hero_parent = get_node_or_null("Heroes")
	if hero_parent != null:
		hero_parent.add_child(new_hero)
	else:
		add_child(new_hero)
		
	new_hero.global_position = spawn_pos
	new_hero.global_rotation = spawn_rot
	new_hero.add_to_group("combat_entities")
	new_hero.add_to_group("heroes")
	player_hero = new_hero
	
	# Skill points & abilities
	if player_hero.ability_container != null:
		player_hero.ability_container.available_skill_points = 4
		for s in [AbilityResource.Slot.Q, AbilityResource.Slot.W, AbilityResource.Slot.E, AbilityResource.Slot.R]:
			if player_hero.ability_container.get_ability_level(s) == 0:
				player_hero.ability_container.ability_levels[s] = 1
				
	if player_hero.inventory_manager != null:
		player_hero.inventory_manager.unlimited_gold_mode = true
		player_hero.inventory_manager.gold = 99999
		player_hero.inventory_manager.gold_updated.emit(99999)
		
	if hero_controller != null:
		if hero_controller.get_parent() != player_hero:
			if hero_controller.get_parent() != null:
				hero_controller.get_parent().remove_child(hero_controller)
			player_hero.add_child(hero_controller)
		hero_controller.hero = player_hero
		hero_controller.camera = camera
		
	if camera != null:
		camera.target_to_follow = player_hero
		
	if dota_hud != null:
		dota_hud.target_hero = player_hero
		if dota_hud.has_method("_bind_hero"):
			dota_hud._bind_hero(player_hero)
			
	GlobalHeroSelection.set_player_hero(hero_id)
	
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("KAHRAMAN DÖNÜŞTÜ: %s (KONTROL AKTİF)" % new_hero.entity_name.to_upper())
		
	return player_hero

func switch_bot_hero(hero_id: String) -> HeroEntity:
	if not HeroDefinition.has_definition(hero_id):
		return dire_hero
		
	var spawn_pos = Vector3(18.0, 0.0, -18.0)
	var spawn_rot = Vector3.ZERO
	if dire_hero != null and is_instance_valid(dire_hero):
		spawn_pos = dire_hero.global_position
		spawn_rot = dire_hero.global_rotation
		if bot_controller != null and bot_controller.get_parent() == dire_hero:
			dire_hero.remove_child(bot_controller)
		dire_hero.queue_free()
		
	var new_bot = HeroDefinition.create_hero_instance(hero_id)
	new_bot.name = "DireBotHero"
	new_bot.team = TeamDefinitions.Team.DIRE
	
	var hero_parent = get_node_or_null("Heroes")
	if hero_parent != null:
		hero_parent.add_child(new_bot)
	else:
		add_child(new_bot)
		
	new_bot.global_position = spawn_pos
	new_bot.global_rotation = spawn_rot
	new_bot.add_to_group("combat_entities")
	new_bot.add_to_group("heroes")
	dire_hero = new_bot
	
	if dire_hero.ability_container != null:
		dire_hero.ability_container.available_skill_points = 4
		for s in [AbilityResource.Slot.Q, AbilityResource.Slot.W, AbilityResource.Slot.E, AbilityResource.Slot.R]:
			if dire_hero.ability_container.get_ability_level(s) == 0:
				dire_hero.ability_container.ability_levels[s] = 1
				
	if bot_controller != null:
		if bot_controller.get_parent() != dire_hero:
			if bot_controller.get_parent() != null:
				bot_controller.get_parent().remove_child(bot_controller)
			dire_hero.add_child(bot_controller)
		bot_controller.bot_hero = dire_hero
		bot_controller.opponent_hero = player_hero
		
	_equip_bot_starter_items(dire_hero)
	GlobalHeroSelection.set_bot_hero(hero_id)
	
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("RAKİP BOT DÖNÜŞTÜ: %s" % new_bot.entity_name.to_upper())
		
	return dire_hero

func _equip_bot_starter_items(bot: HeroEntity) -> void:
	if bot == null or bot.inventory_manager == null:
		return
	bot.inventory_manager.gold = 1200
	bot.inventory_manager.gold_updated.emit(1200)
	
	if Engine.has_singleton("Database") or is_instance_valid(Database):
		var starter_ids = [37, 2, 12, 9] # Boots, Heavy Sword, Giant's Belt, Reinforced Plate
		for item_id in starter_ids:
			var item = Database.get_item(item_id)
			if item != null:
				bot.inventory_manager.equip_item(item)

func _resolve_scene_nodes() -> void:
	if player_hero == null:
		player_hero = get_node_or_null("Heroes/PlayerHero")
	if dire_hero == null:
		dire_hero = get_node_or_null("Heroes/DireBotHero")
		if dire_hero == null:
			dire_hero = get_node_or_null("Heroes/DireAstrisBot")
	if hero_controller == null and player_hero != null:
		hero_controller = player_hero.get_node_or_null("HeroController3D")
	if bot_controller == null and dire_hero != null:
		bot_controller = dire_hero.get_node_or_null("BotHeroController")
	if match_manager == null:
		match_manager = get_node_or_null("MatchManager")
	if dota_hud == null:
		dota_hud = get_node_or_null("DotaHUD")
		
	# Collect all physical towers from scene
	all_towers.clear()
	var tower_container = get_node_or_null("Structures/Towers")
	if tower_container != null:
		for child in tower_container.get_children():
			if child is TowerEntity:
				all_towers.append(child)
	else:
		var grp_towers = get_tree().get_nodes_in_group("towers") if get_tree() != null else []
		for t in grp_towers:
			all_towers.append(t)
			
	# Collect all physical spawners
	all_spawners.clear()
	var spawner_container = get_node_or_null("Spawners")
	if spawner_container != null:
		for child in spawner_container.get_children():
			if child is LaneMinionSpawner:
				all_spawners.append(child)

func _bind_controllers_and_ui() -> void:
	# Configure Player Hero & Controller
	if player_hero != null:
		if player_hero.ability_container != null:
			player_hero.ability_container.available_skill_points = 4
			for s in [AbilityResource.Slot.Q, AbilityResource.Slot.W, AbilityResource.Slot.E, AbilityResource.Slot.R]:
				if player_hero.ability_container.get_ability_level(s) == 0:
					player_hero.ability_container.ability_levels[s] = 1
			
		if player_hero.inventory_manager != null:
			player_hero.inventory_manager.unlimited_gold_mode = true
			player_hero.inventory_manager.gold = 99999
			player_hero.inventory_manager.gold_updated.emit(99999)
			
		if player_hero.global_position.x < -40.0:
			player_hero.global_position = Vector3(-18.0, 0.0, 18.0)
			
		if hero_controller != null:
			hero_controller.hero = player_hero
			hero_controller.camera = camera
			
		if camera != null:
			camera.target_to_follow = player_hero
			camera.is_locked_to_hero = false
			camera.global_position = player_hero.global_position + camera.camera_offset
			
	# Configure Dire Bot Hero
	if dire_hero != null:
		if dire_hero.global_position.x > 40.0:
			dire_hero.global_position = Vector3(18.0, 0.0, -18.0)
			
		if dire_hero.ability_container != null:
			dire_hero.ability_container.available_skill_points = 4
			for s in [AbilityResource.Slot.Q, AbilityResource.Slot.W, AbilityResource.Slot.E, AbilityResource.Slot.R]:
				if dire_hero.ability_container.get_ability_level(s) == 0:
					dire_hero.ability_container.ability_levels[s] = 1
			
		if bot_controller != null:
			bot_controller.bot_hero = dire_hero
			bot_controller.opponent_hero = player_hero
			bot_controller.friendly_tower = dire_t1
			bot_controller.enemy_tower = radiant_t1
			bot_controller.lane_waypoints = DotaMapBuilder3DClass.get_dota_lane_waypoints(TeamDefinitions.Team.DIRE, LaneMinionSpawner.Lane.MID)
			
		_equip_bot_starter_items(dire_hero)
			
	# Configure Dota HUD Layer
	if dota_hud != null:
		dota_hud.target_hero = player_hero
		dota_hud.camera = camera
		dota_hud.match_manager = match_manager

func _configure_demo_spawners() -> void:
	var spawner_container = get_node_or_null("Spawners")
	if spawner_container != null:
		for child in spawner_container.get_children():
			if child is LaneMinionSpawner:
				if child.lane_waypoints.is_empty():
					child.lane_waypoints.assign(LaneMinionSpawner.get_default_waypoints(child.team, child.lane))

func _on_play_again() -> void:
	if match_manager != null:
		match_manager.reset_match(all_spawners, all_towers)
		if dota_hud != null and dota_hud.match_result_ui != null:
			dota_hud.match_result_ui.visible = false

func _on_main_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/hero_selection_screen.tscn")
