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
* Manage users and roles for both {{site.base_gateway}} and for the Dev Portal
* Configure Dev Portals: customize appearance, manage developers and applications, and edit Dev Portal layouts, specs, and documentation
* Monitor performance: visualize cluster-wide, workspace-level, or even object-level health using intuitive, customizable dashboards

{:.note}
> **Note**: If you are running Kong in [traditional mode](/gateway/{{page.kong_version}}/kong-production/deployment-topologies/traditional), increased traffic could lead to potential performance issues for the Kong proxy.
> Server-side sorting and filtering large quantities of entities can also cause increased CPU usage in both {{site.base_gateway}} and its database.

## Kong Manager interface

![Kong Manager interface](/assets/images/docs/gateway/km_workspace.png)
> Figure 1: Kong Manager individual workspace dashboard

### Top menu

Number | Item | Description
-------|------|------------
1 | **Workspaces** | Dashboard for all the workspaces in the cluster.
2 | **Dev Portals** | Overview of all Dev Portals in the cluster. At a glance, see which workspaces have active Dev Portals and access their URLs, or set up a Dev Portal instance.
3 | **Vitals** | Dashboard for cluster-wide monitoring. Use the dashboard to: <br> &nbsp;&nbsp;&bull; View request activity <br> &nbsp;&nbsp;&bull; Track proxy and upstream latency over time <br> &nbsp;&nbsp;&bull; See when the data store cache was accessed and whether the attempts to access it were successful or not
4 | **Teams** | Manage team roles and permissions with RBAC, or map groups to your IdP.
5 | **Account settings** | Manage your password and RBAC token.

### Side menu

Number | Item | Description
-------|------|------------
6 | **Change workspace** | Shortcut to quickly change between workspaces.
7 | **API Gateway** | Manage the {{site.base_gateway}} entities in the current workspace.
8 | **Dev Portal** | Workspace-specific Dev Portal configuration. If you enable Dev Portal for the current workspace, the menu will have additional items: <br> &nbsp;&nbsp;&bull; Settings: General settings for the Dev Portal instance in this workspace <br> &nbsp;&nbsp;&bull; Appearance: Customize your Dev Portal colors, fonts, and branding <br> &nbsp;&nbsp;&bull; Developers: Manage developer requests and access <br> &nbsp;&nbsp;&bull; Applications: Manage application requests and access <br> &nbsp;&nbsp;&bull; Permissions: Manage roles and content permissions <br> &nbsp;&nbsp;&bull; Editor: Access the Dev Portal files editor to configure layouts, documentation, and specs
9 | **Vitals** | Monitor requests by access code for all services in the workspace.

### Workspace dashboard

Number | Item | Description
-------|------|------------
10 | **Settings** | Edit the workspace avatar or delete the workspace.
11 | **Overview panel** | Overview of key statistics for the workspace: number of services, consumers, and API requests, as well as the license validity information.
12 | **Total traffic graph** | Total traffic in the workspace by status code within a selected time frame.
13 | **Time frame selector** | Choose the time frame for the traffic graph, from the last 5 minutes to the last 12 hours.
