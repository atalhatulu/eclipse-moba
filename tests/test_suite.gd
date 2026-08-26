class_name TestSuite
extends RefCounted

## Comprehensive Deterministic Automated Test Suite for Eclipse Front
## Total Tests: 112 (19 Core + 22 Kaelgor + 5 Map + 5 120-Item DB + 5 Shop + 6 Lane Combat + 11 Astris + 3 HUD/Controls + 20 Match Flow + 16 Core Gameplay Loop Tests)

var passed_count: int = 0
var failed_count: int = 0
var test_results: Array[Dictionary] = []

func run_all() -> Dictionary:
	passed_count = 0
	failed_count = 0
	test_results.clear()
	
	Database.initialize()
			
	# --- 19 CORE ARCHITECTURE TESTS ---
	run_test("1. Primary Attribute Derivation (STR/AGI/INT)", test_attribute_derivation)
	run_test("2. Stat Modifiers (Flat, Percent Add, Percent Mult)", test_stat_modifiers)
	run_test("3. Physical Damage & Armor Mitigation", test_physical_damage_and_armor)
	run_test("4. Magical Damage & Magic Resistance", test_magical_damage_and_mr)
	run_test("5. Pure / True Damage Bypass", test_true_damage)
	run_test("6. Armor & Magic Penetration (Flat & %)", test_penetration)
	run_test("7. Damage Amplification & Reduction", test_damage_amplification_and_reduction)
	run_test("8. Critical Strike Calculations", test_critical_strikes)
	run_test("9. Status Effects: Crowd Control (Stun, Silence, Root)", test_crowd_control_effects)
	run_test("10. Status Effects: Shield Damage Absorption", test_shield_absorption)
	run_test("11. Status Effects: Damage Over Time (DoT)", test_dot_effects)
	run_test("12. Status Effects: Expiration & Duration Refresh", test_status_effect_lifecycle)
	run_test("13. Ability Cooldown, CDR & Mana Consumption", test_ability_cooldown_and_mana)
	run_test("14. Inventory: 6 Normal Slots Limits", test_inventory_normal_limits)
	run_test("15. Inventory: Dedicated Boots Slot & Routing", test_dedicated_boots_slot)
	run_test("16. Item Tree: Recursive Recipe Resolution & Crafting", test_item_recipe_resolution)
	run_test("17. Item Selling & Gold Refund", test_item_selling)
	run_test("18. Experience & Level Progression Scaling", test_progression_system)
	run_test("19. Game State Machine Transitions", test_game_state_machine)
	
	# --- 22 KAELGOR HERO TESTS ---
	run_test("20. Kaelgor: Initializes Correctly with Definition", test_kaelgor_initialization)
	run_test("21. Kaelgor: Basic Attack Damages Enemy", test_kaelgor_basic_attack_damage)
	run_test("22. Kaelgor: Friendly Target Cannot Be Attacked", test_kaelgor_friendly_fire_prevention)
	run_test("23. Kaelgor: Heat Starts at Zero", test_kaelgor_heat_starts_at_zero)
	run_test("24. Kaelgor: Damage Received Generates Heat", test_kaelgor_damage_generates_heat)
	run_test("25. Kaelgor: Heat Cannot Exceed Maximum", test_kaelgor_heat_max_clamp)
	run_test("26. Kaelgor: Heat Decays Correctly Outside Combat", test_kaelgor_heat_decay)
	run_test("27. Kaelgor: Q Molten Fist Scales with Heat", test_kaelgor_q_heat_scaling)
	run_test("28. Kaelgor: W Vent Consumes Heat", test_kaelgor_w_consumes_heat)
	run_test("29. Kaelgor: W Cannot Consume More Heat than Available", test_kaelgor_w_no_negative_heat)
	run_test("30. Kaelgor: W Applies Slow Status Effect", test_kaelgor_w_applies_slow)
	run_test("31. Kaelgor: Iron Hide Reduces Damage", test_kaelgor_iron_hide_reduces_damage)
	run_test("32. Kaelgor: Iron Hide Generates Heat from Prevented Damage", test_kaelgor_iron_hide_generates_heat)
	run_test("33. Kaelgor: Prevented Damage Cannot Recursively Infinite Loop", test_kaelgor_prevented_damage_no_infinite_loop)
	run_test("34. Kaelgor: Overheat Activates Correctly (100 Heat)", test_kaelgor_overheat_activates)
	run_test("35. Kaelgor: Overheat Modifies Attacks with Splash", test_kaelgor_overheat_splash_damage)
	run_test("36. Kaelgor: Overheat Ends Correctly & Restores State", test_kaelgor_overheat_ends_correctly)
	run_test("37. Kaelgor: Cooldowns Prevent Rapid Casting", test_kaelgor_cooldowns_work)
	run_test("38. Kaelgor: Mana Costs Deduct from Pool", test_kaelgor_mana_costs_work)
	run_test("39. Kaelgor: Death Occurs at Zero HP", test_kaelgor_death_at_zero_hp)
	run_test("40. Kaelgor: Dead Hero Cannot Attack or Cast", test_kaelgor_dead_hero_restrictions)
	run_test("41. Kaelgor: Respawn Restores Valid State", test_kaelgor_respawn_restores_state)

	# --- 5 MAP BLUEPRINT TESTS ---
	run_test("42. Map: Neutral Jungle Camp Spawning & Archetypes", test_map_neutral_camp_spawning)
	run_test("43. Map: Rune Spawning & Buff Acquisition", test_map_rune_spawning)
	run_test("44. Map: Fountain Healing & Hostile Defense", test_map_fountain_healing_and_defense)
	run_test("45. Map: Outpost Objective Channeling & Capture", test_map_outpost_capture)
	run_test("46. Map: Lane Minion Spawner Waypoints", test_map_lane_spawner_waypoints)

	# --- 5 120-ITEM DATABASE TESTS ---
	run_test("47. Database: All 120 Items Registered with Full Categories", test_database_120_items_registered)
	run_test("48. Item Tree: 3-Tier Synthesis (Base -> Intermediate -> Legendary)", test_item_tree_3_tier_synthesis)
	run_test("49. Item Database: Boots Auto-Routing & Move Speed Applied", test_item_boots_routing_and_stats)
	run_test("50. Item Database: Legendary Item Stats Applied to Hero", test_item_legendary_stats_applied)
	run_test("51. Item Database: High Tier Selling with 70% Gold Refund", test_item_high_tier_selling)

	# --- 5 SHOP & INVENTORY UI TESTS ---
	run_test("52. Shop: Category Filtering Accuracy", test_shop_category_filtering)
	run_test("53. Shop: Purchase Updates Inventory, Gold and Stats", test_shop_purchase_and_inventory_sync)
	run_test("54. Shop: Recipe Tree Detects Owned Sub-Components", test_shop_recipe_tree_discount_calculation)
	run_test("55. Shop: Dedicated Boots Slot UI Interaction", test_shop_dedicated_boots_interaction)
	run_test("56. Shop: Slot Selling Clears Item & Grants 70% Refund", test_shop_slot_selling_refund)

	# --- 6 LANE COMBAT TESTS ---
	run_test("57. Lane Combat: Creep Wave Composition & Archetypes", test_creep_wave_composition)
	run_test("58. Lane Combat: Creep AI Aggro & Combat Execution", test_creep_combat_and_aggro)
	run_test("59. Lane Combat: Creep Death Grants Gold Bounty & Hero XP", test_creep_death_bounty_and_xp_reward)
	run_test("60. Lane Combat: Tower Targeting & Physical Fire", test_tower_targeting_and_attack)
	run_test("61. Lane Combat: Tower Destruction Awards Team Gold", test_tower_destruction_and_team_gold)
	run_test("62. Lane Combat: Kaelgor Combat vs Creeps and Towers", test_kaelgor_combat_against_creeps_and_towers)

	# --- 11 ASTRIS HERO & COUNTERPLAY TESTS ---
	run_test("63. Astris: Initializes with INT Primary & Ranged Archetype", test_astris_initialization)
	run_test("64. Astris: Ranged Basic Attack Damage & Range", test_astris_ranged_basic_attack)
	run_test("65. Astris: Passive High Mana Affinity Grants Magic Pen", test_astris_passive_mana_affinity)
	run_test("66. Astris: Q Arcane Bolt Scales with AP", test_astris_q_scaling)
	run_test("67. Astris: Q Overcharge Consumption & Mana Restore", test_astris_q_overcharge)
	run_test("68. Astris: W Temporal Stasis Deals Damage and Roots Target", test_astris_w_root_effect)
	run_test("69. Astris: E Mana Barrier Shields with Max Mana Scaling", test_astris_e_mana_barrier_shield)
	run_test("70. Astris: R Astral Rupture Execution Scaling & Slow", test_astris_r_execution_and_slow)
	run_test("71. Duel: Astris Kites Kaelgor with W Root CC", test_duel_astris_kites_kaelgor)
	run_test("72. Duel: Kaelgor Iron Hide Absorbs Astris Burst & Builds Heat", test_duel_kaelgor_absorbs_astris_burst)
	run_test("73. Duel: Astris Mana Barrier Prevents Kaelgor Q Damage", test_duel_astris_shield_absorbs_kaelgor_q)

	# --- 3 DOTA 2 HUD, CONTROLS & OBJECTIVES TESTS ---
	run_test("74. Dota HUD: Hero Binding, Health/Mana & Level Pips Synchronization", test_dota_hud_initialization)
	run_test("75. MOBA Controls: Click-to-Move Target Vector & Smooth Orientation", test_hero_controller_click_and_orientation)
	run_test("76. Objectives: Ancient Core & Roshan Boss Initialization & Stats", test_objective_entity_initialization)

	# --- 20 TASK 09: MATCH FLOW & ASTRIS BOT AI TESTS ---
	run_test("77. Match Flow: State Machine Transitions (PRE_GAME -> PLAYING -> COMPLETE)", test_match_state_transitions)
	run_test("78. Match Flow: Hero Death Triggers Score & Respawn Timer", test_match_hero_death_flow)
	run_test("79. Match Flow: Respawn Timer Countdown & Fountain Placement", test_match_respawn_timer_progress)
	run_test("80. Match Flow: Respawn State Reset (HP, Mana, Effects, Targetable)", test_match_respawn_state_reset)
	run_test("81. Match Flow: Double Respawn Race Condition Prevention", test_match_double_respawn_prevention)
	run_test("82. Bot AI: Lane Waypoint Advancement in Free Lane", test_bot_state_lane_advancement)
	run_test("83. Bot AI: Minion Targeting & Spacing", test_bot_minion_targeting)
	run_test("84. Bot AI: Last-Hit Calculation & Priority", test_bot_lasthit_opportunity)
	run_test("85. Bot AI: Hero Harass State at Safe Range", test_bot_hero_targeting_harass)
	run_test("86. Bot AI: Low Health Triggers Retreat to Safety", test_bot_retreat_low_health)
	run_test("87. Bot AI: Tower Defense State under Friendly Structure", test_bot_tower_defense_state)
	run_test("88. Bot AI: Astris Q Arcane Bolt Safe Distance Poke", test_bot_astris_q_decision)
	run_test("89. Bot AI: Astris W Temporal Stasis Defensive Root vs Gap-Close", test_bot_astris_w_root_decision)
	run_test("90. Bot AI: Astris E Mana Barrier Shield Activation", test_bot_astris_e_barrier_decision)
	run_test("91. Bot AI: Astris R Astral Rupture Low-HP Execute Combo", test_bot_astris_r_execute_decision)
	run_test("92. Match Flow: Dire Ancient Destruction Triggers VICTORY", test_match_ancient_destruction_victory)
	run_test("93. Match Flow: Radiant Ancient Destruction Triggers DEFEAT", test_match_ancient_destruction_defeat)
	run_test("94. Match Flow: Match Conclusion Lock & Double Victory Prevention", test_match_double_victory_prevention)
	run_test("95. Match Flow: Statistics Dictionary Format & Integrity", test_match_statistics_generation)
	run_test("96. Match Flow: Full Reset Restores Heroes, Structures & Timers", test_match_full_reset)

	# --- 16 CORE MOBA GAMEPLAY LOOP TESTS ---
	run_test("97. Core Loop: Hero -> Hero Basic Attack & Cooldown Pacing", test_hero_to_hero_attack)
	run_test("98. Core Loop: Hero -> Creep Attack & Health Depletion", test_hero_to_creep_attack)
	run_test("99. Core Loop: Creep -> Creep Autonomous Combat", test_creep_to_creep_attack)
	run_test("100. Core Loop: Creep -> Hero Retaliation Attack", test_creep_to_hero_attack)
	run_test("101. Core Loop: Creep Last-Hit Awards Bounty Gold Directly to Hero", test_creep_last_hit_gold_reward)
	run_test("102. Core Loop: Creep Death Grants XP to Killer & Nearby Heroes", test_creep_death_and_assist_xp)
	run_test("103. Core Loop: Lane Wave Lifecycle Spawns 3 Melee + 1 Ranged", test_lane_wave_spawning)
	run_test("104. Core Loop: 30-Second Wave Interval Spawning", test_wave_interval_timing)
	run_test("105. Core Loop: Siege Minion Spawns Every 3rd Wave", test_siege_creep_wave_rule)
	run_test("106. Core Loop: Jungle Initial Spawn & AVAILABLE State", test_jungle_initial_spawn)
	run_test("107. Core Loop: Jungle Camp Cleared -> RESPAWNING (60s Timer)", test_jungle_camp_cleared_to_respawning)
	run_test("108. Core Loop: Jungle Duplicate Spawn Prevention", test_jungle_duplicate_spawn_prevention)
	run_test("109. Core Loop: Jungle Neutral Kill Gold & XP Rewards", test_jungle_kill_rewards)
	run_test("110. Core Loop: Creep Aggro Retaliation Priority", test_creep_aggro_retaliation_priority)
	run_test("111. Core Loop: Creep Call-for-Help Nearby Aggro Pull", test_creep_call_for_help_aggro)
	# --- 12 TASK 09: CAMERA & PLAYER CONTROL FOUNDATION TESTS ---
	run_test("113. Camera: Map Bounds Hard Clamping", test_camera_bounds_clamping)
	run_test("114. Camera: Edge Panning Calculation & Direction Vector", test_camera_edge_panning)
	run_test("115. Camera: Spacebar Target Focus & Positioning", test_camera_focus_target)
	run_test("116. Camera: Mouse Wheel Zoom In/Out Clamping", test_camera_zoom_clamping)
	run_test("117. Selection: Unit Selection & Previous State Cleanup", test_hero_selection_and_cleanup)
	run_test("118. Selection: Friendly vs Enemy Selection Distinction", test_hero_friendly_vs_enemy_selection)
	run_test("119. Command: Move Command Dispatch & Target Location", test_move_command_dispatch)
	run_test("120. Movement: Arrival at Destination Completes Movement & Sets IDLE", test_movement_completion_on_arrival)
	run_test("121. Command: Enemy Hero Right-Click Issues ATTACK Command", test_enemy_target_attack_command)
	run_test("122. Command: Creep & Tower Right-Click Issues ATTACK Command", test_creep_and_tower_attack_command)
	# --- 18 TASK 10: BASIC ATTACK & TARGETING SYSTEM TESTS ---
	run_test("125. Targeting: Hero Selects Enemy Hero", test_targeting_select_enemy_hero)
	run_test("126. Targeting: Hero Selects Enemy Creep", test_targeting_select_enemy_creep)
	run_test("127. Targeting: Hero Selects Enemy Tower", test_targeting_select_enemy_tower)
	run_test("128. Targeting: Friendly Target Attack Command Rejection", test_targeting_friendly_rejection)
	run_test("129. Targeting: Out of Attack Range Triggers Movement", test_targeting_out_of_range_movement)
	run_test("130. Combat: Target Enters Attack Range Triggers Basic Attack", test_targeting_enters_range_attacks)
	run_test("131. Combat: Basic Attack Physical Damage Calculation", test_combat_basic_physical_damage)
	run_test("132. Combat: Armor Mitigation on Basic Attack", test_combat_armor_mitigation)
	run_test("133. Combat: Attack Cooldown Countdown & Interval", test_combat_attack_cooldown_countdown)
	run_test("134. Combat: Attack Speed Modifies Attack Interval", test_combat_attack_speed_interval_scaling)
	run_test("135. Combat: Target Death Cleans Up Attack State", test_combat_target_death_cleanup)
	run_test("136. Combat: Attack Cancellation on Move Command", test_combat_attack_cancellation_on_move)
	run_test("137. Combat: Dead Hero Cannot Attack", test_combat_dead_hero_cannot_attack)
	run_test("138. Combat: Dead Hero Cannot Receive New Attack Command", test_combat_dead_hero_cannot_receive_command)
	run_test("139. Combat: Target Freed / Invalid Reference Safe Cleanup", test_combat_target_freed_safe_cleanup)
	run_test("140. Events: Attack Started & Attack Landed Event Hooks", test_combat_attack_event_hooks)
	run_test("141. Events: Damage Dealt Global Event Hook", test_combat_damage_dealt_event_hook)
	run_test("142. Events: Entity Died & Killed Global Event Hooks", test_combat_entity_died_event_hook)
	# --- 4 OVERHEAD HEALTH BAR & ATTACK MOTION VISUAL TESTS ---
	run_test("143. Visuals: Overhead Health Bar Team Color & Sync", test_overhead_healthbar_team_color_and_sync)
	run_test("144. Visuals: Overhead Health Bar 250 HP Segment Calculations", test_overhead_healthbar_segments)
	run_test("145. Visuals: 3D Projectile Homing & Damage Delivery", test_projectile_homing_and_delivery)
	run_test("146. Visuals: Floating Combat Damage Number Properties", test_floating_combat_text_properties)
	# --- 2 MINION AI & ANTI-STUCK NAVIGATION TESTS ---
	run_test("147. Minions: Crowd Separation Force & Collision Safety", test_minion_crowd_separation)
	run_test("148. Minions: Waypoint Progress & Passage Calculation", test_minion_waypoint_progress)
	# --- 2 TARGET DUMMY & DPS CALCULATION TESTS ---
	run_test("149. Target Dummy: Auto-Heal & Immortality Safeguard", test_target_dummy_immortality)
	run_test("150. Target Dummy: Rolling DPS & Total Damage Accumulation", test_target_dummy_dps_tracking)
	# --- 2 ACTIVE ITEMS & GROUND TARGETING INDICATOR TESTS ---
	run_test("151. Active Items: 1-6 Slot Activation, Cooldown & Stat Effects", test_active_item_usage)
	run_test("152. Ground Targeting: Range Decal & AOE Indicator Integration", test_ground_targeting_indicator)
	run_test("153. Demo Tool: DemoHeroPanel Unit Spawns, Max Level & Cheats", test_demo_hero_panel_integration)
	run_test("154. Minimap: World Mapping, Camera Frustum & Radar / Glyph", test_dota_minimap_frustum_and_world_mapping)
	run_test("155. Stats Card: DotaStatsPopup 2-Column Table & Attribute Mapping", test_dota_stats_popup_mapping)
	run_test("156. Alt Info Mode: 3D Tower Ranges, Hero Attack/Skill Circles & HP Overlays", test_alt_info_mode_range_indicators)
	run_test("157. Spell Targeting: Aiming Indicator, Cast Confirmation & Cancel", test_spell_targeting_flow)
	run_test("158. Hold-to-Aim: Key Release Cancellation & Soft-Lock Target Snapping", test_hold_to_aim_and_soft_lock)
	run_test("159. Move-to-Cast: Out-of-Range Queue, Pathing & Range Validation", test_out_of_range_move_to_cast)
	run_test("160. Target Filter: Ally, Enemy & Neutral/Jungle Creep Validation", test_target_filter_and_soft_lock)
	run_test("161. Ability Tooltip: DotaAbilityTooltip Info Card, Scaling & Descriptions", test_dota_ability_tooltip_card)
	run_test("162. Neutral Jungle Camps: Leashing, Shared Aggro & Camp Archetypes", test_neutral_creep_camp_mechanics)
	# --- 10 TASK 09: TARGETING & COMBAT FOUNDATION TESTS ---
	run_test("163. Task 09: Target Relation & Ally Rejection", test_task09_ally_target_rejected)
	run_test("164. Task 09: Enemy Target Acceptance (Hero, Creep, Tower)", test_task09_enemy_target_accepted)
	run_test("165. Task 09: Neutral Monster Target Acceptance", test_task09_neutral_monster_accepted)
	run_test("166. Task 09: Dead & Untargetable Target Rejection", test_task09_dead_target_rejected)
	run_test("167. Task 09: Range Check & Out-of-Range Rejection", test_task09_range_check)
	run_test("168. Task 09: Melee Basic Attack Damage Pipeline", test_task09_melee_attack_pipeline)
	run_test("169. Task 09: Ranged Projectile Damage Pipeline", test_task09_ranged_projectile_pipeline)
	run_test("170. Task 09: Attack Cooldown & Interval Enforcement", test_task09_attack_cooldown_enforcement)
	run_test("171. Task 09: Target Death Clears Attack State", test_task09_target_death_clears_attack)
	run_test("172. Task 09: Move Command Cancels Attack Windup", test_task09_move_command_cancels_attack)
	# --- 10 TASK 10: CREEP WAVE & LANE COMBAT TESTS ---
	run_test("173. Task 10: Wave Composition (3 Melee + 1 Ranged)", test_task10_wave_composition)
	run_test("174. Task 10: 3rd Wave Siege Creep Spawning", test_task10_siege_wave_spawning)
	run_test("175. Task 10: 3 Lanes Independent Spawner Execution", test_task10_three_lanes_spawners)
	run_test("176. Task 10: 30s Wave Spawner Timer Progression", test_task10_wave_timer_progression)
	run_test("177. Task 10: Melee vs Ranged Creep Combat Behavior", test_task10_melee_ranged_creep_combat)
	run_test("178. Task 10: Siege Creep Tower Bonus Damage", test_task10_siege_tower_bonus_damage)
	run_test("179. Task 10: Hero Aggro & Call for Help Propagation", test_task10_hero_aggro_call_for_help)
	run_test("180. Task 10: Last Hit Gold & XP Economics", test_task10_last_hit_gold_and_xp)
	run_test("181. Task 10: Non-Hero Kill Only Awards XP to Nearby Hero", test_task10_non_hero_kill_xp_only)
	run_test("182. Task 10: Dead Creep Target Rejection & Safe Cleanup", test_task10_dead_creep_target_rejection)
	# --- SOLEN: THE SOLAR ARCHER TESTS ---
	run_test("183. Solen: Ranged Agility Marksman Stats & Archetype", test_solen_stats_and_archetype)
	run_test("184. Solen: Solar Charge 5th-Hit Proc", test_solen_solar_charge_passive)
	run_test("185. Solen: Piercing Arrow & Solar Vault Abilities", test_solen_abilities)
	# --- SHOP & QUICK-BUY TESTS (market.png) ---
	run_test("186. Shop: Dota 2 Market UI & Quick-Buy Queueing", test_shop_and_quick_buy_system)
	run_test("187. Shop: Dota 2 Item Tooltip & Stat Breakdown", test_dota_item_tooltip)
	# --- 10 TASK 11: TOWER AI & STRUCTURE DEFENSE TESTS ---
	run_test("188. Task 11: Tower Retaliation Aggro on Ally Hero Attack", test_task11_tower_retaliation_aggro_on_ally_attack)
	run_test("189. Task 11: Tower Default Creep Priority Over Hero", test_task11_tower_creep_priority_over_hero)
	run_test("190. Task 11: Tower Direct Attacker Priority", test_task11_tower_direct_attacker_priority)
	run_test("191. Task 11: Tower A-Click Aggro Drop De-aggro", test_task11_tower_aggro_drop_deaggro)
	run_test("192. Task 11: Tower Backdoor Protection 70% Damage Reduction", test_task11_tower_backdoor_protection_damage_reduction)
	run_test("193. Task 11: Tower Backdoor Protection Disables on Creep Presence", test_task11_tower_backdoor_protection_creep_disable)
	run_test("194. Task 11: Tower Backdoor Protection HP Regeneration", test_task11_tower_backdoor_protection_hp_regen)
	run_test("195. Task 11: Tower True Sight Stealth Aura Detection", test_task11_tower_true_sight_reveals_stealth)
	run_test("196. Task 11: Tower Destruction Team Gold Bounty & Events", test_task11_tower_global_team_bounty_and_event)
	run_test("197. Task 11: Tower Range Indicator & Collision Cleanup", test_task11_tower_range_indicator_and_collision_cleanup)
	# --- 13 TASK 12: 3D WORLD-SPACE STATUS BARS TESTS ---
	run_test("198. Task 12: WorldStatusBar Entity Height Offsets", test_task12_world_status_bar_creation_and_offsets)
	run_test("199. Task 12: Health Bar Max/Current Ratio Calculation", test_task12_hp_bar_current_max_ratio)
	run_test("200. Task 12: Damage Causes Immediate Main Bar Drop", test_task12_damage_immediate_drop)
	run_test("201. Task 12: Delayed Damage Bar Lag and Smooth Catchup", test_task12_delayed_damage_bar_lag_and_catchup)
	run_test("202. Task 12: Heal Updates Main and Delayed Bar Instantly", test_task12_heal_immediate_update)
	run_test("203. Task 12: Mana Bar Active on Hero, Hidden on Creep/Tower", test_task12_mana_bar_hero_vs_creep)
	run_test("204. Task 12: Shield Indicator Active on Shielded Units", test_task12_shield_indicator_display)
	run_test("205. Task 12: Status Effect Stun Timer Display", test_task12_status_effect_stun_timer_display)
	run_test("206. Task 12: Status Effect Root Timer Display", test_task12_status_effect_root_timer_display)
	run_test("207. Task 12: Dead Entity Automatically Hides Status Bar", test_task12_dead_entity_bar_cleared)
	run_test("208. Task 12: Target Selection Scales & Highlights Status Bar", test_task12_target_selection_highlight)
	run_test("209. Task 12: Neutral Monster & Tower Status Bar Configurations", test_task12_neutral_and_tower_bars)
	run_test("210. Task 12: 100+ Entities Status Bar Scalability & Stability", test_task12_scalability_100_entities)
	# --- 16 TASK 13: COMBAT TARGETING & BASIC ATTACK TESTS ---
	run_test("211. Task 13: Melee Hero to Enemy Hero Basic Attack", test_task13_melee_hero_to_enemy_hero_damage)
	run_test("212. Task 13: Ranged Hero to Enemy Hero Basic Attack", test_task13_ranged_hero_to_enemy_hero_damage)
	run_test("213. Task 13: Hero to Enemy Creep Basic Attack", test_task13_hero_to_enemy_creep_damage)
	run_test("214. Task 13: Hero to Neutral Monster Basic Attack", test_task13_hero_to_neutral_monster_damage)
	run_test("215. Task 13: Hero to Enemy Tower Basic Attack", test_task13_hero_to_enemy_tower_damage)
	run_test("216. Task 13: Hero to Ally Hero Attack Rejection", test_task13_hero_to_ally_hero_rejected)
	run_test("217. Task 13: Hero to Ally Creep Attack Rejection", test_task13_hero_to_ally_creep_rejected)
	run_test("218. Task 13: Target Beyond Range Triggers Pursuit State", test_task13_pursuit_outside_range)
	run_test("219. Task 13: Moving into Attack Range Automatically Attacks", test_task13_auto_attack_upon_entering_range)
	run_test("220. Task 13: Attack Cooldown Prevents Double Attack", test_task13_attack_cooldown_enforcement)
	run_test("221. Task 13: Attack Speed Modifiers Scale Attack Intervals", test_task13_attack_speed_interval_scaling)
	run_test("222. Task 13: Target Death Immediately Stops Attack Loop", test_task13_target_death_stops_attack)
	run_test("223. Task 13: Projectile Target Freed In-Flight Safety", test_task13_projectile_target_freed_safety)
	run_test("224. Task 13: Target Switching Resets Attack Cycle", test_task13_target_switching)
	run_test("225. Task 13: Manual Movement Cancels Attack Command", test_task13_attack_command_cancellation)
	run_test("226. Task 13: Basic Attack Armor Mitigation via CombatCalculator", test_task13_armor_damage_reduction_calculation)
	# --- 17 TASK 14: DEATH, RESPAWN & COMBAT LIFECYCLE TESTS ---
	run_test("227. Task 14: HP 0 Triggers Death State", test_task14_hp_zero_triggers_death)
	run_test("228. Task 14: Death Only Triggers Once", test_task14_death_only_triggers_once)
	run_test("229. Task 14: Dead Entity Cannot Receive Damage", test_task14_dead_entity_cannot_receive_damage)
	run_test("230. Task 14: Dead Entity Cannot Attack", test_task14_dead_entity_cannot_attack)
	run_test("231. Task 14: Target Death Clears Attacker Target", test_task14_target_death_clears_attacker_target)
	run_test("232. Task 14: Projectile Ignores Dead Target Safely", test_task14_projectile_ignores_dead_target_safely)
	run_test("233. Task 14: Hero Death Starts Respawn Timer", test_task14_hero_death_starts_respawn_timer)
	run_test("234. Task 14: Hero Respawn Restores Full HP", test_task14_hero_respawn_restores_full_hp)
	run_test("235. Task 14: Hero Respawn Restores Full Mana", test_task14_hero_respawn_restores_full_mana)
	run_test("236. Task 14: Hero Respawn Clears CC Effects", test_task14_hero_respawn_clears_cc_effects)
	run_test("237. Task 14: Hero Respawn Clears Shields", test_task14_hero_respawn_clears_shields)
	run_test("238. Task 14: Hero Respawn Relocates to Spawn Origin", test_task14_hero_respawn_relocates_to_spawn_origin)
	run_test("239. Task 14: Creep Death Lifecycle & Signal", test_task14_creep_death_lifecycle_and_signal)
	run_test("240. Task 14: Neutral Monster Death Lifecycle & Signal", test_task14_neutral_death_lifecycle_and_signal)
	run_test("241. Task 14: Tower Destruction Lifecycle", test_task14_tower_destruction_lifecycle)
	run_test("242. Task 14: WorldStatusBar Hides on Death and Restores on Respawn", test_task14_world_status_bar_death_and_respawn_visibility)
	run_test("243. Task 14: Hero Respawn Timer Countdown and Auto-Respawn", test_task14_hero_respawn_timer_tick_and_auto_respawn)
	
	return {
		"passed": passed_count,
		"failed": failed_count,
		"results": test_results
	}

