extends Node

## Centralized data provider and registry for Eclipse Front (120 Items, Abilities & Stats)

var _items: Dictionary = {} # int (id) -> ItemResource
var _items_by_name: Dictionary = {} # String (lowercase) -> ItemResource
var _abilities: Dictionary = {} # String (id) -> AbilityResource
var _balance_config: BalanceConfig = null
var _is_initialized: bool = false

func _ready() -> void:
	initialize()

func initialize() -> void:
	if _is_initialized:
		return
		
	_balance_config = BalanceConfig.get_default()
	_load_all_120_items()
	_register_sample_abilities()
	_is_initialized = true

func get_balance_config() -> BalanceConfig:
	if _balance_config == null:
		_balance_config = BalanceConfig.get_default()
	return _balance_config

func register_item(item: ItemResource) -> void:
	if item == null:
		return
	_items[item.id] = item
	_items_by_name[item.item_name.to_lower()] = item

func get_item(id: int) -> ItemResource:
	if not _is_initialized:
		initialize()
	return _items.get(id, null)

func get_item_by_name(item_name: String) -> ItemResource:
	if not _is_initialized:
		initialize()
	return _items_by_name.get(item_name.to_lower(), null)

func get_all_items() -> Array[ItemResource]:
	if not _is_initialized:
		initialize()
	var res: Array[ItemResource] = []
	for it in _items.values():
		res.append(it)
	return res

func get_items_by_category(category: ItemResource.Category) -> Array[ItemResource]:
	if not _is_initialized:
		initialize()
	var res: Array[ItemResource] = []
	for it in _items.values():
		if it.category == category:
			res.append(it)
	return res

func get_total_item_count() -> int:
	if not _is_initialized:
		initialize()
	return _items.size()

func register_ability(ability: AbilityResource) -> void:
	if ability == null:
		return
	_abilities[ability.id] = ability

func get_ability(id: String) -> AbilityResource:
	if not _is_initialized:
		initialize()
	return _abilities.get(id, null)

# --- 120 ITEM LOADER ---

func _load_all_120_items() -> void:
	var path = "res://data/items.json"
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		if file != null:
			var json_str = file.get_as_text()
			file.close()
			var parsed = JSON.parse_string(json_str)
			var item_list: Array = []
			if parsed is Array:
				item_list = parsed
			elif parsed is Dictionary and parsed.has("items") and parsed["items"] is Array:
				item_list = parsed["items"]
				
			if not item_list.is_empty():
				for item_dict in item_list:
					_register_item_from_dict(item_dict)
				return
				
	# Fallback if file read fails: register sample
	_register_fallback_items()

func _register_item_from_dict(d: Dictionary) -> void:
	var item = ItemResource.new()
	item.id = int(d.get("id", 0))
	item.item_name = str(d.get("name", "Item"))
	
	var cat_str = str(d.get("category", "BASE")).to_upper()
	match cat_str:
		"BASE": item.category = ItemResource.Category.BASE
		"BOOTS": item.category = ItemResource.Category.BOOTS
		"INTERMEDIATE": item.category = ItemResource.Category.INTERMEDIATE
		"LEGENDARY": item.category = ItemResource.Category.LEGENDARY
		"SUPPORT": item.category = ItemResource.Category.SUPPORT
		_: item.category = ItemResource.Category.BASE
		
	item.cost = int(d.get("cost", 0))
	item.build_path_role = str(d.get("build_path_role", ""))
	
	if d.has("active_desc"):
		item.description = str(d.get("active_desc", ""))
	elif d.has("passive_desc"):
		item.description = str(d.get("passive_desc", ""))
	elif d.has("description"):
		item.description = str(d.get("description", ""))
		
	if d.has("recipe"):
		var raw_recipe = d.get("recipe", [])
		if raw_recipe is Array:
			var typed_recipe: Array[int] = []
			for comp_id in raw_recipe:
				typed_recipe.append(int(comp_id))
			item.recipe_components = typed_recipe
			
	if d.has("stats"):
		var stats_dict = d.get("stats", {})
		if stats_dict is Dictionary:
			for key in stats_dict.keys():
				var stat_enum = _parse_stat_key(str(key))
				if stat_enum != -1:
					item.stat_bonuses[stat_enum] = float(stats_dict[key])
					
	register_item(item)

