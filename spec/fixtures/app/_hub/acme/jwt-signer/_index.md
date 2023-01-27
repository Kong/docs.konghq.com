---
name: Kong JWT Signer
publisher: Kong Inc.
desc: Verify and sign one or two tokens in a request
description: |
  The Kong JWT Signer plugin makes it possible to verify, sign, or re-sign
  one or two tokens in a request. With a two token request, one token
  is allocated to an end user and the other token to the client application,
  for example.

  The plugin refers to tokens as an _access token_
  and _channel token_. Tokens can be any valid verifiable tokens. The plugin
  supports both opaque tokens through introspection,
  and signed JWT tokens through signature verification. There are many
  configuration parameters available to accommodate your requirements.
enterprise: true
plus: true
type: plugin
categories:
  - authentication
kong_version_compatibility:
  community_edition:
    compatible: null
  enterprise_edition:
    compatible: true
params:
  name: jwt-signer
  service_id: true
  route_id: true
  consumer_id: false
  protocols:
    - name: http
    - name: https
    - name: grpc
    - name: grpcs
  dbless_compatible: 'yes'
  config:
    - name: realm
      required: false
      default: ngx.var.host
      datatype: string
      description: |
        When authentication or authorization fails, or there is an unexpected
        error, the plugin sends an `WWW-Authenticate` header with the `realm`
        attribute value.
    - name: enable_hs_signatures
      required: false
      default: false
      datatype: boolean
      description: |
        Tokens signed with HMAC algorithms such as `HS256`, `HS384`, or `HS512` are not
        accepted by default. If you need to accept such tokens for verification,
        enable this setting.
    - name: enable_instrumentation
      required: false
      default: false
      datatype: boolean
      description: |
        When you are experiencing problems in production and don't want to change
        the logging level on Kong nodes, which requires a reload, use this
        parameter to enable instrumentation for the request. The parameter writes
        log entries with some added information using `ngx.CRIT` (CRITICAL) level.
    - name: access_token_issuer
      required: false
      default: kong
      datatype: string
      description: |
        The `iss` claim of a signed or re-signed access token is set to this value.
        Original `iss` claim of the incoming token (possibly introspected) is
        stored in `original_iss` claim of the newly signed access token.
    - name: access_token_keyset
      required: false
      default: kong
      datatype: string
      description: |
        Selects the private key for access token signing.
    - name: access_token_jwks_uri
      required: false
      default: null
      datatype: string
      description: |
        If you want to use `config.verify_access_token_signature`, you must specify
        the URI where the plugin can fetch the public keys (JWKS) to verify the
        signature of the access token. If you don't specify a URI and you pass a
        JWT token to the plugin, then the plugin responds with
        `401 Unauthorized`.
    - name: access_token_request_header
      required: false
      default: authorization
      datatype: string
      description: |
        This parameter tells the name of the header where to look for the access token.
        By default, the plugin searches it from `Authorization: Bearer <token>` header
        (the value being magic key `authorization:bearer`). If you don't want to
        do anything with `access token`, then you can set this to `null` or `""` (empty string).
        Any header can be used to pass the access token to the plugin. Two predefined
        values are `authorization:bearer` and `authorization:basic`.
    - name: access_token_leeway
      required: false
      default: 0
      datatype: number
      description: |
        Adjusts clock skew between the token issuer and Kong. The value
        is added to the token's `exp` claim before checking token expiry against
        Kong servers' current time in seconds. You can disable access token
        `expiry` verification altogether with `config.verify_access_token_expiry`.
    - name: access_token_scopes_required
      required: false
      default: null
      datatype: array of string elements
      description: |
        Specify the required values (or scopes) that are checked by a
        claim specified by `config.access_token_scopes_claim`. For example,
        `[ "employee demo-service", "superadmin" ]` can be given as
        `"employee demo-service,superadmin"` (form post) would mean that the claim
        needs to have values `"employee"` and `"demo-service"` **OR** that the claim
        needs to have the value of `"superadmin"` to be successfully authorized for
        the upstream access. If required scopes are
        not found in access token, the plugin responds with `403 Forbidden`.
    - name: access_token_scopes_claim
      required: false
      default:
        - scope
      datatype: array of string elements
      description: |
        Specify the claim in an access token to verify against values of
        `config.access_token_scopes_required`. This supports nested claims. For
        example, with Keycloak you could use `[ "realm_access", "roles" ]`, which can
        be given as `realm_access,roles` (form post).
        If the claim is not found in the access token, and you have specified
        `config.access_token_scopes_required`,
        the plugin responds with `403 Forbidden`.
    - name: access_token_consumer_claim
      required: false
      default: null
      datatype: array of string elements
      description: |
        When you set a value for this parameter, the plugin tries to map an arbitrary
        claim specified with this configuration parameter (for example, `sub` or `username`) in
        an access token to Kong consumer entity. Kong consumers have an `id`, a `username`,
        and a `custom_id`. The `config.access_token_consumer_by` parameter
        tells the plugin which of these Kong consumer properties can be used for mapping.
        If this parameter is enabled but the mapping fails, such as when there's
        a non-existent Kong consumer, the plugin responds with `403 Forbidden`.
        Kong [consumer mapping](#consumer-mapping) is useful when you want to communicate this information
        to other plugins such as [ACL](/hub/kong-inc/acl/) or [rate limiting](/hub/kong-inc/rate-limiting/).
        The JWT Signer plugin also sets a couple of standard Kong
        upstream consumer headers.
    - name: access_token_consumer_by
      required: false
      default:
        - username
        - custom_id
      datatype: array of string elements
      description: |
        When the plugin tries to apply an access token to a Kong consumer mapping,
        it tries to find a matching Kong consumer from properties defined using
        this configuration parameter. The parameter can take an array of
        values. Valid values are `id`, `username`, and `custom_id`.
    - name: access_token_upstream_header
      required: false
      default: 'authorization:bearer'
      datatype: string
      description: |
        Removes the `config.access_token_request_header` from the request after reading its
        value. With `config.access_token_upstream_header`, you can specify the upstream header where the
        plugin adds the Kong signed token. If you don't specify a value,
        such as use `null` or `""` (empty string), the plugin does not even try to
        sign or re-sign the token.
    - name: access_token_upstream_leeway
      required: false
      default: 0
      datatype: number
      description: |
        If you want to add or perhaps subtract (using a negative value) expiry
        time of the original access token, you can specify a value that is added to
        the original access token's `exp` claim.
    - name: access_token_introspection_endpoint
      required: false
      default: null
      datatype: string
      description: |
        When you use `opaque` access tokens and you want to turn on access token
        introspection, you need to specify the OAuth 2.0 introspection endpoint URI
        with this configuration parameter. Otherwise, the plugin does not try
        introspection and returns `401 Unauthorized` instead.
    - name: access_token_introspection_authorization
      required: false
      default: null
      datatype: string
      description: |
        If the introspection endpoint requires client authentication (client being
        the JWT Signer plugin), you can specify the `Authorization` header's value with this
        configuration parameter. For example, if you use client credentials, enter
        the value of `"Basic base64encode('client_id:client_secret')"`
        to this configuration parameter. You are responsible for providing the full string
        of the header and doing all of the necessary encodings (such as base64)
        required on a given endpoint.
    - name: access_token_introspection_body_args
      required: false
      default: null
      datatype: string
      description: |
        If you need to pass additional body arguments to an introspection endpoint
        when the plugin introspects the opaque access token, use this config parameter
        to specify them. You should URL encode the value. For example: `resource=` or `a=1&b=&c`.
    - name: access_token_introspection_hint
      required: false
      default: access_token
      datatype: string
      description: |
        If you need to give `hint` parameter when introspecting an access token,
        use this parameter to specify the value. By default, the plugin
        sends `hint=access_token`.
    - name: access_token_introspection_jwt_claim
      required: false
      default: null
      datatype: array of string elements
      description: |
        If your introspection endpoint returns an access token in one of the keys
        (or claims) within the introspection results (`JSON`), the plugin can use that value
        instead of the introspection results when doing expiry verification and
        signing of the new token issued by Kong. For example, if you specify
        `[ "token_string" ]`, which can be given as `"token_string"` (form post)
        to this configuration parameter, the plugin looks for key `token_string`
        in JSON of the introspection results and uses that as an access token instead
        of using introspection JSON directly. If the key cannot be found, the
        plugin responds with `401 Unauthorized`. Also if the key is found
        but cannot be decoded as JWT, it also responds with `401 Unauthorized`.
    - name: access_token_introspection_scopes_required
      required: false
      default: null
      datatype: array of string elements
      description: |
        Specify the required values (or scopes) that are checked by an
        introspection claim/property specified by `config.access_token_introspection_scopes_claim`.
        For example, `[ "employee demo-service", "superadmin" ]` can be given as `"employee demo-service,superadmin"`
        (form post) would mean that the claim needs to have values `"employee"` and `"demo-service"` **OR**
        that the claim needs to have value of `"superadmin"` to be successfully authorized for the upstream
        access. If required scopes are not found in access token introspection results (`JSON`),
        the plugin responds with `403 Forbidden`.
    - name: access_token_introspection_scopes_claim
      required: true
      default:
        - scope
      datatype: array of string elements
      description: |
        Specify the claim/property in access token introspection results
        (`JSON`) to be verified against values of `config.access_token_introspection_scopes_required`.
        This supports nested claims. For example, with Keycloak you could use `[ "realm_access", "roles" ]`,
        which can be given as `realm_access,roles` (form post). If the claim is not found in access
        token introspection results, and you have specified `config.access_token_introspection_scopes_required`,
        the plugin responds with `403 Forbidden`.
    - name: access_token_introspection_consumer_claim
      required: false
      default: null
      datatype: array of string elements
      description: |
        When you set a value for this parameter, the plugin tries to map an arbitrary
        claim specified with this configuration parameter (such as `sub` or `username`)
        in access token introspection results to the Kong consumer entity. Kong consumers
        have an `id`, a `username`, and a `custom_id`. The
        `config.access_token_introspection_consumer_by` parameter tells the plugin which of these
        Kong consumer properties can be used for mapping. If this parameter is enabled
        but the mapping fails, such as when there's
        a non-existent Kong consumer, the plugin responds
        with `403 Forbidden`. Kong [consumer mapping](#consumer-mapping) is useful when you want to
        communicate this information to other plugins such as [ACL](/hub/kong-inc/acl/)
        or [rate limiting](/hub/kong-inc/rate-limiting/). The JWT Signer plugin also
        sets a couple of standard Kong upstream consumer headers.
    - name: access_token_introspection_consumer_by
      required: false
      default:
        - username
        - custom_id
      datatype: array of string elements
      description: |
        When the plugin tries to do access token introspection results to Kong consumer mapping, it tries to
        find a matching Kong consumer from properties defined using this configuration parameter. The parameter
        can take an array of values. Valid values are `id`, `username`, and `custom_id`.
    - name: access_token_introspection_leeway
      required: false
      default: 0
      datatype: number
      description: |
        Adjusts clock skew between the token issuer introspection results
        and Kong. The value is added to introspection results (`JSON`) `exp` claim/property before
        checking token expiry against Kong servers current time in seconds. You
        can disable access token introspection `expiry` verification altogether
        with `config.verify_access_token_introspection_expiry`.
    - name: access_token_introspection_timeout
      required: false
      default: null
      datatype: number
      description: |
        Timeout in milliseconds for an introspection request.
        The plugin tries to introspect twice if the first request
        fails for some reason. If both requests timeout, then the plugin runs two times the
        `config.access_token_introspection_timeout` on access token introspection.
    - name: access_token_signing_algorithm
      required: true
      default: RS256
      datatype: string
      description: |
        When this plugin sets the upstream header as specified with `config.access_token_upstream_header`,
        it also re-signs the original access token using the private keys of the JWT Signer plugin.
        Specify the algorithm that is used to sign the token. Currently
        supported values:
        - `"HS256"`
        - `"HS384"`
        - `"HS512"`
        - `"RS256"`
        - `"RS512"`
        - `"ES256"`
        - `"ES384"`
        - `"ES512"`
        - `"PS256"`
        - `"PS384"`
        - `"PS512"`
        - `"EdDSA"`

        The `config.access_token_issuer`
        specifies which `keyset` is used to sign the new token issued by Kong using
        the specified signing algorithm.
    - name: access_token_optional
      required: false
      default: false
      datatype: boolean
      description: |
        If an access token is not provided or no `config.access_token_request_header` is specified,
        the plugin cannot verify the access token. In that case, the plugin normally responds
        with `401 Unauthorized` (client didn't send a token) or `500 Unexpected` (a configuration error).
        Use this parameter to allow the request to proceed even when there is no token to check.
        If the token is provided, then this parameter has no effect (look other parameters to enable and
        disable checks in that case).
    - name: verify_access_token_signature
      required: false
      default: true
      datatype: boolean
      description: |
        Quickly turn access token signature verification off and on as needed.
    - name: verify_access_token_expiry
      required: false
      default: true
      datatype: boolean
      description: |
        Quickly turn access token expiry verification off and on as needed.
    - name: verify_access_token_scopes
      required: false
      default: true
      datatype: boolean
      description: |
        Quickly turn off and on the access token
        required scopes verification, specified with `config.access_token_scopes_required`.
    - name: verify_access_token_introspection_expiry
      required: false
      default: true
      datatype: boolean
      description: |
        Quickly turn access token introspection expiry verification off and on as needed.
    - name: verify_access_token_introspection_scopes
      required: false
      default: true
      datatype: boolean
      description: |
        Quickly turn off and on the access token
        introspection scopes verification, specified with
        `config.access_token_introspection_scopes_required`.
    - name: cache_access_token_introspection
      required: false
      default: true
      datatype: boolean
      description: |
        Whether to cache access token introspection results.
    - name: trust_access_token_introspection
      required: false
      default: true
      datatype: boolean
      description: |
        When you provide a opaque access token that the plugin introspects, and you do expiry
        and scopes verification on introspection results, you probably don't want to do another
        round of checks on the payload before the plugin signs a new token. Or that you don't
        want to do checks to a JWT token provided with introspection JSON specified with
        `config.access_token_introspection_jwt_claim`. Use this parameter to enable and
        disable further checks on a payload before the new token is signed. If you set this
        to `true`, the expiry or scopes are not checked on a payload.
    - name: enable_access_token_introspection
      required: false
      default: true
      datatype: boolean
      description: |
        If you don't want to support opaque access tokens, change this
        configuration parameter to `false` to disable introspection.
    - name: channel_token_issuer
      required: false
      default: kong
      datatype: string
      description: |
        The `iss` claim of the re-signed channel token is set to this value, which
        is `kong` by default. The original `iss` claim of the incoming token
        (possibly introspected) is stored in the `original_iss` claim of
        the newly signed channel token.
    - name: channel_token_keyset
      required: false
      default: kong
      datatype: string
      description: |
        Selects the private key for channel token signing.
    - name: channel_token_jwks_uri
      required: false
      default: null
      datatype: string
      description: |
        If you want to use `config.verify_channel_token_signature`, you must specify the URI where
        the plugin can fetch the public keys (JWKS) to verify the signature of the channel token.
        If you don't specify a URI and you pass a JWT token to the plugin, then the plugin responds
        with `401 Unauthorized`.
    - name: channel_token_request_header
      required: false
      default: null
      datatype: string
      description: |
        This parameter tells the name of the header where to look for the channel token.
        By default, the plugin doesn't look for the channel token. If you don't want to
        do anything with the channel token, then you can set this to `null` or `""`
        (empty string). Any header can be used to pass the channel
        token to this plugin. Two predefined values are `authorization:bearer`
        and `authorization:basic`.
    - name: channel_token_leeway
      required: false
      default: 0
      datatype: number
      description: |
        Adjusts clock skew between the token issuer and Kong. The value
        will be added to token's `exp` claim before checking token expiry against Kong servers current
        time in seconds. You can disable channel token `expiry` verification altogether with
        `config.verify_channel_token_expiry`.
    - name: channel_token_scopes_required
      required: false
      default: null
      datatype: array of string elements
      description: |
        Specify the required values (or scopes) that are checked by a claim
        specified by `config.channel_token_scopes_claim`. For example, if `[ "employee demo-service", "superadmin" ]`
        was given as `"employee demo-service,superadmin"` (form post), the claim needs
        to have values `"employee"` and `"demo-service"`, **OR** that the claim needs to have the value of
        `"superadmin"` to be successfully authorized for the upstream access. If required scopes are not
        found in the channel token, the plugin responds with `403 Forbidden`.
    - name: channel_token_scopes_claim
      required: false
      default:
        - scope
      datatype: array of string elements
      description: |
        Specify the claim in a channel token to verify against values of
        `config.channel_token_scopes_required`. This supports nested claims. With Keycloak, you could
        use `[ "realm_access", "roles" ]`, which can be given as `realm_access,roles` (form post).
        If the claim is not found in the channel token, and you have specified `config.channel_token_scopes_required`,
        the plugin responds with `403 Forbidden`.
    - name: channel_token_consumer_claim
      required: false
      default: null
      datatype: array of string elements
      description: |
        When you set a value for this parameter, the plugin tries to map an arbitrary claim specified with
        this configuration parameter (such as `sub` or `username`) in a channel token to a Kong consumer entity. Kong
        consumers have an `id`, a `username`, and a `custom_id`. The `config.channel_token_consumer_by` parameter
        tells the plugin which Kong consumer properties can be used for mapping. If this
        parameter is enabled but the mapping fails, such as when there's
        a non-existent Kong consumer, the plugin responds
        with `403 Forbidden`. Kong [consumer mapping](#consumer-mapping) is useful
        when you want to communicate this information
        to other plugins such as [ACL](/hub/kong-inc/acl/) or [rate limiting](/hub/kong-inc/rate-limiting/).
        The JWT Signer plugin also sets a couple of standard Kong upstream consumer headers.
    - name: channel_token_consumer_by
      required: false
      default:
        - username
        - custom_id
      datatype: array of string elements
      description: |
        When the plugin tries to do channel token to Kong consumer mapping, it tries
        to find a matching Kong consumer from properties defined using this configuration parameter.
        The parameter can take an array of valid values: `id`, `username`, and `custom_id`.
    - name: channel_token_upstream_header
      required: false
      default: null
      datatype: string
      description: |
        This plugin removes the `config.channel_token_request_header` from the request
        after reading its value.
        With `config.channel_token_upstream_header`, you can specify the upstream header where the plugin
        adds the Kong-signed token. If you don't specify a value (so `null` or `""` empty string),
        the plugin does not attempt to re-sign the token.
    - name: channel_token_upstream_leeway
      required: false
      default: 0
      datatype: number
      description: |
        If you want to add or perhaps subtract (using negative value) expiry time of the original channel token,
        you can specify a value that is added to the original channel token's `exp` claim.
    - name: channel_token_introspection_endpoint
      required: false
      default: null
      datatype: string
      description: |
        When using `opaque` channel tokens, and you want to turn on channel token introspection, you need to
        specify the OAuth 2.0 introspection endpoint URI with this configuration parameter.
        Otherwise the plugin will not try introspection, and instead returns `401 Unauthorized`
        when using opaque channel tokens.
    - name: channel_token_introspection_authorization
      required: false
      default: null
      datatype: string
      description: |
        If the introspection endpoint requires client authentication (client being this plugin), you can specify
        the `Authorization` header's value with this configuration parameter. If you use client credentials,
        you should enter the value of `"Basic base64encode('client_id:client_secret')"` to this configuration parameter.
        You are responsible for providing the full string of the header and doing
        all the necessary encodings (such as base64) required on a given endpoint.
    - name: channel_token_introspection_body_args
      required: false
      default: null
      datatype: string
      description: |
        If you need to pass additional body arguments to introspection endpoint when the plugin introspects the
        opaque channel token, you can use this config parameter to specify them. You should URL encode the value.
        For example: `resource=` or `a=1&b=&c`.
    - name: channel_token_introspection_hint
      required: false
      default: null
      datatype: string
      description: |
        If you need to give `hint` parameter when introspecting a channel token, you can use this parameter to
        specify the value of such parameter. By default, a `hint` isn't sent with channel token introspection.
    - name: channel_token_introspection_jwt_claim
      required: false
      default: null
      datatype: array of string elements
      description: |
        If your introspection endpoint returns a channel token in one of the keys (or claims) in the introspection
        results (`JSON`), the plugin can use that value instead of the introspection results when doing expiry verification
        and signing of the new token issued by Kong. For example, if you specify `[ "token_string" ]`, which can be given as
        `"token_string"` (form post) to this configuration parameter, the plugin looks for key `token_string`
        in JSON of the introspection results and uses that as a channel token instead of using introspection JSON
        directly. If the key cannot be found, the plugin responds with `401 Unauthorized`. Also if the key
        is found but cannot be decoded as JWT, the plugin responds with `401 Unauthorized`.
    - name: channel_token_introspection_scopes_required
      required: false
      default: null
      datatype: array of string elements
      description: |
        Use this parameter to specify the required values (or scopes) that are checked by an introspection
        claim/property specified by `config.channel_token_introspection_scopes_claim`.
        For example, `[ "employee demo-service", "superadmin" ]`, which can be given as `"employee demo-service,superadmin"`
        (form post) would mean that the claim needs to have the values `"employee"` and `"demo-service"` **OR** that the
        claim needs to have the value of `"superadmin"` to be successfully authorized for the upstream access.
        If required scopes are not found in channel token introspection results (`JSON`), the plugin
        responds with `403 Forbidden`.
    - name: channel_token_introspection_scopes_claim
      required: false
      default:
        - scope
      datatype: array of string elements
      description: |
        Use this parameter to specify the claim/property in channel token introspection results (`JSON`)
        to be verified against values of `config.channel_token_introspection_scopes_required`. This supports
        nested claims. For example, with Keycloak you could use `[ "realm_access", "roles" ]`, which can be given as
        `realm_access,roles` (form post). If the claim is not found in channel token introspection results,
        and you have specified `config.channel_token_introspection_scopes_required`, the plugin responds
        with `403 Forbidden`.
    - name: channel_token_introspection_consumer_claim
      required: false
      default: null
      datatype: array of string elements
      description: |
        When you set a value for this parameter, the plugin tries to map an arbitrary claim specified with
        this configuration parameter (such as `sub` or `username`) in channel token introspection results to
        Kong consumer entity. Kong consumers have an `id`, a `username` and a `custom_id`. The
        `config.channel_token_introspection_consumer_by` parameter tells the plugin which of these
        Kong consumer properties can be used for mapping. If this parameter is enabled
        but the mapping fails, such as when there's
        a non-existent Kong consumer, the plugin responds with `403 Forbidden`. Kong
        [consumer mapping](#consumer-mapping)
        is useful when you want to communicate this information to other plugins such as
        [ACL](/hub/kong-inc/acl/) or [rate limiting](/hub/kong-inc/rate-limiting/). The
        JWT Signer plugin also sets a couple of standard
        Kong upstream consumer headers.
    - name: channel_token_introspection_consumer_by
      required: false
      default:
        - username
        - custom_id
      datatype: array of string elements
      description: |
        When the plugin tries to do channel token introspection results to Kong consumer mapping, it tries to
        find a matching Kong consumer from properties defined using this configuration parameter. The parameter
        can take an array of values. Valid values are `id`, `username` and `custom_id`.
    - name: channel_token_introspection_leeway
      required: false
      default: 0
      datatype: number
      description: |
        You can use this parameter to adjust clock skew between the token issuer introspection results and Kong.
        The value will be added to introspection results (`JSON`) `exp` claim/property before checking token expiry
        against Kong servers current time (in seconds). You can disable channel token introspection `expiry`
        verification altogether with `config.verify_channel_token_introspection_expiry`.
    - name: access_token_introspection_timeout
      required: false
      default: null
      datatype: number
      description: |
        Timeout in milliseconds for an introspection request. The plugin tries to introspect twice if the first request
        fails for some reason. If both requests timeout, then the plugin runs two times the
        `config.access_token_introspection_timeout` on channel token introspection.
    - name: channel_token_signing_algorithm
      required: true
      default: RS256
      datatype: string
      description: |
        When this plugin sets the upstream header as specified with `config.channel_token_upstream_header`,
        it also re-signs the original channel token using private keys of this plugin.
        Specify the algorithm that is used to sign the token. Currently
        supported values:
        - `"HS256"`
        - `"HS384"`
        - `"HS512"`
        - `"RS256"`
        - `"RS512"`
        - `"ES256"`
        - `"ES384"`
        - `"ES512"`
        - `"PS256"`
        - `"PS384"`
        - `"PS512"`
        - `"EdDSA"`

        The `config.channel_token_issuer` specifies which `keyset`
        is used to sign the new token issued by Kong using the specified signing algorithm.
    - name: channel_token_optional
      required: false
      default: false
      datatype: boolean
      description: |
        If a channel token is not provided or no `config.channel_token_request_header` is specified,
        the plugin cannot verify the channel token. In that case, the plugin normally responds
        with `401 Unauthorized` (client didn't send a token) or `500 Unexpected` (a configuration error).
        Enable this parameter to allow the request to proceed even when there is no channel token
        to check. If the channel token is provided, then this parameter has no effect
        (look other parameters to enable and disable checks in that case).
    - name: verify_channel_token_signature
      required: false
      default: true
      datatype: boolean
      description: |
        Quickly turn on/off the channel token signature verification.
    - name: verify_channel_token_expiry
      required: false
      default: true
      datatype: boolean
      description: |
        Quickly turn on/off the channel token expiry verification.
    - name: verify_channel_token_scopes
      required: false
      default: true
      datatype: boolean
      description: |
        Quickly turn on/off the channel token required scopes
        verification specified with `config.channel_token_scopes_required`.
    - name: verify_channel_token_introspection_expiry
      required: false
      default: true
      datatype: boolean
      description: |
        Quickly turn on/off the channel token introspection expiry
        verification.
    - name: verify_channel_token_introspection_scopes
      required: false
      default: true
      datatype: boolean
      description: |
        Quickly turn on/off the channel token introspection scopes
        verification specified with `config.channel_token_introspection_scopes_required`.
    - name: cache_channel_token_introspection
      required: false
      default: true
      datatype: boolean
      description: |
        Whether to cache channel token introspection results.
    - name: trust_channel_token_introspection
      required: false
      default: true
      datatype: boolean
      description: |
        When you provide an opaque channel token that the plugin introspects, and you do expiry
        and scopes verification on introspection results, you probably don't want to do another
        round of checks on the payload before the plugin signs a new token. Or you don't
        want to do checks to a JWT token provided with introspection JSON specified with
        `config.channel_token_introspection_jwt_claim`. Use this parameter to enable or
        disable further checks on a payload before the new token is signed. If you set this
        to `true` (default), the expiry or scopes are not checked on a payload.
    - name: enable_channel_token_introspection
      required: false
      default: true
      datatype: boolean
      description: |
        If you don't want to support opaque channel tokens, disable introspection by
        changing this configuration parameter to `false`.
  extra: |
    **Configuration Notes:**

    Most of the parameters are optional, but you need to specify some options to actually
    make the plugin work:

    * For example, signature verification cannot be done without the plugin knowing about
    `config.access_token_jwks_uri` and/or `config.channel_token_jwks_uri`.

    * Also for introspection to work, you need to specify introspection endpoints
    `config.access_token_introspection_endpoint` and/or `config.channel_token_introspection_endpoint`.
---

## Manage key signing

If you specify `config.access_token_keyset` or `config.channel_token_keyset` with either an
`http://` or `https://` prefix, it means that token signing keys are externally managed by you.
In that case, the plugin loads the keys just like it does for `config.access_token_jwks_uri`
and `config.channel_token_jwks_uri`. If the prefix is not `http://` or `https://`
(such as `"my-company"` or `"kong"`), Kong autogenerates JWKS for supported algorithms.

External JWKS specified with `config.access_token_keyset` or
`config.channel_token_keyset` should also contain private keys with supported `alg`,
either `"RS256"` or `"RS512"` for now. External URLs that contain private keys should
be protected so that only Kong can access them. Currently, Kong doesn't add any authentication
headers when it loads the keys from an external endpoint, so you have to do it with network
level restrictions. If it is a common need to manage private keys externally
instead of allowing Kong to autogenerate them, we can add another parameter
for adding an authentication header (possibly similar to
`config.channel_token_introspection_authorization`).

The key size (the modulo) for RSA keys is currently hard-coded to 2048 bits.

## Consumer mapping

The following parameters let you provide consumer mapping:

- `config.access_token_consumer_claim`
- `config.access_token_introspection_consumer_claim`
- `config.channel_token_consumer_claim`
- `config.channel_token_introspection_consumer_claim`

You can map only once. The plugin applies mappings in the following order:

1. access token introspection results
2. access token jwt payload
3. access token introspection results
4. access token jwt payload

The mapping order depends on input (opaque or JWT).

When mapping is done, no other mappings are used. If access token already maps
to a Kong consumer, the plugin does not try to map a channel token to a consumer
anymore and does not even error in that case.

A general rule is to map either the access token or the channel token.

## Kong Admin API Endpoints

This plugin also provides a few Admin API endpoints, and some actions upon them.

### Cached JWKS Admin API Endpoint

The plugin caches JWKS specified with `config.access_token_jwks_uri` and
`config.channel_token_jwks_uri` to Kong database for quicker access to them. The plugin
further caches JWKS in Kong node's shared memory, and on process a level memory for
even quicker access. When the plugin is responsible for signing the tokens, it
also stores its own keys in the database.

Admin API endpoints never reveal private keys but do reveal public keys.
Private keys that the plugin autogenerates can only be accessed from database
directly (at least for now). Private parts in JWKS include
properties such as `d`, `p`, `q`, `dp`, `dq`, `qi`, and `oth`. For public keys
that are using a symmetric algorithm (such as `HS256`) and include `k` parameter,
that is not hidden from Admin API as that is practically used both to verify and
to sign. This makes it a bit problematic to use, and we strongly suggest using
asymmetric (or public key) algorithms. Doing so also makes rotating the keys
easier because the public keys can be shared between parties
and published without revealing their secrets.

View all of the public keys that Kong has loaded or generated:

```http
GET kong:8001/jwt-signer/jwks
```

Example:

```bash
curl -X GET http://<kong>:8001/jwt-signer/jwks
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

A particular key set can be accessed in another endpoint:

```http
GET kong:8001/jwt-signer/jwks/<name-or-id>
```

Example:

```bash
curl -X GET http://<kong>:8001/jwt-signer/jwks/kong
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

The `http://<kong>:8001/jwt-signer/jwks/kong` is the URL that you can give to your
upstream services for them to verify Kong-issued tokens. The response is a standard
JWKS endpoint response. The `kong` suffix in the URI is the one that you can specify
with `config.access_token_issuer` or `config.channel_token_issuer`.

You can also make a loopback to this endpoint by routing Kong proxy to this URL.
Then you can use an authentication plugin to protect access to this endpoint,
if that is needed.

You can also `DELETE` a key set by issuing following:

```http
DELETE kong:8001/jwt-signer/jwks/<name-or-id>
```

Example:

```bash
curl -X DELETE http://<kong>:8001/jwt-signer/jwks/kong
```

The plugin automatically reloads or regenerates missing JWKS if it cannot
find cached ones. The plugin also tries to reload JWKS if it cannot verify
the signature of original access token or channel token, such as when
the original issuer has rotated its keys and signed with the new one that is not
found in Kong cache.

### Cached JWKS Admin API Endpoint for a Key Set Rotation

Sometime you might want to rotate the keys Kong uses for signing tokens specified with
`config.access_token_keyset` and `config.channel_token_keyset`, or perhaps
reload tokens specified with `config.access_token_jwks_uri` and
`config.channel_token_jwks_uri`. Kong stores and uses at most two set of keys:
**current** and **previous**. If you want Kong to forget the previous keys, you need to
rotate keys **twice**, as it effectively replaces both current and previous key sets
with newly generated tokens or reloaded tokens if the keys were loaded from
an external URI.

To rotate keys, send a `POST` request:

```http
POST kong:8001/jwt-signer/jwks/<name-or-id>/rotate
```

Example:

```bash
curl -X POST http://<kong>:8001/jwt-signer/jwks/kong/rotate
```
Response:

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

---
## Changelog

### 2.7.x
> handler.lua version: 1.9.0

* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled,
 the following fields  `d`, `p`, `q`, `dp`, `dq`, `qi`, and `k`inside
 `jwt_signer_jwks.previous[...].` and `jwt_signer_jwks.keys[...]` will be
 marked as encrypted.

  {:.important}
  > There's a bug in {{site.base_gateway}} that prevents keyring encryption
  from working on deeply nested fields, so the `encrypted=true` setting does not
  currently have any effect in this plugin.
