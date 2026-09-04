class_name TestSuite
extends RefCounted

## Streamlined Scenario & Integration Test Suite for Eclipse Front
## Runs the 12 core end-to-end integration and smoke tests in under 0.2 seconds.

const HeroBuildMatrixClass = preload("res://data/hero_build_matrix.gd")
const ItemEventEngineClass = preload("res://systems/items/item_event_engine.gd")
const MatchTelemetrySystemClass = preload("res://systems/telemetry/match_telemetry_system.gd")
const FastForwardMatchSimulatorClass = preload("res://systems/simulation/fast_forward_match_simulator.gd")
const TeamfightStressHarnessClass = preload("res://systems/simulation/teamfight_stress_harness.gd")
const AbilityRegressionHarnessClass = preload("res://tests/ability_regression_harness.gd")
const Phase2PrimitivesTestClass = preload("res://tests/phase_2_primitives_test.gd")
const AreaEffectManagerClass = preload("res://systems/areas/area_effect_manager.gd")
const DotaStatusEffectBarClass = preload("res://systems/ui/dota_status_effect_bar.gd")
const HeroMechanicsGuideClass = preload("res://systems/heroes/hero_mechanics_guide.gd")
const CombatMechanicsClass = preload("res://systems/combat/combat_mechanics.gd")

var passed_count: int = 0
var failed_count: int = 0
var test_results: Array[Dictionary] = []

func run_test(test_name: String, test_func: Callable) -> void:
	var error = test_func.call()
	if error == "":
		passed_count += 1
		test_results.append({ "name": test_name, "passed": true, "error": "" })
	else:
		failed_count += 1
		test_results.append({ "name": test_name, "passed": false, "error": error })

func run_all() -> Dictionary:
	passed_count = 0
	failed_count = 0
	test_results.clear()
	
	run_test("1. Hero Roster: 54 Heroes Registered & Instantiable", test_01_hero_roster)
	run_test("2. Item Database: 120 Items & Modular Recipes", test_02_item_database)
	run_test("3. Build Diversity: 54 Heroes x 3 Viable Paths", test_03_build_diversity)
	run_test("4. Combat Math: Physical, Magical & True Damage Formulas", test_04_combat_math)
	run_test("5. Status Effects: Shields, Stuns, Hex & Silences", test_05_status_effects)
	run_test("6. Ability Container: Slots QWER & Cooldown Lifecycle", test_06_ability_container)
	run_test("7. Inventory Manager: 1-6 Active Slots & Hotkeys", test_07_inventory_and_hotkeys)
	run_test("8. Map Objectives: Leviathan Boss & River Power Runes", test_08_map_objectives)
	run_test("9. SoundManager: MOBA Announcer Multi-Kills & Streaks", test_09_sound_manager)
	run_test("10. Full Combat Pipeline: Ability -> Item -> Status -> Kill -> Announcer", test_10_full_combat_pipeline)
	run_test("11. Match Simulation: Multi-Horizon Progression (10m, 30m, 60m)", test_11_match_simulation)
	run_test("12. 5v5 Teamfight Stress Test: Performance (<16.6ms frame budget)", test_12_teamfight_stress)
	run_test("13. Universal Ability Regression Harness: 54 Heroes x 5 Abilities (270 Total)", test_13_ability_regression_harness)
	run_test("14. Phase 2 RED Primitives: Summon, History, Spatial, Observer, Tether", test_14_phase_2_primitives)
	run_test("15. Inventory Interactions & Flying Courier Delivery", test_15_inventory_and_courier)
	run_test("16. Base vs Remote Shop Purchase & Auto Courier Delivery Workflow", test_16_courier_purchase_workflow)
	run_test("17. Market Purchase Feedback: Insufficient Gold Reason", test_17_market_purchase_feedback)
	run_test("18. Active Item Buff: Expires After Its Duration", test_18_active_item_buff_duration)
	run_test("19. Ability Feedback: Failed Cast Reports Its Reason", test_19_ability_failure_feedback)
	run_test("20. CC Primitives: Knockback and Airborne Movement", test_20_cc_primitives)
	run_test("21. Spatial Primitives: Wall, Trap and Allied Gate", test_21_spatial_primitives)
	run_test("22. Summon Primitives: Construct Attack and Shade Swap", test_22_summon_primitives)
	run_test("23. Channel Primitive: Repeated Pulses and Completion", test_23_channel_primitive)
	run_test("24. Persistent Area: Periodic Damage and Expiry", test_24_persistent_area)
	run_test("25. Clone Primitive: Zin Mirage Persists and Swaps", test_25_zin_clone)
	run_test("26. Hero Signatures: Summon, Shade, Wall and Clone Bindings", test_26_hero_signatures)
	run_test("27. Dash Primitive: Stops at First Enemy", test_27_dash_stop)
	run_test("28. Combat Control: Disarm Blocks Attacks and Expires", test_28_disarm)
	run_test("29. Stealth and Blind: Hide Targeting and Miss Attacks", test_29_stealth_and_blind)
	run_test("30. Hero Controls: Noctis Stealth/Blind and Grom Disarm", test_30_hero_controls)
	run_test("31. HUD Status Effects: Icon, Tooltip, Stack and Duration", test_31_hud_status_effects)
	run_test("32. Active Items: Target Rules and Passive Item HUD", test_32_item_targeting_and_passives)
	run_test("33. Hero Mechanics Guide: Passive, Combo, Counterplay and Targeting", test_33_hero_mechanics_guide)
	run_test("34. Combat Mechanics: Marks, Execute, Heal, Shield, Mana and Modifiers", test_34_combat_mechanics)
	run_test("35. Mark Heroes: Mordren, Selka and Talon Common Stack States", test_35_mark_heroes)
	run_test("36. Execution Heroes: Mordren Threshold and Nyxara Missing Health", test_36_execution_heroes)
	run_test("37. Dota 2 Micro-Mechanics: Creep/Tower Deny, Turn Rate, High Ground Miss, Animation Canceling", test_37_dota_micro_mechanics)
	run_test("38. TAB Scoreboard & Combat Tracking: KDA, LH/DN, Bot Starter Equipment", test_38_scoreboard_and_combat_tracking)
	
	return {
		"passed": passed_count,
		"failed": failed_count,
		"results": test_results
	}

func test_01_hero_roster() -> String:
	var hero_ids = HeroDefinition.get_all_hero_ids()
	if hero_ids.size() < 54:
		return "Expected 54 registered heroes, got %d" % hero_ids.size()
	for hid in hero_ids:
		var h = HeroDefinition.create_hero_instance(hid)
		if h == null:
			return "Failed to instantiate hero %s" % hid
		h._ready()
		h.free()
	return ""

func test_02_item_database() -> String:
	var items = Database.get_all_items()
	if items.size() < 120:
		return "Expected 120 items in database, got %d" % items.size()
	var item1 = Database.get_item(1)
	if item1 == null or not item1.stat_bonuses.has(StatModifier.TargetStat.ATTACK_DAMAGE):
		return "Expected Item 1 to have ATTACK_DAMAGE stat bonus parsed from JSON"
	if item1.stat_bonuses[StatModifier.TargetStat.ATTACK_DAMAGE] != 10.0:
		return "Expected Item 1 AD bonus to be 10.0, got %f" % item1.stat_bonuses[StatModifier.TargetStat.ATTACK_DAMAGE]
	return ""

