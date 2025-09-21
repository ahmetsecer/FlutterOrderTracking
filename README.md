# 📦 Flutter Sipariş Takip Uygulaması (v1)

Gerçek iş senaryolarına uygun **gradientsiz**, modern Material 3 sipariş takip uygulaması.  
Durum sekmeleri + sayaçlar, tarih aralığı filtresi, sıralama seçenekleri, arama, detay sayfası ve **kalıcı kullanıcı tercihleri** içerir.

## ✨ Öne Çıkanlar
- Durum sekmeleri **(sayaçlı)**: Tümü, Yeni, Hazırlanıyor, Kargoda, İptal/Değişim/İade, İptal
- **Tarih aralığı** filtresi (DateRangePicker)
- **Sıralama**: Tarih ↑/↓, Tutar ↑/↓
- **Arama**: Müşteri adı / Sipariş No
- **Detay**: Kalemler, adres, özetler
- **Kalıcı ayarlar**: Son filtre/sıralama/tema `shared_preferences` ile korunur
- **Karanlık/Aydınlık tema** geçişi
- **Responsive Material 3 UI** (Android, iOS, Web, Windows)

## 🚀 Çalıştırma
```bash
flutter pub get
flutter run -d chrome   # Web
# veya
flutter run
```

## 🧪 Mock Veri
`assets/orders.json` içindeki anonim ve zengin sahte veriler yüklenir.  
Gerçek API için `OrderService.fetchOrders()` metodunu `http.get(...)` ile güncelleyin.

## 🔒 Gizlilik
Örnek veri **tamamen anonim** tutulmuştur (örn. "Contoso", "Globex", "Fabrikam").

## 📄 Lisans
MIT
