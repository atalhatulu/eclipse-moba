# Eclipse Front - Gameplay Architecture & Technical Reference

**Engine:** Godot 4.x (GDScript)
**Genre:** Data-Driven 5v5 MOBA
**Author:** Lead Gameplay Engineering

---

## 1. Architecture Overview

Eclipse Front is built on a strictly decoupled, data-driven, component-oriented architecture. Core gameplay systems (Attributes, Combat Calculations, Status Effects, Abilities, Item Recipes, Inventory, Progression, and Game State) operate independently through central calculation layers and event buses.

### Key Architectural Pillars:
1. **Separation of Data and Behavior:** Heroes, Items, and Abilities are defined as pure `Resource` or JSON definitions. Adding new heroes, items, or spells requires zero modifications to core combat or inventory engines.
2. **Centralized Combat Resolution:** Damage calculations never occur in individual hero scripts. All combat passes through `CombatCalculator.execute_damage(DamageRequest) -> DamageResult`.
3. **Layered Attribute Derivation:** Primary Attributes (Strength, Agility, Intelligence) feed into derived stats and combat formulas via `BalanceConfig`, allowing global tuning without touching gameplay logic.
4. **Authoritative Network-Ready:** Core classes (`AttributeSystem`, `CombatCalculator`, `EffectContainer`, `AbilityContainer`, `InventoryManager`) are pure deterministic logic components ready to run on a dedicated headless server.

---

## 2. Directory Structure

```
res://
├── core/
│   ├── game/               # GameStateManager (match states, clock, day/night)
│   ├── combat/             # DamageRequest, DamageResult, CombatCalculator
│   ├── entities/           # BaseCombatEntity, HeroEntity, CreepEntity, TowerEntity, ObjectiveEntity, DummyEntity
│   ├── abilities/          # AbilityResource, AbilityContainer
│   ├── items/              # ItemResource, ItemTreeResolver
│   ├── stats/              # AttributeSystem, StatModifier, BalanceConfig
│   ├── effects/            # StatusEffect, EffectContainer
│   ├── teams/              # TeamDefinitions, Target Filtering
│   └── objectives/         # Map Objectives
├── data/
│   ├── heroes/             # Hero data & definitions (heroes.json, sample_heroes)
│   ├── items/              # Item data & definitions (items.json, sample_items)
│   ├── abilities/          # Ability definitions
│   └── balance/            # Balance configuration parameters
├── scenes/
│   └── test/               # Developer test sandbox scene (developer_sandbox.tscn / .gd)
├── systems/
│   └── inventory/          # InventoryManager (6 normal slots + 1 dedicated boots slot)
├── autoload/
│   ├── game_events.gd      # Decoupled global signal bus
│   └── database.gd         # Centralized resource registry and data provider
└── tests/
    └── test_suite.gd       # 19 automated deterministic unit tests
```

---

## 3. Core Classes & Responsibilities

