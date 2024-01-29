---
title: Claims-based authorization
nav_title: Claims
---

The following options can be configured to manage claims verification during authorization:

1. `config.scopes_claim` and `config.scopes_required`
2. `config.audience_claim` and `config.audience_required`
3. `config.groups_claim` and `config.groups_required`
4. `config.roles_claim` and `config.roles_required`

For example, the first configuration option, `config.scopes_claim`, points to a source, from which the value is
retrieved and checked against the value of the second configuration option: `config.scopes_required`.

## Prerequisites

{% include_cached /md/plugins-hub/oidc-prereqs.md %}

## Claims-based authorization

{% include_cached /md/plugins-hub/oidc-prod-note.md %}

Let's take a look at a JWT access token:

1. Patch the plugin to enable the password grant:
   ```bash
   http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
     config.auth_methods=password
   ```
2. Retrieve the content of an access token:
   ```bash
   http -a john:doe :8000 | jq -r .headers.Authorization
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```
   Bearer <access-token>
   ```
3. The signed JWT `<access-token>` (JWS) comes with three parts separated with a dot `.`:
   `<header>.<payload>.<signature>` (a JWS compact serialization format)
4. We are interested with the `<payload>`, and you should have something similar to:
   ```
   eyJleHAiOjE2MjI1NTY3MTMsImF1ZCI6ImFjY291bnQiLCJ0eXAiOiJCZWFyZXIiLC
   JzY29wZSI6Im9wZW5pZCBlbWFpbCBwcm9maWxlIiwicHJlZmVycmVkX3VzZXJuYW1l
   Ijoiam9obiIsImdpdmVuX25hbWUiOiJKb2huIiwiZmFtaWx5X25hbWUiOiJEb2UifQ
   ```
   That can be base64 url decoded to the following `JSON`:
   ```json
   {
       "exp": 1622556713,
       "aud": "account",
       "typ": "Bearer",
       "scope": "openid email profile",
       "preferred_username": "john",
       "given_name": "John",
       "family_name": "Doe"
   }
   ```
   This payload may contain arbitrary claims, such as user roles and groups,
   but as we didn't configure them in Keycloak, let's just use the claims that
   we have. In this case we want to authorize against the values in `scope` claim.

Let's patch the plugin that we created in the [Kong configuration](#prerequisites) step:

1. We want to only use the password grant for demonstration purposes.
2. We require the value `openid` and `email` to be present in `scope` claim of
   the access token.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=password                                   \
  config.scopes_claim=scope                                      \
  config.scopes_required="openid email"
```
```http
HTTP/1.1 200 OK
```
```json
{
    "id": "5f35b796-ced6-4c00-9b2a-90eef745f4f9",
    "name": "openid-connect",
    "service": {
        "id": "5fa9e468-0007-4d7e-9aeb-49ca9edd6ccd"
    },
    "config": {
        "auth_methods": [ "password" ],
        "scopes_claim": [ "scope" ],
        "scopes_required": [ "openid email" ]
    }
}
```

Now let's see if we can still access the service:

```bash
http -v -a john:doe :8000
```
```http
GET / HTTP/1.1
Authorization: Basic BEkg3bHT0ERXFmKr1qelBQYrLBeHb5Hr
```
```http
HTTP/1.1 200 OK
```
```json
{
   "headers": {
       "Authorization": "Bearer <access-token>"
   },
   "method": "GET"
}
```

Works as expected, but let's try to add another authorization:

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.audience_claim=aud                                      \
  config.audience_required=httpbin
```
```http
HTTP/1.1 200 OK
```
```json
{
    "id": "5f35b796-ced6-4c00-9b2a-90eef745f4f9",
    "name": "openid-connect",
    "service": {
        "id": "5fa9e468-0007-4d7e-9aeb-49ca9edd6ccd"
    },
    "config": {
        "auth_methods": [ "password" ],
        "audience_claim": [ "scope" ],
        "audience_required": [ "httpbin" ]
    }
}
```

As we know, the access token has `"aud": "account"`, and that does not match with `"httpbin"`, so
the request should now be forbidden:

```bash
http -v -a john:doe :8000
```
```http
HTTP/1.1 403 Forbidden
```
```json
{
    "message": "Forbidden"
}
```

A few words about `config.scopes_claim` and `config.scopes_required` (and the similar configuration options).
You may have noticed that `config.scopes_claim` is an array of string elements. Why? It is used to traverse
the JSON when looking up a claim, take for example this imaginary payload:

```json
{
    "user": {
        "name": "john",
        "groups": [
            "employee",
            "marketing"
        ]
    }
}
```

In this case you would probably want to use `config.groups_claim` to point to `groups` claim, but that claim
is not a top-level claim, so you need to traverse there:

1. Find the `user` claim.
2. Inside the `user` claim, find the `groups` claim, and read its value:

```json
{
    "config": {
        "groups_claim": [
            "user",
            "groups"
        ]
    }
}
```

or

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.groups_claim=user                                       \
  config.groups_claim=groups
```

The value of a claim can be the following:

- a space separated string (such as `scope` claim usually is)
- an JSON array of strings (such as the imaginary `groups` claim above)
- a simple value, such as a `string`

What about the `config.groups_required` then? That is also an array?

That is correct, the required checks are arrays to allow logical `and`/`or` type of checks:

1. `and`: use a space separated values
2. `or`: specify value(s) in separate array indices


For example:

```json
{
    "config": {
        "groups_required": [
            "employee marketing",
            "super-admins"
        ]
    }
}
```

or

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.groups_required="employee marketing"                    \
  config.groups_required="super-admins"
```

The above means that a claim has to have:
1. `employee` **and** `marketing` values in it, **OR**
2. `super-admins` value in it