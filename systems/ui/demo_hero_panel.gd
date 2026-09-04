class_name DemoHeroPanel
extends Control

## Authentic Dota 2 Style "Demo Hero / Test Tool" Panel (test.png reference)
## Clean core mechanics: Dummy spawn, Enemy spawn, Ally spawn, Max Level, Free Spells, Reset
## Hotkey: F1 or left edge button

signal dummy_spawn_requested(pos: Vector3)
signal enemy_spawn_requested(hero_name: String)
signal ally_spawn_requested(hero_name: String)

@export var target_hero: HeroEntity = null
@export var map_root: Node3D = null

var is_open: bool = true
var panel_container: PanelContainer = null
var toggle_tab_btn: Button = null

# Cheats / Toggles state
var free_spells_active: bool = false
var creeps_enabled: bool = true
var towers_enabled: bool = true
var is_night_time: bool = false

# UI elements for active state reflection
var invulnerable_btn: Button = null
var pause_btn: Button = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS # Allows interacting during pause
	mouse_filter = MOUSE_FILTER_IGNORE
	set_anchors_preset(PRESET_FULL_RECT)
	_build_ui()

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F8 or event.keycode == KEY_QUOTELEFT or event.keycode == KEY_F5:
			_toggle_panel()

func _process(_delta: float) -> void:
	if free_spells_active:
		var hero = _get_hero()
		if hero != null:
			if hero.ability_container != null:
				hero.ability_container.is_free_spells_active = true
				for slot in hero.ability_container.cooldown_timers.keys():
					hero.ability_container.cooldown_timers[slot] = 0.0
				# Ensure all abilities have at least level 1 so they can be cast
				for s in [AbilityResource.Slot.Q, AbilityResource.Slot.W, AbilityResource.Slot.E, AbilityResource.Slot.R]:
					if hero.ability_container.get_ability_level(s) == 0:
						hero.ability_container.ability_levels[s] = 1
			if hero.attribute_system != null:
				hero.attribute_system.current_mana = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)

func _get_hero() -> HeroEntity:
	if target_hero != null and is_instance_valid(target_hero):
		return target_hero
	if get_tree() != null:
		var heroes = get_tree().get_nodes_in_group("heroes")
		for h in heroes:
			if h is HeroEntity and h.team == TeamDefinitions.Team.RADIANT:
				target_hero = h
				return target_hero
		var astris = get_tree().root.find_child("AstrisHero", true, false)
		if astris is HeroEntity:
			target_hero = astris
			return target_hero
		var kaelgor = get_tree().root.find_child("KaelgorHero", true, false)
		if kaelgor is HeroEntity:
			target_hero = kaelgor
			return target_hero
	return null

func _get_map_root() -> Node3D:
	if map_root != null and is_instance_valid(map_root):
		return map_root
	if get_tree() != null and get_tree().current_scene is Node3D:
		map_root = get_tree().current_scene
		return map_root
	return null

