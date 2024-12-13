---
title: Set Up SSO with Okta
badge: enterprise
---


As an alternative to {{site.konnect_saas}}’s native authentication, you can set up single sign-on (SSO) access to {{site.konnect_short_name}} through Okta using OpenID Connect or SAML. These authentication methods allow your users to log in to {{site.konnect_saas}} using their Okta credentials without needing a separate login. 

You cannot mix authenticators in {{site.konnect_saas}}. With Okta authentication enabled, all non-admin {{site.konnect_short_name}} users will log in through Okta. Only the {{site.konnect_short_name}} org owner can continue to log in with {{site.konnect_short_name}}'s native authentication.

This topic covers configuring Okta. For generic instructions on configuring SAML or OIDC for use with other identity providers, see the [generic SSO guide](/konnect/org-management/sso/).

{% include_cached /md/konnect/okta-sso.md desc='Konnect Org' %}

## Okta reference docs
* [Build an Okta SSO integration](https://developer.okta.com/docs/guides/build-sso-integration/openidconnect/overview/)
* [Create claims in Okta](https://developer.okta.com/docs/guides/customize-authz-server/create-claims/)
* [Groups claim](https://developer.okta.com/docs/guides/customize-tokens-groups-claim/add-groups-claim-custom-as/)
* [Custom claims](https://developer.okta.com/docs/guides/customize-tokens-returned-from-okta/add-custom-claim/) 
