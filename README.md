# Eclipse Front — 3D MOBA Game Engine

**Eclipse Front**, Godot 4.x motoru üzerinde GDScript ile geliştirilmiş, Dota 2 standartlarında derin mekaniklere ve veri odaklı (data-driven) mimariye sahip rekabetçi bir 3D MOBA oyunudur.

---

## 🌟 Öne Çıkan Özellikler

### 1. Kahramanlar & Arketip Sistemi
- **Solen (The Solar Archer) [Yeni / Varsayılan]:** Menzilli Çeviklik (AGI) Taşıyıcısı. 6.25m temel menzil, yüksek saldırı hızı, 5. vuruşta patlayan zırh delen *Güneş Yükü* pasifi, hat delen delici ok (*Q*), geriye savurma & kör etme (*W*), kaçış & saldırı hızı güçlendirmesi (*E*) ve alan bombardımanı (*R*).
- **Astris (The Arcane Weaver):** Menzilli Zeka (INT) Büyücüsü. Güdümlemeli büyü füzeleri, aşırı yük pasifi, alan sabitleme ve süpernova patlaması.
- **Kaelgor (The Dread Juggernaut):** Yakın dövüş Güç (STR) Tank/Savaşçısı. Geniş zırh kıran vuruşlar, kükreme savunması, can çalma ve alan sersemletme ultisi.
- **30 Kahramanlık Genişletilebilir Katalog:** STR, AGI ve INT tabanlı veri odaklı yetenek ve stat büyüme sistemi.

### 2. Savaş ve Hedefleme Altyapısı (Targeting & Combat Foundation)
- Merkezi `TargetRelationSystem` ile Dost, Düşman Hero, Düşman Minyon, Kule ve Orman Yaratığı hedef geçerlilik kontrolü.
- `AttackController` durum makinesi (Wind-up → Impact → Recovery).
- Kesintisiz sağ tık hareket, kiting, otomatik hedef arama, menzilli mermi fiziği (`BasicAttackProjectile3D`) ve hasar hesaplama ardışık düzeni (`CombatCalculator`).
- **Basılı Tutarak Hedefleme & Manyetik Kilitlenme (Move-to-Cast):** Büyüler asla menzil dışından havaya atılmaz, kahraman otomatik olarak büyü menziline yürüyüp atışı gerçekleştirir.

### 3. Minyon Dalgaları ve Koridor Savaşı (Creep Waves & Lane Combat)
- **3 Minyon Türü:** Melee (550 HP, tank), Ranged (300 HP, 6m menzil), Kuşatma / Siege (850 HP, 7m menzil, kulelere 1.5x bonus hasar).
- **3 Koridor Rotası:** Top, Mid ve Bot koridorları için fiziksel kışla portalları (`CreepBarracks3D`) ve waypoint yönlendirme sistemi.
- **Dinamik Hero Aggro & Call for Help:** Minyonlara saldıran düşman kahramanlara karşı 8m içindeki dost minyonların anında yardım çağrısına yanıt vermesi.
- **Dota 2 Last-Hit & XP Ekonomisi:** Son vuruşu yapan kahramana tam altın ve XP; minyonların kestiği hedeflerden yakındaki tüm kahramanlara paylaşımlı XP dağıtımı.

### 4. Orman Yaratıkları ve Kamplar (Neutral Creeps, Leashing & Stacking)
- 4 Kamp Seviyesi (Küçük, Orta, Büyük, Kadim).
- 14 metre Leash Mesafesi, 5 saniye kamp dışı kalma sınırı, Rapid Reset (hızlı geri dönüp iyileşme) ve Kamp İstifleme (Stacking) mekaniği.
- Fiziksel 3D taş sunaklar, kamp ateşleri ve dinamik meşale aydınlatmaları.

### 5. Dota 2 HUD & Konsol Arayüzü
- **Alt Konsol:** STR / AGI / INT nitelik kartları, Doğuştan Pasif (`💧`), Yetenek Ağacı (`🌳`), 6 Eşya Yuvası, Çizme Yuvası ve Tarafsız Eşya Yuvası.
- **Tek Parça Zengin Yetenek Kartları (`DotaAbilityTooltip`):** Yetenek butonlarının üzerine gelindiğinde anında açılan hasar, ölçeklenme, menzil ve detaylı mekanik/etkileşim notları.
- **Minimap & Kamera Görüş Konisi:** Sol alttaki minimap üzerinde kameranın canlı baktığı alanı gösteren şeffaf mavi görüş yamuğu (Frustum Cone), Radar Taraması (`📡`) ve Kule Tahkimatı (`🛡`).
- **Kafa Üstü Can Barları:** Segmentli can şeritleri (250 HP çizgileri), seviye rozetleri ve mana barları.
- **F1 Test & Demo Paneli:** Tek tıkla kahraman değiştirme, manken doğurma, dalga başlatma, ölümsüzlük ve seviye atlatma araçları.

