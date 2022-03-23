---
title: Roles reference
no_version: true
---

A team can have any number of roles. Roles can be assigned to teams, but not
directly to users. See [Manage Teams, Roles, and Users](/konnect/org-management/teams-roles-users).

The following predefined roles are available in Konnect:

## Services

| Role                        | Description  |
|-----------------------------|--------------|
| Admin | Admin of an existing Konnect Service. The admins have all write access permissions related to a Service and Service versions. |
| Application Registration |  Allows user to enable or disable application registration for a Konnect Service. |
| Creator | Create new Konnect Services in Service Hub. The creator becomes the owner of the Service they create, gaining admin access to the Service. This role is not for creating sub-entities in a Service such as Service versions, implimentations, API specs, or plugins. |
| Deployer | Allows a user to impliment and associate a Konnect Service version to a runtime group. The user must also have permissions to deploy Services in the associated runtime group. |
| Maintainer | Allows a user to read, edit, and deploy a Konnect Service and its Service versions, and manage its plugins. |
| Plugins Admin | Allows a user to install plugins on the Konnect Service versions and Routes. The user must also have permissions to write to the associated runtime group. |
| Publisher | Allows a user to publish a Konnect Service to the Dev Portal. The user must also have permissions in Portal to Publish Services in order to publish a service to the portal. |
| Viewer | Read-only access to all the configurations of a Konnect Service, including attributes, versions, vitals reports, and plugins. |

## Runtime groups

| Role                        | Description  |
|-----------------------------|--------------|
| Admin | Owner of an existing runtime group. The owners have all write access related to a runtime group, the group's runtime instances, and its configuration. |
| Creator | Creates a new runtime group in Runtime Manager. The creator becomes the owner of the runtime group they create, gaining admin access to the runtime group. This role does not directly grant permissions for creating runtime instances or configuring existing runtime groups. |
| Certificate Admin | Allows a user to configure certificates for an existing runtime group. |
| Deployer | Allows user to deploy a Service to the runtime group. Must also have permissions to deploy the Konnect Service in the Service entity. |
| Viewer | Read-only access to all the configurations of a runtime group and its runtime instances. |
| Upstream Admin | Allows a user to configure upstreams on an existing runtime group. |

## Organizations

| Role                        | Description  |
|-----------------------------|--------------|
| Admin | Allows a user to view and manage existing organization settings, including billing/usage. Admins have all write access to organization objects. |
| Creator | Allows a user to create organizations. [*Q: What's stopping a user from creating orgs in general? What does this role actually imply - they can crete new orgs within a company umbrella of orgs?*] |
| Privileged | Privileged users of an existing organization can change system-level configuration, including the organization's license tier, organization status, (and what else?).
| Root |  Allows root access for an existing organization. This role grants write access to all organization objects as well as to all Konnect Services, runtime groups, Dev Portal, Vitals reports, applications, and developers. |


## Portals

| Role                        | Description  |
|-----------------------------|--------------|
| Admin | Owner of an existing Dev Portal instance. The owner has full write access related to any developers and applications in the organization. |
| Maintainer | Edit, view, and delete Dev Portal applications, and view developers. |
| Viewer | Read-only access to Dev Portal developers and applications. |

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
| Creator | Invite users to the Konnect organization. |
| Viewer | View users in the Konnect organization, their status, team membership, and individual roles. | -->
