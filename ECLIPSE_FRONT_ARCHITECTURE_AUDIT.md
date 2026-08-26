# Eclipse Front - Architecture Audit & Migration Plan

**Date:** 2026-08-23
**Project:** Eclipse Front (Data-driven 5v5 MOBA)
**Engine Target:** Godot 4.x (GDScript)

---

## 1. Executive Summary & Existing Project State

An exhaustive audit of the `/home/teha/Documents/Godot Projects/eclipse` repository was conducted.

### 1.1. Project Configuration (`project.godot`)
- **Engine Version:** Godot 4.x (Config version 5)
- **Features:** `PackedStringArray("4.7", "Forward Plus")`
- **Physics Engine:** `3d/physics_engine = "Jolt Physics"`
- **Rendering Driver:** Windows Direct3D 12 configured; Linux/Vulkan default.
- **Autoloads:** None currently defined.
- **Display Settings:** `stretch/mode = "canvas_items"`, `stretch/aspect = "expand"`.

### 1.2. Existing Scenes & Assets
- **Scenes:** No `.tscn` scene files exist in the project yet.
- **Assets:** Default Godot `icon.svg` and its import metadata.
- **UI:** No UI scenes or themes exist.

### 1.3. Existing Scripts & Data
- **Data:**
  - `data/items.json`: Raw dataset of 120 items from GDD.
  - `data/heroes.json`: Raw dataset of 30 heroes from GDD.
- **Scripts:**
  - `scripts/core/`: Initial drafts of `enums.gd`, `stat_modifier.gd`, `stat_system.gd`, `combat_system.gd`, `inventory_system.gd`, `ability_system.gd`.
  - `scripts/data/`: `ability_data.gd`, `hero_data.gd`, `item_data.gd`, `game_database.gd`.
  - `scripts/entities/`: `base_entity.gd`, `hero_entity.gd`.
  - `scripts/systems/`: `game_manager.gd`, `item_recommender.gd`.
  - `scripts/tests/`: `core_test_runner.gd`.

---

## 2. Gap Analysis & Architecture Critique

1. **Flat / Incomplete Directory Organization:**
   - Previous structure placed everything under a generic `scripts/` folder without separation between core domains, data models, balance configs, systems, UI, and test suites.
2. **Missing STR / AGI / INT Central Derivation Layer:**
   - The previous `stat_system.gd` had basic flat stats but lacked the primary attribute layer (STR, AGI, INT) and centralized mathematical conversion formulas defined via configurable balance resources.
3. **Missing Extensible Status Effect Framework:**
   - No dedicated status effect system existed to handle Stun, Slow, Silence, Root, Knockback, Shields, DoT (Damage over Time), HoT (Heal over Time), Stat Modifiers, and Invulnerability with stacking and duration lifecycle.
4. **Item Tree & Recipe Resolution:**
   - The inventory had simple addition/removal but lacked deterministic recursive item recipe resolution (Base A + Base B -> Intermediate -> Legendary) with partial component recognition and gold cost deduction.
5. **Entity Hierarchy:**
   - Creeps, Towers, Objectives (e.g. Roshan/Aegis), and Combat Dummies were not yet separated into specialized, decoupled entity classes.
6. **Game State Management:**
   - Game state machine lacked discrete MOBA states: `PRE_GAME`, `HERO_SELECTION`, `LOADING`, `PLAYING`, `PAUSED`, `VICTORY`, `DEFEAT`.

---

## 3. Target Architecture & Restructuring Plan

We will establish the official, clean, data-driven MOBA architecture matching industry standards:

```
res://
├── core/
│   ├── game/               # Game state machine, match clock, day/night cycle
│   ├── combat/             # Centralized damage calculator, damage requests/results
│   ├── entities/           # BaseCombatEntity, HeroEntity, CreepEntity, TowerEntity, ObjectiveEntity, DummyEntity
│   ├── abilities/          # AbilityResource, AbilityContainer, targeting, execution
│   ├── items/              # ItemResource, ItemTreeResolver, RecipeGraph
│   ├── stats/              # Primary & Derived AttributeSystem, StatModifier, BalanceConfig
│   ├── effects/            # StatusEffect, EffectContainer, Stun/Slow/Silence/Shield/DoT/HoT/Invulnerability
│   ├── teams/              # Team affiliation, target filtering (Ally, Enemy, Neutral)
│   └── objectives/         # Capture points, neutral camps, boss objectives
├── data/
│   ├── balance/            # BalanceConfig.gd & default balance parameters (Attribute conversion rates)
│   ├── heroes/             # Sample Hero custom resources and definitions
│   ├── items/              # Sample Item custom resources and item tree definitions
│   └── abilities/          # Sample Ability custom resources
├── scenes/
│   ├── test/               # Developer test sandbox scene and controller
│   ├── entities/           # Base entity node hierarchies
│   └── ui/                 # Developer HUD and debug overlays
├── systems/
│   ├── combat/             # Combat manager, combat logs, event routing
│   ├── economy/            # Gold distribution, bounties, shop validation
│   ├── inventory/          # 6 normal slots + 1 dedicated boots slot manager
│   └── progression/        # XP curves, level scaling, ability point allocation
├── autoload/
│   ├── game_events.gd      # Global signal bus for decoupled communications
│   └── database.gd         # Centralized resource registry and data provider
└── tests/
    └── test_suite.gd       # Deterministic automated test runner verifying all 13 core systems
```

---

## 4. Implementation Steps

1. **Balance & Attribute Foundation:** Create `BalanceConfig`, `AttributeSystem`, and derived stat calculators.
2. **Combat & Damage Pipeline:** Implement centralized `CombatCalculator` and `DamageRequest`/`DamageResult` contracts.
3. **Status Effect Engine:** Implement extensible `StatusEffect` base and all 15 effect archetypes (Stun, Slow, Silence, Root, Knockback, Shield, DoT, HoT, Stat Buffs, Damage Amp/Reduction, Invulnerability).
4. **Entity Foundation:** Implement `BaseCombatEntity`, `HeroEntity`, `CreepEntity`, `TowerEntity`, `ObjectiveEntity`, and `DummyEntity`.
5. **Ability Pipeline:** Create data-driven `AbilityResource` and `AbilityContainer` supporting Q/W/E/R/Passive.
6. **Item & Inventory Engine:** Implement `ItemResource`, `ItemTreeResolver`, and 6+1 slot `InventoryManager`.
7. **Game State Engine:** Implement `GameStateManager` with state machine and transition hooks.
8. **Developer Sandbox:** Create an interactive test scene (`developer_sandbox.tscn` / `.gd`).
9. **Automated Test Suite:** Comprehensive test suite validating every single mechanic deterministically.
10. **Architecture & Progress Documentation:** Output comprehensive architecture guide and progress report.