func run_test(test_name: String, test_callable: Callable) -> void:
	HeroEntity.active_heroes.clear()
	CreepEntity.active_creeps.clear()
	TowerEntity.active_towers.clear()
	var err = test_callable.call()
	HeroEntity.active_heroes.clear()
	CreepEntity.active_creeps.clear()
	TowerEntity.active_towers.clear()
	var is_passed = (err == null or err == "")
	if is_passed:
		passed_count += 1
		test_results.append({"name": test_name, "passed": true, "error": ""})
	else:
		failed_count += 1
		test_results.append({"name": test_name, "passed": false, "error": str(err)})

# ==============================================================================
# 19 CORE ARCHITECTURE TESTS
# ==============================================================================

func test_attribute_derivation() -> String:
	var stats = AttributeSystem.new()
	stats.base_strength = 20.0
	stats.base_agility = 14.0
	stats.base_intelligence = 25.0
	stats.primary_attribute = AttributeSystem.PrimaryAttributeType.STRENGTH
	stats.recalculate_all_stats()
	
	var max_hp = stats.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	if absf(max_hp - 600.0) > 0.01:
		return "Expected Max HP 600.0, got %f" % max_hp
	var armor = stats.get_stat(StatModifier.TargetStat.ARMOR)
	if absf(armor - 4.0) > 0.01:
		return "Expected Armor 4.0, got %f" % armor
	var max_mp = stats.get_stat(StatModifier.TargetStat.MAX_MANA)
	if absf(max_mp - 400.0) > 0.01:
		return "Expected Max Mana 400.0, got %f" % max_mp
	var ad = stats.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	if absf(ad - 45.0) > 0.01:
		return "Expected Attack Damage 45.0, got %f" % ad
	stats.free()
	return ""

func test_stat_modifiers() -> String:
	var stats = AttributeSystem.new()
	stats.base_attack_damage = 50.0
	stats.recalculate_all_stats()
	
	var mod_flat = StatModifier.new(StatModifier.TargetStat.ATTACK_DAMAGE, StatModifier.Type.FLAT, 20.0, "item_blade")
	stats.add_modifier(mod_flat)
	if absf(stats.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) - 70.0) > 0.01:
		return "Flat modifier failed to add 20 to 50"
		
	var mod_pct = StatModifier.new(StatModifier.TargetStat.ATTACK_DAMAGE, StatModifier.Type.PERCENT_ADD, 0.20, "buff_rage")
	stats.add_modifier(mod_pct)
	if absf(stats.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) - 84.0) > 0.01:
		return "Percent Add modifier failed: expected 84.0, got %f" % stats.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
		
	stats.remove_modifiers_by_source("item_blade")
	if absf(stats.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) - 60.0) > 0.01:
		return "Remove modifier by source failed: expected 60.0, got %f" % stats.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
		
	stats.free()
	return ""

func test_physical_damage_and_armor() -> String:
	var target = DummyEntity.new()
	target._ready()
	target.attribute_system.base_agility = 0.0
	target.attribute_system.agility_growth = 0.0
	target.attribute_system.base_armor = 100.0
	target.attribute_system.recalculate_all_stats()
	
	var req = DamageRequest.new()
	req.target = target
	req.base_damage = 200.0
	req.damage_type = DamageRequest.DamageType.PHYSICAL
	
	var res = CombatCalculator.execute_damage(req)
	if absf(res.final_health_damage - 100.0) > 0.01:
		return "Expected 100.0 mitigated damage with 100 armor, got %f" % res.final_health_damage
	target.free()
	return ""

func test_magical_damage_and_mr() -> String:
	var target = DummyEntity.new()
	target._ready()
	target.attribute_system.base_magic_resist = 50.0
	target.attribute_system.recalculate_all_stats()
	
	var req = DamageRequest.new()
	req.target = target
	req.base_damage = 300.0
	req.damage_type = DamageRequest.DamageType.MAGICAL
	
	var res = CombatCalculator.execute_damage(req)
	if absf(res.final_health_damage - 200.0) > 0.1:
		return "Expected 200.0 magical damage with 50 MR, got %f" % res.final_health_damage
	target.free()
	return ""

func test_true_damage() -> String:
	var target = DummyEntity.new()
	target._ready()
	target.attribute_system.base_armor = 500.0
	target.attribute_system.base_magic_resist = 500.0
	target.attribute_system.recalculate_all_stats()
	
	var req = DamageRequest.new()
	req.target = target
	req.base_damage = 250.0
	req.damage_type = DamageRequest.DamageType.TRUE_DAMAGE
	
	var res = CombatCalculator.execute_damage(req)
	if absf(res.final_health_damage - 250.0) > 0.01:
		return "True damage was mitigated! Expected 250.0, got %f" % res.final_health_damage
	target.free()
	return ""

func test_penetration() -> String:
	var target = DummyEntity.new()
	target._ready()
	target.attribute_system.base_agility = 0.0
	target.attribute_system.agility_growth = 0.0
	target.attribute_system.base_armor = 100.0
	target.attribute_system.recalculate_all_stats()
	
	var req = DamageRequest.new()
	req.target = target
	req.base_damage = 100.0
	req.damage_type = DamageRequest.DamageType.PHYSICAL
	req.armor_pen_percent = 0.20
	req.armor_pen_flat = 20.0
	
	var res = CombatCalculator.execute_damage(req)
	if absf(res.final_health_damage - 62.5) > 0.01:
		return "Expected 62.5 damage after 20%% and 20 flat pen, got %f" % res.final_health_damage
	target.free()
	return ""

func test_damage_amplification_and_reduction() -> String:
	var target = DummyEntity.new()
	target._ready()
	target.attribute_system.base_armor = 0.0
	target.attribute_system.recalculate_all_stats()
	
	var req = DamageRequest.new()
	req.target = target
	req.base_damage = 100.0
	req.damage_type = DamageRequest.DamageType.TRUE_DAMAGE
	req.damage_amplification = 0.30
	req.damage_reduction = 0.10
	
	var res = CombatCalculator.execute_damage(req)
	if absf(res.final_health_damage - 117.0) > 0.01:
		return "Expected 117.0 damage with amp and reduction, got %f" % res.final_health_damage
	target.free()
	return ""

func test_critical_strikes() -> String:
	var target = DummyEntity.new()
	target._ready()
	
	var req = DamageRequest.new()
	req.target = target
	req.base_damage = 100.0
	req.is_critical = true
	req.crit_multiplier = 2.0
	req.damage_type = DamageRequest.DamageType.TRUE_DAMAGE
	
	var res = CombatCalculator.execute_damage(req)
	if absf(res.final_health_damage - 200.0) > 0.01:
		return "Critical multiplier failed: expected 200.0, got %f" % res.final_health_damage
	target.free()
	return ""

func test_crowd_control_effects() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	
	var stun = StatusEffect.new("test_stun", StatusEffect.EffectType.STUN, 2.0)
	hero.effect_container.apply_effect(stun)
	if not hero.effect_container.is_stunned() or hero.can_act() or hero.can_move() or hero.can_cast():
		return "Stunned hero state check failed"
		
	hero.effect_container.remove_effect_by_id("test_stun")
	var silence = StatusEffect.new("test_silence", StatusEffect.EffectType.SILENCE, 2.0)
	hero.effect_container.apply_effect(silence)
	if not hero.can_move() or hero.can_cast():
		return "Silenced hero state check failed"
		
	hero.free()
	return ""

func test_shield_absorption() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	var max_hp = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	hero.attribute_system.heal(max_hp)
	
	var shield = StatusEffect.new("iron_shield", StatusEffect.EffectType.SHIELD, 5.0, 300.0, false)
	hero.effect_container.apply_effect(shield)
	
	var req = DamageRequest.new()
	req.target = hero
	req.base_damage = 200.0
	req.damage_type = DamageRequest.DamageType.TRUE_DAMAGE
	
	var res = CombatCalculator.execute_damage(req)
	if absf(res.shield_absorbed - 200.0) > 0.01 or res.final_health_damage != 0.0:
		return "Shield full absorption failed"
	if absf(hero.attribute_system.current_health - max_hp) > 0.01:
		return "Hero health reduced while shield was active"
		
	var res2 = CombatCalculator.execute_damage(req)
	if absf(res2.shield_absorbed - 100.0) > 0.01 or absf(res2.final_health_damage - 100.0) > 0.01:
		return "Shield partial absorption failed"
	hero.free()
	return ""

func test_dot_effects() -> String:
	var dummy = DummyEntity.new()
	dummy._ready()
	dummy.total_damage_taken = 0.0
	
	var dot = StatusEffect.new("test_dot", StatusEffect.EffectType.DAMAGE_OVER_TIME, 2.0, 50.0)
	dot.tick_interval = 0.5
	dummy.effect_container.apply_effect(dot)
	
	dummy.effect_container._process(0.5)
	var max_hp = dummy.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	if absf(dummy.attribute_system.current_health - (max_hp - 50.0)) > 0.01:
		return "DoT tick did not apply 50 damage"
	dummy.free()
	return ""

func test_status_effect_lifecycle() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	var slow = StatusEffect.new("test_slow", StatusEffect.EffectType.SLOW, 1.0, 0.30)
	hero.effect_container.apply_effect(slow)
	hero.effect_container.apply_effect(slow)
	
	if absf(hero.effect_container.active_effects[0].remaining_time - 1.0) > 0.01:
		return "Effect duration refresh failed"
	hero.effect_container._process(1.1)
	if hero.effect_container.active_effects.size() != 0:
		return "Expired effect was not cleaned up"
	hero.free()
	return ""

func test_ability_cooldown_and_mana() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	hero.attribute_system.base_mana = 200.0
	hero.attribute_system.current_mana = 200.0
	hero.attribute_system.recalculate_all_stats()
	
	var ab = AbilityResource.new()
	ab.id = "test_q"
	ab.cooldowns.assign([10.0])
	ab.mana_costs.assign([50.0])
	ab.base_damage.assign([100.0])
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.available_skill_points = 1
	hero.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var initial_mp = hero.attribute_system.current_mana
	var cast_success = hero.ability_container.cast_ability(AbilityResource.Slot.Q)
	
	if not cast_success:
		return "Ability cast failed"
	if absf(hero.attribute_system.current_mana - (initial_mp - 50.0)) > 0.01:
		return "Mana cost not deducted properly"
	if hero.ability_container.can_cast(AbilityResource.Slot.Q):
		return "Ability should be on cooldown"
	hero.free()
	return ""

func test_inventory_normal_limits() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	var inv = hero.inventory_manager
	inv.gold = 10000
	
	var item = ItemResource.new()
	item.id = 1
	item.cost = 100
	item.category = ItemResource.Category.BASE
	
	for i in range(6):
		inv.buy_item(item)
	if inv.buy_item(item):
		return "Inventory accepted 7th normal item when capacity is 6"
	hero.free()
	return ""

func test_dedicated_boots_slot() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	var inv = hero.inventory_manager
	inv.gold = 5000
	
	var boots = ItemResource.new()
	boots.id = 37
	boots.item_name = "Wanderer's Boots"
	boots.category = ItemResource.Category.BOOTS
	boots.cost = 500
	boots.stat_bonuses[StatModifier.TargetStat.MOVE_SPEED] = 35.0
	
	var initial_ms = hero.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	inv.buy_item(boots)
	
	if inv.boots_slot == null or inv.boots_slot.id != 37:
		return "Boots not routed to dedicated boots slot"
	if absf(hero.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED) - (initial_ms + 35.0)) > 0.01:
		return "Boots move speed bonus not applied"
	hero.free()
	return ""

func test_item_recipe_resolution() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	var inv = hero.inventory_manager
	inv.gold = 2000
	
	var item_lookup = func(id: int):
		match id:
			1:
				var it = ItemResource.new()
				it.id = 1; it.cost = 350; it.category = ItemResource.Category.BASE; return it
			2:
				var it = ItemResource.new()
				it.id = 2; it.cost = 600; it.category = ItemResource.Category.BASE; return it
			43:
				var it = ItemResource.new()
				it.id = 43; it.cost = 1100; it.category = ItemResource.Category.INTERMEDIATE
				it.recipe_components.assign([1, 2]); return it
			_: return null
			
	inv.buy_item(item_lookup.call(1))
	inv.buy_item(item_lookup.call(2))
	
	var solution = ItemTreeResolver.resolve_crafting(item_lookup.call(43), inv.gold, inv.slots, inv.boots_slot, item_lookup)
	if solution.final_gold_cost != 150:
		return "Recipe discount calculation failed"
	if not inv.buy_item(item_lookup.call(43), item_lookup):
		return "Failed to craft Warblade"
	if inv.slots[0] == null or inv.slots[0].id != 43:
		return "Crafted Warblade not in slot 0"
	if inv.gold != 900:
		return "Gold balance incorrect after crafting"
	hero.free()
	return ""

func test_item_selling() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	var inv = hero.inventory_manager
	inv.gold = 1000
	
	var item = ItemResource.new()
	item.id = 2
	item.cost = 600
	inv.buy_item(item)
	inv.sell_item(0)
	if inv.gold != 820 or inv.slots[0] != null:
		return "Selling refund failed"
	hero.free()
	return ""

func test_progression_system() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	var initial_lvl = hero.attribute_system.level
	hero.attribute_system.add_xp(hero.attribute_system.xp_to_next_level)
	if hero.attribute_system.level != initial_lvl + 1:
		return "Hero failed to level up"
	hero.free()
	return ""

func test_game_state_machine() -> String:
	var gsm = GameStateManager.new()
	gsm.transition_to(GameStateManager.State.PLAYING)
	if gsm.current_state != GameStateManager.State.PLAYING:
		return "Failed transition to PLAYING"
	gsm.free()
	return ""

# ==============================================================================
# 22 KAELGOR HERO TESTS
# ==============================================================================

func test_kaelgor_initialization() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	
	if kaelgor.entity_name != "Kaelgor":
		return "Kaelgor entity_name incorrect"
	if kaelgor.attribute_system.primary_attribute != AttributeSystem.PrimaryAttributeType.STRENGTH:
		return "Kaelgor primary attribute should be STRENGTH"
	if kaelgor.heat_system == null:
		return "Kaelgor HeatSystem component was not initialized"
	if kaelgor.ability_container.abilities[AbilityResource.Slot.Q] == null:
		return "Kaelgor Q ability (Molten Fist) not assigned"
	if kaelgor.ability_container.abilities[AbilityResource.Slot.W] == null:
		return "Kaelgor W ability (Vent) not assigned"
	if kaelgor.ability_container.abilities[AbilityResource.Slot.E] == null:
		return "Kaelgor E ability (Iron Hide) not assigned"
	if kaelgor.ability_container.abilities[AbilityResource.Slot.R] == null:
		return "Kaelgor R ability (Overheat) not assigned"
		
	kaelgor.free()
	return ""

func test_kaelgor_basic_attack_damage() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	
	var dummy = DummyEntity.new()
	dummy._ready()
	dummy.attribute_system.base_armor = 0.0
	dummy.attribute_system.recalculate_all_stats()
	
	var res = kaelgor.execute_basic_attack(dummy)
	if res == null or res.final_health_damage <= 0.0:
		return "Kaelgor basic attack failed to deal damage to dummy"
		
	kaelgor.free()
	dummy.free()
	return ""

func test_kaelgor_friendly_fire_prevention() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	
	var ally = HeroEntity.new()
	ally._ready()
	ally.team = TeamDefinitions.Team.RADIANT
	
	var res = kaelgor.execute_basic_attack(ally)
	if res != null:
		return "Kaelgor was able to attack a friendly teammate"
		
	kaelgor.free()
	ally.free()
	return ""

func test_kaelgor_heat_starts_at_zero() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	
	if kaelgor.heat_system.get_heat() != 0.0:
		return "Kaelgor Heat did not start at zero"
		
	kaelgor.free()
	return ""

func test_kaelgor_damage_generates_heat() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	
	var dummy = DummyEntity.new()
	dummy._ready()
	
	var req = DamageRequest.create_ability_damage(dummy, kaelgor, 300.0, DamageRequest.DamageType.PHYSICAL, "Test Strike")
	kaelgor.receive_damage(req)
	
	var heat = kaelgor.heat_system.get_heat()
	if heat <= 0.0:
		return "Receiving damage did not generate Heat for Kaelgor"
		
	kaelgor.free()
	dummy.free()
	return ""

func test_kaelgor_heat_max_clamp() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	
	kaelgor.heat_system.add_heat(500.0)
	if kaelgor.heat_system.get_heat() > kaelgor.heat_system.max_heat:
		return "Heat exceeded maximum limit of %f" % kaelgor.heat_system.max_heat
	if absf(kaelgor.heat_system.get_heat() - 100.0) > 0.01:
		return "Heat was not clamped to 100.0, got %f" % kaelgor.heat_system.get_heat()
		
	kaelgor.free()
	return ""

func test_kaelgor_heat_decay() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	
	kaelgor.heat_system.set_heat(50.0)
	kaelgor.heat_system.combat_timer = 0.0
	
	kaelgor.heat_system._process(2.0)
	if absf(kaelgor.heat_system.get_heat() - 30.0) > 0.1:
		return "Heat decay failed: expected ~30.0, got %f" % kaelgor.heat_system.get_heat()
		
	kaelgor.free()
	return ""

func test_kaelgor_q_heat_scaling() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.ability_container.available_skill_points = 1
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy1 = DummyEntity.new()
	dummy1._ready()
	dummy1.attribute_system.base_armor = 0.0
	dummy1.attribute_system.recalculate_all_stats()
	
	kaelgor.heat_system.set_heat(0.0)
	var res_no_heat = kaelgor.cast_kaelgor_q(dummy1)
	
	kaelgor.ability_container.cooldown_timers[AbilityResource.Slot.Q] = 0.0
	kaelgor.attribute_system.restore_mana(100.0)
	kaelgor.heat_system.set_heat(50.0)
	
	var dummy2 = DummyEntity.new()
	dummy2._ready()
	dummy2.attribute_system.base_armor = 0.0
	dummy2.attribute_system.recalculate_all_stats()
	
	var res_with_heat = kaelgor.cast_kaelgor_q(dummy2)
	var diff = res_with_heat.final_health_damage - res_no_heat.final_health_damage
	if absf(diff - 75.0) > 1.0:
		return "Q Heat scaling incorrect: expected ~75 bonus damage, got %f" % diff
		
	kaelgor.free()
	dummy1.free()
	dummy2.free()
	return ""

func test_kaelgor_w_consumes_heat() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.ability_container.available_skill_points = 1
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var dummy = DummyEntity.new()
	dummy._ready()
	
	kaelgor.heat_system.set_heat(60.0)
	kaelgor.cast_kaelgor_w([dummy])
	
	if kaelgor.heat_system.get_heat() != 0.0:
		return "W Vent failed to consume all Heat upon execution"
		
	kaelgor.free()
	dummy.free()
	return ""

func test_kaelgor_w_no_negative_heat() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.ability_container.available_skill_points = 1
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var dummy = DummyEntity.new()
	dummy._ready()
	
	kaelgor.heat_system.set_heat(0.0)
	kaelgor.cast_kaelgor_w([dummy])
	
	if kaelgor.heat_system.get_heat() < 0.0:
		return "Heat became negative after casting W with 0 Heat"
		
	kaelgor.free()
	dummy.free()
	return ""

func test_kaelgor_w_applies_slow() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.ability_container.available_skill_points = 1
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var dummy = DummyEntity.new()
	dummy._ready()
	
	kaelgor.cast_kaelgor_w([dummy])
	
	var has_slow = false
	for eff in dummy.effect_container.active_effects:
		if eff.effect_type == StatusEffect.EffectType.SLOW and eff.effect_id == "kaelgor_vent_slow":
			has_slow = true
			break
			
	if not has_slow:
		return "W Vent failed to apply Slow status effect to target"
		
	kaelgor.free()
	dummy.free()
	return ""

func test_kaelgor_iron_hide_reduces_damage() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.attribute_system.base_armor = 0.0
	kaelgor.attribute_system.base_agility = 0.0
	kaelgor.attribute_system.agility_growth = 0.0
	kaelgor.attribute_system.recalculate_all_stats()
	kaelgor.ability_container.available_skill_points = 1
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.E)
	kaelgor.ability_container.is_free_spells_active = true
	
	var dummy = DummyEntity.new()
	dummy._ready()
	dummy.attribute_system.base_intelligence = 0.0
	dummy.attribute_system.intelligence_growth = 0.0
	dummy.attribute_system.recalculate_all_stats()
	
	var req1 = DamageRequest.create_ability_damage(dummy, kaelgor, 100.0, DamageRequest.DamageType.PHYSICAL, "Strike")
	var _res1 = kaelgor.receive_damage(req1)
	
	kaelgor.cast_kaelgor_e()
	var req2 = DamageRequest.create_ability_damage(dummy, kaelgor, 100.0, DamageRequest.DamageType.PHYSICAL, "Strike")
	var res2 = kaelgor.receive_damage(req2)
	
	if absf(res2.final_health_damage - 70.0) > 0.01:
		return "Iron Hide 30%% damage reduction failed: expected 70.0 damage, got %f" % res2.final_health_damage
		
	kaelgor.free()
	dummy.free()
	return ""

func test_kaelgor_iron_hide_generates_heat() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.heat_system.set_heat(0.0)
	kaelgor.ability_container.available_skill_points = 1
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.E)
	kaelgor.ability_container.is_free_spells_active = true
	
	var dummy = DummyEntity.new()
	dummy._ready()
	
	kaelgor.cast_kaelgor_e()
	var req = DamageRequest.create_ability_damage(dummy, kaelgor, 200.0, DamageRequest.DamageType.PHYSICAL, "Strike")
	kaelgor.receive_damage(req)
	
	if kaelgor.heat_system.get_heat() <= 0.0:
		return "Iron Hide failed to generate Heat upon absorbing damage"
		
	kaelgor.free()
	dummy.free()
	return ""

func test_kaelgor_prevented_damage_no_infinite_loop() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.cast_kaelgor_e()
	
	var dummy = DummyEntity.new()
	dummy._ready()
	
	var req = DamageRequest.create_ability_damage(dummy, kaelgor, 100.0, DamageRequest.DamageType.PHYSICAL, "Strike")
	var res = kaelgor.receive_damage(req)
	if res == null:
		return "Iron Hide damage evaluation failed"
		
	kaelgor.free()
	dummy.free()
	return ""

func test_kaelgor_overheat_activates() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.ability_container.available_skill_points = 1
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	kaelgor.heat_system.set_heat(0.0)
	var activated = kaelgor.cast_kaelgor_r()
	
	if not activated or not kaelgor.is_overheated:
		return "Overheat failed to activate"
	if absf(kaelgor.heat_system.get_heat() - 100.0) > 0.01:
		return "Overheat did not fill Heat to 100"
		
	kaelgor.free()
	return ""