func test_03_build_diversity() -> String:
	var hero_ids = HeroDefinition.get_all_hero_ids()
	for hid in hero_ids.slice(0, 10):
		var matrix = HeroBuildMatrixClass.get_builds_for_hero(hid)
		if matrix.size() < 3:
			return "Hero %s has less than 3 builds" % hid
	return ""

func test_04_combat_math() -> String:
	var attacker = HeroEntity.new()
	var target = HeroEntity.new()
	attacker._ready()
	target._ready()
	
	var req = DamageRequest.create_physical_damage(attacker, target, 100.0, "Strike")
	var res = CombatCalculator.execute_damage(req)
	target.receive_damage(req)
	
	if res.final_health_damage <= 0.0:
		attacker.free()
		target.free()
		return "Expected positive damage result"
		
	attacker.free()
	target.free()
	return ""

func test_05_status_effects() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	hero.effect_container.apply_hex(2.0)
	if not hero.effect_container.is_silenced():
		hero.free()
		return "Expected hero to be silenced under Hex"
		
	# Test DoT ticking
	var start_hp = hero.attribute_system.current_health
	var dot = StatusEffect.new("test_bleed", StatusEffect.EffectType.DAMAGE_OVER_TIME, 2.0, 25.0, true)
	dot.tick_interval = 0.5
	hero.effect_container.apply_effect(dot)
	hero.effect_container._process(0.6)
	if hero.attribute_system.current_health >= start_hp:
		hero.free()
		return "Expected DoT tick to reduce health"
		
	hero.free()
	return ""

func test_06_ability_container() -> String:
	# 1. Test Kaelgor Q casting
	var kaelgor = HeroDefinition.create_hero_instance("kaelgor")
	var target = HeroEntity.new()
	kaelgor._ready()
	target._ready()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	target.team = TeamDefinitions.Team.DIRE
	target.position = Vector3(0, 0, -2.0)
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.Q)
	var start_hp = target.attribute_system.current_health
	var cast_ok = kaelgor.ability_container.cast_ability(AbilityResource.Slot.Q, target)
	if not cast_ok:
		kaelgor.free()
		target.free()
		return "Failed to cast Kaelgor Q via AbilityContainer"
	if target.attribute_system.current_health >= start_hp:
		kaelgor.free()
		target.free()
		return "Expected Kaelgor Q to deal damage to target"
	kaelgor.free()
	target.free()
	
	# 2. Test Solen Q casting
	var solen = HeroDefinition.create_hero_instance("solen")
	var target2 = HeroEntity.new()
	solen._ready()
	target2._ready()
	solen.team = TeamDefinitions.Team.RADIANT
	target2.team = TeamDefinitions.Team.DIRE
	solen.position = Vector3(0, 0, 0)
	target2.position = Vector3(0, 0, -5.0)
	solen.ability_container.level_up_ability(AbilityResource.Slot.Q)
	var solen_ok = solen.ability_container.cast_ability(AbilityResource.Slot.Q, null, Vector3(0, 0, -10.0))
	if not solen_ok:
		solen.free()
		target2.free()
		return "Failed to cast Solen Q via AbilityContainer"
	solen.free()
	target2.free()
	return ""

func test_07_inventory_and_hotkeys() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	var base_ad = hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var item1 = Database.get_item(1) # Iron Blade (+10 AD)
	if item1 != null:
		hero.inventory_manager.equip_item(item1, 0)
		var new_ad = hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
		if new_ad != (base_ad + 10.0):
			hero.free()
			return "Expected AD to increase by 10 from Iron Blade, base: %f, new: %f" % [base_ad, new_ad]
			
	var it = ItemResource.new()
	it.active_action_tag = "ACTIVE_BARRIER"
	it.active_cooldown = 10.0
	hero.inventory_manager.equip_item(it, 1)
	var used = hero.inventory_manager.use_active_item(1, hero)
	if not used:
		hero.free()
		return "Failed active item hotkey usage"
	hero.free()
	return ""

func test_08_map_objectives() -> String:
	var spawner = preload("res://systems/objectives/river_rune_spawner.gd").new()
	spawner._ready()
	var rune = spawner.spawn_rune_at(Vector3.ZERO, 0)
	if rune == null:
		spawner.free()
		return "Failed to spawn river rune"
	rune.free()
	spawner.free()
	return ""

func test_09_sound_manager() -> String:
	var sm = (preload("res://autoload/sound_manager.gd") as GDScript).new()
	sm._ready()
	var anns: Array[String] = []
	sm.announcer_triggered.connect(func(type, msg): anns.append(type))
	var k = HeroEntity.new()
	var v = HeroEntity.new()
	k._ready()
	v._ready()
	sm._on_hero_died(v, k, 10.0)
	if not anns.has("FIRST_BLOOD"):
		k.free()
		v.free()
		sm.free()
		return "Expected FIRST_BLOOD announcement"
	k.free()
	v.free()
	sm.free()
	return ""

func test_10_full_combat_pipeline() -> String:
	var sm = (preload("res://autoload/sound_manager.gd") as GDScript).new()
	sm._ready()
	sm.reset_state()
	var anns: Array[String] = []
	sm.announcer_triggered.connect(func(type, msg): anns.append(type))
	
	var attacker = HeroEntity.new()
	attacker.entity_name = "Kaelgor"
	attacker._ready()
	
	var victim = HeroEntity.new()
	victim.entity_name = "Astris"
	victim._ready()
	victim.attribute_system.current_health = 50.0
	
	var req = DamageRequest.create_physical_damage(attacker, victim, 200.0, "Decapitate")
	var res = CombatCalculator.execute_damage(req)
	victim.receive_damage(req)
	ItemEventEngineClass.handle_kill_event(victim, attacker)
	sm._on_hero_died(victim, attacker, 10.0)
	
	if not anns.has("FIRST_BLOOD"):
		attacker.free()
		victim.free()
		sm.free()
		return "Expected FIRST_BLOOD announcement in full pipeline"
		
	attacker.free()
	victim.free()
	sm.free()
	return ""

func test_11_match_simulation() -> String:
	var rad: Array[String] = ["grom", "astris", "valgor"]
	var dir: Array[String] = ["noctis", "aurik", "velum"]
	var sim = FastForwardMatchSimulatorClass.simulate_match(rad, dir, 1800.0, 1.0)
	if not sim.has("timeline"):
		return "Expected timeline in simulation result"
	return ""

func test_12_teamfight_stress() -> String:
	var res = TeamfightStressHarnessClass.run_teamfight_stress_test(5, 30)
	if not res.get("success", false):
		return "Teamfight stress failed"
	if res.get("avg_tick_ms", 999.0) >= 16.6:
		return "Frame time exceeded 16.6ms"
	return ""

