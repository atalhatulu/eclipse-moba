# ECLIPSE FRONT — SECOND PLAYABLE HERO: ASTRIS (RANGED INT MAGE)

**Hero Name:** Astris  
**Attribute:** Intelligence (INT)  
**Role:** Ranged Artillery / Temporal Control Mage  
**Attack Type:** Ranged (575.0 Range, Magic-Infused Projectiles)  

---

## 1. Oynanış Kimliği & Mekanik Felsefesi

Astris, Kaelgor'un yakın dövüş (150 menzil) ve can/hasar alma odaklı Isı mekaniğine tam zıt olarak tasarlanmış **uzun menzilli, mana yönetimi ve kitle kontrolü (kiting)** odaklı bir Zeka büyücüsüdür.

```
[ KAELGOR (Yakın Dövüşçü - Güç) ]                     [ ASTRIS (Menzilli - Zeka) ]
• 150 Saldırı Menzili                                 • 575 Saldırı Menzili
• Hasar Alarak Isı Üretir (Furnace Heart)             • Mana Akışı & Büyü Güçlendirme (Overcharge)
• Yüksek Zırh & Can                                   • Düşük Taban Can, Mana Kalkanı (Mana Barrier)
• Yakın Temas & Isı Boşaltımı                         • Uzak Mesafe Büyü Atışı & Sabitleme (Root CC)
```

---

## 2. Astris Taban Nitelikleri (Level 1)

| Nitelik | Değer | Büyüme (Seviye Başına) |
|---|---|---|
| **Can (HP)** | 500.0 | +65.0 |
| **Mana (MP)** | 450.0 | +80.0 |
| **Can Yenilenmesi** | 2.0 / sn | +0.2 |
| **Mana Yenilenmesi** | 3.5 / sn | +0.5 |
| **Güç (STR)** | 17.0 | +1.6 |
| **Çeviklik (AGI)** | 15.0 | +1.4 |
| **Zeka (INT - Birincil)** | 27.0 | +3.2 |
| **Saldırı Gücü (AD)** | 44.0 | +2.8 |
| **Zırh (Armor)** | 14.0 | +1.8 |
| **Büyü Direnci (MR)** | 25.0 | +0.8 |
| **Saldırı Hızı (AS)** | 0.68 | +%1.2 |
| **Hareket Hızı (MS)** | 315.0 | - |
| **Saldırı Menzili** | **575.0** (Kaelgor: 150) | - |

---

## 3. Yetenek Seti ve Formüller

### Pasif: Arcane Overcharge (Mana Akışı & Nüfuz)
- **Yüksek Mana Uyumu:** Astris'in mevcut manası %50'nin üzerindeyken kalıcı **+%15 Büyü Delme** (`MAGIC_PEN_PERCENT`) kazanır.
- **Aşırı Yükleme:** Her büyü kullanımında bir sonraki büyü veya temel saldırı güçlenir (+%25 AP bonus hasar) ve 20 mana yeniler.

### Q — Arcane Bolt (Ark Teğeti)
- **Bekleme Süresi:** [5.0, 4.5, 4.0, 3.5] saniye | **Mana:** [50.0, 60.0, 70.0, 80.0]
- **Hasar:** `[80.0, 140.0, 200.0, 260.0] + %80 AP` Büyü Hasarı. Overcharge aktifken ek `+%25 AP` hasar eklenir.

### W — Temporal Stasis (Zaman Tuzağı)
- **Bekleme Süresi:** [12.0, 11.0, 10.0, 9.0] saniye | **Mana:** [70.0, 80.0, 90.0, 100.0]
- **Etki:** Hedef alandaki düşmanları **1.5 saniye boyunca SABİTLER (ROOT)** ve `[70.0, 110.0, 150.0, 190.0] + %55 AP` Büyü Hasarı verir. Kaelgor gibi yakın dövüşçüleri mesafede tutmak için birincil kontrol aracıdır.

### E — Mana Barrier (Mana Kalkanı)
- **Bekleme Süresi:** [14.0, 13.0, 12.0, 11.0] saniye | **Mana:** [60.0, 70.0, 80.0, 90.0]
- **Etki:** 4 saniyeliğine `[100.0, 175.0, 250.0, 325.0] + %15 Maksimum Mana` değerinde kalkan açar ve kalkan süresince **+%20 Hareket Hızı** sağlar.

### R — Astral Rupture (Yıldız Çöküşü)
- **Bekleme Süresi:** [90.0, 75.0, 60.0] saniye | **Mana:** [150.0, 200.0, 250.0]
- **Etki:** Geniş alana astral enerji patlaması indirir: `[250.0, 400.0, 550.0] + %100 AP + %10 Hedefin Eksik Canı` kadar infaz büyü hasarı verir ve düşmanları 2 saniyeliğine **%50 yavaşlatır (SLOW)**.

---

## 4. Kaelgor vs Astris Karşı Oyun (Counterplay)

1. **Astris Avantajı (Kiting & Burst):** 575 menzili ve W (Root) yeteneğiyle Kaelgor'u yaklaştırmadan uzaktan eritir.
2. **Kaelgor Avantajı (Gap-Close & Overheat):** Kaelgor mesafeyi kapatabilirse, Iron Hide (E) ile Astris'in anlık büyü hasarını %30 kırıp yüksek Isı üretir ve Overheat (R) ile düşük canlı Astris'i yere serer.
3. **Kalkan & Azaltma Düellosu:** Astris'in Mana Barrier (E) kalkanı Kaelgor'un Molten Fist (Q) vuruşunu emebilirken, Kaelgor'un Iron Hide'ı Astris'in Arcane Bolt patlamasını karşılar.