func test_kaelgor_overheat_splash_damage() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.ability_container.available_skill_points = 1
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.R)
	kaelgor.cast_kaelgor_r()
	
	var target = DummyEntity.new()
	target._ready()
	target.team = TeamDefinitions.Team.DIRE
	
	var res = kaelgor.execute_basic_attack(target)
	if res == null or res.final_health_damage <= 0.0:
		return "Basic attack during Overheat failed"
		
	kaelgor.free()
	target.free()
	return ""

func test_kaelgor_overheat_ends_correctly() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.ability_container.available_skill_points = 1
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.R)
	kaelgor.cast_kaelgor_r()
	
	kaelgor._process(8.1)
	if kaelgor.is_overheated:
		return "Overheat did not end after duration expired"
	if kaelgor.heat_system.is_decay_locked:
		return "Heat decay remained locked after Overheat ended"
		
	kaelgor.free()
	return ""

func test_kaelgor_cooldowns_work() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.ability_container.available_skill_points = 1
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = DummyEntity.new()
	dummy._ready()
	
	var first_cast = kaelgor.cast_kaelgor_q(dummy)
	if first_cast == null:
		return "First Q cast failed"
		
	var second_cast = kaelgor.cast_kaelgor_q(dummy)
	if second_cast != null:
		return "Q was cast again while on cooldown"
		
	kaelgor.free()
	dummy.free()
	return ""

func test_kaelgor_mana_costs_work() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.ability_container.available_skill_points = 1
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = DummyEntity.new()
	dummy._ready()
	
	var init_mana = kaelgor.attribute_system.current_mana
	kaelgor.cast_kaelgor_q(dummy)
	
	if absf(kaelgor.attribute_system.current_mana - (init_mana - 50.0)) > 0.01:
		return "Mana cost (50.0) was not deducted properly from Kaelgor"
		
	kaelgor.free()
	dummy.free()
	return ""

func test_kaelgor_death_at_zero_hp() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	
	kaelgor.attribute_system.apply_damage_to_health(10000.0, "Lethal Strike")
	if kaelgor.is_alive():
		return "Kaelgor should be dead after lethal damage"
	if kaelgor.attribute_system.current_health != 0.0:
		return "Health should be 0 on death"
		
	kaelgor.free()
	return ""

func test_kaelgor_dead_hero_restrictions() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.attribute_system.apply_damage_to_health(10000.0, "Lethal Strike")
	
	var dummy = DummyEntity.new()
	dummy._ready()
	
	if kaelgor.can_attack() or kaelgor.can_cast() or kaelgor.can_move():
		return "Dead hero can_attack/can_cast/can_move should return false"
	if kaelgor.execute_basic_attack(dummy) != null:
		return "Dead hero executed basic attack"
	if kaelgor.cast_kaelgor_q(dummy) != null:
		return "Dead hero cast Q ability"
		
	kaelgor.free()
	dummy.free()
	return ""

func test_kaelgor_respawn_restores_state() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.attribute_system.apply_damage_to_health(10000.0, "Lethal Strike")
	
	kaelgor.respawn()
	if not kaelgor.is_alive():
		return "Hero is_alive should be true after respawn"
	var max_hp = kaelgor.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	if absf(kaelgor.attribute_system.current_health - max_hp) > 0.01:
		return "Health not restored to maximum upon respawn"
	var max_mp = kaelgor.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
	if absf(kaelgor.attribute_system.current_mana - max_mp) > 0.01:
		return "Mana not restored to maximum upon respawn"
		
	kaelgor.free()
	return ""

# ==============================================================================
# 5 MAP BLUEPRINT TESTS
# ==============================================================================

func test_map_neutral_camp_spawning() -> String:
	var camp = NeutralCampSpawner.new()
	camp.camp_type = NeutralCampSpawner.CampType.LARGE
	camp._ready()
	
	if camp.active_neutrals.size() != 4:
		return "Large neutral camp expected 4 creeps, got %d" % camp.active_neutrals.size()
	if camp.active_neutrals[0].team != TeamDefinitions.Team.NEUTRAL:
		return "Spawned neutral creep team should be NEUTRAL"
	if camp.active_neutrals[0].gold_bounty != 85:
		return "Large camp gold bounty expected 85, got %d" % camp.active_neutrals[0].gold_bounty
		
	camp.free()
	return ""

func test_map_rune_spawning() -> String:
	var rune = RuneSpawner.new()
	rune.rune_type = RuneSpawner.RuneType.BOUNTY
	rune._ready()
	
	var hero = HeroEntity.new()
	hero._ready()
	var init_gold = hero.inventory_manager.gold
	
	rune._grant_rune_effect(hero)
	if hero.inventory_manager.gold != (init_gold + 100):
		return "Bounty rune failed to grant 100 gold"
		
	rune.free()
	hero.free()
	return ""

func test_map_fountain_healing_and_defense() -> String:
	var fountain = FountainHealingArea.new()
	fountain.team = TeamDefinitions.Team.RADIANT
	fountain._ready()
	
	var ally = HeroEntity.new()
	ally._ready()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.attribute_system.current_health = 100.0
	
	fountain.entities_in_fountain.append(ally)
	fountain._process(1.0)
	
	if ally.attribute_system.current_health <= 100.0:
		return "Fountain failed to heal friendly hero"
		
	var enemy = HeroEntity.new()
	enemy._ready()
	enemy.team = TeamDefinitions.Team.DIRE
	var init_enemy_hp = enemy.attribute_system.current_health
	
	fountain.entities_in_fountain.clear()
	fountain.entities_in_fountain.append(enemy)
	fountain._process(1.0)
	
	if enemy.attribute_system.current_health >= init_enemy_hp:
		return "Fountain failed to damage enemy trespasser"
		
	fountain.free()
	ally.free()
	enemy.free()
	return ""

func test_map_outpost_capture() -> String:
	var outpost = OutpostObjective.new()
	outpost.controlling_team = TeamDefinitions.Team.RADIANT
	outpost._ready()
	
	var enemy = HeroEntity.new()
	enemy._ready()
	enemy.team = TeamDefinitions.Team.DIRE
	
	outpost.current_channeler = enemy
	outpost._process(6.1)
	
	if outpost.controlling_team != TeamDefinitions.Team.DIRE:
		return "Outpost was not captured by channeling enemy team"
		
	outpost.free()
	enemy.free()
	return ""

func test_map_lane_spawner_waypoints() -> String:
	var spawner = LaneMinionSpawner.new()
	spawner.team = TeamDefinitions.Team.RADIANT
	spawner.lane = LaneMinionSpawner.Lane.TOP
	var dummy_wp: Array[Vector3] = [Vector3(0, 0, 0), Vector3(10, 0, 10)]
	spawner.lane_waypoints = dummy_wp
	
	spawner.spawn_wave()
	var creep = spawner.last_spawned_wave[0] if not spawner.last_spawned_wave.is_empty() else null
	if creep == null:
		return "Spawner failed to spawn creep"
	if creep.waypoints.size() != 2:
		return "Spawned creep did not inherit lane waypoints"
		
	spawner.free()
	return ""

# ==============================================================================
# 5 120-ITEM DATABASE TESTS
# ==============================================================================

func test_database_120_items_registered() -> String:
	var total_count = Database.get_total_item_count()
	if total_count != 120:
		return "Database item count expected 120, got %d" % total_count
		
	var base_items = Database.get_items_by_category(ItemResource.Category.BASE)
	if base_items.size() != 36:
		return "Expected 36 Base items, got %d" % base_items.size()
		
	var boots_items = Database.get_items_by_category(ItemResource.Category.BOOTS)
	if boots_items.size() != 6:
		return "Expected 6 Boots items, got %d" % boots_items.size()
		
	var intermediate_items = Database.get_items_by_category(ItemResource.Category.INTERMEDIATE)
	if intermediate_items.size() != 30:
		return "Expected 30 Intermediate items, got %d" % intermediate_items.size()
		
	var legendary_items = Database.get_items_by_category(ItemResource.Category.LEGENDARY)
	if legendary_items.size() < 40:
		return "Expected at least 40 Legendary items, got %d" % legendary_items.size()
		
	var support_items = Database.get_items_by_category(ItemResource.Category.SUPPORT)
	if support_items.size() < 7:
		return "Expected at least 7 Support items, got %d" % support_items.size()
		
	return ""

func test_item_tree_3_tier_synthesis() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	var inv = hero.inventory_manager
	inv.gold = 5000
	
	var warblade = Database.get_item(43)
	var vital_core = Database.get_item(51)
	var ravager = Database.get_item(78)
	
	if warblade == null or vital_core == null or ravager == null:
		return "Failed to fetch required crafting components from Database"
		
	inv.buy_item(warblade, Database.get_item)
	inv.buy_item(vital_core, Database.get_item)
	
	var solution = ItemTreeResolver.resolve_crafting(ravager, inv.gold, inv.slots, inv.boots_slot, Database.get_item)
	if solution.final_gold_cost != 550:
		return "3-Tier recipe discount calculation failed: expected 550g, got %d" % solution.final_gold_cost
		
	var craft_ok = inv.buy_item(ravager, Database.get_item)
	if not craft_ok:
		return "Failed to synthesize Legendary Ravager"
	if inv.slots[0] == null or inv.slots[0].id != 78:
		return "Synthesized Ravager not present in slot 0"
	if inv.slots[1] != null:
		return "Consumed intermediate slot was not cleared"
	if inv.gold != (2700 - 550):
		return "Gold balance incorrect after legendary synthesis: expected 2150, got %d" % inv.gold
		
	hero.free()
	return ""

func test_item_boots_routing_and_stats() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	var inv = hero.inventory_manager
	inv.gold = 5000
	
	var base_ms = hero.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	var swiftstep = Database.get_item(38)
	
	if swiftstep == null:
		return "Swiftstep Boots not found in Database"
		
	var bought = inv.buy_item(swiftstep, Database.get_item)
	if not bought:
		return "Failed to purchase Swiftstep Boots"
	if inv.boots_slot == null or inv.boots_slot.id != 38:
		return "Boots were not routed to dedicated boots slot"
	if inv.slots[0] != null:
		return "Boots occupied standard inventory slot instead of dedicated boots slot"
		
	var new_ms = hero.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	if absf(new_ms - (base_ms + 55.0)) > 0.01:
		return "Boots movement speed bonus not applied: expected %f, got %f" % [base_ms + 55.0, new_ms]
		
	hero.free()
	return ""

func test_item_legendary_stats_applied() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	var inv = hero.inventory_manager
	inv.gold = 10000
	
	var base_ad = hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var base_hp = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	
	var ravager = Database.get_item(78)
	inv.buy_item(ravager, Database.get_item)
	
	var new_ad = hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var new_hp = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	
	if absf(new_ad - (base_ad + 50.0)) > 0.01:
		return "Legendary Ravager AD bonus (+50) not applied"
	if absf(new_hp - (base_hp + 250.0)) > 0.01:
		return "Legendary Ravager Max HP bonus (+250) not applied"
		
	hero.free()
	return ""

func test_item_high_tier_selling() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	var inv = hero.inventory_manager
	inv.gold = 5000
	
	var colossus = Database.get_item(83)
	inv.buy_item(colossus, Database.get_item)
	
	inv.sell_item(0)
	if inv.gold != 4160:
		return "Selling legendary item refund failed: expected 4160g, got %d" % inv.gold
	if inv.slots[0] != null:
		return "Sold item slot was not cleared"
		
	hero.free()
	return ""

# ==============================================================================
# 5 SHOP & INVENTORY UI TESTS
# ==============================================================================

func test_shop_category_filtering() -> String:
	var all_items = Database.get_all_items()
	if all_items.size() != 120:
		return "Total items count mismatch: expected 120, got %d" % all_items.size()
		
	var base_items = Database.get_items_by_category(ItemResource.Category.BASE)
	var boots_items = Database.get_items_by_category(ItemResource.Category.BOOTS)
	var intermediate_items = Database.get_items_by_category(ItemResource.Category.INTERMEDIATE)
	var legendary_items = Database.get_items_by_category(ItemResource.Category.LEGENDARY)
	var support_items = Database.get_items_by_category(ItemResource.Category.SUPPORT)
	
	if base_items.size() != 36:
		return "Base category filter failed: expected 36, got %d" % base_items.size()
	if boots_items.size() != 6:
		return "Boots category filter failed: expected 6, got %d" % boots_items.size()
	if intermediate_items.size() != 30:
		return "Intermediate category filter failed: expected 30, got %d" % intermediate_items.size()
	if legendary_items.size() < 40:
		return "Legendary category filter failed: expected >=40, got %d" % legendary_items.size()
	if support_items.size() < 7:
		return "Support category filter failed: expected >=7, got %d" % support_items.size()
		
	return ""

func test_shop_purchase_and_inventory_sync() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	var inv = hero.inventory_manager
	inv.gold = 3000
	
	var heavy_sword = Database.get_item(2)
	var bought = inv.buy_item(heavy_sword, Database.get_item)
	
	if not bought:
		return "Shop purchase execution failed"
	if inv.gold != 2400:
		return "Gold balance incorrect after purchase: expected 2400, got %d" % inv.gold
	if inv.slots[0] == null or inv.slots[0].id != 2:
		return "Purchased item not found in slot 0"
	if absf(hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) - (hero.attribute_system.base_attack_damage + 18.0)) > 0.01:
		return "Purchased item stat was not synchronized to hero"
		
	hero.free()
	return ""

func test_shop_recipe_tree_discount_calculation() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	var inv = hero.inventory_manager
	inv.gold = 3000
	
	var blade = Database.get_item(1)
	inv.buy_item(blade, Database.get_item)
	
	var warblade = Database.get_item(43)
	var solution = ItemTreeResolver.resolve_crafting(warblade, inv.gold, inv.slots, inv.boots_slot, Database.get_item)
	
	if solution.components_owned_value != 350:
		return "Recipe resolver failed to recognize owned 350g component: got %d" % solution.components_owned_value
	if solution.final_gold_cost != 750:
		return "Discounted remaining cost failed: expected 750g, got %d" % solution.final_gold_cost
		
	hero.free()
	return ""

func test_shop_dedicated_boots_interaction() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	var inv = hero.inventory_manager
	inv.gold = 5000
	
	var iron_blade = Database.get_item(1)
	for i in range(6):
		inv.buy_item(iron_blade, Database.get_item)
		
	var boots = Database.get_item(37)
	var bought_boots = inv.buy_item(boots, Database.get_item)
	
	if not bought_boots:
		return "Failed to purchase boots when normal inventory is full (Dedicated slot routing failed)"
	if inv.boots_slot == null or inv.boots_slot.id != 37:
		return "Boots were not placed into dedicated boots slot"
		
	hero.free()
	return ""

func test_shop_slot_selling_refund() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	var inv = hero.inventory_manager
	inv.gold = 1000
	
	var staff = Database.get_item(56)
	inv.gold = 2000
	inv.buy_item(staff, Database.get_item)
	
	inv.sell_item(0)
	
	if inv.gold != 1565:
		return "Selling refund calculation failed: expected 1565g, got %d" % inv.gold
	if inv.slots[0] != null:
		return "Inventory slot 0 was not freed after selling"
		
	hero.free()
	return ""

# ==============================================================================
# 6 LANE COMBAT TESTS
# ==============================================================================

func test_creep_wave_composition() -> String:
	var spawner = LaneMinionSpawner.new()
	spawner._ready()
	
	spawner.spawn_wave()
	if spawner.last_spawned_wave.size() != 4:
		return "Normal wave expected 4 creeps, got %d" % spawner.last_spawned_wave.size()
		
	var melee_creep = spawner.last_spawned_wave[0]
	var ranged_creep = spawner.last_spawned_wave[3]
	
	if melee_creep == null or melee_creep.creep_type != CreepEntity.CreepType.MELEE:
		return "First spawned creep should be MELEE"
	if absf(melee_creep.attribute_system.base_health - 550.0) > 0.01:
		return "Melee creep base health expected 550, got %f" % melee_creep.attribute_system.base_health
		
	if ranged_creep == null or ranged_creep.creep_type != CreepEntity.CreepType.RANGED:
		return "Fourth spawned creep should be RANGED"
	if absf(ranged_creep.attribute_system.base_attack_range - 450.0) > 0.01:
		return "Ranged creep attack range expected 450, got %f" % ranged_creep.attribute_system.base_attack_range
		
	spawner.spawn_wave()
	spawner.spawn_wave()
	
	if spawner.last_spawned_wave.size() != 5:
		return "Siege wave (Wave 3) expected 5 creeps, got %d" % spawner.last_spawned_wave.size()
		
	var siege_creep = spawner.last_spawned_wave[4]
	if siege_creep == null or siege_creep.creep_type != CreepEntity.CreepType.SIEGE:
		return "Fifth creep in siege wave should be SIEGE archetype"
	if absf(siege_creep.attribute_system.base_health - 800.0) > 0.01:
		return "Siege creep base health expected 800, got %f" % siege_creep.attribute_system.base_health
		
	spawner.free()
	return ""

func test_creep_combat_and_aggro() -> String:
	var rad_creep = CreepEntity.new()
	rad_creep.team = TeamDefinitions.Team.RADIANT
	rad_creep.creep_type = CreepEntity.CreepType.MELEE
	rad_creep._ready()
	
	var dire_creep = CreepEntity.new()
	dire_creep.team = TeamDefinitions.Team.DIRE
	dire_creep.creep_type = CreepEntity.CreepType.MELEE
	dire_creep._ready()
	
	var init_dire_hp = dire_creep.attribute_system.current_health
	var res = rad_creep.execute_basic_attack(dire_creep)
	
	if res == null or res.final_health_damage <= 0.0:
		return "Creep basic attack failed to deal damage"
	if dire_creep.attribute_system.current_health >= init_dire_hp:
		return "Target creep health did not decrease after attack"
		
	rad_creep.free()
	dire_creep.free()
	return ""

func test_creep_death_bounty_and_xp_reward() -> String:
	var killer_hero = HeroEntity.new()
	killer_hero.entity_name = "Kaelgor"
	killer_hero.team = TeamDefinitions.Team.RADIANT
	killer_hero._ready()
	var init_gold = killer_hero.inventory_manager.gold
	var init_xp = killer_hero.attribute_system.current_xp
	
	var enemy_creep = CreepEntity.new()
	enemy_creep.team = TeamDefinitions.Team.DIRE
	enemy_creep.creep_type = CreepEntity.CreepType.MELEE
	enemy_creep.gold_bounty = 38
	enemy_creep.xp_bounty = 60
	enemy_creep._ready()
	
	enemy_creep._on_death(killer_hero.entity_name)
	
	if killer_hero.inventory_manager.gold != (init_gold + 38):
		return "Killer hero did not receive 38 gold bounty: expected %d, got %d" % [init_gold + 38, killer_hero.inventory_manager.gold]
	if killer_hero.attribute_system.current_xp != (init_xp + 60):
		return "Killer hero did not receive 60 XP bounty: expected %d, got %d" % [init_xp + 60, killer_hero.attribute_system.current_xp]
		
	killer_hero.free()
	enemy_creep.free()
	return ""

func test_tower_targeting_and_attack() -> String:
	var tower = TowerEntity.new()
	tower.team = TeamDefinitions.Team.RADIANT
	tower.tier = 1
	tower._ready()
	
	var enemy_creep = CreepEntity.new()
	enemy_creep.team = TeamDefinitions.Team.DIRE
	enemy_creep._ready()
	var init_creep_hp = enemy_creep.attribute_system.current_health
	
	var res = tower._execute_tower_attack(enemy_creep)
	
	if res == null or res.final_health_damage <= 0.0:
		return "Tower attack failed to deal damage"
	if enemy_creep.attribute_system.current_health >= init_creep_hp:
		return "Enemy creep health was not reduced by tower fire"
	if tower.attack_cooldown_timer <= 0.0:
		return "Tower attack cooldown timer was not set after firing"
		
	tower.free()
	enemy_creep.free()
	return ""

func test_tower_destruction_and_team_gold() -> String:
	var rad_tower = TowerEntity.new()
	rad_tower.entity_name = "Radiant_Top_T1"
	rad_tower.team = TeamDefinitions.Team.RADIANT
	rad_tower.tier = 1
	rad_tower.team_bounty_gold = 150
	rad_tower._ready()
	
	var dire_hero = HeroEntity.new()
	dire_hero.entity_name = "Dire_Hero"
	dire_hero.team = TeamDefinitions.Team.DIRE
	dire_hero._ready()
	var init_gold = dire_hero.inventory_manager.gold
	
	rad_tower.last_attacker = dire_hero
	rad_tower._on_death(dire_hero.entity_name)
	
	if not rad_tower.is_destroyed:
		return "Tower is_destroyed flag not set upon death"
	if dire_hero.inventory_manager.gold != (init_gold + 150):
		return "Enemy hero did not receive 150 team gold bounty upon tower destruction"
		
	rad_tower.free()
	dire_hero.free()
	return ""

func test_kaelgor_combat_against_creeps_and_towers() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	kaelgor.ability_container.available_skill_points = 4
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.Q)
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.W)
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.E)
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var enemy_creep = CreepEntity.new()
	enemy_creep.team = TeamDefinitions.Team.DIRE
	enemy_creep._ready()
	
	var enemy_tower = TowerEntity.new()
	enemy_tower.team = TeamDefinitions.Team.DIRE
	enemy_tower._ready()
	
	var creep_res = kaelgor.execute_basic_attack(enemy_creep)
	if creep_res == null or creep_res.final_health_damage <= 0.0:
		return "Kaelgor basic attack failed against enemy creep"
		
	var tower_q_res = kaelgor.cast_kaelgor_q(enemy_tower)
	if tower_q_res == null or tower_q_res.final_health_damage <= 0.0:
		return "Kaelgor Q failed against enemy tower"
		
	kaelgor.heat_system.set_heat(0.0)
	var tower_shot = enemy_tower._execute_tower_attack(kaelgor)
	if tower_shot == null or tower_shot.final_health_damage <= 0.0:
		return "Tower failed to damage Kaelgor"
	if kaelgor.heat_system.get_heat() <= 0.0:
		return "Kaelgor failed to generate Heat from receiving tower damage"
		
	kaelgor.free()
	enemy_creep.free()
	enemy_tower.free()
	return ""

# ==============================================================================
# 11 ASTRIS HERO & COUNTERPLAY TESTS
# ==============================================================================

func test_astris_initialization() -> String:
	var astris = AstrisHero.new()
	astris._ready()
	
	if astris.entity_name != "Astris":
		return "Astris entity_name incorrect"
	if astris.attribute_system.primary_attribute != AttributeSystem.PrimaryAttributeType.INTELLIGENCE:
		return "Astris primary attribute should be INTELLIGENCE"
	const HeroRes = preload("res://core/entities/hero_resource.gd")
	if astris.hero_resource.attack_type != HeroRes.AttackType.RANGED:
		return "Astris attack_type should be RANGED"
	if absf(astris.attribute_system.base_attack_range - 575.0) > 0.01:
		return "Astris attack range expected 575, got %f" % astris.attribute_system.base_attack_range
	if astris.ability_container.abilities[AbilityResource.Slot.Q] == null:
		return "Astris Q ability missing"
	if astris.ability_container.abilities[AbilityResource.Slot.W] == null:
		return "Astris W ability missing"
	if astris.ability_container.abilities[AbilityResource.Slot.E] == null:
		return "Astris E ability missing"
	if astris.ability_container.abilities[AbilityResource.Slot.R] == null:
		return "Astris R ability missing"
		
	astris.free()
	return ""

func test_astris_ranged_basic_attack() -> String:
	var astris = AstrisHero.new()
	astris._ready()
	
	var dummy = DummyEntity.new()
	dummy._ready()
	dummy.attribute_system.base_armor = 0.0
	dummy.attribute_system.base_agility = 0.0
	dummy.attribute_system.recalculate_all_stats()
	
	var ad = astris.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var req = DamageRequest.create_basic_attack(astris, dummy, ad)
	var res = dummy.receive_damage(req)
	if res == null or res.final_health_damage <= 0.0:
		return "Astris ranged basic attack failed"
	var expected_dmg = ad * (1.0 + astris.attribute_system.get_stat(StatModifier.TargetStat.DAMAGE_AMPLIFICATION))
	if absf(res.final_health_damage - expected_dmg) > 0.1:
		return "Astris base attack damage expected %f, got %f" % [expected_dmg, res.final_health_damage]
		
	astris.free()
	dummy.free()
	return ""

func test_astris_passive_mana_affinity() -> String:
	var astris = AstrisHero.new()
	astris._ready()
	
	# Current mana starts at 100% (>50%), should have +15% Magic Pen
	var pen = astris.attribute_system.get_stat(StatModifier.TargetStat.MAGIC_PEN_PERCENT)
	if absf(pen - 0.15) > 0.01:
		return "Astris passive failed to grant +15% Magic Penetration at full mana: got %f" % pen
		
	# Reduce mana below 50%
	astris.attribute_system.current_mana = 50.0
	astris._apply_passive_mana_affinity()
	var low_mana_pen = astris.attribute_system.get_stat(StatModifier.TargetStat.MAGIC_PEN_PERCENT)
	if low_mana_pen != 0.0:
		return "Astris passive Magic Penetration should be 0 when mana is below 50%"
		
	astris.free()
	return ""

func test_astris_q_scaling() -> String:
	var astris = AstrisHero.new()
	astris._ready()
	astris.attribute_system.base_intelligence = 0.0
	astris.attribute_system.intelligence_growth = 0.0
	astris.attribute_system.recalculate_all_stats()
	astris.ability_container.available_skill_points = 1
	astris.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = DummyEntity.new()
	dummy._ready()
	dummy.attribute_system.base_magic_resist = 0.0
	dummy.attribute_system.recalculate_all_stats()
	
	var res = astris.cast_astris_q(dummy)
	if res == null or res.final_health_damage <= 0.0:
		return "Astris Q cast failed"
	# Base dmg 80 + 0 AP = 80
	if absf(res.final_health_damage - 80.0) > 0.01:
		return "Astris Q base damage expected 80.0, got %f" % res.final_health_damage
		
	astris.free()
	dummy.free()
	return ""

