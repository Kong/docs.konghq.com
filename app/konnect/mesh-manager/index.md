---
title: About Mesh Manager
content_type: explanation
---

Mesh Manager in {{site.konnect_product_name}} allows you to create and view your {{site.mesh_product_name}} [service meshes](/mesh/latest/introduction/what-is-a-service-mesh/) in the {{site.konnect_short_name}} UI. This allows you to use {{site.konnect_short_name}}'s federated access for platform tenants, deep API analytics, API productization with Dev Portal, and a service catalogue offering for service mesh-managed services.  

Mesh Manager is ideal for organizations who want to have a global control plane that allows you to run your service mesh in multiple zones. You can run a mix of Kubernetes and Universal zones. Your mesh environment can include multiple isolated service meshes (multi-tenancy) and workloads running in different regions, on different clouds, or in different datacenters.

Here are a few benefits of creating a service mesh in {{site.konnect_short_name}} instead of a self-managed setup:

* **Kong-managed global control plane:** By creating your service mesh in {{site.konnect_short_name}}, your global control plane is managed by Kong. 
* **All entities in one place:** You can view all your information, such as entities from Kong Ingress Controller (KIC) for Kubernetes, {{site.konnect_short_name}} managed entities, and now service mesh data all from one central platform. 
* **Managed UI wizard setup:** {{site.konnect_short_name}} simplifies the process of creating a service mesh by providing a setup wizard in the UI that guides you through the configuration steps. 

## Create a service mesh in {{site.mesh_product_name}}

Creating a fully-functioning {{site.mesh_product_name}} global control plane in {{site.konnect_short_name}} involves the following steps:

1. Create the global control plane in {{site.konnect_short_name}}.
1. Add and configure a zone for your control plane.
1. Configure `kumactl` to connect to your global control plane.
1. Add services to your service mesh.

### Prerequisites

* [A Kubernetes cluster with a load balancer](https://kubernetes.io/docs/setup/)
* [`kubectl` installed and configured to communicate with your Kubernetes cluster](https://kubernetes.io/docs/tasks/tools/#kubectl)
* [Download the latest version of {{site.mesh_product_name}}](/mesh/latest/production/install-kumactl/)
* Mutual TLS only: If you plan to automatically encrypt [mTLS](/mesh/latest/policies/mutual-tls/) traffic for all the services in your service mesh, you will need the mTLS certificate name and authority.
* Logging only: If you plan to add a logging backend to log traffic via the TrafficLog policy, you will need the IP address and format (WHAT IS THIS?) of your logging backend. [WHICH BACKENDS ARE AVAILABLE?]
* Tracing only: If you plan to add a tracing backend to ___ using the TrafficTrace policy, you will need the sampling [WHAT IS THIS?] and the url of your backend. [WHICH BACKENDS ARE AVAILABLE?]
* Metrics only: If you want to port metrics from your data plane, you will need the data plane port and path of your metrics backend. [WHICH BACKENDS ARE AVAILABLE?]

### Create and configure the global control plane

1. From the left navigation menu in {{site.konnect_short_name}}, open [MESH MANAGER ICON HERE] [**Mesh Manager**](https://cloud.konghq.com/mesh-manager).
1. Click **New Control Plane** and complete the fields as needed.
1. Select the control plane you just created, and then click **Zone CPs** in the sidebar.
1. Click **Create Zone**, configure the fields as needed, and follow the steps in the wizard to connect your zone to {{site.konnect_short_name}}.
1. Create a [personal access token in {{site.konnect_short_name}}](/konnect/getting-started/import/#generate-a-personal-access-token). This will be used to connect your global control plane with your {{site.product_mesh_name}} service mesh.
1. Run the following to ?:
    ```sh
    kumactl config control-planes add --address https://us.api.konghq.com/v0/mesh/control-planes/MGCP_ID/api --name mink-dev --headers 'authorization=Bearer KPAT'
    ```
    * **MGCP_ID:** Replace this with the control plane ID found on the overview page for your global control plane.
    * **KPAT:** Replace this with the personal access token you created for the control plane.

### what's next? how do I add services?



### View service mesh entities

Now that your service mesh is deployed in {{site.mesh_product_name}}, the following information will be displayed in Mesh Manager for each control plane:

* Meshes and data plane proxies with [mTLS](/mesh/latest/policies/mutual-tls/)
* RBAC
* Zone control planes
* [Zone Ingresses](/mesh/latest/explore/zone-ingress/)
* [Zone Egresses](/mesh/latest/explore/zoneegress/)
* Services associated with your service mesh
* [Gateways](/mesh/latest/explore/gateway/) associated with your service mesh
* Data plane proxies
* Policies

[SCREENSHOT]

[TABLE WITH ALL THE THINGS THAT DESCRIBE THE SCREENSHOT]

## More information

* [Multi-zone deployment](/mesh/latest/deployments/multi-zone/) - Find out how multi-zone deployment works in {{site.mesh_product_name}}.
* [Gateway](/mesh/latest/explore/gateway/) - Learn about the {{site.mesh_product_name}} Gateway.
* [Zone Ingresses](/mesh/latest/explore/zone-ingress/) - Find out how to configure the Zone Ingress entity in {{site.mesh_product_name}}.
* [Zone Egresses](/mesh/latest/explore/zoneegress/) - Find out how to configure the Zone Egress entity in {{site.mesh_product_name}}.
* [Observability](/mesh/latest/explore/observability/) - Learn how to configure different observability tools to work with {{site.mesh_product_name}}. 