---
title: Manage Users
content_type: how-to
---

You can invite users to join your {{site.konnect_short_name}} organization through the {% konnect_icon organizations %} **Organization** > **Users** page.

To manage user access, see [Manage Teams and Roles](/konnect/org-management/teams-and-roles/).

From the Users page, you can:
* View usernames, email addresses, assigned team(s), and assigned individual role(s).
* Manage team assignment
* Manage individual roles

For users that have been invited but haven't set up an account yet, a **pending** indicator displays by their name.

{:.note}
> **Note:** If Okta integration is [enabled](/konnect/org-management/okta-idp/),
{{site.konnect_short_name}} users and teams become read-only. An organization
admin can view all registered users in {{site.konnect_short_name}}, but cannot
edit their team membership from the {{site.konnect_short_name}} side. To manage
automatically-created users, adjust user permissions through Okta, or
[adjust team mapping](/konnect/org-management/okta-idp/#map-teams-to-groups).

## Add a user to the organization

### Invite a user

Invite a user from the {% konnect_icon organizations %} [**Organization**](https://cloud.konghq.com/organization/) > **Users** page:

1. Select **Invite User**.
1. Enter the user’s name and email.
1. Assign the user to one or more teams.

    For team descriptions, hover over the information (`i`) icon next to the team name,
    or see the [predefined teams reference](/konnect/org-management/teams-and-roles/teams-reference/).

1. Click **Save** to send an email invitation to the user.

### Accept invite and create account

1. From the invitation email, follow the link to set up your account.
1. Create a password.

    The first and last name, organization, and email address are filled in for
    you and cannot be changed at this time.

1. Log in with your new account and test that you can access the resources
assigned to this account.

## Manage team assignment

Assign a user to a team from the {% konnect_icon organizations %} [**Organization**](https://cloud.konghq.com/organization/) > **Users** page:

1. Select a user row to view their assigned teams and roles.

1. From the **User Actions** drop-down menu, select **Add or remove teams** to change the user's team membership.

1. Check or uncheck any teams, then click **Ok** to save.


## Manage individual user roles

Assign roles to a user from the {% konnect_icon organizations %} [**Organization**](https://cloud.konghq.com/organization/) > **Users** page:

1. Select a user row to view their assigned teams and roles.

1. Open one of the entity tabs: **API Products** or **Control Plane Groups**.

1. To add or remove role(s) from the selected user, click **Add role(s)**.

1. Select an instance of an API product or control plane group, then check any roles you want to assign.

1. Click **Save**.


## Remove user from organization

Remove a user from your organization from the {% konnect_icon organizations %} [**Organization**](https://cloud.konghq.com/organization/) > **Users** page:

1. Click the **User Actions** drop-down menu, then select **Delete**.

1. Confirm deletion to permanently remove this user from the organization.

## See also

See the following documentation for additional information:
* [Manage System Accounts](/konnect/org-management/system-accounts/)