| Class | Location | Responsibility |
|---|---|---|
| `AttributeSystem` | `core/stats/attribute_system.gd` | STR/AGI/INT tracking, derived stat calculations, HP/MP pools, regen, XP & level ups. |
| `BalanceConfig` | `core/stats/balance_config.gd` | Central mathematical constants (e.g. 1 STR = +20 HP, 1 AGI = +0.14 Armor, resistance formulas). |
| `StatModifier` | `core/stats/stat_modifier.gd` | Encapsulates Flat, Percent Add, and Percent Mult modifiers with duration and source tracking. |
| `StatusEffect` | `core/effects/status_effect.gd` | Base class for CC (Stun, Slow, Silence, Root), Shields, DoTs, HoTs, Buffs, and Invulnerability. |
| `EffectContainer` | `core/effects/effect_container.gd` | Entity component that ticks effects, manages stacking/refreshing, and absorbs damage with shields. |
| `CombatCalculator` | `core/combat/combat_calculator.gd` | Computes effective resistances, penetrations, crits, mitigations, shields, and lifesteal. |
| `DamageRequest` / `DamageResult` | `core/combat/` | Data contracts representing incoming attacks/spells and their resolved combat consequences. |
| `BaseCombatEntity` | `core/entities/base_combat_entity.gd` | Common combat-capable foundation for Heroes, Creeps, Towers, Objectives, and Dummies. |
| `HeroEntity` | `core/entities/hero_entity.gd` | Player unit with `AbilityContainer`, `InventoryManager`, leveling, and movement orders. |
| `AbilityResource` | `core/abilities/ability_resource.gd` | Data-driven definition for Q/W/E/R/Passive spells with cooldowns, mana costs, and scalings. |
| `AbilityContainer` | `core/abilities/ability_container.gd` | Handles cooldown timers, CDR calculations, mana checks, level-up points, and spellcasting. |
| `ItemResource` | `core/items/item_resource.gd` | Defines Base, Boots, Intermediate, Legendary, and Support items with stats and recipes. |
| `ItemTreeResolver` | `core/items/item_tree_resolver.gd` | Recursively resolves item recipe graphs, calculates partial inventory component discounts. |
| `InventoryManager` | `systems/inventory/inventory_manager.gd` | Manages 6 regular slots + 1 dedicated boots slot, auto-crafting, gold balance, and stat sync. |
| `GameStateManager` | `core/game/game_state_manager.gd` | State machine: `PRE_GAME`, `HERO_SELECTION`, `LOADING`, `PLAYING`, `PAUSED`, `VICTORY`, `DEFEAT`. |

---

## 4. Architectural Data & System Flows

### 4.1. Stat Derivation Flow
```
[Base Attributes + Growth * (Level - 1)] + Applied Attribute Modifiers
                               ↓
                   [Final STR / AGI / INT]
                               ↓
       [Derived Core Stats Calculated via BalanceConfig]
   (STR -> HP/Regen/AD, AGI -> Armor/AS/MS/AD, INT -> Mana/Regen/Amp/AD)
                               ↓
    [Applied Flat, Percent Add, and Percent Mult Modifiers]
                               ↓
                   [Final Combat Statistics]
```

### 4.2. Combat & Damage Flow
```
[Attacker Basic Attack / Spell]
              ↓
    [DamageRequest Created]
              ↓
  [Invulnerability Check] (Target EffectContainer)
              ↓
  [Critical Strike & Attacker Amp/Penetration Evaluated]
              ↓
  [Target Resistance & Damage Reduction Evaluated]
   (Formula: Raw * 100 / (100 + Effective Resistance))
              ↓
  [Shield Damage Absorption] (Absorbs before health)
              ↓
  [Health Pool Deduction] (Target AttributeSystem)
              ↓
  [Lifesteal / Spell Vamp Applied to Attacker]
              ↓
  [Global GameEvents Dispatched]
```

### 4.3. Item Crafting & Recipe Flow
```
Player Requests to Buy Target Item (e.g. Warblade / Ravager)
                             ↓
              [ItemTreeResolver.resolve_crafting]
                             ↓
Inspect Inventory & Boots Slot for Matching Component IDs
                             ↓
Compute Remaining Gold Cost = Total Cost - Sum(Owned Component Costs)
                             ↓
Check If Player Has Gold & Inventory Space
                             ↓
Deduct Gold -> Consume Component Slots -> Remove Old Stat Modifiers
                             ↓
Equip Final Item -> Apply New Stat Modifiers -> Emit Inventory Events
```

---

## 5. Future Multiplayer & Networking Considerations

The architecture has been designed with future client-server authoritative multiplayer in mind:

1. **State Determinism:** All state calculations (damage, cooldowns, stats, effects) are decoupled from rendering nodes and rely strictly on math/logic components.
2. **Server Authority Ready:** The `CombatCalculator`, `AttributeSystem`, and `AbilityContainer` can run headlessly on a Godot dedicated server instance to validate client inputs and broadcast state snapshots.
3. **Event-Driven Signal Bus:** `GameEvents` provides a clean boundary for network serialization without coupling gameplay objects.
