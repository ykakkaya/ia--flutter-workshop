# todo — Laravel Backend

Workshop'un Todo API'si. Laravel 13 ve Laravel Sanctum ile token tabanlı kimlik doğrulama sunar; her kullanıcı yalnızca kendi görevlerini görür.

## Gereksinimler

- PHP 8.3+
- Composer
- Node.js ve npm (ön yüz varlıkları için)

## Kurulum

```bash
composer run setup   # bağımlılıklar, .env, uygulama anahtarı, migration, build
composer run dev     # geliştirme sunucusu
```

Varsayılan veritabanı SQLite'tır (`.env.example` içinde `DB_CONNECTION=sqlite`).

## Uç noktalar

| Metot | Yol | Açıklama |
| --- | --- | --- |
| `POST` | `/api/register` | Kayıt ol, token al |
| `POST` | `/api/login` | Giriş yap, token al |
| `GET` | `/api/user` | Oturumdaki kullanıcı |
| `POST` | `/api/logout` | Token'ı sil |
| `GET` | `/api/todos` | Görevleri listele |
| `POST` | `/api/todos` | Görev oluştur |
| `GET` | `/api/todos/{id}` | Görev detayı |
| `PUT/PATCH` | `/api/todos/{id}` | Görev güncelle |
| `DELETE` | `/api/todos/{id}` | Görev sil |

`register` ve `login` IP başına dakikada 20 istekle sınırlıdır. Ayrıntılı istek/yanıt örnekleri için [docs/API.md](docs/API.md) dosyasına, etkileşimli dokümantasyon için uygulamadaki `/docs` sayfasına bakın.

## Testler

```bash
composer run test
```
