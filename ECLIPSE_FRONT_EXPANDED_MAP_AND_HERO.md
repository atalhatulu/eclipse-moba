# ECLIPSE FRONT — GENİŞLETİLMİŞ HARİTA (240x240m) VE 3D KAHRAMAN GÖRÜNÜMÜ

**Sürüm:** 1.0.0  
**Harita Boyutu:** 240 metre x 240 metre (Standart Rekabetçi MOBA Ölçeği)  
**Doğum Noktası:** Radiant Çeşmesi `(-90, 1.5, 90)`  

---

## 1. Karakterimiz Haritada Nerede?

- **Doğum Noktası (Spawn Point):** Kahramanımız (Kaelgor), haritanın sol alt köşesindeki **Radiant Çeşmesi (Fountain)** içinde `Vector3(-90.0, 1.5, 90.0)` koordinatında doğar.
- **Kamera Başlangıç Konumu:** Oyun başladığında kamera doğrudan Kaelgor'un üzerine kilitlenir (`is_locked_to_hero = true`) ve onu ekranın tam merkezine alır.
- **3D Model & Görünürlük:**
  - **Gövde:** Obsidyen zırhlı ve parlayan lav çatlaklı 3D model (`KaelgorVisual`), parlayan omuzluklar.
  - **Seçim Halkası:** Ayaklarının altında zemine yansıtılan parlak yeşil seçim aurası.
  - **Baş Üstü Paneli:** Başının üzerinde her açıdan okunan 3D `KAELGOR` isimliği.
  - **Minimap İmleci:** Sol alttaki 2D radarda Kaelgor'un canlı konumu parlak altın rengi bir nokta olarak görünür.

---

## 2. 240x240m Genişletilmiş Harita Mimarisi

Harita, orijinal 160m şablonundan rekabetçi MOBA standartlarına uygun **240m x 240m** boyutuna genişletilmiştir:

```
[ DIRE BASE: (85, 1.5, -85) ]
  |=== TOP LANE ===========================================+
  |                                                        |
  |   Dire Ormanı (5 Kamp)        [ROSHAN PIT]             |
  |                           (-12, -1.0, 12)              |
  |                     \                                  |
  |                      \  NEHİR / RIVER                  |
  |                       \ (-1.0m Düşük Zemin)            |
  |                        \                               |
  |                         \                              |
  |                          \     Radiant Ormanı (5 Kamp) |
  |                                                        |
  +=========================================== BOT LANE ===|
                               [ RADIANT BASE: (-85, 1.5, 85) ]
```

### Genişletilen Öğeler:
1. **Ana Zemin:** `240m x 240m` CSG zemin.
2. **Yüksek Zemin Üsleri (+1.5m):** 50m x 50m Radiant ve Dire üsleri, 12m genişliğinde koridor rampaları.
3. **Nehir Yatağı (-1.0m):** Haritayı çapraz kesen 24m genişliğinde ve 280m uzunluğunda derin su kanalı.
4. **22 Kule Yerleşimi:** Top, Mid, Bot koridorlarına ve üs girişlerine 240m mesafelerine göre orantılı olarak dağıtılmış T1, T2, T3 ve T4 kuleleri.
5. **10 Orman Kampı & 4 Rün:** Radiant ve Dire ormanlarında 2 Küçük, 4 Orta, 2 Büyük, 2 Kadim (Ancient) kamp ve nehir rünleri.
6. **Minyon Yolları:** 240m harita boyunca uzanan 10 duraklı NavMesh kontrol noktaları.
