# ECLIPSE FRONT — LANE COMBAT & TOWER SYSTEM SPECIFICATION

**Version:** 1.0.0
**Target Framework:** Godot 4.x (GDScript)
**Map:** 160m x 160m 3-Lane MOBA Gameplay Blueprint

---

## 1. Minyon Dalga Mekaniği (Creep Waves)

- **Spawn Periyodu:** Her 30 saniyede bir Radiant ve Dire üslerindeki 6 koridor spawner'ından (`Radiant/Dire Top, Mid, Bot`) eş zamanlı dalga çıkar.
- **Standart Dalga Bileşimi:** 3 Yakın Dövüşçü (Melee) + 1 Menzilli (Ranged).
- **Kuşatma Dalgası (Siege Wave):** Her 3 dalgada bir ilave 1 Kuşatma Topu (Siege Creep).

### Minyon Arketip Tablosu
| Tip | Can (HP) | Saldırı Gücü (AD) | Zırh | Menzil | Hız | Altın Ödülü | XP Ödülü |
|---|---|---|---|---|---|---|---|
| **Melee (Yakın Dövüşçü)** | 550 HP | 22 AD | 2 AR | 120 (1.2m) | 325 | 38g | 60 XP |
| **Ranged (Menzilli)** | 300 HP | 32 AD | 0 AR | 450 (4.5m) | 325 | 45g | 75 XP |
| **Siege (Kuşatma Topu)** | 800 HP | 45 AD | 5 AR | 600 (6.0m) | 325 | 70g | 110 XP |

---

## 2. Minyon Yapay Zekası ve Yol Bulma (Lane Follow & Combat AI)

1. **Yol Bulma (Waypoint Following):**
   - Spawner'dan çıkan minyonlar, kendilerine atanan koridor kontrol noktalarını (`lane_waypoints`) sırayla takip eder. Navigasyon `NavigationAgent3D` ve doğrusal vektör yönlendirmesiyle yönetilir.
2. **Hedef Algılama ve Tehdit Önceliği (Aggro Radius: 350 birim):**
   - Minyon, yarıçapındaki en yakın düşman birimini tespit ettiğinde yürüyüşü durdurur ve saldırı menziline girer.
   - Öncelik Sıralaması:
     1. Kendisine veya takım arkadaşına saldıran düşman minyon/kahraman.
     2. En yakın düşman minyonu.
     3. Düşman kule veya kahramanı.
3. **Ödül Dağıtımı:**
   - Son vuruşu yapan (killer) kahramana tam altın ödülü (`gold_bounty`) aktarılır.
   - Killer kahramana tam XP, 15m yakındaki dost kahramanlara %50 asist XP verilir.

---

## 3. Kule Mekaniği ve Yıkım (Tower Defense & Destruction)

1. **Kule Statları:**
   - **T1:** 2500 HP, 120 AD, 18 Zırh, 25 Büyü Direnci, 750 Saldırı Menzili, 0.85 Saldırı Hızı.
   - **T2:** 3500 HP, 160 AD, 24 Zırh.
   - **T3 / T4:** 4500 – 5500 HP, 200 – 240 AD, 30 Zırh.
2. **Kule Hedefleme Önceliği (Target Priority):**
   - **1. Öncelik:** Kule menzili altında dost bir kahramana hasar veren düşman kahraman (*Tower Aggro / Dive Protection*).
   - **2. Öncelik:** Kuleye en yakın düşman minyonu (kahramanları tanklamaktan korur).
   - **3. Öncelik:** Menzildeki en yakın düşman kahramanı.
3. **Kule Yıkımı:**
   - Canı 0'a inen kule çarpışmasını (`CollisionShape3D`) devre dışı bırakır, görünmez olur ve rakip takımın tüm kahramanlarına kule kademesine göre takım altını (**150g * Tier**) ödülü dağıtır.

---

## 4. Kaelgor ile Etkileşim ve Savaş

- Kaelgor temel saldırı ve yetenekleri (Q Molten Fist, W Vent, E Iron Hide, R Overheat) ile minyonları biçebilir ve kulelere hasar verebilir.
- Kule ve minyonlardan alınan her hasar, Kaelgor'un **Furnace Heart** pasifi ile Isı enerjisine dönüştürülür.
