class_name AbilityDefinition
extends AbilityResource

## Universal Data-Driven Ability Definition for Eclipse Front (Task 24)
## Supports all 30 MOBA heroes with rich targeting, scaling, movement, and projectile mechanics

enum BehaviorType {
	DAMAGE,
	HEAL,
	SHIELD,
	BUFF,
	DEBUFF,
	PROJECTILE,
	AOE,
	DASH,
	BLINK,
	CHANNEL
}

# Movement Properties (Dash / Blink)
@export_group("Movement Mechanics")
@export var is_movement_ability: bool = false
@export var is_blink: bool = false
@export var dash_distance: float = 6.0
@export var dash_speed: float = 20.0
@export var blink_range: float = 8.0

# Heal & Shield Parameters
@export_group("Healing & Shielding")
@export var is_healing_ability: bool = false
@export var heal_base: Array[float] = [50.0, 100.0, 150.0, 200.0]
@export var heal_scaling_ratio: float = 0.40
@export var heal_scaling_stat: StatModifier.TargetStat = StatModifier.TargetStat.ABILITY_POWER

@export var is_shielding_ability: bool = false
@export var shield_base: Array[float] = [75.0, 150.0, 225.0, 300.0]
@export var shield_duration: float = 4.0

# Projectile Visual Metadata
@export_group("Projectile Visuals")
@export var projectile_scene_path: String = ""
@export var projectile_color: Color = Color(0.2, 0.6, 1.0)
@export var projectile_radius: float = 0.35

# Custom Buff Modifiers
@export_group("Buff Modifiers")
@export var buff_stat: StatModifier.TargetStat = StatModifier.TargetStat.ATTACK_SPEED
@export var buff_type: StatModifier.Type = StatModifier.Type.FLAT
@export var buff_values: Array[float] = [0.20, 0.30, 0.40, 0.50]
@export var buff_duration: float = 5.0

func get_heal_amount(lvl: int, stat_val: float = 0.0) -> float:
	var idx = clampi(lvl - 1, 0, heal_base.size() - 1)
	var base = heal_base[idx] if idx < heal_base.size() else 0.0
	return base + (stat_val * heal_scaling_ratio)

func get_shield_amount(lvl: int) -> float:
	var idx = clampi(lvl - 1, 0, shield_base.size() - 1)
	return shield_base[idx] if idx < shield_base.size() else 0.0

func get_buff_value(lvl: int) -> float:
	var idx = clampi(lvl - 1, 0, buff_values.size() - 1)
	return buff_values[idx] if idx < buff_values.size() else 0.0

# Virtual Extension Hooks
func on_movement_started(_caster: BaseCombatEntity, _target_pos: Vector3) -> void:
	pass

func on_movement_completed(_caster: BaseCombatEntity, _target_pos: Vector3) -> void:
	pass

func on_cast_started(_caster: BaseCombatEntity, _slot: AbilityResource.Slot) -> void:
	pass

func on_cast_interrupted(_caster: BaseCombatEntity, _slot: AbilityResource.Slot, _reason: String) -> void:
	pass

func on_cast_completed(_caster: BaseCombatEntity, _slot: AbilityResource.Slot) -> void:
	pass
