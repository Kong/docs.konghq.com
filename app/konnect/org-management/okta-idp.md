---
title: Configure SSO with Okta
badge: enterprise
---

{{site.konnect_saas}} provides [built-in authentication](/konnect/org-management/auth/), 
allowing you to setup [users](/konnect/org-management/users/) and [teams](/konnect/org-management/teams-and-roles/) 
for {{site.konnect_short_name}} authentication and authorization. Alternatively, you can set up single sign-on (SSO) 
access to {{site.konnect_short_name}} using OpenID Connect (OIDC) or Security Assertion Markup Language (SAML). 
These authentication methods allow your users to log in to {{site.konnect_short_name}} using IdP authorization, 
without needing additional {{site.konnect_short_name}} specific credentials. You can also configure a mapping
between Okta group claims and {{site.konnect_saas}} teams, allowing for {{site.konnect_short_name}} user team assginments 
from within Okta.

{:.note}
> This topic provides specific instructions for configuring SSO with Okta. 
See [Configure Generic SSO](/konnect/org-management/sso/) for general instructions on setting up SSO for other identity providers.

{:.important}
> It is recommended to utilize a single authentication method, however, {{site.konnect_short_name}} supports the ability to 
combine built-in authentication with _either_ OIDC or SAML based SSO. Combining both OIDC and SAML based SSO is not supported.
Keep built-in authentication enabled while you are testing IdP authentication and only disable it after successfully testing 
your SSO configuration.

{% include_cached /md/konnect/okta-sso.md desc='Konnect Org' %}

## Okta reference docs
* [Build an Okta SSO integration](https://developer.okta.com/docs/guides/build-sso-integration/openidconnect/overview/)
* [Create claims in Okta](https://developer.okta.com/docs/guides/customize-authz-server/create-claims/)
* [Groups claim](https://developer.okta.com/docs/guides/customize-tokens-groups-claim/add-groups-claim-custom-as/)
* [Custom claims](https://developer.okta.com/docs/guides/customize-tokens-returned-from-okta/add-custom-claim/) 
