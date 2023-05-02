---
title: Set up SSO with OpenID Connect
content_type: how-to
---

As an alternative to {{site.konnect_saas}}’s native authentication, you can set
up single sign-on (SSO) access to {{site.konnect_short_name}} through
an identity provider (IdP) with
OpenID Connect.
This authentication method allows your users to log in to {{site.konnect_saas}}
using their IdP credentials, without needing a separate login.

You can't mix authentication methods in {{site.konnect_saas}}. With IdP
authentication enabled, all non-admin {{site.konnect_short_name}} users have to
log in through your IdP. Only the {{site.konnect_short_name}} org
owner can continue to log in with {{site.konnect_short_name}}'s native
authentication.

## Prerequisites

* {{site.konnect_short_name}} must be added to your IdP as an application
* Claims are set up in your IdP

## Set up SSO in {{site.konnect_short_name}}

1. In [{{site.konnect_saas}}](https://cloud.konghq.com), click {% konnect_icon cogwheel %}
**Settings**, and then **Auth Settings**.

1. Click **Configure provider** for **OIDC**.

1. Paste the issuer URI from your IdP in the **Issuer URI** box. 

1. Paste the client ID from your IdP in the **Client ID** box.

1. Paste the client secret from your IdP in the **Client Secret** box.

1. In the **Organization Login Path** box, enter a unique string. For example: `examplepath`.

    {{site.konnect_short_name}} uses this string to generate a custom login
    URL for your organization.

    Requirements:
    * The path must be unique *across all {{site.konnect_short_name}} organizations*.
    If your desired path is already taken, you must to choose another one.
    * The path can be any alphanumeric string.
    * The path does not require a slash (`/`).

1. Click **Save**.
<!-- copied from okta instructions  as is also relevant to OIDC but needs SME edit for actual details  
### Map {{site.konnect_short_name}} teams to Okta groups

By mapping Okta groups to [{{site.konnect_short_name}} teams](/konnect/org-management/teams-and-roles/),
you can manage a user's {{site.konnect_short_name}} team membership directly through
Okta group membership.

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

1. Refer to the [token preview](#test-claims-and-find-groups-for-mapping)
in Okta to locate the Okta groups you want to map.

    You can also locate a list of all existing groups by going to
    **Directory > Groups** in Okta. However, not all of these
    groups may be accessible by the `groups` claim. See the
    [claims](#set-up-claims-in-okta) setup step for details.

1. In {{site.konnect_saas}}, go to ![](/assets/images/icons/konnect/konnect-settings.svg){:.inline .no-image-expand} **Settings > Auth Settings > Team Mappings** and do at least one of the following:

    * To manage user and team memberships in {{site.konnect_short_name}} from the Organization settings, select the **Konnect Mapping Enabled** checkbox.
    * To assign team memberships by the IdP during SSO login via group claims mapped to {{site.konnect_short_name}} teams, select the **IdP Mapping Enabled** checkbox and enter your Okta groups in the relevant fields.

    Each {{site.konnect_short_name}} team can be mapped to **one** Okta group.

    For example, if you have a `service_admin` group in Okta, you might map it
    to the `Service Admin` team in {{site.konnect_short_name}}. You can hover
    over the info (`i`) icon beside each field to learn more about the team, or
    see the [teams reference](/konnect/org-management/teams-and-roles/teams-reference/)
    for more information.

    You must have at least one group mapped to save configuration changes.

1. Click **Save**.

--> 
## Test and apply the configuration

{:.important}
> **Important:** Keep built-in authentication enabled while you are testing IdP authentication. Only disable built-in authentication after successfully testing IdP authentication.

You can test the SSO configuration by navigating to the login URI based on the organization login path you set earlier. For example: `cloud.konghq.com/login/examplepath`. If your configuration is set up correctly, you will see the IdP sign-in window.

You can now manage your organization's user permissions entirely from the IdP
application.
