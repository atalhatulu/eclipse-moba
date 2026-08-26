class_name MobaMap3D
extends Node3D

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
	_resolve_scene_nodes()
	_configure_demo_spawners()
	_bind_controllers_and_ui()
	
	if nav_region != null:
		nav_region.bake_navigation_mesh()
		
	# Start Central Match System
	if match_manager != null:
		match_manager.start_match(player_hero, dire_hero, radiant_ancient, dire_ancient)
	
	if dota_hud != null:
		dota_hud.play_again_clicked.connect(_on_play_again)
		dota_hud.main_menu_clicked.connect(_on_main_menu)

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
			player_hero.ability_container.level_up_ability(AbilityResource.Slot.Q)
			player_hero.ability_container.level_up_ability(AbilityResource.Slot.W)
			player_hero.ability_container.level_up_ability(AbilityResource.Slot.E)
			player_hero.ability_container.level_up_ability(AbilityResource.Slot.R)
			
		if player_hero.inventory_manager != null:
			player_hero.inventory_manager.unlimited_gold_mode = true
			player_hero.inventory_manager.gold = 99999
			player_hero.inventory_manager.gold_updated.emit(99999)
			
		if hero_controller != null:
			hero_controller.hero = player_hero
			hero_controller.camera = camera
			
		if camera != null:
			camera.target_to_follow = player_hero
			camera.is_locked_to_hero = false
			camera.global_position = player_hero.global_position + camera.camera_offset
			
	# Configure Dire Bot Hero
	if dire_hero != null:
		if dire_hero.ability_container != null:
			dire_hero.ability_container.available_skill_points = 4
			dire_hero.ability_container.level_up_ability(AbilityResource.Slot.Q)
			dire_hero.ability_container.level_up_ability(AbilityResource.Slot.W)
			dire_hero.ability_container.level_up_ability(AbilityResource.Slot.E)
			dire_hero.ability_container.level_up_ability(AbilityResource.Slot.R)
			
		if bot_controller != null:
			bot_controller.bot_hero = dire_hero
			bot_controller.opponent_hero = player_hero
			bot_controller.friendly_tower = dire_t1
			bot_controller.enemy_tower = radiant_t1
			bot_controller.lane_waypoints = [
				Vector3(45.0, 0.0, 0.0),
				Vector3(20.0, 0.0, 0.0),
				Vector3(0.0, 0.0, 0.0),
				Vector3(-20.0, 0.0, 0.0),
				Vector3(-45.0, 0.0, 0.0)
			]
			
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
	get_tree().reload_current_scene()
