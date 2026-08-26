class_name FountainHealingArea
extends Area3D

## Fountain healing and protection zone at team base spawns

@export var team: TeamDefinitions.Team = TeamDefinitions.Team.RADIANT
@export var heal_percent_per_sec: float = 0.12 # 12% Max HP/MP per second
@export var attack_damage_per_sec: float = 350.0 # True damage per second to invading enemies

var entities_in_fountain: Array[BaseCombatEntity] = []

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node3D) -> void:
	if body is BaseCombatEntity and body not in entities_in_fountain:
		entities_in_fountain.append(body)

func _on_body_exited(body: Node3D) -> void:
	if body is BaseCombatEntity and body in entities_in_fountain:
		entities_in_fountain.erase(body)

func _process(delta: float) -> void:
	for ent in entities_in_fountain:
		if ent == null or not ent.is_alive():
			continue
			
		if ent.team == team:
			# Friendly unit: Heal HP & MP
			var max_hp = ent.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
			var max_mp = ent.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
			ent.attribute_system.heal(max_hp * heal_percent_per_sec * delta)
			ent.attribute_system.restore_mana(max_mp * heal_percent_per_sec * delta)
		else:
			# Enemy trespasser: Pure True Damage
			var req = DamageRequest.create_ability_damage(
				null, ent, attack_damage_per_sec * delta, DamageRequest.DamageType.TRUE_DAMAGE, "Fountain Turret"
			)
			CombatCalculator.execute_damage(req)
