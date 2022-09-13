---
title: Roles reference
no_version: true
content_type: reference
---

A team can have any number of roles.
See [Manage Teams and Roles](/konnect/org-management/teams-and-roles).

The following predefined roles are available in {{site.konnect_short_name}}:

## Services

| Role                        | Description  |
|-----------------------------|--------------|
| Admin | Admin of an existing {{site.konnect_short_name}} service. The admins have all write access related to a service and service versions. |
| Application Registration | Access to enable or disable application registration for a {{site.konnect_short_name}} service. |
| Creator | Access to create new {{site.konnect_short_name}} services in Service Hub. The creator becomes the owner of the service they create, gaining admin access to the service. <br><br>This role does not provide access to creating sub-entities in a service such as service versions, implementations, API specs, or plugins. See the `Service Admin`, `Maintainer`, or `Plugins Admin` roles. |
| Deployer | Access to implement and associate a {{site.konnect_short_name}} service version to a runtime group. <br><br> Must also have the `Deployer` role for the associated runtime group. |
| Maintainer | Access to read, edit, and deploy a {{site.konnect_short_name}} service and its service versions, and manage its plugins. |
| Plugins Admin | Access to install plugins on the {{site.konnect_short_name}} service versions and routes. <br><br> Must also have the `Admin` role in the associated runtime group. |
| Publisher | Access to publish a {{site.konnect_short_name}} service to the Dev Portal. |
| Viewer | Read-only access to all the configurations of a {{site.konnect_short_name}} service, including attributes, versions, Analytics reports, and plugins. |

## Runtime groups

| Role                        | Description  |
|-----------------------------|--------------|
| Admin | Owner of an existing runtime group. The owners have all write access related to a runtime group, the group's runtime instances, and its configuration. |
| Creator | Access to create a new runtime group in Runtime Manager. The creator becomes the owner of the runtime group they create, gaining admin access to the new runtime group. <br><br>This role does not grant access to _existing_ runtime groups, their runtime instances, or their configurations. See the runtime group `Admin` or `Deployer` roles. |
| Certificate Admin | Access to configure certificates for an existing runtime group. |
| Deployer | Access to deploy a service to the runtime group. Must also have the Deployer role for the service being deployed.  |
| Viewer | Read-only access to all the configurations of a runtime group and its runtime instances. |
| Upstream Admin | Access to configure upstreams for an existing runtime group. |

<!-- ## Organizations

| Role                        | Description  |
|-----------------------------|--------------|
| Admin | Allows a user to view and manage existing organization settings, including billing/usage. Admins have all write access to organization objects. |
| Creator | Allows a user to create organizations. [*Q: What's stopping a user from creating orgs in general? What does this role actually imply - they can crete new orgs within a company umbrella of orgs?*] |
| Privileged | Privileged users of an existing organization can change system-level configuration, including the organization's license tier, organization status, (and what else?).
| Root |  Allows root access for an existing organization. This role grants write access to all organization objects as well as to all {{site.konnect_short_name}} services, runtime groups, Dev Portal, Analytics reports, applications, and developers. | -->

<!--
## Portals

| Role                        | Description  |
|-----------------------------|--------------|
| Admin | Owner of an existing Dev Portal instance. The owner has full write access related to any developers and applications in the organization. |
| Maintainer | Edit, view, and delete Dev Portal applications, and view developers. |
| Viewer | Read-only access to Dev Portal developers and applications. | -->

<!-- ## Teams

| Role                        | Description  |
|-----------------------------|--------------|
| Admin | Create, read, update, and delete teams in the organization. Add or remove users and roles to the team. |
| Creator | Create teams in Runtime Manager. |
| Viewer | Read-only access to all the configurations of a team, including attributes, versions, reports, and plugins. | -->

<!-- ## Users

| Role                        | Description  |
|-----------------------------|--------------|
| Admin | Create, read, update, and delete users in the organization. Add or remove users to and from teams. |
| Creator | Invite users to the {{site.konnect_short_name}} organization. |
| Viewer | View users in the {{site.konnect_short_name}} organization, their status, team membership, and individual roles. | -->
