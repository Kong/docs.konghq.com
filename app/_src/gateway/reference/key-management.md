---
title: Key and Key Set Management in Kong Gateway
content_type: reference
badge: free
---


This page describes {{site.base_gateway}}'s capabilities to manage asymmetric keys and key-sets in {{site.base_gateway}}.

For some operations, access to public and private keys is required. This document also describes how to grant access to those keys using {{site.base_gateway}}.

{% if_version gte:3.2.x %}
>This feature is available in both {site.konnect_short_name}}, and Kong Manager. In **Konnect**, you can manage keys as a  **Runtime Manager** entity. In Kong Manager, it is available from the **API Gateway** drop-down.
{% endif_version %}
{:.note}

### Use cases

Some {{site.base_gateway}} plugins offer a custom endpoint to configure JSON Web Keys. The new generic endpoint replaces the custom endpoints for each plugin. The following table lists the plugins that support the new endpoint:


| Plugin                                         | Keys/Key Sets supported |
| ---------------------------------------------- | --------------------- |
| [OpenID Connect](/hub/kong-inc/openid-connect) | No                    |
| [JWT Signer](/hub/kong-inc/jwt-signer)         | No                    |
| [JWT](/hub/kong-inc/jwt)                       | No                    |
| [JWE Decrypt](/hub/kong-inc/jwe-decrypt)       | Yes                   |

### Keys endpoint

The generic `Keys` endpoint allows you to store asymmetric keys, either a public or private key, as a JWK or PEM. A configurable `kid` string is required to identify the key. The `kid` attribute is a common way to identify the key that should be used to verify or decrypt a token, but it can be used in other scenarios when you must identify a key.

### Key Sets endpoint

You can assign one or many keys to a JSON Web Key Set. This can be useful to logically group multiple keys to use for a specific application or service. Key Sets are also the preferred way to expose keys to plugins because they tell the plugin where to look for keys or have a scoping mechanism to restrict plugins to just _some_ keys.

See the following plugins documentation for more information about how to configure them using a Key Set:
* [OpenID Connect](/hub/kong-inc/openid-connect)
* [JWT Signer](/hub/kong-inc/jwt-signer)
* [JWT](/hub/kong-inc/jwt)
* [JWE Decrypt](/hub/kong-inc/jwe-decrypt)

{:.note}
> **Note:** Deleting a Key Set will remove all associated keys.


### Key formats

Currently two common formats are supported:

* JWK
* PEM

Both formats carry the same base information, such as the public or private key exponents, but may allow you to specify additional meta information. For example, the JWK format carries more information than PEM. This means that one key pair can have multiple different representations (JWK or PEM) while being the same key.

### Create a key using the JWK format and associate it with a Key Set

Create a Key Set:

{% navtabs codeblock %}
{% navtab cURL %}

```bash
curl -i -X PUT http://HOSTNAME:8001/key-sets  \
  --data name=my-set \
```

{% endnavtab %}
{% navtab HTTPie %}

```bash
http -f PUT :8001/key-sets \
  name=my-set \
```

{% endnavtab %}
{% endnavtabs %}

Result:

``` json
{
  "created_at": 1669029622,
  "id": "2033cb3d-ef3b-4f6d-8395-bc3c2d5a0e4f",
  "name": "my-set",
  "tags": null,
  "updated_at": 1669029622
  }
```

Create a key and associate it with the Key Set:

{% navtabs codeblock %}
{% navtab cURL %}

