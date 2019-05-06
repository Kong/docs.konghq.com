---
title: RBAC in Kong Manager
book: admin_gui
---

![Default Roles in Kong Manager](https://konghq.com/wp-content/uploads/2018/11/km-default.png)

In addition to authenticating **Admins** and segmenting **Workspaces**, 
Kong Enterprise has the ability to enforce Role-Based Access Control 
(RBAC) for all resources with the use of **Roles** assigned to **Admins**. 

As the **Super Admin** (or any **Role** with **read** and **write** 
access to the `/admins` and `/rbac` endpoints), it is possible to 
create new **Roles** and customize **Permissions**.

In Kong Manager, RBAC affects how **Admins** are able to navigate 
through the application.

## Default Roles

Kong includes Role-Based Access Control (RBAC). Every admin using Kong Manager will need an assigned Role based on the resources they have permission to access.

When a Super Admin starts Kong for the first time, the `default` Workspace will include three default Roles: `read-only`, `admin`, and `super-admin`. The three Roles have permissions related to every Workspace in the cluster.

Similarly, if a Role is confined to certain Workspaces, the user assigned to it will not be able to see either the overview or links to other Workspaces. 

⚠️ **IMPORTANT**: Although a default admin has full permissions with every endpoint in Kong, only a Super Admin has the ability to assign and modify RBAC permissions. An admin is not able to modify their own permissions or delimit a Super Admin's permissions.

⚠️ **IMPORTANT**: If a Role does not have permission to access entire endpoints, the user assigned to the Role will not be able to see the related navigation links.

## RBAC in Workspaces

RBAC Roles and permissions will be specific to a Workspace if they are assigned from within one. For example, if there are two Workspaces, "Payments" and "Deliveries", an Admin created in "Payments" will not have access to any endpoints in "Deliveries".

When a Super Admin creates a new Workspace, there are three default Roles that mirror the cluster-level Roles, and a fourth unique to each Workspace: `workspace-read-only`, `workspace-admin`, `workspace-super-admin`, and 
`workspace-portal-admin`.

![Default Roles in New Workspaces](https://konghq.com/wp-content/uploads/2018/11/km-workspace-roles.png)

⚠️ **IMPORTANT**: Any Role assigned in the "Default" Workspace will have permissions applied to all subsequently created Workspaces. A Super Admin in "Default" has RBAC permissions across all Workspaces.
