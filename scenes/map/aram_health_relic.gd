class_name AramHealthRelic
extends Node3D

## A contested bridge objective: the first nearby living hero claims it, then
## nearby allies receive a meaningful heal/mana refill.  It creates a visible
## reason to contest side positions instead of permanently brawling at center.

@export var pickup_radius: float = 2.4
@export var ally_radius: float = 7.0
@export var respawn_seconds: float = 75.0
@export var health_restore_ratio: float = 0.18
@export var mana_restore_ratio: float = 0.20

var active := true
var respawn_remaining := 0.0
var crystal: MeshInstance3D = null

func _ready() -> void:
	add_to_group("aram_health_relics")
	_create_visual()

func _process(delta: float) -> void:
	if not active:
		respawn_remaining -= delta
		if respawn_remaining <= 0.0:
			active = true
			if crystal != null:
				crystal.visible = true
		return
	var claimant = _find_claimant()
	if claimant != null:
		claim(claimant)

func claim(hero: HeroEntity) -> bool:
	if not active or hero == null or not is_instance_valid(hero) or not hero.is_alive():
		return false
	active = false
	respawn_remaining = respawn_seconds
	if crystal != null:
		crystal.visible = false
	var healed_count := 0
	var relic_pos = global_position if is_inside_tree() else position
	for ally in HeroEntity.active_heroes:
		if not is_instance_valid(ally) or not ally.is_alive() or ally.team != hero.team or ally.attribute_system == null:
			continue
		var ally_pos = ally.global_position if ally.is_inside_tree() else ally.position
		if ally_pos.distance_to(relic_pos) > ally_radius:
			continue
		var max_hp = ally.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
		var max_mana = ally.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
		CombatMechanics.heal(hero, ally, max_hp * health_restore_ratio, "Abyss Relic")
		ally.attribute_system.restore_mana(max_mana * mana_restore_ratio)
		healed_count += 1
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		GameEvents.combat_log_generated.emit("%s ABYSS RELIC aldı — %d müttefik iyileşti." % [hero.entity_name, healed_count])
		GameEvents.ability_cast.emit(hero, null, relic_pos, null)
	return true

func _find_claimant() -> HeroEntity:
	var best: HeroEntity = null
	var best_distance := INF
	var relic_pos = global_position if is_inside_tree() else position
	for hero in HeroEntity.active_heroes:
		if not is_instance_valid(hero) or not hero.is_alive():
			continue
		var hero_pos = hero.global_position if hero.is_inside_tree() else hero.position
		var distance = hero_pos.distance_to(relic_pos)
		if distance <= pickup_radius and distance < best_distance:
			best = hero
			best_distance = distance
	return best

func _create_visual() -> void:
	crystal = MeshInstance3D.new()
	crystal.name = "RelicCrystal"
	var mesh := SphereMesh.new()
	mesh.radius = 0.46
	mesh.height = 1.05
	crystal.mesh = mesh
	crystal.position.y = 0.85
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.18, 0.95, 0.88, 1.0)
	mat.emission_enabled = true
	mat.emission = Color(0.08, 0.70, 0.88, 1.0)
	crystal.material_override = mat
	add_child(crystal)
