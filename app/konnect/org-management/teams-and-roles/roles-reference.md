---
title: Roles reference
content_type: reference
---

A team can have any number of roles.
See [Manage Teams and Roles](/konnect/org-management/teams-and-roles/). All predefined roles and teams automatically get access to all [geographic regions](/konnect/geo) in your {{site.konnect_short_name}} instance.

The following predefined roles are available in {{site.konnect_short_name}}:

## API products

| Role          | Description  |
|---------------|--------------|
| Admin         | Admin of an existing API product. The admins have all write access permissions related to a API product, API product version, etc. |
| Application Registration | Access to enable or disable application registration for an API Product. |
| Creator       | Access to create new API product in API Products. The creator becomes the owner of the API product they create, gaining admin access to the API product. This role does not provide access to creating sub-entities in an API product such as API product versions or API specs, or link the API product version to a Gateway service. See the Admin or Maintainer role. |
| Maintainer    | Access to fully manage an API product and its API product versions including app registration, publishing documentation, etc. |
| Publisher     | Access to publish an API product to the Dev Portal. |
| Viewer        | Read-only access on an API product including API product versions and its configuration, analytics, and documentation. |

## Control Planes

| Role                         | Description  |
|------------------------------|--------------|
| Admin                        | Owner of an existing control plane group. Admins have write access to control plane nodes, and the control plane group's corresponding data plane nodes.|
| Certificate Admin            | Access to configure certificates for an existing control plane group. |
| Cloud Gateway Cluster Admin  | Access to all read and write permissions related to cloud-gateways configurations and custom domains. |
| Cloud Gateway Cluster Viewer | Access to read-only permissions to cloud-gateways configurations and custom domains. |
| Consumer Admin               | Access to configure consumers for an existing control plane group. Can configure plugins and view plugin partials for consumers they have access to. Cannot create or modify global plugins or plugins outside their scope. |
| Creator                      | Access to create a new control plane group in Gateway Manager. The creator becomes the owner and admin of the control plane group they create. <br><br>This role does not grant access to _existing_ control plane groups, data plane nodes, or their configurations. See the `Admin` or `Deployer` roles. |
| Deployer                     | This role grants full write access to administer services, routes, and plugins necessary to deploy services in Service Catalog. Must also have the Deployer role for the service being deployed. |
| Gateway Service Admin        | Access to configure Gateway services for an existing control plane group. Can configure plugins and view plugin partials for services they have access to. Cannot create or modify global plugins or plugins outside their scope. |
| Key Admin                    | Access to configure keys for an existing control plane group. |
| Plugin Admin                 |  Can configure plugins at any scope (global, service, route, or consumer) within a control plane group. Also has write access to plugin partials. |
| Route Admin | Can configure plugins and view plugin partials for routes they have access to. Cannot create or modify global plugins or plugins outside their scope. |
| Serverless Cluster Admin     | Access to all read and write permissions related to serverless cloud-gateways configurations. | 
| Serverless Cluster Viewer    | Access to read-only permissions to serverless cloud-gateways configurations. |
| SNI Admin                    | Access to configure SNIs for an existing control plane group. |
| Upstream Admin               | Access to configure upstreams for an existing control plane group. |
| Vault Admin                  | Access to configure vaults for an existing control plane group. |
| Viewer                       | Read-only access to all the configurations of a control plane group and corresponding data plane nodes. Includes read-only access to plugin partials within accessible scopes. |

### Plugin Permissions and Partials Access

- **PluginAdmin** and **Admin** roles can configure plugins at all scopes, including global. These roles also have **write access to plugin partials**.

- **RouteAdmin**, **ServiceAdmin**, and **ConsumerAdmin** roles can configure plugins only within their respective scopes. These roles have **read-only access to plugin partials**.

- **Viewer** roles have **read-only access** to plugin partials within their assigned scope.

- If a user with a scoped role attempts to configure a plugin outside their scope, an error will be returned.


## Mesh control planes 

| Role    | Description  |
|---------|--------------|
| Admin   | Owner of an existing mesh control plane. The owners have all write access related to a control plane and its configuration. |
| Creator | Access to create a new mesh control plane in Mesh Manager. The creator becomes the owner of the control plane they create, gaining admin access to the new control plane. <br><br>This role does not grant access to _existing_ control planes or their configurations. See the mesh control plane `Admin` role. |
| Viewer  | Read-only access to all the configurations of a {{site.konnect_short_name}} mesh control plane, including zones, Zone Ingress and Egress, meshes, and RBAC. |

## Networks 

| Role            | Description  |
|-----------------|--------------|
| Network Admin   | Access to all read and write permissions related to a network. |
| Network Creator | Access to creating networks. |
| Network Viewer  | Access to read-only permissions to networks. |


## Service Catalog

| Role               | Description  |
|--------------------|--------------|
| Integration Admin  | Can view and edit all integrations (install/authorize). |
| Integration Viewer | Access to read-only permissions to integrations. |
| Scorecard Viewer   | Access to read-only permissions to scorecards. | 
| Scorecard Admin    | Can view and edit Scorecards. |
| Service Admin      | Can view and edit a select list of Service Catalog services, map resources to those services, manage all resources, and has read-only access to all integrations and integration instances. | 
| Service Creator    | Can create new Service Catalog services, becomes the Service Admin for any service they create, and can view and edit all resources. Includes read-only access to all integrations and integration instances.<br><br>This role does not grant access to _existing_ services or their configurations. See the `Service Admin` role. <br><br>This role does not grant write access to integration instances. See the `Integration Admin` role.
| Service Viewer     | Can view a select list of services and all resources and discovery rules. |

## Portals

| Role                  | Description  |
|-----------------------|--------------|
| Admin                 | Owner of an existing Dev Portal instance. The owner has full write access related to any developers and applications in the organization. |
| Appearance Maintainer | Access the Portal instance and edit its appearance. |
| Creator               | Create new Portals. |
| Maintainer            | Edit, view, and delete Dev Portal applications, and view developers. |
| Product Publisher     | Manage publishing products to a Dev Portal. |
| Viewer                | Read-only access to Dev Portal developers and applications. |

## Application Auth Strategies

| Role       | Description  |
|------------|--------------|
| Creator    | Create new app auth strategies. |
| Maintainer | Edit one or all app auth strategies. |
| Viewer     | Read-only access to one or all app auth strategies. |

## DCR

| Role       | Description  |
|------------|--------------|
| Creator    | Create new DCR providers. |
| Maintainer | Edit one or all DCR providers. |
| Viewer     | Read-only access to one or all DCR providers. |


## Identity

| Role  | Description  |
|-------|--------------|
| Admin | This role grants full write access to all identity resources. |