func _parse_stat_key(key: String) -> int:
	match key.to_upper():
		"AD", "ATTACK_DAMAGE": return StatModifier.TargetStat.ATTACK_DAMAGE
		"AP", "ABILITY_POWER": return StatModifier.TargetStat.ABILITY_POWER
		"AR", "ARMOR": return StatModifier.TargetStat.ARMOR
		"MR", "MAGIC_RESIST", "MAGIC_RESISTANCE": return StatModifier.TargetStat.MAGIC_RESIST
		"HP", "MAX_HEALTH", "HEALTH": return StatModifier.TargetStat.MAX_HEALTH
		"HP_REGEN", "HEALTH_REGEN": return StatModifier.TargetStat.HEALTH_REGEN
		"MP", "MAX_MANA", "MANA": return StatModifier.TargetStat.MAX_MANA
		"MP_REGEN", "MANA_REGEN": return StatModifier.TargetStat.MANA_REGEN
		"AS", "ATTACK_SPEED": return StatModifier.TargetStat.ATTACK_SPEED
		"MS", "MOVE_SPEED", "MOVEMENT_SPEED": return StatModifier.TargetStat.MOVE_SPEED
		"CRIT", "CRITICAL_CHANCE", "CRIT_CHANCE": return StatModifier.TargetStat.CRIT_CHANCE
		"CDR", "COOLDOWN_REDUCTION": return StatModifier.TargetStat.COOLDOWN_REDUCTION
		"LIFESTEAL": return StatModifier.TargetStat.LIFESTEAL
		"SPELL_VAMP": return StatModifier.TargetStat.SPELL_VAMP
		"PEN", "ARMOR_PEN", "ARMOR_PEN_FLAT": return StatModifier.TargetStat.ARMOR_PEN_FLAT
		"PEN_PERCENT", "ARMOR_PEN_PERCENT": return StatModifier.TargetStat.ARMOR_PEN_PERCENT
		"MAGIC_PEN", "MAGIC_PEN_FLAT": return StatModifier.TargetStat.MAGIC_PEN_FLAT
		"MAGIC_PEN_PERCENT": return StatModifier.TargetStat.MAGIC_PEN_PERCENT
		_: return -1

func _register_fallback_items() -> void:
	var iron_blade = ItemResource.new()
	iron_blade.id = 1
	iron_blade.item_name = "Iron Blade"
	iron_blade.category = ItemResource.Category.BASE
	iron_blade.cost = 350
	iron_blade.stat_bonuses[StatModifier.TargetStat.ATTACK_DAMAGE] = 10.0
	register_item(iron_blade)

func _register_sample_abilities() -> void:
	# Q: Molten Strike (Single target physical damage with AD scaling)
	var q_ability = AbilityResource.new()
	q_ability.id = "kaelgor_q"
	q_ability.ability_name = "Molten Fist"
	q_ability.slot = AbilityResource.Slot.Q
	q_ability.target_type = AbilityResource.TargetType.SINGLE_TARGET
	q_ability.cooldowns.assign([6.0, 5.5, 5.0, 4.5])
	q_ability.mana_costs.assign([50.0, 60.0, 70.0, 80.0])
	q_ability.base_damage.assign([80.0, 130.0, 180.0, 230.0])
	q_ability.scaling_stat = StatModifier.TargetStat.ATTACK_DAMAGE
	q_ability.scaling_ratio = 0.70
	q_ability.damage_type = DamageRequest.DamageType.PHYSICAL
	register_ability(q_ability)
	
	# W: Vent (AoE magic damage + slow)
	var w_ability = AbilityResource.new()
	w_ability.id = "kaelgor_w"
	w_ability.ability_name = "Vent"
	w_ability.slot = AbilityResource.Slot.W
	w_ability.target_type = AbilityResource.TargetType.GROUND_AOE
	w_ability.cooldowns.assign([10.0, 9.0, 8.0, 7.0])
	w_ability.mana_costs.assign([60.0, 70.0, 80.0, 90.0])
	w_ability.base_damage.assign([60.0, 100.0, 140.0, 180.0])
	w_ability.scaling_stat = StatModifier.TargetStat.ABILITY_POWER
	w_ability.scaling_ratio = 0.50
	w_ability.damage_type = DamageRequest.DamageType.MAGICAL
	w_ability.applies_status_effect = true
	w_ability.effect_type = StatusEffect.EffectType.SLOW
	w_ability.effect_duration = 2.5
	w_ability.effect_intensity = 0.35
	register_ability(w_ability)
	
	# E: Iron Hide (Defensive buff)
	var e_ability = AbilityResource.new()
	e_ability.id = "kaelgor_e"
	e_ability.ability_name = "Iron Hide"
	e_ability.slot = AbilityResource.Slot.E
	e_ability.target_type = AbilityResource.TargetType.SELF
	e_ability.cooldowns.assign([14.0, 13.0, 12.0, 11.0])
	e_ability.mana_costs.assign([40.0, 45.0, 50.0, 55.0])
	e_ability.base_damage.assign([0.0, 0.0, 0.0, 0.0])
	register_ability(e_ability)
	
	# R: Overheat (Ultimate)
	var r_ability = AbilityResource.new()
	r_ability.id = "kaelgor_r"
	r_ability.ability_name = "Overheat"
	r_ability.slot = AbilityResource.Slot.R
	r_ability.target_type = AbilityResource.TargetType.SELF
	r_ability.max_level = 3
	r_ability.cooldowns.assign([80.0, 70.0, 60.0])
	r_ability.mana_costs.assign([100.0, 125.0, 150.0])
	r_ability.base_damage.assign([150.0, 250.0, 350.0])
	register_ability(r_ability)
