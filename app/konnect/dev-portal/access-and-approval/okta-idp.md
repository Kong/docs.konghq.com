---
title: Set Up SSO with Okta
badge: enterprise
---

You can set up single sign-on (SSO) access to Dev Portals through Okta using OpenID Connect or SAML. These authentication methods allow developers to log in to a Dev Portal using their Okta credentials without needing a separate login. 

You cannot mix authenticators in a {{site.konnect_saas}} Dev Portal. With Okta authentication enabled, all developers will log in to the Dev Portal through Okta.

This topic covers configuring Okta. For generic instructions on configuring SAML or OIDC for use with other identity providers, see the [generic SSO guide](/konnect/dev-portal/access-and-approval/sso/).

{% include_cached /md/konnect/okta-sso.md desc='Dev Portal' %}