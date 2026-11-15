# ftodo — Flutter Mobil Uygulama

Workshop'ta geliştirilen Todo API'sini kullanan Flutter istemcisi.

## Özellikler

- Kayıt olma, giriş ve çıkış (Laravel Sanctum token)
- Token'ın cihazda saklanması (`shared_preferences`)
- Görev ekleme, düzenleme, silme ve tamamlandı olarak işaretleme
- Öncelik seçimi ve başlangıç tarihi/saati
- Tüm görevler / devam edenler / tamamlananlar filtresi
- İlerleme özeti kartı

## Kullanılan paketler

| Paket | Amaç |
| --- | --- |
| `flutter_riverpod` | Durum yönetimi |
| `dio` | HTTP istemcisi |
| `shared_preferences` | Token saklama |
| `intl` | Tarih biçimlendirme |
| `google_fonts` | Yazı tipleri |

## Klasör yapısı

```
lib/
├── core/          # sabitler, tema, token saklama, API hataları
├── models/        # User, Todo
├── repositories/  # API çağrıları (auth, todo)
├── providers/     # Riverpod provider'ları
├── screens/       # giriş, kayıt, ana sayfa, görev formu
└── widgets/       # tekrar kullanılan arayüz bileşenleri
```

## Çalıştırma

```bash
flutter pub get
flutter run
```

API adresi `lib/core/constants.dart` içindeki `apiBaseUrl` sabitinde tanımlıdır. Kendi backend'inizi kullanmak için bu değeri değiştirin (örn. Android emülatöründen yerel sunucu için `http://10.0.2.2:8000/api`).
