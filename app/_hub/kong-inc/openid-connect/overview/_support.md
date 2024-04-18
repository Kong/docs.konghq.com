---
title: Supported credentials, grants, and tested IdPs
nav_title: Supported credentials, grants, and tested IdPs
---
The plugin supports several types of credentials and grants:

- Signed [JWT][jwt] access tokens ([JWS][jws])
- Opaque access tokens
- Refresh tokens
- Authorization code with client secret or PKCE
- Username and password
- Client credentials
- Session cookies

The plugin has been tested with several OpenID Connect providers:

- [Auth0][auth0] ([Kong Integration Guide](/hub/kong-inc/openid-connect/how-to/third-party/auth0/))
- [Amazon AWS Cognito][cognito] ([Kong Integration Guide](/hub/kong-inc/openid-connect/how-to/third-party/cognito/))
- [Connect2id][connect2id]
- [Curity][curity] ([Kong Integration Guide](/hub/kong-inc/openid-connect/how-to/third-party/curity/))
- [Dex][dex]
- [Gluu][gluu]
- [Google][google] ([Kong Integration Guide](/hub/kong-inc/openid-connect/how-to/third-party/google/))
- [IdentityServer][identityserver]
- [Keycloak][keycloak]
- [Microsoft Azure Active Directory][azure] ([Kong Integration Guide](/hub/kong-inc/openid-connect/how-to/third-party/azure-ad/))
- [Microsoft Active Directory Federation Services][adfs]
- [Microsoft Live Connect][liveconnect]
- [Okta][okta] ([Kong Integration Guide](/hub/kong-inc/openid-connect/how-to/third-party/okta/))
- [OneLogin][onelogin]
- [OpenAM][openam]
- [PayPal][paypal]
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