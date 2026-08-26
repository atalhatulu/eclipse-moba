class_name DeveloperSandbox
extends Node3D

## Developer Test Sandbox for Eclipse Front - Featuring Kaelgor vs Astris & Complete Combat HUD

var hero: KaelgorHero = null
var astris: AstrisHero = null
@onready var dummy: DummyEntity = $Dummy
@onready var game_state_manager: GameStateManager = $GameStateManager

# UI Labels & Controls
var debug_ui_layer: CanvasLayer = null
var stats_label: RichTextLabel = null
var combat_log_label: RichTextLabel = null
var combat_logs: Array[String] = []

func _ready() -> void:
	Database.initialize()
	_setup_hero()
	_setup_astris_opponent()
	_setup_debug_ui()
	_log("Eclipse Front Developer Sandbox Başlatıldı. Kaelgor vs Astris Düello Arenası Hazır.")

func _setup_hero() -> void:
	if has_node("Hero"):
		var old_hero = get_node("Hero")
		old_hero.name = "OldHero"
		old_hero.queue_free()
		
	hero = KaelgorHero.new()
	hero.name = "Hero"
	hero.team = TeamDefinitions.Team.RADIANT
	add_child(hero)
	hero.global_position = Vector3(-6.0, 0.0, 0.0)
	hero.add_to_group("combat_entities")
	
	hero.ability_container.available_skill_points = 4
	hero.ability_container.level_up_ability(AbilityResource.Slot.Q)
	hero.ability_container.level_up_ability(AbilityResource.Slot.W)
	hero.ability_container.level_up_ability(AbilityResource.Slot.E)
	hero.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var controller = HeroController3D.new()
	controller.name = "HeroController3D"
	controller.hero = hero
	hero.add_child(controller)

func _setup_astris_opponent() -> void:
	astris = AstrisHero.new()
	astris.name = "AstrisOpponent"
	astris.team = TeamDefinitions.Team.DIRE
	add_child(astris)
	astris.global_position = Vector3(6.0, 0.0, 0.0)
	astris.add_to_group("combat_entities")
	
	astris.ability_container.available_skill_points = 4
	astris.ability_container.level_up_ability(AbilityResource.Slot.Q)
	astris.ability_container.level_up_ability(AbilityResource.Slot.W)
	astris.ability_container.level_up_ability(AbilityResource.Slot.E)
	astris.ability_container.level_up_ability(AbilityResource.Slot.R)

func _process(_delta: float) -> void:
	_update_stats_display()

