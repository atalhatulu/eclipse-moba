class_name HeroDefinition
extends RefCounted

## Unified Hero Definition Registry and Factory for Eclipse Front MOBA

const RavenaHeroClass = preload("res://core/entities/heroes/ravena/ravena_hero.gd")
const RavenaDefinitionClass = preload("res://data/heroes/ravena_definition.gd")
const TharosHeroClass = preload("res://core/entities/heroes/tharos/tharos_hero.gd")
const TharosDefinitionClass = preload("res://data/heroes/tharos_definition.gd")

static var _hero_registry: Dictionary = {}

static func _ensure_registry() -> void:
	if not _hero_registry.has("kaelgor"):
		register_definition("kaelgor", KaelgorDefinition.create_resource())
	if not _hero_registry.has("astris"):
		register_definition("astris", AstrisDefinition.create_resource())
	if not _hero_registry.has("solen"):
		register_definition("solen", SolenDefinition.create_resource())
	if not _hero_registry.has("ravena"):
		register_definition("ravena", RavenaDefinitionClass.create_resource())
	if not _hero_registry.has("tharos"):
		register_definition("tharos", TharosDefinitionClass.create_resource())

static func register_definition(hero_id: String, res: HeroResource) -> void:
	_hero_registry[hero_id.to_lower()] = res

static func get_definition(hero_id: String) -> HeroResource:
	_ensure_registry()
	return _hero_registry.get(hero_id.to_lower(), null)

static func get_all_definitions() -> Array[HeroResource]:
	_ensure_registry()
	var list: Array[HeroResource] = []
	for res in _hero_registry.values():
		list.append(res)
	return list

static func get_all_hero_ids() -> Array[String]:
	_ensure_registry()
	var list: Array[String] = []
	for id in _hero_registry.keys():
		list.append(id)
	return list

static func has_definition(hero_id: String) -> bool:
	_ensure_registry()
	return _hero_registry.has(hero_id.to_lower())

static func create_hero_instance(hero_id: String) -> HeroEntity:
	_ensure_registry()
	var id = hero_id.to_lower()
	var hero: HeroEntity = null
	
	match id:
		"kaelgor":
			hero = KaelgorHero.new()
		"astris":
			hero = AstrisHero.new()
		"solen":
			hero = SolenHero.new()
		"ravena":
			hero = RavenaHeroClass.new()
		"tharos":
			hero = TharosHeroClass.new()
		_:
			hero = HeroEntity.new()
			var def = get_definition(id)
			if def != null:
				hero.hero_resource = def
				
	return hero
