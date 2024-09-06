---
nav_title: Overview
title: Overview
---

The Upstream OAuth plugin allows {{site.base_gateway}} to consume third-party or external APIs to initiate OAuth flows, which lets you use {{site.base_gateway}} in egress workflows.

The plugin supports storing tokens issued by the IdP in different backend formats.

## How it works

The upstream OAuth2 credential flow works similarly to the [client credentials grant](/hub/kong-inc/openid-connect/how-to/authentication/client-credentials/) used by the OpenID Connect plugin. However, instead of Kong verifying the access token, the verification is passed along to the upstream API, which then validates the token against the IdP.

<!--vale off-->

{% mermaid %}
sequenceDiagram
    autonumber
    participant client as Client <br>(e.g. mobile app)
    participant kong as API Gateway <br>(Kong)
    participant api as 3rd Party API
    participant idp as IDP <br>(e.g. Keycloak)
    activate client
    activate kong
    client->>kong: request to Kong<br>with any supported<br> authentication method
    deactivate client
    kong->>kong: load authentication<br> credentials
    activate idp
    kong->>idp: request access token <br>from IdP using <br>client ID and client secret
    deactivate kong
    idp->>idp: authenticate client
    activate kong
    idp->>kong: return access token
    deactivate idp
    activate api
    kong->>api: request with access token in <br>Authorization header
    deactivate kong
    activate idp
    api->>idp: validates <br> access token via IdP
    idp->>api: grants access
    deactivate idp
    activate kong
    api->>kong: response
    deactivate api
    activate client
    kong->>client: response
    deactivate client
    deactivate kong
{% endmermaid %}

<!--vale on-->


## Authentication methods

This plugin supports the following authentication methods:

* [`client_secret_basic`](/hub/kong-inc/upstream-oauth/configuration/#config-client_secret_basic): Send `client_id` and `client_secret` in an `Authorization: Basic` header
* [`client_secret_post`](/hub/kong-inc/upstream-oauth/configuration/#config-client_secret_basic): Send `client_id` and `client_secret` as part of the body
* [`client_secret_jwt`](/hub/kong-inc/upstream-oauth/configuration/#config-client_secret_basic): Send a JWT signed with the `client_secret` using the client assertion as part of the body

## Caching

The Upstream OAuth plugin caches tokens returned by the IdP.  
Cache entries expire based on the `expires_in` indicated by the IdP in the response to the token endpoint.

Tokens are cached using a hash of all values configured under the [`config.oauth`](/hub/kong-inc/upstream-oauth/configuration/#config-oauth) key.
This means that if two instances of the plugin (for example, configured on different routes and services) use identical values under the `config.oauth` section,
then these will share cached tokens.

### Caching strategies

The plugin supports the following caching [strategies](/hub/kong-inc/upstream-oauth/configuration/#config-stategy):

* `memory`: A locally stored `lua_shared_dict`. Note that the default dictionary, `kong_db_cache`, is also used by other plugins and elements of Kong to store unrelated database cache entities.
* `redis`: Supports Redis, Redis Cluster, and Redis Sentinel deployments.

## Get started with the Upstream OAuth plugin

* [Configuration reference](/hub/kong-inc/upstream-oauth/configuration/)
* [Basic configuration example](/hub/kong-inc/upstream-oauth/how-to/basic-example/)
