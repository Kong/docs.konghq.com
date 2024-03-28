---
title: Kong Manager
toc: false
badge: free
---

Kong Manager is the graphical user interface (GUI) for {{site.base_gateway}}.
It uses the Kong Admin API under the hood to administer and control {{site.base_gateway}}.

Here are some of the things you can do with Kong Manager:

* Manage all workspaces in one place
* Create new routes and services
* Activate or deactivate plugins
* Group your teams, services, plugins, consumer management, and everything else exactly how you want them
{% if_version lte:3.4.x -%}
* Manage users and roles for both {{site.base_gateway}} and for the Dev Portal
* Configure Dev Portals: customize appearance, manage developers and applications, and edit Dev Portal layouts, specs, and documentation
* Monitor performance: visualize cluster-wide, workspace-level, or even object-level health using intuitive, customizable dashboards
{% endif_version -%}
{% if_version gte:3.5.x -%}
* Manage users and roles for {{site.base_gateway}}
{% endif_version -%}
{% if_version gte:3.2.x -%}
* Centrally store and easily access key sets and keys. 
{% endif_version %}

{:.note}
> **Note**: If you are running Kong in [traditional mode](/gateway/{{page.release}}/production/deployment-topologies/traditional/), increased traffic could lead to potential performance issues for the Kong proxy.
> Server-side sorting and filtering large quantities of entities can also cause increased CPU usage in both {{site.base_gateway}} and its database.

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
> Figure 1: Kong Manager individual workspace dashboard

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
