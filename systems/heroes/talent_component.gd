class_name TalentComponent
extends Node

## Persistent, mutually-exclusive talent choices.  The component owns choices
## and modifiers so HUD, bot and future draft/network layers all ask the same
## authority instead of applying display-only bonuses.

signal talent_unlocked(tier: int)
signal talent_chosen(tier: int, branch: int, option: Dictionary)

const TIER_LEVELS := [10, 15, 20, 25]
var hero: HeroEntity = null
var chosen_branches: Dictionary = {} # level -> 0 (left) / 1 (right)

func _ready() -> void:
	if hero == null and get_parent() is HeroEntity:
		hero = get_parent() as HeroEntity

func get_available_tier() -> int:
	if hero == null or hero.attribute_system == null:
		return -1
	for tier in TIER_LEVELS:
		if hero.attribute_system.level >= tier and not chosen_branches.has(tier):
			return tier
	return -1

func get_options(tier: int) -> Array[Dictionary]:
	match tier:
		10:
			return [_option("Vanguard Heart", "+200 Maks. Can", StatModifier.TargetStat.MAX_HEALTH, StatModifier.Type.FLAT, 200.0), _option("Swift Hands", "+35% Saldırı Hızı", StatModifier.TargetStat.ATTACK_SPEED, StatModifier.Type.FLAT, 0.35)]
		15:
			return [_option("Arcane Focus", "+15% Büyü Gücü", StatModifier.TargetStat.ABILITY_POWER, StatModifier.Type.PERCENT_ADD, 0.15), _option("Windrunner", "+30 Hareket Hızı", StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.FLAT, 30.0)]
		20:
			return [_option("Execution Edge", "+30 Saldırı Hasarı", StatModifier.TargetStat.ATTACK_DAMAGE, StatModifier.Type.FLAT, 30.0), _option("Bulwark", "+8 Zırh", StatModifier.TargetStat.ARMOR, StatModifier.Type.FLAT, 8.0)]
		25:
			return [_option("Spellweaver", "+20% Bekleme Süresi Azaltma", StatModifier.TargetStat.COOLDOWN_REDUCTION, StatModifier.Type.PERCENT_ADD, 0.20), _option("Aegis Mind", "+25% Büyü Direnci", StatModifier.TargetStat.MAGIC_RESIST, StatModifier.Type.PERCENT_ADD, 0.25)]
	return []

func choose(tier: int, branch: int) -> bool:
	if hero == null or hero.attribute_system == null or tier != get_available_tier() or branch < 0:
		return false
	var options = get_options(tier)
	if branch >= options.size():
		return false
	var option: Dictionary = options[branch]
	var source = "talent_%d" % tier
	hero.attribute_system.remove_modifiers_by_source(source)
	hero.attribute_system.add_modifier(StatModifier.new(option.stat, option.type, option.value, source))
	chosen_branches[tier] = branch
	talent_chosen.emit(tier, branch, option)
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("%s talent seçti — %s: %s" % [hero.entity_name, option.name, option.description])
	return true

func _option(label: String, description: String, stat: StatModifier.TargetStat, type: StatModifier.Type, value: float) -> Dictionary:
	return {"name": label, "description": description, "stat": stat, "type": type, "value": value}
