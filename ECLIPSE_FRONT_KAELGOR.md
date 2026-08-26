# ECLIPSE FRONT — KAELGOR (THE FURNACE HEART) SPECIFICATION & IMPLEMENTATION

**Version:** 1.0.0
**Role:** Bruiser / Melee Fighter
**Primary Attribute:** STRENGTH (STR)
**Resource Type:** Heat (0 - 100)

---

## 1. Hero Overview & Gameplay Identity

Kaelgor is a frontline Bruiser whose offensive potential increases dynamically as he engages in combat and takes damage.

```
[Take Damage / Activate E] ──> [Generate Heat] ──> [Attack Speed & Q Boost] ──> [Consume Heat with W (Vent)] ──> [Continue Fighting]
```

---

## 2. Base Attributes and Combat Stats

### Primary Attributes & Growths
- **Strength (STR):** 25.0 (+3.2 / level) [Primary]
- **Agility (AGI):** 18.0 (+1.8 / level)
- **Intelligence (INT):** 16.0 (+1.5 / level)

### Derived Level 1 Combat Stats (Calculated via AttributeSystem)
- **Max Health:** 740.0 HP (Base 240 + 25 STR * 20)
- **Health Regen:** 4.5 HP/s (Base 2.0 + 25 STR * 0.10)
- **Max Mana:** 312.0 MP (Base 120 + 16 INT * 12)
- **Mana Regen:** 2.0 MP/s (Base 1.2 + 16 INT * 0.05)
- **Attack Damage (AD):** 63.0 (Base 38 + 25 STR * 1.0 Primary Bonus)
- **Armor:** 5.07 (Base 2.5 + 18 AGI * 0.142857)
- **Magic Resist:** 28.0 MR
- **Attack Speed:** 0.68 attacks/sec
- **Movement Speed:** 315.0 units/sec
- **Attack Range:** 150.0 units (Melee)

---

## 3. Heat Resource System (`HeatSystem`)

- **Min Heat:** 0.0
- **Max Heat:** 100.0
- **Combat Timeout (Decay Delay):** 4.0 seconds after dealing or taking damage
- **Decay Rate:** 10.0 Heat / second outside of combat
- **Passive Offensive Scaling:**
  $$\text{Bonus Attack Speed (\%)} = \text{Current Heat} \times 0.30\%$$
  *(At 100 Heat: +30% Attack Speed applied dynamically via `StatModifier`)*
- **Decay Lock:** During Ultimate (*Overheat*), decay is completely locked.

---

## 4. Abilities & Formulas

### Passive: Furnace Heart
- When receiving valid combat damage:
  $$\text{Heat Gained} = (\text{Damage Dealt to Health} + \text{Damage Absorbed by Shield}) \times 0.06$$
- Refreshes the 4.0-second combat timeout.

### Q — Molten Fist (Single Target Melee Strike)
- **Target:** Enemy unit within melee range
- **Cooldown:** `[6.0, 5.5, 5.0, 4.5]` seconds
- **Mana Cost:** `[50.0, 60.0, 70.0, 80.0]` MP
- **Damage Type:** Physical
- **Damage Formula:**
  $$\text{Damage} = \text{Base Q Damage} + (0.70 \times \text{AD}) + (\text{Current Heat} \times 1.5)$$

### W — Vent (Heat Discharge AoE)
- **Target:** Ground AoE around Kaelgor (350 unit radius)
- **Cooldown:** `[10.0, 9.0, 8.0, 7.0]` seconds
- **Mana Cost:** `[60.0, 70.0, 80.0, 90.0]` MP
- **Damage Type:** Magical
- **Damage Formula:**
  $$\text{Damage} = \text{Base W Damage} + (0.50 \times \text{AP}) + (\text{Heat Consumed} \times 2.0)$$
- **Crowd Control:** Applies `StatusEffect.EffectType.SLOW` (30% slow for 2.5 seconds).
- **Execution Rule:** Heat is consumed only upon successful cast execution. Heat cannot become negative.

### E — Iron Hide (Defensive State)
- **Duration:** 4.0 seconds
- **Cooldown:** `[14.0, 13.0, 12.0, 11.0]` seconds
- **Mana Cost:** `[40.0, 45.0, 50.0, 55.0]` MP
- **Mechanics:**
  - Grants **30% Damage Reduction** against all incoming physical and magical damage.
  - **50% of Prevented Damage** is converted directly into Heat without creating recursive damage loops.

### R — Overheat (Ultimate)
- **Duration:** 8.0 seconds
- **Cooldown:** `[80.0, 70.0, 60.0]` seconds
- **Mana Cost:** `[100.0, 125.0, 150.0]` MP
- **Mechanics:**
  - Instantly sets Heat to 100.0.
  - Locks Heat decay for the duration.
  - Basic attacks deal **50% Splash Damage** to all secondary enemy units within 250 units of the primary target.
  - Returns to standard decay and normal attack behavior when duration expires.

---

## 5. Death & Respawn Lifecycle

1. **Death (0 HP):**
   - Entity marked `is_alive = false`.
   - `can_move()`, `can_attack()`, and `can_cast()` immediately return `false`.
   - All active temporary states (*Iron Hide*, *Overheat*) are cleared.
   - Heat is reset to 0.
   - Respawn timer begins: $5.0 + (\text{Level} \times 2.5)$ seconds.
2. **Respawn:**
   - Entity marked `is_alive = true`.
   - Health and Mana restored to 100%.
   - Entity returned to playable state at base fountain.

---

## 6. Automated Unit Tests (22 Kaelgor Tests)

| # | Test Name | Expected Outcome | Status |
|---|---|---|---|
| 20 | Kaelgor Initialization | Definition and components attached | PASS |
| 21 | Basic Attack Damage | Damages target through CombatCalculator | PASS |
| 22 | Friendly Fire Prevention | Friendly teammate attack returns null | PASS |
| 23 | Heat Initial Zero | Starts with 0 Heat | PASS |
| 24 | Damage Generates Heat | Furnace Heart passive generates Heat | PASS |
| 25 | Heat Maximum Clamp | Clamped strictly at 100 Heat | PASS |
| 26 | Heat Decay | Decays outside combat timer | PASS |
| 27 | Q Heat Scaling | +1.5 damage per Heat point verified | PASS |
| 28 | W Heat Consumption | Consumes Heat upon cast | PASS |
| 29 | W No Negative Heat | Cannot reduce Heat below 0 | PASS |
| 30 | W Applies Slow | Target receives 30% Slow effect | PASS |
| 31 | Iron Hide Damage Reduction | 30% damage reduction verified | PASS |
| 32 | Iron Hide Heat Conversion | Prevented damage generates Heat | PASS |
| 33 | Prevented Damage Non-Recursive | Resolves in 1 step without infinite recursion | PASS |
| 34 | Overheat Activation | Sets 100 Heat and enters Overheat | PASS |
| 35 | Overheat Splash Damage | Basic attacks apply 50% splash | PASS |
| 36 | Overheat Duration & Expiry | Ends cleanly and unlocks decay | PASS |
| 37 | Cooldown Validation | Prevents rapid casting | PASS |
| 38 | Mana Cost Deduction | Deducts exact mana amount | PASS |
| 39 | Death at Zero HP | Hero enters dead state at 0 HP | PASS |
| 40 | Dead Hero Restrictions | Dead hero cannot attack/move/cast | PASS |
| 41 | Respawn State Restoration | Restores full HP/Mana and playable state | PASS |
