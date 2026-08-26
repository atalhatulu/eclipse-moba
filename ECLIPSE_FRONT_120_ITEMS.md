# ECLIPSE FRONT — 120 ITEM DATABASE ARCHITECTURE & SPECIFICATION

**Version:** 1.0.0
**Total Items:** 120
**Categories:**
- **Base (Temel) Eşyalar:** 36 Adet (ID: 1 – 36)
- **Boots (Çizmeler):** 6 Adet (ID: 37 – 42)
- **Intermediate (Ara Seviye) Eşyalar:** 30 Adet (ID: 43 – 72)
- **Legendary (Efsanevi) Eşyalar:** 41 Adet (ID: 73 – 113)
- **Support / Special (Destek & Özel) Eşyalar:** 7 Adet (ID: 114 – 120)

---

## 1. Eşya Hiyerarşisi ve Sentez Mimarisi

Eclipse Front eşya motoru, 3 kademeli hiyerarşik tarif sentezi (`ItemTreeResolver`) ile çalışır:

```
[ BASE (Temel Eşyalar: 350g - 850g) ]
             │
             ▼
[ INTERMEDIATE (Ara Eşyalar: 1000g - 1500g) ] ── (Bileşen indirimi uygulanır)
             │
             ▼
[ LEGENDARY / SUPPORT (Efsanevi & Destek: 2200g - 3400g) ] ── (Sahip olunan ara eşyalar düşülür)
```

- **6+1 Envanter Kuralı:** 6 genel envanter yuvası + 1 bağımsız Çizme (Boots) yuvası. Çizmeler satın alındığında doğrudan özel çizme yuvasına yönlendirilir ve 6 eşya yuvasını işgal etmez.
- **%70 Altın İadesi:** Herhangi bir eşya satıldığında toplam maliyetinin %70'i kahramana iade edilir ve uygulanan `StatModifier` anında temizlenir.

---

## 2. 120 Eşya Kataloğu ve Detay Tablosu

### A. Base Items (36 Adet)
| ID | İsim | Kategori | Maliyet | Sağladığı Nitelikler |
|---|---|---|---|---|
| 1 | Iron Blade | BASE | 350g | +10 AD |
| 2 | Heavy Sword | BASE | 600g | +18 AD |
| 3 | Serrated Edge | BASE | 750g | +14 AD, +%8 Zırh Delme |
| 4 | Hunter's Bow | BASE | 400g | +0.10 Saldırı Hızı |
| 5 | Quickblade | BASE | 650g | +0.18 Saldırı Hızı |
| 6 | Keen Edge | BASE | 700g | +%10 Kritik Vuruş |
| 7 | Leather Guard | BASE | 300g | +4 Zırh |
| 8 | Chainmail | BASE | 550g | +8 Zırh |
| 9 | Reinforced Plate | BASE | 800g | +13 Zırh |
| 10 | Iron Helm | BASE | 450g | +100 Can |
| 11 | Vital Crystal | BASE | 500g | +180 Can |
| 12 | Giant's Belt | BASE | 800g | +300 Can |
| 13 | Regrowth Charm | BASE | 350g | +3 Can Yenilenmesi |
| 14 | Healing Core | BASE | 650g | +6 Can Yenilenmesi |
| 15 | Blood Shard | BASE | 700g | +%5 Can Çalma |
| 16 | Apprentice Tome | BASE | 350g | +15 AP |
| 17 | Arcane Crystal | BASE | 700g | +30 AP |
| 18 | Mystic Orb | BASE | 850g | +45 AP |
| 19 | Mana Shard | BASE | 350g | +100 Mana |
| 20 | Sapphire Core | BASE | 650g | +250 Mana |
| 21 | Flowing Rune | BASE | 750g | +5 Mana Yenilenmesi |
| 22 | Null Mantle | BASE | 450g | +10 Büyü Direnci |
| 23 | Spirit Cloak | BASE | 700g | +18 Büyü Direnci |
| 24 | Warding Stone | BASE | 900g | +25 Büyü Direnci |
| 25 | Traveler's Charm | BASE | 400g | +15 Hareket Hızı |
| 26 | Wind Feather | BASE | 650g | +12 Hareket Hızı |
| 27 | Focus Lens | BASE | 500g | +%5 CDR |
| 28 | Mana Ring | BASE | 500g | +3 Mana Yenilenmesi |
| 29 | Hunter's Mark | BASE | 600g | +8 AD |
| 30 | Vampiric Fang | BASE | 450g | +%3 Can Çalma |
| 31 | Execution Shard | BASE | 700g | +5 AD, +%5 Kritik |
| 32 | Mage's Pen | BASE | 650g | +8 Büyü Delme |
| 33 | Bastion Core | BASE | 700g | +5 Zırh, +5 Büyü Direnci |
| 34 | Titan Heart | BASE | 850g | +220 Can |
| 35 | Swift Gloves | BASE | 300g | +0.06 Saldırı Hızı |
| 36 | Lucky Coin | BASE | 500g | +50 Can |

