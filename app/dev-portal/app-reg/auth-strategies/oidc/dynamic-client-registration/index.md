---
title: Dynamic Client Registration Overview
breadcrumb: Dynamic Client Registration
content-type: concepts
---

Dynamic Client Registration (DCR) within {{site.konnect_short_name}} Dev Portal allows applications created in the portal to automatically create a linked application in a third-party Identity Provider (IdP).

This outsources the issuer and management of application credentials to a third party, allowing for additional configuration options and compatibility with various OIDC features provided by the IdP. {{site.konnect_short_name}} offers the flexibility to create multiple DCR configurations.

## Authentication Methods

DCR support in {{site.konnect_short_name}} provides multiple methods by which applications can be authenticated using industry-standard protocols. These methods include:

* **Client credentials grant**: Authenticate with the client ID and secret provided to the application.
* **Bearer tokens**: Authenticate using a token requested from the IdP's `/token` endpoint.
* **Session cookie**: Allow sessions from either client credentials or bearer tokens to persist via cookie until an expiration.

Each method is available when using [Auth0](/dev-portal/app-reg/auth-strategies/oidc/dynamic-client-registration/auth0), [Curity](/dev-portal/app-reg/auth-strategies/oidc/dynamic-client-registration/curity), [Okta](/dev-portal/app-reg/auth-strategies/oidc/dynamic-client-registration/okta), or [Azure](/dev-portal/app-reg/auth-strategies/oidc/dynamic-client-registration/azure) as the DCR identity provider.

{:.note}
> **Note:** When using DCR, each application automatically receives a client ID and secret. These credentials can be used to authenticate directly with services using the client credentials grant, or to obtain an access token from the identity provider when using the bearer token authentication method.

### Authentication with bearer tokens

You can obtain a bearer access token by requesting it from the IdP's `/token` endpoint:

Token endpoints for IdPs are:

| Vendor  | Endpoint  | Body                                 |
|:------|--------|----------------------------------------|
| Auth0 | POST `https://{region}.auth0.com/oauth/token` | `{ "grant_type": "client_credentials", "audience": "<your_audience>" }` |
| Curity | POST `https://{your_curity_domain}/oauth/v2/oauth-token` | `{ "grant_type": "client_credentials" }` |
| Okta | POST `https://{okta-subdomain}.okta.com/oauth2/default/v1/token`  | `{ "grant_type": "client_credentials" }` |
| Azure | POST `https://login.microsoftonline.com/{your_tenant_id}/oauth2/v2.0/token` | `{"grant_type": "client_credentials", "scope":"https://graph.microsoft.com/.default"}`|

### Authentication with session cookie

After successfully authenticating using either client credentials or a bearer access token, you can use session cookie authentication to authenticate subsequent requests without including the original credentials. To use this method, ensure that your identity provider is configured to send session cookie response headers.