func _build_ui() -> void:
	# 1. Slide-out Panel Container (Open by default)
	panel_container = PanelContainer.new()
	panel_container.offset_left = 0
	panel_container.offset_top = 70
	panel_container.offset_right = 260
	panel_container.offset_bottom = 570
	panel_container.custom_minimum_size = Vector2(260, 500)
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.06, 0.08, 0.12, 0.98)
	style.border_width_right = 2
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.35, 0.42, 0.55)
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_right = 8
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	panel_container.add_theme_stylebox_override("panel", style)
	add_child(panel_container)
	
	# 2. Toggle Tab Button (Directly attached to panel edge)
	toggle_tab_btn = Button.new()
	toggle_tab_btn.text = "◀"
	toggle_tab_btn.offset_left = 260
	toggle_tab_btn.offset_top = 180
	toggle_tab_btn.offset_right = 295
	toggle_tab_btn.offset_bottom = 224
	
	var tab_style = StyleBoxFlat.new()
	tab_style.bg_color = Color(0.12, 0.15, 0.22, 0.98)
	tab_style.border_width_right = 2
	tab_style.border_width_top = 2
	tab_style.border_width_bottom = 2
	tab_style.border_color = Color(1.0, 0.8, 0.25)
	tab_style.corner_radius_top_right = 6
	tab_style.corner_radius_bottom_right = 6
	toggle_tab_btn.add_theme_stylebox_override("normal", tab_style)
	toggle_tab_btn.add_theme_color_override("font_color", Color(1.0, 0.88, 0.3))
	toggle_tab_btn.add_theme_font_size_override("font_size", 12)
	toggle_tab_btn.tooltip_text = "Demo Paneli Aç/Kapat (Kısayol: F8)"
	toggle_tab_btn.pressed.connect(_toggle_panel)
	add_child(toggle_tab_btn)
	
	var scroll = ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	panel_container.add_child(scroll)
	
	var main_vbox = VBoxContainer.new()
	main_vbox.size_flags_horizontal = SIZE_EXPAND_FILL
	main_vbox.add_theme_constant_override("separation", 6)
	scroll.add_child(main_vbox)
	
	# SECTION 1: CANLANDIR (SPAWN)
	_build_header(main_vbox, "CANLANDIR")
	
	var btn_switch_hero = _create_btn(main_vbox, "KAHRAMAN DEĞİŞTİR", Color(0.9, 0.8, 0.3))
	btn_switch_hero.pressed.connect(_on_switch_hero_clicked)
	
	var spawn_grid = GridContainer.new()
	spawn_grid.columns = 3
	spawn_grid.add_theme_constant_override("h_separation", 4)
	spawn_grid.add_theme_constant_override("v_separation", 4)
	main_vbox.add_child(spawn_grid)
	
	var btn_dost = _create_btn(spawn_grid, "+DOST", Color(0.2, 0.7, 0.3))
	btn_dost.pressed.connect(_on_spawn_ally_clicked)
	
	var btn_dusman = _create_btn(spawn_grid, "+DÜŞMAN", Color(0.8, 0.25, 0.25))
	btn_dusman.pressed.connect(_on_spawn_enemy_clicked)
	
	var btn_manken = _create_btn(spawn_grid, "+MANKEN", Color(0.25, 0.6, 0.85))
	btn_manken.pressed.connect(_on_spawn_dummy_clicked)
	
	var btn_wave = _create_btn(main_vbox, "🌊 +DALGA BAŞLAT (WAVE)", Color(1.0, 0.78, 0.2))
	btn_wave.pressed.connect(_on_spawn_wave_clicked)
	
	# SECTION 2: BİRİMLER (UNITS & LEVELS)
	_build_header(main_vbox, "BİRİMLER")
	
	var unit_grid = GridContainer.new()
	unit_grid.columns = 2
	unit_grid.add_theme_constant_override("h_separation", 4)
	unit_grid.add_theme_constant_override("v_separation", 4)
	main_vbox.add_child(unit_grid)
	
	var btn_lvl_up = _create_btn(unit_grid, "SEVİYE ATLAT", Color(0.7, 0.75, 0.8))
	btn_lvl_up.pressed.connect(_on_level_up_clicked)
	
	var btn_max_lvl = _create_btn(unit_grid, "MAKS. SVY", Color(1.0, 0.8, 0.2))
	btn_max_lvl.pressed.connect(_on_max_level_clicked)
	
	invulnerable_btn = _create_btn(unit_grid, "DKNLMZ", Color(0.5, 0.7, 0.9))
	invulnerable_btn.pressed.connect(_on_invulnerable_toggle_clicked)
	
	var btn_reset = _create_btn(unit_grid, "SIFIRLA", Color(0.85, 0.6, 0.2))
	btn_reset.pressed.connect(_on_reset_hero_clicked)
	
	var btn_remove = _create_btn(main_vbox, "HEDEFİ KALDIR", Color(0.85, 0.35, 0.35))
	btn_remove.pressed.connect(_on_remove_target_clicked)
	
	# SECTION 3: GENEL (WORLD & CHEATS)
	_build_header(main_vbox, "GENEL")
	
	var chk_free = CheckBox.new()
	chk_free.text = "Sınırsız Büyüler"
	chk_free.add_theme_font_size_override("font_size", 11)
	chk_free.toggled.connect(_on_free_spells_toggled)
	main_vbox.add_child(chk_free)
	
	var chk_creeps = CheckBox.new()
	chk_creeps.text = "Minyonlar Aktif"
	chk_creeps.button_pressed = true
	chk_creeps.add_theme_font_size_override("font_size", 11)
	chk_creeps.toggled.connect(_on_creeps_toggled)
	main_vbox.add_child(chk_creeps)
	
	var chk_towers = CheckBox.new()
	chk_towers.text = "Kuleler Aktif"
	chk_towers.button_pressed = true
	chk_towers.add_theme_font_size_override("font_size", 11)
	chk_towers.toggled.connect(_on_towers_toggled)
	main_vbox.add_child(chk_towers)
	
	var chk_night = CheckBox.new()
	chk_night.text = "Gece Vakti"
	chk_night.add_theme_font_size_override("font_size", 11)
	chk_night.toggled.connect(_on_night_toggled)
	main_vbox.add_child(chk_night)
	
	# Refresh Buttons
	var refresh_hbox = HBoxContainer.new()
	refresh_hbox.add_theme_constant_override("separation", 4)
	main_vbox.add_child(refresh_hbox)
	
	var btn_ref_spells = _create_btn(refresh_hbox, "BÜYÜLERİ YENİLE", Color(0.4, 0.75, 1.0))
	btn_ref_spells.pressed.connect(_on_refresh_spells_clicked)
	
	var btn_ref_hp = _create_btn(refresh_hbox, "SAĞLIK DOLDUR", Color(0.3, 0.9, 0.4))
	btn_ref_hp.pressed.connect(_on_fill_health_clicked)
	
	# SECTION 4: KONTROL (PAUSE & RESET)
	_build_header(main_vbox, "KONTROL")
	var ctrl_hbox = HBoxContainer.new()
	ctrl_hbox.add_theme_constant_override("separation", 4)
	main_vbox.add_child(ctrl_hbox)
	
	pause_btn = _create_btn(ctrl_hbox, "DURAKLAT", Color(0.8, 0.85, 0.9))
	pause_btn.pressed.connect(_on_pause_clicked)
	
	var restart_btn = _create_btn(ctrl_hbox, "YENİDEN BAŞLAT", Color(0.95, 0.4, 0.3))
	restart_btn.pressed.connect(_on_restart_clicked)

