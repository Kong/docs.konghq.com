---
title: ACL-based authorization
nav_title: ACL
---

## Prerequisites

{% include_cached /md/plugins-hub/oidc-prereqs.md %}

## ACL plugin authorization

The OpenID Connect plugin can be integrated with [Kong ACL Plugin](/hub/kong-inc/acl/) that provides
access control functionality in form of allow and deny lists.

Let's first configure the OpenID Connect plugin for integration with the ACL plugin
(remove any other authorization if enabled):

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=password                                   \
  config.authenticated_groups_claim=scope
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
        "authorized_groups_claim": [ "scope" ]
    }
}
```

Before we apply the ACL plugin, let's try it once:

```bash
http -v -a john:doe :8000
```
```http
HTTP/1.1 200 OK
```
```json
{
    "headers": {
        "X-Authenticated-Groups": "openid, email, profile",
    }
}
```

Interesting, the `X-Authenticated-Groups` header was injected in a request.
This means that we are all good to add the ACL plugin:

```bash
http -f put :8001/plugins/b238b64a-8520-4bbb-b5ff-2972165cf3a2 \
  name=acl                                                     \
  service.name=openid-connect                                  \
  config.allow=openid
```

Let's test it again:

```bash
http -v -a john:doe :8000
```
```http
HTTP/1.1 200 OK
```

Let's make it forbidden by changing it to a deny list:

```bash
http -f patch :8001/plugins/b238b64a-8520-4bbb-b5ff-2972165cf3a2 \
  config.allow=                                                  \
  config.deny=profile
```

And try again:

```bash
http -v -a john:doe :8000
```
```http
HTTP/1.1 403 Forbidden
```
```json
{
    "message": "You cannot consume this service"
}
```