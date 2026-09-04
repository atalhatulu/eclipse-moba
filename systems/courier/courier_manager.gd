class_name CourierManager
extends Node

## Manages Radiant and Dire team couriers in Eclipse Front

const CourierEntityClass = preload("res://systems/courier/courier_entity.gd")

static var radiant_courier: CharacterBody3D = null
static var dire_courier: CharacterBody3D = null

static func register_courier(courier: CharacterBody3D) -> void:
	if courier == null:
		return
	if courier.team == TeamDefinitions.Team.RADIANT:
		radiant_courier = courier
	else:
		dire_courier = courier

static func get_courier_for_team(team: int) -> CharacterBody3D:
	return radiant_courier if team == TeamDefinitions.Team.RADIANT else dire_courier

static func deliver_for_hero(hero: BaseCombatEntity) -> bool:
	if hero == null:
		return false
	var c = get_courier_for_team(hero.team)
	if c != null and is_instance_valid(c):
		c.deliver_items_to(hero)
		return true
	return false

static func speed_burst_for_hero(hero: BaseCombatEntity) -> bool:
	if hero == null:
		return false
	var c = get_courier_for_team(hero.team)
	if c != null and is_instance_valid(c):
		return c.activate_burst()
	return false
