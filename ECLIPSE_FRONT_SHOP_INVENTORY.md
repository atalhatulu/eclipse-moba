# ECLIPSE FRONT — SHOP & 6+1 INVENTORY UI SPECIFICATION

**Version:** 1.0.0
**UI Nodes:** `res://systems/ui/shop_inventory_ui.tscn` & `shop_inventory_ui.gd`
**Control Scheme:**
- **P / B Tuşları:** Dükkan penceresini açar / kapatır.
- **HUD Alt Çubuk:** Anlık altın miktarı, 6 genel envanter yuvası, 1 özel çizme yuvası ve Dükkan butonu.
- **Envanter Yuvalarına Tıklama:** Seçili eşyayı görüntüler ve %70 altın iadesiyle Satış butonunu aktif eder.

---

## 1. Dükkan ve Envanter UI Mimarisi

```
┌──────────────────────────────────────────────────────────────────────────────┐
│  ECLIPSE FRONT — EŞYA MAĞAZASI            Mevcut Altın: 2700g          [ X ] │
├──────────────────────────────────────────────────────────────────────────────┤
│ [ TÜMÜ ] [ TEMEL ] [ ÇİZMELER ] [ ARA SEVİYE ] [ EFSANEVİ ] [ DESTEK ]        │
├──────────────────────────────────────┬───────────────────────────────────────┤
│ ITEM GRID LISTESİ                    │ EŞYA DETAY & SENTEZ PANELİ            │
│ ┌──────────────┐ ┌──────────────┐    │                                       │
│ │ Warblade     │ │ Razor Edge   │    │ Ravager [Efsanevi]                    │
│ │ 1100g        │ │ 1300g        │    │ Maliyet: 2850g (İndirimli: 550g)      │
│ ├──────────────┤ ├──────────────┤    │ ────────────────────────────────────  │
│ │ Hunter Recurv│ │ Duelist Blad │    │ Nitelikler:                           │
│ │ 1050g        │ │ 1250g        │    │ • Saldırı Gücü: +50.0                 │
│ ├──────────────┤ ├──────────────┤    │ • Maksimum Can: +250.0                │
│ │ Precision Bow│ │ Steelguard   │    │ ────────────────────────────────────  │
│ │ 1200g        │ │ 1100g        │    │ Tarif & Bileşenler:                   │
│ ├──────────────┤ ├──────────────┤    │ • [lime]Warblade (1100g) (Envanterde) │
│ │ Guardian Plat│ │ Braced Mail  │    │ • [lime]Vital Core (1200g) (Envanterde│
│ │ 1350g        │ │ 1200g        │    │ ────────────────────────────────────  │
│ └──────────────┘ └──────────────┘    │ [ Satın Al / Sentezle ] [ Sat (%70) ] │
└──────────────────────────────────────┴───────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────────┐
│ HUD ENVARTER ÇUBUĞU:                                                         │
│ [Altın: 2150g] [1: Ravager] [2: Boş] [3: Boş] [4: Boş] [5: Boş] [6: Boş]     │
│ [ | ] [Çizme: Swiftstep Boots]  [ Dükkan (P) ]                               │
└──────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Temel Fonksiyonel Özellikler

1. **Kategori Filtreleme:**
   - *Tümü (120 Eşya), Temel (36 Eşya), Çizmeler (6 Eşya), Ara Seviye (30 Eşya), Efsanevi (41 Eşya), Destek (7 Eşya)*.
2. **Dinamik Tarif Sentezi & İndirim Gösterimi:**
   - Seçilen bir üst kademe eşyanın (örn. *Ravager*) gerektirdiği alt bileşenler envanterde taranır.
   - Envanterde bulunan bileşenler yeşil renkle `(Envanterde)` olarak gösterilir, toplam değerleri hesaplanır ve oyuncunun ödeyeceği kalan altın anında güncellenir.
3. **6+1 Envanter & Çizme Yönlendirmesi:**
   - 6 normal envanter yuvası tamamen dolu olsa dahi, bir Çizme satın alındığında otomatik olarak bağımsız Çizme yuvasına aktarılır.
4. **Tek Tıkla Satış (%70 İade):**
   - Envanterdeki herhangi bir eşyaya tıklandığında, eşyanın satış değeri `%70` üzerinden hesaplanır ve tek tuşla satılarak altın anında kahramanın havuzuna eklenir, statlar geri alınır.

---

## 3. Otomatik Test Kapsamı (56/56 Test)

- `test_shop_category_filtering` -> 6 kategorinin tam liste doğrulaması.
- `test_shop_purchase_and_inventory_sync` -> Satın alma sonrası altın, envanter ve hero stat senkronizasyonu.
- `test_shop_recipe_tree_discount_calculation` -> Sahip olunan bileşenlerin indirim olarak düşülmesi.
- `test_shop_dedicated_boots_interaction` -> Dolu envanterde çizmenin özel yuvaya geçişi.
- `test_shop_slot_selling_refund` -> Eşya satışında %70 altın iadesi ve yuvanın serbest kalması.
