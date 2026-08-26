class_name DamageResult
extends RefCounted

## Represents the finalized outcome of a combat damage interaction

var raw_damage: float = 0.0
var mitigated_damage: float = 0.0
var shield_absorbed: float = 0.0
var final_health_damage: float = 0.0
var is_critical: bool = false
var is_fatal: bool = false
var lifesteal_healed: float = 0.0
var spell_vamp_healed: float = 0.0
var damage_type: DamageRequest.DamageType = DamageRequest.DamageType.PHYSICAL
var source_name: String = ""
