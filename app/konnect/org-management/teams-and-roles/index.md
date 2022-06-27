---
title: Teams and Roles
no_version: true
content_type: explanation
---

Many organizations have strict security requirements. For example, organizations
need the ability to segregate the duties of an administrator to ensure that a
mistake or malicious act by one administrator doesn’t cause an outage.

To help secure and govern your environment, {{site.konnect_short_name}} provides
the ability to manage authorization with teams and roles. You can use {{site.konnect_short_name}}'s
predefined teams for a standard set of roles, or create custom teams with
any roles you choose. Invite users and add them to these teams to manage user
access.

## Teams and roles

You can find a list of all teams in your organization through
{% konnect_icon organizations %} **Organization** > **Teams** in {{site.konnect_short_name}}.

You must be part of the **Organization Admin** team to manage users, teams, and
roles.

* **Team:** A group of users with access to the same roles. Teams are useful
for assigning access by functionality, as they can provide granular access to
any group of {{site.konnect_short_name}} resources based on roles. As well, access to specific
runtime groups and Services can be shared with teams.

* **Role:** Predefined access to a particular resource instance, or all
instances of a resource type (for example, a particular Service or all Services).

When you create a {{site.konnect_short_name}} account, you are automatically added to the Organization
Admin team, which is one of the [predefined teams](/konnect/org-management/teams-and-roles/teams-reference)
in {{site.konnect_short_name}}. Predefined teams have sets of roles that can't be modified or
deleted. You can add users to these teams, or create your own custom teams
with any of the [supported roles](/konnect/org-management/teams-and-roles/roles-reference).

All users can view all teams and members of each team, but they can't view the
team roles.

### Access precedence

Users can be part of any number of teams, and the roles gained from the teams
are additive. For example, if you add a user to both the Service Developer and
Portal Viewer teams, the user can create and manage Services
through the Service Hub _and_ register applications through the Dev Portal.

If two roles provide access to the same entity, the role with more access
takes effect. For example, if you have the Service Admin and Service Deployer
roles on the same Service, the Service Admin role takes precedence.

<!-- ### Entity and role sharing

An Organization Admin can share any role or entity with any user in the
organization.

Any user with the Service Admin or Runtime Group Admin role can
also share Services or runtime groups that they have access to, with
the same role or lesser.

For example, say you have a Service Admin role:
* You can share that Service with any other user through the Service Hub.
* Since you have admin access, you can choose to share the Service any
level of access: creator, deployer, viewer, etc.

You can [share any Service](/konnect/servicehub/manage-services/#share-service)
through the Service Hub, or
[share any runtime group](/konnect/runtime-manager/runtime-groups/manage/#share-runtime-group)
through the Runtime Manager. -->

## Get started with access management

* Manage resource access in your organization
 with [teams and roles](/konnect/org-management/teams-and-roles/manage)
* [Invite users](/konnect/org-management/users) to join your
organization
* [View the teams reference](/konnect/org-management/teams-and-roles/teams-reference)
* [View the roles reference](/konnect/org-management/teams-and-roles/roles-reference)
