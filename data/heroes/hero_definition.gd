class_name HeroDefinition
extends RefCounted

## Unified Hero Definition Registry and Factory for Eclipse Front MOBA

static var _hero_registry: Dictionary = {}

static func _ensure_registry() -> void:
	if not _hero_registry.has("kaelgor"):
		register_definition("kaelgor", KaelgorDefinition.create_resource())
	if not _hero_registry.has("astris"):
		register_definition("astris", AstrisDefinition.create_resource())
	if not _hero_registry.has("solen"):
		register_definition("solen", SolenDefinition.create_resource())
	if not _hero_registry.has("ravena"):
		register_definition("ravena", RavenaDefinition.create_resource())
	if not _hero_registry.has("tharos"):
		register_definition("tharos", TharosDefinition.create_resource())
	if not _hero_registry.has("mordren"):
		register_definition("mordren", MordrenDefinition.create_resource())
	if not _hero_registry.has("brakka"):
		register_definition("brakka", BrakkaDefinition.create_resource())
	if not _hero_registry.has("veyra"):
		register_definition("veyra", VeyraDefinition.create_resource())
	if not _hero_registry.has("gorak"):
		register_definition("gorak", GorakDefinition.create_resource())
	if not _hero_registry.has("durn"):
		register_definition("durn", DurnDefinition.create_resource())
	if not _hero_registry.has("auron"):
		register_definition("auron", AuronDefinition.create_resource())
	if not _hero_registry.has("kharos"):
		register_definition("kharos", KharosDefinition.create_resource())
	if not _hero_registry.has("nyxara"):
		register_definition("nyxara", NyxaraDefinition.create_resource())
	if not _hero_registry.has("kaeli"):
		register_definition("kaeli", KaeliDefinition.create_resource())
	if not _hero_registry.has("varyn"):
		register_definition("varyn", VarynDefinition.create_resource())
	if not _hero_registry.has("elyra"):
		register_definition("elyra", ElyraDefinition.create_resource())
	if not _hero_registry.has("rivena"):
		register_definition("rivena", RivenaDefinition.create_resource())
	if not _hero_registry.has("talon"):
		register_definition("talon", TalonDefinition.create_resource())
	if not _hero_registry.has("seris"):
		register_definition("seris", SerisDefinition.create_resource())
	if not _hero_registry.has("mira"):
		register_definition("mira", MiraDefinition.create_resource())
	if not _hero_registry.has("zarek"):
		register_definition("zarek", ZarekDefinition.create_resource())
	if not _hero_registry.has("ilyra"):
		register_definition("ilyra", IlyraDefinition.create_resource())
	if not _hero_registry.has("vael"):
		register_definition("vael", VaelDefinition.create_resource())
	if not _hero_registry.has("neris"):
		register_definition("neris", NerisDefinition.create_resource())
	if not _hero_registry.has("oryn"):
		register_definition("oryn", OrynDefinition.create_resource())
	if not _hero_registry.has("selka"):
		register_definition("selka", SelkaDefinition.create_resource())
	if not _hero_registry.has("mora"):
		register_definition("mora", MoraDefinition.create_resource())
	if not _hero_registry.has("aethon"):
		register_definition("aethon", AethonDefinition.create_resource())
	if not _hero_registry.has("nymera"):
		register_definition("nymera", NymeraDefinition.create_resource())
	if not _hero_registry.has("veylin"):
		register_definition("veylin", VeylinDefinition.create_resource())
	if not _hero_registry.has("zyraen"):
		register_definition("zyraen", ZyraenDefinition.create_resource())

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
			hero = RavenaHero.new()
		"tharos":
			hero = TharosHero.new()
		"mordren":
			hero = MordrenHero.new()
		"brakka":
			hero = BrakkaHero.new()
		"veyra":
			hero = VeyraHero.new()
		"gorak":
			hero = GorakHero.new()
		"durn":
			hero = DurnHero.new()
		"auron":
			hero = AuronHero.new()
		"kharos":
			hero = KharosHero.new()
		"nyxara":
			hero = NyxaraHero.new()
		"kaeli":
			hero = KaeliHero.new()
		"varyn":
			hero = VarynHero.new()
		"elyra":
			hero = ElyraHero.new()
		"rivena":
			hero = RivenaHero.new()
		"talon":
			hero = TalonHero.new()
		"seris":
			hero = SerisHero.new()
		"mira":
			hero = MiraHero.new()
		"zarek":
			hero = ZarekHero.new()
		"ilyra":
			hero = IlyraHero.new()
		"vael":
			hero = VaelHero.new()
		"neris":
			hero = NerisHero.new()
		"oryn":
			hero = OrynHero.new()
		"selka":
			hero = SelkaHero.new()
		"mora":
			hero = MoraHero.new()
		"aethon":
			hero = AethonHero.new()
		"nymera":
			hero = NymeraHero.new()
		"veylin":
			hero = VeylinHero.new()
		"zyraen":
			hero = ZyraenHero.new()
		_:
			hero = HeroEntity.new()
			var def = get_definition(id)
			if def != null:
				hero.hero_resource = def
				
	return hero
