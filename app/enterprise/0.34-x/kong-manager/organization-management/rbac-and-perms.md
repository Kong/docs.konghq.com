---
title: RBAC and Permissions
book: admin_gui
chapter: 6
toc: true
---
## RBAC in Kong Manager

![Default Roles in Kong Manager](https://konghq.com/wp-content/uploads/2018/11/km-default.png)

In addition to verifying users and distinguishing Workspaces, Kong Enterprise has the ability to enforce role-based access control (RBAC) for all resources. For the Super Admin (or any role with read and write access to `/admins` and `/rbac`), this ability entails permission to create new roles and customize permissions.

**Prerequisites**:

* Authentication is enabled, following the [Getting Started](/enterprise/{{page.kong_version}}/kong-manager/configuration/getting-started/) guide
* [RBAC is enabled](/enterprise/{{page.kong_version}}/kong-manager/configuration/authentication/#how-to-enable-basic-authentication)
* [Logged in as the Super Admin](/enterprise/{{page.kong_version}}/kong-manager/configuration/authentication/#how-to-log-in-as-the-first-super-admin) or a user that has `/admins` and `/rbac` read and write access

## Default Roles

Kong includes Role-Based Access Control (RBAC). Every admin using Kong Manager will need an assigned Role based on the resources they have permission to access.

When a Super Admin starts Kong for the first time, the `default` Workspace will include three default Roles: `read-only`, `admin`, and `super-admin`. The three Roles have permissions related to every Workspace in the cluster.

Similarly, if a Role is confined to certain Workspaces, the user assigned to it will not be able to see either the overview or links to other Workspaces. 

⚠️ **IMPORTANT**: Although a default admin has full permissions with every endpoint in Kong, only a Super Admin has the ability to assign and modify RBAC permissions. An admin is not able to modify their own permissions or delimit a Super Admin's permissions.

⚠️ **IMPORTANT**: If a Role does not have permission to access entire endpoints, the user assigned to the Role will not be able to see the related navigation links.

For more information about RBAC Roles in Kong Enterprise as a whole, see the [RBAC Overview](/enterprise/{{page.kong_version}}/rbac/overview)

## RBAC in Workspaces

RBAC Roles and permissions will be specific to a Workspace if they are assigned from within one. For example, if there are two Workspaces, "Payments" and "Deliveries", an Admin created in "Payments" will not have access to any endpoints in "Deliveries".

When a Super Admin creates a new Workspace, there are three default Roles that mirror the cluster-level Roles, and a fourth unique to each Workspace: `workspace-read-only`, `workspace-admin`, `workspace-super-admin`, and 
`workspace-portal-admin`.

![Default Roles in New Workspaces](https://konghq.com/wp-content/uploads/2018/11/km-workspace-roles.png)

⚠️ **IMPORTANT**: Any Role assigned in the "Default" Workspace will have permissions applied to all subsequently created Workspaces. A Super Admin in "Default" has RBAC permissions across all Workspaces.

## How to Create RBAC Roles for Admins in the New Workspace

1. On the "Admins" page, to create a new Role, click the "Add Role" button at the top right of the list of Roles. 

2. On the "Add Role" form, name the Role according to the permissions you want to grant. Write a brief comment describing the permissions of the Role. 

    ![New Role naming](https://konghq.com/wp-content/uploads/2018/11/km-new-role.png)

3. Click the "Add Permissions" button and fill out the form. Add the endpoint permissions by marking the appropriate checkbox.

    ![New Role permissions](https://konghq.com/wp-content/uploads/2018/11/km-perms.png)

4. Click "Add Permission to Role" to see the permissions listed on the form.

    ![New Role permissions list](https://konghq.com/wp-content/uploads/2018/11/km-perms-list.png)

5. To forbid access to certain endpoints, click "Add Permission" again and use the "negative" checkbox.

    ![Negative permissions](https://konghq.com/wp-content/uploads/2018/11/km-negative-perms.png)

6. See the new Role appear on the "Admins" page

    ![Roles list](https://konghq.com/wp-content/uploads/2018/11/km-roles-list.png)

⚠️ **IMPORTANT**: Every Admin who needs access to Kong Manager will need at least `read` access to the home "`/`" endpoint.

⚠️ **IMPORTANT**: A negative permission will always take precedence over a positive one.

Next: [Managing Admins &rsaquo;]({{page.book.next}})
