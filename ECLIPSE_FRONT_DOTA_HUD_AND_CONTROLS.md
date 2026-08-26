# ECLIPSE FRONT — DOTA 2 STİLİ ARAYÜZ (HUD) VE RTS KONTROL SİSTEMİ

**Sürüm:** 1.0.0  
**Tasarım Referansı:** Dota 2 Dashboard & Classic RTS/MOBA Controls  
**Geliştirici:** Antigravity  

---

## 1. Dota 2 Stili Kullanıcı Arayüzü ([`DotaHUD`](file:///home/teha/Documents/Godot%20Projects/eclipse/systems/ui/dota_hud.gd))

Arayüz, Dota 2'nin modern ve işlevsel MOBA konsol yerleşimine göre inşa edilmiştir:

```
+-----------------------------------------------------------------------------------+
|  [RADIANT 0]                   [ 00:00 - SAAT & GÜN ]                   [0 DIRE]  |  <- Üst Skor & Zaman Paneli
+-----------------------------------------------------------------------------------+
|                                                                                   |
|                                3D OYUN ALANI                                      |
|                                                                                   |
+-------------------+---------------------------------------+-----------+-----------+
|                   |  [D] [Q] [W] [E] [R]  (Yetenek Deck)  | STR / AGI | [1][2][3] |
|   RADAR MİNİMAP   |  [=== CAN: 740 / 740 (+4.5) ===]      |    INT    | [4][5][6] |
|   (Sol Alt Köşe)  |  [=== MANA: 312 / 312 (+2.0) ==]      | AD / Zırh | [ Çizme ] |
|                   |  [=== ISI: 0 / 100 ==========]       | MR / Hız  | Altın/Shop|
+-------------------+---------------------------------------+-----------+-----------+
```

### Dashboard Bileşenleri:
1. **Kahraman Kimliği & Seviye Rozeti (Sol Konsol):**
   - Kahraman ismi (`KAELGOR` / `ASTRIS`), seviye çemberi (`Lv. 1`) ve birincil nitelik rozeti (`[GÜÇ]`, `[ZEKA]`).
2. **Sağlık, Mana ve Özel Kaynak Barları (Orta Konsol):**
   - **Can Barı:** Dota yeşili (`#2ecc71`), net can metni (`740 / 740`) ve sağda saniyelik can yenilenmesi (`+4.5`).
   - **Mana Barı:** Dota mavisi (`#2980b9`), mana metni (`312 / 312`) ve sağda saniyelik mana yenilenmesi (`+2.0`).
   - **Özel Isı Barı:** Kaelgor için akkor turuncu/kırmızı bar (`Isı: 0 / 100`), aşırı ısınmada yanıp sönen `AŞIRI ISINMA!` uyarısı.
3. **Yetenek Konsolu (Abilities Deck):**
   - Pasif (D), Q, W, E, R yuvaları.
   - Her yeteneğin altında seviye noktaları (normal yetenekler için 4 nokta, ulti için 3 nokta).
   - Seviye puanı varken yeteneklerin üzerinde beliren altın sarısı `[+]` seviye yükseltme butonları.
   - Gerçek zamanlı bekleme süresi karartması ve saniye geri sayımı.
   - Sağ alt köşede mavi mana maliyeti etiketi.
4. **Nitelikler ve Savaş İstatistikleri:**
   - Güç (STR), Çeviklik (AGI), Zeka (INT) değerleri ve birincil niteliğin altın parlaması.
   - Saldırı Gücü, Zırh, Büyü Direnci, Hareket Hızı göstergeleri.
5. **6 + 1 Özel Envanter & Dükkan:**
   - 6 temel eşya yuvası (2x3 ızgara) + 1 dikey özel Çizme yuvası.
   - Altın sayacı (`600g`) ve tıklandığında veya `[P]` / `[B]` tuşuyla açılan 120 eşyalık tam oyun içi dükkan.
6. **2D Radar Minimap (Sol Alt):**
   - 160x160m harita iz düşümü, koridor yolları, kule noktaları, oyuncu kahraman konumu (sarı imleç).
   - Sol tık ile kamerayı haritada istenen noktaya taşıma, sağ tık ile kahramana doğrudan yürüme emri verme.

---

## 2. Fare ve RTS Kamera Kontrolleri ([`MobaCamera3D`](file:///home/teha/Documents/Godot%20Projects/eclipse/core/entities/controllers/moba_camera_3d.gd))

- **Fare Kenar Kaydırma (Edge Panning):** İmleç ekranın 16 piksellik kenarlarına geldiğinde kamera akıcı bir şekilde o yöne kayar.
- **Orta Tuş Sürükleme (Middle Drag):** Fare orta tuşuna basılı tutularak harita istenilen hızda serbestçe sürüklenebilir.
- **Fare Tekerleği Yakınlaştırma (Zoom):** 10m ile 34m yükseklik aralığında pürüzsüz kamera yakınlaştırma/uzaklaştırma.
- **Spacebar (Boşluk Tuşu):** Kamerayı anında kahramanın üzerine odaklar ve takip moduna alır.
- **Harita Sınırları:** Kamera harita sınırları dışına taşmayacak şekilde sınırlandırılmıştır.

---

## 3. Tıklayarak Yürüme, Saldırı ve Yumuşak Yönelme ([`HeroController3D`](file:///home/teha/Documents/Godot%20Projects/eclipse/core/entities/controllers/hero_controller_3d.gd))

- **Sağ Tık ile Yürüme:** Zemine sağ tıklandığında zeminde yeşil renkli 3D halka (`ClickMarker3D`) belirir. Kahraman hedefe doğru anında dönerek (`rotation.y` açı interpolasyonu) akıcı şekilde yürür.
- **Sağ Tık ile Saldırma:** Düşman minyon, kahraman veya kuleye sağ tıklandığında kırmızı 3D hedef halkası çıkar. Kahraman saldırı menziline kadar hedefi takip eder ve menzile girdiğinde otomatik saldırı döngüsünü başlatır.
- **S Tuşu (Stop Command):** Tüm yürüme ve saldırı emirlerini anında iptal eder.
- **Q, W, E, R Tuşları:** Yetenekleri imleç veya hedefe doğru anında ateşler.
- **Ctrl + Q/W/E/R:** Yeteneklerin seviyesini klavyeden hızlıca yükseltir.
