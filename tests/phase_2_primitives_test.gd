class_name Phase2PrimitivesTest
extends RefCounted

## Unit and Integration Test Suite for Phase 2 Engine Primitives:
## 1. SummonManager (Aethon Constructs & Rivena Shades)
## 2. StateHistorySystem (Nymera Snapshots & Rewind)
## 3. SpatialManager (Neris Nodes/Walls/Gates & Seris Traps)
## 4. SpellObserverSystem (Veylin Cast Observation & Mimicry)
## 5. TetherManager (Oryn/Selka/Auron/Tharos Damage Redirection & Loop Protection)

const SummonManagerClass = preload("res://systems/summons/summon_manager.gd")
const StateHistorySystemClass = preload("res://systems/history/state_history_system.gd")
const SpatialManagerClass = preload("res://systems/spatial/spatial_manager.gd")
const SpellObserverSystemClass = preload("res://systems/spells/spell_observer_system.gd")
const TetherManagerClass = preload("res://systems/tether/tether_manager.gd")

func run_all() -> Dictionary:
	var results: Dictionary = {}
	results["summon_manager"] = test_summon_manager()
	results["state_history"] = test_state_history()
	results["spatial_manager"] = test_spatial_manager()
	results["spell_observer"] = test_spell_observer()
	results["tether_manager"] = test_tether_manager()
	results["red_heroes_integration"] = test_red_heroes_integration()
	
	var is_all_pass = true
	for k in results.keys():
		if results[k] != "":
			is_all_pass = false
			break
			
	return {
		"is_pass": is_all_pass,
		"results": results
	}

func test_summon_manager() -> String:
	SummonManagerClass.clear_all()
	var aethon = HeroDefinition.create_hero_instance("aethon")
	aethon._ready()
	aethon.team = TeamDefinitions.Team.RADIANT
	
	# 1. Spawn Guardian & Cannon
	var g = SummonManagerClass.spawn_construct(aethon, SummonManagerClass.ConstructType.GUARDIAN, Vector3(0, 0, 1), 350.0, 45.0, 15.0)
	var c = SummonManagerClass.spawn_construct(aethon, SummonManagerClass.ConstructType.CANNON, Vector3(1, 0, 1), 250.0, 55.0, 15.0)
	
	if SummonManagerClass.get_construct_count(aethon) != 2:
		aethon.free()
		return "Expected 2 constructs for Aethon"
		
	# 2. Reconfigure constructs
	var reconfig_count = SummonManagerClass.reconfigure_constructs(aethon)
	if reconfig_count != 2:
		aethon.free()
		return "Expected 2 constructs reconfigured"
		
	# 3. Assemble Siege
	var siege = SummonManagerClass.assemble_siege_construct(aethon, Vector3(0, 0, 2))
	if siege.is_empty() or SummonManagerClass.get_construct_count(aethon) != 1:
		aethon.free()
		return "Expected 1 merged Siege construct"
		
	# 4. Rivena Shade & Swap
	var rivena = HeroDefinition.create_hero_instance("rivena")
	rivena._ready()
	rivena.team = TeamDefinitions.Team.RADIANT
	rivena.position = Vector3(0, 0, 0)
	
	SummonManagerClass.spawn_shade(rivena, Vector3(5, 0, 5))
	if SummonManagerClass.get_shade_count(rivena) != 1:
		aethon.free()
		rivena.free()
		return "Expected 1 Rivena shade"
		
	var swap_pos = SummonManagerClass.swap_with_shade(rivena)
	if swap_pos != Vector3(5, 0, 5) or SummonManagerClass.get_shade_count(rivena) != 0:
		aethon.free()
		rivena.free()
		return "Expected Rivena shade swap to (5, 0, 5)"
		
	# 5. Cleanup
	SummonManagerClass.cleanup_owner_summons(aethon)
	SummonManagerClass.cleanup_owner_summons(rivena)
	if SummonManagerClass.get_construct_count(aethon) != 0 or SummonManagerClass.get_shade_count(rivena) != 0:
		aethon.free()
		rivena.free()
		return "Expected complete summon cleanup"
		
	aethon.free()
	rivena.free()
	return ""

