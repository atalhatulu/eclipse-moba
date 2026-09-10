class_name SettingsMenu
extends Control

## In-Game Settings & Pause Menu for Eclipse Front
## Provides Audio volume sliders, Graphics/LOD settings, Controls cheat sheet, and Match Restart.

signal resumed()
signal match_restarted()

var is_menu_open: bool = false

var main_panel: PanelContainer
var tab_container: TabContainer

# Sliders
var master_slider: HSlider
var sfx_slider: HSlider
var music_slider: HSlider
var announcer_slider: HSlider

# Video Controls
var quality_option: OptionButton
var fullscreen_checkbox: CheckBox

# Gameplay Controls
var camera_speed_slider: HSlider
var damage_numbers_checkbox: CheckBox
var colorblind_checkbox: CheckBox

func _init() -> void:
	name = "SettingsMenu"
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_anchors_preset(PRESET_FULL_RECT)

func _ready() -> void:
	_build_ui()
	_sync_from_user_settings()

func _build_ui() -> void:
	# Semi-transparent backdrop
	var backdrop = ColorRect.new()
	backdrop.name = "Backdrop"
	backdrop.set_anchors_preset(PRESET_FULL_RECT)
	backdrop.color = Color(0, 0, 0, 0.70)
	add_child(backdrop)
	
	# Center container
	var center = CenterContainer.new()
	center.set_anchors_preset(PRESET_FULL_RECT)
	add_child(center)
	
	# Main Panel
	main_panel = PanelContainer.new()
	main_panel.custom_minimum_size = Vector2(720, 520)
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.10, 0.13, 0.96)
	style.set_border_width_all(2)
	style.border_color = Color(0.78, 0.65, 0.35, 0.85) # Gold border
	style.set_corner_radius_all(8)
	style.content_margin_left = 24
	style.content_margin_right = 24
	style.content_margin_top = 20
	style.content_margin_bottom = 20
	main_panel.add_theme_stylebox_override("panel", style)
	center.add_child(main_panel)
	
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 16)
	main_panel.add_child(vbox)
	
	# Header
	var title_lbl = Label.new()
	title_lbl.text = "AYARLAR & SEÇENEKLER"
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.add_theme_font_size_override("font_size", 22)
	title_lbl.add_theme_color_override("font_color", Color(0.95, 0.85, 0.50))
	vbox.add_child(title_lbl)
	
	# Tab Container
	tab_container = TabContainer.new()
	tab_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(tab_container)
	
	# Tab 1: Ses Ayarları
	_build_audio_tab(tab_container)
	
	# Tab 2: Oynanış & Kamera
	_build_gameplay_tab(tab_container)
	
	# Tab 3: Görüntü / Grafik
	_build_video_tab(tab_container)
	
	# Tab 4: Kısayol Tuşları
	_build_hotkeys_tab(tab_container)
	
	# Bottom Action Buttons
	var btn_box = HBoxContainer.new()
	btn_box.alignment = BoxContainer.ALIGNMENT_CENTER
	btn_box.add_theme_constant_override("separation", 24)
	vbox.add_child(btn_box)
	
	var resume_btn = Button.new()
	resume_btn.text = "Oyuna Dön (ESC)"
	resume_btn.custom_minimum_size = Vector2(160, 38)
	resume_btn.pressed.connect(close_menu)
	btn_box.add_child(resume_btn)
	
	var restart_btn = Button.new()
	restart_btn.text = "Maçı Yeniden Başlat"
	restart_btn.custom_minimum_size = Vector2(180, 38)
	restart_btn.pressed.connect(_on_restart_pressed)
	btn_box.add_child(restart_btn)

func _build_audio_tab(tabs: TabContainer) -> void:
	var scroll = ScrollContainer.new()
	scroll.name = "Ses"
	tabs.add_child(scroll)
	
	var vb = VBoxContainer.new()
	vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vb.add_theme_constant_override("separation", 14)
	scroll.add_child(vb)
	
	master_slider = _add_slider_row(vb, "Ana Ses Seviyesi:", func(val): _on_volume_changed("master", val))
	sfx_slider = _add_slider_row(vb, "Ses Efektleri (SFX):", func(val): _on_volume_changed("sfx", val))
	music_slider = _add_slider_row(vb, "Müzik Sesi:", func(val): _on_volume_changed("music", val))
	announcer_slider = _add_slider_row(vb, "Spiker & Katliam Bildirimleri:", func(val): _on_volume_changed("announcer", val))

