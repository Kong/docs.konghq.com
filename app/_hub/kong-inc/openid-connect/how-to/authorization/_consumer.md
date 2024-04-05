---
title: Consumer authorization
nav_title: Consumer
---

You can use Kong consumers for authorization and dynamically map
claim values to Kong consumers. This means that we restrict the access to
only those that do have a matching Kong consumer. Kong consumers can have ACL
groups attached to them and be further authorized with the
[Kong ACL plugin](/hub/kong-inc/acl/).

## Prerequisites

{% include_cached /md/plugins-hub/oidc-prereqs.md %}

## Consumer authorization

{% include_cached /md/plugins-hub/oidc-prod-note.md %}

Let's use the following example token payload:

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

Configure the OpenID Connect plugin for integration with the ACL plugin.
For the purposes of the demo, you can use the 
[password grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/).

For the demo, we're going to set up the following:
* Issuer, client ID, and client auth: settings that connect the plugin to your IdP (in this case, the sample Keycloak app).
* Auth method: [password grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/)
 (enabled for demo purposes).
* The `preferred_username` claim from the example payload.

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
  consumer_claim:
    - preferred_username
  consumer_by:
    - username
targets:
  - service
formats:
  - konnect
  - curl
  - yaml
  - kubernetes
{% endplugin_example %}
<!--vale on -->

## Test consumer-based authorization

1. Before moving on, make sure the consumer `john` doesn't exist:

    ```bash
    curl -i -X DELETE http//localhost:8001/consumers/john
    ```

2. Now try access the service without a matching consumer:

    ```bash
    curl --user john:doe http://localhost:8000
    ```

    You should get an HTTP 403 Forbidden response.

3. Now, add the consumer:

    ```bash
    curl -i -X PUT http://localhost:8001/consumers/john
    ```

    You should get an HTTP 200 if the consumer creation is successful.

4. Try to access the service again using the same consumer:

    ```bash
    curl --user john:doe http://localhost:8000
    ```

    This time, you should get an HTTP 200 response. 
    You should also see that the plugin added `X-Consumer-Id` and `X-Consumer-Username` as request headers:

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

{:.note}
> It is possible to make consumer mapping optional and non-authorizing by setting the configuration parameter 
[`config.consumer_optional=true`](/hub/kong-inc/openid-connect/configuration/#consumer_optional).