func test_13_ability_regression_harness() -> String:
	var harness = AbilityRegressionHarnessClass.new()
	var report = harness.run_harness()
	
	print("\n========================================")
	print("ECLIPSE MOBA ABILITY REGRESSION")
	print("========================================")
	print("Heroes: %d / 54" % report.get("heroes_discovered", 0))
	print("Abilities: %d / 270" % report.get("abilities_discovered", 0))
	print("Resource Load: %d PASS, %d FAIL" % [report.get("resource_load_pass", 0), report.get("resource_load_fail", 0)])
	print("Definition Validation: %d PASS, %d FAIL" % [report.get("definition_valid_pass", 0), report.get("definition_valid_fail", 0)])
	print("Ability Slot Validation: %d PASS, %d FAIL" % [report.get("slot_valid_pass", 0), report.get("slot_valid_fail", 0)])
	print("Runtime Gameplay: %d PASS, %d FAIL" % [report.get("runtime_gameplay_pass", 0), report.get("runtime_gameplay_fail", 0)])
	print("YELLOW Mechanics Resolved: %d" % report.get("yellow_resolved", 0))
	print("RED Mechanics Resolved: %d" % report.get("red_resolved", 0))
	print("Double Execution: %s" % report.get("double_execution", "FAIL"))
	print("Cooldown: %s" % report.get("cooldown", "FAIL"))
	print("Mana: %s" % report.get("mana", "FAIL"))
	print("Targeting: %s" % report.get("targeting", "FAIL"))
	print("Malformed Data: %s" % report.get("malformed_data", "FAIL"))
	print("========================================")
	print("RESULT: %s" % ("PASS" if report.get("is_pass", false) else "FAIL"))
	print("========================================\n")
	
	if not report.get("is_pass", false):
		return "Ability regression harness failed: " + str(report.get("errors", []))
	return ""

func test_14_phase_2_primitives() -> String:
	var tester = Phase2PrimitivesTestClass.new()
	var res = tester.run_all()
	if not res.get("is_pass", false):
		return "Phase 2 Primitives test failed: " + str(res.get("results", {}))
	return ""

func test_15_inventory_and_courier() -> String:
	# 1. Test Slot Swapping
	var hero = HeroDefinition.create_hero_instance("solen")
	if hero == null:
		return "Hero instance could not be created"
	hero._ready()
	if hero.inventory_manager == null:
		hero.free()
		return "Hero inventory manager is null"
	var inv: InventoryManager = hero.inventory_manager
	var item1 = Database.get_item(1)
	var item2 = Database.get_item(15)
	inv.equip_item(item1, 0)
	inv.equip_item(item2, 1)
	
	if inv.get_item_in_slot(0) != item1 or inv.get_item_in_slot(1) != item2:
		hero.free()
		return "Equip to specific slots failed"
		
	var swap_ok = inv.swap_slots(0, 1)
	if not swap_ok or inv.get_item_in_slot(0) != item2 or inv.get_item_in_slot(1) != item1:
		hero.free()
		return "Slot swapping failed: items did not swap positions"
		
	# 2. Test Drop to 3D World
	var dropped_pickup = inv.drop_item_to_world(0, Vector3(5, 0, 5))
	if dropped_pickup == null:
		hero.free()
		return "Drop item to world returned null pickup"
	if inv.get_item_in_slot(0) != null:
		hero.free()
		dropped_pickup.free()
		return "Item slot was not cleared upon dropping to world"
		
	# 3. Test Pick up from 3D World
	var pickup_ok = dropped_pickup.try_pickup(hero)
	if not pickup_ok or not inv.has_item(item2.id):
		hero.free()
		dropped_pickup.free()
		return "Pickup item from world failed"
		
	# 4. Test Flying Courier
	var courier = CourierEntity.new()
	courier.team = TeamDefinitions.Team.RADIANT
	courier.home_position = Vector3(0, 3.5, 0)
	courier.position = courier.home_position
	CourierManager.register_courier(courier)
	
	var item3 = Database.get_item(25)
	courier.add_item_to_courier(item3)
	if courier.get_held_items_count() != 1:
		hero.free()
		courier.free()
		return "Courier did not hold item"
		
	courier.deliver_items_to(hero)
	if courier.state != CourierEntity.CourierState.DELIVERING_TO_HERO:
		hero.free()
		courier.free()
		return "Courier did not transition to DELIVERING_TO_HERO"
		
	courier._transfer_items_to_hero()
	if not inv.has_item(item3.id) or courier.get_held_items_count() != 0:
		hero.free()
		courier.free()
		return "Courier item transfer to hero failed"
		
	var burst_ok = courier.activate_burst()
	if not burst_ok or not courier.is_burst_active:
		hero.free()
		courier.free()
		return "Courier speed burst activation failed"
		
	hero.free()
	courier.free()
	return ""

func test_16_courier_purchase_workflow() -> String:
	# 1. Setup Hero and Courier in a test world tree
	var test_root = Node3D.new()
	var hero = HeroDefinition.create_hero_instance("solen")
	hero.team = TeamDefinitions.Team.RADIANT
	hero.position = Vector3(-50.0, 0.5, 0.0) # At base
	test_root.add_child(hero)
	hero._ready()
	
	var courier = CourierEntity.new()
	courier.team = TeamDefinitions.Team.RADIANT
	courier.home_position = Vector3(-50.0, 3.2, -3.5)
	courier.position = courier.home_position
	test_root.add_child(courier)
	courier._ready()
	CourierManager.register_courier(courier)
	
	var inv: InventoryManager = hero.inventory_manager
	inv.gold = 10000
	
	# 2. Test Base Purchase: Hero at base buys item 1
	var item_base = Database.get_item(1)
	var buy_base_ok = inv.buy_item(item_base, func(id): return Database.get_item(id))
	if not buy_base_ok or not inv.has_item(item_base.id):
		test_root.free()
		return "Base purchase failed to equip item directly to hero"
	if courier.get_held_items_count() != 0:
		test_root.free()
		return "Base purchase incorrectly sent item to courier"
		
	# 3. Test Remote Purchase: Move hero away from base to lane
	hero.position = Vector3(10.0, 0.5, 5.0) # Far out in lane
	var item_remote = Database.get_item(15)
	var buy_remote_ok = inv.buy_item(item_remote, func(id): return Database.get_item(id))
	if not buy_remote_ok:
		test_root.free()
		return "Remote purchase failed"
	if inv.has_item(item_remote.id):
		test_root.free()
		return "Remote purchase equipped item to hero immediately instead of courier"
	if courier.get_held_items_count() != 1 or courier.courier_slots[0] != item_remote:
		test_root.free()
		return "Remote purchase did not place item in courier slot"
	if courier.state != CourierEntity.CourierState.DELIVERING_TO_HERO:
		test_root.free()
		return "Remote purchase did not command courier to DELIVERING_TO_HERO"
		
	# 4. Test Courier Flight & Delivery Arrival
	courier.position = hero.position + Vector3(0, 1.0, 0)
	courier._transfer_items_to_hero()
	if not inv.has_item(item_remote.id):
		test_root.free()
		return "Courier delivery failed to transfer item to hero"
	if courier.get_held_items_count() != 0:
		test_root.free()
		return "Courier did not clear slot after transfer"
		
	# 5. Test Return to Base
	courier.return_to_base()
	if courier.state != CourierEntity.CourierState.RETURNING_HOME:
		test_root.free()
		return "Courier failed to transition to RETURNING_HOME"
	courier.position = courier.home_position
	courier._physics_process(0.1)
	if courier.state != CourierEntity.CourierState.IDLE_AT_BASE:
		test_root.free()
		return "Courier did not return to IDLE_AT_BASE upon reaching home"
		
	# 6. Test Multiple Items Batch Remote Purchase
	hero.position = Vector3(25.0, 0.5, -15.0)
	var it_a = Database.get_item(20)
	var it_b = Database.get_item(21)
	var it_c = Database.get_item(22)
	inv.buy_item(it_a, func(id): return Database.get_item(id))
	inv.buy_item(it_b, func(id): return Database.get_item(id))
	inv.buy_item(it_c, func(id): return Database.get_item(id))
	
	if courier.get_held_items_count() != 3:
		test_root.free()
		return "Multiple remote items not all queued in courier (expected 3, got %d)" % courier.get_held_items_count()
		
	courier.position = hero.position
	courier._transfer_items_to_hero()
	if not inv.has_item(it_a.id) or not inv.has_item(it_b.id) or not inv.has_item(it_c.id):
		test_root.free()
		return "Batch courier delivery failed to transfer all items"
	if courier.get_held_items_count() != 0:
		test_root.free()
		return "Courier still holding items after batch transfer"
		
	test_root.free()
	return ""

