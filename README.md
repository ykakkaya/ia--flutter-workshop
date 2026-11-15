# Flutter Workshop: Backend + Mobil

<p>
  <img src="https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/badge/Riverpod-00B4D8" alt="Riverpod"/>
  <img src="https://img.shields.io/badge/Laravel_13-FF2D20?logo=laravel&logoColor=white" alt="Laravel"/>
  <img src="https://img.shields.io/badge/PHP_8.3-777BB4?logo=php&logoColor=white" alt="PHP"/>
  <img src="https://img.shields.io/badge/Sanctum-auth-FF2D20" alt="Sanctum"/>
  <img src="https://img.shields.io/badge/SQLite-003B57?logo=sqlite&logoColor=white" alt="SQLite"/>
</p>

**Düzenleyen:** İstanbul Aydın Üniversitesi
**Tarih:** 28 Ekim 2026

Bu depo, İstanbul Aydın Üniversitesi'nde düzenlenen Flutter workshop'unda geliştirilen uygulamanın kaynak kodlarını ve dokümantasyonunu içerir. Workshop kapsamında hem sunucu tarafı (backend) hem de mobil uygulama (Flutter) geliştirilmiş, katılımcılar uçtan uca bir uygulamanın nasıl tasarlanıp hayata geçirildiğini adım adım takip etmiştir.

## Proje yapısı

| Klasör | İçerik |
| --- | --- |
| [`todo/`](todo) | Laravel 13 + Sanctum ile yazılmış Todo REST API'si (backend) |
| [`ftodo/`](ftodo) | Bu API'yi kullanan Flutter mobil uygulaması |

## Hızlı başlangıç

**Backend**

```bash
cd todo
composer run setup
composer run dev
```

**Mobil uygulama**

```bash
cd ftodo
flutter pub get
flutter run
```

Mobil uygulama varsayılan olarak yayındaki API'ye bağlanır. Yerel backend'i kullanmak için `ftodo/lib/core/constants.dart` içindeki `apiBaseUrl` değerini değiştirin.

## API dokümantasyonu

- [todo/docs/API.md](todo/docs/API.md): uç noktalar, istek/yanıt örnekleri ve hata kodları
- [todo/docs/openapi.json](todo/docs/openapi.json): OpenAPI 3.0 şeması