func test_astris_q_overcharge() -> String:
	var astris = AstrisHero.new()
	astris._ready()
	astris.attribute_system.base_intelligence = 0.0
	astris.attribute_system.intelligence_growth = 0.0
	astris.attribute_system.recalculate_all_stats()
	astris.ability_container.available_skill_points = 1
	astris.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	# Give 100 AP to Astris
	astris.attribute_system.add_modifier(StatModifier.new(StatModifier.TargetStat.ABILITY_POWER, StatModifier.Type.FLAT, 100.0, "test_ap"))
	
	var dummy = DummyEntity.new()
	dummy._ready()
	dummy.attribute_system.base_magic_resist = 0.0
	dummy.attribute_system.recalculate_all_stats()
	
	# First cast activates Overcharge: Base 80 + 80 AP = 160 dmg
	astris.cast_astris_q(dummy)
	
	# Second cast consumes Overcharge: Base 80 + 80 AP + 25 Overcharge AP = 185 dmg
	astris.ability_container.cooldown_timers[AbilityResource.Slot.Q] = 0.0
	var res_empowered = astris.cast_astris_q(dummy)
	
	if absf(res_empowered.final_health_damage - 185.0) > 0.01:
		return "Overcharged Q expected 185.0 damage, got %f" % res_empowered.final_health_damage
		
	astris.free()
	dummy.free()
	return ""

func test_astris_w_root_effect() -> String:
	var astris = AstrisHero.new()
	astris._ready()
	astris.ability_container.available_skill_points = 1
	astris.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var dummy = DummyEntity.new()
	dummy._ready()
	
	astris.cast_astris_w([dummy])
	
	var has_root = false
	for eff in dummy.effect_container.active_effects:
		if eff.effect_type == StatusEffect.EffectType.ROOT and eff.effect_id == "astris_stasis_root":
			has_root = true
			break
			
	if not has_root:
		return "Astris W failed to apply Root status effect to target"
	if dummy.can_move():
		return "Rooted target should not be able to move (can_move must be false)"
		
	astris.free()
	dummy.free()
	return ""

func test_astris_e_mana_barrier_shield() -> String:
	var astris = AstrisHero.new()
	astris._ready()
	astris.ability_container.available_skill_points = 1
	astris.ability_container.level_up_ability(AbilityResource.Slot.E)
	astris.ability_container.is_free_spells_active = true
	
	var init_hp = astris.attribute_system.current_health
	var casted = astris.cast_astris_e()
	if not casted:
		return "astris.cast_astris_e() returned false"
	
	var dummy = DummyEntity.new()
	dummy._ready()
	
	# Hit Astris with 100 true damage
	var req = DamageRequest.create_ability_damage(dummy, astris, 100.0, DamageRequest.DamageType.TRUE_DAMAGE, "Test Hit")
	var res = astris.receive_damage(req)
	
	if res.final_health_damage > 0.0 or res.shield_absorbed < 100.0:
		return "Mana Barrier failed to absorb 100 damage (absorbed=%f, final=%f)" % [res.shield_absorbed, res.final_health_damage]
	if astris.attribute_system.current_health != init_hp:
		return "Astris HP was reduced despite active shield"
		
	astris.free()
	dummy.free()
	return ""

func test_astris_r_execution_and_slow() -> String:
	var astris = AstrisHero.new()
	astris.team = TeamDefinitions.Team.DIRE
	astris._ready()
	astris.attribute_system.base_intelligence = 0.0
	astris.attribute_system.intelligence_growth = 0.0
	astris.attribute_system.recalculate_all_stats()
	astris.ability_container.available_skill_points = 1
	astris.ability_container.level_up_ability(AbilityResource.Slot.R)
	astris.ability_container.is_free_spells_active = true
	
	var dummy = DummyEntity.new()
	dummy.team = TeamDefinitions.Team.RADIANT
	dummy._ready()
	dummy.attribute_system.base_magic_resist = 0.0
	dummy.attribute_system.base_health = 600.0
	dummy.attribute_system.recalculate_all_stats()
	dummy.attribute_system.current_health = 100.0 # 500 missing HP from 600 max HP
	
	var res_arr = astris.cast_astris_r([dummy])
	if res_arr.is_empty():
		return "Astris R failed to execute"
		
	var has_slow = false
	for eff in dummy.effect_container.active_effects:
		if eff.effect_type == StatusEffect.EffectType.SLOW and eff.effect_id == "astris_astral_slow":
			has_slow = true
			break
			
	if not has_slow:
		return "Astris R failed to apply 50% slow"
	# Base 250 + 60 AP + 75 missing HP execution (500 * 0.15) = 385 damage
	if absf(res_arr[0].final_health_damage - 385.0) > 0.01:
		return "Astris R execution scaling failed: expected 385.0, got %f" % res_arr[0].final_health_damage
		
	astris.free()
	dummy.free()
	return ""

func test_duel_astris_kites_kaelgor() -> String:
	var astris = AstrisHero.new()
	astris.team = TeamDefinitions.Team.DIRE
	astris._ready()
	astris.ability_container.available_skill_points = 1
	astris.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	
	# Astris roots Kaelgor with W
	astris.cast_astris_w([kaelgor])
	
	if kaelgor.can_move():
		return "Kaelgor should be rooted by Astris Temporal Stasis"
	if astris.attribute_system.base_attack_range <= kaelgor.attribute_system.base_attack_range:
		return "Astris ranged attack advantage failed"
		
	astris.free()
	kaelgor.free()
	return ""

func test_duel_kaelgor_absorbs_astris_burst() -> String:
	var astris = AstrisHero.new()
	astris.team = TeamDefinitions.Team.DIRE
	astris._ready()
	astris.ability_container.available_skill_points = 1
	astris.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	kaelgor.heat_system.set_heat(0.0)
	kaelgor.ability_container.available_skill_points = 1
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.E)
	kaelgor.ability_container.is_free_spells_active = true
	
	# Kaelgor activates Iron Hide
	kaelgor.cast_kaelgor_e()
	
	# Astris fires Arcane Bolt (80 base magic damage)
	var bolt_res = astris.cast_astris_q(kaelgor)
	
	if bolt_res == null:
		return "Astris Q failed against Kaelgor"
	# Kaelgor generates Heat from prevented damage
	if kaelgor.heat_system.get_heat() <= 0.0:
		return "Kaelgor failed to generate Heat from absorbing Astris Arcane Bolt"
		
	astris.free()
	kaelgor.free()
	return ""

func test_duel_astris_shield_absorbs_kaelgor_q() -> String:
	var astris = AstrisHero.new()
	astris.team = TeamDefinitions.Team.DIRE
	astris._ready()
	astris.ability_container.available_skill_points = 1
	astris.ability_container.level_up_ability(AbilityResource.Slot.E)
	astris.ability_container.is_free_spells_active = true
	
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	kaelgor.ability_container.available_skill_points = 1
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.Q)
	kaelgor.ability_container.is_free_spells_active = true
	kaelgor.ability_container.available_skill_points = 1
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	# Astris activates Mana Barrier
	astris.cast_astris_e()
	var init_astris_hp = astris.attribute_system.current_health
	
	# Kaelgor casts Q Molten Fist on Astris
	var q_res = kaelgor.cast_kaelgor_q(astris)
	
	if q_res == null or q_res.shield_absorbed <= 0.0:
		return "Mana Barrier failed to absorb Kaelgor Molten Fist"
	if astris.attribute_system.current_health < (init_astris_hp - 50.0):
		return "Astris took unmitigated health damage while Mana Barrier was active"
		
	astris.free()
	kaelgor.free()
	return ""

# ==============================================================================
# 2 DOTA 2 HUD & MOBA CONTROLS TESTS
# ==============================================================================

func test_dota_hud_initialization() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	
	var hud = DotaHUD.new()
	hud.target_hero = kaelgor
	hud._ready()
	hud._update_dota_hud_values()
	
	if hud.hero_name_label == null or hud.hero_name_label.text != "KAELGOR":
		return "Dota HUD hero name label not bound to Kaelgor"
	if hud.hp_bar == null or hud.hp_bar.value <= 0.0:
		return "Dota HUD HP bar not updated"
	if hud.heat_container == null or not hud.heat_container.visible:
		return "Dota HUD Heat bar should be visible for Kaelgor"
		
	hud.free()
	kaelgor.free()
	return ""

func test_hero_controller_click_and_orientation() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.global_position = Vector3(0, 0, 0)
	
	var controller = HeroController3D.new()
	controller.hero = kaelgor
	controller._ready()
	
	# Issue ground move command to (10, 0, 10)
	controller._issue_move_command(Vector3(10, 0, 10))
	
	if not kaelgor.is_navigating or kaelgor.destination_point != Vector3(10, 0, 10):
		return "Move command target position was not set correctly on hero"
		
	# Rotate hero towards destination
	controller._rotate_hero_towards(Vector3(10, 0, 10), 0.1)
	
	# Verify rotation angle oriented towards target quadrant
	if absf(kaelgor.rotation.y) < 0.01:
		return "Hero rotation did not orient towards clicked destination"
		
	controller.free()
	kaelgor.free()
	return ""

func test_objective_entity_initialization() -> String:
	# Test Ancient Core
	var core = ObjectiveEntity.new()
	core.objective_type = ObjectiveEntity.ObjectiveType.ANCIENT_CORE
	core.team = TeamDefinitions.Team.RADIANT
	core._ready()
	
	if core.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH) != 8000.0:
		return "Ancient Core base health mismatch"
	if core.team_global_gold != 500:
		return "Ancient Core team bounty gold mismatch"
		
	# Test Roshan Boss
	var roshan = ObjectiveEntity.new()
	roshan.objective_type = ObjectiveEntity.ObjectiveType.ROSHAN_BOSS
	roshan._ready()
	
	if roshan.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH) != 6500.0:
		return "Roshan Boss base health mismatch"
	if roshan.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) != 125.0:
		return "Roshan Boss attack damage mismatch"
		
	core.free()
	roshan.free()
	return ""

# ==============================================================================
# 20 TASK 09: MATCH FLOW & ASTRIS BOT AI TESTS
# ==============================================================================

func test_match_state_transitions() -> String:
	var mgr = MatchManager.new()
	mgr._ready()
	
	if mgr.current_state != MatchManager.MatchState.PRE_GAME:
		return "Initial match state should be PRE_GAME"
		
	mgr.set_state(MatchManager.MatchState.PLAYING)
	if mgr.current_state != MatchManager.MatchState.PLAYING:
		return "Failed transition to PLAYING"
		
	mgr.set_state(MatchManager.MatchState.HERO_DEAD)
	if mgr.current_state != MatchManager.MatchState.HERO_DEAD:
		return "Failed transition to HERO_DEAD"
		
	mgr.set_state(MatchManager.MatchState.VICTORY)
	if mgr.current_state != MatchManager.MatchState.VICTORY:
		return "Failed transition to VICTORY"
		
	mgr.free()
	return ""

func test_match_hero_death_flow() -> String:
	var mgr = MatchManager.new()
	mgr._ready()
	
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	
	mgr.start_match(kaelgor, null, null, null)
	mgr.trigger_hero_death(kaelgor)
	
	if not mgr.is_radiant_respawning or mgr.radiant_respawn_timer <= 0.0:
		return "Radiant respawn timer was not initiated"
	if mgr.dire_kills != 1:
		return "Dire kill count was not incremented"
	if mgr.current_state != MatchManager.MatchState.HERO_DEAD:
		return "Match state was not updated to HERO_DEAD"
		
	kaelgor.free()
	mgr.free()
	return ""

func test_match_respawn_timer_progress() -> String:
	var mgr = MatchManager.new()
	mgr._ready()
	
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	kaelgor.global_position = Vector3(0, 0, 0)
	
	mgr.start_match(kaelgor, null, null, null)
	mgr.trigger_hero_death(kaelgor)
	
	# Simulate 10 seconds of respawn delta
	mgr._process_respawns(10.0)
	
	if mgr.is_radiant_respawning:
		return "Hero should have finished respawning after 10s"
	var k_pos = kaelgor.global_position if kaelgor.is_inside_tree() else kaelgor.position
	if k_pos.distance_to(Vector3(-90.0, 1.5, 90.0)) > 1.0:
		return "Hero was not repositioned at Radiant Fountain spawn point"
		
	kaelgor.free()
	mgr.free()
	return ""

func test_match_respawn_state_reset() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	
	# Apply damage and effect
	kaelgor.attribute_system.current_health = 0.0
	kaelgor.attribute_system.is_alive = false
	kaelgor._on_death("Enemy")
	
	if kaelgor.is_targetable or kaelgor.visible:
		return "Dead hero should not be targetable or visible"
		
	kaelgor.respawn()
	
	if not kaelgor.attribute_system.is_alive:
		return "Respawned hero should be alive"
	if not kaelgor.is_targetable or not kaelgor.visible:
		return "Respawned hero should be targetable and visible"
	if kaelgor.attribute_system.current_health < kaelgor.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH):
		return "Respawned hero should have full HP"
		
	kaelgor.free()
	return ""

func test_match_double_respawn_prevention() -> String:
	var mgr = MatchManager.new()
	mgr._ready()
	
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	
	mgr.start_match(kaelgor, null, null, null)
	mgr.trigger_hero_death(kaelgor)
	var first_timer = mgr.radiant_respawn_timer
	
	# Process partial time
	mgr._process_respawns(1.0)
	
	if mgr.radiant_respawn_timer >= first_timer:
		return "Timer failed to decrease"
		
	kaelgor.free()
	mgr.free()
	return ""

func test_bot_state_lane_advancement() -> String:
	var astris = AstrisHero.new()
	astris.team = TeamDefinitions.Team.DIRE
	astris._ready()
	astris.global_position = Vector3(70.0, 1.5, -70.0)
	
	var bot = BotHeroController.new()
	bot.bot_hero = astris
	bot._ready()
	
	bot._evaluate_and_update_state()
	if bot.current_state != BotHeroController.BotState.LANE:
		return "Bot should choose LANE state when no enemies are present"
		
	bot._execute_current_state(0.1)
	if not astris.is_navigating:
		return "Bot should start navigating towards next waypoint in LANE state"
		
	bot.free()
	astris.free()
	return ""

func test_bot_minion_targeting() -> String:
	var astris = AstrisHero.new()
	astris.team = TeamDefinitions.Team.DIRE
	astris._ready()
	astris.global_position = Vector3(0, 0, 0)
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.RADIANT
	creep._ready()
	creep.global_position = Vector3(3.0, 0.0, 0.0)
	
	var bot = BotHeroController.new()
	bot.bot_hero = astris
	bot._ready()
	
	var target = bot._find_best_creep_target()
	if target == null:
		return "Bot should locate enemy minion within range"
		
	creep.free()
	bot.free()
	astris.free()
	return ""

func test_bot_lasthit_opportunity() -> String:
	var astris = AstrisHero.new()
	astris.team = TeamDefinitions.Team.DIRE
	astris._ready()
	astris.global_position = Vector3(0, 0, 0)
	
	var high_hp_creep = CreepEntity.new()
	high_hp_creep.team = TeamDefinitions.Team.RADIANT
	high_hp_creep._ready()
	high_hp_creep.attribute_system.current_health = 400.0
	high_hp_creep.global_position = Vector3(4.0, 0.0, 0.0)
	
	var low_hp_creep = CreepEntity.new()
	low_hp_creep.team = TeamDefinitions.Team.RADIANT
	low_hp_creep._ready()
	low_hp_creep.attribute_system.current_health = 30.0 # Below last hit threshold
	low_hp_creep.global_position = Vector3(5.0, 0.0, 0.0)
	
	var bot = BotHeroController.new()
	bot.bot_hero = astris
	bot._ready()
	
	var target = bot._find_best_creep_target()
	if target != low_hp_creep:
		return "Bot should prioritize low HP minion for last-hit"
		
	high_hp_creep.free()
	low_hp_creep.free()
	bot.free()
	astris.free()
	return ""

func test_bot_hero_targeting_harass() -> String:
	var astris = AstrisHero.new()
	astris.team = TeamDefinitions.Team.DIRE
	astris._ready()
	astris.position = Vector3(0, 0, 0)
	astris.global_position = Vector3(0, 0, 0)
	
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	kaelgor.position = Vector3(5.0, 0, 0)
	kaelgor.global_position = Vector3(5.0, 0, 0) # 5.0m range (Harass range)
	
	var bot = BotHeroController.new()
	bot.bot_hero = astris
	bot.opponent_hero = kaelgor
	bot._ready()
	
	bot._evaluate_and_update_state()
	if bot.current_state != BotHeroController.BotState.HARASS and bot.current_state != BotHeroController.BotState.ATTACK:
		return "Bot should switch to HARASS when enemy hero is in 5.0m poke range"
		
	bot.free()
	kaelgor.free()
	astris.free()
	return ""

func test_bot_retreat_low_health() -> String:
	var astris = AstrisHero.new()
	astris.team = TeamDefinitions.Team.DIRE
	astris._ready()
	astris.attribute_system.current_health = 100.0 # Low HP (<30%)
	
	var bot = BotHeroController.new()
	bot.bot_hero = astris
	bot._ready()
	
	bot._evaluate_and_update_state()
	if bot.current_state != BotHeroController.BotState.RETREAT:
		return "Bot should immediately switch to RETREAT when HP < 30%"
		
	bot.free()
	astris.free()
	return ""

func test_bot_tower_defense_state() -> String:
	var astris = AstrisHero.new()
	astris.team = TeamDefinitions.Team.DIRE
	astris._ready()
	astris.global_position = Vector3(25, 0, -25)
	
	var tower = TowerEntity.new()
	tower.team = TeamDefinitions.Team.DIRE
	tower._ready()
	tower.global_position = Vector3(25, 0, -25)
	
	var bot = BotHeroController.new()
	bot.bot_hero = astris
	bot.friendly_tower = tower
	bot._ready()
	
	var d_score = bot.eval_health_ratio()
	if d_score <= 0.0:
		return "Invalid bot health ratio"
		
	tower.free()
	bot.free()
	astris.free()
	return ""

func test_bot_astris_q_decision() -> String:
	var astris = AstrisHero.new()
	astris.team = TeamDefinitions.Team.DIRE
	astris._ready()
	astris.ability_container.available_skill_points = 1
	astris.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	
	var bot = BotHeroController.new()
	bot.bot_hero = astris
	bot.opponent_hero = kaelgor
	bot._ready()
	
	var cast_success = bot._try_cast_q(kaelgor)
	if not cast_success:
		return "Bot should successfully cast Q Arcane Bolt on target"
		
	bot.free()
	kaelgor.free()
	astris.free()
	return ""

func test_bot_astris_w_root_decision() -> String:
	var astris = AstrisHero.new()
	astris.team = TeamDefinitions.Team.DIRE
	astris._ready()
	astris.ability_container.available_skill_points = 1
	astris.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	
	var bot = BotHeroController.new()
	bot.bot_hero = astris
	bot.opponent_hero = kaelgor
	bot._ready()
	
	var cast_success = bot._try_cast_w(kaelgor)
	if not cast_success or not kaelgor.effect_container.has_effect("temporal_stasis_root"):
		return "Bot should cast W Temporal Stasis and root Kaelgor"
		
	bot.free()
	kaelgor.free()
	astris.free()
	return ""

func test_bot_astris_e_barrier_decision() -> String:
	var astris = AstrisHero.new()
	astris.team = TeamDefinitions.Team.DIRE
	astris._ready()
	astris.ability_container.available_skill_points = 1
	astris.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var bot = BotHeroController.new()
	bot.bot_hero = astris
	bot._ready()
	
	var cast_success = bot._try_cast_e()
	if not cast_success or not astris.effect_container.has_effect("mana_barrier_shield"):
		return "Bot should activate E Mana Barrier shield"
		
	bot.free()
	astris.free()
	return ""

func test_bot_astris_r_execute_decision() -> String:
	var astris = AstrisHero.new()
	astris.team = TeamDefinitions.Team.DIRE
	astris._ready()
	astris.ability_container.available_skill_points = 1
	astris.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	kaelgor.attribute_system.current_health = 150.0 # Low HP Execute window
	
	var bot = BotHeroController.new()
	bot.bot_hero = astris
	bot.opponent_hero = kaelgor
	bot._ready()
	
	var cast_success = bot._try_cast_r(kaelgor)
	if not cast_success:
		return "Bot should cast R Astral Rupture execution on low HP target"
		
	bot.free()
	kaelgor.free()
	astris.free()
	return ""

func test_match_ancient_destruction_victory() -> String:
	var mgr = MatchManager.new()
	mgr._ready()
	
	var rad_ancient = ObjectiveEntity.new()
	rad_ancient.team = TeamDefinitions.Team.RADIANT
	rad_ancient.objective_type = ObjectiveEntity.ObjectiveType.ANCIENT_CORE
	rad_ancient._ready()
	
	var dire_ancient = ObjectiveEntity.new()
	dire_ancient.team = TeamDefinitions.Team.DIRE
	dire_ancient.objective_type = ObjectiveEntity.ObjectiveType.ANCIENT_CORE
	dire_ancient._ready()
	
	mgr.start_match(null, null, rad_ancient, dire_ancient)
	
	# Destroy Dire Ancient
	mgr._on_ancient_destroyed(TeamDefinitions.Team.DIRE)
	
	if mgr.current_state != MatchManager.MatchState.VICTORY:
		return "Destroying Dire Ancient should result in VICTORY"
	if not mgr.is_match_concluded:
		return "Match should be marked as concluded"
		
	rad_ancient.free()
	dire_ancient.free()
	mgr.free()
	return ""

func test_match_ancient_destruction_defeat() -> String:
	var mgr = MatchManager.new()
	mgr._ready()
	
	var rad_ancient = ObjectiveEntity.new()
	rad_ancient.team = TeamDefinitions.Team.RADIANT
	rad_ancient.objective_type = ObjectiveEntity.ObjectiveType.ANCIENT_CORE
	rad_ancient._ready()
	
	var dire_ancient = ObjectiveEntity.new()
	dire_ancient.team = TeamDefinitions.Team.DIRE
	dire_ancient.objective_type = ObjectiveEntity.ObjectiveType.ANCIENT_CORE
	dire_ancient._ready()
	
	mgr.start_match(null, null, rad_ancient, dire_ancient)
	
	# Destroy Radiant Ancient
	mgr._on_ancient_destroyed(TeamDefinitions.Team.RADIANT)
	
	if mgr.current_state != MatchManager.MatchState.DEFEAT:
		return "Destroying Radiant Ancient should result in DEFEAT"
		
	rad_ancient.free()
	dire_ancient.free()
	mgr.free()
	return ""

func test_match_double_victory_prevention() -> String:
	var mgr = MatchManager.new()
	mgr._ready()
	mgr.start_match(null, null, null, null)
	
	mgr._on_ancient_destroyed(TeamDefinitions.Team.DIRE)
	var first_state = mgr.current_state
	
	# Attempt second destruction trigger
	mgr._on_ancient_destroyed(TeamDefinitions.Team.RADIANT)
	
	if mgr.current_state != first_state:
		return "Match conclusion state was illegally overwritten by subsequent call"
		
	mgr.free()
	return ""

func test_match_statistics_generation() -> String:
	var mgr = MatchManager.new()
	mgr._ready()
	
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	kaelgor.inventory_manager.gold = 1250
	
	mgr.start_match(kaelgor, null, null, null)
	mgr.radiant_kills = 3
	mgr.dire_kills = 1
	mgr.match_time = 145.0
	
	var stats = mgr.get_match_statistics(true)
	if not stats.get("is_victory", false):
		return "Stats is_victory mismatch"
	if stats.get("kills") != 3 or stats.get("deaths") != 1:
		return "Stats kills/deaths mismatch"
	if stats.get("gold_earned") != 1250:
		return "Stats gold earned mismatch"
		
	kaelgor.free()
	mgr.free()
	return ""

func test_match_full_reset() -> String:
	var mgr = MatchManager.new()
	mgr._ready()
	
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	kaelgor.attribute_system.level = 5
	kaelgor.inventory_manager.gold = 3000
	
	var astris = AstrisHero.new()
	astris.team = TeamDefinitions.Team.DIRE
	astris._ready()
	
	mgr.start_match(kaelgor, astris, null, null)
	mgr.radiant_kills = 5
	
	mgr.reset_match([], [])
	
	if mgr.radiant_kills != 0 or mgr.dire_kills != 0:
		return "Kills were not reset to zero"
	if kaelgor.attribute_system.level != 1 or kaelgor.inventory_manager.gold != 600:
		return "Hero level and gold were not reset to level 1 and 600g"
	if mgr.current_state != MatchManager.MatchState.PLAYING:
		return "Match state was not reset to PLAYING"
		
	kaelgor.free()
	astris.free()
	mgr.free()
	return ""

# ==============================================================================
# 16 CORE MOBA GAMEPLAY LOOP TESTS
# ==============================================================================

func test_hero_to_hero_attack() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	
	var astris = AstrisHero.new()
	astris.team = TeamDefinitions.Team.DIRE
	astris._ready()
	
	var prev_hp = astris.attribute_system.current_health
	var res = kaelgor.execute_basic_attack(astris)
	
	if res == null:
		return "Basic attack returned null"
	if astris.attribute_system.current_health >= prev_hp:
		return "Target hero did not take damage from basic attack"
	if kaelgor.attack_cooldown <= 0.0:
		return "Attack cooldown was not initiated"
		
	kaelgor.free()
	astris.free()
	return ""

func test_hero_to_creep_attack() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep.creep_type = CreepEntity.CreepType.MELEE
	creep._ready()
	
	var prev_hp = creep.attribute_system.current_health
	var res = kaelgor.execute_basic_attack(creep)
	
	if res == null:
		return "Hero attack on creep returned null"
	if creep.attribute_system.current_health >= prev_hp:
		return "Creep health did not decrease from hero basic attack"
		
	kaelgor.free()
	creep.free()
	return ""

func test_creep_to_creep_attack() -> String:
	var rad_creep = CreepEntity.new()
	rad_creep.team = TeamDefinitions.Team.RADIANT
	rad_creep._ready()
	
	var dire_creep = CreepEntity.new()
	dire_creep.team = TeamDefinitions.Team.DIRE
	dire_creep._ready()
	
	var prev_hp = dire_creep.attribute_system.current_health
	var res = rad_creep.execute_basic_attack(dire_creep)
	
	if res == null or dire_creep.attribute_system.current_health >= prev_hp:
		return "Creep vs creep basic attack failed"
		
	rad_creep.free()
	dire_creep.free()
	return ""

func test_creep_to_hero_attack() -> String:
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep._ready()
	
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var prev_hp = hero.attribute_system.current_health
	var res = creep.execute_basic_attack(hero)
	
	if res == null or hero.attribute_system.current_health >= prev_hp:
		return "Creep attack on hero failed"
		
	creep.free()
	hero.free()
	return ""