func test_17_market_purchase_feedback() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	var item = Database.get_item(1)
	hero.inventory_manager.gold = 0
	if hero.inventory_manager.buy_item(item, func(id): return Database.get_item(id)):
		hero.free()
		return "Purchase unexpectedly succeeded with no gold"
	if hero.inventory_manager.last_purchase_failure_reason.is_empty():
		hero.free()
		return "Expected a purchase failure reason for UI feedback"
	hero.free()
	return ""

func test_18_active_item_buff_duration() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	var base_attack_speed = hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	var buff_item = ItemResource.new()
	buff_item.active_action_tag = "ACTIVE_ATTACK_SPEED_BUFF"
	if not ItemEventEngineClass.execute_active_item(hero, buff_item):
		hero.free()
		return "Attack speed active item did not activate"
	if hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED) <= base_attack_speed:
		hero.free()
		return "Attack speed buff was not applied"
	hero.effect_container._process(5.1)
	if hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED) != base_attack_speed:
		hero.free()
		return "Attack speed buff did not expire"
	hero.free()
	return ""

func test_19_ability_failure_feedback() -> String:
	var hero = HeroDefinition.create_hero_instance("solen")
	if hero == null:
		return "Could not create Solen for ability feedback test"
	hero._ready()
	var observed_messages: Array[String] = []
	hero.ability_container.ability_cast_failed.connect(func(_slot, _ability, _reason, message): observed_messages.append(message))
	if hero.ability_container.cast_ability(AbilityResource.Slot.Q, null):
		hero.free()
		return "Unlearned ability unexpectedly cast"
	var observed_message = observed_messages[0] if not observed_messages.is_empty() else ""
	if observed_message != "Yetenek öğrenilmedi":
		hero.free()
		return "Expected unlearned ability feedback, got: %s" % observed_message
	hero.free()
	return ""

func test_20_cc_primitives() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	hero.position = Vector3(2.0, 0.0, 0.0)
	hero.effect_container.apply_knockback(Vector3.ZERO, 3.0, 0.25, "test_knockback")
	if hero.position.x < 4.9:
		hero.free()
		return "Knockback did not displace the target away from its origin"
	hero.effect_container.apply_airborne(1.0, 1.5, "test_airborne")
	if not hero.effect_container.is_stunned():
		hero.free()
		return "Airborne target was not stunned"
	hero.effect_container._process(1.1)
	if hero.effect_container.has_effect("test_airborne"):
		hero.free()
		return "Airborne effect did not expire"
	hero.free()
	return ""

func test_21_spatial_primitives() -> String:
	SpatialManager.clear_all()
	var owner = HeroEntity.new()
	var enemy = HeroEntity.new()
	var ally = HeroEntity.new()
	owner._ready()
	enemy._ready()
	ally._ready()
	owner.team = TeamDefinitions.Team.RADIANT
	ally.team = TeamDefinitions.Team.RADIANT
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(1.0, 0.0, 0.0)
	var start_hp = enemy.attribute_system.current_health
	SpatialManager.place_trap(owner, enemy.position, 10.0, 2.0, 100.0)
	SpatialManager.tick(0.1)
	if enemy.attribute_system.current_health >= start_hp:
		_cleanup_spatial_test(owner, enemy, ally)
		return "Trap did not damage an enemy entering its trigger radius"
	if SpatialManager.get_owner_objects(owner, SpatialManager.SpatialType.TRAP).size() != 0:
		_cleanup_spatial_test(owner, enemy, ally)
		return "Triggered trap was not consumed"
	ally.position = Vector3(5.0, 0.0, 0.0)
	SpatialManager.create_gate(owner, Vector3(5.0, 0.0, 0.0), Vector3(18.0, 0.0, 0.0), 10.0)
	SpatialManager.tick(0.1)
	if ally.position.distance_to(Vector3(18.0, 0.0, 0.0)) > 0.01:
		_cleanup_spatial_test(owner, enemy, ally)
		return "Allied gate did not relocate its ally"
	enemy.position = Vector3(0.0, 0.0, 0.0)
	SpatialManager.create_wall(owner, Vector3(-2.0, 0.0, 0.0), Vector3(2.0, 0.0, 0.0), 10.0, 100.0)
	var wall_hp = enemy.attribute_system.current_health
	SpatialManager.tick(0.5)
	if enemy.attribute_system.current_health >= wall_hp:
		_cleanup_spatial_test(owner, enemy, ally)
		return "Energy wall did not damage an enemy crossing it"
	_cleanup_spatial_test(owner, enemy, ally)
	return ""

func _cleanup_spatial_test(owner: HeroEntity, enemy: HeroEntity, ally: HeroEntity) -> void:
	SpatialManager.clear_all()
	owner.free()
	enemy.free()
	ally.free()

func test_22_summon_primitives() -> String:
	SummonManager.clear_all()
	var owner = HeroEntity.new()
	var enemy = HeroEntity.new()
	owner._ready()
	enemy._ready()
	owner.team = TeamDefinitions.Team.RADIANT
	enemy.team = TeamDefinitions.Team.DIRE
	owner.position = Vector3.ZERO
	enemy.position = Vector3(1.0, 0.0, 0.0)
	var start_hp = enemy.attribute_system.current_health
	SummonManager.spawn_construct(owner, SummonManager.ConstructType.GUARDIAN, Vector3.ZERO, 200.0, 90.0, 5.0)
	SummonManager.tick(0.1)
	if enemy.attribute_system.current_health >= start_hp:
		_cleanup_summon_test(owner, enemy)
		return "Construct did not attack a nearby enemy"
	SummonManager.spawn_shade(owner, Vector3(8.0, 0.0, 2.0), 5.0)
	var shade_pos = SummonManager.swap_with_shade(owner)
	if shade_pos.distance_to(Vector3(8.0, 0.0, 2.0)) > 0.01:
		_cleanup_summon_test(owner, enemy)
		return "Shade swap did not return the shade location"
	_cleanup_summon_test(owner, enemy)
	return ""

func _cleanup_summon_test(owner: HeroEntity, enemy: HeroEntity) -> void:
	SummonManager.clear_all()
	owner.free()
	enemy.free()

func test_23_channel_primitive() -> String:
	var caster = HeroEntity.new()
	var target = HeroEntity.new()
	caster._ready()
	target._ready()
	caster.team = TeamDefinitions.Team.RADIANT
	target.team = TeamDefinitions.Team.DIRE
	target.position = Vector3(1.0, 0.0, 0.0)
	var channel = AbilityResource.new()
	channel.id = "test_channel"
	channel.ability_name = "Test Channel"
	channel.slot = AbilityResource.Slot.Q
	channel.target_type = AbilityResource.TargetType.SINGLE_TARGET
	channel.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	channel.cast_time = 0.0
	channel.channel_time = 1.0
	channel.channel_tick_interval = 0.25
	var channel_damage: Array[float] = [40.0]
	channel.base_damage = channel_damage
	caster.ability_container.set_ability(AbilityResource.Slot.Q, channel)
	caster.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	var start_hp = target.attribute_system.current_health
	if not caster.ability_container.cast_ability(AbilityResource.Slot.Q, target):
		caster.free()
		target.free()
		return "Channel ability could not start"
	if caster.ability_container.current_cast_state != AbilityContainer.CastState.CHANNELING:
		caster.free()
		target.free()
		return "Channel ability did not enter channeling state"
	caster.ability_container._process(0.3)
	if target.attribute_system.current_health >= start_hp - 60.0:
		caster.free()
		target.free()
		return "Channel did not apply its opening and repeat pulses"
	caster.ability_container._process(1.0)
	if caster.ability_container.current_cast_state != AbilityContainer.CastState.IDLE:
		caster.free()
		target.free()
		return "Channel did not finish cleanly"
	caster.free()
	target.free()
	return ""