---

### B. Boots (6 Adet — Bağımsız Çizme Yuvası)
| ID | İsim | Maliyet | Tarif Bileşenleri | Nitelikler |
|---|---|---|---|---|
| 37 | Wanderer's Boots | 500g | Taban | +35 Hareket Hızı |
| 38 | Swiftstep Boots | 950g | [37, 35] | +55 MS, +0.08 AS |
| 39 | Ironstride Boots | 1050g | [37, 8] | +50 MS, +7 Zırh |
| 40 | Arcane Boots | 1100g | [37, 20] | +50 MS, +200 Mana, +4 MP Regen |
| 41 | Shadowstep Boots | 1250g | [37, 27] | +55 MS, +%10 CDR |
| 42 | Guardian Boots | 1400g | [37, 33] | +50 MS, +10 Zırh, +10 MR, +100 HP |

---

### C. Intermediate Items (30 Adet — ID: 43 – 72)
- **Warblade (43 - 1100g):** [1, 2] -> +28 AD
- **Razor Edge (44 - 1300g):** [3, 1] -> +25 AD, +%10 Zırh Delme
- **Hunter's Recurve (45 - 1050g):** [4, 5] -> +0.25 AS
- **Duelist Blade (46 - 1250g):** [1, 5] -> +20 AD, +0.10 AS
- **Precision Bow (47 - 1200g):** [4, 6] -> +0.15 AS, +%15 Kritik
- **Steelguard (48 - 1100g):** [8, 7] -> +18 Zırh
- **Guardian Plate (49 - 1350g):** [9, 8] -> +24 Zırh
- **Braced Mail (50 - 1200g):** [8, 10] -> +200 HP, +10 Zırh
- **Vital Core (51 - 1200g):** [11, 10] -> +450 HP
- **Titan Belt (52 - 1450g):** [12, 11] -> +650 HP
- **Bloodstone (53 - 1200g):** [15, 30] -> +%10 Can Çalma
- **Regeneration Orb (54 - 1000g):** [13, 14] -> +10 Can Yenilenmesi
- **Sorcerer's Tome (55 - 1100g):** [16, 17] -> +50 AP
- **Arcane Staff (56 - 1450g):** [17, 18] -> +75 AP
- **Void Crystal (57 - 1350g):** [17, 32] -> +30 AP, +15 Büyü Delme
- **Enchanter's Orb (58 - 1250g):** [18, 20] -> +60 AP, +150 Mana
- **Mystic Core (59 - 1100g):** [20, 21] -> +400 Mana, +5 MP Regen
- **Spirit Core (60 - 1200g):** [22, 23] -> +25 Büyü Direnci
- **Runic Barrier (61 - 1400g):** [23, 11] -> +20 MR, +150 HP
- **Windrunner Cloak (62 - 1150g):** [25, 26] -> +25 MS
- **Force Crystal (63 - 1250g):** [25, 27] -> +15 MS, +%5 CDR
- **Chrono Lens (64 - 1200g):** [27, 28] -> +%10 CDR
- **Sage Pendant (65 - 1150g):** [20, 28] -> +300 Mana, +3 MP Regen
- **Hunter's Emblem (66 - 1250g):** [29, 4] -> +15 AD, +0.10 AS
- **Executioner's Mark (67 - 1400g):** [31, 2] -> +25 AD, +%8 Kritik
- **Armorbreaker (68 - 1450g):** [3, 2] -> +20 AD, +%18 Zırh Delme
- **Bloodguard (69 - 1350g):** [11, 15] -> +250 HP, +%6 Can Çalma
- **Spellguard (70 - 1350g):** [8, 23] -> +15 Zırh, +15 MR
- **Juggernaut Core (71 - 1500g):** [12, 7] -> +500 HP, +5 Zırh
- **Storm Gauntlet (72 - 1350g):** [5, 1] -> +0.20 AS, +5 AD

---