```bash
curl -i -X POST http://HOSTNAME:8001/keys  \
  --data name=my-first-jwk \
  --data jwk='{"kty":"RSA","kid":"42","use":"enc","n":"pjdss8ZaDfEH6K6U7GeW2nxDqR4IP049fk1fK0lndimbMMVBdPv_hSpm8T8EtBDxrUdi1OHZfMhUixGaut-3nQ4GG9nM249oxhCtxqqNvEXrmQRGqczyLxuh-fKn9Fg--hS9UpazHpfVAFnB5aCfXoNhPuI8oByyFKMKaOVgHNqP5NBEqabiLftZD3W_lsFCPGuzr4Vp0YS7zS2hDYScC2oOMu4rGU1LcMZf39p3153Cq7bS2Xh6Y-vw5pwzFYZdjQxDn8x8BG3fJ6j8TGLXQsbKH1218_HcUJRvMwdpbUQG5nvA2GXVqLqdwp054Lzk9_B_f1lVrmOKuHjTNHq48w","e":"AQAB","d":"ksDmucdMJXkFGZxiomNHnroOZxe8AmDLDGO1vhs-POa5PZM7mtUPonxwjVmthmpbZzla-kg55OFfO7YcXhg-Hm2OWTKwm73_rLh3JavaHjvBqsVKuorX3V3RYkSro6HyYIzFJ1Ek7sLxbjDRcDOj4ievSX0oN9l-JZhaDYlPlci5uJsoqro_YrE0PRRWVhtGynd-_aWgQv1YzkfZuMD-hJtDi1Im2humOWxA4eZrFs9eG-whXcOvaSwO4sSGbS99ecQZHM2TcdXeAs1PvjVgQ_dKnZlGN3lTWoWfQP55Z7Tgt8Nf1q4ZAKd-NlMe-7iqCFfsnFwXjSiaOa2CRGZn-Q","p":"4A5nU4ahEww7B65yuzmGeCUUi8ikWzv1C81pSyUKvKzu8CX41hp9J6oRaLGesKImYiuVQK47FhZ--wwfpRwHvSxtNU9qXb8ewo-BvadyO1eVrIk4tNV543QlSe7pQAoJGkxCia5rfznAE3InKF4JvIlchyqs0RQ8wx7lULqwnn0","q":"ven83GM6SfrmO-TBHbjTk6JhP_3CMsIvmSdo4KrbQNvp4vHO3w1_0zJ3URkmkYGhz2tgPlfd7v1l2I6QkIh4Bumdj6FyFZEBpxjE4MpfdNVcNINvVj87cLyTRmIcaGxmfylY7QErP8GFA-k4UoH_eQmGKGK44TRzYj5hZYGWIC8","dp":"lmmU_AG5SGxBhJqb8wxfNXDPJjf__i92BgJT2Vp4pskBbr5PGoyV0HbfUQVMnw977RONEurkR6O6gxZUeCclGt4kQlGZ-m0_XSWx13v9t9DIbheAtgVJ2mQyVDvK4m7aRYlEceFh0PsX8vYDS5o1txgPwb3oXkPTtrmbAGMUBpE","dq":"mxRTU3QDyR2EnCv0Nl0TCF90oliJGAHR9HJmBe__EjuCBbwHfcT8OG3hWOv8vpzokQPRl5cQt3NckzX3fs6xlJN4Ai2Hh2zduKFVQ2p-AF2p6Yfahscjtq-GY9cB85NxLy2IXCC0PF--Sq9LOrTE9QV988SJy_yUrAjcZ5MmECk","qi":"ldHXIrEmMZVaNwGzDF9WG8sHj2mOZmQpw9yrjLK9hAsmsNr5LTyqWAqJIYZSwPTYWhY4nu2O0EY9G9uYiqewXfCKw_UngrJt8Xwfq1Zruz0YY869zPN4GiE9-9rzdZB33RBw8kIOquY3MK74FMwCihYx_LiU2YTHkaoJ3ncvtvg"}' \
  --data kid=42 \
  --data set.name=my-set
```

{% endnavtab %}
{% navtab HTTPie %}

