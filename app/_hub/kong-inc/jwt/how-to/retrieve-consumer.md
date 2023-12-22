---
nav_title: Retrieve the Consumer associated with a JWT
---

Retrieve a [Consumer][consumer-object] associated with a JWT
using the following request:

```bash
curl -X GET http://localhost:8001/jwts/<key-or-id>/consumer
```

Response:
```json
{
	"id": "8a21c1fa-e65e-4558-8673-540e85e67b33",
	"username_lower": "username",
	"custom_id": "123412312312312312312312",
	"type": 0,
	"created_at": 1664398410,
	"username": "Username",
	"tags": null
}
```

`key or id`: The `id` or `key` property of the JWT for which to get the
associated [Consumer][consumer-object].

[api-object]: /gateway/latest/admin-api/#api-object
[configuration]: /gateway/latest/reference/configuration
[consumer-object]: /gateway/latest/admin-api/#consumer-object