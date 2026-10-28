# Todo API

Base URL: `https://todo.ykakkaya.com/api`

Laravel Sanctum token kimlik doğrulaması kullanır. Her kullanıcı yalnızca kendi todo'larını görür ve değiştirir.

## Genel kurallar

- Tüm isteklerde `Accept: application/json` gönderin. İstek gövdesi olan isteklerde ayrıca `Content-Type: application/json` kullanın.
- Korumalı uçlarda `Authorization: Bearer <token>` başlığı gerekir. Token, `register` veya `login` yanıtında döner.
- Tokenın süresi dolmaz. `logout` ile o token silinir.
- `register` ve `login` uçları IP başına dakikada 20 istekle sınırlıdır. Aşılırsa `429` döner.
- Tarih ve saatler UTC, ISO 8601 biçiminde döner (örn. `2026-11-01T09:30:00.000000Z`). Gönderirken ISO 8601 kullanın.

### Hata yanıtları

| Kod | Anlam |
|-----|-------|
| `401` | Token yok veya geçersiz: `{"message":"Unauthenticated."}` |
| `404` | Todo yok **veya başka kullanıcıya ait** |
| `422` | Doğrulama hatası |
| `429` | Çok fazla istek |

Doğrulama hatası (`422`) biçimi:

```json
{
  "message": "The title field is required.",
  "errors": { "title": ["The title field is required."] }
}
```

---

## Kimlik doğrulama

### `POST /register`

Yeni kullanıcı oluşturur ve token döner.

| Alan | Tür | Kural |
|------|-----|-------|
| `name` | string | zorunlu, en çok 255 karakter |
| `email` | string | zorunlu, geçerli e-posta, benzersiz |
| `password` | string | zorunlu, en az 8 karakter |
| `password_confirmation` | string | zorunlu, `password` ile aynı |

```bash
curl -X POST https://todo.ykakkaya.com/api/register \
  -H 'Accept: application/json' -H 'Content-Type: application/json' \
  -d '{"name":"Ayşe","email":"ayse@example.com","password":"gizli1234","password_confirmation":"gizli1234"}'
```

`201 Created`:

```json
{
  "user": { "id": 1, "name": "Ayşe", "email": "ayse@example.com", "created_at": "...", "updated_at": "..." },
  "token": "1|abc123..."
}
```

### `POST /login`

| Alan | Tür | Kural |
|------|-----|-------|
| `email` | string | zorunlu |
| `password` | string | zorunlu |

`200 OK`: `register` ile aynı biçimde `user` ve `token` döner.
Hatalı bilgi: `422` `{"message":"E-posta veya şifre hatalı."}`

### `POST /logout` 🔒

Kullanılan token'ı siler. `200 OK`: `{"message":"Çıkış yapıldı."}`

### `GET /user` 🔒

Giriş yapmış kullanıcıyı döner.

---

## Todo'lar 🔒

### Todo nesnesi

```json
{
  "id": 12,
  "user_id": 1,
  "title": "Rapor hazırla",
  "description": "Aylık satış raporu",
  "priority": "high",
  "starts_at": "2026-11-01T09:30:00.000000Z",
  "completed": false,
  "created_at": "2026-10-28T13:43:22.000000Z",
  "updated_at": "2026-10-28T13:43:22.000000Z"
}
```

| Alan | Tür | Açıklama |
|------|-----|----------|
| `title` | string | Zorunlu, en çok 255 karakter |
| `description` | string \| null | İsteğe bağlı, en çok 5000 karakter |
| `priority` | string | `low` (düşük), `normal`, `high` (yüksek). Varsayılan `normal` |
| `starts_at` | datetime \| null | İsteğe bağlı başlama zamanı |
| `completed` | boolean | `false` = devam ediyor, `true` = tamamlandı. Varsayılan `false` |

### `GET /todos`

Kullanıcının todo'larını, en yeniden eskiye döner.

Sorgu parametresi `status` (isteğe bağlı):

| Değer | Sonuç |
|-------|-------|
| _(yok)_ | Tümü |
| `in_progress` | Devam edenler |
| `completed` | Tamamlananlar |

```bash
curl https://todo.ykakkaya.com/api/todos?status=in_progress \
  -H 'Accept: application/json' -H 'Authorization: Bearer 1|abc123...'
```

### `POST /todos`

Gövde: `title` (zorunlu), `description`, `priority`, `starts_at`, `completed`.

```bash
curl -X POST https://todo.ykakkaya.com/api/todos \
  -H 'Accept: application/json' -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer 1|abc123...' \
  -d '{"title":"Rapor hazırla","description":"Aylık satış raporu","priority":"high","starts_at":"2026-11-01T09:30:00Z"}'
```

`201 Created`: oluşturulan todo nesnesi.

### `GET /todos/{id}`

Tek todo döner. Başkasına aitse `404`.

### `PATCH /todos/{id}`

Kısmi güncelleme: yalnızca göndermek istediğiniz alanları yollayın. `description` veya `starts_at` için `null` göndererek alanı temizleyebilirsiniz. (`PUT` da aynı şekilde çalışır.)

```bash
# Tamamlandı olarak işaretle
curl -X PATCH https://todo.ykakkaya.com/api/todos/12 \
  -H 'Accept: application/json' -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer 1|abc123...' \
  -d '{"completed":true}'
```

`200 OK`: güncel todo nesnesi.

### `DELETE /todos/{id}`

`204 No Content`. Başkasına aitse `404`.

---

🔒 = `Authorization: Bearer <token>` gerekir.
