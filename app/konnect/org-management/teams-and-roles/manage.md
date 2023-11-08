---
title: Manage Teams and Roles
content_type: how-to
---

Manage access to your {{site.konnect_short_name}} organization and its
resources using teams and roles.

{:.note}
> **Note:** If Okta integration is [enabled](/konnect/org-management/okta-idp/),
{{site.konnect_short_name}} users and teams become read-only. An organization
admin can view all registered users in {{site.konnect_short_name}}, but cannot
edit their team membership from the {{site.konnect_short_name}} side. To manage
automatically-created users, adjust user permissions through Okta, or
[adjust team mapping](/konnect/org-management/okta-idp/#map-teams-to-groups).

### Create a team

Create a team from the {% konnect_icon organizations %} [**Organization**](https://cloud.konghq.com/organization/) > **Teams** page:

1. Click **New Team**.

1. Enter a team name and description. Both fields are required.

1. Click **Save**.

By default, your new team has no roles applied. Customize the roles through the team's
configuration page.

### Edit roles for a team

You can edit the roles for any custom team. Any changes made to a team's roles
are automatically applied to all team members.

Edit team roles from the {% konnect_icon organizations %} [**Organization**](https://cloud.konghq.com/organization/) > **Teams** page:

1. Open a team from the list.

    Teams with the `Predefined` label can't be edited or deleted.

1. Open one of the entity tabs: **API Products**, **Control Planes**, or **Mesh Control Planes**.

1. Enterprise only: Select the region you want to add from the **View region** drop-down menu. Members assigned to this role can only access {{site.konnect_short_name}} objects in the selected region.

1. Click **Add role(s)**.

1. Click the instance field to choose an instance of the entity you want to assign, or choose `*` to target all entities of the selected type.

1. Select one or more roles from the list.

    Hover over the `i` icon next to the role to see its description,
    or see the [roles reference](/konnect/org-management/teams-and-roles/roles-reference/).

1. Click **Save**.


### Add or remove team members

Edit team membership for any team, custom or predefined.
Team members inherit all roles attributed to the team.

Add or remove team members from the {% konnect_icon organizations %} [**Organization**](https://cloud.konghq.com/organization/) > **Teams** page:

1. Open a team from the list.

1. On the **Members** tab, click **Add Member(s)**.

1. Select a user in the organization and click **Save**.

### Delete a team

Deleting a team removes it and its configuration from
{{site.konnect_short_name}}. If the team has any team members, they will be
unassigned from the team.

You can't delete predefined teams.

{:.warning}
> **Warning:** Deleting a team is irreversible.

Delete a team from the {% konnect_icon organizations %} [**Organization**](https://cloud.konghq.com/organization/) > **Teams** page:

1. Open a team from the list.

1. From the **Team actions** drop-down, select **Delete**, then confirm deletion in the dialog.

## See also

* [Introduction to teams and roles in {{site.konnect_short_name}}](/konnect/org-management/teams-and-roles/)
* [Teams reference](/konnect/org-management/teams-and-roles/teams-reference/)
* [Roles reference](/konnect/org-management/teams-and-roles/roles-reference/)
