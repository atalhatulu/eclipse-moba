class_name DummyEntity
extends BaseCombatEntity

## Target dummy for testing abilities, damage output, status effects, and DPS

signal dps_updated(total_damage: float, dps: float)

@export var configured_armor: float = 20.0
@export var configured_mr: float = 20.0

var total_damage_taken: float = 0.0
var dps_damage_accumulator: float = 0.0
var dps_time_elapsed: float = 0.0
var current_dps: float = 0.0

func _ready() -> void:
	entity_name = "Combat Dummy"
	team = TeamDefinitions.Team.DIRE
	super._ready()
	
	attribute_system.base_health = 100000.0
	attribute_system.base_health_regen = 5000.0 # Rapid regen
	attribute_system.base_armor = configured_armor
	attribute_system.base_magic_resist = configured_mr
	attribute_system.recalculate_all_stats()
	attribute_system.heal(attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))

func _process(delta: float) -> void:
	super._process(delta)
	
	if dps_time_elapsed > 0.0:
		dps_time_elapsed += delta
		if dps_time_elapsed >= 5.0: # Reset DPS window every 5 seconds of inactivity
			dps_time_elapsed = 0.0
			dps_damage_accumulator = 0.0
			current_dps = 0.0
			dps_updated.emit(total_damage_taken, current_dps)

func receive_damage(request: DamageRequest) -> DamageResult:
	var res = super.receive_damage(request)
	if res != null and res.final_health_damage > 0.0:
		total_damage_taken += res.final_health_damage
		dps_damage_accumulator += res.final_health_damage
		dps_time_elapsed += 0.001 # Start timer
		current_dps = dps_damage_accumulator / maxf(1.0, dps_time_elapsed)
		dps_updated.emit(total_damage_taken, current_dps)
	return res

func reset_damage_stats() -> void:
	total_damage_taken = 0.0
	dps_damage_accumulator = 0.0
	dps_time_elapsed = 0.0
	current_dps = 0.0
	attribute_system.heal(attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
	dps_updated.emit(0.0, 0.0)