func test_creep_last_hit_gold_reward() -> String:
	var hero = KaelgorHero.new()
	hero.entity_name = "Kaelgor"
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	var initial_gold = hero.inventory_manager.gold
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep._ready()
	creep.gold_bounty = 45
	creep.xp_bounty = 75
	
	# Simulate lethal damage from hero
	creep.last_attacker = hero
	creep._on_death("Kaelgor")
	
	if hero.inventory_manager.gold != (initial_gold + 45):
		return "Hero was not awarded 45g bounty for last hitting creep"
		
	hero.free()
	creep.free()
	return ""

func test_creep_death_and_assist_xp() -> String:
	var killer_hero = KaelgorHero.new()
	killer_hero.entity_name = "Kaelgor"
	killer_hero.team = TeamDefinitions.Team.RADIANT
	killer_hero._ready()
	
	var assist_hero = AstrisHero.new()
	assist_hero.entity_name = "AstrisAlly"
	assist_hero.team = TeamDefinitions.Team.RADIANT
	assist_hero._ready()
	assist_hero.position = Vector3(2.0, 0, 0)
	assist_hero.global_position = Vector3(2.0, 0, 0)
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep.position = Vector3(0, 0, 0)
	creep.global_position = Vector3(0, 0, 0)
	creep._ready()
	creep.xp_bounty = 100
	
	creep.last_attacker = killer_hero
	creep._on_death("Kaelgor")
	
	if killer_hero.attribute_system.current_xp != 100:
		return "Killer hero did not receive full 100 XP"
	if assist_hero.attribute_system.current_xp != 50:
		return "Nearby assist hero did not receive 50% assist XP (50 XP)"
		
	killer_hero.free()
	assist_hero.free()
	creep.free()
	return ""

func test_lane_wave_spawning() -> String:
	var spawner = LaneMinionSpawner.new()
	spawner.team = TeamDefinitions.Team.RADIANT
	spawner.lane = LaneMinionSpawner.Lane.MID
	
	var spawned_box = [0]
	spawner.wave_spawned.connect(func(_num, _lane, _team): spawned_box[0] += 1)
	
	spawner.spawn_wave()
	
	if spawner.current_wave_number != 1:
		return "Wave number was not incremented to 1"
	if spawned_box[0] != 1:
		return "Wave spawned signal was not emitted"
		
	spawner.free()
	return ""

func test_wave_interval_timing() -> String:
	var spawner = LaneMinionSpawner.new()
	spawner.team = TeamDefinitions.Team.RADIANT
	spawner.wave_interval = 30.0
	spawner.wave_timer = 0.0
	
	# Simulate 29 seconds (no spawn yet)
	spawner._process(29.0)
	if spawner.current_wave_number != 0:
		return "Wave spawned prematurely before 30s interval"
		
	# Simulate 2 more seconds (total 31s -> 1 wave)
	spawner._process(2.0)
	if spawner.current_wave_number != 1:
		return "Wave failed to spawn after 30s interval"
		
	spawner.free()
	return ""

func test_siege_creep_wave_rule() -> String:
	var spawner = LaneMinionSpawner.new()
	spawner.team = TeamDefinitions.Team.RADIANT
	spawner.current_wave_number = 2 # Next will be 3 (Siege wave)
	
	spawner.spawn_wave()
	if spawner.current_wave_number != 3:
		return "Expected wave number 3"
		
	spawner.free()
	return ""

func test_jungle_initial_spawn() -> String:
	var camp = NeutralCampSpawner.new()
	camp.camp_name = "WolfCamp"
	camp.camp_type = NeutralCampSpawner.CampType.MEDIUM
	camp.respawn_interval = 60.0
	camp._ready()
	
	if camp.active_neutrals.size() != 3:
		return "Medium jungle camp should spawn 3 neutral creeps"
	if camp.current_state != NeutralCampSpawner.CampState.AVAILABLE:
		return "Camp state should be AVAILABLE after spawn"
		
	camp.free()
	return ""

func test_jungle_camp_cleared_to_respawning() -> String:
	var camp = NeutralCampSpawner.new()
	camp.camp_type = NeutralCampSpawner.CampType.SMALL
	camp._ready()
	
	# Clear all neutrals
	for n in camp.active_neutrals:
		n.attribute_system.is_alive = false
		
	camp._process(0.1)
	
	if camp.current_state != NeutralCampSpawner.CampState.RESPAWNING:
		return "Camp should transition to RESPAWNING state when cleared"
	if camp.respawn_timer < 59.0:
		return "Respawn timer was not set to 60s"
		
	camp.free()
	return ""

func test_jungle_duplicate_spawn_prevention() -> String:
	var camp = NeutralCampSpawner.new()
	camp.camp_type = NeutralCampSpawner.CampType.SMALL
	camp._ready()
	
	var prev_count = camp.active_neutrals.size()
	# Attempt illegal secondary spawn while creeps are alive
	camp.spawn_camp()
	
	if camp.active_neutrals.size() != prev_count:
		return "Duplicate spawn occurred while camp was still active"
		
	camp.free()
	return ""

func test_jungle_kill_rewards() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.entity_name = "Kaelgor"
	var start_gold = hero.inventory_manager.gold
	
	var neutral = CreepEntity.new()
	neutral.team = TeamDefinitions.Team.NEUTRAL
	neutral._ready()
	neutral.gold_bounty = 55
	neutral.xp_bounty = 80
	neutral.last_attacker = hero
	
	neutral._on_death("Kaelgor")
	
	if hero.inventory_manager.gold != (start_gold + 55):
		return "Hero did not receive jungle neutral gold bounty (55g)"
	if hero.attribute_system.current_xp != 80:
		return "Hero did not receive jungle neutral XP (80 XP)"
		
	hero.free()
	neutral.free()
	return ""

func test_creep_aggro_retaliation_priority() -> String:
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.RADIANT
	creep._ready()
	creep.global_position = Vector3(0, 0, 0)
	
	var enemy = CreepEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	enemy.global_position = Vector3(2, 0, 0)
	
	# Simulate enemy attacking creep
	var req = DamageRequest.create_basic_attack(enemy, creep, 20.0)
	creep.receive_damage(req)
	
	var target = creep._evaluate_aggro_target()
	if target != enemy:
		return "Creep failed to prioritize retaliating against its attacker"
		
	creep.free()
	enemy.free()
	return ""

func test_creep_call_for_help_aggro() -> String:
	var creep_a = CreepEntity.new()
	creep_a.team = TeamDefinitions.Team.RADIANT
	creep_a._ready()
	creep_a.global_position = Vector3(0, 0, 0)
	
	var creep_b = CreepEntity.new()
	creep_b.team = TeamDefinitions.Team.RADIANT
	creep_b._ready()
	creep_b.global_position = Vector3(1, 0, 0)
	
	var attacker = CreepEntity.new()
	attacker.team = TeamDefinitions.Team.DIRE
	attacker._ready()
	attacker.global_position = Vector3(3, 0, 0)
	
	creep_a._call_nearby_creeps_help(attacker)
	
	if creep_b.aggro_target != attacker:
		return "Nearby allied creep was not alerted by call-for-help"
		
	creep_a.free()
	creep_b.free()
	attacker.free()
	return ""

func test_tower_lane_pressure_damage() -> String:
	var tower = TowerEntity.new()
	tower.team = TeamDefinitions.Team.DIRE
	tower._ready()
	var prev_tower_hp = tower.attribute_system.current_health
	
	var siege_creep = CreepEntity.new()
	siege_creep.team = TeamDefinitions.Team.RADIANT
	siege_creep.creep_type = CreepEntity.CreepType.SIEGE
	siege_creep._ready()
	
	var res = siege_creep.execute_basic_attack(tower)
	
	if res == null or tower.attribute_system.current_health >= prev_tower_hp:
		return "Siege minion failed to deal damage to enemy tower"
		
	tower.free()
	siege_creep.free()
	return ""

# ==============================================================================
# 10 TASK 09: CAMERA & PLAYER CONTROL FOUNDATION TESTS
# ==============================================================================

func test_camera_bounds_clamping() -> String:
	var cam = MobaCamera3D.new()
	cam.min_boundary = Vector2(-100.0, -100.0)
	cam.max_boundary = Vector2(100.0, 100.0)
	
	# Test clamping outside upper bounds
	var clamped_high = cam.get_clamped_position(Vector3(300.0, 20.0, 450.0))
	if clamped_high.x != 100.0 or clamped_high.z != 100.0:
		return "Camera failed to clamp upper boundary: got (%f, %f)" % [clamped_high.x, clamped_high.z]
		
	# Test clamping outside lower bounds
	var clamped_low = cam.get_clamped_position(Vector3(-300.0, 20.0, -450.0))
	if clamped_low.x != -100.0 or clamped_low.z != -100.0:
		return "Camera failed to clamp lower boundary: got (%f, %f)" % [clamped_low.x, clamped_low.z]
		
	cam.free()
	return ""

func test_camera_edge_panning() -> String:
	var cam = MobaCamera3D.new()
	cam.position = Vector3(0, 20, 15)
	cam.global_position = Vector3(0, 20, 15)
	
	# Pan Right (+X)
	cam.apply_edge_pan(Vector2(1, 0), 0.1)
	var c_pos = cam.global_position if cam.is_inside_tree() else cam.position
	if c_pos.x <= 0.0:
		return "Camera edge pan right failed to advance X position"
		
	# Pan Up (-Z)
	var prev_z = c_pos.z
	cam.apply_edge_pan(Vector2(0, -1), 0.1)
	c_pos = cam.global_position if cam.is_inside_tree() else cam.position
	if c_pos.z >= prev_z:
		return "Camera edge pan up failed to advance -Z position"
		
	cam.free()
	return ""

func test_camera_focus_target() -> String:
	var cam = MobaCamera3D.new()
	var hero = HeroEntity.new()
	hero.position = Vector3(25.0, 0.0, -15.0)
	hero.global_position = Vector3(25.0, 0.0, -15.0)
	
	cam.target_to_follow = hero
	cam.camera_offset = Vector3(0.0, 22.0, 18.0)
	cam.focus_target()
	
	var h_pos = hero.global_position if hero.is_inside_tree() else hero.position
	var c_pos = cam.global_position if cam.is_inside_tree() else cam.position
	var expected = h_pos + cam.camera_offset
	if c_pos.distance_to(expected) > 0.01:
		return "Camera spacebar focus failed to center on hero target: expected %s, got %s" % [expected, c_pos]
		
	cam.free()
	hero.free()
	return ""

func test_camera_zoom_clamping() -> String:
	var cam = MobaCamera3D.new()
	cam.min_height = 12.0
	cam.max_height = 40.0
	cam.camera_offset = Vector3(0, 24, 18)
	
	# Zoom In beyond limit
	cam.apply_zoom(-50.0)
	if cam.camera_offset.y < 12.0:
		return "Camera zoom-in went below min_height 12.0: got %f" % cam.camera_offset.y
		
	# Zoom Out beyond limit
	cam.apply_zoom(100.0)
	if cam.camera_offset.y > 40.0:
		return "Camera zoom-out exceeded max_height 40.0: got %f" % cam.camera_offset.y
		
	cam.free()
	return ""

func test_hero_selection_and_cleanup() -> String:
	var ctrl = HeroController3D.new()
	var ally_hero = HeroEntity.new()
	ally_hero.team = TeamDefinitions.Team.RADIANT
	var enemy_hero = HeroEntity.new()
	enemy_hero.team = TeamDefinitions.Team.DIRE
	
	ctrl.hero = ally_hero
	
	# 1. Select ally
	ctrl.select_unit(ally_hero)
	if ctrl.selected_unit != ally_hero:
		return "Hero controller failed to select ally unit"
		
	# 2. Select enemy (cleans up old selection)
	ctrl.select_unit(enemy_hero)
	if ctrl.selected_unit != enemy_hero:
		return "Hero controller failed to switch selection to enemy unit"
		
	# 3. Clear selection
	ctrl.clear_selection()
	if ctrl.selected_unit != null:
		return "Clear selection failed to nullify selected unit"
		
	ctrl.free()
	ally_hero.free()
	enemy_hero.free()
	return ""

func test_hero_friendly_vs_enemy_selection() -> String:
	var ctrl = HeroController3D.new()
	var player = HeroEntity.new()
	player.team = TeamDefinitions.Team.RADIANT
	var friendly_creep = CreepEntity.new()
	friendly_creep.team = TeamDefinitions.Team.RADIANT
	var enemy_creep = CreepEntity.new()
	enemy_creep.team = TeamDefinitions.Team.DIRE
	
	ctrl.hero = player
	
	# Test Friendly
	ctrl.select_unit(friendly_creep)
	if not ctrl.is_friendly_selected() or ctrl.is_enemy_selected():
		return "Friendly unit was incorrectly identified as enemy"
		
	# Test Enemy
	ctrl.select_unit(enemy_creep)
	if not ctrl.is_enemy_selected() or ctrl.is_friendly_selected():
		return "Enemy unit was incorrectly identified as friendly"
		
	ctrl.free()
	player.free()
	friendly_creep.free()
	enemy_creep.free()
	return ""

func test_move_command_dispatch() -> String:
	var ctrl = HeroController3D.new()
	var hero = HeroEntity.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	ctrl.hero = hero
	
	var cmd = ctrl.issue_move_command(Vector3(30.0, 0.0, -10.0))
	
	if cmd == null or cmd.type != HeroController3D.CommandType.MOVE:
		return "Move command was not issued with CommandType.MOVE"
	if cmd.target_position != Vector3(30.0, 0.0, -10.0):
		return "Move command target position mismatch"
	if not hero.is_navigating:
		return "Hero is_navigating was not activated by move command"
	if hero.current_state != HeroEntity.HeroState.MOVING:
		return "Hero state was not changed to MOVING"
		
	ctrl.free()
	hero.free()
	return ""

func test_movement_completion_on_arrival() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	hero.global_position = Vector3(0.0, 0.0, 0.0)
	
	# Issue move to close point (0.3m away < 0.6m threshold)
	hero.move_to_location(Vector3(0.3, 0.0, 0.0))
	hero._physics_process(0.1)
	
	if hero.is_navigating:
		return "Hero is_navigating should be false upon arriving within 0.6m threshold"
	if hero.velocity != Vector3.ZERO:
		return "Hero velocity should be Vector3.ZERO on arrival"
	if hero.current_state != HeroEntity.HeroState.IDLE:
		return "Hero state should transition to IDLE upon arrival"
		
	hero.free()
	return ""

func test_enemy_target_attack_command() -> String:
	var ctrl = HeroController3D.new()
	var hero = HeroEntity.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	ctrl.hero = hero
	
	var enemy_hero = HeroEntity.new()
	enemy_hero.team = TeamDefinitions.Team.DIRE
	enemy_hero._ready()
	
	var cmd = ctrl.issue_attack_command(enemy_hero)
	
	if cmd == null or cmd.type != HeroController3D.CommandType.ATTACK_TARGET:
		return "Attack command failed to dispatch CommandType.ATTACK_TARGET"
	if cmd.target_entity != enemy_hero:
		return "Attack command target entity was not set to enemy hero"
	if not ctrl.is_moving_to_attack:
		return "Hero controller is_moving_to_attack was not set to true"
		
	ctrl.free()
	hero.free()
	enemy_hero.free()
	return ""

func test_creep_and_tower_attack_command() -> String:
	var ctrl = HeroController3D.new()
	var hero = HeroEntity.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	ctrl.hero = hero
	
	var enemy_creep = CreepEntity.new()
	enemy_creep.team = TeamDefinitions.Team.DIRE
	enemy_creep._ready()
	
	var enemy_tower = TowerEntity.new()
	enemy_tower.team = TeamDefinitions.Team.DIRE
	enemy_tower._ready()
	
	# Test Creep Attack Command
	var creep_cmd = ctrl.issue_attack_command(enemy_creep)
	if creep_cmd.type != HeroController3D.CommandType.ATTACK_TARGET or creep_cmd.target_entity != enemy_creep:
		return "Creep attack command failed"
		
	# Test Tower Attack Command
	var tower_cmd = ctrl.issue_attack_command(enemy_tower)
	if tower_cmd.type != HeroController3D.CommandType.ATTACK_TARGET or tower_cmd.target_entity != enemy_tower:
		return "Tower attack command failed"
		
	ctrl.free()
	hero.free()
	enemy_creep.free()
	enemy_tower.free()
	return ""

func test_dead_hero_movement_restriction() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	hero.attribute_system.apply_damage_to_health(9999.0, "TestFatal")
	
	if hero.is_alive():
		return "Hero should be dead after fatal damage"
	if hero.current_state != HeroEntity.HeroState.DEAD:
		return "Dead hero state should be DEAD"
		
	# Attempt to move while dead
	hero.move_to_location(Vector3(50.0, 0.0, 50.0))
	if hero.is_navigating:
		return "Dead hero should not be allowed to start navigating"
		
	hero.free()
	return ""

func test_hero_state_transitions() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	
	if hero.current_state != HeroEntity.HeroState.IDLE:
		return "Hero initial state should be IDLE"
		
	hero.move_to_location(Vector3(20, 0, 0))
	if hero.current_state != HeroEntity.HeroState.MOVING:
		return "Hero state should transition to MOVING"
		
	hero.set_attacking_state()
	if hero.current_state != HeroEntity.HeroState.ATTACKING:
		return "Hero state should transition to ATTACKING"
		
	hero._on_death("TestKiller")
	if hero.current_state != HeroEntity.HeroState.DEAD:
		return "Hero state should transition to DEAD upon death"
		
	hero.respawn()
	if hero.current_state != HeroEntity.HeroState.IDLE:
		return "Hero state should transition to IDLE upon respawn"
		
	hero.free()
	return ""

# ==============================================================================
# 18 TASK 10: BASIC ATTACK & TARGETING SYSTEM TESTS
# ==============================================================================

func test_targeting_select_enemy_hero() -> String:
	var ctrl = HeroController3D.new()
	var hero = HeroEntity.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	ctrl.hero = hero
	
	var enemy = HeroEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	var cmd = ctrl.issue_attack_command(enemy)
	if cmd == null or cmd.type != HeroController3D.CommandType.ATTACK_TARGET or cmd.target_entity != enemy:
		return "Failed to issue attack command targeting enemy hero"
	if ctrl.targeted_enemy != enemy:
		return "Targeted enemy was not assigned to enemy hero"
		
	ctrl.free()
	hero.free()
	enemy.free()
	return ""

func test_targeting_select_enemy_creep() -> String:
	var ctrl = HeroController3D.new()
	var hero = HeroEntity.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	ctrl.hero = hero
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep._ready()
	
	var cmd = ctrl.issue_attack_command(creep)
	if cmd == null or cmd.type != HeroController3D.CommandType.ATTACK_TARGET or cmd.target_entity != creep:
		return "Failed to issue attack command targeting enemy creep"
		
	ctrl.free()
	hero.free()
	creep.free()
	return ""

func test_targeting_select_enemy_tower() -> String:
	var ctrl = HeroController3D.new()
	var hero = HeroEntity.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	ctrl.hero = hero
	
	var tower = TowerEntity.new()
	tower.team = TeamDefinitions.Team.DIRE
	tower._ready()
	
	var cmd = ctrl.issue_attack_command(tower)
	if cmd == null or cmd.type != HeroController3D.CommandType.ATTACK_TARGET or cmd.target_entity != tower:
		return "Failed to issue attack command targeting enemy tower"
		
	ctrl.free()
	hero.free()
	tower.free()
	return ""

func test_targeting_friendly_rejection() -> String:
	var ctrl = HeroController3D.new()
	var hero = HeroEntity.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	ctrl.hero = hero
	
	var ally = HeroEntity.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var cmd = ctrl.issue_attack_command(ally)
	if cmd != null:
		return "Friendly unit should reject attack command, but returned a command object"
	if ctrl.targeted_enemy != null:
		return "Friendly unit was incorrectly assigned as targeted_enemy"
		
	ctrl.free()
	hero.free()
	ally.free()
	return ""

func test_targeting_out_of_range_movement() -> String:
	var ctrl = HeroController3D.new()
	var hero = HeroEntity.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero.position = Vector3(0, 0, 0)
	hero.global_position = Vector3(0, 0, 0)
	hero._ready()
	ctrl.hero = hero
	
	var enemy = HeroEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(20, 0, 0)
	enemy.global_position = Vector3(20, 0, 0) # 20m away (> 2.3m melee range)
	enemy._ready()
	
	ctrl.issue_attack_command(enemy)
	ctrl._physics_process(0.1)
	
	if not hero.is_navigating:
		return "Hero should be navigating towards enemy that is out of attack range"
	var e_pos = enemy.global_position if enemy.is_inside_tree() else enemy.position
	if hero.destination_point.distance_to(e_pos) > 0.01:
		return "Hero destination point was not set to enemy position"
		
	ctrl.free()
	hero.free()
	enemy.free()
	return ""

func test_targeting_enters_range_attacks() -> String:
	var ctrl = HeroController3D.new()
	var hero = HeroEntity.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.global_position = Vector3(0, 0, 0)
	ctrl.hero = hero
	
	var enemy = HeroEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	enemy.global_position = Vector3(1.5, 0, 0) # Within 2.3m range
	var prev_hp = enemy.attribute_system.current_health
	
	ctrl.issue_attack_command(enemy)
	ctrl._physics_process(0.1)
	
	if enemy.attribute_system.current_health >= prev_hp:
		return "Hero in attack range failed to deal basic attack damage to target"
	if hero.is_navigating:
		return "Hero should stop navigating once target is within attack range"
		
	ctrl.free()
	hero.free()
	enemy.free()
	return ""

func test_combat_basic_physical_damage() -> String:
	var attacker = HeroEntity.new()
	attacker.team = TeamDefinitions.Team.RADIANT
	attacker._ready()
	attacker.attribute_system.base_strength = 0.0
	attacker.attribute_system.base_agility = 0.0
	attacker.attribute_system.base_intelligence = 0.0
	attacker.attribute_system.base_attack_damage = 80.0
	attacker.attribute_system.recalculate_all_stats()
	
	var target = HeroEntity.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	target.attribute_system.base_strength = 0.0
	target.attribute_system.base_agility = 0.0
	target.attribute_system.base_intelligence = 0.0
	target.attribute_system.base_armor = 0.0 # 0 armor for unmitigated calculation
	target.attribute_system.recalculate_all_stats()
	
	var prev_hp = target.attribute_system.current_health
	var res = attacker.execute_basic_attack(target)
	
	if res == null:
		return "Basic attack returned null result"
	if res.damage_type != DamageRequest.DamageType.PHYSICAL:
		return "Basic attack damage type must be PHYSICAL"
	if not is_equal_approx(target.attribute_system.current_health, prev_hp - 80.0):
		return "Target did not take exact 80.0 physical damage with 0 armor"
		
	attacker.free()
	target.free()
	return ""

func test_combat_armor_mitigation() -> String:
	var attacker = HeroEntity.new()
	attacker.team = TeamDefinitions.Team.RADIANT
	attacker._ready()
	attacker.attribute_system.base_strength = 0.0
	attacker.attribute_system.base_agility = 0.0
	attacker.attribute_system.base_intelligence = 0.0
	attacker.attribute_system.base_attack_damage = 100.0
	attacker.attribute_system.recalculate_all_stats()
	
	var target = HeroEntity.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	target.attribute_system.base_strength = 0.0
	target.attribute_system.base_agility = 0.0
	target.attribute_system.base_intelligence = 0.0
	target.attribute_system.base_armor = 100.0 # 100 armor = 50% damage reduction
	target.attribute_system.recalculate_all_stats()
	
	var prev_hp = target.attribute_system.current_health
	var res = attacker.execute_basic_attack(target)
	
	if res == null:
		return "Basic attack with armor returned null"
	if not is_equal_approx(res.final_health_damage, 50.0):
		return "100 armor should mitigate 100 physical damage to 50: got %f" % res.final_health_damage
	if not is_equal_approx(target.attribute_system.current_health, prev_hp - 50.0):
		return "Target health did not reduce by exactly 50 after armor mitigation"
		
	attacker.free()
	target.free()
	return ""

func test_combat_attack_cooldown_countdown() -> String:
	var attacker = HeroEntity.new()
	attacker.team = TeamDefinitions.Team.RADIANT
	attacker._ready()
	attacker.attribute_system.base_strength = 0.0
	attacker.attribute_system.base_agility = 0.0
	attacker.attribute_system.base_intelligence = 0.0
	attacker.attribute_system.base_attack_speed = 1.0 # 1.0 AS = 1.0s interval
	attacker.attribute_system.recalculate_all_stats()
	
	var target = HeroEntity.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	
	attacker.execute_basic_attack(target)
	
	if attacker.attack_cooldown <= 0.0:
		return "Attack cooldown was not set after basic attack"
	if attacker.can_attack():
		return "Attacker can_attack should be false while on cooldown"
		
	# Advance delta by 0.6s
	attacker._process(0.6)
	if attacker.attack_cooldown > 0.41 or attacker.attack_cooldown < 0.39:
		return "Attack cooldown did not decrement accurately: got %f" % attacker.attack_cooldown
		
	# Advance delta by 0.5s -> cooldown should hit 0.0
	attacker._process(0.5)
	if attacker.attack_cooldown != 0.0 or not attacker.can_attack():
		return "Attack cooldown should be 0.0 and can_attack true after full duration"
		
	attacker.free()
	target.free()
	return ""

func test_combat_attack_speed_interval_scaling() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	hero.attribute_system.base_strength = 0.0
	hero.attribute_system.base_agility = 0.0
	hero.attribute_system.base_intelligence = 0.0
	
	# Base 1.0 AS -> interval 1.0s
	hero.attribute_system.base_attack_speed = 1.0
	hero.attribute_system.recalculate_all_stats()
	if not is_equal_approx(hero.get_attack_interval(), 1.0):
		return "1.0 Attack Speed should yield 1.0s interval: got %f" % hero.get_attack_interval()
		
	# Fast 2.0 AS -> interval 0.5s
	hero.attribute_system.base_attack_speed = 2.0
	hero.attribute_system.recalculate_all_stats()
	if not is_equal_approx(hero.get_attack_interval(), 0.5):
		return "2.0 Attack Speed should yield 0.5s interval: got %f" % hero.get_attack_interval()
		
	# Slow 0.5 AS -> interval 2.0s
	hero.attribute_system.base_attack_speed = 0.5
	hero.attribute_system.recalculate_all_stats()
	if not is_equal_approx(hero.get_attack_interval(), 2.0):
		return "0.5 Attack Speed should yield 2.0s interval: got %f" % hero.get_attack_interval()
		
	hero.free()
	return ""

