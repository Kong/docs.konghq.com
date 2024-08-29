---
nav_title: Overview
title: Overview
---

The Upstream OAuth plugin lets you manage OAuth flows between Kong Gateway and an upstream service.

## Authentication methods

This plugin supports the following authentication methods:

- [`client_secret_basic`]: Send `client_id` and `client_secret` in an `Authorization: Basic` header
- [`client_secret_post`]: Send `client_id` and `client_secret` as part of the body
- [`client_secret_jwt`]: Send a JWT signed with the `client_secret` using the client assertion as part of the body

## Caching

The Upstream OAuth plugin will cache tokens returned by the IdP.  
Cache entries will expire based on the `expires_in` indicated by the IdP in the response to the token endpoint.

Tokens are cached using a hash of all values configured under the `config.oauth` key.
This means that if two instances of the plugin (for example, configured on different routes/services) use identical values under the `config.oauth` section then these will share cached tokens.

The plugin is designed to support storing tokens issued by the IdP in different backend formats. 

Currently, the following [strategies] are provided:

- `memory`: A `lua_shared_dict`. Note that the default dictionary, `kong_db_cache`, is also used by other plugins and elements of Kong to store unrelated database cache entities.
- `redis`: Supports Redis, Redis Cluster, and Redis Sentinel deployments.


## Get started with the Upstream OAuth plugin

* [Configuration reference](/hub/kong-inc/upstream-oauth/configuration/)
* [Basic configuration example](/hub/kong-inc/upstream-oauth/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/upstream-oauth/how-to/)