func _build_gameplay_tab(tabs: TabContainer) -> void:
	var scroll = ScrollContainer.new()
	scroll.name = "Oynanış"
	tabs.add_child(scroll)
	
	var vb = VBoxContainer.new()
	vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vb.add_theme_constant_override("separation", 14)
	scroll.add_child(vb)
	
	camera_speed_slider = _add_slider_row(vb, "Kamera Kaydırma Hızı:", func(val): _on_camera_speed_changed(val), 10.0, 60.0, 25.0)
	
	damage_numbers_checkbox = CheckBox.new()
	damage_numbers_checkbox.text = "Savaş Hasar Numaralarını Göster"
	damage_numbers_checkbox.toggled.connect(func(t): _on_setting_toggled("gameplay", "show_damage_numbers", t))
	vb.add_child(damage_numbers_checkbox)
	
	colorblind_checkbox = CheckBox.new()
	colorblind_checkbox.text = "Renk Körü Modu (Yüksek Kontrastlı Can Barları)"
	colorblind_checkbox.toggled.connect(func(t): _on_setting_toggled("gameplay", "colorblind_mode", t))
	vb.add_child(colorblind_checkbox)

func _build_video_tab(tabs: TabContainer) -> void:
	var scroll = ScrollContainer.new()
	scroll.name = "Görüntü"
	tabs.add_child(scroll)
	
	var vb = VBoxContainer.new()
	vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vb.add_theme_constant_override("separation", 14)
	scroll.add_child(vb)
	
	var q_lbl = Label.new()
	q_lbl.text = "Grafik / LOD Seviyesi:"
	vb.add_child(q_lbl)
	
	quality_option = OptionButton.new()
	quality_option.add_item("Düşük (Yüksek Performans)", 0)
	quality_option.add_item("Orta (Dengeli)", 1)
	quality_option.add_item("Yüksek (Detaylı Aydınlatma)", 2)
	quality_option.select(1)
	quality_option.item_selected.connect(_on_quality_selected)
	vb.add_child(quality_option)
	
	fullscreen_checkbox = CheckBox.new()
	fullscreen_checkbox.text = "Tam Ekran Modu"
	fullscreen_checkbox.toggled.connect(_on_fullscreen_toggled)
	vb.add_child(fullscreen_checkbox)

func _build_hotkeys_tab(tabs: TabContainer) -> void:
	var scroll = ScrollContainer.new()
	scroll.name = "Tuş Kısayolları"
	tabs.add_child(scroll)
	
	var vb = VBoxContainer.new()
	vb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vb.add_theme_constant_override("separation", 8)
	scroll.add_child(vb)
	
	var hotkeys = [
		["Q / W / E", "Temel Yetenekler (Slot 1, 2, 3)"],
		["R", "Nihai Yetenek (Ultimate - Seviye 6+)"],
		["D / F", "Sihırdar / Özel Büyüler"],
		["1 - 6 Tuşları", "Envanter Eşyası Aktif Kullanımı"],
		["Alt + Sol Tık", "\"Yoldayım / Buradayım\" Harita İşareti (Ping)"],
		["G Tuşu", "\"Tehlike / Çekilin\" Harita İşareti (Ping)"],
		["F2 Tuşu", "Kurye Hızlandırma (Burst Speed)"],
		["F3 Tuşu", "Kurye Eşya Teslimatı Çağrısı"],
		["TAB (Basılı Tut)", "10 Oyunculu MOBA Skor & Eşya Tablosu"],
		["B veya P Tuşu", "Eşya Dükkanı ve Tarif Ağacı"],
		["Boşluk / F1", "Kamerayı Kahramana Odakla"],
		["ESC Tuşu", "Ayarlar Menüsü / Hedefleme İptali"]
	]
	
	for hk in hotkeys:
		var row = HBoxContainer.new()
		var k_lbl = Label.new()
		k_lbl.text = hk[0]
		k_lbl.custom_minimum_size = Vector2(180, 0)
		k_lbl.add_theme_color_override("font_color", Color(0.9, 0.75, 0.3))
		
		var desc_lbl = Label.new()
		desc_lbl.text = hk[1]
		desc_lbl.add_theme_color_override("font_color", Color(0.8, 0.85, 0.9))
		
		row.add_child(k_lbl)
		row.add_child(desc_lbl)
		vb.add_child(row)