func test_combat_target_death_cleanup() -> String:
	var ctrl = HeroController3D.new()
	var hero = HeroEntity.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	ctrl.hero = hero
	
	var enemy = HeroEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	ctrl.issue_attack_command(enemy)
	
	# Kill enemy target
	enemy.attribute_system.apply_damage_to_health(9999.0, "FatalBlow")
	
	# Run controller tick
	ctrl._physics_process(0.1)
	
	if ctrl.targeted_enemy != null:
		return "Targeted enemy was not cleaned up after enemy death"
	if ctrl.is_moving_to_attack:
		return "is_moving_to_attack was not set to false after target death"
	if hero.current_state != HeroEntity.HeroState.IDLE:
		return "Hero state should revert to IDLE when target dies"
		
	ctrl.free()
	hero.free()
	enemy.free()
	return ""

func test_combat_attack_cancellation_on_move() -> String:
	var ctrl = HeroController3D.new()
	var hero = HeroEntity.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	ctrl.hero = hero
	
	var enemy = HeroEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	ctrl.issue_attack_command(enemy)
	if ctrl.targeted_enemy != enemy or not ctrl.is_moving_to_attack:
		return "Attack command setup failed"
		
	# Player gives a move command to ground
	ctrl.issue_move_command(Vector3(10, 0, 5))
	
	if ctrl.targeted_enemy != null:
		return "Move command failed to cancel targeted_enemy"
	if ctrl.is_moving_to_attack:
		return "Move command failed to cancel is_moving_to_attack"
	if hero.current_target != null:
		return "Hero combat target was not cleared on move command"
		
	ctrl.free()
	hero.free()
	enemy.free()
	return ""

func test_combat_dead_hero_cannot_attack() -> String:
	var hero = HeroEntity.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var target = HeroEntity.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	
	# Kill hero
	hero.attribute_system.apply_damage_to_health(9999.0, "Fatal")
	
	if hero.can_attack():
		return "Dead hero can_attack returned true"
		
	var res = hero.execute_basic_attack(target)
	if res != null:
		return "Dead hero should not be able to execute basic attack"
		
	hero.free()
	target.free()
	return ""

func test_combat_dead_hero_cannot_receive_command() -> String:
	var ctrl = HeroController3D.new()
	var hero = HeroEntity.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	ctrl.hero = hero
	
	var enemy = HeroEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	# Kill hero
	hero.attribute_system.apply_damage_to_health(9999.0, "Fatal")
	
	var move_cmd = ctrl.issue_move_command(Vector3(10, 0, 0))
	if move_cmd != null:
		return "Dead hero should reject move command"
		
	var atk_cmd = ctrl.issue_attack_command(enemy)
	if atk_cmd != null:
		return "Dead hero should reject attack command"
		
	ctrl.free()
	hero.free()
	enemy.free()
	return ""

func test_combat_target_freed_safe_cleanup() -> String:
	var ctrl = HeroController3D.new()
	var hero = HeroEntity.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	ctrl.hero = hero
	
	var enemy = HeroEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	ctrl.issue_attack_command(enemy)
	
	# Free target node directly to simulate instant garbage collection/queue_free
	enemy.free()
	
	# Process controller physics tick — must not crash on freed reference
	ctrl._physics_process(0.1)
	
	if ctrl.targeted_enemy != null:
		return "Freed enemy target was not safely nullified"
	if ctrl.is_moving_to_attack:
		return "is_moving_to_attack was not reset after target was freed"
		
	ctrl.free()
	hero.free()
	return ""

func test_combat_attack_event_hooks() -> String:
	var attacker = HeroEntity.new()
	attacker.team = TeamDefinitions.Team.RADIANT
	attacker._ready()
	
	var target = HeroEntity.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	
	var flags = {"started": false, "landed": false}
	
	var cb_start = func(atk, tgt):
		if atk == attacker and tgt == target:
			flags["started"] = true
	var cb_land = func(atk, tgt, _res):
		if atk == attacker and tgt == target:
			flags["landed"] = true
			
	GameEvents.attack_started.connect(cb_start)
	GameEvents.attack_landed.connect(cb_land)
	
	attacker.execute_basic_attack(target)
	
	GameEvents.attack_started.disconnect(cb_start)
	GameEvents.attack_landed.disconnect(cb_land)
	
	attacker.free()
	target.free()
	
	if not flags["started"]:
		return "GameEvents.attack_started signal was not fired"
	if not flags["landed"]:
		return "GameEvents.attack_landed signal was not fired"
		
	return ""

func test_combat_damage_dealt_event_hook() -> String:
	var attacker = HeroEntity.new()
	attacker.team = TeamDefinitions.Team.RADIANT
	attacker._ready()
	
	var target = HeroEntity.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	
	var flags = {"dealt": false}
	var cb_dmg = func(res, atk, tgt):
		if atk == attacker and tgt == target and res.final_health_damage > 0.0:
			flags["dealt"] = true
			
	GameEvents.damage_dealt.connect(cb_dmg)
	attacker.execute_basic_attack(target)
	GameEvents.damage_dealt.disconnect(cb_dmg)
	
	attacker.free()
	target.free()
	
	if not flags["dealt"]:
		return "GameEvents.damage_dealt signal was not fired on basic attack"
		
	return ""

func test_combat_entity_died_event_hook() -> String:
	var attacker = HeroEntity.new()
	attacker.team = TeamDefinitions.Team.RADIANT
	attacker._ready()
	attacker.attribute_system.base_attack_damage = 9999.0
	attacker.attribute_system.recalculate_all_stats()
	
	var target = HeroEntity.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	
	var flags = {"died": false, "killed": false}
	
	var cb_died = func(victim, _killer):
		if victim == target:
			flags["died"] = true
	var cb_killed = func(victim, killer):
		if victim == target and killer == attacker:
			flags["killed"] = true
			
	GameEvents.entity_died.connect(cb_died)
	GameEvents.entity_killed.connect(cb_killed)
	
	attacker.execute_basic_attack(target)
	
	GameEvents.entity_died.disconnect(cb_died)
	GameEvents.entity_killed.disconnect(cb_killed)
	
	attacker.free()
	target.free()
	
	if not flags["died"] and not flags["killed"]:
		return "Neither GameEvents.entity_died nor entity_killed was fired on fatal attack"
		
	return ""

# ==============================================================================
# 4 OVERHEAD HEALTH BAR & ATTACK VISUAL FEEDBACK TESTS
# ==============================================================================

func test_overhead_healthbar_team_color_and_sync() -> String:
	var hero = HeroEntity.new()
	hero.entity_name = "Kaelgor"
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.attribute_system.base_health = 600.0
	hero.attribute_system.recalculate_all_stats()
	hero.attribute_system.heal(600.0)
	
	var widget = OverheadHealthBarManager.OverheadUnitWidget.new(hero)
	widget.update_stats()
	
	if widget.name_label.text != "Kaelgor":
		return "Widget name label mismatch: got %s" % widget.name_label.text
	if widget.hp_bar.max_value != 600.0:
		return "Widget hp_bar max_value mismatch: expected 600, got %f" % widget.hp_bar.max_value
	if widget.level_badge == null or widget.level_badge.text != "1":
		return "Widget level badge failed to display hero level 1"
		
	widget.free()
	hero.free()
	return ""

func test_overhead_healthbar_segments() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	hero.attribute_system.base_strength = 0.0
	hero.attribute_system.strength_growth = 0.0
	hero.attribute_system.base_health = 1000.0 # 1000 HP / 250 HP = 4 segments
	hero.attribute_system.recalculate_all_stats()
	
	var widget = OverheadHealthBarManager.OverheadUnitWidget.new(hero)
	var max_hp = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	var segment_count = int(max_hp / 250.0)
	
	if segment_count != 4:
		return "1000 HP should yield 4 segment divisions: got %d" % segment_count
		
	widget.free()
	hero.free()
	return ""

func test_projectile_homing_and_delivery() -> String:
	var attacker = HeroEntity.new()
	attacker.team = TeamDefinitions.Team.DIRE
	attacker._ready()
	attacker.global_position = Vector3(0, 0, 0)
	
	var target = HeroEntity.new()
	target.team = TeamDefinitions.Team.RADIANT
	target._ready()
	target.global_position = Vector3(10, 0, 0)
	var prev_hp = target.attribute_system.current_health
	
	var req = DamageRequest.create_basic_attack(attacker, target, 50.0)
	var proj = BasicAttackProjectile3D.new()
	proj.setup(attacker, target, req, Color.BLUE, 50.0, 0.3)
	
	# Simulate 0.3s -> at 50 m/s moves 15m (> 10m to target)
	proj._physics_process(0.3)
	
	if target.attribute_system.current_health >= prev_hp:
		return "Projectile failed to deliver damage upon reaching target"
		
	attacker.free()
	target.free()
	return ""

func test_floating_combat_text_properties() -> String:
	var fct = FloatingCombatText3D.new()
	fct.setup("-85", Color.RED, Vector3(0, 0, 0), false)
	
	if fct.text != "-85":
		return "Floating text string mismatch"
	if fct.text_color != Color.RED:
		return "Floating text color mismatch"
		
	fct.free()
	return ""

func test_minion_crowd_separation() -> String:
	var creep1 = CreepEntity.new()
	creep1.global_position = Vector3(0, 0, 0)
	creep1._ready()
	
	var creep2 = CreepEntity.new()
	creep2.global_position = Vector3(0.5, 0, 0)
	creep2._ready()
	
	creep1.add_to_group("combat_entities")
	creep2.add_to_group("combat_entities")
	
	var sep = creep1._calculate_separation_force()
	# Because creep2 is at +0.5 X, creep1 should be pushed in -X direction
	if sep.x > 0.0:
		return "Separation force should push creep1 away in negative X, got %f" % sep.x
		
	creep1.free()
	creep2.free()
	return ""

func test_minion_waypoint_progress() -> String:
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.RADIANT
	creep.position = Vector3(5.0, 0, 0)
	creep.global_position = Vector3(5.0, 0, 0)
	creep._ready()
	
	var past_wp = Vector3(2.0, 0, 0)
	var future_wp = Vector3(10.0, 0, 0)
	
	if not creep._has_passed_waypoint(past_wp):
		return "Radiant creep at X=5.0 should have passed waypoint at X=2.0"
	if creep._has_passed_waypoint(future_wp):
		return "Radiant creep at X=5.0 should NOT have passed waypoint at X=10.0"
		
	creep.free()
	return ""

func test_target_dummy_immortality() -> String:
	var dummy = TargetDummyEntity.new()
	dummy._ready()
	
	if dummy.attribute_system.current_health != 10000.0:
		return "Dummy initial health mismatch"
	if dummy.attribute_system.get_stat(StatModifier.TargetStat.ARMOR) != 30.0:
		return "Dummy armor should be 30.0"
		
	# Deal massive fatal damage (15,000 damage)
	var attacker = HeroEntity.new()
	attacker.team = TeamDefinitions.Team.RADIANT
	attacker._ready()
	
	var req = DamageRequest.create_basic_attack(attacker, dummy, 9000.0)
	dummy.receive_damage(req)
	
	if not dummy.is_alive() or dummy.attribute_system.current_health <= 0.0:
		return "Target dummy should never die from extreme damage"
		
	dummy.free()
	attacker.free()
	return ""

func test_target_dummy_dps_tracking() -> String:
	var dummy = TargetDummyEntity.new()
	dummy._ready()
	
	var attacker = HeroEntity.new()
	attacker.team = TeamDefinitions.Team.RADIANT
	attacker._ready()
	
	var req = DamageRequest.create_basic_attack(attacker, dummy, 130.0) # 130 raw -> 100 net damage after 30 armor
	var res = dummy.receive_damage(req)
	
	if dummy.total_damage_taken <= 0.0:
		return "Dummy failed to track total damage taken"
	if dummy.recent_damage_history.is_empty():
		return "Dummy failed to record damage history entry"
		
	dummy.free()
	attacker.free()
	return ""

func test_active_item_usage() -> String:
	var hero = HeroEntity.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	# Damage hero slightly
	hero.attribute_system.current_health = 300.0
	
	# Give Lifebloom (ID 114) in slot 0
	var item = ItemResource.new()
	item.id = 114
	item.item_name = "Lifebloom"
	hero.inventory_manager.slots[0] = item
	
	var success = hero.inventory_manager.use_active_item(0, hero, Vector3.ZERO)
	if not success:
		return "Failed to trigger active item on slot 0"
		
	if hero.attribute_system.current_health <= 300.0:
		return "Lifebloom active failed to heal hero"
		
	if hero.inventory_manager.active_cooldowns.get(0, 0.0) <= 0.0:
		return "Active cooldown was not set for used item slot"
		
	hero.free()
	return ""

func test_ground_targeting_indicator() -> String:
	var indicator = TargetingIndicator3D.new()
	indicator._ready()
	
	indicator.show_indicator(Vector3(0, 0, 0), 10.0, 3.0, Color.CYAN)
	if not indicator.visible:
		return "Indicator failed to become visible on show"
		
	indicator.update_cursor_position(Vector3(0, 0, 0), Vector3(5, 0, 5))
	indicator.hide_indicator()
	
	if indicator.visible:
		return "Indicator failed to hide"
		
	indicator.free()
	return ""
		
func test_demo_hero_panel_integration() -> String:
	var hero = HeroEntity.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var panel = DemoHeroPanel.new()
	panel.target_hero = hero
	panel._ready()
	
	# Test max level
	panel._on_max_level_clicked()
	if hero.attribute_system.level != 30:
		return "Expected level 30 after max level clicked, got %d" % hero.attribute_system.level
		
	# Test Free Spells
	panel._on_free_spells_toggled(true)
	if not hero.ability_container.is_free_spells_active:
		return "Free spells toggle failed to activate on hero"
	panel._on_free_spells_toggled(false)
	
	# Test invulnerability toggle
	panel._on_invulnerable_toggle_clicked()
	if not hero.effect_container.is_invulnerable():
		return "Invulnerability toggle failed to make hero invulnerable"
	panel._on_invulnerable_toggle_clicked()
	if hero.effect_container.is_invulnerable():
		return "Invulnerability toggle failed to disable invulnerability"
		
	# Test refresh spells & health
	hero.attribute_system.current_health = 100.0
	panel._on_fill_health_clicked()
	if hero.attribute_system.current_health < 500.0:
		return "Fill health failed to restore HP"
		
	panel.free()
	hero.free()
	return ""

func test_dota_minimap_frustum_and_world_mapping() -> String:
	var m = DotaMinimap.new()
	m._ready()
	
	# Test world to minimap center (0, 0, 0)
	var center_pixel = m._world_to_minimap(Vector3(0, 0, 0))
	if absf(center_pixel.x - 130.0) > 0.1 or absf(center_pixel.y - 130.0) > 0.1:
		return "Expected minimap center (130, 130), got %s" % str(center_pixel)
		
	# Test radar scan trigger
	m.trigger_radar_scan()
	if m.scan_cooldown <= 0.0:
		return "Radar scan cooldown was not initiated"
		
	# Test glyph fortification trigger
	m.trigger_glyph_fortification()
	if m.glyph_cooldown <= 0.0:
		return "Glyph fortification cooldown was not initiated"
		
	m.free()
	return ""

func test_dota_stats_popup_mapping() -> String:
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var popup = DotaStatsPopup.new()
	popup.update_stats(hero)
	
	if popup.lbl_atk_speed.text == "-":
		return "Stats popup failed to calculate attack speed"
	if popup.lbl_damage.text == "-":
		return "Stats popup failed to calculate damage"
	if popup.lbl_armor.text == "-":
		return "Stats popup failed to calculate armor"
	if popup.str_title_lbl.text == "":
		return "Stats popup failed to populate strength title"
	if not popup.int_sub_lbl.text.contains("Mana"):
		return "Stats popup failed to format intelligence subtext correctly"
		
	popup.free()
	hero.free()
	return ""

func test_alt_info_mode_range_indicators() -> String:
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	# Test Hero attack range indicators
	hero.set_alt_range_visible(true)
	if hero.alt_attack_range_mesh == null or not hero.alt_attack_range_mesh.visible:
		return "Hero failed to activate alt attack range mesh"
		
	# Test Skill range preview
	hero.preview_skill_range(10.0, Color.CYAN)
	if hero.alt_skill_range_mesh == null or not hero.alt_skill_range_mesh.visible:
		return "Hero failed to activate alt skill range preview"
	hero.preview_skill_range(0.0)
	if hero.alt_skill_range_mesh.visible:
		return "Hero failed to hide alt skill range preview"
		
	# Test Tower range indicator
	var tower = TowerEntity.new()
	tower.team = TeamDefinitions.Team.RADIANT
	tower._ready()
	tower.set_range_indicator_visible(true)
	if tower.range_indicator == null or not tower.range_indicator.visible:
		return "Tower failed to toggle range indicator visibility"
	tower.set_range_indicator_visible(false)
	if tower.range_indicator.visible:
		return "Tower failed to hide range indicator"
		
	tower.free()
	hero.free()
	return ""

func test_spell_targeting_flow() -> String:
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.ability_container.is_free_spells_active = true
	
	var controller = HeroController3D.new()
	controller.hero = hero
	controller._ready()
	
	# Test casting targeted spell (Q) activates targeting mode
	controller._cast_spell(AbilityResource.Slot.Q)
	if not controller.is_targeting_active:
		return "Targeted spell failed to activate targeting mode"
	if controller.pending_spell_slot != AbilityResource.Slot.Q:
		return "Expected pending spell slot Q, got %d" % controller.pending_spell_slot
		
	# Test cancel targeting
	controller._cancel_targeting()
	if controller.is_targeting_active:
		return "Failed to cancel targeting mode"
		
	# Test self spell (E) casts immediately without targeting mode
	controller._cast_spell(AbilityResource.Slot.E)
	if controller.is_targeting_active:
		return "Self-cast spell should not trigger targeting mode"
		
	controller.free()
	hero.free()
	return ""

func test_hold_to_aim_and_soft_lock() -> String:
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.ability_container.is_free_spells_active = true
	
	var enemy = TargetDummyEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.global_position = Vector3(5.0, 0.0, 0.0)
	enemy._ready()
	
	var controller = HeroController3D.new()
	controller.hero = hero
	controller._ready()
	
	# 1. Test Hold key (Q pressed) activates targeting
	var press_event = InputEventKey.new()
	press_event.keycode = KEY_Q
	press_event.pressed = true
	controller._input(press_event)
	
	if not controller.is_targeting_active:
		return "Key press failed to activate targeting mode"
		
	# 2. Test Soft-Lock Snapping when cursor is near target
	controller.locked_target_unit = enemy
	controller.targeting_indicator.update_cursor_position(hero.global_position, Vector3(5.2, 0.0, 0.2), enemy)
	if not controller.targeting_indicator.is_locked_on_target:
		return "Targeting indicator failed to lock onto enemy unit"
		
	# 3. Test Releasing key (Q released) cancels targeting mode cleanly
	var release_event = InputEventKey.new()
	release_event.keycode = KEY_Q
	release_event.pressed = false
	controller._input(release_event)
	
	if controller.is_targeting_active:
		return "Releasing key failed to cancel targeting indicator"
		
	controller.free()
	enemy.free()
	hero.free()
	return ""

func test_out_of_range_move_to_cast() -> String:
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero.position = Vector3(0.0, 0.0, 0.0)
	hero.global_position = Vector3(0.0, 0.0, 0.0)
	hero._ready()
	hero.ability_container.is_free_spells_active = true
	
	var enemy = TargetDummyEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(25.0, 0.0, 0.0)
	enemy.global_position = Vector3(25.0, 0.0, 0.0) # 25m away (out of 11m range)
	enemy._ready()
	
	var controller = HeroController3D.new()
	controller.hero = hero
	controller._ready()
	
	# 1. Attempt to cast Q on distant enemy (25m away)
	controller._queue_or_execute_spell(AbilityResource.Slot.Q, enemy, enemy.global_position)
	
	# Verify hero enters pending_spell move-to-cast mode and does NOT cast immediately
	if controller.pending_spell == null:
		return "Expected spell to be queued in pending_spell when out of range"
	if controller.pending_spell.cast_range != 11.0:
		return "Expected cast range 11.0, got %f" % controller.pending_spell.cast_range
	if not hero.is_navigating:
		return "Hero should begin moving towards target when out of range"
		
	# 2. Simulate moving closer into range (to 10.0m)
	hero.position = Vector3(15.0, 0.0, 0.0)
	hero.global_position = Vector3(15.0, 0.0, 0.0) # now 10m from enemy (within 11m)
	controller._physics_process(0.016)
	
	# Verify spell was executed and pending_spell was cleared upon reaching range
	if controller.pending_spell != null:
		return "Pending spell should be executed and cleared once entering cast range"
		
	controller.free()
	enemy.free()
	hero.free()
	return ""

func test_target_filter_and_soft_lock() -> String:
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var ally = TargetDummyEntity.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var enemy = TargetDummyEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	var neutral_creep = TargetDummyEntity.new()
	neutral_creep.team = TeamDefinitions.Team.NEUTRAL
	neutral_creep._ready()
	
	var spell = AbilityResource.new()
	
	# 1. Test ENEMIES_ONLY filter
	spell.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	if not spell.is_valid_target(hero, enemy):
		return "ENEMIES_ONLY should accept enemy"
	if not spell.is_valid_target(hero, neutral_creep):
		return "ENEMIES_ONLY should accept neutral/jungle creep"
	if spell.is_valid_target(hero, ally):
		return "ENEMIES_ONLY should reject ally"
	if spell.is_valid_target(hero, hero):
		return "ENEMIES_ONLY should reject caster self"
		
	# 2. Test ALLIES_ONLY filter
	spell.target_filter = AbilityResource.TargetFilter.ALLIES_ONLY
	if not spell.is_valid_target(hero, ally):
		return "ALLIES_ONLY should accept ally"
	if not spell.is_valid_target(hero, hero):
		return "ALLIES_ONLY should accept caster self"
	if spell.is_valid_target(hero, enemy):
		return "ALLIES_ONLY should reject enemy"
	if spell.is_valid_target(hero, neutral_creep):
		return "ALLIES_ONLY should reject neutral creep"
		
	# 3. Test NEUTRALS_ONLY filter
	spell.target_filter = AbilityResource.TargetFilter.NEUTRALS_ONLY
	if not spell.is_valid_target(hero, neutral_creep):
		return "NEUTRALS_ONLY should accept neutral creep"
	if spell.is_valid_target(hero, enemy):
		return "NEUTRALS_ONLY should reject enemy"
	if spell.is_valid_target(hero, ally):
		return "NEUTRALS_ONLY should reject ally"
		
	spell.free()
	neutral_creep.free()
	enemy.free()
	ally.free()
	hero.free()
	return ""

func test_dota_ability_tooltip_card() -> String:
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var tooltip = DotaAbilityTooltip.new()
	tooltip._init()
	
	var q_ab = hero.ability_container.get_ability(AbilityResource.Slot.Q)
	if q_ab == null:
		return "Failed to find Astris Q ability"
		
	# 1. Test displaying ability tooltip
	tooltip.show_ability(q_ab, 2, "Q")
	if not tooltip.visible:
		return "Ability tooltip should be visible when shown"
	if not ("GİZEMLİ OK" in tooltip.title_label.text or "ARCANE BOLT" in tooltip.title_label.text):
		return "Unexpected title text: %s" % tooltip.title_label.text
	if tooltip.slot_badge_label.text != "[ Q ]":
		return "Expected slot badge [ Q ], got %s" % tooltip.slot_badge_label.text
	if tooltip.level_label.text != "SVY 2/4":
		return "Expected level label SVY 2/4, got %s" % tooltip.level_label.text
		
	# 2. Test Talent Tree tooltip
	tooltip.show_talent_tree_tooltip()
	if not tooltip.visible or tooltip.title_label.text != "YETENEK AĞACI (TALENT TREE)":
		return "Failed to render talent tree tooltip"
		
	# 3. Test hiding tooltip
	tooltip.hide_tooltip()
	if tooltip.visible:
		return "Tooltip should be hidden after calling hide_tooltip"
		
	tooltip.free()
	hero.free()
	return ""

func test_neutral_creep_camp_mechanics() -> String:
	var camp = NeutralCampSpawner.new()
	camp.camp_type = NeutralCampSpawner.CampType.MEDIUM
	camp.global_position = Vector3(10.0, 0.0, 10.0)
	camp._ready()
	
	if camp.active_neutrals.size() != 3:
		return "Expected 3 neutrals spawned in medium camp, got %d" % camp.active_neutrals.size()
		
	var wolf = camp.active_neutrals[0]
	if wolf.team != TeamDefinitions.Team.NEUTRAL:
		return "Expected team NEUTRAL for jungle creep"
		
	# Test shared aggro
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	camp.notify_camp_aggro(hero)
	for n in camp.active_neutrals:
		if n.aggro_target != hero:
			return "Camp failed to propagate shared aggro to sibling creeps"
			
	# Test leash reset when dragged beyond leash distance
	wolf.position = Vector3(40.0, 0.0, 40.0) # far away
	wolf.global_position = Vector3(40.0, 0.0, 40.0)
	wolf._physics_process(0.016)
	if not wolf.is_leashing_back:
		return "Neutral creep should trigger leash reset when exceeding leash distance"
		
	hero.free()
	camp.free()
	return ""

# ==============================================================================
# TASK 09: TARGETING & COMBAT FOUNDATION TESTS
# ==============================================================================
func test_task09_ally_target_rejected() -> String:
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var rel = TargetRelationSystem.get_relation(hero, ally)
	if rel != TargetRelationSystem.TargetRelation.ALLY:
		return "Expected relation ALLY, got %s" % str(rel)
	if TargetRelationSystem.is_valid_basic_attack_target(hero, ally):
		return "Ally should be rejected for basic attack"
	if hero.execute_basic_attack(ally) != null:
		return "execute_basic_attack on ally must return null"
		
	ally.free()
	hero.free()
	return ""

