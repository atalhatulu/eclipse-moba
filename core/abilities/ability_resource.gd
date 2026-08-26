class_name AbilityResource
extends Resource

## Data-driven definition for hero abilities in Eclipse Front

enum Slot {
	PASSIVE,
	Q,
	W,
	E,
	R
}

enum TargetType {
	SELF,
	SINGLE_TARGET,
	DIRECTIONAL,
	GROUND_AOE,
	PASSIVE
}

enum TargetFilter {
	ENEMIES_ONLY,      # Enemy heroes, enemy creeps, neutral / jungle creeps, enemy structures
	ENEMY_HEROES_ONLY, # Only enemy heroes
	ENEMY_CREEPS_ONLY, # Only enemy creeps
	ALLIES_ONLY,       # Allied heroes, allied creeps, self
	ALLIES_NOT_SELF,   # Allied heroes/creeps excluding self
	ALLY_HEROES_ONLY,  # Allied heroes only
	SELF_ONLY,         # Only caster
	NEUTRALS_ONLY,     # Only neutral / jungle creeps (e.g. Devour / Hand of Midas)
	HEROES_ONLY,       # Enemy heroes only
	ALL_UNITS,         # Any living unit
	ALL_EXCEPT_SELF    # Any living unit except caster
}

@export var id: String = "ability_q"
@export var ability_name: String = "Ability"
@export var slot: Slot = Slot.Q
@export var target_type: TargetType = TargetType.SINGLE_TARGET
@export var target_filter: TargetFilter = TargetFilter.ENEMIES_ONLY
@export var is_passive: bool = false
@export var description: String = ""

@export var max_level: int = 4
@export var cooldowns: Array[float] = [8.0, 7.0, 6.0, 5.0]
@export var mana_costs: Array[float] = [60.0, 70.0, 80.0, 90.0]
@export var cast_range: float = 600.0
@export var aoe_radius: float = 0.0
@export var projectile_speed: float = 24.0
@export var cast_time: float = 0.25
@export var channel_time: float = 0.0

@export var base_damage: Array[float] = [75.0, 125.0, 175.0, 225.0]
@export var scaling_stat: StatModifier.TargetStat = StatModifier.TargetStat.ATTACK_DAMAGE
@export var scaling_ratio: float = 0.60
@export var damage_type: DamageRequest.DamageType = DamageRequest.DamageType.MAGICAL

@export_group("Status Effect Application")
@export var applies_status_effect: bool = false
@export var effect_type: StatusEffect.EffectType = StatusEffect.EffectType.SLOW
@export var effect_duration: float = 2.0
@export var effect_intensity: float = 0.30

func get_cooldown(lvl: int) -> float:
	var idx = clampi(lvl - 1, 0, cooldowns.size() - 1)
	return cooldowns[idx] if idx < cooldowns.size() else 0.0

func get_mana_cost(lvl: int) -> float:
	var idx = clampi(lvl - 1, 0, mana_costs.size() - 1)
	return mana_costs[idx] if idx < mana_costs.size() else 0.0

func get_base_damage(lvl: int) -> float:
	var idx = clampi(lvl - 1, 0, base_damage.size() - 1)
	return base_damage[idx] if idx < base_damage.size() else 0.0

func get_cast_range(_lvl: int = 1) -> float:
	return cast_range / 100.0 if cast_range > 50.0 else cast_range

func is_valid_target(caster: BaseCombatEntity, target: BaseCombatEntity) -> bool:
	if caster == null or target == null or not is_instance_valid(target) or not target.is_alive() or not target.is_targetable:
		return false
		
	var is_self = (caster == target)
	var is_same_team = (caster.team == target.team)
	var is_neutral = (target.team == TeamDefinitions.Team.NEUTRAL or target is NeutralCreepEntity)
	var is_enemy = (not is_same_team and not is_neutral)
	var is_hero = (target is HeroEntity)
	var is_creep = (target is CreepEntity and not (target is NeutralCreepEntity))
	
	match target_filter:
		TargetFilter.ENEMIES_ONLY:
			return (is_enemy or is_neutral) and not is_self
		TargetFilter.ENEMY_HEROES_ONLY:
			return is_hero and is_enemy and not is_self
		TargetFilter.ENEMY_CREEPS_ONLY:
			return is_creep and is_enemy and not is_self
		TargetFilter.ALLIES_ONLY:
			return is_same_team
		TargetFilter.ALLIES_NOT_SELF:
			return is_same_team and not is_self
		TargetFilter.ALLY_HEROES_ONLY:
			return is_hero and is_same_team and not is_self
		TargetFilter.SELF_ONLY:
			return is_self
		TargetFilter.NEUTRALS_ONLY:
			return is_neutral
		TargetFilter.HEROES_ONLY:
			return is_hero and (is_enemy or is_neutral)
		TargetFilter.ALL_UNITS:
			return true
		TargetFilter.ALL_EXCEPT_SELF:
			return not is_self
	return true

# Extensible hooks for custom logic
func on_projectile_hit(_caster: BaseCombatEntity, _target: BaseCombatEntity, _impact_point: Vector3) -> void:
	pass

func on_aoe_triggered(_caster: BaseCombatEntity, _center_point: Vector3, _affected_entities: Array[BaseCombatEntity]) -> void:
	pass
