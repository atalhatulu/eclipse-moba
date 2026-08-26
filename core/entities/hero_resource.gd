class_name HeroResource
extends Resource

## Data-driven definition for playable hero archetypes in Eclipse Front

enum AttackType {
	MELEE,
	RANGED
}

@export var hero_id: String = "kaelgor"
@export var id: String = "kaelgor"
@export var hero_name: String = "Kaelgor"
@export var role: String = "Bruiser"
@export var role_description: String = "Bruiser"
@export var primary_attribute: AttributeSystem.PrimaryAttributeType = AttributeSystem.PrimaryAttributeType.STRENGTH
@export var attack_type: AttackType = AttackType.MELEE

@export_group("Primary Attributes & Growths")
@export var base_strength: float = 25.0
@export var strength_growth: float = 3.2
@export var base_agility: float = 18.0
@export var agility_growth: float = 1.8
@export var base_intelligence: float = 16.0
@export var intelligence_growth: float = 1.5

@export_group("Base Core Stats")
@export var base_health: float = 240.0
@export var base_health_regen: float = 2.0
@export var base_mana: float = 120.0
@export var base_mana_regen: float = 1.2
@export var base_attack_damage: float = 38.0
@export var base_ability_power: float = 0.0
@export var base_armor: float = 2.5
@export var base_magic_resist: float = 28.0
@export var base_attack_speed: float = 0.68
@export var base_move_speed: float = 315.0
@export var base_attack_range: float = 150.0

@export_group("Abilities")
@export var abilities: Array[AbilityResource] = []
@export var passive_ability: AbilityResource = null
@export var q_ability: AbilityResource = null
@export var w_ability: AbilityResource = null
@export var e_ability: AbilityResource = null
@export var r_ability: AbilityResource = null
