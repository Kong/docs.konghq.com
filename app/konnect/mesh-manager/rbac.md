---
title: Mesh Manager RBAC
content_type: reference
---

Mesh Manager has it's own role-based access control (RBAC) settings that are separate from the {{site.konnect_short_name}} RBAC settings. The Mesh Manager RBAC settings are specific to the meshes and mesh policies in Mesh Manager. 

To completely configure RBAC for Mesh Manager, you must configure both roles and role bindings.
* **Role:** Determines what resources a user or group has access to
* **Role binding:** Determines which users or groups are assigned to a particular role

The Admin role and role binding is automatically created for you. The admin role can be used for the service mesh operators who are part of infrastructure team responsible for {{site.mesh_product_name}} deployment.

## Key mapping

### Roles

Access roles specify access levels and resources to which access is granted. Access is only defined for write operations. Read access is available to all users who have the {{site.konnect_short_name}} Mesh global control plane `viewer` role. Access roles define roles that are assigned separately to users and groups/teams using access role bindings. They are scoped globally, which means they are not bound to a mesh. 

For more information about how to configure the key mappings and RBAC settings, see [Role-Based Access Control](/mesh/latest/features/rbac/) in the {{site.mesh_product_name}} documentation.

### Role binding

| {{site.mesh_product_name}} key      | Description  |
|-----------------------------|--------------|
| `type` | The resource type. This will be `AccessRoleBinding`. |
| `name` | Name for the role that you want to display in the {{site.konnect_short_name}} UI. |
| `subjects.type` | The type of subject you want to bind the role to. This must be either `User` or `Group`. |
| `subjects.name` | When `subjects.type` is `User`, this should be the {{site.konnect_short_name}} email address associated with them. When `subjects.type` is `Group`, this should be the name of the {{site.konnect_short_name}} team you want to bind the role to. |
| `roles` | List of roles that you want to assign to the users or groups/teams. |