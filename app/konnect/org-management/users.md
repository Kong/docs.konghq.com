---
title: Manage Users
no_version: true
---

You can invite users to join your Konnect organization through the **Organization**
page.

To manage user access, see [Manage Teams and Roles](/konnect/org-management/teams-and-roles).

{:.note}
> **Note:** If Okta integration is [enabled](/konnect/org-management/okta-idp),
{{site.konnect_short_name}} users and teams become read-only. An organization
admin can view all registered users in {{site.konnect_short_name}}, but cannot
edit their team membership from the {{site.konnect_short_name}} side. To manage
automatically-created users, adjust user permissions through Okta, or
[adjust team mapping](/konnect/org-management/okta-idp/#map-teams-to-groups).

## Prerequisites

You must be part of the **Organization Admin** team to manage users.

## Add a user to the organization

### Invite a user
1. In {{site.konnect_saas}}, open the ![](/assets/images/icons/konnect/icn-organizations.svg){:.inline .no-image-expand .konnect-icon}
 **Organization > Users** page.
1. Select **Invite User**.
1. Enter the user’s name and email.
1. Assign the user to one or more teams.

    For team descriptions, hover over the information (`i`) icon next to the team name,
    or see the [predefined teams references](/konnect/org-management/teams-reference).

1. Click **Save**.

    An email invitation is sent to the user.

### Accept invite and create account

1. From the invitation email, follow the link to set up your account.
1. Create a password.

    The first and last name, organization, and email address are filled in for
    you and cannot be changed at this time.

1. Log in with your new account and test that you can access the resources
assigned to this account.

## View and manage users
1. In {{site.konnect_saas}}, open the ![](/assets/images/icons/konnect/icn-organization.svg){:.inline .no-image-expand}
 **Organization > Users** page.
2. From the Users page, you can:
   * View usernames, email addresses, assigned team(s), and assigned individual
   role(s).
   * For users that have been invited but haven't set up an account yet,
   a **pending** indicator displays by their name.
   * To edit assigned teams, select a user row to drill down to their
   assigned teams and roles. Select
   **Actions > Add/Remove** to change the user's team membership.
   * To edit assigned individual roles, select a user row to drill down to their
    assigned teams and roles. Select an entity from the tabs on the page, then open
    **Actions > Add/Remove Roles** for any role to add or remove role(s) from the
    selected user.
  * Remove a user from the organization entirely by selecting **Actions > Delete**
    from the Users page.
