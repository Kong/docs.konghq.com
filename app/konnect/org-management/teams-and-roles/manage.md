---
title: Manage Teams and Roles
no_version: true
content_type: how-to
---

Manage access to your {{site.konnect_short_name}} organization and its
resources using teams and roles.

{:.note}
> **Note:** If Okta integration is [enabled](/konnect/org-management/okta-idp),
{{site.konnect_short_name}} users and teams become read-only. An organization
admin can view all registered users in {{site.konnect_short_name}}, but cannot
edit their team membership from the {{site.konnect_short_name}} side. To manage
automatically-created users, adjust user permissions through Okta, or
[adjust team mapping](/konnect/org-management/okta-idp/#map-teams-to-groups).

### Create a team

1. From the left navigation menu in {{site.konnect_short_name}}, open the {% konnect_icon organizations %}
 **Organization** link.
2. Click **+ New Team**.
3. Enter a team name and description. Both fields are required.
4. Click **Save**.

By default, your new team has no roles applied. Customize the roles through the team's
configuration page.

### Edit roles for a team

You can edit the roles for any custom team. Any changes made to a team's roles
are automatically applied to all team members.

1. From the left navigation menu in {{site.konnect_short_name}}, open the {% konnect_icon organizations %}
 **Organization** link.
2. Choose a team from the list.

    Teams with the `Predefined` label can't be edited or deleted.

3. Choose an entity tab, then click **+ Add role(s)**.

4. Enter the UUID of the element you want to assign, or enter `*` to target
all entities of the selected type.

5. Select one or more roles from the list.

    Hover over the `i` icon next to the role to see its description,
    or see the [roles reference](/konnect/org-management/teams-and-roles/roles-reference).

6. Click **Save**.


### Add or remove team members

Edit team membership for any team, custom or predefined.

1. From the left navigation menu in {{site.konnect_short_name}}, open the {% konnect_icon organizations %}
 **Organization** link.
2. Choose a team from the list.
3. On the **Members** tab, click **+ New Member**.
4. Select a user in the organization and click **Save**.

The user gains all roles attributed to the team.

### Delete a team

Deleting a team completely removes it and its configuration from
{{site.konnect_short_name}}. If the team has any team members, they will be
unassigned from the team.

{:.warning}
> **Warning:** Deleting a team is irreversible.

1. From the left navigation menu in {{site.konnect_short_name}}, open the {% konnect_icon organizations %}
 **Organization** link.

1. Choose a team from the list, open the action menu on the right of the row,
and click **Delete**.

1. Confirm deletion in the dialog.

## See also

* [Introduction to teams and roles in {{site.konnect_short_name}}](/konnect/org-management/teams-and-roles/)
* [Teams reference](/konnect/org-management/teams-and-roles/teams-reference)
* [Roles reference](/konnect/org-management/teams-and-roles/roles-reference)
