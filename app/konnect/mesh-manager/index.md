---
title: About Mesh Manager
content_type: explanation
---

Mesh Manager in {{site.konnect_product_name}} allows you to create a service mesh and view your {{site.service_mesh_name}} service meshes in the {{site.konnect_short_name}} UI. This allows you to use {{site.konnect_short_name}}'s federated access for platform tenants, deep API analytics, API productization with Dev Portal, and a service catalogue offering to service mesh managed services.

Descriptions of use cases: 

* Mesh global control plane
* Multi-zone, not standalone?
* What else?

Here are a few benefits of creating a service mesh in {{site.konnect_short_name}} over a self-managed setup:

* **Kong-managed global control plane:** By creating your service mesh in {{site.konnect_short_name}}, your global control plane is managed by Kong. 
* **All entities in one place:** You can view all your information, such as entities from Kong Ingress Controller (KIC) for Kubernetes, {{site.konnect_short_name}} managed entities, and now service mesh data all from one central platform. 
* **Managed UI wizard setup:** {{site.konnect_short_name}} simplifies the process of creating a service mesh by providing a setup wizard in the UI that guides you through the steps. 

## Create a service mesh in {{site.konnect_short_name}}

When you create a {{site.service_mesh_name}} control plane in {{site.konnect_short_name}}, you configure the settings for the control plane in the {{site.konnect_short_name}} UI and then deploy the control plane in {{site.service_mesh_name}} using `kumactl`. 

### Prerequisites

* Mutual TLS only: If you plan to automatically encrypt mTLS traffic for all the services in your service mesh, you will need the mTLS certificate name and authority.
* Logging only: If you plan to add a logging backend to log traffic via the TrafficLog policy, you will need the IP address and format (WHAT IS THIS) of your logging backend. [WHICH BACKENDS ARE AVAILABLE]
* Tracing only: If you plan to add a tracing backend to ___ using the TrafficTrace policy, you will need the sampling [WHAT IS THIS] and the url of your backend. [WHICH BACKENDS ARE AVAILABLE]
* Metrics only: If you want to port metrics from your data plane, you will need the data plane port and path of your metrics backend. [WHICH BACKENDS ARE AVAILABLE]

### Deploy the service mesh in {{site.service_mesh_name}}

After you create a service mesh in {{site.konnect_short_name}}, you must deploy it in {{site.service_mesh_name}} before you can view the service mesh details in {{site.konnect_short_name}}.

Next, follow the instructions in the [Deploy a standalone control plane](/mesh/latest/production/cp-deployment/stand-alone/) {{site.service_mesh_name}} documentation.

### View service mesh entities

Now that your service mesh is deployed in {{site.service_mesh_name}}, the following information will be displayed in Mesh Manager in {{site.konnect_short_name}}:

* Meshes and data plane proxies with mTLS
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

* [Multi-zone deployment](/mesh/latest/deployments/multi-zone/) - Find out how multi-zone deployment works in {{site.service_mesh_name}}.
* [Gateway](/mesh/latest/explore/gateway/) - Learn about the {{site.service_mesh_name}} Gateway.
* [Zone Ingresses](/mesh/latest/explore/zone-ingress/) - Find out how to configure the Zone Ingress entity in {{site.service_mesh_name}}.
* [Zone Egresses](/mesh/latest/explore/zoneegress/) - Find out how to configure the Zone Egress entity in {{site.service_mesh_name}}.
* [Observability](/mesh/latest/explore/observability/) - Learn how to configure different observability tools to work with {{site.service_mesh_name}}. 