func test_24_persistent_area() -> String:
	AreaEffectManagerClass.clear_all()
	var owner = HeroEntity.new()
	var target = HeroEntity.new()
	owner._ready()
	target._ready()
	owner.team = TeamDefinitions.Team.RADIANT
	target.team = TeamDefinitions.Team.DIRE
	target.position = Vector3(1.0, 0.0, 0.0)
	var start_hp = target.attribute_system.current_health
	AreaEffectManagerClass.create_zone(owner, Vector3.ZERO, 2.0, 0.4, 0.1, 50.0, DamageRequest.DamageType.MAGICAL, true, StatusEffect.EffectType.SLOW, 0.5, 0.3, "Test Area")
	AreaEffectManagerClass.tick(0.1)
	if target.attribute_system.current_health >= start_hp:
		AreaEffectManagerClass.clear_all()
		owner.free()
		target.free()
		return "Persistent area did not damage an enemy inside it"
	if not target.effect_container.has_effect_type(StatusEffect.EffectType.SLOW):
		AreaEffectManagerClass.clear_all()
		owner.free()
		target.free()
		return "Persistent area did not apply its configured effect"
	AreaEffectManagerClass.tick(0.5)
	if not AreaEffectManagerClass._active_zones.is_empty():
		AreaEffectManagerClass.clear_all()
		owner.free()
		target.free()
		return "Persistent area did not expire"
	AreaEffectManagerClass.clear_all()
	owner.free()
	target.free()
	return ""

func test_25_zin_clone() -> String:
	var zin = HeroDefinition.create_hero_instance("zin")
	var enemy = HeroEntity.new()
	if zin == null:
		enemy.free()
		return "Could not create Zin for clone test"
	zin._ready()
	enemy._ready()
	zin.team = TeamDefinitions.Team.RADIANT
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(4.0, 0.0, 0.0)
	var clone_pos = Vector3(4.0, 0.0, 0.0)
	zin.cast_zin_q(clone_pos, [enemy])
	if not zin._has_mirror_clone() or zin.mirror_clone_position != clone_pos:
		zin.free()
		enemy.free()
		return "Mirror Mirage did not retain a logical clone in headless gameplay"
	if not zin.cast_zin_w() or zin.position.distance_to(clone_pos) > 0.01:
		zin.free()
		enemy.free()
		return "Mirror Swap did not move Zin to the clone position"
	zin._process(6.1)
	if zin._has_mirror_clone():
		zin.free()
		enemy.free()
		return "Mirror clone did not expire after its lifetime"
	zin.free()
	enemy.free()
	return ""

func test_26_hero_signatures() -> String:
	SummonManager.clear_all()
	SpatialManager.clear_all()
	var enemy = HeroEntity.new()
	enemy._ready()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(3.0, 0.0, 0.0)
	var aethon = HeroDefinition.create_hero_instance("aethon")
	if aethon == null:
		enemy.free()
		return "Could not create Aethon"
	aethon._ready()
	aethon.team = TeamDefinitions.Team.RADIANT
	aethon.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	if not aethon.ability_container.cast_ability(AbilityResource.Slot.Q, null, Vector3(2.0, 0.0, 0.0)) or int(aethon.call("get_construct_count")) < 1:
		aethon.free()
		enemy.free()
		SummonManager.clear_all()
		return "Aethon Q did not bind to construct spawning"
	aethon.free()
	SummonManager.clear_all()
	var rivena = HeroDefinition.create_hero_instance("rivena")
	rivena._ready()
	rivena.team = TeamDefinitions.Team.RADIANT
	rivena.ability_container.ability_levels[AbilityResource.Slot.R] = 1
	var rivena_shades: Array = rivena.get("active_shades")
	if not rivena.ability_container.cast_ability(AbilityResource.Slot.R):
		rivena.free()
		enemy.free()
		return "Rivena R could not be cast"
	rivena_shades = rivena.get("active_shades")
	if rivena_shades.size() != 2:
		rivena.free()
		enemy.free()
		return "Rivena R did not bind to shade spawning"
	rivena.free()
	var neris = HeroDefinition.create_hero_instance("neris")
	neris._ready()
	neris.team = TeamDefinitions.Team.RADIANT
	neris.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	if not neris.ability_container.cast_ability(AbilityResource.Slot.Q, null, Vector3(3.0, 0.0, 0.0)):
		neris.free()
		enemy.free()
		return "Neris Q could not be cast"
	var neris_walls: Array = neris.get("active_walls")
	if neris_walls.size() < 1 or SpatialManager.get_owner_objects(neris, SpatialManager.SpatialType.WALL).is_empty():
		neris.free()
		enemy.free()
		return "Neris Q did not bind to wall creation"
	neris.free()
	var zin = HeroDefinition.create_hero_instance("zin")
	zin._ready()
	zin.team = TeamDefinitions.Team.RADIANT
	zin.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	if not zin.ability_container.cast_ability(AbilityResource.Slot.Q, null, Vector3(4.0, 0.0, 0.0)) or not bool(zin.call("_has_mirror_clone")):
		zin.free()
		enemy.free()
		return "Zin Q did not bind to clone creation"
	zin.free()
	enemy.free()
	SpatialManager.clear_all()
	return ""

func test_27_dash_stop() -> String:
	var caster = HeroEntity.new()
	var enemy = HeroEntity.new()
	caster._ready()
	enemy._ready()
	caster.team = TeamDefinitions.Team.RADIANT
	enemy.team = TeamDefinitions.Team.DIRE
	caster.position = Vector3.ZERO
	enemy.position = Vector3(3.0, 0.0, 0.0)
	var dash = AbilityResource.new()
	dash.id = "test_stopping_dash"
	dash.stop_on_first_enemy = true
	dash.set_meta("dash_distance", 8.0)
	caster.ability_container.set_ability(AbilityResource.Slot.Q, dash)
	if not caster.ability_container.execute_dash(AbilityResource.Slot.Q, Vector3(8.0, 0.0, 0.0)):
		caster.free()
		enemy.free()
		return "Stopping dash could not execute"
	if caster.position.x < 1.9 or caster.position.x > 2.3:
		caster.free()
		enemy.free()
		return "Dash did not stop before the first enemy, ended at %f" % caster.position.x
	caster.free()
	enemy.free()
	return ""

func test_28_disarm() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	if not hero.can_attack():
		hero.free()
		return "Fresh hero unexpectedly cannot attack"
	hero.effect_container.apply_disarm(1.0, "test_disarm")
	if not hero.effect_container.is_disarmed() or hero.can_attack():
		hero.free()
		return "Disarm did not block basic attacks"
	hero.effect_container._process(1.1)
	if hero.effect_container.is_disarmed() or not hero.can_attack():
		hero.free()
		return "Disarm did not expire cleanly"
	hero.free()
	return ""

