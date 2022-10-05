---
title: RBAC in Kong Manager
badge: enterprise
---

In addition to authenticating admins and segmenting workspaces,
{{site.base_gateway}} has the ability to enforce Role-Based Access Control
(RBAC) for all resources with the use of roles assigned to admins.

As the super admin (or any role with read and write
access to the `/admins` and `/rbac` endpoints), it is possible to
create new roles and customize permissions.

In Kong Manager, RBAC affects how admins are able to navigate
through the application.

## Default roles

Kong includes Role-Based Access Control (RBAC). Every admin using Kong Manager
needs an assigned role based on the resources they have permission to access.

When a super admin starts Kong for the first time, the `default` workspace
includes three default roles: `read-only`, `admin`, and `super-admin`. The three
roles have permissions related to every workspace in the cluster.

Similarly, if a role is confined to certain workspaces, the admin assigned to it
will not be able to see either the overview or links to other workspaces.

If a role does not have permission to access entire endpoints,
the admin assigned to the role will not be able to see the related navigation links.

{:.important}
> Important: Although a default admin has full permissions to every
endpoint in Kong, only a super admin has the ability to assign and modify RBAC permissions.
An admin is not able to modify their own permissions or delimit a super admin's permissions.

## RBAC in workspaces

If RBAC roles and permissions are assigned from within a workspace, they are specific to that workspace.
For example, if there are two workspaces, Payments and
Deliveries, an admin created in Payments doesn't have access to any
endpoints in Deliveries.

When a super admin creates a new workspace, there are three default roles that
mirror the cluster-level roles, and a fourth unique to each workspace:
`workspace-read-only`, `workspace-admin`, `workspace-super-admin`, and
`workspace-portal-admin`.

These roles can be viewed in the **Teams** > **Roles** tab in Kong Manager.

{:.important}
> Important: Any role assigned in the `default` workspace will have
permissions applied to all subsequently created workspaces. A super admin
in `default` has RBAC Permissions across all workspaces.
