---
title: About Mesh Manager
content_type: explanation
beta: true
---

Mesh Manager in {{site.konnect_product_name}} allows you to create, manage and view your {{site.mesh_product_name}} [service meshes](/mesh/latest/introduction/what-is-a-service-mesh/) in the {{site.konnect_short_name}} UI and using the {{site.konnect_short_name}} platform.

Mesh Manager is ideal for organizations who want to have one or more global control planes that allow you to run your mesh deployments across multiple zones. You can run a mix of Kubernetes and Universal zones. Your mesh deployment environments can include multiple isolated meshes (for multi-tenancy) and workloads running in different regions, on different clouds, or in different data-centers.

Here are a few benefits of creating a mesh deployment in {{site.konnect_short_name}} instead of a self-managed setup:

* **Kong-managed global control plane:** By creating your mesh in {{site.konnect_short_name}}, your global control plane is managed by Kong. 
* **All entities in one place:** You can view all your information, such as entities from Kong Ingress Controller (KIC) for Kubernetes, {{site.konnect_short_name}}-managed entities, and now service mesh data all from one central platform. 
* **Managed UI wizard setup:** {{site.konnect_short_name}} simplifies the process of creating a mesh by providing a setup wizard in the UI that guides you through the configuration steps. 

## View service mesh entities

After your mesh is deployed in {{site.mesh_product_name}}, the following information will be displayed in Mesh Manager for each control plane:

* Meshes and data plane proxies with [mTLS](/mesh/latest/policies/mutual-tls/)
* RBAC
* Zone control planes
* [Zone Ingresses](/mesh/latest/explore/zone-ingress/)
* [Zone Egresses](/mesh/latest/explore/zoneegress/)
* Services associated with your mesh
* [Gateways](/mesh/latest/explore/gateway/) associated with your mesh
* Policies

![control plane dashboard](/assets/images/docs/konnect/konnect-control-plane-dashboard.png)
> _**Figure 1:** Example control plane dashboard with several zones and services, a service mesh, and data plane proxies._

## Mesh Manager RBAC

Mesh Manager has it's own role-based access control (RBAC) settings that are separate from the [{{site.konnect_short_name}} RBAC settings](/konnect/org-management/teams-and-roles/roles-reference/). The Mesh Manager RBAC settings are specific to the meshes and mesh policies in Mesh Manager. 

To completely configure RBAC for Mesh Manager, you must configure both roles and role bindings.
* **Role:** Determines what resources a user or group has access to
* **Role binding:** Determines which users or groups are assigned to a particular role

The Admin role and role binding is automatically created for you. The admin role can be used for the service mesh operators who are part of infrastructure team responsible for {{site.mesh_product_name}} deployment.

### Key mapping

#### Roles

Access roles specify access levels and resources to which access is granted. Access is only defined for write operations. Read access is available to all users who have the {{site.konnect_short_name}} Mesh global control plane `Viewer` role. Access roles define roles that are assigned separately to users and groups/teams using access role bindings. They are scoped globally, which means they are not bound to a mesh. 

For more information about how to configure the key mappings and RBAC settings, see [Role-Based Access Control](/mesh/latest/features/rbac/) in the {{site.mesh_product_name}} documentation.

#### Role binding

| {{site.mesh_product_name}} key      | Description  |
|-----------------------------|--------------|
| `type` | The resource type. For role binding, this should be `AccessRoleBinding`. |
| `name` | Name for the role that you want to display in the {{site.konnect_short_name}} UI. |
| `subjects.type` | The type of subject you want to bind the role to. This must be either `User` or `Group`. |
| `subjects.name` | When `subjects.type` is `User`, this should be the {{site.konnect_short_name}} email address associated with them. When `subjects.type` is `Group`, this should be the name of the {{site.konnect_short_name}} team you want to bind the role to. |
| `roles` | List of roles that you want to assign to the users or groups/teams. |