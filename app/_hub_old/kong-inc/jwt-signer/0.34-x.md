---
name: Kong JWT Signer
publisher: Kong Inc.
version: 0.34-x

desc: Verify and (re-)sign one or two tokens in a request
description: |
  The Kong JWT Signer plugin makes it possible to verify and (re-)sign
  one or two tokens in a request, that the plugin refers as access token
  and channel token. The plugin supports both opaque tokens (via introspection)
  and signed JWT tokens (JWS tokens via signature verification).
  `access_token` and `channel_token` are names of the tokens and they
  can be any valid verifiable tokens. E.g. two access tokens
  (one given to end user and one given to client application).

enterprise: true
type: plugin
categories:
  - authentication

kong_version_compatibility:
    community_edition:
      compatible:
    enterprise_edition:
      compatible:
        - 0.34-x

params:
  name: jwt-signer
  api_id: true
  service_id: true
  route_id: true
  consumer_id: false
---

## Contents

* [Plugin Configuration](#plugin-configuration)
* [Plugin Configuration Parameters](#plugin-configuration-parameters)
  * [Description of Plugin Configuration Parameters](#description-of-plugin-configuration-parameters)
    * [config.realm](#configrealm)
    * [config.access_token_issuer](#configaccess_token_issuer)
    * [config.access_token_keyset](#configaccess_token_keyset)
    * [config.access_token_jwks_uri](#configaccess_token_jwks_uri)
    * [config.access_token_request_header](#configaccess_token_request_header)
    * [config.access_token_leeway](#configaccess_token_leeway)
    * [config.access_token_scopes_required](#configaccess_token_scopes_required)
    * [config.access_token_scopes_claim](#configaccess_token_scopes_claim)
    * [config.access_token_consumer_claim](#configaccess_token_consumer_claim)
    * [config.access_token_consumer_by](#configaccess_token_consumer_by)
    * [config.access_token_upstream_header](#configaccess_token_upstream_header)
    * [config.access_token_upstream_leeway](#configaccess_token_upstream_leeway)
    * [config.access_token_introspection_endpoint](#configaccess_token_introspection_endpoint)
    * [config.access_token_introspection_authorization](#configaccess_token_introspection_authorization)
    * [config.access_token_introspection_body_args](#configaccess_token_introspection_body_args)
    * [config.access_token_introspection_hint](#configaccess_token_introspection_hint)
    * [config.access_token_introspection_jwt_claim](#configaccess_token_introspection_jwt_claim)
    * [config.access_token_introspection_scopes_required](#configaccess_token_introspection_scopes_required)
    * [config.access_token_introspection_scopes_claim](#configaccess_token_introspection_scopes_claim)
    * [config.access_token_introspection_consumer_claim](#configaccess_token_introspection_consumer_claim)
    * [config.access_token_introspection_consumer_by](#configaccess_token_introspection_consumer_by)
    * [config.access_token_introspection_leeway](#configaccess_token_introspection_leeway)
    * [config.access_token_signing_algorithm](#configaccess_token_signing_algorithm)
    * [config.access_token_optional](#configaccess_token_optional)
    * [config.verify_access_token_signature](#configverify_access_token_signature)
    * [config.verify_access_token_expiry](#configverify_access_token_expiry)
    * [config.verify_access_token_scopes](#configverify_access_token_scopes)
    * [config.verify_access_token_introspection_expiry](#configverify_access_token_introspection_expiry)
    * [config.verify_access_token_introspection_scopes](#configverify_access_token_introspection_scopes)
    * [config.cache_access_token_introspection](#configcache_access_token_introspection)
    * [config.trust_access_token_introspection](#configtrust_access_token_introspection)
    * [config.enable_access_token_introspection](#configenable_access_token_introspection)
    * [config.channel_token_issuer](#configchannel_token_issuer)
    * [config.channel_token_keyset](#configchannel_token_keyset)
    * [config.channel_token_jwks_uri](#configchannel_token_jwks_uri)
    * [config.channel_token_request_header](#configchannel_token_request_header)
    * [config.channel_token_leeway](#configchannel_token_leeway)
    * [config.channel_token_scopes_required](#configchannel_token_scopes_required)
    * [config.channel_token_scopes_claim](#configchannel_token_scopes_claim)
    * [config.channel_token_consumer_claim](#configchannel_token_consumer_claim)
    * [config.channel_token_consumer_by](#configchannel_token_consumer_by)
    * [config.channel_token_upstream_header](#configchannel_token_upstream_header)
    * [config.channel_token_upstream_leeway](#configchannel_token_upstream_leeway)
    * [config.channel_token_introspection_endpoint](#configchannel_token_introspection_endpoint)
    * [config.channel_token_introspection_authorization](#configchannel_token_introspection_authorization)
    * [config.channel_token_introspection_body_args](#configchannel_token_introspection_body_args)
    * [config.channel_token_introspection_hint](#configchannel_token_introspection_hint)
    * [config.channel_token_introspection_jwt_claim](#configchannel_token_introspection_jwt_claim)
    * [config.channel_token_introspection_scopes_required](#configchannel_token_introspection_scopes_required)
    * [config.channel_token_introspection_scopes_claim](#configchannel_token_introspection_scopes_claim)
    * [config.channel_token_introspection_consumer_claim](#configchannel_token_introspection_consumer_claim)
    * [config.channel_token_introspection_consumer_by](#configchannel_token_introspection_consumer_by)
    * [config.channel_token_introspection_leeway](#configchannel_token_introspection_leeway)
    * [config.channel_token_signing_algorithm](#configchannel_token_signing_algorithm)
    * [config.channel_token_optional](#configchannel_token_optional)
    * [config.verify_channel_token_signature](#configverify_channel_token_signature)
    * [config.verify_channel_token_expiry](#configverify_channel_token_expiry)
    * [config.verify_channel_token_scopes](#configverify_channel_token_scopes)
    * [config.verify_channel_token_introspection_expiry](#configverify_channel_token_introspection_expiry)
    * [config.verify_channel_token_introspection_scopes](#configverify_channel_token_introspection_scopes)
    * [config.cache_channel_token_introspection](#configcache_channel_token_introspection)
    * [config.trust_channel_token_introspection](#configtrust_channel_token_introspection)
    * [config.enable_channel_token_introspection](#configenable_channel_token_introspection)
  * [Default Plugin Configuration Values](#default-plugin-configuration-values)
* [Note About Signing Key Management](#note-about-signing-key-management)
* [Note About Consumer Mapping](#note-about-consumer-mapping)
* [Kong Admin API Endpoints](#kong-admin-api-endpoints)
  * [Cached JWKS Admin API Endpoint](#cached-jwks-admin-api-endpoint)
  * [Cached JWKS Admin API Endpoint for a Key Set](#cached-jwks-admin-api-endpoint-for-a-key-set)
  * [Cached JWKS Admin API Endpoint for a Key Set Rotation](#cached-jwks-admin-api-endpoint-for-a-key-set-rotation)

## Plugin Configuration

Configure the plugin for a service:

```bash
$ curl -X POST http://<kong>:8001/service/{service}/plugins \
       --data "name=jwt-signer"
```

## Plugin Configuration Parameters

All the parameters are optional, but you need to specify some options to actually make it work.

For example signature verification cannot be done without plugin knowing about:
`config.access_token_jwks_uri` and/or `config.channel_token_jwks_uri`.

Also for introspection to work, you need to specify introspection endpoints:
`config.access_token_introspection_endpoint` and/or `config.channel_token_introspection_endpoint`.


### Description of Plugin Configuration Parameters

#### `config.realm`

When authentication or authorization fails, or there is an unexpected error, the plugin will
send `WWW-Authenticate` header with `realm` attribute value of this configuration parameter.


#### `config.enable_instrumentation`

When you are experiencing problems in production and don't want to change logging level
on Kong nodes, which requires a reload, you can use this parameter to enable instrumentation
for the request. It will write log entries with some added information using `ngx.CRIT`
(CRITICAL) level.

 
#### `config.access_token_issuer`

`iss` claim of (re-)signed access token is set to this value. Original `iss` claim of the
incoming token (possibly introspected) will be stored in `original_iss` claim of the newly
signed access token.


#### `config.access_token_keyset`

This configuration parameter is used to select the private key for access token signing.


#### `config.access_token_jwks_uri`

If you want to use `config.verify_access_token_signature`, you must specify URI where the
plugin can fetch the public keys (JWKS) to verify the signature of the access token. If you
don't specify one, and you pass JWT token to plugin, then the plugin will respond with
`401 Unauthorized`.


#### `config.access_token_request_header`

This parameter tells the name of the header where to look at the access token. By default
we search it from `Authorization: Bearer <token>` header (the value being magic key
`authorization:bearer`). If you don't want to do anything with `access token` then you can
set this to `null` or `""` (empty string). Any header can be used to pass the access token
to this plugin. Two predefined values are `authorization:bearer` and `authorization:basic`. 


#### `config.access_token_leeway`

You can use this parameter to adjust clock skew between the token issuer and Kong. The value
will be added to token's `exp` claim before checking token expiry against Kong servers current
time (in seconds). You can disable access token `expiry` verification altogether with
`config.verify_access_token_expiry`.


#### `config.access_token_scopes_required`

With this parameter you can specify the required values (or scopes) that are looked from a
claim specified by `config.access_token_scopes_claim`. E.g. `[ "employee demo-service", "superadmin" ]`
which can be given as `"employee demo-service,superadmin"` (form post) would mean that claim
need to have values `"employee"` and `"demo-service"` **OR** that the claim need to have value
of `"superadmin"` to be successfully authorized for the upstream access. If required scopes are
not found in access token, the plugin will respond with `403 Forbidden`.

 
#### `config.access_token_scopes_claim`

With this parameter you can specify the claim in access token to be verified against values of
`config.access_token_scopes_required`. This supports nested claims, e.g. with Keycloak you could
use `[ "realm_access", "roles" ]` which can be given as `realm_access,roles` (form post). If the
claim is not found in access token, and you have specified `config.access_token_scopes_required`,
the plugin will respond with `403 Forbidden`.


#### `config.access_token_consumer_claim`

When you set a value for this parameter, the plugin will try to map an arbitrary claim specified with
this configuration parameter (e.g. `sub` or `username`) in access token to Kong consumer entity. Kong
consumers have an `id`, a `username` and a `custom_id`. The `config.access_token_consumer_by` parameter
is used to tell the plugin what of these Kong consumer properties can be used for mapping. If this
parameter is enable but the mapping fails (e.g. in-existent Kong consumer), the plugin will respond
with `403 Forbidden`. Kong consumer mapping is useful when you want to communicate this information
to other plugins such as ACL (access control through blacklisting and whitelisting) or rate-limiting.
The plugin will also set a couple of standard Kong upstream consumer headers.


#### `config.access_token_consumer_by`

When the plugin tries to do access token to Kong consumer mapping, it tries to find a matching Kong
consumer from properties defined using this configuration parameter. The parameter can take an array of
values. Valid values are `id`, `username` and `custom_id`.


#### `config.access_token_upstream_header`

This plugin removes the `config.access_token_request_header` from the request after reading its
value. With `config.access_token_upstream_header` you can specify the upstream header where the
plugin will add the Kong signed token. If you don't specify value for this (e.g. use `null` or
`""` (empty string), the plugin will not even try to (re-)sign the token. 


#### `config.access_token_upstream_leeway`

If you want to add or perhaps subtract (using negative value) expiry time of the original access
token, you can specify value that is added to original access token's `exp` claim.


#### `config.access_token_introspection_endpoint`

When using `opaque` access tokens, and you want to turn on access token introspection, you need
to specify the OAuth 2.0 introspection endpoint uri with this configuration parameter. Otherwise
the plugin will not try introspection, and will instead give `401 Unauthorized` when using opaque
access tokens. 


#### `config.access_token_introspection_authorization`

If the introspection endpoint requires client authentication (client being this plugin), you can
specify the `Authorization` header's value with this configuration parameter. E.g. if you use
client credentials you should enter value of `"Basic base64encode('client_id:client_secret')"`
to this configuration parameter (you are responsible to give full string of the header and do
all the necessary encodings (e.g. base64) that is required on given endpoint.


#### `config.access_token_introspection_body_args`

If you need to pass additional body arguments to introspection endpoint when the plugin introspects
the opaque access token, you can use this config parameter to specify them. You should url encode
the value, e.g. `resource=` or `a=1&b=&c`.


#### `config.access_token_introspection_hint`

If you need to give `hint` parameter when introspecting access token you can use this parameter to
specify the value of such parameter. By default we send `hint=access_token`.  


#### `config.access_token_introspection_jwt_claim`

If your introspection endpoint return an access token in one of the keys (or claims) in the
introspection results (`JSON`), we can use that value instead of the introspection results when
doing expiry verification and signing of the new token issued by Kong. E.g. if you specify
`[ "token_string" ]` which can be given as `"token_string"` (form post) to this configuration
parameter, the plugin will look for key `token_string` in JSON of the introspection results
and use that as an access token (instead of using introspection JSON directly). If the key
cannot be found it, the plugin will respond with `401 Unauthorized`. Also if the key is found,
but cannot be decoded as JWT, it will also result `401 Unauthorized`.


#### `config.access_token_introspection_scopes_required`

With this parameter you can specify the required values (or scopes) that are looked from an
introspection claim/property specified by `config.access_token_introspection_scopes_claim`.
E.g. `[ "employee demo-service", "superadmin" ]` which can be given as `"employee demo-service,superadmin"`
(form post) would mean that claim need to have values `"employee"` and `"demo-service"` **OR**
that the claim need to have value of `"superadmin"` to be successfully authorized for the upstream
access. If required scopes are not found in access token introspection results (`JSON`),
the plugin will respond with `403 Forbidden`.


#### `config.access_token_introspection_scopes_claim`

With this parameter you can specify the claim/property in access token introspection results
(`JSON`) to be verified against values of `config.access_token_introspection_scopes_required`.
This supports nested claims, e.g. with Keycloak you could use `[ "realm_access", "roles" ]`
which can be given as `realm_access,roles` (form post). If the claim is not found in access
token introspection results, and you have specified `config.access_token_introspection_scopes_required`,
the plugin will respond with `403 Forbidden`.  


#### `config.access_token_introspection_consumer_claim`

When you set a value for this parameter, the plugin will try to map an arbitrary claim specified with
this configuration parameter (e.g. `sub` or `username`) in access token introspection results to
Kong consumer entity. Kong consumers have an `id`, a `username` and a `custom_id`. The
`config.access_token_introspection_consumer_by` parameter is used to tell the plugin what of these
Kong consumer properties can be used for mapping. If this parameter is enable but the mapping fails
(e.g. in-existent Kong consumer), the plugin will respond with `403 Forbidden`. Kong consumer mapping
is useful when you want to communicate this information to other plugins such as ACL (access control
through blacklisting and whitelisting) or rate-limiting. The plugin will also set a couple of standard
Kong upstream consumer headers.


#### `config.access_token_introspection_consumer_by`

When the plugin tries to do access token introspection results to Kong consumer mapping, it tries to
find a matching Kong consumer from properties defined using this configuration parameter. The parameter
can take an array of values. Valid values are `id`, `username` and `custom_id`.


#### `config.access_token_introspection_leeway`

You can use this parameter to adjust clock skew between the token issuer introspection results
and Kong. The value will be added to introspection results (`JSON`) `exp` claim/property before
checking token expiry against Kong servers current time (in seconds). You can disable access
token introspection `expiry` verification altogether with `config.verify_access_token_introspection_expiry`.


#### `config.access_token_introspection_timeout`

Timeout for introspection request. This plugin will try to introspect twice if the first request
fails for some reason. If both requests timeout, then the plugin will run two times the
`config.access_token_introspection_timeout` on access token introspection.


#### `config.access_token_signing_algorithm`

When this plugin sets the upstream header, as specified with `config.access_token_upstream_header`,
it will also (re-)sign the original access token using private keys of this plugin. With this
configuration parameter you can specify the algorithm that is used to sign the token. Currently
supported values are `"RS256"` and `"RS512"` (rest will be added later). `config.access_token_issuer`
specifies which `keyset` will be used to sign the new token issued by Kong, using the algorithm
specified with this configuration parameter.


#### `config.access_token_optional`

In case when access token is not provided or no `config.access_token_request_header` is specified,
the plugin cannot obviously verify the access token. In that case the plugin normally responds
with `401 Unauthorized` (client didn't send a token) or `500 Unexpected` (a configuration error).
With this parameter you can let the request to proceed even when there is no token to be checked.
If the token is provided, then this parameter has no effect (look other parameters to enable and
disable checks in that case). 


#### `config.verify_access_token_signature`

With this configuration parameter you can quickly turn on/off the access token
signature verification.


#### `config.verify_access_token_expiry`

With this configuration parameter you can quickly turn on/off the access token
expiry verification.


#### `config.verify_access_token_scopes`

With this configuration parameter you can quickly turn on/off the access token
required scopes verification, specified with `config.access_token_scopes_required`.


#### `config.verify_access_token_introspection_expiry`

With this configuration parameter you can quickly turn on/off the access token
introspection expiry verification.


#### `config.verify_access_token_introspection_scopes`

With this configuration parameter you can quickly turn on/off the access token
introspection scopes verification, specified with
`config.access_token_introspection_scopes_required`.


#### `config.cache_access_token_introspection`

Whether or not to cache access token introspection results.


#### `config.trust_access_token_introspection`

When you provide a opaque access token that the plugin introspects, and you do expiry
and scopes verification on introspection results, you probably don't want to do another
round of checks on the payload before the plugin signs a new token. Or that you don't
want to do checks to a JWT token provided with introspection JSON specified with
`config.access_token_introspection_jwt_claim`. With this parameter you can enable /
disable further checks on payload before the new token is signed. If you set this
to `true` the expiry or scopes are not checked on payload.

#### `config.enable_access_token_introspection`

If you don't want to support opaque access tokens, you can disable introspection by
changing this configuration parameter to `false`.


#### `config.channel_token_issuer`

`iss` claim of (re-)signed channel token is set to this value. Original `iss` claim of
the incoming token (possibly introspected) will be stored in `original_iss` claim of
the newly signed channel token.


#### `config.channel_token_keyset`

This configuration parameter is used to select the private key for channel token signing.


#### `config.channel_token_jwks_uri`

If you want to use `config.verify_channel_token_signature`, you must specify URI where
the plugin can fetch the public keys (JWKS) to verify the signature of the channel token.
If you don't specify one, and you pass JWT token to plugin, then the plugin will respond
with `401 Unauthorized`.


#### `config.channel_token_request_header`

This parameter tells the name of the header where to look at the channel token. By default
we won't look for channel token. If you don't want to do anything with channel token then
you can set this to `null` or `""` (empty string). Any header can be used to pass the channel
token to this plugin. Two predefined values are `authorization:bearer` and `authorization:basic`.


#### `config.channel_token_leeway`

You can use this parameter to adjust clock skew between the token issuer and Kong. The value
will be added to token's `exp` claim before checking token expiry against Kong servers current
time (in seconds). You can disable channel token `expiry` verification altogether with
`config.verify_channel_token_expiry`.


#### `config.channel_token_scopes_required`

With this parameter you can specify the required values (or scopes) that are looked from a claim
specified by `config.channel_token_scopes_claim`. E.g. `[ "employee demo-service", "superadmin" ]`
which can be given as `"employee demo-service,superadmin"` (form post) would mean that claim need
to have values `"employee"` and `"demo-service"` **OR** that the claim need to have value of
`"superadmin"` to be successfully authorized for the upstream access. If required scopes are not
found in channel token, the plugin will respond with `403 Forbidden`.


#### `config.channel_token_scopes_claim`

With this parameter you can specify the claim in channel token to be verified against values of
`config.channel_token_scopes_required`. This supports nested claims, e.g. with Keycloak you could
use `[ "realm_access", "roles" ]` which can be given as `realm_access,roles` (form post).
If the claim is not found in channel token, and you have specified `config.channel_token_scopes_required`,
the plugin will respond with `403 Forbidden`.


#### `config.channel_token_consumer_claim`
 
When you set a value for this parameter, the plugin will try to map an arbitrary claim specified with
this configuration parameter (e.g. `sub` or `username`) in channel token to Kong consumer entity. Kong
consumers have an `id`, a `username` and a `custom_id`. The `config.channel_token_consumer_by` parameter
is used to tell the plugin what of these Kong consumer properties can be used for mapping. If this
parameter is enable but the mapping fails (e.g. in-existent Kong consumer), the plugin will respond
with `403 Forbidden`. Kong consumer mapping is useful when you want to communicate this information
to other plugins such as ACL (access control through blacklisting and whitelisting) or rate-limiting.
The plugin will also set a couple of standard Kong upstream consumer headers.
 

#### `config.channel_token_consumer_by`

When the plugin tries to do channel token to Kong consumer mapping, it tries to find a matching Kong
consumer from properties defined using this configuration parameter. The parameter can take an array of
values. Valid values are `id`, `username` and `custom_id`.


#### `config.channel_token_upstream_header`

This plugin removes the `config.channel_token_request_header` from the request after reading its value.
With `config.channel_token_upstream_header` you can specify the upstream header where the plugin will
add the Kong signed token. If you don't specify value for this (e.g. use `null` or `""` (empty string),
the plugin will not even try to (re-)sign the token.


#### `config.channel_token_upstream_leeway`

If you want to add or perhaps subtract (using negative value) expiry time of the original channel token,
you can specify value that is added to original channel token's `exp` claim.


#### `config.channel_token_introspection_endpoint`

When using `opaque` channel tokens, and you want to turn on channel token introspection, you need to
specify the OAuth 2.0 introspection endpoint uri with this configuration parameter. Otherwise the plugin
will not try introspection, and will instead give `401 Unauthorized` when using opaque channel tokens.


#### `config.channel_token_introspection_authorization`

If the introspection endpoint requires client authentication (client being this plugin), you can specify
the `Authorization` header's value with this configuration parameter. E.g. if you use client credentials
you should enter value of `"Basic base64encode('client_id:client_secret')"` to this configuration parameter
(you are responsible to give full string of the header and do all the necessary encodings (e.g. base64)
that is required on given endpoint.


#### `config.channel_token_introspection_body_args`

If you need to pass additional body arguments to introspection endpoint when the plugin introspects the
opaque channel token, you can use this config parameter to specify them. You should url encode the value,
e.g. `resource=` or `a=1&b=&c`.


#### `config.channel_token_introspection_hint`

If you need to give `hint` parameter when introspecting channel token you can use this parameter to
specify the value of such parameter. By default we don't send a `hint` with channel token introspection.


#### `config.channel_token_introspection_jwt_claim`

If your introspection endpoint return an channel token in one of the keys (or claims) in the introspection
results (`JSON`), we can use that value instead of the introspection results when doing expiry verification
and signing of the new token issued by Kong. E.g. if you specify `[ "token_string" ]` which can be given as
`"token_string"` (form post) to this configuration parameter, the plugin will look for key `token_string`
in JSON of the introspection results and use that as a channel token (instead of using introspection JSON
directly). If the key cannot be found it, the plugin will respond with `401 Unauthorized`. Also if the key
is found, but cannot be decoded as JWT, it will also result `401 Unauthorized`.


#### `config.channel_token_introspection_scopes_required`

With this parameter you can specify the required values (or scopes) that are looked from an introspection
claim/property specified by `config.channel_token_introspection_scopes_claim`.
E.g. `[ "employee demo-service", "superadmin" ]` which can be given as `"employee demo-service,superadmin"`
(form post) would mean that claim need to have values `"employee"` and `"demo-service"` **OR** that the
claim need to have value of `"superadmin"` to be successfully authorized for the upstream access.
If required scopes are not found in channel token introspection results (`JSON`), the plugin will
respond with `403 Forbidden`.


#### `config.channel_token_introspection_scopes_claim`

With this parameter you can specify the claim/property in channel token introspection results (`JSON`)
to be verified against values of `config.channel_token_introspection_scopes_required`. This supports
nested claims, e.g. with Keycloak you could use `[ "realm_access", "roles" ]` which can be given as
`realm_access,roles` (form post). If the claim is not found in channel token introspection results,
and you have specified `config.channel_token_introspection_scopes_required`, the plugin will respond
with `403 Forbidden`.


#### `config.channel_token_introspection_consumer_claim`

When you set a value for this parameter, the plugin will try to map an arbitrary claim specified with
this configuration parameter (e.g. `sub` or `username`) in channel token introspection results to
Kong consumer entity. Kong consumers have an `id`, a `username` and a `custom_id`. The
`config.channel_token_introspection_consumer_by` parameter is used to tell the plugin what of these
Kong consumer properties can be used for mapping. If this parameter is enable but the mapping fails
(e.g. in-existent Kong consumer), the plugin will respond with `403 Forbidden`. Kong consumer mapping
is useful when you want to communicate this information to other plugins such as ACL (access control
through blacklisting and whitelisting) or rate-limiting. The plugin will also set a couple of standard
Kong upstream consumer headers.


#### `config.channel_token_introspection_consumer_by`

When the plugin tries to do channel token introspection results to Kong consumer mapping, it tries to
find a matching Kong consumer from properties defined using this configuration parameter. The parameter
can take an array of values. Valid values are `id`, `username` and `custom_id`.


#### `config.channel_token_introspection_leeway`

You can use this parameter to adjust clock skew between the token issuer introspection results and Kong.
The value will be added to introspection results (`JSON`) `exp` claim/property before checking token expiry
against Kong servers current time (in seconds). You can disable channel token introspection `expiry`
verification altogether with `config.verify_channel_token_introspection_expiry`.


#### `config.access_token_introspection_timeout`

Timeout for introspection request. This plugin will try to introspect twice if the first request
fails for some reason. If both requests timeout, then the plugin will run two times the
`config.access_token_introspection_timeout` on channel token introspection.


#### `config.channel_token_signing_algorithm`

When this plugin sets the upstream header, as specified with `config.channel_token_upstream_header`,
it will also (re-)sign the original channel token using private keys of this plugin. With this configuration
parameter you can specify the algorithm that is used to sign the token. Currently supported values are
`"RS256"` and `"RS512"` (rest will be added later). `config.channel_token_issuer` specifies which `keyset`
will be used to sign the new token issued by Kong, using the algorithm specified with this configuration
parameter.


#### `config.channel_token_optional`

In case when channel token is not provided or no `config.channel_token_request_header` is specified,
the plugin cannot obviously verify the channel token. In that case the plugin normally responds
with `401 Unauthorized` (client didn't send a token) or `500 Unexpected` (a configuration error).
With this parameter you can let the request to proceed even when there is no token to be checked.
If the token is provided, then this parameter has no effect (look other parameters to enable and
disable checks in that case).


#### `config.verify_channel_token_signature`

With this configuration parameter you can quickly turn on/off the channel token signature verification.


#### `config.verify_channel_token_expiry`

With this configuration parameter you can quickly turn on/off the channel token expiry verification.


#### `config.verify_channel_token_scopes`

With this configuration parameter you can quickly turn on/off the channel token required scopes
verification, specified with `config.channel_token_scopes_required`.


#### `config.verify_channel_token_introspection_expiry`

With this configuration parameter you can quickly turn on/off the channel token introspection expiry
verification.


#### `config.verify_channel_token_introspection_scopes`

With this configuration parameter you can quickly turn on/off the channel token introspection scopes
verification, specified with `config.channel_token_introspection_scopes_required`.


#### `config.cache_channel_token_introspection`

Whether or not to cache channel token introspection results.


#### `config.trust_channel_token_introspection`

When you provide a opaque channel token that the plugin introspects, and you do expiry
and scopes verification on introspection results, you probably don't want to do another
round of checks on the payload before the plugin signs a new token. Or that you don't
want to do checks to a JWT token provided with introspection JSON specified with
`config.channel_token_introspection_jwt_claim`. With this parameter you can enable /
disable further checks on payload before the new token is signed. If you set this
to `true` the expiry or scopes are not checked on payload.


#### `config.enable_channel_token_introspection`

If you don't want to support opaque channel tokens, you can disable introspection by
changing this configuration parameter to `false`.


### Default Plugin Configuration Values 

Parameter                                            | Default
-----------------------------------------------------|--------
`config.realm`                                       | value of `ngx.var.host` 
`config.access_token_issuer`                         | `"kong"`
`config.access_token_keyset`                         | `"kong"`
`config.access_token_jwks_uri`                       |
`config.access_token_leeway`                         | `0`
`config.access_token_scopes_required`                | 
`config.access_token_scopes_claim`                   | `[ "scope" ]`
`config.access_token_consumer_claim`                 |
`config.access_token_consumer_by`                    | `[ "username", "custom_id" ]`
`config.access_token_upstream_header`                | `"authorization:bearer"` 
`config.access_token_upstream_leeway`                | `0`
`config.access_token_introspection_endpoint`         | 
`config.access_token_introspection_authorization`    |  
`config.access_token_introspection_body_args`        |
`config.access_token_introspection_hint`             | `"access_token"`  
`config.access_token_introspection_jwt_claim`        |
`config.access_token_introspection_scopes_required`  |
`config.access_token_introspection_scopes_claim`     | `[ "scope" ]`
`config.access_token_introspection_consumer_claim`   |
`config.access_token_introspection_consumer_by`      | `[ "username", "custom_id" ]`
`config.access_token_introspection_leeway`           | `0`
`config.access_token_signing_algorithm`              | `"RS256"`
`config.access_token_optional`                       | `false`
`config.verify_access_token_signature`               | `true`
`config.verify_access_token_expiry`                  | `true`
`config.verify_access_token_scopes`                  | `true`
`config.verify_access_token_introspection_expiry`    | `true`
`config.verify_access_token_introspection_scopes`    | `true`
`config.cache_access_token_introspection`            | `true`
`config.trust_access_token_introspection`            | `true`
`config.enable_access_token_introspection`           | `true`
`config.channel_token_issuer`                        | `"kong"`
`config.channel_token_keyset`                        | `"kong"`
`config.channel_token_jwks_uri`                      |
`config.channel_token_request_header`                |
`config.channel_token_leeway`                        | `0`
`config.channel_token_scopes_required`               |
`config.channel_token_scopes_claim`                  | `[ "scope" ]`
`config.channel_token_consumer_claim`                |
`config.channel_token_consumer_by`                   | `[ "username", "custom_id" ]`
`config.channel_token_upstream_header`               |
`config.channel_token_upstream_leeway`               | `0`
`config.channel_token_introspection_endpoint`        |
`config.channel_token_introspection_authorization`   |
`config.channel_token_introspection_body_args`       |
`config.channel_token_introspection_hint`            |
`config.channel_token_introspection_jwt_claim`       |
`config.channel_token_introspection_scopes_required` |
`config.channel_token_introspection_scopes_claim`    | `[ "scope" ]`
`config.channel_token_introspection_consumer_claim`  |
`config.channel_token_introspection_consumer_by`     | `[ "username", "custom_id" ]`
`config.channel_token_introspection_leeway`          | `0`
`config.channel_token_signing_algorithm`             | `"RS256"`
`config.channel_token_optional`                      | `false`
`config.verify_channel_token_signature`              | `true`
`config.verify_channel_token_expiry`                 | `true`
`config.verify_channel_token_scopes`                 | `true`
`config.verify_channel_token_introspection_expiry`   | `true`
`config.verify_channel_token_introspection_scopes`   | `true`
`config.cache_channel_token_introspection`           | `true`
`config.trust_channel_token_introspection`           | `true`
`config.enable_channel_token_introspection`          | `true`


## Note About Signing Key Management

If you specify `config.access_token_keyset` or `config.channel_token_keyset` with either
`http://` or `https://` prefix, it will mean that token signing keys are externally managed (by you),
and in that case the plugin will load the keys just like it does for `config.access_token_jwks_uri`
and `config.channel_token_jwks_uri`. If the prefix is not `http://` or `https://`
(e.g. `"my-company"` or `"kong"`), Kong will auto-generate JWKS for supported algorithms.

Please note that external JWKS specified with `config.access_token_keyset` or
`config.channel_token_keyset` should also contain private keys with supported `alg`,
either `"RS256"` or `"RS512"` for now. External URLs that contain private keys should
be protected so that only Kong can access them. ATM Kong doesn't add any authentication
headers when it loads the keys from external endpoint, so you have to do it with network
level restrictions. If it is a common need to manage private keys externally
(instead of letting Kong to auto-generate them), we can add another parameter
for adding authentication header (possibly similar to
`config.channel_token_introspection_authorization`).

The key size (the modulo) for RSA keys is currently hard-coded to 2048 bits.


## Note About Consumer Mapping

There are several parameters that provide a way to do consumer mapping:

- `config.access_token_consumer_claim`
- `config.access_token_introspection_consumer_claim`
- `config.channel_token_consumer_claim`
- `config.channel_token_introspection_consumer_claim`

Obviously you cannot map more than once. The order the plugin does the mapping is:

1. access token introspection results
2. access token jwt payload
3. access token introspection results
4. access token jwt payload

of course, depending on input (opaque or JWT).

When mapping is done, no other mappings are used. E.g. if access token already maps to Kong consumer,
the plugin will not try to map channel token to consumer anymore (and will not even error on that case).

General rule to follow would be to only map either access or channel token.


## Kong Admin API Endpoints

This plugin also providers a few Admin API endpoints, and some actions upon them.


### Cached JWKS Admin API Endpoint

The plugin will cache JWKS specified with `config.access_token_jwks_uri` and 
`config.channel_token_jwks_uri` to Kong database for quicker access to them. The plugin
further caches JWKS in Kong node's shared memory, and on process a level memory for 
even quicker access. When the plugin is responsible for signing the tokens, it will
also store its own keys in the database.

Admin API endpoints will never reveal private
keys, but it will reveal the public keys. Private keys, that the plugin will auto-generate,
can only be accessed from database directly (at least for now). Private parts in JWKS include
properties such as `d`, `p`, `q`, `dp`, `dq`, `qi`, and `oth`. For public keys that are using
a symmetric algorithm (such as `HS256`) and include `k` parameter, that is not hidden from
admin api as that is practically used both to verify and to sign. This makes it a bit problematic
to use, and we strongly suggest using asymmetric (or public key) algorithms, it will also make
rotating the keys easier as the public keys can be shared between parties and published (without
revealing the secrets).

All the public keys that Kong has loaded or generated can be viewed by accessing:

```http
GET kong:8001/jwt-signer/jwks
```

E.g.

```bash
$ curl -X GET http://<kong>:8001/jwt-signer/jwks
```
```json
{
    "data": [
        {
            "created_at": 1535560520731,
            "id": "c1d2d9b7-ac3a-4ca4-b595-453acd78925e",
            "keys": [
                {
                    "alg": "RS256",
                    "e": "AQAB",
                    "kid": "aXKFjIY80eM_H4rqhT6iaOfdL5iDHDHjag2BWLaxeJA",
                    "kty": "RSA",
                    "n": "qDjxLGSa4jI14ctmvjMDQzZDfZJcXS6G6-wcVxLsQgrIWc_JnZ44b1ApAokFwaZsig4oNFLQYAMdapZSORI2jNlZ9lsJ-b3VZUz0gB5jGaFAyx7G1Uh46w_-2JZKI4wW8KinJ8VZayobSYS3eg6p3f34t2mDv36Uwa4B8DZKo8cE0JE8T2ne2lyS18W9bJkpfIoctcDjzsvFTg4NbEF3Y61q5v_6icxyJkB9JtS2JE1RjJxmBDOb_ETCLyIiN0Wlb9OdLX_HSdY3DRfnYNl3XAaPdqr8QifqidfdWI4YnJiJ3mYAgI-E37waZ0-1-Ykt-mpvUX1l_UvAdxqetGuC5Q",
                    "use": "sig"
                },
                {
                    "alg": "RS512",
                    "e": "AQAB",
                    "kid": "xb_lFJbpaVuo7cWO7XADl0PsL4G97VFpFg3hIgRiJHQ",
                    "kty": "RSA",
                    "n": "vLY2u2q1gmzysPCbjq7mSDwh2oeRLZ3A047gn0-JsNWF2BZrgMUlB5cnKHOUPAD2ugHjUAOVMy_1d6FO2VBxV6i66KgWM_CMu0sqpmM-n7iUq8TCbpOX5mWczt3GutXPw960--LGyFTuuy2xi1wVYW1WbDIvb4oLo9b0G1eJIjvtSjmQ8tiBkiIxnRGKKxeZl0oTX99v6Z9X1aXoQ11y46l4_IGsN1b8ZWfBJ7Glyi80trWIs6z-EmZED6gdRushRT98GHofqTPRaaOnOJ1itHECj6U82ec6UU-IBtryGqUn_PQ9fUpI1Ru-0jGEcMY3aBZdZ4Uy_189ELK4jqn28w",
                    "use": "sig"
                }
            ],
            "name": "kong",
            "previous": [],
            "updated_at": 1535560520731
        },
        {
            "created_at": 1535560520379,
            "id": "d9d5b731-55fe-4cad-829f-6aba4b2d8823",
            "keys": [
                {
                    "alg": "RS256",
                    "e": "AQAB",
                    "kid": "b863b534069bfc0207197bcf831320d1cdc2cee2",
                    "kty": "RSA",
                    "n": "8h6tCwOYDPtzyFivNaIguQVc_yBO5eOA2kUu_MAN8s4VWn8tIfCbVvcAz3yNwQuGpkdNg8gTk9QmReXl4SE8m7aCa0iRcBBWLyPUt6TM1RkYE51rOGYhjWxo9V8ogMXSBclE6x0t8qFY00l5O34gjYzXtyvyBX7Sw5mGuNLVAzq2nsCTnIsHrIaBy70IKU3FLsJ_PRYyViXP1nfo9872q3mtn7bJ7_hqss0vDgUiNAqPztVIsrZinFbaTgXjLhBlUjFWgJx_g4p76CJkjQ3-puZRU5A0D04KvqQ_0AWcN1Q8pvwQ9V4uGHm6Bop9nUhIcZJYjjlTM9Pkx_JnVOfekw",
                    "use": "sig"
                },
                {
                    "alg": "RS256",
                    "e": "AQAB",
                    "kid": "55b854edf35f093b4708f72dec4f15149836e8ac",
                    "kty": "RSA",
                    "n": "xul55cFjIY7QFMhl79y_3MWK4rHDRqTu-C2VxaPqxbLUSW-LJp8hotDeIOdMEawi2WFNUUCrOpSl33CtX3oFeq7ytLS6y5aosoQMLlguGHnU7FBNvw9kNtR41ykvLphU5YGJVr_JVFAqJPcpB9cEo6f6Mo9i8_gfsXMhkyrm5eqXDFlgDfgfJ_oaMyfkBmhLO2sjgdLguy_x6jg1Ys3WK2DfsI0q7X_esbEStEiV9M9lHOYsmdikKO-CPK6_c5zzJgiIjoND47WEtWuuOp_izV6BeojK9JFPHxcOnX71__sTWYl2iv7cZUNQQeH3Kub6gfpfVjCExy_5qKvtdMnzrw",
                    "use": "sig"
                },
                {
                    "alg": "RS256",
                    "e": "AQAB",
                    "kid": "ba4aeae8b208ad9ae12b6610865f63961287b6d6",
                    "kty": "RSA",
                    "n": "1f7xnpGKS5pq7l2nE0iLQ1SYX3MVeOxFDdqzTLOzU_JCNrl_w0a3f1Ry0nRPGMjONaBodUAKKgVbTKT3v88Y8-8l4BAk7lnw0fjw404MfDCt2lHaLVY_WjCHfltsUbCklta_eSN92bYQX81wmlGhwWW5kAyagTkpsPGb04zZLWTPR5fYffdYfRY1r65VmzrZaniEq4HQUr49swKmH5yyqF_HrtkpXXAcqmPlsoh1rwm1G1fsDTiNgwhJD54oZ1z5h-_8S4a0XV5cfrAQw6zzRw2Yfe6_FSXVJdJjZ_qZmY_Eqay3Wv-FDr0mZGZg6RmTtDt5208lwUcB4j49kczUhw",
                    "use": "sig"
                }
            ],
            "name": "https://www.googleapis.com/oauth2/v3/certs",
            "previous": [],
            "updated_at": 1535560520379
        }
    ],
    "total": 2
}
```
 
### Cached JWKS Admin API Endpoint for a Key Set

A particular keyset can be accessed in another endpoint:

```http
GET kong:8001/jwt-signer/jwks/<name-or-id>
```

E.g.

```bash
$ curl -X GET http://<kong>:8001/jwt-signer/jwks/kong
```
```json
{
    "keys": [
        {
            "alg": "RS256",
            "e": "AQAB",
            "kid": "v6el8V8dbrKY5w2PInkM468aSuODrKcfbt-44xdDIjk",
            "kty": "RSA",
            "n": "uJzCU_TangWMFk25_JggtkVNjtFfaaz3jERYEYrsb92KFK4FpjfenYYeo8XCGLphn-NcYJroHy3aVznTvU3O8B-5z27uFgXUzk_m-fJ5C4cyqBaJS_myuMOnx0SBl-V6rIGmbdAd0rxsR9SK4JXaZ7xPnQKl8Z6N_Be2iWzf8RUzgM51x7RLQWr55DXBz5IS0O3uYi0z2_xaTyhvZ01aGMGO8Jom1QZkSf2SBGVvQiff464wB_R9Uw8bnbDw6SI0A7JbvSTj80dsoB5YJaR6OZ7XzJX53J1-efiEPc-JTXnqsN1xd-7DbrwpGSui7cGU79H7rG2o-DdVtz649JVXHw",
            "use": "sig"
        },
        {
            "alg": "RS512",
            "e": "AQAB",
            "kid": "SBFmMBtMQzjQEYPDQ_7H5emJzfjX4-FBVE22_SRy5oU",
            "kty": "RSA",
            "n": "rPcrSYQKnJNfMd0AF2t8JGSRdSSOeEPwSpPNyq6T13NXWLBDzzmZC8gNURFrsB8hkeY_KUNe3rVZz__6Vp7_h5PxWXKIUFJT18Gl8mSJ_4ohWUFziWdLV1rliZ671Uo5My2_McgRFI2DfHCWCe5XL5ApKPv9YFT684_FfKpnvTIn7_rVoyQYp3g9Ud_7X5hJGEuBa3HKSGPhn-zh1A0kxnLwNrLms4t3bQZMamuR0R3XYXr76OwU0xQMsqy3_DwV1DJ0z9o0gFV8GSkYWYllVNwfGPXiTSUvTKWIARGV60jUaoYB1sG5yXyhgBcWn-XX5wcOG--aGfdWwlnYF7p_ow",
            "use": "sig"
        }
    ],
    "previous": []
}
```

The `http://<kong>:8001/jwt-signer/jwks/kong` being the URL that you can give to your
upstream services for them to verify Kong issued tokens. The response is a standard
JWKS endpoint response. The `kong` suffix in the URI is the one that you can specify
with `config.access_token_issuer` and/or `config.channel_token_issuer`.

You can also make a loop-back to this endpoint by routing Kong proxy to this URL.
Then you can use authentication plugin to protect access to this endpoint,
if that is needed.

You can also `DELETE` a keyset by issuing following:

```http
DELETE kong:8001/jwt-signer/jwks/<name-or-id>
```

E.g.

```bash
$ curl -X DELETE http://<kong>:8001/jwt-signer/jwks/kong
```

The plugin will automatically reload or regenerate missing JWKS if it cannot
find a cached ones. The plugin will also try to reload JWKS if it cannot verify
the signature of original access token and/or channel token, e.g. in case where
the original issuer has rotated its keys and signed with the new one that is not
found in Kong cache.


### Cached JWKS Admin API Endpoint for a Key Set Rotation

Sometime you may want to rotate the keys Kong uses for signing tokens specified with
`config.access_token_keyset` and `config.channel_token_keyset`, or perhaps
reload tokens specified with `config.access_token_jwks_uri` and
`config.channel_token_jwks_uri`. Kong will store and use at maximum two set of keys:
**current** and **previous**. If you want Kong to forget the previous keys, you need to
rotate keys **twice**, as it will effectively store replace both `current` and `previous`
with newly generated tokens OR reloaded tokens (in case the keys are loaded from external
uri).

To rotate keys you can send `POST` request:
```http
POST kong:8001/jwt-signer/jwks/<name-or-id>/rotate
```

E.g.

```bash
$ curl -X POST http://<kong>:8001/jwt-signer/jwks/kong/rotate
```
```json
{
    "keys": [
        {
            "alg": "RS256",
            "e": "AQAB",
            "kid": "WL-MciVclsUiIOo1IFBozrFmCIGHcYieGGny3RiENbU",
            "kty": "RSA",
            "n": "sOIf20LLUMcwaScetGnnljjkla_uZ1xQbWOy5cUjiDqku1MqiRgSvI9lM0A6USa4xtqGEnAhE-wZG7fqdWIUPgm3gZxmB6JjIV3E32PjWUtiVAiJUId3dMaGn4FSzU-TTKFAIB-xfO_0qoccaGfjsh2E5qeBGK1IBznnaw3ShnqdB53kJkSS0xgZ3NyCwh4zfTb0XeJq0l8U9xS3IdaVMj5EBOFvo-DBMneyICgLQaLIEB2KQ64aN2al4sLhKCL_Ui02s1F0igLdUr0nyhe7iFK6YIyhERMviDmv_HW7CfFcNVvB-dbpIfW0Z9SX4CtkpaAHdY4HPZFneJ4VtqYQLQ",
            "use": "sig"
        },
        {
            "alg": "RS512",
            "e": "AQAB",
            "kid": "6EIBzS288AfTm1atFHICYZ4SvWY3X9jnZEYQT3uKfXw",
            "kty": "RSA",
            "n": "zpxT7SlEmnWxquVwELysCCmrAkAvJb8eYHk3DLKEvjDDUVjA8u6KFoCBL6ySRg59kZESZ_30A0Oi1wWO85kUySlL_rtn-1PYPCUX_Yhsdoq0dYmD388l5VxRDdwVQh6c4VnbTZbJGk7RDm-dBe2xNwdfNs_C5f4pf-nGMyk1kqfgVRoYkrXuMAwd4xbeb-gh7ZdBNQO-LkMlLVGKbFe5bsnvG2ht202qx_VdHjN-spxbRUANCDRpPTAM1uEdB15EijZDLnwXZCywUsb0WIKA0bxxEJtH6tO7g8EujYqZB3Z-TaCq-dtq8lKT2FoRNx6-Zc3zVsRHb5RWqV2pgrKWZQ",
            "use": "sig"
        }
    ],
    "previous": [
        {
            "alg": "RS256",
            "e": "AQAB",
            "kid": "v6el8V8dbrKY5w2PInkM468aSuODrKcfbt-44xdDIjk",
            "kty": "RSA",
            "n": "uJzCU_TangWMFk25_JggtkVNjtFfaaz3jERYEYrsb92KFK4FpjfenYYeo8XCGLphn-NcYJroHy3aVznTvU3O8B-5z27uFgXUzk_m-fJ5C4cyqBaJS_myuMOnx0SBl-V6rIGmbdAd0rxsR9SK4JXaZ7xPnQKl8Z6N_Be2iWzf8RUzgM51x7RLQWr55DXBz5IS0O3uYi0z2_xaTyhvZ01aGMGO8Jom1QZkSf2SBGVvQiff464wB_R9Uw8bnbDw6SI0A7JbvSTj80dsoB5YJaR6OZ7XzJX53J1-efiEPc-JTXnqsN1xd-7DbrwpGSui7cGU79H7rG2o-DdVtz649JVXHw",
            "use": "sig"
        },
        {
            "alg": "RS512",
            "e": "AQAB",
            "kid": "SBFmMBtMQzjQEYPDQ_7H5emJzfjX4-FBVE22_SRy5oU",
            "kty": "RSA",
            "n": "rPcrSYQKnJNfMd0AF2t8JGSRdSSOeEPwSpPNyq6T13NXWLBDzzmZC8gNURFrsB8hkeY_KUNe3rVZz__6Vp7_h5PxWXKIUFJT18Gl8mSJ_4ohWUFziWdLV1rliZ671Uo5My2_McgRFI2DfHCWCe5XL5ApKPv9YFT684_FfKpnvTIn7_rVoyQYp3g9Ud_7X5hJGEuBa3HKSGPhn-zh1A0kxnLwNrLms4t3bQZMamuR0R3XYXr76OwU0xQMsqy3_DwV1DJ0z9o0gFV8GSkYWYllVNwfGPXiTSUvTKWIARGV60jUaoYB1sG5yXyhgBcWn-XX5wcOG--aGfdWwlnYF7p_ow",
            "use": "sig"
        }
    ]
}
```