### 6. 120 Eşya, Mağaza ve Hızlı Satın Alma (Quick-Buy)
- 120 adet dengelenmiş temel, gelişmiş ve efsanevi eşya (`data/items.json`).
- `market.png` standartlarında kategori sekmeleri (`TEMEL`, `YÜKSELTME`, `TARAFSIZ`), kahramana özel rehber eşya listeleri, canlı arama çubuğu ve sabitlenmiş eşyalar.
- **Sağ Alt Konsol:** 6 yuvalı Zula (Stash), tek tıkla Hızlı Alım (Quick-Buy), TP Parşömeni yuvası, büyük altın butonu ve kurye aksiyonları (`🐻 F2`, `⏩`, `🛡`, `➡ F3`).

---

## 🏗️ Proje Mimarisi

```
eclipse-moba/
├── autoload/                     # Global Singleton Yöneticileri (Database, GameEvents, BalanceConfig)
├── core/                         # Çekirdek Sistemler
│   ├── abilities/                # Yetenek Konteyneri ve Kaynak Tanımları
│   ├── combat/                   # Hasar Hesaplama, Durum Etkileri ve Hedefleme Sistemi
│   ├── entities/                 # Varlık Sınıfları (Hero, Creep, Tower, Neutral, Objective)
│   │   ├── controllers/          # Kamera ve Kahraman Kontrolcüleri (MobaCamera3D, HeroController3D)
│   │   └── heroes/               # Kahraman Uygulamaları (Solen, Astris, Kaelgor)
│   ├── items/                    # Eşya Tanımları ve Tarif Ağacı Çözücüsü
│   └── stats/                    # Nitelik Sistemi (STR/AGI/INT) ve Stat Değiştiricileri
├── data/                         # Veri Dosyaları (120 Items JSON, Hero Definitions)
├── scenes/                       # 3D Sahneler ve Harita
│   ├── effects/                  # Görsel Mermi ve Büyü Efektleri (BasicAttackProjectile3D)
│   └── map/                      # Moba Haritası, Kışlalar (CreepBarracks3D), Orman Kampları
├── systems/                      # Oyun İçi Alt Sistemler
│   ├── inventory/                # Envanter ve Altın Yöneticisi
│   ├── match/                    # Skor ve Maç Yöneticisi
│   └── ui/                       # Dota 2 HUD, Minimap, Mağaza, Tooltip ve Demo Panelleri
└── tests/                        # 187 Adet Kapsamlı Otomasyon Test Paketi
```

---

## 🧪 Test Paketi ve Doğrulama

Eclipse Front, tüm mekaniklerini ve matematiksel formüllerini doğrulayan **187 adet yerleşik birim ve entegrasyon testine** sahiptir:

- **Testleri Çalıştırma:** Proje içindeki `tests/test_suite.gd` dosyasını çalıştırın veya sahnede test panelini tetikleyin.
- **Sonuç:** `187 / 187 Test BAŞARILI (0 Hata)`

---

## 🎮 Kontroller ve Kısayollar

| Tuş | Eylem |
| :--- | :--- |
| **Sağ Tık (Zemin)** | Hareket et / Pozisyon al |
| **Sağ Tık (Düşman)** | Temel saldırı yap / Takip et ve saldır |
| **Q / W / E / R** | Yetenekleri hazırla / Kullan |
| **B veya P** | Dota 2 Mağazasını Aç / Kapat |
| **Shift + Sol Tık (Market)** | Eşyayı Hızlı Satın Alıma (Quick-Buy) Ekle |
| **F1** | Demo / Test Kontrol Panelini Aç / Kapat |
| **F2 / F3** | Kurye Seç / Kurye Gönder |
| **Alt (Basılı Tut)** | Kafa üstü sayısal can/mana ve saldırı menzili göstergeleri |
| **Mouse Hover (Yetenekler)** | Zengin yetenek bilgisi, hasar formülleri ve mekanik notları |
| **Mouse Hover (Eşyalar)** | Eşya statları, bedeli, pasif/aktif açıklaması ve bileşen ağacı |

---

## 📄 Lisans
Bu proje geliştirme ve eğitim amaçlı açık kaynak kodlu olarak yapılandırılmıştır.
