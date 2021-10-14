---
title: RBAC in Kong Manager
book: admin_gui
---

### Introduction to RBAC in Kong Manager

In addition to authenticating **Admins** and segmenting **Workspaces**,
Kong Enterprise has the ability to enforce Role-Based Access Control
(RBAC) for all resources with the use of **Roles** assigned to **Admins**.

As the **Super Admin** (or any **Role** with **read** and **write**
access to the `/admins` and `/rbac` endpoints), it is possible to
create new **Roles** and customize **Permissions**.

In Kong Manager, RBAC affects how **Admins** are able to navigate
through the application.

### Default Roles

Kong includes Role-Based Access Control (RBAC). Every **Admin** using Kong Manager
will need an assigned **Role** based on the resources they have **Permission** to access.

When a **Super Admin** starts Kong for the first time, the `default` **Workspace** will
include three default **Roles**: `read-only`, `admin`, and `super-admin`. The three
**Roles** have **Permissions** related to every **Workspace** in the cluster.

Similarly, if a **Role** is confined to certain **Workspaces**, the **Admin** assigned to it
will not be able to see either the overview or links to other **Workspaces**.

⚠️ **IMPORTANT**: Although a default **Admin** has full permissions with every
endpoint in Kong, only a **Super Admin** has the ability to assign and modify RBAC
**Permissions**. An **Admin** is not able to modify their own **Permissions** or delimit a
**Super Admin's** **Permissions**.

⚠️ **IMPORTANT**: If a **Role** does not have **Permission** to access entire endpoints,
the **Admin** assigned to the **Role** will not be able to see the related navigation links.

### RBAC in Workspaces

RBAC **Roles** and **Permissions** will be specific to a **Workspace** if they are assigned
from within one. For example, if there are two **Workspaces**, **Payments** and
**Deliveries**, an **Admin** created in **Payments** will not have access to any
endpoints in **Deliveries**.

When a **Super Admin** creates a new **Workspace**, there are three default **Roles** that
mirror the cluster-level **Roles**, and a fourth unique to each **Workspace**:
`workspace-read-only`, `workspace-admin`, `workspace-super-admin`, and
`workspace-portal-admin`.

These roles can be viewed in the **Teams** tab under **Roles**

![Default Roles in New Workspaces](https://doc-assets.konghq.com/1.3/manager/teams/kong-manager-default-roles.png)

⚠️ **IMPORTANT**: Any Role assigned in the **Default Workspace** will have
**Permissions** applied to all subsequently created **Workspaces**. A **Super Admin**
in `default` has RBAC **Permissions** across all **Workspaces**.
