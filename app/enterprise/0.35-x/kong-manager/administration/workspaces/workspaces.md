---
title: Workspaces in Kong Manager
book: admin_gui
---

**Workspaces** enable an organization to segment traffic so that 
teams of **Admins** sharing the same Kong cluster are only able to 
interact with entities from their groups. Within a **Workspace**, 
it is possible to invite **Admins** to a particular team and to 
enforce **RBAC** with **Roles** and **Permissions** that further 
delimit the types of actions and entities available to an **Admin**.

## Default Workspace

When the first **Super Admin** logs in, they begin in the **Workspace**
named **default**. From here, they may invite **Admins** who are 
intended to be able to manage all other **Workspaces**, as well as 
the **Workspaces** themselves.

## Creating Additional Workspaces

To create a new **Workspace**, follow the guide, How to Create a New 
Workspace in Kong Manager.

## Navigating across Workspaces in Kong Manager

To navigate between Workspaces from the **Overview** page, click on any 
Workspace displayed beneath the **Vitals** chart. 

The list of **Workspaces** may be rendered as cards or a table, 
depending on preference.

![Workspace List](https://konghq.com/wp-content/uploads/2018/11/km-ws-list.png)

## Workspace Access

If a **Role** does not have permission to access entire endpoints within
a **Workspace**, the **Admin** assigned to that **Role** will not be 
able to see the related navigation links.

For more information about **Admins** and **Roles**, see 
[RBAC and Permissions](/enterprise/{{page.kong_version}}/kong-manager/organization-management/rbac-and-perms). 
For information about how RBAC applies to specific Workspaces, see 
[RBAC in Workspaces](/enterprise/{{page.kong_version}}/kong-manager/organization-management/rbac-in-workspaces)