func _setup_debug_ui() -> void:
	debug_ui_layer = CanvasLayer.new()
	add_child(debug_ui_layer)
	
	var bg = ColorRect.new()
	bg.color = Color(0.04, 0.05, 0.07, 0.90)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	debug_ui_layer.add_child(bg)
	
	var main_vbox = VBoxContainer.new()
	main_vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	main_vbox.offset_left = 20
	main_vbox.offset_top = 15
	main_vbox.offset_right = -20
	main_vbox.offset_bottom = -15
	debug_ui_layer.add_child(main_vbox)
	
	var title = Label.new()
	title.text = "ECLIPSE FRONT — KAELGOR (STR) vs ASTRIS (INT) SAVAŞ VE ENJEKSİYON ARENASI"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 17)
	main_vbox.add_child(title)
	
	var split_hbox = HBoxContainer.new()
	split_hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_vbox.add_child(split_hbox)
	
	# Left column: Stats RichTextLabel
	stats_label = RichTextLabel.new()
	stats_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	stats_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stats_label.bbcode_enabled = true
	stats_label.text = "Stats Yükleniyor..."
	split_hbox.add_child(stats_label)
	
	# Right column: Buttons & Controls
	var scroll = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(360, 0)
	split_hbox.add_child(scroll)
	
	var btn_vbox = VBoxContainer.new()
	btn_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(btn_vbox)
	
	# Kaelgor Controls
	_add_section_header(btn_vbox, "--- KAELGOR (RADIANT STR) ---")
	_add_button(btn_vbox, "Kaelgor Temel Vuruş (-> Astris)", _on_btn_kaelgor_attack_astris)
	_add_button(btn_vbox, "Kaelgor Q: Molten Fist (-> Astris)", _on_btn_cast_q)
	_add_button(btn_vbox, "Kaelgor W: Vent (Isı Tüket & Yavaşlat)", _on_btn_cast_w)
	_add_button(btn_vbox, "Kaelgor E: Iron Hide (Hasar Azalt & Isı)", _on_btn_cast_e)
	_add_button(btn_vbox, "Kaelgor R: Overheat (100 Isı & Alan Vuruşu)", _on_btn_cast_r)
	
	# Astris Controls
	_add_section_header(btn_vbox, "--- ASTRIS (DIRE RANGED INT) ---")
	_add_button(btn_vbox, "Astris Menzilli Vuruş (-> Kaelgor)", _on_btn_astris_attack_kaelgor)
	_add_button(btn_vbox, "Astris Q: Arcane Bolt (-> Kaelgor)", _on_btn_astris_cast_q)
	_add_button(btn_vbox, "Astris W: Temporal Stasis (Kaelgor'u Sabitle)", _on_btn_astris_cast_w)
	_add_button(btn_vbox, "Astris E: Mana Barrier (Mana Kalkanı)", _on_btn_astris_cast_e)
	_add_button(btn_vbox, "Astris R: Astral Rupture (Kaelgor'a Ulti)", _on_btn_astris_cast_r)
	
	# General & Shop Controls
	_add_section_header(btn_vbox, "--- GENEL & DÜKKAN ---")
	_add_button(btn_vbox, "Dükkan & 6+1 Envanter Aç (P / B)", _on_btn_toggle_shop)
	_add_button(btn_vbox, "Kaelgor'u Sıfırla (Can/Mana/Isı)", _on_btn_reset_kaelgor)
	_add_button(btn_vbox, "Astris'i Sıfırla (Can/Mana)", _on_btn_reset_astris)
	_add_button(btn_vbox, "İki Kahramana da +1 Seviye Ver", _on_btn_level_up_both)
	
	# Envanter ve Dükkan UI sahnesi
	var shop_scene = load("res://systems/ui/shop_inventory_ui.tscn")
	if shop_scene != null:
		var shop_ui = shop_scene.instantiate() as ShopInventoryUI
		shop_ui.target_hero = hero
		debug_ui_layer.add_child(shop_ui)
	
	# Bottom: Combat Log
	combat_log_label = RichTextLabel.new()
	combat_log_label.custom_minimum_size = Vector2(0, 110)
	combat_log_label.bbcode_enabled = true
	main_vbox.add_child(combat_log_label)

func _add_section_header(parent: Control, text: String) -> void:
	var lbl = Label.new()
	lbl.text = text
	lbl.add_theme_color_override("font_color", Color(1, 0.8, 0.3, 1))
	parent.add_child(lbl)

func _add_button(parent: Control, label_text: String, callback: Callable) -> void:
	var btn = Button.new()
	btn.text = label_text
	btn.pressed.connect(callback)
	parent.add_child(btn)

func _on_btn_toggle_shop() -> void:
	for child in debug_ui_layer.get_children():
		if child is ShopInventoryUI:
			child.toggle_shop()
			break

func _update_stats_display() -> void:
	if hero == null or astris == null or stats_label == null:
		return
		
	var ks = hero.attribute_system
	var as_stat = astris.attribute_system
	
	var txt = "[b][color=orange]KAELGOR (Yakın Dövüşçü - Güç):[/color][/b]\n"
	txt += "• Can: %.1f / %.1f | Mana: %.1f / %.1f\n" % [ks.current_health, ks.get_stat(StatModifier.TargetStat.MAX_HEALTH), ks.current_mana, ks.get_stat(StatModifier.TargetStat.MAX_MANA)]
	txt += "• Isı: [color=red]%.1f / 100[/color] %s | AD: %.1f | Zırh: %.1f | MR: %.1f | Menzil: %.0f\n" % [
		hero.heat_system.get_heat(),
		("[OVERHEAT!]" if hero.is_overheated else ""),
		ks.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE),
		ks.get_stat(StatModifier.TargetStat.ARMOR),
		ks.get_stat(StatModifier.TargetStat.MAGIC_RESIST),
		ks.get_stat(StatModifier.TargetStat.ATTACK_RANGE)
	]
	
	txt += "\n[b][color=cyan]ASTRIS (Menzilli Büyücü - Zeka):[/color][/b]\n"
	txt += "• Can: %.1f / %.1f | Mana: %.1f / %.1f\n" % [as_stat.current_health, as_stat.get_stat(StatModifier.TargetStat.MAX_HEALTH), as_stat.current_mana, as_stat.get_stat(StatModifier.TargetStat.MAX_MANA)]
	txt += "• AP: %.1f | Zırh: %.1f | MR: %.1f | Büyü Delme: %%%d | Menzil: [color=yellow]%.0f[/color]\n" % [
		as_stat.get_stat(StatModifier.TargetStat.ABILITY_POWER),
		as_stat.get_stat(StatModifier.TargetStat.ARMOR),
		as_stat.get_stat(StatModifier.TargetStat.MAGIC_RESIST),
		int(as_stat.get_stat(StatModifier.TargetStat.MAGIC_PEN_PERCENT) * 100),
		as_stat.get_stat(StatModifier.TargetStat.ATTACK_RANGE)
	]
	txt += "• Overcharge: %s\n" % ("[color=lime]AKTİF[/color]" if astris.is_overcharged else "Pasif")
	
	stats_label.text = txt

