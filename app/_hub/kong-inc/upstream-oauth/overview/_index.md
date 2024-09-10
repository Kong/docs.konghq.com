---
nav_title: Overview
title: Overview
---

The Upstream OAuth plugin allows {{site.base_gateway}} to support OAuth flows between Kong and the upstream API.

The plugin supports storing tokens issued by the IdP in different backend formats.

## How it works

The upstream OAuth2 credential flow works similarly to the [client credentials grant](/hub/kong-inc/openid-connect/how-to/authentication/client-credentials/) used by the OpenID Connect plugin. If a cached access token isn't found, Kong issues a request to the IdP token endpoint to obtain a new token, which is cached, and then passed to the upstream API via a configurable header (`Authorization` by default).

<!--vale off-->

{% mermaid %}
sequenceDiagram
    autonumber
    participant client as Client <br>(e.g. mobile app)
    participant kong as API Gateway <br>(Kong)
    participant idp as IdP <br>(e.g. Keycloak)
    participant api as 3rd Party API
    activate client
    activate kong
    client->>kong: request to Kong
    deactivate client
    activate idp
    kong->>idp: request access token <br>from IdP using <br>client ID and client secret (if IdP auth is set)
    deactivate kong
    idp->>idp: authenticate client
    activate kong
    idp->>kong: return access token
    deactivate idp
    activate api
    kong->>api: request with access token <br>in Authorization header
    deactivate kong
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
Cached entries expire based on the `expires_in` indicated by the IdP in the response to the token endpoint.

Tokens are cached using a hash of all values configured under the [`config.oauth`](/hub/kong-inc/upstream-oauth/configuration/#config-oauth) key.
This means that if two instances of the plugin (for example, configured on different routes and services) use identical values under the `config.oauth` section,
then these will share cached tokens.

### Caching strategies

The plugin supports the following caching [strategies](/hub/kong-inc/upstream-oauth/configuration/#config-stategy):

* `memory`: A locally stored `lua_shared_dict`. The default dictionary, `kong_db_cache`, is also used by other plugins and {{site.base_gateway}} elements to store unrelated database cache entities.
* `redis`: Supports Redis, Redis Cluster, and Redis Sentinel deployments.

## Get started with the Upstream OAuth plugin

* [Configuration reference](/hub/kong-inc/upstream-oauth/configuration/)
* [Basic configuration example](/hub/kong-inc/upstream-oauth/how-to/basic-example/)
