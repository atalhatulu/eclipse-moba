class_name DamageRequest
extends RefCounted

## Represents a request to deal damage from an attacker to a target

enum DamageType {
	PHYSICAL,
	MAGICAL,
	TRUE_DAMAGE
}

var attacker: Node = null
var target: Node = null
var base_damage: float = 0.0
var damage_type: DamageType = DamageType.PHYSICAL

var is_ability: bool = false
var is_critical: bool = false
var crit_multiplier: float = 1.75

var armor_pen_flat: float = 0.0
var armor_pen_percent: float = 0.0
var magic_pen_flat: float = 0.0
var magic_pen_percent: float = 0.0

var lifesteal: float = 0.0
var spell_vamp: float = 0.0
var damage_amplification: float = 0.0
var damage_reduction: float = 0.0

var source_name: String = ""

static func create_basic_attack(p_attacker: Node, p_target: Node, p_damage: float) -> DamageRequest:
	var req = DamageRequest.new()
	req.attacker = p_attacker
	req.target = p_target
	req.base_damage = p_damage
	req.damage_type = DamageType.PHYSICAL
	req.is_ability = false
	return req

static func create_spell_damage(p_attacker: Node, p_target: Node, p_damage: float, p_type: DamageType, p_spell_name: String = "") -> DamageRequest:
	var req = DamageRequest.new()
	req.attacker = p_attacker
	req.target = p_target
	req.base_damage = p_damage
	req.damage_type = p_type
	req.is_ability = true
	req.source_name = p_spell_name
	return req

static func create_ability_damage(p_attacker: Node, p_target: Node, p_damage: float, p_type: DamageType, p_spell_name: String = "") -> DamageRequest:
	return create_spell_damage(p_attacker, p_target, p_damage, p_type, p_spell_name)