```bash
http -f PUT :8001/keys \
  name=my-first-jwk \
  jwk='{"kty":"RSA","kid":"42","use":"enc","n":"pjdss8ZaDfEH6K6U7GeW2nxDqR4IP049fk1fK0lndimbMMVBdPv_hSpm8T8EtBDxrUdi1OHZfMhUixGaut-3nQ4GG9nM249oxhCtxqqNvEXrmQRGqczyLxuh-fKn9Fg--hS9UpazHpfVAFnB5aCfXoNhPuI8oByyFKMKaOVgHNqP5NBEqabiLftZD3W_lsFCPGuzr4Vp0YS7zS2hDYScC2oOMu4rGU1LcMZf39p3153Cq7bS2Xh6Y-vw5pwzFYZdjQxDn8x8BG3fJ6j8TGLXQsbKH1218_HcUJRvMwdpbUQG5nvA2GXVqLqdwp054Lzk9_B_f1lVrmOKuHjTNHq48w","e":"AQAB","d":"ksDmucdMJXkFGZxiomNHnroOZxe8AmDLDGO1vhs-POa5PZM7mtUPonxwjVmthmpbZzla-kg55OFfO7YcXhg-Hm2OWTKwm73_rLh3JavaHjvBqsVKuorX3V3RYkSro6HyYIzFJ1Ek7sLxbjDRcDOj4ievSX0oN9l-JZhaDYlPlci5uJsoqro_YrE0PRRWVhtGynd-_aWgQv1YzkfZuMD-hJtDi1Im2humOWxA4eZrFs9eG-whXcOvaSwO4sSGbS99ecQZHM2TcdXeAs1PvjVgQ_dKnZlGN3lTWoWfQP55Z7Tgt8Nf1q4ZAKd-NlMe-7iqCFfsnFwXjSiaOa2CRGZn-Q","p":"4A5nU4ahEww7B65yuzmGeCUUi8ikWzv1C81pSyUKvKzu8CX41hp9J6oRaLGesKImYiuVQK47FhZ--wwfpRwHvSxtNU9qXb8ewo-BvadyO1eVrIk4tNV543QlSe7pQAoJGkxCia5rfznAE3InKF4JvIlchyqs0RQ8wx7lULqwnn0","q":"ven83GM6SfrmO-TBHbjTk6JhP_3CMsIvmSdo4KrbQNvp4vHO3w1_0zJ3URkmkYGhz2tgPlfd7v1l2I6QkIh4Bumdj6FyFZEBpxjE4MpfdNVcNINvVj87cLyTRmIcaGxmfylY7QErP8GFA-k4UoH_eQmGKGK44TRzYj5hZYGWIC8","dp":"lmmU_AG5SGxBhJqb8wxfNXDPJjf__i92BgJT2Vp4pskBbr5PGoyV0HbfUQVMnw977RONEurkR6O6gxZUeCclGt4kQlGZ-m0_XSWx13v9t9DIbheAtgVJ2mQyVDvK4m7aRYlEceFh0PsX8vYDS5o1txgPwb3oXkPTtrmbAGMUBpE","dq":"mxRTU3QDyR2EnCv0Nl0TCF90oliJGAHR9HJmBe__EjuCBbwHfcT8OG3hWOv8vpzokQPRl5cQt3NckzX3fs6xlJN4Ai2Hh2zduKFVQ2p-AF2p6Yfahscjtq-GY9cB85NxLy2IXCC0PF--Sq9LOrTE9QV988SJy_yUrAjcZ5MmECk","qi":"ldHXIrEmMZVaNwGzDF9WG8sHj2mOZmQpw9yrjLK9hAsmsNr5LTyqWAqJIYZSwPTYWhY4nu2O0EY9G9uYiqewXfCKw_UngrJt8Xwfq1Zruz0YY869zPN4GiE9-9rzdZB33RBw8kIOquY3MK74FMwCihYx_LiU2YTHkaoJ3ncvtvg"}' \
  kid=42 \
  set.name=my-set
```

{% endnavtab %}
{% endnavtabs %}

Result:

```json
{
  "id":"92a245af-8cb6-4175-b3a9-9383cbb9848f",
  "jwk":
          { kty":"RSA",
            "kid":"42",
            "use":"enc",
            ..."},
  "created_at":1669029250,
  "updated_at":1669029250,
  "name":"my-first-jwk",
  "tags":null,
  "set":
          { "id":"cb5b5df8-0161-4fdf-a2ce-cefc9481d5f9"},
  "kid":"42",
  "pem":null
  }
```

### Create a Key using the PEM format and associate with a Key Set


Create a Key Set:

{% navtabs codeblock %}
{% navtab cURL %}

```bash
curl -i -X PUT http://HOSTNAME:8001/key-sets  \
  --data name=my-other-set \
```

{% endnavtab %}
{% navtab HTTPie %}

```bash
http -f PUT :8001/key-sets \
  name=my-other-set \
```

{% endnavtab %}
{% endnavtabs %}

Result:

``` json
{
  "created_at": 1669029622,
  "id": "2033cb3d-ef3b-4f6d-8395-bc3c2d5a0e4f",
  "name": "my-other-set",
  "jwks_url": null,
  "tags": null,
  "updated_at": 1669029622
  }
```

Create a PEM-encoded key and associate it with the Key Set:

{% navtabs codeblock %}
{% navtab cURL %}

```bash
curl -i -X POST http://HOSTNAME:8001/keys  \
  --data name=my-first-pem-key \
  --data pem.private_key=@path/to/private_key.pem
  --data pem.public_key=@path/to/public_key.pem
  --data kid=23 \
  --data set.name=my-other-set
```

{% endnavtab %}
{% navtab HTTPie %}

```bash
http -f PUT :8001/keys \
  name=my-first-jwk \
  kid=23 \
  set.name=my-other-set \
  pem.private_key=@path/to/private_key.pem \
  pem.public_key=@path/to/public_key.pem \
  -f
```

{% endnavtab %}
{% endnavtabs %}

Result:

```json
{
  "id":"92a245af-8cb6-4175-b3a9-9383cbb9848f",
  "jwk": null
  "pem": {
          "public_key": "----BEGIN...",
          "private_key": "----BEGIN...."
  }
  "created_at":1669029250,
  "updated_at":1669029250,
  "name":"my-first-pem-key",
  "tags":null,
  "set":
          { "id":"cb5b5df8-0161-4fdf-a2ce-cefc9481d5f9"},
  "kid":"23",
  }
```

### Importing keys from a remote resource


In case you need access to keys stored in a remote location, you can use the `jwks_url` attribute of the `key-sets` entity.
It enables easier management of keys for large-scale applications, where multiple keys might be needed to support different cryptographic functions or to support a large number of clients. By sourcing keys from remote URLs, Kong can automatically fetch the latest version of the JWKS keys, eliminating the need for manual updates and reducing the risk of key expiration or misconfiguration.
Sourcing JWKS(JSON Web Key Sets) from remote URLs enables Kong to support distributed and heterogeneous environments, where keys might be managed by different services or stored in different locations. This approach allows for flexible and scalable key management, while ensuring consistent and secure access to keys across the system

#### Example

``` shell
http :8001/key-sets name=google jwks_url=https://www.googleapis.com/oauth2/v3/certs

{
    "created_at": 1677147024,
    "id": "ed6d2e01-1e38-4e86-a7ef-fc1d7de5b472",
    "jwks_url": "https://www.googleapis.com/oauth2/v3/certs",
    "name": "google",
    "tags": null,
    "updated_at": 1677147024
}

# this should have triggered a key retrieval from the specified `jwks_url`

http  :8001/key-sets/google/keys


{
    "data": [
        {
            "created_at": 1677147024,
            "id": "88d18f0e-014f-4b75-b730-8168aa5fb967",
            "jwk": ".."
            "name": null,
            "pem": null,
            "set": {
                "id": "ed6d2e01-1e38-4e86-a7ef-fc1d7de5b472"
            },
            "tags": null,
            "updated_at": 1677147024
        },
        {
            "created_at": 1677147024,
            "id": "9138ac51-d3d6-4efa-84e8-979766b209ef",
            "jwk": "..."
            "kid": "d25f8dbcf97dc7ec401f0171fb6e6bda9ed9e792",
            "name": null,
            "pem": null,
            "set": {
                "id": "ed6d2e01-1e38-4e86-a7ef-fc1d7de5b472"
            },
            "tags": null,
            "updated_at": 1677147024
        }
    ],
    "next": null
}
```

Keys will

* inherit the `kid` from the remote key-set.
* not have a name

Keys must be rejected when they

* don't match the expected format
* can't be loaded by our openssl lib
* there is no `kid`

#### Rotation

Keys and key-sets behind a remote resource can be subject to change. As there is no canonical way  in Kong to get notified about remote content change, we have to support time/schedule based key-rotation.

Keys will only be updated when

* the `JWK` (identified by `kid`) has changed in the remote location
	* or does not yet exist

Rotation is a process that needs to be kicked off when:

* Kong starts (starts a timer with a 10 minute cooldown)
* A key-set was
	* created
	* updated
	* deleted

Cache invalidation events need to be emitted in these scenarios. This is handled by the entity for all CRUD events)

##### Interfaces

The timeframe a user choose to trigger key-rotation might be relatively large. Within Kong, we need mechanisms to interface with this feature to forcefully trigger a key rotation.

##### Plugins

Within plugins we can use the `dao` to trigger the `rotate` function

``` lua
-- kong/plugin/example/handler.lua

local key_set = kong.db.key_sets:select("key-set name or ID you get from the plugin's configuration")

locak rotate_ok, rotate_err = kong.db.key_sets:rotate(key_set)
--- ..

```

##### Admin Api

If a user is aware that the content in the remote resource has changed, he can kick-off a `rotate` operation by targeting the respective key-set

``` shell
http :8001/key-sets/:key-set/rotate
{
    "message": "ok"
}
```


### FAQ:


* What happens with keys that are associated to a key-set but can't be found on a remote URL?

A) Remove
B) Keep

(B). A user may want to mix and match remote keys with self-issues keys. There can be a partial outage of the remote server where it will appear healthy (status->200) but does not deliver content. In this case we should not remove keys.


* Do we keep previously rotated keys?


No, keys are separate, loosely coupled, entities that have no notion of `previous` or `current`.  A successful rotation will only update existing keys (detected by their `kid` attribute). There is no "hot swap" where full key-sets are flipped from `previous->current`.


* When _new_ appear in the resource will they be included automatically?


Yes.