func test_state_history() -> String:
	StateHistorySystemClass.clear_all()
	var nymera = HeroDefinition.create_hero_instance("nymera")
	nymera._ready()
	nymera.team = TeamDefinitions.Team.RADIANT
	nymera.position = Vector3(0, 0, 0)
	
	var initial_hp = nymera.attribute_system.current_health
	
	# Record snapshot at t=0.0
	StateHistorySystemClass.record_snapshot(nymera, 0.0)
	
	# Move and damage entity at t=4.0
	nymera.position = Vector3(10, 0, 10)
	nymera.attribute_system.current_health = initial_hp - 200.0
	StateHistorySystemClass.record_snapshot(nymera, 4.0)
	
	# Test window damage taken
	var dmg_taken = StateHistorySystemClass.get_damage_taken_in_window(nymera, 4.0, 4.0)
	if absf(dmg_taken - 200.0) > 1.0:
		nymera.free()
		return "Expected 200 damage taken in window, got %f" % dmg_taken
		
	# Test rewind
	var rewind_res = StateHistorySystemClass.rewind_entity(nymera, 4.0, 4.0)
	if rewind_res.get("to_pos") != Vector3(0, 0, 0):
		nymera.free()
		return "Expected rewind to position (0, 0, 0)"
	if absf(nymera.attribute_system.current_health - initial_hp) > 1.0:
		nymera.free()
		return "Expected health restored to initial after rewind"
		
	StateHistorySystemClass.clear_entity_history(nymera)
	nymera.free()
	return ""

func test_spatial_manager() -> String:
	SpatialManagerClass.clear_all()
	var neris = HeroDefinition.create_hero_instance("neris")
	neris._ready()
	
	# Neris Spatial Objects
	SpatialManagerClass.create_node(neris, Vector3(0, 0, 0))
	SpatialManagerClass.create_node(neris, Vector3(5, 0, 0))
	SpatialManagerClass.create_wall(neris, Vector3(0, 0, 0), Vector3(5, 0, 0), 8.0, 150.0)
	SpatialManagerClass.create_gate(neris, Vector3(0, 0, 0), Vector3(10, 0, 10), 10.0)
	
	var nodes = SpatialManagerClass.get_owner_objects(neris, SpatialManagerClass.SpatialType.NODE)
	var walls = SpatialManagerClass.get_owner_objects(neris, SpatialManagerClass.SpatialType.WALL)
	var gates = SpatialManagerClass.get_owner_objects(neris, SpatialManagerClass.SpatialType.GATE)
	
	if nodes.size() != 2 or walls.size() != 1 or gates.size() != 1:
		neris.free()
		return "Expected 2 nodes, 1 wall, 1 gate for Neris"
		
	# Seris Traps
	var seris = HeroDefinition.create_hero_instance("seris")
	seris._ready()
	
	SpatialManagerClass.place_trap(seris, Vector3(2, 0, 2))
	SpatialManagerClass.place_trap(seris, Vector3(4, 0, 4))
	
	var traps = SpatialManagerClass.get_owner_objects(seris, SpatialManagerClass.SpatialType.TRAP)
	if traps.size() != 2:
		neris.free()
		seris.free()
		return "Expected 2 traps placed for Seris"
		
	var detonated = SpatialManagerClass.detonate_all_traps(seris)
	if detonated != 2 or not SpatialManagerClass.get_owner_objects(seris, SpatialManagerClass.SpatialType.TRAP).is_empty():
		neris.free()
		seris.free()
		return "Expected 2 traps detonated and cleared"
		
	SpatialManagerClass.cleanup_owner_objects(neris)
	SpatialManagerClass.cleanup_owner_objects(seris)
	neris.free()
	seris.free()
	return ""

func test_spell_observer() -> String:
	SpellObserverSystemClass.clear_all()
	var astris = HeroDefinition.create_hero_instance("astris")
	var veylin = HeroDefinition.create_hero_instance("veylin")
	astris._ready()
	veylin._ready()
	astris.team = TeamDefinitions.Team.DIRE
	veylin.team = TeamDefinitions.Team.RADIANT
	astris.position = Vector3(0, 0, 5)
	veylin.position = Vector3(0, 0, 0)
	
	# 1. Record spell cast
	var q_res = astris.hero_resource.get_ability_by_slot(AbilityResource.Slot.Q)
	SpellObserverSystemClass.record_cast(astris, q_res, Vector3(0, 0, 0), veylin)
	
	# 2. Get last enemy cast
	var last_cast = SpellObserverSystemClass.get_last_enemy_cast(veylin, 15.0)
	if last_cast.is_empty() or last_cast.get("caster") != astris:
		astris.free()
		veylin.free()
		return "Expected last cast to be from Astris"
		
	# 3. Mimic Ability
	var mimicked = SpellObserverSystemClass.mimic_ability(veylin, astris)
	if mimicked == null or not mimicked.id.begins_with("veylin_mimic_"):
		astris.free()
		veylin.free()
		return "Expected mimicked ability instance for Veylin"
		
	# 4. Counterspell
	var countered = SpellObserverSystemClass.try_counter_spell(veylin, "Arcane Bolt")
	if not countered:
		astris.free()
		veylin.free()
		return "Expected counterspell to succeed"
		
	SpellObserverSystemClass.clear_all()
	astris.free()
	veylin.free()
	return ""

