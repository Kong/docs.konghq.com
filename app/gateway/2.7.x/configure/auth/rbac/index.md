---
title: RBAC in Kong Manager
badge: enterprise
---

In addition to authenticating Admins and segmenting Workspaces,
{{site.base_gateway}} has the ability to enforce Role-Based Access Control
(RBAC) for all resources with the use of Roles assigned to Admins.

As the Super Admin (or any Role with read and write
access to the `/admins` and `/rbac` endpoints), it is possible to
create new Roles and customize Permissions.

In Kong Manager, RBAC affects how Admins are able to navigate
through the application.

### Default Roles

Kong includes Role-Based Access Control (RBAC). Every Admin using Kong Manager
will need an assigned Role based on the resources they have Permission to access.

When a Super Admin starts Kong for the first time, the `default` Workspace will
include three default Roles: `read-only`, `admin`, and `super-admin`. The three
Roles have Permissions related to every Workspace in the cluster.

Similarly, if a Role is confined to certain Workspaces, the Admin assigned to it
will not be able to see either the overview or links to other Workspaces.

If a Role does not have Permission to access entire endpoints,
the Admin assigned to the Role will not be able to see the related navigation links.

{:.important}
> Important: Although a default Admin has full permissions with every
endpoint in Kong, only a Super Admin has the ability to assign and modify RBAC Permissions. An Admin is not able to modify their own Permissions or delimit a Super Admin's Permissions.

### RBAC in Workspaces

RBAC Roles and Permissions will be specific to a Workspace if they are assigned
from within one. For example, if there are two Workspaces, Payments and
Deliveries, an Admin created in Payments will not have access to any
endpoints in Deliveries.

When a Super Admin creates a new Workspace, there are three default Roles that
mirror the cluster-level Roles, and a fourth unique to each Workspace:
`workspace-read-only`, `workspace-admin`, `workspace-super-admin`, and
`workspace-portal-admin`.

These roles can be viewed in the **Teams > Roles** tab in Kong Manager.


{:.important}
> **Important:** Any role assigned in the `default` workspace has permissions to all subsequently created
> workspaces unless roles in specific workspaces are explicitly assigned. When roles across multiple workspaces are
> assigned, roles in workspaces other than `default` take precedent. For example, a super admin assigned to the
> `super-admin` role in the `default` workspace as well as the `workspace-read-only` role in the `ws` workspace has RBAC permissions across all workspaces
> and full permissions to endpoints in workspaces except the `ws` workspace. The admin only has read-only permissions to endpoints in the `ws` workspace.

### How RBAC rules work in {{site.base_gateway}}

Although there are concepts like groups and roles in {{site.base_gateway}}, when determining if a user has sufficient permissions to access the endpoint, combinations of workspace and endpoint are collected from roles and groups assigned to a user, being the minimal unit for {{site.base_gateway}} to check for permissions. These combinations will be referred to as “rules” in the following paragraphs.

{{site.base_gateway}} uses a precedence model, from most specificity to least specificity, to determine if a user has access to an endpoint. For each request {{site.base_gateway}} checks for an RBAC rule assigned to the requesting user in the following order:

* An allow or deny rule against the current endpoint in the current workspace

* An allow or deny rule against the current endpoint in any workspace (`*`)

* An allow or deny rule against any endpoint (`*`) in the current workspace

* An allow or deny rule against any endpoint (`*`) in any workspace (`*`)

If {{site.base_gateway}} finds a matching rule for the current user, endpoint, and workspace it allows or denies the request according to
that rule. Once {{site.base_gateway}} finds an applicable rule, it stops, and does not continue checking for less specific rules. If no rules are found, the request is denied. 

The default admin roles define permissions for any workspace is (`*`).
{{site.base_gateway}} stops at the first role, which means any role assigned in the default workspace has permissions to all subsequently created workspaces unless roles
in specific workspaces are explicitly assigned. When roles across multiple workspaces are assigned, roles in workspaces
other than default take precedent. For example, a user assigned to the `super-admin` role in the default workspace as well
as the `workspace-read-only` role in the `ws` workspace has full permissions to endpoints in all workspaces except the `ws` workspace. The user only has read-only permissions to endpoints in the `ws` workspace.

{{site.base_gateway}} allows you to add negative rules to a role. A negative rule denies actions associated with the endpoint.
Meanwhile, a negative rule precedes other non-negative rules while following the above rules.