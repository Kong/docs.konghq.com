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

First, configure the OpenID Connect plugin.
For the purposes of the demo, you can use the 
[password grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/).

For the demo, we're going to set up the following:
* Issuer, client ID, and client auth: settings that connect the plugin to your IdP (in this case, the sample Keycloak app).
* Auth method: [password grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/)
 (enabled for demo purposes).
* We require the values `openid` and `email` to be present in the `scope` claim of
   the access token.

   A claim payload may contain arbitrary claims, such as user roles and groups,
   but as you didn't configure them in Keycloak, let's just use the claims that
   are configured. In this case, we want to authorize against the values in `scope` claim.

<!-- vale off-->
{% plugin_example %}
plugin: kong-inc/openid-connect
name: openid-connect
config:
  issuer: "http://keycloak.test:8080/auth/realms/master"
  client_id: "kong"
  client_auth: "private_key_jwt"
  auth_methods:
    - password
  scopes_claim:
    - scope
  scopes_required:
    - openid
    - email
targets:
  - service
formats:
  - konnect
  - curl
  - yaml
  - kubernetes
{% endplugin_example %}
<!--vale on -->

## Test the claims-based authorization

### Retrieve access token

In this example, the password grant
lets you obtain a JWT access token, enabling you to test how JWT access token authentication works. 
One way to get a JWT access token is to issue the following call 
(we use [jq](https://stedolan.github.io/jq/) to filter the response):

```bash
curl --user john:doe http://localhost:8000/openid-connect \
    | jq -r .headers.Authorization
```

Output:
```
Bearer <access-token>
```

The signed JWT `<access-token>` (JWS) composed of three parts, each separated with a dot character `.`:
`<header>.<payload>.<signature>` (a JWS compact serialization format).
We are interested with the `<payload>`, and you should have something similar to:
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

### Access the service

Try accessing the service:

```bash
curl --user john:doe http://localhost:8000
```
You should get an HTTP 200 response.

If you set a claim that isn't enabled in your IdP, you will get a 
403 Forbidden response instead. 

For example, if you also add `audience_claim = aud` to the plugin's configuration and try to access it with your Keycloak credentials from the [prerequisites](#prerequisites), the response will be a 403, as the access token has `"aud": "account"`, and that does not match `"httpbin"`.

## Arrays in claims-based configuration

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
curl -i -X PATCH http://localhost:8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  --data "config.groups_claim=user" \
  --data "config.groups_claim=groups"
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
curl -i -X PATCH http://localhost:8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  --data "config.groups_required=employee marketing" \
  --data "config.groups_required=super-admins"
```

The above means that a claim has to have:
1. `employee` **and** `marketing` values in it, **OR**
2. `super-admins` value in it