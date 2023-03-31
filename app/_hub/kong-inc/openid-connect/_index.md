---
name: OpenID Connect
publisher: Kong Inc.
desc: Integrate Kong with a third-party OpenID Connect provider
description: |
  OpenID Connect ([1.0][connect]) plugin allows for integration with a third party
  identity provider (IdP) in a standardized way. This plugin can be used to implement
  Kong as a (proxying) [OAuth 2.0][oauth2] resource server (RS) and/or as an OpenID
  Connect relying party (RP) between the client, and the upstream service.

  The plugin supports several types of credentials and grants:

  - Signed [JWT][jwt] access tokens ([JWS][jws])
  - Opaque access tokens
  - Refresh tokens
  - Authorization code with client secret or PKCE
  - Username and password
  - Client credentials
  - Session cookies

  The plugin has been tested with several OpenID Connect providers:

  - [Auth0][auth0] ([Kong Integration Guide](/gateway/latest/configure/auth/oidc-auth0/))
  - [Amazon AWS Cognito][cognito] ([Kong Integration Guide](/gateway/latest/configure/auth/oidc-cognito/))
  - [Connect2id][connect2id]
  - [Curity][curity]
  - [Dex][dex]
  - [Gluu][gluu]
  - [Google][google] ([Kong Integration Guide](/gateway/latest/configure/auth/oidc-google/))
  - [IdentityServer][identityserver]
  - [Keycloak][keycloak]
  - [Microsoft Azure Active Directory][azure] ([Kong Integration Guide](/gateway/latest/configure/auth/oidc-azuread/))
  - [Microsoft Active Directory Federation Services][adfs]
  - [Microsoft Live Connect][liveconnect]
  - [Okta][okta] ([Kong Integration Guide](/gateway/latest/configure/auth/oidc-okta/))
  - [OneLogin][onelogin]
  - [OpenAM][openam]
  - [Paypal][paypal]
  - [PingFederate][pingfederate]
  - [Salesforce][salesforce]
  - [WSO2][wso2]
  - [Yahoo!][yahoo]

  As long as your provider supports OpenID Connect standards, the plugin should
  work, even if it is not specifically tested against it. Let Kong know if you
  want your provider to be tested and added to the list.

  [curity]: https://curity.io/resources/learn/openid-connect-overview/
  [connect]: http://openid.net/specs/openid-connect-core-1_0.html
  [oauth2]: https://tools.ietf.org/html/rfc6749
  [jwt]: https://tools.ietf.org/html/rfc7519
  [jws]: https://tools.ietf.org/html/rfc7515
  [auth0]: https://auth0.com/docs/protocols/openid-connect-protocol
  [cognito]: https://aws.amazon.com/cognito/
  [connect2id]: https://connect2id.com/products/server
  [curity]: https://curity.io/resources/learn/openid-connect-overview/
  [dex]: https://dexidp.io/docs/openid-connect/
  [gluu]: https://gluu.org/docs/ce/api-guide/openid-connect-api/
  [google]: https://developers.google.com/identity/protocols/oauth2/openid-connect
  [identityserver]: https://duendesoftware.com/
  [keycloak]: http://www.keycloak.org/documentation.html
  [azure]: https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-protocols-oidc
  [adfs]: https://docs.microsoft.com/en-us/windows-server/identity/ad-fs/development/ad-fs-openid-connect-oauth-concepts
  [liveconnect]: https://docs.microsoft.com/en-us/advertising/guides/authentication-oauth-live-connect
  [okta]: https://developer.okta.com/docs/api/resources/oidc.html
  [onelogin]: https://developers.onelogin.com/openid-connect
  [openam]: https://backstage.forgerock.com/docs/openam/13.5/admin-guide/#chap-openid-connect
  [paypal]: https://developer.paypal.com/docs/log-in-with-paypal/integrate/
  [pingfederate]: https://docs.pingidentity.com/r/en-us/pingfederate-112/pf_pingfederate_landing_page
  [salesforce]: https://help.salesforce.com/articleView?id=sf.sso_provider_openid_connect.htm&type=5
  [wso2]: https://is.docs.wso2.com/en/latest/guides/identity-federation/configure-oauth2-openid-connect/
  [yahoo]: https://developer.yahoo.com/oauth2/guide/openid_connect/

  Once applied, any user with a valid credential can access the Service.

  This plugin can be used for authentication in conjunction with the
  [Application Registration](/hub/kong-inc/application-registration/) plugin.

  ## Important Configuration Parameters

  This plugin includes many configuration parameters that allow finely grained customization.
  The following steps will help you get started setting up the plugin:

  1. Configure: `config.issuer`.

     This parameter tells the plugin where to find discovery information, and it is
     the only required parameter. You should set the value `realm` or `iss` on this
     parameter if you don't have a discovery endpoint.

     {:.note}
      > **Note**: This does not have
     to match the URL of the `iss` claim in the access tokens being validated. To set
     URLs supported in the `iss` claim, use `config.issuers_allowed`.
  2. Decide what authentication grants to use with this plugin and configure
     the `config.auth_methods` field accordingly.

     In order to restrict the scope of potential attacks, the parameter should only contain the grants that you want to use. 

  3. In many cases, you also need to specify `config.client_id`, and if your identity provider
     requires authentication, such as on a token endpoint, you will need to specify the client
     authentication credentials too, for example `config.client_secret`.

  4. If you are using a public identity provider, such as Google, you should limit
     the audience with `config.audience_required` to contain only your `config.client_id`.
     You may also need to adjust `config.audience_claim` in case your identity provider
     uses a non-standard claim (other than `aud` as specified in JWT standard). This is
     important because some identity providers, such as Google, share public keys
     with different clients.

  5. If you are using Kong in DB-less mode with a declarative configuration and 
     session cookie authentication, you should set `config.session_secret`.
     Leaving this parameter unset will result in every Nginx worker across your
     nodes encrypting and signing the cookies with their own secrets.

  In summary, start with the following parameters:

  1. `config.issuer`
  2. `config.auth_methods`
  3. `config.client_id` (and in many cases the client authentication credentials)
  4. `config.audience_required` (if using a public identity provider)
  5. `config.session_secret` (if using Kong in DB-less mode)
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
  name: openid-connect
  service_id: true
  route_id: true
  consumer_id: false
  protocols:
    - name: http
    - name: https
    - name: grpc (depends on the grant)
    - name: grpcs (depends on the grant)
  dbless_compatible: 'yes'
  config:
    - group: Authentication Grants
      description: Parameters for enabling only grants/credentials that you want to use.
    - name: auth_methods
      required: false
      default:
        - password
        - client_credentials
        - authorization_code
        - bearer
        - introspection
        - userinfo
        - kong_oauth2
        - refresh_token
        - session
      value_in_examples:
        - authorization_code
        - session
      datatype: array of string elements
      description: |
        Types of credentials/grants to enable:
        - `password`: OAuth legacy password grant
        - `client_credentials`: OAuth client credentials grant
        - `authorization_code`: authorization code flow
        - `bearer`: JWT access token verification
        - `introspection`: OAuth introspection
        - `userinfo`: OpenID Connect user info endpoint authentication
        - `kong_oauth2`: Kong OAuth plugin issued tokens verification
        - `refresh_token`: OAuth refresh token grant
        - `session`: session cookie authentication
    - group: Anonymous Access
      description: Parameter for allowing anonymous access. This parameter is disabled by default.
    - name: anonymous
      required: false
      default: null
      datatype: string
      description:
        An optional string (consumer UUID or username) value that functions as an “anonymous” consumer if authentication fails. If empty (default null), requests that fail authentication will return a `4xx` HTTP status code. This value must refer to the consumer `id` or `username` attribute, and **not** its `custom_id`.
      minimum_version: "3.1.x"  
    - name: anonymous
      required: false
      default: null
      datatype: string      
      description: |
        An optional string (consumer UUID) value to use as an anonymous consumer if authentication fails.
        If empty (default), the request will fail with an authentication failure `4xx`. Note that this value
        must refer to the consumer `id` attribute that is internal to Kong Gateway, and **not** its `custom_id`.
      maximum_version: "3.0.x"
    - group: General Settings
      description: Parameters for settings that affect different grants and flows.
    - name: preserve_query_args
      required: false
      default: false
      datatype: boolean
      description: |
        With this parameter, you can preserve request query arguments even when doing authorization code flow.
        > When this parameter is used with the `config.login_action=redirect` parameter, the browser location
        > will change and display the original query arguments. Otherwise, the upstream request
        > is modified to include the original query arguments, and the browser will not display
        > them in the location field.
    - name: refresh_tokens
      required: false
      default: true
      datatype: boolean
      description: |
        Specifies whether the plugin should try to refresh (soon to be) expired access tokens if the
        plugin has a `refresh_token` available.
    - name: hide_credentials
      required: true
      default: true
      datatype: boolean
      description: |
        Remove the credentials used for authentication from the request.
        > If multiple credentials are sent with the same request, the plugin will
        > remove those that were used for successful authentication.
    - name: search_user_info
      required: false
      default: false
      datatype: boolean
      description: |
        Specify whether to use the user info endpoint to get additional claims for consumer mapping,
        credential mapping, authenticated groups, and upstream and downstream headers.
        > This requires an extra round-trip and can add latency, but the plugin can also cache
        > user info requests (see: `config.cache_user_info`).
    - group: Discovery
      description: Parameters for auto-configuring most of the settings and providing the means for key rotation.
    - name: issuer
      required: true
      default: null
      value_in_examples: <discovery-uri>
      datatype: url
      description: |
        The discovery endpoint (or the issuer identifier).
        > When using Kong with the database, the discovery information and the JWKS
        > are cached to the Kong configuration database.
    - name: rediscovery_lifetime
      required: false
      default: 30
      datatype: integer
      description: |
        Specifies how long (in seconds) the plugin waits between discovery attempts. Discovery is still triggered on an as-needed basis.
        > The re-discovery usually happens when the plugin cannot find a key for verifying
        > the signature. For example, if a token is presented for which Kong does not have a
        > JWK cached, it will poll the discovery endpoint for new JWK data. If that discovery
        > attempt does not yield a JWK that can validate the token, Kong will wait the specified
        > number of seconds before retrying the discovery.
    - group: Client
    - name: client_id
      required: false
      value_in_examples:
        - <client-id>
      default: null
      datatype: array of string elements (the plugin supports multiple clients)
      encrypted: true
      referenceable: true
      description: |
        The client id(s) that the plugin uses when it calls authenticated endpoints on the identity provider.
        Other settings that are associated with the client are:
        - `config.client_secret`
        - `config.client_auth`
        - `config.client_jwk`
        - `config.client_alg`
        - `config.redirect_uri`
        - `config.login_redirect_uri`
        - `config.logout_redirect_uri`
        - `config.unauthorized_redirect_uri`
        - `config.forbidden_redirect_uri`
        - `config.unexpected_redirect_uri`

        Use the same array index when configuring related settings for the client.
    - name: client_arg
      required: false
      default: null
      datatype: string
      description: |
        The client to use for this request (the selection is made with a request parameter with the same name).
        For example, setting this value to `Client`, and sending the request header `Client: 1` will cause the plugin
        to use the first client (see: `config.client_id`) from the client array.
    - group: Client Authentication
      description: Parameters for configuring how the client should authenticate with the identity provider.
    - name: client_auth
      required: false
      default: (discovered or "client_secret_basic")
      datatype: array of string elements (one for each client)
      description: |
        The authentication method used by the client (plugin) when calling the endpoints:
        - `client_secret_basic`: send `client_id` and `client_secret` in `Authorization: Basic` header
        - `client_secret_post`: send `client_id` and `client_secret` as part of the body
        - `client_secret_jwt`: send client assertion signed with the `client_secret` as part of the body
        - `private_key_jwt`:  send client assertion signed with the `private key` as part of the body
        - `none`: do not authenticate


        > Private keys can be stored in a database, and they are by the default automatically generated
        > in the database. It is also possible to specify private keys with `config.client_jwk` directly
        > in the plugin configuration.
    - name: client_secret
      required: false
      value_in_examples:
        - <client-secret>
      default: null
      datatype: array of string elements (one for each client)
      encrypted: true
      referenceable: true
      description: |
        The client secret.
        > Specify one if using `client_secret_*` authentication with the client on
        > the identity provider endpoints.
    - name: client_jwk
      required: false
      default: (plugin managed)
      datatype: array of JWK records (one for each client)
      description: |
        The JWK used for the `private_key_jwt` authentication.
    - name: client_alg
      required: false
      default: '(client_secret_jwt: "HS256", private_key_jwt: "RS256")'
      datatype: array of string elements (one for each client)
      description: |
        The algorithm to use for `client_secret_jwt` (only `HS***`) or `private_key_jwt` authentication:
        - `HS256`: HMAC using SHA-256
        - `HS384`: HMAC using SHA-384
        - `HS512`: HMAC using SHA-512
        - `RS256`: RSASSA-PKCS1-v1_5 using SHA-256
        - `RS512`: RSASSA-PKCS1-v1_5 using SHA-512
        - `ES256`: ECDSA using P-256 and SHA-256
        - `ES384`: ECDSA using P-384 and SHA-384
        - `ES512`: ECDSA using P-521 and SHA-512
        - `PS256`: RSASSA-PSS using SHA-256 and MGF1 with SHA-256
        - `PS384`: RSASSA-PSS using SHA-384 and MGF1 with SHA-384
        - `PS512`: RSASSA-PSS using SHA-512 and MGF1 with SHA-512
        - `EdDSA`: EdDSA with Ed25519
    - group: JWT Access Token Authentication
      description: Parameters for specifying the location of the bearer token, and introspection options.
    - name: bearer_token_param_type
      required: false
      default:
        - header
        - query
        - body
      datatype: array of string elements
      description: |
        Where to look for the bearer token:
        - `header`: search the HTTP headers
        - `query`: search the URL's query string
        - `body`: search the HTTP request body
        - `cookie`: search the HTTP request cookies specified with `config.bearer_token_cookie_name`
    - name: bearer_token_cookie_name
      required: false
      default: null
      datatype: string
      description: The name of the cookie in which the bearer token is passed.
    - name: introspect_jwt_tokens
      required: false
      default: false
      datatype: boolean
      description: Specifies whether to introspect the JWT access tokens (can be used to check for revocations).
    - group: Client Credentials Grant
      description: Parameters specifying the location of client credentials.
    - name: client_credentials_param_type
      required: false
      default:
        - header
        - query
        - body
      datatype: array of string elements
      description: |
        Where to look for the client credentials:
        - `header`: search the HTTP headers
        - `query`: search the URL's query string
        - `body`: search from the HTTP request body
    - group: Password Grant
      description: Parameters for where to look for the username and password.
    - name: password_param_type
      required: false
      default:
        - header
        - query
        - body
      datatype: array of string elements
      description: |
        Where to look for the username and password:
        - `header`: search the HTTP headers
        - `query`: search the URL's query string
        - `body`: search the HTTP request body
    - group: Refresh Token Grant
      description: Parameters for where to look for the refresh token (rarely used as the refresh tokens are in many cases bound to the client).
    - name: refresh_token_param_type
      required: false
      default:
        - header
        - query
        - body
      datatype: array of string elements
      description: |
        Where to look for the refresh token:
        - `header`: search the HTTP headers
        - `query`: search the URL's query string
        - `body`: search the HTTP request body
    - name: refresh_token_param_name
      required: false
      default: null
      datatype: string
      description: The name of the parameter used to pass the refresh token.
    - group: ID Token
      description: Parameters for where to look for the id token (rarely sent as part of the request).
    - name: id_token_param_type
      required: false
      default:
        - header
        - query
        - body
      datatype: array of string elements
      description: |
        Where to look for the id token:
        - `header`: search the HTTP headers
        - `query`: search the URL's query string
        - `body`: search the HTTP request body
    - name: id_token_param_name
      required: false
      default: null
      datatype: string
      description: The name of the parameter used to pass the id token.
    - group: Consumer Mapping
      description: Parameters for mapping external identity provider managed identities to Kong managed ones.
    - name: admin_claim
      minimum_version: "2.7.x"
      required: false
      default: null
      datatype: string
      description: The claim used for admin mapping for Kong Manager. Required if mapping IdP claims to Kong Manager admins.
    - name: consumer_claim
      required: false
      default: null
      datatype: array of string elements
      description: The claim used for consumer mapping.
    - name: consumer_by
      required: false
      default:
        - username
        - custom_id
      datatype: array of string elements
      description: |
        Consumer fields used for mapping:
        - `id`: try to find the matching Consumer by `id`
        - `username`: try to find the matching Consumer by `username`
        - `custom_id`: try to find the matching Consumer by `custom_id`
    - name: by_username_ignore_case
      minimum_version: "2.6.x"
      required: false
      default: false
      datatype: boolean
      description: 'If `consumer_by` is set to `username`, specify whether `username` can match consumers case-insensitively.'
    - name: consumer_optional
      required: false
      default: false
      datatype: boolean
      description: Do not terminate the request if consumer mapping fails.
    - group: Credential Mapping
      description: Parameters for mapping external identity provider managed identities to a Kong credential (virtual in this case).
    - name: credential_claim
      required: false
      default:
        - sub
      datatype: array of string elements
      description: 'The claim used to derive virtual credentials (e.g. to be consumed by the rate-limiting plugin), in case the consumer mapping is not used.'
    - group: Issuer Verification
    - name: issuers_allowed
      minimum_version: "2.2.x"
      required: false
      default: (discovered issuer)
      datatype: array of string elements
      description: The issuers allowed to be present in the tokens (`iss` claim).
    - group: Authorization
    - name: authenticated_groups_claim
      required: false
      default: null
      datatype: array of string elements
      description: |
        The claim that contains authenticated groups. This setting can be used together
        with ACL plugin, but it also enables IdP managed groups with other applications
        and integrations (for example, Kong Manager and Dev Portal). The OpenID Connect
        plugin itself does not do anything other than set the context value.
    - name: scopes_required
      required: false
      default: (discovered issuer)
      datatype: array of string elements
      description: |
        The scopes (`scopes_claim` claim) required to be present in the access token (or introspection results) for successful authorization. This config parameter works in both **AND** / **OR** cases.
        - When `["scope1 scope2"]` are in the same array indices, both `scope1` AND `scope2` need to be present in access token (or introspection results).
        - When `["scope1", "scope2"]` are in different array indices, either `scope1` OR `scope2` need to be present in access token (or introspection results).
    - name: scopes_claim
      required: false
      default:
        - scope
      datatype: array of string elements
      description: The claim that contains the scopes.
    - name: audience_required
      required: false
      default: null
      datatype: array of string elements
      description: |
        The audiences (`audience_claim` claim) required to be present in the access token (or introspection results) for successful authorization. This config parameter works in both **AND** / **OR** cases.
        - When `["audience1 audience2"]` are in the same array indices, both `audience1` AND `audience2` need to be present in access token (or introspection results).
        - When `["audience1", "audience2"]` are in different array indices, either `audience1` OR `audience2` need to be present in access token (or introspection results).
    - name: audience_claim
      required: false
      default:
        - aud
      datatype: array of string elements
      description: The claim that contains the audience.
    - name: groups_required
      required: false
      default: null
      datatype: array of string elements
      description: |
        The groups (`groups_claim` claim) required to be present in the access token (or introspection results) for successful authorization. This config parameter works in both **AND** / **OR** cases.
        - When `["group1 group2"]` are in the same array indices, both `group1` AND `group2` need to be present in access token (or introspection results).
        - When `["group1", "group2"]` are in different array indices, either `group1` OR `group2` need to be present in access token (or introspection results).
    - name: groups_claim
      required: false
      default:
        - groups
      datatype: array of string elements
      description: The claim that contains the groups.
    - name: roles_required
      required: false
      default: null
      datatype: array of string elements
      description: |
        The roles (`roles_claim` claim) required to be present in the access token (or introspection results) for successful authorization. This config parameter works in both **AND** / **OR** cases.
        - When `["role1 role2"]` are in the same array indices, both `role1` AND `role2` need to be present in access token (or introspection results).
        - When `["role1", "role2"]` are in different array indices, either `role1` OR `role2` need to be present in access token (or introspection results).
    - name: roles_claim
      required: false
      default:
        - roles
      datatype: array of string elements
      description: The claim that contains the roles.
    - group: Claims Verification
      description: Parameters for verification rules for standard claims.
    - name: verify_claims
      required: false
      default: true
      datatype: boolean
      description: Verify tokens for standard claims.
    - name: leeway
      required: false
      default: 0
      datatype: integer
      description: Allow some leeway on the ttl / expiry verification.
    - name: domains
      required: false
      default: null
      datatype: array of string elements
      description: The allowed values for the `hd` claim.
    - name: max_age
      required: false
      default: null
      datatype: integer
      description: The maximum age (in seconds) compared to the `auth_time` claim.
    - name: jwt_session_claim
      required: false
      default: '"sid"'
      datatype: string
      description: The claim to match against the JWT session cookie.
    - name: jwt_session_cookie
      required: false
      default: null
      datatype: string
      description: The name of the JWT session cookie.
    - group: Signature Verification
    - name: verify_signature
      required: false
      default: true
      datatype: boolean
      description: Verify signature of tokens.
    - name: enable_hs_signatures
      required: false
      default: false
      datatype: boolean
      description: 'Enable shared secret, for example, HS256, signatures (when disabled they will not be accepted).'
    - name: ignore_signature
      required: false
      default: null
      datatype: array of string elements
      description: |
        Skip the token signature verification on certain grants:
        - `password`: OAuth password grant
        - `client_credentials`: OAuth client credentials grant
        - `authorization_code`: authorization code flow
        - `refresh_token`: OAuth refresh token grant
        - `session`: session cookie authentication
        - `introspection`: OAuth introspection
        - `userinfo`: OpenID Connect user info endpoint authentication
    - name: extra_jwks_uris
      required: false
      default: null
      datatype: array of string elements
      description: JWKS URIs whose public keys are trusted (in addition to the keys found with the discovery).
    - group: Authorization Code Flow Verification
    - name: verify_nonce
      required: false
      default: true
      datatype: boolean
      description: Verify nonce on authorization code flow.
    - group: Introspection Verification
    - name: introspection_check_active
      required: false
      default: true
      datatype: boolean
      description: Check that the introspection response has an `active` claim with a value of `true`.
    - group: Configuration Verification
    - name: verify_parameters
      required: false
      default: false
      datatype: boolean
      description: Verify plugin configuration against discovery.
    - group: Upstream Headers
      description: Parameters for the headers for the upstream service request.
    - name: upstream_headers_claims
      required: false
      default: null
      datatype: array of string elements
      description: The upstream header claims.
    - name: upstream_headers_names
      required: false
      default: null
      datatype: array of string elements
      description: The upstream header names for the claim values.
    - name: upstream_access_token_header
      required: false
      default: 'authorization:bearer'
      datatype: string
      description: The upstream access token header.
    - name: upstream_access_token_jwk_header
      required: false
      default: null
      datatype: string
      description: The upstream access token JWK header.
    - name: upstream_id_token_header
      required: false
      default: null
      datatype: string
      description: The upstream id token header.
    - name: upstream_id_token_jwk_header
      required: false
      default: null
      datatype: string
      description: The upstream id token JWK header.
    - name: upstream_refresh_token_header
      required: false
      default: null
      datatype: string
      description: The upstream refresh token header.
    - name: upstream_user_info_header
      required: false
      default: null
      datatype: string
      description: The upstream user info header.
    - name: upstream_user_info_jwt_header
      required: false
      default: null
      datatype: string
      description: The upstream user info JWT header (in case the user info returns a JWT response).
    - name: upstream_introspection_header
      required: false
      default: null
      datatype: string
      description: The upstream introspection header.
    - name: upstream_introspection_jwt_header
      required: false
      default: null
      datatype: string
      description: The upstream introspection header (in case the introspection returns a JWT response).
    - name: upstream_session_id_header
      required: false
      default: null
      datatype: string
      description: The upstream session id header.
    - group: Downstream Headers
      description: Parameters for the headers for the downstream response.
    - name: downstream_headers_claims
      required: false
      default: null
      datatype: array of string elements
      description: The downstream header claims.
    - name: downstream_headers_names
      required: false
      default: null
      datatype: array of string elements
      description: The downstream header names for the claim values.
    - name: downstream_access_token_header
      required: false
      default: 'authorization:bearer'
      datatype: string
      description: The downstream access token header.
    - name: downstream_access_token_jwk_header
      required: false
      default: null
      datatype: string
      description: The downstream access token JWK header.
    - name: downstream_id_token_header
      required: false
      default: null
      datatype: string
      description: The downstream id token header.
    - name: downstream_id_token_jwk_header
      required: false
      default: null
      datatype: string
      description: The downstream id token JWK header.
    - name: downstream_refresh_token_header
      required: false
      default: null
      datatype: string
      description: The downstream refresh token header.
    - name: downstream_user_info_header
      required: false
      default: null
      datatype: string
      description: The downstream user info header.
    - name: downstream_user_info_jwt_header
      required: false
      default: null
      datatype: string
      description: The downstream user info JWT header (in case the user info returns a JWT response).
    - name: downstream_introspection_header
      required: false
      default: null
      datatype: string
      description: The downstream introspection header.
    - name: downstream_introspection_jwt_header
      required: false
      default: null
      datatype: string
      description: The downstream introspection header (in case the introspection returns a JWT response).
    - name: downstream_session_id_header
      required: false
      default: null
      datatype: string
      description: The downstream session id header.
    - group: Cross-Origin Resource Sharing (CORS)
    - name: run_on_preflight
      required: false
      default: true
      datatype: boolean
      description: Specifies whether to run this plugin on pre-flight (`OPTIONS`) requests.
    - group: Login
      description: Parameters for what action the plugin completes after a successful login.
    - name: login_methods
      required: false
      default:
        - authorization_code
      datatype: array of string elements
      description: |
        Enable login functionality with specified grants:
        - `password`: enable for OAuth password grant
        - `client_credentials`: enable OAuth client credentials grant
        - `authorization_code`: enable for authorization code flow
        - `bearer`: enable for JWT access token authentication
        - `introspection`: enable for OAuth introspection authentication
        - `userinfo`: enable for OpenID Connect user info endpoint authentication
        - `kong_oauth2`: enable for Kong OAuth Plugin authentication
        - `refresh_token`: enable for OAuth refresh token grant
        - `session`: enable for session cookie authentication
    - name: login_action
      required: false
      default: '"upstream"'
      datatype: string
      description: |
        What to do after successful login:
        - `upstream`: proxy request to upstream service
        - `response`: terminate request with a response
        - `redirect`: redirect to a different location
    - name: login_tokens
      required: false
      default:
        - id_token
      datatype: array of string elements
      description: |
        What tokens to include in `response` body or `redirect` query string or fragment:
        - `id_token`: include id token
        - `access_token`: include access token
        - `refresh_token`: include refresh token
        - `tokens`: include the full token endpoint response
        - `introspection`: include introspection response
    - name: login_redirect_mode
      required: false
      default: '"fragment"'
      datatype: string
      description: |
        Where to place `login_tokens` when using `redirect` `login_action`:
        - `query`: place tokens in query string
        - `fragment`: place tokens in url fragment (not readable by servers)
    - name: login_redirect_uri
      required: false
      default: null
      datatype: array of urls (one for each client)
      description: |
        Where to redirect the client when `login_action` is set to `redirect`.
        > Tip: Leave this empty and the plugin will redirect the client to the URL that originally initiated the
        > flow with possible query args preserved from the original request when `config.preserve_query_args`
        > is enabled.
    - group: Logout
      description: Parameters for triggering logout with the plugin and the actions to take on logout.
    - name: logout_query_arg
      required: false
      default: null
      datatype: string
      description: The request query argument that activates the logout.
    - name: logout_post_arg
      required: false
      default: null
      datatype: string
      description: The request body argument that activates the logout.
    - name: logout_uri_suffix
      required: false
      default: null
      datatype: string
      description: The request URI suffix that activates the logout.
    - name: logout_methods
      required: false
      default: null
      datatype: array of string elements
      description: |
        The request methods that can activate the logout:
        - `POST`: HTTP POST method
        - `GET`: HTTP GET method
        - `DELETE`: HTTP DELETE method
    - name: logout_revoke
      required: false
      default: false
      datatype: boolean
      description: Revoke tokens as part of the logout.
    - name: logout_revoke_access_token
      required: false
      default: true
      datatype: boolean
      description: Revoke the access token as part of the logout.
    - name: logout_revoke_refresh_token
      required: false
      default: true
      datatype: boolean
      description: Revoke the refresh token as part of the logout.
    - name: logout_redirect_uri
      required: false
      default: null
      datatype: array of urls (one for each client)
      description: Where to redirect the client after the logout.
    - group: Unauthorized
      description: Parameters for how to handle unauthorized requests.
    - name: unauthorized_redirect_uri
      required: false
      default: null
      datatype: array of urls (one for each client)
      description: Where to redirect the client on unauthorized requests.
    - name: unauthorized_error_message
      required: false
      default: '"Forbidden"'
      datatype: string
      description: The error message for the unauthorized requests (when not using the redirection).
    - group: Forbidden
      description: Parameters for how to handle forbidden requests.
    - name: forbidden_redirect_uri
      required: false
      default: null
      datatype: array of urls (one for each client)
      description: Where to redirect the client on forbidden requests.
    - name: forbidden_error_message
      required: false
      default: '"Forbidden"'
      datatype: string
      description: The error message for the forbidden requests (when not using the redirection).
    - name: forbidden_destroy_session
      required: false
      default: true
      datatype: boolean
      description: Destroy any active session for the forbidden requests.
    - group: Errors
      description: Parameters for how to handle unexpected errors.
    - name: unexpected_redirect_uri
      required: false
      default: null
      datatype: array of urls (one for each client)
      description: Where to redirect the client when unexpected errors happen with the requests.
    - name: display_errors
      required: false
      default: false
      datatype: boolean
      description: Display errors on failure responses.
    - group: Authorization Cookie
      description: Parameters used during authorization code flow for verification and preserving settings.
    - name: authorization_cookie_name
      required: false
      default: '"authorization"'
      datatype: string
      description: The authorization cookie name.
    - name: authorization_cookie_lifetime
      maximum_version: "3.1.x"
      required: false
      default: 600
      datatype: integer
      description: The authorization cookie lifetime in seconds.
    - name: authorization_rolling_timeout
      minimum_version: "3.2.x"
      required: false
      default: 600
      datatype: integer
      description: |
        The authorization cookie rolling timeout in seconds.
        Specifies how long the authorization cookie can be used until it needs to be renewed.
    - name: authorization_cookie_path
      required: false
      default: '"/"'
      datatype: string
      description: The authorization cookie Path flag.
    - name: authorization_cookie_domain
      required: false
      default: null
      datatype: string
      description: The authorization cookie Domain flag.
    - name: authorization_cookie_samesite
      maximum_version: "3.1.x"
      required: false
      default: '"off"'
      datatype: string
      description: |
        Controls whether a cookie is sent with cross-origin requests, providing some protection against cross-site request forgery attacks:
        - `Strict`: Cookies will only be sent in a first-party context and not be sent along with requests initiated by third party websites.
        - `Lax`: Cookies are not sent on normal cross-site subrequests (for example to load images or frames into a third party site), but are sent when a user is navigating to the origin site (for instance, when following a link).
        - `None`: Cookies will be sent in all contexts, for example in responses to both first-party and cross-origin requests. If `SameSite=None` is set, the cookie Secure attribute must also be set (or the cookie will be blocked).
        - `off`: Do not set the SameSite flag.
    - name: authorization_cookie_same_site
      minimum_version: "3.2.x"
      required: false
      default: '"Default"'
      datatype: string
      description: |
        Controls whether a cookie is sent with cross-origin requests, providing some protection against cross-site request forgery attacks:
        - `Strict`: Cookies will only be sent in a first-party context and not be sent along with requests initiated by third party websites.
        - `Lax`: Cookies are not sent on normal cross-site subrequests (for example to load images or frames into a third party site), but are sent when a user is navigating to the origin site (for instance, when following a link).
        - `None`: Cookies will be sent in all contexts, for example in responses to both first-party and cross-origin requests. If `SameSite=None` is set, the cookie Secure attribute must also be set (or the cookie will be blocked).
        - `Default`: Do not explicitly specify a SameSite attribute.
    - name: authorization_cookie_httponly
      maximum_version: "3.1.x"
      required: false
      default: true
      datatype: boolean
      description: | 
        Forbids JavaScript from accessing the cookie, for example, through the `Document.cookie` property.
    - name: authorization_cookie_http_only
      minimum_version: "3.2.x"
      required: false
      default: true
      datatype: boolean
      description: 'Forbids JavaScript from accessing the cookie, for example, through the `Document.cookie` property.'
    - name: authorization_cookie_secure
      required: false
      default: (from the request scheme)
      datatype: boolean
      description: |
        Cookie is only sent to the server when a request is made with the https: scheme (except on localhost),
        and therefore is more resistant to man-in-the-middle attacks.
    - group: Session Cookie
      description: Parameters used with the session cookie authentication.
    - name: session_cookie_name
      required: false
      default: '"session"'
      datatype: string
      description: The session cookie name.
    - name: session_cookie_lifetime
      maximum_version: "3.1.x"
      required: false
      default: 3600
      datatype: integer
      description: The session cookie lifetime in seconds.
    - name: session_rolling_timeout
      minimum_version: "3.2.x"
      required: false
      default: 3600
      datatype: integer
      description: |
        The session cookie rolling timeout in seconds.
        Specifies how long the session can be used until it needs to be renewed.
    - name: session_absolute_timeout
      minimum_version: "3.2.x"
      required: false
      default: 86400
      datatype: integer
      description: |
        The session cookie absolute timeout in seconds.
        Specifies how long the session can be used until it is no longer valid.
    - name: session_cookie_idletime
      maximum_version: "3.1.x"
      required: false
      default: null
      datatype: integer
      description: The session cookie idle time in seconds.
    - name: session_idling_timeout
      minimum_version: "3.2.x"
      required: false
      default: 900
      datatype: integer
      description: The session cookie idle time in seconds.
    - name: session_cookie_renew
      maximum_version: "3.1.x"
      required: false
      default: 600
      datatype: integer
      description: The number of seconds prior to the `session_cookie_lifetime` that the session cookie will be renewed.
    - name: session_cookie_path
      required: false
      default: '"/"'
      datatype: string
      description: The session cookie Path flag.
    - name: session_cookie_domain
      required: false
      default: null
      datatype: string
      description: The session cookie Domain flag.
    - name: session_cookie_samesite
      maximum_version: "3.1.x"
      required: false
      default: '"Lax"'
      datatype: string
      description: |
        Controls whether a cookie is sent with cross-origin requests, providing some protection against cross-site request forgery attacks:
        - `Strict`: Cookies will only be sent in a first-party context and not be sent along with requests initiated by third party websites.
        - `Lax`: Cookies are not sent on normal cross-site subrequests (for example to load images or frames into a third party site), but are sent when a user is navigating to the origin site (for example, when following a link).
        - `None`: Cookies will be sent in all contexts, for example in responses to both first-party and cross-origin requests. If SameSite=None is set, the cookie Secure attribute must also be set (or the cookie will be blocked)
        - `off`: Do not set the SameSite flag.
    - name: session_cookie_same_site
      minimum_version: "3.2.x"
      required: false
      default: '"Lax"'
      datatype: string
      description: |
        Controls whether a cookie is sent with cross-origin requests, providing some protection against cross-site request forgery attacks:
        - `Strict`: Cookies will only be sent in a first-party context and aren't sent along with requests initiated by third party websites.
        - `Lax`: Cookies are not sent on normal cross-site subrequests (for example to load images or frames into a third party site), but are sent when a user is navigating to the origin site (for example, when following a link).
        - `None`: Cookies will be sent in all contexts, for example in responses to both first party and cross-origin requests. If `SameSite=None` is set, the cookie `Secure` attribute must also be set, or the cookie will be blocked.
        - `Default`: Do not explicitly specify a `SameSite` attribute.
    - name: session_cookie_httponly
      maximum_version: "3.1.x"
      required: false
      default: true
      datatype: boolean
      description: |
        Forbids JavaScript from accessing the cookie, for example, through the `Document.cookie` property.
    - name: session_cookie_http_only
      minimum_version: "3.2.x"
      required: false
      default: true
      datatype: boolean
      description: 'Forbids JavaScript from accessing the cookie, for example, through the `Document.cookie` property.'
    - name: session_cookie_secure
      required: false
      default: (from the request scheme)
      datatype: boolean
      description: |
        Cookie is only sent to the server when a request is made with the https: scheme (except on localhost),
        and therefore is more resistant to man-in-the-middle attacks.
    - name: session_cookie_maxsize
      maximum_version: "3.1.x"
      required: false
      default: 4000
      datatype: integer
      description: The maximum size of each cookie chunk in bytes.
    - group: Session Settings
    - name: session_secret
      required: false
      default: '(with database, or traditional mode, the value is auto-generated and stored along the issuer discovery information in the database)'
      datatype: string
      encrypted: true
      value_in_examples: <session-secret>
      referenceable: true
      description: |
        The session secret.
    - name: disable_session
      required: false
      default: null
      datatype: array of string elements
      description: |
        Disable issuing the session cookie with the specified grants:
        - `password`: do not start a session with the password grant
        - `client_credentials`: do not start a session with the client credentials grant
        - `authorization_code`: do not start a session after authorization code flow
        - `bearer`: do not start session with JWT access token authentication
        - `introspection`: do not start session with introspection authentication
        - `userinfo`: do not start session with user info authentication
        - `kong_oauth2`: do not start session with Kong OAuth authentication
        - `refresh_token` do not start session with refresh token grant
        - `session`: do not renew the session with session cookie authentication
    - name: session_strategy
      maximum_version: "3.1.x"
      required: false
      default: '"default"'
      datatype: string
      description: |
        The session strategy:
        - `default`:  reuses session identifiers over modifications (but can be problematic with single-page applications with a lot of concurrent asynchronous requests)
        - `regenerate`: generates a new session identifier on each modification and does not use expiry for signature verification (useful in single-page applications or SPAs)
    - name: session_compressor
      maximum_version: "3.1.x"
      required: false
      default: '"none"'
      datatype: string
      description: |
        The session strategy:
        - `none`: no compression
        - `zlib`: use zlib to compress cookie data
    - name: session_audience
      minimum_version: "3.2.x"
      required: false
      default: '"default"'
      datatype: string
      description: The session audience, which is the intended target application. For example `"my-application"`.
    - name: session_remember
      minimum_version: "3.2.x"
      required: false
      default: false
      datatype: boolean
      description: Enables or disables persistent sessions.
    - name: session_remember_cookie_name
      minimum_version: "3.2.x"
      required: false
      default: '"remember"'
      datatype: string
      description: Persistent session cookie name. Use with the `remember` configuration parameter.
    - name: session_remember_rolling_timeout
      minimum_version: "3.2.x"
      required: false
      default: 604800
      datatype: integer
      description: The persistent session rolling timeout window, in seconds.
    - name: session_remember_absolute_timeout
      minimum_version: "3.2.x"
      required: false
      default: 2592000
      datatype: integer
      description: The persistent session absolute timeout limit, in seconds.
    - name: session_request_headers
      minimum_version: "3.2.x"
      required: false
      default: null
      datatype: array of string elements
      description: |
        List of information to include, as headers, in the request to the upstream. 
        Accepted values are: `id`, `audience`, `subject`, `timeout`, `idling-timeout`, `rolling-timeout`, and
        `absolute-timeout`.
        For example, `{ "id", "timeout" }` sets both `Session-Id` and `Session-Timeout` in the request headers.
    - name: session_response_headers
      minimum_version: "3.2.x"
      required: false
      default: null
      datatype: array of string elements
      description: |
        List of information to include, as headers, in the response to the downstream. 
        Accepted values are: `id`, `audience`, `subject`, `timeout`, `idling-timeout`, `rolling-timeout`, and
        `absolute-timeout`.
        For example: `{ "id", "timeout" }` injects both `Session-Id` and `Session-Timeout` in the response headers.
    - name: session_store_metadata
      minimum_version: "3.2.x"
      required: false
      default: false
      datatype: boolean
      description: | 
        Configures whether or not session metadata should be stored.
        This metadata includes information about the active sessions for a specific audience
        belonging to a specific subject.
    - name: session_enforce_same_subject
      minimum_version: "3.2.x"
      required: false
      default: false
      datatype: boolean
      description: When set to `true`, audiences are forced to share the same subject.
    - name: session_hash_subject
      minimum_version: "3.2.x"
      required: false
      default: false
      datatype: boolean
      description: |
        When set to `true`, the value of subject is hashed before being stored.
        Only applies when `session_store_metadata` is enabled.
    - name: session_hash_storage_key
      minimum_version: "3.2.x"
      required: false
      default: false
      datatype: boolean
      description: |
        When set to `true`, the storage key (session ID) is hashed for extra security.
        Hashing the storage key means it is impossible to decrypt data from the storage
        without a cookie.
    - name: session_storage
      required: false
      default: '"cookie"'
      datatype: string
      description: |
        The session storage for session data:
        - `cookie`: stores session data with the session cookie (the session cannot be invalidated or revoked without changing session secret, but is stateless, and doesn't require a database)
        - `memcache`: stores session data in memcached
        - `redis`: stores session data in Redis
    - name: reverify
      required: false
      default: false
      datatype: boolean
      description: Specifies whether to always verify tokens stored in the session.
    - group: Session Settings for Memcached
    - name: session_memcache_prefix
      maximum_version: "3.1.x"
      required: false
      default: '"sessions"'
      datatype: string
      description: The memcached session key prefix.
    - name: session_memcached_prefix
      minimum_version: "3.2.x"
      required: false
      default: '"sessions"'
      datatype: string
      description: The memcached session key prefix.
    - name: session_memcache_socket
      maximum_version: "3.1.x"
      required: false
      default: null
      datatype: string
      description: The memcached unix socket path.
    - name: session_memcached_socket
      minimum_version: "3.2.x"
      required: false
      default: null
      datatype: string
      description: The memcached unix socket path.
    - name: session_memcache_host
      maximum_version: "3.1.x"
      required: false
      default: '"127.0.0.1"'
      datatype: string
      description: The memcached host.
    - name: session_memcached_host
      minimum_version: "3.2.x"
      required: false
      default: '"127.0.0.1"'
      datatype: string
      description: The memcached host.
    - name: session_memcache_port
      maximum_version: "3.1.x"
      required: false
      default: 11211
      datatype: integer
      description: The memcached port.
    - name: session_memcached_port
      minimum_version: "3.2.x"
      required: false
      default: 11211
      datatype: integer
      description: The memcached port.
    - group: Session Settings for Redis
    - name: session_redis_prefix
      required: false
      default: '"sessions"'
      datatype: string
      description: The Redis session key prefix.
    - name: session_redis_socket
      required: false
      default: null
      datatype: string
      description: The Redis unix socket path.
    - name: session_redis_host
      required: false
      default: '"127.0.0.1"'
      datatype: string
      description: The Redis host
    - name: session_redis_port
      required: false
      default: 6379
      datatype: integer
      description: The Redis port.
    - name: session_redis_username
      minimum_version: "2.8.x"
      required: false
      default: null
      datatype: string
      referenceable: true
      description: |
        Username to use for Redis connection when the `redis` session storage is defined and ACL authentication is desired.
        If undefined, ACL authentication will not be performed.

        This requires Redis v6.0.0+. The username **cannot** be set to `default`.
    - name: session_redis_password
      minimum_version: "2.8.x"
      required: false
      default: (from kong)
      encrypted: true
      datatype: string
      referenceable: true
      description: |
        Password to use for Redis connection when the `redis` session storage is defined.
        If undefined, no AUTH commands are sent to Redis.
    - name: session_redis_auth
      maximum_version: "2.8.x"
      required: false
      default: (from kong)
      encrypted: true
      datatype: string
      description: |
        Password to use for Redis connection when the `redis` session storage is defined.
        If undefined, no AUTH commands are sent to Redis.

        {:.important}
        > In Kong Gateway 2.8.x, this field is deprecated and replaced with `session_redis_password`.
        > The`session_redis_auth` field will continue to work in a backwards compatible way,
        > but it is recommended to use the replacement field.
        >
        > Starting from Kong Gateway 3.0.0.0, this field has been removed.

    - name: session_redis_connect_timeout
      required: false
      default: (from kong)
      datatype: integer
      description: The Redis connection timeout in milliseconds.
    - name: session_redis_read_timeout
      required: false
      default: (from kong)
      datatype: integer
      description: The Redis read timeout in milliseconds.
    - name: session_redis_send_timeout
      required: false
      default: (from kong)
      datatype: integer
      description: The Redis send timeout in milliseconds.
    - name: session_redis_ssl
      required: false
      default: false
      datatype: boolean
      description: Use SSL/TLS for Redis connection.
    - name: session_redis_ssl_verify
      required: false
      default: false
      datatype: boolean
      description: Verify Redis server certificate.
    - name: session_redis_server_name
      required: false
      default: null
      datatype: string
      description: The SNI used for connecting the Redis server.

    - name: session_redis_cluster_nodes # old parameter version
      maximum_version: "2.5.x"
      required: false
      default: null
      datatype: array of host records
      description: |
        The Redis cluster node host. Takes an array of host records, with
        `ip` and `port` values.

    - name: session_redis_cluster_nodes # current parameter version
      minimum_version: "2.6.x"
      required: false
      default: null
      datatype: array of host records
      description: |
        The Redis cluster node host. Takes an array of host records, with
        either `ip` or `host`, and `port` values.

    - name: session_redis_cluster_maxredirections
      maximum_version: "3.1.x"
      required: false
      default: null
      datatype: integer
      description: The Redis cluster maximum redirects.
    - name: session_redis_cluster_max_redirections
      minimum_version: "3.2.x"
      required: false
      default: null
      datatype: integer
      description: The Redis cluster maximum redirects.
    - group: Endpoints
      description: Parameters normally not needed as the endpoints are discovered.
    - name: authorization_endpoint
      required: false
      default: (discovered uri)
      datatype: url
      description: The authorization endpoint.
    - name: token_endpoint
      required: false
      default: (discovered uri)
      datatype: url
      description: The token endpoint.
    - name: introspection_endpoint
      required: false
      default: (discovered uri)
      datatype: url
      description: The introspection endpoint.
    - name: revocation_endpoint
      required: false
      default: (discovered uri)
      datatype: url
      description: The revocation endpoint.
    - name: userinfo_endpoint
      minimum_version: "2.2.x"
      required: false
      default: (discovered uri)
      datatype: url
      description: The user info endpoint.
    - name: end_session_endpoint
      required: false
      default: (discovered uri)
      datatype: url
      description: The end session endpoint.
    - name: token_exchange_endpoint
      required: false
      default: (discovered uri)
      datatype: url
      description: The token exchange endpoint.
    - group: Endpoint Authentication
      description: Parameters normally not needed as the client authentication can be specified for the client.
    - name: token_endpoint_auth_method
      required: false
      default: '(see: config.client_auth)'
      datatype: string
      description: |
        The token endpoint authentication method:
        - `client_secret_basic`: send `client_id` and `client_secret` in `Authorization: Basic` header
        - `client_secret_post`: send `client_id` and `client_secret` as part of the body
        - `client_secret_jwt`: send client assertion signed with the `client_secret` as part of the body
        - `private_key_jwt`:  send client assertion signed with the `private key` as part of the body
        - `none`: do not authenticate
    - name: introspection_endpoint_auth_method
      required: false
      default: '(see: config.client_auth)'
      datatype: string
      description: |
        The introspection endpoint authentication method:
        - `client_secret_basic`: send `client_id` and `client_secret` in `Authorization: Basic` header
        - `client_secret_post`: send `client_id` and `client_secret` as part of the body
        - `client_secret_jwt`: send client assertion signed with the `client_secret` as part of the body
        - `private_key_jwt`:  send client assertion signed with the `private key` as part of the body
        - `none`: do not authenticate
    - name: revocation_endpoint_auth_method
      required: false
      default: '(see: config.client_auth)'
      datatype: string
      description: |
        The revocation endpoint authentication method:
        - `client_secret_basic`: send `client_id` and `client_secret` in `Authorization: Basic` header
        - `client_secret_post`: send `client_id` and `client_secret` as part of the body
        - `client_secret_jwt`: send client assertion signed with the `client_secret` as part of the body
        - `private_key_jwt`:  send client assertion signed with the `private key` as part of the body
        - `none`: do not authenticate
    - group: Discovery Endpoint Arguments
    - name: discovery_headers_names
      required: false
      default: null
      datatype: array of string elements
      description: Extra header names passed to the discovery endpoint.
    - name: discovery_headers_values
      required: false
      default: null
      datatype: array of string elements
      description: Extra header values passed to the discovery endpoint.
    - group: Authorization Endpoint Arguments
    - name: response_mode
      required: false
      default: '"query"'
      datatype: string
      value_in_examples: form_post
      description: |
        The response mode passed to the authorization endpoint:
        - `query`: Instructs the identity provider to pass parameters in query string
        - `form_post`: Instructs the identity provider to pass parameters in request body
        - `fragment`: Instructs the identity provider to pass parameters in uri fragment (rarely useful as the plugin itself cannot read it)
    - name: response_type
      required: false
      default:
        - code
      datatype: array of string elements
      description: The response type passed to the authorization endpoint.
    - name: scopes
      required: false
      default:
        - openid
      datatype: array of string elements
      description: The scopes passed to the authorization and token endpoints.
    - name: audience
      required: false
      default: null
      datatype: array of string elements
      description: The audience passed to the authorization endpoint.
    - name: redirect_uri
      required: false
      default: (request uri)
      datatype: array of urls (one for each client)
      description: The redirect URI passed to the authorization and token endpoints.
    - name: authorization_query_args_names
      required: false
      default: null
      datatype: array of string elements
      description: Extra query argument names passed to the authorization endpoint.
    - name: authorization_query_args_values
      required: false
      default: null
      datatype: array of string elements
      description: Extra query argument values passed to the authorization endpoint.
    - name: authorization_query_args_client
      required: false
      default: null
      datatype: array of string elements
      description: Extra query arguments passed from the client to the authorization endpoint.
    - group: Token Endpoint Arguments
    - name: token_headers_names
      required: false
      default: null
      datatype: array of string elements
      description: Extra header names passed to the token endpoint.
    - name: token_headers_values
      required: false
      default: null
      datatype: array of string elements
      description: Extra header values passed to the token endpoint.
    - name: token_headers_client
      required: false
      default: null
      datatype: array of string elements
      description: Extra headers passed from the client to the token endpoint.
    - name: token_post_args_names
      required: false
      default: null
      datatype: array of string elements
      description: Extra post argument names passed to the token endpoint.
    - name: token_post_args_values
      required: false
      default: null
      datatype: array of string elements
      description: Extra post argument values passed to the token endpoint.
    - name: token_post_args_client
      required: false
      default: null
      datatype: array of string elements
      description: |
        Pass extra arguments from the client to the OpenID-Connect plugin. If arguments exist, the client can pass them using:
        - Request Body
        - Query parameters

        This parameter can be used with `scope` values, like this:

        `config.token_post_args_client=scope`

        In this case, the token would take the `scope` value from the query parameter or from the request body and send it to the token endpoint.
    - group: Token Endpoint Response Headers
      description: Parameters for an uncommon use case of sending certain token endpoint headers to the downstream client.
    - name: token_headers_replay
      default: null
      datatype: array of string elements
      description: The names of token endpoint response headers to forward to the downstream client.
    - name: token_headers_prefix
      default: null
      datatype: string
      description: Add a prefix to the token endpoint response headers before forwarding them to the downstream client.
    - name: token_headers_grants
      default: null
      datatype: array of string elements
      description: |
        Enable the sending of the token endpoint response headers only with certain grants:
        - `password`: with OAuth password grant
        - `client_credentials`: with OAuth client credentials grant
        - `authorization_code`: with authorization code flow
        - `refresh_token` with refresh token grant
    - group: Introspection Endpoint Arguments
    - name: introspection_hint
      required: false
      default: '"access_token"'
      datatype: string
      description: Introspection hint parameter value passed to the introspection endpoint.
    - name: introspection_accept
      required: false
      default: '"application/json"'
      datatype: string
      description: |
        The value of `Accept` header for introspection requests:
        - `application/json`: introspection response as JSON
        - `application/token-introspection+jwt`: introspection response as JWT (from the current IETF draft document)
        - `application/jwt`: introspection response as JWT (from the obsolete IETF draft document)
    - name: introspection_headers_names
      required: false
      default: null
      datatype: array of string elements
      description: Extra header names passed to the introspection endpoint.
    - name: introspection_headers_values
      required: false
      default: null
      datatype: array of string elements
      description: Extra header values passed to the introspection endpoint.
    - name: introspection_headers_client
      required: false
      default: null
      datatype: array of string elements
      description: Extra headers passed from the client to the introspection endpoint.
    - name: introspection_post_args_names
      required: false
      default: null
      datatype: array of string elements
      description: Extra post argument names passed to the introspection endpoint.
    - name: introspection_post_args_values
      required: false
      default: null
      datatype: array of string elements
      description: Extra post argument values passed to the introspection endpoint.
    - name: introspection_post_args_client
      required: false
      default: null
      datatype: array of string elements
      description: Extra post arguments passed from the client to the introspection endpoint.
    - group: User Info Endpoint Arguments
    - name: userinfo_accept
      required: false
      default: '"application/json"'
      datatype: string
      description: |
        The value of `Accept` header for user info requests:
        - `application/json`: user info response as JSON
        - `application/jwt`: user info response as JWT (from the obsolete IETF draft document)
    - name: userinfo_headers_names
      required: false
      default: null
      datatype: array of string elements
      description: Extra header names passed to the user info endpoint.
    - name: userinfo_headers_values
      required: false
      default: null
      datatype: array of string elements
      description: Extra header values passed to the user info endpoint.
    - name: userinfo_headers_client
      required: false
      default: null
      datatype: array of string elements
      description: Extra headers passed from the client to the user info endpoint.
    - name: userinfo_query_args_names
      required: false
      default: null
      datatype: array of string elements
      description: Extra query argument names passed to the user info endpoint.
    - name: userinfo_query_args_values
      required: false
      default: null
      datatype: array of string elements
      description: Extra query argument values passed to the user info endpoint.
    - name: userinfo_query_args_client
      required: false
      default: null
      datatype: array of string elements
      description: Extra query arguments passed from the client to the user info endpoint.
    - group: HTTP Client
      description: Parameters for generic settings for the HTTP client when the plugin needs to interact with the identity provider.
    - name: keepalive
      required: false
      default: true
      datatype: boolean
      description: Use keepalive with the HTTP client.
    - name: ssl_verify
      required: false
      default: false
      datatype: boolean
      description: Verify identity provider server certificate.
    - name: timeout
      required: false
      default: 10000
      datatype: integer
      description: Network IO timeout in milliseconds.
    - name: http_version
      required: false
      default: 1.1
      datatype: number
      description: |
        The HTTP version used for the requests by this plugin:
        - `1.1`: HTTP 1.1 (the default)
        - `1.0`: HTTP 1.0
    - group: HTTP Client Proxy Settings
      description: Parameters only needed if the HTTP(S) requests to identity provider need to go through a proxy server.
    - name: http_proxy
      required: false
      default: null
      datatype: url
      description: The HTTP proxy
    - name: http_proxy_authorization
      required: false
      default: null
      datatype: string
      description: The HTTP proxy authorization.
    - name: https_proxy
      required: false
      default: null
      datatype: url
      description: The HTTPS proxy
    - name: https_proxy_authorization
      required: false
      default: null
      datatype: string
      description: The HTTPS proxy authorization.
    - name: no_proxy
      required: false
      default: null
      datatype: array of string elements
      description: Do not use proxy with these hosts.
    - group: Cache TTLs
      description: These do not apply to the discovery cache.
    - name: cache_ttl
      required: false
      default: 3600
      datatype: integer
      description: The default cache ttl in seconds that is used in case the cached object does not specify the expiry.
    - name: cache_ttl_max
      required: false
      default: null
      datatype: integer
      description: The maximum cache ttl in seconds (enforced).
    - name: cache_ttl_min
      required: false
      default: null
      datatype: integer
      description: The minimum cache ttl in seconds (enforced).
    - name: cache_ttl_neg
      required: false
      default: (derived from Kong configuration)
      datatype: integer
      description: The negative cache ttl in seconds.
    - name: cache_ttl_resurrect
      required: false
      default: (derived from Kong configuration)
      datatype: integer
      description: The resurrection ttl in seconds.
    - group: Cache Settings for the Endpoints
    - name: cache_tokens
      required: false
      default: true
      datatype: boolean
      description: Cache the token endpoint requests.
    - name: cache_tokens_salt
      required: false
      default: (auto generated)
      datatype: string
      description: |
        Salt used for generating the cache key that us used for caching the token
        endpoint requests.
        > If you use multiple plugin instances of the OpenID Connect
        > plugin and want to share token endpoint caches between the plugin
        > instances, set the salt to the same value on each plugin instance.
    - name: cache_introspection
      required: false
      default: true
      datatype: boolean
      description: Cache the introspection endpoint requests.
    - name: cache_token_exchange
      required: false
      default: true
      datatype: boolean
      description: Cache the token exchange endpoint requests.
    - name: cache_user_info
      required: false
      default: true
      datatype: boolean
      description: Cache the user info requests.
    - name: resolve_distributed_claims
      minimum_version: "2.8.x"
      required: false
      default: false
      datatype: boolean
      description: |
        Distributed claims are represented by the `_claim_names` and `_claim_sources` members
        of the JSON object containing the claims.
        If this parameter is set to `true`, the plugin explicitly resolves these distributed claims.
issuer_body: |
  Attributes | Description
  ---:| ---
  `name`<br>*optional* | The Service name.
  `retries`<br>*optional* | The number of retries to execute upon failure to proxy. Default: `5`.
  `protocol` |  The protocol used to communicate with the upstream.  Accepted values are: `"grpc"`, `"grpcs"`, `"http"`, `"https"`, `"tcp"`, `"tls"`, `"udp"`.  Default: `"http"`.
  `host` | The host of the upstream server.
  `port` | The upstream server port. Default: `80`.
  `path`<br>*optional* | The path to be used in requests to the upstream server.
  `connect_timeout`<br>*optional* |  The timeout in milliseconds for establishing a connection to the upstream server.  Default: `60000`.
  `write_timeout`<br>*optional* |  The timeout in milliseconds between two successive write operations for transmitting a request to the upstream server.  Default: `60000`.
  `read_timeout`<br>*optional* |  The timeout in milliseconds between two successive read operations for transmitting a request to the upstream server.  Default: `60000`.
  `tags`<br>*optional* |  An optional set of strings associated with the Service for grouping and filtering.
  `client_certificate`<br>*optional* |  Certificate to be used as client certificate while TLS handshaking to the upstream server. With form-encoded, the notation is `client_certificate.id=<client_certificate id>`. With JSON, use "`"client_certificate":{"id":"<client_certificate id>"}`.
  `tls_verify`<br>*optional* |  Whether to enable verification of upstream server TLS certificate. If set to `null`, then the Nginx default is respected.
  `tls_verify_depth`<br>*optional* |  Maximum depth of chain while verifying Upstream server's TLS certificate. If set to `null`, then the Nginx default is respected.  Default: `null`.
  `ca_certificates`<br>*optional* |  Array of `CA Certificate` object UUIDs that are used to build the trust store while verifying upstream server's TLS certificate. If set to `null` when Nginx default is respected. If default CA list in Nginx are not specified and TLS verification is enabled, then handshake with upstream server will always fail (because no CA are trusted).  With form-encoded, the notation is `ca_certificates[]=4e3ad2e4-0bc4-4638-8e34-c84a417ba39b&ca_certificates[]=51e77dc2-8f3e-4afa-9d0e-0e3bbbcfd515`. With JSON, use an Array.
  `url`<br>*shorthand-attribute* |  Shorthand attribute to set `protocol`, `host`, `port` and `path` at once. This attribute is write-only (the Admin API never returns the URL).
issuer_json: |
  {
      "id": "<uuid>",
      "issuer": "<config.issuer>"
      "created_at": <timestamp>,
      "configuration": {
          <discovery>
      },
      "keys": [
          <keys>
      ]
  }
issuer_data: |
  {
      "data": [{
          "id": "<uuid>",
          "issuer": "<config.issuer>"
          "created_at": <timestamp>,
          "configuration": {
              <discovery>
          },
          "keys": [
              <keys>
          ]
      }],
      "next": null
  }
host: |
  {
      "ip": "127.0.0.1"
      "port": 6379
  }
jwk: |
  {
      "kid": "B2FxBJ8G_e61tnZEfaYpaMLjswjNO3dbVEQhR7-i_9s",
      "kty": "RSA",
      "alg": "RS256",
      "use": "sig"
      "e": "AQAB",
      "n": "…",
      "d": "…",
      "p": "…",
      "q": "…",
      "dp": "…",
      "dq": "…",
      "qi": "…"
  }
jwks: |
  {
      "keys": [{
          <keys>
      }]
  }
---

---

## Records

In the above parameter list, two configuration settings used an array of records as a data type:

- `config.client_jwk`: array of JWK records (one for each client)
- `config.session_redis_cluster_nodes`: array of host records, either as IP
addresses or hostnames, and their ports.

Below are descriptions of the record types.

### JWK Record

The JSON Web Key (JWK) record is specified in [RFC7517][jwk]. This record is used with the
`config.client_jwk` when using `private_key_jwk` client authentication.

Here is an example of JWK record generated by the plugin itself (see: [JSON Web Key Set](#json-web-key-set)):

```json
{{ page.jwk }}
```

The JWK private fields (`k`, `d`, `p`, `q`, `dp`, `dq`, `qi`, `oth`, `r`, `t`) are _referenceable_,
which means they can be securely stored as a
[secret](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

### Host Record

The Host record used with the `config.session_redis_cluster_nodes` is simple.
It contains `ip` or `host`, and the `port` where the `port` defaults to `6379`.

Here is an example of Host the record:

```json
{{ page.host }}
```

## Admin API

The OpenID Connect plugin extends the [Kong Admin API][admin] with a few endpoints.

[admin]: /gateway/latest/admin-api/

### Discovery Cache

When configuring the plugin using `config.issuer`, the plugin will store the fetched discovery
information to the Kong database, or in the worker memory with DB-less. The discovery cache does
not have an expiry or TTL, and so must be cleared manually using the `DELETE` endpoints listed below.

The discovery cache will attempt to be refreshed when a token is presented with required discovery 
information that is not already available, based on the `config.issuer` value. Once a rediscovery attempt 
has been made, a new attempt will not occur until the number of seconds defined in `rediscovery_lifetime` 
has elapsed - this avoids excessive discovery requests to the identity provider.
            
If a JWT cannot be validated due to missing discovery information and an invalid status code is 
received from the rediscovery request (for example, non-2xx), the plugin will attempt to validate the JWT
by falling back to any sufficient discovery information that is still in the discovery cache.

##### Discovery Cache Object

```json
{{ page.issuer_json }}
```

#### List All Discovery Cache Objects

<div class="endpoint get indent">/openid-connect/issuers</div>


##### Response

```
HTTP 200 OK
```

```json
{{ page.issuer_data }}
```

#### Retrieve Discovery Cache Object

<div class="endpoint get indent">/openid-connect/issuers/{issuer or id}</div>

{:.indent}
Attributes | Description
---:| ---
`issuer or id`<br>**required** | The unique identifier **or** the value of `config.issuer`

##### Response

```
HTTP 200 OK
```

```json
{{ page.issuer_json }}
```

#### Delete All Discovery Cache Objects

<div class="endpoint delete indent">/openid-connect/issuers</div>

##### Response

```
HTTP 204 No Content
```

{:.note}
> **Note:** The automatically generated session secret (that can be overridden with the
`config.session_secret`) is stored with the discovery cache objects. Deleting discovery cache
objects will invalidate all the sessions created with the associated secret.

#### Delete Discovery Cache Object

<div class="endpoint delete indent">/openid-connect/issuers/{issuer or id}</div>

{:.indent}
Attributes | Description
---:| ---
`issuer or id`<br>**required** | The unique identifier **or** the value of `config.issuer`

##### Response

```
HTTP 204 No Content
```

### JSON Web Key Set

When the OpenID Connect client (the plugin) is set to communicate with the identity provider endpoints
using `private_key_jwt`, the plugin needs to use public key cryptography. Thus, the plugin needs
to generate the needed keys. Identity provider on the other hand has to verify that the assertions
used for the client authentication.

The plugin will automatically generate the key pairs for the different algorithms. It will also
publish the public keys with the admin api where the identity provider could fetch them.

```json
{{ page.jwks }}
```

#### Retrieve JWKS

<div class="endpoint get indent">/openid-connect/jwks</div>

This endpoint will return a standard [JWK Set document][jwks] with the private keys stripped out.

##### Response

```
HTTP 200 OK
```

```json
{{ page.jwks }}
```

#### Rotate JWKS

<div class="endpoint delete indent">/openid-connect/jwks</div>

Deleting JWKS will also cause auto-generation of a new JWK set, so
`DELETE` will actually cause a key rotation.

##### Response

```
HTTP 204 No Content
```

[jwk]: https://datatracker.ietf.org/doc/html/rfc7517#section-4
[jwks]: https://datatracker.ietf.org/doc/html/rfc7517#appendix-A.1
[json-web-key-set]: #json-web-key-set


## Preparations

The OpenID Connect plugin relies in most cases on a third party identity provider.
In this section, we explain configuration of Keycloak and Kong.

All the `*.test` domains in the following examples point to the `localhost` (`127.0.0.1` and/or `::1`).

### Keycloak Configuration

We use [Keycloak][keycloak] as the identity provider in the following examples,
but the steps will be similar in other standard identity providers. If you encounter
difficulties during this phase, please refer to the [Keycloak documentation](https://www.keycloak.org/documentation).

1. Create a confidential client `kong` with `private_key_jwt` authentication and configure
   Keycloak to download the public keys from [the OpenID Connect Plugin JWKS endpoint][json-web-key-set]:
   <br><br>
   <img src="/assets/images/docs/openid-connect/keycloak-client-kong-settings.png">
   <br>
   <img src="/assets/images/docs/openid-connect/keycloak-client-kong-auth.png">
   <br>
2. Create another confidential client `service` with `client_secret_basic` authentication.
   For this client, Keycloak will auto-generate a secret similar to the following: `cf4c655a-0622-4ce6-a0de-d3353ef0b714`.
   Enable the client credentials grant for the client:
   <br><br>
   <img src="/assets/images/docs/openid-connect/keycloak-client-service-settings.png">
   <br>
   <img src="/assets/images/docs/openid-connect/keycloak-client-service-auth.png">
   <br>
3. Create a verified user with the name: `john` and the non-temporary password: `doe` that can be used with the password grant:
   <br><br>
   <img src="/assets/images/docs/openid-connect/keycloak-user-john.png">

Alternatively you can [download the exported Keycloak configuration](/assets/images/docs/openid-connect/keycloak.json),
and use it to configure the Keycloak. Please refer to [Keycloak import documentation](https://www.keycloak.org/docs/latest/server_admin/#_export_import)
for more information.

You need to modify Keycloak `standalone.xml` configuration file, and change the socket binding from:

```xml
<socket-binding name="https" port="${jboss.https.port:8443}"/>
```

to

```xml
<socket-binding name="https" port="${jboss.https.port:8440}"/>
```

The Keycloak default `https` port conflicts with the default Kong TLS proxy port,
and that can be a problem if both are started on the same host.

[keycloak]: http://www.keycloak.org/

### Kong Configuration

#### Create a Service

```bash
http -f put :8001/services/openid-connect url=http://httpbin.org/anything
```
```http
HTTP/1.1 200 OK
```
```json
{
    "id": "5fa9e468-0007-4d7e-9aeb-49ca9edd6ccd",
    "name": "openid-connect",
    "protocol": "http",
    "host": "httpbin.org",
    "port": 80,
    "path": "/anything"
}
```

#### Create a Route

```bash
http -f put :8001/services/openid-connect/routes/openid-connect paths=/
```
```http
HTTP/1.1 200 OK
```
```json
{
    "id": "ac1e86bd-4bce-4544-9b30-746667aaa74a",
    "name": "openid-connect",
    "paths": [ "/" ]
}
```

#### Create a Plugin

You may execute this before patching the plugin (as seen on following examples) to reset
the plugin configuration.

```bash
http -f put :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  name=openid-connect                                          \
  service.name=openid-connect                                  \
  config.issuer=http://keycloak.test:8080/auth/realms/master   \
  config.client_id=kong                                        \
  config.client_auth=private_key_jwt
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
        "issuer": "http://keycloak.test:8080/auth/realms/master",
        "client_id": [ "kong" ],
        "client_auth": [ "private_key_jwt" ]
    }
}
```


> Also, check the discovery cache: `http :8001/openid-connect/issuers`.
> It should contain Keycloak OpenID Connect discovery document, and the keys.

#### Summary

At this point we have:

1. Created a Service
2. Routed traffic to the service
3. Enabled OpenID Connect plugin on the service

The following sections will guide you through the process of enabling the OpenID Connect
plugin for specific grants or flows.

## Authentication

Before you proceed, check that you have done [the preparations](#preparations).

We use [HTTPie](https://httpie.org/) to execute the examples. The output is stripped
for a better readability. [httpbin.org](https://httpbin.org/) is used as an upstream service.

Using Admin API is convenient when testing the plugin, but similar configs can
be done in declarative format as well.

When this plugin is configured with multiple grants/flows there is a hard-coded search
order for the credentials:

1. [Session Authentication](#session-authentication)
2. [JWT Access Token Authentication](#jwt-access-token-authentication)
3. [Kong OAuth Token Authentication](#kong-oauth-token-authentication)
4. [Introspection Authentication](#introspection-authentication)
5. [User Info Authentication](#user-info-authentication)
6. [Refresh Token Grant](#refresh-token-grant)
7. [Password Grant](#password-grant)
8. [Client Credentials Grant](#client-credentials-grant)
9. [Authorization Code Flow](#authorization-code-flow)

Once credentials are found, the plugin will stop searching further. Multiple grants may
share the same credentials. For example, both the password and client credentials grants can use 
basic access authentication through the `Authorization` header.

{:.warning}
> The choices made in the examples below are solely aimed at simplicity.
Because `httpbin.org` is used as an upstream service, it is highly recommended that you do
not run these usage examples with a production identity provider as there is a great chance
of leaking information. Also the examples below use the plain HTTP protocol that you should
never use in production. 

### Authorization Code Flow

The authorization code flow is the three-legged OAuth/OpenID Connect flow.
The sequence diagram below describes the participants and their interactions
for this usage scenario, including the use of session cookies:

<img src="/assets/images/docs/openid-connect/authorization-code-flow.svg">

#### Patch the Plugin

Let's patch the plugin that we created in the [Kong configuration](#kong-configuration) step:

1. We want to only use the authorization code flow and the session authentication.
2. We want to set the response mode to `form_post` so that authorization codes won't get logged to the access logs.
3. We want to preserve the original request query arguments over the authorization code flow redirection.
3. We want to redirect the client to original request url after the authorization code flow so that
   the `POST` request (because of `form_post`) is turned to the `GET` request, and the browser address bar is updated
   with the original request query arguments.
4. We don't want to include any tokens in the browser address bar.

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=authorization_code                         \
  config.auth_methods=session                                    \
  config.response_mode=form_post                                 \
  config.preserve_query_args=true                                \
  config.login_action=redirect                                   \
  config.login_tokens=
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
        "auth_methods": [
            "authorization_code",
            "session"
        ],
        "login_action": "redirect",
        "preserve_query_args": true,
        "login_tokens": null
    }
}
```

#### Test the Authorization Code Flow

1. Open the Service Page with some query arguments:
   ```bash
   open http://service.test:8000/?hello=world
   ```
   <img src="/assets/images/docs/openid-connect/authorization-code-flow-1.png">

2. See that the browser is redirected to the Keycloak login page:
   <br><br>
   <img src="/assets/images/docs/openid-connect/authorization-code-flow-2.png">
   <br>
   > You may examine the query arguments passed to Keycloak with the browser developer tools.
3. And finally you will be presented a response from httpbin.org:
   <br><br>
   <img src="/assets/images/docs/openid-connect/authorization-code-flow-3.png">
4. Done.

It looks rather simple from the user point of view, but what really happened is
described in [the diagram](#authorization-code-flow) above.

### Password Grant

Password grant is a legacy authentication grant. This is a less secure way of
authenticating end users than the authorization code flow, because, for example,
the passwords are shared with third parties. The image below illustrates the grant:

<img src="/assets/images/docs/openid-connect/password-grant.svg">

#### Patch the Plugin

Let's patch the plugin that we created in the [Kong configuration](#kong-configuration) step:

1. We want to only use the password grant.
2. We want to search credentials for password grant from the headers only.

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=password                                   \
  config.password_param_type=header
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
        "password_param_type": [ "header" ]
    }
}
```

#### Test the Password Grant

1. Request the service with basic authentication credentials created in the [Keycloak configuration](#keycloak-configuration) step:
   ```bash
   http -v -a john:doe :8000
   ```
   ```http
   GET / HTTP/1.1
   Authorization: Basic BEkg3bHT0ERXFmKr1qelBQYrLBeHb5Hr
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```json
   {
       "headers": {
           "Authorization": "Bearer <access-token>"
       },
       "method": "GET"
   }
   ```
2. Done.

> If you make another request using the same credentials, you should see that Kong adds less
> latency to the request as it has cached the token endpoint call to Keycloak.

### Client Credentials Grant

The client credentials grant is very similar to [the password grant](#password-grant).
The most important difference in the Kong OpenID Connect plugin is that the plugin itself
does not try to authenticate. It just forwards the credentials passed by the client
to the identity server's token endpoint. The client credentials grant is visualized
below:

<img src="/assets/images/docs/openid-connect/client-credentials-grant.svg">

#### Patch the Plugin

Let's patch the plugin that we created in the [Kong configuration](#kong-configuration) step:

1. We want to only use the client credentials grant.
2. We want to search credentials for client credentials from the headers only.

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=client_credentials                         \
  config.client_credentials_param_type=header
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
        "auth_methods": [ "client_credentials" ],
        "client_credentials_param_type": [ "header" ]
    }
}
```

#### Test the Client Credentials Grant

1. Request the service with client credentials created in the [Keycloak configuration](#keycloak-configuration) step:
   ```bash
   http -v -a service:cf4c655a-0622-4ce6-a0de-d3353ef0b714 :8000
   ```
   ```http
   GET / HTTP/1.1
   Authorization: Basic c2VydmljZTpjZjRjNjU1YS0wNjIyLTRjZTYtYTBkZS1kMzM1M2VmMGI3MTQ=
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```json
   {
       "headers": {
           "Authorization": "Bearer <access-token>"
       },
       "method": "GET"
   }
   ```
2. Done.

> If you make another request using the same credentials, you should see that Kong adds less
> latency to the request as it has cached the token endpoint call to Keycloak.

### Refresh Token Grant

The refresh token grant can be used when the client has a refresh token available. There is a caveat
with this: identity providers in general only allow refresh token grant to be executed with the same
client that originally got the refresh token, and if there is a mismatch, it may not work. The mismatch
is likely when Kong OpenID Connect is configured to use one client, and the refresh token is retrieved
with another. The grant itself is very similar to [password grant](#password-grant) and
[client credentials grant](#client-credentials-grant):

<img src="/assets/images/docs/openid-connect/refresh-token-grant.svg">

#### Patch the Plugin

Let's patch the plugin that we created in the [Kong configuration](#kong-configuration) step:

1. We want to only use the refresh token grant, but we also enable [the password grant](#password-grant) for demoing purposes
2. We want to search the refresh token for the refresh token grant from the headers only.
3. We want to pass refresh token from the client in `Refresh-Token` header.
4. We want to pass refresh token to upstream in `Refresh-Token` header.

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.refresh_token_param_name=refresh_token                  \
  config.refresh_token_param_type=header                         \
  config.auth_methods=refresh_token                              \
  config.auth_methods=password                                   \
  config.upstream_refresh_token_header=refresh_token
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
        "auth_methods": [
            "refresh_token",
            "password"
        ],
        "refresh_token_param_name": "refresh_token",
        "refresh_token_param_type": [ "header" ],
        "upstream_refresh_token_header": "refresh_token"
    }
}
```

The `config.auth_methods` and `config.upstream_refresh_token_header`
are only enabled for demoing purposes so that we can get a refresh token with:

```bash
http -a john:doe :8000 | jq -r '.headers."Refresh-Token"'
```
Output:
```
<refresh-token>
```

We can use the output in `Refresh-Token` header.

#### Test the Refresh Token Grant

1. Request the service with a bearer token:
   ```bash
   http -v :8000 Refresh-Token:$(http -a john:doe :8000 | \
     jq -r '.headers."Refresh-Token"')
   ```
   or
   ```bash
   http -v :8000 Refresh-Token:"<refresh-token>"
   ```
   ```http
   GET / HTTP/1.1
   Refresh-Token: <refresh-token>
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```json
   {
       "headers": {
           "Authorization": "Bearer <access-token>",
           "Refresh-Token": "<refresh-token>"
       },
       "method": "GET"
   }
   ```
2. Done.

### JWT Access Token Authentication

For legacy reasons, the stateless `JWT Access Token` authentication is named `bearer` with the Kong
OpenID Connect plugin (see: `config.auth_methods`). Stateless authentication basically means
the signature verification using the identity provider published public keys and the standard
claims' verification (such as `exp` (or expiry)). The client may have received the token directly
from the identity provider or by other means. It is simple:

<img src="/assets/images/docs/openid-connect/bearer-authentication.svg">

#### Patch the Plugin

Let's patch the plugin that we created in the [Kong configuration](#kong-configuration) step:

1. We want to only use the bearer authentication, but we also enable [the password grant](#password-grant) for demoing purposes
2. We want to search the bearer token for the bearer authentication from the headers only.

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.bearer_token_param_type=header                          \
  config.auth_methods=bearer                                     \
  config.auth_methods=password # only enabled for demoing purposes
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
        "auth_methods": [
            "bearer",
            "password"
        ],
        "bearer_token_param_type": [ "header" ]
    }
}
```

The [password grant](#password-grant) is enabled so that we can get a JWT access token that we can use
to show how the JWT access token authentication works. That is: we need a token. One way to get a JWT access token
is to issue the following call (we use [jq](https://stedolan.github.io/jq/) to filter the response):

```bash
http -a john:doe :8000 | jq -r .headers.Authorization
```
Output:
```
Bearer <access-token>
```

We can use the output in `Authorization` header.

#### Test the JWT Access Token Authentication

1. Request the service with a bearer token:
   ```bash
   http -v :8000 Authorization:"$(http -a john:doe :8000 | \
     jq -r .headers.Authorization)"
   ```
   or
   ```bash
   http -v :8000 Authorization:"Bearer <access-token>"
   ```
   ```http
   GET / HTTP/1.1
   Authorization: Bearer <access-token>
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```json
   {
       "headers": {
           "Authorization": "Bearer <access-token>"
       },
       "method": "GET"
   }
   ```
2. Done.

### Introspection Authentication

As with [JWT Access Token Authentication](#jwt-access-token-authentication)), the introspection authentication
relies on a bearer token that the client has already gotten from somewhere. The difference to stateless
JWT authentication is that the plugin needs to call the introspection endpoint of the identity provider
to find out whether the token is valid and active. This makes it possible to issue opaque tokens to
the clients.

<img src="/assets/images/docs/openid-connect/introspection-authentication.svg">

#### Patch the Plugin

Let's patch the plugin that we created in the [Kong configuration](#kong-configuration) step:

1. We want to only use the introspection authentication, but we also enable [the password grant](#password-grant) for demoing purposes
2. We want to search the bearer token for the introspection from the headers only.

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.bearer_token_param_type=header                          \
  config.auth_methods=introspection                              \
  config.auth_methods=password # only enabled for demoing purposes
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
        "auth_methods": [
            "introspection",
            "password"
        ],
        "bearer_token_param_type": [ "header" ]
    }
}
```

#### Test the Introspection Authentication

1. Request the service with a bearer token:
   ```bash
   http -v :8000 Authorization:"$(http -a john:doe :8000 | \
     jq -r .headers.Authorization)"
   ```
   or
   ```bash
   http -v :8000 Authorization:"Bearer <access-token>"
   ```
   ```http
   GET / HTTP/1.1
   Authorization: Bearer <access-token>
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```json
   {
       "headers": {
           "Authorization": "Bearer <access-token>"
       },
       "method": "GET"
   }
   ```
2. Done.

### User Info Authentication

The user info authentication uses OpenID Connect standard user info endpoint to verify the access token.
In most cases it is preferable to use [Introspection Authentication](#introspection-authentication)
as that is meant for retrieving information from the token itself, whereas the user info endpoint is
meant for retrieving information about the user for whom the token was given. The sequence
diagram below looks almost identical to introspection authentication:

<img src="/assets/images/docs/openid-connect/userinfo-authentication.svg">

#### Patch the Plugin

Let's patch the plugin that we created in the [Kong configuration](#kong-configuration) step:

1. We want to only use the user info authentication, but we also enable [the password grant](#password-grant) for demoing purposes
2. We want to search the bearer token for the user info from the headers only.

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.bearer_token_param_type=header                          \
  config.auth_methods=userinfo                                   \
  config.auth_methods=password # only enabled for demoing purposes
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
        "auth_methods": [
            "userinfo",
            "password"
        ],
        "bearer_token_param_type": [ "header" ]
    }
}
```

#### Test the User Info Authentication

1. Request the service with a bearer token:
   ```bash
   http -v :8000 Authorization:"$(http -a john:doe :8000 | \
     jq -r .headers.Authorization)"
   ```
   or
   ```bash
   http -v :8000 Authorization:"Bearer <access-token>"
   ```
   ```http
   GET / HTTP/1.1
   Authorization: Bearer <access-token>
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```json
   {
       "headers": {
           "Authorization": "Bearer <access-token>"
       },
       "method": "GET"
   }
   ```
2. Done.

### Kong OAuth Token Authentication

The OpenID Connect plugin can also verify the tokens issued by [Kong OAuth 2.0 Plugin](/hub/kong-inc/oauth2/).
This is very similar to third party identity provider issued [JWT access token authentication](#jwt-access-token-authentication)
or [introspection authentication](#introspection-authentication):

<img src="/assets/images/docs/openid-connect/kong-oauth-authentication.svg">

#### Prepare Kong OAuth Application

1. Create a Consumer:
   ```bash
   http -f put :8001/consumers/jane
   ```
2. Create Kong OAuth Application for the consumer:
   ```bash
   http -f put :8001/consumers/jane/oauth2/client \
     name=demo                                    \
     client_secret=secret                         \
     hash_secret=true
   ```
3. Create a Route:
   ```bash
   http -f put :8001/routes/auth paths=/auth
   ```
4. Apply OAuth plugin to the Route:
   ```bash
   http -f put :8001/plugins/7cdeaa2d-5faf-416d-8df5-533d1e4cd2c4 \
     name=oauth2                                                  \
     route.name=auth                                              \
     config.global_credentials=true                               \
     config.enable_client_credentials=true
   ```
5. Test the token endpoint:
   ```bash
   https -f --verify no post :8443/auth/oauth2/token \
     client_id=client                                \
     client_secret=secret                            \
     grant_type=client_credentials
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```json
   {
       "access_token": "<access-token>",
       "expires_in": 7200,
       "token_type": "bearer"
   }
   ```

At this point we should be able to retrieve a new access token with:

```bash
https -f --verify no post :8443/auth/oauth2/token \
  client_id=client                                \
  client_secret=secret                            \
  grant_type=client_credentials |                 \
  jq -r .access_token
```
Output:
```
<access-token>
```

#### Patch the Plugin

Let's patch the plugin that we created in the [Kong configuration](#kong-configuration) step:

1. We want to only use the Kong OAuth authentication
2. We want to search the bearer token for the Kong OAuth authentication from the headers only.

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=kong_oauth2                                \
  config.bearer_token_param_type=header
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
        "auth_methods": [ "kong_oauth2" ],
        "bearer_token_param_type": [ "header" ]
    }
}
```

#### Test the Kong OAuth Token Authentication

1. Request the service with Kong OAuth token:
   ```bash
   http -v :8000 Authorization:"Bearer $(https -f --verify no \
     post :8443/auth/oauth2/token                             \
     client_id=client                                         \
     client_secret=secret                                     \
     grant_type=client_credentials |                          \
     jq -r .access_token)"
   ```
   or
   ```bash
   http -v :8000 Authorization:"Bearer <access-token>"
   ```
   ```http
   GET / HTTP/1.1
   Authorization: Bearer <access-token>
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```json
   {
       "headers": {
           "Authorization": "Bearer <access-token>",
           "X-Consumer-Id": "<consumer-id>",
           "X-Consumer-Username": "jane"
       },
       "method": "GET"
   }
   ```
2. Done.

### Session Authentication

Kong OpenID Connect plugin can issue a session cookie that can be used for further
session authentication. To make OpenID Connect issue a session cookie, you need
to first authenticate with one of the other grant / flows described above. In
[authorization code flow](#authorization-code-flow) we already demonstrated session
authentication when we used the redirect login action. The session authentication
is described below:

<img src="/assets/images/docs/openid-connect/session-authentication.svg">

#### Patch the Plugin

Let's patch the plugin that we created in the [Kong configuration](#kong-configuration) step:

1. We want to only use the session authentication, but we also enable [the password grant](#password-grant) for demoing purposes

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=session                                    \
  config.auth_methods=password # only enabled for demoing purposes
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
        "auth_methods": [
            "session",
            "password"
        ]
    }
}
```

#### Test the Session Authentication

1. Request the service with basic authentication credentials (created in the [Keycloak configuration](#keycloak-configuration) step),
   and store the session:
   ```bash
   http -v -a john:doe --session=john :8000
   ```
   ```http
   GET / HTTP/1.1
   Authorization: Basic BEkg3bHT0ERXFmKr1qelBQYrLBeHb5Hr
   ```
   ```http
   HTTP/1.1 200 OK
   Set-Cookie: session=<session-cookie>; Path=/; SameSite=Lax; HttpOnly
   ```
   ```json
   {
       "headers": {
           "Authorization": "Bearer <access-token>"
       },
       "method": "GET"
   }
   ```
2. Make request with a session cookie (stored above):
   ```bash
   http -v --session=john :8000
   ```
   ```http
   GET / HTTP/1.1
   Cookie: session=<session-cookie>
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```json
   {
       "headers": {
           "Authorization": "Bearer <access-token>"
       },
       "method": "GET"
   }
   ```
3. Done.

> If you want to disable session creation with some grants, you can use the `config.disable_session`.

## Authorization

Before you proceed, check that you have completed [the preparations](#preparations).

The OpenID Connect plugin has several features to do coarse grained authorization:

1. [Claims based authorization](#claims-based-authorization)
2. [ACL plugin authorization](#acl-plugin-authorization)
3. [Consumer authorization](#consumer-authorization)

### Claims Based Authorization

The following options can be configured to manage claims verification during authorization:

1. `config.scopes_claim` and `config.scopes_required`
2. `config.audience_claim` and `config.audience_required`
3. `config.groups_claim` and `config.groups_required`
4. `config.roles_claim` and `config.roles_required`

For example, the first configuration option, `config.scopes_claim`, points to a source, from which the value is
retrieved and checked against the value of the second configuration option: `config.scopes_required`.

Let's take a look at a JWT access token:

[Reset the plugin configuration](#create-a-plugin) before patching.

1. Patch the plugin to enable the password grant:
   ```bash
   http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
     config.auth_methods=password
   ```
2. Retrieve the content of an access token:
   ```bash
   http -a john:doe :8000 | jq -r .headers.Authorization
   ```
   ```http
   HTTP/1.1 200 OK
   ```
   ```
   Bearer <access-token>
   ```
3. The signed JWT `<access-token>` (JWS) comes with three parts separated with a dot `.`:
   `<header>.<payload>.<signature>` (a JWS compact serialization format)
4. We are interested with the `<payload>`, and you should have something similar to:
   ```
   eyJleHAiOjE2MjI1NTY3MTMsImF1ZCI6ImFjY291bnQiLCJ0eXAiOiJCZWFyZXIiLC
   JzY29wZSI6Im9wZW5pZCBlbWFpbCBwcm9maWxlIiwicHJlZmVycmVkX3VzZXJuYW1l
   Ijoiam9obiIsImdpdmVuX25hbWUiOiJKb2huIiwiZmFtaWx5X25hbWUiOiJEb2UifQ
   ```
   That can be base64 url decoded to the following `JSON`:
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
   This payload may contain arbitrary claims, such as user roles and groups,
   but as we didn't configure them in Keycloak, let's just use the claims that
   we have. In this case we want to authorize against the values in `scope` claim.

Let's patch the plugin that we created in the [Kong configuration](#kong-configuration) step:

1. We want to only use the password grant for demonstration purposes.
2. We require the value `openid` and `email` to be present in `scope` claim of
   the access token.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=password                                   \
  config.scopes_claim=scope                                      \
  config.scopes_required="openid email"
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
        "scopes_claim": [ "scope" ],
        "scopes_required": [ "openid email" ]
    }
}
```

Now let's see if we can still access the service:

```bash
http -v -a john:doe :8000
```
```http
GET / HTTP/1.1
Authorization: Basic BEkg3bHT0ERXFmKr1qelBQYrLBeHb5Hr
```
```http
HTTP/1.1 200 OK
```
```json
{
   "headers": {
       "Authorization": "Bearer <access-token>"
   },
   "method": "GET"
}
```

Works as expected, but let's try to add another authorization:

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.audience_claim=aud                                      \
  config.audience_required=httpbin
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
        "audience_claim": [ "scope" ],
        "audience_required": [ "httpbin" ]
    }
}
```

As we know, the access token has `"aud": "account"`, and that does not match with `"httpbin"`, so
the request should now be forbidden:

```bash
http -v -a john:doe :8000
```
```http
HTTP/1.1 403 Forbidden
```
```json
{
    "message": "Forbidden"
}
```

A few words about `config.scopes_claim` and `config.scopes_required` (and the similar configuration options).
You may have noticed that `config.scopes_claim` is an array of string elements. Why? It is used to traverse
the JSON when looking up a claim, take for example this imaginary payload:

```json
{
    "user": {
        "name": "john",
        "groups": [
            "employee",
            "marketing"
        ]
    }
}
```

In this case you would probably want to use `config.groups_claim` to point to `groups` claim, but that claim
is not a top-level claim, so you need to traverse there:

1. Find the `user` claim.
2. Inside the `user` claim, find the `groups` claim, and read its value:

```json
{
    "config": {
        "groups_claim": [
            "user",
            "groups"
        ]
    }
}
```

or

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.groups_claim=user                                       \
  config.groups_claim=groups
```

The value of a claim can be the following:

- a space separated string (such as `scope` claim usually is)
- an JSON array of strings (such as the imaginary `groups` claim above)
- a simple value, such as a `string`

What about the `config.groups_required` then? That is also an array?

That is correct, the required checks are arrays to allow logical `and`/`or` type of checks:

1. `and`: use a space separated values
2. `or`: specify value(s) in separate array indices


For example:

```json
{
    "config": {
        "groups_required": [
            "employee marketing",
            "super-admins"
        ]
    }
}
```

or

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.groups_required="employee marketing"                    \
  config.groups_required="super-admins"
```

The above means that a claim has to have:
1. `employee` **and** `marketing` values in it, **OR**
2. `super-admins` value in it

### ACL Plugin Authorization

The plugin can also be integrated with [Kong ACL Plugin](/hub/kong-inc/acl/) that provides
access control functionality in form of allow and deny lists.

Please read [the claims verification](#claims-verification) section for a basic information,
as a lot of that applies here too.

Let's first configure the OpenID Connect plugin for integration with the ACL plugin
(please remove other authorization if enabled):

[Reset the plugin configuration](#create-a-plugin) before patching.

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

Let's make it forbidden by changing it to a deny-list:

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

### Consumer Authorization

The third option for authorization is to use Kong consumers and dynamically map
from a claim value to a Kong consumer. This means that we restrict the access to
only those that do have a matching Kong consumer. Kong consumers can have ACL
groups attached to them and be further authorized with the
[Kong ACL Plugin](/hub/kong-inc/acl/).

As a remainder our token payload looks like this:
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

Out of these the `preferred_username` claim looks promising for consumer mapping.
Let's patch the plugin:

[Reset the plugin configuration](#create-a-plugin) before patching.

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

Nice, as you can see the plugin even added the `X-Consumer-Id` and `X-Consumer-Username` as request headers.

> It is possible to make consumer mapping optional and non-authorizing by setting the `config.consumer_optional=true`.

## Headers

Before you proceed, check that you have completed [the preparations](#preparations).

The OpenID Connect plugin can pass claim values, tokens, JWKs, and the session identifier to the upstream service
in request headers, and to the downstream client in response headers. By default, the plugin passes an access token
in `Authorization: Bearer <access-token>` header to the upstream service (this can be controlled with
`config.upstream_access_token_header`). The claim values can be taken from:
- an access token,
- an id token,
- an introspection response, or
- a user info response

Let's take a look for an access token payload:

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

To pass the `preferred_username` claim's value `john` to the upstream with an `Authenticated-User` header,
we need to patch our plugin:

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=password                                   \
  config.upstream_headers_claims=preferred_username              \
  config.upstream_headers_names=authenticated_user
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
        "upstream_headers_claims": [ "preferred_username" ],
        "upstream_headers_names": [ "authenticated_user" ]
    }
}
```

Let's see if it had any effect:

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
        "Authenticated-User": "john"
    },
    "method": "GET"
}
```

See the [configuration parameters](#parameters) for other options.

## Logout

The logout functionality is mostly useful together with [session authentication](#session-authentication)
that is mostly useful with [authorization code flow](#authorization-code-flow).

As part of the logout, the OpenID Connect plugin implements several features:

- session invalidation
- token revocation
- relying party (RP) initiated logout

Let's patch the OpenID Connect plugin to provide the logout functionality:

[Reset the plugin configuration](#create-a-plugin) before patching.

```bash
http -f patch :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
  config.auth_methods=session                                    \
  config.auth_methods=password                                   \
  config.logout_uri_suffix=/logout                               \
  config.logout_methods=POST                                     \
  config.logout_revoke=true
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
        "auth_methods": [ "password", "session" ],
        "logout_uri_suffix": "/logout",
        "logout_methods": [ "POST" ],
        "logout_revoke": true
    }
}
```

Login and establish a session:

```bash
http -a john:doe --session=john :8000
```
```http
HTTP/1.1 200 OK
```

Test that session authentication works:

```bash
http --session=john :8000
```
```http
HTTP/1.1 200 OK
```

Logout, and follow the redirect:

```bash
http --session=john --follow -a john: post :8000/logout
```
```http
HTTP/1.1 200 OK
```

> We needed to pass `-a john:` as there seems to be a feature with `HTTPie`
> that makes it to store the original basic authentication credentials in
> a session - not just the session cookies.

At this point the client has logged out from both Kong and the identity provider (Keycloak).

Check that the session is really gone:

```bash
http --session=john :8000
```
```http
HTTP/1.1 401 Unauthorized
```

## Debugging

The OpenID Connect plugin is complex, integrating with third-party identity providers can present challenges. If you have
issues with the plugin or integration, try the following:

1. Set Kong [log level](/gateway/latest/reference/configuration/#log_level) to `debug`, and check the Kong `error.log` (you can filter it with `openid-connect`)
   ```bash
   KONG_LOG_LEVEL=debug kong restart
   ```
2. Set the Kong OpenID Connect plugin to display errors:
   ```json
   {
       "config": {
           "display_errors": true
       }
   }
   ```
3. Disable the Kong OpenID Connect plugin verifications and see if you get further, just for debugging purposes:
   ```json
   {
       "config": {
           "verify_nonce": false,
           "verify_claims": false,
           "verify_signature": false
       }
   }
   ```
4. See what kind of tokens the Kong OpenID Connect plugin gets:
   ```json
   {
       "config": {
           "login_action": "response",
           "login_tokens": [ "tokens" ],
           "login_methods": [
               "password",
               "client_credentials",
               "authorization_code",
               "bearer",
               "introspection",
               "userinfo",
               "kong_oauth2",
               "refresh_token",
               "session"
           ]
       }
   }
   ```

With session related issues, you can try to store the session data in `Redis` or `memcache` as that will make the session
cookie much smaller. It is rather common that big cookies do cause issues. You can also enable session
compression.

Also try to eliminate indirection as that makes it easier to find out where the problem is. By indirection, we
mean other gateways, load balancers, NATs, and such in front of Kong. If there is such, you may look at using:

- [port maps](/gateway/latest/reference/configuration/#port_maps)
- `X-Forwarded-*` headers

---

## Changelog

**{{site.base_gateway}} 3.2.x**
* The plugin has been updated to use version 4.0.0 of the `lua-resty-session` library which introduced several new features such as the possibility to specify audiences.
The following configuration parameters have been affected:

Added:
  * `session_audience`
  * `session_remember`
  * `session_remember_cookie_name`
  * `session_remember_rolling_timeout`
  * `session_remember_absolute_timeout`
  * `session_absolute_timeout`
  * `session_request_headers`
  * `session_response_headers`
  * `session_store_metadata`
  * `session_enforce_same_subject`
  * `session_hash_subject`
  * `session_hash_storage_key`

Renamed:
  * `authorization_cookie_lifetime` to `authorization_rolling_timeout`
  * `authorization_cookie_samesite` to `authorization_cookie_same_site`
  * `authorization_cookie_httponly` to `authorization_cookie_http_only`
  * `session_cookie_lifetime` to `session_rolling_timeout`
  * `session_cookie_idletime` to `session_idling_timeout`
  * `session_cookie_samesite` to `session_cookie_same_site`
  * `session_cookie_httponly` to `session_cookie_http_only`
  * `session_memcache_prefix` to `session_memcached_prefix`
  * `session_memcache_socket` to `session_memcached_socket`
  * `session_memcache_host` to `session_memcached_host`
  * `session_memcache_port` to `session_memcached_port`
  * `session_redis_cluster_maxredirections` to `session_redis_cluster_max_redirections`

Removed:
  * `session_cookie_renew`
  * `session_cookie_maxsize`
  * `session_strategy`
  * `session_compressor`

**{{site.base_gateway}} 3.0.x**
* The deprecated `session_redis_auth` field has been removed from the plugin.

**{{site.base_gateway}} 2.8.x**

* Added the `session_redis_username` and `session_redis_password` configuration
parameters.

    {:.important}
    > These parameters replace the `session_redis_auth` field, which is
    now **deprecated** and planned to be removed in 3.x.x.

* Added the `resolve_distributed_claims` configuration parameter.

* The `client_id`, `client_secret`, `session_secret`, `session_redis_username`,
and `session_redis_password` configuration fields are now marked as
referenceable, which means they can be securely stored as
[secrets](/gateway/latest/kong-enterprise/secrets-management/getting-started/)
in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/secrets-management/reference-format/).

**{{site.base_gateway}} 2.7.x**

* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled,
 the `config.client_id`, `config.client_secret`, `config.session_auth`, and
 `config.session_redis_auth` parameter values will be encrypted.

  Additionally, the `d`, `p`, `q`, `dp`, `dq`, `qi`, `oth`, `r`, `t`, and `k`
  fields inside `openid_connect_jwks.previous[...].` and `openid_connect_jwks.keys[...]`
  will be marked as encrypted.

  {:.important}
  > There's a bug in {{site.base_gateway}} that prevents keyring encryption
  from working on deeply nested fields, so the `encrypted=true` setting does not
  currently have any effect on the nested fields in this plugin.

* The plugin now allows Redis cluster nodes to be specified by hostname through
the `session_redis_cluster_nodes` field, which is helpful if the cluster IPs are
not static.

**{{site.base_gateway}} 2.6.x**

* The OpenID Connect plugin can now handle JWT responses from a `userinfo` endpoint.
* Added support for JWE introspection.
* Added a new parameter, `by_username_ignore_case`, which allows `consumer_by` username
values to be matched case-insensitive with identity provider (IdP) claims.
