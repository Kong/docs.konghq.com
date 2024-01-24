---
nav_title: Paginate through the JWTs
---

You can paginate through the JWTs for all Consumers using the following
request:

```bash
curl -X GET http://localhost:8001/jwts
```

Response:
```json
{
	"next": null,
	"data": [
		{
			"id": "0701ad83-949c-423f-b553-091d5a6bae52",
			"secret": "C50k0bcahDhLNhLKSUBSR1OMiFGzNZ7X",
			"key": "YJdmaDvVTJxtcWRCvkMikc8oELgAVNcz",
			"tags": null,
			"rsa_public_key": null,
			"consumer": {
				"id": "8a21c1fa-e65e-4558-8673-540e85e67b33"
			},
			"algorithm": "HS256",
			"created_at": 1664462115
		},
		{
			"id": "e14d775e-3b52-45cc-be9e-b39cdb3f7ebf",
			"secret": "gFrOZAYWH1osQ6ivkesT4qqH16DHpKu0",
			"key": "7TrSUEFcEP7KZb2QrGT9IQXcEWrmszC8",
			"tags": null,
			"rsa_public_key": null,
			"consumer": {
				"id": "8a21c1fa-e65e-4558-8673-540e85e67b33"
			},
			"algorithm": "HS256",
			"created_at": 1664398496
		}
	]
}
```

You can filter the list by consumer by using another path:

```bash
curl -X GET http://localhost:8001/consumers/<username-or-id>/jwt
```

Response:
```json
{
    "next": null,
    "data": [
        {
            "created_at": 1511389527000,
            "id": "0dfc969b-02be-42ae-9d98-e04ed1c05850",
            "algorithm": "ES256",
            "key": "vcc1NlsPfK3N6uU03YdNrDZhzmFF4S19",
            "secret": "b65Rs6wvnWPYaCEypNU7FnMOZ4lfMGM7",
            "consumer": {
               "id": "c0d92ba9-8306-482a-b60d-0cfdd2f0e880" 
              }
        }
    ]
}
```

`username or id`: The username or id of the Consumer whose JWTs need to be listed.