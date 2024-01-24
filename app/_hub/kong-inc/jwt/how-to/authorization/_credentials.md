---
nav_title: Manage JWT plugin credentials
---

### Create a JWT credential

{% navtabs %}
{% navtab Kong Admin API %}
You can provision a new HS256 JWT credential by issuing the following HTTP request:

```bash
curl -X POST http://localhost:8001/consumers/<consumer>/jwt -H "Content-Type: application/x-www-form-urlencoded"
```

Response:
```json
HTTP/1.1 201 Created
{
    "algorithm": "HS256",
    "consumer": {
        "id": "789955d4-7cbf-469a-bb64-8cd00bd0f0db"
    },
    "created_at": 1652208453,
    "id": "95d4ee08-c68c-4b69-aa18-e6efad3a4ff0",
    "key": "H8WBDhQlcfjoFmIiYymmkRm1y0A2c5WU",
    "rsa_public_key": null,
    "secret": "n415M6OrVnR4Dr1gyErpta0wSKQ2cMzK",
    "tags": null
}
```
{% endnavtab %}
{% navtab Declarative (YAML) %}
You can add JWT credentials on your declarative config file on the `jwt_secrets:` yaml entry:

``` yaml
jwt_secrets:
- consumer: <consumer>
```
{% endnavtab %}
{% endnavtabs %}

In both cases, the fields/parameters work as follows:

field/parameter                | default         | description
---                            | ---             | ---
`consumer`                   |                 | The `id` or `username` property of the [consumer][consumer-object] entity to associate the credentials to.
`key`<br>*optional*            |                 | A unique string identifying the credential. If left out, it will be auto-generated.
`algorithm`<br>*optional*      | `HS256`         | The algorithm used to verify the token's signature. Can be `HS256`, `HS384`, `HS512`, `RS256`, `RS384`, `RS512`, `ES256`, or `ES384`.
`rsa_public_key`<br>*optional* |                 | If `algorithm` is `RS256`, `RS384`, `RS512`, `ES256`, or `ES384`, the public key (in PEM format) to use to verify the token's signature.
`secret`<br>*optional*         |                 | If `algorithm` is `HS256`, `HS384`, or `HS512`, the secret used to sign JWTs for this credential. If left out, will be auto-generated.

{:.important}
> **Note for decK and {{site.kic_product_name}} users:** The declarative
configuration used in decK and the {{site.kic_product_name}} imposes some
additional validation requirements that differ from the requirements listed
above. Because they cannot rely on defaults and do not implement their own
algorithm-specific requirements, all fields other than
`rsa_public_key` fields are required.
> <br/><br/>
> You should always fill out `key`, `algorithm`, and
`secret`. If you use the `RS256` or
`ES256` algorithm, use a dummy value for `secret`.

### Delete a JWT credential

You can remove a Consumer's JWT credential by issuing the following HTTP
request:

```bash
curl -X DELETE http://localhost:8001/consumers/<consumer>/jwt/<jwt-id>
```

Response:
```
HTTP/1.1 204 No Content
```

- `consumer`: The `id` or `username` property of the [Consumer][consumer-object] entity to associate the credentials to.
- `jwt-id`: The `id` of the JWT credential.

### List JWT credentials

You can list a Consumer's JWT credentials by issuing the following HTTP
request:

```bash
curl -X GET http://localhost:8001/consumers/<consumer>/jwt
```

Response:
```
HTTP/1.1 200 OK
```

- `consumer`: The `id` or `username` property of the
  [Consumer][consumer-object] entity to list credentials for.

```json
{
	"data": [
        {
            "algorithm": "HS256",
            "consumer": {
                "id": "789955d4-7cbf-469a-bb64-8cd00bd0f0db"
            },
            "created_at": 1652208453,
            "id": "95d4ee08-c68c-4b69-aa18-e6efad3a4ff0",
            "key": "H8WBDhQlcfjoFmIiYymmkRm1y0A2c5WU",
            "rsa_public_key": null,
            "secret": "n415M6OrVnR4Dr1gyErpta0wSKQ2cMzK",
            "tags": null
        }
    ],
    "next": null
}
```