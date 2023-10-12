---
title: Roles reference
content_type: reference
---

A team can have any number of roles.
See [Manage Teams and Roles](/konnect/org-management/teams-and-roles/).

The following predefined roles are available in {{site.konnect_short_name}}:

## API products

| Role                        | Description  |
|-----------------------------|--------------|
| Admin | Admin of an existing API product. The admins have all write access permissions related to a API product, API product version, etc. |
| Application Registration | Access to enable or disable application registration for an API Product. |
| Creator | Access to create new API product in API Products. The creator becomes the owner of the API product they create, gaining admin access to the API product. This role does not provide access to creating sub-entities in an API product such as API product versions or API specs, or link the API product version to a Gateway service. See the Admin or Maintainer role. |
| Maintainer | Access to fully manage an API product and its API product versions including app registration, publishing documentation, etc. |
| Publisher | Access to publish an API product to the Dev Portal. |
| Viewer | Read-only access on an API product including API product versions and its configuration, analytics, and documentation. |

## Control Planes

| Role                        | Description  |
|-----------------------------|--------------|
| Admin | Owner of an existing control plane group. Admins have write access to control plane nodes, and the control plane group's corresponding data plane nodes.|
| Creator | Access to create a new control plane group in Gateway Manager. The creator becomes the owner and admin of the control plane group they create. <br><br>This role does not grant access to _existing_ control plane groups, data plane nodes, or their configurations. See the `Admin` or `Deployer` roles. |
| Certificate Admin | Access to configure certificates for an existing control plane group. |
| Deployer | Access to deploy a Gateway service across the control plane group. Must also have the Deployer role for the service being deployed.  |
| Viewer | Read-only access to all the configurations of a control plane group and corresponding data plane nodes. |
| Consumer Admin | Access to configure consumers for an existing control plane group. |
| Gateway Service Admin | Access to configure Gateway services for an existing control plane group. |
| Key Admin | Access to configure keys for an existing control plane group. |
| Plugin Admin | Access to configure plugins for an existing control plane group. |
| Route Admin | Access to configure routes for an existing control plane group. |
| SNI Admin | Access to configure SNIs for an existing control plane group. |
| Upstream Admin | Access to configure upstreams for an existing control plane group. |
| Vault Admin | Access to configure vaults for an existing control plane group. |

## Mesh control planes 

| Role                        | Description  |
|-----------------------------|--------------|
| Admin | Owner of an existing mesh control plane. The owners have all write access related to a control plane and its configuration. |
| Connector | Access to connect a zone to the mesh control plane in {{site.konnect_short_name}}.|
| Creator | Access to create a new mesh control plane in Mesh Manager. The creator becomes the owner of the control plane they create, gaining admin access to the new control plane. <br><br>This role does not grant access to _existing_ control planes or their configurations. See the mesh control plane `Admin` role. |
| Viewer | Read-only access to all the configurations of a {{site.konnect_short_name}} mesh control plane, including zones, Zone Ingress and Egress, meshes, and RBAC. |

## Administration

| Role                        | Description  |
|-----------------------------|--------------|
| Identity Management | Access to users, teams, system accounts, tokens, IdP configurations, and authentication settings. |
| Audit Logs Setup | Access to configuring webhooks to receive region-specific audit logs and to trigger audit log replays. |

<!-- ## Organizations

| Role                        | Description  |
|-----------------------------|--------------|
| Admin | Allows a user to view and manage existing organization settings, including billing/usage. Admins have all write access to organization objects. |
| Creator | Allows a user to create organizations. [*Q: What's stopping a user from creating orgs in general? What does this role actually imply - they can crete new orgs within a company umbrella of orgs?*] |
| Privileged | Privileged users of an existing organization can change system-level configuration, including the organization's license tier, organization status, (and what else?).
| Root |  Allows root access for an existing organization. This role grants write access to all organization objects as well as to all {{site.konnect_short_name}} services, control planes, Dev Portal, Analytics reports, applications, and developers. | -->

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
| Creator | Create teams in Gateway Manager. |
| Viewer | Read-only access to all the configurations of a team, including attributes, versions, reports, and plugins. | -->

<!-- ## Users

| Role                        | Description  |
|-----------------------------|--------------|
| Admin | Create, read, update, and delete users in the organization. Add or remove users to and from teams. |
| Creator | Invite users to the {{site.konnect_short_name}} organization. |
| Viewer | View users in the {{site.konnect_short_name}} organization, their status, team membership, and individual roles. | -->