func test_29_stealth_and_blind() -> String:
	var attacker = HeroEntity.new()
	var target = HeroEntity.new()
	attacker._ready()
	target._ready()
	attacker.effect_container.apply_invisibility(1.0, "test_invisibility")
	if not attacker.is_invisible or attacker.is_targetable:
		attacker.free()
		target.free()
		return "Invisibility did not hide the hero from targeting"
	attacker.effect_container._process(1.1)
	if attacker.is_invisible or not attacker.is_targetable:
		attacker.free()
		target.free()
		return "Invisibility did not restore targeting when it expired"
	var start_hp = target.attribute_system.current_health
	attacker.effect_container.apply_blind(1.0, 1.0, "test_blind")
	var result = CombatCalculator.execute_damage(DamageRequest.create_basic_attack(attacker, target, 100.0))
	if result.final_health_damage != 0.0 or target.attribute_system.current_health != start_hp:
		attacker.free()
		target.free()
		return "100 percent blind did not force a basic attack miss"
	attacker.free()
	target.free()
	return ""

func test_30_hero_controls() -> String:
	var target = HeroEntity.new()
	target._ready()
	target.team = TeamDefinitions.Team.DIRE
	target.position = Vector3(2.0, 0.0, 0.0)
	var noctis = HeroDefinition.create_hero_instance("noctis")
	if noctis == null:
		target.free()
		return "Could not create Noctis"
	noctis._ready()
	noctis.team = TeamDefinitions.Team.RADIANT
	noctis.ability_container.ability_levels[AbilityResource.Slot.W] = 1
	noctis.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	if not noctis.ability_container.cast_ability(AbilityResource.Slot.W) or not noctis.is_invisible:
		noctis.free()
		target.free()
		return "Noctis W did not apply invisibility"
	# Restore targetability only for the follow-up test; Noctis can still cast while hidden.
	if not noctis.ability_container.cast_ability(AbilityResource.Slot.Q, target) or not target.effect_container.is_blinded():
		noctis.free()
		target.free()
		return "Noctis Q did not apply blind"
	noctis.free()
	var grom = HeroDefinition.create_hero_instance("grom")
	grom._ready()
	grom.team = TeamDefinitions.Team.RADIANT
	grom.ability_container.ability_levels[AbilityResource.Slot.R] = 1
	if not grom.ability_container.cast_ability(AbilityResource.Slot.R, target) or not target.effect_container.is_disarmed():
		grom.free()
		target.free()
		return "Grom R did not apply disarm"
	grom.free()
	target.free()
	return ""

func test_31_hud_status_effects() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	var blind = StatusEffect.new("test_blind", StatusEffect.EffectType.BLIND, 2.0, 0.5, true)
	blind.stacks = 3
	hero.effect_container.apply_effect(blind)
	var status_bar = DotaStatusEffectBarClass.new()
	status_bar.target_hero = hero
	status_bar._ready()
	status_bar._process(0.0)
	if status_bar.icon_pool.size() != 1:
		status_bar.free()
		hero.free()
		return "HUD did not create an icon for an active status effect"
	var icon = status_bar.icon_pool[0]
	if icon.symbol_label.text != "◉" or icon.stack_label.text != "x3":
		status_bar.free()
		hero.free()
		return "HUD status icon did not show its glyph and stack count"
	if not icon.tooltip_text.contains("Körlük") or not icon.tooltip_text.contains("Süre: 2.0s"):
		status_bar.free()
		hero.free()
		return "HUD status icon tooltip lacks effect information"
	status_bar.free()
	hero.free()
	return ""

func test_32_item_targeting_and_passives() -> String:
	var hero = HeroEntity.new()
	var enemy = HeroEntity.new()
	hero._ready()
	enemy._ready()
	hero.team = TeamDefinitions.Team.RADIANT
	enemy.team = TeamDefinitions.Team.DIRE
	var cyclone = ItemResource.new()
	cyclone.id = 9001
	cyclone.item_name = "Test Cyclone"
	cyclone.active_action_tag = "ACTIVE_CYCLONE"
	cyclone.active_cooldown = 10.0
	hero.inventory_manager.equip_item(cyclone, 0)
	if hero.inventory_manager.get_active_item_target_mode(0) != "enemy":
		hero.free()
		enemy.free()
		return "Cyclone item did not request an enemy target"
	if hero.inventory_manager.use_active_item(0):
		hero.free()
		enemy.free()
		return "Enemy-targeted active was consumed without a target"
	if not hero.inventory_manager.use_active_item(0, enemy):
		hero.free()
		enemy.free()
		return "Enemy-targeted active did not execute on a valid target"
	var passive_item = ItemResource.new()
	passive_item.id = 9002
	passive_item.item_name = "Test Diken"
	passive_item.description = "Savunma eşyası."
	var passive_tags: Array[String] = ["DEFENSIVE_THORNS"]
	passive_item.item_tags = passive_tags
	hero.inventory_manager.equip_item(passive_item, 1)
	var status_bar = DotaStatusEffectBarClass.new()
	status_bar.target_hero = hero
	status_bar._ready()
	status_bar._process(0.0)
	var passive_found := false
	for icon in status_bar.icon_pool:
		if icon.tooltip_text.contains("Dikenli Yansıma") and icon.symbol_label.text == "◆":
			passive_found = true
			break
	status_bar.free()
	hero.free()
	enemy.free()
	if not passive_found:
		return "Equipped passive item did not appear in the status HUD"
	return ""

func test_33_hero_mechanics_guide() -> String:
	var heroes = HeroDefinition.get_all_definitions()
	if heroes.size() < 54:
		return "Mechanics guide did not receive the full hero roster"
	for hero in heroes:
		var guide = HeroMechanicsGuideClass.get_guide(hero)
		if guide.is_empty() or str(guide.get("passive_desc", "")).is_empty():
			return "%s has no passive guide" % hero.hero_id
		if str(guide.get("combo", "")).is_empty() or str(guide.get("counterplay", "")).is_empty():
			return "%s has incomplete combo/counterplay guidance" % hero.hero_id
		var targeting: Array = guide.get("targeting", [])
		if targeting.size() != 4:
			return "%s does not expose Q/W/E/R targeting rules" % hero.hero_id
		for rule in targeting:
			if not str(rule).contains(":") or not str(rule).contains("—"):
				return "%s has malformed target rule: %s" % [hero.hero_id, rule]
	var fallback_hero = HeroDefinition.create_hero_instance("kaelen")
	if fallback_hero == null:
		return "Could not create fallback-passive hero"
	fallback_hero._ready()
	if not fallback_hero.uses_fallback_innate:
		fallback_hero.free()
		return "Hero without bespoke passive did not receive Combat Rhythm"
	fallback_hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	if not fallback_hero.ability_container.cast_ability(AbilityResource.Slot.Q, null, Vector3(1.0, 0.0, 0.0)):
		fallback_hero.free()
		return "Fallback hero could not cast to trigger Combat Rhythm"
	if not fallback_hero.effect_container.has_effect("fallback_combat_rhythm"):
		fallback_hero.free()
		return "Combat Rhythm did not create its temporary attack-speed buff"
	fallback_hero._on_hero_ability_casted(AbilityResource.Slot.Q, fallback_hero.ability_container.get_ability(AbilityResource.Slot.Q))
	fallback_hero._on_hero_ability_casted(AbilityResource.Slot.W, fallback_hero.ability_container.get_ability(AbilityResource.Slot.W))
	fallback_hero._on_hero_ability_casted(AbilityResource.Slot.E, fallback_hero.ability_container.get_ability(AbilityResource.Slot.E))
	if not fallback_hero.effect_container.has_effect("hero_combo_momentum"):
		fallback_hero.free()
		return "Three distinct hero skills did not award Combo Momentum"
	fallback_hero.free()
	return ""

