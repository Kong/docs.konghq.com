---
title: Key and Key Set Management in Kong Gateway
content_type: reference
---

Note that this is an OSS feature.


This page describes Kong Gateway's capabilities to manage asymmetric keys and key-sets in {{site.base_gateway}}.


### Keys and Key Sets

For some operations it is required to have access to public and/or private keys. This document describes how to achieve that with Kong Gateway.


### Use cases

Some Kong plugins offer a custom endpoint to configure JSON Web Keys today. This new endpoint aims to replace the custom endpoints for each plugin with this, a more generic endpoint. Affected plugins will gradually receive supported. TODO: table below where all plugins that _could_ use this feature and whether they already have support for it.


| plugin name    | keys/key-sets support |
|----------------|-----------------------|
| openid-connect | no                    |
| jwt-signer     | no                    |
| jwt            | no                    |
| jwe-decrypt    | yes                   |

### Keys

The generic `Keys` endpoint allows you to store asymmetric keys (public and or private key, note that also only a public key or only a private key can be stored) in different formats (ref to Formats section maybe?). A freely configurable `kid` string is required to identify the key. The `kid` attribute is a common way to identify the key that should be used to verify or decrypt a token in the JWT world but could be used in other scenarios where identifying a key is required.


### Key Sets

You can assign one or many keys to a key-set. This can be useful to logically group multiple keys. (A group of keys used for a specific application or service). Key-sets are also the preferred way to expose keys to plugins. (meaning; telling plugins where to look for keys -or- have a scoping mechanism to restrict plugins to just _some_ keys.). You will find instructions in the respective plugins docs on how to configure them using a key-set.
Note: Deleting a Key-set will remove all associated keys.


### Formats

Currently there is support for two common formats

* JWK
* PEM

Note that the formats carry the same base information (public and/or private key exponents) but may allow to specify additional meta information. (JWK carries more information than PEM/DER). This means that one keypair can have multiple different representations (JWK, PEM) while being the same key.


### Examples


#### Create a Key using the JWK format and associate it with a Key Set.

TODO: Also add a reference to a the admin api for keys/keysets

First create a Key-set


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


Now create a Key and associate it with the just created set.

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

#### Create a Key using PEM format and associate with key-set


Create a Key-Set first.


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
  "tags": null,
  "updated_at": 1669029622
}
```


Now create a PEM encoded key and associate it with the just created set.

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
