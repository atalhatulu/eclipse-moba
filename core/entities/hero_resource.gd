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
@export var title: String = ""
@export var lore: String = ""
@export var role: String = "Bruiser"
@export var role_description: String = "Bruiser"
@export var difficulty: int = 1 # 1 (Easy) - 3 (Hard)
@export var tags: Array[String] = []
@export var primary_attribute: AttributeSystem.PrimaryAttributeType = AttributeSystem.PrimaryAttributeType.STRENGTH
@export var attack_type: AttackType = AttackType.MELEE

@export_group("Primary Attributes & Growths")
@export var base_strength: float = 25.0
@export var strength_growth: float = 3.2
@export var base_agility: float = 18.0
@export var agility_growth: float = 1.8
@export var base_intelligence: float = 16.0
@export var intelligence_growth: float = 1.5

@export_group("Base Core Stats & Growths")
@export var base_health: float = 240.0
@export var health_growth: float = 0.0
@export var base_health_regen: float = 2.0
@export var health_regen_growth: float = 0.0
@export var base_mana: float = 120.0
@export var mana_growth: float = 0.0
@export var base_mana_regen: float = 1.2
@export var mana_regen_growth: float = 0.0
@export var base_attack_damage: float = 38.0
@export var attack_damage_growth: float = 0.0
@export var base_ability_power: float = 0.0
@export var base_armor: float = 2.5
@export var armor_growth: float = 0.0
@export var base_magic_resist: float = 28.0
@export var magic_resist_growth: float = 0.0
@export var base_attack_speed: float = 0.68
@export var attack_speed_growth: float = 0.0
@export var base_move_speed: float = 315.0
@export var base_attack_range: float = 150.0

@export_group("Projectile Settings")
@export var projectile_scene_path: String = "res://scenes/effects/basic_attack_projectile_3d.gd"
@export var projectile_speed: float = 24.0
@export var projectile_color: Color = Color(1.0, 0.8, 0.2)
@export var projectile_radius: float = 0.4

@export_group("Abilities")
@export var abilities: Array[AbilityResource] = []
@export var passive_ability: AbilityResource = null
@export var q_ability: AbilityResource = null
@export var w_ability: AbilityResource = null
@export var e_ability: AbilityResource = null
@export var r_ability: AbilityResource = null

func get_ability_by_slot(slot: AbilityResource.Slot) -> AbilityResource:
	match slot:
		AbilityResource.Slot.PASSIVE: return passive_ability
		AbilityResource.Slot.Q: return q_ability
		AbilityResource.Slot.W: return w_ability
		AbilityResource.Slot.E: return e_ability
		AbilityResource.Slot.R: return r_ability
	return null

func get_all_abilities() -> Array[AbilityResource]:
	var list: Array[AbilityResource] = []
	if passive_ability != null: list.append(passive_ability)
	if q_ability != null: list.append(q_ability)
	if w_ability != null: list.append(w_ability)
	if e_ability != null: list.append(e_ability)
	if r_ability != null: list.append(r_ability)
	return list
