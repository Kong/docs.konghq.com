---
title: Kong Manager
---

Kong Manager is the graphical user interface (GUI) for {{site.base_gateway}}.
It uses the Kong Admin API under the hood to administer and control {{site.base_gateway}}.
It comes in two options, depending on the edition of {{site.base_gateway}} that you're running: open-source or enterprise.

Here's a comparison of some of the capabilities you get access to between the Kong Manager Enterprise (or Free mode) edition, and the OSS edition:

| Capability | Kong Manager Enteprise | Kong Manager OSS |
|--|---------------------------------------|------------------|
| Manage all workspaces in one place | ✅ | ❌ |
| Create and manage routes and services | ✅ | ✅ |
| Activate or deactivate plugins | ✅ | ✅ |
| Manage certificates | ✅ | ✅ |
| Group your services, plugins, consumers, and everything else exactly how you want them | ✅ | ❌ | 
| Manage teams | ✅ | ❌ |
{% if_version lte:3.4.x -%}
| Manage users and roles for both {{site.base_gateway}} and for the Dev Portal | ✅ | ❌ |
| Configure Dev Portals: customize appearance, manage developers and applications, and edit Dev Portal layouts, specs, and documentation | ✅ | ❌ |
| Monitor performance: visualize cluster-wide, workspace-level, or even object-level health using intuitive, customizable dashboards | ✅ | ❌ |
{% endif_version -%}
{% if_version gte:3.5.x -%}
| Manage users and roles for {{site.base_gateway}} | ✅ | ❌ |
{% endif_version -%}
{% if_version gte:3.2.x -%}
| Centrally store and easily access key sets and keys | ✅ | ✅ |
{% endif_version %}
| Manage vaults | ✅ | ✅ |

{:.note}
> **Note**: If you are running Kong in [traditional mode](/gateway/{{page.release}}/production/deployment-topologies/traditional/), increased traffic could lead to potential performance issues for the Kong proxy.
> Server-side sorting and filtering large quantities of entities can also cause increased CPU usage in both {{site.base_gateway}} and its database.

