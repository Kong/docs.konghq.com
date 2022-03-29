---
title: Manage Teams and Roles
no_version: true
---

Many organizations have strict security requirements. For example, organizations
need the ability to segregate the duties of an administrator to ensure that a
mistake or malicious act by one administrator doesn’t cause an outage.

To help secure and govern your environment, {{site.konnect_short_name}} provides
the ability to manage authorization with teams and roles. You can use {{site.konnect_short_name}}'s
predefined teams for a standard set of roles, or create custom teams with
any roles you choose. Invite users and add them to these teams to manage user
access.

To invite users to your organization, see [Manage Users](/konnect/org-management/users).

{:.note}
> **Note:** If Okta integration is [enabled](/konnect/org-management/okta-idp),
{{site.konnect_short_name}} users and teams become read-only. An organization
admin can view all registered users in {{site.konnect_short_name}}, but cannot
edit their team membership from the {{site.konnect_short_name}} side. To manage
automatically-created users, adjust user permissions through Okta, or
[adjust team mapping](/konnect/org-management/okta-idp/#map-teams-to-groups).


## Prerequisites

You must be part of the **Organization Admin** team to manage users, teams, and
roles.

## Manage teams and roles

You can find a list of all teams in your organization through
![](/assets/images/icons/konnect/icn-organizations.svg){:.inline .no-image-expand .konnect-icon}
**Organization** > **Teams** in Konnect.

* **Team:** A group of users with access to the same roles. Teams are useful
for assigning access by functionality, as they can provide granular access to
any group of Konnect resources based on roles. As well, access to specific
runtime groups and Services can be shared with teams.

* **Role:** Predefined access to a particular resource instance, or all
instances of a resource type (for example, a particular Service or all Services).

When you create a Konnect account, you are automatically added to the Organization
Admin team, which is one of the [predefined teams](/konnect/org-management/teams-reference)
in Konnect. Predefined teams have sets of roles that can't be modified or
deleted. You can add users to these teams, or create your own custom teams
with any of the [supported roles](/konnect/org-management/roles-reference).

All users can view all teams and members of each team, but they can't view the
team roles.

### Access precedence

Users can be part of any number of teams, and the roles gained from the teams
are additive. For example, if you add a user to both the Service Developer and
Portal Viewer teams, the user can create and manage Services
through the ServiceHub _and_ register applications through the Dev Portal.

If two roles provide access to the same entity, the role with more access
takes effect. For example, if you have the Service Admin and Service Deployer
roles on the same Service, the Service Admin role takes precedence.

### Entity and role sharing

An Organization Admin can share any role or entity with any user in the
organization.

Any user with the Service Admin or Runtime Group Admin role can
also share Services or runtime groups that they have access to, with
the same role or lesser.

For example, say you have a Service Admin role:
* You can share that Service with any other user through the ServiceHub.
* Since you have admin access, you can choose to share the Service any
level of access: creator, deployer, viewer, etc.

You can [share any Service](/konnect/configure/servicehub/manage-services/#share-service)
through the ServiceHub, or
[share any runtime group](/konnect/configure/runtime-manager/runtime-groups/manage/#share-runtime-group)
through the Runtime Manager.

### Create a team

1. From the left navigation menu in Konnect, open the
![](/assets/images/icons/konnect/icn-organizations.svg){:.inline .no-image-expand .konnect-icon}
 **Organization** link.
2. Click **+ New Team**.
3. Enter a team name and description. Both fields are required.
4. Click **Save**.

By default, your new team has no roles applied. Customize the roles through the team's
configuration page.

### Edit roles for a team

You can edit the roles for any custom team. Any changes made to a team's roles
are automatically applied to all team members.

1. From the left navigation menu in Konnect, open the
![](/assets/images/icons/konnect/icn-organizations.svg){:.inline .no-image-expand .konnect-icon}
 **Organization** link.
2. Choose a team from the list.

    Teams with the `Predefined` label can't be edited or deleted.

3. Choose an entity tab, then click **+ Add role(s)**.

4. Enter the UUID of the element you want to assign, or enter `*` to target
all entities of the selected type.

5. Select one or more roles from the list.

    Hover over the `i` icon next to the role to see its description,
    or see the [roles reference](/konnect/org-management/roles-reference).

6. Click **Save**.


### Add or remove team members

Edit team membership for any team, custom or predefined.

1. From the left navigation menu in Konnect, open the
![](/assets/images/icons/konnect/icn-organizations.svg){:.inline .no-image-expand .konnect-icon}
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

1. From the left navigation menu in Konnect, open the
![](/assets/images/icons/konnect/icn-organizations.svg){:.inline .no-image-expand .konnect-icon}
 **Organization** link.

1. Choose a team from the list, open the action menu on the right of the row,
and click **Delete**.

1. Confirm deletion in the dialog.
