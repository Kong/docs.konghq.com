---
title: Keyring & Data Encryption
badge: enterprise
---

## View Keyring
**Endpoint**

<div class="endpoint get">/keyring</div>

**Response**

```
HTTP 200 OK
```

```json
{
    "active": "RfsDJ2Ol",
    "ids": [
        "RfsDJ2Ol",
        "xSD219lH"
    ]
}

```

## View Active Key
**Endpoint**

<div class="endpoint get">/keyring/active</div>

**Response**

```
HTTP 200 OK
```

```json
{
    "id": "RfsDJ2Ol"
}

```

## Export Keyring

*This endpoint is only available with the `cluster` keyring strategy.*

*The endpoint requires that the `keyring_public_key` and `keyring_private_key` Kong configuration values are defined.*

**Endpoint**

<div class="endpoint post">/keyring/export</div>

**Response**

```
HTTP 200 OK
```

```json
{
    "data": "<base64>..."
}
```

## Import Exported Keyring

*This endpoint is only available with the `cluster` keyring strategy.*

*The endpoint requires that the `keyring_public_key` and `keyring_private_key` Kong configuration values are defined.*

**Endpoint**

<div class="endpoint post">/keyring/import</div>

**Request Body**

| Attribute        | Description                   |
| ---------        | -----------                   |
| `data`           | Base64-encoded keyring export material. |


**Response**

```
HTTP 201 Created
```

## Import Key

*This endpoint is only available with the `cluster` keyring strategy.*

*The endpoint requires that the `keyring_public_key` and `keyring_private_key` Kong configuration values are defined.*

**Endpoint**

<div class="endpoint post">/keyring/import/raw</div>

**Request Body**

| Attribute        | Description                   |
| ---------        | -----------                   |
| `id`             | 8-byte key identifier.        |
| `data`           | Base64-encoded keyring export material. |


**Response**

```
HTTP 201 Created
```

## Generate New Key

*This endpoint is only available with the `cluster` keyring strategy.*

**Endpoint**

<div class="endpoint post">/keyring/generate</div>

**Response**

```
HTTP 201 Created
```

```json
{
    "id": "500pIquV",
    "key": "3I23Ben5m7qKcCA/PK7rnsNeD3kI4IPtA6ki7YjAgKA="
}
```

## Remove Key from Keyring

*This endpoint is only available with the `cluster` keyring strategy.*

**Endpoint**

<div class="endpoint post">/keyring/remove</div>

**Request Body**

| Attribute        | Description                   |
| ---------        | -----------                   |
| `key`             | 8-byte key identifier.        |


**Response**

```
HTTP 204 No Content
```

## Sync Keyring with Vault Endpoint

*This endpoint is only available with the `vault` keyring strategy.*

**Endpoint**

<div class="endpoint post">/keyring/vault/sync</div>

**Response**

```
HTTP 204 No Content
```
