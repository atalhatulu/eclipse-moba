class_name HeroBuildMatrix
extends RefCounted

## Manages and resolves the 54 Heroes x 3 Build Pathways (162 total builds)

static var _matrix_cache: Dictionary = {}

static func get_builds_for_hero(hero_id: String) -> Array:
	_ensure_loaded()
	var lower = hero_id.to_lower()
	if _matrix_cache.has(lower):
		return _matrix_cache[lower].get("builds", [])
	return []

static func get_all_hero_matrix() -> Dictionary:
	_ensure_loaded()
	return _matrix_cache

static func _ensure_loaded() -> void:
	if not _matrix_cache.is_empty():
		return
		
	var path = "res://data/hero_build_matrix.json"
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		if file != null:
			var txt = file.get_as_text()
			file.close()
			var parsed = JSON.parse_string(txt)
			if parsed is Dictionary:
				_matrix_cache = parsed

static func get_build(hero_id: String, build_index: int) -> Dictionary:
	var builds = get_builds_for_hero(hero_id)
	if build_index >= 0 and build_index < builds.size():
		return builds[build_index]
	return builds[0] if not builds.is_empty() else {}
