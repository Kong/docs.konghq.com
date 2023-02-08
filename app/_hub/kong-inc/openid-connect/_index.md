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

  - [Auth0][auth0] ([Kong Integration Guide](/gateway/latest/configure/auth/oidc-auth0))
  - [Amazon AWS Cognito][cognito] ([Kong Integration Guide](/gateway/latest/configure/auth/oidc-cognito/))
  - [Connect2id][connect2id]
  - [Curity][curity]
  - [Dex][dex]
  - [Gluu][gluu]
  - [Google][google] ([Kong Integration Guide](/gateway/latest/configure/auth/oidc-google/))
  - [IdentityServer][identityserver]
  - [Keycloak][keycloak]
  - [Microsoft Azure Active Directory][azure] ([Kong Integration Guide](/gateway/latest/configure/auth/oidc-azuread))
  - [Microsoft Active Directory Federation Services][adfs]
  - [Microsoft Live Connect][liveconnect]
  - [Okta][okta] ([Kong Integration Guide](/gateway/latest/configure/auth/oidc-okta))
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
  [pingfederate]: https://documentation.pingidentity.com/pingfederate/
  [salesforce]: https://help.salesforce.com/articleView?id=sf.sso_provider_openid_connect.htm&type=5
  [wso2]: https://is.docs.wso2.com/en/latest/guides/identity-federation/configure-oauth2-openid-connect/
  [yahoo]: https://developer.yahoo.com/oauth2/guide/openid_connect/

  Once applied, any user with a valid credential can access the Service.

  This plugin can be used for authentication in conjunction with the
  [Application Registration](/hub/kong-inc/application-registration) plugin.

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