To access Kong Manager, go to the following URL after installing {{site.ce_product_name}}: [http://localhost:8002](http://localhost:8002)

## Kong Manager interface

{% if_version lte:3.0.x %}
![Kong Manager interface](/assets/images/products/gateway/km_workspace_3.0.png)
{% endif_version %}

{% if_version gte:3.1.x lte:3.4.x %}
![Kong Manager interface](/assets/images/products/gateway/km_workspace_3.1.png)
{% endif_version %}

{% if_version gte:3.5.x %}
![Kong Manager interface](/assets/images/products/gateway/km_workspace_3.5.png)
{% endif_version %}
> _Figure 1: Kong Manager individual workspace dashboard_

### Top menu

{% if_version gte:3.5.x %}

Item | Description
-----|------------
**Workspaces** | Dashboard for all the workspaces in the cluster.
**Teams** | Manage team roles and permissions with RBAC, or map groups to your IdP.

{% endif_version %}

{% if_version gte:3.1.x lte:3.4.x %}

Number | Item | Description
-------|------|------------
1 | **Workspaces** | Dashboard for all the workspaces in the cluster.
2 | **Dev Portals** | Overview of all Dev Portals in the cluster. At a glance, see which workspaces have active Dev Portals and access their URLs, or set up a Dev Portal instance.
3 | **Vitals** | Dashboard for cluster-wide monitoring. Use the dashboard to: <br> &nbsp;&nbsp;&bull; View request activity <br> &nbsp;&nbsp;&bull; Track proxy and upstream latency over time <br> &nbsp;&nbsp;&bull; See when the data store cache was accessed and whether the attempts to access it were successful or not
4 | **Teams** | Manage team roles and permissions with RBAC, or map groups to your IdP.
5 | **Account settings** | Manage your password and RBAC token.

{% endif_version %}
### Side menu

{% if_version gte:3.5.x %}

Item | Description
-----|------------
**Dashboard** | See information about a workspace.
**API Gateway** | Manage the {{site.base_gateway}} entities in the current workspace.
**Secrets** | Manage vaults, keys and key sets for your environment.
{% endif_version %}
{% if_version lte:3.4.x %}

| Number | Item | Description |
-------|------|------------
| 6 | **Change workspace** | Shortcut to quickly change between workspaces. |
| 7 | **API Gateway** | Manage the {{site.base_gateway}} entities in the current workspace. |
| 8 | **Dev Portal** | Workspace-specific Dev Portal configuration. If you enable Dev Portal for the current workspace, the menu will have additional items: <br> &nbsp;&nbsp;&bull; Settings: General settings for the Dev Portal instance in this workspace <br> &nbsp;&nbsp;&bull; Appearance: Customize your Dev Portal colors, fonts, and branding <br> &nbsp;&nbsp;&bull; Developers: Manage developer requests and access <br> &nbsp;&nbsp;&bull; Applications: Manage application requests and access <br> &nbsp;&nbsp;&bull; Permissions: Manage roles and content permissions <br> &nbsp;&nbsp;&bull; Editor: Access the Dev Portal files editor to configure layouts, documentation, and specs |
| 9 | **Vitals** | Monitor requests by access code for all services in the workspace. |

{% if_version gte:3.1.x %}
| 10 | **Vaults** | Manage secret vaults in your environment. |
{% endif_version %}

{% if_version gte:3.2.x %}
| 11 | **Keys** | Centrally store and easily access key sets and keys. |
{% endif_version %}

{% endif_version %}

{% if_version lte:3.4.x %}
### Workspace dashboard

{% if_version lte:3.0.x %}
Number | Item | Description
-------|------|------------
10 | **Settings** | Edit the workspace avatar or delete the workspace.
11 | **Overview panel** | Overview of key statistics for the workspace: number of services, consumers, and API requests, as well as the license validity information.
12 | **Total traffic graph** | Total traffic in the workspace by status code within a selected time frame.
13 | **Time frame selector** | Choose the time frame for the traffic graph, from the last 5 minutes to the last 12 hours.
{% endif_version %}

{% if_version gte:3.1.x %}
Number | Item | Description
-------|------|------------
11 | **Settings** | Edit the workspace avatar or delete the workspace.
12 | **Overview panel** | Overview of key statistics for the workspace: number of services, consumers, and API requests, as well as the license validity information.
13 | **Total traffic graph** | Total traffic in the workspace by status code within a selected time frame.
14 | **Time frame selector** | Choose the time frame for the traffic graph, from the last 5 minutes to the last 12 hours.
{% endif_version %}
{% endif_version %}

## Kong Manager OSS interface

Kong Manager Open Source (OSS) is the graphical user interface (GUI) for {{site.ce_product_name}}. 
It uses the Kong Admin API under the hood to administer and control {{site.ce_product_name}}. 

{:.note}
> **Note:** Kong Manager OSS is designed for use with the Open Source version of {{site.ce_product_name}}.

![Kong Manager OSS interface](/assets/images/products/gateway/km_oss.png)

> _Figure 2: Kong Manager OSS overview_

 Item | Description
------|------------
**Overview** | Dashboard that contains information about your {{site.ce_product_name}}.
[**Gateway Services**](/gateway/{{page.release}}/key-concepts/services/) | Overview of all services associated with your {{site.ce_product_name}}. From this dashboard, you can add new services, manage existing services, and see all services at a glance.
[**Routes**](/gateway/{{page.release}}/key-concepts/routes/) | Overview of all routes associated with your {{site.ce_product_name}}. From this dashboard, you can add new routes, manage existing routes, and see all routes at a glance. 
**Consumers** | Overview of all consumers associated with your {{site.ce_product_name}}. From this dashboard, you can add new consumers, manage existing consumers, and see all consumers at a glance.
[**Plugins**](/gateway/{{page.release}}/key-concepts/plugins/) | Overview of all plugins associated with your {{site.ce_product_name}}. From this dashboard, you can enable or disable plugins. 
[**Upstreams**](/gateway/{{page.release}}/key-concepts/upstreams/) | Overview of all upstreams associated with your {{site.ce_product_name}}. From this dashboard, you can add new upstreams, manage existing upstreams, and see all upstreams at a glance.
**Certificates** | Manage your certificates for SSL/TLS termination for encrypted requests.
**CA Certificates** | Manage your CA certificates for client and server certificate validation.
**SNIs** | Manage SNI object one-to-many mappings of hostnames to a certificate. 
**Vaults** | Manage the security of {{site.ce_product_name}} with centralized secrets.
**Keys** | Manage your asymmetric keys by adding a key object.
**Key Sets** | Manage your asymmetric key collections by adding a key set object.
