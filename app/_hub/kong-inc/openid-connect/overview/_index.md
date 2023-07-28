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

Once applied, any user with a valid credential can access the service.

This plugin can be used for authentication in conjunction with the
[Application Registration](/hub/kong-inc/application-registration/) plugin.

## Important configuration parameters

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

    In order to restrict the scope of potential attacks, the parameter should only 
    contain the grants that you want to use. 

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

## Authentication

We use [HTTPie](https://httpie.org/) to execute the examples. The output is stripped
for a better readability. [httpbin.org](https://httpbin.org/) is used as an upstream service.

Using Admin API is convenient when testing the plugin, but similar configs can
be done in declarative format as well.

When this plugin is configured with multiple grants/flows there is a hard-coded search
order for the credentials:

1. [Session Authentication](/hub/kong-inc/openid-connect/how-to/authentication/session/)
2. [JWT Access Token Authentication](/hub/kong-inc/openid-connect/how-to/authentication/jwt-access-token/)
3. [Kong OAuth Token Authentication](/hub/kong-inc/openid-connect/how-to/authentication/kong-oauth-token/)
4. [Introspection Authentication](/hub/kong-inc/openid-connect/how-to/authentication/introspection/)
5. [User Info Authentication](/hub/kong-inc/openid-connect/how-to/authentication/user-info/)
6. [Refresh Token Grant](/hub/kong-inc/openid-connect/how-to/authentication/refresh-token-grant/)
7. [Password Grant](/hub/kong-inc/openid-connect/how-to/authentication/password-grant/)
8. [Client Credentials Grant](/hub/kong-inc/openid-connect/how-to/authentication/client-credentials-grant/)
9. [Authorization Code Flow](/hub/kong-inc/openid-connect/how-to/authentication/authorization-code-flow/)

Once credentials are found, the plugin will stop searching further. Multiple grants may
share the same credentials. For example, both the password and client credentials grants can use 
basic access authentication through the `Authorization` header.

{:.warning}
> The choices made in the examples below are solely aimed at simplicity.
Because `httpbin.org` is used as an upstream service, it is highly recommended that you do
not run these usage examples with a production identity provider as there is a great chance
of leaking information. Also the examples below use the plain HTTP protocol that you should
never use in production. 

## Authorization

The OpenID Connect plugin has several features to do coarse grained authorization:

1. [Claims based authorization](/hub/kong-inc/openid-connect/how-to/authorization/claims/)
2. [ACL plugin authorization](/hub/kong-inc/openid-connect/how-to/authorization/acl/)
3. [Consumer authorization](/hub/kong-inc/openid-connect/how-to/authorization/consumer/)
