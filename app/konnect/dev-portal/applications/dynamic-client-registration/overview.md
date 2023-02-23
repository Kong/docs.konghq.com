---
title: DCR Overview
content-type: explanation
---

## Dynamic Client Registration Overview

Dynamic Client Registration (DCR) support in {{site.konnect_short_name}} provides multiple methods by which applications can be authenticated using industry-standard protocols.

These methods include:
* **Client Credentials Grant**: This authentication method utilizes client ID/secret information and is available for [Auth0](/konnect/dev-portal/applications/dynamic-client-registration/auth0), [Curity](/konnect/dev-portal/applications/dynamic-client-registration/curity), and [Okta](/konnect/dev-portal/applications/dynamic-client-registration/okta).
* **Bearer tokens**: This authentication method allows you to request a token from the Identiy provider (IdP)'s endpoint.
* **Session cookie**: This authentication method allows credentials from either client credentials grant or bearer tokens to persist as long as the cookie has not expired.

<p align="center">
  <img src="/assets/images/docs/konnect/dcr-auth-methods.png" />
</p>
Each method is available when using [Auth0](/konnect/dev-portal/applications/dynamic-client-registration/auth0), [Curity](/konnect/dev-portal/applications/dynamic-client-registration/curity), or [Okta](/konnect/dev-portal/applications/dynamic-client-registration/okta) as the DCR Identity Provider.

{:.note}
> **Note:** When using DCR for a Dev Portal, each application will automatically recieve a client ID and secret. This can be used to authenticate with services directly if using the Client Credentials Grant, or can be used to obtain an access token from the Identity Provider if using the Bearer Token authentication method.

## Authentication with bearer tokens
If you have checked `Bearer Access Token`, then you can request a token from the IdP's `/token` endpoint and use the returned token as a Bearer Token:

<p align="center">
  <img src="/assets/images/docs/konnect/dcr-bearer-tokens.png" />
</p>

Token endpoints for IdPs are:

| Vendor  | Endpoint  | Variables                                 |
|:------|--------|----------------------------------------|
| Auth0 | `https://<your-subdomain>.us.auth0.com/oauth/token` | `{ "grant_type": "client_credentials", "audience": "<your_audience>" }` |
| Curity | `https://curity.konger.me/oauth/v2/oauth-token` | `{ "grant_types": "client_credentials" }` |
| Okta | POST `https://<your-subdomain>.okta.com/oauth2/default/v1/token` | `{ "grant_types": "client_credentials" }` |