func test_tether_manager() -> String:
	TetherManagerClass.clear_all()
	var selka = HeroDefinition.create_hero_instance("selka")
	var enemy = HeroDefinition.create_hero_instance("kaelgor")
	selka._ready()
	enemy._ready()
	selka.team = TeamDefinitions.Team.RADIANT
	enemy.team = TeamDefinitions.Team.DIRE
	selka.position = Vector3(0, 0, 0)
	enemy.position = Vector3(0, 0, 3)
	
	# 1. Create Life Link tether (35% damage redirect from Selka to Enemy)
	var t = TetherManagerClass.create_tether(selka, enemy, TetherManagerClass.TetherType.LIFE_LINK, 0.35, 6.0, 12.0)
	if t.is_empty():
		selka.free()
		enemy.free()
		return "Failed to create Life Link tether"
		
	var selka_hp_before = selka.attribute_system.current_health
	var enemy_hp_before = enemy.attribute_system.current_health
	
	# 2. Apply 100 true damage to Selka
	var req = DamageRequest.new()
	req.attacker = enemy
	req.target = selka
	req.base_damage = 100.0
	req.damage_type = DamageRequest.DamageType.TRUE_DAMAGE
	
	CombatCalculator.execute_damage(req)
	
	var selka_hp_lost = selka_hp_before - selka.attribute_system.current_health
	var enemy_hp_lost = enemy_hp_before - enemy.attribute_system.current_health
	
	# Selka should take 65 damage, enemy should take 35 damage (due to redirect)
	if absf(selka_hp_lost - 65.0) > 3.0 or absf(enemy_hp_lost - 35.0) > 3.0:
		selka.free()
		enemy.free()
		return "Expected 65/35 damage split, got Selka lost %f, Enemy lost %f" % [selka_hp_lost, enemy_hp_lost]
		
	# 3. Test distance break
	enemy.position = Vector3(0, 0, 20.0) # Move beyond 12.0m max_dist
	TetherManagerClass.tick(0.1)
	if not TetherManagerClass.get_tethers_for_entity(selka).is_empty():
		selka.free()
		enemy.free()
		return "Expected tether to break on distance > 12m"
		
	TetherManagerClass.clear_all()
	selka.free()
	enemy.free()
	return ""

func test_red_heroes_integration() -> String:
	# Test that all 10 RED heroes can instantiate and execute their signature skills cleanly
	var red_hero_ids = ["aethon", "rivena", "nymera", "neris", "seris", "veylin", "oryn", "selka", "auron", "tharos"]
	
	for hid in red_hero_ids:
		var hero = HeroDefinition.create_hero_instance(hid)
		if hero == null:
			return "Failed to instantiate RED hero '%s'" % hid
		hero._ready()
		hero.team = TeamDefinitions.Team.RADIANT
		hero.position = Vector3.ZERO
		
		# Test QWER casting
		for slot in [AbilityResource.Slot.Q, AbilityResource.Slot.W, AbilityResource.Slot.E, AbilityResource.Slot.R]:
			var ab = hero.hero_resource.get_ability_by_slot(slot)
			if ab == null:
				hero.free()
				return "Hero '%s' missing ability in slot %d" % [hid, slot]
			hero.ability_container.ability_levels[slot] = 1
			hero.ability_container.cooldown_timers.clear()
			if hero.attribute_system != null:
				hero.attribute_system.restore_mana(9999.0)
				hero.attribute_system.heal(9999.0)
			hero.ability_container.cast_ability(slot, hero, Vector3(0, 0, -2))
			
		hero.free()
		
	return ""
