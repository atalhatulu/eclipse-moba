class_name AbilityInstance
extends RefCounted

## Runtime Instance of a Hero Ability in Eclipse Front (Task 24)
## Encapsulates real-time state, cooldowns, level, and cast execution

enum AbilityState {
	NOT_LEARNED,
	READY,
	CASTING,
	CHANNELING,
	COOLDOWN,
	DISABLED
}

var definition: Resource = null
var slot: int = 1 # AbilityResource.Slot.Q
var level: int = 0
var cooldown_remaining: float = 0.0
var max_cooldown: float = 0.0
var cast_time_remaining: float = 0.0
var channel_time_remaining: float = 0.0

var caster: Node = null
var container: Node = null

func _init(p_def: Resource = null, p_slot: int = 1, p_caster: Node = null, p_container: Node = null) -> void:
	definition = p_def
	slot = p_slot
	caster = p_caster
	container = p_container
	if definition != null and "is_passive" in definition and definition.is_passive:
		level = 1

func get_current_level() -> int:
	if container != null and "ability_levels" in container:
		return container.ability_levels.get(slot, level)
	return level

func get_state() -> AbilityState:
	var cur_lvl = get_current_level()
	if definition == null or (cur_lvl <= 0 and not ("is_passive" in definition and definition.is_passive)):
		return AbilityState.NOT_LEARNED
		
	if caster != null:
		if caster.has_method("is_alive") and not caster.is_alive():
			return AbilityState.DISABLED
		if "effect_container" in caster and caster.effect_container != null:
			if caster.effect_container.is_silenced() or caster.effect_container.is_stunned():
				return AbilityState.DISABLED
			
	if cast_time_remaining > 0.0:
		return AbilityState.CASTING
		
	if channel_time_remaining > 0.0:
		return AbilityState.CHANNELING
		
	if cooldown_remaining > 0.0:
		return AbilityState.COOLDOWN
		
	return AbilityState.READY

func is_ready() -> bool:
	return get_state() == AbilityState.READY

func is_on_cooldown() -> bool:
	return cooldown_remaining > 0.0

func is_casting() -> bool:
	return cast_time_remaining > 0.0

func is_learned() -> bool:
	var cur_lvl = get_current_level()
	return cur_lvl > 0 or (definition != null and "is_passive" in definition and definition.is_passive)

func get_mana_cost() -> float:
	var cur_lvl = get_current_level()
	if definition == null or cur_lvl <= 0:
		return 0.0
	if definition.has_method("get_mana_cost"):
		return definition.get_mana_cost(cur_lvl)
	return 0.0

func get_cooldown() -> float:
	var cur_lvl = get_current_level()
	if definition == null or cur_lvl <= 0:
		return 0.0
	var base_cd = 0.0
	if definition.has_method("get_cooldown"):
		base_cd = definition.get_cooldown(cur_lvl)
	if caster != null and "attribute_system" in caster and caster.attribute_system != null:
		var cdr = caster.attribute_system.get_stat(StatModifier.TargetStat.COOLDOWN_REDUCTION)
		return base_cd * (1.0 - cdr)
	return base_cd

func get_cast_range() -> float:
	var cur_lvl = get_current_level()
	if definition == null or cur_lvl <= 0:
		return 0.0
	if definition.has_method("get_cast_range"):
		return definition.get_cast_range(cur_lvl)
	return 0.0

func get_base_damage() -> float:
	var cur_lvl = get_current_level()
	if definition == null or cur_lvl <= 0:
		return 0.0
	if definition.has_method("get_base_damage"):
		return definition.get_base_damage(cur_lvl)
	return 0.0

func tick_cooldown(delta: float) -> void:
	if cooldown_remaining > 0.0:
		cooldown_remaining = maxf(0.0, cooldown_remaining - delta)

func start_cooldown(custom_cd: float = -1.0) -> void:
	var cd = custom_cd if custom_cd >= 0.0 else get_cooldown()
	cooldown_remaining = cd
	max_cooldown = cd

func reset_cooldown() -> void:
	cooldown_remaining = 0.0
	max_cooldown = 0.0

func level_up() -> int:
	if definition != null and "max_level" in definition and level < definition.max_level:
		level += 1
	return level