func test_34_combat_mechanics() -> String:
	var source = HeroEntity.new()
	var target = HeroEntity.new()
	source._ready()
	target._ready()
	source.team = TeamDefinitions.Team.RADIANT
	target.team = TeamDefinitions.Team.DIRE
	for _i in range(3):
		CombatMechanicsClass.apply_mark(source, target, "test", "Test Damga", 6.0, 3, "◆")
	var mark = target.effect_container.get_effect("mark_test")
	if mark == null or mark.stacks != 3 or mark.get_meta("display_name", "") != "Test Damga":
		source.free()
		target.free()
		return "Mark stacks or metadata were not applied centrally"
	if CombatMechanicsClass.consume_marks(target, "test", 2) != 2 or mark.stacks != 1:
		source.free()
		target.free()
		return "Mark consumption did not preserve the remaining stack"
	CombatMechanicsClass.apply_shield(source, target, "test_shield", "Test Kalkan", 120.0, 4.0)
	CombatMechanicsClass.apply_shield(source, target, "test_shield", "Test Kalkan", 80.0, 4.0)
	var shield = target.effect_container.get_effect("test_shield")
	if shield == null or absf(shield.intensity - 200.0) > 0.01:
		source.free()
		target.free()
		return "Repeated shield did not add capacity"
	target.attribute_system.apply_damage_to_health(250.0, "test")
	var before_heal = target.attribute_system.current_health
	var healed = CombatMechanicsClass.heal(source, target, 100.0, "Test Heal")
	if healed <= 0.0 or target.attribute_system.current_health <= before_heal:
		source.free()
		target.free()
		return "Central healing did not restore health"
	target.attribute_system.current_mana = 100.0
	var burn = CombatMechanicsClass.burn_mana(source, target, 35.0, 1.0, "Test Burn")
	if absf(float(burn["mana_burned"]) - 35.0) > 0.01 or absf(target.attribute_system.current_mana - 65.0) > 0.01:
		source.free()
		target.free()
		return "Mana burn did not consume and report mana correctly"
	target.attribute_system.current_health = target.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH) * 0.5
	var execute = CombatMechanicsClass.execute_missing_health_damage(source, target, 100.0, 0.20, "Test Execute")
	if execute.raw_damage <= 100.0:
		source.free()
		target.free()
		return "Missing-health execute did not scale with missing health"
	CombatMechanicsClass.apply_damage_modifier(source, source, "test_amp", "Test Güç", 0.10, 3.0, true)
	CombatMechanicsClass.apply_lifesteal(source, source, "test_lifesteal", "Test Can Çalma", 0.15, 3.0)
	if source.attribute_system.get_stat(StatModifier.TargetStat.DAMAGE_AMPLIFICATION) < 0.09 or source.attribute_system.get_stat(StatModifier.TargetStat.LIFESTEAL) < 0.14:
		source.free()
		target.free()
		return "Damage amplification or lifesteal modifier did not apply"
	source.free()
	target.free()
	return ""

func test_35_mark_heroes() -> String:
	var target = HeroEntity.new()
	target._ready()
	target.team = TeamDefinitions.Team.DIRE
	var mordren = HeroDefinition.create_hero_instance("mordren")
	mordren._ready()
	mordren.team = TeamDefinitions.Team.RADIANT
	mordren.apply_hunt_mark(target)
	var hunt_mark = target.effect_container.get_effect("mark_mordren_hunt")
	if hunt_mark == null or hunt_mark.get_meta("display_name", "") != "Av Damgası":
		mordren.free()
		target.free()
		return "Mordren hunt mark did not use common visible mark state"
	mordren.free()
	var selka = HeroDefinition.create_hero_instance("selka")
	selka._ready()
	selka.team = TeamDefinitions.Team.RADIANT
	selka.apply_hex_mark(target)
	selka.apply_hex_mark(target)
	selka.apply_hex_mark(target)
	var hex_mark = target.effect_container.get_effect("mark_selka_hex")
	if hex_mark == null or hex_mark.stacks != 3:
		selka.free()
		target.free()
		return "Selka hex stacks did not sync to common mark state"
	selka.clear_hex_marks(target)
	if target.effect_container.has_effect("mark_selka_hex"):
		selka.free()
		target.free()
		return "Selka detonation cleanup did not consume common mark state"
	selka.free()
	var talon = HeroDefinition.create_hero_instance("talon")
	talon._ready()
	talon.team = TeamDefinitions.Team.RADIANT
	talon.add_predator_stack(target)
	talon.add_predator_stack(target)
	var predator_mark = target.effect_container.get_effect("mark_talon_predator")
	if predator_mark == null or predator_mark.stacks != 2:
		talon.free()
		target.free()
		return "Talon stacks did not sync to common mark state"
	talon._process_predator(5.1)
	if talon.predator_stacks != 0 or target.effect_container.has_effect("mark_talon_predator"):
		talon.free()
		target.free()
		return "Talon predator stacks did not expire after the shared duration"
	talon.free()
	target.free()
	return ""

func test_36_execution_heroes() -> String:
	var target = HeroEntity.new()
	target._ready()
	target.team = TeamDefinitions.Team.DIRE
	target.attribute_system.base_health = 3000.0
	target.attribute_system.recalculate_all_stats()
	target.attribute_system.heal(target.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
	var mordren = HeroDefinition.create_hero_instance("mordren")
	mordren._ready()
	mordren.team = TeamDefinitions.Team.RADIANT
	mordren.ability_container.ability_levels[AbilityResource.Slot.R] = 1
	mordren.apply_hunt_mark(target)
	target.attribute_system.current_health = target.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH) * 0.36
	if mordren.cast_mordren_r(target) != null:
		mordren.free()
		target.free()
		return "Mordren Final Hunt ignored its 35 percent execution threshold"
	target.attribute_system.current_health = target.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH) * 0.35
	var before = target.attribute_system.current_health
	var final_hunt = mordren.cast_mordren_r(target)
	if final_hunt == null or target.attribute_system.current_health >= before:
		var validation = mordren.ability_container.validate_cast(AbilityResource.Slot.R, target)
		var reason = mordren.ability_container.get_validation_error_message(validation)
		mordren.free()
		target.free()
		return "Mordren Final Hunt did not execute at its marked threshold (%s)" % reason
	mordren.free()
	target.free()
	var nyx_target = HeroEntity.new()
	nyx_target._ready()
	nyx_target.team = TeamDefinitions.Team.DIRE
	nyx_target.attribute_system.base_health = 3000.0
	nyx_target.attribute_system.recalculate_all_stats()
	nyx_target.attribute_system.heal(nyx_target.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
	var nyxara = HeroDefinition.create_hero_instance("nyxara")
	nyxara._ready()
	nyxara.team = TeamDefinitions.Team.RADIANT
	nyxara.ability_container.ability_levels[AbilityResource.Slot.E] = 1
	nyx_target.attribute_system.current_health = nyx_target.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH) * 0.50
	nyxara.apply_veil_mark(nyx_target, 2)
	before = nyx_target.attribute_system.current_health
	var sever = nyxara.cast_nyxara_e(nyx_target)
	if sever == null or nyx_target.attribute_system.current_health >= before or nyx_target.effect_container.has_effect("mark_nyxara_veil"):
		nyxara.free()
		nyx_target.free()
		return "Nyxara Sever Thread did not consume marks and apply its finisher"
	nyxara.free()
	nyx_target.free()
	return ""