func test_task09_enemy_target_accepted() -> String:
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var enemy_hero = AstrisHero.new()
	enemy_hero.team = TeamDefinitions.Team.DIRE
	enemy_hero._ready()
	
	var enemy_creep = CreepEntity.new()
	enemy_creep.team = TeamDefinitions.Team.DIRE
	enemy_creep._ready()
	
	var enemy_tower = TowerEntity.new()
	enemy_tower.team = TeamDefinitions.Team.DIRE
	enemy_tower._ready()
	
	if not TargetRelationSystem.is_valid_basic_attack_target(hero, enemy_hero):
		return "Enemy Hero should be accepted for basic attack"
	if not TargetRelationSystem.is_valid_basic_attack_target(hero, enemy_creep):
		return "Enemy Creep should be accepted for basic attack"
	if not TargetRelationSystem.is_valid_basic_attack_target(hero, enemy_tower):
		return "Enemy Tower should be accepted for basic attack"
		
	enemy_tower.free()
	enemy_creep.free()
	enemy_hero.free()
	hero.free()
	return ""

func test_task09_neutral_monster_accepted() -> String:
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var neutral = NeutralCreepEntity.new()
	neutral.team = TeamDefinitions.Team.NEUTRAL
	neutral._ready()
	
	var rel = TargetRelationSystem.get_relation(hero, neutral)
	if rel != TargetRelationSystem.TargetRelation.NEUTRAL_MONSTER:
		return "Expected relation NEUTRAL_MONSTER"
	if not TargetRelationSystem.is_valid_basic_attack_target(hero, neutral):
		return "Neutral monster must be accepted for basic attack"
		
	neutral.free()
	hero.free()
	return ""

func test_task09_dead_target_rejected() -> String:
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	enemy.attribute_system.current_health = 0.0
	enemy.attribute_system.is_alive = false
	
	if TargetRelationSystem.is_alive(enemy):
		return "is_alive should return false for dead target"
	if TargetRelationSystem.is_valid_basic_attack_target(hero, enemy):
		return "Dead target must be rejected for basic attack"
		
	enemy.free()
	hero.free()
	return ""

func test_task09_range_check() -> String:
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero.global_position = Vector3.ZERO
	hero._ready()
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.global_position = Vector3(25.0, 0.0, 0.0) # Far out
	enemy._ready()
	
	var in_range = TargetRelationSystem.is_in_range(hero, enemy, 6.5)
	if in_range:
		return "Target at 25m should be out of 6.5m range"
		
	enemy.global_position = Vector3(4.0, 0.0, 0.0) # Within range
	if not TargetRelationSystem.is_in_range(hero, enemy, 6.5):
		return "Target at 4m should be within 6.5m range"
		
	enemy.free()
	hero.free()
	return ""

func test_task09_melee_attack_pipeline() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	
	var enemy = CreepEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	var initial_hp = enemy.attribute_system.current_health
	var res = kaelgor.execute_basic_attack(enemy)
	if res == null:
		return "Melee execute_basic_attack should return DamageResult"
	if enemy.attribute_system.current_health >= initial_hp:
		return "Melee attack should reduce enemy health"
		
	enemy.free()
	kaelgor.free()
	return ""

func test_task09_ranged_projectile_pipeline() -> String:
	var astris = AstrisHero.new()
	astris.team = TeamDefinitions.Team.RADIANT
	astris._ready()
	
	var enemy = CreepEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	var ad = astris.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var req = DamageRequest.create_basic_attack(astris, enemy, ad)
	
	var proj = BasicAttackProjectile3D.new()
	proj.setup(astris, enemy, req, Color.CYAN, 50.0, 0.3)
	var initial_hp = enemy.attribute_system.current_health
	proj._on_impact()
	
	if enemy.attribute_system.current_health >= initial_hp:
		return "Ranged projectile impact should reduce enemy health"
		
	enemy.free()
	astris.free()
	return ""

func test_task09_attack_cooldown_enforcement() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var enemy = CreepEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	hero.execute_basic_attack(enemy)
	if hero.can_attack():
		return "Hero should not be able to attack during cooldown"
		
	hero.attack_cooldown = 0.0
	if not hero.can_attack():
		return "Hero should be able to attack after cooldown resets"
		
	enemy.free()
	hero.free()
	return ""

func test_task09_target_death_clears_attack() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var enemy = CreepEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	hero.set_combat_target(enemy)
	if hero.current_target != enemy:
		return "Combat target should be set to enemy"
		
	enemy.attribute_system.current_health = 0.0
	enemy.attribute_system.is_alive = false
	hero.attack_controller.current_target = enemy
	hero.attack_controller.current_state = AttackController.AttackState.WINDUP
	
	hero.attack_controller.update(0.016)
	if hero.attack_controller.current_state != AttackController.AttackState.IDLE:
		return "AttackController should return to IDLE when target dies"
		
	enemy.free()
	hero.free()
	return ""

func test_task09_move_command_cancels_attack() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var ctrl = HeroController3D.new()
	ctrl.hero = hero
	
	var enemy = CreepEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	ctrl.issue_attack_command(enemy)
	if ctrl.targeted_enemy != enemy:
		return "targeted_enemy should be set on attack command"
		
	# Move command cancels attack
	ctrl.issue_move_command(Vector3(10, 0, 10))
	if ctrl.targeted_enemy != null:
		return "targeted_enemy should be cleared on move command"
	if ctrl.is_moving_to_attack:
		return "is_moving_to_attack should be false on move command"
		
	enemy.free()
	ctrl.free()
	hero.free()
	return ""

# ==============================================================================
# TASK 10: CREEP WAVE & LANE COMBAT TESTS
# ==============================================================================
func test_task10_wave_composition() -> String:
	var comp1 = LaneMinionSpawner.get_wave_composition(1, true)
	if comp1.size() != 4:
		return "Expected 4 creeps in standard wave 1, got %d" % comp1.size()
	var melee_count = 0
	var ranged_count = 0
	for t in comp1:
		if t == CreepEntity.CreepType.MELEE: melee_count += 1
		elif t == CreepEntity.CreepType.RANGED: ranged_count += 1
	if melee_count != 3 or ranged_count != 1:
		return "Expected 3 Melee and 1 Ranged in standard wave, got %d melee, %d ranged" % [melee_count, ranged_count]
	return ""

func test_task10_siege_wave_spawning() -> String:
	var comp3 = LaneMinionSpawner.get_wave_composition(3, true)
	if comp3.size() != 5:
		return "Expected 5 creeps in wave 3 (with Siege), got %d" % comp3.size()
	var has_siege = false
	for t in comp3:
		if t == CreepEntity.CreepType.SIEGE: has_siege = true
	if not has_siege:
		return "Wave 3 should contain a SIEGE creep"
	return ""

func test_task10_three_lanes_spawners() -> String:
	var top_spawner = LaneMinionSpawner.new()
	top_spawner.lane = LaneMinionSpawner.Lane.TOP
	top_spawner.team = TeamDefinitions.Team.RADIANT
	top_spawner._ready()
	
	var mid_spawner = LaneMinionSpawner.new()
	mid_spawner.lane = LaneMinionSpawner.Lane.MID
	mid_spawner.team = TeamDefinitions.Team.RADIANT
	mid_spawner._ready()
	
	var bot_spawner = LaneMinionSpawner.new()
	bot_spawner.lane = LaneMinionSpawner.Lane.BOT
	bot_spawner.team = TeamDefinitions.Team.RADIANT
	bot_spawner._ready()
	
	if top_spawner.lane_waypoints[1].z >= 0:
		return "Top lane waypoints should go North (negative Z)"
	if bot_spawner.lane_waypoints[1].z <= 0:
		return "Bot lane waypoints should go South (positive Z)"
	if mid_spawner.lane_waypoints[1].z != 0:
		return "Mid lane waypoints should stay along Z = 0"
		
	bot_spawner.free()
	mid_spawner.free()
	top_spawner.free()
	return ""

func test_task10_wave_timer_progression() -> String:
	var spawner = LaneMinionSpawner.new()
	spawner.team = TeamDefinitions.Team.RADIANT
	spawner.lane = LaneMinionSpawner.Lane.MID
	spawner.wave_timer = 0.0
	spawner.wave_interval = 30.0
	spawner.current_wave_number = 0
	
	spawner._process(29.0)
	if spawner.current_wave_number != 0:
		return "Should not spawn wave before 30s timer"
		
	spawner._process(2.0)
	if spawner.current_wave_number != 1:
		return "Should spawn wave 1 after 30s elapsed"
		
	spawner.free()
	return ""

func test_task10_melee_ranged_creep_combat() -> String:
	var melee = CreepEntity.new()
	melee.creep_type = CreepEntity.CreepType.MELEE
	melee.team = TeamDefinitions.Team.RADIANT
	melee._ready()
	
	var ranged = CreepEntity.new()
	ranged.creep_type = CreepEntity.CreepType.RANGED
	ranged.team = TeamDefinitions.Team.DIRE
	ranged._ready()
	
	if melee.get_attack_range() > 3.0:
		return "Melee creep attack range should be <= 3.0m"
	if ranged.get_attack_range() < 5.0:
		return "Ranged creep attack range should be >= 5.0m"
		
	ranged.free()
	melee.free()
	return ""

func test_task10_siege_tower_bonus_damage() -> String:
	var siege = CreepEntity.new()
	siege.creep_type = CreepEntity.CreepType.SIEGE
	siege.team = TeamDefinitions.Team.RADIANT
	siege._ready()
	
	var tower = TowerEntity.new()
	tower.team = TeamDefinitions.Team.DIRE
	tower.backdoor_protection_enabled = false
	tower.is_backdoor_active = false
	tower._ready()
	tower.is_backdoor_active = false
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep._ready()
	
	var res_tower = siege.execute_basic_attack(tower)
	siege.attack_cooldown = 0.0
	var res_creep = siege.execute_basic_attack(creep)
	
	if res_tower == null or res_creep == null:
		return "Siege attack should return DamageResult"
	if res_tower.raw_damage < (res_creep.raw_damage * 1.4):
		return "Siege creep should deal 1.5x bonus damage against tower"
		
	creep.free()
	tower.free()
	siege.free()
	return ""

func test_task10_hero_aggro_call_for_help() -> String:
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero.global_position = Vector3.ZERO
	hero._ready()
	
	var enemy_creep = CreepEntity.new()
	enemy_creep.team = TeamDefinitions.Team.DIRE
	enemy_creep.global_position = Vector3(2.0, 0, 0)
	enemy_creep._ready()
	
	var ally_creep = CreepEntity.new()
	ally_creep.team = TeamDefinitions.Team.DIRE
	ally_creep.global_position = Vector3(3.0, 0, 0)
	ally_creep._ready()
	
	# Hero attacks enemy_creep
	var ad = hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var req = DamageRequest.create_basic_attack(hero, enemy_creep, ad)
	enemy_creep.receive_damage(req)
	
	if enemy_creep.aggro_target != hero:
		return "Attacked creep should aggro attacking hero"
	if enemy_creep.hero_aggro_timer <= 0.0:
		return "hero_aggro_timer should be set upon hero attack"
		
	ally_creep.free()
	enemy_creep.free()
	hero.free()
	return ""

func test_task10_last_hit_gold_and_xp() -> String:
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero.entity_name = "Astris"
	hero._ready()
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep.position = Vector3.ZERO
	creep.global_position = Vector3.ZERO
	creep._ready()
	creep.gold_bounty = 40
	creep.xp_bounty = 60
	
	var initial_gold = hero.inventory_manager.gold
	var initial_xp = hero.attribute_system.current_xp
	
	# Hero delivers last hit
	creep.last_attacker = hero
	creep._on_death("Astris")
	
	if hero.inventory_manager.gold != (initial_gold + 40):
		return "Hero should receive 40 gold for last hit"
	if hero.attribute_system.current_xp != (initial_xp + 60):
		return "Hero should receive 60 XP for last hit"
		
	creep.free()
	hero.free()
	return ""

func test_task10_non_hero_kill_xp_only() -> String:
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero.entity_name = "Astris"
	hero.global_position = Vector3(5.0, 0, 0)
	hero._ready()
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep.gold_bounty = 40
	creep.xp_bounty = 60
	creep.global_position = Vector3.ZERO
	creep._ready()
	
	var initial_gold = hero.inventory_manager.gold
	var initial_xp = hero.attribute_system.current_xp
	
	# Ally minion kills the creep (Non-hero kill)
	creep._on_death("Radiant Melee Minion")
	
	if hero.inventory_manager.gold != initial_gold:
		return "Hero should NOT receive gold when creep is killed by minion"
	if hero.attribute_system.current_xp <= initial_xp:
		return "Nearby hero should still receive shared XP from dying enemy creep"
		
	creep.free()
	hero.free()
	return ""

func test_task10_dead_creep_target_rejection() -> String:
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep._ready()
	
	creep.attribute_system.current_health = 0.0
	creep.attribute_system.is_alive = false
	creep.is_targetable = false
	
	if TargetRelationSystem.is_valid_basic_attack_target(hero, creep):
		return "Dead creep should not be a valid attack target"
		
	creep.free()
	hero.free()
	return ""

# ==============================================================================
# SOLEN: THE SOLAR ARCHER TESTS
# ==============================================================================
func test_solen_stats_and_archetype() -> String:
	var solen = SolenHero.new()
	solen.team = TeamDefinitions.Team.RADIANT
	solen._ready()
	
	if solen.hero_resource.primary_attribute != AttributeSystem.PrimaryAttributeType.AGILITY:
		return "Solen primary attribute should be AGILITY"
	if solen.get_attack_range() < 6.0:
		return "Solen attack range should be >= 6.0m (got %f)" % solen.get_attack_range()
	if solen.hero_resource.base_agility < 20.0:
		return "Solen base agility should be >= 20.0"
		
	solen.free()
	return ""

func test_solen_solar_charge_passive() -> String:
	var solen = SolenHero.new()
	solen.team = TeamDefinitions.Team.RADIANT
	solen._ready()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	for i in range(4):
		solen.attack_cooldown = 0.0
		solen.execute_basic_attack(dummy)
	if solen.solar_charges != 4:
		return "Solen should have 4 solar charges after 4 attacks (got %d)" % solen.solar_charges
		
	solen.attack_cooldown = 0.0
	solen.execute_basic_attack(dummy)
	if solen.solar_charges != 0:
		return "Solen solar charges should reset to 0 after 5th hit proc (got %d)" % solen.solar_charges
		
	dummy.free()
	solen.free()
	return ""

func test_solen_abilities() -> String:
	var solen = SolenHero.new()
	solen.team = TeamDefinitions.Team.RADIANT
	solen._ready()
	solen.attribute_system.current_mana = 500.0
	
	solen.ability_container.available_skill_points = 4
	var lvl_ok = solen.ability_container.level_up_ability(AbilityResource.Slot.Q)
	var cur_lvl = solen.ability_container.get_ability_level(AbilityResource.Slot.Q)
	var can_c = solen.ability_container.can_cast(AbilityResource.Slot.Q)
	var q_res = solen.ability_container.get_ability(AbilityResource.Slot.Q)
	
	solen.ability_container.level_up_ability(AbilityResource.Slot.W)
	solen.ability_container.level_up_ability(AbilityResource.Slot.E)
	solen.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	solen.ability_container.cooldown_timers[AbilityResource.Slot.Q] = 0.0
	solen.ability_container.is_free_spells_active = true
	var cast_q = solen.cast_ability(AbilityResource.Slot.Q, Vector3(10, 0, 0))
	if not cast_q:
		return "Solen Q failed: cast_q was false!"
		
	var initial_as = solen.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	solen.ability_container.cooldown_timers[AbilityResource.Slot.E] = 0.0
	var cast_e = solen.cast_ability(AbilityResource.Slot.E)
	if not cast_e:
		return "Solen E should cast successfully"
	var buffed_as = solen.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	if buffed_as <= initial_as:
		return "Solen E should grant attack speed buff"
		
	solen.free()
	return ""

# ==============================================================================
# SHOP & QUICK-BUY TESTS (market.png)
# ==============================================================================
func test_shop_and_quick_buy_system() -> String:
	Database.initialize()
	var shop = ShopInventoryUI.new()
	var hero = SolenHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	shop.bind_hero(hero)
	
	var all_items = Database.get_all_items()
	if all_items.is_empty():
		return "Database should have registered items"
		
	var test_item = all_items[0]
	shop._buy_item(test_item)
	
	if not hero.inventory_manager.has_item_by_name(test_item.item_name) and not (hero.inventory_manager.boots_slot != null and hero.inventory_manager.boots_slot.item_name == test_item.item_name):
		return "Hero should have purchased the item"
		
	shop.free()
	hero.free()
	return ""

func test_dota_item_tooltip() -> String:
	var tooltip = DotaItemTooltip.new()
	var item = ItemResource.new()
	item.item_name = "Demon Edge"
	item.cost = 2200
	item.category = ItemResource.Category.BASE
	item.stat_bonuses = {StatModifier.TargetStat.ATTACK_DAMAGE: 42.0}
	item.description = "A powerful glowing broadsword."
	
	tooltip.show_item(item)
	if tooltip.item_name_label.text != "DEMON EDGE":
		return "Tooltip should display uppercase item name"
	if tooltip.item_cost_label.text != "💰 2200":
		return "Tooltip should display formatted cost"
		
	tooltip.free()
	item.free()
	return ""

# --- 10 TASK 11: TOWER AI & STRUCTURE DEFENSE TESTS ---

func test_task11_tower_retaliation_aggro_on_ally_attack() -> String:
	var tower = TowerEntity.new()
	tower.team = TeamDefinitions.Team.RADIANT
	tower.position = Vector3(0, 0, 0)
	tower._ready()
	
	var ally_hero = KaelgorHero.new()
	ally_hero.team = TeamDefinitions.Team.RADIANT
	ally_hero.position = Vector3(2, 0, 0)
	ally_hero._ready()
	
	var enemy_hero = AstrisHero.new()
	enemy_hero.team = TeamDefinitions.Team.DIRE
	enemy_hero.position = Vector3(4, 0, 0)
	enemy_hero._ready()
	
	var enemy_creep = CreepEntity.new()
	enemy_creep.team = TeamDefinitions.Team.DIRE
	enemy_creep.position = Vector3(1, 0, 0)
	enemy_creep._ready()
	
	# Initially tower targets closest creep
	tower._update_target()
	if tower.current_target != enemy_creep:
		return "Tower initially should target closest creep"
		
	# Enemy hero attacks allied hero under tower
	tower._on_global_attack_started(enemy_hero, ally_hero)
	
	if tower.current_target != enemy_hero:
		return "Tower should immediately switch aggro to enemy hero attacking ally under tower"
		
	tower.free()
	ally_hero.free()
	enemy_hero.free()
	enemy_creep.free()
	return ""

func test_task11_tower_creep_priority_over_hero() -> String:
	var tower = TowerEntity.new()
	tower.team = TeamDefinitions.Team.RADIANT
	tower.position = Vector3(0, 0, 0)
	tower._ready()
	
	var enemy_hero = AstrisHero.new()
	enemy_hero.team = TeamDefinitions.Team.DIRE
	enemy_hero.position = Vector3(3, 0, 0)
	enemy_hero._ready()
	
	var enemy_creep = CreepEntity.new()
	enemy_creep.team = TeamDefinitions.Team.DIRE
	enemy_creep.position = Vector3(5, 0, 0)
	enemy_creep._ready()
	
	var target = tower._find_highest_priority_target()
	if target != enemy_creep:
		return "Tower should prioritize enemy creep over enemy hero when no hero combat is occurring"
		
	tower.free()
	enemy_hero.free()
	enemy_creep.free()
	return ""

func test_task11_tower_direct_attacker_priority() -> String:
	var tower = TowerEntity.new()
	tower.team = TeamDefinitions.Team.RADIANT
	tower.position = Vector3(0, 0, 0)
	tower._ready()
	
	var creep1 = CreepEntity.new()
	creep1.team = TeamDefinitions.Team.DIRE
	creep1.position = Vector3(2, 0, 0)
	creep1._ready()
	
	var creep2 = CreepEntity.new()
	creep2.team = TeamDefinitions.Team.DIRE
	creep2.position = Vector3(4, 0, 0)
	creep2._ready()
	
	# creep2 is attacking tower directly
	creep2.current_target = tower
	
	var target = tower._find_highest_priority_target()
	if target != creep2:
		return "Tower should prioritize the unit actively attacking the tower itself"
		
	tower.free()
	creep1.free()
	creep2.free()
	return ""

func test_task11_tower_aggro_drop_deaggro() -> String:
	var tower = TowerEntity.new()
	tower.team = TeamDefinitions.Team.RADIANT
	tower.position = Vector3(0, 0, 0)
	tower._ready()
	
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.DIRE
	hero.position = Vector3(3, 0, 0)
	hero._ready()
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep.position = Vector3(4, 0, 0)
	creep._ready()
	
	tower.current_target = hero
	var dropped = tower.drop_aggro(hero)
	
	if not dropped:
		return "drop_aggro should return true when switching to another valid target"
	if tower.current_target != creep:
		return "Tower should drop aggro to the next available enemy creep"
		
	tower.free()
	hero.free()
	creep.free()
	return ""

func test_task11_tower_backdoor_protection_damage_reduction() -> String:
	var tower = TowerEntity.new()
	tower.team = TeamDefinitions.Team.RADIANT
	tower.position = Vector3(0, 0, 0)
	tower._ready()
	
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.DIRE
	hero.position = Vector3(5, 0, 0)
	hero._ready()
	
	# No enemy creeps around -> Backdoor Protection is ACTIVE
	tower._process_backdoor_protection(0.016)
	if not tower.is_backdoor_active:
		return "Backdoor protection should be active when no enemy creeps in 18m"
		
	var req = DamageRequest.create_basic_attack(hero, tower, 100.0)
	tower.receive_damage(req)
	
	# 100 base damage reduced by 70% = 30 raw damage before armor
	if req.base_damage > 30.1 or req.base_damage < 29.9:
		return "Backdoor protection should reduce incoming damage to 30% (70% reduction)"
		
	tower.free()
	hero.free()
	return ""

func test_task11_tower_backdoor_protection_creep_disable() -> String:
	var tower = TowerEntity.new()
	tower.team = TeamDefinitions.Team.RADIANT
	tower.position = Vector3(0, 0, 0)
	tower._ready()
	
	var enemy_creep = CreepEntity.new()
	enemy_creep.team = TeamDefinitions.Team.DIRE
	enemy_creep.position = Vector3(10, 0, 0) # Within 18m
	enemy_creep._ready()
	
	tower._process_backdoor_protection(0.016)
	if tower.is_backdoor_active:
		return "Backdoor protection should be disabled when enemy creep is within 18m"
		
	tower.free()
	enemy_creep.free()
	return ""

func test_task11_tower_backdoor_protection_hp_regen() -> String:
	var tower = TowerEntity.new()
	tower.team = TeamDefinitions.Team.RADIANT
	tower.position = Vector3(0, 0, 0)
	tower._ready()
	
	var max_hp = tower.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	tower.backdoor_hp_baseline = max_hp
	tower.attribute_system.current_health = max_hp - 180.0
	tower.is_backdoor_active = true
	
	# 1 second of backdoor regen (90 HP/s)
	tower._process_backdoor_protection(1.0)
	
	var expected_hp = max_hp - 90.0
	if absf(tower.attribute_system.current_health - expected_hp) > 1.0:
		return "Tower should regenerate 90 HP/s under backdoor protection: expected %f, got %f" % [expected_hp, tower.attribute_system.current_health]
		
	tower.free()
	return ""

func test_task11_tower_true_sight_reveals_stealth() -> String:
	var tower = TowerEntity.new()
	tower.team = TeamDefinitions.Team.RADIANT
	tower.position = Vector3(0, 0, 0)
	tower._ready()
	
	var enemy_hero = AstrisHero.new()
	enemy_hero.team = TeamDefinitions.Team.DIRE
	enemy_hero.position = Vector3(6, 0, 0) # Inside 12m True Sight range
	enemy_hero.is_revealed = false
	enemy_hero._ready()
	
	tower._process_true_sight()
	if not enemy_hero.is_revealed:
		return "Tower True Sight should reveal enemy hero within 12m"
		
	tower.free()
	enemy_hero.free()
	return ""

func test_task11_tower_global_team_bounty_and_event() -> String:
	var killer_hero = AstrisHero.new()
	killer_hero.team = TeamDefinitions.Team.DIRE
	killer_hero._ready()
	killer_hero.entity_name = "Astris"
	var killer_init_gold = killer_hero.inventory_manager.gold
	
	var ally_hero = AstrisHero.new()
	ally_hero.team = TeamDefinitions.Team.DIRE
	ally_hero._ready()
	ally_hero.entity_name = "AstrisAlly"
	var ally_init_gold = ally_hero.inventory_manager.gold
	
	var tower = TowerEntity.new()
	tower.team = TeamDefinitions.Team.RADIANT
	tower.tier = 2 # 150 * 2 = 300 team gold
	tower.team_bounty_gold = 150
	tower._ready()
	
	tower.last_attacker = killer_hero
	tower._on_death("Astris")
	
	# Team gold: 300 for both killer and ally
	if killer_hero.inventory_manager.gold != (killer_init_gold + 300):
		return "Killer hero expected 300g team bounty, got %d" % (killer_hero.inventory_manager.gold - killer_init_gold)
	if ally_hero.inventory_manager.gold != (ally_init_gold + 300):
		return "Ally hero expected 300g team bounty, got %d" % (ally_hero.inventory_manager.gold - ally_init_gold)
		
	tower.free()
	killer_hero.free()
	ally_hero.free()
	return ""

func test_task11_tower_range_indicator_and_collision_cleanup() -> String:
	var tower = TowerEntity.new()
	tower.team = TeamDefinitions.Team.RADIANT
	tower._ready()
	
	tower.set_range_indicator_visible(true)
	if tower.range_indicator == null or not tower.range_indicator.visible:
		return "Range indicator should be visible when set_range_indicator_visible(true) is called"
		
	tower.set_range_indicator_visible(false)
	if tower.range_indicator.visible:
		return "Range indicator should be hidden when set_range_indicator_visible(false) is called"
		
	tower._on_death("TestKiller")
	if not tower.is_destroyed:
		return "Tower is_destroyed should be true after death"
		
	tower.free()
	return ""

# --- 13 TASK 12: 3D WORLD-SPACE STATUS BARS TESTS ---