func _on_btn_kaelgor_attack_astris() -> void:
	if hero == null or astris == null: return
	var res = hero.execute_basic_attack(astris)
	if res != null:
		_log("Kaelgor -> Astris'e temel saldırı yaptı: %.1f fiziksel hasar." % res.final_health_damage)

func _on_btn_cast_q() -> void:
	if hero == null or astris == null: return
	var res = hero.cast_kaelgor_q(astris)
	if res != null:
		_log("Kaelgor [Q Molten Fist] -> Astris'e %.1f hasar vurdu." % res.final_health_damage)

func _on_btn_cast_w() -> void:
	if hero == null or astris == null: return
	var res = hero.cast_kaelgor_w([astris])
	if not res.is_empty():
		_log("Kaelgor [W Vent] -> Astris'e %.1f hasar ve %35 yavaşlatma vurdu." % res[0].final_health_damage)

func _on_btn_cast_e() -> void:
	if hero == null: return
	hero.cast_kaelgor_e()
	_log("Kaelgor [E Iron Hide] aktif: 4s boyunca %%30 hasar azaltma + Isı üretimi.")

func _on_btn_cast_r() -> void:
	if hero == null: return
	hero.cast_kaelgor_r()
	_log("Kaelgor [R Overheat] aktif: 100 Isı, saldırı hızı ve alan hasarı devrede.")

func _on_btn_astris_attack_kaelgor() -> void:
	if astris == null or hero == null: return
	var res = astris.execute_basic_attack(hero)
	if res != null:
		_log("Astris -> Kaelgor'a menzilli saldırı yaptı: %.1f hasar." % res.final_health_damage)

func _on_btn_astris_cast_q() -> void:
	if astris == null or hero == null: return
	var res = astris.cast_astris_q(hero)
	if res != null:
		_log("Astris [Q Arcane Bolt] -> Kaelgor'a %.1f büyü hasarı vurdu." % res.final_health_damage)

func _on_btn_astris_cast_w() -> void:
	if astris == null or hero == null: return
	var res = astris.cast_astris_w([hero])
	if not res.is_empty():
		_log("Astris [W Temporal Stasis] -> Kaelgor'u 1.5s SABİTLEDİ (Root) ve %.1f hasar vurdu." % res[0].final_health_damage)

func _on_btn_astris_cast_e() -> void:
	if astris == null: return
	astris.cast_astris_e()
	_log("Astris [E Mana Barrier] aktif: Mana ölçekli kalkan ve +%20 hareket hızı kazanıldı.")

func _on_btn_astris_cast_r() -> void:
	if astris == null or hero == null: return
	var res = astris.cast_astris_r([hero])
	if not res.is_empty():
		_log("Astris [R Astral Rupture] -> Kaelgor'a %.1f infaz hasarı ve %50 yavaşlatma vurdu." % res[0].final_health_damage)

func _on_btn_reset_kaelgor() -> void:
	if hero != null:
		hero.respawn()
		hero.heat_system.set_heat(0.0)
		_log("Kaelgor sıfırlandı.")

func _on_btn_reset_astris() -> void:
	if astris != null:
		astris.respawn()
		_log("Astris sıfırlandı.")

func _on_btn_level_up_both() -> void:
	if hero != null:
		hero.attribute_system.add_xp(hero.attribute_system.xp_to_next_level)
	if astris != null:
		astris.attribute_system.add_xp(astris.attribute_system.xp_to_next_level)
	_log("Her iki kahramana da seviye atlatıldı.")

func _log(msg: String) -> void:
	var timestamp = Time.get_time_string_from_system()
	combat_logs.push_front("[%s] %s" % [timestamp, msg])
	if combat_logs.size() > 10:
		combat_logs.pop_back()
	if combat_log_label != null:
		combat_log_label.text = "\n".join(combat_logs)