func _add_slider_row(parent: Node, label_text: String, callback: Callable, min_val: float = 0.0, max_val: float = 1.0, default_val: float = 1.0) -> HSlider:
	var row = HBoxContainer.new()
	row.add_theme_constant_override("separation", 16)
	
	var lbl = Label.new()
	lbl.text = label_text
	lbl.custom_minimum_size = Vector2(240, 0)
	row.add_child(lbl)
	
	var slider = HSlider.new()
	slider.min_value = min_val
	slider.max_value = max_val
	slider.step = 0.05 if max_val <= 1.0 else 1.0
	slider.value = default_val
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.value_changed.connect(callback)
	row.add_child(slider)
	
	var val_lbl = Label.new()
	val_lbl.custom_minimum_size = Vector2(50, 0)
	val_lbl.text = "%d%%" % int(default_val * 100) if max_val <= 1.0 else "%d" % int(default_val)
	slider.value_changed.connect(func(v):
		val_lbl.text = "%d%%" % int(v * 100) if max_val <= 1.0 else "%d" % int(v)
	)
	row.add_child(val_lbl)
	
	parent.add_child(row)
	return slider

func _sync_from_user_settings() -> void:
	if Engine.has_singleton("UserSettings") or is_instance_valid(UserSettings):
		var master_v = float(UserSettings.get_setting("audio", "master", 1.0))
		var sfx_v = float(UserSettings.get_setting("audio", "sfx", 1.0))
		var music_v = float(UserSettings.get_setting("audio", "music", 0.8))
		var ann_v = float(UserSettings.get_setting("audio", "announcer", 1.0))
		
		if master_slider != null: master_slider.value = master_v
		if sfx_slider != null: sfx_slider.value = sfx_v
		if music_slider != null: music_slider.value = music_v
		if announcer_slider != null: announcer_slider.value = ann_v
		
		var show_dmg = bool(UserSettings.get_setting("gameplay", "show_damage_numbers", true))
		var colorblind = bool(UserSettings.get_setting("gameplay", "colorblind_mode", false))
		if damage_numbers_checkbox != null: damage_numbers_checkbox.button_pressed = show_dmg
		if colorblind_checkbox != null: colorblind_checkbox.button_pressed = colorblind

func toggle_menu() -> void:
	if is_menu_open:
		close_menu()
	else:
		open_menu()

func open_menu() -> void:
	is_menu_open = true
	visible = true
	_sync_from_user_settings()

func close_menu() -> void:
	is_menu_open = false
	visible = false
	resumed.emit()

func _on_volume_changed(bus_key: String, val: float) -> void:
	if Engine.has_singleton("UserSettings") or is_instance_valid(UserSettings):
		UserSettings.set_setting("audio", bus_key, val)

func _on_camera_speed_changed(val: float) -> void:
	if Engine.has_singleton("UserSettings") or is_instance_valid(UserSettings):
		UserSettings.set_setting("gameplay", "camera_speed", val)

func _on_setting_toggled(sec: String, key: String, is_on: bool) -> void:
	if Engine.has_singleton("UserSettings") or is_instance_valid(UserSettings):
		UserSettings.set_setting(sec, key, is_on)

func _on_quality_selected(idx: int) -> void:
	var qual_name = "low" if idx == 0 else ("medium" if idx == 1 else "high")
	if Engine.has_singleton("UserSettings") or is_instance_valid(UserSettings):
		UserSettings.set_setting("video", "quality", qual_name)

func _on_fullscreen_toggled(is_full: bool) -> void:
	if DisplayServer.get_name() != "headless":
		var mode = DisplayServer.WINDOW_MODE_FULLSCREEN if is_full else DisplayServer.WINDOW_MODE_WINDOWED
		DisplayServer.window_set_mode(mode)

func _on_restart_pressed() -> void:
	close_menu()
	match_restarted.emit()
	if get_tree() != null:
		get_tree().reload_current_scene()
