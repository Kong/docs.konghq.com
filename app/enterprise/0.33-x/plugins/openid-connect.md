---
title: OpenID Connect Plugin
---

# Kong OpenID Connect Plugin

The Kong OpenID Connect plugin provides a general-purpose OpenID Connect and OAuth toolkit.

## Contents

* [Terminology](#terminology)
* [Use Cases](#use-cases)
* [Features](#features)
* [OpenID Connect Plugin](#openid-connect-plugin)
  * [Configuration Parameters](#configuration-parameters)
  * [Authorization](#authorization)
  * [Usage](#usage)
* [Compatibility](#compatibility)

## Terminology

Term           | Description
--------------:|------------
`OP`           | OpenID Connect Provider
`RP`           | OpenID Connect Relying Party
`RS`           | OpenID Connect Resource Server
`JOSE`         | JSON Object Signing and Encryption
`JWA`          | JSON Web Algorithms
`JWT`          | JSON Web Token
`JWS`          | JSON Web Signature
`JWE`          | JSON Web Encryption
`JWK`          | JSON Web Key
`PKCE`         | Proof-Key for Code Exchange

## Use Cases

### Protecting Server to Server API Access

For server-to-server we recommend you to use OAuth 2.0 **client credentials** grant
that is enhanced with OpenID Connect features (such as standardized security
feature, and automatic discovery). Client credentials are easier to revoke than
say password credentials without affecting too many things.

### Protecting Interactive Browser based API / Web Site Access

The best method to use here is to use OpenID Connect Authentication using
*authorization code** flow. Kong sets up a session with the browser. After
initial authentication the browser will send the cookie automatically —
even when making API requests using Javascript. With authorization code
flow you can usually utilize stronger authentication methods such as
two-factor authentication on your identity provider.

### Protecting Access to APIs from 1st Party Client

Here you can use OAuth 2.0 **password grant** that is enhanced with OpenID
Connect features.

### Protecting Access to APIs with Stateless JWT Tokens

When you have JWT (or JWS to be more specific) available for your client,
that is possibly issued directly from the identity provider (e.g. by using
implicit flow), and want you to use that token to access API protected by
Kong, you should use a plugin that provides you OpenID Connect aware
stateless verification.

### Accessing APIs from Basic Authentication Aware Client

Basic authentication is supported in many 3rd party clients. One such client
is Microsoft Excel. The `openid-connect` plugin allows you to supply username
and password or client id and client secret using normal basic authentication
headers.

## Features

### OpenID Connect Discovery

The plugin does support OpenID Connect Discovery as defined in
[the specification](http://openid.net/specs/openid-connect-discovery-1_0.html).

![OpenID Connect Discovery Sequence Diagram](/assets/images/ee/plugins/openid-connect-discovery.png "OpenID Connect Discovery Sequence Diagram")

### JWA Signing Algorithms

Algorithm | Signing | Verification
:--------:|:-------:|:-----------:
`HS256`   | `no`    | `yes`
`HS384`   | `no`    | `yes`
`HS512`   | `no`    | `yes`
`RS256`   | `no`    | `yes`
`RS384`   | `no`    | `no` ¹
`RS512`   | `no`    | `yes`
`ES256`   | `no`    | `yes`
`ES384`   | `no`    | `yes`
`ES512`   | `no`    | `yes`
`PS256`   | `no`    | `yes`
`PS384`   | `no`    | `yes`
`PS512`   | `no`    | `yes`
`none` ²  | `no`    | `no`

¹⁾ there is currently no support for using `SHA384` with RSA signatures,
   since there’s no gain in either computation time nor message size
   compared to using `SHA256` or `SHA512`, respectively.

²⁾ for security purposes we have decided not to support `none`
   signing algorithm at this point. We might add it later, though.

At this point we are mostly focusing on the `RP` side of OpenID
Connect, and that's why we have not bothered with signing algorithms
as none of our plugins do use them. The signature verification support
is rather complete.

### JWT Serialization Formats

This is what the plugins currently support for `JWT` serializations.
The table may change in a future as further features get implemented.

Type    | Compact Serialization | JSON Serialization
:------:|:---------------------:|:-----------------:
`JWS`   | `yes`                 | `no`
`JWE`   | `no`                  | `no`

## OpenID Connect Plugin

The OpenID Connect plugin supports a variety of authentication and authorization methods:

* OAuth 2.0 Password Grant
* OAuth 2.0 Client Credentials Grant
* OpenID Connect 1.0 / OAuth 2.0 Authorization Code Flows
* JWT Bearer Tokens (both signature and claims validations)
* OAuth 2.0 Introspection (verifying opaque tokens)
* Kong OAuth 2.0 Authentication Plugin issued tokens
* Refreshing expired access token with refresh token, if available
* Session authentication with a HTTP Only session cookie sent by this plugin

This plugin **exchanges** credentials and injects **access token** as a **bearer**
token into `Authorization` HTTP header.

### Configuration Parameters

As OpenID Connect can be used in many ways, the plugin has many parameters. Some of the settings
are used only in some flows, and others are used more broadly. Generally speaking, while parameters are optional,
requirements will vary depending on your use case and identity provider.

#### Descriptions

Parameter ¹                          | Description
------------------------------------:|------------
`issuer`                             | The issuer `url` from which OpenID Connect configuration can be discovered.
`client_arg`                         | Allows you to define client argument name used to pick up the right client configuration.
`client_id`                          | The `client_id` of the OpenID Connect client registered in OpenID Connect Provider.
`client_secret`                      | The `client_secret` of the OpenID Connect client registered in OpenID Connect Provider.
`redirect_uri`                       | The `redirect_uri` of the client defined with `client_id` (also used as a redirection uri on authorization code flow).
`login_redirect_uri`                 | If `login_action` is `redirect`, here you can set up the redirection url for that.
`logout_redirect_uri`                | On logout this is the url where the client is redirected after logout is done (used also for `post_logout_redirect_uri`).
`forbidden_redirect_uri`             | Instead of responding with HTTP status code 403, send a 302 redirect with the defined uri.
`unauthorized_redirect_uri`          | Instead of responding with HTTP status code 401, send a 302 redirect with the defined uri.
`unexpected_redirect_uri`            | Instead of responding with HTTP status code 500, send a 302 redirect with the defined uri.
`forbidden_destroy_session`          | Whether or not the session is also destroyed on forbidden.
`scopes`                             | The scopes to be requested from OP.
`scopes_required`                    | The scopes required to be present in access token (or introspection results) for successful authorization.
`response_mode`                      | The response mode used with authorization endpoint (e.g. authorization code flow).
`auth_methods`                       | The supported authentication methods you want to enable.
`audience`                           | The audience passed to authorization endpoint, also used for verification of `aud` claim.
`audience_required`                  | The audience required to be present in access token (or introspection results) for successful authorization.
`domains`                            | The domains to be verified against the `hd` claim.
`max_age`                            | The `max_age` (in seconds) for the previous authentication, specifically the `auth_time` claim.
`authorization_cookie_name`          | The name of authorization code flow cookie that is used for verifying the responses from OpenID Connect provider.
`authorization_cookie_lifetime`      | Authorization cookie lifetime in seconds.
`session_cookie_name`                | The name of session cookie when session authentication is enabled.
`session_cookie_lifetime`            | Session cookie lifetime in seconds.
`session_storage`                    | The storage that is used to store the data part of the session cookie.
`session_memcache_prefix`            | Memcache session key prefix (all session keys will use this prefix).
`session_memcache_socket`            | Memcache `unix` socket path.
`session_memcache_host`              | Memcache `host`.
`session_memcache_port`              | Memcache `port`.
`session_redis_prefix`               | Redis session key prefix (all session keys will use this prefix).
`session_redis_socket`               | Redis `unix` socket path.
`session_redis_host`                 | Redis `host`.
`session_redis_port`                 | Redis `port`.
`session_redis_auth`                 | Redis authentication password.
`extra_jwks_uris`                    | If your IdP uses other JWKS to sign e.g. access tokens that are not found with OpenID Connect discovery, you can define additional uris with this.
`jwt_session_cookie`                 | Name of the cookie that contains a value for a claim defined with `session_claim` (used only for additional JWT verification).
`jwt_session_claim`                  | Name of the claim that is checked against the `session_cookie` (used only for additional JWT verification).
`reverify`                           | When `session` authentication method is used, you can enable re-verification of signatures and claims of the tokens using this parameter.
`bearer_token_param_type`            | The types of delivery mechanisms for the bearer token parameter.
`client_credentials_param_type`      | The types of delivery mechanisms for the client credentials.
`password_param_type`                | The types of delivery mechanisms for the username and password.
`id_token_param_name`                | The name of the payload parameter where the ID token is delivered for verification.
`id_token_param_type`                | The types of delivery mechanisms for the ID token parameter.
`discovery_headers_names`            | Extra header names that you want to include in discovery requests (such as `Authorization`).
`discovery_headers_values`           | Values for the extra headers that you want to include in discovery requests.
`authorization_query_args_names`     | Extra query argument names that you want to include in authorization endpoint query string.
`authorization_query_args_values`    | Values for the extra query arguments that you want to include in authorization endpoint query string.
`authorization_query_args_client`    | These parameters are passed from client request to authorization endpoint (use this for parameters such as `login_hint`).
`token_post_args_names`              | Extra arguments names that you want to include in token endpoint post args.
`token_post_args_values`             | Values for the extra arguments that you want to include in token endpoint post args.
`token_headers_client`               | When Kong calls token endpoint, you can specify the headers that Kong will pass to token endpoint from client request headers.
`token_headers_replay`               | When Kong calls token endpoint, you can specify the headers that you want the Kong to send back to the client.
`token_headers_prefix`               | If you want you can prefix the token endpoint headers with a string to differentiate them from other headers.
`token_headers_grants`               | You can limit the grants for which the token headers are replayed.
`upstream_headers_claims`            | Claims to look from which to create upstream headers.
`upstream_headers_names`             | Upstream headers to create for the matching claims.
`downstream_headers_claims`          | Claims to look from which to create downstream headers.
`downstream_headers_names`           | Downstream headers to create for the matching claims.
`upstream_access_token_header`       | The name of upstream header where the access token is injected.
`downstream_access_token_header`     | The name of downstream header where the access token is injected.
`upstream_access_token_jwk_header`   | The name of upstream header where the JWK used for Access token verification is injected (if any).
`downstream_access_token_jwk_header` | The name of downstream header where the JWK used for Access token verification is injected (if any).
`upstream_id_token_header`           | The name of upstream header where the ID token is injected (if any).
`downstream_id_token_header`         | The name of downstream header where the ID token is injected (if any).
`upstream_id_token_jwk_header`       | The name of upstream header where the JWK used for ID token verification is injected (if any).
`downstream_id_token_jwk_header`     | The name of downstream header where the JWK used for ID token verification is injected (if any).
`upstream_refresh_token_header`      | The name of upstream header where the Refresh token is injected (if any).
`downstream_refresh_token_header`    | The name of downstream header where the Refresh token is injected (if any).
`upstream_user_info_header`          | The name of upstream header where the User Info is injected (if any).
`downstream_user_info_header`        | The name of downstream header where the User Info is injected (if any).
`upstream_introspection_header`      | The name of upstream header where the introspection results are injected (if any).
`downstream_introspection_header`    | The name of downstream header where the introspection results are injected (if any).
`introspect_jwt_tokens`              | Enable this option to also introspect JWT tokens (and not only those opaque ones). Can be used to check revocation of JWT tokens.
`introspection_endpoint`             | The url of introspection endpoint that can be used if the OP doesn't announce a non-standard introspection endpoint in discovery document.
`introspection_hint`                 | Use this parameter if you want to change introspection request `token_type_hint` argument to something else than the default `access_token`.
`introspection_headers_names`        | Extra arguments names that you want to include in introspection requests.
`introspection_headers_values`       | Values for the extra arguments that you want to include in introspection requests.
`login_methods`                      | Other `login_*` parameters depend on this, and they are only used if matching authentication method is used.
`login_action`                       | Controls what to do after successful authentication when using a matching login method defined with `login_methods`.
`login_tokens`                       | If you set `login_action` to `redirect` or `response`, this parameter configures what tokens are returned in url hash (`redirect`) or response body (`response`).
`login_redirect_mode`                | Defines how you want to pass `login_tokens` in case of `login_action` of `redirect`.
`logout_query_arg`                   | A query argument found in request that means that we should do a logout.
`logout_post_arg`                    | A post argument found in request that means that we should do a logout.
`logout_uri_suffix`                  | If request uri ends with specific string, that means that we should do a logout.
`logout_methods`                     | List of HTTP methods that can be used for logout.
`logout_revoke`                      | Revoke tokens from IdP on logout by calling `revocation_endpoint`.
`revocation_endpoint`                | If `revocation_endpoint` is not specified in discovery (as it is not standardized by OpenID Connect), you can specify it manually.
`end_session_endpoint`               | If `end_session_endpoint` is not specified in discovery, you can specify it manually (e.g. you can use your own non-OpenID Connect logout endpoint).
`token_exchange_endpoint`            | Token exchange endpoint, if you want to exchange the access token to a new one before proxying to upstream service.
`consumer_claim`                     | Name of the claim that is used to find a consumer.
`consumer_by`                        | Search consumer by this (or these) fields.
`credential_claim`                   | Name of the claim that is used to set arbitrary credential (can be used with e.g. rate-limiting).
`anonymous`                          | If `consumer_claim` is specified, but consumer is not found, allow fallback to a consumer defined by this property.
`run_on_preflight`                   | A boolean value that indicates whether the plugin should run (and try to authenticate) on `OPTIONS` pre-flight requests, if set to false then `OPTIONS` requests will always be allowed.
`leeway`                             | The leeway (in seconds) that is used to adjust the possible clock skew between the OP and Kong (used in all time related verifications).
`verify_parameters`                  | Enables or disables verification of the plugin parameters against the discovery documentation rules (for debugging).
`verify_nonce`                       | Enables or disables verification of the nonce used in authorization code flow (for debugging).
`verify_signature`                   | Enables or disables verification of the signature (for debugging).
`verify_claims`                      | Enables or disables verification of the standard claims (for debugging).
`cache_ttl`                          | Cache expiry time in seconds.
`cache_introspection`                | Enables of disables caching of introspection request results.
`cache_token_exchange`               | Enables of disables caching of token exchange results.
`cache_tokens`                       | Enables of disables caching of token endpoint request results.
`cache_user_info`                    | Enables of disables caching of user info request results.
`hide_credentials`                   | An optional boolean value telling the plugin to hide the credential to the upstream API server. It will be removed by Kong before proxying the request.
`http_version`                       | The HTTP version to use between Kong and OP.
`ssl_verify`                         | Whether or not should Kong verify SSL Certificates when communicating to OP.
`timeout`                            | The timeout value (in seconds) that is used for the Network IO.

#### Types, Optionality and Defaults

While there are a lot of parameters, most of them are optional
as you can see below.

`—` in default column means that there is no (static) default.

Parameter ¹                          | Type      | Required | Default
------------------------------------:|:---------:|:--------:|------------
`issuer`                             | `url`     | `yes`    | `—`
`client_arg`                         | `string`  | `no`     | `client_id`
`client_id`                          | `array`   | `no`     | `—` (many auth methods need this)
`client_secret`                      | `array`   | `no`     | `—` (many auth methods need this)
`redirect_uri`                       | `array`   | `no`     | `—` (request uri)
`login_redirect_uri`                 | `array`   | `no`     | `—`
`logout_redirect_uri`                | `array`   | `no`     | `—`
`forbidden_redirect_uri`             | `array`   | `no`     | `—`
`unauthorized_redirect_uri`          | `array`   | `no`     | `—`
`unexpected_redirect_uri`            | `array`   | `no`     | `—`
`forbidden_destroy_session`          | `boolean` | `no`     | `true`
`scopes`                             | `array`   | `no`     | `"open_id"`
`scopes_required`                    | `array`   | `no`     | `—`
`response_mode`                      | `string`  | `no`     | `"query"`
`auth_methods`                       | `array`   | `no`     | `"password"`, `"client_credentials"`, `"authorization_code"`, `"bearer"`, `"introspection"`, `"kong_oauth2"`, `"refresh_token"`, `"session"`
`audience`                           | `array`   | `no`     | `—`
`audience_required`                  | `array`   | `no`     | `—`
`domains`                            | `array`   | `no`     | `—`
`max_age`                            | `number`  | `no`     | `—`
`authorization_cookie_name`          | `string`  | `no`     | `"authorization"`
`authorization_cookie_lifetime`      | `number`  | `no`     | `600`
`session_cookie_name`                | `string`  | `no`     | `"session"`
`session_cookie_lifetime`            | `number`  | `no`     | `3600`
`session_storage`                    | `string`  | `no`     | `"cookie"`
`session_memcache_prefix`            | `string`  | `no`     | `"sessions"`
`session_memcache_socket`            | `string`  | `no`     | `—`
`session_memcache_host`              | `string`  | `no`     | `"127.0.0.1"`
`session_memcache_port`              | `number`  | `no`     | `11211`
`session_redis_prefix`               | `string`  | `no`     | `"sessions"`
`session_redis_socket`               | `string`  | `no`     | `—`
`session_redis_host`                 | `string`  | `no`     | `"127.0.0.1"`
`session_redis_port`                 | `number`  | `no`     | `6379`
`session_redis_auth`                 | `string`  | `no`     | `—`
`extra_jwks_uris`                    | `array`   | `no`     | `—`
`jwt_session_cookie`                 | `string`  | `no`     | `—`
`jwt_session_claim`                  | `string`  | `no`     | `"sid"`
`reverify`                           | `boolean` | `no`     | `false`
`bearer_token_param_type`            | `array`   | `no`     | `"query"`, `"header"`, `"body"`
`client_credentials_param_type`      | `array`   | `no`     | `"query"`, `"header"`, `"body"`
`password_param_type`                | `array`   | `no`     | `"query"`, `"header"`, `"body"`
`id_token_param_name`                | `string`  | `no`     | `—`
`id_token_param_type`                | `array`   | `no`     | `"query"`, `"header"`, `"body"`
`discovery_headers_names`            | `array`   | `no`     | `—`
`discovery_headers_values`           | `array`   | `no`     | `—`
`authorization_query_args_names`     | `array`   | `no`     | `—`
`authorization_query_args_values`    | `array`   | `no`     | `—`
`authorization_query_args_client`    | `array`   | `no`     | `—`
`token_post_args_names`              | `array`   | `no`     | `—`
`token_post_args_values`             | `array`   | `no`     | `—`
`token_headers_client`               | `array`   | `no`     | `—`
`token_headers_replay`               | `array`   | `no`     | `—`
`token_headers_prefix`               | `string`  | `no`     | `—`
`token_headers_grants`               | `array`   | `no`     | `—`
`upstream_headers_claims`            | `array`   | `no`     | `—`
`upstream_headers_names`             | `array`   | `no`     | `—`
`downstream_headers_claims`          | `array`   | `no`     | `—`
`downstream_headers_names`           | `array`   | `no`     | `—`
`upstream_access_token_header`       | `string`  | `no`     | `"authorization:bearer"`
`downstream_access_token_header`     | `string`  | `no`     | `—`
`upstream_access_token_jwk_header`   | `string`  | `no`     | `—`
`downstream_access_token_jwk_header` | `string`  | `no`     | `—`
`upstream_id_token_header`           | `string`  | `no`     | `—`
`downstream_id_token_header`         | `string`  | `no`     | `—`
`upstream_id_token_jwk_header`       | `string`  | `no`     | `—`
`downstream_id_token_jwk_header`     | `string`  | `no`     | `—`
`upstream_refresh_token_header`      | `string`  | `no`     | `—`
`downstream_refresh_token_header`    | `string`  | `no`     | `—`
`upstream_user_info_header`          | `string`  | `no`     | `—`
`downstream_user_info_header`        | `string`  | `no`     | `—`
`upstream_introspection_header`      | `string`  | `no`     | `—`
`downstream_introspection_header`    | `string`  | `no`     | `—`
`introspect_jwt_tokens`              | `boolean` | `no`     | `false`
`introspection_endpoint`             | `url`     | `no`     | `—`
`introspection_hint`                 | `string`  | `no`     | `"access_token"`
`introspection_headers_names`        | `array`   | `no`     | `—`
`introspection_headers_values`       | `array`   | `no`     | `—`
`login_methods`                      | `array`   | `no`     | `"authorization_code"`
`login_action`                       | `string`  | `no`     | `"upstream"`
`login_tokens`                       | `array`   | `no`     | `"id_token"`
`login_redirect_mode`                | `string`  | `no`     | `"fragment"`
`logout_query_arg`                   | `string`  | `no`     | `—`
`logout_post_arg`                    | `string`  | `no`     | `—`
`logout_uri_suffix`                  | `string`  | `no`     | `—`
`logout_methods`                     | `array`   | `no`     | `"POST"`, `"DELETE"`
`logout_revoke`                      | `boolean` | `no`     | `false`
`revocation_endpoint`                | `url`     | `no`     | `—` (OpenID Connect Discovery)
`end_session_endpoint`               | `url`     | `no`     | `—` (OpenID Connect Discovery)
`token_exchange_endpoint`            | `url`     | `no`     | `—`
`consumer_claim`                     | `string`  | `no`     | `—`
`consumer_by`                        | `array`   | `no`     | `"username"`, `"custom_id"`
`credential_claim`                   | `array`   | `no`     | `"sub"`
`anonymous`                          | `string`  | `no`     | `—`
`run_on_preflight`                   | `boolean` | `no`     | `true`
`leeway`                             | `number`  | `no`     | `0`
`verify_parameters`                  | `boolean` | `no`     | `true`
`verify_nonce`                       | `boolean` | `no`     | `true`
`verify_signature`                   | `boolean` | `no`     | `true`
`verify_claims`                      | `boolean` | `no`     | `true`
`cache_ttl`                          | `number`  | `no`     | `3600`
`cache_introspection`                | `boolean` | `no`     | `true`
`cache_token_exchange`               | `boolean` | `no`     | `true`
`cache_tokens`                       | `boolean` | `no`     | `true`
`cache_user_info`                    | `boolean` | `no`     | `true`
`hide_credentials`                   | `boolean` | `no`     | `false`
`http_version`                       | `number`  | `no`     | `1.1`
`ssl_verify`                         | `boolean` | `no`     | `true`
`timeout`                            | `number`  | `no`     | `10000`

¹⁾ all the config parameters should be prefixed with `config.`.

#### config.issuer

The OpenID Provider configuration and JWKS are discovered using the
`config.issuer` configuration parameter. Set this to a location where
the plugin will find the `/.well-known/openid-configuration` discovery
endpoint. This parameter accepts only URLs.

Default | Required
:------:|:-------:
`none`  | `yes`

**Examples:**

* `https://accounts.google.com/`
* `https://accounts.google.com/.well-known/openid-configuration`

#### config.client_arg

Sometimes you need to use different client or client parameters,
e.g. when you use this plugin in front of multiple services.

Default     | Required
:----------:|:-------:
`client_id` | `no`

This argument is used to pick up the right configuration to
from following config parameters:

* `config.client_id`
* `config.client_secret`
* `config.redirect_uri`
* `config.login_redirect_uri`
* `config.logout_redirect_uri`
* `config.forbidden_redirect_uri`
* `config.unauthorized_redirect_uri`
* `config.unexpected_redirect_uri`

If you want to override default `client_id` value you can use
this config parameter to define one. Then we look for value
in following order (the default `client_id` is used here as
example):

* header `X-Client-ID` or `Client-ID`
* query argument `client_id`
* post argument `client_id`

If you specify `config.client_arg` with value `client_config` then
the plugin tries to find value from:

* header `X-Client-Config` or `Client-Config`
* query argument `client_config`
* post argument `client_config`

The value stored in the parameter can be `integer` or actual
`client_id` found in `config.client_id`. In case it is an integer,
that is used to pick up correct parameters by index from the following:

* `config.client_id`
* `config.client_secret`
* `config.redirect_uri`
* `config.login_redirect_uri`
* `config.logout_redirect_uri`

Indexing starts from `1`. If no such index is found, then the index of `1`
is used. You can also you the actual `client_id` and then we use the index
of the `config.client_id` to rest of the parameters (and fallback to `1` if
not found in specified index).

#### config.client_id

With this parameter specify the `client_id` of your client
that you have registered in OpenID Connect Provider. This
is the client that authenticates Kong with your OpenID
Provider. It can be considered a trusted client or confidential
client. This parameter can also be an array as this plugin
supports multiple clients. The right one is then picked up
by matching to a request parameter (defined with `config.client_arg`).

Default | Required
:------:|:-------:
`none`  | `no`

**Note:** In many cases you will need to configure this to allow Kong
to work as a trusted client. If you only do e.g. JWT bearer token
verification, you won't need to configure this.

#### config.client_secret

With this parameter specify the `client_secret` of your client
that you have registered in OpenID Connect Provider. As mentioned
above, also this can be an array of client secrets.

Default | Required
:------:|:-------:
`none`  | `no`

**Note:** In many cases you will need to configure this to allow Kong
to work as a trusted client. If you only do e.g. JWT bearer token
verification, you won't need to configure this.

#### config.redirect_uri

Specify where you want the browser to be redirected (from IdP) in
case of a successful login. The ID Token will be appended
as an URL fragment to the redirect URL. If this parameter
is not specified, the ID Token will be returned instead
of redirect. This as `client_id` and `client_secret` can
also be an array if different clients use different
redirect uris.

**Examples:**

* `"https://example.com/"`


#### config.login_redirect_uri

When `config.login_action` is set to `redirect`, this configuration parameter
contains the url for the redirection. It can also be an array,
so that you can pick up different `login_redirect_uri` depending
on the selected `client`.

#### config.logout_redirect_uri

When logout is requested you can use this configuration parameter
to define url to be redirected after a successful logout. If relying
party initiated logout is used, this logout redirect uri will be used
as `post_logout_redirect_uri` passed to IdP. It can also be an array,
so that you can pick up different `logout_redirect_uri` depending
on the selected `client`.

#### config.forbidden_redirect_uri

Instead of responding with HTTP status code of 403, with this parameter
you can instead send 302 redirect. Nice to have if you are trying to
protect web sites (instead of say individual APIs) with this plugin.

#### config.unauthorized_redirect_uri

Instead of responding with HTTP status code of 401, with this parameter
you can instead send 302 redirect. Nice to have if you are trying to
protect web sites (instead of say individual APIs) with this plugin.

#### config.unexpected_redirect_uri

Instead of responding with HTTP status code of 500, with this parameter
you can instead send 302 redirect. Nice to have if you are trying to
protect web sites (instead of say individual APIs) with this plugin.

#### config.forbidden_destroy_session

Whether or not to destroy session cookie when the request was forbidden.

Default                     | Required
:--------------------------:|:-------:
`true`                      | `no`

You may want to turn this off in case you want to keep users logged in
in case they try to do something forbidden.

#### config.scopes

Scopes requested when authenticating.

Default                     | Required
:--------------------------:|:-------:
`"openid"`                  | `no`

**Examples:**

* `"openid"`
* `"openid,profile,email"`
* `"openid,profile,email,offline_access"`


#### config.scopes_required

Scopes required to be present in access token (`scope` claim) or introspection results (`scope` claim) for authorization.

Default                     | Required
:--------------------------:|:-------:
`none`                      | `no`

This config parameter works in both **AND** / **OR** cases.

**Examples:**

* `"scope1 scope2"` -- both `scope1` AND `scope2` need to be present in access token (or introspection results)
* `"scope1,scope2"` -- either `scope1` OR `scope2` need to be present in access token (or introspection results)

#### config.response_mode

When Kong talks to authorization endpoint this value instructs
OP to respond in a specific way (if OP supports different response modes):

Response mode can be one of these:

* `query` (the default)
* `form_post`
* `fragment`

**Examples:**

* `"form_post"`
* `"fragment"`

#### config.auth_methods

This so called all-in-one plugin supports many different methods to
authenticate the request using 3rd party OP. This parameter is an
array that lists all the authentication methods that you want the
plugin to accept, and the array can contain following values:

* `"password"`
* `"client_credentials"`
* `"authorization_code"`
* `"bearer"`
* `"introspection"`
* `"kong_oauth2"`
* `"refresh_token"`
* `"session"`

*password*

This enables password grant. To use this authentication method you
can either `Authorization: Basic username:password` header where
`username:password` can optionally be base64 encoded as defined in
HTTP Basic authentication specification. You can also send `username`
and `password` fields with those names to Kong as a payload.

*client_credentials*

Similar to `password` grant, but this time you have to send `client_id`
and `client_secret` as `Authorization: Basic client_id:client_secret`
header. You can also send `client_id` and `client_secret` as a payload
to Kong (with those names).

*authorization_code*

This enables (mostly) interactive authorization code flow, where Kong
initiates the process and sends redirect to OP to the client. Authorization
code flow is also the one that we use as the last fallback (when enabled)
if no other authentication methods match the request.

*bearer*

This enables Kong to look for `Authorization: Bearer <token>` header. The
`<token>` can either be a value token (signed JWT token aka JWS token) or
it can be opaque token. For value tokens Kong does signature verification
and standard claims verification (e.g. expiration checks, and many other
OpenID Connect standardized claims). For opaque tokens Kong can try to
`introspect` them, if introspection is enabled as one of the authentication
methods. On version `0.1.1` we also look bearer token in `Access-Token`,
and `X-Access-Token` headers.

*introspection*

If a bearer token is provided as opaque token, Kong can try to verify it
by using introspection.

*kong_oauth2*

A special version of opaque tokens are the ones issued by Kong OAuth 2.0
authentication plugin. This plugin can be used to verify those as well.

*session*

Kong can optionally setup session using HTTP only cookie between the client
and Kong. That can also be used for authenticating the request. This is
especially nice when used together with authorization code flow.

*refresh_token*

If refresh token is available for Kong, this authentication method enables
Kong to automatically refresh the access token using the refresh token.

#### config.audience

Used to send `audience` argument to authorization endpoint in case that is
needed. Also verifies `aud` claim of JWT tokens.

Default | Required
:------:|:-------:
`none`  | `no`

**Examples:**

* `"https://example.com/api/v2/"`
* `"https://example.com/api/v2/,https://example.com/api/v3/"`

See `config.audience_required` for a more flexible option to be used for strictly `aud` claim verification.

#### config.audience_required

Audience required to be present in access token (`aud` claim) or introspection results (`aud` claim) for authorization.

Default                     | Required
:--------------------------:|:-------:
`none`                      | `no`

This config parameter works in both **AND** / **OR** cases.

**Examples:**

* `"audience1 audience2"` -- both `audience1` AND `audience2` need to be present in access token (or introspection results)
* `"audience1,audience2"` -- either `audience1` OR `audience2` need to be present in access token (or introspection results)

#### config.domains

With this config parameter you may specify the domains that are allowed
to use the API. The token's `hd` claim (hosted domain) is verified
against the `config.domains`.

Default | Required
:------:|:-------:
`none`  | `no`

**Examples:**

* `"example.com"`
* `"example.com,company.com"`

#### config.max_age

This configuration parameter is used to configure `auth_time` claim
verification. With this parameter you may restrict the use of the API
with too old id tokens. The `max_age` is specified in seconds.

**Note:** `config.leeway` may affect the calculation as well.

Default | Required
:------:|:-------:
`0`     | `no`

**Examples:**

* `86400`
* `1800`

#### config.authorization_cookie_name

When this plugin initiates authorization code flow, it will store
some state information (for verification etc.) to a cookie that is
sent to a client together with 302 redirect to IdP's authorization
endpoint.

Default           | Required
:----------------:|:-------:
`"authorization"` | `no`

If you want to use different name for the cookie, you can use this
parameter to define one.

#### config.authorization_cookie_lifetime

Session cookie lifetime in seconds.

Default           | Required
:----------------:|:-------:
`3600`            | `no`

#### config.session_cookie_name

When this plugin initiates a session (on successful login) with
the client it will send a cookie to a client. With this parameter
you can specify the name of the cookie that client receives.

Default           | Required
:----------------:|:-------:
`"session"`       | `no`


#### config.session_cookie_lifetime

Session cookie lifetime in seconds.

Default           | Required
:----------------:|:-------:
`3600`            | `no`

#### config.session_storage

With this configuration parameter you can select where the plugin
stores the data part or the session cookie. Possible values are:

* `"cookie"`
* `"memcache"`
* `"redis"`

Default           | Required
:----------------:|:-------:
`"cookie"`        | `no`

Cookie storage has benefit of being stateless and that no database server
is needed on server. It is also lock-less. The bad side of using cookie
to store session data is that the cookies can grow big when storing
JWT tokens with a lot of claims in them. And then it will then make request
headers larger which can cause other problems, such as need to configure
Nginx/Kong (and possibly load balancers) to handle large headers. Also if
cookies grow bigger than 4k they are split in multiple cookies. Other
problems with storing data in cookie is that there could be a slight
change for someone to be able to decrypt the cookies and get access to
tokens that way. In secure environments you should never use cookie storage
without forced SSL/TLS . One additional benefit is that server stored
cookies can be deleted from the database, which will effectively invalidate
session cookies. Server stored cookies are typically well under a hundred
bytes while cookie stored data usually grow the cookies to several
kilobytes.

Below are listed the configuration parameters for `memcache` and
`redis` storage backends.

#### config.session_memcache_prefix

Memcache session key prefix (all session keys will use this prefix).

Default           | Required
:----------------:|:-------:
`"sessions"`      | `no`

E.g. if the value is `sessions` then all the sessions will be stored
in keys prefixed with `sessions:<session-id>`.

#### config.session_memcache_socket

Redis `unix` socket path. If this is defined, it will override whatever
is put in `config.session_redis_host` or `config.session_redis_port`.

#### config.session_memcache_host

Memcache `host`.

Default           | Required
:----------------:|:-------:
`"127.0.0.1"`     | `no`

#### config.session_memcache_port

Memcache `port`.

Default           | Required
:----------------:|:-------:
`11211`           | `no`

#### config.session_redis_prefix

Redis session key prefix (all session keys will use this prefix).

Default           | Required
:----------------:|:-------:
`"sessions"`      | `no`

E.g. if the value is `sessions` then all the sessions will be stored
in keys prefixed with `sessions:<session-id>`.

#### config.session_redis_socket

Redis `unix` socket path. If this is defined, it will override whatever
is put in `config.session_redis_host` or `config.session_redis_port`.

#### config.session_redis_host

Redis `host`.

Default           | Required
:----------------:|:-------:
`"127.0.0.1"`     | `no`

#### config.session_redis_port

Redis `port`.

Default           | Required
:----------------:|:-------:
`6379`            | `no`

#### config.session_redis_auth

Redis authentication password.

#### config.extra_jwks_uris

Some identity providers sign access tokens with different JWK-keys than
what they use to sign id tokens, and they don't necessarily reveal the
public keys in OpenID Connect discovery. With this parameter you can
define alternative URIs where the plugin can find the additional keys
used to verify signatures.

**Examples:**

* `"https://pingfederate.com:9031/ext/jwks"`

#### config.jwt_session_cookie

Defines a name of the cookie that contains a value for a claim that is
specified with `config.jwt_session_claim` (and which is by default `sid`)
in a JWT access token.

If you don't specify value for this, then the claim is not checked.
This is not a standard OpenID Connect feature but it is added here
for added verification of a JWT value token (your identity provider
or additional service should issue the cookie, and that cookie
should be HTTP only and sent to Kong (as well) when accessing
upstream API service).

This parameter is only used when authenticating with stateless
JWT bearer tokens (for other authentication methods we currently
ignore this).

Default | Required
:------:|:-------:
`none`  | `no`

**Examples:**

* `"sid"`
* `"session_state"`

#### config.jwt_session_claim

With this you can configure a claim in JWT access token that is verified
against a cookie with a name that is configured with `config.jwt_session_cookie`
parameter. If no name for cookie is specified, the verification is
skipped.

This parameter is only used when authenticating with stateless
JWT bearer tokens (for other authentication methods we currently
ignore this).

Default | Required
:------:|:-------:
`"sid"`  | `no`

**Examples:**

* `"sid"`
* `"session_state"`


#### config.reverify

If you are utilizing session based authentication method. Then by
default we trust that alone and do not do further verifications.
If you enable re-verification, then Kong will recheck the possible
signature and the claims on each request.

#### config.bearer_token_param_type

With this parameter you can define where the bearer tokens are searched
in request. On header we seek it from `Authorization: Bearer`, `Access-Token`,
and `X-Access-Token` headers and in query and body we seek for argument named
`access_token`.

Value         | Enabled by Default | Description
:------------:|:------------------:|------------
`"header"`    | `yes`              | If specified, tries to find bearer token from the HTTP header.
`"query"`     | `yes`              | If specified, tries to find bearer token from the URL's query string.
`"body"`      | `yes`              | If specified, tries to find bearer token from the HTTP request body.

Here are the unconfigured defaults:

Default               | Required
:--------------------:|:-------:
`"header,query,body"` | `no`

#### config.client_credentials_param_type

With this parameter you can define where the client credentials are searched
in request. On header we seek it from `Authorization: Basic` header and in query
and body we seek for arguments named `client_id` and `client_secret`.

Value         | Enabled by Default | Description
:------------:|:------------------:|------------
`"header"`    | `yes`              | If specified, tries to find client credentials from the HTTP header.
`"query"`     | `yes`              | If specified, tries to find client credentials from the URL's query string.
`"body"`      | `yes`              | If specified, tries to find client credentials from the HTTP request body.

Here are the unconfigured defaults:

Default               | Required
:--------------------:|:-------:
`"header,query,body"` | `no`

#### config.password_param_type

With this parameter you can define where the password grant credentials are searched
in request. On header we seek it from `Authorization: Basic` header and in query
and body we seek for arguments named `username` and `password`.

Value         | Enabled by Default | Description
:------------:|:------------------:|------------
`"header"`    | `yes`              | If specified, tries to find password grant credentials from the HTTP header.
`"query"`     | `yes`              | If specified, tries to find password grant credentials from the URL's query string.
`"body"`      | `yes`              | If specified, tries to find password grant credentials from the HTTP request body.

Here are the unconfigured defaults:

Default               | Required
:--------------------:|:-------:
`"header,query,body"` | `no`

#### config.id_token_param_name

Because there is no such standard that defines how the id token should
be send to a server for verification this parameter solves one half of
the puzzle by defining the parameters name where the plugin should look
for the id token.

Default      | Required
:-----------:|:-------:
`"id_token"` | `no`

**Examples:**

* `"idtoken"`
* `"idt"`
* `"X-ID-Token"`

#### config.id_token_param_type

This parameter is the another half of the puzzle of how the id token
is delivered for verification (another one being `config.id_token_param_name`).
The HTTP protocol provides a few methods for information delivery to
the server:

1. URL Query String
2. HTTP Headers
3. HTTP Body

(servers do not generally deal with url `#fragments`).

For query string and HTTP headers we do look for a value defined with
`config.id_token_param_type`. For HTTP Body we support several ways of delivery:

1. `application/x-www-form-urlencoded`
2. `application/json`

There we look for a value defined with `config.id_token_param_name`.

Based on the above the supported values for this configuration parameter
are (or any combination of them):

Value         | Enabled by Default | Description
:------------:|:------------------:|------------
`"header"`    | `yes`              | If specified, tries to find id token from the HTTP header.
`"query"`     | `yes`              | If specified, tries to find id token from the URL's query string.
`"body"`      | `yes`              | If specified, tries to find id token from the HTTP request body (according to the possiblities defined above).

Here are the unconfigured defaults:

Default               | Required
:--------------------:|:-------:
`"header,query,body"` | `no`

#### config.discovery_headers_names

Extra arguments names that you want to include in discovery
request headers (such as `Authorization`).

#### config.discovery_headers_values

Values for the extra arguments that you want to include in
discovery request headers.

#### config.authorization_query_args_names

Extra arguments names that you want to include in authorization
endpoint query string.

#### config.authorization_query_args_values

Values for the extra arguments that you want to include in
authorization endpoint query string.

#### config.authorization_query_args_client

Extra dynamic arguments that are passed from client to authorization
endpoint. E.g. specify arguments such as `login_hint` with this config
parameter.

#### config.token_post_args_names

Extra arguments names that you want to include in token
endpoint post args.

#### config.token_post_args_values

Values for the extra arguments that you want to include
in token endpoint post args.

#### config.token_headers_client

When Kong calls token endpoint, you can specify the headers
that Kong will pass to token endpoint from client request
headers.

#### config.token_headers_replay

When Kong calls token endpoint, you can specify the headers
(from the token endpoint response) that you want the Kong
to send back to the client.

#### config.token_headers_prefix

If you want you can prefix the token endpoint headers with
a string to differentiate them from other headers.

#### config.token_headers_grants

You can limit the grants for which the token headers are replayed:

* `"password"`
* `"client_credentials"`
* `"authorization_code"`

#### config.upstream_headers_claims

Claims to look from which to create upstream headers.

#### config.upstream_headers_names

Upstream headers to create for the matching claims.

#### config.upstream_access_token_header

Specify a name of the `upstream` header where the access token is
injected. By default this is set to a special value
`authorization:bearer` which means that the access token is injected
as `Authorization` header and the values is set as a `bearer` token.

#### config.downstream_access_token_header

If you want to inject access token in downstream headers (response),
you can use this configuration parameter to specify the name of the header
where the access token is injected. By default we don't inject access token
in response headers.

#### config.upstream_access_token_jwk_header

With this configuration parameter you can specify the name of the
header that Kong will inject to a request before proxying to upstream
service. The value will be set to a JWK that was used to verify the
access token. This is used when the JWT access token is available.

#### config.downstream_access_token_jwk_header

Similar to above, but this time for downstream (response).

#### config.upstream_id_token_header

Specify a name of the `upstream` header where the id token is
injected (if any). By default we don't inject id tokens to
upstream headers.

#### config.downstream_id_token_header

Specify a name of the `downstream` (response) header where the
id token is injected (if any). By default we don't inject
id tokens to downstream headers.

#### config.upstream_id_token_jwk_header

With this configuration parameter you can specify the name of the
header that Kong will inject to a request before proxying to upstream
service. The value will be set to a JWK that was used to verify the
id token. This is used when the JWT id token is available.

#### config.downstream_id_token_jwk_header

Similar to above, but this time for downstream (response).

#### config.upstream_refresh_token_header

Specify a name of the `upstream` header where the refresh token is
injected (if any). By default we don't inject refresh tokens to
upstream headers.

#### config.downstream_refresh_token_header

Specify a name of the `downstream` (response) header where the
refresh token is injected (if any). By default we don't inject
refresh tokens to downstream headers.

#### config.upstream_user_info_header

With this configuration parameter you can specify the name of the
header that Kong will inject to a request before proxying to upstream
service. The value will be set to a OpenID Connect standard User Info
(JSON document), if the plugin is able to retrieve that.

#### config.downstream_user_info_header

Similar to above, but this time for downstream (response).

#### config.upstream_introspection_header

When you try to login with opaque access token, Kong tries to
authenticate the request using standard OAuth 2.0 Introspection.
If that succeeds and you want to pass the introspection results
to upstream, you can do so by setting this parameter.

#### config.downstream_introspection_header

Similar to above, but this time for downstream (response).

#### config.introspect_jwt_tokens

You can turn this option on (`true`) to enable introspection of
JWT Bearer tokens. This enables checking of revoked JWT tokens,
but it adds latency to request. So if you enable this, it is good
to make Kong to IdP traffic as fast as possible. We still cache
introspection results if `config.cache_introspection` is enabled.
So in environments where you require absolutely up-to-date information
about token revocation, you should disable `config.cache_introspection`.
If you do so, Kong will then always call IdP's introspection endpoint
before deciding whether or not to allow processing continue, and
ultimately proxying to upstream service.

Default | Required
:------:|:-------:
`false` | `no`

#### config.introspection_endpoint

OAuth 2.0 introspection endpoint is not defined in OpenID Connect
standards or OpenID Connect Discovery. Still some OpenID providers
announce the introspection endpoint in discovery document. Kong
tries hard to figure out the introspection endpoint, but sometimes
it is not possible through automation. With this configuration
parameter you can specify a URL for your issuer's introspection
endpoint.

#### config.introspection_hint

Some providers such as `WSO2` don't implement OAuth 2.0 introspection
standard correctly, and they want to have `token_type_hint` argument
with value `bearer` instead of `access_token` when introspecting
access tokens. With this parameter you can change the value of the
`token_type_hint` argument that the plugin will pass to introspection
endpoint when introspecting access tokens.

#### config.introspection_headers_names

Extra arguments names that you want to include in introspection
request headers (e.g. use this to override `Authorization` header).

#### config.introspection_headers_values

Values for the extra arguments that you want to include in
introspection request headers.

#### config.login_methods

With this configuration parameter you can adjust plugin to only
use other `config.login_*` parameters when there is a matching
authentication method used. Possible values:

* `"password"`
* `"client_credentials"`
* `"authorization_code"`
* `"bearer"`
* `"introspection"`
* `"kong_oauth2"`
* `"session"`

By default this is configured only for `authorization_code`.
Non matching grants will be proxied to upstream regardless of
`config.login_action`.

#### config.login_action

When the authentication is done with a method specified with
`config.login_methods`, this configuration parameter enables
you to decide what Kong does next. The possible actions are:

1. `"upstream"` — after authentication, Kong reverse proxies the request to upstream service (this is the default)
2. `"response"` — after authentication, Kong returns response that by default contains `id token` (if any)
3. `"redirect"` — after authentication, Kong sends a redirect response to client with redirection uri taken from `config.login.redirect_uri`

#### config.login_tokens

If the `login_action` is set to `response` or `redirect`, you can specify
the tokens to be returned (if available) or added to redirection uri's hash.

#### config.login_redirect_mode

When `config.login_action` is set to `redirect`, this configuration parameter
is used to define how you want to pass `login_tokens with `login_redirect_uri`.
The options are:

* `"fragment"` (default)
* `"query"`
* `"form_post"` (not yet implemented)

`fragment` means that `login_tokens` are appended to `login_redirect_uri`'s
uri fragment (`#`) so that they are only accessible to the client. `query`
means that `login_tokens` are appended to `login_redirect_uri`'s query string
(`?`) making it available both to the client and the server. In future we are
going to enable third option `form_post` which will, instead of doing `302`
redirect will make a HTTP POST to `login_redirect_uri` with the tokens as
HTTP POST arguments in HTTP POST request's body.

#### config.logout_query_arg

If you want to enable logout by query argument, use this parameter to
define name of the query argument.

#### config.logout_post_arg

If you want to enable logout by post argument, use this parameter to
define name of the post argument.

#### config.logout_uri_suffix

If you want to enable logout by uri suffix, use this parameter to
define the suffix.

#### config.logout_methods

Specify HTTP methods that are allowed for logout. You can use these
methods:

* `"POST"`
* `"GET"`
* `"DELETE"`

By default `"POST"` and `"DELETE"` are enabled.

#### config.logout_revoke

If you want also try to revoke the tokens on logout by calling IdP's
revocation endpoint, you can use this parameter to enable it. By default
the plugin does not call revocation endpoint.

#### config.revocation_endpoint

If revocation endpoint is not defined in OpenID Connect discovery document,
you can use this parameter to define one manually.

#### config.end_session_endpoint

Usually this is defined in OpenID Connect discovery document, but you can
use this parameter to define one manually. If either this parameter is specified
or end session endpoint is found in discovery document, this plugin will,
on logout, redirect client to here.

#### config.token_exchange_endpoint

Whe you specify this parameter, the plugin will call the token exchange
endpoint to exchange the access token with a new one before proxying to
upstream.

The plugin will send HTTP POST request to this endpoint with valid access
token added as a bearer token in `Authorization: Bearer` header. The plugin
expects the token exchange endpoint to response with HTTP status code `200`
and the new access token needs to be in the response body. Please make it sure
that the access token is correctly encoded (e.g. use JWT Compact Encoding),
so that the token can be used e.g. in upstream service request headers.

#### config.consumer_claim

Define the name of the claim that you want to use for consumer mapping.
Setting this value will also make it possible to limit access to only
those tokens that have a matching consumer in Kong. A good value for
this setting is `"sub"`. The claim value will be loaded from ID token,
if provided or access token or introspection results. If no match is
found a `403` error is returned. In case you have defined `config.anonymous`
the anonymous consumer will be searched as well, and will be used as a
fallback if found.

Default | Required
:------:|:-------:
`none`  | `no`

**Examples:**

* `"sub"`
* `"username"`

#### config.consumer_by

This can be defined as an array of these values:

* `"id"` — search consumer by `id`,
* `"custom_id"` — search consumer by `custom_id`, or
* `"username"` — search consumer by `username`

Default       | Required
:------------:|:-------:
`"custom_id"` | `no`

**Examples:**

* `"custom_id"`
* `"username,custom_id"`
* `"id,custom_id,username"`

#### config.credential_claim

If consumer cannot be found or you don't want to use consumer mapping
this property allows you to set Kong credential by arbitrary claim. This
allows e.g. rate-limiting by arbitrary claim. All credentials share same
limits, but each has limit of their own. If you want to give someone
different limits, you can use this together with `config.consumer_claim`.

Default | Required
:------:|:-------:
`sub`   | `no`

**Examples:**

* `"sub"`
* `"user,preferred_username"` (looks under claim `user` for key `preferred_username`)

#### config.anonymous

If consumer is not found and `config.consumer_claim` is defined,
you can use this value to fallback to an anonymous consumer. Set
this value to `id` of the consumer that you want to fallback. If
fallback fails `401` will be returned.

Default | Required
:------:|:-------:
`none`  | `no`

**Examples:**

* `"f4bc9005-7488-4fe5-9861-17a4e7cb31eb"`

#### config.run_on_preflight

A boolean value that indicates whether the plugin should run
(and try to authenticate) on `OPTIONS` preflight requests,
if set to false then `OPTIONS` requests will always be allowed.

Default | Required
:------:|:-------:
`true`  | `no`

#### config.leeway

This configuration parameter is used to adjust possible clock skew
between the `OP` and `Kong`. The `config.leeway` is taken in account
in all the time related verifications. The `leeway` is specified in
seconds. Leeway is also used when checking session expiration, aka
when to refresh the access token if refresh token is available.

#### config.verify_parameters

For debugging purposes you can turn off parameter verification. Sometimes
providers announce erroneous information in their discovery documents
(e.g. they don't announce features that they actually do support). This
parameter turns all the discovery based parameter validations off. It can
be safely turned off. Please always check Kong error logs, as the plugins
in this suite usually give very clear information of what went wrong.

#### config.verify_nonce

For debugging purposes you can turn off nonce verification. Please always
check Kong error logs, as the plugins in this suite usually give very clear
information of what went wrong. Turning off the verification of nonce is not
a good idea in production as it is a security feature, If your identity provider
doesn't support it, then it might be reasonable to try turning this off.

#### config.verify_signature

You can turn off all the signature verification with this option. Generally
it is not recommended, but you can use this for debugging purposes.
Claims will still be verified.

#### config.verify_claims

You can turn off all the claims verification with this option. Generally
it is not recommended, but you can use this for debugging purposes.
Signature will still be verified.

Additional claims verification (e.g. `config.scopes_required`) will still
be checked if defined.

#### config.cache_ttl

Cache expiry time in seconds.

#### config.cache_introspection

You can turn off caching of introspection requests with this parameter.

#### config.cache_token_exchange

You can turn off caching of token exchange requests with this parameter.

#### config.cache_tokens

You can turn off caching of token endpoint requests with this parameter.

#### config.cache_user_info

You can turn off caching of user info request with this parameter.

#### config.hide_credentials

An optional boolean value telling the plugin to hide the credential to
the upstream API server. It will be removed by Kong before proxying
the request.

#### config.http_version

Specifies the HTTP version that is used for communicating with the
OP. It can either be `1.1` or `1.0`.

Default | Required
:------:|:-------:
`1.1`   | `no`

**Examples:**

* `1.0`
* `1.1`

#### config.ssl_verify

Specifies whether or not the plugin should verify the certificates
used in SSL/TLS communication.

Default | Required
:------:|:-------:
`true`  | `no`

**Examples:**

* `true`
* `false`

#### config.timeout

 Specified the timeouts for HTTP requests used in non-blocking communications
 between `Kong` and `OP`, and between `Kong` and the `Client`. This parameter
 is specified in milliseconds.

 Default | Required
 :------:|:-------:
 `10000`  | `no`

 **Examples:**

 * `10000`
 * `30000`
 * `5000`

### Authorization

`openid-connect` plugin supports different authentication / authorization
methods in one plugin. The plugin figures out the method used for
authentication by looking the request headers or parameters (and also
plugin configuration parameter `config.auth_methods).

#### Authorization Code Grant

Authorization Code grant is default (if enabled) that Kong tries when there is
no other credentials supplied. With authorization code flow Kong sends a
HTTP redirect response to the client, and initiates the authorization code flow.
After the client authenticates on identity provider, the provider sends the
client back to Kong where Kong validates the parameters and then goes on with
exchanging the authorization code with the tokens by calling token endpoint
of the identity provider.

#### Resource Owner Password Credentials Grant

The plugin looks for `Authorization: Basic <username>:<password>` header to
determine the username and password. `<username>:<password>` pair can (and should)
be base64 encoded (HTTP Basic Authentication). Alternatively you can send
`username` and `password` in url (`GET`) or body (`POST`) arguments using
`username` and `password` fields.

#### Client Credentials Grant

The plugin looks for `Authorization: Basic <client_id>:<client_secret>` header to
determine the username and password. `<client_id>:<client_secret>` pair can (and should)
be base64 encoded (HTTP Basic Authentication). Alternatively you can send
`client_id` and `client_secret` in url (`GET`) or body (`POST`) arguments using
`client_id` and `client_secret` fields.

#### JWT Bearer Token

When the client has an JWT access token available. E.g. it could have retrieved one
directly from identity provider by using implicit flow, or it could have received it
by other means. That token an then be used as a bearer token that is presented in
an authorization header (`Authorization: Bearer <token>`).  The JWT token (or JWS
in this case) will be verified for signature and standard claims before it gets
accepted.

#### Opaque Bearer Token

Similar to JWT bearer tokens, but this time Kong will figure out through introspection
whether or not to trust this token. Also the opaque access tokens are presented in an
authorization header (`Authorization: Bearer <token>`).

#### Kong OAuth 2.0 Authentication Plugin issued Opaque Access Tokens

The plugin will also accept tokens that are issued by Kong OAuth 2.0 Authentication Plugin,
and it can be used to verify them. It duplicates some verification code from Kong OAuth 2.0
plugin, but this plugin does not provide any identity provider functionality as the Kong OAuth
2.0 plugin does. Similar to JWT Bearer tokens and opaque bearer tokens, the Kong issued opaque
tokens are presented in an authorization header (`Authorization: Bearer <token>`).

#### Session Cookie

When the client has authenticated with one of the supported authentication methods mentioned
above, this plugin can also (optionally) send a HTTP Only session cookie to the client. This
cookie can be used to authenticate further requests This works especially nicely with
Authorization Code Grant that is usually used with interactive browser sessions. Session cookie
is presented to this plugin by setting the cookie header (e.g. `Cookie: session=…`).

#### Refresh Token

While this plugin does not accept refresh token directly from the client, it does support
automatic refreshing of access tokens if there is a refresh token received from a token
endpoint. With all methods there may not be a refresh token available, though (e.g. the
bearer token ones).

### Usage

Here are the step by step usage instructions. The examples are executed
using [HTTPie](https://httpie.org/). Before proceeding, please **NOTE**
that this usage example is for testing purposes and that you should
not send confidential information to `httpbin.org` that is used here
for illustrative purposes.

#### 1. Creating the API

To create an API we execute the following command:

```bash
$ http post :8001/apis                          \
    name=openid-connect-demo                    \
    uris=/                                      \
    upstream_url=http://httpbin.org/anything -v
```
```http
POST /apis HTTP/1.1
Accept: application/json, */*
Accept-Encoding: gzip, deflate
Connection: keep-alive
Content-Length: 91
Content-Type: application/json
Host: localhost:8001
User-Agent: HTTPie/0.9.9
```
```json
{
    "name": "openid-connect-demo",
    "upstream_url": "http://httpbin.org/anything",
    "uris": "/"
}
```
```http
HTTP/1.1 201 Created
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Type: application/json; charset=utf-8
Date: Mon, 14 Aug 2017 17:09:43 GMT
Server: kong/0.10.3
Transfer-Encoding: chunked
```
```json
{
    "created_at": 1502730583000,
    "http_if_terminated": false,
    "https_only": false,
    "id": "f5331dd8-4dc8-4272-8537-199598e660ad",
    "name": "openid-connect-demo",
    "preserve_host": false,
    "retries": 5,
    "strip_uri": true,
    "upstream_connect_timeout": 60000,
    "upstream_read_timeout": 60000,
    "upstream_send_timeout": 60000,
    "upstream_url": "http://httpbin.org/anything",
    "uris": [
        "/"
    ]
}
```

#### 2. Checking the API

Check that the API works by issuing the following command:

```bash
$ http :8000 -v
```

And you should get output similar to this:

```http
GET / HTTP/1.1
Accept: */*
Accept-Encoding: gzip, deflate
Connection: keep-alive
Host: localhost:8000
User-Agent: HTTPie/0.9.9
```
```http
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 390
Content-Type: application/json
Date: Mon, 14 Aug 2017 17:12:16 GMT
Server: meinheld/0.6.1
Via: kong/0.10.3
X-Kong-Proxy-Latency: 181
X-Kong-Upstream-Latency: 828
X-Powered-By: Flask
X-Processed-Time: 0.00134587287903
```
```json
{
    "args": {},
    "data": "",
    "files": {},
    "form": {},
    "headers": {
        "Accept": "*/*",
        "Accept-Encoding": "gzip, deflate",
        "Connection": "close",
        "Host": "httpbin.org",
        "User-Agent": "HTTPie/0.9.9",
        "X-Forwarded-Host": "localhost"
    },
    "json": null,
    "method": "GET",
    "origin": "127.0.0.1, 37.33.72.184",
    "url": "http://localhost/anything"
}
```

#### 3. Enabling the Plugin

To enable `openid-connect` plugin for the API,
execute the following command (on production you
shouldn't disable SSL verification):

```bash
$ http post :8001/apis/openid-connect-demo/plugins  \
    name=openid-connect                             \
    config.issuer=<ISSUER>                          \
    config.client_id=<CLIENT_ID>                    \
    config.client_secret=<CLIENT_SECRET>            \
    config.redirect_uri=<REDIRECT_URI>              \
    config.ssl_verify=false -v
```

On successful call you will get output similar to this:

```http
POST /apis/openid-connect-demo/plugins HTTP/1.1
Accept: application/json, */*
Accept-Encoding: gzip, deflate
Connection: keep-alive
Content-Length: 256
Content-Type: application/json
Host: localhost:8001
User-Agent: HTTPie/0.9.9
```
```json
{
    "config.client_id": "ATdm9WUNmfGzdE0pyRApY66pnfHVJNMI",
    "config.client_secret": "kaSFMAJSEQVlYl4Crvf4Sl9WIM0rP3gVxbhT3GAhPDTzRbzxKh3pxHnNWMhhRrcN",
    "config.issuer": "https://kong-demo.eu.auth0.com/",
    "config.ssl_verify": "false",
    "name": "openid-connect"
}
```
```http
HTTP/1.1 201 Created
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Type: application/json; charset=utf-8
Date: Mon, 14 Aug 2017 17:22:27 GMT
Server: kong/0.10.3
Transfer-Encoding: chunked
```
```json
{
    "api_id": "f5331dd8-4dc8-4272-8537-199598e660ad",
    "config": {
        "auth_methods": [
            "password",
            "client_credentials",
            "authorization_code",
            "bearer",
            "introspection",
            "kong_oauth2",
            "refresh_token",
            "session"
        ],
        "client_id": [
            "<CLIENT_ID>"
        ],
        "client_secret": [
            "<CLIENT_SECRET>"
        ],
        "consumer_by": [
            "username",
            "custom_id"
        ],
        "http_version": 1.1,
        "id_token_param_type": [
            "query",
            "header",
            "body"
        ],
        "issuer": "<ISSUER>",
        "leeway": 0,
        "login_action": "upstream",
        "login_tokens": [
            "id_token"
        ],
        "response_mode": "query",
        "reverify": false,
        "scopes": [
            "openid"
        ],
        "ssl_verify": false,
        "timeout": 10000,
        "upstream_access_token_header": "authorization:bearer",
        "verify_claims": true,
        "verify_nonce": true,
        "verify_parameters": true,
        "verify_signature": true
    },
    "created_at": 1502731347000,
    "enabled": true,
    "id": "4a91a0ef-1632-491d-a4e3-b8f98f75dcda",
    "name": "openid-connect"
}
```

#### 4. Try the API

```bash
$ http :8000 -v
```

As you might have expected, it doesn't work anymore:

```http
GET / HTTP/1.1
Accept: */*
Accept-Encoding: gzip, deflate
Connection: keep-alive
Host: localhost:8000
User-Agent: HTTPie/0.9.9
```

as it gives this redirect as a reply:

```http
HTTP/1.1 302 Moved Temporarily
Connection: keep-alive
Content-Length: 167
Content-Type: text/html
Date: Mon, 14 Aug 2017 17:24:59 GMT
Location: https://<ISSUER>/authorize?scope=openid&client_id=<CLIENT_ID>&response_mode=query&state=y2J74-KJFzogFXEtWgwDzl-Y&nonce=J-Ylp3E4dIQIhgutGFo3JOOU&redirect_uri=<REDIRECT_URI>&response_type=code
Server: kong/0.10.3
Set-Cookie: authorization=<COOKIE>; Path=/; HttpOnly
```
```html
<html>
  <head><title>302 Found</title></head>
  <body bgcolor="white">
    <center><h1>302 Found</h1></center>
    <hr><center>openresty/1.11.2.2</center>
  </body>
</html>
```

Now, at this point you could try to open the page using a browser and
see if you can go through the authorization code flow, and after that
get an reply from httpbin.org. Please check that your redirect uri is
correctly registered as the identity provider should redirect the
browser back to Kong url where this plugin is enabled (it can be the same
API or it can be different API).

You could also try another ways, like for example password grant
(and please try other authentication methods as well):

```bash
$ http :8000 Authorization:"Basic <username>:<password>"
```

Then start playing with plugin configuration, e.g. set some upstream
and downstream headers:

```bash
$ http patch :8001/plugins/<PLUGIN_ID>
    config.upstream_access_token_jwk_header=x_access_token_jwk
    config.upstream_id_token_header=x_id_token
    config.upstream_id_token_jwk_header=x_id_token_jwk
    config.upstream_refresh_token_header=x_refresh_token
    config.upstream_user_info_header=x_user_info
    config.upstream_introspection_header=x_introspection
    config.downstream_access_token_jwk_header=x_access_token_jwk
    config.downstream_id_token_header=x_id_token
    config.downstream_id_token_jwk_header=x_id_token_jwk
    config.downstream_refresh_token_header=x_refresh_token
    config.downstream_user_info_header=x_user_info
    config.downstream_introspection_header=x_introspection -v
```

And make an authenticated request again to see how this affects
the request and response headers.

## Compatibility

The library behind these plugins have been tested with several OpenID
Connect Providers, and we do expect the plugins to work with them as
well.

### Cloud Providers

Provider                                                        | Information
----------------------------------------------------------------|:------------:
[Auth0](https://auth0.com/)                                     | [Docs](https://auth0.com/protocols/oidc) / [Discovery](https://demo.auth0.com/.well-known/openid-configuration) / [Keys](https://demo.auth0.com/.well-known/jwks.json)
[Okta](https://www.okta.com/)                                   | [Docs](https://developer.okta.com/api/resources/oidc.html) / [Discovery](https://demo.oktapreview.com/.well-known/openid-configuration) / [Keys](https://demo.oktapreview.com/oauth2/v1/keys)
[OneLogin](https://www.onelogin.com/)                           | [Docs](https://developers.onelogin.com/openid-connect) / [Discovery](https://openid-connect.onelogin.com/oidc/.well-known/openid-configuration) / [Keys](https://openid-connect.onelogin.com/oidc/certs)
[Google](https://www.google.com/)                               | [Docs](https://developers.google.com/identity/protocols/OpenIDConnect) / [Discovery](https://accounts.google.com/.well-known/openid-configuration) / [Keys](https://www.googleapis.com/oauth2/v3/certs)
[Microsoft](https://www.microsoft.com/) Live Connect            | Docs / [Discovery](https://login.live.com/.well-known/openid-configuration) / [Keys](https://nexus.passport.com/public/partner/discovery/key)
[Microsoft](https://www.microsoft.com/) Azure AD                | [Docs](https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-v2-protocols-oidc) / [Discovery](https://login.microsoftonline.com/organizations/v2.0/.well-known/openid-configuration) / [Keys](https://login.microsoftonline.com/organizations/discovery/v2.0/keys)
[Yahoo!](https://www.yahoo.com/)                                | [Docs](https://developer.yahoo.com/oauth2/guide/openid_connect/) / [Discovery](https://api.login.yahoo.com/.well-known/openid-configuration) / [Keys](https://login.yahoo.com/openid/v1/certs)
[Salesforce](https://www.salesforce.com/f)                      | [Docs](https://developer.salesforce.com/page/Inside_OpenID_Connect_on_Force.com) / [Discovery](https://test.salesforce.com/.well-known/openid-configuration) / [Keys](https://test.salesforce.com/id/keys)
[Paypal](https://www.paypal.com/)                               | [Docs](https://developer.paypal.com/integration/direct/identity/log-in-with-paypal/) / [Discovery](https://www.paypal.com/.well-known/openid-configuration) / Keys

### On Premises

Provider                                                        | Information
----------------------------------------------------------------|:------------:
[Connect2id](https://connect2id.com/)                           | [Docs](https://connect2id.com/products/server) / [Discovery](https://demo.c2id.com/c2id/.well-known/openid-configuration) / [Keys](https://demo.c2id.com/c2id/jwks.json)
[PingFederate](https://www.pingidentity.com/)                   | [Docs](https://documentation.pingidentity.com/pingfederate/pf84/)
[IdentityServer4](http://identityserver.io/)                    | [Docs](https://identityserver4.readthedocs.io/) / [Discovery](https://demo.identityserver.io/.well-known/openid-configuration) / [Keys](https://demo.identityserver.io/.well-known/openid-configuration/jwks)
[OpenAM](https://www.forgerock.com/platform/access-management/) | [Docs](https://backstage.forgerock.com/openam/13.5/admin-guide/chap-openid-connect)
[Gluu](https://gluu.org/)                                       | [Docs](https://gluu.org/ce/api-guide/openid-connect-api/)
[Keycloak](http://www.keycloak.org/)                            | [Docs](https://keycloak.gitbooks.io/documentation/securing_apps/topics/oidc/oidc-generic.html)
[Dex](https://github.com/coreos/dex)                            | [Docs](https://github.com/coreos/dex/blob/master/Documentation/openid-connect.md)
[WSO2](https://wso2.com/)                                       | [Docs](https://docs.wso2.com/display/IS541/OpenID+Connect)
