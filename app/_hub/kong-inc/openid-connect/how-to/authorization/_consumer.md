---
title: Consumer authorization
nav_title: Consumer
---

## Prerequisites

{% include_cached /md/plugins-hub/oidc-prereqs.md %}

## Consumer authorization

The third option for authorization is to use Kong consumers and dynamically map
from a claim value to a Kong consumer. This means that we restrict the access to
only those that do have a matching Kong consumer. Kong consumers can have ACL
groups attached to them and be further authorized with the
[Kong ACL Plugin](/hub/kong-inc/acl/).

Let's use the following token payload:

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

Out of these attributes, the `preferred_username` claim looks promising for consumer mapping.

Let's patch the plugin that we created in the [Kong configuration](#prerequisites) step:

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=password                                   \
  config.consumer_claim=preferred_username                       \
  config.consumer_by=username
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
        "consumer_claim": [ "preferred_username" ],
        "consumer_by": [ "username" ]
    }
}
```

Before we proceed, let's make sure we don't have consumer `john`:

```bash
http delete :8001/consumers/john
```
```http
HTTP/1.1 204 No Content
```

Let's try to access the service without a matching consumer:

```bash
http -a john:doe :8000
```
```http
HTTP/1.1 403 Forbidden
```
```json
{
    "message": "Forbidden"
}
```

Now, let's add the consumer:

```bash
http -f put :8001/consumers/john
```
```http
HTTP/1.1 200 OK
```
```json

{
    "id": "<consumer-id>",
    "username": "john"
}
```

Let's try to access the service again:

```bash
http -a john:doe :8000
```
```http
HTTP/1.1 200 OK
```
```json
{
    "headers": {
        "Authorization": "Bearer <access-token>",
        "X-Consumer-Id": "<consumer-id>",
        "X-Consumer-Username": "john"
    },
    "method": "GET"
}
```

You can see that the plugin added the `X-Consumer-Id` and `X-Consumer-Username` as request headers.

{:.note}
> It is possible to make consumer mapping optional and non-authorizing by setting the configuration parameter 
[`config.consumer_optional=true`](/hub/kong-inc/openid-connect/configuration/#consumer_optional).