### D. Legendary Items (41 Adet — ID: 73 – 113)
- **Bloodfang (73 - 2600g):** [43, 53] -> +55 AD, +%15 Lifesteal
- **Executioner's Blade (74 - 2800g):** [43, 67] -> +65 AD, +%25 Kritik
- **Dread Reaver (75 - 2900g):** [44, 43] -> +55 AD, +25 Düz Delme
- **Titan Slayer (76 - 3000g):** [43, 68] -> +50 AD, +%20 Zırh Delme
- **Stormblade (77 - 2700g):** [43, 45] -> +35 AD, +0.35 AS
- **Ravager (78 - 2850g):** [43, 51] -> +50 AD, +250 HP
- **Phantom Edge (79 - 3000g):** [47, 62] -> +45 AD, +%25 Kritik, +25 MS
- **Duelist's Fury (80 - 2750g):** [46, 45] -> +30 AD, +0.50 AS
- **Deadeye (81 - 3100g):** [43, 47] -> +60 AD, +%20 Kritik
- **Void Reaper (82 - 2900g):** [44, 68] -> +50 AD, +35 Düz Delme
- **Colossus Armor (83 - 2800g):** [52, 48] -> +700 HP, +35 Zırh
- **Aegis Plate (84 - 3000g):** [51, 49] -> +550 HP, +45 Zırh
- **Spirit Fortress (85 - 2900g):** [51, 60] -> +500 HP, +40 MR
- **Titanwall (86 - 3100g):** [52, 51] -> +900 HP
- **Ironheart (87 - 2950g):** [52, 54] -> +700 HP, +12 HP Regen
- **Thornmail (88 - 2700g):** [51, 48] -> +500 HP, +35 Zırh
- **Frostguard (89 - 2850g):** [51, 48] -> +500 HP, +30 Zırh
- **Dreadnought (90 - 3000g):** [52, 70] -> +650 HP, +25 Zırh, +20 MR
- **Eternal Bastion (91 - 3400g):** [52, 70] -> +900 HP, +30 Zırh, +30 MR
- **Soul Fortress (92 - 3200g):** [52, 60] -> +700 HP, +35 MR
- **Arcane Dominion (93 - 2800g):** [55, 56] -> +100 AP
- **Void Scepter (94 - 2900g):** [56, 57] -> +85 AP, +30 Büyü Delme
- **Astral Tome (95 - 2700g):** [55, 58] -> +120 AP
- **Chronomancer's Eye (96 - 2800g):** [56, 64] -> +90 AP, +%25 CDR
- **Soulfire Orb (97 - 3000g):** [56, 51] -> +80 AP, +400 HP
- **Starfall Crown (98 - 3200g):** [56, 55] -> +130 AP
- **Eclipse Staff (99 - 3000g):** [56, 57] -> +100 AP, +35 Büyü Delme
- **Blood Mage's Core (100 - 2900g):** [56, 53] -> +90 AP, +%10 Spell Vamp
- **Infinite Codex (101 - 3400g):** [56, 64] -> +150 AP, +%20 CDR
- **Hexbinder (102 - 2850g):** [55, 64] -> +85 AP, +%20 CDR
- **Windcaller (103 - 2700g):** [55, 62] -> +85 AP, +30 MS
- **Vampiric Crown (104 - 2500g):** [51, 53] -> +350 HP, +%15 Lifesteal
- **Blood Engine (105 - 2900g):** [43, 69] -> +40 AD, +500 HP, +%8 Lifesteal
- **Soul Reaver (106 - 3000g):** [43, 55] -> +55 AD, +70 AP
- **Warbringer (107 - 3000g):** [43, 51] -> +60 AD, +450 HP
- **Frostbite Hammer (108 - 2700g):** [43, 51] -> +40 AD, +400 HP
- **Tempest Claw (109 - 2850g):** [46, 45] -> +30 AD, +0.45 AS
- **Horizon Pike (110 - 2800g):** [46, 62] -> +35 AD, +0.20 AS, +30 MS
- **Phantom Cloak (111 - 2750g):** [44, 62] -> +40 AD, +%20 Kritik, +30 MS
- **Night Reaper (112 - 3100g):** [44, 43] -> +70 AD, +30 Düz Delme
- **Celestial Guard (113 - 3100g):** [51, 70] -> +400 HP, +25 Zırh, +25 MR

---

### E. Support / Special Items (7 Adet — ID: 114 – 120)
- **Lifebloom (114 - 2400g):** [51, 55] -> +350 HP, +15 AP | Aktif: Dost birimi iyileştirme (12s CD)
- **Radiant Aegis (115 - 2600g):** [51, 48] -> +300 HP, +20 Zırh | Aktif: 250 HP Kalkan
- **War Banner (116 - 2500g):** [51, 64] -> +250 HP, +%10 CDR | Pasif: Yakındaki dostlara +%10 AS
- **Spirit Lantern (117 - 2200g):** [60, 59] -> +20 MR, +250 Mana | Pasif: Görünmez birimleri açığa çıkarma
- **Force Relic (118 - 2450g):** [62, 64] -> +30 MS, +%15 CDR | Aktif: Hedefi 450 birim itme
- **Timekeeper (119 - 2700g):** [64, 59] -> +%25 CDR, +300 Mana | Aktif: Bekleme süresinin %40'ını sıfırlama
- **Oracle Lens (120 - 2300g):** [51, 64] -> +300 HP, +%10 CDR | Aktif: Alandaki gizli totem/tuzakları tarama
