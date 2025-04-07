---
title: About Mesh Manager
content_type: explanation
---

[Mesh Manager](https://cloud.konghq.com/mesh-manager) in {{site.konnect_product_name}} allows you to create, manage, and view your {{site.mesh_product_name}} [service meshes](/mesh/latest/introduction/about-service-meshes/) using the {{site.konnect_short_name}} platform.

A global control plane is a managed central component that stores and distributes all of the configuration and policies for your meshes and services to local zones. 
Global control planes are responsible for validating and accepting connections from local zone control planes, and distributing the appropriate configuration down to each local zone as required. 
They also serve as targets for all `kumactl` CLI operations when manipulating resources and configuration within the [mesh deployment](/mesh/latest/production/deployment/multi-zone/).

![mesh global control plane](/assets/images/diagrams/diagram-mesh-in-konnect.png)

> _**Figure 1:** {{site.mesh_product_name}} can support multiple zones (like a Kubernetes cluster, VPC, data center, etc.) together in the same distributed deployment. Then, you can create multiple isolated virtual meshes with the same control plane to support every team and application in the organization._

Mesh Manager is ideal for organizations who want to have one or more global control planes that allow you to run your mesh deployments across multiple zones. You can run a mix of Kubernetes and Universal zones. Your mesh deployment environments can include multiple isolated meshes for multi-tenancy, with workloads running in different regions, on different clouds, or in different data-centers.

Here are a few benefits of creating a mesh deployment in {{site.konnect_short_name}} instead of using a self-managed setup:

* **Kong-managed global control plane:** By creating your mesh in {{site.konnect_short_name}}, your global control plane is managed by Kong. 
* **All entities in one place:** You can view all your information, such as entities from {{site.kic_product_name}} (KIC) for Kubernetes, {{site.konnect_short_name}}-managed entities, and now service mesh data, all from one central platform. 
* **Managed UI wizard setup:** {{site.konnect_short_name}} simplifies the process of creating a mesh by providing a setup wizard in the UI that guides you through the configuration steps.

## Create a mesh

Creating a fully-functioning {{site.mesh_product_name}} deployment in {{site.konnect_short_name}} involves the following steps:

1. Create the global control plane in {{site.konnect_short_name}} by going to [Mesh Manager](https://cloud.konghq.com/mesh-manager).
1. Add and configure a zone for your control plane from the mesh global control plane dashboard.
    {:.note}
    > **Note:** You can't create multiple zones in the same cluster.
1. Configure `kumactl` to connect to your global control plane following the wizard in the UI.
1. Add services to your mesh.
    * If you're using Kubernetes, you must add the [kuma.io/sidecar-injection](/mesh/latest/reference/kubernetes-annotations/#kumaiosidecar-injection) label to the namespace or deployments you want to bring into the mesh. This will automatically enable {{site.product_mesh_name}} and register the service pods in the mesh.
    * If you are using universal, you must create a [dataplane definition](/mesh/latest/production/dp-config/dpp-on-universal/), pass it to the `kuma-dp run` command on a virtual machine, and point it to the local zone control plane.

Mesh zones are priced based on consumption. For more information about the pricing and consumption of zones, see Kong's [Pricing](https://konghq.com/pricing) page.

### Mesh Manager dashboard

After your service mesh is deployed in {{site.konnect_short_name}}, Mesh Manager displays the following information for each control plane:

* Meshes and data plane proxies with [mTLS](/mesh/latest/policies/mutual-tls/)
* RBAC
* Zone control planes
* [Zone Ingresses](/mesh/latest/explore/zone-ingress/)
* [Zone Egresses](/mesh/latest/explore/zoneegress/)
* Services associated with your mesh
* [Gateways](/mesh/latest/explore/gateway/) associated with your mesh
* Policies

![mesh control plane dashboard](/assets/images/products/konnect/mesh-manager/konnect-mesh-control-plane-dashboard.png)
> _**Figure 1:** Example control plane dashboard with several zones and services, a service mesh, and data plane proxies._

## Supported installation options

{{site.konnect_short_name}} supports the following installation options for {{site.mesh_product_name}} zones:

* Kubernetes
* Helm
* OpenShift
* Docker
* Amazon Linux
* Red Hat
* CentOS
* Debian
* Ubuntu
* macOS

The installer automatically chooses the installation option based on your current platform.


## Mesh Manager RBAC

Mesh Manager has its own role-based access control (RBAC) settings that are separate from the [{{site.konnect_short_name}} RBAC settings](/konnect/org-management/teams-and-roles/roles-reference/). The Mesh Manager RBAC settings are specific to the meshes and mesh policies in Mesh Manager. 

To completely configure RBAC for Mesh Manager, you must configure both roles and role bindings.
* **Role:** Determines what resources a user or group has access to
* **Role binding:** Determines which users or groups are assigned to a particular role

The Admin role and role binding is automatically created for you. The admin role can be used for the service mesh operators who are part of infrastructure team responsible for {{site.mesh_product_name}} deployment.

### Key mapping

#### Roles

Access roles specify access levels and resources to which access is granted. Access is only defined for write operations. Read access is available to all users who have the {{site.konnect_short_name}} Mesh global control plane `Viewer` role. Access roles define roles that are assigned separately to users and groups/teams using access role bindings. They are scoped globally, which means they aren't bound to a mesh. 

For more information about how to configure the key mappings and RBAC settings, see [Role-Based Access Control](/mesh/latest/features/rbac/) in the {{site.mesh_product_name}} documentation.

#### Role binding

{% if_version gte:2.11.x %}
To obtain current user information you can use:

```bash
kumactl who-am-i
```

This will output:

```
User: {
   "name": "your.name@example.com",
   "groups": [
      "organization-admin",
      "team-a",
      "mesh-system:authenticated"
   ]
}
```

for a [User Account Token](https://docs.konghq.com/konnect/org-management/access-tokens/) and

```
User: {
   "name": "spat:97f08003-c893-4e42-88f1-e43088e51d1a",
   "groups": [
      "mesh-system:authenticated",
      "team-b"
   ]
}
```

for a [System Account Token](https://docs.konghq.com/konnect/org-management/access-tokens/#main).

You can use that information to bind the role to a user or group/team.
{% endif_version %}

| {{site.mesh_product_name}} key | Description                                                                                                                                                                                                                                                                                                                                                                  |
|--------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `type`                         | The resource type. For role binding, this should be `AccessRoleBinding`.                                                                                                                                                                                                                                                                                                     |
| `name`                         | Name for the role that you want to display in the {{site.konnect_short_name}} UI.                                                                                                                                                                                                                                                                                            |
| `subjects.type`                | The type of subject you want to bind the role to. This must be either `User` or `Group`.                                                                                                                                                                                                                                                                                     |
| `subjects.name`                | When `subjects.type` is `User`, this should be the {{site.konnect_short_name}} email address associated with them (or a `spat:<uuid>` when using [System Account Token](https://docs.konghq.com/konnect/org-management/access-tokens/#main)). When `subjects.type` is `Group`, this should be the name of the {{site.konnect_short_name}} team you want to bind the role to. |
| `roles`                        | List of roles that you want to assign to the users or groups/teams.                                                                                                                                                                                                                                                                                                          |
