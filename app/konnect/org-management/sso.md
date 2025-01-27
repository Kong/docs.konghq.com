---
title: Configure generic SSO for a Konnect Org
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
> This topic provides general instructions for configuring SSO across identity providers.
See [Configure Okta SSO](/konnect/org-management/okta-idp/) specific instructions on setting up SSO with Okta.

{:.important}
> It is recommended to utilize a single authentication method, however, {{site.konnect_short_name}} supports the ability to 
combine built-in authentication with _either_ OIDC or SAML based SSO. Combining both OIDC and SAML based SSO is not supported.
Keep built-in authentication enabled while you are testing IdP authentication and only disable it after successfully testing 
your SSO configuration.

## Map {{site.konnect_short_name}} teams to IdP groups

Before you enable SSO, you have the option to map IdP groups to [{{site.konnect_short_name}} teams](/konnect/org-management/teams-and-roles/). By doing this, you can manage a user's {{site.konnect_short_name}} team membership directly through your IdP group membership.

After mapping is set up:
* IdP users belonging to the mapped groups can log in to {{site.konnect_short_name}}.
* When a user logs into {{site.konnect_short_name}} with their IdP account
for the first time,
{{site.konnect_short_name}} automatically provisions an account with the
relevant roles.
* If your org already has non-admin {{site.konnect_short_name}} users before
mapping, on their next
login they will be mapped to the teams defined by their IdP group membership.
* An organization admin can view all registered users in
{{site.konnect_short_name}},
but cannot edit their team membership from the {{site.konnect_short_name}} side. To
manage automatically-created users, adjust user permissions through your IdP, or
adjust the team mapping.

Any changes to the mapped IdP groups on the IdP-side are reflected in
{{site.konnect_saas}}. For example:
* Removing a user from a group in your IdP also deactivates their
{{site.konnect_short_name}} account.
* Moving a user from one group to another changes their team in {{site.konnect_short_name}}
to align with the new group-to-team mapping.

{% include_cached /md/konnect/generic-sso.md desc='Konnect Org' %}

## Related links

* [Configure generic SSO for Dev Portal](/konnect/dev-portal/access-and-approval/sso/)
* [IdP SAML attribute mapping reference](/konnect/reference/saml-idp-mappings/): Learn how Azure, Oracle Cloud, and KeyCloak attributes map to {{site.konnect_short_name}}.