func _build_header(parent: Control, title: String) -> void:
	var lbl = Label.new()
	lbl.text = title
	lbl.add_theme_font_size_override("font_size", 11)
	lbl.add_theme_color_override("font_color", Color(0.7, 0.75, 0.85))
	parent.add_child(lbl)
	
	var sep = HSeparator.new()
	parent.add_child(sep)

func _create_btn(parent: Control, txt: String, text_col: Color) -> Button:
	var btn = Button.new()
	btn.text = txt
	btn.custom_minimum_size = Vector2(60, 26)
	btn.size_flags_horizontal = SIZE_EXPAND_FILL
	btn.add_theme_font_size_override("font_size", 10)
	btn.add_theme_color_override("font_color", text_col)
	parent.add_child(btn)
	return btn

func _toggle_panel() -> void:
	is_open = not is_open
	var tween = create_tween()
	var target_x = 0 if is_open else -260
	tween.tween_property(panel_container, "offset_left", target_x, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(panel_container, "offset_right", target_x + 260, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	if is_open:
		tween.parallel().tween_property(toggle_tab_btn, "offset_left", 260, 0.25)
		tween.parallel().tween_property(toggle_tab_btn, "offset_right", 295, 0.25)
		toggle_tab_btn.text = "◀"
	else:
		tween.parallel().tween_property(toggle_tab_btn, "offset_left", 0, 0.25)
		tween.parallel().tween_property(toggle_tab_btn, "offset_right", 120, 0.25)
		toggle_tab_btn.text = "▶ DEMO (F8)"

# --- Action Implementations ---

func _on_free_spells_toggled(enabled: bool) -> void:
	free_spells_active = enabled
	var hero = _get_hero()
	if hero != null and hero.ability_container != null:
		hero.ability_container.is_free_spells_active = enabled
		if enabled:
			for s in [AbilityResource.Slot.Q, AbilityResource.Slot.W, AbilityResource.Slot.E, AbilityResource.Slot.R]:
				if hero.ability_container.get_ability_level(s) == 0:
					hero.ability_container.ability_levels[s] = 1
			for slot in hero.ability_container.cooldown_timers.keys():
				hero.ability_container.cooldown_timers[slot] = 0.0

var hero_selector_modal: HeroSelectionUI = null

func _on_switch_hero_clicked() -> void:
	if hero_selector_modal == null:
		hero_selector_modal = HeroSelectionUI.new()
		hero_selector_modal.is_modal_mode = true
		hero_selector_modal.target_moba_map = _get_map_root()
		hero_selector_modal.close_requested.connect(func(): hero_selector_modal.visible = false)
		
		# Add to HUD canvas layer or root
		var hud = get_parent()
		if hud != null:
			hud.add_child(hero_selector_modal)
		else:
			add_child(hero_selector_modal)
		hero_selector_modal.visible = true
	else:
		hero_selector_modal.visible = not hero_selector_modal.visible
		
	if hero_selector_modal.visible:
		hero_selector_modal.inspect_hero(GlobalHeroSelection.get_player_hero_id())

func _on_spawn_dummy_clicked() -> void:
	var hero = _get_hero()
	var m_root = _get_map_root()
	if hero != null and m_root != null:
		var spawn_pos = hero.global_position - hero.global_transform.basis.z * 5.0
		var dummy = TargetDummyEntity.new()
		dummy.team = TeamDefinitions.Team.NEUTRAL
		m_root.add_child(dummy)
		dummy.global_position = spawn_pos
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("DEMO: HEDEF MANKENİ (DUMMY) OLUŞTURULDU")

func _on_spawn_enemy_clicked() -> void:
	var hero = _get_hero()
	var m_root = _get_map_root()
	if hero != null and m_root != null:
		var spawn_pos = hero.global_position - hero.global_transform.basis.z * 7.0
		var bot_id = GlobalHeroSelection.get_bot_hero_id()
		var bot = HeroDefinition.create_hero_instance(bot_id)
		bot.team = TeamDefinitions.Team.DIRE
		m_root.add_child(bot)
		bot.global_position = spawn_pos
		bot.add_to_group("combat_entities")
		bot.add_to_group("heroes")
		
		# Attach functional AI controller
		var b_ctrl = BotHeroController.new()
		b_ctrl.name = "BotHeroController"
		b_ctrl.bot_hero = bot
		b_ctrl.opponent_hero = hero
		bot.add_child(b_ctrl)
		
		if bot.ability_container != null:
			bot.ability_container.available_skill_points = 4
			for s in [AbilityResource.Slot.Q, AbilityResource.Slot.W, AbilityResource.Slot.E, AbilityResource.Slot.R]:
				bot.ability_container.ability_levels[s] = 1
				
		if bot.inventory_manager != null and (Engine.has_singleton("Database") or is_instance_valid(Database)):
			bot.inventory_manager.gold = 1200
			for item_id in [37, 2, 12, 9]:
				var item = Database.get_item(item_id)
				if item != null:
					bot.inventory_manager.equip_item(item)
				
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("DEMO: DÜŞMAN BOT (%s) OLUŞTURULDU (YAPAY ZEKA AKTİF)" % bot.entity_name)

func _on_spawn_ally_clicked() -> void:
	var hero = _get_hero()
	var m_root = _get_map_root()
	if hero != null and m_root != null:
		var spawn_pos = hero.global_position + hero.global_transform.basis.x * 4.0
		var ally_id = GlobalHeroSelection.get_player_hero_id()
		var ally = HeroDefinition.create_hero_instance(ally_id)
		ally.team = TeamDefinitions.Team.RADIANT
		m_root.add_child(ally)
		ally.global_position = spawn_pos
		ally.add_to_group("combat_entities")
		ally.add_to_group("heroes")
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("DEMO: DOST KAHRAMAN (%s) OLUŞTURULDU" % ally.entity_name)

func _on_spawn_wave_clicked() -> void:
	var spawners: Array[Node] = []
	if get_tree() != null:
		var root = get_tree().current_scene
		if root != null:
			var s_node = root.find_child("Spawners", true, false)
			if s_node != null:
				for c in s_node.get_children():
					if c is LaneMinionSpawner:
						spawners.append(c)
	for sp in spawners:
		if sp is LaneMinionSpawner:
			sp.spawn_wave()
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("DEMO: MİNYON DALGASI (WAVE) TÜM KORİDORLARDA BAŞLATILDI")

func _on_level_up_clicked() -> void:
	var hero = _get_hero()
	if hero != null and hero.attribute_system != null:
		hero.attribute_system.grant_experience(1200.0)
		if hero.ability_container != null:
			hero.ability_container.available_skill_points += 1
			for s in [AbilityResource.Slot.Q, AbilityResource.Slot.W, AbilityResource.Slot.E, AbilityResource.Slot.R]:
				if hero.ability_container.get_ability_level(s) == 0:
					hero.ability_container.ability_levels[s] = 1
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("DEMO: SEVİYE %d (+1000 XP)" % hero.attribute_system.level)

func _on_max_level_clicked() -> void:
	var hero = _get_hero()
	if hero != null and hero.attribute_system != null:
		hero.attribute_system.level = 30
		hero.attribute_system.recalculate_all_stats()
		hero.attribute_system.current_health = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
		hero.attribute_system.current_mana = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
		if hero.ability_container != null:
			hero.ability_container.available_skill_points = 25
			for s in [AbilityResource.Slot.Q, AbilityResource.Slot.W, AbilityResource.Slot.E, AbilityResource.Slot.R]:
				var ab = hero.ability_container.get_ability(s)
				if ab != null:
					hero.ability_container.ability_levels[s] = ab.max_level
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("DEMO: MAKSİMUM SEVİYE (30) UYGULANDI")

func _on_invulnerable_toggle_clicked() -> void:
	var hero = _get_hero()
	if hero != null and hero.effect_container != null:
		if hero.effect_container.is_invulnerable():
			hero.effect_container.remove_effect_by_id("demo_invulnerable")
			if invulnerable_btn != null: invulnerable_btn.text = "DKNLMZ"
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("DEMO: DOKUNULMAZLIK KAPATILDI")
		else:
			var inv_eff = StatusEffect.new("demo_invulnerable", StatusEffect.EffectType.INVULNERABILITY, -1.0, 0.0, false)
			hero.effect_container.apply_effect(inv_eff)
			if invulnerable_btn != null: invulnerable_btn.text = "DKNLMZ [AÇIK]"
			if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
				GameEvents.combat_log_generated.emit("DEMO: DOKUNULMAZLIK AKTİF EDİLDİ")

func _on_reset_hero_clicked() -> void:
	_on_fill_health_clicked()
	_on_refresh_spells_clicked()
	var hero = _get_hero()
	if hero != null and hero.effect_container != null:
		hero.effect_container.clear_all_debuffs()
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("DEMO: KAHRAMAN DURUMU SIFIRLANDI (TAM SAĞLIK & MANA)")

func _on_refresh_spells_clicked() -> void:
	var hero = _get_hero()
	if hero != null and hero.ability_container != null:
		for slot in hero.ability_container.cooldown_timers.keys():
			hero.ability_container.cooldown_timers[slot] = 0.0
	if hero != null and hero.inventory_manager != null:
		for s in hero.inventory_manager.active_cooldowns.keys():
			hero.inventory_manager.active_cooldowns[s] = 0.0
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("DEMO: TÜM YETENEK VE EŞYA BEKLEME SÜRELERİ SIFIRLANDI")

func _on_fill_health_clicked() -> void:
	var hero = _get_hero()
	if hero != null and hero.attribute_system != null:
		hero.attribute_system.current_health = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
		hero.attribute_system.current_mana = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("DEMO: SAĞLIK VE MANA TAMAMEN DOLDURULDU")

func _on_remove_target_clicked() -> void:
	var hero = _get_hero()
	var m_root = _get_map_root()
	if m_root != null and hero != null:
		var entities = m_root.get_tree().get_nodes_in_group("combat_entities") if m_root.get_tree() != null else []
		for ent in entities:
			if ent != hero and ent is BaseCombatEntity and not (ent is TowerEntity or ent is ObjectiveEntity):
				var dist = ent.global_position.distance_to(hero.global_position)
				if dist <= 12.0:
					ent.queue_free()
					if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
						GameEvents.combat_log_generated.emit("DEMO: %s ALANDAN KALDIRILDI" % ent.entity_name)
					break

func _on_creeps_toggled(enabled: bool) -> void:
	creeps_enabled = enabled
	var m_root = _get_map_root()
	if m_root != null:
		var spawners = m_root.get_tree().get_nodes_in_group("spawners")
		for sp in spawners:
			if sp is LaneMinionSpawner:
				sp.is_spawning = enabled
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("DEMO: MİNYON ÜRETİMİ: %s" % ("AÇIK" if enabled else "KAPALI"))

func _on_towers_toggled(enabled: bool) -> void:
	towers_enabled = enabled
	var m_root = _get_map_root()
	if m_root != null:
		var towers = m_root.get_tree().get_nodes_in_group("towers")
		for tw in towers:
			if tw is TowerEntity:
				tw.is_invulnerable_to_damage = not enabled
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("DEMO: KULELER: %s" % ("AKTİF" if enabled else "DURDURULDU"))

func _on_night_toggled(is_night: bool) -> void:
	is_night_time = is_night
	var m_root = _get_map_root()
	if m_root != null:
		var sun = m_root.get_node_or_null("WorldEnvironment/DirectionalLight3D")
		if sun == null:
			sun = m_root.find_child("DirectionalLight3D", true, false)
		if sun is DirectionalLight3D:
			sun.light_energy = 0.15 if is_night else 1.2
			sun.light_color = Color(0.4, 0.5, 0.8) if is_night else Color(1.0, 0.95, 0.85)
		if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
			GameEvents.combat_log_generated.emit("DEMO: VAKİT: %s" % ("GECE" if is_night else "GÜNDÜZ"))

func _on_pause_clicked() -> void:
	var paused = not get_tree().paused
	get_tree().paused = paused
	if pause_btn != null:
		pause_btn.text = "DEVAM ET" if paused else "DURAKLAT"
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("DEMO: OYUN %s" % ("DURAKLATILDI" if paused else "DEVAM EDİYOR"))

func _on_restart_clicked() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
