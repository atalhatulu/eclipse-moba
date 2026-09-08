class_name UserSettingsAutoload
extends Node

## Persisted player-facing settings.  Game systems read this service instead of
## embedding preferences in scenes, which also keeps future multiplayer clients
## from inheriting one another's local UI/audio choices.

signal setting_changed(section: String, key: String, value: Variant)

const SETTINGS_PATH := "user://eclipse_settings.cfg"
const DEFAULTS := {
	"audio": {"master": 1.0, "sfx": 1.0, "music": 0.80, "announcer": 1.0},
	"gameplay": {"camera_lock": false, "show_damage_numbers": true, "colorblind_mode": false},
	"video": {"screen_shake": true, "ui_scale": 1.0}
}
var values: Dictionary = {}

func _ready() -> void:
	load_settings()
	apply_audio_settings()

func load_settings() -> void:
	values = DEFAULTS.duplicate(true)
	var config := ConfigFile.new()
	if config.load(SETTINGS_PATH) != OK:
		return
	for section in DEFAULTS.keys():
		for key in DEFAULTS[section].keys():
			values[section][key] = config.get_value(section, key, values[section][key])

func save_settings() -> Error:
	var config := ConfigFile.new()
	for section in values.keys():
		for key in values[section].keys():
			config.set_value(section, key, values[section][key])
	return config.save(SETTINGS_PATH)

func get_setting(section: String, key: String, fallback: Variant = null) -> Variant:
	if values.has(section) and values[section].has(key):
		return values[section][key]
	return fallback

func set_setting(section: String, key: String, value: Variant, persist: bool = true) -> void:
	if not values.has(section):
		values[section] = {}
	values[section][key] = value
	if section == "audio":
		apply_audio_settings()
	setting_changed.emit(section, key, value)
	if persist:
		save_settings()

func apply_audio_settings() -> void:
	if not (Engine.has_singleton("SoundManager") or is_instance_valid(SoundManager)):
		return
	var bus_map = {"master": "Master", "sfx": "SFX", "music": "Music", "announcer": "Announcer"}
	for key in bus_map:
		SoundManager.set_bus_volume(bus_map[key], float(get_setting("audio", key, 1.0)))
