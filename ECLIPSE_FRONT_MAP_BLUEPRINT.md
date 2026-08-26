# ECLIPSE FRONT — 3D MOBA MAP GAMEPLAY BLUEPRINT SPECIFICATION

**Version:** 1.0.0
**Map Dimension:** 160m x 160m (Square Arena)
**Elevation Levels:** 
- **High-Ground (Base Platforms):** +1.5m
- **Mid-Ground (Lanes & Jungle Paths):** 0.0m
- **Low-Ground (River Valley & Roshan Pit):** -1.0m
- **Obstacle Cliffs (Jungle Plateaus):** +2.5m

---

## 1. Map Layout & Strategic Zones

```
[ DIRE BASE (+1.5m) ] ────────── TOP LANE ────────── [ RADIANT SECRET SHOP ]
       │                                                      │
       │                 [ TOP POWER RUNE (-1.0m) ]           │
       │                                                      │
   TOP LANE             [ ROSHAN / BOSS PIT (-1.0m) ]     MID LANE
       │                                                      │
       │                 [ BOT POWER RUNE (-1.0m) ]           │
       │                                                      │
[ DIRE SECRET SHOP ] ────────── BOT LANE ────────── [ RADIANT BASE (+1.5m) ]
```

---

## 2. Structural & Combat Geometry

### Bases & Fountains
- **Radiant Base:** Centered at `(-50, 1.5, 50)` with High-Ground +1.5m elevation.
  - **Radiant Fountain:** `(-58, 1.5, 58)` with `FountainHealingArea` (+12% HP/MP per second, 350 True Damage/s to enemies).
  - **Radiant Ancient Core:** `(-52, 1.5, 52)`.
  - **Base Ramps:** 3 ramps (Top, Mid, Bot) transitioning smoothly from +1.5m to 0.0m.
- **Dire Base:** Centered at `(50, 1.5, -50)` with High-Ground +1.5m elevation.
  - **Dire Fountain:** `(58, 1.5, -58)` with `FountainHealingArea` (+12% HP/MP per second, 350 True Damage/s to enemies).
  - **Dire Ancient Core:** `(52, 1.5, -52)`.
  - **Base Ramps:** 3 ramps (Top, Mid, Bot) transitioning smoothly from +1.5m to 0.0m.

### Towers (Tier 1, Tier 2, Tier 3, Tier 4)
- **Radiant Towers:**
  - **Top Lane:** T1 `(-55, 0, 15)`, T2 `(-55, 0, 35)`, T3 `(-48, 1.5, 40)`.
  - **Mid Lane:** T1 `(-15, 0, 15)`, T2 `(-28, 0, 28)`, T3 `(-40, 1.5, 40)`.
  - **Bot Lane:** T1 `(-15, 0, 55)`, T2 `(-35, 0, 55)`, T3 `(-40, 1.5, 48)`.
  - **Base Twin Towers (T4):** Left `(-48, 1.5, 52)`, Right `(-52, 1.5, 48)`.
- **Dire Towers:**
  - **Top Lane:** T1 `(15, 0, -55)`, T2 `(35, 0, -55)`, T3 `(40, 1.5, -48)`.
  - **Mid Lane:** T1 `(15, 0, -15)`, T2 `(28, 0, -28)`, T3 `(40, 1.5, -40)`.
  - **Bot Lane:** T1 `(55, 0, -15)`, T2 `(55, 0, -35)`, T3 `(48, 1.5, -40)`.
  - **Base Twin Towers (T4):** Left `(48, 1.5, -52)`, Right `(52, 1.5, -48)`.

---

## 3. Jungle Camps & Neutral Spawners

- **Radiant Jungle:**
  - **Small Camp:** `(-25, 0, 35)` — 3 Neutrals (300 HP, 35 Gold, 45 XP)
  - **Medium Camp:** `(-35, 0, 20)` — 3 Neutrals (500 HP, 55 Gold, 75 XP)
  - **Large Camp:** `(-20, 0, 42)` — 4 Neutrals (850 HP, 85 Gold, 110 XP)
  - **Ancient Camp:** `(-10, 0, 30)` — 3 Neutrals (1400 HP, 140 Gold, 190 XP)
- **Dire Jungle:**
  - **Small Camp:** `(25, 0, -35)` — 3 Neutrals (300 HP, 35 Gold, 45 XP)
  - **Medium Camp:** `(35, 0, -20)` — 3 Neutrals (500 HP, 55 Gold, 75 XP)
  - **Large Camp:** `(20, 0, -42)` — 4 Neutrals (850 HP, 85 Gold, 110 XP)
  - **Ancient Camp:** `(10, 0, -30)` — 3 Neutrals (1400 HP, 140 Gold, 190 XP)

---

## 4. Runes, Secret Shops & Objectives

- **Power Runes (River):**
  - **Top River Power Rune:** `(-25, -1.0, -25)`
  - **Bot River Power Rune:** `(25, -1.0, 25)`
  - *Effect:* Grants +30% Movement Speed and +25 Attack Damage for 20 seconds.
- **Bounty Runes (Jungle):**
  - **Radiant Bounty Rune:** `(-28, 0, 45)`
  - **Dire Bounty Rune:** `(28, 0, -45)`
  - *Effect:* Grants +100 Gold to hero.
- **Secret Shops:**
  - **Radiant Secret Shop:** `(-50, 0, -10)`
  - **Dire Secret Shop:** `(50, 0, 10)`
- **Teleport Outposts:**
  - **Radiant Outpost:** `(-42, 0, -15)` (Channel time: 6.0s)
  - **Dire Outpost:** `(42, 0, 15)` (Channel time: 6.0s)
- **Boss Objective (Aegis Guardian):**
  - **Location:** `(-6, -1.0, 6)` inside enclosed rocky pit with a single entrance facing North-West.

---

## 5. Navigation & Waypoints

- `NavigationRegion3D` covers all terrain, ramps (45 degree slope max climb), and choke points.
- Minion spawners for Top, Mid, and Bot dispatch periodic waves traversing through all lane waypoints toward enemy base towers and Ancient Core.
