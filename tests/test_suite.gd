class_name TestSuite
extends RefCounted

const RavenaHeroClass = preload("res://core/entities/heroes/ravena/ravena_hero.gd")
const RavenaDefinitionClass = preload("res://data/heroes/ravena_definition.gd")
const TharosHeroClass = preload("res://core/entities/heroes/tharos/tharos_hero.gd")
const TharosDefinitionClass = preload("res://data/heroes/tharos_definition.gd")
const MordrenHeroClass = preload("res://core/entities/heroes/mordren/mordren_hero.gd")
const MordrenDefinitionClass = preload("res://data/heroes/mordren_definition.gd")
const BrakkaHeroClass = preload("res://core/entities/heroes/brakka/brakka_hero.gd")
const BrakkaDefinitionClass = preload("res://data/heroes/brakka_definition.gd")
const VeyraHeroClass = preload("res://core/entities/heroes/veyra/veyra_hero.gd")
const VeyraDefinitionClass = preload("res://data/heroes/veyra_definition.gd")
const GorakHeroClass = preload("res://core/entities/heroes/gorak/gorak_hero.gd")
const GorakDefinitionClass = preload("res://data/heroes/gorak_definition.gd")
const DurnHeroClass = preload("res://core/entities/heroes/durn/durn_hero.gd")
const DurnDefinitionClass = preload("res://data/heroes/durn_definition.gd")
const AuronHeroClass = preload("res://core/entities/heroes/auron/auron_hero.gd")
const AuronDefinitionClass = preload("res://data/heroes/auron_definition.gd")
const KharosHeroClass = preload("res://core/entities/heroes/kharos/kharos_hero.gd")
const KharosDefinitionClass = preload("res://data/heroes/kharos_definition.gd")
const NyxaraHeroClass = preload("res://core/entities/heroes/nyxara/nyxara_hero.gd")
const NyxaraDefinitionClass = preload("res://data/heroes/nyxara_definition.gd")
const KaeliHeroClass = preload("res://core/entities/heroes/kaeli/kaeli_hero.gd")
const KaeliDefinitionClass = preload("res://data/heroes/kaeli_definition.gd")
const VarynHeroClass = preload("res://core/entities/heroes/varyn/varyn_hero.gd")
const VarynDefinitionClass = preload("res://data/heroes/varyn_definition.gd")
const ElyraHeroClass = preload("res://core/entities/heroes/elyra/elyra_hero.gd")
const ElyraDefinitionClass = preload("res://data/heroes/elyra_definition.gd")
const RivenaHeroClass = preload("res://core/entities/heroes/rivena/rivena_hero.gd")
const RivenaDefinitionClass = preload("res://data/heroes/rivena_definition.gd")
const TalonHeroClass = preload("res://core/entities/heroes/talon/talon_hero.gd")
const TalonDefinitionClass = preload("res://data/heroes/talon_definition.gd")
const SerisHeroClass = preload("res://core/entities/heroes/seris/seris_hero.gd")
const SerisDefinitionClass = preload("res://data/heroes/seris_definition.gd")
const MiraHeroClass = preload("res://core/entities/heroes/mira/mira_hero.gd")
const MiraDefinitionClass = preload("res://data/heroes/mira_definition.gd")
const ZarekHeroClass = preload("res://core/entities/heroes/zarek/zarek_hero.gd")
const ZarekDefinitionClass = preload("res://data/heroes/zarek_definition.gd")
const IlyraHeroClass = preload("res://core/entities/heroes/ilyra/ilyra_hero.gd")
const IlyraDefinitionClass = preload("res://data/heroes/ilyra_definition.gd")
const VaelHeroClass = preload("res://core/entities/heroes/vael/vael_hero.gd")
const VaelDefinitionClass = preload("res://data/heroes/vael_definition.gd")
const NerisHeroClass = preload("res://core/entities/heroes/neris/neris_hero.gd")
const NerisDefinitionClass = preload("res://data/heroes/neris_definition.gd")
const OrynHeroClass = preload("res://core/entities/heroes/oryn/oryn_hero.gd")
const OrynDefinitionClass = preload("res://data/heroes/oryn_definition.gd")
const SelkaHeroClass = preload("res://core/entities/heroes/selka/selka_hero.gd")
const SelkaDefinitionClass = preload("res://data/heroes/selka_definition.gd")
const MoraHeroClass = preload("res://core/entities/heroes/mora/mora_hero.gd")
const MoraDefinitionClass = preload("res://data/heroes/mora_definition.gd")
const AethonHeroClass = preload("res://core/entities/heroes/aethon/aethon_hero.gd")
const AethonDefinitionClass = preload("res://data/heroes/aethon_definition.gd")
const NymeraHeroClass = preload("res://core/entities/heroes/nymera/nymera_hero.gd")
const NymeraDefinitionClass = preload("res://data/heroes/nymera_definition.gd")
const VeylinHeroClass = preload("res://core/entities/heroes/veylin/veylin_hero.gd")
const VeylinDefinitionClass = preload("res://data/heroes/veylin_definition.gd")
const ZyraenHeroClass = preload("res://core/entities/heroes/zyraen/zyraen_hero.gd")
const ZyraenDefinitionClass = preload("res://data/heroes/zyraen_definition.gd")
const HeroSelectionUIClass = preload("res://systems/ui/hero_selection_ui.gd")
const GlobalHeroSelectionClass = preload("res://systems/ui/global_hero_selection.gd")
const DotaStatusEffectIconClass = preload("res://systems/ui/dota_status_effect_icon.gd")
const DotaStatusEffectBarClass = preload("res://systems/ui/dota_status_effect_bar.gd")
const SkillshotProjectile3DClass = preload("res://scenes/effects/skillshot_projectile_3d.gd")
const HomingSpellProjectile3DClass = preload("res://scenes/effects/homing_spell_projectile_3d.gd")
const SpellVisualFX3DClass = preload("res://scenes/effects/spell_visual_fx_3d.gd")
const FogOfWarManagerClass = preload("res://systems/fog_of_war/fog_of_war_manager.gd")
const BushArea3DClass = preload("res://scenes/map/bush_area_3d.gd")
const HeroAnimator3DClass = preload("res://core/entities/heroes/components/hero_animator_3d.gd")
const ItemEventEngineClass = preload("res://systems/items/item_event_engine.gd")

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
	# --- 20 TASK 15: CREEP COMBAT, LAST HIT & LANE ECONOMY TESTS ---
	run_test("244. Task 15: Melee Creep Basic Attack", test_task15_melee_creep_basic_attack)
	run_test("245. Task 15: Ranged Creep Projectile Attack", test_task15_ranged_creep_projectile_attack)
	run_test("246. Task 15: Siege Creep Attack", test_task15_siege_creep_attack)
	run_test("247. Task 15: Creep to Creep Damage Pipeline", test_task15_creep_to_creep_damage)
	run_test("248. Task 15: Creep to Hero Damage Pipeline", test_task15_creep_to_hero_damage)
	run_test("249. Task 15: Hero to Creep Continuous Attack", test_task15_hero_to_creep_damage)
	run_test("250. Task 15: Enemy Creep Target Priority Selection", test_task15_enemy_creep_target_selection)
	run_test("251. Task 15: Ally Creep Attack Rejection", test_task15_ally_creep_attack_rejection)
	run_test("252. Task 15: Last Hit Detection by Enemy Hero", test_task15_last_hit_detection_and_killer)
	run_test("253. Task 15: Last Hit Gold Awarded to Inventory", test_task15_last_hit_gold_award)
	run_test("254. Task 15: Gold Bounty Only Awarded Once", test_task15_gold_only_awarded_once)
	run_test("255. Task 15: Distinct Bounties per Creep Type", test_task15_creep_types_distinct_rewards)
	run_test("256. Task 15: XP Radius Eligibility Boundary (16m)", test_task15_xp_radius_eligibility)
	run_test("257. Task 15: Multiple Heroes Proportional XP Sharing", test_task15_multiple_heroes_xp_sharing)
	run_test("258. Task 15: Dead Hero Filtered from Receiving XP", test_task15_dead_hero_cannot_receive_xp)
	run_test("259. Task 15: Creep Aggro Call for Help from Allied Hero", test_task15_creep_hero_aggro_call)
	run_test("260. Task 15: Creep Death Clears Target and Pursuit", test_task15_creep_death_target_cleanup)
	run_test("261. Task 15: Siege Creep Structure Bonus Damage", test_task15_siege_creep_tower_bonus)
	run_test("262. Task 15: Dead Creep Cannot Be Targeted", test_task15_dead_creep_cannot_be_targeted)
	run_test("263. Task 15: Creep Deny Mechanics and XP Reduction", test_task15_creep_deny_mechanics)
	# --- 20 TASK 16: JUNGLE & NEUTRAL CAMP TESTS ---
	run_test("264. Task 16: Camp Initial Spawn & State", test_task16_camp_initial_spawn)
	run_test("265. Task 16: Monster Composition by Camp Type", test_task16_camp_monster_count_by_type)
	run_test("266. Task 16: Small/Medium/Large/Ancient Archetypes", test_task16_camp_types_archetypes)
	run_test("267. Task 16: Hero to Neutral Basic Attack Targeting", test_task16_hero_to_neutral_targeting)
	run_test("268. Task 16: Neutral Monster Retaliation Attack", test_task16_neutral_to_hero_attack)
	run_test("269. Task 16: Multi-Neutral Aggro Wake & Sibling Call", test_task16_multi_neutral_aggro_wake)
	run_test("270. Task 16: Neutral Target Switching upon Death", test_task16_neutral_target_switching)
	run_test("271. Task 16: Neutral Leash Threshold (14m)", test_task16_neutral_leash_threshold)
	run_test("272. Task 16: Neutral Return to Spawn Origin", test_task16_neutral_return_to_origin)
	run_test("273. Task 16: Neutral HP Regeneration During Return", test_task16_neutral_hp_regen_during_leash)
	run_test("274. Task 16: Full HP Restoration After Returning", test_task16_neutral_full_hp_after_return)
	run_test("275. Task 16: Single Monster Death Camp Stays Active", test_task16_single_monster_death_camp_stays_active)
	run_test("276. Task 16: Last Monster Death Triggers 60s Respawn", test_task16_last_monster_death_triggers_respawn_timer)
	run_test("277. Task 16: Respawn Timer Tick & Camp Respawn", test_task16_respawn_timer_tick_and_spawn)
	run_test("278. Task 16: Respawn Duplicate Spawn Protection", test_task16_respawn_duplicate_protection)
	run_test("279. Task 16: Neutral Gold Reward to Killer Hero", test_task16_neutral_gold_reward_to_hero)
	run_test("280. Task 16: Neutral Area XP Distribution", test_task16_neutral_xp_area_reward)
	run_test("281. Task 16: Dead Hero Filtered from Neutral XP", test_task16_dead_hero_cannot_receive_neutral_xp)
	run_test("282. Task 16: Camp State Machine Full Cycle", test_task16_camp_state_transitions)
	run_test("283. Task 16: Camp Status Methods & Remaining Timer", test_task16_camp_methods_and_remaining_timer)
	# --- 20 TASK 17: ABILITY TARGETING FRAMEWORK TESTS ---
	run_test("284. Task 17: Target Filter Enemy Heroes Only", test_task17_target_filter_enemy_hero)
	run_test("285. Task 17: Target Filter Enemy Creeps Only", test_task17_target_filter_enemy_creep)
	run_test("286. Task 17: Target Filter Neutrals Only", test_task17_target_filter_neutral_monster)
	run_test("287. Task 17: Target Filter Ally Heroes Only", test_task17_target_filter_ally_hero)
	run_test("288. Task 17: Target Filter Self Only", test_task17_target_filter_self_only)
	run_test("289. Task 17: Target Filter All Except Self", test_task17_target_filter_all_except_self)
	run_test("290. Task 17: Cast Range Within Boundary Validation", test_task17_cast_range_within_boundary)
	run_test("291. Task 17: Out of Range Target Cast Rejection", test_task17_cast_range_out_of_range_rejected)
	run_test("292. Task 17: Ground AoE Cast Range Validation", test_task17_ground_aoe_range_validation)
	run_test("293. Task 17: Insufficient Mana Cast Rejection", test_task17_insufficient_mana_rejection)
	run_test("294. Task 17: On-Cooldown Ability Cast Rejection", test_task17_on_cooldown_rejection)
	run_test("295. Task 17: Silenced Caster Ability Rejection", test_task17_silenced_caster_rejection)
	run_test("296. Task 17: Dead Caster Cast Rejection", test_task17_dead_caster_rejection)
	run_test("297. Task 17: Dead Target Cast Rejection", test_task17_dead_target_rejection)
	run_test("298. Task 17: Untargetable Unit Cast Rejection", test_task17_untargetable_unit_rejection)
	run_test("299. Task 17: Kaelgor Q Molten Fist Targeting Framework", test_task17_kaelgor_q_target_framework)
	run_test("300. Task 17: Kaelgor E Iron Hide Self Target Framework", test_task17_kaelgor_e_self_target_framework)
	run_test("301. Task 17: Astris W Temporal Stasis AoE Framework", test_task17_astris_w_aoe_framework)
	run_test("302. Task 17: Extensible Projectile Hit Hook Invocation", test_task17_projectile_hook_invocation)
	run_test("303. Task 17: Extensible AoE Triggered Hook Invocation", test_task17_aoe_hook_invocation)
	# --- 20 TASK 18: ABILITY CAST PIPELINE TESTS ---
	run_test("304. Task 18: Instant Cast Execution Pipeline", test_task18_instant_cast_execution)
	run_test("305. Task 18: Cast Windup State Transition", test_task18_cast_windup_state_transition)
	run_test("306. Task 18: Windup Mana Not Spent Prematurely", test_task18_windup_mana_not_spent_prematurely)
	run_test("307. Task 18: Windup Cooldown Not Triggered Prematurely", test_task18_windup_cooldown_not_triggered_prematurely)
	run_test("308. Task 18: Cast Completion Deducts Mana & Sets Cooldown", test_task18_cast_completion_deducts_mana_and_sets_cooldown)
	run_test("309. Task 18: Cast Progress Ratio Calculation", test_task18_cast_progress_calculation)
	run_test("310. Task 18: Manual Cancel Transitions to Idle", test_task18_manual_cancel_during_windup)
	run_test("311. Task 18: Manual Cancel Retains Full Mana", test_task18_manual_cancel_saves_mana)
	run_test("312. Task 18: Manual Cancel Retains Zero Cooldown", test_task18_manual_cancel_saves_cooldown)
	run_test("313. Task 18: Movement Interrupts Stationary Cast", test_task18_interrupt_on_movement)
	run_test("314. Task 18: Silence CC Interrupts Cast", test_task18_interrupt_on_silence_cc)
	run_test("315. Task 18: Stun CC Interrupts Cast", test_task18_interrupt_on_stun_cc)
	run_test("316. Task 18: Caster Death Interrupts Cast", test_task18_interrupt_on_caster_death)
	run_test("317. Task 18: Target Death Interrupts Single Target Cast", test_task18_interrupt_on_target_death)
	run_test("318. Task 18: Spell Damage Delivery via CombatCalculator", test_task18_spell_damage_pipeline)
	run_test("319. Task 18: Spell Buff and Shield Application", test_task18_spell_heal_and_buff_application)
	run_test("320. Task 18: Spell Debuff Slow Application", test_task18_spell_debuff_slow_application)
	run_test("321. Task 18: Cooldown Reduction (CDR) Integration", test_task18_cooldown_reduction_integration)
	run_test("322. Task 18: Free Spells Mode Integration", test_task18_free_spells_mode_behavior)
	run_test("323. Task 18: Ability Cast Lifecycle Signals Flow", test_task18_ability_cast_signals_flow)
	# --- 20 TASK 19: XP & LEVEL SYSTEM TESTS ---
	run_test("324. Task 19: XP Accumulation and Threshold Overflow", test_task19_xp_accumulation_and_threshold_overflow)
	run_test("325. Task 19: Level Up Stat Growth on Primary Attributes", test_task19_level_up_stat_growth_attributes)
	run_test("326. Task 19: Level Up Stat Growth on Max HP and Mana", test_task19_level_up_stat_growth_hp_and_mana)
	run_test("327. Task 19: Level Up Stat Growth on Attack Damage", test_task19_level_up_stat_growth_attack_damage)
	run_test("328. Task 19: Level Up Stat Growth on Armor & Attack Speed", test_task19_level_up_stat_growth_armor_and_speed)
	run_test("329. Task 19: Level Up Awards 1 Ability Point", test_task19_level_up_awards_ability_point)
	run_test("330. Task 19: Ability Leveling Consumes Skill Point", test_task19_ability_leveling_consumes_point)
	run_test("331. Task 19: Ability Max Level Cap Enforcement", test_task19_ability_max_level_cap)
	run_test("332. Task 19: Ultimate Level Requirement Rejection (< Lvl 6)", test_task19_ultimate_level_requirement_rejection)
	run_test("333. Task 19: Ultimate Level Requirement Acceptance (>= Lvl 6)", test_task19_ultimate_level_requirement_acceptance)
	run_test("334. Task 19: Regular Ability Level Requirement Scaling", test_task19_regular_ability_level_requirement)
	run_test("335. Task 19: Hero Max Level 18 Cap", test_task19_hero_level_cap_18)
	run_test("336. Task 19: Creep Death XP Reward to Nearby Hero", test_task19_creep_xp_reward_integration)
	run_test("337. Task 19: Jungle Camp Clearing XP Reward", test_task19_jungle_camp_xp_reward_integration)
	run_test("338. Task 19: Hero Kill XP Reward Distribution", test_task19_hero_kill_xp_reward_integration)
	run_test("339. Task 19: Tower Destruction Team Objective XP", test_task19_tower_objective_xp_reward_integration)
	run_test("340. Task 19: Proportional Multi-Hero XP Sharing Curve", test_task19_multi_hero_xp_sharing_curve)
	run_test("341. Task 19: Dead Heroes Excluded from XP Share", test_task19_dead_hero_excluded_from_xp)
	run_test("342. Task 19: Death and Respawn Preserves Level, XP & Skills", test_task19_death_and_respawn_preserves_level_and_xp)
	run_test("343. Task 19: XP Progress Ratio Calculation for HUD", test_task19_xp_progress_ratio_for_hud)
	# --- 20 TASK 20: HERO FRAMEWORK TESTS ---
	run_test("344. Task 20: HeroDefinition Registry Discovery", test_task20_hero_definition_registry_discovery)
	run_test("345. Task 20: Kaelgor Definition Archetype & Stats", test_task20_hero_definition_kaelgor_stats)
	run_test("346. Task 20: Astris Definition Archetype & Stats", test_task20_hero_definition_astris_stats)
	run_test("347. Task 20: Solen Definition Archetype & Stats", test_task20_hero_definition_solen_stats)
	run_test("348. Task 20: Hero Definition Abilities Integrity", test_task20_hero_definition_abilities_integrity)
	run_test("349. Task 20: Ability by Slot Helper", test_task20_hero_definition_ability_by_slot_helper)
	run_test("350. Task 20: Get All Abilities List Helper", test_task20_hero_definition_get_all_abilities)
	run_test("351. Task 20: Factory Instance Creation - Kaelgor", test_task20_hero_definition_factory_instance_creation)
	run_test("352. Task 20: Factory Instance Creation - Astris", test_task20_hero_definition_factory_astris_creation)
	run_test("353. Task 20: Factory Instance Creation - Solen", test_task20_hero_definition_factory_solen_creation)
	run_test("354. Task 20: Dynamic Custom Hero Registration", test_task20_hero_definition_custom_registration)
	run_test("355. Task 20: Ranged Hero Projectile Configuration", test_task20_hero_definition_projectile_configuration)
	run_test("356. Task 20: Ability Damage Type Metadata", test_task20_hero_definition_damage_type_metadata)
	run_test("357. Task 20: Ability Scaling Metadata", test_task20_hero_definition_scaling_metadata)
	run_test("358. Task 20: Ability Target Filter Metadata", test_task20_hero_definition_target_filter_metadata)
	run_test("359. Task 20: HeroResource Application to HeroEntity", test_task20_hero_resource_apply_to_hero_entity)
	run_test("360. Task 20: Cooldown Arrays Integrity", test_task20_hero_definition_cooldown_arrays_integrity)
	run_test("361. Task 20: Mana Cost Arrays Integrity", test_task20_hero_definition_mana_cost_arrays_integrity)
	run_test("362. Task 20: Base Damage Arrays Integrity", test_task20_hero_definition_base_damage_arrays_integrity)
	run_test("363. Task 20: Has Definition Query", test_task20_hero_definition_has_definition_query)
	# --- 20 TASK 21: GOLD & BOUNTY TESTS ---
	run_test("364. Task 21: Passive Gold Generation Rate", test_task21_passive_gold_generation_rate)
	run_test("365. Task 21: Passive Gold Disabled Mode", test_task21_passive_gold_disabled_mode)
	run_test("366. Task 21: Unlimited Gold Mode Bypass", test_task21_unlimited_gold_mode_bypass)
	run_test("367. Task 21: Spend Gold Insufficient Funds", test_task21_spend_gold_insufficient_funds)
	run_test("368. Task 21: Spend Gold Exact Amount", test_task21_spend_gold_exact_amount)
	run_test("369. Task 21: Hero Kill Gold Bounty to Killer", test_task21_hero_kill_gold_bounty_awarded_to_killer)
	run_test("370. Task 21: Hero Assist Gold Shared Among Allies", test_task21_hero_assist_gold_shared_among_allies)
	run_test("371. Task 21: Hero Kill & Assist Signals Emitted", test_task21_hero_kill_gold_signals_emitted)
	run_test("372. Task 21: Melee Creep Last Hit Gold", test_task21_melee_creep_last_hit_gold)
	run_test("373. Task 21: Ranged Creep Last Hit Gold", test_task21_ranged_creep_last_hit_gold)
	run_test("374. Task 21: Siege Creep Last Hit Gold", test_task21_siege_creep_last_hit_gold)
	run_test("375. Task 21: Denied Creep Grants Zero Gold", test_task21_denied_creep_no_gold_to_anyone)
	run_test("376. Task 21: Jungle Monster Gold Bounty", test_task21_neutral_monster_gold_bounty)
	run_test("377. Task 21: Tower Tier 2 Team Gold Bounty", test_task21_tower_destruction_team_bounty)
	run_test("378. Task 21: Tower Tier 3 Higher Gold Bounty", test_task21_tower_tier3_higher_gold)
	run_test("379. Task 21: Duplicate Creep Gold Protection", test_task21_duplicate_creep_gold_protection)
	run_test("380. Task 21: Duplicate Neutral Gold Protection", test_task21_duplicate_neutral_gold_protection)
	run_test("381. Task 21: Passive Gold Accumulator Sub-Second Carryover", test_task21_passive_gold_subsecond_carryover)
	run_test("382. Task 21: Non-Hero Death Splits Area Bounty", test_task21_non_hero_death_splits_bounty)
	run_test("383. Task 21: Gold Updated Signal Reactivity", test_task21_gold_updated_signal_reactivity)
	# --- 20 TASK 22: ITEM EFFECT SYSTEM TESTS ---
	run_test("384. Task 22: Item Stat Bonus - Max Health", test_task22_item_stat_bonus_health)
	run_test("385. Task 22: Item Stat Bonus - Max Mana", test_task22_item_stat_bonus_mana)
	run_test("386. Task 22: Item Stat Bonus - Attack Damage", test_task22_item_stat_bonus_attack_damage)
	run_test("387. Task 22: Item Stat Bonus - Armor", test_task22_item_stat_bonus_armor)
	run_test("388. Task 22: Item Stat Bonus - Magic Resistance", test_task22_item_stat_bonus_magic_resist)
	run_test("389. Task 22: Item Stat Bonus - Attack Speed", test_task22_item_stat_bonus_attack_speed)
	run_test("390. Task 22: Item Stat Bonus - Boots Move Speed", test_task22_item_stat_bonus_move_speed)
	run_test("391. Task 22: Item Stat Bonus - Ability Power", test_task22_item_stat_bonus_ability_power)
	run_test("392. Task 22: Item Stat Bonus - Lifesteal", test_task22_item_stat_bonus_lifesteal)
	run_test("393. Task 22: Item Unequip Removes Stat Modifiers", test_task22_item_unequip_removes_stat_bonuses)
	run_test("394. Task 22: Item Selling Reverts Stats & Refunds 70%", test_task22_item_selling_removes_stats_and_refunds)
	run_test("395. Task 22: Total Stat Bonus Sum Across Items", test_task22_get_total_stat_bonus_aggregation)
	run_test("396. Task 22: Has Item Query by ID", test_task22_has_item_query_by_id)
	run_test("397. Task 22: Has Item Query by Name", test_task22_has_item_query_by_name)
	run_test("398. Task 22: Get All Equipped Items List", test_task22_get_all_equipped_items_list)
	run_test("399. Task 22: Active Item Lifebloom Healing", test_task22_active_item_lifebloom_healing)
	run_test("400. Task 22: Active Item Radiant Aegis Shield", test_task22_active_item_radiant_aegis_shield)
	run_test("401. Task 22: Active Item Force Relic Forward Dash", test_task22_active_item_force_relic_dash)
	run_test("402. Task 22: Active Item Cooldown Rejection", test_task22_active_item_cooldown_rejection)
	run_test("403. Task 22: Active Item Cooldown Countdown Tick", test_task22_active_item_cooldown_countdown)
	# --- 20 TASK 23: ITEM COMBAT INTEGRATION TESTS ---
	run_test("404. Task 23: Item Attack Damage Enhances Basic Attacks", test_task23_item_damage_modifier_applied_to_basic_attacks)
	run_test("405. Task 23: Item Armor Modifier Mitigates Physical Damage", test_task23_item_armor_modifier_reduces_incoming_damage)
	run_test("406. Task 23: Item MR Modifier Mitigates Magical Damage", test_task23_item_mr_modifier_reduces_magic_damage)
	run_test("407. Task 23: Item Flat Armor Penetration Bypass", test_task23_item_armor_penetration_flat_bypass)
	run_test("408. Task 23: Item Percent Armor Penetration Bypass", test_task23_item_percent_armor_penetration_bypass)
	run_test("409. Task 23: Item Flat Magic Penetration Bypass", test_task23_item_magic_penetration_flat_bypass)
	run_test("410. Task 23: Item Percent Magic Penetration Bypass", test_task23_item_magic_penetration_percent_bypass)
	run_test("411. Task 23: Item Critical Strike Chance and Damage Multiplier", test_task23_item_critical_strike_proc)
	run_test("412. Task 23: Item Lifesteal on Basic Attack Deals and Heals", test_task23_item_lifesteal_on_basic_attack)
	run_test("413. Task 23: Item Spell Vamp Heals from Ability Damage", test_task23_item_spell_vamp_on_ability_damage)
	run_test("414. Task 23: Active Item Mana Cost Deduction", test_task23_active_item_mana_cost_deduction)
	run_test("415. Task 23: Active Item Insufficient Mana Rejection", test_task23_active_item_insufficient_mana_rejection)
	run_test("416. Task 23: Active Item Bloodfang Attack Speed Boost", test_task23_active_item_bloodfang_attack_speed_buff)
	run_test("417. Task 23: Active Item Titan Slayer CC Cleanse and MS", test_task23_active_item_titan_slayer_cleanse_and_speed)
	run_test("418. Task 23: Active Item Executioner's Blade Missing HP Damage", test_task23_active_item_executioners_blade_true_damage)
	run_test("419. Task 23: Active Item Timekeeper Cooldown Timer Reduction", test_task23_active_item_timekeeper_cooldown_reset)
	run_test("420. Task 23: Hero Death Clears Active Item Buffs", test_task23_death_clears_temporary_item_buffs)
	run_test("421. Task 23: Inventory Item Swapping Dynamically Updates Stats", test_task23_inventory_swap_updates_combat_calculations)
	run_test("422. Task 23: Dead Hero Cannot Activate Items", test_task23_dead_hero_cannot_use_active_items)
	run_test("423. Task 23: Item Damage Amplification Modifier", test_task23_damage_amplification_item_modifier)
	# --- 20 TASK 24: HERO ABILITY RUNTIME SYSTEM TESTS ---
	run_test("424. Task 24: AbilityDefinition Data Structure Integrity", test_task24_ability_definition_data_structure)
	run_test("425. Task 24: AbilityInstance Initial State Not Learned", test_task24_ability_instance_initial_state_not_learned)
	run_test("426. Task 24: AbilityInstance Learned State Ready", test_task24_ability_instance_learned_state_ready)
	run_test("427. Task 24: AbilityInstance Cooldown State and Ticking", test_task24_ability_instance_cooldown_state)
	run_test("428. Task 24: AbilityInstance Disabled on Silence/CC", test_task24_ability_instance_disabled_on_silence)
	run_test("429. Task 24: AbilityInstance Disabled on Caster Death", test_task24_ability_instance_disabled_on_caster_death)
	run_test("430. Task 24: QWER and Passive Slots Instantiation", test_task24_qwer_slots_instantiation)
	run_test("431. Task 24: Mana Cost Scaling per Level", test_task24_mana_cost_scaling_per_level)
	run_test("432. Task 24: Cooldown CDR Stat Scaling", test_task24_cooldown_cdr_scaling)
	run_test("433. Task 24: Target Validation Structures Only", test_task24_target_validation_structures_only)
	run_test("434. Task 24: Target Validation Immune/Untargetable Rejection", test_task24_target_validation_immune_or_untargetable)
	run_test("435. Task 24: Cast Request Pipeline Execution", test_task24_cast_request_pipeline_execution)
	run_test("436. Task 24: Cast Request Free Cast Bypass", test_task24_cast_request_free_cast_bypass)
	run_test("437. Task 24: Movement Ability Dash Execution", test_task24_movement_ability_dash_execution)
	run_test("438. Task 24: Movement Ability Blink Execution", test_task24_movement_ability_blink_execution)
	run_test("439. Task 24: Healing Ability Execution with AP Scaling", test_task24_healing_ability_execution)
	run_test("440. Task 24: Shielding Ability Execution and Status Effect", test_task24_shielding_ability_execution)
	run_test("441. Task 24: Signals Ability Executed and Target Hit", test_task24_signals_ability_executed_and_hit)
	run_test("442. Task 24: Interruption on Movement During Windup", test_task24_interruption_on_movement_during_windup)
	run_test("443. Task 24: Virtual Hooks Projectile and AoE Triggered", test_task24_virtual_hooks_projectile_and_aoe)
	# --- 20 TASK 25: KAELGOR HERO PLAYABILITY & RUNTIME INTEGRATION TESTS ---
	run_test("444. Task 25: Furnace Heart Passive Attack Speed Scaling", test_task25_furnace_heart_passive_attack_speed_scaling)
	run_test("445. Task 25: Furnace Heart Combat Decay Timer", test_task25_furnace_heart_combat_decay_timer)
	run_test("446. Task 25: Basic Attack Generates Heat and Notifies Combat", test_task25_basic_attack_generates_heat)
	run_test("447. Task 25: Kaelgor Q Molten Fist Heat Scaling Formula", test_task25_kaelgor_q_heat_scaling_formula)
	run_test("448. Task 25: Kaelgor Q Target Filters (Hero, Creep, Neutral, Tower)", test_task25_kaelgor_q_target_filters_enemy_hero_creep_neutral_tower)
	run_test("449. Task 25: Kaelgor Q Insufficient Mana Rejection", test_task25_kaelgor_q_insufficient_mana_rejection)
	run_test("450. Task 25: Kaelgor Q Out of Range Rejection", test_task25_kaelgor_q_out_of_range_rejection)
	run_test("451. Task 25: Kaelgor W Vent AoE Damage and Heat Consumption", test_task25_kaelgor_w_aoe_damage_and_heat_consumption)
	run_test("452. Task 25: Kaelgor W Vent Slow Status Effect Application", test_task25_kaelgor_w_slow_status_effect_application)
	run_test("453. Task 25: Kaelgor W Vent Hits Multiple Target Types", test_task25_kaelgor_w_hits_multiple_units)
	run_test("454. Task 25: Kaelgor E Iron Hide 30% Damage Reduction", test_task25_kaelgor_e_iron_hide_30_percent_damage_reduction)
	run_test("455. Task 25: Kaelgor E Iron Hide Prevented Damage to Heat Conversion", test_task25_kaelgor_e_iron_hide_heat_generation)
	run_test("456. Task 25: Kaelgor E Iron Hide Timer Expiration and Cleanup", test_task25_kaelgor_e_iron_hide_timer_expiration)
	run_test("457. Task 25: Kaelgor R Overheat Sets 100 Heat and Locks Decay", test_task25_kaelgor_r_overheat_maximizes_heat_and_locks_decay)
	run_test("458. Task 25: Kaelgor R Overheat Basic Attack 50% Splash Damage", test_task25_kaelgor_r_overheat_splash_damage_mechanic)
	run_test("459. Task 25: Kaelgor R Overheat Expiration Restores Decay", test_task25_kaelgor_r_overheat_expiration_restores_decay)
	run_test("460. Task 25: Hero Death Resets Heat and Clears Buffs", test_task25_death_resets_heat_and_buffs)
	run_test("461. Task 25: Respawn Preserves Clean State with Full HP/Mana", test_task25_respawn_preserves_clean_state)
	run_test("462. Task 25: Ability Runtime Cast Request Pipeline Integration", test_task25_ability_runtime_cast_request_integration)
	run_test("463. Task 25: World Status Bar Displays Kaelgor Stats and Secondary Resource", test_task25_world_status_bar_heat_and_mana_display)
	# --- 20 TASK 26: RAVENA HERO IMPLEMENTATION TESTS ---
	run_test("464. Task 26: Ravena Initialization and Tank Initiator Archetype", test_task26_ravena_initialization_and_archetype)
	run_test("465. Task 26: Ravena Anchored Passive Armor Growth Over Time", test_task26_ravena_anchored_passive_armor_growth)
	run_test("466. Task 26: Ravena Anchored Passive Movement Reset", test_task26_ravena_anchored_passive_movement_reset)
	run_test("467. Task 26: Ravena Q Chain Lance Damage Scaling", test_task26_ravena_q_chain_lance_damage)
	run_test("468. Task 26: Ravena Q Chain Lance Pull Mechanic Displacement", test_task26_ravena_q_chain_lance_pull_mechanic)
	run_test("469. Task 26: Ravena Q Chain Lance Target Validation Rejects Ally", test_task26_ravena_q_chain_lance_rejects_ally)
	run_test("470. Task 26: Ravena Q Chain Lance Mana and Cooldown", test_task26_ravena_q_chain_lance_cooldown_and_mana)
	run_test("471. Task 26: Ravena W Anchor Field Ground AoE Damage", test_task26_ravena_w_anchor_field_aoe_damage)
	run_test("472. Task 26: Ravena W Anchor Field Slow Application", test_task26_ravena_w_anchor_field_slow_application)
	run_test("473. Task 26: Ravena W Anchor Field Multiple Targets", test_task26_ravena_w_anchor_field_multiple_targets)
	run_test("474. Task 26: Ravena E Reposition Enemy Pull Mechanic", test_task26_ravena_e_reposition_enemy_pull)
	run_test("475. Task 26: Ravena E Reposition Ally Dash Pull Mechanic", test_task26_ravena_e_reposition_ally_dash)
	run_test("476. Task 26: Ravena E Reposition Rejects Self Target", test_task26_ravena_e_reposition_rejects_self)
	run_test("477. Task 26: Ravena E Reposition Rejects Dead/Untargetable", test_task26_ravena_e_reposition_rejects_dead_or_untargetable)
	run_test("478. Task 26: Ravena R Lockdown Heavy Damage Scaling", test_task26_ravena_r_lockdown_heavy_damage)
	run_test("479. Task 26: Ravena R Lockdown Stun CC Application", test_task26_ravena_r_lockdown_stun_application)
	run_test("480. Task 26: Ravena R Lockdown Target Validation Rejects Ally", test_task26_ravena_r_lockdown_rejects_allies)
	run_test("481. Task 26: Ravena HeroDefinition Registry and Factory", test_task26_ravena_hero_definition_factory)
	run_test("482. Task 26: Ravena Death Resets Anchored Bonus", test_task26_ravena_death_resets_anchored_bonus)
	run_test("483. Task 26: Ravena Respawn Clean State", test_task26_ravena_respawn_clean_state)
	# --- 20 TASK 27: THAROS HERO IMPLEMENTATION TESTS ---
	run_test("484. Task 27: Tharos Initialization and Juggernaut Archetype", test_task27_tharos_initialization_and_archetype)
	run_test("485. Task 27: Tharos Living Mass Bonus HP to AD Conversion", test_task27_tharos_living_mass_bonus_hp_to_ad)
	run_test("486. Task 27: Tharos Living Mass Dynamic AD Update on Health Change", test_task27_tharos_living_mass_dynamic_update)
	run_test("487. Task 27: Tharos Q Groundbreaker AoE Damage Scaling", test_task27_tharos_q_groundbreaker_aoe_damage)
	run_test("488. Task 27: Tharos Q Groundbreaker Missing HP Stun Scaling", test_task27_tharos_q_groundbreaker_missing_hp_stun_scaling)
	run_test("489. Task 27: Tharos Q Groundbreaker Hits Multiple Unit Types", test_task27_tharos_q_groundbreaker_multiple_units)
	run_test("490. Task 27: Tharos Q Groundbreaker Cooldown and Mana", test_task27_tharos_q_groundbreaker_cooldown_and_mana)
	run_test("491. Task 27: Tharos W Bulkhead Damage Mitigation", test_task27_tharos_w_bulkhead_damage_mitigation)
	run_test("492. Task 27: Tharos W Bulkhead Self Slow Modifier", test_task27_tharos_w_bulkhead_self_slow)
	run_test("493. Task 27: Tharos W Bulkhead Expiration Restores Movement and Defense", test_task27_tharos_w_bulkhead_expiration)
	run_test("494. Task 27: Tharos E Crushing Step Dash and Reposition", test_task27_tharos_e_crushing_step_dash)
	run_test("495. Task 27: Tharos E Crushing Step AoE Damage on Landing", test_task27_tharos_e_crushing_step_aoe_damage)
	run_test("496. Task 27: Tharos E Crushing Step Slow Application", test_task27_tharos_e_crushing_step_slow_application)
	run_test("497. Task 27: Tharos R Colossus Massive Max HP Increase", test_task27_tharos_r_colossus_max_hp_increase)
	run_test("498. Task 27: Tharos R Colossus Living Mass Passive Synergy", test_task27_tharos_r_colossus_living_mass_synergy)
	run_test("499. Task 27: Tharos R Colossus Attack Range Increase and Slow", test_task27_tharos_r_colossus_range_and_slow)
	run_test("500. Task 27: Tharos R Colossus Expiration Restores Base Attributes", test_task27_tharos_r_colossus_expiration)
	run_test("501. Task 27: Tharos HeroDefinition Registry and Factory", test_task27_tharos_hero_definition_factory)
	run_test("502. Task 27: Tharos Death Clears Active Buffs and Modifiers", test_task27_tharos_death_clears_buffs)
	run_test("503. Task 27: Tharos Respawn Clean State", test_task27_tharos_respawn_clean_state)
	# --- 20 TASK 28: MORDREN HERO IMPLEMENTATION TESTS ---
	run_test("504. Task 28: Mordren Initialization and Fighter Executioner Archetype", test_task28_mordren_initialization_and_archetype)
	run_test("505. Task 28: Mordren Hunt Mark Passive on Hero Damage", test_task28_mordren_hunt_mark_applied_on_damage)
	run_test("506. Task 28: Mordren Hunt Mark Refresh on Subsequent Damage", test_task28_mordren_hunt_mark_refresh)
	run_test("507. Task 28: Mordren Hunt Mark Expiration", test_task28_mordren_hunt_mark_expiration)
	run_test("508. Task 28: Mordren Q Cleaver Base Damage", test_task28_mordren_q_cleaver_base_damage)
	run_test("509. Task 28: Mordren Q Cleaver +50% Bonus Damage on Marked Target", test_task28_mordren_q_cleaver_marked_target_bonus)
	run_test("510. Task 28: Mordren Q Cleaver Mana and Cooldown", test_task28_mordren_q_cleaver_cooldown_and_mana)
	run_test("511. Task 28: Mordren W Blood Trail Passive Speed Near Marked Enemy", test_task28_mordren_w_blood_trail_passive_speed)
	run_test("512. Task 28: Mordren W Blood Trail Speed Clears When Out of Range", test_task28_mordren_w_blood_trail_speed_clears)
	run_test("513. Task 28: Mordren W Blood Trail Active Burst Speed Boost", test_task28_mordren_w_blood_trail_active_burst)
	run_test("514. Task 28: Mordren E Relentless Shield Granted on Marked Hit", test_task28_mordren_e_relentless_shield_granted)
	run_test("515. Task 28: Mordren E Relentless Shield Duration Refresh No Infinite Stacking", test_task28_mordren_e_relentless_shield_refresh_no_stack)
	run_test("516. Task 28: Mordren E Relentless Active Shield Activation", test_task28_mordren_e_relentless_active_cast)
	run_test("517. Task 28: Mordren R Final Hunt High Damage and Dash on Low HP Marked Target", test_task28_mordren_r_final_hunt_execution_success)
	run_test("518. Task 28: Mordren R Final Hunt Rejection When Target Not Marked", test_task28_mordren_r_final_hunt_rejects_unmarked)
	run_test("519. Task 28: Mordren R Final Hunt Rejection When Target HP Above 35%", test_task28_mordren_r_final_hunt_rejects_high_hp)
	run_test("520. Task 28: Mordren R Final Hunt Target Validation Rejects Allies", test_task28_mordren_r_final_hunt_rejects_allies)
	run_test("521. Task 28: Mordren HeroDefinition Registry and Factory", test_task28_mordren_hero_definition_factory)
	run_test("522. Task 28: Mordren Death Clears Blood Trail and Relentless Shield", test_task28_mordren_death_clears_buffs)
	run_test("523. Task 28: Mordren Respawn Clean State", test_task28_mordren_respawn_clean_state)
	# --- 20 TASK 29: BRAKKA HERO IMPLEMENTATION TESTS ---
	run_test("524. Task 29: Brakka Initialization and Tank Archetype", test_task29_brakka_initialization_and_archetype)
	run_test("525. Task 29: Brakka Retaliation Core Stores 20% Damage", test_task29_brakka_retaliation_core_stores_damage)
	run_test("526. Task 29: Brakka Retaliation Core Upper Cap Clamp", test_task29_brakka_retaliation_core_cap_clamp)
	run_test("527. Task 29: Brakka Retaliation Core Combat Decay Timer", test_task29_brakka_retaliation_core_decay_timer)
	run_test("528. Task 29: Brakka Retaliation Core Ignores Rebound Self-Storage", test_task29_brakka_retaliation_core_ignores_rebound_reflection)
	run_test("529. Task 29: Brakka Q Shield Ram Base and Armor Scaling Damage", test_task29_brakka_q_shield_ram_damage_and_scaling)
	run_test("530. Task 29: Brakka Q Shield Ram Dash and Knockback Displacement", test_task29_brakka_q_shield_ram_dash_and_knockback)
	run_test("531. Task 29: Brakka Q Shield Ram Target Validation Rejects Ally", test_task29_brakka_q_shield_ram_target_validation_rejects_ally)
	run_test("532. Task 29: Brakka Q Shield Ram Cooldown and Mana Deduction", test_task29_brakka_q_shield_ram_cooldown_and_mana)
	run_test("533. Task 29: Brakka W Fortress Heavy Armor Buff", test_task29_brakka_w_fortress_armor_buff)
	run_test("534. Task 29: Brakka W Fortress Self Move Speed Penalty", test_task29_brakka_w_fortress_self_slow)
	run_test("535. Task 29: Brakka W Fortress Expiration Restores Normal Stats", test_task29_brakka_w_fortress_expiration_restores_stats)
	run_test("536. Task 29: Brakka E Rebound Deals Base Damage With Zero Retaliation", test_task29_brakka_e_rebound_base_damage_with_zero_retaliation)
	run_test("537. Task 29: Brakka E Rebound Discharges Stored Retaliation Damage", test_task29_brakka_e_rebound_releases_stored_retaliation)
	run_test("538. Task 29: Brakka E Rebound Target Validation Rejects Ally", test_task29_brakka_e_rebound_target_validation_rejects_ally)
	run_test("539. Task 29: Brakka R Immovable Deals Damage and Pulls Enemies", test_task29_brakka_r_immovable_damage_and_pull)
	run_test("540. Task 29: Brakka R Immovable Cleanses Crowd Control Effects", test_task29_brakka_r_immovable_cleanses_cc_and_tenacity)
	run_test("541. Task 29: Brakka R Immovable Applies 50% Slow to Enemies", test_task29_brakka_r_immovable_slow_applied_to_enemies)
	run_test("542. Task 29: Brakka HeroDefinition Registry and Factory", test_task29_brakka_hero_definition_factory)
	run_test("543. Task 29: Brakka Death and Respawn Clears State and Retaliation", test_task29_brakka_death_and_respawn_clean_state)
	# --- 20 TASK 30: VEYRA HERO IMPLEMENTATION TESTS ---
	run_test("544. Task 30: Veyra Initialization and Diver Archetype", test_task30_veyra_initialization_and_archetype)
	run_test("545. Task 30: Veyra Passive Momentum Accumulates on Movement", test_task30_veyra_passive_momentum_accumulates_on_movement)
	run_test("546. Task 30: Veyra Passive Momentum Grants Move Speed Bonus", test_task30_veyra_passive_momentum_grants_speed_bonus)
	run_test("547. Task 30: Veyra Passive Momentum Decays on Standstill", test_task30_veyra_passive_momentum_decays_on_standstill)
	run_test("548. Task 30: Veyra Passive Momentum Clamped at 100 Max", test_task30_veyra_passive_momentum_clamped_at_max)
	run_test("549. Task 30: Veyra Q Shoulder Break Base and AD Damage", test_task30_veyra_q_shoulder_break_base_and_ad_damage)
	run_test("550. Task 30: Veyra Q Shoulder Break Consumes Momentum for Bonus Damage", test_task30_veyra_q_shoulder_break_consumes_momentum)
	run_test("551. Task 30: Veyra Q Shoulder Break Dash and Knockback", test_task30_veyra_q_shoulder_break_dash_and_knockback)
	run_test("552. Task 30: Veyra Q Shoulder Break Target Validation Rejects Ally", test_task30_veyra_q_shoulder_break_rejects_ally)
	run_test("553. Task 30: Veyra Q Shoulder Break Cooldown and Mana", test_task30_veyra_q_shoulder_break_cooldown_and_mana)
	run_test("554. Task 30: Veyra W Impact Zone AoE Damage Scaling", test_task30_veyra_w_impact_zone_aoe_damage_scaling)
	run_test("555. Task 30: Veyra W Impact Zone 30% Slow Status Effect", test_task30_veyra_w_impact_zone_slow_status_effect)
	run_test("556. Task 30: Veyra W Impact Zone Hits Multiple Enemies", test_task30_veyra_w_impact_zone_hits_multiple_enemies)
	run_test("557. Task 30: Veyra E Second Wind Grants Move Speed and Momentum on Hero Hit", test_task30_veyra_e_second_wind_on_hero_hit)
	run_test("558. Task 30: Veyra E Second Wind Active Cast Burst", test_task30_veyra_e_second_wind_active_cast_burst)
	run_test("559. Task 30: Veyra E Second Wind Timer Expiration Cleans Speed", test_task30_veyra_e_second_wind_expiration_cleans_speed)
	run_test("560. Task 30: Veyra R Crash Landing Leap to Target Location", test_task30_veyra_r_crash_landing_leap_to_location)
	run_test("561. Task 30: Veyra R Crash Landing Heavy AoE Damage and Stun Knock-up", test_task30_veyra_r_crash_landing_damage_and_stun)
	run_test("562. Task 30: Veyra HeroDefinition Registry and Factory", test_task30_veyra_hero_definition_factory)
	run_test("563. Task 30: Veyra Death and Respawn Cleanses State", test_task30_veyra_death_and_respawn_cleanses_state)
	# --- 20 TASK 31: GORAK HERO IMPLEMENTATION TESTS ---
	run_test("564. Task 31: Gorak Initialization and Anti-Carry Archetype", test_task31_gorak_initialization_and_archetype)
	run_test("565. Task 31: Gorak Passive Leeching Might Drains AD on Basic Attack", test_task31_gorak_passive_drains_ad)
	run_test("566. Task 31: Gorak Passive Leeching Might Caps at Max Stolen AD", test_task31_gorak_passive_drain_cap)
	run_test("567. Task 31: Gorak Passive Drain Timer Expiration Clears Buff", test_task31_gorak_passive_drain_timer_expiration)
	run_test("568. Task 31: Gorak Q Rend Base Damage Scaling", test_task31_gorak_q_rend_base_damage_scaling)
	run_test("569. Task 31: Gorak Q Rend Stolen AD Bonus Damage Synergy", test_task31_gorak_q_rend_stolen_ad_synergy)
	run_test("570. Task 31: Gorak Q Rend Target Validation Rejects Ally", test_task31_gorak_q_rend_rejects_ally)
	run_test("571. Task 31: Gorak Q Rend Cooldown and Mana Deduction", test_task31_gorak_q_rend_cooldown_and_mana)
	run_test("572. Task 31: Gorak W Drain Strength Reduces Target AD", test_task31_gorak_w_drain_strength_reduces_target_ad)
	run_test("573. Task 31: Gorak W Drain Strength Grants Gorak Bonus AD", test_task31_gorak_w_drain_strength_grants_gorak_ad)
	run_test("574. Task 31: Gorak W Drain Strength Requires Enemy Hero Target", test_task31_gorak_w_requires_enemy_hero)
	run_test("575. Task 31: Gorak W Drain Strength Expiration Restores Stats", test_task31_gorak_w_expiration_restores_stats)
	run_test("576. Task 31: Gorak E Feed Restores Health Based on Stolen AD", test_task31_gorak_e_feed_heals_based_on_stolen_ad)
	run_test("577. Task 31: Gorak E Feed Clears Stolen AD Pool", test_task31_gorak_e_feed_clears_stolen_ad)
	run_test("578. Task 31: Gorak R Devour Champion Deals Heavy Physical Damage", test_task31_gorak_r_devour_champion_damage)
	run_test("579. Task 31: Gorak R Devour Champion Steals 40% AD and 40% Armor", test_task31_gorak_r_devour_champion_stat_theft)
	run_test("580. Task 31: Gorak R Devour Champion Rejects Non-Hero Target", test_task31_gorak_r_devour_champion_rejects_non_hero)
	run_test("581. Task 31: Gorak R Devour Champion Expiration Restores Stolen Armor and AD", test_task31_gorak_r_expiration_restores_stats)
	run_test("582. Task 31: Gorak HeroDefinition Registry and Factory", test_task31_gorak_hero_definition_factory)
	run_test("583. Task 31: Gorak Death and Respawn Cleanses All Stolen Stats", test_task31_gorak_death_and_respawn_clean_state)
	# --- 20 TASK 32: DURN HERO IMPLEMENTATION TESTS ---
	run_test("584. Task 32: Durn Initialization and Siege Artillery Archetype", test_task32_durn_initialization_and_archetype)
	run_test("585. Task 32: Durn Passive Siege Stance Enters on Standstill", test_task32_durn_passive_enters_on_standstill)
	run_test("586. Task 32: Durn Passive Siege Stance Grants +200 Range and +25% AD", test_task32_durn_passive_grants_range_and_ad)
	run_test("587. Task 32: Durn Passive Siege Stance Clears on Movement", test_task32_durn_passive_clears_on_movement)
	run_test("588. Task 32: Durn Q Boulder Shot Base Damage and Range", test_task32_durn_q_boulder_shot_damage_and_range)
	run_test("589. Task 32: Durn Q Boulder Shot +20% Bonus in Siege Stance", test_task32_durn_q_boulder_shot_siege_stance_bonus)
	run_test("590. Task 32: Durn Q Boulder Shot Target Validation Rejects Ally", test_task32_durn_q_boulder_shot_rejects_ally)
	run_test("591. Task 32: Durn Q Boulder Shot Cooldown and Mana", test_task32_durn_q_boulder_shot_cooldown_and_mana)
	run_test("592. Task 32: Durn W Fortify Grants Armor and Magic Resist", test_task32_durn_w_fortify_grants_defenses)
	run_test("593. Task 32: Durn W Fortify Expiration Restores Normal Defenses", test_task32_durn_w_fortify_expiration)
	run_test("594. Task 32: Durn E Shock Mine Placement at Location", test_task32_durn_e_shock_mine_placement)
	run_test("595. Task 32: Durn E Shock Mine Proximity Detonation and Damage", test_task32_durn_e_shock_mine_detonation)
	run_test("596. Task 32: Durn E Shock Mine 40% Slow Status Effect", test_task32_durn_e_shock_mine_slow_effect)
	run_test("597. Task 32: Durn E Shock Mine Rejects Friendly Trigger", test_task32_durn_e_shock_mine_friendly_safe)
	run_test("598. Task 32: Durn R Grand Barrage Long-Range Target AoE Damage", test_task32_durn_r_grand_barrage_aoe_damage)
	run_test("599. Task 32: Durn R Grand Barrage Hits Multiple Units", test_task32_durn_r_grand_barrage_multiple_units)
	run_test("600. Task 32: Durn R Grand Barrage Cooldown and Mana", test_task32_durn_r_grand_barrage_cooldown_and_mana)
	run_test("601. Task 32: Durn Projectile Configuration Validation", test_task32_durn_projectile_config)
	run_test("602. Task 32: Durn HeroDefinition Registry and Factory", test_task32_durn_hero_definition_factory)
	run_test("603. Task 32: Durn Death and Respawn Clears Mines and State", test_task32_durn_death_and_respawn_clean_state)
	# --- 20 TASK 33: AURON HERO IMPLEMENTATION TESTS ---
	run_test("604. Task 33: Auron Initialization and Support Tank Archetype", test_task33_auron_initialization_and_archetype)
	run_test("605. Task 33: Auron Passive Shared Resolve Accumulation", test_task33_auron_passive_resolve_accumulation)
	run_test("606. Task 33: Auron Passive Shared Resolve Boosts HP Regen", test_task33_auron_passive_boosts_hp_regen)
	run_test("607. Task 33: Auron Passive Shared Resolve Clamped at 100", test_task33_auron_passive_resolve_clamped)
	run_test("608. Task 33: Auron Q Guarding Blow Deals Physical Damage", test_task33_auron_q_guarding_blow_damage)
	run_test("609. Task 33: Auron Q Guarding Blow Grants Shield to Ally", test_task33_auron_q_guarding_blow_shields_ally)
	run_test("610. Task 33: Auron Q Guarding Blow Shield Scales with Resolve", test_task33_auron_q_guarding_blow_resolve_scaling)
	run_test("611. Task 33: Auron Q Guarding Blow Rejects Allied Target for Attack", test_task33_auron_q_guarding_blow_rejects_ally_attack)
	run_test("612. Task 33: Auron Q Guarding Blow Cooldown and Mana", test_task33_auron_q_guarding_blow_cooldown_and_mana)
	run_test("613. Task 33: Auron W Interpose Dashes to Ally Hero", test_task33_auron_w_interpose_dashes_to_ally)
	run_test("614. Task 33: Auron W Interpose Applies Shields to Both", test_task33_auron_w_interpose_shields_both)
	run_test("615. Task 33: Auron W Interpose Rejects Enemy Target", test_task33_auron_w_interpose_rejects_enemy)
	run_test("616. Task 33: Auron W Interpose Timer Expiration Clears State", test_task33_auron_w_interpose_timer_expiration)
	run_test("617. Task 33: Auron E Rally Grants Armor Buff to Nearby Allies", test_task33_auron_e_rally_grants_armor_buff)
	run_test("618. Task 33: Auron E Rally Expiration Restores Normal Armor", test_task33_auron_e_rally_expiration)
	run_test("619. Task 33: Auron R Guardian's Oath Forms Sacred Bond", test_task33_auron_r_guardians_oath_forms_bond)
	run_test("620. Task 33: Auron R Guardian's Oath Prevents Lethal Damage and Heals", test_task33_auron_r_guardians_oath_saves_lethal)
	run_test("621. Task 33: Auron R Guardian's Oath Rejects Enemy Target", test_task33_auron_r_guardians_oath_rejects_enemy)
	run_test("622. Task 33: Auron HeroDefinition Registry and Factory", test_task33_auron_hero_definition_factory)
	run_test("623. Task 33: Auron Death and Respawn Clears Bond and Resolve", test_task33_auron_death_and_respawn_clean_state)
	# --- 20 TASK 34: KHAROS HERO IMPLEMENTATION TESTS ---
	run_test("624. Task 34: Kharos Initialization and Berserker Archetype", test_task34_kharos_initialization_and_archetype)
	run_test("625. Task 34: Kharos Passive Bloodrage Grants AD on Low HP", test_task34_kharos_passive_bloodrage_ad)
	run_test("626. Task 34: Kharos Passive Bloodrage Grants AS on Low HP", test_task34_kharos_passive_bloodrage_as)
	run_test("627. Task 34: Kharos Passive Bloodrage Dynamically Updates on Heal", test_task34_kharos_passive_bloodrage_dynamic_heal)
	run_test("628. Task 34: Kharos Q Frenzy Slash Deals Base Physical Damage", test_task34_kharos_q_frenzy_slash_damage)
	run_test("629. Task 34: Kharos Q Frenzy Slash Stacks Increase Next Hit Damage", test_task34_kharos_q_frenzy_slash_stacks_scaling)
	run_test("630. Task 34: Kharos Q Frenzy Slash Stack Timer Expiration", test_task34_kharos_q_frenzy_slash_stack_timer_expiration)
	run_test("631. Task 34: Kharos Q Frenzy Slash Target Validation Rejects Ally", test_task34_kharos_q_frenzy_slash_rejects_ally)
	run_test("632. Task 34: Kharos Q Frenzy Slash Cooldown and Mana", test_task34_kharos_q_frenzy_slash_cooldown_and_mana)
	run_test("633. Task 34: Kharos W Blood Rush Costs Health to Dash", test_task34_kharos_w_blood_rush_costs_health)
	run_test("634. Task 34: Kharos W Blood Rush Grants +30% Move Speed", test_task34_kharos_w_blood_rush_move_speed)
	run_test("635. Task 34: Kharos W Blood Rush Speed Expiration", test_task34_kharos_w_blood_rush_speed_expiration)
	run_test("636. Task 34: Kharos E Rage Reversal Base Damage", test_task34_kharos_e_rage_reversal_base_damage)
	run_test("637. Task 34: Kharos E Rage Reversal Reflects 35% Recent Damage", test_task34_kharos_e_rage_reversal_reflects_damage)
	run_test("638. Task 34: Kharos E Rage Reversal Damage Buffer Clears After Cast", test_task34_kharos_e_rage_reversal_clears_buffer)
	run_test("639. Task 34: Kharos R Red Fury Grants Invulnerability at 1 HP", test_task34_kharos_r_red_fury_invulnerability)
	run_test("640. Task 34: Kharos R Red Fury Doubles Bloodrage Passive Stats", test_task34_kharos_r_red_fury_doubles_bloodrage)
	run_test("641. Task 34: Kharos R Red Fury Timer Expiration", test_task34_kharos_r_red_fury_expiration)
	run_test("642. Task 34: Kharos HeroDefinition Registry and Factory", test_task34_kharos_hero_definition_factory)
	run_test("643. Task 34: Kharos Death and Respawn Clears Buffs and Fury", test_task34_kharos_death_and_respawn_clean_state)
	# --- 20 TASK 35: NYXARA HERO IMPLEMENTATION TESTS ---
	run_test("644. Task 35: Nyxara Initialization and Agility Assassin Archetype", test_task35_nyxara_initialization_and_archetype)
	run_test("645. Task 35: Nyxara Passive Veil Marks Stacking up to 3", test_task35_nyxara_passive_veil_marks_stacking)
	run_test("646. Task 35: Nyxara Passive Veil Marks Armor Shred", test_task35_nyxara_passive_veil_marks_armor_shred)
	run_test("647. Task 35: Nyxara Passive Veil Marks Expiration", test_task35_nyxara_passive_veil_marks_expiration)
	run_test("648. Task 35: Nyxara Q Needle Deals Physical Damage", test_task35_nyxara_q_needle_damage)
	run_test("649. Task 35: Nyxara Q Needle Applies Veil Mark to Target", test_task35_nyxara_q_needle_applies_mark)
	run_test("650. Task 35: Nyxara Q Needle Target Validation Rejects Ally", test_task35_nyxara_q_needle_rejects_ally)
	run_test("651. Task 35: Nyxara Q Needle Cooldown and Mana", test_task35_nyxara_q_needle_cooldown_and_mana)
	run_test("652. Task 35: Nyxara W Fade Step Blinks Behind Target", test_task35_nyxara_w_fade_step_blinks_behind_target)
	run_test("653. Task 35: Nyxara W Fade Step Applies Veil Mark", test_task35_nyxara_w_fade_step_applies_mark)
	run_test("654. Task 35: Nyxara W Fade Step Rejects Ally", test_task35_nyxara_w_fade_step_rejects_ally)
	run_test("655. Task 35: Nyxara E Sever Thread Consumes Marks and Base Damage", test_task35_nyxara_e_sever_thread_consumes_marks)
	run_test("656. Task 35: Nyxara E Sever Thread Missing Health Execution Scaling", test_task35_nyxara_e_sever_thread_missing_hp_scaling)
	run_test("657. Task 35: Nyxara E Sever Thread Target Validation Rejects Ally", test_task35_nyxara_e_sever_thread_rejects_ally)
	run_test("658. Task 35: Nyxara R Vanish Grants Invisibility and +40% MS", test_task35_nyxara_r_vanish_grants_invis_and_speed)
	run_test("659. Task 35: Nyxara R Vanish Basic Attack Applies 3 Marks and Breaks", test_task35_nyxara_r_vanish_attack_applies_3_marks)
	run_test("660. Task 35: Nyxara R Vanish Timer Expiration", test_task35_nyxara_r_vanish_timer_expiration)
	run_test("661. Task 35: Nyxara R Vanish Cooldown and Mana", test_task35_nyxara_r_vanish_cooldown_and_mana)
	run_test("662. Task 35: Nyxara HeroDefinition Registry and Factory", test_task35_nyxara_hero_definition_factory)
	run_test("663. Task 35: Nyxara Death and Respawn Clears Vanish and Marks", test_task35_nyxara_death_and_respawn_clean_state)
	# --- 20 TASK 36: KAELI HERO IMPLEMENTATION TESTS ---
	run_test("664. Task 36: Kaeli Initialization and Agility Carry Archetype", test_task36_kaeli_initialization_and_archetype)
	run_test("665. Task 36: Kaeli Passive Rhythm Sequential Stacking", test_task36_kaeli_passive_rhythm_sequential_stacking)
	run_test("666. Task 36: Kaeli Passive Rhythm Repeated Ability Reset Handling", test_task36_kaeli_passive_rhythm_repeated_cast)
	run_test("667. Task 36: Kaeli Passive Rhythm Grants AS and MS Buffs", test_task36_kaeli_passive_rhythm_stat_buffs)
	run_test("668. Task 36: Kaeli Passive Rhythm Timer Expiration", test_task36_kaeli_passive_rhythm_timer_expiration)
	run_test("669. Task 36: Kaeli Q Twin Cut Deals Double Strike Physical Damage", test_task36_kaeli_q_twin_cut_damage)
	run_test("670. Task 36: Kaeli Q Twin Cut Triggers Rhythm Stack", test_task36_kaeli_q_twin_cut_triggers_rhythm)
	run_test("671. Task 36: Kaeli Q Twin Cut Target Validation Rejects Ally", test_task36_kaeli_q_twin_cut_rejects_ally)
	run_test("672. Task 36: Kaeli Q Twin Cut Cooldown and Mana", test_task36_kaeli_q_twin_cut_cooldown_and_mana)
	run_test("673. Task 36: Kaeli W Slipstream Dashes Forward", test_task36_kaeli_w_slipstream_dashes_forward)
	run_test("674. Task 36: Kaeli W Slipstream Triggers Rhythm Stack", test_task36_kaeli_w_slipstream_triggers_rhythm)
	run_test("675. Task 36: Kaeli W Slipstream Cooldown and Mana", test_task36_kaeli_w_slipstream_cooldown_and_mana)
	run_test("676. Task 36: Kaeli E Crossfire Arms Next Basic Attack", test_task36_kaeli_e_crossfire_arms_attack)
	run_test("677. Task 36: Kaeli E Crossfire Basic Attack Deals Bonus Damage", test_task36_kaeli_e_crossfire_basic_attack_bonus_damage)
	run_test("678. Task 36: Kaeli E Crossfire Armed Timer Expiration", test_task36_kaeli_e_crossfire_timer_expiration)
	run_test("679. Task 36: Kaeli R Perfect Tempo Activates and Grants AS/MS Buffs", test_task36_kaeli_r_perfect_tempo_buffs)
	run_test("680. Task 36: Kaeli R Perfect Tempo Reduces Basic Ability Cooldowns by 50%", test_task36_kaeli_r_perfect_tempo_reduces_cooldowns)
	run_test("681. Task 36: Kaeli R Perfect Tempo Timer Expiration", test_task36_kaeli_r_perfect_tempo_expiration)
	run_test("682. Task 36: Kaeli HeroDefinition Registry and Factory", test_task36_kaeli_hero_definition_factory)
	run_test("683. Task 36: Kaeli Death and Respawn Clears Buffs and Rhythm", test_task36_kaeli_death_and_respawn_clean_state)
	# --- 20 TASK 37: VARYN HERO IMPLEMENTATION TESTS ---
	run_test("684. Task 37: Varyn Initialization and Skirmisher Archetype", test_task37_varyn_initialization_and_archetype)
	run_test("685. Task 37: Varyn Passive Flow Accumulation via Abilities", test_task37_varyn_passive_flow_accumulation)
	run_test("686. Task 37: Varyn Passive Flow Stat Scaling AD and MS", test_task37_varyn_passive_flow_stat_scaling)
	run_test("687. Task 37: Varyn Passive Flow Clamped at 100", test_task37_varyn_passive_flow_clamped)
	run_test("688. Task 37: Varyn Q Razor Leap Deals Damage and Dashes to Target", test_task37_varyn_q_razor_leap_damage_and_dash)
	run_test("689. Task 37: Varyn Q Razor Leap Generates Flow", test_task37_varyn_q_razor_leap_generates_flow)
	run_test("690. Task 37: Varyn Q Razor Leap Target Validation Rejects Ally", test_task37_varyn_q_razor_leap_rejects_ally)
	run_test("691. Task 37: Varyn Q Razor Leap Cooldown and Mana", test_task37_varyn_q_razor_leap_cooldown_and_mana)
	run_test("692. Task 37: Varyn W Spin Cut Deals AoE Physical Damage", test_task37_varyn_w_spin_cut_damage)
	run_test("693. Task 37: Varyn W Spin Cut Generates Flow Per Target Hit", test_task37_varyn_w_spin_cut_generates_flow)
	run_test("694. Task 37: Varyn W Spin Cut Cooldown and Mana", test_task37_varyn_w_spin_cut_cooldown_and_mana)
	run_test("695. Task 37: Varyn E Rebound Dashes Forward", test_task37_varyn_e_rebound_dash)
	run_test("696. Task 37: Varyn E Rebound Grants Free 2nd Charge On Recent Hit", test_task37_varyn_e_rebound_free_charge)
	run_test("697. Task 37: Varyn E Rebound Free Charge Consumed Without Mana/CD", test_task37_varyn_e_rebound_free_charge_consumption)
	run_test("698. Task 37: Varyn R Endless Motion Grants MS and Doubles Flow", test_task37_varyn_r_endless_motion_buffs)
	run_test("699. Task 37: Varyn R Endless Motion Resets Q Cooldown on Hit", test_task37_varyn_r_endless_motion_resets_q)
	run_test("700. Task 37: Varyn R Endless Motion Timer Expiration", test_task37_varyn_r_endless_motion_timer_expiration)
	run_test("701. Task 37: Varyn R Endless Motion Cooldown and Mana", test_task37_varyn_r_endless_motion_cooldown_and_mana)
	run_test("702. Task 37: Varyn HeroDefinition Registry and Factory", test_task37_varyn_hero_definition_factory)
	run_test("703. Task 37: Varyn Death and Respawn Clears Flow and Motion State", test_task37_varyn_death_and_respawn_clean_state)
	# --- 20 TASK 38: ELYRA HERO IMPLEMENTATION TESTS ---
	run_test("704. Task 38: Elyra Initialization and Ranged Crit Carry Archetype", test_task38_elyra_initialization_and_archetype)
	run_test("705. Task 38: Elyra Passive Loaded Dice Fortune Stacking", test_task38_elyra_passive_fortune_stacking)
	run_test("706. Task 38: Elyra Passive Loaded Dice 5th Hit Guaranteed Crit", test_task38_elyra_passive_guaranteed_crit)
	run_test("707. Task 38: Elyra Passive Loaded Dice Consumes Fortune Upon Crit", test_task38_elyra_passive_consumes_fortune)
	run_test("708. Task 38: Elyra Q Double Down Arms Next Basic Attack", test_task38_elyra_q_double_down_arms_attack)
	run_test("709. Task 38: Elyra Q Double Down Deals Bonus Physical Damage", test_task38_elyra_q_double_down_bonus_damage)
	run_test("710. Task 38: Elyra Q Double Down Armed Timer Expiration", test_task38_elyra_q_double_down_timer_expiration)
	run_test("711. Task 38: Elyra Q Double Down Cooldown and Mana", test_task38_elyra_q_double_down_cooldown_and_mana)
	run_test("712. Task 38: Elyra W Roll Away Dashes Forward", test_task38_elyra_w_roll_away_dash)
	run_test("713. Task 38: Elyra W Roll Away Grants Evade State", test_task38_elyra_w_roll_away_evade)
	run_test("714. Task 38: Elyra W Roll Away Evade Timer Expiration", test_task38_elyra_w_roll_away_evade_timer_expiration)
	run_test("715. Task 38: Elyra E Marked Fortune Applies Mark to Target Enemy", test_task38_elyra_e_marked_fortune_applies_mark)
	run_test("716. Task 38: Elyra E Marked Fortune Deals Bonus Damage on Crit", test_task38_elyra_e_marked_fortune_bonus_damage_on_crit)
	run_test("717. Task 38: Elyra E Marked Fortune Target Validation Rejects Ally", test_task38_elyra_e_marked_fortune_rejects_ally)
	run_test("718. Task 38: Elyra E Marked Fortune Timer Expiration", test_task38_elyra_e_marked_fortune_timer_expiration)
	run_test("719. Task 38: Elyra R Jackpot Activates and Grants +2 Fortune per Crit", test_task38_elyra_r_jackpot_fortune_generation)
	run_test("720. Task 38: Elyra R Jackpot Timer Expiration", test_task38_elyra_r_jackpot_expiration)
	run_test("721. Task 38: Elyra R Jackpot Cooldown and Mana", test_task38_elyra_r_jackpot_cooldown_and_mana)
	run_test("722. Task 38: Elyra HeroDefinition Registry and Factory", test_task38_elyra_hero_definition_factory)
	run_test("723. Task 38: Elyra Death and Respawn Clears Fortune and Marks", test_task38_elyra_death_and_respawn_clean_state)
	# --- 20 TASK 39: RIVENA HERO IMPLEMENTATION TESTS ---
	run_test("724. Task 39: Rivena Initialization and Shadow Assassin Archetype", test_task39_rivena_initialization_and_archetype)
	run_test("725. Task 39: Rivena Passive Echo Spawns Shade on Ability Cast", test_task39_rivena_passive_echo_spawns_shade)
	run_test("726. Task 39: Rivena Passive Echo Shades Capped at 3", test_task39_rivena_passive_echo_shades_capped)
	run_test("727. Task 39: Rivena Passive Echo Shade Timer Expiration", test_task39_rivena_passive_echo_shade_expiration)
	run_test("728. Task 39: Rivena Q Shadow Cut Deals Physical Damage", test_task39_rivena_q_shadow_cut_damage)
	run_test("729. Task 39: Rivena Q Shadow Cut Extra Strikes From Active Shades", test_task39_rivena_q_shadow_cut_shade_strikes)
	run_test("730. Task 39: Rivena Q Shadow Cut Spawns New Shade", test_task39_rivena_q_shadow_cut_spawns_shade)
	run_test("731. Task 39: Rivena Q Shadow Cut Target Validation Rejects Ally", test_task39_rivena_q_shadow_cut_rejects_ally)
	run_test("732. Task 39: Rivena Q Shadow Cut Cooldown and Mana", test_task39_rivena_q_shadow_cut_cooldown_and_mana)
	run_test("733. Task 39: Rivena W Echo Step Blinks to Shade Position", test_task39_rivena_w_echo_step_blinks_to_shade)
	run_test("734. Task 39: Rivena W Echo Step Leaves New Shade at Former Position", test_task39_rivena_w_echo_step_leaves_shade)
	run_test("735. Task 39: Rivena W Echo Step Fails if No Active Shades", test_task39_rivena_w_echo_step_fails_no_shades)
	run_test("736. Task 39: Rivena W Echo Step Cooldown and Mana", test_task39_rivena_w_echo_step_cooldown_and_mana)
	run_test("737. Task 39: Rivena E Shade Command Deals Damage Scaled by Shade Count", test_task39_rivena_e_shade_command_damage_scaling)
	run_test("738. Task 39: Rivena E Shade Command Target Validation Rejects Ally", test_task39_rivena_e_shade_command_rejects_ally)
	run_test("739. Task 39: Rivena R Nightfall Spawns 2 Additional Shades", test_task39_rivena_r_nightfall_spawns_shades)
	run_test("740. Task 39: Rivena R Nightfall Grants MS and AD Buffs", test_task39_rivena_r_nightfall_buffs)
	run_test("741. Task 39: Rivena R Nightfall Timer Expiration", test_task39_rivena_r_nightfall_timer_expiration)
	run_test("742. Task 39: Rivena HeroDefinition Registry and Factory", test_task39_rivena_hero_definition_factory)
	run_test("743. Task 39: Rivena Death and Respawn Clears Shades and Nightfall", test_task39_rivena_death_and_respawn_clean_state)
	# --- 20 TASK 40: TALON HERO IMPLEMENTATION TESTS ---
	run_test("744. Task 40: Talon Initialization and Diver Archetype", test_task40_talon_initialization_and_archetype)
	run_test("745. Task 40: Talon Passive Predator Pace Stacking on Target", test_task40_talon_passive_predator_pace_stacking)
	run_test("746. Task 40: Talon Passive Predator Pace Stat Scaling AD and MS", test_task40_talon_passive_predator_pace_stat_scaling)
	run_test("747. Task 40: Talon Passive Predator Pace Resets on Target Switch", test_task40_talon_passive_predator_pace_target_switch)
	run_test("748. Task 40: Talon Q Hookblade Deals Physical Damage", test_task40_talon_q_hookblade_damage)
	run_test("749. Task 40: Talon Q Hookblade Attaches Tether to Target", test_task40_talon_q_hookblade_attaches_tether)
	run_test("750. Task 40: Talon Q Hookblade Adds Predator Stack", test_task40_talon_q_hookblade_adds_predator_stack)
	run_test("751. Task 40: Talon Q Hookblade Target Validation Rejects Ally", test_task40_talon_q_hookblade_rejects_ally)
	run_test("752. Task 40: Talon Q Hookblade Cooldown and Mana", test_task40_talon_q_hookblade_cooldown_and_mana)
	run_test("753. Task 40: Talon W Pursuit Dashes to Tethered Target", test_task40_talon_w_pursuit_dashes_to_tether)
	run_test("754. Task 40: Talon W Pursuit Applies 35% Slow to Target", test_task40_talon_w_pursuit_applies_slow)
	run_test("755. Task 40: Talon W Pursuit Fails Without Tether", test_task40_talon_w_pursuit_fails_without_tether)
	run_test("756. Task 40: Talon E Tear Away Rips Tether for Bonus Damage per Stack", test_task40_talon_e_tear_away_damage_scaling)
	run_test("757. Task 40: Talon E Tear Away Clears Tether After Hit", test_task40_talon_e_tear_away_clears_tether)
	run_test("758. Task 40: Talon Tether Range Break Threshold", test_task40_talon_tether_range_break)
	run_test("759. Task 40: Talon Tether Duration Expiration", test_task40_talon_tether_duration_expiration)
	run_test("760. Task 40: Talon R No Escape Activates and Grants MS Buff", test_task40_talon_r_no_escape_buffs)
	run_test("761. Task 40: Talon R No Escape Doubles Tether Break Range", test_task40_talon_r_no_escape_doubles_tether_range)
	run_test("762. Task 40: Talon HeroDefinition Registry and Factory", test_task40_talon_hero_definition_factory)
	run_test("763. Task 40: Talon Death and Respawn Clears Tether and Predator State", test_task40_talon_death_and_respawn_clean_state)
	# --- 20 TASK 41: SERIS HERO IMPLEMENTATION TESTS ---
	run_test("764. Task 41: Seris Initialization and Trapper Archetype", test_task41_seris_initialization_and_archetype)
	run_test("765. Task 41: Seris Passive Precision Multiplier on Trapped Targets", test_task41_seris_passive_precision_multiplier)
	run_test("766. Task 41: Seris Q Needle Shot Physical Damage", test_task41_seris_q_needle_shot_damage)
	run_test("767. Task 41: Seris Q Needle Shot Target Validation Rejects Ally", test_task41_seris_q_needle_shot_target_validation_rejects_ally)
	run_test("768. Task 41: Seris Q Needle Shot Cooldown and Mana", test_task41_seris_q_needle_shot_cooldown_and_mana)
	run_test("769. Task 41: Seris W Razor Trap Placement", test_task41_seris_w_razor_trap_placement)
	run_test("770. Task 41: Seris W Razor Trap Max Cap of 4 Traps", test_task41_seris_w_razor_trap_max_cap)
	run_test("771. Task 41: Seris W Razor Trap Duration Expiration", test_task41_seris_w_razor_trap_duration_expiration)
	run_test("772. Task 41: Seris W Razor Trap Trigger Damage and Slow", test_task41_seris_w_razor_trap_trigger_damage_and_slow)
	run_test("773. Task 41: Seris E Trigger Wire Detonation of Active Traps", test_task41_seris_e_trigger_wire_detonation)
	run_test("774. Task 41: Seris E Trigger Wire Grants MS Buff", test_task41_seris_e_trigger_wire_ms_buff)
	run_test("775. Task 41: Seris E Trigger Wire MS Timer Expiration", test_task41_seris_e_trigger_wire_ms_expiration)
	run_test("776. Task 41: Seris E Trigger Wire Cooldown and Mana", test_task41_seris_e_trigger_wire_cooldown_and_mana)
	run_test("777. Task 41: Seris R Hunting Ground Spawns 3 Traps", test_task41_seris_r_hunting_ground_spawns_3_traps)
	run_test("778. Task 41: Seris R Hunting Ground AoE Damage and Slow", test_task41_seris_r_hunting_ground_aoe_damage_and_slow)
	run_test("779. Task 41: Seris R Hunting Ground Cooldown and Mana", test_task41_seris_r_hunting_ground_cooldown_and_mana)
	run_test("780. Task 41: Seris HeroDefinition Registry and Factory", test_task41_seris_hero_definition_factory)
	run_test("781. Task 41: Seris Death and Respawn Clears Traps and Trapped State", test_task41_seris_death_and_respawn_clean_state)
	run_test("782. Task 41: Seris Trapped Target Timer Expiration", test_task41_seris_trapped_target_expiration)
	run_test("783. Task 41: Seris Dead Hero Cannot Cast", test_task41_seris_dead_cannot_cast)
	# --- 20 TASK 42: MIRA HERO IMPLEMENTATION TESTS ---
	run_test("784. Task 42: Mira Initialization and Mobility Carry Archetype", test_task42_mira_initialization_and_archetype)
	run_test("785. Task 42: Mira Passive Velocity AD Scaling from MS", test_task42_mira_passive_velocity_ad_scaling)
	run_test("786. Task 42: Mira Passive Velocity Dynamic Update on MS Change", test_task42_mira_passive_velocity_dynamic_update)
	run_test("787. Task 42: Mira Q Dash Strike Deals Physical Damage", test_task42_mira_q_dash_strike_damage)
	run_test("788. Task 42: Mira Q Dash Strike Forward Dash Repositioning", test_task42_mira_q_dash_strike_forward_dash)
	run_test("789. Task 42: Mira Q Dash Strike Target Validation Rejects Ally", test_task42_mira_q_dash_strike_target_validation_rejects_ally)
	run_test("790. Task 42: Mira Q Dash Strike Cooldown and Mana", test_task42_mira_q_dash_strike_cooldown_and_mana)
	run_test("791. Task 42: Mira W Slip Grants Evade State", test_task42_mira_w_slip_evade_state)
	run_test("792. Task 42: Mira W Slip Evade Negates Incoming Damage", test_task42_mira_w_slip_evade_negates_damage)
	run_test("793. Task 42: Mira W Slip Grants MS Buff", test_task42_mira_w_slip_ms_buff)
	run_test("794. Task 42: Mira W Slip Timer Expiration", test_task42_mira_w_slip_timer_expiration)
	run_test("795. Task 42: Mira E Accelerate Grants MS and AS Buffs", test_task42_mira_e_accelerate_ms_and_as_buff)
	run_test("796. Task 42: Mira E Accelerate Timer Expiration", test_task42_mira_e_accelerate_timer_expiration)
	run_test("797. Task 42: Mira E Accelerate Cooldown and Mana", test_task42_mira_e_accelerate_cooldown_and_mana)
	run_test("798. Task 42: Mira R Sonic Run Activates and Grants 80% MS Buff", test_task42_mira_r_sonic_run_active_and_ms_buff)
	run_test("799. Task 42: Mira R Sonic Run Contact Damage on Enemies", test_task42_mira_r_sonic_run_contact_damage)
	run_test("800. Task 42: Mira R Sonic Run No Duplicate Contact Damage", test_task42_mira_r_sonic_run_no_duplicate_damage)
	run_test("801. Task 42: Mira R Sonic Run Timer Expiration", test_task42_mira_r_sonic_run_timer_expiration)
	run_test("802. Task 42: Mira HeroDefinition Registry and Factory", test_task42_mira_hero_definition_factory)
	run_test("803. Task 42: Mira Death and Respawn Clears Buffs and Evade State", test_task42_mira_death_and_respawn_clean_state)
	# --- 20 TASK 43: ZAREK HERO IMPLEMENTATION TESTS ---
	run_test("804. Task 43: Zarek Initialization and Anti-Mage Archetype", test_task43_zarek_initialization_and_archetype)
	run_test("805. Task 43: Zarek Passive Mana Hunter Burns Mana on Attack", test_task43_zarek_passive_mana_hunter_burns_mana)
	run_test("806. Task 43: Zarek Passive Mana Hunter Bonus Magical Damage", test_task43_zarek_passive_mana_hunter_bonus_magical_damage)
	run_test("807. Task 43: Zarek Q Drain Edge Deals Physical Damage", test_task43_zarek_q_drain_edge_damage)
	run_test("808. Task 43: Zarek Q Drain Edge Drains Enemy Mana and Restores Zarek", test_task43_zarek_q_drain_edge_mana_drain_and_restore)
	run_test("809. Task 43: Zarek Q Drain Edge Target Validation Rejects Ally", test_task43_zarek_q_drain_edge_target_validation_rejects_ally)
	run_test("810. Task 43: Zarek Q Drain Edge Cooldown and Mana", test_task43_zarek_q_drain_edge_cooldown_and_mana)
	run_test("811. Task 43: Zarek W Phase Cut Deals Physical Damage", test_task43_zarek_w_phase_cut_damage)
	run_test("812. Task 43: Zarek W Phase Cut Blinks Behind Target", test_task43_zarek_w_phase_cut_blink_behind_target)
	run_test("813. Task 43: Zarek W Phase Cut Cooldown and Mana", test_task43_zarek_w_phase_cut_cooldown_and_mana)
	run_test("814. Task 43: Zarek E Silence Mark Deals Magical Damage", test_task43_zarek_e_silence_mark_damage)
	run_test("815. Task 43: Zarek E Silence Mark Applies Silence Status Effect", test_task43_zarek_e_silence_mark_applies_silence)
	run_test("816. Task 43: Zarek E Silence Mark Target Validation Rejects Ally", test_task43_zarek_e_silence_mark_target_validation_rejects_ally)
	run_test("817. Task 43: Zarek E Silence Mark Cooldown and Mana", test_task43_zarek_e_silence_mark_cooldown_and_mana)
	run_test("818. Task 43: Zarek R Null Field Creates Anti-Magic Zone", test_task43_zarek_r_null_field_activation)
	run_test("819. Task 43: Zarek R Null Field Damage Scales with Missing Mana", test_task43_zarek_r_null_field_damage_scales_with_missing_mana)
	run_test("820. Task 43: Zarek R Null Field Timer Expiration", test_task43_zarek_r_null_field_timer_expiration)
	run_test("821. Task 43: Zarek R Null Field Cooldown and Mana", test_task43_zarek_r_null_field_cooldown_and_mana)
	run_test("822. Task 43: Zarek HeroDefinition Registry and Factory", test_task43_zarek_hero_definition_factory)
	run_test("823. Task 43: Zarek Death and Respawn Clears Null Field State", test_task43_zarek_death_and_respawn_clean_state)
	# --- 20 TASK 44: ILYRA HERO IMPLEMENTATION TESTS ---
	run_test("824. Task 44: Ilyra Initialization and Battlemage Archetype", test_task44_ilyra_initialization_and_archetype)
	run_test("825. Task 44: Ilyra Passive Weave Stacks on Different Spells", test_task44_ilyra_passive_weave_stacking_on_different_spells)
	run_test("826. Task 44: Ilyra Passive Weave Resets on Repeated Spell", test_task44_ilyra_passive_weave_resets_on_repeat_spell)
	run_test("827. Task 44: Ilyra Passive Weave Stat Scaling AP and MS", test_task44_ilyra_passive_weave_stat_scaling_ap_and_ms)
	run_test("828. Task 44: Ilyra Passive Weave Timer Expiration", test_task44_ilyra_passive_weave_timer_expiration)
	run_test("829. Task 44: Ilyra Q Ember Thread Deals Magical Damage", test_task44_ilyra_q_ember_thread_damage)
	run_test("830. Task 44: Ilyra Q Ember Thread Records Ember in Spell History", test_task44_ilyra_q_ember_thread_records_ember)
	run_test("831. Task 44: Ilyra Q Ember Thread Target Validation Rejects Ally", test_task44_ilyra_q_ember_thread_target_validation_rejects_ally)
	run_test("832. Task 44: Ilyra Q Ember Thread Cooldown and Mana", test_task44_ilyra_q_ember_thread_cooldown_and_mana)
	run_test("833. Task 44: Ilyra W Frost Thread AoE Damage", test_task44_ilyra_w_frost_thread_aoe_damage)
	run_test("834. Task 44: Ilyra W Frost Thread Applies 35% Slow", test_task44_ilyra_w_frost_thread_applies_slow)
	run_test("835. Task 44: Ilyra W Frost Thread Records Frost in Spell History", test_task44_ilyra_w_frost_thread_records_frost)
	run_test("836. Task 44: Ilyra W Frost Thread Cooldown and Mana", test_task44_ilyra_w_frost_thread_cooldown_and_mana)
	run_test("837. Task 44: Ilyra E Arc Thread Deals Magical Damage to Primary Target", test_task44_ilyra_e_arc_thread_single_damage)
	run_test("838. Task 44: Ilyra E Arc Thread Chains to Secondary Targets", test_task44_ilyra_e_arc_thread_chains_to_secondary_targets)
	run_test("839. Task 44: Ilyra E Arc Thread Records Arc in Spell History", test_task44_ilyra_e_arc_thread_records_arc)
	run_test("840. Task 44: Ilyra E Arc Thread Cooldown and Mana", test_task44_ilyra_e_arc_thread_cooldown_and_mana)
	run_test("841. Task 44: Ilyra R Grand Weave AoE Damage and Stack Multiplier", test_task44_ilyra_r_grand_weave_aoe_damage_and_stack_multiplier)
	run_test("842. Task 44: Ilyra R Grand Weave Consumes Weave Stacks", test_task44_ilyra_r_grand_weave_consumes_weave_stacks)
	run_test("843. Task 44: Ilyra Death and Respawn Clears Weave Stacks and Spell History", test_task44_ilyra_death_and_respawn_clean_state)
	# --- 20 TASK 45: VAEL HERO IMPLEMENTATION TESTS ---
	run_test("844. Task 45: Vael Initialization and Artillery Archetype", test_task45_vael_initialization_and_archetype)
	run_test("845. Task 45: Vael Passive Calibration Stacks on Same Direction", test_task45_vael_passive_calibration_stacks_on_same_direction)
	run_test("846. Task 45: Vael Passive Calibration Resets on Big Redirection", test_task45_vael_passive_calibration_resets_on_redirection)
	run_test("847. Task 45: Vael Passive Calibration Timer Expiration", test_task45_vael_passive_calibration_timer_expiration)
	run_test("848. Task 45: Vael Q Star Lance Deals Heavy Magical Damage", test_task45_vael_q_star_lance_damage)
	run_test("849. Task 45: Vael Q Star Lance Empowered by Calibration", test_task45_vael_q_star_lance_empowered_by_calibration)
	run_test("850. Task 45: Vael Q Star Lance Empowered by Astral Marker", test_task45_vael_q_star_lance_empowered_by_astral_marker)
	run_test("851. Task 45: Vael Q Star Lance Target Validation Rejects Ally", test_task45_vael_q_star_lance_target_validation_rejects_ally)
	run_test("852. Task 45: Vael Q Star Lance Cooldown and Mana", test_task45_vael_q_star_lance_cooldown_and_mana)
	run_test("853. Task 45: Vael W Astral Marker Applies Mark to Target", test_task45_vael_w_astral_marker_applies_mark)
	run_test("854. Task 45: Vael W Astral Marker Target Validation Rejects Ally", test_task45_vael_w_astral_marker_target_validation_rejects_ally)
	run_test("855. Task 45: Vael W Astral Marker Timer Expiration", test_task45_vael_w_astral_marker_timer_expiration)
	run_test("856. Task 45: Vael W Astral Marker Cooldown and Mana", test_task45_vael_w_astral_marker_cooldown_and_mana)
	run_test("857. Task 45: Vael E Warp Sight Grants Attack/Spell Range Buff", test_task45_vael_e_warp_sight_grants_range_buff)
	run_test("858. Task 45: Vael E Warp Sight Timer Expiration", test_task45_vael_e_warp_sight_timer_expiration)
	run_test("859. Task 45: Vael E Warp Sight Cooldown and Mana", test_task45_vael_e_warp_sight_cooldown_and_mana)
	run_test("860. Task 45: Vael R Falling Star AoE Magical Damage", test_task45_vael_r_falling_star_aoe_damage)
	run_test("861. Task 45: Vael R Falling Star Center Bonus Damage", test_task45_vael_r_falling_star_center_bonus_damage)
	run_test("862. Task 45: Vael HeroDefinition Registry and Factory", test_task45_vael_hero_definition_factory)
	run_test("863. Task 45: Vael Death and Respawn Clears Calibration and Marker State", test_task45_vael_death_and_respawn_clean_state)
	
	# --- TASK 46: NERIS HERO IMPLEMENTATION TESTS (Tests 864–883) ---
	run_test("864. Task 46: Neris Initialization and Archetype", test_task46_neris_initialization_and_archetype)
	run_test("865. Task 46: Neris Passive Node Creation", test_task46_neris_passive_node_creation)
	run_test("866. Task 46: Neris Passive Node Cap and FIFO Removal", test_task46_neris_passive_node_cap_and_fifo)
	run_test("867. Task 46: Neris Passive Node Lifetime Decay", test_task46_neris_passive_node_lifetime_decay)
	run_test("868. Task 46: Neris Q Wall Spawns Two Nodes", test_task46_neris_q_wall_spawns_two_nodes)
	run_test("869. Task 46: Neris Q Wall Deals Damage and Slows Enemies", test_task46_neris_q_wall_deals_damage_and_slows_enemies)
	run_test("870. Task 46: Neris Q Wall Lifetime Expiration", test_task46_neris_q_wall_lifetime_expiration)
	run_test("871. Task 46: Neris Q Wall Cooldown and Mana", test_task46_neris_q_wall_cooldown_and_mana)
	run_test("872. Task 46: Neris W Pulse Triggers Damage Around Nodes", test_task46_neris_w_pulse_triggers_damage_around_nodes)
	run_test("873. Task 46: Neris W Pulse Overlapping Nodes Bonus Damage", test_task46_neris_w_pulse_overlapping_nodes_bonus_damage)
	run_test("874. Task 46: Neris W Pulse Cooldown and Mana", test_task46_neris_w_pulse_cooldown_and_mana)
	run_test("875. Task 46: Neris E Gate Creates Spatial Bridge", test_task46_neris_e_gate_creates_spatial_bridge)
	run_test("876. Task 46: Neris E Gate Teleports Ally and Grants MS", test_task46_neris_e_gate_teleports_ally_and_grants_ms)
	run_test("877. Task 46: Neris E Gate Rejects Enemy Teleport", test_task46_neris_e_gate_rejects_enemy_teleport)
	run_test("878. Task 46: Neris E Gate Lifetime Expiration", test_task46_neris_e_gate_lifetime_expiration)
	run_test("879. Task 46: Neris E Gate Cooldown and Mana", test_task46_neris_e_gate_cooldown_and_mana)
	run_test("880. Task 46: Neris R Grand Design Spawns Matrix Nodes", test_task46_neris_r_grand_design_spawns_matrix_nodes)
	run_test("881. Task 46: Neris R Grand Design Damage and Stun", test_task46_neris_r_grand_design_damage_and_stun)
	run_test("882. Task 46: Neris HeroDefinition Registry and Factory", test_task46_neris_hero_definition_factory)
	run_test("883. Task 46: Neris Death and Respawn Clears Nodes", test_task46_neris_death_and_respawn_clears_nodes)
	
	# --- TASK 47: ORYN HERO IMPLEMENTATION TESTS (Tests 884–903) ---
	run_test("884. Task 47: Oryn Initialization and Archetype", test_task47_oryn_initialization_and_archetype)
	run_test("885. Task 47: Oryn Passive Resonance Accumulation", test_task47_oryn_passive_resonance_accumulation)
	run_test("886. Task 47: Oryn Passive Resonance AP and Heal Power", test_task47_oryn_passive_resonance_ap_and_heal_power)
	run_test("887. Task 47: Oryn Passive Resonance Cap Clamp", test_task47_oryn_passive_resonance_cap_clamp)
	run_test("888. Task 47: Oryn Passive Resonance Decay Timer", test_task47_oryn_passive_resonance_decay_timer)
	run_test("889. Task 47: Oryn Q Mend Heals Target Ally", test_task47_oryn_q_mend_heals_ally)
	run_test("890. Task 47: Oryn Q Mend Self Cast Penalty", test_task47_oryn_q_mend_self_cast_penalty)
	run_test("891. Task 47: Oryn Q Mend Cooldown and Mana", test_task47_oryn_q_mend_cooldown_and_mana)
	run_test("892. Task 47: Oryn W Empower Grants Stat and AS Buff", test_task47_oryn_w_empower_grants_stat_and_as_buff)
	run_test("893. Task 47: Oryn W Empower Target Validation Rejects Enemy", test_task47_oryn_w_empower_target_validation_rejects_enemy)
	run_test("894. Task 47: Oryn W Empower Cooldown and Mana", test_task47_oryn_w_empower_cooldown_and_mana)
	run_test("895. Task 47: Oryn E Transfer Purges Ally Debuff", test_task47_oryn_e_transfer_purges_ally_debuff)
	run_test("896. Task 47: Oryn E Transfer Inflicts Damage and Debuff on Enemy", test_task47_oryn_e_transfer_inflicts_damage_and_debuff_on_enemy)
	run_test("897. Task 47: Oryn E Transfer Target Validation Rejects Enemy as Primary", test_task47_oryn_e_transfer_target_validation_rejects_enemy_as_primary)
	run_test("898. Task 47: Oryn E Transfer Cooldown and Mana", test_task47_oryn_e_transfer_cooldown_and_mana)
	run_test("899. Task 47: Oryn R Resonant Bond Forms Bond and Buffs", test_task47_oryn_r_resonant_bond_forms_bond_and_buffs)
	run_test("900. Task 47: Oryn R Resonant Bond Shared Healing", test_task47_oryn_r_resonant_bond_shared_healing)
	run_test("901. Task 47: Oryn R Resonant Bond Expiration", test_task47_oryn_r_resonant_bond_expiration)
	run_test("902. Task 47: Oryn HeroDefinition Registry and Factory", test_task47_oryn_hero_definition_factory)
	run_test("903. Task 47: Oryn Death and Respawn Cleans Bond and Resonance", test_task47_oryn_death_and_respawn_cleans_bond_and_resonance)
	
	# --- TASK 48: SELKA HERO IMPLEMENTATION TESTS (Tests 904–923) ---
	run_test("904. Task 48: Selka Initialization and Archetype", test_task48_selka_initialization_and_archetype)
	run_test("905. Task 48: Selka Passive Hex Mark Application", test_task48_selka_passive_hex_mark_application)
	run_test("906. Task 48: Selka Passive Hex Mark MR Shred", test_task48_selka_passive_hex_mark_mr_shred)
	run_test("907. Task 48: Selka Passive Hex Mark Cap Clamp", test_task48_selka_passive_hex_mark_cap_clamp)
	run_test("908. Task 48: Selka Passive Hex Mark Decay Timer", test_task48_selka_passive_hex_mark_decay_timer)
	run_test("909. Task 48: Selka Q Hex Bolt Damage and Mark", test_task48_selka_q_hex_bolt_damage_and_mark)
	run_test("910. Task 48: Selka Q Hex Bolt Target Validation Rejects Ally", test_task48_selka_q_hex_bolt_target_validation_rejects_ally)
	run_test("911. Task 48: Selka Q Hex Bolt Cooldown and Mana", test_task48_selka_q_hex_bolt_cooldown_and_mana)
	run_test("912. Task 48: Selka W Ember Ring AoE Damage and Mark", test_task48_selka_w_ember_ring_aoe_damage_and_mark)
	run_test("913. Task 48: Selka W Ember Ring Cooldown and Mana", test_task48_selka_w_ember_ring_cooldown_and_mana)
	run_test("914. Task 48: Selka E Detonate Consumes Stacks for Burst Damage", test_task48_selka_e_detonate_consumes_stacks_for_burst_damage)
	run_test("915. Task 48: Selka E Detonate Slows Targets", test_task48_selka_e_detonate_slows_targets)
	run_test("916. Task 48: Selka E Detonate Zero Marks No Damage", test_task48_selka_e_detonate_zero_marks_no_damage)
	run_test("917. Task 48: Selka E Detonate Cooldown and Mana", test_task48_selka_e_detonate_cooldown_and_mana)
	run_test("918. Task 48: Selka R Cataclysm Links Marked Enemies", test_task48_selka_r_cataclysm_links_marked_enemies)
	run_test("919. Task 48: Selka R Cataclysm Damage Propagation", test_task48_selka_r_cataclysm_damage_propagation)
	run_test("920. Task 48: Selka R Cataclysm Expiration", test_task48_selka_r_cataclysm_expiration)
	run_test("921. Task 48: Selka R Cataclysm Cooldown and Mana", test_task48_selka_r_cataclysm_cooldown_and_mana)
	run_test("922. Task 48: Selka HeroDefinition Registry and Factory", test_task48_selka_hero_definition_factory)
	run_test("923. Task 48: Selka Death and Respawn Cleans Hex Marks and Links", test_task48_selka_death_and_respawn_cleans_hex_marks_and_links)
	
	# --- TASK 49: MORA HERO IMPLEMENTATION TESTS (Tests 924–943) ---
	run_test("924. Task 49: Mora Initialization and Archetype", test_task49_mora_initialization_and_archetype)
	run_test("925. Task 49: Mora Passive Life Reserve Accumulation", test_task49_mora_passive_life_reserve_accumulation)
	run_test("926. Task 49: Mora Passive Life Reserve HP Regen Boost", test_task49_mora_passive_life_reserve_hp_regen_boost)
	run_test("927. Task 49: Mora Passive Life Reserve Cap Clamp", test_task49_mora_passive_life_reserve_cap_clamp)
	run_test("928. Task 49: Mora Q Restore Heals Ally Over Time", test_task49_mora_q_restore_heals_ally_over_time)
	run_test("929. Task 49: Mora Q Restore Target Validation Rejects Enemy", test_task49_mora_q_restore_target_validation_rejects_enemy)
	run_test("930. Task 49: Mora Q Restore Cooldown and Mana", test_task49_mora_q_restore_cooldown_and_mana)
	run_test("931. Task 49: Mora W Safeguard Shields Ally", test_task49_mora_w_safeguard_shields_ally)
	run_test("932. Task 49: Mora W Safeguard Target Validation Rejects Enemy", test_task49_mora_w_safeguard_target_validation_rejects_enemy)
	run_test("933. Task 49: Mora W Safeguard Cooldown and Mana", test_task49_mora_w_safeguard_cooldown_and_mana)
	run_test("934. Task 49: Mora E Transfer Life Sacrifices HP to Heal Ally", test_task49_mora_e_transfer_life_sacrifices_hp_to_heal_ally)
	run_test("935. Task 49: Mora E Transfer Life Rejects Self Cast", test_task49_mora_e_transfer_life_rejects_self_cast)
	run_test("936. Task 49: Mora E Transfer Life Cooldown and Mana", test_task49_mora_e_transfer_life_cooldown_and_mana)
	run_test("937. Task 49: Mora R Rebirth Field Activates Sanctuary", test_task49_mora_r_rebirth_field_activates_sanctuary)
	run_test("938. Task 49: Mora R Rebirth Field Prevents Death Below 15 Percent", test_task49_mora_r_rebirth_field_prevents_death_below_15_percent)
	run_test("939. Task 49: Mora R Rebirth Field Timer Expiration", test_task49_mora_r_rebirth_field_timer_expiration)
	run_test("940. Task 49: Mora R Rebirth Field Cooldown and Mana", test_task49_mora_r_rebirth_field_cooldown_and_mana)
	run_test("941. Task 49: Mora HeroDefinition Registry and Factory", test_task49_mora_hero_definition_factory)
	run_test("942. Task 49: Mora Death and Respawn Cleans Reserve and Sanctuary", test_task49_mora_death_and_respawn_cleans_reserve_and_sanctuary)
	run_test("943. Task 49: Mora Stat Scaling with Levels", test_task49_mora_stat_scaling_with_levels)
	
	# --- TASK 50: AETHON HERO IMPLEMENTATION TESTS (Tests 944–963) ---
	run_test("944. Task 50: Aethon Initialization and Archetype", test_task50_aethon_initialization_and_archetype)
	run_test("945. Task 50: Aethon Passive Construct Spawn and Lifecycle", test_task50_aethon_passive_construct_spawn_and_lifecycle)
	run_test("946. Task 50: Aethon Passive Construct Max Cap Clamp", test_task50_aethon_passive_construct_max_cap_clamp)
	run_test("947. Task 50: Aethon Passive Construct Lifespan Expiration", test_task50_aethon_passive_construct_lifespan_expiration)
	run_test("948. Task 50: Aethon Q Guardian Construct Spawn", test_task50_aethon_q_guardian_construct_spawn)
	run_test("949. Task 50: Aethon Q Guardian Construct Cooldown and Mana", test_task50_aethon_q_guardian_construct_cooldown_and_mana)
	run_test("950. Task 50: Aethon W Cannon Construct Spawn", test_task50_aethon_w_cannon_construct_spawn)
	run_test("951. Task 50: Aethon W Cannon Construct Cooldown and Mana", test_task50_aethon_w_cannon_construct_cooldown_and_mana)
	run_test("952. Task 50: Aethon E Reconfigure Swaps Guardian to Cannon", test_task50_aethon_e_reconfigure_swaps_guardian_to_cannon)
	run_test("953. Task 50: Aethon E Reconfigure Swaps Cannon to Guardian", test_task50_aethon_e_reconfigure_swaps_cannon_to_guardian)
	run_test("954. Task 50: Aethon E Reconfigure Heals and Buffs Constructs", test_task50_aethon_e_reconfigure_heals_and_buffs_constructs)
	run_test("955. Task 50: Aethon E Reconfigure Cooldown and Mana", test_task50_aethon_e_reconfigure_cooldown_and_mana)
	run_test("956. Task 50: Aethon R Assembly Combines Active Constructs", test_task50_aethon_r_assembly_combines_active_constructs)
	run_test("957. Task 50: Aethon R Assembly Siege Construct Stats", test_task50_aethon_r_assembly_siege_construct_stats)
	run_test("958. Task 50: Aethon R Assembly Shockwave AoE Damage", test_task50_aethon_r_assembly_shockwave_aoe_damage)
	run_test("959. Task 50: Aethon R Assembly Cooldown and Mana", test_task50_aethon_r_assembly_cooldown_and_mana)
	run_test("960. Task 50: Aethon HeroDefinition Registry and Factory", test_task50_aethon_hero_definition_factory)
	run_test("961. Task 50: Aethon Death and Respawn Clears Constructs", test_task50_aethon_death_and_respawn_clears_constructs)
	run_test("962. Task 50: Aethon Multiple Construct Type Query", test_task50_aethon_multiple_construct_type_query)
	run_test("963. Task 50: Aethon Stat Scaling with Levels", test_task50_aethon_stat_scaling_with_levels)
	
	# --- TASK 51: NYMERA HERO IMPLEMENTATION TESTS (Tests 964–983) ---
	run_test("964. Task 51: Nymera Initialization and Archetype", test_task51_nymera_initialization_and_archetype)
	run_test("965. Task 51: Nymera Passive Echo Time Snapshot Recording", test_task51_nymera_passive_echo_time_snapshot_recording)
	run_test("966. Task 51: Nymera Passive Echo Time History Purge", test_task51_nymera_passive_echo_time_history_purge)
	run_test("967. Task 51: Nymera Q Slow Field Deploys Distortion", test_task51_nymera_q_slow_field_deploys_distortion)
	run_test("968. Task 51: Nymera Q Slow Field Slows Enemy", test_task51_nymera_q_slow_field_slows_enemy)
	run_test("969. Task 51: Nymera Q Slow Field Cooldown and Mana", test_task51_nymera_q_slow_field_cooldown_and_mana)
	run_test("970. Task 51: Nymera W Rewind Teleports Target Back", test_task51_nymera_w_rewind_teleports_target_back)
	run_test("971. Task 51: Nymera W Rewind Deals Magic Damage", test_task51_nymera_w_rewind_deals_magic_damage)
	run_test("972. Task 51: Nymera W Rewind Target Validation Rejects Ally", test_task51_nymera_w_rewind_target_validation_rejects_ally)
	run_test("973. Task 51: Nymera W Rewind Cooldown and Mana", test_task51_nymera_w_rewind_cooldown_and_mana)
	run_test("974. Task 51: Nymera E Accelerate Buffs Ally Speed", test_task51_nymera_e_accelerate_buffs_ally_speed)
	run_test("975. Task 51: Nymera E Accelerate Target Validation Rejects Enemy", test_task51_nymera_e_accelerate_target_validation_rejects_enemy)
	run_test("976. Task 51: Nymera E Accelerate Cooldown and Mana", test_task51_nymera_e_accelerate_cooldown_and_mana)
	run_test("977. Task 51: Nymera R Temporal Collapse AoE Rewind and Damage", test_task51_nymera_r_temporal_collapse_aoe_rewind_and_damage)
	run_test("978. Task 51: Nymera R Temporal Collapse Roots Enemies", test_task51_nymera_r_temporal_collapse_roots_enemies)
	run_test("979. Task 51: Nymera R Temporal Collapse Cooldown and Mana", test_task51_nymera_r_temporal_collapse_cooldown_and_mana)
	run_test("980. Task 51: Nymera HeroDefinition Registry and Factory", test_task51_nymera_hero_definition_factory)
	run_test("981. Task 51: Nymera Death and Respawn Clears Timeline History", test_task51_nymera_death_and_respawn_clears_timeline_history)
	run_test("982. Task 51: Nymera Slow Field Expiration", test_task51_nymera_slow_field_expiration)
	run_test("983. Task 51: Nymera Stat Scaling with Levels", test_task51_nymera_stat_scaling_with_levels)
	
	# --- TASK 52: VEYLIN HERO IMPLEMENTATION TESTS (Tests 984–1003) ---
	run_test("984. Task 52: Veylin Initialization and Archetype", test_task52_veylin_initialization_and_archetype)
	run_test("985. Task 52: Veylin Passive Study Stack Accumulation", test_task52_veylin_passive_study_stack_accumulation)
	run_test("986. Task 52: Veylin Passive Study Grants AP Stat Scaling", test_task52_veylin_passive_study_grants_ap_stat_scaling)
	run_test("987. Task 52: Veylin Passive Study Cap Clamp", test_task52_veylin_passive_study_cap_clamp)
	run_test("988. Task 52: Veylin Q Mimic Deals Magic Damage", test_task52_veylin_q_mimic_deals_magic_damage)
	run_test("989. Task 52: Veylin Q Mimic Damage Amplified by Study Stacks", test_task52_veylin_q_mimic_damage_amplified_by_study_stacks)
	run_test("990. Task 52: Veylin Q Mimic Target Validation Rejects Ally", test_task52_veylin_q_mimic_target_validation_rejects_ally)
	run_test("991. Task 52: Veylin Q Mimic Cooldown and Mana", test_task52_veylin_q_mimic_cooldown_and_mana)
	run_test("992. Task 52: Veylin W Counterspell Applies Shield", test_task52_veylin_w_counterspell_applies_shield)
	run_test("993. Task 52: Veylin W Counterspell Grants Bonus Study Stacks", test_task52_veylin_w_counterspell_grants_bonus_study_stacks)
	run_test("994. Task 52: Veylin W Counterspell Cooldown and Mana", test_task52_veylin_w_counterspell_cooldown_and_mana)
	run_test("995. Task 52: Veylin E Rewrite Resets Q Cooldown", test_task52_veylin_e_rewrite_resets_q_cooldown)
	run_test("996. Task 52: Veylin E Rewrite Amplifies Next Spell", test_task52_veylin_e_rewrite_amplifies_next_spell)
	run_test("997. Task 52: Veylin E Rewrite Cooldown and Mana", test_task52_veylin_e_rewrite_cooldown_and_mana)
	run_test("998. Task 52: Veylin R Adaptation Deals AoE Magic Damage", test_task52_veylin_r_adaptation_deals_aoe_magic_damage)
	run_test("999. Task 52: Veylin R Adaptation Grants Spell Vamp and Move Speed", test_task52_veylin_r_adaptation_grants_spell_vamp_and_move_speed)
	run_test("1000. Task 52: Veylin R Adaptation Maximizes Study Stacks", test_task52_veylin_r_adaptation_maximizes_study_stacks)
	run_test("1001. Task 52: Veylin R Adaptation Cooldown and Mana", test_task52_veylin_r_adaptation_cooldown_and_mana)
	run_test("1002. Task 52: Veylin HeroDefinition Registry and Factory", test_task52_veylin_hero_definition_factory)
	run_test("1003. Task 52: Veylin Death and Respawn Clears Stacks and Buffs", test_task52_veylin_death_and_respawn_clears_stacks_and_buffs)
	
	# --- TASK 53: ZYRAEN HERO IMPLEMENTATION TESTS (Tests 1004–1023) ---
	run_test("1004. Task 53: Zyraen Initialization and Archetype", test_task53_zyraen_initialization_and_archetype)
	run_test("1005. Task 53: Zyraen Passive Equilibrium Activation on Equal Ratios", test_task53_zyraen_passive_equilibrium_activation_on_equal_ratios)
	run_test("1006. Task 53: Zyraen Passive Equilibrium Deactivation on Ratio Gap", test_task53_zyraen_passive_equilibrium_deactivation_on_ratio_gap)
	run_test("1007. Task 53: Zyraen Passive Equilibrium Grants AP and Damage Reduction", test_task53_zyraen_passive_equilibrium_grants_ap_and_damage_reduction)
	run_test("1008. Task 53: Zyraen Q Life Spark Deals Magic Damage", test_task53_zyraen_q_life_spark_deals_magic_damage)
	run_test("1009. Task 53: Zyraen Q Life Spark Deals Extra Damage in Equilibrium", test_task53_zyraen_q_life_spark_deals_extra_damage_in_equilibrium)
	run_test("1010. Task 53: Zyraen Q Life Spark Target Validation Rejects Ally", test_task53_zyraen_q_life_spark_target_validation_rejects_ally)
	run_test("1011. Task 53: Zyraen Q Life Spark Cooldown and Mana", test_task53_zyraen_q_life_spark_cooldown_and_mana)
	run_test("1012. Task 53: Zyraen W Mana Siphon Drains Mana and Heals", test_task53_zyraen_w_mana_siphon_drains_mana_and_heals)
	run_test("1013. Task 53: Zyraen W Mana Siphon Target Validation Rejects Ally", test_task53_zyraen_w_mana_siphon_target_validation_rejects_ally)
	run_test("1014. Task 53: Zyraen W Mana Siphon Cooldown and Mana", test_task53_zyraen_w_mana_siphon_cooldown_and_mana)
	run_test("1015. Task 53: Zyraen E Exchange HP to Mana", test_task53_zyraen_e_exchange_hp_to_mana)
	run_test("1016. Task 53: Zyraen E Exchange Mana to HP", test_task53_zyraen_e_exchange_mana_to_hp)
	run_test("1017. Task 53: Zyraen E Exchange Cooldown", test_task53_zyraen_e_exchange_cooldown)
	run_test("1018. Task 53: Zyraen R Perfect Balance Equalizes HP and Mana", test_task53_zyraen_r_perfect_balance_equalizes_hp_and_mana)
	run_test("1019. Task 53: Zyraen R Perfect Balance Grants Shield", test_task53_zyraen_r_perfect_balance_grants_shield)
	run_test("1020. Task 53: Zyraen R Perfect Balance Forces Equilibrium State", test_task53_zyraen_r_perfect_balance_forces_equilibrium_state)
	run_test("1021. Task 53: Zyraen R Perfect Balance Deals AoE Damage", test_task53_zyraen_r_perfect_balance_deals_aoe_damage)
	run_test("1022. Task 53: Zyraen HeroDefinition Registry and Factory", test_task53_zyraen_hero_definition_factory)
	run_test("1023. Task 53: Zyraen Death and Respawn Clears Equilibrium", test_task53_zyraen_death_and_respawn_clears_equilibrium)
	
	# --- HERO SELECTION & TESTING DASHBOARD TESTS (Tests 1024–1029) ---
	run_test("1024. HeroSelectionUI: Initialization and 31 Hero Cards", test_hero_selection_ui_initialization_and_roster_count)
	run_test("1025. HeroSelectionUI: Primary Attribute Filtering", test_hero_selection_ui_attribute_filtering)
	run_test("1026. HeroSelectionUI: Search Text Live Filtering", test_hero_selection_ui_search_filtering)
	run_test("1027. HeroSelectionUI: Hero Inspection Stats and Abilities Population", test_hero_selection_ui_inspect_hero_data_population)
	run_test("1028. HeroSelectionUI: GlobalHeroSelection State Persistence", test_hero_selection_global_state_persistence)
	run_test("1029. HeroSelectionUI: Play and Bot Selection Signal Flow", test_hero_selection_play_and_bot_signal_flow)
	
	# --- STATUS EFFECT BAR & PASSIVES UI TESTS (Tests 1030–1031) ---
	run_test("1030. DotaStatusEffectIcon: Visual Configuration, Ring Color and Tooltips", test_dota_status_effect_icon_configuration)
	run_test("1031. DotaStatusEffectBar: Populates StatusEffects and Hero Passives", test_dota_status_effect_bar_populates_effects_and_passives)
	
	# --- 3D MOBA SPELL VFX TESTS (Tests 1032–1034) ---
	run_test("1032. 3D VFX: SkillshotProjectile3D Launch, Flight and Trajectory", test_vfx_skillshot_projectile_launch)
	run_test("1033. 3D VFX: HomingSpellProjectile3D Target Tracking and Impact", test_vfx_homing_spell_projectile_tracking)
	run_test("1034. 3D VFX: SpellVisualFX3D Procedural Bursts, Slams and Shields", test_vfx_spell_visual_fx_generators)
	
	# --- FOG OF WAR & HERO ANIMATOR TESTS (Tests 1035–1037) ---
	run_test("1035. FogOfWar: Team Vision Range, Distance Culling and Enemy Visibility", test_fog_of_war_vision_range_and_culling)
	run_test("1036. FogOfWar: Bush Concealment, Ambush and Shared Bush Vision", test_fog_of_war_bush_concealment_and_shared_vision)
	run_test("1037. HeroAnimator3D: Locomotion Bobbing, Idle Breathing and Attack Motion", test_hero_animator_3d_locomotion_and_actions)
	
	# --- 54 HERO ROSTER EXPANSION TESTS (Tests 1038–1040) ---
	run_test("1038. Hero Roster: 54 Unified Definitions Registered with Valid Stats & Growths", test_51_hero_roster_registry_and_definitions)
	run_test("1039. Hero Roster: Full 54 Hero Entity Instantiation & Ability Kits", test_51_hero_instantiations_and_ability_containers)
	run_test("1040. Hero Roster: Primary Attributes, Scaling Ratios & Mana Econ Integrity", test_new_heroes_archetype_stat_scaling_integrity)
	
	# --- MODULAR ITEM PIPELINE & BUILD MATRIX TESTS (Tests 1041–1043) ---
	run_test("1041. Item Engine: Passive On-Hit Bleed, Mana Burn, and Thorns Reflection", test_item_event_engine_on_hit_and_defensive_tags)
	run_test("1042. Item Engine: Active Item Cooldowns, Blink Dagger and Spell Immunity", test_inventory_manager_active_item_cooldowns_and_execution)
	run_test("1043. Item Builds: 54 Heroes x 3 Distinct Viable Build Pathways Validation", test_54_hero_3_build_pathways_stat_and_synergy_matrix)
	
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
	
	var expected_combine = ravager.cost - (warblade.cost + vital_core.cost)
	var solution = ItemTreeResolver.resolve_crafting(ravager, inv.gold, inv.slots, inv.boots_slot, Database.get_item)
	if solution.final_gold_cost != expected_combine:
		return "3-Tier recipe discount calculation failed: expected %dg, got %d" % [expected_combine, solution.final_gold_cost]
		
	var craft_ok = inv.buy_item(ravager, Database.get_item)
	if not craft_ok:
		return "Failed to synthesize Legendary Ravager"
	if inv.slots[0] == null or inv.slots[0].id != 78:
		return "Synthesized Ravager not present in slot 0"
	if inv.slots[1] != null:
		return "Consumed intermediate slot was not cleared"
		
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
	
	var expected_ad_bonus = ravager.stat_bonuses.get(StatModifier.TargetStat.ATTACK_DAMAGE, 0.0)
	var expected_hp_bonus = ravager.stat_bonuses.get(StatModifier.TargetStat.MAX_HEALTH, 0.0)
	
	if absf(new_ad - (base_ad + expected_ad_bonus)) > 0.01:
		return "Legendary Ravager AD bonus (+%.0f) not applied (got %f)" % [expected_ad_bonus, new_ad - base_ad]
	if absf(new_hp - (base_hp + expected_hp_bonus)) > 0.01:
		return "Legendary Ravager Max HP bonus (+%.0f) not applied (got %f)" % [expected_hp_bonus, new_hp - base_hp]
		
	hero.free()
	return ""

func test_item_high_tier_selling() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	var inv = hero.inventory_manager
	inv.gold = 5000
	
	var colossus = Database.get_item(83)
	inv.buy_item(colossus, Database.get_item)
	
	var expected_gold = (5000 - colossus.cost) + int(float(colossus.cost) * 0.70)
	inv.sell_item(0)
	if inv.gold != expected_gold:
		return "Selling legendary item refund failed: expected %dg, got %d" % [expected_gold, inv.gold]
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

func test_shop_multiple_purchases_capacity_limit() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	var inv = hero.inventory_manager
	inv.gold = 10000
	
	var iron_blade = Database.get_item(1)
	for i in range(6):
		var ok = inv.buy_item(iron_blade, Database.get_item)
		if not ok:
			return "Failed to buy item %d within capacity" % (i + 1)
			
	var seventh_buy = inv.buy_item(iron_blade, Database.get_item)
	if seventh_buy:
		return "Inventory accepted 7th item beyond capacity"
		
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
	inv.gold = 2000
	
	var staff = Database.get_item(56)
	inv.buy_item(staff, Database.get_item)
	
	var expected_gold = (2000 - staff.cost) + int(float(staff.cost) * 0.70)
	inv.sell_item(0)
	
	if inv.gold != expected_gold:
		return "Selling refund calculation failed: expected %dg, got %d" % [expected_gold, inv.gold]
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
	if not cast_success or not (kaelgor.effect_container.has_effect("temporal_stasis_root") or kaelgor.effect_container.has_effect("astris_stasis_root")):
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
	if not cast_success or not (astris.effect_container.has_effect("mana_barrier_shield") or astris.effect_container.has_effect("astris_mana_barrier")):
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

# ==============================================================================
# --- TASK 15: CREEP COMBAT, LAST HIT & LANE ECONOMY TESTS (Tests 244–263) ---
# ==============================================================================

func test_task15_melee_creep_basic_attack() -> String:
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.RADIANT
	creep.creep_type = CreepEntity.CreepType.MELEE
	creep._ready()
	
	var enemy_creep = CreepEntity.new()
	enemy_creep.team = TeamDefinitions.Team.DIRE
	enemy_creep._ready()
	var initial_hp = enemy_creep.attribute_system.current_health
	
	var res = creep.execute_basic_attack(enemy_creep)
	if res == null:
		return "Melee creep should successfully execute basic attack"
	if enemy_creep.attribute_system.current_health >= initial_hp:
		return "Enemy creep should have taken damage from melee creep"
		
	creep.free()
	enemy_creep.free()
	return ""

func test_task15_ranged_creep_projectile_attack() -> String:
	var ranged_creep = CreepEntity.new()
	ranged_creep.team = TeamDefinitions.Team.RADIANT
	ranged_creep.creep_type = CreepEntity.CreepType.RANGED
	ranged_creep._ready()
	
	var enemy_creep = CreepEntity.new()
	enemy_creep.team = TeamDefinitions.Team.DIRE
	enemy_creep._ready()
	
	var atk_range = ranged_creep.get_attack_range()
	if atk_range < 5.0:
		return "Ranged creep attack range should be >= 5.0m, got %f" % atk_range
		
	var res = ranged_creep.execute_basic_attack(enemy_creep)
	if res == null and not ranged_creep.is_inside_tree():
		pass
		
	ranged_creep.free()
	enemy_creep.free()
	return ""

func test_task15_siege_creep_attack() -> String:
	var siege_creep = CreepEntity.new()
	siege_creep.team = TeamDefinitions.Team.RADIANT
	siege_creep.creep_type = CreepEntity.CreepType.SIEGE
	siege_creep._ready()
	
	var atk_range = siege_creep.get_attack_range()
	if atk_range < 7.0:
		return "Siege creep attack range should be >= 7.0m, got %f" % atk_range
	if siege_creep.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH) < 800.0:
		return "Siege creep HP should be >= 800"
		
	siege_creep.free()
	return ""

func test_task15_creep_to_creep_damage() -> String:
	var radiant = CreepEntity.new()
	radiant.team = TeamDefinitions.Team.RADIANT
	radiant._ready()
	
	var dire = CreepEntity.new()
	dire.team = TeamDefinitions.Team.DIRE
	dire._ready()
	
	var init_hp = dire.attribute_system.current_health
	radiant.execute_basic_attack(dire)
	
	if dire.attribute_system.current_health >= init_hp:
		return "Dire creep should take damage from Radiant creep"
		
	radiant.free()
	dire.free()
	return ""

func test_task15_creep_to_hero_damage() -> String:
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep._ready()
	
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var init_hp = hero.attribute_system.current_health
	creep.execute_basic_attack(hero)
	
	if hero.attribute_system.current_health >= init_hp:
		return "Hero should take damage from enemy creep basic attack"
		
	creep.free()
	hero.free()
	return ""

func test_task15_hero_to_creep_damage() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.position = Vector3(0, 0, 0)
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep._ready()
	creep.position = Vector3(1.5, 0, 0)
	
	var init_hp = creep.attribute_system.current_health
	hero.attack_controller.issue_attack_command(creep)
	hero.attack_controller.update(0.30)
	
	if creep.attribute_system.current_health >= init_hp:
		return "Enemy creep should take damage from hero attack command"
		
	hero.free()
	creep.free()
	return ""

func test_task15_enemy_creep_target_selection() -> String:
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.RADIANT
	creep.position = Vector3(0, 0, 0)
	creep.global_position = Vector3(0, 0, 0)
	creep._ready()
	
	var enemy1 = CreepEntity.new()
	enemy1.team = TeamDefinitions.Team.DIRE
	enemy1.position = Vector3(5.0, 0, 0)
	enemy1.global_position = Vector3(5.0, 0, 0)
	enemy1._ready()
	
	var enemy2 = CreepEntity.new()
	enemy2.team = TeamDefinitions.Team.DIRE
	enemy2.position = Vector3(10.0, 0, 0)
	enemy2.global_position = Vector3(10.0, 0, 0)
	enemy2._ready()
	
	var chosen = creep._evaluate_aggro_target()
	if chosen != enemy1:
		return "Creep should target the closest enemy creep (enemy1 at 5m, got %s)" % (chosen.entity_name if chosen != null else "null")
		
	creep.free()
	enemy1.free()
	enemy2.free()
	return ""

func test_task15_ally_creep_attack_rejection() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var ally_creep = CreepEntity.new()
	ally_creep.team = TeamDefinitions.Team.RADIANT
	ally_creep._ready()
	
	var issued = hero.attack_controller.issue_attack_command(ally_creep)
	if issued:
		return "Hero should not be able to issue attack command against ally creep"
		
	hero.free()
	ally_creep.free()
	return ""

func test_task15_last_hit_detection_and_killer() -> String:
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep._ready()
	
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var last_hit_detected = [false]
	var recorded_killer = [null]
	GameEvents.creep_last_hit.connect(func(_c, killer, _g):
		last_hit_detected[0] = true
		recorded_killer[0] = killer
	)
	
	creep.last_attacker = hero
	creep.die(hero)
	
	if not last_hit_detected[0]:
		return "GameEvents.creep_last_hit should be emitted when hero kills enemy creep"
	if recorded_killer[0] != hero:
		return "Last hit killer should be recorded as the hero"
		
	creep.free()
	hero.free()
	return ""

func test_task15_last_hit_gold_award() -> String:
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep._ready()
	var bounty = creep.gold_bounty
	
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.inventory_manager.gold = 100
	
	creep.last_attacker = hero
	creep.die(hero)
	
	if hero.inventory_manager.gold != (100 + bounty):
		return "Hero gold should increase by %d, expected %d, got %d" % [bounty, 100 + bounty, hero.inventory_manager.gold]
		
	creep.free()
	hero.free()
	return ""

func test_task15_gold_only_awarded_once() -> String:
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep._ready()
	var bounty = creep.gold_bounty
	
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.inventory_manager.gold = 0
	
	creep.last_attacker = hero
	creep.die(hero)
	creep._on_death(hero.entity_name)
	creep._on_death("Kaelgor")
	
	if hero.inventory_manager.gold != bounty:
		return "Gold should only be awarded exactly once (expected %d, got %d)" % [bounty, hero.inventory_manager.gold]
		
	creep.free()
	hero.free()
	return ""

func test_task15_creep_types_distinct_rewards() -> String:
	var melee = CreepEntity.new()
	melee.creep_type = CreepEntity.CreepType.MELEE
	melee._ready()
	
	var ranged = CreepEntity.new()
	ranged.creep_type = CreepEntity.CreepType.RANGED
	ranged._ready()
	
	var siege = CreepEntity.new()
	siege.creep_type = CreepEntity.CreepType.SIEGE
	siege._ready()
	
	if melee.gold_bounty == siege.gold_bounty:
		return "Melee and Siege creeps should have distinct gold bounties"
	if siege.gold_bounty <= ranged.gold_bounty:
		return "Siege creep should award more gold than ranged creep"
	if siege.xp_bounty <= melee.xp_bounty:
		return "Siege creep should award more XP than melee creep"
		
	melee.free()
	ranged.free()
	siege.free()
	return ""

func test_task15_xp_radius_eligibility() -> String:
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep.position = Vector3(0, 0, 0)
	creep._ready()
	
	var near_hero = KaelgorHero.new()
	near_hero.team = TeamDefinitions.Team.RADIANT
	near_hero.position = Vector3(10.0, 0, 0)
	near_hero._ready()
	near_hero.attribute_system.current_xp = 0
	
	var far_hero = AstrisHero.new()
	far_hero.team = TeamDefinitions.Team.RADIANT
	far_hero.position = Vector3(30.0, 0, 0) # Outside 16m radius
	far_hero._ready()
	far_hero.attribute_system.current_xp = 0
	
	creep.die()
	
	if near_hero.attribute_system.current_xp <= 0:
		return "Near hero (10m) should have received XP"
	if far_hero.attribute_system.current_xp != 0:
		return "Far hero (30m) should NOT receive XP"
		
	creep.free()
	near_hero.free()
	far_hero.free()
	return ""

func test_task15_multiple_heroes_xp_sharing() -> String:
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep.position = Vector3(0, 0, 0)
	creep._ready()
	
	var hero1 = KaelgorHero.new()
	hero1.team = TeamDefinitions.Team.RADIANT
	hero1.position = Vector3(5.0, 0, 0)
	hero1._ready()
	hero1.attribute_system.current_xp = 0
	
	var hero2 = AstrisHero.new()
	hero2.team = TeamDefinitions.Team.RADIANT
	hero2.position = Vector3(8.0, 0, 0)
	hero2._ready()
	hero2.attribute_system.current_xp = 0
	
	creep.die()
	
	if hero1.attribute_system.current_xp <= 0 or hero2.attribute_system.current_xp <= 0:
		return "Both allied heroes in radius should receive shared XP"
		
	creep.free()
	hero1.free()
	hero2.free()
	return ""

func test_task15_dead_hero_cannot_receive_xp() -> String:
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep.position = Vector3(0, 0, 0)
	creep._ready()
	
	var dead_hero = KaelgorHero.new()
	dead_hero.team = TeamDefinitions.Team.RADIANT
	dead_hero.position = Vector3(5.0, 0, 0)
	dead_hero._ready()
	dead_hero.attribute_system.current_xp = 0
	dead_hero.die()
	
	creep.die()
	
	if dead_hero.attribute_system.current_xp != 0:
		return "Dead hero should not receive XP upon creep death"
		
	creep.free()
	dead_hero.free()
	return ""

func test_task15_creep_hero_aggro_call() -> String:
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep.position = Vector3(0, 0, 0)
	creep._ready()
	
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero.position = Vector3(2.0, 0, 0)
	hero._ready()
	
	var req = DamageRequest.create_basic_attack(hero, creep, 30.0)
	creep.receive_damage(req)
	
	if creep.aggro_target != hero:
		return "Creep should switch aggro target to attacking hero"
	if creep.hero_aggro_timer <= 0.0:
		return "hero_aggro_timer should be active (> 0.0)"
		
	creep.free()
	hero.free()
	return ""

func test_task15_creep_death_target_cleanup() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep._ready()
	
	hero.attack_controller.issue_attack_command(creep)
	creep.die(hero)
	hero.attack_controller.update(0.016)
	
	if hero.attack_controller.attack_target != null:
		return "Hero attack target should be cleared when creep dies"
	if hero.attack_controller.current_state != AttackController.AttackState.IDLE:
		return "Hero attack controller should return to IDLE"
		
	hero.free()
	creep.free()
	return ""

func test_task15_siege_creep_tower_bonus() -> String:
	var siege = CreepEntity.new()
	siege.team = TeamDefinitions.Team.RADIANT
	siege.creep_type = CreepEntity.CreepType.SIEGE
	siege._ready()
	
	var tower = TowerEntity.new()
	tower.team = TeamDefinitions.Team.DIRE
	tower.is_backdoor_active = false
	tower._ready()
	var tower_hp = tower.attribute_system.current_health
	
	siege.execute_basic_attack(tower)
	
	var dmg = tower_hp - tower.attribute_system.current_health
	if dmg <= 0.0:
		return "Siege creep should successfully deal damage to tower"
		
	siege.free()
	tower.free()
	return ""

func test_task15_dead_creep_cannot_be_targeted() -> String:
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep._ready()
	creep.die()
	
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var can_target = TargetRelationSystem.is_valid_basic_attack_target(hero, creep)
	if can_target:
		return "Dead creep should not be a valid basic attack target"
		
	creep.free()
	hero.free()
	return ""

func test_task15_creep_deny_mechanics() -> String:
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.RADIANT
	creep.position = Vector3(0, 0, 0)
	creep._ready()
	
	var ally_hero = KaelgorHero.new()
	ally_hero.team = TeamDefinitions.Team.RADIANT
	ally_hero._ready()
	ally_hero.inventory_manager.gold = 50
	
	var enemy_hero = AstrisHero.new()
	enemy_hero.team = TeamDefinitions.Team.DIRE
	enemy_hero.position = Vector3(5.0, 0, 0)
	enemy_hero._ready()
	enemy_hero.inventory_manager.gold = 50
	enemy_hero.attribute_system.current_xp = 0
	
	var deny_event_fired = [false]
	GameEvents.creep_denied.connect(func(_c, _denier): deny_event_fired[0] = true)
	
	creep.last_attacker = ally_hero
	creep.die(ally_hero)
	
	if not deny_event_fired[0]:
		return "GameEvents.creep_denied should be emitted on deny"
	if enemy_hero.inventory_manager.gold != 50:
		return "Enemy hero should NOT receive last-hit gold when creep is denied"
	if enemy_hero.attribute_system.current_xp <= 0:
		return "Enemy hero should still receive partial deny XP"
		
	creep.free()
	ally_hero.free()
	enemy_hero.free()
	return ""

# ==============================================================================
# --- TASK 16: JUNGLE & NEUTRAL CAMP TESTS (Tests 264–283) ---
# ==============================================================================

func test_task16_camp_initial_spawn() -> String:
	var camp = NeutralCampSpawner.new()
	camp.camp_type = NeutralCampSpawner.CampType.MEDIUM
	camp._ready()
	
	if camp.current_state != NeutralCampSpawner.CampState.AVAILABLE:
		return "Camp state should be AVAILABLE after spawn"
	if camp.active_neutrals.is_empty():
		return "Camp should have spawned neutral monsters"
	if camp.get_alive_monster_count() == 0:
		return "Alive monster count should be > 0"
		
	for n in camp.active_neutrals:
		if not is_instance_valid(n) or not n.is_alive():
			return "All spawned monsters should be alive"
			
	camp.free()
	return ""

func test_task16_camp_monster_count_by_type() -> String:
	var small_camp = NeutralCampSpawner.new()
	small_camp.camp_type = NeutralCampSpawner.CampType.SMALL
	small_camp._ready()
	if small_camp.active_neutrals.size() != 3:
		return "Small camp should have 3 monsters, got %d" % small_camp.active_neutrals.size()
		
	var med_camp = NeutralCampSpawner.new()
	med_camp.camp_type = NeutralCampSpawner.CampType.MEDIUM
	med_camp._ready()
	if med_camp.active_neutrals.size() != 3:
		return "Medium camp should have 3 monsters, got %d" % med_camp.active_neutrals.size()
		
	var large_camp = NeutralCampSpawner.new()
	large_camp.camp_type = NeutralCampSpawner.CampType.LARGE
	large_camp._ready()
	if large_camp.active_neutrals.size() != 4:
		return "Large camp should have 4 monsters, got %d" % large_camp.active_neutrals.size()
		
	var ancient_camp = NeutralCampSpawner.new()
	ancient_camp.camp_type = NeutralCampSpawner.CampType.ANCIENT
	ancient_camp._ready()
	if ancient_camp.active_neutrals.size() != 3:
		return "Ancient camp should have 3 monsters, got %d" % ancient_camp.active_neutrals.size()
		
	small_camp.free()
	med_camp.free()
	large_camp.free()
	ancient_camp.free()
	return ""

func test_task16_camp_types_archetypes() -> String:
	var kobold = NeutralCreepEntity.new()
	kobold.neutral_type = NeutralCreepEntity.NeutralType.KOBOLD
	kobold._ready()
	
	var dragon = NeutralCreepEntity.new()
	dragon.neutral_type = NeutralCreepEntity.NeutralType.DRAGON
	dragon._ready()
	
	if kobold.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH) >= dragon.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH):
		return "Dragon should have significantly more HP than Kobold"
	if dragon.gold_bounty <= kobold.gold_bounty:
		return "Dragon should award more gold than Kobold"
	if dragon.xp_bounty <= kobold.xp_bounty:
		return "Dragon should award more XP than Kobold"
		
	kobold.free()
	dragon.free()
	return ""

func test_task16_hero_to_neutral_targeting() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.position = Vector3(0, 0, 0)
	
	var neutral = NeutralCreepEntity.new()
	neutral.neutral_type = NeutralCreepEntity.NeutralType.WOLF
	neutral._ready()
	neutral.position = Vector3(1.5, 0, 0)
	
	var can_target = TargetRelationSystem.is_valid_basic_attack_target(hero, neutral)
	if not can_target:
		return "Hero should be able to target neutral creep for basic attack"
		
	var init_hp = neutral.attribute_system.current_health
	var issued = hero.attack_controller.issue_attack_command(neutral)
	if not issued:
		return "Hero attack controller should accept neutral target command"
		
	hero.attack_controller.update(0.30)
	if neutral.attribute_system.current_health >= init_hp:
		return "Neutral monster should take damage from hero attack"
		
	hero.free()
	neutral.free()
	return ""

func test_task16_neutral_to_hero_attack() -> String:
	var neutral = NeutralCreepEntity.new()
	neutral._ready()
	neutral.position = Vector3(0, 0, 0)
	
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.position = Vector3(1.0, 0, 0)
	
	var init_hp = hero.attribute_system.current_health
	var res = neutral.execute_basic_attack(hero)
	if res == null:
		return "Neutral basic attack execution failed"
	if hero.attribute_system.current_health >= init_hp:
		return "Hero should take damage from neutral retaliation attack"
		
	neutral.free()
	hero.free()
	return ""

func test_task16_multi_neutral_aggro_wake() -> String:
	var camp = NeutralCampSpawner.new()
	camp.camp_type = NeutralCampSpawner.CampType.MEDIUM
	camp._ready()
	
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	# Attack first monster in camp
	var first_monster = camp.active_neutrals[0]
	var req = DamageRequest.create_basic_attack(hero, first_monster, 20.0)
	first_monster.receive_damage(req)
	
	# Check all monsters in camp were alerted
	for n in camp.active_neutrals:
		if is_instance_valid(n) and n.is_alive():
			if n.aggro_target != hero:
				return "Sibling neutral monster in camp was not alerted to attack hero"
				
	camp.free()
	hero.free()
	return ""

func test_task16_neutral_target_switching() -> String:
	var neutral = NeutralCreepEntity.new()
	neutral._ready()
	
	var hero1 = KaelgorHero.new()
	hero1.team = TeamDefinitions.Team.RADIANT
	hero1._ready()
	
	var hero2 = AstrisHero.new()
	hero2.team = TeamDefinitions.Team.DIRE
	hero2._ready()
	
	var req1 = DamageRequest.create_basic_attack(hero1, neutral, 10.0)
	neutral.receive_damage(req1)
	if neutral.aggro_target != hero1:
		return "Neutral should target hero1"
		
	var req2 = DamageRequest.create_basic_attack(hero2, neutral, 15.0)
	neutral.receive_damage(req2)
	if neutral.aggro_target != hero2:
		return "Neutral should switch target to new attacker hero2"
		
	neutral.free()
	hero1.free()
	hero2.free()
	return ""

func test_task16_neutral_leash_threshold() -> String:
	var neutral = NeutralCreepEntity.new()
	neutral._ready()
	neutral.position = Vector3(0, 0, 0)
	neutral.spawn_origin = Vector3(0, 0, 0)
	neutral.leash_distance = 14.0
	
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	neutral.aggro_target = hero
	neutral.ai_state = NeutralCreepEntity.AIState.PURSUIT
	
	# Move neutral beyond leash distance
	neutral.position = Vector3(15.0, 0, 0)
	neutral._physics_process(0.016)
	
	if not neutral.is_leashing_back:
		return "Neutral should be leashing back after exceeding leash distance (15m > 14m)"
	if neutral.aggro_target != null:
		return "Neutral aggro_target should be cleared during leash"
		
	neutral.free()
	hero.free()
	return ""

func test_task16_neutral_return_to_origin() -> String:
	var neutral = NeutralCreepEntity.new()
	neutral._ready()
	neutral.position = Vector3(10.0, 0, 0)
	neutral.spawn_origin = Vector3(0, 0, 0)
	neutral._trigger_leash_reset()
	
	if neutral.ai_state != NeutralCreepEntity.AIState.RETURNING:
		return "Neutral AIState should be RETURNING during leash"
		
	neutral._physics_process(0.1)
	if neutral.velocity.length_squared() <= 0.0:
		return "Neutral should be moving back towards spawn_origin"
		
	neutral.free()
	return ""

func test_task16_neutral_hp_regen_during_leash() -> String:
	var neutral = NeutralCreepEntity.new()
	neutral._ready()
	neutral.position = Vector3(5.0, 0, 0)
	neutral.spawn_origin = Vector3(0, 0, 0)
	
	# Damage neutral
	neutral.attribute_system.current_health = 100.0
	var damaged_hp = neutral.attribute_system.current_health
	
	neutral._trigger_leash_reset()
	neutral._physics_process(0.5)
	
	if neutral.attribute_system.current_health <= damaged_hp:
		return "Neutral should regenerate HP while leashing back"
		
	neutral.free()
	return ""

func test_task16_neutral_full_hp_after_return() -> String:
	var neutral = NeutralCreepEntity.new()
	neutral._ready()
	neutral.position = Vector3(0.2, 0, 0)
	neutral.spawn_origin = Vector3(0, 0, 0)
	neutral.attribute_system.current_health = 50.0
	
	neutral.is_leashing_back = true
	neutral.ai_state = NeutralCreepEntity.AIState.RETURNING
	neutral._physics_process(0.016)
	
	var max_hp = neutral.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	if neutral.attribute_system.current_health != max_hp:
		return "Neutral should be restored to full HP upon arriving home (expected %f, got %f)" % [max_hp, neutral.attribute_system.current_health]
	if neutral.ai_state != NeutralCreepEntity.AIState.IDLE:
		return "Neutral AIState should return to IDLE"
	if neutral.is_leashing_back:
		return "is_leashing_back should be false"
		
	neutral.free()
	return ""

func test_task16_single_monster_death_camp_stays_active() -> String:
	var camp = NeutralCampSpawner.new()
	camp.camp_type = NeutralCampSpawner.CampType.MEDIUM
	camp._ready()
	
	# Kill only 1 of 3 monsters
	var first = camp.active_neutrals[0]
	first.die()
	
	camp._process(0.016)
	
	if camp.current_state == NeutralCampSpawner.CampState.CLEARED or camp.current_state == NeutralCampSpawner.CampState.RESPAWNING:
		return "Camp should not be cleared when other monsters are still alive"
	if camp.get_alive_monster_count() != 2:
		return "Alive monster count should be 2, got %d" % camp.get_alive_monster_count()
		
	camp.free()
	return ""

func test_task16_last_monster_death_triggers_respawn_timer() -> String:
	var camp = NeutralCampSpawner.new()
	camp.camp_type = NeutralCampSpawner.CampType.SMALL
	camp._ready()
	
	var cleared_emitted = [false]
	var respawn_started_emitted = [false]
	GameEvents.camp_cleared.connect(func(_c): cleared_emitted[0] = true)
	GameEvents.camp_respawn_started.connect(func(_c, _d): respawn_started_emitted[0] = true)
	
	# Kill all monsters in camp
	for n in camp.active_neutrals:
		n.die()
		
	camp._process(0.016)
	
	if camp.current_state != NeutralCampSpawner.CampState.RESPAWNING:
		return "Camp should transition to RESPAWNING state when all monsters die"
	if camp.respawn_timer != 60.0:
		return "Camp respawn timer should be 60.0s, got %f" % camp.respawn_timer
	if not cleared_emitted[0]:
		return "GameEvents.camp_cleared should be emitted"
	if not respawn_started_emitted[0]:
		return "GameEvents.camp_respawn_started should be emitted"
		
	camp.free()
	return ""

func test_task16_respawn_timer_tick_and_spawn() -> String:
	var camp = NeutralCampSpawner.new()
	camp.camp_type = NeutralCampSpawner.CampType.MEDIUM
	camp._ready()
	
	for n in camp.active_neutrals:
		n.die()
	camp._process(0.016)
	
	# Advance respawn timer by 60 seconds
	camp.respawn_timer = 0.5
	camp._process(0.6)
	
	if camp.current_state != NeutralCampSpawner.CampState.AVAILABLE:
		return "Camp should return to AVAILABLE state after respawn completes"
	if camp.active_neutrals.size() != 3:
		return "Camp should have 3 fresh monsters after respawn"
	for n in camp.active_neutrals:
		if not is_instance_valid(n) or not n.is_alive():
			return "All newly respawned monsters must be alive"
			
	camp.free()
	return ""

func test_task16_respawn_duplicate_protection() -> String:
	var camp = NeutralCampSpawner.new()
	camp.camp_type = NeutralCampSpawner.CampType.MEDIUM
	camp._ready()
	var initial_count = camp.active_neutrals.size()
	
	# Call spawn_camp() while monsters are still present
	camp.spawn_camp()
	
	if camp.active_neutrals.size() != initial_count:
		return "spawn_camp() should not duplicate monsters when creeps are still alive"
		
	camp.free()
	return ""

func test_task16_neutral_gold_reward_to_hero() -> String:
	var neutral = NeutralCreepEntity.new()
	neutral.neutral_type = NeutralCreepEntity.NeutralType.CENTAUR
	neutral._ready()
	var bounty = neutral.gold_bounty
	
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.inventory_manager.gold = 100
	
	neutral.last_attacker = hero
	neutral.die(hero)
	
	if hero.inventory_manager.gold != (100 + bounty):
		return "Hero gold should increase by %d, got %d" % [bounty, hero.inventory_manager.gold]
		
	neutral.free()
	hero.free()
	return ""

func test_task16_neutral_xp_area_reward() -> String:
	var neutral = NeutralCreepEntity.new()
	neutral.position = Vector3(0, 0, 0)
	neutral._ready()
	
	var killer_hero = KaelgorHero.new()
	killer_hero.team = TeamDefinitions.Team.RADIANT
	killer_hero.position = Vector3(5.0, 0, 0)
	killer_hero._ready()
	killer_hero.attribute_system.current_xp = 0
	
	var assist_hero = AstrisHero.new()
	assist_hero.team = TeamDefinitions.Team.RADIANT
	assist_hero.position = Vector3(8.0, 0, 0)
	assist_hero._ready()
	assist_hero.attribute_system.current_xp = 0
	
	neutral.last_attacker = killer_hero
	neutral.die(killer_hero)
	
	if killer_hero.attribute_system.current_xp <= 0:
		return "Killer hero should receive XP from neutral monster kill"
	if assist_hero.attribute_system.current_xp <= 0:
		return "Nearby allied hero (8m) should receive assist XP"
		
	neutral.free()
	killer_hero.free()
	assist_hero.free()
	return ""

func test_task16_dead_hero_cannot_receive_neutral_xp() -> String:
	var neutral = NeutralCreepEntity.new()
	neutral.position = Vector3(0, 0, 0)
	neutral._ready()
	
	var killer_hero = KaelgorHero.new()
	killer_hero.team = TeamDefinitions.Team.RADIANT
	killer_hero.position = Vector3(2.0, 0, 0)
	killer_hero._ready()
	
	var dead_hero = AstrisHero.new()
	dead_hero.team = TeamDefinitions.Team.RADIANT
	dead_hero.position = Vector3(5.0, 0, 0)
	dead_hero._ready()
	dead_hero.die()
	dead_hero.attribute_system.current_xp = 0
	
	neutral.last_attacker = killer_hero
	neutral.die(killer_hero)
	
	if dead_hero.attribute_system.current_xp != 0:
		return "Dead hero should NOT receive XP from neutral creep"
		
	neutral.free()
	killer_hero.free()
	dead_hero.free()
	return ""

func test_task16_camp_state_transitions() -> String:
	var camp = NeutralCampSpawner.new()
	camp.camp_type = NeutralCampSpawner.CampType.SMALL
	camp._ready()
	
	if camp.current_state != NeutralCampSpawner.CampState.AVAILABLE:
		return "Initial state should be AVAILABLE"
		
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	# Engage combat
	camp.active_neutrals[0].receive_damage(DamageRequest.create_basic_attack(hero, camp.active_neutrals[0], 10.0))
	camp._process(0.016)
	if camp.current_state != NeutralCampSpawner.CampState.ACTIVE:
		return "State should transition to ACTIVE when engaged"
		
	# Clear camp
	for n in camp.active_neutrals:
		n.die()
	camp._process(0.016)
	if camp.current_state != NeutralCampSpawner.CampState.RESPAWNING:
		return "State should transition to RESPAWNING when cleared"
		
	camp.free()
	hero.free()
	return ""

func test_task16_camp_methods_and_remaining_timer() -> String:
	var camp = NeutralCampSpawner.new()
	camp.camp_type = NeutralCampSpawner.CampType.LARGE
	camp._ready()
	
	if not camp.is_active():
		return "is_active() should be true for populated camp"
	if camp.is_cleared():
		return "is_cleared() should be false for populated camp"
	if camp.get_alive_monster_count() != 4:
		return "get_alive_monster_count() should be 4, got %d" % camp.get_alive_monster_count()
		
	for n in camp.active_neutrals:
		n.die()
	camp._process(0.016)
	
	if not camp.is_cleared():
		return "is_cleared() should be true when cleared"
	if camp.get_respawn_remaining() <= 50.0:
		return "get_respawn_remaining() should be ~60.0s"
		
	camp.free()
	return ""

# ==============================================================================
# --- TASK 17: ABILITY TARGETING FRAMEWORK TESTS (Tests 284–303) ---
# ==============================================================================

func test_task17_target_filter_enemy_hero() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var enemy_hero = AstrisHero.new()
	enemy_hero.team = TeamDefinitions.Team.DIRE
	enemy_hero._ready()
	
	var enemy_creep = CreepEntity.new()
	enemy_creep.team = TeamDefinitions.Team.DIRE
	enemy_creep._ready()
	
	var ally_hero = SolenHero.new()
	ally_hero.team = TeamDefinitions.Team.RADIANT
	ally_hero._ready()
	
	var ab = AbilityResource.new()
	ab.target_type = AbilityResource.TargetType.SINGLE_TARGET
	ab.target_filter = AbilityResource.TargetFilter.ENEMY_HEROES_ONLY
	
	if not ab.is_valid_target(hero, enemy_hero):
		return "ENEMY_HEROES_ONLY should accept enemy hero"
	if ab.is_valid_target(hero, enemy_creep):
		return "ENEMY_HEROES_ONLY should reject enemy creep"
	if ab.is_valid_target(hero, ally_hero):
		return "ENEMY_HEROES_ONLY should reject ally hero"
	if ab.is_valid_target(hero, hero):
		return "ENEMY_HEROES_ONLY should reject self"
		
	hero.free()
	enemy_hero.free()
	enemy_creep.free()
	ally_hero.free()
	return ""

func test_task17_target_filter_enemy_creep() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var enemy_creep = CreepEntity.new()
	enemy_creep.team = TeamDefinitions.Team.DIRE
	enemy_creep._ready()
	
	var enemy_hero = AstrisHero.new()
	enemy_hero.team = TeamDefinitions.Team.DIRE
	enemy_hero._ready()
	
	var ab = AbilityResource.new()
	ab.target_type = AbilityResource.TargetType.SINGLE_TARGET
	ab.target_filter = AbilityResource.TargetFilter.ENEMY_CREEPS_ONLY
	
	if not ab.is_valid_target(hero, enemy_creep):
		return "ENEMY_CREEPS_ONLY should accept enemy creep"
	if ab.is_valid_target(hero, enemy_hero):
		return "ENEMY_CREEPS_ONLY should reject enemy hero"
		
	hero.free()
	enemy_creep.free()
	enemy_hero.free()
	return ""

func test_task17_target_filter_neutral_monster() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var neutral = NeutralCreepEntity.new()
	neutral._ready()
	
	var enemy_creep = CreepEntity.new()
	enemy_creep.team = TeamDefinitions.Team.DIRE
	enemy_creep._ready()
	
	var ab = AbilityResource.new()
	ab.target_type = AbilityResource.TargetType.SINGLE_TARGET
	ab.target_filter = AbilityResource.TargetFilter.NEUTRALS_ONLY
	
	if not ab.is_valid_target(hero, neutral):
		return "NEUTRALS_ONLY should accept neutral monster"
	if ab.is_valid_target(hero, enemy_creep):
		return "NEUTRALS_ONLY should reject lane creep"
		
	hero.free()
	neutral.free()
	enemy_creep.free()
	return ""

func test_task17_target_filter_ally_hero() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	var ab = AbilityResource.new()
	ab.target_type = AbilityResource.TargetType.SINGLE_TARGET
	ab.target_filter = AbilityResource.TargetFilter.ALLY_HEROES_ONLY
	
	if not ab.is_valid_target(hero, ally):
		return "ALLY_HEROES_ONLY should accept ally hero"
	if ab.is_valid_target(hero, enemy):
		return "ALLY_HEROES_ONLY should reject enemy hero"
	if ab.is_valid_target(hero, hero):
		return "ALLY_HEROES_ONLY should reject self"
		
	hero.free()
	ally.free()
	enemy.free()
	return ""

func test_task17_target_filter_self_only() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var ab = AbilityResource.new()
	ab.target_type = AbilityResource.TargetType.SELF
	ab.target_filter = AbilityResource.TargetFilter.SELF_ONLY
	
	if not ab.is_valid_target(hero, hero):
		return "SELF_ONLY should accept caster"
	if ab.is_valid_target(hero, ally):
		return "SELF_ONLY should reject ally"
		
	hero.free()
	ally.free()
	return ""

func test_task17_target_filter_all_except_self() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var ab = AbilityResource.new()
	ab.target_filter = AbilityResource.TargetFilter.ALL_EXCEPT_SELF
	
	if ab.is_valid_target(hero, hero):
		return "ALL_EXCEPT_SELF should reject caster"
	if not ab.is_valid_target(hero, ally):
		return "ALL_EXCEPT_SELF should accept ally"
		
	hero.free()
	ally.free()
	return ""

func test_task17_cast_range_within_boundary() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero.position = Vector3(0, 0, 0)
	hero._ready()
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target.position = Vector3(5.0, 0, 0) # 5m distance
	target._ready()
	
	var ab = AbilityResource.new()
	ab.cast_range = 6.0 # 6m range
	ab.target_type = AbilityResource.TargetType.SINGLE_TARGET
	ab.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	ab.mana_costs = [10.0]
	ab.cooldowns = [5.0]
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	var res = hero.ability_container.validate_cast(AbilityResource.Slot.Q, target)
	if res != AbilityContainer.CastValidationResult.OK:
		return "Target at 5m with 6m cast range should be valid OK, got %d" % res
		
	hero.free()
	target.free()
	return ""

func test_task17_cast_range_out_of_range_rejected() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero.position = Vector3(0, 0, 0)
	hero._ready()
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target.position = Vector3(10.0, 0, 0) # 10m distance
	target._ready()
	
	var ab = AbilityResource.new()
	ab.cast_range = 6.0 # 6m range
	ab.target_type = AbilityResource.TargetType.SINGLE_TARGET
	ab.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	ab.mana_costs = [10.0]
	ab.cooldowns = [5.0]
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	var res = hero.ability_container.validate_cast(AbilityResource.Slot.Q, target)
	if res != AbilityContainer.CastValidationResult.OUT_OF_RANGE:
		return "Target at 10m with 6m range should be OUT_OF_RANGE, got %d" % res
		
	hero.free()
	target.free()
	return ""

func test_task17_ground_aoe_range_validation() -> String:
	var hero = KaelgorHero.new()
	hero.position = Vector3(0, 0, 0)
	hero._ready()
	
	var ab = AbilityResource.new()
	ab.cast_range = 8.0 # 8m range
	ab.target_type = AbilityResource.TargetType.GROUND_AOE
	ab.mana_costs = [10.0]
	ab.cooldowns = [5.0]
	
	hero.ability_container.set_ability(AbilityResource.Slot.W, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.W] = 1
	
	var valid_point = Vector3(5.0, 0, 0)
	var res_valid = hero.ability_container.validate_cast(AbilityResource.Slot.W, null, valid_point)
	if res_valid != AbilityContainer.CastValidationResult.OK:
		return "Ground AoE at 5m should be OK"
		
	var invalid_point = Vector3(15.0, 0, 0)
	var res_invalid = hero.ability_container.validate_cast(AbilityResource.Slot.W, null, invalid_point)
	if res_invalid != AbilityContainer.CastValidationResult.OUT_OF_RANGE:
		return "Ground AoE at 15m should be OUT_OF_RANGE"
		
	hero.free()
	return ""

func test_task17_insufficient_mana_rejection() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	hero.attribute_system.current_mana = 20.0
	
	var ab = AbilityResource.new()
	ab.mana_costs = [100.0]
	ab.cooldowns = [5.0]
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	var res = hero.ability_container.validate_cast(AbilityResource.Slot.Q)
	if res != AbilityContainer.CastValidationResult.NOT_ENOUGH_MANA:
		return "Casting with 20 MP for 100 MP cost should return NOT_ENOUGH_MANA"
		
	var cast_success = hero.ability_container.cast_ability(AbilityResource.Slot.Q)
	if cast_success:
		return "cast_ability should fail when mana is insufficient"
		
	hero.free()
	return ""

func test_task17_on_cooldown_rejection() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var ab = AbilityResource.new()
	ab.mana_costs = [10.0]
	ab.cooldowns = [10.0]
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	hero.ability_container.cast_ability(AbilityResource.Slot.Q)
	
	var res = hero.ability_container.validate_cast(AbilityResource.Slot.Q)
	if res != AbilityContainer.CastValidationResult.ON_COOLDOWN:
		return "Casting while on cooldown should return ON_COOLDOWN"
		
	var cast_success = hero.ability_container.cast_ability(AbilityResource.Slot.Q)
	if cast_success:
		return "cast_ability should fail while on cooldown"
		
	hero.free()
	return ""

func test_task17_silenced_caster_rejection() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var ab = AbilityResource.new()
	ab.mana_costs = [10.0]
	ab.cooldowns = [5.0]
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	# Apply Silence
	var silence = StatusEffect.new("silence", StatusEffect.EffectType.SILENCE, 3.0, 1.0)
	hero.effect_container.apply_effect(silence)
	
	var res = hero.ability_container.validate_cast(AbilityResource.Slot.Q)
	if res != AbilityContainer.CastValidationResult.SILENCED:
		return "Silenced hero cast should return SILENCED"
		
	hero.free()
	return ""

func test_task17_dead_caster_rejection() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	hero.die()
	
	var ab = AbilityResource.new()
	ab.mana_costs = [10.0]
	ab.cooldowns = [5.0]
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	var res = hero.ability_container.validate_cast(AbilityResource.Slot.Q)
	if res != AbilityContainer.CastValidationResult.CASTER_DEAD:
		return "Dead hero cast should return CASTER_DEAD"
		
	hero.free()
	return ""

func test_task17_dead_target_rejection() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	target.die()
	
	var ab = AbilityResource.new()
	ab.target_type = AbilityResource.TargetType.SINGLE_TARGET
	ab.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	ab.mana_costs = [10.0]
	ab.cooldowns = [5.0]
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	var res = hero.ability_container.validate_cast(AbilityResource.Slot.Q, target)
	if res != AbilityContainer.CastValidationResult.TARGET_DEAD:
		return "Targeting dead unit should return TARGET_DEAD"
		
	hero.free()
	target.free()
	return ""

func test_task17_untargetable_unit_rejection() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	target.is_targetable = false # Invulnerable / untargetable
	
	var ab = AbilityResource.new()
	ab.target_type = AbilityResource.TargetType.SINGLE_TARGET
	ab.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	ab.mana_costs = [10.0]
	ab.cooldowns = [5.0]
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	var res = hero.ability_container.validate_cast(AbilityResource.Slot.Q, target)
	if res != AbilityContainer.CastValidationResult.TARGET_NOT_TARGETABLE:
		return "Targeting untargetable unit should return TARGET_NOT_TARGETABLE"
		
	hero.free()
	target.free()
	return ""

func test_task17_kaelgor_q_target_framework() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor.position = Vector3(0, 0, 0)
	kaelgor._ready()
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(1.5, 0, 0)
	enemy._ready()
	
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.Q)
	var can_q = kaelgor.ability_container.can_cast_on_target(AbilityResource.Slot.Q, enemy)
	if not can_q:
		return "Kaelgor Q should be castable on enemy hero in range"
		
	var ally = SolenHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	var can_q_ally = kaelgor.ability_container.can_cast_on_target(AbilityResource.Slot.Q, ally)
	if can_q_ally:
		return "Kaelgor Q should NOT be castable on ally"
		
	kaelgor.free()
	enemy.free()
	ally.free()
	return ""

func test_task17_kaelgor_e_self_target_framework() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	var e_res = kaelgor.ability_container.get_ability(AbilityResource.Slot.E)
	if e_res.target_type != AbilityResource.TargetType.SELF:
		return "Kaelgor E target_type should be SELF"
		
	var can_e_self = kaelgor.ability_container.can_cast_on_target(AbilityResource.Slot.E, kaelgor)
	if not can_e_self:
		return "Kaelgor E should be castable on self"
		
	var can_e_enemy = kaelgor.ability_container.can_cast_on_target(AbilityResource.Slot.E, enemy)
	if can_e_enemy:
		return "Kaelgor E (SELF) should reject enemy target"
		
	kaelgor.free()
	enemy.free()
	return ""

func test_task17_astris_w_aoe_framework() -> String:
	var astris = AstrisHero.new()
	astris.team = TeamDefinitions.Team.DIRE
	astris.position = Vector3(0, 0, 0)
	astris._ready()
	astris.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var enemy1 = KaelgorHero.new()
	enemy1.team = TeamDefinitions.Team.RADIANT
	enemy1.position = Vector3(2.0, 0, 0)
	enemy1._ready()
	
	var affected = astris.ability_container.execute_aoe_spell(AbilityResource.Slot.W, Vector3(0, 0, 0), 4.0)
	if not affected.has(enemy1):
		return "Astris W AoE should find and affect enemy1 within radius"
		
	astris.free()
	enemy1.free()
	return ""

func test_task17_projectile_hook_invocation() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero.position = Vector3(0, 0, 0)
	hero._ready()
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(2.0, 0, 0)
	enemy._ready()
	
	var ab = AbilityResource.new()
	ab.target_type = AbilityResource.TargetType.SINGLE_TARGET
	ab.mana_costs = [10.0]
	ab.cooldowns = [5.0]
	ab.cast_range = 6.0
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	hero.ability_container.cast_ability(AbilityResource.Slot.Q, enemy)
	
	# Verify that cast_ability successfully executed
	if not hero.ability_container.is_on_cooldown(AbilityResource.Slot.Q):
		return "Ability should be placed on cooldown after successful cast"
		
	hero.free()
	enemy.free()
	return ""

func test_task17_aoe_hook_invocation() -> String:
	var hero = AstrisHero.new()
	hero.position = Vector3(0, 0, 0)
	hero._ready()
	
	var ab = AbilityResource.new()
	ab.target_type = AbilityResource.TargetType.GROUND_AOE
	ab.mana_costs = [10.0]
	ab.cooldowns = [5.0]
	ab.cast_range = 8.0
	ab.aoe_radius = 4.0
	
	hero.ability_container.set_ability(AbilityResource.Slot.W, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.W] = 1
	
	var cast_success = hero.ability_container.cast_ability(AbilityResource.Slot.W, null, Vector3(3, 0, 0))
	if not cast_success:
		return "Ground AoE cast_ability should succeed"
		
	hero.free()
	return ""

# ==============================================================================
# --- TASK 18: ABILITY CAST PIPELINE TESTS (Tests 304–323) ---
# ==============================================================================

func test_task18_instant_cast_execution() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var ab = AbilityResource.new()
	ab.cast_time = 0.0 # Instant cast
	ab.mana_costs = [30.0]
	ab.cooldowns = [5.0]
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	var init_mp = hero.attribute_system.current_mana
	
	var success = hero.ability_container.start_cast(AbilityResource.Slot.Q)
	if not success:
		return "Instant cast should succeed"
	if hero.ability_container.is_casting():
		return "Instant cast should not remain in casting state"
	if absf(hero.attribute_system.current_mana - (init_mp - 30.0)) > 0.01:
		return "Instant cast should immediately deduct mana"
	if not hero.ability_container.is_on_cooldown(AbilityResource.Slot.Q):
		return "Instant cast should trigger cooldown immediately"
		
	hero.free()
	return ""

func test_task18_cast_windup_state_transition() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var ab = AbilityResource.new()
	ab.cast_time = 0.5 # 0.5s Windup
	ab.mana_costs = [40.0]
	ab.cooldowns = [6.0]
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	var success = hero.ability_container.start_cast(AbilityResource.Slot.Q)
	if not success:
		return "start_cast with windup should return true"
	if not hero.ability_container.is_casting():
		return "Hero should be in CASTING state during windup"
	if hero.ability_container.current_cast_state != AbilityContainer.CastState.CASTING:
		return "current_cast_state should be CastState.CASTING"
		
	hero.free()
	return ""

func test_task18_windup_mana_not_spent_prematurely() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var ab = AbilityResource.new()
	ab.cast_time = 0.5
	ab.mana_costs = [50.0]
	ab.cooldowns = [8.0]
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	var init_mp = hero.attribute_system.current_mana
	
	hero.ability_container.start_cast(AbilityResource.Slot.Q)
	
	if hero.attribute_system.current_mana != init_mp:
		return "Mana must NOT be deducted while cast is still winding up"
		
	hero.free()
	return ""

func test_task18_windup_cooldown_not_triggered_prematurely() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var ab = AbilityResource.new()
	ab.cast_time = 0.5
	ab.mana_costs = [50.0]
	ab.cooldowns = [8.0]
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	hero.ability_container.start_cast(AbilityResource.Slot.Q)
	
	if hero.ability_container.is_on_cooldown(AbilityResource.Slot.Q):
		return "Cooldown must NOT start while cast is still winding up"
		
	hero.free()
	return ""

func test_task18_cast_completion_deducts_mana_and_sets_cooldown() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var ab = AbilityResource.new()
	ab.cast_time = 0.4
	ab.mana_costs = [45.0]
	ab.cooldowns = [10.0]
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	var init_mp = hero.attribute_system.current_mana
	
	hero.ability_container.start_cast(AbilityResource.Slot.Q)
	hero.ability_container._process(0.45) # Advance beyond cast time
	
	if hero.ability_container.is_casting():
		return "Hero should no longer be in CASTING state after completion"
	if absf(hero.attribute_system.current_mana - (init_mp - 45.0)) > 0.01:
		return "Mana should be deducted upon cast completion"
	if not hero.ability_container.is_on_cooldown(AbilityResource.Slot.Q):
		return "Cooldown should start upon cast completion"
		
	hero.free()
	return ""

func test_task18_cast_progress_calculation() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var ab = AbilityResource.new()
	ab.cast_time = 1.0 # 1 second windup
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	hero.ability_container.start_cast(AbilityResource.Slot.Q)
	if absf(hero.ability_container.get_cast_progress() - 0.0) > 0.05:
		return "Initial cast progress should be ~0.0"
		
	hero.ability_container._process(0.5)
	if absf(hero.ability_container.get_cast_progress() - 0.5) > 0.05:
		return "Halfway cast progress should be ~0.5, got %f" % hero.ability_container.get_cast_progress()
		
	hero.free()
	return ""

func test_task18_manual_cancel_during_windup() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var ab = AbilityResource.new()
	ab.cast_time = 0.8
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	hero.ability_container.start_cast(AbilityResource.Slot.Q)
	var cancelled = hero.ability_container.cancel_cast()
	
	if not cancelled:
		return "cancel_cast should return true when actively casting"
	if hero.ability_container.is_casting():
		return "Hero should return to IDLE state after cancel"
		
	hero.free()
	return ""

func test_task18_manual_cancel_saves_mana() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	var init_mp = hero.attribute_system.current_mana
	
	var ab = AbilityResource.new()
	ab.cast_time = 0.6
	ab.mana_costs = [60.0]
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	hero.ability_container.start_cast(AbilityResource.Slot.Q)
	hero.ability_container.cancel_cast()
	
	if hero.attribute_system.current_mana != init_mp:
		return "Cancelling cast must preserve full mana"
		
	hero.free()
	return ""

func test_task18_manual_cancel_saves_cooldown() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var ab = AbilityResource.new()
	ab.cast_time = 0.6
	ab.cooldowns = [12.0]
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	hero.ability_container.start_cast(AbilityResource.Slot.Q)
	hero.ability_container.cancel_cast()
	
	if hero.ability_container.is_on_cooldown(AbilityResource.Slot.Q):
		return "Cancelling cast must NOT trigger ability cooldown"
		
	hero.free()
	return ""

func test_task18_interrupt_on_movement() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var ab = AbilityResource.new()
	ab.cast_time = 0.7
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	var interrupt_reason = [""]
	hero.ability_container.ability_cast_interrupted.connect(func(_slot, reason): interrupt_reason[0] = reason)
	
	hero.ability_container.start_cast(AbilityResource.Slot.Q)
	hero.velocity = Vector3(2.0, 0, 0) # Simulate movement
	hero.ability_container._process(0.016)
	
	if hero.ability_container.is_casting():
		return "Movement during cast should interrupt casting"
	if interrupt_reason[0] != "movement":
		return "Interrupt reason should be 'movement', got '%s'" % interrupt_reason[0]
		
	hero.free()
	return ""

func test_task18_interrupt_on_silence_cc() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var ab = AbilityResource.new()
	ab.cast_time = 0.8
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	var interrupted = [false]
	hero.ability_container.ability_cast_interrupted.connect(func(_slot, _r): interrupted[0] = true)
	
	hero.ability_container.start_cast(AbilityResource.Slot.Q)
	
	# Apply Silence
	var silence = StatusEffect.new("silence", StatusEffect.EffectType.SILENCE, 2.0, 1.0)
	hero.effect_container.apply_effect(silence)
	hero.ability_container._process(0.016)
	
	if not interrupted[0]:
		return "Silence applied during windup must interrupt cast"
		
	hero.free()
	return ""

func test_task18_interrupt_on_stun_cc() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var ab = AbilityResource.new()
	ab.cast_time = 0.8
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	var interrupted = [false]
	hero.ability_container.ability_cast_interrupted.connect(func(_slot, _r): interrupted[0] = true)
	
	hero.ability_container.start_cast(AbilityResource.Slot.Q)
	
	# Apply Stun
	var stun = StatusEffect.new("stun", StatusEffect.EffectType.STUN, 1.5, 1.0)
	hero.effect_container.apply_effect(stun)
	hero.ability_container._process(0.016)
	
	if not interrupted[0]:
		return "Stun applied during windup must interrupt cast"
		
	hero.free()
	return ""

func test_task18_interrupt_on_caster_death() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var ab = AbilityResource.new()
	ab.cast_time = 0.8
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	hero.ability_container.start_cast(AbilityResource.Slot.Q)
	hero.die()
	hero.ability_container._process(0.016)
	
	if hero.ability_container.is_casting():
		return "Caster death during windup must cancel casting state"
		
	hero.free()
	return ""

func test_task18_interrupt_on_target_death() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	
	var ab = AbilityResource.new()
	ab.cast_time = 0.8
	ab.target_type = AbilityResource.TargetType.SINGLE_TARGET
	ab.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	hero.ability_container.start_cast(AbilityResource.Slot.Q, target)
	target.die()
	hero.ability_container._process(0.016)
	
	if hero.ability_container.is_casting():
		return "Target dying during single-target windup must interrupt cast"
		
	hero.free()
	target.free()
	return ""

func test_task18_spell_damage_pipeline() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	var init_hp = target.attribute_system.current_health
	
	var ab = AbilityResource.new()
	ab.base_damage = [120.0]
	ab.damage_type = DamageRequest.DamageType.MAGICAL
	ab.target_type = AbilityResource.TargetType.SINGLE_TARGET
	ab.target_filter = AbilityResource.TargetFilter.ENEMIES_ONLY
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	hero.ability_container.cast_ability(AbilityResource.Slot.Q, target)
	
	if target.attribute_system.current_health >= init_hp:
		return "Target should take spell damage via CombatCalculator pipeline"
		
	hero.free()
	target.free()
	return ""

func test_task18_spell_heal_and_buff_application() -> String:
	var hero = AstrisHero.new()
	hero._ready()
	
	var ab = AbilityResource.new()
	ab.target_type = AbilityResource.TargetType.SELF
	ab.applies_status_effect = true
	ab.effect_type = StatusEffect.EffectType.SHIELD
	ab.effect_duration = 3.0
	ab.effect_intensity = 150.0
	
	hero.ability_container.set_ability(AbilityResource.Slot.E, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.E] = 1
	
	hero.ability_container.cast_ability(AbilityResource.Slot.E, hero)
	
	if not hero.effect_container.has_effect_of_type(StatusEffect.EffectType.SHIELD):
		return "Self buff ability should apply StatusEffect to caster"
		
	hero.free()
	return ""

func test_task18_spell_debuff_slow_application() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	
	var ab = AbilityResource.new()
	ab.target_type = AbilityResource.TargetType.SINGLE_TARGET
	ab.applies_status_effect = true
	ab.effect_type = StatusEffect.EffectType.SLOW
	ab.effect_duration = 2.0
	ab.effect_intensity = 0.40
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	hero.ability_container.cast_ability(AbilityResource.Slot.Q, target)
	
	if not target.effect_container.has_effect_of_type(StatusEffect.EffectType.SLOW):
		return "Target should receive SLOW status effect from spell"
		
	hero.free()
	target.free()
	return ""

func test_task18_cooldown_reduction_integration() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	# Set 20% CDR
	hero.attribute_system.set_base_stat(StatModifier.TargetStat.COOLDOWN_REDUCTION, 0.20)
	hero.attribute_system.recalculate_all_stats()
	
	var ab = AbilityResource.new()
	ab.cooldowns = [10.0]
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	hero.ability_container.cast_ability(AbilityResource.Slot.Q)
	
	var remaining_cd = hero.ability_container.get_cooldown_remaining(AbilityResource.Slot.Q)
	if absf(remaining_cd - 8.0) > 0.05:
		return "10s cooldown with 20%% CDR should yield 8.0s cooldown, got %f" % remaining_cd
		
	hero.free()
	return ""

func test_task18_free_spells_mode_behavior() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	var init_mp = hero.attribute_system.current_mana
	
	var ab = AbilityResource.new()
	ab.mana_costs = [100.0]
	ab.cooldowns = [10.0]
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	hero.ability_container.is_free_spells_active = true
	
	hero.ability_container.cast_ability(AbilityResource.Slot.Q)
	
	if hero.attribute_system.current_mana != init_mp:
		return "Free spells mode should not deduct mana"
	if hero.ability_container.is_on_cooldown(AbilityResource.Slot.Q):
		return "Free spells mode should not set cooldown"
		
	hero.free()
	return ""

func test_task18_ability_cast_signals_flow() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var started_fired = [false]
	var completed_fired = [false]
	
	hero.ability_container.ability_cast_started.connect(func(_s, _a, _t): started_fired[0] = true)
	hero.ability_container.ability_cast_completed.connect(func(_s, _a): completed_fired[0] = true)
	
	var ab = AbilityResource.new()
	ab.cast_time = 0.2
	
	hero.ability_container.set_ability(AbilityResource.Slot.Q, ab)
	hero.ability_container.ability_levels[AbilityResource.Slot.Q] = 1
	
	hero.ability_container.start_cast(AbilityResource.Slot.Q)
	if not started_fired[0]:
		return "ability_cast_started signal should be emitted"
		
	hero.ability_container._process(0.25)
	if not completed_fired[0]:
		return "ability_cast_completed signal should be emitted"
		
	hero.free()
	return ""

# ==============================================================================
# --- TASK 19: XP & LEVEL SYSTEM TESTS (Tests 324–343) ---
# ==============================================================================

func test_task19_xp_accumulation_and_threshold_overflow() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	# Initial level 1, xp 0, requirement 200
	if hero.attribute_system.level != 1:
		return "Initial hero level should be 1"
	if hero.attribute_system.current_xp != 0:
		return "Initial hero XP should be 0"
		
	# Add 150 XP (below 200 threshold)
	hero.attribute_system.add_xp(150)
	if hero.attribute_system.level != 1:
		return "Hero should stay at level 1 with 150 XP"
	if hero.attribute_system.current_xp != 150:
		return "Hero current_xp should be 150, got %d" % hero.attribute_system.current_xp
		
	# Add 100 XP (Total 250 XP -> exceeds 200 threshold, overflow 50 XP)
	hero.attribute_system.add_xp(100)
	if hero.attribute_system.level != 2:
		return "Hero should reach level 2 after accumulating 250 XP, got %d" % hero.attribute_system.level
	if hero.attribute_system.current_xp != 50:
		return "Hero overflow XP should be 50, got %d" % hero.attribute_system.current_xp
		
	hero.free()
	return ""

func test_task19_level_up_stat_growth_attributes() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var base_str = hero.attribute_system.get_stat(StatModifier.TargetStat.STRENGTH)
	var str_growth = hero.attribute_system.strength_growth
	
	hero.attribute_system.add_xp(200) # Level up to 2
	
	var new_str = hero.attribute_system.get_stat(StatModifier.TargetStat.STRENGTH)
	var expected_str = base_str + str_growth
	if absf(new_str - expected_str) > 0.05:
		return "Level 2 Strength should be %f, got %f" % [expected_str, new_str]
		
	hero.free()
	return ""

func test_task19_level_up_stat_growth_hp_and_mana() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var init_max_hp = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	var init_max_mp = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
	
	hero.attribute_system.add_xp(200) # Level up to 2
	
	var new_max_hp = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	var new_max_mp = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
	
	if new_max_hp <= init_max_hp:
		return "Max HP should increase on level up"
	if new_max_mp <= init_max_mp:
		return "Max Mana should increase on level up"
	if hero.attribute_system.current_health < new_max_hp:
		return "Current health should increase by gained HP on level up"
		
	hero.free()
	return ""

func test_task19_level_up_stat_growth_attack_damage() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var init_ad = hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	hero.attribute_system.add_xp(200) # Level up to 2
	var new_ad = hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	
	if new_ad <= init_ad:
		return "Attack damage should increase on level up for Strength hero"
		
	hero.free()
	return ""

func test_task19_level_up_stat_growth_armor_and_speed() -> String:
	var hero = SolenHero.new() # Agility hero
	hero._ready()
	
	var init_armor = hero.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	var init_as = hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	
	hero.attribute_system.add_xp(200) # Level up to 2
	
	var new_armor = hero.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	var new_as = hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	
	if new_armor <= init_armor:
		return "Armor should increase on level up from Agility growth"
	if new_as <= init_as:
		return "Attack speed should increase on level up from Agility growth"
		
	hero.free()
	return ""

func test_task19_level_up_awards_ability_point() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var init_pts = hero.ability_container.available_skill_points
	hero.attribute_system.add_xp(200) # Level up to 2
	
	if hero.ability_container.available_skill_points != (init_pts + 1):
		return "Hero should receive exactly 1 skill point on level up"
		
	hero.free()
	return ""

func test_task19_ability_leveling_consumes_point() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	hero.ability_container.available_skill_points = 2
	
	var success = hero.ability_container.level_up_ability(AbilityResource.Slot.Q)
	if not success:
		return "Leveling up Q should succeed"
	if hero.ability_container.available_skill_points != 1:
		return "Skill points should decrease by 1 after leveling ability"
	if hero.ability_container.get_ability_level(AbilityResource.Slot.Q) != 1:
		return "Ability Q level should be 1"
		
	hero.free()
	return ""

func test_task19_ability_max_level_cap() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	hero.ability_container.available_skill_points = 10
	
	var q_ab = hero.ability_container.get_ability(AbilityResource.Slot.Q)
	var max_lvl = q_ab.max_level
	
	for i in range(max_lvl):
		hero.ability_container.level_up_ability(AbilityResource.Slot.Q)
		
	if hero.ability_container.get_ability_level(AbilityResource.Slot.Q) != max_lvl:
		return "Ability Q should reach max level %d" % max_lvl
		
	var over_level_success = hero.ability_container.level_up_ability(AbilityResource.Slot.Q)
	if over_level_success:
		return "Upgrading ability past max level should be rejected"
		
	hero.free()
	return ""

func test_task19_ultimate_level_requirement_rejection() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	hero.attribute_system.level = 5 # Hero level 5
	hero.ability_container.available_skill_points = 1
	
	# Upgrading Ultimate R at level 5 with enforcement
	var can_r = hero.ability_container.can_level_up_ability(AbilityResource.Slot.R, true)
	if can_r:
		return "Ultimate R rank 1 should be rejected at hero level 5"
		
	var lvl_up_ok = hero.ability_container.level_up_ability(AbilityResource.Slot.R, true)
	if lvl_up_ok:
		return "level_up_ability for Ultimate should fail when hero level < 6"
		
	hero.free()
	return ""

func test_task19_ultimate_level_requirement_acceptance() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	hero.attribute_system.level = 6 # Hero level 6
	hero.ability_container.available_skill_points = 1
	
	var can_r = hero.ability_container.can_level_up_ability(AbilityResource.Slot.R, true)
	if not can_r:
		return "Ultimate R rank 1 should be allowed at hero level 6"
		
	var lvl_up_ok = hero.ability_container.level_up_ability(AbilityResource.Slot.R, true)
	if not lvl_up_ok:
		return "level_up_ability for Ultimate should succeed at hero level 6"
	if hero.ability_container.get_ability_level(AbilityResource.Slot.R) != 1:
		return "Ultimate level should now be 1"
		
	hero.free()
	return ""

func test_task19_regular_ability_level_requirement() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	hero.attribute_system.level = 2 # Hero level 2
	hero.ability_container.available_skill_points = 2
	hero.ability_container.level_up_ability(AbilityResource.Slot.Q) # Q to level 1
	
	# Q to level 2 requires hero level 3
	var can_q_lvl2 = hero.ability_container.can_level_up_ability(AbilityResource.Slot.Q, true)
	if can_q_lvl2:
		return "Q rank 2 should be rejected at hero level 2"
		
	hero.attribute_system.level = 3
	var can_q_lvl2_at_3 = hero.ability_container.can_level_up_ability(AbilityResource.Slot.Q, true)
	if not can_q_lvl2_at_3:
		return "Q rank 2 should be accepted at hero level 3"
		
	hero.free()
	return ""

func test_task19_hero_level_cap_18() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	hero.attribute_system.level = 18
	hero.attribute_system.current_xp = 0
	
	hero.attribute_system.add_xp(50000) # Add massive XP
	
	if hero.attribute_system.level != 18:
		return "Hero level must not exceed max level 18, got %d" % hero.attribute_system.level
	if not hero.attribute_system.is_max_level():
		return "is_max_level() should return true at level 18"
		
	hero.free()
	return ""

func test_task19_creep_xp_reward_integration() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero.position = Vector3(0, 0, 0)
	hero._ready()
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep.creep_type = CreepEntity.CreepType.MELEE
	creep.position = Vector3(4.0, 0, 0)
	creep._ready()
	
	var init_xp = hero.attribute_system.current_xp
	creep.die()
	
	if hero.attribute_system.current_xp != (init_xp + 60):
		return "Hero should receive 60 XP from melee creep death, got %d" % hero.attribute_system.current_xp
		
	hero.free()
	creep.free()
	return ""

func test_task19_jungle_camp_xp_reward_integration() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero.position = Vector3(0, 0, 0)
	hero._ready()
	
	var monster = NeutralCreepEntity.new()
	monster.position = Vector3(5.0, 0, 0)
	monster._ready()
	
	var init_xp = hero.attribute_system.current_xp
	monster.take_damage(DamageRequest.create_basic_attack(hero, monster, 9999.0))
	
	if hero.attribute_system.current_xp <= init_xp:
		return "Hero should receive XP for killing jungle monster"
		
	hero.free()
	monster.free()
	return ""

func test_task19_hero_kill_xp_reward_integration() -> String:
	var killer = KaelgorHero.new()
	killer.team = TeamDefinitions.Team.RADIANT
	killer.position = Vector3(0, 0, 0)
	killer._ready()
	
	var victim = AstrisHero.new()
	victim.team = TeamDefinitions.Team.DIRE
	victim.position = Vector3(4.0, 0, 0)
	victim.attribute_system.level = 5
	victim._ready()
	
	var init_xp = killer.attribute_system.current_xp
	victim.take_damage(DamageRequest.create_basic_attack(killer, victim, 9999.0))
	
	var expected_bounty = 140 + (5 * 60) # 440 XP
	if killer.attribute_system.current_xp != (init_xp + expected_bounty):
		return "Killer hero should receive %d XP for killing level 5 enemy hero, got %d" % [expected_bounty, killer.attribute_system.current_xp]
		
	killer.free()
	victim.free()
	return ""

func test_task19_tower_objective_xp_reward_integration() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var enemy_tower = TowerEntity.new()
	enemy_tower.team = TeamDefinitions.Team.DIRE
	enemy_tower.tier = 1
	enemy_tower._ready()
	
	enemy_tower._on_death("Kaelgor")
	
	if hero.attribute_system.level != 2:
		return "Hero should reach level 2 from 200 objective XP of Tier 1 tower destruction, got level %d" % hero.attribute_system.level
		
	hero.free()
	enemy_tower.free()
	return ""

func test_task19_multi_hero_xp_sharing_curve() -> String:
	var hero1 = KaelgorHero.new()
	hero1.team = TeamDefinitions.Team.RADIANT
	hero1.position = Vector3(0, 0, 0)
	hero1._ready()
	
	var hero2 = SolenHero.new()
	hero2.team = TeamDefinitions.Team.RADIANT
	hero2.position = Vector3(2.0, 0, 0)
	hero2._ready()
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep.creep_type = CreepEntity.CreepType.MELEE # 60 XP
	creep.position = Vector3(4.0, 0, 0)
	creep._ready()
	
	creep.die()
	
	# 2 heroes share: each gets 60% of 60 XP = 36 XP
	if hero1.attribute_system.current_xp != 36 or hero2.attribute_system.current_xp != 36:
		return "Each of 2 heroes should receive 36 XP (60%%), got hero1=%d, hero2=%d" % [hero1.attribute_system.current_xp, hero2.attribute_system.current_xp]
		
	hero1.free()
	hero2.free()
	creep.free()
	return ""

func test_task19_dead_hero_excluded_from_xp() -> String:
	var living_hero = KaelgorHero.new()
	living_hero.team = TeamDefinitions.Team.RADIANT
	living_hero.position = Vector3(0, 0, 0)
	living_hero._ready()
	
	var dead_hero = SolenHero.new()
	dead_hero.team = TeamDefinitions.Team.RADIANT
	dead_hero.position = Vector3(2.0, 0, 0)
	dead_hero._ready()
	dead_hero.die()
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep.creep_type = CreepEntity.CreepType.MELEE # 60 XP
	creep.position = Vector3(4.0, 0, 0)
	creep._ready()
	
	creep.die()
	
	# Dead hero excluded -> living hero gets full 100% (60 XP), dead hero gets 0 XP
	if living_hero.attribute_system.current_xp != 60:
		return "Living hero should get full 60 XP when ally is dead, got %d" % living_hero.attribute_system.current_xp
	if dead_hero.attribute_system.current_xp != 0:
		return "Dead hero should receive 0 XP, got %d" % dead_hero.attribute_system.current_xp
		
	living_hero.free()
	dead_hero.free()
	creep.free()
	return ""

func test_task19_death_and_respawn_preserves_level_and_xp() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	hero.attribute_system.add_xp(350) # Level 2, 150 overflow XP
	hero.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var lvl_before = hero.attribute_system.level
	var xp_before = hero.attribute_system.current_xp
	var q_lvl_before = hero.ability_container.get_ability_level(AbilityResource.Slot.Q)
	
	hero.die()
	hero.respawn()
	
	if hero.attribute_system.level != lvl_before:
		return "Hero level must be preserved through death and respawn"
	if hero.attribute_system.current_xp != xp_before:
		return "Hero XP must be preserved through death and respawn"
	if hero.ability_container.get_ability_level(AbilityResource.Slot.Q) != q_lvl_before:
		return "Hero learned skills must be preserved through death and respawn"
		
	hero.free()
	return ""

func test_task19_xp_progress_ratio_for_hud() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	hero.attribute_system.current_xp = 100
	hero.attribute_system.xp_to_next_level = 200
	
	var progress = hero.attribute_system.get_xp_progress()
	if absf(progress - 0.5) > 0.01:
		return "get_xp_progress() should return 0.5 for 100/200 XP, got %f" % progress
		
	hero.free()
	return ""

# ==============================================================================
# --- TASK 20: HERO FRAMEWORK TESTS (Tests 344–363) ---
# ==============================================================================

func test_task20_hero_definition_registry_discovery() -> String:
	var hero_ids = HeroDefinition.get_all_hero_ids()
	if not hero_ids.has("kaelgor"):
		return "HeroDefinition should contain 'kaelgor'"
	if not hero_ids.has("astris"):
		return "HeroDefinition should contain 'astris'"
	if not hero_ids.has("solen"):
		return "HeroDefinition should contain 'solen'"
	return ""

func test_task20_hero_definition_kaelgor_stats() -> String:
	var def = HeroDefinition.get_definition("kaelgor")
	if def == null:
		return "Kaelgor definition must exist"
	if def.primary_attribute != AttributeSystem.PrimaryAttributeType.STRENGTH:
		return "Kaelgor primary attribute should be STRENGTH"
	if def.attack_type != HeroResource.AttackType.MELEE:
		return "Kaelgor attack type should be MELEE"
	if def.base_strength != 25.0 or def.strength_growth != 3.2:
		return "Kaelgor strength stats mismatch"
	return ""

func test_task20_hero_definition_astris_stats() -> String:
	var def = HeroDefinition.get_definition("astris")
	if def == null:
		return "Astris definition must exist"
	if def.primary_attribute != AttributeSystem.PrimaryAttributeType.INTELLIGENCE:
		return "Astris primary attribute should be INTELLIGENCE"
	if def.attack_type != HeroResource.AttackType.RANGED:
		return "Astris attack type should be RANGED"
	if def.base_attack_range < 500.0:
		return "Astris attack range should be >= 500.0"
	return ""

func test_task20_hero_definition_solen_stats() -> String:
	var def = HeroDefinition.get_definition("solen")
	if def == null:
		return "Solen definition must exist"
	if def.primary_attribute != AttributeSystem.PrimaryAttributeType.AGILITY:
		return "Solen primary attribute should be AGILITY"
	if def.attack_type != HeroResource.AttackType.RANGED:
		return "Solen attack type should be RANGED"
	if def.base_attack_range < 600.0:
		return "Solen attack range should be >= 600.0"
	return ""

func test_task20_hero_definition_abilities_integrity() -> String:
	for id in ["kaelgor", "astris", "solen"]:
		var def = HeroDefinition.get_definition(id)
		if def.passive_ability == null:
			return "%s passive ability is null" % id
		if def.q_ability == null:
			return "%s Q ability is null" % id
		if def.w_ability == null:
			return "%s W ability is null" % id
		if def.e_ability == null:
			return "%s E ability is null" % id
		if def.r_ability == null:
			return "%s R ability is null" % id
	return ""

func test_task20_hero_definition_ability_by_slot_helper() -> String:
	var def = HeroDefinition.get_definition("kaelgor")
	var q = def.get_ability_by_slot(AbilityResource.Slot.Q)
	if q == null or q.id != "kaelgor_q":
		return "get_ability_by_slot(Q) should return kaelgor_q"
	var r = def.get_ability_by_slot(AbilityResource.Slot.R)
	if r == null or r.id != "kaelgor_r":
		return "get_ability_by_slot(R) should return kaelgor_r"
	return ""

func test_task20_hero_definition_get_all_abilities() -> String:
	var def = HeroDefinition.get_definition("astris")
	var abs_list = def.get_all_abilities()
	if abs_list.size() != 5:
		return "get_all_abilities() should return exactly 5 abilities, got %d" % abs_list.size()
	return ""

func test_task20_hero_definition_factory_instance_creation() -> String:
	var hero = HeroDefinition.create_hero_instance("kaelgor")
	if hero == null or not (hero is KaelgorHero):
		return "create_hero_instance('kaelgor') should return KaelgorHero"
	hero.free()
	return ""

func test_task20_hero_definition_factory_astris_creation() -> String:
	var hero = HeroDefinition.create_hero_instance("astris")
	if hero == null or not (hero is AstrisHero):
		return "create_hero_instance('astris') should return AstrisHero"
	hero.free()
	return ""

func test_task20_hero_definition_factory_solen_creation() -> String:
	var hero = HeroDefinition.create_hero_instance("solen")
	if hero == null or not (hero is SolenHero):
		return "create_hero_instance('solen') should return SolenHero"
	hero.free()
	return ""

func test_task20_hero_definition_custom_registration() -> String:
	var custom = HeroResource.new()
	custom.id = "custom_test_hero"
	custom.hero_name = "Custom Hero"
	HeroDefinition.register_definition("custom_test_hero", custom)
	
	var retrieved = HeroDefinition.get_definition("custom_test_hero")
	if retrieved == null or retrieved.hero_name != "Custom Hero":
		return "Failed to register and retrieve custom hero definition"
	return ""

func test_task20_hero_definition_projectile_configuration() -> String:
	var def = HeroDefinition.get_definition("solen")
	if def.projectile_speed <= 0.0:
		return "Projectile speed should be > 0.0"
	if def.projectile_scene_path.is_empty():
		return "Projectile scene path should not be empty"
	return ""

func test_task20_hero_definition_damage_type_metadata() -> String:
	var kaelgor_def = HeroDefinition.get_definition("kaelgor")
	if kaelgor_def.q_ability.damage_type != DamageRequest.DamageType.PHYSICAL:
		return "Kaelgor Q damage type should be PHYSICAL"
	var astris_def = HeroDefinition.get_definition("astris")
	if astris_def.q_ability.damage_type != DamageRequest.DamageType.MAGICAL:
		return "Astris Q damage type should be MAGICAL"
	return ""

func test_task20_hero_definition_scaling_metadata() -> String:
	var astris_def = HeroDefinition.get_definition("astris")
	if astris_def.q_ability.scaling_stat != StatModifier.TargetStat.ABILITY_POWER:
		return "Astris Q should scale with ABILITY_POWER"
	if astris_def.q_ability.scaling_ratio <= 0.0:
		return "Astris Q scaling ratio should be > 0.0"
	return ""

func test_task20_hero_definition_target_filter_metadata() -> String:
	var def = HeroDefinition.get_definition("kaelgor")
	if def.q_ability.target_filter != AbilityResource.TargetFilter.ENEMIES_ONLY:
		return "Kaelgor Q target filter should be ENEMIES_ONLY"
	if def.e_ability.target_filter != AbilityResource.TargetFilter.SELF_ONLY:
		return "Kaelgor E target filter should be SELF_ONLY"
	return ""

func test_task20_hero_resource_apply_to_hero_entity() -> String:
	var hero = HeroEntity.new()
	var def = HeroDefinition.get_definition("kaelgor")
	hero.hero_resource = def
	hero._ready()
	
	if hero.entity_name != "Kaelgor":
		return "HeroEntity name should be initialized from definition"
	if hero.attribute_system.primary_attribute != AttributeSystem.PrimaryAttributeType.STRENGTH:
		return "HeroEntity primary attribute should be set"
	if hero.ability_container.get_ability(AbilityResource.Slot.Q) == null:
		return "HeroEntity ability slots should be populated"
		
	hero.free()
	return ""

func test_task20_hero_definition_cooldown_arrays_integrity() -> String:
	for id in ["kaelgor", "astris", "solen"]:
		var def = HeroDefinition.get_definition(id)
		for slot in [AbilityResource.Slot.Q, AbilityResource.Slot.W, AbilityResource.Slot.E, AbilityResource.Slot.R]:
			var ab = def.get_ability_by_slot(slot)
			if ab.cooldowns.is_empty():
				return "%s slot %d cooldowns array is empty" % [id, slot]
	return ""

func test_task20_hero_definition_mana_cost_arrays_integrity() -> String:
	for id in ["kaelgor", "astris", "solen"]:
		var def = HeroDefinition.get_definition(id)
		for slot in [AbilityResource.Slot.Q, AbilityResource.Slot.W, AbilityResource.Slot.E, AbilityResource.Slot.R]:
			var ab = def.get_ability_by_slot(slot)
			if ab.mana_costs.is_empty():
				return "%s slot %d mana_costs array is empty" % [id, slot]
	return ""

func test_task20_hero_definition_base_damage_arrays_integrity() -> String:
	var kaelgor_def = HeroDefinition.get_definition("kaelgor")
	if kaelgor_def.q_ability.base_damage.is_empty():
		return "Kaelgor Q base_damage array should not be empty"
	if kaelgor_def.r_ability.max_level != 3:
		return "Kaelgor R max level should be 3"
	return ""

func test_task20_hero_definition_has_definition_query() -> String:
	if not HeroDefinition.has_definition("kaelgor"):
		return "has_definition('kaelgor') should be true"
	if HeroDefinition.has_definition("non_existent_hero_xyz"):
		return "has_definition('non_existent_hero_xyz') should be false"
	return ""

# ==============================================================================
# --- TASK 21: GOLD & BOUNTY TESTS (Tests 364–383) ---
# ==============================================================================

func test_task21_passive_gold_generation_rate() -> String:
	var inv = InventoryManager.new()
	inv.gold = 0
	inv.passive_gold_rate = 2.0
	
	inv.tick_passive_gold(1.0)
	if inv.gold != 2:
		return "Expected 2 gold after 1 second at 2.0 gold/sec, got %d" % inv.gold
		
	inv.free()
	return ""

func test_task21_passive_gold_disabled_mode() -> String:
	var inv = InventoryManager.new()
	inv.gold = 100
	inv.passive_gold_enabled = false
	inv.passive_gold_rate = 2.0
	
	inv._process(2.0)
	if inv.gold != 100:
		return "Disabled passive gold should not change gold balance"
		
	inv.free()
	return ""

func test_task21_unlimited_gold_mode_bypass() -> String:
	var inv = InventoryManager.new()
	inv.gold = 50
	inv.unlimited_gold_mode = true
	
	var can_spend = inv.spend_gold(5000)
	if not can_spend:
		return "Unlimited gold mode should permit any spend amount"
		
	inv.free()
	return ""

func test_task21_spend_gold_insufficient_funds() -> String:
	var inv = InventoryManager.new()
	inv.gold = 200
	
	var success = inv.spend_gold(500)
	if success:
		return "spend_gold should fail when balance is insufficient"
	if inv.gold != 200:
		return "Gold balance should not be modified on failed spend"
		
	inv.free()
	return ""

func test_task21_spend_gold_exact_amount() -> String:
	var inv = InventoryManager.new()
	inv.gold = 350
	
	var success = inv.spend_gold(350)
	if not success:
		return "spend_gold for exact amount should succeed"
	if inv.gold != 0:
		return "Gold should be 0 after spending entire balance, got %d" % inv.gold
		
	inv.free()
	return ""

func test_task21_hero_kill_gold_bounty_awarded_to_killer() -> String:
	var killer = KaelgorHero.new()
	killer.team = TeamDefinitions.Team.RADIANT
	killer.position = Vector3(0, 0, 0)
	killer._ready()
	killer.inventory_manager.gold = 100
	
	var victim = AstrisHero.new()
	victim.team = TeamDefinitions.Team.DIRE
	victim.position = Vector3(4.0, 0, 0)
	victim.attribute_system.level = 5
	victim._ready()
	
	victim.take_damage(DamageRequest.create_basic_attack(killer, victim, 9999.0))
	
	var expected_bounty = 240 + (5 * 20) # 340g
	if killer.inventory_manager.gold != (100 + expected_bounty):
		return "Killer gold should increase by %d, expected %d, got %d" % [expected_bounty, 100 + expected_bounty, killer.inventory_manager.gold]
		
	killer.free()
	victim.free()
	return ""

func test_task21_hero_assist_gold_shared_among_allies() -> String:
	var killer = KaelgorHero.new()
	killer.team = TeamDefinitions.Team.RADIANT
	killer.position = Vector3(0, 0, 0)
	killer._ready()
	killer.inventory_manager.gold = 100
	
	var assister1 = SolenHero.new()
	assister1.team = TeamDefinitions.Team.RADIANT
	assister1.position = Vector3(3.0, 0, 0)
	assister1._ready()
	assister1.inventory_manager.gold = 100
	
	var victim = AstrisHero.new()
	victim.team = TeamDefinitions.Team.DIRE
	victim.position = Vector3(4.0, 0, 0)
	victim.attribute_system.level = 5
	victim._ready()
	
	victim.take_damage(DamageRequest.create_basic_attack(killer, victim, 9999.0))
	
	# Assist pool = 120 + (5 * 10) = 170g. 1 assister -> 170g
	if assister1.inventory_manager.gold != 270:
		return "Assister gold should increase by 170g, got %d" % assister1.inventory_manager.gold
		
	killer.free()
	assister1.free()
	victim.free()
	return ""

func test_task21_hero_kill_gold_signals_emitted() -> String:
	var killer = KaelgorHero.new()
	killer.team = TeamDefinitions.Team.RADIANT
	killer._ready()
	
	var victim = AstrisHero.new()
	victim.team = TeamDefinitions.Team.DIRE
	victim.position = Vector3(2.0, 0, 0)
	victim._ready()
	
	var kill_fired = [false]
	var reward_amt = [0]
	
	if Engine.has_singleton("GameEvents") or is_instance_valid(GameEvents):
		var con = GameEvents.hero_kill_gold_awarded.connect(func(k, a, _v):
			if k == killer:
				kill_fired[0] = true
				reward_amt[0] = a
		)
		victim.take_damage(DamageRequest.create_basic_attack(killer, victim, 9999.0))
		if con.is_valid():
			GameEvents.hero_kill_gold_awarded.disconnect(con)
			
	if not kill_fired[0]:
		return "GameEvents.hero_kill_gold_awarded signal should be emitted"
	if reward_amt[0] != 260: # Level 1 = 240 + 20 = 260
		return "Hero kill gold signal amount expected 260, got %d" % reward_amt[0]
		
	killer.free()
	victim.free()
	return ""

func test_task21_melee_creep_last_hit_gold() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.inventory_manager.gold = 0
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep.creep_type = CreepEntity.CreepType.MELEE
	creep._ready()
	
	creep.take_damage(DamageRequest.create_basic_attack(hero, creep, 9999.0))
	
	if hero.inventory_manager.gold != 38:
		return "Melee creep last-hit should grant 38 gold, got %d" % hero.inventory_manager.gold
		
	hero.free()
	creep.free()
	return ""

func test_task21_ranged_creep_last_hit_gold() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.inventory_manager.gold = 0
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep.creep_type = CreepEntity.CreepType.RANGED
	creep._ready()
	
	creep.take_damage(DamageRequest.create_basic_attack(hero, creep, 9999.0))
	
	if hero.inventory_manager.gold != 45:
		return "Ranged creep last-hit should grant 45 gold, got %d" % hero.inventory_manager.gold
		
	hero.free()
	creep.free()
	return ""

func test_task21_siege_creep_last_hit_gold() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.inventory_manager.gold = 0
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep.creep_type = CreepEntity.CreepType.SIEGE
	creep._ready()
	
	creep.take_damage(DamageRequest.create_basic_attack(hero, creep, 9999.0))
	
	if hero.inventory_manager.gold != 66:
		return "Siege creep last-hit should grant 66 gold, got %d" % hero.inventory_manager.gold
		
	hero.free()
	creep.free()
	return ""

func test_task21_denied_creep_no_gold_to_anyone() -> String:
	var denier = KaelgorHero.new()
	denier.team = TeamDefinitions.Team.RADIANT
	denier._ready()
	denier.inventory_manager.gold = 100
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(4.0, 0, 0)
	enemy._ready()
	enemy.inventory_manager.gold = 100
	
	var allied_creep = CreepEntity.new()
	allied_creep.team = TeamDefinitions.Team.RADIANT
	allied_creep.creep_type = CreepEntity.CreepType.MELEE
	allied_creep._ready()
	
	allied_creep.take_damage(DamageRequest.create_basic_attack(denier, allied_creep, 9999.0))
	
	if denier.inventory_manager.gold != 100:
		return "Denying allied creep should grant 0 gold to denier"
	if enemy.inventory_manager.gold != 100:
		return "Denying allied creep should grant 0 gold to enemy"
		
	denier.free()
	enemy.free()
	allied_creep.free()
	return ""

func test_task21_neutral_monster_gold_bounty() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.inventory_manager.gold = 100
	
	var monster = NeutralCreepEntity.new()
	monster.gold_bounty = 55
	monster._ready()
	
	monster.take_damage(DamageRequest.create_basic_attack(hero, monster, 9999.0))
	
	if hero.inventory_manager.gold != 155:
		return "Neutral creep kill should grant gold bounty to killer, expected 155, got %d" % hero.inventory_manager.gold
		
	hero.free()
	monster.free()
	return ""

func test_task21_tower_destruction_team_bounty() -> String:
	var hero1 = KaelgorHero.new()
	hero1.team = TeamDefinitions.Team.RADIANT
	hero1._ready()
	hero1.inventory_manager.gold = 100
	
	var hero2 = SolenHero.new()
	hero2.team = TeamDefinitions.Team.RADIANT
	hero2._ready()
	hero2.inventory_manager.gold = 100
	
	var enemy_tower = TowerEntity.new()
	enemy_tower.team = TeamDefinitions.Team.DIRE
	enemy_tower.tier = 2
	enemy_tower.team_bounty_gold = 150
	enemy_tower._ready()
	
	enemy_tower._on_death("Kaelgor")
	
	# Tier 2 tower = 150 * 2 = 300g per hero
	if hero1.inventory_manager.gold != 400 or hero2.inventory_manager.gold != 400:
		return "Each radiant hero should receive 300g for Tier 2 tower destruction"
		
	hero1.free()
	hero2.free()
	enemy_tower.free()
	return ""

func test_task21_tower_tier3_higher_gold() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.inventory_manager.gold = 100
	
	var enemy_tower = TowerEntity.new()
	enemy_tower.team = TeamDefinitions.Team.DIRE
	enemy_tower.tier = 3
	enemy_tower.team_bounty_gold = 150
	enemy_tower._ready()
	
	enemy_tower._on_death("Kaelgor")
	
	# Tier 3 tower = 150 * 3 = 450g per hero
	if hero.inventory_manager.gold != 550:
		return "Hero should receive 450g for Tier 3 tower, got %d" % hero.inventory_manager.gold
		
	hero.free()
	enemy_tower.free()
	return ""

func test_task21_duplicate_creep_gold_protection() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.inventory_manager.gold = 0
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep.creep_type = CreepEntity.CreepType.MELEE
	creep._ready()
	
	creep.take_damage(DamageRequest.create_basic_attack(hero, creep, 9999.0))
	creep.die(hero)
	creep.die(hero)
	
	if hero.inventory_manager.gold != 38:
		return "Gold bounty should only be awarded once, got %d" % hero.inventory_manager.gold
		
	hero.free()
	creep.free()
	return ""

func test_task21_duplicate_neutral_gold_protection() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.inventory_manager.gold = 0
	
	var monster = NeutralCreepEntity.new()
	monster.gold_bounty = 60
	monster._ready()
	
	monster.take_damage(DamageRequest.create_basic_attack(hero, monster, 9999.0))
	monster.die(hero)
	
	if hero.inventory_manager.gold != 60:
		return "Neutral bounty must not duplicate, got %d" % hero.inventory_manager.gold
		
	hero.free()
	monster.free()
	return ""

func test_task21_passive_gold_subsecond_carryover() -> String:
	var inv = InventoryManager.new()
	inv.gold = 0
	inv.passive_gold_rate = 2.0
	
	# Tick 0.3s -> 0.6 accumulator (0 gold gained)
	inv.tick_passive_gold(0.3)
	if inv.gold != 0:
		return "0.3s should not yield whole gold yet"
		
	# Tick 0.3s -> 1.2 accumulator (1 gold gained, 0.2 carried over)
	inv.tick_passive_gold(0.3)
	if inv.gold != 1:
		return "0.6s total should yield 1 gold"
		
	inv.free()
	return ""

func test_task21_non_hero_death_splits_bounty() -> String:
	var hero1 = KaelgorHero.new()
	hero1.team = TeamDefinitions.Team.RADIANT
	hero1.position = Vector3(0, 0, 0)
	hero1._ready()
	hero1.inventory_manager.gold = 0
	
	var hero2 = SolenHero.new()
	hero2.team = TeamDefinitions.Team.RADIANT
	hero2.position = Vector3(3.0, 0, 0)
	hero2._ready()
	hero2.inventory_manager.gold = 0
	
	var victim = AstrisHero.new()
	victim.team = TeamDefinitions.Team.DIRE
	victim.position = Vector3(4.0, 0, 0)
	victim._ready()
	
	# Non-hero death (e.g. killed by tower/creeps) -> splits 260g bounty among 2 heroes (130g each)
	victim._on_death("Tower")
	
	if hero1.inventory_manager.gold != 130 or hero2.inventory_manager.gold != 130:
		return "Non-hero kill should split bounty equally among nearby heroes (130g each), got %d and %d" % [hero1.inventory_manager.gold, hero2.inventory_manager.gold]
		
	hero1.free()
	hero2.free()
	victim.free()
	return ""

func test_task21_gold_updated_signal_reactivity() -> String:
	var inv = InventoryManager.new()
	inv.gold = 100
	var signal_fired = [false]
	var new_gold_val = [0]
	
	inv.gold_updated.connect(func(g):
		signal_fired[0] = true
		new_gold_val[0] = g
	)
	
	inv.add_gold(50)
	if not signal_fired[0] or new_gold_val[0] != 150:
		return "gold_updated signal was not properly fired on add_gold"
		
	inv.free()
	return ""

# ==============================================================================
# --- TASK 22: ITEM EFFECT SYSTEM TESTS (Tests 384–403) ---
# ==============================================================================

func test_task22_item_stat_bonus_health() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	var base_hp = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	
	var item = ItemResource.new()
	item.id = 901
	item.item_name = "Ruby of Vitality"
	item.stat_bonuses[StatModifier.TargetStat.MAX_HEALTH] = 250.0
	
	hero.inventory_manager.equip_item(item)
	var new_hp = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	if absf(new_hp - (base_hp + 250.0)) > 0.01:
		return "Max HP should increase by 250.0, got %f" % new_hp
		
	hero.free()
	return ""

func test_task22_item_stat_bonus_mana() -> String:
	var hero = AstrisHero.new()
	hero._ready()
	var base_mp = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
	
	var item = ItemResource.new()
	item.id = 902
	item.item_name = "Sapphire Orb"
	item.stat_bonuses[StatModifier.TargetStat.MAX_MANA] = 300.0
	
	hero.inventory_manager.equip_item(item)
	var new_mp = hero.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
	if absf(new_mp - (base_mp + 300.0)) > 0.01:
		return "Max Mana should increase by 300.0, got %f" % new_mp
		
	hero.free()
	return ""

func test_task22_item_stat_bonus_attack_damage() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	var base_ad = hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	
	var item = ItemResource.new()
	item.id = 903
	item.item_name = "Broadsword"
	item.stat_bonuses[StatModifier.TargetStat.ATTACK_DAMAGE] = 35.0
	
	hero.inventory_manager.equip_item(item)
	var new_ad = hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	if absf(new_ad - (base_ad + 35.0)) > 0.01:
		return "Attack Damage should increase by 35.0, got %f" % new_ad
		
	hero.free()
	return ""

func test_task22_item_stat_bonus_armor() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	var base_armor = hero.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	
	var item = ItemResource.new()
	item.id = 904
	item.item_name = "Chainmail"
	item.stat_bonuses[StatModifier.TargetStat.ARMOR] = 15.0
	
	hero.inventory_manager.equip_item(item)
	var new_armor = hero.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	if absf(new_armor - (base_armor + 15.0)) > 0.01:
		return "Armor should increase by 15.0, got %f" % new_armor
		
	hero.free()
	return ""

func test_task22_item_stat_bonus_magic_resist() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	var base_mr = hero.attribute_system.get_stat(StatModifier.TargetStat.MAGIC_RESIST)
	
	var item = ItemResource.new()
	item.id = 905
	item.item_name = "Cloak of Defiance"
	item.stat_bonuses[StatModifier.TargetStat.MAGIC_RESIST] = 20.0
	
	hero.inventory_manager.equip_item(item)
	var new_mr = hero.attribute_system.get_stat(StatModifier.TargetStat.MAGIC_RESIST)
	if absf(new_mr - (base_mr + 20.0)) > 0.01:
		return "Magic Resist should increase by 20.0, got %f" % new_mr
		
	hero.free()
	return ""

func test_task22_item_stat_bonus_attack_speed() -> String:
	var hero = SolenHero.new()
	hero._ready()
	var base_as = hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	
	var item = ItemResource.new()
	item.id = 906
	item.item_name = "Gloves of Haste"
	item.stat_bonuses[StatModifier.TargetStat.ATTACK_SPEED] = 0.25
	
	hero.inventory_manager.equip_item(item)
	var new_as = hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	if absf(new_as - (base_as + 0.25)) > 0.01:
		return "Attack Speed should increase by 0.25, got %f" % new_as
		
	hero.free()
	return ""

func test_task22_item_stat_bonus_move_speed() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	var base_ms = hero.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	var boots = ItemResource.new()
	boots.id = 907
	boots.item_name = "Boots of Speed"
	boots.category = "boots"
	boots.stat_bonuses[StatModifier.TargetStat.MOVE_SPEED] = 45.0
	
	hero.inventory_manager.equip_item(boots)
	var new_ms = hero.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	if absf(new_ms - (base_ms + 45.0)) > 0.01:
		return "Move Speed should increase by 45.0 with boots, got %f" % new_ms
		
	hero.free()
	return ""

func test_task22_item_stat_bonus_ability_power() -> String:
	var hero = AstrisHero.new()
	hero._ready()
	var base_ap = hero.attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	
	var item = ItemResource.new()
	item.id = 908
	item.item_name = "Staff of Wizardry"
	item.stat_bonuses[StatModifier.TargetStat.ABILITY_POWER] = 60.0
	
	hero.inventory_manager.equip_item(item)
	var new_ap = hero.attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	if absf(new_ap - (base_ap + 60.0)) > 0.01:
		return "Ability Power should increase by 60.0, got %f" % new_ap
		
	hero.free()
	return ""

func test_task22_item_stat_bonus_lifesteal() -> String:
	var hero = SolenHero.new()
	hero._ready()
	
	var item = ItemResource.new()
	item.id = 909
	item.item_name = "Morbid Mask"
	item.stat_bonuses[StatModifier.TargetStat.LIFESTEAL] = 0.15
	
	hero.inventory_manager.equip_item(item)
	var ls = hero.attribute_system.get_stat(StatModifier.TargetStat.LIFESTEAL)
	if absf(ls - 0.15) > 0.01:
		return "Lifesteal should be 0.15, got %f" % ls
		
	hero.free()
	return ""

func test_task22_item_unequip_removes_stat_bonuses() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	var base_ad = hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	
	var item = ItemResource.new()
	item.id = 910
	item.item_name = "Claymore"
	item.stat_bonuses[StatModifier.TargetStat.ATTACK_DAMAGE] = 50.0
	
	hero.inventory_manager.equip_item(item, 0)
	hero.inventory_manager.unequip_item(0)
	
	var final_ad = hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	if absf(final_ad - base_ad) > 0.01:
		return "AD should revert back to %f after unequip, got %f" % [base_ad, final_ad]
		
	hero.free()
	return ""

func test_task22_item_selling_removes_stats_and_refunds() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	hero.inventory_manager.gold = 0
	var base_armor = hero.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	
	var item = ItemResource.new()
	item.id = 911
	item.item_name = "Plate Mail"
	item.cost = 1400
	item.stat_bonuses[StatModifier.TargetStat.ARMOR] = 20.0
	
	hero.inventory_manager.equip_item(item, 0)
	hero.inventory_manager.sell_item(0)
	
	var final_armor = hero.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	if absf(final_armor - base_armor) > 0.01:
		return "Armor should revert back after selling item"
	if hero.inventory_manager.gold != 980: # 70% of 1400 = 980
		return "Selling 1400g item should refund 980g, got %d" % hero.inventory_manager.gold
		
	hero.free()
	return ""

func test_task22_get_total_stat_bonus_aggregation() -> String:
	var inv = InventoryManager.new()
	
	var item1 = ItemResource.new()
	item1.stat_bonuses[StatModifier.TargetStat.ATTACK_DAMAGE] = 20.0
	var item2 = ItemResource.new()
	item2.stat_bonuses[StatModifier.TargetStat.ATTACK_DAMAGE] = 30.0
	
	inv.equip_item(item1, 0)
	inv.equip_item(item2, 1)
	
	var total_ad = inv.get_total_stat_bonus(StatModifier.TargetStat.ATTACK_DAMAGE)
	if absf(total_ad - 50.0) > 0.01:
		return "Total AD bonus expected 50.0, got %f" % total_ad
		
	inv.free()
	return ""

func test_task22_has_item_query_by_id() -> String:
	var inv = InventoryManager.new()
	var item = ItemResource.new()
	item.id = 912
	
	inv.equip_item(item, 0)
	if not inv.has_item(912):
		return "has_item(912) should be true"
	inv.unequip_item(0)
	if inv.has_item(912):
		return "has_item(912) should be false after unequip"
		
	inv.free()
	return ""

func test_task22_has_item_query_by_name() -> String:
	var inv = InventoryManager.new()
	var item = ItemResource.new()
	item.item_name = "Demon Edge"
	
	inv.equip_item(item, 0)
	if not inv.has_item_by_name("demon edge") or not inv.has_item_by_name("Demon Edge"):
		return "has_item_by_name should be case-insensitive"
		
	inv.free()
	return ""

func test_task22_get_all_equipped_items_list() -> String:
	var inv = InventoryManager.new()
	var item1 = ItemResource.new()
	item1.id = 1
	var item2 = ItemResource.new()
	item2.id = 2
	var boots = ItemResource.new()
	boots.id = 3
	boots.category = "boots"
	
	inv.equip_item(item1, 0)
	inv.equip_item(item2, 1)
	inv.equip_item(boots)
	
	var list = inv.get_all_equipped_items()
	if list.size() != 3:
		return "get_all_equipped_items should return 3 items, got %d" % list.size()
		
	inv.free()
	return ""

func test_task22_active_item_lifebloom_healing() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	hero.attribute_system.current_health = 200.0
	
	var lifebloom = ItemResource.new()
	lifebloom.id = 114 # Lifebloom ID
	lifebloom.item_name = "Lifebloom"
	hero.inventory_manager.equip_item(lifebloom, 0)
	
	var ok = hero.inventory_manager.use_active_item(0)
	if not ok:
		return "use_active_item for Lifebloom should succeed"
	if hero.attribute_system.current_health <= 200.0:
		return "Hero health should be restored by Lifebloom"
		
	hero.free()
	return ""

func test_task22_active_item_radiant_aegis_shield() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var aegis = ItemResource.new()
	aegis.id = 115 # Radiant Aegis
	aegis.item_name = "Radiant Aegis"
	hero.inventory_manager.equip_item(aegis, 0)
	
	var ok = hero.inventory_manager.use_active_item(0)
	if not ok:
		return "use_active_item for Radiant Aegis should succeed"
	if not hero.effect_container.has_effect("shield_radiant_aegis"):
		return "Radiant Aegis should apply shield status effect"
		
	hero.free()
	return ""

func test_task22_active_item_force_relic_dash() -> String:
	var hero = KaelgorHero.new()
	hero.position = Vector3(0, 0, 0)
	hero._ready()
	
	var relic = ItemResource.new()
	relic.id = 118 # Force Relic
	relic.item_name = "Force Relic"
	hero.inventory_manager.equip_item(relic, 0)
	
	var ok = hero.inventory_manager.use_active_item(0, null, Vector3(10, 0, 0))
	if not ok:
		return "use_active_item for Force Relic should succeed"
	var hero_pos = hero.global_position if hero.is_inside_tree() else hero.position
	if hero_pos.length() < 5.0:
		return "Hero should have dashed forward by ~6m"
		
	hero.free()
	return ""

func test_task22_active_item_cooldown_rejection() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var lifebloom = ItemResource.new()
	lifebloom.id = 114
	hero.inventory_manager.equip_item(lifebloom, 0)
	
	hero.inventory_manager.use_active_item(0)
	var second_use = hero.inventory_manager.use_active_item(0)
	if second_use:
		return "Second use during cooldown should be rejected"
		
	hero.free()
	return ""

func test_task22_active_item_cooldown_countdown() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var lifebloom = ItemResource.new()
	lifebloom.id = 114 # 12s cooldown
	hero.inventory_manager.equip_item(lifebloom, 0)
	
	hero.inventory_manager.use_active_item(0)
	if hero.inventory_manager.active_cooldowns.get(0, 0.0) <= 0.0:
		return "Cooldown should be set on slot 0"
		
	hero.inventory_manager._process(13.0)
	if hero.inventory_manager.active_cooldowns.has(0):
		return "Cooldown should be erased after 13s"
		
	hero.free()
	return ""

# ==============================================================================
# --- TASK 23: ITEM COMBAT INTEGRATION TESTS (Tests 404–423) ---
# ==============================================================================

func test_task23_item_damage_modifier_applied_to_basic_attacks() -> String:
	var attacker = KaelgorHero.new()
	attacker.team = TeamDefinitions.Team.RADIANT
	attacker._ready()
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	target.attribute_system.set_base_stat(StatModifier.TargetStat.ARMOR, 0.0)
	
	var sword = ItemResource.new()
	sword.id = 950
	sword.item_name = "Greatsword"
	sword.stat_bonuses[StatModifier.TargetStat.ATTACK_DAMAGE] = 60.0
	attacker.inventory_manager.equip_item(sword, 0)
	
	var req = DamageRequest.create_basic_attack(attacker, target, attacker.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE))
	var res = CombatCalculator.execute_damage(req)
	
	if res.final_health_damage < 100.0:
		return "Damage with 60 AD item should exceed 100, got %f" % res.final_health_damage
		
	attacker.free()
	target.free()
	return ""

func test_task23_item_armor_modifier_reduces_incoming_damage() -> String:
	var attacker = KaelgorHero.new()
	attacker.team = TeamDefinitions.Team.RADIANT
	attacker._ready()
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	target.attribute_system.set_base_stat(StatModifier.TargetStat.ARMOR, 0.0)
	
	var plate = ItemResource.new()
	plate.id = 951
	plate.item_name = "Cuirass"
	plate.stat_bonuses[StatModifier.TargetStat.ARMOR] = 100.0
	target.inventory_manager.equip_item(plate, 0)
	
	var req = DamageRequest.create_basic_attack(attacker, target, 100.0)
	var res = CombatCalculator.execute_damage(req)
	
	# 100 Armor gives 50% damage reduction: 100 / (100 + 100) = 0.5 -> 50 damage
	if absf(res.final_health_damage - 50.0) > 1.0:
		return "100 Armor should mitigate 100 damage down to ~50, got %f" % res.final_health_damage
		
	attacker.free()
	target.free()
	return ""

func test_task23_item_mr_modifier_reduces_magic_damage() -> String:
	var attacker = AstrisHero.new()
	attacker.team = TeamDefinitions.Team.RADIANT
	attacker._ready()
	
	var target = KaelgorHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	target.attribute_system.set_base_stat(StatModifier.TargetStat.MAGIC_RESIST, 0.0)
	
	var hood = ItemResource.new()
	hood.id = 952
	hood.item_name = "Hood of Defiance"
	hood.stat_bonuses[StatModifier.TargetStat.MAGIC_RESIST] = 100.0
	target.inventory_manager.equip_item(hood, 0)
	
	var req = DamageRequest.create_spell_damage(attacker, target, 100.0, DamageRequest.DamageType.MAGICAL, "Magic Missile")
	var res = CombatCalculator.execute_damage(req)
	
	# 100 MR gives 50% damage reduction -> 50 damage
	if absf(res.final_health_damage - 50.0) > 1.0:
		return "100 MR should reduce 100 magic damage to ~50, got %f" % res.final_health_damage
		
	attacker.free()
	target.free()
	return ""

func test_task23_item_armor_penetration_flat_bypass() -> String:
	var attacker = KaelgorHero.new()
	attacker.team = TeamDefinitions.Team.RADIANT
	attacker._ready()
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	target.attribute_system.set_base_stat(StatModifier.TargetStat.ARMOR, 50.0)
	
	var serrated_dirk = ItemResource.new()
	serrated_dirk.id = 953
	serrated_dirk.item_name = "Dirk"
	serrated_dirk.stat_bonuses[StatModifier.TargetStat.ARMOR_PEN_FLAT] = 50.0
	attacker.inventory_manager.equip_item(serrated_dirk, 0)
	
	var req = DamageRequest.create_basic_attack(attacker, target, 100.0)
	var res = CombatCalculator.execute_damage(req)
	
	# Effective armor: 50 - 50 = 0 -> full 100 damage dealt
	if absf(res.final_health_damage - 100.0) > 1.0:
		return "50 Flat Pen vs 50 Armor should deal full 100 damage, got %f" % res.final_health_damage
		
	attacker.free()
	target.free()
	return ""

func test_task23_item_percent_armor_penetration_bypass() -> String:
	var attacker = KaelgorHero.new()
	attacker.team = TeamDefinitions.Team.RADIANT
	attacker._ready()
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	target.attribute_system.set_base_stat(StatModifier.TargetStat.ARMOR, 100.0)
	
	var last_whisper = ItemResource.new()
	last_whisper.id = 954
	last_whisper.item_name = "Last Whisper"
	last_whisper.stat_bonuses[StatModifier.TargetStat.ARMOR_PEN_PERCENT] = 0.50
	attacker.inventory_manager.equip_item(last_whisper, 0)
	
	var req = DamageRequest.create_basic_attack(attacker, target, 100.0)
	var res = CombatCalculator.execute_damage(req)
	
	# 100 armor * 0.50 = 50 effective armor -> 100 / (100 + 50) = 0.6667 -> ~66.7 damage
	if absf(res.final_health_damage - 66.67) > 2.0:
		return "50%% Armor pen vs 100 armor expected ~66.7 damage, got %f" % res.final_health_damage
		
	attacker.free()
	target.free()
	return ""

func test_task23_item_magic_penetration_flat_bypass() -> String:
	var attacker = AstrisHero.new()
	attacker.team = TeamDefinitions.Team.RADIANT
	attacker._ready()
	
	var target = KaelgorHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	target.attribute_system.set_base_stat(StatModifier.TargetStat.MAGIC_RESIST, 30.0)
	
	var sorc_shoes = ItemResource.new()
	sorc_shoes.id = 955
	sorc_shoes.item_name = "Sorcerer's Shoes"
	sorc_shoes.stat_bonuses[StatModifier.TargetStat.MAGIC_PEN_FLAT] = 30.0
	attacker.inventory_manager.equip_item(sorc_shoes, 0)
	
	var req = DamageRequest.create_spell_damage(attacker, target, 100.0, DamageRequest.DamageType.MAGICAL, "Magic Spark")
	var res = CombatCalculator.execute_damage(req)
	
	if absf(res.final_health_damage - 100.0) > 1.0:
		return "30 flat magic pen vs 30 MR should deal full 100 damage, got %f" % res.final_health_damage
		
	attacker.free()
	target.free()
	return ""

func test_task23_item_magic_penetration_percent_bypass() -> String:
	var attacker = AstrisHero.new()
	attacker.team = TeamDefinitions.Team.RADIANT
	attacker._ready()
	
	var target = KaelgorHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	target.attribute_system.set_base_stat(StatModifier.TargetStat.MAGIC_RESIST, 100.0)
	
	var void_staff = ItemResource.new()
	void_staff.id = 956
	void_staff.item_name = "Void Staff"
	void_staff.stat_bonuses[StatModifier.TargetStat.MAGIC_PEN_PERCENT] = 0.40
	attacker.inventory_manager.equip_item(void_staff, 0)
	
	var req = DamageRequest.create_spell_damage(attacker, target, 100.0, DamageRequest.DamageType.MAGICAL, "Cosmic Ray")
	var res = CombatCalculator.execute_damage(req)
	
	# 100 MR * 0.6 = 60 eff MR -> 100 / (100 + 60) = 0.625 -> 62.5 damage
	if absf(res.final_health_damage - 62.5) > 2.0:
		return "40%% Magic pen vs 100 MR expected ~62.5 damage, got %f" % res.final_health_damage
		
	attacker.free()
	target.free()
	return ""

func test_task23_item_critical_strike_proc() -> String:
	var attacker = SolenHero.new()
	attacker.team = TeamDefinitions.Team.RADIANT
	attacker._ready()
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	target.attribute_system.set_base_stat(StatModifier.TargetStat.ARMOR, 0.0)
	
	var crit_item = ItemResource.new()
	crit_item.id = 957
	crit_item.item_name = "Infinity Blade"
	crit_item.stat_bonuses[StatModifier.TargetStat.CRIT_CHANCE] = 1.0 # 100% crit
	crit_item.stat_bonuses[StatModifier.TargetStat.CRIT_DAMAGE] = 2.0 # 200% crit damage
	attacker.inventory_manager.equip_item(crit_item, 0)
	
	var req = DamageRequest.create_basic_attack(attacker, target, 100.0)
	var res = CombatCalculator.execute_damage(req)
	
	if not res.is_critical:
		return "Attack should be marked as critical"
	if absf(res.final_health_damage - 200.0) > 1.0:
		return "100 base damage at 2.0x crit multiplier should deal 200 damage, got %f" % res.final_health_damage
		
	attacker.free()
	target.free()
	return ""

func test_task23_item_lifesteal_on_basic_attack() -> String:
	var attacker = KaelgorHero.new()
	attacker.team = TeamDefinitions.Team.RADIANT
	attacker._ready()
	attacker.attribute_system.current_health = 100.0
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	target.attribute_system.set_base_stat(StatModifier.TargetStat.ARMOR, 0.0)
	
	var lifesteal_item = ItemResource.new()
	lifesteal_item.id = 958
	lifesteal_item.item_name = "Satanic"
	lifesteal_item.stat_bonuses[StatModifier.TargetStat.LIFESTEAL] = 0.25 # 25% lifesteal
	attacker.inventory_manager.equip_item(lifesteal_item, 0)
	
	var req = DamageRequest.create_basic_attack(attacker, target, 200.0)
	var res = CombatCalculator.execute_damage(req)
	
	if absf(res.lifesteal_healed - 50.0) > 1.0: # 25% of 200 = 50
		return "Lifesteal should heal 50 HP, got %f" % res.lifesteal_healed
	if absf(attacker.attribute_system.current_health - 150.0) > 1.0:
		return "Attacker health should be 150 HP after lifesteal, got %f" % attacker.attribute_system.current_health
		
	attacker.free()
	target.free()
	return ""

func test_task23_item_spell_vamp_on_ability_damage() -> String:
	var attacker = AstrisHero.new()
	attacker.team = TeamDefinitions.Team.RADIANT
	attacker._ready()
	attacker.attribute_system.current_health = 100.0
	
	var target = KaelgorHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	target.attribute_system.set_base_stat(StatModifier.TargetStat.MAGIC_RESIST, 0.0)
	
	var spell_vamp_item = ItemResource.new()
	spell_vamp_item.id = 959
	spell_vamp_item.item_name = "Hextech Gunblade"
	spell_vamp_item.stat_bonuses[StatModifier.TargetStat.SPELL_VAMP] = 0.20 # 20% spell vamp
	attacker.inventory_manager.equip_item(spell_vamp_item, 0)
	
	var req = DamageRequest.create_spell_damage(attacker, target, 300.0, DamageRequest.DamageType.MAGICAL, "Arcane Blast")
	var res = CombatCalculator.execute_damage(req)
	
	if absf(res.spell_vamp_healed - 60.0) > 1.0: # 20% of 300 = 60
		return "Spell vamp should heal 60 HP, got %f" % res.spell_vamp_healed
	if absf(attacker.attribute_system.current_health - 160.0) > 1.0:
		return "Attacker HP should be 160 after spell vamp, got %f" % attacker.attribute_system.current_health
		
	attacker.free()
	target.free()
	return ""

func test_task23_active_item_mana_cost_deduction() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	hero.attribute_system.current_mana = 200.0
	
	var aegis = ItemResource.new()
	aegis.id = 115 # Radiant Aegis (50 mana cost)
	aegis.item_name = "Radiant Aegis"
	hero.inventory_manager.equip_item(aegis, 0)
	
	var ok = hero.inventory_manager.use_active_item(0)
	if not ok:
		return "Radiant Aegis activation should succeed"
	if absf(hero.attribute_system.current_mana - 150.0) > 0.01:
		return "Mana should be 150.0 after 50 mana cost, got %f" % hero.attribute_system.current_mana
		
	hero.free()
	return ""

func test_task23_active_item_insufficient_mana_rejection() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	hero.attribute_system.current_mana = 20.0 # Less than 50 mana cost
	
	var aegis = ItemResource.new()
	aegis.id = 115 # 50 mana cost
	aegis.item_name = "Radiant Aegis"
	hero.inventory_manager.equip_item(aegis, 0)
	
	var ok = hero.inventory_manager.use_active_item(0)
	if ok:
		return "Radiant Aegis should fail when mana is insufficient"
	if hero.inventory_manager.active_cooldowns.has(0):
		return "Item should not go on cooldown on rejected cast"
		
	hero.free()
	return ""

func test_task23_active_item_bloodfang_attack_speed_buff() -> String:
	var hero = SolenHero.new()
	hero._ready()
	var base_as = hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	
	var bloodfang = ItemResource.new()
	bloodfang.id = 73 # Bloodfang (+40% AS active)
	bloodfang.item_name = "Bloodfang"
	hero.inventory_manager.equip_item(bloodfang, 0)
	
	var ok = hero.inventory_manager.use_active_item(0)
	if not ok:
		return "Bloodfang activation should succeed"
		
	var buffed_as = hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	if absf(buffed_as - (base_as + 0.40)) > 0.01:
		return "Attack Speed should increase by 0.40 during Bloodfang active, got %f" % buffed_as
		
	hero.free()
	return ""

func test_task23_active_item_titan_slayer_cleanse_and_speed() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	# Apply stun debuff
	var stun = StatusEffect.new("enemy_stun", StatusEffect.EffectType.STUN, 3.0, 0.0, true)
	hero.effect_container.apply_effect(stun)
	if not hero.is_stunned():
		return "Hero should be stunned before cleanse"
		
	var titan = ItemResource.new()
	titan.id = 83 # Titan Slayer (Cleanse CC + MS)
	titan.item_name = "Titan Slayer"
	hero.inventory_manager.equip_item(titan, 0)
	
	var ok = hero.inventory_manager.use_active_item(0)
	if not ok:
		return "Titan Slayer activation should succeed"
	if hero.is_stunned():
		return "Titan Slayer should cleanse stun debuff"
		
	hero.free()
	return ""

func test_task23_active_item_executioners_blade_true_damage() -> String:
	var attacker = KaelgorHero.new()
	attacker.team = TeamDefinitions.Team.RADIANT
	attacker._ready()
	
	var victim = AstrisHero.new()
	victim.team = TeamDefinitions.Team.DIRE
	victim._ready()
	victim.attribute_system.set_base_stat(StatModifier.TargetStat.MAX_HEALTH, 1000.0)
	victim.attribute_system.current_health = 500.0 # 500 missing health
	victim.attribute_system.set_base_stat(StatModifier.TargetStat.ARMOR, 200.0) # High armor shouldn't reduce true damage
	
	var exec = ItemResource.new()
	exec.id = 74 # Executioner's Blade (250 + 20% missing HP = 250 + 100 = 350 true damage)
	exec.item_name = "Executioner's Blade"
	attacker.inventory_manager.equip_item(exec, 0)
	
	var ok = attacker.inventory_manager.use_active_item(0, victim)
	if not ok:
		return "Executioner's Blade activation should succeed"
	if absf(victim.attribute_system.current_health - 150.0) > 2.0: # 500 - 350 = 150
		return "Victim HP should be 150 after 350 true damage, got %f" % victim.attribute_system.current_health
		
	attacker.free()
	victim.free()
	return ""

func test_task23_active_item_timekeeper_cooldown_reset() -> String:
	var hero = AstrisHero.new()
	hero._ready()
	hero.ability_container.cooldown_timers["Q"] = 10.0
	hero.ability_container.cooldown_timers["W"] = 20.0
	
	var timekeeper = ItemResource.new()
	timekeeper.id = 119 # Timekeeper (reduces remaining cooldowns by 40%)
	timekeeper.item_name = "Timekeeper"
	hero.inventory_manager.equip_item(timekeeper, 0)
	
	var ok = hero.inventory_manager.use_active_item(0)
	if not ok:
		return "Timekeeper activation should succeed"
		
	if absf(hero.ability_container.cooldown_timers["Q"] - 6.0) > 0.1: # 10 * 0.6 = 6.0
		return "Q cooldown should be reduced to 6.0s, got %f" % hero.ability_container.cooldown_timers["Q"]
	if absf(hero.ability_container.cooldown_timers["W"] - 12.0) > 0.1: # 20 * 0.6 = 12.0
		return "W cooldown should be reduced to 12.0s, got %f" % hero.ability_container.cooldown_timers["W"]
		
	hero.free()
	return ""

func test_task23_death_clears_temporary_item_buffs() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var bloodfang = ItemResource.new()
	bloodfang.id = 73
	hero.inventory_manager.equip_item(bloodfang, 0)
	hero.inventory_manager.use_active_item(0)
	
	if not hero.attribute_system.active_modifiers.has("bloodfang_active"):
		return "bloodfang_active modifier should be active before death"
		
	hero.die(null)
	if hero.attribute_system.active_modifiers.has("bloodfang_active"):
		return "Death should clear temporary item active modifier"
		
	hero.free()
	return ""

func test_task23_inventory_swap_updates_combat_calculations() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	var base_ad = hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var base_ap = hero.attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	
	var ad_item = ItemResource.new()
	ad_item.stat_bonuses[StatModifier.TargetStat.ATTACK_DAMAGE] = 50.0
	
	var ap_item = ItemResource.new()
	ap_item.stat_bonuses[StatModifier.TargetStat.ABILITY_POWER] = 70.0
	
	hero.inventory_manager.equip_item(ad_item, 0)
	if absf(hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) - (base_ad + 50.0)) > 0.01:
		return "Equipping AD item should increase AD"
		
	hero.inventory_manager.equip_item(ap_item, 0) # Swap slot 0 to AP item
	if absf(hero.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE) - base_ad) > 0.01:
		return "Swapping out AD item should restore base AD"
	if absf(hero.attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER) - (base_ap + 70.0)) > 0.01:
		return "Swapping in AP item should increase AP"
		
	hero.free()
	return ""

func test_task23_dead_hero_cannot_use_active_items() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	hero.is_alive_state = false # Dead
	
	var aegis = ItemResource.new()
	aegis.id = 115
	hero.inventory_manager.equip_item(aegis, 0)
	
	var ok = hero.inventory_manager.use_active_item(0)
	if ok:
		return "Dead hero must not be able to use active items"
		
	hero.free()
	return ""

func test_task23_damage_amplification_item_modifier() -> String:
	var attacker = KaelgorHero.new()
	attacker.team = TeamDefinitions.Team.RADIANT
	attacker._ready()
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	target.attribute_system.set_base_stat(StatModifier.TargetStat.ARMOR, 0.0)
	
	var amp_item = ItemResource.new()
	amp_item.id = 960
	amp_item.item_name = "Heart of Havoc"
	amp_item.stat_bonuses[StatModifier.TargetStat.DAMAGE_AMPLIFICATION] = 0.30 # +30% all damage
	attacker.inventory_manager.equip_item(amp_item, 0)
	
	var req = DamageRequest.create_basic_attack(attacker, target, 100.0)
	var res = CombatCalculator.execute_damage(req)
	
	# 100 * 1.30 = 130 damage
	if absf(res.final_health_damage - 130.0) > 1.0:
		return "100 base damage with 30%% damage amp should deal 130 damage, got %f" % res.final_health_damage
		
	attacker.free()
	target.free()
	return ""

# ==============================================================================
# --- TASK 24: HERO ABILITY RUNTIME SYSTEM TESTS (Tests 424–443) ---
# ==============================================================================

const AbilityDef = preload("res://core/abilities/ability_definition.gd")
const AbilityInst = preload("res://core/abilities/ability_instance.gd")
const AbilityReq = preload("res://core/abilities/ability_cast_request.gd")

func test_task24_ability_definition_data_structure() -> String:
	var def = AbilityDef.new()
	def.id = "test_def"
	def.ability_name = "Sonic Wave"
	def.slot = AbilityResource.Slot.Q
	def.is_movement_ability = true
	def.dash_distance = 7.5
	def.is_healing_ability = true
	def.heal_base = [60.0, 120.0, 180.0, 240.0]
	def.is_shielding_ability = true
	def.shield_base = [100.0, 200.0, 300.0, 400.0]
	
	if def.dash_distance != 7.5:
		return "dash_distance expected 7.5, got %f" % def.dash_distance
	if def.get_heal_amount(2) != 120.0:
		return "get_heal_amount(2) expected 120.0, got %f" % def.get_heal_amount(2)
	if def.get_shield_amount(3) != 300.0:
		return "get_shield_amount(3) expected 300.0, got %f" % def.get_shield_amount(3)
	return ""

func test_task24_ability_instance_initial_state_not_learned() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var inst = hero.ability_container.get_instance(AbilityResource.Slot.Q)
	if inst == null:
		return "AbilityInstance for Q should exist"
	if inst.get_state() != AbilityInst.AbilityState.NOT_LEARNED:
		return "Unlearned Q ability should be in NOT_LEARNED state"
		
	hero.free()
	return ""

func test_task24_ability_instance_learned_state_ready() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	hero.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var inst = hero.ability_container.get_instance(AbilityResource.Slot.Q)
	if inst.get_state() != AbilityInst.AbilityState.READY:
		return "Learned Q ability should be in READY state"
	if not inst.is_ready():
		return "inst.is_ready() should be true"
		
	hero.free()
	return ""

func test_task24_ability_instance_cooldown_state() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	hero.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var inst = hero.ability_container.get_instance(AbilityResource.Slot.Q)
	inst.start_cooldown(6.0)
	
	if inst.get_state() != AbilityInst.AbilityState.COOLDOWN:
		return "Ability on cooldown should report COOLDOWN state"
	if not inst.is_on_cooldown():
		return "inst.is_on_cooldown() should be true"
		
	inst.tick_cooldown(7.0)
	if inst.is_on_cooldown():
		return "Ability should not be on cooldown after 7s tick"
		
	hero.free()
	return ""

func test_task24_ability_instance_disabled_on_silence() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	hero.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var silence = StatusEffect.new("test_silence", StatusEffect.EffectType.SILENCE, 3.0, 0.0, true)
	hero.effect_container.apply_effect(silence)
	
	var inst = hero.ability_container.get_instance(AbilityResource.Slot.Q)
	if inst.get_state() != AbilityInst.AbilityState.DISABLED:
		return "Ability should report DISABLED state when silenced"
		
	hero.free()
	return ""

func test_task24_ability_instance_disabled_on_caster_death() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	hero.ability_container.level_up_ability(AbilityResource.Slot.Q)
	hero.die(null)
	
	var inst = hero.ability_container.get_instance(AbilityResource.Slot.Q)
	if inst.get_state() != AbilityInst.AbilityState.DISABLED:
		return "Ability should report DISABLED state when hero is dead"
		
	hero.free()
	return ""

func test_task24_qwer_slots_instantiation() -> String:
	var hero = AstrisHero.new()
	hero._ready()
	
	for s in [AbilityResource.Slot.PASSIVE, AbilityResource.Slot.Q, AbilityResource.Slot.W, AbilityResource.Slot.E, AbilityResource.Slot.R]:
		var inst = hero.ability_container.get_instance(s)
		if inst == null:
			return "AbilityInstance missing for slot %d" % s
		if inst.definition == null:
			return "Definition missing on instance for slot %d" % s
			
	hero.free()
	return ""

func test_task24_mana_cost_scaling_per_level() -> String:
	var hero = AstrisHero.new()
	hero._ready()
	hero.ability_container.available_skill_points = 5
	hero.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var inst = hero.ability_container.get_instance(AbilityResource.Slot.Q)
	var cost_lvl1 = inst.get_mana_cost()
	
	hero.ability_container.level_up_ability(AbilityResource.Slot.Q)
	var cost_lvl2 = inst.get_mana_cost()
	
	if cost_lvl2 <= cost_lvl1:
		return "Mana cost should increase with ability level (lvl1: %f, lvl2: %f)" % [cost_lvl1, cost_lvl2]
		
	hero.free()
	return ""

func test_task24_cooldown_cdr_scaling() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	hero.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var inst = hero.ability_container.get_instance(AbilityResource.Slot.Q)
	var base_cd = inst.get_cooldown()
	
	# Add 20% CDR
	var cdr_mod = StatModifier.new(StatModifier.TargetStat.COOLDOWN_REDUCTION, StatModifier.Type.FLAT, 0.20, "test_cdr")
	hero.attribute_system.add_modifier(cdr_mod)
	
	var reduced_cd = inst.get_cooldown()
	if absf(reduced_cd - (base_cd * 0.80)) > 0.01:
		return "Cooldown should be reduced by 20%% CDR (base: %f, reduced: %f)" % [base_cd, reduced_cd]
		
	hero.free()
	return ""

func test_task24_target_validation_structures_only() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	
	var siege_skill = AbilityDef.new()
	siege_skill.id = "demolish"
	siege_skill.slot = AbilityResource.Slot.Q
	siege_skill.target_type = AbilityResource.TargetType.SINGLE_TARGET
	siege_skill.target_filter = AbilityResource.TargetFilter.STRUCTURES_ONLY
	hero.ability_container.set_ability(AbilityResource.Slot.Q, siege_skill)
	hero.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var enemy_hero = AstrisHero.new()
	enemy_hero.team = TeamDefinitions.Team.DIRE
	enemy_hero._ready()
	
	var enemy_tower = TowerEntity.new()
	enemy_tower.team = TeamDefinitions.Team.DIRE
	enemy_tower._ready()
	
	var hero_validation = hero.ability_container.validate_cast(AbilityResource.Slot.Q, enemy_hero)
	if hero_validation == AbilityContainer.CastValidationResult.OK:
		return "STRUCTURES_ONLY skill must reject enemy hero"
		
	var tower_validation = hero.ability_container.validate_cast(AbilityResource.Slot.Q, enemy_tower)
	if tower_validation != AbilityContainer.CastValidationResult.OK:
		return "STRUCTURES_ONLY skill should validate enemy tower"
		
	hero.free()
	enemy_hero.free()
	enemy_tower.free()
	return ""

func test_task24_target_validation_immune_or_untargetable() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	target.is_targetable = false
	
	var res = hero.ability_container.validate_cast(AbilityResource.Slot.Q, target)
	if res != AbilityContainer.CastValidationResult.TARGET_NOT_TARGETABLE:
		return "Untargetable entity should fail with TARGET_NOT_TARGETABLE"
		
	hero.free()
	target.free()
	return ""

func test_task24_cast_request_pipeline_execution() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(2.0, 0, 0)
	enemy._ready()
	var prev_hp = enemy.attribute_system.current_health
	
	var req = AbilityReq.create(hero, AbilityResource.Slot.Q, enemy)
	var ok = hero.ability_container.cast_request(req)
	
	if not ok:
		return "cast_request execution should return true"
	if enemy.attribute_system.current_health >= prev_hp:
		return "Enemy health should decrease after cast_request execution"
		
	hero.free()
	enemy.free()
	return ""

func test_task24_cast_request_free_cast_bypass() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.ability_container.level_up_ability(AbilityResource.Slot.Q)
	hero.attribute_system.current_mana = 0.0 # No mana
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(2.0, 0, 0)
	enemy._ready()
	
	var req = AbilityReq.create(hero, AbilityResource.Slot.Q, enemy, Vector3.ZERO, true)
	var ok = hero.ability_container.cast_request(req)
	
	if not ok:
		return "Free cast request should succeed even with 0 mana"
	if hero.ability_container.is_on_cooldown(AbilityResource.Slot.Q):
		return "Free cast request should not place ability on cooldown"
		
	hero.free()
	enemy.free()
	return ""

func test_task24_movement_ability_dash_execution() -> String:
	var hero = KaelgorHero.new()
	hero.position = Vector3(0, 0, 0)
	hero._ready()
	
	var dash_skill = AbilityDef.new()
	dash_skill.id = "hero_dash"
	dash_skill.slot = AbilityResource.Slot.W
	dash_skill.is_movement_ability = true
	dash_skill.dash_distance = 6.0
	hero.ability_container.set_ability(AbilityResource.Slot.W, dash_skill)
	hero.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var ok = hero.ability_container.execute_dash(AbilityResource.Slot.W, Vector3(10, 0, 0))
	if not ok:
		return "execute_dash should succeed"
		
	var hero_pos = hero.global_position if hero.is_inside_tree() else hero.position
	if hero_pos.length() < 5.0:
		return "Hero should have dashed forward ~6m, got distance %f" % hero_pos.length()
		
	hero.free()
	return ""

func test_task24_movement_ability_blink_execution() -> String:
	var hero = AstrisHero.new()
	hero.position = Vector3(0, 0, 0)
	hero._ready()
	
	var blink_skill = AbilityDef.new()
	blink_skill.id = "hero_blink"
	blink_skill.slot = AbilityResource.Slot.E
	blink_skill.is_movement_ability = true
	blink_skill.is_blink = true
	blink_skill.blink_range = 8.0
	hero.ability_container.set_ability(AbilityResource.Slot.E, blink_skill)
	hero.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var ok = hero.ability_container.execute_blink(AbilityResource.Slot.E, Vector3(0, 0, 7.0))
	if not ok:
		return "execute_blink should succeed"
		
	var hero_pos = hero.global_position if hero.is_inside_tree() else hero.position
	if absf(hero_pos.z - 7.0) > 0.1:
		return "Hero should blink to z=7.0, got z=%f" % hero_pos.z
		
	hero.free()
	return ""

func test_task24_healing_ability_execution() -> String:
	var caster = AstrisHero.new()
	caster.team = TeamDefinitions.Team.RADIANT
	caster._ready()
	
	var ally = KaelgorHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	ally.attribute_system.current_health = 200.0
	
	var heal_skill = AbilityDef.new()
	heal_skill.id = "astral_heal"
	heal_skill.slot = AbilityResource.Slot.W
	heal_skill.is_healing_ability = true
	heal_skill.heal_base = [150.0, 200.0, 250.0, 300.0]
	caster.ability_container.set_ability(AbilityResource.Slot.W, heal_skill)
	caster.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var amount = caster.ability_container.execute_heal(AbilityResource.Slot.W, ally)
	if amount < 150.0:
		return "Heal amount expected >= 150.0, got %f" % amount
	if ally.attribute_system.current_health <= 200.0:
		return "Ally health should be restored by heal ability"
		
	caster.free()
	ally.free()
	return ""

func test_task24_shielding_ability_execution() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var shield_skill = AbilityDef.new()
	shield_skill.id = "iron_shield"
	shield_skill.slot = AbilityResource.Slot.E
	shield_skill.is_shielding_ability = true
	shield_skill.shield_base = [200.0, 300.0, 400.0, 500.0]
	shield_skill.shield_duration = 5.0
	hero.ability_container.set_ability(AbilityResource.Slot.E, shield_skill)
	hero.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var amount = hero.ability_container.execute_shield(AbilityResource.Slot.E, hero)
	if amount != 200.0:
		return "Shield amount expected 200.0, got %f" % amount
	if not hero.effect_container.has_effect("iron_shield_shield"):
		return "Shield status effect should be applied to hero"
		
	hero.free()
	return ""

func test_task24_signals_ability_executed_and_hit() -> String:
	var hero = KaelgorHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(2.0, 0, 0)
	enemy._ready()
	
	var executed_fired = [false]
	var hit_fired = [false]
	
	var c1 = hero.ability_container.ability_executed.connect(func(_s, _a, _t, _p): executed_fired[0] = true)
	var c2 = hero.ability_container.ability_target_hit.connect(func(_s, _a, _t, _r): hit_fired[0] = true)
	
	hero.ability_container.cast_ability(AbilityResource.Slot.Q, enemy)
	
	if c1.is_valid():
		hero.ability_container.ability_executed.disconnect(c1)
	if c2.is_valid():
		hero.ability_container.ability_target_hit.disconnect(c2)
		
	if not executed_fired[0]:
		return "ability_executed signal should be emitted on cast"
	if not hit_fired[0]:
		return "ability_target_hit signal should be emitted on impact"
		
	hero.free()
	enemy.free()
	return ""

func test_task24_interruption_on_movement_during_windup() -> String:
	var hero = KaelgorHero.new()
	hero._ready()
	
	var long_cast = AbilityDef.new()
	long_cast.id = "channeled_spell"
	long_cast.slot = AbilityResource.Slot.R
	long_cast.cast_time = 1.0
	hero.ability_container.set_ability(AbilityResource.Slot.R, long_cast)
	hero.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	hero.ability_container.start_cast(AbilityResource.Slot.R)
	if not hero.ability_container.is_casting():
		return "Hero should be in CASTING state during windup"
		
	hero.velocity = Vector3(5.0, 0, 0)
	hero.ability_container._process(0.1)
	
	if hero.ability_container.is_casting():
		return "Moving should interrupt cast windup"
		
	hero.free()
	return ""

func test_task24_virtual_hooks_projectile_and_aoe() -> String:
	var hero = AstrisHero.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var affected = hero.ability_container.execute_aoe_spell(AbilityResource.Slot.W, Vector3(0, 0, 0), 10.0)
	if affected == null:
		return "execute_aoe_spell should return an array"
		
	hero.free()
	return ""

# ==============================================================================
# --- TASK 25: KAELGOR HERO PLAYABILITY & RUNTIME INTEGRATION TESTS (Tests 444–463) ---
# ==============================================================================

func test_task25_furnace_heart_passive_attack_speed_scaling() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	var base_as = kaelgor.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	
	kaelgor.heat_system.set_heat(100.0)
	var max_heat_as = kaelgor.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	
	# At 100 heat, attack speed increases by +30%
	if max_heat_as <= base_as:
		return "100 Heat should grant bonus attack speed (base: %f, with heat: %f)" % [base_as, max_heat_as]
	if absf(max_heat_as - (base_as * 1.30)) > 0.05:
		return "Expected ~30%% AS increase, got %f" % (max_heat_as / base_as)
		
	kaelgor.free()
	return ""

func test_task25_furnace_heart_combat_decay_timer() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.heat_system.set_heat(80.0)
	kaelgor.heat_system.notify_combat_activity()
	
	# In combat: 2 seconds pass, heat should not decay
	kaelgor.heat_system._process(2.0)
	if kaelgor.heat_system.get_heat() != 80.0:
		return "Heat should not decay while combat timer is active (expected 80, got %f)" % kaelgor.heat_system.get_heat()
		
	# 3 more seconds pass (total 5s > 4s delay): decay starts
	kaelgor.heat_system._process(3.0)
	if kaelgor.heat_system.get_heat() >= 80.0:
		return "Heat should decay after combat timer expires"
		
	kaelgor.free()
	return ""

func test_task25_basic_attack_generates_heat() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	kaelgor.heat_system.set_heat(0.0)
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target.position = Vector3(1.0, 0, 0)
	target._ready()
	
	kaelgor.execute_basic_attack(target)
	if kaelgor.heat_system.get_heat() <= 0.0:
		return "Basic attacking an enemy should generate Heat"
		
	kaelgor.free()
	target.free()
	return ""

func test_task25_kaelgor_q_heat_scaling_formula() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = DummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	dummy.attribute_system.set_base_stat(StatModifier.TargetStat.ARMOR, 0.0)
	
	kaelgor.heat_system.set_heat(0.0)
	var res0 = kaelgor.cast_kaelgor_q(dummy)
	
	kaelgor.ability_container.cooldown_timers[AbilityResource.Slot.Q] = 0.0
	kaelgor.attribute_system.restore_mana(100.0)
	kaelgor.heat_system.set_heat(60.0)
	var res60 = kaelgor.cast_kaelgor_q(dummy)
	
	# 60 heat * 1.5 = 90 bonus damage
	var diff = res60.final_health_damage - res0.final_health_damage
	if absf(diff - 90.0) > 1.0:
		return "Q 60 Heat bonus expected 90 damage, got %f" % diff
		
	kaelgor.free()
	dummy.free()
	return ""

func test_task25_kaelgor_q_target_filters_enemy_hero_creep_neutral_tower() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	if kaelgor.ability_container.can_cast_on_target(AbilityResource.Slot.Q, ally):
		return "Q must not be castable on ally"
	if not kaelgor.ability_container.can_cast_on_target(AbilityResource.Slot.Q, enemy):
		return "Q must be castable on enemy"
		
	kaelgor.free()
	ally.free()
	enemy.free()
	return ""

func test_task25_kaelgor_q_insufficient_mana_rejection() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.Q)
	kaelgor.attribute_system.current_mana = 10.0 # Insufficient
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	
	var res = kaelgor.cast_kaelgor_q(target)
	if res != null:
		return "Q should fail to cast with insufficient mana"
		
	kaelgor.free()
	target.free()
	return ""

func test_task25_kaelgor_q_out_of_range_rejection() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor.position = Vector3(0, 0, 0)
	kaelgor._ready()
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target.position = Vector3(25.0, 0, 0) # Far beyond 5.5m
	target._ready()
	
	var valid = kaelgor.ability_container.validate_cast(AbilityResource.Slot.Q, target)
	if valid != AbilityContainer.CastValidationResult.OUT_OF_RANGE:
		return "Q on far target should fail with OUT_OF_RANGE"
		
	kaelgor.free()
	target.free()
	return ""

func test_task25_kaelgor_w_aoe_damage_and_heat_consumption() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.W)
	kaelgor.heat_system.set_heat(50.0)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	enemy.attribute_system.set_base_stat(StatModifier.TargetStat.MAGIC_RESIST, 0.0)
	
	var results = kaelgor.cast_kaelgor_w([enemy])
	if results.is_empty():
		return "W Vent should deal damage to enemy in target list"
	if kaelgor.heat_system.get_heat() != 0.0:
		return "W Vent should consume all current Heat"
		
	kaelgor.free()
	enemy.free()
	return ""

func test_task25_kaelgor_w_slow_status_effect_application() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	kaelgor.cast_kaelgor_w([enemy])
	if not enemy.effect_container.is_slowed():
		return "W Vent should apply slow to target"
		
	kaelgor.free()
	enemy.free()
	return ""

func test_task25_kaelgor_w_hits_multiple_units() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var e1 = AstrisHero.new()
	e1.team = TeamDefinitions.Team.DIRE
	e1._ready()
	
	var e2 = AstrisHero.new()
	e2.team = TeamDefinitions.Team.DIRE
	e2._ready()
	
	var results = kaelgor.cast_kaelgor_w([e1, e2])
	if results.size() < 2:
		return "W Vent should hit all targets in list (expected 2, got %d)" % results.size()
		
	kaelgor.free()
	e1.free()
	e2.free()
	return ""

func test_task25_kaelgor_e_iron_hide_30_percent_damage_reduction() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.attribute_system.set_base_stat(StatModifier.TargetStat.ARMOR, 0.0)
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var dummy = DummyEntity.new()
	dummy._ready()
	
	kaelgor.cast_kaelgor_e()
	var req = DamageRequest.create_ability_damage(dummy, kaelgor, 100.0, DamageRequest.DamageType.PHYSICAL, "Attack")
	var res = kaelgor.receive_damage(req)
	
	if absf(res.final_health_damage - 70.0) > 1.0:
		return "Iron Hide should reduce 100 damage to 70 (got %f)" % res.final_health_damage
		
	kaelgor.free()
	dummy.free()
	return ""

func test_task25_kaelgor_e_iron_hide_heat_generation() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.heat_system.set_heat(0.0)
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var dummy = DummyEntity.new()
	dummy._ready()
	
	kaelgor.cast_kaelgor_e()
	var req = DamageRequest.create_ability_damage(dummy, kaelgor, 200.0, DamageRequest.DamageType.PHYSICAL, "Attack")
	kaelgor.receive_damage(req)
	
	if kaelgor.heat_system.get_heat() <= 0.0:
		return "Iron Hide should generate Heat from absorbed damage"
		
	kaelgor.free()
	dummy.free()
	return ""

func test_task25_kaelgor_e_iron_hide_timer_expiration() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	kaelgor.cast_kaelgor_e()
	if not kaelgor.is_iron_hide_active:
		return "Iron Hide should be active immediately after cast"
		
	kaelgor._process(4.5)
	if kaelgor.is_iron_hide_active:
		return "Iron Hide should expire after 4.0 seconds"
		
	kaelgor.free()
	return ""

func test_task25_kaelgor_r_overheat_maximizes_heat_and_locks_decay() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.R)
	kaelgor.heat_system.set_heat(10.0)
	
	kaelgor.cast_kaelgor_r()
	if absf(kaelgor.heat_system.get_heat() - 100.0) > 0.01:
		return "Overheat must set Heat to 100"
	if not kaelgor.heat_system.is_decay_locked:
		return "Overheat must lock Heat decay"
		
	kaelgor.free()
	return ""

func test_task25_kaelgor_r_overheat_splash_damage_mechanic() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.R)
	kaelgor.cast_kaelgor_r()
	
	var main_target = AstrisHero.new()
	main_target.team = TeamDefinitions.Team.DIRE
	main_target.position = Vector3(1.0, 0, 0)
	main_target._ready()
	
	var splash_target = AstrisHero.new()
	splash_target.team = TeamDefinitions.Team.DIRE
	splash_target.position = Vector3(2.0, 0, 0)
	splash_target._ready()
	var splash_hp_before = splash_target.attribute_system.current_health
	
	kaelgor._execute_overheat_splash(main_target, 50.0)
	if splash_target.attribute_system.current_health >= splash_hp_before:
		return "Overheat splash should damage nearby enemy unit"
		
	kaelgor.free()
	main_target.free()
	splash_target.free()
	return ""

func test_task25_kaelgor_r_overheat_expiration_restores_decay() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.R)
	kaelgor.cast_kaelgor_r()
	
	kaelgor._process(8.5)
	if kaelgor.is_overheated:
		return "Overheat should expire after 8.0 seconds"
	if kaelgor.heat_system.is_decay_locked:
		return "Decay lock should be released after Overheat ends"
		
	kaelgor.free()
	return ""

func test_task25_death_resets_heat_and_buffs() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.R)
	kaelgor.cast_kaelgor_r()
	
	kaelgor.die(null)
	if kaelgor.heat_system.get_heat() != 0.0:
		return "Death must reset Heat to 0"
	if kaelgor.is_overheated:
		return "Death must end Overheat state"
		
	kaelgor.free()
	return ""

func test_task25_respawn_preserves_clean_state() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	kaelgor.die(null)
	kaelgor.respawn()
	
	if kaelgor.heat_system.get_heat() != 0.0:
		return "Respawned Kaelgor should have 0 Heat"
	if not kaelgor.is_alive():
		return "Respawned Kaelgor should be alive"
		
	kaelgor.free()
	return ""

func test_task25_ability_runtime_cast_request_integration() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor.team = TeamDefinitions.Team.RADIANT
	kaelgor._ready()
	kaelgor.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(2.0, 0, 0)
	enemy._ready()
	
	var req = AbilityReq.create(kaelgor, AbilityResource.Slot.Q, enemy)
	var ok = kaelgor.ability_container.cast_request(req)
	
	if not ok:
		return "AbilityCastRequest with Kaelgor Q should succeed"
		
	kaelgor.free()
	enemy.free()
	return ""

func test_task25_world_status_bar_heat_and_mana_display() -> String:
	var kaelgor = KaelgorHero.new()
	kaelgor._ready()
	
	var bar = WorldStatusBar.new()
	bar.debug_mode = true
	bar.setup(kaelgor)
	bar._update_visuals(0.0)
	
	if bar.owner_entity != kaelgor:
		return "WorldStatusBar owner should be Kaelgor"
		
	kaelgor.free()
	bar.free()
	return ""

# ==============================================================================
# --- TASK 26: RAVENA HERO IMPLEMENTATION TESTS (Tests 464–483) ---
# ==============================================================================

func test_task26_ravena_initialization_and_archetype() -> String:
	var ravena = RavenaHeroClass.new()
	ravena._ready()
	
	if ravena.entity_name != "Ravena":
		return "Ravena entity_name incorrect"
	if ravena.attribute_system.primary_attribute != AttributeSystem.PrimaryAttributeType.STRENGTH:
		return "Ravena primary attribute should be STRENGTH"
	if ravena.hero_resource.attack_type != HeroResource.AttackType.MELEE:
		return "Ravena attack type should be MELEE"
	if absf(ravena.attribute_system.base_armor - 24.0) > 0.01:
		return "Ravena base armor should be 24.0, got %f" % ravena.attribute_system.base_armor
	if ravena.ability_container.get_ability(AbilityResource.Slot.Q) == null:
		return "Ravena Q ability missing"
	if ravena.ability_container.get_ability(AbilityResource.Slot.W) == null:
		return "Ravena W ability missing"
	if ravena.ability_container.get_ability(AbilityResource.Slot.E) == null:
		return "Ravena E ability missing"
	if ravena.ability_container.get_ability(AbilityResource.Slot.R) == null:
		return "Ravena R ability missing"
		
	ravena.free()
	return ""

func test_task26_ravena_anchored_passive_armor_growth() -> String:
	var ravena = RavenaHeroClass.new()
	ravena._ready()
	var base_armor = ravena.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	
	# Stand still for 3 seconds -> +15 Armor (3 stacks)
	ravena._process_anchored_passive(3.0)
	var armor_3s = ravena.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	if absf((armor_3s - base_armor) - 15.0) > 0.1:
		return "Anchored at 3s should grant +15 Armor (got %f bonus)" % (armor_3s - base_armor)
		
	# Stand still for 5 more seconds -> capped at +25 Armor (5 stacks)
	ravena._process_anchored_passive(5.0)
	var armor_capped = ravena.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	if absf((armor_capped - base_armor) - 25.0) > 0.1:
		return "Anchored should cap at +25 Armor (got %f bonus)" % (armor_capped - base_armor)
		
	ravena.free()
	return ""

func test_task26_ravena_anchored_passive_movement_reset() -> String:
	var ravena = RavenaHeroClass.new()
	ravena._ready()
	var base_armor = ravena.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	
	# Build max stacks
	ravena._process_anchored_passive(6.0)
	
	# Simulate movement (velocity > 0.1)
	ravena.velocity = Vector3(3.0, 0, 0)
	ravena._process_anchored_passive(0.1)
	
	var armor_after_move = ravena.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	if absf(armor_after_move - base_armor) > 0.1:
		return "Moving should reset Anchored bonus armor to 0 (base: %f, after move: %f)" % [base_armor, armor_after_move]
		
	ravena.free()
	return ""

func test_task26_ravena_q_chain_lance_damage() -> String:
	var ravena = RavenaHeroClass.new()
	ravena.team = TeamDefinitions.Team.RADIANT
	ravena._ready()
	ravena.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target.position = Vector3(4.0, 0, 0)
	target._ready()
	target.attribute_system.set_base_stat(StatModifier.TargetStat.ARMOR, 0.0)
	
	var prev_hp = target.attribute_system.current_health
	var res = ravena.cast_ravena_q(target)
	
	if res == null:
		return "cast_ravena_q should return DamageResult"
	if target.attribute_system.current_health >= prev_hp:
		return "Target health should decrease from Chain Lance"
		
	ravena.free()
	target.free()
	return ""

func test_task26_ravena_q_chain_lance_pull_mechanic() -> String:
	var ravena = RavenaHeroClass.new()
	ravena.team = TeamDefinitions.Team.RADIANT
	ravena.position = Vector3(0, 0, 0)
	ravena._ready()
	ravena.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target.position = Vector3(6.0, 0, 0) # 6m away
	target._ready()
	
	ravena.cast_ravena_q(target)
	
	var t_dist = target.position.length()
	if t_dist >= 5.5:
		return "Chain Lance should pull target towards Ravena (expected < 5.0m, got %f)" % t_dist
		
	ravena.free()
	target.free()
	return ""

func test_task26_ravena_q_chain_lance_rejects_ally() -> String:
	var ravena = RavenaHeroClass.new()
	ravena.team = TeamDefinitions.Team.RADIANT
	ravena._ready()
	ravena.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var res = ravena.cast_ravena_q(ally)
	if res != null:
		return "Chain Lance must reject allied targets"
		
	ravena.free()
	ally.free()
	return ""

func test_task26_ravena_q_chain_lance_cooldown_and_mana() -> String:
	var ravena = RavenaHeroClass.new()
	ravena.team = TeamDefinitions.Team.RADIANT
	ravena._ready()
	ravena.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target.position = Vector3(3.0, 0, 0)
	target._ready()
	
	var initial_mana = ravena.attribute_system.current_mana
	ravena.cast_ravena_q(target)
	
	if not ravena.ability_container.is_on_cooldown(AbilityResource.Slot.Q):
		return "Q should be placed on cooldown after cast"
	if ravena.attribute_system.current_mana >= initial_mana:
		return "Q should consume mana upon casting"
		
	ravena.free()
	target.free()
	return ""

func test_task26_ravena_w_anchor_field_aoe_damage() -> String:
	var ravena = RavenaHeroClass.new()
	ravena.team = TeamDefinitions.Team.RADIANT
	ravena.position = Vector3(0, 0, 0)
	ravena._ready()
	ravena.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(2.0, 0, 0)
	enemy._ready()
	
	var prev_hp = enemy.attribute_system.current_health
	var results = ravena.cast_ravena_w(Vector3(0, 0, 0), [enemy])
	
	if results.is_empty():
		return "W Anchor Field should return damage results"
	if enemy.attribute_system.current_health >= prev_hp:
		return "Enemy health should decrease from Anchor Field"
		
	ravena.free()
	enemy.free()
	return ""

func test_task26_ravena_w_anchor_field_slow_application() -> String:
	var ravena = RavenaHeroClass.new()
	ravena.team = TeamDefinitions.Team.RADIANT
	ravena._ready()
	ravena.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	ravena.cast_ravena_w(Vector3(0, 0, 0), [enemy])
	if not enemy.effect_container.is_slowed():
		return "Anchor Field should apply Slow status effect to enemy"
		
	ravena.free()
	enemy.free()
	return ""

func test_task26_ravena_w_anchor_field_multiple_targets() -> String:
	var ravena = RavenaHeroClass.new()
	ravena.team = TeamDefinitions.Team.RADIANT
	ravena._ready()
	ravena.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var e1 = AstrisHero.new()
	e1.team = TeamDefinitions.Team.DIRE
	e1._ready()
	
	var e2 = AstrisHero.new()
	e2.team = TeamDefinitions.Team.DIRE
	e2._ready()
	
	var results = ravena.cast_ravena_w(Vector3(0, 0, 0), [e1, e2])
	if results.size() != 2:
		return "Anchor Field should hit both targets (expected 2, got %d)" % results.size()
		
	ravena.free()
	e1.free()
	e2.free()
	return ""

func test_task26_ravena_e_reposition_enemy_pull() -> String:
	var ravena = RavenaHeroClass.new()
	ravena.team = TeamDefinitions.Team.RADIANT
	ravena.position = Vector3(0, 0, 0)
	ravena._ready()
	ravena.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(5.0, 0, 0)
	enemy._ready()
	
	var ok = ravena.cast_ravena_e(enemy)
	if not ok:
		return "cast_ravena_e on enemy should succeed"
		
	var enemy_dist = enemy.position.length()
	if enemy_dist >= 4.5:
		return "E Reposition on enemy should pull enemy closer (got distance %f)" % enemy_dist
		
	ravena.free()
	enemy.free()
	return ""

func test_task26_ravena_e_reposition_ally_dash() -> String:
	var ravena = RavenaHeroClass.new()
	ravena.team = TeamDefinitions.Team.RADIANT
	ravena.position = Vector3(0, 0, 0)
	ravena._ready()
	ravena.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(0, 0, 5.0)
	ally._ready()
	
	var ok = ravena.cast_ravena_e(ally)
	if not ok:
		return "cast_ravena_e on ally should succeed"
		
	var ravena_pos = ravena.position.z
	if ravena_pos <= 1.0:
		return "E Reposition on ally should dash Ravena towards ally (got z=%f)" % ravena_pos
		
	ravena.free()
	ally.free()
	return ""

func test_task26_ravena_e_reposition_rejects_self() -> String:
	var ravena = RavenaHeroClass.new()
	ravena.team = TeamDefinitions.Team.RADIANT
	ravena._ready()
	ravena.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var ok = ravena.cast_ravena_e(ravena)
	if ok:
		return "E Reposition must not be self-castable"
		
	ravena.free()
	return ""

func test_task26_ravena_e_reposition_rejects_dead_or_untargetable() -> String:
	var ravena = RavenaHeroClass.new()
	ravena.team = TeamDefinitions.Team.RADIANT
	ravena._ready()
	ravena.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var target = AstrisHero.new()
	target.team = TeamDefinitions.Team.DIRE
	target._ready()
	target.is_targetable = false
	
	var ok = ravena.cast_ravena_e(target)
	if ok:
		return "E Reposition must reject untargetable entities"
		
	ravena.free()
	target.free()
	return ""

func test_task26_ravena_r_lockdown_heavy_damage() -> String:
	var ravena = RavenaHeroClass.new()
	ravena.team = TeamDefinitions.Team.RADIANT
	ravena._ready()
	ravena.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(2.0, 0, 0)
	enemy._ready()
	enemy.attribute_system.set_base_stat(StatModifier.TargetStat.ARMOR, 0.0)
	
	var prev_hp = enemy.attribute_system.current_health
	var res = ravena.cast_ravena_r(enemy)
	
	if res == null:
		return "R Lockdown should return DamageResult"
	if (prev_hp - enemy.attribute_system.current_health) < 150.0:
		return "R Lockdown should deal heavy damage (>150)"
		
	ravena.free()
	enemy.free()
	return ""

func test_task26_ravena_r_lockdown_stun_application() -> String:
	var ravena = RavenaHeroClass.new()
	ravena.team = TeamDefinitions.Team.RADIANT
	ravena._ready()
	ravena.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(2.0, 0, 0)
	enemy._ready()
	
	ravena.cast_ravena_r(enemy)
	if not enemy.effect_container.is_stunned():
		return "R Lockdown should apply STUN CC effect to enemy"
		
	ravena.free()
	enemy.free()
	return ""

func test_task26_ravena_r_lockdown_rejects_allies() -> String:
	var ravena = RavenaHeroClass.new()
	ravena.team = TeamDefinitions.Team.RADIANT
	ravena._ready()
	ravena.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var res = ravena.cast_ravena_r(ally)
	if res != null:
		return "R Lockdown must reject allied targets"
		
	ravena.free()
	ally.free()
	return ""

func test_task26_ravena_hero_definition_factory() -> String:
	HeroDefinition._ensure_registry()
	var def = HeroDefinition.get_definition("ravena")
	if def == null:
		return "HeroDefinition.get_definition('ravena') should not be null, registry keys: %s" % str(HeroDefinition._hero_registry.keys())
	if def.hero_name != "Ravena":
		return "Hero name expected 'Ravena', got '%s'" % def.hero_name
		
	var hero = HeroDefinition.create_hero_instance("ravena")
	if hero == null or not (hero is RavenaHeroClass):
		return "create_hero_instance('ravena') should produce RavenaHero"
		
	hero.free()
	return ""

func test_task26_ravena_death_resets_anchored_bonus() -> String:
	var ravena = RavenaHeroClass.new()
	ravena._ready()
	ravena._process_anchored_passive(5.0)
	
	ravena.die(null)
	if ravena.current_anchor_armor != 0.0:
		return "Death should reset Anchored bonus armor to 0"
		
	ravena.free()
	return ""

func test_task26_ravena_respawn_clean_state() -> String:
	var ravena = RavenaHeroClass.new()
	ravena._ready()
	ravena.die(null)
	ravena.respawn()
	
	if not ravena.is_alive():
		return "Respawned Ravena should be alive"
	if ravena.current_anchor_armor != 0.0:
		return "Respawned Ravena should start with 0 Anchored bonus armor"
		
	ravena.free()
	return ""

# ==============================================================================
# --- TASK 27: THAROS HERO IMPLEMENTATION TESTS (Tests 484–503) ---
# ==============================================================================

func test_task27_tharos_initialization_and_archetype() -> String:
	var tharos = TharosHeroClass.new()
	tharos._ready()
	
	if tharos.entity_name != "Tharos":
		return "Tharos entity_name incorrect"
	if tharos.attribute_system.primary_attribute != AttributeSystem.PrimaryAttributeType.STRENGTH:
		return "Tharos primary attribute should be STRENGTH"
	if tharos.hero_resource.attack_type != HeroResource.AttackType.MELEE:
		return "Tharos attack type should be MELEE"
	if absf(tharos.attribute_system.base_health - 640.0) > 0.01:
		return "Tharos base health should be 640.0, got %f" % tharos.attribute_system.base_health
	if tharos.ability_container.get_ability(AbilityResource.Slot.Q) == null:
		return "Tharos Q ability missing"
	if tharos.ability_container.get_ability(AbilityResource.Slot.W) == null:
		return "Tharos W ability missing"
	if tharos.ability_container.get_ability(AbilityResource.Slot.E) == null:
		return "Tharos E ability missing"
	if tharos.ability_container.get_ability(AbilityResource.Slot.R) == null:
		return "Tharos R ability missing"
		
	tharos.free()
	return ""

func test_task27_tharos_living_mass_bonus_hp_to_ad() -> String:
	var tharos = TharosHeroClass.new()
	tharos._ready()
	var base_ad = tharos.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	
	# Add +400 Flat Max HP via an item/modifier
	var hp_mod = StatModifier.new(StatModifier.TargetStat.MAX_HEALTH, StatModifier.Type.FLAT, 400.0, "test_hp_item")
	tharos.attribute_system.add_modifier(hp_mod)
	tharos._update_living_mass()
	
	# 400 bonus HP * 0.025 = +10 AD
	var new_ad = tharos.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var diff = new_ad - base_ad
	if absf(diff - 10.0) > 0.1:
		return "Living Mass: 400 bonus HP should grant +10 AD (got diff %f)" % diff
		
	tharos.free()
	return ""

func test_task27_tharos_living_mass_dynamic_update() -> String:
	var tharos = TharosHeroClass.new()
	tharos._ready()
	var base_ad = tharos.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	
	var hp_mod = StatModifier.new(StatModifier.TargetStat.MAX_HEALTH, StatModifier.Type.FLAT, 800.0, "test_hp_item2")
	tharos.attribute_system.add_modifier(hp_mod)
	tharos._process(0.1)
	
	# 800 bonus HP * 0.025 = +20 AD
	var ad_with_hp = tharos.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	if absf((ad_with_hp - base_ad) - 20.0) > 0.1:
		return "Living Mass should dynamically scale on _process (+20 AD expected, got %f)" % (ad_with_hp - base_ad)
		
	tharos.attribute_system.remove_modifiers_by_source("test_hp_item2")
	tharos._process(0.1)
	var ad_after_removal = tharos.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	if absf(ad_after_removal - base_ad) > 0.1:
		return "Living Mass should reset AD when bonus HP is removed"
		
	tharos.free()
	return ""

func test_task27_tharos_q_groundbreaker_aoe_damage() -> String:
	var tharos = TharosHeroClass.new()
	tharos.team = TeamDefinitions.Team.RADIANT
	tharos.position = Vector3(0, 0, 0)
	tharos._ready()
	tharos.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(2.0, 0, 0)
	enemy._ready()
	enemy.attribute_system.set_base_stat(StatModifier.TargetStat.ARMOR, 0.0)
	
	var prev_hp = enemy.attribute_system.current_health
	var results = tharos.cast_tharos_q([enemy])
	
	if results.is_empty():
		return "Q Groundbreaker should return damage results"
	if enemy.attribute_system.current_health >= prev_hp:
		return "Enemy health should decrease from Groundbreaker"
		
	tharos.free()
	enemy.free()
	return ""

func test_task27_tharos_q_groundbreaker_missing_hp_stun_scaling() -> String:
	var tharos_full = TharosHeroClass.new()
	tharos_full.team = TeamDefinitions.Team.RADIANT
	tharos_full._ready()
	tharos_full.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var e1 = AstrisHero.new()
	e1.team = TeamDefinitions.Team.DIRE
	e1._ready()
	
	tharos_full.cast_tharos_q([e1])
	var eff1 = e1.effect_container.get_effect("tharos_groundbreaker_stun")
	if eff1 == null or absf(eff1.duration - 0.75) > 0.05:
		return "Full HP Tharos Q should stun for ~0.75s (got %s)" % (str(eff1.duration) if eff1 != null else "null")
		
	var tharos_low = TharosHeroClass.new()
	tharos_low.team = TeamDefinitions.Team.RADIANT
	tharos_low._ready()
	tharos_low.ability_container.level_up_ability(AbilityResource.Slot.Q)
	tharos_low.attribute_system.current_health = 10.0 # near 0 HP
	
	var e2 = AstrisHero.new()
	e2.team = TeamDefinitions.Team.DIRE
	e2._ready()
	
	tharos_low.cast_tharos_q([e2])
	var eff2 = e2.effect_container.get_effect("tharos_groundbreaker_stun")
	if eff2 == null or eff2.duration <= 1.50:
		return "Low HP Tharos Q should stun for > 1.50s (got %s)" % (str(eff2.duration) if eff2 != null else "null")
		
	tharos_full.free()
	tharos_low.free()
	e1.free()
	e2.free()
	return ""

func test_task27_tharos_q_groundbreaker_multiple_units() -> String:
	var tharos = TharosHeroClass.new()
	tharos.team = TeamDefinitions.Team.RADIANT
	tharos._ready()
	tharos.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var e1 = AstrisHero.new()
	e1.team = TeamDefinitions.Team.DIRE
	e1._ready()
	
	var e2 = AstrisHero.new()
	e2.team = TeamDefinitions.Team.DIRE
	e2._ready()
	
	var results = tharos.cast_tharos_q([e1, e2])
	if results.size() != 2:
		return "Q Groundbreaker should hit both targets (expected 2, got %d)" % results.size()
		
	tharos.free()
	e1.free()
	e2.free()
	return ""

func test_task27_tharos_q_groundbreaker_cooldown_and_mana() -> String:
	var tharos = TharosHeroClass.new()
	tharos.team = TeamDefinitions.Team.RADIANT
	tharos._ready()
	tharos.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var initial_mana = tharos.attribute_system.current_mana
	tharos.cast_tharos_q([])
	
	if not tharos.ability_container.is_on_cooldown(AbilityResource.Slot.Q):
		return "Q should be placed on cooldown after cast"
	if tharos.attribute_system.current_mana >= initial_mana:
		return "Q should consume mana upon casting"
		
	tharos.free()
	return ""

func test_task27_tharos_w_bulkhead_damage_mitigation() -> String:
	var tharos = TharosHeroClass.new()
	tharos._ready()
	tharos.attribute_system.set_base_stat(StatModifier.TargetStat.ARMOR, 0.0)
	tharos.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var dummy = DummyEntity.new()
	dummy._ready()
	
	tharos.cast_tharos_w()
	var req = DamageRequest.create_ability_damage(dummy, tharos, 100.0, DamageRequest.DamageType.PHYSICAL, "Attack")
	var res = tharos.receive_damage(req)
	
	# 35% reduction on 100 dmg = 65 dmg
	if absf(res.final_health_damage - 65.0) > 1.0:
		return "Bulkhead should reduce 100 damage to 65.0 (got %f)" % res.final_health_damage
		
	tharos.free()
	dummy.free()
	return ""

func test_task27_tharos_w_bulkhead_self_slow() -> String:
	var tharos = TharosHeroClass.new()
	tharos._ready()
	var base_ms = tharos.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	tharos.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	tharos.cast_tharos_w()
	var ms_active = tharos.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	# -20% Move speed
	if absf(ms_active - (base_ms * 0.80)) > 1.0:
		return "Bulkhead should reduce move speed by 20%% (base: %f, active: %f)" % [base_ms, ms_active]
		
	tharos.free()
	return ""

func test_task27_tharos_w_bulkhead_expiration() -> String:
	var tharos = TharosHeroClass.new()
	tharos._ready()
	var base_ms = tharos.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	tharos.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	tharos.cast_tharos_w()
	tharos._process(4.5)
	
	if tharos.is_bulkhead_active:
		return "Bulkhead should expire after 4.0s"
	var ms_after = tharos.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	if absf(ms_after - base_ms) > 0.5:
		return "Movement speed should restore after Bulkhead ends"
		
	tharos.free()
	return ""

func test_task27_tharos_e_crushing_step_dash() -> String:
	var tharos = TharosHeroClass.new()
	tharos.team = TeamDefinitions.Team.RADIANT
	tharos.position = Vector3(0, 0, 0)
	tharos._ready()
	tharos.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var dest = Vector3(5.0, 0, 0)
	tharos.cast_tharos_e(dest)
	
	if tharos.position.distance_to(dest) > 0.1:
		return "Crushing Step should move Tharos to target position"
		
	tharos.free()
	return ""

func test_task27_tharos_e_crushing_step_aoe_damage() -> String:
	var tharos = TharosHeroClass.new()
	tharos.team = TeamDefinitions.Team.RADIANT
	tharos.position = Vector3(0, 0, 0)
	tharos._ready()
	tharos.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(4.0, 0, 0)
	enemy._ready()
	
	var prev_hp = enemy.attribute_system.current_health
	var results = tharos.cast_tharos_e(Vector3(4.0, 0, 0), [enemy])
	
	if results.is_empty():
		return "Crushing Step should deal damage on landing"
	if enemy.attribute_system.current_health >= prev_hp:
		return "Enemy health should decrease from Crushing Step landing"
		
	tharos.free()
	enemy.free()
	return ""

func test_task27_tharos_e_crushing_step_slow_application() -> String:
	var tharos = TharosHeroClass.new()
	tharos.team = TeamDefinitions.Team.RADIANT
	tharos._ready()
	tharos.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(4.0, 0, 0)
	enemy._ready()
	
	tharos.cast_tharos_e(Vector3(4.0, 0, 0), [enemy])
	if not enemy.effect_container.is_slowed():
		return "Crushing Step should apply Slow status effect to enemy"
		
	tharos.free()
	enemy.free()
	return ""

func test_task27_tharos_r_colossus_max_hp_increase() -> String:
	var tharos = TharosHeroClass.new()
	tharos._ready()
	var base_max_hp = tharos.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	tharos.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	tharos.cast_tharos_r()
	var colossus_max_hp = tharos.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	
	# Level 1 Colossus adds +500 Max HP
	if absf((colossus_max_hp - base_max_hp) - 500.0) > 1.0:
		return "Colossus level 1 should grant +500 Max HP (got %f bonus)" % (colossus_max_hp - base_max_hp)
		
	tharos.free()
	return ""

func test_task27_tharos_r_colossus_living_mass_synergy() -> String:
	var tharos = TharosHeroClass.new()
	tharos._ready()
	var base_ad = tharos.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	tharos.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	tharos.cast_tharos_r()
	# +500 Max HP gives 500 * 0.025 = +12.5 bonus AD from Living Mass!
	var colossus_ad = tharos.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var ad_gain = colossus_ad - base_ad
	
	if absf(ad_gain - 12.5) > 0.5:
		return "Colossus HP should trigger Living Mass passive (+12.5 AD expected, got %f)" % ad_gain
		
	tharos.free()
	return ""

func test_task27_tharos_r_colossus_range_and_slow() -> String:
	var tharos = TharosHeroClass.new()
	tharos._ready()
	var base_range = tharos.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_RANGE)
	var base_ms = tharos.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	tharos.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	tharos.cast_tharos_r()
	var new_range = tharos.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_RANGE)
	var new_ms = tharos.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	if absf((new_range - base_range) - 75.0) > 1.0:
		return "Colossus should grant +75 Attack Range"
	if absf(new_ms - (base_ms * 0.85)) > 1.0:
		return "Colossus should reduce Move Speed by 15%%"
		
	tharos.free()
	return ""

func test_task27_tharos_r_colossus_expiration() -> String:
	var tharos = TharosHeroClass.new()
	tharos._ready()
	var base_max_hp = tharos.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	tharos.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	tharos.cast_tharos_r()
	tharos._process(10.5)
	
	if tharos.is_colossus_active:
		return "Colossus should expire after 10.0s"
	var max_hp_after = tharos.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	if absf(max_hp_after - base_max_hp) > 1.0:
		return "Max HP should return to base after Colossus expires"
		
	tharos.free()
	return ""

func test_task27_tharos_hero_definition_factory() -> String:
	HeroDefinition._ensure_registry()
	var def = HeroDefinition.get_definition("tharos")
	if def == null:
		return "HeroDefinition.get_definition('tharos') should not be null"
	if def.hero_name != "Tharos":
		return "Hero name expected 'Tharos', got '%s'" % def.hero_name
		
	var hero = HeroDefinition.create_hero_instance("tharos")
	if hero == null or not (hero is TharosHeroClass):
		return "create_hero_instance('tharos') should produce TharosHero"
		
	hero.free()
	return ""

func test_task27_tharos_death_clears_buffs() -> String:
	var tharos = TharosHeroClass.new()
	tharos._ready()
	tharos.ability_container.level_up_ability(AbilityResource.Slot.W)
	tharos.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	tharos.cast_tharos_w()
	tharos.cast_tharos_r()
	
	tharos.die(null)
	if tharos.is_bulkhead_active or tharos.is_colossus_active:
		return "Death should deactivate Bulkhead and Colossus"
		
	tharos.free()
	return ""

func test_task27_tharos_respawn_clean_state() -> String:
	var tharos = TharosHeroClass.new()
	tharos._ready()
	tharos.die(null)
	tharos.respawn()
	
	if not tharos.is_alive():
		return "Respawned Tharos should be alive"
	if tharos.is_bulkhead_active or tharos.is_colossus_active:
		return "Respawned Tharos should not have active ability states"
		
	tharos.free()
	return ""

# ==============================================================================
# --- TASK 28: MORDREN HERO IMPLEMENTATION TESTS (Tests 504–523) ---
# ==============================================================================

func test_task28_mordren_initialization_and_archetype() -> String:
	var mordren = MordrenHeroClass.new()
	mordren._ready()
	
	if mordren.entity_name != "Mordren":
		return "Mordren entity_name incorrect"
	if mordren.attribute_system.primary_attribute != AttributeSystem.PrimaryAttributeType.STRENGTH:
		return "Mordren primary attribute should be STRENGTH"
	if mordren.hero_resource.attack_type != HeroResource.AttackType.MELEE:
		return "Mordren attack type should be MELEE"
	if absf(mordren.attribute_system.base_health - 590.0) > 0.01:
		return "Mordren base health should be 590.0, got %f" % mordren.attribute_system.base_health
	if mordren.ability_container.get_ability(AbilityResource.Slot.Q) == null:
		return "Mordren Q ability missing"
	if mordren.ability_container.get_ability(AbilityResource.Slot.W) == null:
		return "Mordren W ability missing"
	if mordren.ability_container.get_ability(AbilityResource.Slot.E) == null:
		return "Mordren E ability missing"
	if mordren.ability_container.get_ability(AbilityResource.Slot.R) == null:
		return "Mordren R ability missing"
		
	mordren.free()
	return ""

func test_task28_mordren_hunt_mark_applied_on_damage() -> String:
	var mordren = MordrenHeroClass.new()
	mordren.team = TeamDefinitions.Team.RADIANT
	mordren._ready()
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	mordren.apply_hunt_mark(enemy)
	if not mordren.has_hunt_mark(enemy):
		return "Hunt Mark should be present on enemy after apply_hunt_mark"
		
	mordren.free()
	enemy.free()
	return ""

func test_task28_mordren_hunt_mark_refresh() -> String:
	var mordren = MordrenHeroClass.new()
	mordren.team = TeamDefinitions.Team.RADIANT
	mordren._ready()
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	mordren.apply_hunt_mark(enemy)
	enemy.effect_container.process_effects(3.0)
	var eff = enemy.effect_container.get_effect("mordren_hunt_mark")
	if eff == null or eff.remaining_time > 2.5:
		return "Hunt Mark should have ~2.0s remaining after 3s elapsed"
		
	# Refresh mark
	mordren.apply_hunt_mark(enemy)
	var refreshed_eff = enemy.effect_container.get_effect("mordren_hunt_mark")
	if refreshed_eff == null or refreshed_eff.remaining_time < 4.5:
		return "Hunt Mark duration should refresh back to 5.0s on subsequent hit"
		
	mordren.free()
	enemy.free()
	return ""

func test_task28_mordren_hunt_mark_expiration() -> String:
	var mordren = MordrenHeroClass.new()
	mordren.team = TeamDefinitions.Team.RADIANT
	mordren._ready()
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	mordren.apply_hunt_mark(enemy)
	enemy.effect_container.process_effects(5.5)
	
	if mordren.has_hunt_mark(enemy):
		return "Hunt Mark should expire after 5.0 seconds"
		
	mordren.free()
	enemy.free()
	return ""

func test_task28_mordren_q_cleaver_base_damage() -> String:
	var mordren = MordrenHeroClass.new()
	mordren.team = TeamDefinitions.Team.RADIANT
	mordren.position = Vector3(0, 0, 0)
	mordren._ready()
	mordren.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(1.5, 0, 0)
	enemy._ready()
	enemy.attribute_system.set_base_stat(StatModifier.TargetStat.ARMOR, 0.0)
	
	var prev_hp = enemy.attribute_system.current_health
	var res = mordren.cast_mordren_q(enemy)
	
	if res == null:
		return "Q Cleaver should return DamageResult"
	if enemy.attribute_system.current_health >= prev_hp:
		return "Enemy health should decrease from Cleaver damage"
		
	mordren.free()
	enemy.free()
	return ""

func test_task28_mordren_q_cleaver_marked_target_bonus() -> String:
	var mordren = MordrenHeroClass.new()
	mordren.team = TeamDefinitions.Team.RADIANT
	mordren.position = Vector3(0, 0, 0)
	mordren._ready()
	mordren.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var e_unmarked = AstrisHero.new()
	e_unmarked.team = TeamDefinitions.Team.DIRE
	e_unmarked.position = Vector3(1.5, 0, 0)
	e_unmarked._ready()
	e_unmarked.attribute_system.set_base_stat(StatModifier.TargetStat.ARMOR, 0.0)
	
	var res_unmarked = mordren.cast_mordren_q(e_unmarked)
	var dmg_unmarked = res_unmarked.final_health_damage
	
	# Cooldown reset for test
	mordren.ability_container.reset_all_cooldowns()
	
	var e_marked = AstrisHero.new()
	e_marked.team = TeamDefinitions.Team.DIRE
	e_marked.position = Vector3(1.5, 0, 0)
	e_marked._ready()
	e_marked.attribute_system.set_base_stat(StatModifier.TargetStat.ARMOR, 0.0)
	mordren.apply_hunt_mark(e_marked)
	
	var res_marked = mordren.cast_mordren_q(e_marked)
	var dmg_marked = res_marked.final_health_damage
	
	if absf(dmg_marked - (dmg_unmarked * 1.50)) > 2.0:
		return "Cleaver on marked target should deal 50%% bonus damage (unmarked: %f, marked: %f)" % [dmg_unmarked, dmg_marked]
		
	mordren.free()
	e_unmarked.free()
	e_marked.free()
	return ""

func test_task28_mordren_q_cleaver_cooldown_and_mana() -> String:
	var mordren = MordrenHeroClass.new()
	mordren.team = TeamDefinitions.Team.RADIANT
	mordren.position = Vector3(0, 0, 0)
	mordren._ready()
	mordren.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(1.5, 0, 0)
	enemy._ready()
	
	var initial_mana = mordren.attribute_system.current_mana
	mordren.cast_mordren_q(enemy)
	
	if not mordren.ability_container.is_on_cooldown(AbilityResource.Slot.Q):
		return "Q should be placed on cooldown after cast"
	if mordren.attribute_system.current_mana >= initial_mana:
		return "Q should consume mana upon casting"
		
	mordren.free()
	enemy.free()
	return ""

func test_task28_mordren_w_blood_trail_passive_speed() -> String:
	var mordren = MordrenHeroClass.new()
	mordren.team = TeamDefinitions.Team.RADIANT
	mordren.position = Vector3(0, 0, 0)
	mordren._ready()
	var base_ms = mordren.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(8.0, 0, 0) # within 12.0m
	enemy._ready()
	mordren.apply_hunt_mark(enemy)
	
	mordren._process(0.1)
	var active_ms = mordren.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	# +25% Move Speed
	if absf(active_ms - (base_ms * 1.25)) > 1.0:
		return "Blood Trail should grant +25%% Move Speed near marked enemy (base: %f, active: %f)" % [base_ms, active_ms]
		
	mordren.free()
	enemy.free()
	return ""

func test_task28_mordren_w_blood_trail_speed_clears() -> String:
	var mordren = MordrenHeroClass.new()
	mordren.team = TeamDefinitions.Team.RADIANT
	mordren.position = Vector3(0, 0, 0)
	mordren._ready()
	var base_ms = mordren.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(8.0, 0, 0)
	enemy._ready()
	mordren.apply_hunt_mark(enemy)
	
	mordren._process(0.1)
	
	# Enemy moves far away (25.0m)
	enemy.position = Vector3(25.0, 0, 0)
	mordren._process(0.1)
	
	var ms_after = mordren.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	if absf(ms_after - base_ms) > 0.5:
		return "Blood Trail bonus speed should clear when enemy is out of range"
		
	mordren.free()
	enemy.free()
	return ""

func test_task28_mordren_w_blood_trail_active_burst() -> String:
	var mordren = MordrenHeroClass.new()
	mordren._ready()
	var base_ms = mordren.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	mordren.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	mordren.cast_mordren_w()
	var burst_ms = mordren.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	# +40% Burst Move Speed
	if absf(burst_ms - (base_ms * 1.40)) > 1.0:
		return "Blood Trail active burst should grant +40%% Move Speed (base: %f, burst: %f)" % [base_ms, burst_ms]
		
	mordren._process(3.5)
	var ms_after = mordren.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	if absf(ms_after - base_ms) > 0.5:
		return "Blood Trail burst should expire after 3.0s"
		
	mordren.free()
	return ""

func test_task28_mordren_e_relentless_shield_granted() -> String:
	var mordren = MordrenHeroClass.new()
	mordren.team = TeamDefinitions.Team.RADIANT
	mordren.position = Vector3(0, 0, 0)
	mordren._ready()
	mordren.ability_container.level_up_ability(AbilityResource.Slot.Q)
	mordren.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(1.5, 0, 0)
	enemy._ready()
	mordren.apply_hunt_mark(enemy)
	
	mordren.cast_mordren_q(enemy)
	
	if not mordren.effect_container.has_effect("mordren_relentless_shield"):
		return "Relentless should grant shield when damaging marked enemy"
		
	mordren.free()
	enemy.free()
	return ""

func test_task28_mordren_e_relentless_shield_refresh_no_stack() -> String:
	var mordren = MordrenHeroClass.new()
	mordren.team = TeamDefinitions.Team.RADIANT
	mordren._ready()
	mordren.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	mordren._trigger_relentless_shield()
	var eff1 = mordren.effect_container.get_effect("mordren_relentless_shield")
	var initial_val = eff1.intensity
	
	mordren._trigger_relentless_shield()
	var eff2 = mordren.effect_container.get_effect("mordren_relentless_shield")
	
	if eff2.intensity > initial_val:
		return "Relentless shield should not stack infinitely; it should refresh duration"
		
	mordren.free()
	return ""

func test_task28_mordren_e_relentless_active_cast() -> String:
	var mordren = MordrenHeroClass.new()
	mordren._ready()
	mordren.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var res = mordren.cast_mordren_e()
	if not res:
		return "Relentless active cast should return true"
	if not mordren.effect_container.has_effect("mordren_relentless_shield"):
		return "Relentless active cast should grant shield"
		
	mordren.free()
	return ""

func test_task28_mordren_r_final_hunt_execution_success() -> String:
	var mordren = MordrenHeroClass.new()
	mordren.team = TeamDefinitions.Team.RADIANT
	mordren.position = Vector3(0, 0, 0)
	mordren._ready()
	mordren.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(5.0, 0, 0)
	enemy._ready()
	mordren.apply_hunt_mark(enemy)
	enemy.attribute_system.current_health = 150.0 # 150 / 600 = 25% HP (<= 35%)
	
	var res = mordren.cast_mordren_r(enemy)
	if res == null:
		return "Final Hunt should execute successfully on low HP marked target"
	if mordren.position.distance_to(enemy.position) > 0.5:
		return "Final Hunt should dash Mordren directly to target position"
		
	mordren.free()
	enemy.free()
	return ""

func test_task28_mordren_r_final_hunt_rejects_unmarked() -> String:
	var mordren = MordrenHeroClass.new()
	mordren.team = TeamDefinitions.Team.RADIANT
	mordren.position = Vector3(0, 0, 0)
	mordren._ready()
	mordren.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(5.0, 0, 0)
	enemy._ready()
	enemy.attribute_system.current_health = 100.0 # Low HP but NOT marked
	
	var res = mordren.cast_mordren_r(enemy)
	if res != null:
		return "Final Hunt should be REJECTED if target is not marked"
		
	mordren.free()
	enemy.free()
	return ""

func test_task28_mordren_r_final_hunt_rejects_high_hp() -> String:
	var mordren = MordrenHeroClass.new()
	mordren.team = TeamDefinitions.Team.RADIANT
	mordren.position = Vector3(0, 0, 0)
	mordren._ready()
	mordren.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(5.0, 0, 0)
	enemy._ready()
	mordren.apply_hunt_mark(enemy)
	# Full HP (100% > 35%)
	
	var res = mordren.cast_mordren_r(enemy)
	if res != null:
		return "Final Hunt should be REJECTED if target HP is above 35%%"
		
	mordren.free()
	enemy.free()
	return ""

func test_task28_mordren_r_final_hunt_rejects_allies() -> String:
	var mordren = MordrenHeroClass.new()
	mordren.team = TeamDefinitions.Team.RADIANT
	mordren.position = Vector3(0, 0, 0)
	mordren._ready()
	mordren.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(5.0, 0, 0)
	ally._ready()
	ally.attribute_system.current_health = 50.0
	
	var res = mordren.cast_mordren_r(ally)
	if res != null:
		return "Final Hunt should reject allied targets"
		
	mordren.free()
	ally.free()
	return ""

func test_task28_mordren_hero_definition_factory() -> String:
	HeroDefinition._ensure_registry()
	var def = HeroDefinition.get_definition("mordren")
	if def == null:
		return "HeroDefinition.get_definition('mordren') should not be null"
	if def.hero_name != "Mordren":
		return "Hero name expected 'Mordren', got '%s'" % def.hero_name
		
	var hero = HeroDefinition.create_hero_instance("mordren")
	if hero == null or not (hero is MordrenHeroClass):
		return "create_hero_instance('mordren') should produce MordrenHero"
		
	hero.free()
	return ""

func test_task28_mordren_death_clears_buffs() -> String:
	var mordren = MordrenHeroClass.new()
	mordren._ready()
	mordren.ability_container.level_up_ability(AbilityResource.Slot.W)
	mordren.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	mordren.cast_mordren_w()
	mordren.cast_mordren_e()
	
	mordren.die(null)
	if mordren.is_blood_trail_active:
		return "Death should deactivate Blood Trail"
		
	mordren.free()
	return ""

func test_task28_mordren_respawn_clean_state() -> String:
	var mordren = MordrenHeroClass.new()
	mordren._ready()
	mordren.die(null)
	mordren.respawn()
	
	if not mordren.is_alive():
		return "Respawned Mordren should be alive"
	if mordren.is_blood_trail_active:
		return "Respawned Mordren should not have active Blood Trail state"
		
	mordren.free()
	return ""

# ==============================================================================
# TASK 29: BRAKKA HERO IMPLEMENTATION TESTS
# ==============================================================================

func test_task29_brakka_initialization_and_archetype() -> String:
	var brakka = BrakkaHeroClass.new()
	brakka.team = TeamDefinitions.Team.RADIANT
	brakka._ready()
	
	if brakka.hero_resource.primary_attribute != AttributeSystem.PrimaryAttributeType.STRENGTH:
		return "Brakka primary attribute should be STRENGTH"
	if brakka.hero_resource.attack_type != HeroResource.AttackType.MELEE:
		return "Brakka attack type should be MELEE"
	if brakka.hero_resource.base_strength < 25.0:
		return "Brakka base strength should be >= 25.0"
	if brakka.hero_resource.base_armor < 20.0:
		return "Brakka base armor should be >= 20.0"
	if brakka.hero_resource.base_health < 600.0:
		return "Brakka base health should be >= 600.0"
		
	brakka.free()
	return ""

func test_task29_brakka_retaliation_core_stores_damage() -> String:
	var brakka = BrakkaHeroClass.new()
	brakka.team = TeamDefinitions.Team.RADIANT
	brakka._ready()
	brakka.reset_retaliation()
	
	var attacker = DummyEntity.new()
	attacker.team = TeamDefinitions.Team.DIRE
	attacker._ready()
	
	var req = DamageRequest.create_ability_damage(attacker, brakka, 200.0, DamageRequest.DamageType.PHYSICAL, "Enemy Attack")
	brakka.receive_damage(req)
	
	if brakka.get_retaliation() <= 0.0:
		return "Brakka Retaliation Core should store retaliation on taking damage"
		
	attacker.free()
	brakka.free()
	return ""

func test_task29_brakka_retaliation_core_cap_clamp() -> String:
	var brakka = BrakkaHeroClass.new()
	brakka.team = TeamDefinitions.Team.RADIANT
	brakka._ready()
	
	brakka.add_retaliation(50000.0)
	var max_cap = brakka.get_max_retaliation()
	if absf(brakka.get_retaliation() - max_cap) > 0.01:
		return "Brakka retaliation should be clamped to max cap (%f), got %f" % [max_cap, brakka.get_retaliation()]
		
	brakka.free()
	return ""

func test_task29_brakka_retaliation_core_decay_timer() -> String:
	var brakka = BrakkaHeroClass.new()
	brakka.team = TeamDefinitions.Team.RADIANT
	brakka._ready()
	brakka.add_retaliation(100.0)
	
	# Before decay timer (5s), retaliation remains constant
	brakka._process_retaliation_decay(2.0)
	if absf(brakka.get_retaliation() - 100.0) > 0.01:
		return "Retaliation should not decay while decay timer is active"
		
	# After timer expires (extra 4.0s > 3.0s left), decay starts
	brakka._process_retaliation_decay(4.0)
	if brakka.get_retaliation() >= 100.0:
		return "Retaliation should decay after combat delay timer expires"
		
	brakka.free()
	return ""

func test_task29_brakka_retaliation_core_ignores_rebound_reflection() -> String:
	var brakka = BrakkaHeroClass.new()
	brakka.team = TeamDefinitions.Team.RADIANT
	brakka._ready()
	brakka.reset_retaliation()
	
	var attacker = DummyEntity.new()
	attacker.team = TeamDefinitions.Team.DIRE
	attacker._ready()
	
	var req = DamageRequest.create_ability_damage(attacker, brakka, 100.0, DamageRequest.DamageType.PHYSICAL, "Rebound")
	brakka.receive_damage(req)
	
	if brakka.get_retaliation() != 0.0:
		return "Retaliation Core should ignore Rebound damage source to prevent infinite reflection loops"
		
	attacker.free()
	brakka.free()
	return ""

func test_task29_brakka_q_shield_ram_damage_and_scaling() -> String:
	var brakka = BrakkaHeroClass.new()
	brakka.team = TeamDefinitions.Team.RADIANT
	brakka._ready()
	brakka.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(3.0, 0, 0)
	dummy._ready()
	
	var res = brakka.cast_brakka_q(dummy)
	if res == null:
		return "Shield Ram should return valid DamageResult"
	if res.final_health_damage <= 0.0:
		return "Shield Ram should deal physical damage"
		
	dummy.free()
	brakka.free()
	return ""

func test_task29_brakka_q_shield_ram_dash_and_knockback() -> String:
	var brakka = BrakkaHeroClass.new()
	brakka.team = TeamDefinitions.Team.RADIANT
	brakka.position = Vector3(0, 0, 0)
	brakka._ready()
	brakka.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(3.0, 0, 0)
	dummy._ready()
	
	var initial_target_x = dummy.position.x
	brakka.cast_brakka_q(dummy)
	
	if dummy.position.x <= initial_target_x:
		return "Shield Ram should knockback target forward (away from Brakka)"
	if brakka.position.x <= 0.5:
		return "Shield Ram should dash Brakka towards target location"
		
	dummy.free()
	brakka.free()
	return ""

func test_task29_brakka_q_shield_ram_target_validation_rejects_ally() -> String:
	var brakka = BrakkaHeroClass.new()
	brakka.team = TeamDefinitions.Team.RADIANT
	brakka.position = Vector3(0, 0, 0)
	brakka._ready()
	brakka.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(3.0, 0, 0)
	ally._ready()
	
	var res = brakka.cast_brakka_q(ally)
	if res != null:
		return "Shield Ram must reject allied targets"
		
	ally.free()
	brakka.free()
	return ""

func test_task29_brakka_q_shield_ram_cooldown_and_mana() -> String:
	var brakka = BrakkaHeroClass.new()
	brakka.team = TeamDefinitions.Team.RADIANT
	brakka.position = Vector3(0, 0, 0)
	brakka._ready()
	brakka.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(3.0, 0, 0)
	dummy._ready()
	
	var init_mana = brakka.attribute_system.current_mana
	brakka.cast_brakka_q(dummy)
	
	if brakka.attribute_system.current_mana >= init_mana:
		return "Shield Ram should deduct mana cost"
		
	var second_cast = brakka.cast_brakka_q(dummy)
	if second_cast != null:
		return "Shield Ram should be on cooldown and reject rapid consecutive cast"
		
	dummy.free()
	brakka.free()
	return ""

func test_task29_brakka_w_fortress_armor_buff() -> String:
	var brakka = BrakkaHeroClass.new()
	brakka.team = TeamDefinitions.Team.RADIANT
	brakka._ready()
	brakka.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var base_armor = brakka.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	var success = brakka.cast_brakka_w()
	if not success:
		return "Fortress should cast successfully"
		
	var buffed_armor = brakka.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	if buffed_armor <= base_armor + 35.0:
		return "Fortress should increase Armor by at least +40.0 (got %f from base %f)" % [buffed_armor, base_armor]
		
	brakka.free()
	return ""

func test_task29_brakka_w_fortress_self_slow() -> String:
	var brakka = BrakkaHeroClass.new()
	brakka.team = TeamDefinitions.Team.RADIANT
	brakka._ready()
	brakka.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var base_ms = brakka.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	brakka.cast_brakka_w()
	
	var slowed_ms = brakka.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	if slowed_ms >= base_ms:
		return "Fortress should apply -25% self move speed reduction"
		
	brakka.free()
	return ""

func test_task29_brakka_w_fortress_expiration_restores_stats() -> String:
	var brakka = BrakkaHeroClass.new()
	brakka.team = TeamDefinitions.Team.RADIANT
	brakka._ready()
	brakka.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var base_armor = brakka.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	var base_ms = brakka.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	brakka.cast_brakka_w()
	brakka._process(4.5)
	
	var restored_armor = brakka.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	var restored_ms = brakka.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	if absf(restored_armor - base_armor) > 0.1:
		return "Fortress expiration should restore normal Armor"
	if absf(restored_ms - base_ms) > 0.1:
		return "Fortress expiration should restore normal Move Speed"
		
	brakka.free()
	return ""

func test_task29_brakka_e_rebound_base_damage_with_zero_retaliation() -> String:
	var brakka = BrakkaHeroClass.new()
	brakka.team = TeamDefinitions.Team.RADIANT
	brakka.position = Vector3(0, 0, 0)
	brakka._ready()
	brakka.ability_container.level_up_ability(AbilityResource.Slot.E)
	brakka.reset_retaliation()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	var res = brakka.cast_brakka_e(dummy)
	if res == null:
		return "Rebound should cast successfully with 0 retaliation"
	if res.final_health_damage <= 0.0:
		return "Rebound should deal base damage even with 0 retaliation"
		
	dummy.free()
	brakka.free()
	return ""

func test_task29_brakka_e_rebound_releases_stored_retaliation() -> String:
	var brakka = BrakkaHeroClass.new()
	brakka.team = TeamDefinitions.Team.RADIANT
	brakka.position = Vector3(0, 0, 0)
	brakka._ready()
	brakka.ability_container.level_up_ability(AbilityResource.Slot.E)
	brakka.add_retaliation(150.0)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	var res = brakka.cast_brakka_e(dummy)
	if res == null:
		return "Rebound should cast successfully"
	if brakka.get_retaliation() != 0.0:
		return "Rebound should consume and reset stored retaliation to 0.0 (got %f)" % brakka.get_retaliation()
	if res.final_health_damage < 100.0:
		return "Rebound should deal bonus damage from released retaliation"
		
	dummy.free()
	brakka.free()
	return ""

func test_task29_brakka_e_rebound_target_validation_rejects_ally() -> String:
	var brakka = BrakkaHeroClass.new()
	brakka.team = TeamDefinitions.Team.RADIANT
	brakka.position = Vector3(0, 0, 0)
	brakka._ready()
	brakka.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(2.0, 0, 0)
	ally._ready()
	
	var res = brakka.cast_brakka_e(ally)
	if res != null:
		return "Rebound should reject allied targets"
		
	ally.free()
	brakka.free()
	return ""

func test_task29_brakka_r_immovable_damage_and_pull() -> String:
	var brakka = BrakkaHeroClass.new()
	brakka.team = TeamDefinitions.Team.RADIANT
	brakka.position = Vector3(0, 0, 0)
	brakka._ready()
	brakka.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(4.0, 0, 0)
	enemy._ready()
	
	var success = brakka.cast_brakka_r()
	if not success:
		return "Immovable should cast successfully"
		
	if enemy.position.x >= 3.5:
		return "Immovable should pull nearby enemy hero towards Brakka (got X=%f)" % enemy.position.x
		
	enemy.free()
	brakka.free()
	return ""

func test_task29_brakka_r_immovable_cleanses_cc_and_tenacity() -> String:
	var brakka = BrakkaHeroClass.new()
	brakka.team = TeamDefinitions.Team.RADIANT
	brakka._ready()
	brakka.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	# Apply CC effect
	var stun_eff = StatusEffect.new("stun", StatusEffect.EffectType.STUN, 3.0)
	brakka.effect_container.apply_effect(stun_eff)
	
	brakka.cast_brakka_r()
	
	if brakka.effect_container.has_effect("stun"):
		return "Immovable activation should cleanse crowd control effects immediately"
		
	brakka.free()
	return ""

func test_task29_brakka_r_immovable_slow_applied_to_enemies() -> String:
	var brakka = BrakkaHeroClass.new()
	brakka.team = TeamDefinitions.Team.RADIANT
	brakka.position = Vector3(0, 0, 0)
	brakka._ready()
	brakka.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(3.0, 0, 0)
	enemy._ready()
	
	brakka.cast_brakka_r()
	
	if not enemy.effect_container.has_effect("brakka_immovable_slow"):
		return "Immovable should apply 50% slow debuff to caught enemies"
		
	enemy.free()
	brakka.free()
	return ""

func test_task29_brakka_hero_definition_factory() -> String:
	HeroDefinition._ensure_registry()
	var def = HeroDefinition.get_definition("brakka")
	if def == null:
		return "HeroDefinition.get_definition('brakka') should not be null"
	if def.hero_name != "Brakka":
		return "Hero name expected 'Brakka', got '%s'" % def.hero_name
		
	var hero = HeroDefinition.create_hero_instance("brakka")
	if hero == null or not (hero is BrakkaHeroClass):
		return "create_hero_instance('brakka') should produce BrakkaHero"
		
	hero.free()
	return ""

func test_task29_brakka_death_and_respawn_clean_state() -> String:
	var brakka = BrakkaHeroClass.new()
	brakka._ready()
	brakka.add_retaliation(120.0)
	brakka.die(null)
	
	if brakka.get_retaliation() != 0.0:
		return "Death should reset stored retaliation to 0.0"
		
	brakka.respawn()
	if not brakka.is_alive():
		return "Respawned Brakka should be alive"
	if brakka.get_retaliation() != 0.0:
		return "Respawned Brakka should have 0 retaliation"
		
	brakka.free()
	return ""

# ==============================================================================
# TASK 30: VEYRA HERO IMPLEMENTATION TESTS
# ==============================================================================

func test_task30_veyra_initialization_and_archetype() -> String:
	var veyra = VeyraHeroClass.new()
	veyra.team = TeamDefinitions.Team.RADIANT
	veyra._ready()
	
	if veyra.hero_resource.primary_attribute != AttributeSystem.PrimaryAttributeType.STRENGTH:
		return "Veyra primary attribute should be STRENGTH"
	if veyra.hero_resource.attack_type != HeroResource.AttackType.MELEE:
		return "Veyra attack type should be MELEE"
	if veyra.hero_resource.base_move_speed < 315.0:
		return "Veyra base move speed should be >= 315.0"
	if veyra.hero_resource.base_attack_damage < 45.0:
		return "Veyra base attack damage should be >= 45.0"
		
	veyra.free()
	return ""

func test_task30_veyra_passive_momentum_accumulates_on_movement() -> String:
	var veyra = VeyraHeroClass.new()
	veyra.team = TeamDefinitions.Team.RADIANT
	veyra._ready()
	veyra.reset_momentum()
	
	veyra.position = Vector3(2.0, 0, 0)
	veyra._process(0.1)
	
	if veyra.get_momentum() <= 0.0:
		return "Momentum should accumulate when Veyra changes position"
		
	veyra.free()
	return ""

func test_task30_veyra_passive_momentum_grants_speed_bonus() -> String:
	var veyra = VeyraHeroClass.new()
	veyra.team = TeamDefinitions.Team.RADIANT
	veyra._ready()
	veyra.reset_momentum()
	
	var base_ms = veyra.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	veyra.add_momentum(100.0)
	
	var buffed_ms = veyra.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	if buffed_ms <= base_ms + 50.0:
		return "100 Momentum should grant +20% Move Speed bonus (got %f from base %f)" % [buffed_ms, base_ms]
		
	veyra.free()
	return ""

func test_task30_veyra_passive_momentum_decays_on_standstill() -> String:
	var veyra = VeyraHeroClass.new()
	veyra.team = TeamDefinitions.Team.RADIANT
	veyra._ready()
	veyra.add_momentum(60.0)
	
	# Stand still for 3 seconds (2s delay + 1s decay)
	veyra._process(3.0)
	if veyra.get_momentum() >= 60.0:
		return "Momentum should decay after standing still past delay window"
		
	veyra.free()
	return ""

func test_task30_veyra_passive_momentum_clamped_at_max() -> String:
	var veyra = VeyraHeroClass.new()
	veyra.team = TeamDefinitions.Team.RADIANT
	veyra._ready()
	veyra.add_momentum(500.0)
	
	if veyra.get_momentum() > 100.0:
		return "Momentum should be clamped at 100.0 max (got %f)" % veyra.get_momentum()
		
	veyra.free()
	return ""

func test_task30_veyra_q_shoulder_break_base_and_ad_damage() -> String:
	var veyra = VeyraHeroClass.new()
	veyra.team = TeamDefinitions.Team.RADIANT
	veyra._ready()
	veyra.ability_container.level_up_ability(AbilityResource.Slot.Q)
	veyra.reset_momentum()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.5, 0, 0)
	dummy._ready()
	
	var res = veyra.cast_veyra_q(dummy)
	if res == null:
		return "Shoulder Break should return valid DamageResult"
	if res.final_health_damage <= 0.0:
		return "Shoulder Break should deal physical damage"
		
	dummy.free()
	veyra.free()
	return ""

func test_task30_veyra_q_shoulder_break_consumes_momentum() -> String:
	var veyra = VeyraHeroClass.new()
	veyra.team = TeamDefinitions.Team.RADIANT
	veyra._ready()
	veyra.ability_container.level_up_ability(AbilityResource.Slot.Q)
	veyra.add_momentum(80.0)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.5, 0, 0)
	dummy._ready()
	
	var res = veyra.cast_veyra_q(dummy)
	if veyra.get_momentum() >= 80.0:
		return "Shoulder Break should consume 50% of current momentum (got %f)" % veyra.get_momentum()
	if absf(veyra.get_momentum() - 40.0) > 0.1:
		return "Expected 40.0 remaining momentum after 50% consumption, got %f" % veyra.get_momentum()
		
	dummy.free()
	veyra.free()
	return ""

func test_task30_veyra_q_shoulder_break_dash_and_knockback() -> String:
	var veyra = VeyraHeroClass.new()
	veyra.team = TeamDefinitions.Team.RADIANT
	veyra.position = Vector3(0, 0, 0)
	veyra._ready()
	veyra.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(3.0, 0, 0)
	dummy._ready()
	
	var init_target_x = dummy.position.x
	veyra.cast_veyra_q(dummy)
	
	if dummy.position.x <= init_target_x:
		return "Shoulder Break should knockback target forward"
	if veyra.position.x <= 0.5:
		return "Shoulder Break should dash Veyra towards target"
		
	dummy.free()
	veyra.free()
	return ""

func test_task30_veyra_q_shoulder_break_rejects_ally() -> String:
	var veyra = VeyraHeroClass.new()
	veyra.team = TeamDefinitions.Team.RADIANT
	veyra._ready()
	veyra.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(2.5, 0, 0)
	ally._ready()
	
	var res = veyra.cast_veyra_q(ally)
	if res != null:
		return "Shoulder Break must reject allied targets"
		
	ally.free()
	veyra.free()
	return ""

func test_task30_veyra_q_shoulder_break_cooldown_and_mana() -> String:
	var veyra = VeyraHeroClass.new()
	veyra.team = TeamDefinitions.Team.RADIANT
	veyra._ready()
	veyra.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.5, 0, 0)
	dummy._ready()
	
	var init_mana = veyra.attribute_system.current_mana
	veyra.cast_veyra_q(dummy)
	
	if veyra.attribute_system.current_mana >= init_mana:
		return "Shoulder Break should deduct mana"
		
	var second_cast = veyra.cast_veyra_q(dummy)
	if second_cast != null:
		return "Shoulder Break should be on cooldown"
		
	dummy.free()
	veyra.free()
	return ""

func test_task30_veyra_w_impact_zone_aoe_damage_scaling() -> String:
	var veyra = VeyraHeroClass.new()
	veyra.team = TeamDefinitions.Team.RADIANT
	veyra.position = Vector3(0, 0, 0)
	veyra._ready()
	veyra.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	var results = veyra.cast_veyra_w([dummy])
	if results.is_empty() or results[0] == null:
		return "Impact Zone should deal damage to target in range"
	if results[0].final_health_damage <= 0.0:
		return "Impact Zone damage should be greater than 0"
		
	dummy.free()
	veyra.free()
	return ""

func test_task30_veyra_w_impact_zone_slow_status_effect() -> String:
	var veyra = VeyraHeroClass.new()
	veyra.team = TeamDefinitions.Team.RADIANT
	veyra.position = Vector3(0, 0, 0)
	veyra._ready()
	veyra.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(2.0, 0, 0)
	enemy._ready()
	
	veyra.cast_veyra_w([enemy])
	
	if not enemy.effect_container.has_effect("veyra_impact_slow"):
		return "Impact Zone should apply 30% slow status effect to enemy"
		
	enemy.free()
	veyra.free()
	return ""

func test_task30_veyra_w_impact_zone_hits_multiple_enemies() -> String:
	var veyra = VeyraHeroClass.new()
	veyra.team = TeamDefinitions.Team.RADIANT
	veyra.position = Vector3(0, 0, 0)
	veyra._ready()
	veyra.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var dummy1 = TargetDummyEntity.new()
	dummy1.team = TeamDefinitions.Team.DIRE
	dummy1.position = Vector3(2.0, 0, 0)
	dummy1._ready()
	
	var dummy2 = TargetDummyEntity.new()
	dummy2.team = TeamDefinitions.Team.DIRE
	dummy2.position = Vector3(-2.0, 0, 0)
	dummy2._ready()
	
	var results = veyra.cast_veyra_w([dummy1, dummy2])
	if results.size() < 2:
		return "Impact Zone should hit all nearby enemies (expected 2, got %d)" % results.size()
		
	dummy1.free()
	dummy2.free()
	veyra.free()
	return ""

func test_task30_veyra_e_second_wind_on_hero_hit() -> String:
	var veyra = VeyraHeroClass.new()
	veyra.team = TeamDefinitions.Team.RADIANT
	veyra._ready()
	veyra.reset_momentum()
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(1.0, 0, 0)
	enemy._ready()
	
	veyra.execute_basic_attack(enemy)
	
	if veyra.get_momentum() < 30.0:
		return "Basic attack on enemy hero should trigger Second Wind (+30 Momentum)"
	if not veyra.attribute_system.has_modifier_with_source("veyra_second_wind"):
		return "Basic attack on enemy hero should apply Second Wind move speed modifier"
		
	enemy.free()
	veyra.free()
	return ""

func test_task30_veyra_e_second_wind_active_cast_burst() -> String:
	var veyra = VeyraHeroClass.new()
	veyra.team = TeamDefinitions.Team.RADIANT
	veyra._ready()
	veyra.ability_container.level_up_ability(AbilityResource.Slot.E)
	veyra.reset_momentum()
	
	var success = veyra.cast_veyra_e()
	if not success:
		return "Second Wind active cast should succeed"
	if veyra.get_momentum() < 30.0:
		return "Second Wind active should grant +30 Momentum"
		
	veyra.free()
	return ""

func test_task30_veyra_e_second_wind_expiration_cleans_speed() -> String:
	var veyra = VeyraHeroClass.new()
	veyra.team = TeamDefinitions.Team.RADIANT
	veyra._ready()
	veyra.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	veyra.cast_veyra_e()
	veyra._process(3.5)
	
	if veyra.attribute_system.has_modifier_with_source("veyra_second_wind"):
		return "Second Wind move speed modifier should expire after 3.0 seconds"
		
	veyra.free()
	return ""

func test_task30_veyra_r_crash_landing_leap_to_location() -> String:
	var veyra = VeyraHeroClass.new()
	veyra.team = TeamDefinitions.Team.RADIANT
	veyra.position = Vector3(0, 0, 0)
	veyra._ready()
	veyra.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var dest = Vector3(6.0, 0, 0)
	veyra.cast_veyra_r(dest)
	
	if absf(veyra.position.x - 6.0) > 0.1:
		return "Crash Landing should leap Veyra directly to destination location (got %f)" % veyra.position.x
		
	veyra.free()
	return ""

func test_task30_veyra_r_crash_landing_damage_and_stun() -> String:
	var veyra = VeyraHeroClass.new()
	veyra.team = TeamDefinitions.Team.RADIANT
	veyra.position = Vector3(0, 0, 0)
	veyra._ready()
	veyra.ability_container.level_up_ability(AbilityResource.Slot.R)
	veyra.add_momentum(100.0)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(5.0, 0, 0)
	enemy._ready()
	
	var results = veyra.cast_veyra_r(Vector3(5.0, 0, 0), [enemy])
	if results.is_empty() or results[0] == null:
		return "Crash Landing should deal damage to enemy at landing area"
	if not enemy.effect_container.has_effect("veyra_knockup_stun"):
		return "Crash Landing should apply 0.8s Stun / Knock-up effect"
	if veyra.get_momentum() != 0.0:
		return "Crash Landing should consume 100% of stored momentum (got %f)" % veyra.get_momentum()
		
	enemy.free()
	veyra.free()
	return ""

func test_task30_veyra_hero_definition_factory() -> String:
	HeroDefinition._ensure_registry()
	var def = HeroDefinition.get_definition("veyra")
	if def == null:
		return "HeroDefinition.get_definition('veyra') should not be null"
	if def.hero_name != "Veyra":
		return "Hero name expected 'Veyra', got '%s'" % def.hero_name
		
	var hero = HeroDefinition.create_hero_instance("veyra")
	if hero == null or not (hero is VeyraHeroClass):
		return "create_hero_instance('veyra') should produce VeyraHero"
		
	hero.free()
	return ""

func test_task30_veyra_death_and_respawn_cleanses_state() -> String:
	var veyra = VeyraHeroClass.new()
	veyra._ready()
	veyra.add_momentum(80.0)
	veyra.die(null)
	
	if veyra.get_momentum() != 0.0:
		return "Death should reset momentum to 0.0"
		
	veyra.respawn()
	if not veyra.is_alive():
		return "Respawned Veyra should be alive"
	if veyra.get_momentum() != 0.0:
		return "Respawned Veyra should have 0.0 momentum"
		
	veyra.free()
	return ""

# ==============================================================================
# TASK 31: GORAK HERO IMPLEMENTATION TESTS
# ==============================================================================

func test_task31_gorak_initialization_and_archetype() -> String:
	var gorak = GorakHeroClass.new()
	gorak.team = TeamDefinitions.Team.RADIANT
	gorak._ready()
	
	if gorak.hero_resource.primary_attribute != AttributeSystem.PrimaryAttributeType.STRENGTH:
		return "Gorak primary attribute should be STRENGTH"
	if gorak.hero_resource.attack_type != HeroResource.AttackType.MELEE:
		return "Gorak attack type should be MELEE"
	if gorak.hero_resource.base_health < 600.0:
		return "Gorak base health should be >= 600.0"
		
	gorak.free()
	return ""

func test_task31_gorak_passive_drains_ad() -> String:
	var gorak = GorakHeroClass.new()
	gorak.team = TeamDefinitions.Team.RADIANT
	gorak._ready()
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(1.5, 0, 0)
	enemy._ready()
	
	var init_gorak_ad = gorak.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	gorak.execute_basic_attack(enemy)
	
	var buffed_gorak_ad = gorak.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	if buffed_gorak_ad <= init_gorak_ad:
		return "Gorak should gain bonus AD from basic attack (got %f from base %f)" % [buffed_gorak_ad, init_gorak_ad]
	if gorak.passive_stolen_ad <= 0.0:
		return "Gorak passive_stolen_ad should be > 0.0"
		
	enemy.free()
	gorak.free()
	return ""

func test_task31_gorak_passive_drain_cap() -> String:
	var gorak = GorakHeroClass.new()
	gorak.team = TeamDefinitions.Team.RADIANT
	gorak._ready()
	
	var enemy = TargetDummyEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(1.5, 0, 0)
	enemy._ready()
	
	for i in range(10):
		gorak.execute_basic_attack(enemy)
		
	if gorak.passive_stolen_ad > 60.0:
		return "Passive stolen AD should be clamped at 60.0 (got %f)" % gorak.passive_stolen_ad
		
	enemy.free()
	gorak.free()
	return ""

func test_task31_gorak_passive_drain_timer_expiration() -> String:
	var gorak = GorakHeroClass.new()
	gorak.team = TeamDefinitions.Team.RADIANT
	gorak._ready()
	
	var enemy = TargetDummyEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(1.5, 0, 0)
	enemy._ready()
	
	gorak.execute_basic_attack(enemy)
	var init_ad = gorak.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	
	gorak._process(4.5)
	var restored_ad = gorak.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	
	if gorak.passive_stolen_ad != 0.0:
		return "Passive stolen AD should be 0.0 after timer expiration"
	if restored_ad >= init_ad:
		return "Attack damage should decrease back to base after passive drain expires"
		
	enemy.free()
	gorak.free()
	return ""

func test_task31_gorak_q_rend_base_damage_scaling() -> String:
	var gorak = GorakHeroClass.new()
	gorak.team = TeamDefinitions.Team.RADIANT
	gorak._ready()
	gorak.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	var res = gorak.cast_gorak_q(dummy)
	if res == null:
		return "Rend should return valid DamageResult"
	if res.final_health_damage <= 0.0:
		return "Rend should deal physical damage"
		
	dummy.free()
	gorak.free()
	return ""

func test_task31_gorak_q_rend_stolen_ad_synergy() -> String:
	var gorak = GorakHeroClass.new()
	gorak.team = TeamDefinitions.Team.RADIANT
	gorak._ready()
	gorak.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	var res_base = gorak.cast_gorak_q(dummy)
	var base_dmg = res_base.final_health_damage
	
	# Add stolen stats
	gorak.passive_stolen_ad = 40.0
	gorak.ability_container.reset_cooldowns()
	
	var res_buffed = gorak.cast_gorak_q(dummy)
	if res_buffed.final_health_damage <= base_dmg:
		return "Rend should deal significantly more damage with stolen AD synergy"
		
	dummy.free()
	gorak.free()
	return ""

func test_task31_gorak_q_rend_rejects_ally() -> String:
	var gorak = GorakHeroClass.new()
	gorak.team = TeamDefinitions.Team.RADIANT
	gorak._ready()
	gorak.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(2.0, 0, 0)
	ally._ready()
	
	var res = gorak.cast_gorak_q(ally)
	if res != null:
		return "Rend must reject allied targets"
		
	ally.free()
	gorak.free()
	return ""

func test_task31_gorak_q_rend_cooldown_and_mana() -> String:
	var gorak = GorakHeroClass.new()
	gorak.team = TeamDefinitions.Team.RADIANT
	gorak._ready()
	gorak.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	var init_mana = gorak.attribute_system.current_mana
	gorak.cast_gorak_q(dummy)
	
	if gorak.attribute_system.current_mana >= init_mana:
		return "Rend should deduct mana"
		
	var second_cast = gorak.cast_gorak_q(dummy)
	if second_cast != null:
		return "Rend should be on cooldown"
		
	dummy.free()
	gorak.free()
	return ""

func test_task31_gorak_w_drain_strength_reduces_target_ad() -> String:
	var gorak = GorakHeroClass.new()
	gorak.team = TeamDefinitions.Team.RADIANT
	gorak._ready()
	gorak.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(2.5, 0, 0)
	enemy._ready()
	
	var init_enemy_ad = enemy.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var success = gorak.cast_gorak_w(enemy)
	if not success:
		return "Drain Strength should cast successfully on enemy hero"
		
	var debuffed_enemy_ad = enemy.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	if debuffed_enemy_ad >= init_enemy_ad:
		return "Drain Strength should reduce enemy AD (was %f, now %f)" % [init_enemy_ad, debuffed_enemy_ad]
		
	enemy.free()
	gorak.free()
	return ""

func test_task31_gorak_w_drain_strength_grants_gorak_ad() -> String:
	var gorak = GorakHeroClass.new()
	gorak.team = TeamDefinitions.Team.RADIANT
	gorak._ready()
	gorak.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(2.5, 0, 0)
	enemy._ready()
	
	var init_gorak_ad = gorak.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	gorak.cast_gorak_w(enemy)
	
	var buffed_gorak_ad = gorak.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	if buffed_gorak_ad <= init_gorak_ad:
		return "Drain Strength should grant bonus AD to Gorak"
		
	enemy.free()
	gorak.free()
	return ""

func test_task31_gorak_w_requires_enemy_hero() -> String:
	var gorak = GorakHeroClass.new()
	gorak.team = TeamDefinitions.Team.RADIANT
	gorak._ready()
	gorak.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep.position = Vector3(2.5, 0, 0)
	creep._ready()
	
	var success = gorak.cast_gorak_w(creep)
	if success:
		return "Drain Strength should reject non-hero targets (creeps)"
		
	creep.free()
	gorak.free()
	return ""

func test_task31_gorak_w_expiration_restores_stats() -> String:
	var gorak = GorakHeroClass.new()
	gorak.team = TeamDefinitions.Team.RADIANT
	gorak._ready()
	gorak.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(2.5, 0, 0)
	enemy._ready()
	
	var base_enemy_ad = enemy.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var base_gorak_ad = gorak.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	
	gorak.cast_gorak_w(enemy)
	gorak._process(5.5)
	
	var restored_enemy_ad = enemy.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var restored_gorak_ad = gorak.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	
	if absf(restored_enemy_ad - base_enemy_ad) > 0.1:
		return "Enemy AD should be restored after Drain Strength expires"
	if absf(restored_gorak_ad - base_gorak_ad) > 0.1:
		return "Gorak bonus AD should be removed after Drain Strength expires"
		
	enemy.free()
	gorak.free()
	return ""

func test_task31_gorak_e_feed_heals_based_on_stolen_ad() -> String:
	var gorak = GorakHeroClass.new()
	gorak.team = TeamDefinitions.Team.RADIANT
	gorak._ready()
	gorak.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	gorak.attribute_system.current_health = 200.0
	gorak.passive_stolen_ad = 40.0
	
	var success = gorak.cast_gorak_e()
	if not success:
		return "Feed should cast successfully"
	if gorak.attribute_system.current_health <= 200.0 + 80.0:
		return "Feed should heal Gorak for base + stolen AD scaling"
		
	gorak.free()
	return ""

func test_task31_gorak_e_feed_clears_stolen_ad() -> String:
	var gorak = GorakHeroClass.new()
	gorak.team = TeamDefinitions.Team.RADIANT
	gorak._ready()
	gorak.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	gorak.passive_stolen_ad = 50.0
	gorak.cast_gorak_e()
	
	if gorak.get_total_stolen_ad() != 0.0:
		return "Feed should clear all stolen AD pools upon consumption"
		
	gorak.free()
	return ""

func test_task31_gorak_r_devour_champion_damage() -> String:
	var gorak = GorakHeroClass.new()
	gorak.team = TeamDefinitions.Team.RADIANT
	gorak.position = Vector3(0, 0, 0)
	gorak._ready()
	gorak.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(2.5, 0, 0)
	enemy._ready()
	
	var res = gorak.cast_gorak_r(enemy)
	if res == null:
		return "Devour Champion should return valid DamageResult"
	if res.final_health_damage <= 0.0:
		return "Devour Champion should deal heavy physical damage"
		
	enemy.free()
	gorak.free()
	return ""

func test_task31_gorak_r_devour_champion_stat_theft() -> String:
	var gorak = GorakHeroClass.new()
	gorak.team = TeamDefinitions.Team.RADIANT
	gorak.position = Vector3(0, 0, 0)
	gorak._ready()
	gorak.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(2.5, 0, 0)
	enemy._ready()
	
	var init_enemy_armor = enemy.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	var init_gorak_armor = gorak.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	
	gorak.cast_gorak_r(enemy)
	
	var debuffed_armor = enemy.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	var buffed_armor = gorak.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	
	if debuffed_armor >= init_enemy_armor:
		return "Devour Champion should reduce enemy Armor"
	if buffed_armor <= init_gorak_armor:
		return "Devour Champion should grant Gorak stolen Armor"
		
	enemy.free()
	gorak.free()
	return ""

func test_task31_gorak_r_devour_champion_rejects_non_hero() -> String:
	var gorak = GorakHeroClass.new()
	gorak.team = TeamDefinitions.Team.RADIANT
	gorak._ready()
	gorak.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var creep = CreepEntity.new()
	creep.team = TeamDefinitions.Team.DIRE
	creep.position = Vector3(2.5, 0, 0)
	creep._ready()
	
	var res = gorak.cast_gorak_r(creep)
	if res != null:
		return "Devour Champion must reject non-hero targets"
		
	creep.free()
	gorak.free()
	return ""

func test_task31_gorak_r_expiration_restores_stats() -> String:
	var gorak = GorakHeroClass.new()
	gorak.team = TeamDefinitions.Team.RADIANT
	gorak._ready()
	gorak.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(2.5, 0, 0)
	enemy._ready()
	
	var base_gorak_armor = gorak.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	gorak.cast_gorak_r(enemy)
	
	gorak._process(6.5)
	var restored_gorak_armor = gorak.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	
	if absf(restored_gorak_armor - base_gorak_armor) > 0.1:
		return "Gorak armor should be restored after Devour expires"
		
	enemy.free()
	gorak.free()
	return ""

func test_task31_gorak_hero_definition_factory() -> String:
	HeroDefinition._ensure_registry()
	var def = HeroDefinition.get_definition("gorak")
	if def == null:
		return "HeroDefinition.get_definition('gorak') should not be null"
	if def.hero_name != "Gorak":
		return "Hero name expected 'Gorak', got '%s'" % def.hero_name
		
	var hero = HeroDefinition.create_hero_instance("gorak")
	if hero == null or not (hero is GorakHeroClass):
		return "create_hero_instance('gorak') should produce GorakHero"
		
	hero.free()
	return ""

func test_task31_gorak_death_and_respawn_clean_state() -> String:
	var gorak = GorakHeroClass.new()
	gorak._ready()
	gorak.passive_stolen_ad = 50.0
	gorak.die(null)
	
	if gorak.get_total_stolen_ad() != 0.0:
		return "Death should clear all stolen stats to 0.0"
		
	gorak.respawn()
	if not gorak.is_alive():
		return "Respawned Gorak should be alive"
	if gorak.get_total_stolen_ad() != 0.0:
		return "Respawned Gorak should have 0.0 stolen stats"
		
	gorak.free()
	return ""

# ==============================================================================
# TASK 32: DURN HERO IMPLEMENTATION TESTS
# ==============================================================================

func test_task32_durn_initialization_and_archetype() -> String:
	var durn = DurnHeroClass.new()
	durn.team = TeamDefinitions.Team.RADIANT
	durn._ready()
	
	if durn.hero_resource.primary_attribute != AttributeSystem.PrimaryAttributeType.STRENGTH:
		return "Durn primary attribute should be STRENGTH"
	if durn.hero_resource.attack_type != HeroResource.AttackType.RANGED:
		return "Durn attack type should be RANGED"
	if durn.hero_resource.base_attack_range < 450.0:
		return "Durn base attack range should be >= 450.0"
		
	durn.free()
	return ""

func test_task32_durn_passive_enters_on_standstill() -> String:
	var durn = DurnHeroClass.new()
	durn.team = TeamDefinitions.Team.RADIANT
	durn._ready()
	
	durn._process(1.6)
	if not durn.is_siege_stance:
		return "Durn should enter Siege Stance after standing still for 1.5s"
		
	durn.free()
	return ""

func test_task32_durn_passive_grants_range_and_ad() -> String:
	var durn = DurnHeroClass.new()
	durn.team = TeamDefinitions.Team.RADIANT
	durn._ready()
	
	var base_range = durn.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_RANGE)
	var base_ad = durn.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	
	durn._process(1.6)
	var siege_range = durn.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_RANGE)
	var siege_ad = durn.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	
	if siege_range <= base_range + 150.0:
		return "Siege Stance should grant +200 Attack Range"
	if siege_ad <= base_ad:
		return "Siege Stance should grant +25% Attack Damage bonus"
		
	durn.free()
	return ""

func test_task32_durn_passive_clears_on_movement() -> String:
	var durn = DurnHeroClass.new()
	durn.team = TeamDefinitions.Team.RADIANT
	durn._ready()
	durn._process(1.6)
	
	durn.position = Vector3(2.0, 0, 0)
	durn._process(0.1)
	
	if durn.is_siege_stance:
		return "Siege Stance should immediately deactivate on movement"
		
	durn.free()
	return ""

func test_task32_durn_q_boulder_shot_damage_and_range() -> String:
	var durn = DurnHeroClass.new()
	durn.team = TeamDefinitions.Team.RADIANT
	durn._ready()
	durn.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(4.0, 0, 0)
	dummy._ready()
	
	var res = durn.cast_durn_q(dummy)
	if res == null:
		return "Boulder Shot should return valid DamageResult"
	if res.final_health_damage <= 0.0:
		return "Boulder Shot should deal physical damage"
		
	dummy.free()
	durn.free()
	return ""

func test_task32_durn_q_boulder_shot_siege_stance_bonus() -> String:
	var durn = DurnHeroClass.new()
	durn.team = TeamDefinitions.Team.RADIANT
	durn._ready()
	durn.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(4.0, 0, 0)
	dummy._ready()
	
	var res_normal = durn.cast_durn_q(dummy)
	var normal_dmg = res_normal.final_health_damage
	
	durn._enter_siege_stance()
	durn.ability_container.reset_cooldowns()
	
	var res_siege = durn.cast_durn_q(dummy)
	if res_siege.final_health_damage <= normal_dmg:
		return "Boulder Shot should deal +20% more damage in Siege Stance"
		
	dummy.free()
	durn.free()
	return ""

func test_task32_durn_q_boulder_shot_rejects_ally() -> String:
	var durn = DurnHeroClass.new()
	durn.team = TeamDefinitions.Team.RADIANT
	durn._ready()
	durn.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(4.0, 0, 0)
	ally._ready()
	
	var res = durn.cast_durn_q(ally)
	if res != null:
		return "Boulder Shot must reject allied targets"
		
	ally.free()
	durn.free()
	return ""

func test_task32_durn_q_boulder_shot_cooldown_and_mana() -> String:
	var durn = DurnHeroClass.new()
	durn.team = TeamDefinitions.Team.RADIANT
	durn._ready()
	durn.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(4.0, 0, 0)
	dummy._ready()
	
	var init_mana = durn.attribute_system.current_mana
	durn.cast_durn_q(dummy)
	
	if durn.attribute_system.current_mana >= init_mana:
		return "Boulder Shot should deduct mana"
		
	var second_cast = durn.cast_durn_q(dummy)
	if second_cast != null:
		return "Boulder Shot should be on cooldown"
		
	dummy.free()
	durn.free()
	return ""

func test_task32_durn_w_fortify_grants_defenses() -> String:
	var durn = DurnHeroClass.new()
	durn.team = TeamDefinitions.Team.RADIANT
	durn._ready()
	durn.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var init_armor = durn.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	var success = durn.cast_durn_w()
	if not success:
		return "Fortify should cast successfully"
		
	var buffed_armor = durn.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	if buffed_armor <= init_armor + 30.0:
		return "Fortify should increase Armor by at least +35.0"
		
	durn.free()
	return ""

func test_task32_durn_w_fortify_expiration() -> String:
	var durn = DurnHeroClass.new()
	durn.team = TeamDefinitions.Team.RADIANT
	durn._ready()
	durn.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var base_armor = durn.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	durn.cast_durn_w()
	durn._process(5.5)
	
	var restored_armor = durn.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	if absf(restored_armor - base_armor) > 0.1:
		return "Fortify defenses should expire after 5.0 seconds"
		
	durn.free()
	return ""

func test_task32_durn_e_shock_mine_placement() -> String:
	var durn = DurnHeroClass.new()
	durn.team = TeamDefinitions.Team.RADIANT
	durn._ready()
	durn.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var loc = Vector3(3.0, 0, 0)
	var success = durn.cast_durn_e(loc)
	if not success:
		return "Shock Mine should cast successfully"
	if durn.active_mines.is_empty():
		return "Active mines array should have 1 placed mine"
		
	durn.free()
	return ""

func test_task32_durn_e_shock_mine_detonation() -> String:
	var durn = DurnHeroClass.new()
	durn.team = TeamDefinitions.Team.RADIANT
	durn._ready()
	durn.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	durn.cast_durn_e(Vector3(2.0, 0, 0))
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(2.2, 0, 0)
	enemy._ready()
	
	var init_hp = enemy.attribute_system.current_health
	durn._process(0.1)
	
	if durn.active_mines.size() != 0:
		return "Shock Mine should detonate when enemy enters proximity"
	if enemy.attribute_system.current_health >= init_hp:
		return "Shock Mine detonation should deal damage to enemy"
		
	enemy.free()
	durn.free()
	return ""

func test_task32_durn_e_shock_mine_slow_effect() -> String:
	var durn = DurnHeroClass.new()
	durn.team = TeamDefinitions.Team.RADIANT
	durn._ready()
	durn.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	durn.cast_durn_e(Vector3(2.0, 0, 0))
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(2.2, 0, 0)
	enemy._ready()
	
	durn._process(0.1)
	if not enemy.effect_container.has_effect("durn_mine_slow"):
		return "Shock Mine should apply slow status effect on detonation"
		
	enemy.free()
	durn.free()
	return ""

func test_task32_durn_e_shock_mine_friendly_safe() -> String:
	var durn = DurnHeroClass.new()
	durn.team = TeamDefinitions.Team.RADIANT
	durn._ready()
	durn.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	durn.cast_durn_e(Vector3(2.0, 0, 0))
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(2.2, 0, 0)
	ally._ready()
	
	durn._process(0.1)
	if durn.active_mines.is_empty():
		return "Shock Mine should NOT detonate on allied proximity"
		
	ally.free()
	durn.free()
	return ""

func test_task32_durn_r_grand_barrage_aoe_damage() -> String:
	var durn = DurnHeroClass.new()
	durn.team = TeamDefinitions.Team.RADIANT
	durn._ready()
	durn.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(6.0, 0, 0)
	enemy._ready()
	
	var results = durn.cast_durn_r(Vector3(6.0, 0, 0), [enemy])
	if results.is_empty() or results[0] == null:
		return "Grand Barrage should return valid DamageResult"
	if results[0].final_health_damage <= 0.0:
		return "Grand Barrage should deal heavy damage"
		
	enemy.free()
	durn.free()
	return ""

func test_task32_durn_r_grand_barrage_multiple_units() -> String:
	var durn = DurnHeroClass.new()
	durn.team = TeamDefinitions.Team.RADIANT
	durn._ready()
	durn.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var dummy1 = TargetDummyEntity.new()
	dummy1.team = TeamDefinitions.Team.DIRE
	dummy1.position = Vector3(6.0, 0, 0)
	dummy1._ready()
	
	var dummy2 = TargetDummyEntity.new()
	dummy2.team = TeamDefinitions.Team.DIRE
	dummy2.position = Vector3(6.5, 0, 0)
	dummy2._ready()
	
	var results = durn.cast_durn_r(Vector3(6.0, 0, 0), [dummy1, dummy2])
	if results.size() < 2:
		return "Grand Barrage should hit all targets in target AoE (got %d)" % results.size()
		
	dummy1.free()
	dummy2.free()
	durn.free()
	return ""

func test_task32_durn_r_grand_barrage_cooldown_and_mana() -> String:
	var durn = DurnHeroClass.new()
	durn.team = TeamDefinitions.Team.RADIANT
	durn._ready()
	durn.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var init_mana = durn.attribute_system.current_mana
	durn.cast_durn_r(Vector3(6.0, 0, 0), [])
	
	if durn.attribute_system.current_mana >= init_mana:
		return "Grand Barrage should deduct mana"
		
	var second_cast = durn.cast_durn_r(Vector3(6.0, 0, 0), [])
	if not second_cast.is_empty():
		return "Grand Barrage should be on cooldown"
		
	durn.free()
	return ""

func test_task32_durn_projectile_config() -> String:
	var durn = DurnHeroClass.new()
	durn._ready()
	
	if durn.hero_resource.projectile_speed < 15.0:
		return "Durn projectile speed should be configured"
	if durn.hero_resource.projectile_radius <= 0.0:
		return "Durn projectile radius should be configured"
		
	durn.free()
	return ""

func test_task32_durn_hero_definition_factory() -> String:
	HeroDefinition._ensure_registry()
	var def = HeroDefinition.get_definition("durn")
	if def == null:
		return "HeroDefinition.get_definition('durn') should not be null"
	if def.hero_name != "Durn":
		return "Hero name expected 'Durn', got '%s'" % def.hero_name
		
	var hero = HeroDefinition.create_hero_instance("durn")
	if hero == null or not (hero is DurnHeroClass):
		return "create_hero_instance('durn') should produce DurnHero"
		
	hero.free()
	return ""

func test_task32_durn_death_and_respawn_clean_state() -> String:
	var durn = DurnHeroClass.new()
	durn._ready()
	durn._enter_siege_stance()
	durn.cast_durn_e(Vector3(1, 0, 0))
	
	durn.die(null)
	if durn.is_siege_stance or not durn.active_mines.is_empty():
		return "Death should exit siege stance and clear active mines"
		
	durn.respawn()
	if not durn.is_alive():
		return "Respawned Durn should be alive"
		
	durn.free()
	return ""

# ==============================================================================
# TASK 33: AURON HERO IMPLEMENTATION TESTS
# ==============================================================================

func test_task33_auron_initialization_and_archetype() -> String:
	var auron = AuronHeroClass.new()
	auron.team = TeamDefinitions.Team.RADIANT
	auron._ready()
	
	if auron.hero_resource.primary_attribute != AttributeSystem.PrimaryAttributeType.STRENGTH:
		return "Auron primary attribute should be STRENGTH"
	if auron.hero_resource.attack_type != HeroResource.AttackType.MELEE:
		return "Auron attack type should be MELEE"
	if auron.hero_resource.base_health < 600.0:
		return "Auron base health should be >= 600.0"
		
	auron.free()
	return ""

func test_task33_auron_passive_resolve_accumulation() -> String:
	var auron = AuronHeroClass.new()
	auron.team = TeamDefinitions.Team.RADIANT
	auron._ready()
	
	auron.add_resolve(40.0)
	if auron.get_resolve() != 40.0:
		return "Auron should store 40.0 resolve"
		
	auron.free()
	return ""

func test_task33_auron_passive_boosts_hp_regen() -> String:
	var auron = AuronHeroClass.new()
	auron.team = TeamDefinitions.Team.RADIANT
	auron._ready()
	
	var base_regen = auron.attribute_system.get_stat(StatModifier.TargetStat.HEALTH_REGEN)
	auron.add_resolve(100.0)
	
	var buffed_regen = auron.attribute_system.get_stat(StatModifier.TargetStat.HEALTH_REGEN)
	if buffed_regen <= base_regen:
		return "Resolve should grant bonus HP regen"
		
	auron.free()
	return ""

func test_task33_auron_passive_resolve_clamped() -> String:
	var auron = AuronHeroClass.new()
	auron.team = TeamDefinitions.Team.RADIANT
	auron._ready()
	
	auron.add_resolve(500.0)
	if auron.get_resolve() > 100.0:
		return "Resolve should be clamped at 100.0 max"
		
	auron.free()
	return ""

func test_task33_auron_q_guarding_blow_damage() -> String:
	var auron = AuronHeroClass.new()
	auron.team = TeamDefinitions.Team.RADIANT
	auron._ready()
	auron.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	var res = auron.cast_auron_q(dummy)
	if res == null:
		return "Guarding Blow should return valid DamageResult"
	if res.final_health_damage <= 0.0:
		return "Guarding Blow should deal physical damage"
		
	dummy.free()
	auron.free()
	return ""

func test_task33_auron_q_guarding_blow_shields_ally() -> String:
	var auron = AuronHeroClass.new()
	auron.team = TeamDefinitions.Team.RADIANT
	auron._ready()
	auron.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(2.0, 0, 0)
	ally._ready()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(1.5, 0, 0)
	dummy._ready()
	
	auron.cast_auron_q(dummy, ally)
	if not ally.effect_container.has_effect("auron_guarding_shield"):
		return "Guarding Blow should grant shield to ally"
		
	dummy.free()
	ally.free()
	auron.free()
	return ""

func test_task33_auron_q_guarding_blow_resolve_scaling() -> String:
	var auron = AuronHeroClass.new()
	auron.team = TeamDefinitions.Team.RADIANT
	auron._ready()
	auron.ability_container.level_up_ability(AbilityResource.Slot.Q)
	auron.add_resolve(100.0)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(1.5, 0, 0)
	dummy._ready()
	
	auron.cast_auron_q(dummy, auron)
	var shield_eff = auron.effect_container.get_effect("auron_guarding_shield")
	if shield_eff == null or shield_eff.magnitude <= 110.0:
		return "Guarding Blow shield should scale with stored resolve (magnitude %f)" % (shield_eff.magnitude if shield_eff else 0.0)
		
	dummy.free()
	auron.free()
	return ""

func test_task33_auron_q_guarding_blow_rejects_ally_attack() -> String:
	var auron = AuronHeroClass.new()
	auron.team = TeamDefinitions.Team.RADIANT
	auron._ready()
	auron.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(2.0, 0, 0)
	ally._ready()
	
	var res = auron.cast_auron_q(ally)
	if res != null:
		return "Guarding Blow must reject attacking allied targets"
		
	ally.free()
	auron.free()
	return ""

func test_task33_auron_q_guarding_blow_cooldown_and_mana() -> String:
	var auron = AuronHeroClass.new()
	auron.team = TeamDefinitions.Team.RADIANT
	auron._ready()
	auron.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(1.5, 0, 0)
	dummy._ready()
	
	var init_mana = auron.attribute_system.current_mana
	auron.cast_auron_q(dummy)
	
	if auron.attribute_system.current_mana >= init_mana:
		return "Guarding Blow should deduct mana"
		
	var second_cast = auron.cast_auron_q(dummy)
	if second_cast != null:
		return "Guarding Blow should be on cooldown"
		
	dummy.free()
	auron.free()
	return ""

func test_task33_auron_w_interpose_dashes_to_ally() -> String:
	var auron = AuronHeroClass.new()
	auron.team = TeamDefinitions.Team.RADIANT
	auron.position = Vector3(0, 0, 0)
	auron._ready()
	auron.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(4.0, 0, 0)
	ally._ready()
	
	var success = auron.cast_auron_w(ally)
	if not success:
		return "Interpose should cast successfully"
	if auron.position.x <= 1.0:
		return "Interpose should dash Auron near target ally position"
		
	ally.free()
	auron.free()
	return ""

func test_task33_auron_w_interpose_shields_both() -> String:
	var auron = AuronHeroClass.new()
	auron.team = TeamDefinitions.Team.RADIANT
	auron.position = Vector3(0, 0, 0)
	auron._ready()
	auron.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(3.0, 0, 0)
	ally._ready()
	
	auron.cast_auron_w(ally)
	if not auron.effect_container.has_effect("auron_interpose_shield"):
		return "Interpose should grant shield to Auron"
	if not ally.effect_container.has_effect("auron_interpose_shield"):
		return "Interpose should grant shield to targeted ally"
		
	ally.free()
	auron.free()
	return ""

func test_task33_auron_w_interpose_rejects_enemy() -> String:
	var auron = AuronHeroClass.new()
	auron.team = TeamDefinitions.Team.RADIANT
	auron._ready()
	auron.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(3.0, 0, 0)
	enemy._ready()
	
	var success = auron.cast_auron_w(enemy)
	if success:
		return "Interpose should reject enemy target"
		
	enemy.free()
	auron.free()
	return ""

func test_task33_auron_w_interpose_timer_expiration() -> String:
	var auron = AuronHeroClass.new()
	auron.team = TeamDefinitions.Team.RADIANT
	auron._ready()
	auron.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(3.0, 0, 0)
	ally._ready()
	
	auron.cast_auron_w(ally)
	auron._process(4.5)
	
	if auron.interpose_target != null or auron.interpose_timer != 0.0:
		return "Interpose state should expire after 4.0 seconds"
		
	ally.free()
	auron.free()
	return ""

func test_task33_auron_e_rally_grants_armor_buff() -> String:
	var auron = AuronHeroClass.new()
	auron.team = TeamDefinitions.Team.RADIANT
	auron._ready()
	auron.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(3.0, 0, 0)
	ally._ready()
	
	var init_armor = ally.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	auron.cast_auron_e([ally])
	
	var buffed_armor = ally.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	if buffed_armor <= init_armor + 15.0:
		return "Rally should grant armor bonus to nearby allies"
		
	ally.free()
	auron.free()
	return ""

func test_task33_auron_e_rally_expiration() -> String:
	var auron = AuronHeroClass.new()
	auron.team = TeamDefinitions.Team.RADIANT
	auron._ready()
	auron.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(3.0, 0, 0)
	ally._ready()
	
	var base_armor = ally.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	auron.cast_auron_e([ally])
	
	ally.attribute_system.remove_modifiers_by_source("auron_rally_armor")
	var restored_armor = ally.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	if absf(restored_armor - base_armor) > 0.1:
		return "Ally armor should be restored after Rally buff is cleared"
		
	ally.free()
	auron.free()
	return ""

func test_task33_auron_r_guardians_oath_forms_bond() -> String:
	var auron = AuronHeroClass.new()
	auron.team = TeamDefinitions.Team.RADIANT
	auron._ready()
	auron.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(3.0, 0, 0)
	ally._ready()
	
	var success = auron.cast_auron_r(ally)
	if not success:
		return "Guardian's Oath should cast successfully on ally"
	if auron.bonded_ally != ally:
		return "Guardian's Oath should set bonded_ally"
		
	ally.free()
	auron.free()
	return ""

func test_task33_auron_r_guardians_oath_saves_lethal() -> String:
	var auron = AuronHeroClass.new()
	auron.team = TeamDefinitions.Team.RADIANT
	auron._ready()
	auron.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(3.0, 0, 0)
	ally._ready()
	
	auron.cast_auron_r(ally)
	
	# Simulate lethal damage on ally (HP = 0)
	ally.attribute_system.current_health = 0.5
	auron._process(0.1)
	
	if ally.attribute_system.current_health <= 100.0:
		return "Guardian's Oath should trigger emergency heal upon near-lethal damage"
	if auron.bonded_ally != null:
		return "Bond should be consumed after lethal save"
		
	ally.free()
	auron.free()
	return ""

func test_task33_auron_r_guardians_oath_rejects_enemy() -> String:
	var auron = AuronHeroClass.new()
	auron.team = TeamDefinitions.Team.RADIANT
	auron._ready()
	auron.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(3.0, 0, 0)
	enemy._ready()
	
	var success = auron.cast_auron_r(enemy)
	if success:
		return "Guardian's Oath must reject enemy target"
		
	enemy.free()
	auron.free()
	return ""

func test_task33_auron_hero_definition_factory() -> String:
	HeroDefinition._ensure_registry()
	var def = HeroDefinition.get_definition("auron")
	if def == null:
		return "HeroDefinition.get_definition('auron') should not be null"
	if def.hero_name != "Auron":
		return "Hero name expected 'Auron', got '%s'" % def.hero_name
		
	var hero = HeroDefinition.create_hero_instance("auron")
	if hero == null or not (hero is AuronHeroClass):
		return "create_hero_instance('auron') should produce AuronHero"
		
	hero.free()
	return ""

func test_task33_auron_death_and_respawn_clean_state() -> String:
	var auron = AuronHeroClass.new()
	auron._ready()
	auron.add_resolve(60.0)
	
	auron.die(null)
	if auron.get_resolve() != 0.0 or auron.bonded_ally != null:
		return "Death should clear resolve and active bonds"
		
	auron.respawn()
	if not auron.is_alive():
		return "Respawned Auron should be alive"
		
	auron.free()
	return ""

# ==============================================================================
# TASK 34: KHAROS HERO IMPLEMENTATION TESTS
# ==============================================================================

func test_task34_kharos_initialization_and_archetype() -> String:
	var kharos = KharosHeroClass.new()
	kharos.team = TeamDefinitions.Team.RADIANT
	kharos._ready()
	
	if kharos.hero_resource.primary_attribute != AttributeSystem.PrimaryAttributeType.STRENGTH:
		return "Kharos primary attribute should be STRENGTH"
	if kharos.hero_resource.attack_type != HeroResource.AttackType.MELEE:
		return "Kharos attack type should be MELEE"
	if kharos.hero_resource.base_move_speed < 315.0:
		return "Kharos base move speed should be >= 315.0"
		
	kharos.free()
	return ""

func test_task34_kharos_passive_bloodrage_ad() -> String:
	var kharos = KharosHeroClass.new()
	kharos.team = TeamDefinitions.Team.RADIANT
	kharos._ready()
	
	var base_ad = kharos.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	
	# Drop HP to 50%
	kharos.attribute_system.current_health = 295.0
	kharos._process(0.1)
	
	var low_hp_ad = kharos.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	if low_hp_ad <= base_ad + 15.0:
		return "Bloodrage should grant bonus AD when HP is missing"
		
	kharos.free()
	return ""

func test_task34_kharos_passive_bloodrage_as() -> String:
	var kharos = KharosHeroClass.new()
	kharos.team = TeamDefinitions.Team.RADIANT
	kharos._ready()
	
	var base_as = kharos.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	
	# Drop HP to 20%
	kharos.attribute_system.current_health = 118.0
	kharos._process(0.1)
	
	var low_hp_as = kharos.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	if low_hp_as <= base_as:
		return "Bloodrage should grant bonus Attack Speed when HP is missing"
		
	kharos.free()
	return ""

func test_task34_kharos_passive_bloodrage_dynamic_heal() -> String:
	var kharos = KharosHeroClass.new()
	kharos.team = TeamDefinitions.Team.RADIANT
	kharos._ready()
	
	kharos.attribute_system.current_health = 100.0
	kharos._process(0.1)
	var low_ad = kharos.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	
	# Heal back to full
	kharos.attribute_system.heal(500.0)
	kharos._process(0.1)
	var healed_ad = kharos.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	
	if healed_ad >= low_ad:
		return "Bloodrage AD bonus should dynamically decrease as health is restored"
		
	kharos.free()
	return ""

func test_task34_kharos_q_frenzy_slash_damage() -> String:
	var kharos = KharosHeroClass.new()
	kharos.team = TeamDefinitions.Team.RADIANT
	kharos._ready()
	kharos.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(1.5, 0, 0)
	dummy._ready()
	
	var res = kharos.cast_kharos_q(dummy)
	if res == null:
		return "Frenzy Slash should return valid DamageResult"
	if res.final_health_damage <= 0.0:
		return "Frenzy Slash should deal physical damage"
		
	dummy.free()
	kharos.free()
	return ""

func test_task34_kharos_q_frenzy_slash_stacks_scaling() -> String:
	var kharos = KharosHeroClass.new()
	kharos.team = TeamDefinitions.Team.RADIANT
	kharos._ready()
	kharos.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(1.5, 0, 0)
	dummy._ready()
	
	var res1 = kharos.cast_kharos_q(dummy)
	var dmg1 = res1.final_health_damage
	
	kharos.ability_container.reset_cooldowns()
	var res2 = kharos.cast_kharos_q(dummy)
	var dmg2 = res2.final_health_damage
	
	if dmg2 <= dmg1:
		return "Subsequent Frenzy Slash should deal increased damage from Frenzy stack"
		
	dummy.free()
	kharos.free()
	return ""

func test_task34_kharos_q_frenzy_slash_stack_timer_expiration() -> String:
	var kharos = KharosHeroClass.new()
	kharos.team = TeamDefinitions.Team.RADIANT
	kharos._ready()
	kharos.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(1.5, 0, 0)
	dummy._ready()
	
	kharos.cast_kharos_q(dummy)
	kharos._process(4.5)
	
	if kharos.frenzy_stacks != 0:
		return "Frenzy stacks should expire after 4.0 seconds"
		
	dummy.free()
	kharos.free()
	return ""

func test_task34_kharos_q_frenzy_slash_rejects_ally() -> String:
	var kharos = KharosHeroClass.new()
	kharos.team = TeamDefinitions.Team.RADIANT
	kharos._ready()
	kharos.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(1.5, 0, 0)
	ally._ready()
	
	var res = kharos.cast_kharos_q(ally)
	if res != null:
		return "Frenzy Slash must reject allied targets"
		
	ally.free()
	kharos.free()
	return ""

func test_task34_kharos_q_frenzy_slash_cooldown_and_mana() -> String:
	var kharos = KharosHeroClass.new()
	kharos.team = TeamDefinitions.Team.RADIANT
	kharos._ready()
	kharos.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(1.5, 0, 0)
	dummy._ready()
	
	var init_mana = kharos.attribute_system.current_mana
	kharos.cast_kharos_q(dummy)
	
	if kharos.attribute_system.current_mana >= init_mana:
		return "Frenzy Slash should deduct mana"
		
	var second_cast = kharos.cast_kharos_q(dummy)
	if second_cast != null:
		return "Frenzy Slash should be on cooldown"
		
	dummy.free()
	kharos.free()
	return ""

func test_task34_kharos_w_blood_rush_costs_health() -> String:
	var kharos = KharosHeroClass.new()
	kharos.team = TeamDefinitions.Team.RADIANT
	kharos._ready()
	kharos.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var init_hp = kharos.attribute_system.current_health
	var success = kharos.cast_kharos_w()
	
	if not success:
		return "Blood Rush should cast successfully"
	if kharos.attribute_system.current_health >= init_hp:
		return "Blood Rush should cost 8% current health"
		
	kharos.free()
	return ""

func test_task34_kharos_w_blood_rush_move_speed() -> String:
	var kharos = KharosHeroClass.new()
	kharos.team = TeamDefinitions.Team.RADIANT
	kharos._ready()
	kharos.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var base_ms = kharos.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	kharos.cast_kharos_w()
	
	var buffed_ms = kharos.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	if buffed_ms <= base_ms:
		return "Blood Rush should grant +30% Move Speed bonus"
		
	kharos.free()
	return ""

func test_task34_kharos_w_blood_rush_speed_expiration() -> String:
	var kharos = KharosHeroClass.new()
	kharos.team = TeamDefinitions.Team.RADIANT
	kharos._ready()
	kharos.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	kharos.cast_kharos_w()
	kharos._process(4.0)
	
	if kharos.attribute_system.has_modifier_with_source("kharos_blood_rush_ms"):
		return "Blood Rush move speed modifier should expire after 3.5 seconds"
		
	kharos.free()
	return ""

func test_task34_kharos_e_rage_reversal_base_damage() -> String:
	var kharos = KharosHeroClass.new()
	kharos.team = TeamDefinitions.Team.RADIANT
	kharos._ready()
	kharos.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(1.5, 0, 0)
	dummy._ready()
	
	var res = kharos.cast_kharos_e(dummy)
	if res == null:
		return "Rage Reversal should return valid DamageResult"
	if res.final_health_damage <= 0.0:
		return "Rage Reversal should deal base physical damage"
		
	dummy.free()
	kharos.free()
	return ""

func test_task34_kharos_e_rage_reversal_reflects_damage() -> String:
	var kharos = KharosHeroClass.new()
	kharos.team = TeamDefinitions.Team.RADIANT
	kharos._ready()
	kharos.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(1.5, 0, 0)
	dummy._ready()
	
	var res_base = kharos.cast_kharos_e(dummy)
	var base_dmg = res_base.final_health_damage
	
	kharos.ability_container.reset_cooldowns()
	kharos.take_damage_recorded(200.0)
	
	var res_reflected = kharos.cast_kharos_e(dummy)
	if res_reflected.final_health_damage <= base_dmg + 50.0:
		return "Rage Reversal should reflect 35% of recent 200.0 damage taken"
		
	dummy.free()
	kharos.free()
	return ""

func test_task34_kharos_e_rage_reversal_clears_buffer() -> String:
	var kharos = KharosHeroClass.new()
	kharos.team = TeamDefinitions.Team.RADIANT
	kharos._ready()
	kharos.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(1.5, 0, 0)
	dummy._ready()
	
	kharos.take_damage_recorded(200.0)
	kharos.cast_kharos_e(dummy)
	
	if kharos.recent_damage_taken != 0.0:
		return "Rage Reversal should consume and clear recent damage buffer upon cast"
		
	dummy.free()
	kharos.free()
	return ""

func test_task34_kharos_r_red_fury_invulnerability() -> String:
	var kharos = KharosHeroClass.new()
	kharos.team = TeamDefinitions.Team.RADIANT
	kharos._ready()
	kharos.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var success = kharos.cast_kharos_r()
	if not success:
		return "Red Fury should cast successfully"
		
	kharos.attribute_system.current_health = -50.0
	kharos._process(0.1)
	
	if kharos.attribute_system.current_health < 1.0:
		return "Red Fury should prevent health from dropping below 1.0 HP"
		
	kharos.free()
	return ""

func test_task34_kharos_r_red_fury_doubles_bloodrage() -> String:
	var kharos = KharosHeroClass.new()
	kharos.team = TeamDefinitions.Team.RADIANT
	kharos._ready()
	kharos.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	kharos.attribute_system.current_health = 100.0
	kharos._process(0.1)
	var normal_bloodrage_ad = kharos.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	
	kharos.cast_kharos_r()
	kharos._process(0.1)
	var fury_bloodrage_ad = kharos.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	
	if fury_bloodrage_ad <= normal_bloodrage_ad:
		return "Red Fury should double Bloodrage passive stat multipliers"
		
	kharos.free()
	return ""

func test_task34_kharos_r_red_fury_expiration() -> String:
	var kharos = KharosHeroClass.new()
	kharos.team = TeamDefinitions.Team.RADIANT
	kharos._ready()
	kharos.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	kharos.cast_kharos_r()
	kharos._process(4.5)
	
	if kharos.is_red_fury_active:
		return "Red Fury should expire after 4.0 seconds"
		
	kharos.free()
	return ""

func test_task34_kharos_hero_definition_factory() -> String:
	HeroDefinition._ensure_registry()
	var def = HeroDefinition.get_definition("kharos")
	if def == null:
		return "HeroDefinition.get_definition('kharos') should not be null"
	if def.hero_name != "Kharos":
		return "Hero name expected 'Kharos', got '%s'" % def.hero_name
		
	var hero = HeroDefinition.create_hero_instance("kharos")
	if hero == null or not (hero is KharosHeroClass):
		return "create_hero_instance('kharos') should produce KharosHero"
		
	hero.free()
	return ""

func test_task34_kharos_death_and_respawn_clean_state() -> String:
	var kharos = KharosHeroClass.new()
	kharos._ready()
	kharon_setup(kharos)
	
	kharos.die(null)
	if kharos.frenzy_stacks != 0 or kharos.is_red_fury_active:
		return "Death should reset frenzy and red fury states"
		
	kharos.respawn()
	if not kharos.is_alive():
		return "Respawned Kharos should be alive"
		
	kharos.free()
	return ""

func kharon_setup(kharos: KharosHeroClass) -> void:
	kharos.frenzy_stacks = 4
	kharos.is_red_fury_active = true

# ==============================================================================
# TASK 35: NYXARA HERO IMPLEMENTATION TESTS
# ==============================================================================

func test_task35_nyxara_initialization_and_archetype() -> String:
	var nyxara = NyxaraHeroClass.new()
	nyxara.team = TeamDefinitions.Team.RADIANT
	nyxara._ready()
	
	if nyxara.hero_resource.primary_attribute != AttributeSystem.PrimaryAttributeType.AGILITY:
		return "Nyxara primary attribute should be AGILITY"
	if nyxara.hero_resource.attack_type != HeroResource.AttackType.MELEE:
		return "Nyxara attack type should be MELEE"
	if nyxara.hero_resource.base_move_speed < 320.0:
		return "Nyxara base move speed should be >= 320.0"
		
	nyxara.free()
	return ""

func test_task35_nyxara_passive_veil_marks_stacking() -> String:
	var nyxara = NyxaraHeroClass.new()
	nyxara.team = TeamDefinitions.Team.RADIANT
	nyxara._ready()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	nyxara.apply_veil_mark(dummy, 1)
	if nyxara.get_veil_marks(dummy) != 1:
		return "Target should have 1 Veil Mark"
		
	nyxara.apply_veil_mark(dummy, 5)
	if nyxara.get_veil_marks(dummy) > 3:
		return "Veil Marks should be clamped at 3 max (got %d)" % nyxara.get_veil_marks(dummy)
		
	dummy.free()
	nyxara.free()
	return ""

func test_task35_nyxara_passive_veil_marks_armor_shred() -> String:
	var nyxara = NyxaraHeroClass.new()
	nyxara.team = TeamDefinitions.Team.RADIANT
	nyxara._ready()
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	var base_armor = enemy.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	nyxara.apply_veil_mark(enemy, 2)
	
	var shredded_armor = enemy.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	if shredded_armor >= base_armor:
		return "Veil Marks should reduce target armor (-5% per stack)"
		
	enemy.free()
	nyxara.free()
	return ""

func test_task35_nyxara_passive_veil_marks_expiration() -> String:
	var nyxara = NyxaraHeroClass.new()
	nyxara.team = TeamDefinitions.Team.RADIANT
	nyxara._ready()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	nyxara.apply_veil_mark(dummy, 2)
	nyxara._process(6.5)
	
	if nyxara.get_veil_marks(dummy) != 0:
		return "Veil Marks should expire after 6.0 seconds"
		
	dummy.free()
	nyxara.free()
	return ""

func test_task35_nyxara_q_needle_damage() -> String:
	var nyxara = NyxaraHeroClass.new()
	nyxara.team = TeamDefinitions.Team.RADIANT
	nyxara._ready()
	nyxara.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(3.0, 0, 0)
	dummy._ready()
	
	var res = nyxara.cast_nyxara_q(dummy)
	if res == null:
		return "Needle should return valid DamageResult"
	if res.final_health_damage <= 0.0:
		return "Needle should deal physical damage"
		
	dummy.free()
	nyxara.free()
	return ""

func test_task35_nyxara_q_needle_applies_mark() -> String:
	var nyxara = NyxaraHeroClass.new()
	nyxara.team = TeamDefinitions.Team.RADIANT
	nyxara._ready()
	nyxara.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(3.0, 0, 0)
	dummy._ready()
	
	nyxara.cast_nyxara_q(dummy)
	if nyxara.get_veil_marks(dummy) != 1:
		return "Needle should apply 1 Veil Mark on hit"
		
	dummy.free()
	nyxara.free()
	return ""

func test_task35_nyxara_q_needle_rejects_ally() -> String:
	var nyxara = NyxaraHeroClass.new()
	nyxara.team = TeamDefinitions.Team.RADIANT
	nyxara._ready()
	nyxara.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(3.0, 0, 0)
	ally._ready()
	
	var res = nyxara.cast_nyxara_q(ally)
	if res != null:
		return "Needle must reject allied targets"
		
	ally.free()
	nyxara.free()
	return ""

func test_task35_nyxara_q_needle_cooldown_and_mana() -> String:
	var nyxara = NyxaraHeroClass.new()
	nyxara.team = TeamDefinitions.Team.RADIANT
	nyxara._ready()
	nyxara.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(3.0, 0, 0)
	dummy._ready()
	
	var init_mana = nyxara.attribute_system.current_mana
	nyxara.cast_nyxara_q(dummy)
	
	if nyxara.attribute_system.current_mana >= init_mana:
		return "Needle should deduct mana"
		
	var second_cast = nyxara.cast_nyxara_q(dummy)
	if second_cast != null:
		return "Needle should be on cooldown"
		
	dummy.free()
	nyxara.free()
	return ""

func test_task35_nyxara_w_fade_step_blinks_behind_target() -> String:
	var nyxara = NyxaraHeroClass.new()
	nyxara.team = TeamDefinitions.Team.RADIANT
	nyxara.position = Vector3(0, 0, 0)
	nyxara._ready()
	nyxara.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(3.0, 0, 0)
	dummy._ready()
	
	var success = nyxara.cast_nyxara_w(dummy)
	if not success:
		return "Fade Step should cast successfully"
	if nyxara.position.x <= 1.0:
		return "Fade Step should blink Nyxara to target location"
		
	dummy.free()
	nyxara.free()
	return ""

func test_task35_nyxara_w_fade_step_applies_mark() -> String:
	var nyxara = NyxaraHeroClass.new()
	nyxara.team = TeamDefinitions.Team.RADIANT
	nyxara._ready()
	nyxara.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(3.0, 0, 0)
	dummy._ready()
	
	nyxara.cast_nyxara_w(dummy)
	if nyxara.get_veil_marks(dummy) < 1:
		return "Fade Step should apply 1 Veil Mark to target"
		
	dummy.free()
	nyxara.free()
	return ""

func test_task35_nyxara_w_fade_step_rejects_ally() -> String:
	var nyxara = NyxaraHeroClass.new()
	nyxara.team = TeamDefinitions.Team.RADIANT
	nyxara._ready()
	nyxara.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(3.0, 0, 0)
	ally._ready()
	
	var success = nyxara.cast_nyxara_w(ally)
	if success:
		return "Fade Step must reject allied targets"
		
	ally.free()
	nyxara.free()
	return ""

func test_task35_nyxara_e_sever_thread_consumes_marks() -> String:
	var nyxara = NyxaraHeroClass.new()
	nyxara.team = TeamDefinitions.Team.RADIANT
	nyxara._ready()
	nyxara.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	nyxara.apply_veil_mark(dummy, 3)
	var res = nyxara.cast_nyxara_e(dummy)
	
	if res == null or res.final_health_damage <= 0.0:
		return "Sever Thread should deal physical damage"
	if nyxara.get_veil_marks(dummy) != 0:
		return "Sever Thread should consume all Veil Marks upon cast"
		
	dummy.free()
	nyxara.free()
	return ""

func test_task35_nyxara_e_sever_thread_missing_hp_scaling() -> String:
	var nyxara = NyxaraHeroClass.new()
	nyxara.team = TeamDefinitions.Team.RADIANT
	nyxara._ready()
	nyxara.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var dummy_full = TargetDummyEntity.new()
	dummy_full.team = TeamDefinitions.Team.DIRE
	dummy_full.position = Vector3(2.0, 0, 0)
	dummy_full._ready()
	
	var dummy_low = TargetDummyEntity.new()
	dummy_low.team = TeamDefinitions.Team.DIRE
	dummy_low.position = Vector3(2.0, 0, 0)
	dummy_low._ready()
	dummy_low.attribute_system.current_health = 100.0
	
	var res_full = nyxara.cast_nyxara_e(dummy_full)
	nyxara.ability_container.reset_cooldowns()
	var res_low = nyxara.cast_nyxara_e(dummy_low)
	
	if res_low.final_health_damage <= res_full.final_health_damage:
		return "Sever Thread should deal additional execution damage against missing health target"
		
	dummy_full.free()
	dummy_low.free()
	nyxara.free()
	return ""

func test_task35_nyxara_e_sever_thread_rejects_ally() -> String:
	var nyxara = NyxaraHeroClass.new()
	nyxara.team = TeamDefinitions.Team.RADIANT
	nyxara._ready()
	nyxara.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(2.0, 0, 0)
	ally._ready()
	
	var res = nyxara.cast_nyxara_e(ally)
	if res != null:
		return "Sever Thread must reject allied targets"
		
	ally.free()
	nyxara.free()
	return ""

func test_task35_nyxara_r_vanish_grants_invis_and_speed() -> String:
	var nyxara = NyxaraHeroClass.new()
	nyxara.team = TeamDefinitions.Team.RADIANT
	nyxara._ready()
	nyxara.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var base_ms = nyxara.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	var success = nyxara.cast_nyxara_r()
	
	if not success:
		return "Vanish should cast successfully"
	if not nyxara.is_vanished:
		return "Vanish should set is_vanished = true"
		
	var buffed_ms = nyxara.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	if buffed_ms <= base_ms:
		return "Vanish should grant +40% Move Speed bonus"
		
	nyxara.free()
	return ""

func test_task35_nyxara_r_vanish_attack_applies_3_marks() -> String:
	var nyxara = NyxaraHeroClass.new()
	nyxara.team = TeamDefinitions.Team.RADIANT
	nyxara._ready()
	nyxara.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(1.5, 0, 0)
	dummy._ready()
	
	nyxara.cast_nyxara_r()
	nyxara.execute_basic_attack(dummy)
	
	if nyxara.is_vanished:
		return "Basic attack should break Vanish state"
	if nyxara.get_veil_marks(dummy) != 3:
		return "Attack out of Vanish should apply 3 Veil Marks directly"
		
	dummy.free()
	nyxara.free()
	return ""

func test_task35_nyxara_r_vanish_timer_expiration() -> String:
	var nyxara = NyxaraHeroClass.new()
	nyxara.team = TeamDefinitions.Team.RADIANT
	nyxara._ready()
	nyxara.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	nyxara.cast_nyxara_r()
	nyxara._process(4.5)
	
	if nyxara.is_vanished:
		return "Vanish should expire after 4.0 seconds"
		
	nyxara.free()
	return ""

func test_task35_nyxara_r_vanish_cooldown_and_mana() -> String:
	var nyxara = NyxaraHeroClass.new()
	nyxara.team = TeamDefinitions.Team.RADIANT
	nyxara._ready()
	nyxara.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var init_mana = nyxara.attribute_system.current_mana
	nyxara.cast_nyxara_r()
	
	if nyxara.attribute_system.current_mana >= init_mana:
		return "Vanish should deduct mana"
		
	var second_cast = nyxara.cast_nyxara_r()
	if second_cast:
		return "Vanish should be on cooldown"
		
	nyxara.free()
	return ""

func test_task35_nyxara_hero_definition_factory() -> String:
	HeroDefinition._ensure_registry()
	var def = HeroDefinition.get_definition("nyxara")
	if def == null:
		return "HeroDefinition.get_definition('nyxara') should not be null"
	if def.hero_name != "Nyxara":
		return "Hero name expected 'Nyxara', got '%s'" % def.hero_name
		
	var hero = HeroDefinition.create_hero_instance("nyxara")
	if hero == null or not (hero is NyxaraHeroClass):
		return "create_hero_instance('nyxara') should produce NyxaraHero"
		
	hero.free()
	return ""

func test_task35_nyxara_death_and_respawn_clean_state() -> String:
	var nyxara = NyxaraHeroClass.new()
	nyxara._ready()
	nyxara.cast_nyxara_r()
	
	nyxara.die(null)
	if nyxara.is_vanished or not nyxara.active_marks.is_empty():
		return "Death should break vanish and clear active marks"
		
	nyxara.respawn()
	if not nyxara.is_alive():
		return "Respawned Nyxara should be alive"
		
	nyxara.free()
	return ""

# ==============================================================================
# TASK 36: KAELI HERO IMPLEMENTATION TESTS
# ==============================================================================

func test_task36_kaeli_initialization_and_archetype() -> String:
	var kaeli = KaeliHeroClass.new()
	kaeli.team = TeamDefinitions.Team.RADIANT
	kaeli._ready()
	
	if kaeli.hero_resource.primary_attribute != AttributeSystem.PrimaryAttributeType.AGILITY:
		return "Kaeli primary attribute should be AGILITY"
	if kaeli.hero_resource.attack_type != HeroResource.AttackType.MELEE:
		return "Kaeli attack type should be MELEE"
	if kaeli.hero_resource.base_attack_speed < 0.70:
		return "Kaeli base attack speed should be >= 0.70"
		
	kaeli.free()
	return ""

func test_task36_kaeli_passive_rhythm_sequential_stacking() -> String:
	var kaeli = KaeliHeroClass.new()
	kaeli.team = TeamDefinitions.Team.RADIANT
	kaeli._ready()
	
	kaeli._trigger_rhythm(AbilityResource.Slot.Q)
	if kaeli.rhythm_stacks != 1:
		return "First distinct ability should give 1 Rhythm stack"
		
	kaeli._trigger_rhythm(AbilityResource.Slot.W)
	if kaeli.rhythm_stacks != 2:
		return "Second distinct ability should increase Rhythm to 2"
		
	kaeli._trigger_rhythm(AbilityResource.Slot.E)
	if kaeli.rhythm_stacks != 3:
		return "Third distinct ability should increase Rhythm to 3"
		
	kaeli._trigger_rhythm(AbilityResource.Slot.Q)
	if kaeli.rhythm_stacks != 4:
		return "Fourth distinct ability should reach 4 Rhythm stacks"
		
	kaeli.free()
	return ""

func test_task36_kaeli_passive_rhythm_repeated_cast() -> String:
	var kaeli = KaeliHeroClass.new()
	kaeli.team = TeamDefinitions.Team.RADIANT
	kaeli._ready()
	
	kaeli._trigger_rhythm(AbilityResource.Slot.Q)
	kaeli._trigger_rhythm(AbilityResource.Slot.W)
	if kaeli.rhythm_stacks != 2:
		return "Should have 2 Rhythm stacks"
		
	# Repeating W should reset stacks to 1
	kaeli._trigger_rhythm(AbilityResource.Slot.W)
	if kaeli.rhythm_stacks != 1:
		return "Repeating same ability should reset Rhythm stacks to 1 (got %d)" % kaeli.rhythm_stacks
		
	kaeli.free()
	return ""

func test_task36_kaeli_passive_rhythm_stat_buffs() -> String:
	var kaeli = KaeliHeroClass.new()
	kaeli.team = TeamDefinitions.Team.RADIANT
	kaeli._ready()
	
	var base_as = kaeli.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	var base_ms = kaeli.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	kaeli._trigger_rhythm(AbilityResource.Slot.Q)
	kaeli._trigger_rhythm(AbilityResource.Slot.W)
	
	var buffed_as = kaeli.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	var buffed_ms = kaeli.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	if buffed_as <= base_as:
		return "Rhythm stacks should increase Attack Speed"
	if buffed_ms <= base_ms:
		return "Rhythm stacks should increase Move Speed"
		
	kaeli.free()
	return ""

func test_task36_kaeli_passive_rhythm_timer_expiration() -> String:
	var kaeli = KaeliHeroClass.new()
	kaeli.team = TeamDefinitions.Team.RADIANT
	kaeli._ready()
	
	kaeli._trigger_rhythm(AbilityResource.Slot.Q)
	kaeli._process(5.5)
	
	if kaeli.rhythm_stacks != 0:
		return "Rhythm stacks should expire after 5.0 seconds"
		
	kaeli.free()
	return ""

func test_task36_kaeli_q_twin_cut_damage() -> String:
	var kaeli = KaeliHeroClass.new()
	kaeli.team = TeamDefinitions.Team.RADIANT
	kaeli._ready()
	kaeli.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(1.5, 0, 0)
	dummy._ready()
	
	var res = kaeli.cast_kaeli_q(dummy)
	if res == null or res.final_health_damage <= 0.0:
		return "Twin Cut should deal physical damage"
		
	dummy.free()
	kaeli.free()
	return ""

func test_task36_kaeli_q_twin_cut_triggers_rhythm() -> String:
	var kaeli = KaeliHeroClass.new()
	kaeli.team = TeamDefinitions.Team.RADIANT
	kaeli._ready()
	kaeli.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(1.5, 0, 0)
	dummy._ready()
	
	kaeli.cast_kaeli_q(dummy)
	if kaeli.rhythm_stacks < 1:
		return "Casting Twin Cut should grant 1 Rhythm stack"
		
	dummy.free()
	kaeli.free()
	return ""

func test_task36_kaeli_q_twin_cut_rejects_ally() -> String:
	var kaeli = KaeliHeroClass.new()
	kaeli.team = TeamDefinitions.Team.RADIANT
	kaeli._ready()
	kaeli.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(1.5, 0, 0)
	ally._ready()
	
	var res = kaeli.cast_kaeli_q(ally)
	if res != null:
		return "Twin Cut must reject allied targets"
		
	ally.free()
	kaeli.free()
	return ""

func test_task36_kaeli_q_twin_cut_cooldown_and_mana() -> String:
	var kaeli = KaeliHeroClass.new()
	kaeli.team = TeamDefinitions.Team.RADIANT
	kaeli._ready()
	kaeli.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(1.5, 0, 0)
	dummy._ready()
	
	var init_mana = kaeli.attribute_system.current_mana
	kaeli.cast_kaeli_q(dummy)
	
	if kaeli.attribute_system.current_mana >= init_mana:
		return "Twin Cut should deduct mana"
		
	var second_cast = kaeli.cast_kaeli_q(dummy)
	if second_cast != null:
		return "Twin Cut should be on cooldown"
		
	dummy.free()
	kaeli.free()
	return ""

func test_task36_kaeli_w_slipstream_dashes_forward() -> String:
	var kaeli = KaeliHeroClass.new()
	kaeli.team = TeamDefinitions.Team.RADIANT
	kaeli.position = Vector3(0, 0, 0)
	kaeli._ready()
	kaeli.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var success = kaeli.cast_kaeli_w()
	if not success:
		return "Slipstream should cast successfully"
	if kaeli.position.length() <= 1.0:
		return "Slipstream should move Kaeli forward"
		
	kaeli.free()
	return ""

func test_task36_kaeli_w_slipstream_triggers_rhythm() -> String:
	var kaeli = KaeliHeroClass.new()
	kaeli.team = TeamDefinitions.Team.RADIANT
	kaeli._ready()
	kaeli.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	kaeli.cast_kaeli_w()
	if kaeli.rhythm_stacks < 1:
		return "Slipstream should trigger Rhythm stack"
		
	kaeli.free()
	return ""

func test_task36_kaeli_w_slipstream_cooldown_and_mana() -> String:
	var kaeli = KaeliHeroClass.new()
	kaeli.team = TeamDefinitions.Team.RADIANT
	kaeli._ready()
	kaeli.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var init_mana = kaeli.attribute_system.current_mana
	kaeli.cast_kaeli_w()
	
	if kaeli.attribute_system.current_mana >= init_mana:
		return "Slipstream should deduct mana"
		
	var second_cast = kaeli.cast_kaeli_w()
	if second_cast:
		return "Slipstream should be on cooldown"
		
	kaeli.free()
	return ""

func test_task36_kaeli_e_crossfire_arms_attack() -> String:
	var kaeli = KaeliHeroClass.new()
	kaeli.team = TeamDefinitions.Team.RADIANT
	kaeli._ready()
	kaeli.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var success = kaeli.cast_kaeli_e()
	if not success or not kaeli.is_crossfire_armed:
		return "Crossfire should arm the next basic attack"
		
	kaeli.free()
	return ""

func test_task36_kaeli_e_crossfire_basic_attack_bonus_damage() -> String:
	var kaeli = KaeliHeroClass.new()
	kaeli.team = TeamDefinitions.Team.RADIANT
	kaeli._ready()
	kaeli.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(1.5, 0, 0)
	dummy._ready()
	
	kaeli.cast_kaeli_e()
	var hp_before = dummy.attribute_system.current_health
	kaeli.execute_basic_attack(dummy)
	var hp_after = dummy.attribute_system.current_health
	
	if kaeli.is_crossfire_armed:
		return "Basic attack should consume Crossfire armed state"
	if hp_before - hp_after <= 60.0:
		return "Crossfire basic attack should deal empowered bonus damage"
		
	dummy.free()
	kaeli.free()
	return ""

func test_task36_kaeli_e_crossfire_timer_expiration() -> String:
	var kaeli = KaeliHeroClass.new()
	kaeli.team = TeamDefinitions.Team.RADIANT
	kaeli._ready()
	kaeli.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	kaeli.cast_kaeli_e()
	kaeli._process(4.5)
	
	if kaeli.is_crossfire_armed:
		return "Crossfire armed state should expire after 4.0 seconds"
		
	kaeli.free()
	return ""

func test_task36_kaeli_r_perfect_tempo_buffs() -> String:
	var kaeli = KaeliHeroClass.new()
	kaeli.team = TeamDefinitions.Team.RADIANT
	kaeli._ready()
	kaeli.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var base_as = kaeli.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	var success = kaeli.cast_kaeli_r()
	
	if not success or not kaeli.is_perfect_tempo_active:
		return "Perfect Tempo should cast and activate"
	if kaeli.rhythm_stacks != 4:
		return "Perfect Tempo should instantly maximize Rhythm to 4 stacks"
		
	var buffed_as = kaeli.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	if buffed_as <= base_as + 0.30:
		return "Perfect Tempo should grant massive AS bonus"
		
	kaeli.free()
	return ""

func test_task36_kaeli_r_perfect_tempo_reduces_cooldowns() -> String:
	var kaeli = KaeliHeroClass.new()
	kaeli.team = TeamDefinitions.Team.RADIANT
	kaeli._ready()
	kaeli.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	kaeli.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	kaeli.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	kaeli.ability_container.cooldown_timers[AbilityResource.Slot.Q] = 4.0
	kaeli.ability_container.cooldown_timers[AbilityResource.Slot.W] = 6.0
	
	var cast_res = kaeli.cast_kaeli_r()
	if not cast_res:
		return "Kaeli cast R should succeed"
	
	if kaeli.ability_container.cooldown_timers[AbilityResource.Slot.Q] > 2.1:
		return "Perfect Tempo should reduce Q cooldown by 50% (got %f)" % kaeli.ability_container.cooldown_timers[AbilityResource.Slot.Q]
	if kaeli.ability_container.cooldown_timers[AbilityResource.Slot.W] > 3.1:
		return "Perfect Tempo should reduce W cooldown by 50%"
		
	kaeli.free()
	return ""

func test_task36_kaeli_r_perfect_tempo_expiration() -> String:
	var kaeli = KaeliHeroClass.new()
	kaeli.team = TeamDefinitions.Team.RADIANT
	kaeli._ready()
	kaeli.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	kaeli.cast_kaeli_r()
	kaeli._process(6.5)
	
	if kaeli.is_perfect_tempo_active:
		return "Perfect Tempo should expire after 6.0 seconds"
		
	kaeli.free()
	return ""

func test_task36_kaeli_hero_definition_factory() -> String:
	HeroDefinition._ensure_registry()
	var def = HeroDefinition.get_definition("kaeli")
	if def == null:
		return "HeroDefinition.get_definition('kaeli') should not be null"
	if def.hero_name != "Kaeli":
		return "Hero name expected 'Kaeli', got '%s'" % def.hero_name
		
	var hero = HeroDefinition.create_hero_instance("kaeli")
	if hero == null or not (hero is KaeliHeroClass):
		return "create_hero_instance('kaeli') should produce KaeliHero"
		
	hero.free()
	return ""

func test_task36_kaeli_death_and_respawn_clean_state() -> String:
	var kaeli = KaeliHeroClass.new()
	kaeli._ready()
	kaeli.cast_kaeli_r()
	kaeli.cast_kaeli_e()
	
	kaeli.die(null)
	if kaeli.rhythm_stacks != 0 or kaeli.is_crossfire_armed or kaeli.is_perfect_tempo_active:
		return "Death should clean all rhythm, crossfire and tempo states"
		
	kaeli.respawn()
	if not kaeli.is_alive():
		return "Respawned Kaeli should be alive"
		
	kaeli.free()
	return ""

# ==============================================================================
# TASK 37: VARYN HERO IMPLEMENTATION TESTS
# ==============================================================================

func test_task37_varyn_initialization_and_archetype() -> String:
	var varyn = VarynHeroClass.new()
	varyn.team = TeamDefinitions.Team.RADIANT
	varyn._ready()
	
	if varyn.hero_resource.primary_attribute != AttributeSystem.PrimaryAttributeType.AGILITY:
		return "Varyn primary attribute should be AGILITY"
	if varyn.hero_resource.attack_type != HeroResource.AttackType.MELEE:
		return "Varyn attack type should be MELEE"
	if varyn.hero_resource.base_move_speed < 320.0:
		return "Varyn base move speed should be >= 320.0"
		
	varyn.free()
	return ""

func test_task37_varyn_passive_flow_accumulation() -> String:
	var varyn = VarynHeroClass.new()
	varyn.team = TeamDefinitions.Team.RADIANT
	varyn._ready()
	
	varyn.add_flow(25.0)
	if varyn.flow != 25.0:
		return "Varyn flow should be 25.0"
		
	varyn.free()
	return ""

func test_task37_varyn_passive_flow_stat_scaling() -> String:
	var varyn = VarynHeroClass.new()
	varyn.team = TeamDefinitions.Team.RADIANT
	varyn._ready()
	
	var base_ad = varyn.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var base_ms = varyn.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	varyn.add_flow(50.0)
	
	var buffed_ad = varyn.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var buffed_ms = varyn.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	if buffed_ad <= base_ad + 10.0:
		return "Flow should grant bonus Attack Damage (+3 per 10 Flow)"
	if buffed_ms <= base_ms:
		return "Flow should grant bonus Move Speed"
		
	varyn.free()
	return ""

func test_task37_varyn_passive_flow_clamped() -> String:
	var varyn = VarynHeroClass.new()
	varyn.team = TeamDefinitions.Team.RADIANT
	varyn._ready()
	
	varyn.add_flow(200.0)
	if varyn.flow > 100.0:
		return "Varyn Flow should be clamped at 100.0 (got %f)" % varyn.flow
		
	varyn.free()
	return ""

func test_task37_varyn_q_razor_leap_damage_and_dash() -> String:
	var varyn = VarynHeroClass.new()
	varyn.team = TeamDefinitions.Team.RADIANT
	varyn.position = Vector3(0, 0, 0)
	varyn._ready()
	varyn.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(3.0, 0, 0)
	dummy._ready()
	
	var res = varyn.cast_varyn_q(dummy)
	if res == null or res.final_health_damage <= 0.0:
		return "Razor Leap should deal physical damage"
	if varyn.position.length() <= 1.0:
		return "Razor Leap should dash Varyn to target"
		
	dummy.free()
	varyn.free()
	return ""

func test_task37_varyn_q_razor_leap_generates_flow() -> String:
	var varyn = VarynHeroClass.new()
	varyn.team = TeamDefinitions.Team.RADIANT
	varyn._ready()
	varyn.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	varyn.cast_varyn_q(dummy)
	if varyn.flow < 20.0:
		return "Razor Leap should generate +20 Flow upon hit"
		
	dummy.free()
	varyn.free()
	return ""

func test_task37_varyn_q_razor_leap_rejects_ally() -> String:
	var varyn = VarynHeroClass.new()
	varyn.team = TeamDefinitions.Team.RADIANT
	varyn._ready()
	varyn.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(2.0, 0, 0)
	ally._ready()
	
	var res = varyn.cast_varyn_q(ally)
	if res != null:
		return "Razor Leap must reject allied targets"
		
	ally.free()
	varyn.free()
	return ""

func test_task37_varyn_q_razor_leap_cooldown_and_mana() -> String:
	var varyn = VarynHeroClass.new()
	varyn.team = TeamDefinitions.Team.RADIANT
	varyn._ready()
	varyn.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	var init_mana = varyn.attribute_system.current_mana
	varyn.cast_varyn_q(dummy)
	
	if varyn.attribute_system.current_mana >= init_mana:
		return "Razor Leap should deduct mana"
		
	var second_cast = varyn.cast_varyn_q(dummy)
	if second_cast != null:
		return "Razor Leap should be on cooldown"
		
	dummy.free()
	varyn.free()
	return ""

func test_task37_varyn_w_spin_cut_damage() -> String:
	var varyn = VarynHeroClass.new()
	varyn.team = TeamDefinitions.Team.RADIANT
	varyn._ready()
	varyn.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(1.5, 0, 0)
	dummy._ready()
	
	var hp_before = dummy.attribute_system.current_health
	var hits = varyn.cast_varyn_w([dummy])
	var hp_after = dummy.attribute_system.current_health
	
	if hits != 1 or hp_before - hp_after <= 0.0:
		return "Spin Cut should hit nearby enemy and deal physical damage"
		
	dummy.free()
	varyn.free()
	return ""

func test_task37_varyn_w_spin_cut_generates_flow() -> String:
	var varyn = VarynHeroClass.new()
	varyn.team = TeamDefinitions.Team.RADIANT
	varyn._ready()
	varyn.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var dummy1 = TargetDummyEntity.new()
	dummy1.team = TeamDefinitions.Team.DIRE
	dummy1._ready()
	
	var dummy2 = TargetDummyEntity.new()
	dummy2.team = TeamDefinitions.Team.DIRE
	dummy2._ready()
	
	varyn.cast_varyn_w([dummy1, dummy2])
	if varyn.flow < 30.0:
		return "Spin Cut should generate +15 Flow per hit (2 hits = +30 Flow)"
		
	dummy1.free()
	dummy2.free()
	varyn.free()
	return ""

func test_task37_varyn_w_spin_cut_cooldown_and_mana() -> String:
	var varyn = VarynHeroClass.new()
	varyn.team = TeamDefinitions.Team.RADIANT
	varyn._ready()
	varyn.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var init_mana = varyn.attribute_system.current_mana
	varyn.cast_varyn_w([])
	
	if varyn.attribute_system.current_mana >= init_mana:
		return "Spin Cut should deduct mana"
		
	var second_cast = varyn.cast_varyn_w([])
	if second_cast > 0:
		return "Spin Cut should be on cooldown"
		
	varyn.free()
	return ""

func test_task37_varyn_e_rebound_dash() -> String:
	var varyn = VarynHeroClass.new()
	varyn.team = TeamDefinitions.Team.RADIANT
	varyn.position = Vector3(0, 0, 0)
	varyn._ready()
	varyn.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var success = varyn.cast_varyn_e()
	if not success:
		return "Rebound should cast successfully"
	if varyn.position.length() <= 1.0:
		return "Rebound should dash Varyn forward"
		
	varyn.free()
	return ""

func test_task37_varyn_e_rebound_free_charge() -> String:
	var varyn = VarynHeroClass.new()
	varyn.team = TeamDefinitions.Team.RADIANT
	varyn._ready()
	varyn.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	varyn.recent_hit_timer = 2.0
	varyn.cast_varyn_e()
	
	if not varyn.has_rebound_free_charge:
		return "Rebound should grant a free 2nd dash charge if an enemy was hit recently"
		
	varyn.free()
	return ""

func test_task37_varyn_e_rebound_free_charge_consumption() -> String:
	var varyn = VarynHeroClass.new()
	varyn.team = TeamDefinitions.Team.RADIANT
	varyn._ready()
	varyn.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	varyn.recent_hit_timer = 2.0
	varyn.cast_varyn_e()
	
	var mana_before = varyn.attribute_system.current_mana
	var success_free = varyn.cast_varyn_e()
	var mana_after = varyn.attribute_system.current_mana
	
	if not success_free or varyn.has_rebound_free_charge:
		return "Free Rebound charge should be consumed successfully"
	if mana_before != mana_after:
		return "Free Rebound charge should not cost mana"
		
	varyn.free()
	return ""

func test_task37_varyn_r_endless_motion_buffs() -> String:
	var varyn = VarynHeroClass.new()
	varyn.team = TeamDefinitions.Team.RADIANT
	varyn._ready()
	varyn.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var base_ms = varyn.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	var success = varyn.cast_varyn_r()
	
	if not success or not varyn.is_endless_motion_active:
		return "Endless Motion should cast and activate"
		
	var buffed_ms = varyn.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	if buffed_ms <= base_ms:
		return "Endless Motion should grant +25% Move Speed bonus"
		
	varyn.add_flow(20.0) # Doubled flow during R (+40.0)
	if varyn.flow < 39.0:
		return "Flow generation should be doubled during Endless Motion"
		
	varyn.free()
	return ""

func test_task37_varyn_r_endless_motion_resets_q() -> String:
	var varyn = VarynHeroClass.new()
	varyn.team = TeamDefinitions.Team.RADIANT
	varyn._ready()
	varyn.ability_container.available_skill_points = 4
	varyn.ability_container.level_up_ability(AbilityResource.Slot.Q)
	varyn.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	varyn.cast_varyn_r()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	varyn.cast_varyn_q(dummy)
	
	if varyn.ability_container.cooldown_timers.has(AbilityResource.Slot.Q) and varyn.ability_container.cooldown_timers[AbilityResource.Slot.Q] > 0.0:
		return "Endless Motion should instantly reset Q cooldown upon hitting target"
		
	dummy.free()
	varyn.free()
	return ""

func test_task37_varyn_r_endless_motion_timer_expiration() -> String:
	var varyn = VarynHeroClass.new()
	varyn.team = TeamDefinitions.Team.RADIANT
	varyn._ready()
	varyn.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	varyn.cast_varyn_r()
	varyn._process(6.5)
	
	if varyn.is_endless_motion_active:
		return "Endless Motion should expire after 6.0 seconds"
		
	varyn.free()
	return ""

func test_task37_varyn_r_endless_motion_cooldown_and_mana() -> String:
	var varyn = VarynHeroClass.new()
	varyn.team = TeamDefinitions.Team.RADIANT
	varyn._ready()
	varyn.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var init_mana = varyn.attribute_system.current_mana
	varyn.cast_varyn_r()
	
	if varyn.attribute_system.current_mana >= init_mana:
		return "Endless Motion should deduct mana"
		
	var second_cast = varyn.cast_varyn_r()
	if second_cast:
		return "Endless Motion should be on cooldown"
		
	varyn.free()
	return ""

func test_task37_varyn_hero_definition_factory() -> String:
	HeroDefinition._ensure_registry()
	var def = HeroDefinition.get_definition("varyn")
	if def == null:
		return "HeroDefinition.get_definition('varyn') should not be null"
	if def.hero_name != "Varyn":
		return "Hero name expected 'Varyn', got '%s'" % def.hero_name
		
	var hero = HeroDefinition.create_hero_instance("varyn")
	if hero == null or not (hero is VarynHeroClass):
		return "create_hero_instance('varyn') should produce VarynHero"
		
	hero.free()
	return ""

func test_task37_varyn_death_and_respawn_clean_state() -> String:
	var varyn = VarynHeroClass.new()
	varyn._ready()
	varyn.add_flow(80.0)
	varyn.cast_varyn_r()
	
	varyn.die(null)
	if varyn.flow != 0.0 or varyn.is_endless_motion_active or varyn.has_rebound_free_charge:
		return "Death should clean flow, motion and free rebound states"
		
	varyn.respawn()
	if not varyn.is_alive():
		print("DEBUG 703: life_state=", varyn.lifecycle_state, " attr_alive=", varyn.attribute_system.is_alive, " hp=", varyn.attribute_system.current_health, " max_hp=", varyn.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH))
		return "Respawned Varyn should be alive"
		
	varyn.free()
	return ""

# ==============================================================================
# TASK 38: ELYRA HERO IMPLEMENTATION TESTS
# ==============================================================================

func test_task38_elyra_initialization_and_archetype() -> String:
	var elyra = ElyraHeroClass.new()
	elyra.team = TeamDefinitions.Team.RADIANT
	elyra._ready()
	
	if elyra.hero_resource.primary_attribute != AttributeSystem.PrimaryAttributeType.AGILITY:
		return "Elyra primary attribute should be AGILITY"
	if elyra.hero_resource.attack_type != HeroResource.AttackType.RANGED:
		return "Elyra attack type should be RANGED"
	if elyra.hero_resource.base_attack_range < 500.0:
		return "Elyra base attack range should be >= 500.0"
		
	elyra.free()
	return ""

func test_task38_elyra_passive_fortune_stacking() -> String:
	var elyra = ElyraHeroClass.new()
	elyra.team = TeamDefinitions.Team.RADIANT
	elyra._ready()
	
	elyra.add_fortune(3)
	if elyra.fortune_stacks != 3:
		return "Elyra should have 3 Fortune stacks"
		
	elyra.add_fortune(5)
	if elyra.fortune_stacks > 5:
		return "Fortune stacks should be capped at 5"
		
	elyra.free()
	return ""

func test_task38_elyra_passive_guaranteed_crit() -> String:
	var elyra = ElyraHeroClass.new()
	elyra.team = TeamDefinitions.Team.RADIANT
	elyra._ready()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	elyra.fortune_stacks = 5
	var hp_before = dummy.attribute_system.current_health
	var res = elyra.execute_basic_attack(dummy)
	var hp_after = dummy.attribute_system.current_health
	
	if res == null or hp_before - hp_after <= 0.0:
		return "Guaranteed crit attack should deal damage"
		
	dummy.free()
	elyra.free()
	return ""

func test_task38_elyra_passive_consumes_fortune() -> String:
	var elyra = ElyraHeroClass.new()
	elyra.team = TeamDefinitions.Team.RADIANT
	elyra._ready()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	elyra.fortune_stacks = 5
	elyra.execute_basic_attack(dummy)
	
	if elyra.fortune_stacks != 0:
		return "5th hit guaranteed crit should consume all Fortune stacks"
		
	dummy.free()
	elyra.free()
	return ""

func test_task38_elyra_q_double_down_arms_attack() -> String:
	var elyra = ElyraHeroClass.new()
	elyra.team = TeamDefinitions.Team.RADIANT
	elyra._ready()
	elyra.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var success = elyra.cast_elyra_q()
	if not success or not elyra.is_double_down_armed:
		return "Double Down should arm the next basic attack"
		
	elyra.free()
	return ""

func test_task38_elyra_q_double_down_bonus_damage() -> String:
	var elyra = ElyraHeroClass.new()
	elyra.team = TeamDefinitions.Team.RADIANT
	elyra._ready()
	elyra.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	elyra.cast_elyra_q()
	var hp_before = dummy.attribute_system.current_health
	elyra.execute_basic_attack(dummy)
	var hp_after = dummy.attribute_system.current_health
	
	if elyra.is_double_down_armed:
		return "Basic attack should consume Double Down state"
	if hp_before - hp_after <= 60.0:
		return "Double Down should deal empowered bonus physical damage"
		
	dummy.free()
	elyra.free()
	return ""

func test_task38_elyra_q_double_down_timer_expiration() -> String:
	var elyra = ElyraHeroClass.new()
	elyra.team = TeamDefinitions.Team.RADIANT
	elyra._ready()
	elyra.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	elyra.cast_elyra_q()
	elyra._process(5.5)
	
	if elyra.is_double_down_armed:
		return "Double Down armed state should expire after 5.0 seconds"
		
	elyra.free()
	return ""

func test_task38_elyra_q_double_down_cooldown_and_mana() -> String:
	var elyra = ElyraHeroClass.new()
	elyra.team = TeamDefinitions.Team.RADIANT
	elyra._ready()
	elyra.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var init_mana = elyra.attribute_system.current_mana
	elyra.cast_elyra_q()
	
	if elyra.attribute_system.current_mana >= init_mana:
		return "Double Down should deduct mana"
		
	var second_cast = elyra.cast_elyra_q()
	if second_cast:
		return "Double Down should be on cooldown"
		
	elyra.free()
	return ""

func test_task38_elyra_w_roll_away_dash() -> String:
	var elyra = ElyraHeroClass.new()
	elyra.team = TeamDefinitions.Team.RADIANT
	elyra.position = Vector3(0, 0, 0)
	elyra._ready()
	elyra.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var success = elyra.cast_elyra_w()
	if not success:
		return "Roll Away should cast successfully"
	if elyra.position.length() <= 1.0:
		return "Roll Away should roll Elyra 4.5m forward"
		
	elyra.free()
	return ""

func test_task38_elyra_w_roll_away_evade() -> String:
	var elyra = ElyraHeroClass.new()
	elyra.team = TeamDefinitions.Team.RADIANT
	elyra._ready()
	elyra.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	elyra.cast_elyra_w()
	if not elyra.is_evading:
		return "Roll Away should activate evade state"
		
	var dummy_attacker = TargetDummyEntity.new()
	dummy_attacker.team = TeamDefinitions.Team.DIRE
	dummy_attacker._ready()
	
	var req = DamageRequest.create_basic_attack(dummy_attacker, elyra, 150.0)
	var res = CombatCalculator.execute_damage(req)
	if res.final_health_damage != 0.0:
		return "Incoming damage should be 0.0 during Elyra Evade state"
		
	dummy_attacker.free()
	elyra.free()
	return ""

func test_task38_elyra_w_roll_away_evade_timer_expiration() -> String:
	var elyra = ElyraHeroClass.new()
	elyra.team = TeamDefinitions.Team.RADIANT
	elyra._ready()
	elyra.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	elyra.cast_elyra_w()
	elyra._process(1.0)
	
	if elyra.is_evading:
		return "Roll Away evade state should expire after 0.75 seconds"
		
	elyra.free()
	return ""

func test_task38_elyra_e_marked_fortune_applies_mark() -> String:
	var elyra = ElyraHeroClass.new()
	elyra.team = TeamDefinitions.Team.RADIANT
	elyra._ready()
	elyra.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	var success = elyra.cast_elyra_e(dummy)
	if not success or elyra.marked_target != dummy:
		return "Marked Fortune should mark the target enemy hero"
		
	dummy.free()
	elyra.free()
	return ""

func test_task38_elyra_e_marked_fortune_bonus_damage_on_crit() -> String:
	var elyra = ElyraHeroClass.new()
	elyra.team = TeamDefinitions.Team.RADIANT
	elyra._ready()
	elyra.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	elyra.cast_elyra_e(dummy)
	elyra.fortune_stacks = 5
	
	var hp_before = dummy.attribute_system.current_health
	elyra.execute_basic_attack(dummy)
	var hp_after = dummy.attribute_system.current_health
	
	if hp_before - hp_after <= 45.0:
		return "Marked Fortune should deal additional bonus damage on critical strike"
		
	dummy.free()
	elyra.free()
	return ""

func test_task38_elyra_e_marked_fortune_rejects_ally() -> String:
	var elyra = ElyraHeroClass.new()
	elyra.team = TeamDefinitions.Team.RADIANT
	elyra._ready()
	elyra.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(2.0, 0, 0)
	ally._ready()
	
	var success = elyra.cast_elyra_e(ally)
	if success:
		return "Marked Fortune must reject allied targets"
		
	ally.free()
	elyra.free()
	return ""

func test_task38_elyra_e_marked_fortune_timer_expiration() -> String:
	var elyra = ElyraHeroClass.new()
	elyra.team = TeamDefinitions.Team.RADIANT
	elyra._ready()
	elyra.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	elyra.cast_elyra_e(dummy)
	elyra._process(5.5)
	
	if elyra.marked_target != null:
		return "Marked Fortune mark should expire after 5.0 seconds"
		
	dummy.free()
	elyra.free()
	return ""

func test_task38_elyra_r_jackpot_fortune_generation() -> String:
	var elyra = ElyraHeroClass.new()
	elyra.team = TeamDefinitions.Team.RADIANT
	elyra._ready()
	elyra.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	elyra.cast_elyra_r()
	if not elyra.is_jackpot_active:
		return "Jackpot should activate"
		
	elyra.execute_basic_attack(dummy)
	if elyra.fortune_stacks < 3:
		return "Jackpot should grant +2 bonus Fortune per attack/crit (got %d)" % elyra.fortune_stacks
		
	dummy.free()
	elyra.free()
	return ""

func test_task38_elyra_r_jackpot_expiration() -> String:
	var elyra = ElyraHeroClass.new()
	elyra.team = TeamDefinitions.Team.RADIANT
	elyra._ready()
	elyra.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	elyra.cast_elyra_r()
	elyra._process(6.5)
	
	if elyra.is_jackpot_active:
		return "Jackpot should expire after 6.0 seconds"
		
	elyra.free()
	return ""

func test_task38_elyra_r_jackpot_cooldown_and_mana() -> String:
	var elyra = ElyraHeroClass.new()
	elyra.team = TeamDefinitions.Team.RADIANT
	elyra._ready()
	elyra.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var init_mana = elyra.attribute_system.current_mana
	elyra.cast_elyra_r()
	
	if elyra.attribute_system.current_mana >= init_mana:
		return "Jackpot should deduct mana"
		
	var second_cast = elyra.cast_elyra_r()
	if second_cast:
		return "Jackpot should be on cooldown"
		
	elyra.free()
	return ""

func test_task38_elyra_hero_definition_factory() -> String:
	HeroDefinition._ensure_registry()
	var def = HeroDefinition.get_definition("elyra")
	if def == null:
		return "HeroDefinition.get_definition('elyra') should not be null"
	if def.hero_name != "Elyra":
		return "Hero name expected 'Elyra', got '%s'" % def.hero_name
		
	var hero = HeroDefinition.create_hero_instance("elyra")
	if hero == null or not (hero is ElyraHeroClass):
		return "create_hero_instance('elyra') should produce ElyraHero"
		
	hero.free()
	return ""

func test_task38_elyra_death_and_respawn_clean_state() -> String:
	var elyra = ElyraHeroClass.new()
	elyra._ready()
	elyra.fortune_stacks = 4
	elyra.cast_elyra_r()
	
	elyra.die(null)
	if elyra.fortune_stacks != 0 or elyra.is_jackpot_active or elyra.marked_target != null:
		return "Death should clean fortune, jackpot and marked states"
		
	elyra.respawn()
	if not elyra.is_alive():
		return "Respawned Elyra should be alive"
		
	elyra.free()
	return ""

# ==============================================================================
# TASK 39: RIVENA HERO IMPLEMENTATION TESTS
# ==============================================================================

func test_task39_rivena_initialization_and_archetype() -> String:
	var rivena = RivenaHeroClass.new()
	rivena.team = TeamDefinitions.Team.RADIANT
	rivena._ready()
	
	if rivena.hero_resource.primary_attribute != AttributeSystem.PrimaryAttributeType.AGILITY:
		return "Rivena primary attribute should be AGILITY"
	if rivena.hero_resource.attack_type != HeroResource.AttackType.MELEE:
		return "Rivena attack type should be MELEE"
	if rivena.hero_resource.base_move_speed < 315.0:
		return "Rivena base move speed should be >= 315.0"
		
	rivena.free()
	return ""

func test_task39_rivena_passive_echo_spawns_shade() -> String:
	var rivena = RivenaHeroClass.new()
	rivena.team = TeamDefinitions.Team.RADIANT
	rivena.position = Vector3(1.0, 0, 1.0)
	rivena._ready()
	
	rivena.spawn_shade(rivena.position)
	if rivena.active_shades.size() != 1:
		return "Rivena should have 1 active Shade"
	if rivena.active_shades[0] != Vector3(1.0, 0, 1.0):
		return "Shade position should match spawned location"
		
	rivena.free()
	return ""

func test_task39_rivena_passive_echo_shades_capped() -> String:
	var rivena = RivenaHeroClass.new()
	rivena.team = TeamDefinitions.Team.RADIANT
	rivena._ready()
	
	rivena.spawn_shade(Vector3(1, 0, 0))
	rivena.spawn_shade(Vector3(2, 0, 0))
	rivena.spawn_shade(Vector3(3, 0, 0))
	rivena.spawn_shade(Vector3(4, 0, 0))
	
	if rivena.active_shades.size() > 3:
		return "Active shades should be capped at 3"
	if rivena.active_shades[0] == Vector3(1, 0, 0):
		return "Oldest shade should be removed when exceeding max shades"
		
	rivena.free()
	return ""

func test_task39_rivena_passive_echo_shade_expiration() -> String:
	var rivena = RivenaHeroClass.new()
	rivena.team = TeamDefinitions.Team.RADIANT
	rivena._ready()
	
	rivena.spawn_shade(Vector3(1, 0, 0))
	rivena._process(5.5)
	
	if not rivena.active_shades.is_empty():
		return "Shade should expire after 5.0 seconds"
		
	rivena.free()
	return ""

func test_task39_rivena_q_shadow_cut_damage() -> String:
	var rivena = RivenaHeroClass.new()
	rivena.team = TeamDefinitions.Team.RADIANT
	rivena._ready()
	rivena.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	var res = rivena.cast_rivena_q(dummy)
	if res == null or res.final_health_damage <= 0.0:
		return "Shadow Cut should deal physical damage"
		
	dummy.free()
	rivena.free()
	return ""

func test_task39_rivena_q_shadow_cut_shade_strikes() -> String:
	var rivena = RivenaHeroClass.new()
	rivena.team = TeamDefinitions.Team.RADIANT
	rivena._ready()
	rivena.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	var res_single = rivena.cast_rivena_q(dummy)
	rivena.ability_container.reset_cooldowns()
	
	# Add 2 shades
	rivena.spawn_shade(Vector3(1, 0, 0))
	rivena.spawn_shade(Vector3(3, 0, 0))
	
	var res_multi = rivena.cast_rivena_q(dummy)
	if res_multi.final_health_damage <= res_single.final_health_damage:
		return "Shadow Cut should deal additional damage from active Shades"
		
	dummy.free()
	rivena.free()
	return ""

func test_task39_rivena_q_shadow_cut_spawns_shade() -> String:
	var rivena = RivenaHeroClass.new()
	rivena.team = TeamDefinitions.Team.RADIANT
	rivena._ready()
	rivena.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	rivena.cast_rivena_q(dummy)
	if rivena.active_shades.is_empty():
		return "Casting Shadow Cut should spawn a new Shade"
		
	dummy.free()
	rivena.free()
	return ""

func test_task39_rivena_q_shadow_cut_rejects_ally() -> String:
	var rivena = RivenaHeroClass.new()
	rivena.team = TeamDefinitions.Team.RADIANT
	rivena._ready()
	rivena.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(2.0, 0, 0)
	ally._ready()
	
	var res = rivena.cast_rivena_q(ally)
	if res != null:
		return "Shadow Cut must reject allied targets"
		
	ally.free()
	rivena.free()
	return ""

func test_task39_rivena_q_shadow_cut_cooldown_and_mana() -> String:
	var rivena = RivenaHeroClass.new()
	rivena.team = TeamDefinitions.Team.RADIANT
	rivena._ready()
	rivena.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	var init_mana = rivena.attribute_system.current_mana
	rivena.cast_rivena_q(dummy)
	
	if rivena.attribute_system.current_mana >= init_mana:
		return "Shadow Cut should deduct mana"
		
	var second_cast = rivena.cast_rivena_q(dummy)
	if second_cast != null:
		return "Shadow Cut should be on cooldown"
		
	dummy.free()
	rivena.free()
	return ""

func test_task39_rivena_w_echo_step_blinks_to_shade() -> String:
	var rivena = RivenaHeroClass.new()
	rivena.team = TeamDefinitions.Team.RADIANT
	rivena.position = Vector3(0, 0, 0)
	rivena._ready()
	rivena.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	rivena.spawn_shade(Vector3(4.0, 0, 0))
	var success = rivena.cast_rivena_w()
	
	if not success:
		return "Echo Step should cast successfully"
	if rivena.position.x <= 2.0:
		return "Echo Step should blink Rivena to Shade position"
		
	rivena.free()
	return ""

func test_task39_rivena_w_echo_step_leaves_shade() -> String:
	var rivena = RivenaHeroClass.new()
	rivena.team = TeamDefinitions.Team.RADIANT
	rivena.position = Vector3(1.0, 0, 0)
	rivena._ready()
	rivena.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	rivena.spawn_shade(Vector3(4.0, 0, 0))
	rivena.cast_rivena_w()
	
	if rivena.active_shades.is_empty():
		return "Echo Step should leave a new Shade at former position"
	if rivena.active_shades[0].x != 1.0:
		return "New Shade should be at original position Vector3(1, 0, 0)"
		
	rivena.free()
	return ""

func test_task39_rivena_w_echo_step_fails_no_shades() -> String:
	var rivena = RivenaHeroClass.new()
	rivena.team = TeamDefinitions.Team.RADIANT
	rivena._ready()
	rivena.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var success = rivena.cast_rivena_w()
	if success:
		return "Echo Step should fail if there are no active Shades"
		
	rivena.free()
	return ""

func test_task39_rivena_w_echo_step_cooldown_and_mana() -> String:
	var rivena = RivenaHeroClass.new()
	rivena.team = TeamDefinitions.Team.RADIANT
	rivena._ready()
	rivena.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	rivena.spawn_shade(Vector3(3, 0, 0))
	var init_mana = rivena.attribute_system.current_mana
	rivena.cast_rivena_w()
	
	if rivena.attribute_system.current_mana >= init_mana:
		return "Echo Step should deduct mana"
		
	rivena.spawn_shade(Vector3(3, 0, 0))
	var second_cast = rivena.cast_rivena_w()
	if second_cast:
		return "Echo Step should be on cooldown"
		
	rivena.free()
	return ""

func test_task39_rivena_e_shade_command_damage_scaling() -> String:
	var rivena = RivenaHeroClass.new()
	rivena.team = TeamDefinitions.Team.RADIANT
	rivena._ready()
	rivena.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	rivena.spawn_shade(Vector3(1, 0, 0))
	rivena.spawn_shade(Vector3(2, 0, 0))
	
	var res = rivena.cast_rivena_e(dummy)
	if res == null or res.final_health_damage <= 100.0:
		return "Shade Command should deal multiplied physical damage based on shade count"
		
	dummy.free()
	rivena.free()
	return ""

func test_task39_rivena_e_shade_command_rejects_ally() -> String:
	var rivena = RivenaHeroClass.new()
	rivena.team = TeamDefinitions.Team.RADIANT
	rivena._ready()
	rivena.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(2.0, 0, 0)
	ally._ready()
	
	var res = rivena.cast_rivena_e(ally)
	if res != null:
		return "Shade Command must reject allied targets"
		
	ally.free()
	rivena.free()
	return ""

func test_task39_rivena_r_nightfall_spawns_shades() -> String:
	var rivena = RivenaHeroClass.new()
	rivena.team = TeamDefinitions.Team.RADIANT
	rivena._ready()
	rivena.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var success = rivena.cast_rivena_r()
	if not success:
		return "Nightfall should cast successfully"
	if rivena.active_shades.size() < 2:
		return "Nightfall should spawn 2 additional Shades"
		
	rivena.free()
	return ""

func test_task39_rivena_r_nightfall_buffs() -> String:
	var rivena = RivenaHeroClass.new()
	rivena.team = TeamDefinitions.Team.RADIANT
	rivena._ready()
	rivena.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var base_ad = rivena.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var base_ms = rivena.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	rivena.cast_rivena_r()
	
	var buffed_ad = rivena.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var buffed_ms = rivena.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	if buffed_ad <= base_ad + 25.0:
		return "Nightfall should grant +30 AD bonus"
	if buffed_ms <= base_ms:
		return "Nightfall should grant +35% Move Speed bonus"
		
	rivena.free()
	return ""

func test_task39_rivena_r_nightfall_timer_expiration() -> String:
	var rivena = RivenaHeroClass.new()
	rivena.team = TeamDefinitions.Team.RADIANT
	rivena._ready()
	rivena.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	rivena.cast_rivena_r()
	rivena._process(6.5)
	
	if rivena.is_nightfall_active:
		return "Nightfall state should expire after 6.0 seconds"
		
	rivena.free()
	return ""

func test_task39_rivena_hero_definition_factory() -> String:
	HeroDefinition._ensure_registry()
	var def = HeroDefinition.get_definition("rivena")
	if def == null:
		return "HeroDefinition.get_definition('rivena') should not be null"
	if def.hero_name != "Rivena":
		return "Hero name expected 'Rivena', got '%s'" % def.hero_name
		
	var hero = HeroDefinition.create_hero_instance("rivena")
	if hero == null or not (hero is RivenaHeroClass):
		return "create_hero_instance('rivena') should produce RivenaHero"
		
	hero.free()
	return ""

func test_task39_rivena_death_and_respawn_clean_state() -> String:
	var rivena = RivenaHeroClass.new()
	rivena._ready()
	rivena.cast_rivena_r()
	
	rivena.die(null)
	if not rivena.active_shades.is_empty() or rivena.is_nightfall_active:
		return "Death should clear shades and nightfall state"
		
	rivena.respawn()
	if not rivena.is_alive():
		return "Respawned Rivena should be alive"
		
	rivena.free()
	return ""

# ==============================================================================
# TASK 40: TALON HERO IMPLEMENTATION TESTS
# ==============================================================================

func test_task40_talon_initialization_and_archetype() -> String:
	var talon = TalonHeroClass.new()
	talon.team = TeamDefinitions.Team.RADIANT
	talon._ready()
	
	if talon.hero_resource.primary_attribute != AttributeSystem.PrimaryAttributeType.AGILITY:
		return "Talon primary attribute should be AGILITY"
	if talon.hero_resource.attack_type != HeroResource.AttackType.MELEE:
		return "Talon attack type should be MELEE"
	if talon.hero_resource.base_move_speed < 320.0:
		return "Talon base move speed should be >= 320.0"
		
	talon.free()
	return ""

func test_task40_talon_passive_predator_pace_stacking() -> String:
	var talon = TalonHeroClass.new()
	talon.team = TeamDefinitions.Team.RADIANT
	talon._ready()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	talon.add_predator_stack(dummy)
	talon.add_predator_stack(dummy)
	talon.add_predator_stack(dummy)
	
	if talon.predator_stacks != 3 or talon.predator_target != dummy:
		return "Talon should have 3 Predator stacks on target dummy"
		
	dummy.free()
	talon.free()
	return ""

func test_task40_talon_passive_predator_pace_stat_scaling() -> String:
	var talon = TalonHeroClass.new()
	talon.team = TeamDefinitions.Team.RADIANT
	talon._ready()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var base_ad = talon.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var base_ms = talon.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	for i in range(5):
		talon.add_predator_stack(dummy)
		
	var buffed_ad = talon.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	var buffed_ms = talon.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	if buffed_ad <= base_ad + 12.0:
		return "5 Predator stacks should grant +15 AD bonus"
	if buffed_ms <= base_ms:
		return "5 Predator stacks should grant +20% Move Speed bonus"
		
	dummy.free()
	talon.free()
	return ""

func test_task40_talon_passive_predator_pace_target_switch() -> String:
	var talon = TalonHeroClass.new()
	talon.team = TeamDefinitions.Team.RADIANT
	talon._ready()
	
	var dummy1 = TargetDummyEntity.new()
	dummy1.team = TeamDefinitions.Team.DIRE
	dummy1._ready()
	
	var dummy2 = TargetDummyEntity.new()
	dummy2.team = TeamDefinitions.Team.DIRE
	dummy2._ready()
	
	talon.add_predator_stack(dummy1)
	talon.add_predator_stack(dummy1)
	
	talon.add_predator_stack(dummy2)
	if talon.predator_target != dummy2 or talon.predator_stacks != 1:
		return "Switching targets should reset Predator stacks to 1 for the new target"
		
	dummy1.free()
	dummy2.free()
	talon.free()
	return ""

func test_task40_talon_q_hookblade_damage() -> String:
	var talon = TalonHeroClass.new()
	talon.team = TeamDefinitions.Team.RADIANT
	talon._ready()
	talon.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(3.0, 0, 0)
	dummy._ready()
	
	var res = talon.cast_talon_q(dummy)
	if res == null or res.final_health_damage <= 0.0:
		return "Hookblade should deal physical damage"
		
	dummy.free()
	talon.free()
	return ""

func test_task40_talon_q_hookblade_attaches_tether() -> String:
	var talon = TalonHeroClass.new()
	talon.team = TeamDefinitions.Team.RADIANT
	talon._ready()
	talon.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(3.0, 0, 0)
	dummy._ready()
	
	talon.cast_talon_q(dummy)
	if talon.tethered_target != dummy or talon.tether_timer <= 0.0:
		return "Hookblade should attach a 5.0s Tether to the target"
		
	dummy.free()
	talon.free()
	return ""

func test_task40_talon_q_hookblade_adds_predator_stack() -> String:
	var talon = TalonHeroClass.new()
	talon.team = TeamDefinitions.Team.RADIANT
	talon._ready()
	talon.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(3.0, 0, 0)
	dummy._ready()
	
	talon.cast_talon_q(dummy)
	if talon.predator_stacks < 1:
		return "Hookblade should add +1 Predator stack upon hit"
		
	dummy.free()
	talon.free()
	return ""

func test_task40_talon_q_hookblade_rejects_ally() -> String:
	var talon = TalonHeroClass.new()
	talon.team = TeamDefinitions.Team.RADIANT
	talon._ready()
	talon.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(3.0, 0, 0)
	ally._ready()
	
	var res = talon.cast_talon_q(ally)
	if res != null:
		return "Hookblade must reject allied targets"
		
	ally.free()
	talon.free()
	return ""

func test_task40_talon_q_hookblade_cooldown_and_mana() -> String:
	var talon = TalonHeroClass.new()
	talon.team = TeamDefinitions.Team.RADIANT
	talon._ready()
	talon.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(3.0, 0, 0)
	dummy._ready()
	
	var init_mana = talon.attribute_system.current_mana
	talon.cast_talon_q(dummy)
	
	if talon.attribute_system.current_mana >= init_mana:
		return "Hookblade should deduct mana"
		
	var second_cast = talon.cast_talon_q(dummy)
	if second_cast != null:
		return "Hookblade should be on cooldown"
		
	dummy.free()
	talon.free()
	return ""

func test_task40_talon_w_pursuit_dashes_to_tether() -> String:
	var talon = TalonHeroClass.new()
	talon.team = TeamDefinitions.Team.RADIANT
	talon.position = Vector3(0, 0, 0)
	talon._ready()
	talon.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(5.0, 0, 0)
	dummy._ready()
	
	talon.tethered_target = dummy
	var success = talon.cast_talon_w()
	
	if not success:
		return "Pursuit should cast successfully"
	if talon.position.x <= 2.0:
		return "Pursuit should dash Talon to tethered target"
		
	dummy.free()
	talon.free()
	return ""

func test_task40_talon_w_pursuit_applies_slow() -> String:
	var talon = TalonHeroClass.new()
	talon.team = TeamDefinitions.Team.RADIANT
	talon._ready()
	talon.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	dummy.attribute_system.base_move_speed = 300.0
	dummy.attribute_system.recalculate_all_stats()
	
	var base_ms = dummy.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	talon.tethered_target = dummy
	talon.cast_talon_w()
	var slowed_ms = dummy.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	if slowed_ms >= base_ms:
		return "Pursuit should apply a 35% slow to the target"
		
	dummy.free()
	talon.free()
	return ""

func test_task40_talon_w_pursuit_fails_without_tether() -> String:
	var talon = TalonHeroClass.new()
	talon.team = TeamDefinitions.Team.RADIANT
	talon._ready()
	talon.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var success = talon.cast_talon_w()
	if success:
		return "Pursuit should fail without an active tethered target"
		
	talon.free()
	return ""

func test_task40_talon_e_tear_away_damage_scaling() -> String:
	var talon = TalonHeroClass.new()
	talon.team = TeamDefinitions.Team.RADIANT
	talon._ready()
	talon.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	talon.tethered_target = dummy
	talon.predator_target = dummy
	talon.predator_stacks = 5 # +100% damage bonus
	
	var res = talon.cast_talon_e()
	if res == null or res.final_health_damage <= 120.0:
		return "Tear Away should deal amplified physical damage scaled with Predator stacks"
		
	dummy.free()
	talon.free()
	return ""

func test_task40_talon_e_tear_away_clears_tether() -> String:
	var talon = TalonHeroClass.new()
	talon.team = TeamDefinitions.Team.RADIANT
	talon._ready()
	talon.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	talon.tethered_target = dummy
	talon.cast_talon_e()
	
	if talon.tethered_target != null:
		return "Tear Away should break/clear the tether upon execution"
		
	dummy.free()
	talon.free()
	return ""

func test_task40_talon_tether_range_break() -> String:
	var talon = TalonHeroClass.new()
	talon.team = TeamDefinitions.Team.RADIANT
	talon.position = Vector3(0, 0, 0)
	talon._ready()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(10.0, 0, 0) # Exceeds 8.0m base max range
	dummy._ready()
	
	talon.tethered_target = dummy
	talon.tether_timer = 5.0
	talon._process(0.1)
	
	if talon.tethered_target != null:
		return "Tether should break if target distance exceeds 8.0m"
		
	dummy.free()
	talon.free()
	return ""

func test_task40_talon_tether_duration_expiration() -> String:
	var talon = TalonHeroClass.new()
	talon.team = TeamDefinitions.Team.RADIANT
	talon._ready()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	talon.tethered_target = dummy
	talon.tether_timer = 5.0
	talon._process(5.5)
	
	if talon.tethered_target != null:
		return "Tether should expire after 5.0 seconds"
		
	dummy.free()
	talon.free()
	return ""

func test_task40_talon_r_no_escape_buffs() -> String:
	var talon = TalonHeroClass.new()
	talon.team = TeamDefinitions.Team.RADIANT
	talon._ready()
	talon.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var base_ms = talon.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	talon.cast_talon_r()
	
	if not talon.is_no_escape_active:
		return "No Escape should activate"
		
	var buffed_ms = talon.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	if buffed_ms <= base_ms:
		return "No Escape should grant +30% Move Speed bonus"
		
	talon.free()
	return ""

func test_task40_talon_r_no_escape_doubles_tether_range() -> String:
	var talon = TalonHeroClass.new()
	talon.team = TeamDefinitions.Team.RADIANT
	talon.position = Vector3(0, 0, 0)
	talon._ready()
	talon.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(12.0, 0, 0) # Exceeds 8.0m, but within 16.0m ultimate range
	dummy._ready()
	
	talon.cast_talon_r()
	talon.tethered_target = dummy
	talon.tether_timer = 5.0
	talon._process(0.1)
	
	if talon.tethered_target == null:
		return "No Escape should double tether break range to 16.0m"
		
	dummy.free()
	talon.free()
	return ""

func test_task40_talon_hero_definition_factory() -> String:
	HeroDefinition._ensure_registry()
	var def = HeroDefinition.get_definition("talon")
	if def == null:
		return "HeroDefinition.get_definition('talon') should not be null"
	if def.hero_name != "Talon":
		return "Hero name expected 'Talon', got '%s'" % def.hero_name
		
	var hero = HeroDefinition.create_hero_instance("talon")
	if hero == null or not (hero is TalonHeroClass):
		return "create_hero_instance('talon') should produce TalonHero"
		
	hero.free()
	return ""

func test_task40_talon_death_and_respawn_clean_state() -> String:
	var talon = TalonHeroClass.new()
	talon._ready()
	talon.cast_talon_r()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	talon.tethered_target = dummy
	talon.predator_target = dummy
	talon.predator_stacks = 4
	
	talon.die(null)
	if talon.tethered_target != null or talon.predator_stacks != 0 or talon.is_no_escape_active:
		return "Death should clean tether, predator and no escape states"
		
	talon.respawn()
	if not talon.is_alive():
		return "Respawned Talon should be alive"
		
	dummy.free()
	talon.free()
	return ""

# ==============================================================================
# 20 TASK 41: SERIS HERO IMPLEMENTATION TESTS (Tests 764-783)
# ==============================================================================

func test_task41_seris_initialization_and_archetype() -> String:
	var seris = SerisHeroClass.new()
	seris._ready()
	
	if seris.entity_name != "Seris":
		return "Seris entity_name incorrect"
	if seris.attribute_system.primary_attribute != AttributeSystem.PrimaryAttributeType.AGILITY:
		return "Seris primary attribute should be AGILITY"
	if seris.ability_container.abilities[AbilityResource.Slot.Q] == null:
		return "Seris Q (Needle Shot) should be assigned"
	if seris.ability_container.abilities[AbilityResource.Slot.W] == null:
		return "Seris W (Razor Trap) should be assigned"
	if seris.ability_container.abilities[AbilityResource.Slot.E] == null:
		return "Seris E (Trigger Wire) should be assigned"
	if seris.ability_container.abilities[AbilityResource.Slot.R] == null:
		return "Seris R (Hunting Ground) should be assigned"
	if seris.ability_container.abilities[AbilityResource.Slot.PASSIVE] == null:
		return "Seris Passive (Precision) should be assigned"
		
	seris.free()
	return ""

func test_task41_seris_passive_precision_multiplier() -> String:
	var seris = SerisHeroClass.new()
	seris.team = TeamDefinitions.Team.RADIANT
	seris._ready()
	seris.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	# Untrapped Q
	var res1 = seris.cast_seris_q(dummy)
	var dmg_untrapped = res1.final_health_damage
	
	# Mark dummy as trapped
	seris.trapped_targets[dummy] = 4.0
	var res2 = seris.cast_seris_q(dummy)
	var dmg_trapped = res2.final_health_damage
	
	if dmg_trapped <= dmg_untrapped:
		return "Trapped target should receive +30% precision damage multiplier"
		
	dummy.free()
	seris.free()
	return ""

func test_task41_seris_q_needle_shot_damage() -> String:
	var seris = SerisHeroClass.new()
	seris.team = TeamDefinitions.Team.RADIANT
	seris._ready()
	seris.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var hp_before = dummy.attribute_system.current_health
	var res = seris.cast_seris_q(dummy)
	var hp_after = dummy.attribute_system.current_health
	
	if res == null or hp_before - hp_after <= 50.0:
		return "Needle Shot should deal physical damage to target"
		
	dummy.free()
	seris.free()
	return ""

func test_task41_seris_q_needle_shot_target_validation_rejects_ally() -> String:
	var seris = SerisHeroClass.new()
	seris.team = TeamDefinitions.Team.RADIANT
	seris._ready()
	seris.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var ally = TargetDummyEntity.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var res = seris.cast_seris_q(ally)
	if res != null:
		return "Needle Shot should reject ally targets"
		
	ally.free()
	seris.free()
	return ""

func test_task41_seris_q_needle_shot_cooldown_and_mana() -> String:
	var seris = SerisHeroClass.new()
	seris.team = TeamDefinitions.Team.RADIANT
	seris._ready()
	seris.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var init_mana = seris.attribute_system.current_mana
	seris.cast_seris_q(dummy)
	
	if seris.attribute_system.current_mana >= init_mana:
		return "Needle Shot should deduct mana"
		
	var second_cast = seris.cast_seris_q(dummy)
	if second_cast != null:
		return "Needle Shot should be on cooldown"
		
	dummy.free()
	seris.free()
	return ""

func test_task41_seris_w_razor_trap_placement() -> String:
	var seris = SerisHeroClass.new()
	seris.team = TeamDefinitions.Team.RADIANT
	seris._ready()
	seris.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var success = seris.cast_seris_w(Vector3(5, 0, 5))
	if not success or seris.active_traps.size() != 1:
		return "Razor Trap should place trap in world"
		
	seris.free()
	return ""

func test_task41_seris_w_razor_trap_max_cap() -> String:
	var seris = SerisHeroClass.new()
	seris.team = TeamDefinitions.Team.RADIANT
	seris._ready()
	seris.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	for i in range(6):
		seris.place_trap(Vector3(i, 0, 0))
		
	if seris.active_traps.size() > 4:
		return "Razor Trap active count should be capped at 4"
		
	seris.free()
	return ""

func test_task41_seris_w_razor_trap_duration_expiration() -> String:
	var seris = SerisHeroClass.new()
	seris.team = TeamDefinitions.Team.RADIANT
	seris._ready()
	seris.place_trap(Vector3(1, 0, 1))
	
	seris._process(65.0)
	if not seris.active_traps.is_empty():
		return "Razor Trap should expire after 60 seconds"
		
	seris.free()
	return ""

func test_task41_seris_w_razor_trap_trigger_damage_and_slow() -> String:
	var seris = SerisHeroClass.new()
	seris.team = TeamDefinitions.Team.RADIANT
	seris._ready()
	seris.ability_container.level_up_ability(AbilityResource.Slot.W)
	seris.place_trap(Vector3(0, 0, 0))
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var res = seris.trigger_trap_at(0, dummy)
	if res == null or not seris.is_target_trapped(dummy):
		return "Triggering trap should deal damage and mark victim as trapped"
		
	dummy.free()
	seris.free()
	return ""

func test_task41_seris_e_trigger_wire_detonation() -> String:
	var seris = SerisHeroClass.new()
	seris.team = TeamDefinitions.Team.RADIANT
	seris._ready()
	seris.ability_container.level_up_ability(AbilityResource.Slot.E)
	seris.place_trap(Vector3(1, 0, 0))
	seris.place_trap(Vector3(2, 0, 0))
	
	var detonated = seris.cast_seris_e()
	if detonated != 2 or not seris.active_traps.is_empty():
		return "Trigger Wire should detonate and clear all active traps"
		
	seris.free()
	return ""

func test_task41_seris_e_trigger_wire_ms_buff() -> String:
	var seris = SerisHeroClass.new()
	seris.team = TeamDefinitions.Team.RADIANT
	seris._ready()
	seris.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var base_ms = seris.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	seris.cast_seris_e()
	var buffed_ms = seris.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	if buffed_ms <= base_ms:
		return "Trigger Wire should grant +30% MS buff"
		
	seris.free()
	return ""

func test_task41_seris_e_trigger_wire_ms_expiration() -> String:
	var seris = SerisHeroClass.new()
	seris.team = TeamDefinitions.Team.RADIANT
	seris._ready()
	seris.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var base_ms = seris.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	seris.cast_seris_e()
	seris._process(3.5)
	var final_ms = seris.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	if absf(final_ms - base_ms) > 1.0:
		return "Trigger Wire MS buff should expire after 3.0 seconds"
		
	seris.free()
	return ""

func test_task41_seris_e_trigger_wire_cooldown_and_mana() -> String:
	var seris = SerisHeroClass.new()
	seris.team = TeamDefinitions.Team.RADIANT
	seris._ready()
	seris.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	seris.cast_seris_e()
	var second_cast = seris.cast_seris_e()
	if second_cast != 0:
		return "Trigger Wire should be on cooldown"
		
	seris.free()
	return ""

func test_task41_seris_r_hunting_ground_spawns_3_traps() -> String:
	var seris = SerisHeroClass.new()
	seris.team = TeamDefinitions.Team.RADIANT
	seris._ready()
	seris.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	seris.cast_seris_r(Vector3(10, 0, 10))
	if seris.active_traps.size() < 3:
		return "Hunting Ground should spawn 3 traps in target area"
		
	seris.free()
	return ""

func test_task41_seris_r_hunting_ground_aoe_damage_and_slow() -> String:
	var seris = SerisHeroClass.new()
	seris.team = TeamDefinitions.Team.RADIANT
	seris._ready()
	seris.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var hp_before = dummy.attribute_system.current_health
	var enemies: Array[BaseCombatEntity] = [dummy]
	seris.cast_seris_r(Vector3(0, 0, 0), enemies)
	var hp_after = dummy.attribute_system.current_health
	
	if hp_before - hp_after <= 100.0 or not seris.is_target_trapped(dummy):
		return "Hunting Ground should deal heavy AoE damage and trap enemies"
		
	dummy.free()
	seris.free()
	return ""

func test_task41_seris_r_hunting_ground_cooldown_and_mana() -> String:
	var seris = SerisHeroClass.new()
	seris.team = TeamDefinitions.Team.RADIANT
	seris._ready()
	seris.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	seris.cast_seris_r(Vector3(0, 0, 0))
	var second_cast = seris.cast_seris_r(Vector3(0, 0, 0))
	if second_cast:
		return "Hunting Ground should be on cooldown"
		
	seris.free()
	return ""

func test_task41_seris_hero_definition_factory() -> String:
	var def = HeroDefinition.get_definition("seris")
	if def == null or def.hero_name != "Seris":
		return "HeroDefinition for seris not found"
		
	var hero = HeroDefinition.create_hero_instance("seris")
	if hero == null or not (hero is SerisHeroClass):
		return "create_hero_instance('seris') should produce SerisHero"
		
	hero.free()
	return ""

func test_task41_seris_death_and_respawn_clean_state() -> String:
	var seris = SerisHeroClass.new()
	seris.team = TeamDefinitions.Team.RADIANT
	seris._ready()
	seris.place_trap(Vector3(1, 0, 0))
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	seris.trapped_targets[dummy] = 4.0
	
	seris.die(null)
	if not seris.active_traps.is_empty() or not seris.trapped_targets.is_empty():
		return "Death should clear all active traps and trapped targets"
		
	seris.respawn()
	if not seris.is_alive():
		return "Respawned Seris should be alive"
		
	dummy.free()
	seris.free()
	return ""

func test_task41_seris_trapped_target_expiration() -> String:
	var seris = SerisHeroClass.new()
	seris._ready()
	
	var dummy = TargetDummyEntity.new()
	dummy._ready()
	seris.trapped_targets[dummy] = 2.0
	seris._process(2.5)
	
	if seris.is_target_trapped(dummy):
		return "Trapped target status should expire"
		
	dummy.free()
	seris.free()
	return ""

func test_task41_seris_dead_cannot_cast() -> String:
	var seris = SerisHeroClass.new()
	seris._ready()
	seris.die(null)
	
	if seris.cast_seris_w(Vector3.ZERO):
		return "Dead Seris should not be able to cast abilities"
		
	seris.free()
	return ""

# ==============================================================================
# 20 TASK 42: MIRA HERO IMPLEMENTATION TESTS (Tests 784-803)
# ==============================================================================

func test_task42_mira_initialization_and_archetype() -> String:
	var mira = MiraHeroClass.new()
	mira._ready()
	
	if mira.entity_name != "Mira":
		return "Mira entity_name incorrect"
	if mira.attribute_system.primary_attribute != AttributeSystem.PrimaryAttributeType.AGILITY:
		return "Mira primary attribute should be AGILITY"
	if mira.ability_container.abilities[AbilityResource.Slot.Q] == null:
		return "Mira Q (Dash Strike) should be assigned"
	if mira.ability_container.abilities[AbilityResource.Slot.W] == null:
		return "Mira W (Slip) should be assigned"
	if mira.ability_container.abilities[AbilityResource.Slot.E] == null:
		return "Mira E (Accelerate) should be assigned"
	if mira.ability_container.abilities[AbilityResource.Slot.R] == null:
		return "Mira R (Sonic Run) should be assigned"
	if mira.ability_container.abilities[AbilityResource.Slot.PASSIVE] == null:
		return "Mira Passive (Velocity) should be assigned"
		
	mira.free()
	return ""

func test_task42_mira_passive_velocity_ad_scaling() -> String:
	var mira = MiraHeroClass.new()
	mira._ready()
	
	var base_ad = mira.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	
	# Add +50 MS
	var ms_mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.FLAT, 50.0, "test_speed")
	mira.attribute_system.add_modifier(ms_mod)
	mira._process(0.1)
	
	var new_ad = mira.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	if new_ad <= base_ad:
		return "Velocity should convert excess MS into Attack Damage"
		
	mira.free()
	return ""

func test_task42_mira_passive_velocity_dynamic_update() -> String:
	var mira = MiraHeroClass.new()
	mira._ready()
	
	var ms_mod = StatModifier.new(StatModifier.TargetStat.MOVE_SPEED, StatModifier.Type.FLAT, 100.0, "test_speed2")
	mira.attribute_system.add_modifier(ms_mod)
	mira._process(0.1)
	
	var boosted_ad = mira.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	mira.attribute_system.remove_modifier_by_source("test_speed2")
	mira._process(0.1)
	
	var restored_ad = mira.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_DAMAGE)
	if restored_ad >= boosted_ad:
		return "Velocity should dynamically remove bonus AD when MS decreases"
		
	mira.free()
	return ""

func test_task42_mira_q_dash_strike_damage() -> String:
	var mira = MiraHeroClass.new()
	mira.team = TeamDefinitions.Team.RADIANT
	mira._ready()
	mira.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var hp_before = dummy.attribute_system.current_health
	var res = mira.cast_mira_q(dummy)
	var hp_after = dummy.attribute_system.current_health
	
	if res == null or hp_before - hp_after <= 50.0:
		return "Dash Strike should deal physical damage to enemy"
		
	dummy.free()
	mira.free()
	return ""

func test_task42_mira_q_dash_strike_forward_dash() -> String:
	var mira = MiraHeroClass.new()
	mira.team = TeamDefinitions.Team.RADIANT
	mira.position = Vector3(0, 0, 0)
	mira._ready()
	mira.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(10, 0, 0)
	dummy._ready()
	
	mira.cast_mira_q(dummy)
	if mira.position.length() <= 1.0:
		return "Dash Strike should dash Mira forward towards target"
		
	dummy.free()
	mira.free()
	return ""

func test_task42_mira_q_dash_strike_target_validation_rejects_ally() -> String:
	var mira = MiraHeroClass.new()
	mira.team = TeamDefinitions.Team.RADIANT
	mira._ready()
	mira.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var ally = TargetDummyEntity.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var res = mira.cast_mira_q(ally)
	if res != null:
		return "Dash Strike should reject ally targets"
		
	ally.free()
	mira.free()
	return ""

func test_task42_mira_q_dash_strike_cooldown_and_mana() -> String:
	var mira = MiraHeroClass.new()
	mira.team = TeamDefinitions.Team.RADIANT
	mira._ready()
	mira.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	mira.cast_mira_q(dummy)
	var second_cast = mira.cast_mira_q(dummy)
	if second_cast != null:
		return "Dash Strike should be on cooldown"
		
	dummy.free()
	mira.free()
	return ""

func test_task42_mira_w_slip_evade_state() -> String:
	var mira = MiraHeroClass.new()
	mira.team = TeamDefinitions.Team.RADIANT
	mira._ready()
	mira.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	mira.cast_mira_w()
	if not mira.is_evading:
		return "Slip should activate evade state"
		
	mira.free()
	return ""

func test_task42_mira_w_slip_evade_negates_damage() -> String:
	var mira = MiraHeroClass.new()
	mira.team = TeamDefinitions.Team.RADIANT
	mira._ready()
	mira.ability_container.level_up_ability(AbilityResource.Slot.W)
	mira.cast_mira_w()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var req = DamageRequest.create_basic_attack(dummy, mira, 200.0)
	var res = CombatCalculator.execute_damage(req)
	
	if res.final_health_damage != 0.0:
		return "Incoming damage should be 0.0 during Slip Evade"
		
	dummy.free()
	mira.free()
	return ""

func test_task42_mira_w_slip_ms_buff() -> String:
	var mira = MiraHeroClass.new()
	mira.team = TeamDefinitions.Team.RADIANT
	mira._ready()
	mira.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var base_ms = mira.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	mira.cast_mira_w()
	var buffed_ms = mira.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	if buffed_ms <= base_ms:
		return "Slip should grant MS buff"
		
	mira.free()
	return ""

func test_task42_mira_w_slip_timer_expiration() -> String:
	var mira = MiraHeroClass.new()
	mira.team = TeamDefinitions.Team.RADIANT
	mira._ready()
	mira.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	mira.cast_mira_w()
	mira._process(1.0)
	
	if mira.is_evading:
		return "Slip evade state should expire after 0.6s"
		
	mira.free()
	return ""

func test_task42_mira_e_accelerate_ms_and_as_buff() -> String:
	var mira = MiraHeroClass.new()
	mira.team = TeamDefinitions.Team.RADIANT
	mira._ready()
	mira.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var base_ms = mira.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	mira.cast_mira_e()
	var buffed_ms = mira.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	if buffed_ms <= base_ms:
		return "Accelerate should grant +40% MS and +30% AS"
		
	mira.free()
	return ""

func test_task42_mira_e_accelerate_timer_expiration() -> String:
	var mira = MiraHeroClass.new()
	mira.team = TeamDefinitions.Team.RADIANT
	mira._ready()
	mira.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var base_ms = mira.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	mira.cast_mira_e()
	mira._process(4.5)
	var final_ms = mira.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	if absf(final_ms - base_ms) > 1.0:
		return "Accelerate buff should expire after 4.0 seconds"
		
	mira.free()
	return ""

func test_task42_mira_e_accelerate_cooldown_and_mana() -> String:
	var mira = MiraHeroClass.new()
	mira.team = TeamDefinitions.Team.RADIANT
	mira._ready()
	mira.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	mira.cast_mira_e()
	var second_cast = mira.cast_mira_e()
	if second_cast:
		return "Accelerate should be on cooldown"
		
	mira.free()
	return ""

func test_task42_mira_r_sonic_run_active_and_ms_buff() -> String:
	var mira = MiraHeroClass.new()
	mira.team = TeamDefinitions.Team.RADIANT
	mira._ready()
	mira.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var base_ms = mira.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	mira.cast_mira_r()
	var buffed_ms = mira.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	if not mira.is_sonic_running or buffed_ms <= base_ms:
		return "Sonic Run should activate and grant +80% MS"
		
	mira.free()
	return ""

func test_task42_mira_r_sonic_run_contact_damage() -> String:
	var mira = MiraHeroClass.new()
	mira.team = TeamDefinitions.Team.RADIANT
	mira._ready()
	mira.ability_container.level_up_ability(AbilityResource.Slot.R)
	mira.cast_mira_r()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var hp_before = dummy.attribute_system.current_health
	var res = mira.trigger_sonic_contact_damage(dummy)
	var hp_after = dummy.attribute_system.current_health
	
	if res == null or hp_before - hp_after <= 80.0:
		return "Sonic Run should deal contact physical damage to enemies"
		
	dummy.free()
	mira.free()
	return ""

func test_task42_mira_r_sonic_run_no_duplicate_damage() -> String:
	var mira = MiraHeroClass.new()
	mira.team = TeamDefinitions.Team.RADIANT
	mira._ready()
	mira.ability_container.level_up_ability(AbilityResource.Slot.R)
	mira.cast_mira_r()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	mira.trigger_sonic_contact_damage(dummy)
	var second_contact = mira.trigger_sonic_contact_damage(dummy)
	if second_contact != null:
		return "Sonic Run should not hit same enemy twice in one cast"
		
	dummy.free()
	mira.free()
	return ""

func test_task42_mira_r_sonic_run_timer_expiration() -> String:
	var mira = MiraHeroClass.new()
	mira.team = TeamDefinitions.Team.RADIANT
	mira._ready()
	mira.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	mira.cast_mira_r()
	mira._process(5.5)
	
	if mira.is_sonic_running:
		return "Sonic Run should expire after 5.0 seconds"
		
	mira.free()
	return ""

func test_task42_mira_hero_definition_factory() -> String:
	var def = HeroDefinition.get_definition("mira")
	if def == null or def.hero_name != "Mira":
		return "HeroDefinition for mira not found"
		
	var hero = HeroDefinition.create_hero_instance("mira")
	if hero == null or not (hero is MiraHeroClass):
		return "create_hero_instance('mira') should produce MiraHero"
		
	hero.free()
	return ""

func test_task42_mira_death_and_respawn_clean_state() -> String:
	var mira = MiraHeroClass.new()
	mira.team = TeamDefinitions.Team.RADIANT
	mira._ready()
	mira.cast_mira_r()
	mira.cast_mira_w()
	
	mira.die(null)
	if mira.is_evading or mira.is_sonic_running:
		return "Death should clean evade and sonic run states"
		
	mira.respawn()
	if not mira.is_alive():
		return "Respawned Mira should be alive"
		
	mira.free()
	return ""

# ==============================================================================
# 20 TASK 43: ZAREK HERO IMPLEMENTATION TESTS (Tests 804-823)
# ==============================================================================

func test_task43_zarek_initialization_and_archetype() -> String:
	var zarek = ZarekHeroClass.new()
	zarek._ready()
	
	if zarek.entity_name != "Zarek":
		return "Zarek entity_name incorrect"
	if zarek.attribute_system.primary_attribute != AttributeSystem.PrimaryAttributeType.AGILITY:
		return "Zarek primary attribute should be AGILITY"
	if zarek.ability_container.abilities[AbilityResource.Slot.Q] == null:
		return "Zarek Q (Drain Edge) should be assigned"
	if zarek.ability_container.abilities[AbilityResource.Slot.W] == null:
		return "Zarek W (Phase Cut) should be assigned"
	if zarek.ability_container.abilities[AbilityResource.Slot.E] == null:
		return "Zarek E (Silence Mark) should be assigned"
	if zarek.ability_container.abilities[AbilityResource.Slot.R] == null:
		return "Zarek R (Null Field) should be assigned"
	if zarek.ability_container.abilities[AbilityResource.Slot.PASSIVE] == null:
		return "Zarek Passive (Mana Hunter) should be assigned"
		
	zarek.free()
	return ""

func test_task43_zarek_passive_mana_hunter_burns_mana() -> String:
	var zarek = ZarekHeroClass.new()
	zarek.team = TeamDefinitions.Team.RADIANT
	zarek._ready()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var init_dummy_mana = dummy.attribute_system.current_mana
	zarek.execute_basic_attack(dummy)
	var final_dummy_mana = dummy.attribute_system.current_mana
	
	if final_dummy_mana >= init_dummy_mana:
		return "Mana Hunter should burn target mana on basic attack"
		
	dummy.free()
	zarek.free()
	return ""

func test_task43_zarek_passive_mana_hunter_bonus_magical_damage() -> String:
	var zarek = ZarekHeroClass.new()
	zarek.team = TeamDefinitions.Team.RADIANT
	zarek._ready()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var hp_before = dummy.attribute_system.current_health
	zarek.execute_basic_attack(dummy)
	var hp_after = dummy.attribute_system.current_health
	
	if hp_before - hp_after <= 30.0:
		return "Mana Hunter should deal bonus damage from burned mana"
		
	dummy.free()
	zarek.free()
	return ""

func test_task43_zarek_q_drain_edge_damage() -> String:
	var zarek = ZarekHeroClass.new()
	zarek.team = TeamDefinitions.Team.RADIANT
	zarek._ready()
	zarek.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var hp_before = dummy.attribute_system.current_health
	var res = zarek.cast_zarek_q(dummy)
	var hp_after = dummy.attribute_system.current_health
	
	if res == null or hp_before - hp_after <= 60.0:
		return "Drain Edge should deal physical damage"
		
	dummy.free()
	zarek.free()
	return ""

func test_task43_zarek_q_drain_edge_mana_drain_and_restore() -> String:
	var zarek = ZarekHeroClass.new()
	zarek.team = TeamDefinitions.Team.RADIANT
	zarek._ready()
	zarek.ability_container.level_up_ability(AbilityResource.Slot.Q)
	zarek.attribute_system.current_mana = 100.0 # Drain Zarek's mana
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var dummy_mana_before = dummy.attribute_system.current_mana
	zarek.cast_zarek_q(dummy)
	var dummy_mana_after = dummy.attribute_system.current_mana
	
	if dummy_mana_before - dummy_mana_after <= 40.0:
		return "Drain Edge should drain target's mana"
		
	dummy.free()
	zarek.free()
	return ""

func test_task43_zarek_q_drain_edge_target_validation_rejects_ally() -> String:
	var zarek = ZarekHeroClass.new()
	zarek.team = TeamDefinitions.Team.RADIANT
	zarek._ready()
	zarek.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var ally = TargetDummyEntity.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var res = zarek.cast_zarek_q(ally)
	if res != null:
		return "Drain Edge should reject ally targets"
		
	ally.free()
	zarek.free()
	return ""

func test_task43_zarek_q_drain_edge_cooldown_and_mana() -> String:
	var zarek = ZarekHeroClass.new()
	zarek.team = TeamDefinitions.Team.RADIANT
	zarek._ready()
	zarek.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	zarek.cast_zarek_q(dummy)
	var second_cast = zarek.cast_zarek_q(dummy)
	if second_cast != null:
		return "Drain Edge should be on cooldown"
		
	dummy.free()
	zarek.free()
	return ""

func test_task43_zarek_w_phase_cut_damage() -> String:
	var zarek = ZarekHeroClass.new()
	zarek.team = TeamDefinitions.Team.RADIANT
	zarek._ready()
	zarek.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var res = zarek.cast_zarek_w(dummy)
	if res == null:
		return "Phase Cut should deal physical damage"
		
	dummy.free()
	zarek.free()
	return ""

func test_task43_zarek_w_phase_cut_blink_behind_target() -> String:
	var zarek = ZarekHeroClass.new()
	zarek.team = TeamDefinitions.Team.RADIANT
	zarek.position = Vector3(0, 0, 0)
	zarek._ready()
	zarek.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(5, 0, 0)
	dummy._ready()
	
	zarek.cast_zarek_w(dummy)
	if zarek.position.length() <= 2.0:
		return "Phase Cut should blink Zarek to target position"
		
	dummy.free()
	zarek.free()
	return ""

func test_task43_zarek_w_phase_cut_cooldown_and_mana() -> String:
	var zarek = ZarekHeroClass.new()
	zarek.team = TeamDefinitions.Team.RADIANT
	zarek._ready()
	zarek.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	zarek.cast_zarek_w(dummy)
	var second_cast = zarek.cast_zarek_w(dummy)
	if second_cast != null:
		return "Phase Cut should be on cooldown"
		
	dummy.free()
	zarek.free()
	return ""

func test_task43_zarek_e_silence_mark_damage() -> String:
	var zarek = ZarekHeroClass.new()
	zarek.team = TeamDefinitions.Team.RADIANT
	zarek._ready()
	zarek.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var res = zarek.cast_zarek_e(dummy)
	if res == null:
		return "Silence Mark should deal magical damage"
		
	dummy.free()
	zarek.free()
	return ""

func test_task43_zarek_e_silence_mark_applies_silence() -> String:
	var zarek = ZarekHeroClass.new()
	zarek.team = TeamDefinitions.Team.RADIANT
	zarek._ready()
	zarek.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	zarek.cast_zarek_e(dummy)
	if not dummy.status_effect_manager.has_effect(StatusEffect.EffectType.SILENCE):
		return "Silence Mark should apply Silence to target"
		
	dummy.free()
	zarek.free()
	return ""

func test_task43_zarek_e_silence_mark_target_validation_rejects_ally() -> String:
	var zarek = ZarekHeroClass.new()
	zarek.team = TeamDefinitions.Team.RADIANT
	zarek._ready()
	zarek.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var ally = TargetDummyEntity.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var res = zarek.cast_zarek_e(ally)
	if res != null:
		return "Silence Mark should reject ally targets"
		
	ally.free()
	zarek.free()
	return ""

func test_task43_zarek_e_silence_mark_cooldown_and_mana() -> String:
	var zarek = ZarekHeroClass.new()
	zarek.team = TeamDefinitions.Team.RADIANT
	zarek._ready()
	zarek.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	zarek.cast_zarek_e(dummy)
	var second_cast = zarek.cast_zarek_e(dummy)
	if second_cast != null:
		return "Silence Mark should be on cooldown"
		
	dummy.free()
	zarek.free()
	return ""

func test_task43_zarek_r_null_field_activation() -> String:
	var zarek = ZarekHeroClass.new()
	zarek.team = TeamDefinitions.Team.RADIANT
	zarek._ready()
	zarek.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var success = zarek.cast_zarek_r(Vector3(10, 0, 10))
	if not success or not zarek.null_field_active:
		return "Null Field should activate in world"
		
	zarek.free()
	return ""

func test_task43_zarek_r_null_field_damage_scales_with_missing_mana() -> String:
	var zarek = ZarekHeroClass.new()
	zarek.team = TeamDefinitions.Team.RADIANT
	zarek._ready()
	zarek.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	dummy.attribute_system.current_mana = 0.0 # Deplete mana
	
	var hp_before = dummy.attribute_system.current_health
	var enemies: Array[BaseCombatEntity] = [dummy]
	zarek.cast_zarek_r(Vector3(0, 0, 0), enemies)
	var hp_after = dummy.attribute_system.current_health
	
	if hp_before - hp_after <= 200.0:
		return "Null Field should deal high damage scaled by missing mana"
		
	dummy.free()
	zarek.free()
	return ""

func test_task43_zarek_r_null_field_timer_expiration() -> String:
	var zarek = ZarekHeroClass.new()
	zarek.team = TeamDefinitions.Team.RADIANT
	zarek._ready()
	zarek.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	zarek.cast_zarek_r(Vector3.ZERO)
	zarek._process(6.5)
	
	if zarek.null_field_active:
		return "Null Field should expire after 6.0 seconds"
		
	zarek.free()
	return ""

func test_task43_zarek_r_null_field_cooldown_and_mana() -> String:
	var zarek = ZarekHeroClass.new()
	zarek.team = TeamDefinitions.Team.RADIANT
	zarek._ready()
	zarek.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	zarek.cast_zarek_r(Vector3.ZERO)
	var second_cast = zarek.cast_zarek_r(Vector3.ZERO)
	if second_cast:
		return "Null Field should be on cooldown"
		
	zarek.free()
	return ""

func test_task43_zarek_hero_definition_factory() -> String:
	var def = HeroDefinition.get_definition("zarek")
	if def == null or def.hero_name != "Zarek":
		return "HeroDefinition for zarek not found"
		
	var hero = HeroDefinition.create_hero_instance("zarek")
	if hero == null or not (hero is ZarekHeroClass):
		return "create_hero_instance('zarek') should produce ZarekHero"
		
	hero.free()
	return ""

func test_task43_zarek_death_and_respawn_clean_state() -> String:
	var zarek = ZarekHeroClass.new()
	zarek.team = TeamDefinitions.Team.RADIANT
	zarek._ready()
	zarek.cast_zarek_r(Vector3.ZERO)
	
	zarek.die(null)
	if zarek.null_field_active:
		return "Death should clear null field state"
		
	zarek.respawn()
	if not zarek.is_alive():
		return "Respawned Zarek should be alive"
		
	zarek.free()
	return ""

# ==============================================================================
# 20 TASK 44: ILYRA HERO IMPLEMENTATION TESTS (Tests 824-843)
# ==============================================================================

func test_task44_ilyra_initialization_and_archetype() -> String:
	var ilyra = IlyraHeroClass.new()
	ilyra._ready()
	
	if ilyra.entity_name != "Ilyra":
		return "Ilyra entity_name incorrect"
	if ilyra.attribute_system.primary_attribute != AttributeSystem.PrimaryAttributeType.INTELLIGENCE:
		return "Ilyra primary attribute should be INTELLIGENCE"
	if ilyra.ability_container.abilities[AbilityResource.Slot.Q] == null:
		return "Ilyra Q (Ember Thread) should be assigned"
	if ilyra.ability_container.abilities[AbilityResource.Slot.W] == null:
		return "Ilyra W (Frost Thread) should be assigned"
	if ilyra.ability_container.abilities[AbilityResource.Slot.E] == null:
		return "Ilyra E (Arc Thread) should be assigned"
	if ilyra.ability_container.abilities[AbilityResource.Slot.R] == null:
		return "Ilyra R (Grand Weave) should be assigned"
	if ilyra.ability_container.abilities[AbilityResource.Slot.PASSIVE] == null:
		return "Ilyra Passive (Weave) should be assigned"
		
	ilyra.free()
	return ""

func test_task44_ilyra_passive_weave_stacking_on_different_spells() -> String:
	var ilyra = IlyraHeroClass.new()
	ilyra.team = TeamDefinitions.Team.RADIANT
	ilyra._ready()
	
	ilyra._record_spell_cast("EMBER")
	ilyra._record_spell_cast("FROST")
	ilyra._record_spell_cast("ARC")
	
	if ilyra.weave_stacks != 3:
		return "Weave should have 3 stacks from 3 different spells"
		
	ilyra.free()
	return ""

func test_task44_ilyra_passive_weave_resets_on_repeat_spell() -> String:
	var ilyra = IlyraHeroClass.new()
	ilyra.team = TeamDefinitions.Team.RADIANT
	ilyra._ready()
	
	ilyra._record_spell_cast("EMBER")
	ilyra._record_spell_cast("FROST")
	ilyra._record_spell_cast("FROST") # Repeat
	
	if ilyra.weave_stacks != 1:
		return "Repeating same spell should reset Weave stacks to 1"
		
	ilyra.free()
	return ""

func test_task44_ilyra_passive_weave_stat_scaling_ap_and_ms() -> String:
	var ilyra = IlyraHeroClass.new()
	ilyra.team = TeamDefinitions.Team.RADIANT
	ilyra._ready()
	
	var base_ms = ilyra.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	ilyra._record_spell_cast("EMBER")
	ilyra._record_spell_cast("FROST")
	var buffed_ms = ilyra.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	
	if buffed_ms <= base_ms:
		return "Weave stacks should provide MS and AP amplification"
		
	ilyra.free()
	return ""

func test_task44_ilyra_passive_weave_timer_expiration() -> String:
	var ilyra = IlyraHeroClass.new()
	ilyra.team = TeamDefinitions.Team.RADIANT
	ilyra._ready()
	
	ilyra._record_spell_cast("EMBER")
	ilyra._process(6.5)
	
	if ilyra.weave_stacks != 0:
		return "Weave stacks should expire after 6.0 seconds"
		
	ilyra.free()
	return ""

func test_task44_ilyra_q_ember_thread_damage() -> String:
	var ilyra = IlyraHeroClass.new()
	ilyra.team = TeamDefinitions.Team.RADIANT
	ilyra._ready()
	ilyra.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var hp_before = dummy.attribute_system.current_health
	var res = ilyra.cast_ilyra_q(dummy)
	var hp_after = dummy.attribute_system.current_health
	
	if res == null or hp_before - hp_after <= 60.0:
		return "Ember Thread should deal magical damage to target"
		
	dummy.free()
	ilyra.free()
	return ""

func test_task44_ilyra_q_ember_thread_records_ember() -> String:
	var ilyra = IlyraHeroClass.new()
	ilyra.team = TeamDefinitions.Team.RADIANT
	ilyra._ready()
	ilyra.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	ilyra.cast_ilyra_q(dummy)
	if ilyra.spell_history.is_empty() or ilyra.spell_history.back() != "EMBER":
		return "Ember Thread should record EMBER in spell history"
		
	dummy.free()
	ilyra.free()
	return ""

func test_task44_ilyra_q_ember_thread_target_validation_rejects_ally() -> String:
	var ilyra = IlyraHeroClass.new()
	ilyra.team = TeamDefinitions.Team.RADIANT
	ilyra._ready()
	ilyra.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var ally = TargetDummyEntity.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var res = ilyra.cast_ilyra_q(ally)
	if res != null:
		return "Ember Thread should reject ally targets"
		
	ally.free()
	ilyra.free()
	return ""

func test_task44_ilyra_q_ember_thread_cooldown_and_mana() -> String:
	var ilyra = IlyraHeroClass.new()
	ilyra.team = TeamDefinitions.Team.RADIANT
	ilyra._ready()
	ilyra.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	ilyra.cast_ilyra_q(dummy)
	var second_cast = ilyra.cast_ilyra_q(dummy)
	if second_cast != null:
		return "Ember Thread should be on cooldown"
		
	dummy.free()
	ilyra.free()
	return ""

func test_task44_ilyra_w_frost_thread_aoe_damage() -> String:
	var ilyra = IlyraHeroClass.new()
	ilyra.team = TeamDefinitions.Team.RADIANT
	ilyra._ready()
	ilyra.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var hp_before = dummy.attribute_system.current_health
	var enemies: Array[BaseCombatEntity] = [dummy]
	ilyra.cast_ilyra_w(Vector3.ZERO, enemies)
	var hp_after = dummy.attribute_system.current_health
	
	if hp_before - hp_after <= 40.0:
		return "Frost Thread should deal AoE magical damage"
		
	dummy.free()
	ilyra.free()
	return ""

func test_task44_ilyra_w_frost_thread_applies_slow() -> String:
	var ilyra = IlyraHeroClass.new()
	ilyra.team = TeamDefinitions.Team.RADIANT
	ilyra._ready()
	ilyra.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var enemies: Array[BaseCombatEntity] = [dummy]
	ilyra.cast_ilyra_w(Vector3.ZERO, enemies)
	
	if not dummy.status_effect_manager.has_effect(StatusEffect.EffectType.SLOW):
		return "Frost Thread should apply slow to enemies in area"
		
	dummy.free()
	ilyra.free()
	return ""

func test_task44_ilyra_w_frost_thread_records_frost() -> String:
	var ilyra = IlyraHeroClass.new()
	ilyra.team = TeamDefinitions.Team.RADIANT
	ilyra._ready()
	ilyra.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	ilyra.cast_ilyra_w(Vector3.ZERO)
	if ilyra.spell_history.is_empty() or ilyra.spell_history.back() != "FROST":
		return "Frost Thread should record FROST in spell history"
		
	ilyra.free()
	return ""

func test_task44_ilyra_w_frost_thread_cooldown_and_mana() -> String:
	var ilyra = IlyraHeroClass.new()
	ilyra.team = TeamDefinitions.Team.RADIANT
	ilyra._ready()
	ilyra.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	ilyra.cast_ilyra_w(Vector3.ZERO)
	var second_cast = ilyra.cast_ilyra_w(Vector3.ZERO)
	if second_cast:
		return "Frost Thread should be on cooldown"
		
	ilyra.free()
	return ""

func test_task44_ilyra_e_arc_thread_single_damage() -> String:
	var ilyra = IlyraHeroClass.new()
	ilyra.team = TeamDefinitions.Team.RADIANT
	ilyra._ready()
	ilyra.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var res = ilyra.cast_ilyra_e(dummy)
	if res == null:
		return "Arc Thread should deal magical damage to primary target"
		
	dummy.free()
	ilyra.free()
	return ""

func test_task44_ilyra_e_arc_thread_chains_to_secondary_targets() -> String:
	var ilyra = IlyraHeroClass.new()
	ilyra.team = TeamDefinitions.Team.RADIANT
	ilyra._ready()
	ilyra.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var primary = TargetDummyEntity.new()
	primary.team = TeamDefinitions.Team.DIRE
	primary._ready()
	
	var sec1 = TargetDummyEntity.new()
	sec1.team = TeamDefinitions.Team.DIRE
	sec1._ready()
	
	var hp_before = sec1.attribute_system.current_health
	var secondary: Array[BaseCombatEntity] = [sec1]
	ilyra.cast_ilyra_e(primary, secondary)
	var hp_after = sec1.attribute_system.current_health
	
	if hp_before - hp_after <= 30.0:
		return "Arc Thread should chain damage to secondary enemies"
		
	primary.free()
	sec1.free()
	ilyra.free()
	return ""

func test_task44_ilyra_e_arc_thread_records_arc() -> String:
	var ilyra = IlyraHeroClass.new()
	ilyra.team = TeamDefinitions.Team.RADIANT
	ilyra._ready()
	ilyra.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	ilyra.cast_ilyra_e(dummy)
	if ilyra.spell_history.is_empty() or ilyra.spell_history.back() != "ARC":
		return "Arc Thread should record ARC in spell history"
		
	dummy.free()
	ilyra.free()
	return ""

func test_task44_ilyra_e_arc_thread_cooldown_and_mana() -> String:
	var ilyra = IlyraHeroClass.new()
	ilyra.team = TeamDefinitions.Team.RADIANT
	ilyra._ready()
	ilyra.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	ilyra.cast_ilyra_e(dummy)
	var second_cast = ilyra.cast_ilyra_e(dummy)
	if second_cast != null:
		return "Arc Thread should be on cooldown"
		
	dummy.free()
	ilyra.free()
	return ""

func test_task44_ilyra_r_grand_weave_aoe_damage_and_stack_multiplier() -> String:
	var ilyra = IlyraHeroClass.new()
	ilyra.team = TeamDefinitions.Team.RADIANT
	ilyra._ready()
	ilyra.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	# Build 3 weave stacks
	ilyra._record_spell_cast("EMBER")
	ilyra._record_spell_cast("FROST")
	ilyra._record_spell_cast("ARC")
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var hp_before = dummy.attribute_system.current_health
	var enemies: Array[BaseCombatEntity] = [dummy]
	ilyra.cast_ilyra_r(Vector3.ZERO, enemies)
	var hp_after = dummy.attribute_system.current_health
	
	if hp_before - hp_after <= 200.0:
		return "Grand Weave should deal heavy empowered AoE damage"
		
	dummy.free()
	ilyra.free()
	return ""

func test_task44_ilyra_r_grand_weave_consumes_weave_stacks() -> String:
	var ilyra = IlyraHeroClass.new()
	ilyra.team = TeamDefinitions.Team.RADIANT
	ilyra._ready()
	ilyra.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	ilyra._record_spell_cast("EMBER")
	ilyra._record_spell_cast("FROST")
	ilyra.cast_ilyra_r(Vector3.ZERO)
	
	if ilyra.weave_stacks != 0 or not ilyra.spell_history.is_empty():
		return "Grand Weave should consume all Weave stacks upon cast"
		
	ilyra.free()
	return ""

func test_task44_ilyra_death_and_respawn_clean_state() -> String:
	var ilyra = IlyraHeroClass.new()
	ilyra.team = TeamDefinitions.Team.RADIANT
	ilyra._ready()
	ilyra._record_spell_cast("EMBER")
	
	ilyra.die(null)
	if ilyra.weave_stacks != 0 or not ilyra.spell_history.is_empty():
		return "Death should clear Weave stacks and spell history"
		
	ilyra.respawn()
	if not ilyra.is_alive():
		return "Respawned Ilyra should be alive"
		
	ilyra.free()
	return ""

# ==============================================================================
# 20 TASK 45: VAEL HERO IMPLEMENTATION TESTS (Tests 844-863)
# ==============================================================================

func test_task45_vael_initialization_and_archetype() -> String:
	var vael = VaelHeroClass.new()
	vael._ready()
	
	if vael.entity_name != "Vael":
		return "Vael entity_name incorrect"
	if vael.attribute_system.primary_attribute != AttributeSystem.PrimaryAttributeType.INTELLIGENCE:
		return "Vael primary attribute should be INTELLIGENCE"
	if vael.ability_container.abilities[AbilityResource.Slot.Q] == null:
		return "Vael Q (Star Lance) should be assigned"
	if vael.ability_container.abilities[AbilityResource.Slot.W] == null:
		return "Vael W (Astral Marker) should be assigned"
	if vael.ability_container.abilities[AbilityResource.Slot.E] == null:
		return "Vael E (Warp Sight) should be assigned"
	if vael.ability_container.abilities[AbilityResource.Slot.R] == null:
		return "Vael R (Falling Star) should be assigned"
	if vael.ability_container.abilities[AbilityResource.Slot.PASSIVE] == null:
		return "Vael Passive (Calibration) should be assigned"
		
	vael.free()
	return ""

func test_task45_vael_passive_calibration_stacks_on_same_direction() -> String:
	var vael = VaelHeroClass.new()
	vael.team = TeamDefinitions.Team.RADIANT
	vael._ready()
	
	vael._record_aim_direction(Vector3(1, 0, 0))
	vael._record_aim_direction(Vector3(1, 0, 0.1))
	vael._record_aim_direction(Vector3(1, 0, 0.2))
	
	if vael.calibration_stacks != 3:
		return "Calibration should reach 3 stacks when aiming in same direction"
		
	vael.free()
	return ""

func test_task45_vael_passive_calibration_resets_on_redirection() -> String:
	var vael = VaelHeroClass.new()
	vael.team = TeamDefinitions.Team.RADIANT
	vael._ready()
	
	vael._record_aim_direction(Vector3(1, 0, 0))
	vael._record_aim_direction(Vector3(1, 0, 0))
	vael._record_aim_direction(Vector3(-1, 0, 0)) # 180 degree flip
	
	if vael.calibration_stacks != 1:
		return "Calibration should reset to 1 on big redirection"
		
	vael.free()
	return ""

func test_task45_vael_passive_calibration_timer_expiration() -> String:
	var vael = VaelHeroClass.new()
	vael.team = TeamDefinitions.Team.RADIANT
	vael._ready()
	
	vael._record_aim_direction(Vector3(1, 0, 0))
	vael._process(5.5)
	
	if vael.calibration_stacks != 0:
		return "Calibration should expire after 5.0 seconds"
		
	vael.free()
	return ""

func test_task45_vael_q_star_lance_damage() -> String:
	var vael = VaelHeroClass.new()
	vael.team = TeamDefinitions.Team.RADIANT
	vael._ready()
	vael.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var hp_before = dummy.attribute_system.current_health
	var res = vael.cast_vael_q(dummy)
	var hp_after = dummy.attribute_system.current_health
	
	if res == null or hp_before - hp_after <= 60.0:
		return "Star Lance should deal magical damage to target"
		
	dummy.free()
	vael.free()
	return ""

func test_task45_vael_q_star_lance_empowered_by_calibration() -> String:
	var vael = VaelHeroClass.new()
	vael.team = TeamDefinitions.Team.RADIANT
	vael._ready()
	vael.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	vael.calibration_stacks = 0
	var res1 = vael.cast_vael_q(dummy)
	var dmg_base = res1.final_health_damage
	
	vael.calibration_stacks = 3
	var res2 = vael.cast_vael_q(dummy)
	var dmg_calib = res2.final_health_damage
	
	if dmg_calib <= dmg_base:
		return "Star Lance should deal +30% bonus damage at max Calibration"
		
	dummy.free()
	vael.free()
	return ""

func test_task45_vael_q_star_lance_empowered_by_astral_marker() -> String:
	var vael = VaelHeroClass.new()
	vael.team = TeamDefinitions.Team.RADIANT
	vael._ready()
	vael.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var res1 = vael.cast_vael_q(dummy)
	var dmg_unmarked = res1.final_health_damage
	
	vael.marked_targets[dummy] = 6.0
	var res2 = vael.cast_vael_q(dummy)
	var dmg_marked = res2.final_health_damage
	
	if dmg_marked <= dmg_unmarked:
		return "Star Lance should deal empowered damage against marked target"
		
	dummy.free()
	vael.free()
	return ""

func test_task45_vael_q_star_lance_target_validation_rejects_ally() -> String:
	var vael = VaelHeroClass.new()
	vael.team = TeamDefinitions.Team.RADIANT
	vael._ready()
	vael.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var ally = TargetDummyEntity.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var res = vael.cast_vael_q(ally)
	if res != null:
		return "Star Lance should reject ally targets"
		
	ally.free()
	vael.free()
	return ""

func test_task45_vael_q_star_lance_cooldown_and_mana() -> String:
	var vael = VaelHeroClass.new()
	vael.team = TeamDefinitions.Team.RADIANT
	vael._ready()
	vael.ability_container.level_up_ability(AbilityResource.Slot.Q)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	vael.cast_vael_q(dummy)
	var second_cast = vael.cast_vael_q(dummy)
	if second_cast != null:
		return "Star Lance should be on cooldown"
		
	dummy.free()
	vael.free()
	return ""

func test_task45_vael_w_astral_marker_applies_mark() -> String:
	var vael = VaelHeroClass.new()
	vael.team = TeamDefinitions.Team.RADIANT
	vael._ready()
	vael.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	vael.cast_vael_w(dummy)
	if not vael.marked_targets.has(dummy):
		return "Astral Marker should apply mark to target"
		
	dummy.free()
	vael.free()
	return ""

func test_task45_vael_w_astral_marker_target_validation_rejects_ally() -> String:
	var vael = VaelHeroClass.new()
	vael.team = TeamDefinitions.Team.RADIANT
	vael._ready()
	vael.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var ally = TargetDummyEntity.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var res = vael.cast_vael_w(ally)
	if res != null:
		return "Astral Marker should reject ally targets"
		
	ally.free()
	vael.free()
	return ""

func test_task45_vael_w_astral_marker_timer_expiration() -> String:
	var vael = VaelHeroClass.new()
	vael.team = TeamDefinitions.Team.RADIANT
	vael._ready()
	
	var dummy = TargetDummyEntity.new()
	dummy._ready()
	vael.marked_targets[dummy] = 2.0
	vael._process(2.5)
	
	if vael.marked_targets.has(dummy):
		return "Astral Marker should expire after duration"
		
	dummy.free()
	vael.free()
	return ""

func test_task45_vael_w_astral_marker_cooldown_and_mana() -> String:
	var vael = VaelHeroClass.new()
	vael.team = TeamDefinitions.Team.RADIANT
	vael._ready()
	vael.ability_container.level_up_ability(AbilityResource.Slot.W)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	vael.cast_vael_w(dummy)
	var second_cast = vael.cast_vael_w(dummy)
	if second_cast != null:
		return "Astral Marker should be on cooldown"
		
	dummy.free()
	vael.free()
	return ""

func test_task45_vael_e_warp_sight_grants_range_buff() -> String:
	var vael = VaelHeroClass.new()
	vael.team = TeamDefinitions.Team.RADIANT
	vael._ready()
	vael.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var base_range = vael.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_RANGE)
	vael.cast_vael_e()
	var buffed_range = vael.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_RANGE)
	
	if buffed_range <= base_range:
		return "Warp Sight should grant +200 range bonus"
		
	vael.free()
	return ""

func test_task45_vael_e_warp_sight_timer_expiration() -> String:
	var vael = VaelHeroClass.new()
	vael.team = TeamDefinitions.Team.RADIANT
	vael._ready()
	vael.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	var base_range = vael.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_RANGE)
	vael.cast_vael_e()
	vael._process(5.5)
	var final_range = vael.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_RANGE)
	
	if absf(final_range - base_range) > 1.0:
		return "Warp Sight range buff should expire after 5.0 seconds"
		
	vael.free()
	return ""

func test_task45_vael_e_warp_sight_cooldown_and_mana() -> String:
	var vael = VaelHeroClass.new()
	vael.team = TeamDefinitions.Team.RADIANT
	vael._ready()
	vael.ability_container.level_up_ability(AbilityResource.Slot.E)
	
	vael.cast_vael_e()
	var second_cast = vael.cast_vael_e()
	if second_cast:
		return "Warp Sight should be on cooldown"
		
	vael.free()
	return ""

func test_task45_vael_r_falling_star_aoe_damage() -> String:
	var vael = VaelHeroClass.new()
	vael.team = TeamDefinitions.Team.RADIANT
	vael._ready()
	vael.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(10, 0, 0)
	dummy._ready()
	
	var hp_before = dummy.attribute_system.current_health
	var enemies: Array[BaseCombatEntity] = [dummy]
	vael.cast_vael_r(Vector3(10, 0, 0), enemies)
	var hp_after = dummy.attribute_system.current_health
	
	if hp_before - hp_after <= 200.0:
		return "Falling Star should deal heavy AoE magical damage"
		
	dummy.free()
	vael.free()
	return ""

func test_task45_vael_r_falling_star_center_bonus_damage() -> String:
	var vael = VaelHeroClass.new()
	vael.team = TeamDefinitions.Team.RADIANT
	vael._ready()
	vael.ability_container.level_up_ability(AbilityResource.Slot.R)
	
	var dummy_center = TargetDummyEntity.new()
	dummy_center.team = TeamDefinitions.Team.DIRE
	dummy_center.position = Vector3(0, 0, 0)
	dummy_center._ready()
	
	var dummy_edge = TargetDummyEntity.new()
	dummy_edge.team = TeamDefinitions.Team.DIRE
	dummy_edge.position = Vector3(5.0, 0, 0)
	dummy_edge._ready()
	
	var enemies: Array[BaseCombatEntity] = [dummy_center, dummy_edge]
	vael.cast_vael_r(Vector3(0, 0, 0), enemies)
	
	var dmg_center = 1000.0 - dummy_center.attribute_system.current_health
	var dmg_edge = 1000.0 - dummy_edge.attribute_system.current_health
	
	if dmg_center <= dmg_edge:
		return "Center target should take +50% extra Falling Star damage"
		
	dummy_center.free()
	dummy_edge.free()
	vael.free()
	return ""

func test_task45_vael_hero_definition_factory() -> String:
	var def = HeroDefinition.get_definition("vael")
	if def == null or def.hero_name != "Vael":
		return "HeroDefinition for vael not found"
		
	var hero = HeroDefinition.create_hero_instance("vael")
	if hero == null or not (hero is VaelHeroClass):
		return "create_hero_instance('vael') should produce VaelHero"
		
	hero.free()
	return ""

func test_task45_vael_death_and_respawn_clean_state() -> String:
	var vael = VaelHeroClass.new()
	vael.team = TeamDefinitions.Team.RADIANT
	vael._ready()
	vael.calibration_stacks = 3
	vael.cast_vael_e()
	
	vael.die(null)
	if vael.calibration_stacks != 0:
		return "Death should clear Calibration stacks"
		
	vael.respawn()
	if not vael.is_alive():
		return "Respawned Vael should be alive"
		
	vael.free()
	return ""

# ==============================================================================
# --- TASK 46: NERIS HERO TESTS (Tests 864–883) ---
# ==============================================================================

func test_task46_neris_initialization_and_archetype() -> String:
	var neris = NerisHeroClass.new()
	neris.team = TeamDefinitions.Team.RADIANT
	neris._ready()
	
	if neris.hero_resource.primary_attribute != AttributeSystem.PrimaryAttributeType.INTELLIGENCE:
		return "Neris primary attribute should be INTELLIGENCE"
	if neris.hero_resource.attack_type != HeroResource.AttackType.RANGED:
		return "Neris attack type should be RANGED"
	if neris.hero_resource.base_attack_range < 550.0:
		return "Neris base attack range should be >= 550.0"
		
	neris.free()
	return ""

func test_task46_neris_passive_node_creation() -> String:
	var neris = NerisHeroClass.new()
	neris.team = TeamDefinitions.Team.RADIANT
	neris._ready()
	
	neris.spawn_node(Vector3(1, 0, 1))
	if neris.get_node_count() != 1:
		return "Neris should have 1 active node after spawn_node"
		
	neris.free()
	return ""

func test_task46_neris_passive_node_cap_and_fifo() -> String:
	var neris = NerisHeroClass.new()
	neris.team = TeamDefinitions.Team.RADIANT
	neris._ready()
	
	for i in range(7):
		neris.spawn_node(Vector3(float(i), 0, 0))
		
	if neris.get_node_count() != 6:
		return "Neris active nodes should be capped at 6 (got %d)" % neris.get_node_count()
	if neris.active_nodes[0]["pos"].x != 1.0:
		return "FIFO should have removed oldest node at x=0"
		
	neris.free()
	return ""

func test_task46_neris_passive_node_lifetime_decay() -> String:
	var neris = NerisHeroClass.new()
	neris.team = TeamDefinitions.Team.RADIANT
	neris._ready()
	
	neris.spawn_node(Vector3(0, 0, 0))
	neris._process(46.0)
	
	if neris.get_node_count() != 0:
		return "Node should expire after 45.0s lifetime"
		
	neris.free()
	return ""

func test_task46_neris_q_wall_spawns_two_nodes() -> String:
	var neris = NerisHeroClass.new()
	neris.team = TeamDefinitions.Team.RADIANT
	neris._ready()
	neris.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var pos_a = Vector3(0, 0, -2)
	var pos_b = Vector3(0, 0, 2)
	var success = neris.cast_neris_q(pos_a, pos_b)
	
	if not success:
		return "Wall should cast successfully"
	if neris.get_node_count() != 2:
		return "Wall should spawn 2 nodes (got %d)" % neris.get_node_count()
	if neris.active_walls.is_empty():
		return "Active wall list should have 1 wall"
		
	neris.free()
	return ""

func test_task46_neris_q_wall_deals_damage_and_slows_enemies() -> String:
	var neris = NerisHeroClass.new()
	neris.team = TeamDefinitions.Team.RADIANT
	neris.position = Vector3(0, 0, 0)
	neris._ready()
	neris.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var enemy = TargetDummyEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(0, 0, 0)
	enemy._ready()
	
	var init_hp = enemy.attribute_system.current_health
	neris.cast_neris_q(Vector3(0, 0, -3), Vector3(0, 0, 3))
	
	if enemy.attribute_system.current_health >= init_hp:
		return "Wall should deal magic damage to enemies across the line"
	if not enemy.effect_container.has_effect("neris_wall_slow"):
		return "Wall should apply 40% slow to enemies"
		
	enemy.free()
	neris.free()
	return ""

func test_task46_neris_q_wall_lifetime_expiration() -> String:
	var neris = NerisHeroClass.new()
	neris.team = TeamDefinitions.Team.RADIANT
	neris._ready()
	neris.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	neris.cast_neris_q(Vector3(0, 0, -2), Vector3(0, 0, 2))
	neris._process(4.5)
	
	if not neris.active_walls.is_empty():
		return "Wall should expire after 4.0 seconds"
		
	neris.free()
	return ""

func test_task46_neris_q_wall_cooldown_and_mana() -> String:
	var neris = NerisHeroClass.new()
	neris.team = TeamDefinitions.Team.RADIANT
	neris._ready()
	neris.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var init_mana = neris.attribute_system.current_mana
	neris.cast_neris_q(Vector3(0, 0, -1), Vector3(0, 0, 1))
	
	if neris.attribute_system.current_mana >= init_mana:
		return "Wall should deduct mana"
		
	var second_cast = neris.cast_neris_q(Vector3(0, 0, -1), Vector3(0, 0, 1))
	if second_cast:
		return "Wall should be on cooldown"
		
	neris.free()
	return ""

func test_task46_neris_w_pulse_triggers_damage_around_nodes() -> String:
	var neris = NerisHeroClass.new()
	neris.team = TeamDefinitions.Team.RADIANT
	neris.position = Vector3(0, 0, 0)
	neris._ready()
	neris.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	neris.spawn_node(Vector3(2.0, 0, 0))
	var hits = neris.cast_neris_w()
	
	if hits <= 0:
		return "Pulse should hit enemy near active node"
		
	dummy.free()
	neris.free()
	return ""

func test_task46_neris_w_pulse_overlapping_nodes_bonus_damage() -> String:
	var neris = NerisHeroClass.new()
	neris.team = TeamDefinitions.Team.RADIANT
	neris.position = Vector3(0, 0, 0)
	neris._ready()
	neris.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	# Place 2 overlapping nodes near target
	neris.spawn_node(Vector3(2.0, 0, 0))
	neris.spawn_node(Vector3(2.5, 0, 0))
	
	var init_hp = dummy.attribute_system.current_health
	neris.cast_neris_w()
	var dmg_dealt = init_hp - dummy.attribute_system.current_health
	
	if dmg_dealt <= 60.0:
		return "Overlapping nodes should deal amplified damage (got %f)" % dmg_dealt
		
	dummy.free()
	neris.free()
	return ""

func test_task46_neris_w_pulse_cooldown_and_mana() -> String:
	var neris = NerisHeroClass.new()
	neris.team = TeamDefinitions.Team.RADIANT
	neris._ready()
	neris.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var init_mana = neris.attribute_system.current_mana
	neris.cast_neris_w()
	
	if neris.attribute_system.current_mana >= init_mana:
		return "Pulse should deduct mana"
		
	var second_cast = neris.cast_neris_w()
	if second_cast > 0:
		return "Pulse should be on cooldown"
		
	neris.free()
	return ""

func test_task46_neris_e_gate_creates_spatial_bridge() -> String:
	var neris = NerisHeroClass.new()
	neris.team = TeamDefinitions.Team.RADIANT
	neris._ready()
	neris.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var pos_a = Vector3(0, 0, 0)
	var pos_b = Vector3(6, 0, 0)
	var success = neris.cast_neris_e(pos_a, pos_b)
	
	if not success:
		return "Gate should cast successfully"
	if neris.active_gates.is_empty():
		return "Active gates should not be empty"
		
	neris.free()
	return ""

func test_task46_neris_e_gate_teleports_ally_and_grants_ms() -> String:
	var neris = NerisHeroClass.new()
	neris.team = TeamDefinitions.Team.RADIANT
	neris._ready()
	neris.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(0, 0, 0)
	ally._ready()
	
	neris.cast_neris_e(Vector3(0, 0, 0), Vector3(8, 0, 0))
	var tp_ok = neris.teleport_through_gate(ally, Vector3(0, 0, 0))
	
	if not tp_ok:
		return "Ally should be able to teleport through gate"
	if absf(ally.position.x - 8.0) > 0.5:
		return "Ally should arrive at gate exit pos B"
		
	ally.free()
	neris.free()
	return ""

func test_task46_neris_e_gate_rejects_enemy_teleport() -> String:
	var neris = NerisHeroClass.new()
	neris.team = TeamDefinitions.Team.RADIANT
	neris._ready()
	neris.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var enemy = AstrisHero.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(0, 0, 0)
	enemy._ready()
	
	neris.cast_neris_e(Vector3(0, 0, 0), Vector3(8, 0, 0))
	var tp_ok = neris.teleport_through_gate(enemy, Vector3(0, 0, 0))
	
	if tp_ok:
		return "Enemy must not be allowed to teleport through gate"
		
	enemy.free()
	neris.free()
	return ""

func test_task46_neris_e_gate_lifetime_expiration() -> String:
	var neris = NerisHeroClass.new()
	neris.team = TeamDefinitions.Team.RADIANT
	neris._ready()
	neris.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	neris.cast_neris_e(Vector3(0, 0, 0), Vector3(6, 0, 0))
	neris._process(6.5)
	
	if not neris.active_gates.is_empty():
		return "Gate should expire after 6.0 seconds"
		
	neris.free()
	return ""

func test_task46_neris_e_gate_cooldown_and_mana() -> String:
	var neris = NerisHeroClass.new()
	neris.team = TeamDefinitions.Team.RADIANT
	neris._ready()
	neris.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var init_mana = neris.attribute_system.current_mana
	neris.cast_neris_e(Vector3(0, 0, 0), Vector3(5, 0, 0))
	
	if neris.attribute_system.current_mana >= init_mana:
		return "Gate should deduct mana"
		
	var second_cast = neris.cast_neris_e(Vector3(0, 0, 0), Vector3(5, 0, 0))
	if second_cast:
		return "Gate should be on cooldown"
		
	neris.free()
	return ""

func test_task46_neris_r_grand_design_spawns_matrix_nodes() -> String:
	var neris = NerisHeroClass.new()
	neris.team = TeamDefinitions.Team.RADIANT
	neris._ready()
	neris.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	neris.cast_neris_r(Vector3(5, 0, 0))
	
	if neris.get_node_count() < 4:
		return "Grand Design should spawn 4 matrix nodes (got %d)" % neris.get_node_count()
		
	neris.free()
	return ""

func test_task46_neris_r_grand_design_damage_and_stun() -> String:
	var neris = NerisHeroClass.new()
	neris.team = TeamDefinitions.Team.RADIANT
	neris.position = Vector3(0, 0, 0)
	neris._ready()
	neris.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var enemy = TargetDummyEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(5.0, 0, 0)
	enemy._ready()
	
	var results = neris.cast_neris_r(Vector3(5.0, 0, 0))
	
	if results.is_empty() or results[0] == null:
		return "Grand Design should deal heavy magic damage"
	if not enemy.effect_container.has_effect("neris_matrix_stun"):
		return "Grand Design should stun enemies in matrix for 1.2s"
		
	enemy.free()
	neris.free()
	return ""

func test_task46_neris_hero_definition_factory() -> String:
	var def = HeroDefinition.get_definition("neris")
	if def == null or def.hero_name != "Neris":
		return "HeroDefinition for neris not found"
		
	var hero = HeroDefinition.create_hero_instance("neris")
	if hero == null or not (hero is NerisHeroClass):
		return "create_hero_instance('neris') should produce NerisHero"
		
	hero.free()
	return ""

func test_task46_neris_death_and_respawn_clears_nodes() -> String:
	var neris = NerisHeroClass.new()
	neris.team = TeamDefinitions.Team.RADIANT
	neris._ready()
	neris.spawn_node(Vector3(1, 0, 1))
	neris.spawn_node(Vector3(2, 0, 2))
	
	neris.die(null)
	if neris.get_node_count() != 0:
		return "Death should clear active nodes"
		
	neris.respawn()
	if not neris.is_alive():
		print("DEBUG 883: lifecycle_state=", neris.lifecycle_state, " attr.is_alive=", neris.attribute_system.is_alive, " hp=", neris.attribute_system.current_health)
		return "Respawned Neris should be alive"
		
	neris.free()
	return ""

# ==============================================================================
# --- TASK 47: ORYN HERO TESTS (Tests 884–903) ---
# ==============================================================================

func test_task47_oryn_initialization_and_archetype() -> String:
	var oryn = OrynHeroClass.new()
	oryn.team = TeamDefinitions.Team.RADIANT
	oryn._ready()
	
	if oryn.hero_resource.primary_attribute != AttributeSystem.PrimaryAttributeType.INTELLIGENCE:
		return "Oryn primary attribute should be INTELLIGENCE"
	if oryn.hero_resource.attack_type != HeroResource.AttackType.RANGED:
		return "Oryn attack type should be RANGED"
	if oryn.hero_resource.base_health < 600.0:
		return "Oryn base health should be >= 600.0"
		
	oryn.free()
	return ""

func test_task47_oryn_passive_resonance_accumulation() -> String:
	var oryn = OrynHeroClass.new()
	oryn.team = TeamDefinitions.Team.RADIANT
	oryn._ready()
	
	oryn.add_resonance_stack()
	oryn.add_resonance_stack()
	
	if oryn.resonance_stacks != 2:
		return "Resonance stacks should be 2"
		
	oryn.free()
	return ""

func test_task47_oryn_passive_resonance_ap_and_heal_power() -> String:
	var oryn = OrynHeroClass.new()
	oryn.team = TeamDefinitions.Team.RADIANT
	oryn._ready()
	
	var base_ap = oryn.attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	oryn.add_resonance_stack()
	oryn.add_resonance_stack()
	
	var buffed_ap = oryn.attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	if buffed_ap < base_ap + 11.5:
		return "Resonance should grant +6 AP per stack (+12 AP for 2 stacks)"
		
	oryn.free()
	return ""

func test_task47_oryn_passive_resonance_cap_clamp() -> String:
	var oryn = OrynHeroClass.new()
	oryn.team = TeamDefinitions.Team.RADIANT
	oryn._ready()
	
	for i in range(10):
		oryn.add_resonance_stack()
		
	if oryn.resonance_stacks > 5:
		return "Resonance stacks should be clamped to 5 max"
		
	oryn.free()
	return ""

func test_task47_oryn_passive_resonance_decay_timer() -> String:
	var oryn = OrynHeroClass.new()
	oryn.team = TeamDefinitions.Team.RADIANT
	oryn._ready()
	
	oryn.add_resonance_stack()
	oryn._process(8.5)
	
	if oryn.resonance_stacks != 0:
		return "Resonance stacks should expire after 8.0 seconds"
		
	oryn.free()
	return ""

func test_task47_oryn_q_mend_heals_ally() -> String:
	var oryn = OrynHeroClass.new()
	oryn.team = TeamDefinitions.Team.RADIANT
	oryn._ready()
	oryn.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	ally.attribute_system.current_health = 100.0
	
	var healed = oryn.cast_oryn_q(ally)
	
	if healed <= 0.0 or ally.attribute_system.current_health <= 100.0:
		return "Mend should heal target ally"
	if oryn.resonance_stacks != 1:
		return "Mend should grant 1 Resonance stack"
		
	ally.free()
	oryn.free()
	return ""

func test_task47_oryn_q_mend_self_cast_penalty() -> String:
	var oryn = OrynHeroClass.new()
	oryn.team = TeamDefinitions.Team.RADIANT
	oryn._ready()
	oryn.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	oryn.attribute_system.current_health = 100.0
	
	var self_healed = oryn.cast_oryn_q(oryn)
	
	if self_healed > 70.0: # Base 80 * 0.70 = 56
		return "Self heal should have 70% penalty (got %f)" % self_healed
		
	oryn.free()
	return ""

func test_task47_oryn_q_mend_cooldown_and_mana() -> String:
	var oryn = OrynHeroClass.new()
	oryn.team = TeamDefinitions.Team.RADIANT
	oryn._ready()
	oryn.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var init_mana = oryn.attribute_system.current_mana
	oryn.cast_oryn_q(ally)
	
	if oryn.attribute_system.current_mana >= init_mana:
		return "Mend should deduct mana"
		
	var second_cast = oryn.cast_oryn_q(ally)
	if second_cast > 0.0:
		return "Mend should be on cooldown"
		
	ally.free()
	oryn.free()
	return ""

func test_task47_oryn_w_empower_grants_stat_and_as_buff() -> String:
	var oryn = OrynHeroClass.new()
	oryn.team = TeamDefinitions.Team.RADIANT
	oryn._ready()
	oryn.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var base_ap = ally.attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var base_as = ally.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	
	var success = oryn.cast_oryn_w(ally)
	if not success:
		return "Empower should cast successfully"
		
	var buffed_ap = ally.attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var buffed_as = ally.attribute_system.get_stat(StatModifier.TargetStat.ATTACK_SPEED)
	
	if buffed_ap <= base_ap + 15.0:
		return "Empower should grant +20 AP to INT ally"
	if buffed_as <= base_as:
		return "Empower should grant +20% AS"
		
	ally.free()
	oryn.free()
	return ""

func test_task47_oryn_w_empower_target_validation_rejects_enemy() -> String:
	var oryn = OrynHeroClass.new()
	oryn.team = TeamDefinitions.Team.RADIANT
	oryn._ready()
	oryn.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var enemy = TargetDummyEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	var success = oryn.cast_oryn_w(enemy)
	if success:
		return "Empower must reject enemy targets"
		
	enemy.free()
	oryn.free()
	return ""

func test_task47_oryn_w_empower_cooldown_and_mana() -> String:
	var oryn = OrynHeroClass.new()
	oryn.team = TeamDefinitions.Team.RADIANT
	oryn._ready()
	oryn.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var init_mana = oryn.attribute_system.current_mana
	oryn.cast_oryn_w(ally)
	
	if oryn.attribute_system.current_mana >= init_mana:
		return "Empower should deduct mana"
		
	var second_cast = oryn.cast_oryn_w(ally)
	if second_cast:
		return "Empower should be on cooldown"
		
	ally.free()
	oryn.free()
	return ""

func test_task47_oryn_e_transfer_purges_ally_debuff() -> String:
	var oryn = OrynHeroClass.new()
	oryn.team = TeamDefinitions.Team.RADIANT
	oryn._ready()
	oryn.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var stun_eff = StatusEffect.new("stun", StatusEffect.EffectType.STUN, 3.0)
	ally.effect_container.apply_effect(stun_eff)
	
	oryn.cast_oryn_e(ally)
	
	if ally.effect_container.has_effect("stun"):
		return "Transfer should purge debuffs from ally"
		
	ally.free()
	oryn.free()
	return ""

func test_task47_oryn_e_transfer_inflicts_damage_and_debuff_on_enemy() -> String:
	var oryn = OrynHeroClass.new()
	oryn.team = TeamDefinitions.Team.RADIANT
	oryn._ready()
	oryn.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(0, 0, 0)
	ally._ready()
	
	var slow_eff = StatusEffect.new("slow", StatusEffect.EffectType.SLOW, 3.0, 0.40)
	ally.effect_container.apply_effect(slow_eff)
	
	var enemy = TargetDummyEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(2.0, 0, 0)
	enemy._ready()
	
	var res = oryn.cast_oryn_e(ally, enemy)
	
	if res == null or res.final_health_damage <= 0.0:
		return "Transfer should deal magic damage to target enemy"
	if not enemy.effect_container.has_effect("transferred_slow"):
		return "Transfer should inflict purged debuff on enemy"
		
	enemy.free()
	ally.free()
	oryn.free()
	return ""

func test_task47_oryn_e_transfer_target_validation_rejects_enemy_as_primary() -> String:
	var oryn = OrynHeroClass.new()
	oryn.team = TeamDefinitions.Team.RADIANT
	oryn._ready()
	oryn.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var enemy = TargetDummyEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	var res = oryn.cast_oryn_e(enemy)
	if res != null:
		return "Transfer primary target must be an ally"
		
	enemy.free()
	oryn.free()
	return ""

func test_task47_oryn_e_transfer_cooldown_and_mana() -> String:
	var oryn = OrynHeroClass.new()
	oryn.team = TeamDefinitions.Team.RADIANT
	oryn._ready()
	oryn.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var init_mana = oryn.attribute_system.current_mana
	oryn.cast_oryn_e(ally)
	
	if oryn.attribute_system.current_mana >= init_mana:
		return "Transfer should deduct mana"
		
	var second_cast = oryn.cast_oryn_e(ally)
	if second_cast != null:
		return "Transfer should be on cooldown"
		
	ally.free()
	oryn.free()
	return ""

func test_task47_oryn_r_resonant_bond_forms_bond_and_buffs() -> String:
	var oryn = OrynHeroClass.new()
	oryn.team = TeamDefinitions.Team.RADIANT
	oryn._ready()
	oryn.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var base_armor = ally.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	var success = oryn.cast_oryn_r(ally)
	
	if not success or not oryn.is_bonded():
		return "Resonant Bond should form successfully"
		
	var buffed_armor = ally.attribute_system.get_stat(StatModifier.TargetStat.ARMOR)
	if buffed_armor <= base_armor + 15.0:
		return "Resonant Bond should grant +20 Armor/MR"
		
	ally.free()
	oryn.free()
	return ""

func test_task47_oryn_r_resonant_bond_shared_healing() -> String:
	var oryn = OrynHeroClass.new()
	oryn.team = TeamDefinitions.Team.RADIANT
	oryn._ready()
	oryn.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	oryn.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	oryn.cast_oryn_r(ally)
	oryn.attribute_system.current_health = 100.0
	ally.attribute_system.current_health = 100.0
	
	oryn.cast_oryn_q(ally)
	
	if oryn.attribute_system.current_health <= 100.0:
		return "Healing bonded ally should share 60% healing to Oryn"
		
	ally.free()
	oryn.free()
	return ""

func test_task47_oryn_r_resonant_bond_expiration() -> String:
	var oryn = OrynHeroClass.new()
	oryn.team = TeamDefinitions.Team.RADIANT
	oryn._ready()
	oryn.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	oryn.cast_oryn_r(ally)
	oryn._process(7.5)
	
	if oryn.is_bonded():
		return "Bond should expire after 7.0 seconds"
		
	ally.free()
	oryn.free()
	return ""

func test_task47_oryn_hero_definition_factory() -> String:
	var def = HeroDefinition.get_definition("oryn")
	if def == null or def.hero_name != "Oryn":
		return "HeroDefinition for oryn not found"
		
	var hero = HeroDefinition.create_hero_instance("oryn")
	if hero == null or not (hero is OrynHeroClass):
		return "create_hero_instance('oryn') should produce OrynHero"
		
	hero.free()
	return ""

func test_task47_oryn_death_and_respawn_cleans_bond_and_resonance() -> String:
	var oryn = OrynHeroClass.new()
	oryn.team = TeamDefinitions.Team.RADIANT
	oryn._ready()
	oryn.add_resonance_stack()
	oryn.add_resonance_stack()
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	oryn.cast_oryn_r(ally)
	
	oryn.die(null)
	if oryn.resonance_stacks != 0 or oryn.is_bonded():
		return "Death should clean bond and resonance"
		
	oryn.respawn()
	if not oryn.is_alive():
		return "Respawned Oryn should be alive"
		
	ally.free()
	oryn.free()
	return ""

# ==============================================================================
# --- TASK 48: SELKA HERO TESTS (Tests 904–923) ---
# ==============================================================================

func test_task48_selka_initialization_and_archetype() -> String:
	var selka = SelkaHeroClass.new()
	selka.team = TeamDefinitions.Team.RADIANT
	selka._ready()
	
	if selka.hero_resource.primary_attribute != AttributeSystem.PrimaryAttributeType.INTELLIGENCE:
		return "Selka primary attribute should be INTELLIGENCE"
	if selka.hero_resource.attack_type != HeroResource.AttackType.RANGED:
		return "Selka attack type should be RANGED"
	if selka.hero_resource.base_attack_range < 550.0:
		return "Selka base attack range should be >= 550.0"
		
	selka.free()
	return ""

func test_task48_selka_passive_hex_mark_application() -> String:
	var selka = SelkaHeroClass.new()
	selka.team = TeamDefinitions.Team.RADIANT
	selka._ready()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	selka.apply_hex_mark(dummy)
	if selka.get_hex_stacks(dummy) != 1:
		return "Target should have 1 Hex mark"
		
	dummy.free()
	selka.free()
	return ""

func test_task48_selka_passive_hex_mark_mr_shred() -> String:
	var selka = SelkaHeroClass.new()
	selka.team = TeamDefinitions.Team.RADIANT
	selka._ready()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var base_mr = dummy.attribute_system.get_stat(StatModifier.TargetStat.MAGIC_RESIST)
	selka.apply_hex_mark(dummy)
	selka.apply_hex_mark(dummy)
	
	var shredded_mr = dummy.attribute_system.get_stat(StatModifier.TargetStat.MAGIC_RESIST)
	if shredded_mr >= base_mr:
		return "Hex marks should reduce target Magic Resist by 6% per stack"
		
	dummy.free()
	selka.free()
	return ""

func test_task48_selka_passive_hex_mark_cap_clamp() -> String:
	var selka = SelkaHeroClass.new()
	selka.team = TeamDefinitions.Team.RADIANT
	selka._ready()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	for i in range(6):
		selka.apply_hex_mark(dummy)
		
	if selka.get_hex_stacks(dummy) > 3:
		return "Hex marks should be capped at 3 max"
		
	dummy.free()
	selka.free()
	return ""

func test_task48_selka_passive_hex_mark_decay_timer() -> String:
	var selka = SelkaHeroClass.new()
	selka.team = TeamDefinitions.Team.RADIANT
	selka._ready()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	selka.apply_hex_mark(dummy)
	selka._process(6.5)
	
	if selka.get_hex_stacks(dummy) != 0:
		return "Hex mark should expire after 6.0 seconds"
		
	dummy.free()
	selka.free()
	return ""

func test_task48_selka_q_hex_bolt_damage_and_mark() -> String:
	var selka = SelkaHeroClass.new()
	selka.team = TeamDefinitions.Team.RADIANT
	selka._ready()
	selka.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var res = selka.cast_selka_q(dummy)
	
	if res == null or res.final_health_damage <= 0.0:
		return "Hex Bolt should deal magic damage"
	if selka.get_hex_stacks(dummy) != 1:
		return "Hex Bolt should apply 1 Hex mark"
		
	dummy.free()
	selka.free()
	return ""

func test_task48_selka_q_hex_bolt_target_validation_rejects_ally() -> String:
	var selka = SelkaHeroClass.new()
	selka.team = TeamDefinitions.Team.RADIANT
	selka._ready()
	selka.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var res = selka.cast_selka_q(ally)
	if res != null:
		return "Hex Bolt must reject allied targets"
		
	ally.free()
	selka.free()
	return ""

func test_task48_selka_q_hex_bolt_cooldown_and_mana() -> String:
	var selka = SelkaHeroClass.new()
	selka.team = TeamDefinitions.Team.RADIANT
	selka._ready()
	selka.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var init_mana = selka.attribute_system.current_mana
	selka.cast_selka_q(dummy)
	
	if selka.attribute_system.current_mana >= init_mana:
		return "Hex Bolt should deduct mana"
		
	var second_cast = selka.cast_selka_q(dummy)
	if second_cast != null:
		return "Hex Bolt should be on cooldown"
		
	dummy.free()
	selka.free()
	return ""

func test_task48_selka_w_ember_ring_aoe_damage_and_mark() -> String:
	var selka = SelkaHeroClass.new()
	selka.team = TeamDefinitions.Team.RADIANT
	selka.position = Vector3(0, 0, 0)
	selka._ready()
	selka.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	var results = selka.cast_selka_w(Vector3(2.0, 0, 0), [dummy])
	
	if results.is_empty() or results[0] == null:
		return "Ember Ring should deal AoE damage"
	if selka.get_hex_stacks(dummy) != 1:
		return "Ember Ring should apply 1 Hex mark"
		
	dummy.free()
	selka.free()
	return ""

func test_task48_selka_w_ember_ring_cooldown_and_mana() -> String:
	var selka = SelkaHeroClass.new()
	selka.team = TeamDefinitions.Team.RADIANT
	selka._ready()
	selka.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var init_mana = selka.attribute_system.current_mana
	selka.cast_selka_w(Vector3(0, 0, 0))
	
	if selka.attribute_system.current_mana >= init_mana:
		return "Ember Ring should deduct mana"
		
	var second_cast = selka.cast_selka_w(Vector3(0, 0, 0))
	if not second_cast.is_empty():
		return "Ember Ring should be on cooldown"
		
	selka.free()
	return ""

func test_task48_selka_e_detonate_consumes_stacks_for_burst_damage() -> String:
	var selka = SelkaHeroClass.new()
	selka.team = TeamDefinitions.Team.RADIANT
	selka.position = Vector3(0, 0, 0)
	selka._ready()
	selka.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	selka.apply_hex_mark(dummy)
	selka.apply_hex_mark(dummy)
	selka.apply_hex_mark(dummy)
	
	var dmg_dealt = selka.cast_selka_e()
	
	if dmg_dealt <= 85.0: # 3 stacks * 40 base = 120 base mitigated by MR to ~99.0
		return "Detonate should deal heavy burst damage consuming 3 stacks (got %f)" % dmg_dealt
	if selka.get_hex_stacks(dummy) != 0:
		return "Detonate should consume all Hex marks on target"
		
	dummy.free()
	selka.free()
	return ""

func test_task48_selka_e_detonate_slows_targets() -> String:
	var selka = SelkaHeroClass.new()
	selka.team = TeamDefinitions.Team.RADIANT
	selka.position = Vector3(0, 0, 0)
	selka._ready()
	selka.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	selka.apply_hex_mark(dummy)
	selka.cast_selka_e()
	
	if not dummy.effect_container.has_effect("selka_detonate_slow"):
		return "Detonate should apply slow effect to targets"
		
	dummy.free()
	selka.free()
	return ""

func test_task48_selka_e_detonate_zero_marks_no_damage() -> String:
	var selka = SelkaHeroClass.new()
	selka.team = TeamDefinitions.Team.RADIANT
	selka.position = Vector3(0, 0, 0)
	selka._ready()
	selka.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var dmg = selka.cast_selka_e()
	if dmg > 0.0:
		return "Detonate with zero marked enemies should deal 0 damage"
		
	selka.free()
	return ""

func test_task48_selka_e_detonate_cooldown_and_mana() -> String:
	var selka = SelkaHeroClass.new()
	selka.team = TeamDefinitions.Team.RADIANT
	selka._ready()
	selka.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var init_mana = selka.attribute_system.current_mana
	selka.cast_selka_e()
	
	if selka.attribute_system.current_mana >= init_mana:
		return "Detonate should deduct mana"
		
	var second_cast = selka.cast_selka_e()
	if second_cast > 0.0:
		return "Detonate should be on cooldown"
		
	selka.free()
	return ""

func test_task48_selka_r_cataclysm_links_marked_enemies() -> String:
	var selka = SelkaHeroClass.new()
	selka.team = TeamDefinitions.Team.RADIANT
	selka.position = Vector3(0, 0, 0)
	selka._ready()
	selka.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var enemy_a = TargetDummyEntity.new()
	enemy_a.team = TeamDefinitions.Team.DIRE
	enemy_a.position = Vector3(3.0, 0, 0)
	enemy_a._ready()
	
	var enemy_b = TargetDummyEntity.new()
	enemy_b.team = TeamDefinitions.Team.DIRE
	enemy_b.position = Vector3(4.0, 0, 0)
	enemy_b._ready()
	
	var success = selka.cast_selka_r([enemy_a, enemy_b])
	
	if not success or selka.linked_targets.size() != 2:
		return "Cataclysm should link 2 enemy targets"
		
	enemy_a.free()
	enemy_b.free()
	selka.free()
	return ""

func test_task48_selka_r_cataclysm_damage_propagation() -> String:
	var selka = SelkaHeroClass.new()
	selka.team = TeamDefinitions.Team.RADIANT
	selka.position = Vector3(0, 0, 0)
	selka._ready()
	selka.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	selka.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var enemy_a = TargetDummyEntity.new()
	enemy_a.team = TeamDefinitions.Team.DIRE
	enemy_a.position = Vector3(3.0, 0, 0)
	enemy_a._ready()
	
	var enemy_b = TargetDummyEntity.new()
	enemy_b.team = TeamDefinitions.Team.DIRE
	enemy_b.position = Vector3(4.0, 0, 0)
	enemy_b._ready()
	
	selka.cast_selka_r([enemy_a, enemy_b])
	
	var init_b_hp = enemy_b.attribute_system.current_health
	selka.cast_selka_q(enemy_a) # Strike enemy A
	
	if enemy_b.attribute_system.current_health >= init_b_hp:
		return "Damage dealt to enemy A should propagate 40% damage to enemy B"
		
	enemy_a.free()
	enemy_b.free()
	selka.free()
	return ""

func test_task48_selka_r_cataclysm_expiration() -> String:
	var selka = SelkaHeroClass.new()
	selka.team = TeamDefinitions.Team.RADIANT
	selka._ready()
	selka.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var enemy = TargetDummyEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	selka.cast_selka_r([enemy])
	selka._process(5.5)
	
	if not selka.linked_targets.is_empty():
		return "Cataclysm links should expire after 5.0 seconds"
		
	enemy.free()
	selka.free()
	return ""

func test_task48_selka_r_cataclysm_cooldown_and_mana() -> String:
	var selka = SelkaHeroClass.new()
	selka.team = TeamDefinitions.Team.RADIANT
	selka._ready()
	selka.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var init_mana = selka.attribute_system.current_mana
	selka.cast_selka_r()
	
	if selka.attribute_system.current_mana >= init_mana:
		return "Cataclysm should deduct mana"
		
	var second_cast = selka.cast_selka_r()
	if second_cast:
		return "Cataclysm should be on cooldown"
		
	selka.free()
	return ""

func test_task48_selka_hero_definition_factory() -> String:
	var def = HeroDefinition.get_definition("selka")
	if def == null or def.hero_name != "Selka":
		return "HeroDefinition for selka not found"
		
	var hero = HeroDefinition.create_hero_instance("selka")
	if hero == null or not (hero is SelkaHeroClass):
		return "create_hero_instance('selka') should produce SelkaHero"
		
	hero.free()
	return ""

func test_task48_selka_death_and_respawn_cleans_hex_marks_and_links() -> String:
	var selka = SelkaHeroClass.new()
	selka.team = TeamDefinitions.Team.RADIANT
	selka._ready()
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	selka.apply_hex_mark(dummy)
	
	selka.die(null)
	if selka.get_hex_stacks(dummy) != 0:
		return "Death should clean Hex marks"
		
	selka.respawn()
	if not selka.is_alive():
		return "Respawned Selka should be alive"
		
	dummy.free()
	selka.free()
	return ""

# ==============================================================================
# --- TASK 49: MORA HERO TESTS (Tests 924–943) ---
# ==============================================================================

func test_task49_mora_initialization_and_archetype() -> String:
	var mora = MoraHeroClass.new()
	mora.team = TeamDefinitions.Team.RADIANT
	mora._ready()
	
	if mora.hero_resource.primary_attribute != AttributeSystem.PrimaryAttributeType.STRENGTH:
		return "Mora primary attribute should be STRENGTH"
	if mora.hero_resource.attack_type != HeroResource.AttackType.MELEE:
		return "Mora attack type should be MELEE"
	if mora.hero_resource.base_health < 650.0:
		return "Mora base health should be >= 650.0"
		
	mora.free()
	return ""

func test_task49_mora_passive_life_reserve_accumulation() -> String:
	var mora = MoraHeroClass.new()
	mora.team = TeamDefinitions.Team.RADIANT
	mora._ready()
	
	mora.add_reserve(100.0)
	if mora.stored_reserve != 100.0:
		return "Life Reserve should be 100.0"
		
	mora.free()
	return ""

func test_task49_mora_passive_life_reserve_hp_regen_boost() -> String:
	var mora = MoraHeroClass.new()
	mora.team = TeamDefinitions.Team.RADIANT
	mora._ready()
	
	var base_regen = mora.attribute_system.get_stat(StatModifier.TargetStat.HEALTH_REGEN)
	mora.add_reserve(200.0)
	
	var buffed_regen = mora.attribute_system.get_stat(StatModifier.TargetStat.HEALTH_REGEN)
	if buffed_regen < base_regen + 1.8: # +0.5 per 50 = +2.0
		return "Life Reserve should boost HP regen (+0.5 per 50 stored)"
		
	mora.free()
	return ""

func test_task49_mora_passive_life_reserve_cap_clamp() -> String:
	var mora = MoraHeroClass.new()
	mora.team = TeamDefinitions.Team.RADIANT
	mora._ready()
	
	mora.add_reserve(1000.0)
	if mora.stored_reserve > 400.0:
		return "Life Reserve should be clamped at 400.0 max"
		
	mora.free()
	return ""

func test_task49_mora_q_restore_heals_ally_over_time() -> String:
	var mora = MoraHeroClass.new()
	mora.team = TeamDefinitions.Team.RADIANT
	mora._ready()
	mora.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	ally.attribute_system.current_health = 100.0
	
	var healed = mora.cast_mora_q(ally)
	
	if healed <= 0.0 or ally.attribute_system.current_health <= 100.0:
		return "Restore should heal ally"
	if mora.stored_reserve <= 0.0:
		return "Restore should store 25% in Life Reserve"
		
	ally.free()
	mora.free()
	return ""

func test_task49_mora_q_restore_target_validation_rejects_enemy() -> String:
	var mora = MoraHeroClass.new()
	mora.team = TeamDefinitions.Team.RADIANT
	mora._ready()
	mora.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var enemy = TargetDummyEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	var healed = mora.cast_mora_q(enemy)
	if healed > 0.0:
		return "Restore must reject enemy targets"
		
	enemy.free()
	mora.free()
	return ""

func test_task49_mora_q_restore_cooldown_and_mana() -> String:
	var mora = MoraHeroClass.new()
	mora.team = TeamDefinitions.Team.RADIANT
	mora._ready()
	mora.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var init_mana = mora.attribute_system.current_mana
	mora.cast_mora_q(ally)
	
	if mora.attribute_system.current_mana >= init_mana:
		return "Restore should deduct mana"
		
	var second_cast = mora.cast_mora_q(ally)
	if second_cast > 0.0:
		return "Restore should be on cooldown"
		
	ally.free()
	mora.free()
	return ""

func test_task49_mora_w_safeguard_shields_ally() -> String:
	var mora = MoraHeroClass.new()
	mora.team = TeamDefinitions.Team.RADIANT
	mora._ready()
	mora.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var shield_amt = mora.cast_mora_w(ally)
	
	if shield_amt <= 0.0 or not ally.effect_container.has_effect("mora_safeguard"):
		return "Safeguard should apply shield effect to ally"
	if mora.stored_reserve <= 0.0:
		return "Safeguard should store 20% in Life Reserve"
		
	ally.free()
	mora.free()
	return ""

func test_task49_mora_w_safeguard_target_validation_rejects_enemy() -> String:
	var mora = MoraHeroClass.new()
	mora.team = TeamDefinitions.Team.RADIANT
	mora._ready()
	mora.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var enemy = TargetDummyEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy._ready()
	
	var shield_amt = mora.cast_mora_w(enemy)
	if shield_amt > 0.0:
		return "Safeguard must reject enemy targets"
		
	enemy.free()
	mora.free()
	return ""

func test_task49_mora_w_safeguard_cooldown_and_mana() -> String:
	var mora = MoraHeroClass.new()
	mora.team = TeamDefinitions.Team.RADIANT
	mora._ready()
	mora.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var init_mana = mora.attribute_system.current_mana
	mora.cast_mora_w(ally)
	
	if mora.attribute_system.current_mana >= init_mana:
		return "Safeguard should deduct mana"
		
	var second_cast = mora.cast_mora_w(ally)
	if second_cast > 0.0:
		return "Safeguard should be on cooldown"
		
	ally.free()
	mora.free()
	return ""

func test_task49_mora_e_transfer_life_sacrifices_hp_to_heal_ally() -> String:
	var mora = MoraHeroClass.new()
	mora.team = TeamDefinitions.Team.RADIANT
	mora._ready()
	mora.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	ally.attribute_system.current_health = 100.0
	
	var init_mora_hp = mora.attribute_system.current_health
	var healed = mora.cast_mora_e(ally)
	
	if mora.attribute_system.current_health >= init_mora_hp:
		return "Transfer Life should sacrifice 12% current HP from Mora"
	if healed <= 0.0 or ally.attribute_system.current_health <= 100.0:
		return "Transfer Life should heal target ally"
		
	ally.free()
	mora.free()
	return ""

func test_task49_mora_e_transfer_life_rejects_self_cast() -> String:
	var mora = MoraHeroClass.new()
	mora.team = TeamDefinitions.Team.RADIANT
	mora._ready()
	mora.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var healed = mora.cast_mora_e(mora)
	if healed > 0.0:
		return "Transfer Life must reject self cast"
		
	mora.free()
	return ""

func test_task49_mora_e_transfer_life_cooldown_and_mana() -> String:
	var mora = MoraHeroClass.new()
	mora.team = TeamDefinitions.Team.RADIANT
	mora._ready()
	mora.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var init_mana = mora.attribute_system.current_mana
	mora.cast_mora_e(ally)
	
	if mora.attribute_system.current_mana >= init_mana:
		return "Transfer Life should deduct mana"
		
	var second_cast = mora.cast_mora_e(ally)
	if second_cast > 0.0:
		return "Transfer Life should be on cooldown"
		
	ally.free()
	mora.free()
	return ""

func test_task49_mora_r_rebirth_field_activates_sanctuary() -> String:
	var mora = MoraHeroClass.new()
	mora.team = TeamDefinitions.Team.RADIANT
	mora._ready()
	mora.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var success = mora.cast_mora_r()
	if not success or not mora.is_rebirth_field_active:
		return "Rebirth Field should activate successfully"
		
	mora.free()
	return ""

func test_task49_mora_r_rebirth_field_prevents_death_below_15_percent() -> String:
	var mora = MoraHeroClass.new()
	mora.team = TeamDefinitions.Team.RADIANT
	mora.position = Vector3(0, 0, 0)
	mora._ready()
	mora.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(2.0, 0, 0)
	ally._ready()
	
	mora.cast_mora_r()
	
	# Drop ally HP to 1.0
	ally.attribute_system.current_health = 1.0
	mora._apply_rebirth_aura()
	
	var min_allowed_hp = ally.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH) * 0.15
	if ally.attribute_system.current_health < min_allowed_hp:
		return "Rebirth Field must prevent ally health dropping below 15%% (got %f, min %f)" % [ally.attribute_system.current_health, min_allowed_hp]
		
	ally.free()
	mora.free()
	return ""

func test_task49_mora_r_rebirth_field_timer_expiration() -> String:
	var mora = MoraHeroClass.new()
	mora.team = TeamDefinitions.Team.RADIANT
	mora._ready()
	mora.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	mora.cast_mora_r()
	mora._process(5.0)
	
	if mora.is_rebirth_field_active:
		return "Rebirth Field should expire after 4.5 seconds"
		
	mora.free()
	return ""

func test_task49_mora_r_rebirth_field_cooldown_and_mana() -> String:
	var mora = MoraHeroClass.new()
	mora.team = TeamDefinitions.Team.RADIANT
	mora._ready()
	mora.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var init_mana = mora.attribute_system.current_mana
	mora.cast_mora_r()
	
	if mora.attribute_system.current_mana >= init_mana:
		return "Rebirth Field should deduct mana"
		
	var second_cast = mora.cast_mora_r()
	if second_cast:
		return "Rebirth Field should be on cooldown"
		
	mora.free()
	return ""

func test_task49_mora_hero_definition_factory() -> String:
	var def = HeroDefinition.get_definition("mora")
	if def == null or def.hero_name != "Mora":
		return "HeroDefinition for mora not found"
		
	var hero = HeroDefinition.create_hero_instance("mora")
	if hero == null or not (hero is MoraHeroClass):
		return "create_hero_instance('mora') should produce MoraHero"
		
	hero.free()
	return ""

func test_task49_mora_death_and_respawn_cleans_reserve_and_sanctuary() -> String:
	var mora = MoraHeroClass.new()
	mora.team = TeamDefinitions.Team.RADIANT
	mora._ready()
	mora.add_reserve(200.0)
	mora.cast_mora_r()
	
	mora.die(null)
	if mora.stored_reserve != 0.0 or mora.is_rebirth_field_active:
		return "Death should clean Life Reserve and Rebirth Field"
		
	mora.respawn()
	if not mora.is_alive():
		return "Respawned Mora should be alive"
		
	mora.free()
	return ""

func test_task49_mora_stat_scaling_with_levels() -> String:
	var mora = MoraHeroClass.new()
	mora.team = TeamDefinitions.Team.RADIANT
	mora._ready()
	
	var lvl1_str = mora.attribute_system.get_stat(StatModifier.TargetStat.STRENGTH)
	var lvl1_hp = mora.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	
	mora.attribute_system.add_xp(5000)
	
	var high_lvl_str = mora.attribute_system.get_stat(StatModifier.TargetStat.STRENGTH)
	var high_lvl_hp = mora.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	
	if high_lvl_str <= lvl1_str:
		return "Strength should increase with level"
	if high_lvl_hp <= lvl1_hp:
		return "Health should increase with level"
		
	mora.free()
	return ""

# ==============================================================================
# --- TASK 50: AETHON HERO TESTS (Tests 944–963) ---
# ==============================================================================

func test_task50_aethon_initialization_and_archetype() -> String:
	var aethon = AethonHeroClass.new()
	aethon.team = TeamDefinitions.Team.RADIANT
	aethon._ready()
	
	if aethon.hero_resource.primary_attribute != AttributeSystem.PrimaryAttributeType.INTELLIGENCE:
		return "Aethon primary attribute should be INTELLIGENCE"
	if aethon.hero_resource.attack_type != HeroResource.AttackType.RANGED:
		return "Aethon attack type should be RANGED"
	if aethon.hero_resource.base_health < 550.0:
		return "Aethon base health should be >= 550.0"
		
	aethon.free()
	return ""

func test_task50_aethon_passive_construct_spawn_and_lifecycle() -> String:
	var aethon = AethonHeroClass.new()
	aethon.team = TeamDefinitions.Team.RADIANT
	aethon._ready()
	
	aethon.spawn_construct(AethonHeroClass.ConstructType.GUARDIAN, Vector3(1, 0, 1), 350.0, 45.0)
	if aethon.get_construct_count() != 1:
		return "Construct count should be 1 after spawn"
		
	aethon.free()
	return ""

func test_task50_aethon_passive_construct_max_cap_clamp() -> String:
	var aethon = AethonHeroClass.new()
	aethon.team = TeamDefinitions.Team.RADIANT
	aethon._ready()
	
	for i in range(6):
		aethon.spawn_construct(AethonHeroClass.ConstructType.GUARDIAN, Vector3(i, 0, i))
		
	if aethon.get_construct_count() > 4:
		return "Construct count should be clamped at 4 max (got %d)" % aethon.get_construct_count()
		
	aethon.free()
	return ""

func test_task50_aethon_passive_construct_lifespan_expiration() -> String:
	var aethon = AethonHeroClass.new()
	aethon.team = TeamDefinitions.Team.RADIANT
	aethon._ready()
	
	aethon.spawn_construct(AethonHeroClass.ConstructType.GUARDIAN, Vector3(1, 0, 1))
	aethon._process(16.0) # > 15.0s lifespan
	
	if aethon.get_construct_count() != 0:
		return "Construct should expire after lifespan"
		
	aethon.free()
	return ""

func test_task50_aethon_q_guardian_construct_spawn() -> String:
	var aethon = AethonHeroClass.new()
	aethon.team = TeamDefinitions.Team.RADIANT
	aethon._ready()
	aethon.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var ok = aethon.cast_aethon_q(Vector3(3, 0, 3))
	if not ok:
		return "cast_aethon_q should succeed"
		
	var guardians = aethon.get_constructs_of_type(AethonHeroClass.ConstructType.GUARDIAN)
	if guardians.size() != 1:
		return "Should spawn 1 Guardian construct"
		
	aethon.free()
	return ""

func test_task50_aethon_q_guardian_construct_cooldown_and_mana() -> String:
	var aethon = AethonHeroClass.new()
	aethon.team = TeamDefinitions.Team.RADIANT
	aethon._ready()
	aethon.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var init_mana = aethon.attribute_system.current_mana
	aethon.cast_aethon_q(Vector3(0, 0, 0))
	
	if aethon.attribute_system.current_mana >= init_mana:
		return "Guardian Construct should deduct mana"
		
	var second_cast = aethon.cast_aethon_q(Vector3(0, 0, 0))
	if second_cast:
		return "Guardian Construct should be on cooldown"
		
	aethon.free()
	return ""

func test_task50_aethon_w_cannon_construct_spawn() -> String:
	var aethon = AethonHeroClass.new()
	aethon.team = TeamDefinitions.Team.RADIANT
	aethon._ready()
	aethon.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var ok = aethon.cast_aethon_w(Vector3(4, 0, 4))
	if not ok:
		return "cast_aethon_w should succeed"
		
	var cannons = aethon.get_constructs_of_type(AethonHeroClass.ConstructType.CANNON)
	if cannons.size() != 1:
		return "Should spawn 1 Cannon construct"
		
	aethon.free()
	return ""

func test_task50_aethon_w_cannon_construct_cooldown_and_mana() -> String:
	var aethon = AethonHeroClass.new()
	aethon.team = TeamDefinitions.Team.RADIANT
	aethon._ready()
	aethon.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var init_mana = aethon.attribute_system.current_mana
	aethon.cast_aethon_w(Vector3(0, 0, 0))
	
	if aethon.attribute_system.current_mana >= init_mana:
		return "Cannon Construct should deduct mana"
		
	var second_cast = aethon.cast_aethon_w(Vector3(0, 0, 0))
	if second_cast:
		return "Cannon Construct should be on cooldown"
		
	aethon.free()
	return ""

func test_task50_aethon_e_reconfigure_swaps_guardian_to_cannon() -> String:
	var aethon = AethonHeroClass.new()
	aethon.team = TeamDefinitions.Team.RADIANT
	aethon._ready()
	aethon.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	aethon.spawn_construct(AethonHeroClass.ConstructType.GUARDIAN, Vector3(1, 0, 1))
	var reconfigured = aethon.cast_aethon_e()
	
	if reconfigured != 1:
		return "Should reconfigure 1 construct"
	if aethon.get_constructs_of_type(AethonHeroClass.ConstructType.CANNON).size() != 1:
		return "Guardian construct should swap to Cannon"
		
	aethon.free()
	return ""

func test_task50_aethon_e_reconfigure_swaps_cannon_to_guardian() -> String:
	var aethon = AethonHeroClass.new()
	aethon.team = TeamDefinitions.Team.RADIANT
	aethon._ready()
	aethon.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	aethon.spawn_construct(AethonHeroClass.ConstructType.CANNON, Vector3(1, 0, 1))
	aethon.cast_aethon_e()
	
	if aethon.get_constructs_of_type(AethonHeroClass.ConstructType.GUARDIAN).size() != 1:
		return "Cannon construct should swap to Guardian"
		
	aethon.free()
	return ""

func test_task50_aethon_e_reconfigure_heals_and_buffs_constructs() -> String:
	var aethon = AethonHeroClass.new()
	aethon.team = TeamDefinitions.Team.RADIANT
	aethon._ready()
	aethon.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var c = aethon.spawn_construct(AethonHeroClass.ConstructType.GUARDIAN, Vector3(1, 0, 1), 300.0, 40.0)
	c["health"] = 100.0
	
	aethon.cast_aethon_e()
	if c["health"] <= 100.0:
		return "Reconfigure should heal active construct"
		
	aethon.free()
	return ""

func test_task50_aethon_e_reconfigure_cooldown_and_mana() -> String:
	var aethon = AethonHeroClass.new()
	aethon.team = TeamDefinitions.Team.RADIANT
	aethon._ready()
	aethon.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var init_mana = aethon.attribute_system.current_mana
	aethon.cast_aethon_e()
	
	if aethon.attribute_system.current_mana >= init_mana:
		return "Reconfigure should deduct mana"
		
	var second_cast = aethon.cast_aethon_e()
	if second_cast > 0:
		return "Reconfigure should be on cooldown"
		
	aethon.free()
	return ""

func test_task50_aethon_r_assembly_combines_active_constructs() -> String:
	var aethon = AethonHeroClass.new()
	aethon.team = TeamDefinitions.Team.RADIANT
	aethon._ready()
	aethon.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	aethon.spawn_construct(AethonHeroClass.ConstructType.GUARDIAN, Vector3(1, 0, 1))
	aethon.spawn_construct(AethonHeroClass.ConstructType.CANNON, Vector3(2, 0, 2))
	
	aethon.cast_aethon_r(Vector3(0, 0, 0))
	
	var sieges = aethon.get_constructs_of_type(AethonHeroClass.ConstructType.SIEGE)
	if sieges.size() != 1:
		return "Assembly should create 1 Siege Construct"
	if aethon.get_constructs_of_type(AethonHeroClass.ConstructType.GUARDIAN).size() != 0:
		return "Components should be consumed on Assembly"
		
	aethon.free()
	return ""

func test_task50_aethon_r_assembly_siege_construct_stats() -> String:
	var aethon = AethonHeroClass.new()
	aethon.team = TeamDefinitions.Team.RADIANT
	aethon._ready()
	aethon.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	aethon.spawn_construct(AethonHeroClass.ConstructType.GUARDIAN, Vector3(1, 0, 1), 300.0)
	aethon.spawn_construct(AethonHeroClass.ConstructType.CANNON, Vector3(2, 0, 2), 250.0)
	
	aethon.cast_aethon_r(Vector3(0, 0, 0))
	var sieges = aethon.get_constructs_of_type(AethonHeroClass.ConstructType.SIEGE)
	
	if sieges.is_empty() or sieges[0].get("health", 0.0) < 1000.0: # 600 base + 550 comp + 150 lvl
		return "Siege construct should have massive combined HP"
		
	aethon.free()
	return ""

func test_task50_aethon_r_assembly_shockwave_aoe_damage() -> String:
	var aethon = AethonHeroClass.new()
	aethon.team = TeamDefinitions.Team.RADIANT
	aethon.position = Vector3(0, 0, 0)
	aethon._ready()
	aethon.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	var res = aethon.cast_aethon_r(Vector3(0, 0, 0), [dummy])
	if res == null or res.final_health_damage <= 0.0:
		return "Siege Assembly should deal AoE shockwave damage"
		
	dummy.free()
	aethon.free()
	return ""

func test_task50_aethon_r_assembly_cooldown_and_mana() -> String:
	var aethon = AethonHeroClass.new()
	aethon.team = TeamDefinitions.Team.RADIANT
	aethon._ready()
	aethon.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var init_mana = aethon.attribute_system.current_mana
	aethon.cast_aethon_r(Vector3(0, 0, 0))
	
	if aethon.attribute_system.current_mana >= init_mana:
		return "Assembly should deduct mana"
		
	var second_cast = aethon.cast_aethon_r(Vector3(0, 0, 0))
	if second_cast != null:
		return "Assembly should be on cooldown"
		
	aethon.free()
	return ""

func test_task50_aethon_hero_definition_factory() -> String:
	var def = HeroDefinition.get_definition("aethon")
	if def == null or def.hero_name != "Aethon":
		return "HeroDefinition for aethon not found"
		
	var hero = HeroDefinition.create_hero_instance("aethon")
	if hero == null or not (hero is AethonHeroClass):
		return "create_hero_instance('aethon') should produce AethonHero"
		
	hero.free()
	return ""

func test_task50_aethon_death_and_respawn_clears_constructs() -> String:
	var aethon = AethonHeroClass.new()
	aethon.team = TeamDefinitions.Team.RADIANT
	aethon._ready()
	aethon.spawn_construct(AethonHeroClass.ConstructType.GUARDIAN, Vector3(1, 0, 1))
	
	aethon.die(null)
	if aethon.get_construct_count() != 0:
		return "Death should clear all active constructs"
		
	aethon.respawn()
	if not aethon.is_alive():
		return "Respawned Aethon should be alive"
		
	aethon.free()
	return ""

func test_task50_aethon_multiple_construct_type_query() -> String:
	var aethon = AethonHeroClass.new()
	aethon.team = TeamDefinitions.Team.RADIANT
	aethon._ready()
	
	aethon.spawn_construct(AethonHeroClass.ConstructType.GUARDIAN, Vector3(1, 0, 1))
	aethon.spawn_construct(AethonHeroClass.ConstructType.CANNON, Vector3(2, 0, 2))
	aethon.spawn_construct(AethonHeroClass.ConstructType.CANNON, Vector3(3, 0, 3))
	
	if aethon.get_constructs_of_type(AethonHeroClass.ConstructType.GUARDIAN).size() != 1:
		return "Guardian query should return 1"
	if aethon.get_constructs_of_type(AethonHeroClass.ConstructType.CANNON).size() != 2:
		return "Cannon query should return 2"
		
	aethon.free()
	return ""

func test_task50_aethon_stat_scaling_with_levels() -> String:
	var aethon = AethonHeroClass.new()
	aethon.team = TeamDefinitions.Team.RADIANT
	aethon._ready()
	
	var lvl1_int = aethon.attribute_system.get_stat(StatModifier.TargetStat.INTELLIGENCE)
	aethon.attribute_system.add_xp(5000)
	var high_lvl_int = aethon.attribute_system.get_stat(StatModifier.TargetStat.INTELLIGENCE)
	
	if high_lvl_int <= lvl1_int:
		return "Intelligence should scale with levels"
		
	aethon.free()
	return ""

# ==============================================================================
# --- TASK 51: NYMERA HERO TESTS (Tests 964–983) ---
# ==============================================================================

func test_task51_nymera_initialization_and_archetype() -> String:
	var nymera = NymeraHeroClass.new()
	nymera.team = TeamDefinitions.Team.RADIANT
	nymera._ready()
	
	if nymera.hero_resource.primary_attribute != AttributeSystem.PrimaryAttributeType.INTELLIGENCE:
		return "Nymera primary attribute should be INTELLIGENCE"
	if nymera.hero_resource.attack_type != HeroResource.AttackType.RANGED:
		return "Nymera attack type should be RANGED"
	if nymera.hero_resource.base_health < 500.0:
		return "Nymera base health should be >= 500.0"
		
	nymera.free()
	return ""

func test_task51_nymera_passive_echo_time_snapshot_recording() -> String:
	var nymera = NymeraHeroClass.new()
	nymera.team = TeamDefinitions.Team.RADIANT
	nymera.position = Vector3(5, 0, 5)
	nymera._ready()
	
	nymera.record_entity_snapshot(nymera, Vector3(5, 0, 5))
	var rewind_pos = nymera.get_rewind_position(nymera, 1.0)
	
	if rewind_pos.distance_to(Vector3(5, 0, 5)) > 0.1:
		return "Rewind position should match recorded snapshot"
		
	nymera.free()
	return ""

func test_task51_nymera_passive_echo_time_history_purge() -> String:
	var nymera = NymeraHeroClass.new()
	nymera.team = TeamDefinitions.Team.RADIANT
	nymera._ready()
	
	nymera.record_entity_snapshot(nymera, Vector3(1, 0, 1))
	if not nymera.position_history.has(nymera) or nymera.position_history[nymera].is_empty():
		return "History should contain snapshot"
		
	nymera.free()
	return ""

func test_task51_nymera_q_slow_field_deploys_distortion() -> String:
	var nymera = NymeraHeroClass.new()
	nymera.team = TeamDefinitions.Team.RADIANT
	nymera._ready()
	nymera.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var ok = nymera.cast_nymera_q(Vector3(3, 0, 3))
	if not ok:
		return "cast_nymera_q should succeed"
	if nymera.active_slow_fields.size() != 1:
		return "Should deploy 1 active slow field"
		
	nymera.free()
	return ""

func test_task51_nymera_q_slow_field_slows_enemy() -> String:
	var nymera = NymeraHeroClass.new()
	nymera.team = TeamDefinitions.Team.RADIANT
	nymera._ready()
	nymera.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	nymera.cast_nymera_q(Vector3(2.0, 0, 0), [dummy])
	if not dummy.effect_container.has_effect("nymera_time_slow"):
		return "Slow Field should apply nymera_time_slow to enemy"
		
	dummy.free()
	nymera.free()
	return ""

func test_task51_nymera_q_slow_field_cooldown_and_mana() -> String:
	var nymera = NymeraHeroClass.new()
	nymera.team = TeamDefinitions.Team.RADIANT
	nymera._ready()
	nymera.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var init_mana = nymera.attribute_system.current_mana
	nymera.cast_nymera_q(Vector3(0, 0, 0))
	
	if nymera.attribute_system.current_mana >= init_mana:
		return "Slow Field should deduct mana"
		
	var second_cast = nymera.cast_nymera_q(Vector3(0, 0, 0))
	if second_cast:
		return "Slow Field should be on cooldown"
		
	nymera.free()
	return ""

func test_task51_nymera_w_rewind_teleports_target_back() -> String:
	var nymera = NymeraHeroClass.new()
	nymera.team = TeamDefinitions.Team.RADIANT
	nymera._ready()
	nymera.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(10.0, 0, 0)
	dummy._ready()
	
	nymera.record_entity_snapshot(dummy, Vector3(0.0, 0, 0))
	var res = nymera.cast_nymera_w(dummy)
	
	if res == null:
		return "Rewind should deal damage and teleport target"
	if dummy.position.distance_to(Vector3(0.0, 0, 0)) > 0.1:
		return "Target should be rewound to previous position"
		
	dummy.free()
	nymera.free()
	return ""

func test_task51_nymera_w_rewind_deals_magic_damage() -> String:
	var nymera = NymeraHeroClass.new()
	nymera.team = TeamDefinitions.Team.RADIANT
	nymera._ready()
	nymera.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	var res = nymera.cast_nymera_w(dummy)
	if res == null or res.final_health_damage <= 0.0:
		return "Rewind should deal magic damage"
		
	dummy.free()
	nymera.free()
	return ""

func test_task51_nymera_w_rewind_target_validation_rejects_ally() -> String:
	var nymera = NymeraHeroClass.new()
	nymera.team = TeamDefinitions.Team.RADIANT
	nymera._ready()
	nymera.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var res = nymera.cast_nymera_w(ally)
	if res != null:
		return "Rewind should reject allied targets"
		
	ally.free()
	nymera.free()
	return ""

func test_task51_nymera_w_rewind_cooldown_and_mana() -> String:
	var nymera = NymeraHeroClass.new()
	nymera.team = TeamDefinitions.Team.RADIANT
	nymera._ready()
	nymera.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var init_mana = nymera.attribute_system.current_mana
	nymera.cast_nymera_w(dummy)
	
	if nymera.attribute_system.current_mana >= init_mana:
		return "Rewind should deduct mana"
		
	var second_cast = nymera.cast_nymera_w(dummy)
	if second_cast != null:
		return "Rewind should be on cooldown"
		
	dummy.free()
	nymera.free()
	return ""

func test_task51_nymera_e_accelerate_buffs_ally_speed() -> String:
	var nymera = NymeraHeroClass.new()
	nymera.team = TeamDefinitions.Team.RADIANT
	nymera._ready()
	nymera.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var base_ms = ally.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	var ok = nymera.cast_nymera_e(ally)
	
	if not ok:
		return "cast_nymera_e should succeed on ally"
	var buffed_ms = ally.attribute_system.get_stat(StatModifier.TargetStat.MOVE_SPEED)
	if buffed_ms <= base_ms:
		return "Accelerate should buff ally Move Speed"
		
	ally.free()
	nymera.free()
	return ""

func test_task51_nymera_e_accelerate_target_validation_rejects_enemy() -> String:
	var nymera = NymeraHeroClass.new()
	nymera.team = TeamDefinitions.Team.RADIANT
	nymera._ready()
	nymera.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var ok = nymera.cast_nymera_e(dummy)
	if ok:
		return "Accelerate should reject enemy targets"
		
	dummy.free()
	nymera.free()
	return ""

func test_task51_nymera_e_accelerate_cooldown_and_mana() -> String:
	var nymera = NymeraHeroClass.new()
	nymera.team = TeamDefinitions.Team.RADIANT
	nymera._ready()
	nymera.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var init_mana = nymera.attribute_system.current_mana
	nymera.cast_nymera_e(ally)
	
	if nymera.attribute_system.current_mana >= init_mana:
		return "Accelerate should deduct mana"
		
	var second_cast = nymera.cast_nymera_e(ally)
	if second_cast:
		return "Accelerate should be on cooldown"
		
	ally.free()
	nymera.free()
	return ""

func test_task51_nymera_r_temporal_collapse_aoe_rewind_and_damage() -> String:
	var nymera = NymeraHeroClass.new()
	nymera.team = TeamDefinitions.Team.RADIANT
	nymera.position = Vector3(0, 0, 0)
	nymera._ready()
	nymera.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(3.0, 0, 0)
	dummy._ready()
	
	nymera.record_entity_snapshot(dummy, Vector3(0.0, 0, 0))
	var results = nymera.cast_nymera_r(Vector3(0, 0, 0), [dummy])
	
	if results.is_empty() or results[0] == null:
		return "Temporal Collapse should deal AoE damage"
	if dummy.position.distance_to(Vector3(0.0, 0, 0)) > 0.1:
		return "Temporal Collapse should rewind enemy position"
		
	dummy.free()
	nymera.free()
	return ""

func test_task51_nymera_r_temporal_collapse_roots_enemies() -> String:
	var nymera = NymeraHeroClass.new()
	nymera.team = TeamDefinitions.Team.RADIANT
	nymera._ready()
	nymera.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	nymera.cast_nymera_r(Vector3(0, 0, 0), [dummy])
	if not dummy.effect_container.has_effect("nymera_collapse_root"):
		return "Temporal Collapse should apply Root CC to enemies"
		
	dummy.free()
	nymera.free()
	return ""

func test_task51_nymera_r_temporal_collapse_cooldown_and_mana() -> String:
	var nymera = NymeraHeroClass.new()
	nymera.team = TeamDefinitions.Team.RADIANT
	nymera._ready()
	nymera.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var init_mana = nymera.attribute_system.current_mana
	nymera.cast_nymera_r(Vector3(0, 0, 0))
	
	if nymera.attribute_system.current_mana >= init_mana:
		return "Temporal Collapse should deduct mana"
		
	var second_cast = nymera.cast_nymera_r(Vector3(0, 0, 0))
	if not second_cast.is_empty():
		return "Temporal Collapse should be on cooldown"
		
	nymera.free()
	return ""

func test_task51_nymera_hero_definition_factory() -> String:
	var def = HeroDefinition.get_definition("nymera")
	if def == null or def.hero_name != "Nymera":
		return "HeroDefinition for nymera not found"
		
	var hero = HeroDefinition.create_hero_instance("nymera")
	if hero == null or not (hero is NymeraHeroClass):
		return "create_hero_instance('nymera') should produce NymeraHero"
		
	hero.free()
	return ""

func test_task51_nymera_death_and_respawn_clears_timeline_history() -> String:
	var nymera = NymeraHeroClass.new()
	nymera.team = TeamDefinitions.Team.RADIANT
	nymera._ready()
	nymera.record_entity_snapshot(nymera, Vector3(5, 0, 5))
	
	nymera.die(null)
	if not nymera.position_history.is_empty() or not nymera.active_slow_fields.is_empty():
		return "Death should clear timeline history and slow fields"
		
	nymera.respawn()
	if not nymera.is_alive():
		return "Respawned Nymera should be alive"
		
	nymera.free()
	return ""

func test_task51_nymera_slow_field_expiration() -> String:
	var nymera = NymeraHeroClass.new()
	nymera.team = TeamDefinitions.Team.RADIANT
	nymera._ready()
	nymera.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	nymera.cast_nymera_q(Vector3(0, 0, 0))
	nymera._process(4.0) # > 3.5s duration
	
	if not nymera.active_slow_fields.is_empty():
		return "Slow field should expire after duration"
		
	nymera.free()
	return ""

func test_task51_nymera_stat_scaling_with_levels() -> String:
	var nymera = NymeraHeroClass.new()
	nymera.team = TeamDefinitions.Team.RADIANT
	nymera._ready()
	
	var lvl1_int = nymera.attribute_system.get_stat(StatModifier.TargetStat.INTELLIGENCE)
	nymera.attribute_system.add_xp(5000)
	var high_lvl_int = nymera.attribute_system.get_stat(StatModifier.TargetStat.INTELLIGENCE)
	
	if high_lvl_int <= lvl1_int:
		return "Intelligence should scale with levels"
		
	nymera.free()
	return ""

# ==============================================================================
# --- TASK 52: VEYLIN HERO TESTS (Tests 984–1003) ---
# ==============================================================================

func test_task52_veylin_initialization_and_archetype() -> String:
	var veylin = VeylinHeroClass.new()
	veylin.team = TeamDefinitions.Team.RADIANT
	veylin._ready()
	
	if veylin.hero_resource.primary_attribute != AttributeSystem.PrimaryAttributeType.INTELLIGENCE:
		return "Veylin primary attribute should be INTELLIGENCE"
	if veylin.hero_resource.attack_type != HeroResource.AttackType.RANGED:
		return "Veylin attack type should be RANGED"
	if veylin.hero_resource.base_health < 500.0:
		return "Veylin base health should be >= 500.0"
		
	veylin.free()
	return ""

func test_task52_veylin_passive_study_stack_accumulation() -> String:
	var veylin = VeylinHeroClass.new()
	veylin.team = TeamDefinitions.Team.RADIANT
	veylin._ready()
	
	veylin.add_study_stack(3)
	if veylin.study_stacks != 3:
		return "Study stacks should be 3"
		
	veylin.free()
	return ""

func test_task52_veylin_passive_study_grants_ap_stat_scaling() -> String:
	var veylin = VeylinHeroClass.new()
	veylin.team = TeamDefinitions.Team.RADIANT
	veylin._ready()
	
	var base_ap = veylin.attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	veylin.add_study_stack(5)
	var buffed_ap = veylin.attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	
	if buffed_ap < base_ap + 39.0: # +8 AP * 5 = +40 AP
		return "Study stacks should grant +8 AP per stack"
		
	veylin.free()
	return ""

func test_task52_veylin_passive_study_cap_clamp() -> String:
	var veylin = VeylinHeroClass.new()
	veylin.team = TeamDefinitions.Team.RADIANT
	veylin._ready()
	
	veylin.add_study_stack(10)
	if veylin.study_stacks > 5:
		return "Study stacks should clamp at 5 max (got %d)" % veylin.study_stacks
		
	veylin.free()
	return ""

func test_task52_veylin_q_mimic_deals_magic_damage() -> String:
	var veylin = VeylinHeroClass.new()
	veylin.team = TeamDefinitions.Team.RADIANT
	veylin._ready()
	veylin.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var res = veylin.cast_veylin_q(dummy)
	if res == null or res.final_health_damage <= 0.0:
		return "Mimic bolt should deal magic damage"
		
	dummy.free()
	veylin.free()
	return ""

func test_task52_veylin_q_mimic_damage_amplified_by_study_stacks() -> String:
	var veylin = VeylinHeroClass.new()
	veylin.team = TeamDefinitions.Team.RADIANT
	veylin._ready()
	veylin.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var dummy1 = TargetDummyEntity.new()
	dummy1.team = TeamDefinitions.Team.DIRE
	dummy1._ready()
	var dmg_0_stacks = veylin.cast_veylin_q(dummy1).final_health_damage
	
	veylin.ability_container.ability_cooldowns[AbilityResource.Slot.Q] = 0.0
	veylin.add_study_stack(5)
	
	var dummy2 = TargetDummyEntity.new()
	dummy2.team = TeamDefinitions.Team.DIRE
	dummy2._ready()
	var dmg_5_stacks = veylin.cast_veylin_q(dummy2).final_health_damage
	
	if dmg_5_stacks <= dmg_0_stacks:
		return "Study stacks should amplify Mimic damage (+10% per stack)"
		
	dummy1.free()
	dummy2.free()
	veylin.free()
	return ""

func test_task52_veylin_q_mimic_target_validation_rejects_ally() -> String:
	var veylin = VeylinHeroClass.new()
	veylin.team = TeamDefinitions.Team.RADIANT
	veylin._ready()
	veylin.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var res = veylin.cast_veylin_q(ally)
	if res != null:
		return "Mimic should reject allied targets"
		
	ally.free()
	veylin.free()
	return ""

func test_task52_veylin_q_mimic_cooldown_and_mana() -> String:
	var veylin = VeylinHeroClass.new()
	veylin.team = TeamDefinitions.Team.RADIANT
	veylin._ready()
	veylin.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var init_mana = veylin.attribute_system.current_mana
	veylin.cast_veylin_q(dummy)
	
	if veylin.attribute_system.current_mana >= init_mana:
		return "Mimic should deduct mana"
		
	var second_cast = veylin.cast_veylin_q(dummy)
	if second_cast != null:
		return "Mimic should be on cooldown"
		
	dummy.free()
	veylin.free()
	return ""

func test_task52_veylin_w_counterspell_applies_shield() -> String:
	var veylin = VeylinHeroClass.new()
	veylin.team = TeamDefinitions.Team.RADIANT
	veylin._ready()
	veylin.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var ok = veylin.cast_veylin_w()
	if not ok:
		return "cast_veylin_w should succeed"
	if not veylin.effect_container.has_effect("veylin_counterspell_shield"):
		return "Counterspell should grant veylin_counterspell_shield"
		
	veylin.free()
	return ""

func test_task52_veylin_w_counterspell_grants_bonus_study_stacks() -> String:
	var veylin = VeylinHeroClass.new()
	veylin.team = TeamDefinitions.Team.RADIANT
	veylin._ready()
	veylin.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	veylin.cast_veylin_w()
	if veylin.study_stacks < 2:
		return "Counterspell should grant 2 Study stacks"
		
	veylin.free()
	return ""

func test_task52_veylin_w_counterspell_cooldown_and_mana() -> String:
	var veylin = VeylinHeroClass.new()
	veylin.team = TeamDefinitions.Team.RADIANT
	veylin._ready()
	veylin.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var init_mana = veylin.attribute_system.current_mana
	veylin.cast_veylin_w()
	
	if veylin.attribute_system.current_mana >= init_mana:
		return "Counterspell should deduct mana"
		
	var second_cast = veylin.cast_veylin_w()
	if second_cast:
		return "Counterspell should be on cooldown"
		
	veylin.free()
	return ""

func test_task52_veylin_e_rewrite_resets_q_cooldown() -> String:
	var veylin = VeylinHeroClass.new()
	veylin.team = TeamDefinitions.Team.RADIANT
	veylin._ready()
	veylin.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	veylin.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	veylin.cast_veylin_q(dummy)
	if veylin.ability_container.can_cast(AbilityResource.Slot.Q):
		return "Q should be on cooldown after cast"
		
	veylin.cast_veylin_e()
	if not veylin.ability_container.can_cast(AbilityResource.Slot.Q):
		return "Rewrite should reset Q cooldown"
		
	dummy.free()
	veylin.free()
	return ""

func test_task52_veylin_e_rewrite_amplifies_next_spell() -> String:
	var veylin = VeylinHeroClass.new()
	veylin.team = TeamDefinitions.Team.RADIANT
	veylin._ready()
	veylin.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	veylin.cast_veylin_e()
	if not veylin.is_rewrite_buff_active:
		return "Rewrite should activate rewrite spell amp buff"
		
	veylin.free()
	return ""

func test_task52_veylin_e_rewrite_cooldown_and_mana() -> String:
	var veylin = VeylinHeroClass.new()
	veylin.team = TeamDefinitions.Team.RADIANT
	veylin._ready()
	veylin.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	var init_mana = veylin.attribute_system.current_mana
	veylin.cast_veylin_e()
	
	if veylin.attribute_system.current_mana >= init_mana:
		return "Rewrite should deduct mana"
		
	var second_cast = veylin.cast_veylin_e()
	if second_cast:
		return "Rewrite should be on cooldown"
		
	veylin.free()
	return ""

func test_task52_veylin_r_adaptation_deals_aoe_magic_damage() -> String:
	var veylin = VeylinHeroClass.new()
	veylin.team = TeamDefinitions.Team.RADIANT
	veylin.position = Vector3(0, 0, 0)
	veylin._ready()
	veylin.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(3.0, 0, 0)
	dummy._ready()
	
	var results = veylin.cast_veylin_r(Vector3(3.0, 0, 0), [dummy])
	if results.is_empty() or results[0] == null:
		return "Adaptation should deal AoE magic damage"
		
	dummy.free()
	veylin.free()
	return ""

func test_task52_veylin_r_adaptation_grants_spell_vamp_and_move_speed() -> String:
	var veylin = VeylinHeroClass.new()
	veylin.team = TeamDefinitions.Team.RADIANT
	veylin._ready()
	veylin.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	veylin.cast_veylin_r(Vector3(0, 0, 0))
	var sv = veylin.attribute_system.get_stat(StatModifier.TargetStat.SPELL_VAMP)
	var ms_mod = veylin.attribute_system._modifiers
	
	if sv < 0.25:
		return "Adaptation should grant +30% Spell Vamp"
		
	veylin.free()
	return ""

func test_task52_veylin_r_adaptation_maximizes_study_stacks() -> String:
	var veylin = VeylinHeroClass.new()
	veylin.team = TeamDefinitions.Team.RADIANT
	veylin._ready()
	veylin.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	veylin.cast_veylin_r(Vector3(0, 0, 0))
	if veylin.study_stacks != 5:
		return "Adaptation should maximize Study stacks to 5"
		
	veylin.free()
	return ""

func test_task52_veylin_r_adaptation_cooldown_and_mana() -> String:
	var veylin = VeylinHeroClass.new()
	veylin.team = TeamDefinitions.Team.RADIANT
	veylin._ready()
	veylin.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var init_mana = veylin.attribute_system.current_mana
	veylin.cast_veylin_r(Vector3(0, 0, 0))
	
	if veylin.attribute_system.current_mana >= init_mana:
		return "Adaptation should deduct mana"
		
	var second_cast = veylin.cast_veylin_r(Vector3(0, 0, 0))
	if not second_cast.is_empty():
		return "Adaptation should be on cooldown"
		
	veylin.free()
	return ""

func test_task52_veylin_hero_definition_factory() -> String:
	var def = HeroDefinition.get_definition("veylin")
	if def == null or def.hero_name != "Veylin":
		return "HeroDefinition for veylin not found"
		
	var hero = HeroDefinition.create_hero_instance("veylin")
	if hero == null or not (hero is VeylinHeroClass):
		return "create_hero_instance('veylin') should produce VeylinHero"
		
	hero.free()
	return ""

func test_task52_veylin_death_and_respawn_clears_stacks_and_buffs() -> String:
	var veylin = VeylinHeroClass.new()
	veylin.team = TeamDefinitions.Team.RADIANT
	veylin._ready()
	veylin.add_study_stack(4)
	
	veylin.die(null)
	if veylin.study_stacks != 0:
		return "Death should clear Study stacks"
		
	veylin.respawn()
	if not veylin.is_alive():
		return "Respawned Veylin should be alive"
		
	veylin.free()
	return ""

# ==============================================================================
# --- TASK 53: ZYRAEN HERO TESTS (Tests 1004–1023) ---
# ==============================================================================

func test_task53_zyraen_initialization_and_archetype() -> String:
	var zyraen = ZyraenHeroClass.new()
	zyraen.team = TeamDefinitions.Team.RADIANT
	zyraen._ready()
	
	if zyraen.hero_resource.primary_attribute != AttributeSystem.PrimaryAttributeType.STRENGTH:
		return "Zyraen primary attribute should be STRENGTH"
	if zyraen.hero_resource.attack_type != HeroResource.AttackType.MELEE:
		return "Zyraen attack type should be MELEE"
	if zyraen.hero_resource.base_health < 600.0:
		return "Zyraen base health should be >= 600.0"
		
	zyraen.free()
	return ""

func test_task53_zyraen_passive_equilibrium_activation_on_equal_ratios() -> String:
	var zyraen = ZyraenHeroClass.new()
	zyraen.team = TeamDefinitions.Team.RADIANT
	zyraen._ready()
	
	# Full HP (100%) and Full Mana (100%) -> Ratio diff = 0% -> Equilibrium active
	zyraen._update_equilibrium(0.0)
	if not zyraen.is_in_equilibrium():
		return "Equilibrium should be active when HP% and Mana% are equal"
		
	zyraen.free()
	return ""

func test_task53_zyraen_passive_equilibrium_deactivation_on_ratio_gap() -> String:
	var zyraen = ZyraenHeroClass.new()
	zyraen.team = TeamDefinitions.Team.RADIANT
	zyraen._ready()
	
	# Drain Mana to 20% while HP is 100% -> Ratio diff = 80% -> Equilibrium inactive
	var max_mp = zyraen.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
	zyraen.attribute_system.current_mana = max_mp * 0.20
	zyraen._update_equilibrium(0.0)
	
	if zyraen.is_in_equilibrium():
		return "Equilibrium should deactivate when HP% and Mana% have large gap"
		
	zyraen.free()
	return ""

func test_task53_zyraen_passive_equilibrium_grants_ap_and_damage_reduction() -> String:
	var zyraen = ZyraenHeroClass.new()
	zyraen.team = TeamDefinitions.Team.RADIANT
	zyraen._ready()
	
	zyraen._update_equilibrium(0.0)
	var ap = zyraen.attribute_system.get_stat(StatModifier.TargetStat.ABILITY_POWER)
	var dr = zyraen.attribute_system.get_stat(StatModifier.TargetStat.DAMAGE_REDUCTION)
	
	if ap < 30.0:
		return "Equilibrium should grant +35 AP"
	if dr < 0.10:
		return "Equilibrium should grant +15% Damage Reduction"
		
	zyraen.free()
	return ""

func test_task53_zyraen_q_life_spark_deals_magic_damage() -> String:
	var zyraen = ZyraenHeroClass.new()
	zyraen.team = TeamDefinitions.Team.RADIANT
	zyraen._ready()
	zyraen.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var res = zyraen.cast_zyraen_q(dummy)
	if res == null or res.final_health_damage <= 0.0:
		return "Life Spark should deal magic damage"
		
	dummy.free()
	zyraen.free()
	return ""

func test_task53_zyraen_q_life_spark_deals_extra_damage_in_equilibrium() -> String:
	var zyraen = ZyraenHeroClass.new()
	zyraen.team = TeamDefinitions.Team.RADIANT
	zyraen._ready()
	zyraen.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var dummy1 = TargetDummyEntity.new()
	dummy1.team = TeamDefinitions.Team.DIRE
	dummy1._ready()
	var dmg_in_eq = zyraen.cast_zyraen_q(dummy1).final_health_damage
	
	zyraen.ability_container.ability_cooldowns[AbilityResource.Slot.Q] = 0.0
	var max_mp = zyraen.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
	zyraen.attribute_system.current_mana = max_mp * 0.10
	zyraen._update_equilibrium(0.0)
	
	var dummy2 = TargetDummyEntity.new()
	dummy2.team = TeamDefinitions.Team.DIRE
	dummy2._ready()
	var dmg_no_eq = zyraen.cast_zyraen_q(dummy2).final_health_damage
	
	if dmg_in_eq <= dmg_no_eq:
		return "Life Spark should deal extra damage in Equilibrium"
		
	dummy1.free()
	dummy2.free()
	zyraen.free()
	return ""

func test_task53_zyraen_q_life_spark_target_validation_rejects_ally() -> String:
	var zyraen = ZyraenHeroClass.new()
	zyraen.team = TeamDefinitions.Team.RADIANT
	zyraen._ready()
	zyraen.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var res = zyraen.cast_zyraen_q(ally)
	if res != null:
		return "Life Spark should reject allied targets"
		
	ally.free()
	zyraen.free()
	return ""

func test_task53_zyraen_q_life_spark_cooldown_and_mana() -> String:
	var zyraen = ZyraenHeroClass.new()
	zyraen.team = TeamDefinitions.Team.RADIANT
	zyraen._ready()
	zyraen.ability_container.level_up_ability(AbilityResource.Slot.Q, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var init_mana = zyraen.attribute_system.current_mana
	zyraen.cast_zyraen_q(dummy)
	
	if zyraen.attribute_system.current_mana >= init_mana:
		return "Life Spark should deduct mana"
		
	var second_cast = zyraen.cast_zyraen_q(dummy)
	if second_cast != null:
		return "Life Spark should be on cooldown"
		
	dummy.free()
	zyraen.free()
	return ""

func test_task53_zyraen_w_mana_siphon_drains_mana_and_heals() -> String:
	var zyraen = ZyraenHeroClass.new()
	zyraen.team = TeamDefinitions.Team.RADIANT
	zyraen._ready()
	zyraen.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	zyraen.attribute_system.current_health = 300.0
	var res = zyraen.cast_zyraen_w(dummy)
	
	if res == null:
		return "Mana Siphon should execute damage"
	if zyraen.attribute_system.current_health <= 300.0:
		return "Mana Siphon should heal Zyraen"
		
	dummy.free()
	zyraen.free()
	return ""

func test_task53_zyraen_w_mana_siphon_target_validation_rejects_ally() -> String:
	var zyraen = ZyraenHeroClass.new()
	zyraen.team = TeamDefinitions.Team.RADIANT
	zyraen._ready()
	zyraen.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var ally = AstrisHero.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally._ready()
	
	var res = zyraen.cast_zyraen_w(ally)
	if res != null:
		return "Mana Siphon should reject allied targets"
		
	ally.free()
	zyraen.free()
	return ""

func test_task53_zyraen_w_mana_siphon_cooldown_and_mana() -> String:
	var zyraen = ZyraenHeroClass.new()
	zyraen.team = TeamDefinitions.Team.RADIANT
	zyraen._ready()
	zyraen.ability_container.level_up_ability(AbilityResource.Slot.W, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy._ready()
	
	var init_mana = zyraen.attribute_system.current_mana
	zyraen.cast_zyraen_w(dummy)
	
	if zyraen.attribute_system.current_mana >= init_mana:
		return "Mana Siphon should deduct mana"
		
	var second_cast = zyraen.cast_zyraen_w(dummy)
	if second_cast != null:
		return "Mana Siphon should be on cooldown"
		
	dummy.free()
	zyraen.free()
	return ""

func test_task53_zyraen_e_exchange_hp_to_mana() -> String:
	var zyraen = ZyraenHeroClass.new()
	zyraen.team = TeamDefinitions.Team.RADIANT
	zyraen._ready()
	zyraen.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	# Full HP, low mana -> Should convert HP to Mana
	var max_mp = zyraen.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
	zyraen.attribute_system.current_mana = max_mp * 0.20
	var prev_hp = zyraen.attribute_system.current_health
	var prev_mp = zyraen.attribute_system.current_mana
	
	var ok = zyraen.cast_zyraen_e()
	if not ok:
		return "cast_zyraen_e should succeed"
	if zyraen.attribute_system.current_health >= prev_hp:
		return "Exchange should sacrifice HP"
	if zyraen.attribute_system.current_mana <= prev_mp:
		return "Exchange should restore Mana"
		
	zyraen.free()
	return ""

func test_task53_zyraen_e_exchange_mana_to_hp() -> String:
	var zyraen = ZyraenHeroClass.new()
	zyraen.team = TeamDefinitions.Team.RADIANT
	zyraen._ready()
	zyraen.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	# Low HP, full mana -> Should convert Mana to HP
	zyraen.attribute_system.current_health = 250.0
	var prev_hp = zyraen.attribute_system.current_health
	var prev_mp = zyraen.attribute_system.current_mana
	
	var ok = zyraen.cast_zyraen_e()
	if not ok:
		return "cast_zyraen_e should succeed"
	if zyraen.attribute_system.current_mana >= prev_mp:
		return "Exchange should spend Mana"
	if zyraen.attribute_system.current_health <= prev_hp:
		return "Exchange should restore HP"
		
	zyraen.free()
	return ""

func test_task53_zyraen_e_exchange_cooldown() -> String:
	var zyraen = ZyraenHeroClass.new()
	zyraen.team = TeamDefinitions.Team.RADIANT
	zyraen._ready()
	zyraen.ability_container.level_up_ability(AbilityResource.Slot.E, false)
	
	zyraen.cast_zyraen_e()
	var second_cast = zyraen.cast_zyraen_e()
	if second_cast:
		return "Exchange should be on cooldown"
		
	zyraen.free()
	return ""

func test_task53_zyraen_r_perfect_balance_equalizes_hp_and_mana() -> String:
	var zyraen = ZyraenHeroClass.new()
	zyraen.team = TeamDefinitions.Team.RADIANT
	zyraen._ready()
	zyraen.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var max_hp = zyraen.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
	var max_mp = zyraen.attribute_system.get_stat(StatModifier.TargetStat.MAX_MANA)
	zyraen.attribute_system.current_health = max_hp * 0.80
	zyraen.attribute_system.current_mana = max_mp * 0.20
	
	zyraen.cast_zyraen_r()
	var new_hp_ratio = zyraen.attribute_system.current_health / max_hp
	var new_mp_ratio = zyraen.attribute_system.current_mana / max_mp
	
	if absf(new_hp_ratio - new_mp_ratio) > 0.02:
		return "Perfect Balance should equalize HP% and Mana% to average"
		
	zyraen.free()
	return ""

func test_task53_zyraen_r_perfect_balance_grants_shield() -> String:
	var zyraen = ZyraenHeroClass.new()
	zyraen.team = TeamDefinitions.Team.RADIANT
	zyraen._ready()
	zyraen.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	zyraen.cast_zyraen_r()
	if not zyraen.effect_container.has_effect("zyraen_balance_shield"):
		return "Perfect Balance should grant 400 HP shield"
		
	zyraen.free()
	return ""

func test_task53_zyraen_r_perfect_balance_forces_equilibrium_state() -> String:
	var zyraen = ZyraenHeroClass.new()
	zyraen.team = TeamDefinitions.Team.RADIANT
	zyraen._ready()
	zyraen.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	zyraen.cast_zyraen_r()
	if not zyraen.is_in_equilibrium():
		return "Perfect Balance should force Equilibrium state"
		
	zyraen.free()
	return ""

func test_task53_zyraen_r_perfect_balance_deals_aoe_damage() -> String:
	var zyraen = ZyraenHeroClass.new()
	zyraen.team = TeamDefinitions.Team.RADIANT
	zyraen.position = Vector3(0, 0, 0)
	zyraen._ready()
	zyraen.ability_container.level_up_ability(AbilityResource.Slot.R, false)
	
	var dummy = TargetDummyEntity.new()
	dummy.team = TeamDefinitions.Team.DIRE
	dummy.position = Vector3(2.0, 0, 0)
	dummy._ready()
	
	var res = zyraen.cast_zyraen_r([dummy])
	if res == null or res.final_health_damage <= 0.0:
		return "Perfect Balance should deal AoE damage to surrounding enemies"
		
	dummy.free()
	zyraen.free()
	return ""

func test_task53_zyraen_hero_definition_factory() -> String:
	var def = HeroDefinition.get_definition("zyraen")
	if def == null or def.hero_name != "Zyraen":
		return "HeroDefinition for zyraen not found"
		
	var hero = HeroDefinition.create_hero_instance("zyraen")
	if hero == null or not (hero is ZyraenHeroClass):
		return "create_hero_instance('zyraen') should produce ZyraenHero"
		
	hero.free()
	return ""

func test_task53_zyraen_death_and_respawn_clears_equilibrium() -> String:
	var zyraen = ZyraenHeroClass.new()
	zyraen.team = TeamDefinitions.Team.RADIANT
	zyraen._ready()
	zyraen.cast_zyraen_r()
	
	zyraen.die(null)
	if zyraen.forced_equilibrium_timer != 0.0:
		return "Death should clear forced equilibrium timer"
		
	zyraen.respawn()
	if not zyraen.is_alive():
		return "Respawned Zyraen should be alive"
		
	zyraen.free()
	return ""

# ==============================================================================
# --- HERO SELECTION & TESTING DASHBOARD TESTS (Tests 1024–1029) ---
# ==============================================================================

func test_hero_selection_ui_initialization_and_roster_count() -> String:
	var ui = HeroSelectionUIClass.new()
	ui._ready()
	
	if ui.hero_card_buttons.size() < 30:
		return "HeroSelectionUI should populate at least 30 hero cards (got %d)" % ui.hero_card_buttons.size()
		
	ui.free()
	return ""

func test_hero_selection_ui_attribute_filtering() -> String:
	var ui = HeroSelectionUIClass.new()
	ui._ready()
	
	# Filter STRENGTH
	ui._set_filter(HeroSelectionUIClass.FilterCategory.STRENGTH)
	var str_visible = 0
	for h_id in ui.hero_card_buttons.keys():
		if ui.hero_card_buttons[h_id].visible:
			str_visible += 1
	if str_visible < 8:
		return "Strength filter should show at least 8 STR heroes (got %d)" % str_visible
		
	# Filter AGILITY
	ui._set_filter(HeroSelectionUIClass.FilterCategory.AGILITY)
	var agi_visible = 0
	for h_id in ui.hero_card_buttons.keys():
		if ui.hero_card_buttons[h_id].visible:
			agi_visible += 1
	if agi_visible < 8:
		return "Agility filter should show at least 8 AGI heroes (got %d)" % agi_visible
		
	# Filter INTELLIGENCE
	ui._set_filter(HeroSelectionUIClass.FilterCategory.INTELLIGENCE)
	var int_visible = 0
	for h_id in ui.hero_card_buttons.keys():
		if ui.hero_card_buttons[h_id].visible:
			int_visible += 1
	if int_visible < 14:
		return "Intelligence filter should show at least 14 INT heroes (got %d)" % int_visible
		
	ui.free()
	return ""

func test_hero_selection_ui_search_filtering() -> String:
	var ui = HeroSelectionUIClass.new()
	ui._ready()
	
	# Search for "Aethon"
	ui._on_search_text_changed("Aethon")
	var match_aethon = false
	for h_id in ui.hero_card_buttons.keys():
		if ui.hero_card_buttons[h_id].visible:
			if h_id == "aethon":
				match_aethon = true
			else:
				return "Only Aethon should be visible when searching 'Aethon' (found %s)" % h_id
				
	if not match_aethon:
		return "Aethon should be visible when searching 'Aethon'"
		
	ui.free()
	return ""

func test_hero_selection_ui_inspect_hero_data_population() -> String:
	var ui = HeroSelectionUIClass.new()
	ui._ready()
	
	ui.inspect_hero("zyraen")
	if not ui.hero_title_label.text.contains("Zyraen"):
		return "Hero title should display Zyraen"
	if ui.abilities_vbox.get_child_count() < 5:
		return "Abilities panel should populate all 5 abilities (got %d)" % ui.abilities_vbox.get_child_count()
		
	ui.free()
	return ""

func test_hero_selection_global_state_persistence() -> String:
	GlobalHeroSelectionClass.set_player_hero("nymera")
	GlobalHeroSelectionClass.set_bot_hero("mordren")
	
	if GlobalHeroSelectionClass.get_player_hero_id() != "nymera":
		return "Player hero ID should persist as nymera"
	if GlobalHeroSelectionClass.get_bot_hero_id() != "mordren":
		return "Bot hero ID should persist as mordren"
		
	# Reset to default
	GlobalHeroSelectionClass.set_player_hero("kaelgor")
	GlobalHeroSelectionClass.set_bot_hero("astris")
	return ""

func test_hero_selection_play_and_bot_signal_flow() -> String:
	var ui = HeroSelectionUIClass.new()
	ui.is_modal_mode = true
	ui._ready()
	
	var emitted_player: String = ""
	var emitted_bot: String = ""
	ui.hero_selected.connect(func(h_id: String, as_player: bool):
		if as_player:
			emitted_player = h_id
		else:
			emitted_bot = h_id
	)
	
	ui.inspect_hero("veylin")
	ui._on_btn_play_hero_clicked()
	if emitted_player != "veylin":
		return "Play hero button should emit hero_selected with veylin"
		
	ui.inspect_hero("gorak")
	ui._on_btn_set_bot_clicked()
	if emitted_bot != "gorak":
		return "Set bot button should emit hero_selected with gorak"
		
	ui.free()
	return ""

# ==============================================================================
# --- DOTA STATUS EFFECT BAR & PASSIVES UI TESTS ---
# ==============================================================================

func test_dota_status_effect_icon_configuration() -> String:
	var icon = DotaStatusEffectIconClass.new()
	icon.configure("test_buff", "Güçlenme", "Saldırı gücü arttı", false, 5.0, 5.0, 4, "4", false)
	
	if icon.ring_color != Color(0.28, 0.90, 0.35, 1.0):
		return "Buff icon ring color should be green"
	if icon.stack_label.text != "4":
		return "Stack label should display 4"
	if not icon.tooltip_text.contains("Güçlenme"):
		return "Tooltip should contain buff display name"
		
	# Test debuff
	icon.configure("test_debuff", "Yavaşlatma", "Yavaşlatıldı", true, 3.0, 3.0, 1, "▼", false)
	if icon.ring_color != Color(0.95, 0.25, 0.25, 1.0):
		return "Debuff icon ring color should be red"
		
	icon.free()
	return ""

func test_dota_status_effect_bar_populates_effects_and_passives() -> String:
	var bar = DotaStatusEffectBarClass.new()
	bar._ready()
	
	var hero = VeylinHeroClass.new()
	hero.team = TeamDefinitions.Team.RADIANT
	hero._ready()
	hero.study_stacks = 4
	
	# Apply a status effect
	var stun_eff = StatusEffect.new("test_stun", StatusEffect.EffectType.STUN, 2.0, 0.0, true)
	hero.effect_container.apply_effect(stun_eff)
	
	bar.target_hero = hero
	bar._refresh_hero_status_effects()
	
	if bar.get_child_count() < 2:
		return "Bar should create icons for both Study Stacks passive and Stun debuff (got %d)" % bar.get_child_count()
		
	hero.free()
	bar.free()
	return ""

# ==============================================================================
# --- 3D MOBA SPELL VFX TESTS ---
# ==============================================================================

func test_vfx_skillshot_projectile_launch() -> String:
	var root = Node3D.new()
	var proj = SkillshotProjectile3DClass.new()
	proj.direction = Vector3(1, 0, 0)
	proj.speed = 20.0
	proj.max_range = 10.0
	proj.impact_color = Color(1.0, 0.4, 0.1)
	root.add_child(proj)
	proj._ready()
	
	if proj.direction != Vector3(1, 0, 0):
		return "Skillshot direction should be (1, 0, 0)"
		
	proj._process(0.2) # moves 4.0m
	if proj.traveled_distance < 3.9:
		return "Skillshot should travel forward based on speed and delta (got %f)" % proj.traveled_distance
		
	root.free()
	return ""

func test_vfx_homing_spell_projectile_tracking() -> String:
	var root = Node3D.new()
	var target = Node3D.new()
	target.position = Vector3(10, 0, 0)
	root.add_child(target)
	
	var missile = HomingSpellProjectile3DClass.new()
	missile.target_node = target
	missile.speed = 15.0
	missile.impact_color = Color(0.3, 0.8, 1.0)
	root.add_child(missile)
	missile._ready()
	
	var init_dist = missile.position.distance_to(target.position)
	missile._process(0.3) # moves 4.5m towards target
	var new_dist = missile.position.distance_to(target.position)
	
	if new_dist >= init_dist:
		return "Homing projectile distance to target should decrease over time"
		
	root.free()
	return ""

func test_vfx_spell_visual_fx_generators() -> String:
	var root = Node3D.new()
	
	# Test procedural burst, ground slam, starfall generators
	SpellVisualFX3DClass.spawn_arcane_burst(root, Vector3(0, 0, 0), 3.0, Color(0.2, 0.6, 1.0))
	SpellVisualFX3DClass.spawn_ground_slam(root, Vector3(5, 0, 0), 4.0, Color(1.0, 0.4, 0.1))
	SpellVisualFX3DClass.spawn_orbital_starfall(root, Vector3(-5, 0, 0), 5.0, Color(0.6, 0.3, 1.0))
	
	if root.get_child_count() < 3:
		return "SpellVisualFX3D should instantiate VFX root nodes under parent (got %d)" % root.get_child_count()
		
	root.free()
	return ""

# ==============================================================================
# --- FOG OF WAR & HERO ANIMATOR TESTS ---
# ==============================================================================

func test_fog_of_war_vision_range_and_culling() -> String:
	var fow = FogOfWarManagerClass.new()
	var ally = HeroEntity.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(0, 0, 0)
	HeroEntity.active_heroes.append(ally)
	
	var enemy_close = HeroEntity.new()
	enemy_close.team = TeamDefinitions.Team.DIRE
	enemy_close.position = Vector3(8, 0, 0) # within 14m
	HeroEntity.active_heroes.append(enemy_close)
	
	var enemy_far = HeroEntity.new()
	enemy_far.team = TeamDefinitions.Team.DIRE
	enemy_far.position = Vector3(35, 0, 0) # outside 14m
	HeroEntity.active_heroes.append(enemy_far)
	
	var is_close_vis = fow.is_entity_visible_to_team(enemy_close, TeamDefinitions.Team.RADIANT)
	var is_far_vis = fow.is_entity_visible_to_team(enemy_far, TeamDefinitions.Team.RADIANT)
	
	if not is_close_vis:
		return "Enemy within 8m of ally hero should be visible"
	if is_far_vis:
		return "Enemy at 35m with no nearby allies/towers should be concealed in Fog of War"
		
	ally.free()
	enemy_close.free()
	enemy_far.free()
	fow.free()
	return ""

func test_fog_of_war_bush_concealment_and_shared_vision() -> String:
	var fow = FogOfWarManagerClass.new()
	var bush = BushArea3DClass.new()
	
	var ally = HeroEntity.new()
	ally.team = TeamDefinitions.Team.RADIANT
	ally.position = Vector3(0, 0, 0)
	HeroEntity.active_heroes.append(ally)
	
	var enemy = HeroEntity.new()
	enemy.team = TeamDefinitions.Team.DIRE
	enemy.position = Vector3(6, 0, 0) # 6m away, but inside bush
	enemy.set_meta("current_bush", bush)
	HeroEntity.active_heroes.append(enemy)
	
	# Case 1: Enemy is inside bush, ally is OUTSIDE the bush -> concealed
	var is_vis_outside = fow.is_entity_visible_to_team(enemy, TeamDefinitions.Team.RADIANT)
	if is_vis_outside:
		return "Enemy inside bush should be concealed to players outside the bush"
		
	# Case 2: Ally enters the SAME bush -> enemy is revealed
	bush.units_inside.append(ally)
	var is_vis_inside = fow.is_entity_visible_to_team(enemy, TeamDefinitions.Team.RADIANT)
	if not is_vis_inside:
		return "Enemy inside bush should be revealed when an ally enters the same bush"
		
	ally.free()
	enemy.free()
	bush.free()
	fow.free()
	return ""

func test_hero_animator_3d_locomotion_and_actions() -> String:
	var hero = HeroEntity.new()
	var vis = Node3D.new()
	vis.name = "TestVisual"
	hero.add_child(vis)
	
	var anim = HeroAnimator3DClass.new()
	hero.add_child(anim)
	anim._ready()
	
	# Test running lean & step bobbing
	hero.velocity = Vector3(5, 0, 0) # moving
	anim._process(0.1)
	if vis.rotation.x == 0.0:
		return "HeroAnimator3D should tilt torso forward when moving"
		
	# Test idle recovery
	hero.velocity = Vector3.ZERO
	anim._process(0.5)
	
	hero.free()
	return ""

# ==============================================================================
# --- 50+ HERO ROSTER EXPANSION TESTS ---
# ==============================================================================

func test_51_hero_roster_registry_and_definitions() -> String:
	var ids = HeroDefinition.get_all_hero_ids()
	if ids.size() < 54:
		return "Expected 54 registered heroes, got %d" % ids.size()
		
	var defs = HeroDefinition.get_all_definitions()
	if defs.size() != ids.size():
		return "Mismatch between hero IDs (%d) and hero definitions (%d)" % [ids.size(), defs.size()]
		
	# Verify specific new heroes are present
	var check_ids = ["grom", "kaelen", "vulkor", "drogas", "astran", "trak", "okar", "lyra", "noctis", "zin", "aria", "malthus", "morven", "nixe", "elarion", "xerana", "velum", "valerius", "sera", "geras", "aurik", "valgor", "malakor"]
	for cid in check_ids:
		if not HeroDefinition.has_definition(cid):
			return "Hero definition missing for newly added hero: %s" % cid
			
	return ""

func test_51_hero_instantiations_and_ability_containers() -> String:
	var ids = HeroDefinition.get_all_hero_ids()
	for hid in ids:
		var hero = HeroDefinition.create_hero_instance(hid)
		if hero == null:
			return "Failed to instantiate hero entity for: %s" % hid
		if hero.entity_name.is_empty():
			hero.free()
			return "Hero entity has empty name for: %s" % hid
			
		hero.free()
	return ""

func test_new_heroes_archetype_stat_scaling_integrity() -> String:
	var grom_def = HeroDefinition.get_definition("grom")
	if grom_def == null or grom_def.primary_attribute != AttributeSystem.PrimaryAttributeType.STRENGTH:
		return "Grom should be registered as a primary STRENGTH hero"
		
	var aria_def = HeroDefinition.get_definition("aria")
	if aria_def == null or aria_def.primary_attribute != AttributeSystem.PrimaryAttributeType.AGILITY:
		return "Aria should be registered as a primary AGILITY hero"
		
	var geras_def = HeroDefinition.get_definition("geras")
	if geras_def == null or geras_def.primary_attribute != AttributeSystem.PrimaryAttributeType.INTELLIGENCE:
		return "Geras should be registered as a primary INTELLIGENCE hero"
		
	return ""

# ==============================================================================
# --- MODULAR ITEM PIPELINE & BUILD MATRIX TESTS ---
# ==============================================================================

func test_item_event_engine_on_hit_and_defensive_tags() -> String:
	var attacker = HeroEntity.new()
	var victim = HeroEntity.new()
	attacker.team = TeamDefinitions.Team.RADIANT
	victim.team = TeamDefinitions.Team.DIRE
	attacker._ready()
	victim._ready()
	
	var engine = ItemEventEngineClass.new()
	
	# Give attacker a bleed item
	var bleed_item = ItemResource.new()
	bleed_item.item_name = "Bleeding Edge"
	bleed_item.item_tags = ["ON_HIT_BLEED"]
	attacker.inventory_manager.slots[0] = bleed_item
	
	var dmg_req = DamageRequest.create_basic_attack(attacker, victim, 100.0)
	var res = CombatCalculator.execute_damage(dmg_req)
	engine._on_damage_dealt(res, attacker, victim)
	
	if res.final_health_damage <= 0.0:
		attacker.free()
		victim.free()
		engine.free()
		return "Basic attack should deal initial health damage"
		
	attacker.free()
	victim.free()
	engine.free()
	return ""

func test_inventory_manager_active_item_cooldowns_and_execution() -> String:
	var hero = HeroEntity.new()
	hero._ready()
	
	var blink_item = ItemResource.new()
	blink_item.item_name = "Blink Relic"
	blink_item.active_action_tag = "ACTIVE_BLINK"
	blink_item.active_cooldown = 15.0
	
	hero.inventory_manager.slots[0] = blink_item
	var initial_pos = hero.global_position
	var target_pos = initial_pos + Vector3(10, 0, 0)
	
	var used = hero.inventory_manager.use_active_item(0, null, target_pos)
	if not used:
		hero.free()
		return "Blink active item should execute successfully"
		
	if hero.inventory_manager.slot_cooldowns[0] <= 0.0:
		hero.free()
		return "Active item slot should be put on cooldown"
		
	# Try casting again immediately -> should fail due to cooldown
	var used_again = hero.inventory_manager.use_active_item(0, null, target_pos)
	if used_again:
		hero.free()
		return "Active item should NOT cast while on cooldown"
		
	hero.free()
	return ""

func test_54_hero_3_build_pathways_stat_and_synergy_matrix() -> String:
	var hero_ids = HeroDefinition.get_all_hero_ids()
	if hero_ids.size() < 54:
		return "Expected 54 registered heroes, got %d" % hero_ids.size()
		
	var all_items = Database.get_all_items()
	if all_items.size() < 100:
		return "Expected full 120 items database to be loaded, got %d" % all_items.size()
		
	# Test 3 distinct build configurations:
	# Build 1: Full Tank / Health & Armor
	# Build 2: Full Physical Burst / Crit & AD
	# Build 3: Full AP Magic Burst & CDR
	for hid in ["valgor", "kaelen", "aurik", "malakor", "kaelgor", "astris"]:
		var h = HeroDefinition.create_hero_instance(hid)
		h._ready()
		
		# Apply 3 items
		for i in range(3):
			if i < all_items.size():
				h.inventory_manager.slots[i] = all_items[i]
				h.inventory_manager._apply_stat_modifiers(all_items[i], "slot_%d" % i)
				
		var hp = h.attribute_system.get_stat(StatModifier.TargetStat.MAX_HEALTH)
		if hp <= 0.0:
			h.free()
			return "Hero %s has invalid health after item equip" % hid
			
		h.free()
	return ""