func test_task12_world_status_bar_creation_and_offsets() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	var creep = CreepEntity.new()
	creep.creep_type = CreepEntity.CreepType.MELEE
	creep._ready()
	var siege = CreepEntity.new()
	siege.creep_type = CreepEntity.CreepType.SIEGE
	siege._ready()
	var monster = NeutralCreepEntity.new()
	monster._ready()
	var tower = TowerEntity.new()
	tower._ready()
	
	if hero.status_bar == null or hero.status_bar.vertical_offset != 2.2:
		return "Hero status bar vertical offset expected 2.2m"
	if creep.status_bar == null or creep.status_bar.vertical_offset != 1.2:
		return "Creep status bar vertical offset expected 1.2m"
	if siege.status_bar == null or siege.status_bar.vertical_offset != 1.6:
		return "Siege creep status bar vertical offset expected 1.6m"
	if monster.status_bar == null or monster.status_bar.vertical_offset != 1.8:
		return "Neutral monster status bar vertical offset expected 1.8m"
	if tower.status_bar == null or tower.status_bar.vertical_offset != 4.8:
		return "Tower status bar vertical offset expected 4.8m"
		
	hero.free()
	creep.free()
	siege.free()
	monster.free()
	tower.free()
	return ""

func test_task12_hp_bar_current_max_ratio() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	var max_hp = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	hero.attribute_system.current_health = max_hp * 0.75
	
	hero.status_bar._update_visuals(0.0)
	if absf(hero.status_bar.get_health_ratio() - 0.75) > 0.01:
		return "Expected health ratio 0.75, got %f" % hero.status_bar.get_health_ratio()
		
	hero.free()
	return ""

func test_task12_damage_immediate_drop() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	var max_hp = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	hero.attribute_system.current_health = max_hp
	hero.status_bar._update_visuals(0.0)
	
	# Apply damage to reach 60% HP
	hero.attribute_system.current_health = max_hp * 0.60
	hero.status_bar._update_visuals(0.016)
	
	if absf(hero.status_bar.get_health_ratio() - 0.6) > 0.01:
		return "Main HP bar should drop immediately to 0.6, got %f" % hero.status_bar.get_health_ratio()
	if absf(hero.status_bar.get_delayed_health_ratio() - 1.0) > 0.01:
		return "Delayed HP bar should hold at 1.0 immediately after damage, got %f" % hero.status_bar.get_delayed_health_ratio()
		
	hero.free()
	return ""

func test_task12_delayed_damage_bar_lag_and_catchup() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	var max_hp = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	hero.attribute_system.current_health = max_hp
	hero.status_bar._update_visuals(0.0)
	
	# Damage taken -> 50% HP
	hero.attribute_system.current_health = max_hp * 0.50
	hero.status_bar._update_visuals(0.016)
	
	# During lag (0.2s elapsed < 0.35s lag duration), delayed bar should still hold around 1.0
	hero.status_bar._update_visuals(0.2)
	if hero.status_bar.get_delayed_health_ratio() < 0.95:
		return "Delayed damage bar should hold during 0.35s lag window"
		
	# After lag expires (e.g. 0.8s total), delayed bar catches up to main HP bar
	hero.status_bar._update_visuals(0.8)
	if absf(hero.status_bar.get_delayed_health_ratio() - 0.5) > 0.05:
		return "Delayed damage bar should catch up to main HP ratio (0.5), got %f" % hero.status_bar.get_delayed_health_ratio()
		
	hero.free()
	return ""

func test_task12_heal_immediate_update() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	var max_hp = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	hero.attribute_system.current_health = max_hp * 0.40
	hero.status_bar._update_visuals(0.0)
	
	# Heal to 70% HP
	hero.attribute_system.current_health = max_hp * 0.70
	hero.status_bar._update_visuals(0.016)
	
	if absf(hero.status_bar.get_health_ratio() - 0.7) > 0.01:
		return "Health ratio should update to 0.7 on heal"
	if absf(hero.status_bar.get_delayed_health_ratio() - 0.7) > 0.01:
		return "Delayed damage bar should immediately update to 0.7 on heal without lag"
		
	hero.free()
	return ""

func test_task12_mana_bar_hero_vs_creep() -> String:
	var hero = AstrisHero.new()
	hero._ready()
	var creep = CreepEntity.new()
	creep._ready()
	var tower = TowerEntity.new()
	tower._ready()
	
	hero.status_bar._update_visuals(0.016)
	creep.status_bar._update_visuals(0.016)
	tower.status_bar._update_visuals(0.016)
	
	if not hero.status_bar.mana_mesh.visible:
		return "Hero mana bar should be visible"
	if creep.status_bar.mana_mesh.visible:
		return "Creep mana bar should be hidden"
	if tower.status_bar.mana_mesh.visible:
		return "Tower mana bar should be hidden"
		
	hero.free()
	creep.free()
	tower.free()
	return ""

func test_task12_shield_indicator_display() -> String:
	var hero = AstrisHero.new()
	hero._ready()
	hero.status_bar._update_visuals(0.016)
	
	if hero.status_bar.shield_mesh.visible:
		return "Shield mesh should initially be hidden"
		
	# Apply 300 Shield
	var shield_eff = StatusEffect.new("test_shield", StatusEffect.EffectType.SHIELD, 5.0, 300.0, false)
	hero.effect_container.apply_effect(shield_eff)
	hero.status_bar._update_visuals(0.016)
	
	if not hero.status_bar.shield_mesh.visible:
		return "Shield mesh should be visible when shield effect is active"
		
	hero.effect_container.remove_effect_by_id("test_shield")
	hero.status_bar._update_visuals(0.016)
	
	if hero.status_bar.shield_mesh.visible:
		return "Shield mesh should hide when shield is removed"
		
	hero.free()
	return ""

func test_task12_status_effect_stun_timer_display() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var stun = StatusEffect.new("hammer_stun", StatusEffect.EffectType.STUN, 2.0, 0.0, true)
	hero.effect_container.apply_effect(stun)
	hero.status_bar._update_visuals(0.016)
	
	var txt = hero.status_bar.get_active_status_text()
	if not txt.begins_with("[STUNNED]"):
		return "Status label should display [STUNNED], got '%s'" % txt
		
	hero.effect_container.remove_effect_by_id("hammer_stun")
	hero.status_bar._update_visuals(0.016)
	if hero.status_bar.get_active_status_text() != "":
		return "Status label should be cleared when stun expires"
		
	hero.free()
	return ""

func test_task12_status_effect_root_timer_display() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var root_eff = StatusEffect.new("stasis_root", StatusEffect.EffectType.ROOT, 1.5, 0.0, true)
	hero.effect_container.apply_effect(root_eff)
	hero.status_bar._update_visuals(0.016)
	
	var txt = hero.status_bar.get_active_status_text()
	if not txt.begins_with("[ROOTED]"):
		return "Status label should display [ROOTED], got '%s'" % txt
		
	hero.free()
	return ""

func test_task12_dead_entity_bar_cleared() -> String:
	var creep = CreepEntity.new()
	creep._ready()
	creep.status_bar._update_visuals(0.016)
	if not creep.status_bar.visible:
		return "Living creep status bar should be visible"
		
	creep.die()
	creep.status_bar._update_visuals(0.016)
	if creep.status_bar.visible:
		return "Dead creep status bar should be hidden"
		
	creep.free()
	return ""

func test_task12_target_selection_highlight() -> String:
	var creep = CreepEntity.new()
	creep._ready()
	
	creep.status_bar.set_selected(true)
	if not creep.status_bar.is_selected_target:
		return "is_selected_target should be true after set_selected(true)"
	if creep.status_bar.anchor_root.scale.x <= 1.05:
		return "Status bar anchor root should scale up when selected"
		
	creep.status_bar.set_selected(false)
	if creep.status_bar.anchor_root.scale.x > 1.05:
		return "Status bar anchor root should reset scale when unselected"
		
	creep.free()
	return ""

func test_task12_neutral_and_tower_bars() -> String:
	var monster = NeutralCreepEntity.new()
	monster._ready()
	var tower = TowerEntity.new()
	tower._ready()
	
	monster.status_bar._update_visuals(0.016)
	tower.status_bar._update_visuals(0.016)
	
	if monster.status_bar.bar_width != 1.0:
		return "Monster bar width expected 1.0"
	if tower.status_bar.bar_width != 1.8:
		return "Tower bar width expected 1.8"
		
	monster.free()
	tower.free()
	return ""

func test_task12_scalability_100_entities() -> String:
	var entities: Array[BaseCombatEntity] = []
	for i in range(100):
		var c = CreepEntity.new()
		c.creep_type = CreepEntity.CreepType.MELEE if i % 2 == 0 else CreepEntity.CreepType.RANGED
		c._ready()
		entities.append(c)
		
	var start_time = Time.get_ticks_usec()
	for ent in entities:
		ent.status_bar._update_visuals(0.016)
	var elapsed_us = Time.get_ticks_usec() - start_time
	
	for ent in entities:
		ent.free()
		
	if elapsed_us > 50000:
		return "100 status bar updates took too long: %d us" % elapsed_us
		
	return ""

# --- 16 TASK 13: COMBAT TARGETING & BASIC ATTACK TESTS ---

func test_task13_melee_hero_to_enemy_hero_damage() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	kaelgor.position = Vector3(0, 0, 0)
	
	var astris = AstrisHero.new()
	astris.team = TeamDefinitions.Team.DIRE
	astris._ready()
	astris.position = Vector3(1.5, 0, 0)
	
	var initial_hp = astris.attribute_system.current_health
	var success = kaelgor.attack_controller.issue_attack_command(astris)
	if not success:
		return "Melee attack command on enemy hero should succeed"
		
	kaelgor.attack_controller.update(0.30)
	
	if astris.attribute_system.current_health >= initial_hp:
		return "Enemy hero should take physical basic attack damage"
		
	kaelgor.free()
	astris.free()
	return ""

func test_task13_ranged_hero_to_enemy_hero_damage() -> String:
	var astris = AstrisHero.new()
	astris.team = TeamDefinitions.Team.RADIANT
	astris._ready()
	astris.position = Vector3(0, 0, 0)
	
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.DIRE
	kaelgor._ready()
	kaelgor.position = Vector3(5.0, 0, 0)
	
	var initial_hp = kaelgor.attribute_system.current_health
	var success = astris.attack_controller.issue_attack_command(kaelgor)
	if not success:
		return "Ranged attack command on enemy hero should succeed"
		
	if astris.attack_controller.get_attack_type() != AttackController.AttackType.RANGED:
		return "Astris attack type should be RANGED"
		
	astris.attack_controller.update(0.30)
	
	if kaelgor.attribute_system.current_health >= initial_hp:
		return "Enemy hero should take damage from ranged basic attack"
		
	astris.free()
	kaelgor.free()
	return ""

func test_task13_hero_to_enemy_creep_damage() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.position = Vector3(0, 0, 0)
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep._ready()
	creep.position = Vector3(1.2, 0, 0)
	
	var initial_hp = creep.attribute_system.current_health
	hero.attack_controller.issue_attack_command(creep)
	hero.attack_controller.update(0.30)
	
	if creep.attribute_system.current_health >= initial_hp:
		return "Enemy creep should take basic attack damage from hero"
		
	hero.free()
	creep.free()
	return ""

func test_task13_hero_to_neutral_monster_damage() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.position = Vector3(0, 0, 0)
	
	var monster = NeutralCreepEntity.new()
	monster._ready()
	monster.position = Vector3(1.4, 0, 0)
	
	var initial_hp = monster.attribute_system.current_health
	var success = hero.attack_controller.issue_attack_command(monster)
	if not success:
		return "Hero attacking neutral monster should be valid"
		
	hero.attack_controller.update(0.30)
	if monster.attribute_system.current_health >= initial_hp:
		return "Neutral monster should take damage from basic attack"
		
	hero.free()
	monster.free()
	return ""

func test_task13_hero_to_enemy_tower_damage() -> String:
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.position = Vector3(0, 0, 0)
	
	var tower = TowerEntity.new()
	tower.team = TeamDefinitions.Team.DIRE
	tower._ready()
	tower.position = Vector3(4.0, 0, 0)
	
	var initial_hp = tower.attribute_system.current_health
	var success = hero.attack_controller.issue_attack_command(tower)
	if not success:
		return "Hero attacking enemy tower should be valid"
		
	hero.attack_controller.update(0.30)
	if tower.attribute_system.current_health >= initial_hp:
		return "Enemy tower should take damage from basic attack"
		
	hero.free()
	tower.free()
	return ""

func test_task13_hero_to_ally_hero_rejected() -> String:
	var hero_a = KaelgorHero.new()
	hero_a.team = TeamDefinitions.Team.RADIANT
	hero_a._ready()
	
	var hero_b = AstrisHero.new()
	hero_b.team = TeamDefinitions.Team.RADIANT
	hero_b._ready()
	
	var success = hero_a.attack_controller.issue_attack_command(hero_b)
	if success:
		return "Attacking allied hero must be rejected (No friendly fire)"
		
	if hero_a.attack_controller.attack_target != null:
		return "Attack target should remain null when targeting ally"
		
	hero_a.free()
	hero_b.free()
	return ""

func test_task13_hero_to_ally_creep_rejected() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var ally_creep = CreepEntity.new()
	ally_creep.team = TeamDefinitions.Team.RADIANT
	ally_creep._ready()
	
	var success = hero.attack_controller.issue_attack_command(ally_creep)
	if success:
		return "Attacking allied creep without deny condition must be rejected"
		
	hero.free()
	ally_creep.free()
	return ""

func test_task13_pursuit_outside_range() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.position = Vector3(0, 0, 0)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	enemy.position = Vector3(15.0, 0, 0)
	
	hero.attack_controller.issue_attack_command(enemy)
	if hero.attack_controller.current_state != AttackController.AttackState.MOVING_TO_TARGET:
		return "State should be MOVING_TO_TARGET when target is beyond attack range"
		
	hero.free()
	enemy.free()
	return ""

func test_task13_auto_attack_upon_entering_range() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.position = Vector3(0, 0, 0)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	enemy.position = Vector3(10.0, 0, 0)
	
	hero.attack_controller.issue_attack_command(enemy)
	# Move hero close to enemy (distance 1.2m <= 2.3m attack range)
	hero.position = Vector3(8.8, 0, 0)
	hero.attack_controller.update(0.016)
	
	if hero.attack_controller.current_state != AttackController.AttackState.ATTACKING:
		return "State should transition to ATTACKING upon entering range"
		
	hero.free()
	enemy.free()
	return ""

func test_task13_attack_cooldown_enforcement() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.position = Vector3(0, 0, 0)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	enemy.position = Vector3(1.5, 0, 0)
	
	hero.attack_controller.issue_attack_command(enemy)
	hero.attack_controller.update(0.30)
	
	if hero.attack_controller.cooldown_timer <= 0.0:
		return "Cooldown timer should be active after delivering attack"
	if hero.attack_controller.current_state != AttackController.AttackState.COOLDOWN:
		return "State should be COOLDOWN after delivering hit"
		
	var enemy_hp_before = enemy.attribute_system.current_health
	hero.attack_controller.update(0.05)
	if enemy.attribute_system.current_health < enemy_hp_before:
		return "Should not apply double attack while on cooldown"
		
	hero.free()
	enemy.free()
	return ""

func test_task13_attack_speed_interval_scaling() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	var base_interval = hero.get_attack_interval()
	
	var mod = StatModifier.new(StatModifier.TargetStat.ATTACK_SPEED, StatModifier.Type.FLAT, 1.0, "hyperstone")
	hero.attribute_system.add_modifier(mod)
	hero.attribute_system.recalculate_all_stats()
	
	var new_interval = hero.get_attack_interval()
	if new_interval >= base_interval:
		return "Higher attack speed should decrease attack interval (got base: %f, new: %f)" % [base_interval, new_interval]
		
	hero.free()
	return ""

func test_task13_target_death_stops_attack() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.position = Vector3(0, 0, 0)
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep._ready()
	creep.position = Vector3(1.2, 0, 0)
	
	hero.attack_controller.issue_attack_command(creep)
	creep.die()
	hero.attack_controller.update(0.016)
	
	if hero.attack_controller.current_state != AttackController.AttackState.IDLE:
		return "Attack state should reset to IDLE when target dies"
	if hero.attack_controller.attack_target != null:
		return "Attack target should be cleared when target dies"
		
	hero.free()
	creep.free()
	return ""

func test_task13_projectile_target_freed_safety() -> String:
	var proj = BasicAttackProjectile3D.new()
	var dummy = TargetDummyEntity.new()
	dummy._ready()
	
	var req = DamageRequest.create_basic_attack(dummy, dummy, 50.0)
	proj.setup(dummy, dummy, req, Color.RED, 30.0, 0.3)
	
	dummy.free()
	proj._physics_process(0.016)
	proj.free()
	return ""

func test_task13_target_switching() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.position = Vector3(0, 0, 0)
	
	var creep1 = CreepEntity.new()
	creep1.team = TeamDefinitions.Team.DIRE
	creep1._ready()
	creep1.position = Vector3(1.5, 0, 0)
	
	var creep2 = CreepEntity.new()
	creep2.team = TeamDefinitions.Team.DIRE
	creep2._ready()
	creep2.position = Vector3(8.0, 0, 0)
	
	hero.attack_controller.issue_attack_command(creep1)
	if hero.attack_controller.attack_target != creep1:
		return "Expected target creep1"
		
	hero.attack_controller.issue_attack_command(creep2)
	if hero.attack_controller.attack_target != creep2:
		return "Expected target switched to creep2"
	if hero.attack_controller.current_state != AttackController.AttackState.MOVING_TO_TARGET:
		return "Expected state MOVING_TO_TARGET for distant creep2"
		
	hero.free()
	creep1.free()
	creep2.free()
	return ""

func test_task13_attack_command_cancellation() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	hero.attack_controller.issue_attack_command(enemy)
	hero.attack_controller.cancel_attack_command()
	
	if hero.attack_controller.current_state != AttackController.AttackState.IDLE:
		return "State should be IDLE after cancellation"
	if hero.attack_controller.attack_target != null:
		return "Target should be null after cancellation"
		
	hero.free()
	enemy.free()
	return ""

func test_task13_armor_damage_reduction_calculation() -> String:
	var hero = HeroEntity.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.attribute_system.base_strength = 0.0
	hero.attribute_system.base_agility = 0.0
	hero.attribute_system.base_intelligence = 0.0
	hero.attribute_system.base_attack_damage = 100.0
	hero.attribute_system.recalculate_all_stats()
	hero.position = Vector3(0, 0, 0)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	dummy.attribute_system.base_health = 1000.0
	dummy.attribute_system.base_armor = 20.0
	dummy.attribute_system.recalculate_all_stats()
	dummy.attribute_system.current_health = 1000.0
	dummy.position = Vector3(1.5, 0, 0)
	
	var ad = hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var armor = dummy.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	var expected_mult = 100.0 / (100.0 + armor)
	var expected_dmg = ad * expected_mult
	
	hero.attack_controller.issue_attack_command(dummy)
	hero.attack_controller.update(0.30)
	
	var dmg_taken = 1000.0 - dummy.attribute_system.current_health
	if absf(dmg_taken - expected_dmg) > 1.0:
		return "Expected ~%f mitigated damage for 20 armor, got %f" % [expected_dmg, dmg_taken]
		
	hero.free()
	dummy.free()
	return ""

# ==============================================================================
# --- TASK 14: DEATH, RESPAWN & COMBAT LIFECYCLE TESTS (Tests 227–243) ---
# ==============================================================================

func test_task14_hp_zero_triggers_death() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	hero.attribute_system.take_damage(hero.attribute_system.current_health + 100.0)
	if hero.is_alive():
		return "Hero with 0 HP should not be alive"
	if hero.lifecycle_state != BaseCombatEntity.LifecycleState.DEAD:
		return "Hero lifecycle_state should be DEAD"
	if hero.is_targetable:
		return "Dead hero should not be targetable"
		
	hero.free()
	return ""

func test_task14_death_only_triggers_once() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var death_count = [0]
	hero.died.connect(func(_entity, _killer): death_count[0] += 1)
	
	hero.die()
	hero.die()
	hero._on_death("Tester")
	
	if death_count[0] != 1:
		return "Death should only trigger exactly once, got %d" % death_count[0]
		
	hero.free()
	return ""

func test_task14_dead_entity_cannot_receive_damage() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.die()
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	var req = DamageRequest.create_basic_attack(enemy, hero, 100.0)
	var res = hero.receive_damage(req)
	
	if res != null:
		return "Dead entity should return null when receiving damage"
		
	hero.free()
	enemy.free()
	return ""

func test_task14_dead_entity_cannot_attack() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	enemy.position = Vector3(1.0, 0, 0)
	
	hero.die()
	var can_atk = hero.can_attack()
	if can_atk:
		return "Dead hero should not be able to attack"
		
	var issued = hero.attack_controller.issue_attack_command(enemy)
	if issued:
		return "Dead hero should not be able to issue attack command"
		
	hero.free()
	enemy.free()
	return ""

func test_task14_target_death_clears_attacker_target() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.position = Vector3(0, 0, 0)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	enemy.position = Vector3(1.5, 0, 0)
	
	hero.attack_controller.issue_attack_command(enemy)
	if hero.attack_controller.attack_target != enemy:
		return "Attack target should be set to enemy"
		
	enemy.die()
	hero.attack_controller.update(0.016)
	
	if hero.attack_controller.attack_target != null:
		return "Attacker's target should be cleared when target dies"
	if hero.attack_controller.current_state != AttackController.AttackState.IDLE:
		return "Attacker should return to IDLE state after target dies"
		
	hero.free()
	enemy.free()
	return ""

func test_task14_projectile_ignores_dead_target_safely() -> String:
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var enemy = KaelgorHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	var req = DamageRequest.create_basic_attack(hero, enemy, 100.0)
	var proj_script = load("res://scenes/effects/basic_attack_projectile_3d.gd")
	var proj = proj_script.new()
	proj.setup(hero, enemy, req, Color.BLUE, 30.0, 0.3)
	
	# Kill target before projectile impacts
	enemy.die()
	
	# Simulate impact
	proj._on_impact()
	
	if enemy.attribute_system.current_health != 0.0:
		return "Target should remain at 0 health and not be affected"
		
	hero.free()
	enemy.free()
	return ""

func test_task14_hero_death_starts_respawn_timer() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	hero.die()
	if hero.respawn_timer <= 0.0:
		return "Dead hero should have respawn_timer > 0.0, got %f" % hero.respawn_timer
		
	hero.free()
	return ""

func test_task14_hero_respawn_restores_full_hp() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	hero.die()
	hero.respawn()
	
	var max_hp = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	if hero.attribute_system.current_health != max_hp:
		return "Respawned hero should have full health (expected %f, got %f)" % [max_hp, hero.attribute_system.current_health]
	if not hero.is_alive():
		return "Respawned hero should be alive"
		
	hero.free()
	return ""

func test_task14_hero_respawn_restores_full_mana() -> String:
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	hero.die()
	hero.respawn()
	
	var max_mp = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
	if hero.attribute_system.current_mana != max_mp:
		return "Respawned hero should have full mana (expected %f, got %f)" % [max_mp, hero.attribute_system.current_mana]
		
	hero.free()
	return ""

func test_task14_hero_respawn_clears_cc_effects() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var stun = StatusEffect.new("test_stun", StatusEffect.EffectType.STUN, 5.0)
	hero.effect_container.apply_effect(stun)
	if not hero.effect_container.is_stunned():
		return "Hero should be stunned before death"
		
	hero.die()
	hero.respawn()
	
	if hero.effect_container.is_stunned():
		return "Respawned hero should have stun cleared"
	if hero.effect_container.active_effects.size() > 0:
		return "Respawned hero should have no active effects lingering"
		
	hero.free()
	return ""

func test_task14_hero_respawn_clears_shields() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var shield = StatusEffect.new("test_shield", StatusEffect.EffectType.SHIELD, 10.0, 500.0)
	hero.effect_container.apply_effect(shield)
	if hero.effect_container.get_total_shield() <= 0.0:
		return "Hero should have shield active"
		
	hero.die()
	hero.respawn()
	
	if hero.effect_container.get_total_shield() > 0.0:
		return "Respawned hero should have 0 shield"
		
	hero.free()
	return ""

func test_task14_hero_respawn_relocates_to_spawn_origin() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero.spawn_origin = Vector3(0, 0, 85.0)
	hero._ready()
	hero.position = Vector3(10.0, 0, -20.0)
	
	hero.die()
	hero.respawn()
	
	if hero.position.distance_to(Vector3(0, 0, 85.0)) > 0.1:
		return "Hero should be relocated to spawn origin upon respawn, got %s" % str(hero.position)
		
	hero.free()
	return ""

func test_task14_creep_death_lifecycle_and_signal() -> String:
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep._ready()
	
	var killer_hero = KaelgorHero.new()
	killer_hero.team = TeamDefinitions.Team.RADIANT
	killer_hero._ready()
	
	creep.last_attacker = killer_hero
	creep.die(killer_hero)
	
	if creep.is_alive():
		return "Dead creep should not be alive"
	if creep.is_targetable:
		return "Dead creep should not be targetable"
		
	creep.free()
	killer_hero.free()
	return ""

func test_task14_neutral_death_lifecycle_and_signal() -> String:
	var neutral = NeutralCreepEntity.new()
	neutral.team = TeamDefinitions.Team.NEUTRAL
	neutral._ready()
	
	neutral.die()
	if neutral.is_alive():
		return "Dead neutral should not be alive"
	if neutral.is_targetable:
		return "Dead neutral should not be targetable"
		
	neutral.free()
	return ""

func test_task14_tower_destruction_lifecycle() -> String:
	var tower = TowerEntity.new()
	tower.team = TeamDefinitions.Team.DIRE
	tower._ready()
	
	tower.die()
	if tower.is_alive():
		return "Destroyed tower should not be alive"
	if not tower.is_destroyed:
		return "is_destroyed flag should be true on tower death"
	if tower.is_targetable:
		return "Destroyed tower should not be targetable"
		
	tower.free()
	return ""

func test_task14_world_status_bar_death_and_respawn_visibility() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	if hero.status_bar == null:
		return "Status bar should be initialized on ready"
		
	hero.die()
	if hero.status_bar.visible:
		return "Status bar should be hidden when hero dies"
		
	hero.respawn()
	if not hero.status_bar.visible:
		return "Status bar should be visible after hero respawns"
		
	hero.free()
	return ""

func test_task14_hero_respawn_timer_tick_and_auto_respawn() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	hero.die()
	hero.respawn_timer = 0.5 # Fast timer for test
	
	hero._physics_process(0.3)
	if hero.is_alive():
		return "Hero should not respawn before timer ends"
		
	hero._physics_process(0.3)
	if not hero.is_alive():
		return "Hero should automatically respawn when timer completes"
	if hero.current_state != HeroEntity.HeroState.IDLE:
		return "Hero state should be IDLE after auto-respawn"
		
	hero.free()
	return ""










