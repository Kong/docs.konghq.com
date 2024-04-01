---
title: ACL-based authorization
nav_title: ACL
---

The OpenID Connect plugin can be integrated with the [ACL plugin](/hub/kong-inc/acl/), which provides
access control functionality in the form of allow and deny lists.

You can also pair ACL-based authorization with 
[Kong consumer authorization](/hub/kong-inc/openid-connect/how-to/authorization/consumer/).

## Prerequisites

{% include_cached /md/plugins-hub/oidc-prereqs.md %}

## ACL plugin authorization

{% include_cached /md/plugins-hub/oidc-prod-note.md %}

### Configure OpenID Connect

First, configure the OpenID Connect plugin for integration with the ACL plugin.
For the purposes of the demo, you can use the 
[password grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/).

<!-- vale off-->
{% plugin_example %}
plugin: kong-inc/openid-connect
name: openid-connect
config:
  issuer: "http://keycloak.test:8080/auth/realms/master"
  client_id: "kong"
  client_auth: "private_key_jwt"
  auth_methods:
    - "password"
  authenticated_groups_claim:
    - "scope"
targets:
  - service
formats:
  - konnect
  - curl
  - yaml
  - kubernetes
{% endplugin_example %}
<!--vale on -->

Before applying the ACL plugin, test the OpenID Connect plugin configuration:

```bash
curl --user user:pass http://localhost:8000
```

You should get an HTTP 200 response with an `X-Authenticated-Groups` header:

```json
{
    "headers": {
        "X-Authenticated-Groups": "openid, email, profile",
    }
}
```

### Configure the ACL plugin

The following examples show how to enable ACL deny or allow lists with OpenID Connect. 
You can also have both `allow` and `deny` lists configured at the same time.

{% navtabs %}
{% navtab Allow %}

Add the ACL plugin to the `openid-connect` service and configure the `allow` parameter:

<!-- vale off-->
{% plugin_example %}
plugin: kong-inc/acl
name: acl
config:
  allow:
    - "openid"
targets:
  - service
formats:
  - konnect
  - curl
  - yaml
  - kubernetes
{% endplugin_example %}
<!--vale on -->

Test the configuration with both plugins enabled:

```bash
curl --user user:pass http://localhost:8000
```

You should get an HTTP 200 response.

{% endnavtab %}
{% navtab Deny %}

Add the ACL plugin to the `openid-connect` service and configure the `deny` parameter:

<!-- vale off-->
{% plugin_example %}
plugin: kong-inc/acl
name: acl
config:
  deny:
    - "openid"
targets:
  - service
formats:
  - konnect
  - curl
  - yaml
  - kubernetes
{% endplugin_example %}
<!--vale on -->

Try accessing the proxy:

```bash
curl --user john:doe http://localhost:8000
```

You should get an HTTP 403 Forbidden response, and the following message:

```json
{
    "message": "You cannot consume this service"
}
```

{% endnavtab %}
{% endnavtabs %}