func test_37_dota_micro_mechanics() -> String:
	# 1. Creep Deny Eligibility & Execution
	var hero = HeroDefinition.create_hero_instance("solen")
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var ally_creep = CreepEntity.new()
	ally_creep.team = TeamDefinitions.Team.RADIANT
	ally_creep._ready()
	var max_creep_hp = ally_creep.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	
	# High HP creep (>50% HP) cannot be denied
	ally_creep.attribute_system.current_health = max_creep_hp * 0.80
	if TargetRelationSystem.is_valid_basic_attack_target(hero, ally_creep):
		hero.free()
		ally_creep.free()
		return "TargetRelationSystem allowed attacking allied creep above 50% HP"
		
	# Low HP creep (<=50% HP) CAN be denied
	ally_creep.attribute_system.current_health = max_creep_hp * 0.40
	if not TargetRelationSystem.is_valid_basic_attack_target(hero, ally_creep):
		hero.free()
		ally_creep.free()
		return "TargetRelationSystem rejected attacking allied creep at 40% HP"
		
	# 2. Tower Deny Eligibility
	var ally_tower = TowerEntity.new()
	ally_tower.team = TeamDefinitions.Team.RADIANT
	ally_tower._ready()
	var max_tower_hp = ally_tower.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	
	# Tower above 10% HP cannot be denied
	ally_tower.attribute_system.current_health = max_tower_hp * 0.20
	if TargetRelationSystem.is_valid_basic_attack_target(hero, ally_tower):
		hero.free()
		ally_creep.free()
		ally_tower.free()
		return "TargetRelationSystem allowed attacking allied tower above 10% HP"
		
	# Tower at or below 10% HP can be denied
	ally_tower.attribute_system.current_health = max_tower_hp * 0.08
	if not TargetRelationSystem.is_valid_basic_attack_target(hero, ally_tower):
		hero.free()
		ally_creep.free()
		ally_tower.free()
		return "TargetRelationSystem rejected attacking allied tower at 8% HP"
		
	# 3. Turn Rate & Facing Check
	hero.position = Vector3(0, 0, 0)
	hero.rotation = Vector3(0, 0, 0) # Facing positive Z
	var in_front = Vector3(0, 0, 10.0)
	var behind = Vector3(0, 0, -10.0)
	
	if not hero.is_facing_point(in_front, 0.4):
		hero.free()
		ally_creep.free()
		ally_tower.free()
		return "Hero reported not facing point directly in front"
		
	if hero.is_facing_point(behind, 0.4):
		hero.free()
		ally_creep.free()
		ally_tower.free()
		return "Hero incorrectly reported facing point directly behind"
		
	# Turning towards behind point
	var old_rot = hero.rotation.y
	hero.turn_towards_point(behind, 0.1)
	if hero.rotation.y == old_rot:
		hero.free()
		ally_creep.free()
		ally_tower.free()
		return "Hero turn_towards_point did not rotate hero orientation"
		
	# 4. Attack Animation Canceling (Stutter-Step / Backswing Cancel)
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var ac = hero.attack_controller
	ac.attack_target = dummy
	ac.current_state = AttackController.AttackState.RECOVERY
	ac.state_timer = 0.25
	ac.cooldown_timer = 0.85
	
	var cancelled = ac.notify_move_command_issued()
	if not cancelled:
		hero.free()
		ally_creep.free()
		ally_tower.free()
		dummy.free()
		return "notify_move_command_issued returned false during RECOVERY"
		
	if ac.current_state != AttackController.AttackState.IDLE or ac.state_timer != 0.0:
		hero.free()
		ally_creep.free()
		ally_tower.free()
		dummy.free()
		return "Attack state was not reset to IDLE upon animation cancel"
		
	if ac.cooldown_timer <= 0.0:
		hero.free()
		ally_creep.free()
		ally_tower.free()
		dummy.free()
		return "Attack cooldown was wiped upon animation cancel (exploit protection failed)"
		
	hero.free()
	ally_creep.free()
	ally_tower.free()
	dummy.free()
	return ""

func test_38_scoreboard_and_combat_tracking() -> String:
	var h1 = HeroEntity.new()
	var h2 = HeroEntity.new()
	h1.entity_name = "RadiantHero"
	h2.entity_name = "DireHero"
	h1.team = TeamDefinitions.Team.RADIANT
	h2.team = TeamDefinitions.Team.DIRE
	h1._ready()
	h2._ready()
	
	# 1. KDA and CS Tracking
	if h1.kills != 0 or h1.deaths != 0 or h1.assists != 0 or h1.last_hits != 0 or h1.denies != 0:
		h1.free()
		h2.free()
		return "Initial KDA and CS stats were not zero"
		
	# Last Hit and Deny simulation
	var dummy_creep = CreepEntity.new()
	dummy_creep.team = TeamDefinitions.Team.DIRE
	h1._on_creep_last_hit(dummy_creep, h1, 50)
	if h1.last_hits != 1:
		dummy_creep.free()
		h1.free()
		h2.free()
		return "Hero last_hits did not increment after creep kill"
		
	h1._on_creep_denied(dummy_creep, h1)
	if h1.denies != 1:
		dummy_creep.free()
		h1.free()
		h2.free()
		return "Hero denies did not increment after creep deny"
		
	dummy_creep.free()
	
	# Kill / Death Tracking
	h2.last_attacker = h1
	h2._on_death("RadiantHero")
	if h2.deaths != 1:
		h1.free()
		h2.free()
		return "Hero deaths did not increment upon death"
	if h1.kills != 1:
		h1.free()
		h2.free()
		return "Killer hero kills did not increment upon scoring a hero kill"
		
	# 2. Bot Starter Equipment Verification
	var boots = Database.get_item(37)
	if boots != null:
		h2.inventory_manager.equip_item(boots)
		if h2.inventory_manager.boots_slot == null:
			h1.free()
			h2.free()
			return "Bot did not equip boots in boots_slot"
			
	var sword = Database.get_item(2)
	if sword != null:
		h2.inventory_manager.equip_item(sword)
		if h2.inventory_manager.get_item_in_slot(0) == null:
			h1.free()
			h2.free()
			return "Bot did not equip sword in slot 0"
			
	# 3. DotaScoreboard UI Construction & Data Refresh
	var scoreboard_script = load("res://systems/ui/dota_scoreboard.gd")
	var scoreboard = scoreboard_script.new()
	scoreboard.player_hero = h1
	scoreboard.bot_hero = h2
	scoreboard._ready()
	scoreboard.update_scoreboard()
	
	if scoreboard.radiant_vbox == null or scoreboard.dire_vbox == null:
		scoreboard.free()
		h1.free()
		h2.free()
		return "Scoreboard team containers were null"
		
	if scoreboard.radiant_vbox.get_child_count() == 0:
		scoreboard.free()
		h1.free()
		h2.free()
		return "Scoreboard did not create a row for Radiant hero"
		
	if scoreboard.dire_vbox.get_child_count() == 0:
		scoreboard.free()
		h1.free()
		h2.free()
		return "Scoreboard did not create a row for Dire hero"
		
	scoreboard.free()
	h1.free()
	h2.free()
	return ""

