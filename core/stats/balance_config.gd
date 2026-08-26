class_name BalanceConfig
extends Resource

## Central mathematical balance parameters for Eclipse Front MOBA

# --- Primary Attribute Conversions ---
@export_group("Strength Conversions")
@export var str_to_hp: float = 20.0
@export var str_to_hp_regen: float = 0.10
@export var str_to_primary_ad: float = 1.0

@export_group("Agility Conversions")
@export var agi_to_armor: float = 0.142857 # ~7 Agility gives 1 Armor
@export var agi_to_attack_speed_pct: float = 0.01 # 1 Agility gives +1% Attack Speed
@export var agi_to_move_speed_flat: float = 0.05
@export var agi_to_primary_ad: float = 1.0

@export_group("Intelligence Conversions")
@export var int_to_mana: float = 12.0
@export var int_to_mana_regen: float = 0.05
@export var int_to_magic_amp_pct: float = 0.001 # 10 Intelligence gives +1% Magic Amp
@export var int_to_primary_ad: float = 1.0

# --- Combat Constants ---
@export_group("Combat Constants")
@export var resistance_constant: float = 100.0
@export var base_crit_damage_multiplier: float = 1.75
@export var max_cooldown_reduction: float = 0.40 # 40% cap
@export var min_move_speed: float = 100.0
@export var max_move_speed: float = 650.0

# --- Economy & Progression ---
@export_group("Economy & Progression")
@export var max_hero_level: int = 18
@export var base_xp_requirement: int = 200
@export var xp_growth_factor: float = 1.30
@export var passive_gold_interval: float = 1.0
@export var passive_gold_amount: int = 2
@export var item_sell_refund_ratio: float = 0.70

# --- Inventory Limits ---
@export_group("Inventory Limits")
@export var normal_inventory_slots: int = 6
@export var dedicated_boots_slots: int = 1

static var _default_instance: BalanceConfig = null

static func get_default() -> BalanceConfig:
	if _default_instance == null:
		_default_instance = BalanceConfig.new()
	return _default_instance
