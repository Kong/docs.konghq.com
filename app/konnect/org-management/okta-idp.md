---
title: Configure SSO with Okta
badge: enterprise
---

{{site.konnect_saas}} provides
[native authentication](/konnect/org-management/auth/), allowing you to setup users and groups for {{site.konnect_short_name}}
authentication and authorization. Alternatively, you can set up single sign-on (SSO) 
access to {{site.konnect_short_name}} through Okta using OpenID Connect (OIDC) or Security Assertion Markup Language (SAML). 
These authentication methods allow your users to log in to {{site.konnect_short_name}} using Okta authorization, 
without needing additional {{site.konnect_short_name}} specific credentials.

{:.note}
> This topic provides specific instructions for configuring SSO with Okta. 
See [Configure Generic SSO](/konnect/org-management/sso/) for general instructions on setting up SSO for other identity providers.

{:.important}
> It is recommended to utilize a single authentication method, however, {{site.konnect_short_name}} supports the ability to 
combine native authentication with _either_ OIDC or SAML based SSO. Combining both OIDC and SAML based SSO is not supported.

{% include_cached /md/konnect/okta-sso.md desc='Konnect Org' %}

## Okta reference docs
* [Build an Okta SSO integration](https://developer.okta.com/docs/guides/build-sso-integration/openidconnect/overview/)
* [Create claims in Okta](https://developer.okta.com/docs/guides/customize-authz-server/create-claims/)
* [Groups claim](https://developer.okta.com/docs/guides/customize-tokens-groups-claim/add-groups-claim-custom-as/)
* [Custom claims](https://developer.okta.com/docs/guides/customize-tokens-returned-from-okta/add-custom-claim/) 
