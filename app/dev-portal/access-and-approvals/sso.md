---
title: Configure generic SSO for Dev Portal
content_type: how-to
---

You can configure single sign-on (SSO) for {{site.konnect_short_name}} Dev Portal with OpenID Connect (OIDC) or SAML.
This allows developers to log in to Dev Portals by using their IdP credentials, without needing a separate login.

{:.note}
> This page provides general instructions for configuring SSO across identity providers.
See [Set Up SSO with Okta](/konnect/org-management/okta-idp/) for specific instructions on setting up SSO with Okta.

Keep the following in mind when configuring SSO for Dev Portal:

* Developers are auto-approved by {{site.konnect_short_name}} when they use SSO to log in to the Dev Portal.
This is because Kong outsources the approval process to the IdP instance when using SSO. Therefore, you must restrict
who can sign up from the IdP rather than through {{site.konnect_short_name}}.
* If you plan on using [team mappings from an IdP](/dev-portal/access-and-approvals/teams/),
they must be from the same IdP instance as your SSO.
* If you have multiple Dev Portals, keep in mind that each Dev Portal has a separate SSO configuration.
You can use the same IdP for multiple Dev Portals or different IdPs per Dev Portal.
* Dev Portal SSO is different than the [SSO for {{site.konnect_short_name}}](/konnect/org-management/oidc-idp).
If you want to use SSO to log in to {{site.konnect_short_name}}, you must configure that separately.

{:.important}
> It is recommended to use a single authentication method, however, {{site.konnect_short_name}} supports the ability to
combine built-in authentication with _either_ OIDC or SAML based SSO. Combining both OIDC and SAML based SSO is not supported.
Keep built-in authentication enabled while you are testing IdP authentication. Only disable built-in authentication after
successfully testing the configurations in these guides.

<!-- TODO fix include
include_cached /md/konnect/generic-sso.md desc='Dev Portal' %}
-->

## Konnect Portal Editor considerations

To seamlessly use the Konnect Portal Editor preview experience, you may need to configure your IdP with additional settings to ensure the login flow and preview environment function properly.

* The Sign On URL (SSO URL) must be set to the path on your Portal's custom domain, if applicable: `https://example.com/login/sso`.
* Specifically for SAML, the primary Reply URL (Assertion Consumer Service URL) must be set to the path on your Portal's custom domain, if applicable: `https://example.com/api/v2/developer/authenticate/saml/acs`.
  * To support the Konnect Portal Editor, you must also set an additional Reply URL (other callable SSO URLs) to the Kong-managed Portal domain: `https://{subdomain}.edge.{region}.portal.konghq.com/api/v2/developer/authenticate/saml/acs`.
* Your IdP must be configured to allow embedding its sign in screen within an iframe. As an example from Okta, you can configure [Trusted Origins](https://help.okta.com/en-us/content/topics/api/trusted-origins-iframe.htm) with your IdP. You should add `https://cloud.konghq.com` as a Trusted Origin for iframe embedding. This will allow your users to use the IdP login flow within the Konnect Portal Editor preview environment.

## Related links

* [Configure generic SSO for a Konnect Org](/konnect/org-management/sso/)
* [IdP SAML attribute mapping reference](/konnect/reference/saml-idp-mappings/)
