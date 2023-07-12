---
title: Dynamic Client Registration Overview
content-type: explanation
---

Dynamic Client Registration (DCR) within {{site.konnect_short_name}} Dev Portal allows applications created in the portal to automatically create a linked application in a third-party Identity Provider (IdP).
This outsources the issuer and management of application credentials to a third party, allowing for additional configuration options and compatibility with various OIDC features provided by the IdP.

## Authentication Methods

DCR support in {{site.konnect_short_name}} provides multiple methods by which applications can be authenticated using industry-standard protocols. These methods include:
* **Client Credentials Grant**: Authenticate with the client ID and secret provided to the application.
* **Bearer tokens**: Authenticate using a token requested from the IdP's `/token` endpoint.
* **Session cookie**: Allow sessions from either client credentials or bearer tokens to persist via cookie until an expiration.

Each method is available when using [Auth0](/konnect/dev-portal/applications/dynamic-client-registration/auth0), [Curity](/konnect/dev-portal/applications/dynamic-client-registration/curity/), [Okta](/konnect/dev-portal/applications/dynamic-client-registration/okta/), or [Azure](/konnect/dev-portal/applications/dynamic-client-registration/azure/) as the DCR Identity Provider.

{:.note}
> **Note:** When using DCR for a Dev Portal, each application will automatically receive a client ID and secret. These can be used to authenticate with services directly if using the Client Credentials Grant, or can be used to obtain an access token from the Identity Provider if using the Bearer Token authentication method.

### Authentication with bearer tokens
If you have checked `Bearer Access Token`, then you can request a token from the IdP's `/token` endpoint and use the returned token as a Bearer Token.

<p align="center">
  <img src="/assets/images/docs/konnect/dcr-bearer-tokens.png" />
</p>

Token endpoints for IdPs are:

| Vendor  | Endpoint  | Body                                 |
|:------|--------|----------------------------------------|
| Auth0 | POST `https://YOUR_AUTH0_SUBDOMAIN.REGION.auth0.com/oauth/token` | `{ "grant_type": "client_credentials", "audience": "<your_audience>" }` |
| Curity | POST `https://YOUR_CURITY_DOMAIN/oauth/v2/oauth-token` | `{ "grant_types": "client_credentials" }` |
| Okta | POST `https://YOUR_OKTA_SUBDOMAIN.okta.com/oauth2/default/v1/token` | `{ "grant_types": "client_credentials" }` |
| Azure | GET `https://login.microsoftonline.com/YOUR_TENANT_ID/oauth2/token` | `{"grant_type": "client_credentials", "scope":"https://graph.microsoft.com/.default"}`|

### Authentication with session cookie

After successfully authenticating with either Client Credentials or Bearer Access Token, the Session Cookie authentication method can be used to authenticate subsequent requests without including the original credentials. To use this authentication method, ensure your Identity Provider is configured to send session cookie response headers.

