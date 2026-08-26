class_name AbilityCastRequest
extends RefCounted

## Represents a request to cast a spell/ability in the MOBA runtime pipeline

var caster: Node = null
var slot: int = 1 # AbilityResource.Slot.Q
var ability: Resource = null
var target_entity: Node = null
var target_point: Vector3 = Vector3.ZERO
var is_free_cast: bool = false

static func create(p_caster: Node, p_slot: int, p_target_entity: Node = null, p_target_point: Vector3 = Vector3.ZERO, p_is_free: bool = false) -> RefCounted:
	var script = load("res://core/abilities/ability_cast_request.gd") as GDScript
	var req = script.new()
	req.caster = p_caster
	req.slot = p_slot
	req.target_entity = p_target_entity
	req.target_point = p_target_point
	req.is_free_cast = p_is_free
	if p_caster != null and "ability_container" in p_caster and p_caster.ability_container != null:
		req.ability = p_caster.ability_container.get_ability(p_slot)
	return req
