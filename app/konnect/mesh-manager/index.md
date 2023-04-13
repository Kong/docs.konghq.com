---
title: About Mesh Manager
content_type: explanation
---

Mesh Manager in {{site.konnect_product_name}} allows you to create a service mesh and view your {{site.mesh_product_name}} service meshes in the {{site.konnect_short_name}} UI. This allows you to use {{site.konnect_short_name}}'s federated access for platform tenants, deep API analytics, API productization with Dev Portal, and a service catalogue offering for service mesh managed services.  

Mesh Manager is ideal for organizations who want to have a global control plane that allows you to run your service mesh in multiple zones. You can run a mix of Kubernetes and Universal zones. Your mesh environment can include multiple isolated service meshes (multi-tenancy), and workloads running in different regions, on different clouds, or in different datacenters.

Here are a few benefits of creating a service mesh in {{site.konnect_short_name}} over a self-managed setup:

* **Kong-managed global control plane:** By creating your service mesh in {{site.konnect_short_name}}, your global control plane is managed by Kong. 
* **All entities in one place:** You can view all your information, such as entities from Kong Ingress Controller (KIC) for Kubernetes, {{site.konnect_short_name}} managed entities, and now service mesh data all from one central platform. 
* **Managed UI wizard setup:** {{site.konnect_short_name}} simplifies the process of creating a service mesh by providing a setup wizard in the UI that guides you through the configuration steps. 

## Create a service mesh in {{site.mesh_product_name}}

When you create a {{site.mesh_product_name}} control plane in {{site.konnect_short_name}}, you configure the settings for the control plane in the {{site.konnect_short_name}} UI and then deploy the control plane in {{site.mesh_product_name}} using `kumactl`. 

### Prerequisites

* Mutual TLS only: If you plan to automatically encrypt [mTLS](/mesh/latest/policies/mutual-tls/) traffic for all the services in your service mesh, you will need the mTLS certificate name and authority.
* Logging only: If you plan to add a logging backend to log traffic via the TrafficLog policy, you will need the IP address and format (WHAT IS THIS) of your logging backend. [WHICH BACKENDS ARE AVAILABLE]
* Tracing only: If you plan to add a tracing backend to ___ using the TrafficTrace policy, you will need the sampling [WHAT IS THIS] and the url of your backend. [WHICH BACKENDS ARE AVAILABLE]
* Metrics only: If you want to port metrics from your data plane, you will need the data plane port and path of your metrics backend. [WHICH BACKENDS ARE AVAILABLE]

### Deploy the service mesh in {{site.mesh_product_name}}

After you create a service mesh in {{site.konnect_short_name}}, you must deploy it in {{site.mesh_product_name}} before you can view the service mesh details in {{site.konnect_short_name}}.

Next, follow the instructions in the [Deploy a standalone control plane](/mesh/latest/production/cp-deployment/stand-alone/) {{site.mesh_product_name}} documentation.

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