---
title: Third-party OAuth2 Support for Application Registration
badge: enterprise
---

Third-party OAuth2 support allows developers to centralize application
credentials management with the [supported Identity Provider](#idps) of their
choice. To use the external IdP feature, set the `portal_app_auth`
configuration option to `external-oauth2` in the
`kong.conf.default` configuration file. For more information, see setting the
[Authorization Provider Strategy](/gateway/{{page.kong_version}}/developer-portal/administration/application-registration/auth-provider-strategy).

The Kong [OIDC](/hub/kong-inc/openid-connect/) and
[Portal Application Registration](/hub/kong-inc/application-registration/)
plugins are used in conjunction with each other on a Service:

* The OIDC plugin handles all aspects of the OAuth2 handshake, including
looking up the Consumer via
[custom claim](/gateway/{{page.kong_version}}/developer-portal/administration/application-registration/okta-config#auth-server-cclaim)
(the `custom_id` matches the identity provider `client_id` claim).

* The Application Registration plugin is responsible for checking the mapped
Consumer and ensuring the Consumer has the correct ACL (Access Control List)
permissions to access the Route.

## Supported identity providers {#idps}

The Kong OIDC plugin supports many identity providers out of the box. The
following providers have been tested for the current version of the Kong
Portal Application Registration plugin used in tandem with the Kong OIDC plugin:

* [Okta](https://developer.okta.com/). See the
  [Okta setup example](/gateway/{{page.kong_version}}/developer-portal/administration/application-registration/okta-config).
* [Azure](https://azure.microsoft.com/). See the
  [Azure setup example](/gateway/{{page.kong_version}}/developer-portal/administration/application-registration/azure-oidc-config).
* [Ping Identity](https://www.pingidentity.com/).

### Resources

How you authenticate with a Service depends on its underlying OAuth2
implementation. For more information, reference the documentation below for
your implemented identity provider and OAuth flow.

- Okta
  - [Authorization Code Flow](https://developer.okta.com/docs/guides/implement-auth-code/overview/)
  - [Authorization Code Flow (PKCE)](https://developer.okta.com/docs/guides/implement-auth-code-pkce/overview/)
  - [Client Credentials Flow](https://developer.okta.com/docs/guides/implement-client-creds/overview/)
  - [Implicit Grant Flow](https://developer.okta.com/docs/guides/implement-implicit/overview/)

- Azure
  - [Authorization Code Flow](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-auth-code-flow)
  - [Client Credentials Flow](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-client-creds-grant-flow)
  - [Implicit Grant Flow](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-oauth2-implicit-grant-flow)

- Ping Identity
  - [Oauth2 Developers Guide](https://www.pingidentity.com/developer/en/resources/oauth-2-0-developers-guide.html)

## Supported OAuth flows

* Client Credentials ([RFC 6742 Section 4.4](https://tools.ietf.org/html/rfc6749#section-4.4))
* Authorization Code ([RFC 6742 Section 4.1](https://tools.ietf.org/html/rfc6749#section-4.1))
* Implicit Grant ([RFC 6742 Section 4.2](https://tools.ietf.org/html/rfc6749#section-4.2))
* Password Grant ([RFC 6742 Section 4.3](https://tools.ietf.org/html/rfc6749#section-4.3))

Password Grant and [Implicit Grant flows](https://developer.okta.com/blog/2019/05/01/is-the-oauth-implicit-flow-dead) are available but not recommended
because they are less secure than the Authorization Code and Client Credentials
flows.

### Client Credentials Flow {#cc-flow}

The OIDC plugin makes authenticating using Client Credentials very
straightforward. This flow should be used for server-side and secure
machine-to-machine communication. The Client Credentials flow requires the
authorizing party to store and send the application's `client_secret`.

In this flow, a developer makes a request against the Service with the OIDC and Application
Registration plugins applied. This request should contain the `client_id` and
`client_secret` as a Basic Auth authentication header:

`Authorization: Basic client_id:client_secret`

The `client_id:client_secret` should be base64-encoded.

The following sequence diagram illustrates the Client Credentials flow through
the OIDC and Application Registration plugins. Click on the image to expand its
 view.

![Client Credentials Flow](/assets/images/docs/dev-portal/dp-appreg-3rdparty-ccflow.png)

| Step | Explanation                                                          |
|:------|:---------------------------------------------------------------------|
| a | Developer sends the Okta application's `client_id` and `client_secret` to the Route. The OIDC plugin proxies this request to the Okta auth server's endpoint.|
| b | Okta reads the `client_id` and `client_secret` and generates an access token. The auth server is configured to insert a custom claim `application_id`, which is a key/value pair with the Okta application's `client_id`. |
| c | Okta returns the access token to Kong. |
| d | The OIDC plugin reads the resulting access token and associates the request with the application via the `application_id` custom claim. |
| e |  If the resolved application has permission to consume the Service via its Portal Application Registration plugin, Kong forwards the request to the Upstream. |

### Authorization Code Flow {#ac-flow}

Due to limitations of the OIDC plugin, a single plugin instance cannot handle
dynamic `client_id's` provisioned from multiple sources (applications).
To circumvent this issue, the IdP Issuer URL is exposed to developers on the
Dev Portal application show page when
[`show_issuer`](/gateway/{{page.kong_version}}/developer-portal/administration/application-registration/enable-application-registration#app-reg-params) is enabled in the
Application Registration plugin. Developers can hit the Issuer URL directly to
provision an access token. After getting the access token, requests can be made
against the proxy.

1. Set up the application to secure an access token against the IdP directly.
For more information about implementing the Authorization Code flow with Okta,
refer to the
[Okta developer guide](https://developer.okta.com/docs/guides/implement-auth-code/overview/).

2. After the initial access token handshake has been completed, make subsequent
requests to the Kong service using that access token as a
[bearer token](https://tools.ietf.org/html/rfc6750#section-2.1). After
the first successful request, the OIDC plugin will establish a session with the
client so that the access token does not need to be continually passed with
every request.

The following sequence diagram illustrates the Authorization Code flow through
the OIDC and Application Registration plugins. Click on the image to expand its
 view.

![Authorization Code Flow](/assets/images/docs/dev-portal/dp-appreg-3rdparty-authcodeflow.png)

| Step | Explanation                                                          |
|:------|:--------------------------------------------------------------------|
| a | A developer copies the target Service's `issuer_id`, which can be exposed in the Dev Portal application view Service Details page. Developers can configure their application to make a request to this endpoint to authenticate the user and retrieve an access token. |
| b | Okta redirects the user to a login page. |
| c | The user inputs their Single Sign-On (SSO) information. |
| d | The user submits the SSO form that contains their Okta username and password. |
| e | Upon a successful login, the application is given an access token to make against calls for all subsequent requests. |
| f | The user makes a request to the protected Service and Route.|
| g | The OIDC plugin takes the access token and runs introspection, consulting the Okta authorization server if necessary. After the access token has been verified, the plugin matches the custom claim to find the associated application Consumer via its `custom_id`. |
| h | The request is passed to the Application Registration plugin, which checks to make sure the Consumer has the appropriate ACL (Access Control List) permissions. |
| i | The request is proxied to the Upstream. |

### Implicit Grant Flow

The Implicit Grant flow is not recommended if the Authorization Code flow is
possible.

1. Set up the application to secure an access token against the IdP directly.
For more information about implementing the Implicit Grant flow with Okta, refer to
the [Okta developer guide](https://developer.okta.com/docs/guides/implement-implicit/use-flow/).

2. After the access token handshake has been completed, make subsequent requests
to the Kong service using that access token as a bearer token. After the first
successful request, the OIDC plugin will establish a session with the client so
that the access token does not need to be passed continuously.
