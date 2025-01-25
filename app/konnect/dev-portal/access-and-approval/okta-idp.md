---
title: Configure Okta SSO for Dev Portal
badge: enterprise
---

You can set up single sign-on (SSO) access to Dev Portals through Okta using OpenID Connect or SAML. 
These authentication methods allow developers to log in to a Dev Portal using their Okta credentials 
without needing a separate {{site.konnect_saas}} Dev Portal login. 

{:.note}
> This page provides specific instructions for configuring SSO with Okta. 
See [Configure Generic SSO](/konnect/dev-portal/access-and-approval/sso/) for general instructions on setting up SSO for other identity providers.

{:.important}
> It is recommended to utilize a single authentication method, however, {{site.konnect_short_name}} supports the ability to 
combine built-in authentication with _either_ OIDC or SAML based SSO. Combining both OIDC and SAML based SSO is not supported.
Keep built-in authentication enabled while you are testing IdP authentication and only disable it after successfully testing 
your SSO configuration.

{% include_cached /md/konnect/okta-sso.md desc='Dev Portal' %}
