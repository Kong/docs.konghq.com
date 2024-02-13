---
title: Dynamic Client Registration Overview
content-type: explanation
---

Dynamic Client Registration (DCR) within {{site.konnect_short_name}} Dev Portal allows applications created in the portal to automatically create a linked application in a third-party Identity Provider (IdP).
This outsources the issuer and management of application credentials to a third party, allowing for additional configuration options and compatibility with various OIDC features provided by the IdP. You have the flexibility to create and apply as many DCR configurations as you see fit. For example, you can use the same DCR configuration for all new applications in your Dev Portal, you can create a unique DCR configuration per API Product in your portal, or something in between.

## Authentication Methods

DCR support in {{site.konnect_short_name}} provides multiple methods by which applications can be authenticated using industry-standard protocols. These methods include:
* **Client credentials grant**: Authenticate with the client ID and secret provided to the application.
* **Bearer tokens**: Authenticate using a token requested from the IdP's `/token` endpoint.
* **Session cookie**: Allow sessions from either client credentials or bearer tokens to persist via cookie until an expiration.

Each method is available when using [Auth0](/konnect/dev-portal/applications/dynamic-client-registration/auth0), [Curity](/konnect/dev-portal/applications/dynamic-client-registration/curity/), [Okta](/konnect/dev-portal/applications/dynamic-client-registration/okta/), or [Azure](/konnect/dev-portal/applications/dynamic-client-registration/azure/) as the DCR identity provider.

{:.note}
> **Note:** When using DCR, each application will automatically receive a client ID and secret. These can be used to authenticate with services directly if using the client credentials grant, or can be used to obtain an access token from the identity provider if using the bearer token authentication method.

### Authentication with bearer tokens

You can obtain a bearer access token by requesting it from the IdP's `/token` endpoint:


<p align="center">
  <img src="/assets/images/products/konnect/dev-portal/dcr-bearer-tokens.png" />
</p>

Token endpoints for IdPs are:

| Vendor  | Endpoint  | Body                                 |
|:------|--------|----------------------------------------|
| Auth0 | POST `https://YOUR_AUTH0_SUBDOMAIN.REGION.auth0.com/oauth/token` | `{ "grant_type": "client_credentials", "audience": "<your_audience>" }` |
| Curity | POST `https://YOUR_CURITY_DOMAIN/oauth/v2/oauth-token` | `{ "grant_types": "client_credentials" }` |
| Okta | POST `https://YOUR_OKTA_SUBDOMAIN.okta.com/oauth2/default/v1/token` | `{ "grant_types": "client_credentials" }` |
| Azure | GET `https://login.microsoftonline.com/YOUR_TENANT_ID/oauth2/token` | `{"grant_type": "client_credentials", "scope":"https://graph.microsoft.com/.default"}`|

### Authentication with session cookie

After successfully authenticating with either client Credentials or bearer access token, the session cookie authentication method can be used to authenticate subsequent requests without including the original credentials. To use this authentication method, ensure your identity provider is configured to send session cookie response headers.

