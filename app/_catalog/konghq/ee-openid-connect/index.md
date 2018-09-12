---

name: OpenID Connect

desc: Integrate Kong with a third-party OpenID Connect 1.0 provider
description: |
  OpenID Connect ([1.0][connect]) plugin allows the integration with a 3rd party
  identity provider (IdP) or [Kong OAuth 2.0 Plugin][oauth2plugin] in a standardized way.
  This plugin can be used to implement Kong as a (proxying) [OAuth 2.0][oauth2] resource
  server (RS) and / or as an OpenID Connect relying party (RP) between the client
  and the upstream service.

  * [Detailed documentation for the EE OpenID Connect Plugin](/enterprise/latest/plugins/openid-connect/)

  The plugin supports several types of credentials, including:

  - Signed [JWT][jwt] access tokens ([JWS][jws]) with the standardized signing algorithms ([JWA][jwa])
  - Opaque access tokens with either Kong OAuth 2.0 plugin issued tokens or
    3rd party IdP issued ones through token introspection (IdP needs to support it)
  - Username and password through the OAuth 2.0 password grant (the plugin will
    automatically exchange such credentials with access token by calling the IdP's token
    endpoint)
  - Client id and secret through the OAuth 2.0 client credentials grant (the plugin
    will automatically exchange such credentials with access token by calling the IdP's
    token endpoint)
  - Authorization code that the OpenID Connect plugin can retrieve from the client when using
    OpenID Connect authorization code flow
  - Session cookie credentials that the plugin can setup between the client and Kong
    (usually used with web browser clients together with authorization code grant)

  This plugin can automatically refresh the access token using a refresh token.

  You can either let the plugin to exclusively talk your IdP as a trusted client
  (and let it do all the credential exchange) or you can let clients talk to IdP
  directly, and then present access token to the upstream service protected with
  the OpenID Connect plugin (or you can do both).

  Some of the capabilities of the plugin are listed below:

  - [WebFinger][webfinger] and [OpenID Connect Discovery][discovery]
  - [ID Token][idtoken] verification
  - [UserInfo][userinfo] endpoint data injecting
  - [RP-Initiated Logout][rplogout]
  - [OAuth 2.0 Token Revovation][revocation] during the logout (optionally)
  - [OAuth 2.0 Token Introspection][introspection] support
  - [OAuth 2.0 Proof Key for Code Exchange][pkce] (PKCE) support
  - Standard and configurable claims verification
  - Caching (optional) of token, introspection and user info endpoint request

  The plugin has been tested with several OpenID Connect capable providers such as:

  - [Auth0][auth0]
  - [Connect2id][connect2id]
  - [Dex][dex]
  - [Gluu][gluu]
  - [Google][google]
  - [IdentityServer4][identityserver4]
  - [Keycloak][keycloak]
  - [Microsoft Azure Active Directory v1][azurev1]
  - [Microsoft Azure Active Directory v2][azurev2]
  - Microsoft Live Connect
  - [Okta][okta]
  - [OneLogin][onelogin]
  - [OpenAM][openam]
  - [Paypal][paypal]
  - [PingFederate][pingfederate]
  - [Salesforce][salesforce]
  - [Yahoo!][yahoo]

  As long as your provider supports OpenID Connect standards the plugin should
  work, even if it is not specifically tested against it. Let us know if you
  want your provider to be tested and added to the list.

  [connect]: http://openid.net/specs/openid-connect-core-1_0.html
  [oauth2plugin]: /plugins/oauth2-authentication/
  [oauth2]: https://tools.ietf.org/html/rfc6749
  [jwt]: https://tools.ietf.org/html/rfc7519
  [jws]: https://tools.ietf.org/html/rfc7515
  [jwa]: https://tools.ietf.org/html/rfc7518
  [webfinger]: https://tools.ietf.org/html/rfc7033
  [discovery]: http://openid.net/specs/openid-connect-discovery-1_0.html
  [idtoken]: http://openid.net/specs/openid-connect-core-1_0.html#IDToken
  [userinfo]: http://openid.net/specs/openid-connect-core-1_0.html#UserInfo
  [rplogout]: http://openid.net/specs/openid-connect-session-1_0.html#RPLogout
  [revocation]: https://tools.ietf.org/html/rfc7009
  [introspection]: https://tools.ietf.org/html/rfc7662
  [pkce]: https://tools.ietf.org/html/rfc7636
  [auth0]: https://auth0.com/docs/protocols/oidc
  [connect2id]: https://connect2id.com/products/server
  [dex]: https://github.com/coreos/dex/blob/master/Documentation/openid-connect.md
  [gluu]: https://gluu.org/docs/ce/api-guide/openid-connect-api/
  [google]: https://developers.google.com/identity/protocols/OpenIDConnect
  [identityserver4]: https://identityserver4.readthedocs.io/
  [keycloak]: http://www.keycloak.org/documentation.html
  [azurev1]: https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-protocols-openid-connect-code
  [azurev2]: https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-v2-protocols-oidc
  [okta]: https://developer.okta.com/docs/api/resources/oidc.html
  [onelogin]: https://developers.onelogin.com/openid-connect
  [openam]: https://backstage.forgerock.com/docs/openam/13.5/admin-guide/#chap-openid-connect
  [paypal]: https://developer.paypal.com/docs/integration/direct/identity/log-in-with-paypal/
  [pingfederate]: https://documentation.pingidentity.com/pingfederate/
  [salesforce]: https://developer.salesforce.com/page/Inside_OpenID_Connect_on_Force.com
  [yahoo]: https://developer.yahoo.com/oauth2/guide/openid_connect/

  Once applied, any user with a valid credential can access the Service/API.
  To restrict usage to only some of the authenticated users, also add the
  [ACL](/plugins/acl/) plugin (not covered here) and create whitelist or
  blacklist groups of users.


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
        - 0.33-x
        - 0.32-x

---
