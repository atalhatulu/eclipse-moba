class_name GlobalHeroSelection
extends RefCounted

## Global state for selected player hero and bot opponent across scenes

static var selected_player_hero_id: String = "kaelgor"
static var selected_bot_hero_id: String = "astris"

static func set_player_hero(hero_id: String) -> void:
	if HeroDefinition.has_definition(hero_id):
		selected_player_hero_id = hero_id.to_lower()

static func set_bot_hero(hero_id: String) -> void:
	if HeroDefinition.has_definition(hero_id):
		selected_bot_hero_id = hero_id.to_lower()

static func get_player_hero_id() -> String:
	if not HeroDefinition.has_definition(selected_player_hero_id):
		selected_player_hero_id = "kaelgor"
	return selected_player_hero_id

static func get_bot_hero_id() -> String:
	if not HeroDefinition.has_definition(selected_bot_hero_id):
		selected_bot_hero_id = "astris"
	return selected_bot_hero_id
