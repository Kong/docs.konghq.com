---
title: Mesh Manager RBAC
content_type: reference
---

Mesh Manager has it's own role-based access control (RBAC) settings that are separate from the {{site.konnect_short_name}} RBAC settings. The Mesh Manager RBAC settings are specific to the meshes and mesh policies in Mesh Manager. 

To completely configure RBAC for Mesh Manager, you must configure both roles and role bindings.
* **Role:** Determines what resources a user or group has access to
* **Role binding:** Determines which users or groups are assigned to a particular role

<!-- Is the admin role included by default/automatically? -->

## Roles description

You can use the following example roles as guides when you are configuring RBAC for Mesh Manager:

| Role                        | Description  |
|-----------------------------|--------------|
| Admin | The admin is the service mesh operator and they are a part of infrastructure team responsible for {{site.mesh_product_name}} deployment. |
| Service owner | The service owner is a part of the team that is responsible for a given service. |
| Observability operator | The observability operator is a member of the infrastructure team that is responsible for the logging, metrics, and tracing systems in the organization. Currently, those features are configured on `Mesh`, `TrafficLog`, and `TrafficTrace` objects. |
| Single mesh operator | With {{site.mesh_product_name}}, you can segment the deployment into many logical service meshes configured by the `Mesh` object. You can add a role that grants access to one specific mesh and all objects connected with this mesh instead of all meshes. |

## Key mapping

### Roles

| {{site.mesh_product_name}} key                        | Description  |
|-----------------------------|--------------|
| `type` | The RBAC method. This will be `AccessRole`. |
| `name` | Name for the role that you want to display in the {{site.konnect_short_name}} UI. |
| `rules.types` | List of types to which access is granted. If this is empty, then access is granted to all types. Types include ? |
| `rules.names` | List of allowed names of types that access is granted to. If this is empty, then access is granted to all resources regardless of the name. |
| `rules.mesh` | Name of the mesh in {{site.konnect_short_name}} that access is granted to the resources. It can only be used with the Mesh-scoped resources. |
| `rules.access` | an action that is bound to a type.? |
| `rules.when.sources` | a condition on sources section in connection policies (like TrafficRoute or Healthcheck). If this value is missing, then all sources are allowed.? Is this the name of a policy/policies? |
| `rules.when.destinations` | a condition on destinations section in connection policies (like TrafficRoute or Healthcheck). If this value is missing, then all sources are allowed.? |
| `rules.when.selectors` | a condition on selectors section in dataplane policies (like TrafficTrace or ProxyTemplate). |
| `rules.when.dpToken` | a condition on generate dataplane token. |

### Role binding

| {{site.mesh_product_name}} key                        | Description  |
|-----------------------------|--------------|
| `type` | The RBAC method. This will be `AccessRoleBinding`. |
| `name` | Name for the role that you want to display in the {{site.konnect_short_name}} UI. |
| `subjects.type` | The type of subject you want to bind the role to. This will be `User` or `Group`. |
| `subjects.name` | Either the email of the user or the name of the group depending on what value you used for `subjects.type`. ? |
| `roles` | List of roles that you want to assign to the users or groups. |

## More information

For more information about how to configure the key mappings and RBAC settings, see [Role-Based Access Control](/mesh/latest/features/rbac/) in the {{site.mesh_product_name}} documentation.