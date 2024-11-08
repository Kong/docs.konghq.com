---
title: Configure generic SSO for a Konnect Org
---


As an alternative to {{site.konnect_saas}}’s native authentication, you can set up single sign-on (SSO) access to {{site.konnect_short_name}} using OpenID Connect or SAML. This authentication method allows your users to log in to {{site.konnect_saas}} using their IdP credentials, without needing a separate login. This topic covers configuring SSO for use with various identity providers. 

If you want to configure Okta, please see the [Okta configuration guide](/konnect/org-management/okta-idp/).

## Map {{site.konnect_short_name}} teams to Okta groups

Before you enable SSO, you have the option to map Okta groups to [{{site.konnect_short_name}} teams](/konnect/org-management/teams-and-roles/). By doing this, you can manage a user's {{site.konnect_short_name}} team membership directly through Okta group membership.

After mapping is set up:
* Okta users belonging to the mapped groups can log in to {{site.konnect_short_name}}.
* When a user logs into {{site.konnect_short_name}} with their Okta account
for the first time,
{{site.konnect_short_name}} automatically provisions an account with the
relevant roles.
* If your org already has non-admin {{site.konnect_short_name}} users before
mapping, on their next
login they will be mapped to the teams defined by their Okta group membership.
* An organization admin can view all registered users in
{{site.konnect_short_name}},
but cannot edit their team membership from the {{site.konnect_short_name}} side. To
manage automatically-created users, adjust user permissions through Okta, or
adjust the team mapping.

Any changes to the mapped Okta groups on the Okta side are reflected in
{{site.konnect_saas}}. For example:
* Removing a user from a group in Okta also deactivates their
{{site.konnect_short_name}} account.
* Moving a user from one group to another changes their team in {{site.konnect_short_name}}
to align with the new group-to-team mapping.

{% include_cached /md/konnect/generic-sso.md desc='Konnect Org' %}

## Related links

* [Configure generic SSO for Dev Portal](/konnect/dev-portal/access-and-approval/sso/)
* [IdP SAML attribute mapping reference](/konnect/reference/saml-idp-mappings/): Learn how Azure, Oracle Cloud, and KeyCloak attributes map to {{site.konnect_short_name}}.