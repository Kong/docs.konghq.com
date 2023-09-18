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

## Supported installation options

{{site.konnect_short_name}} supports the following installation options for {{site.mesh_product_name}} zones:

* Kubernetes
* Helm
* OpenShift
* Docker
* Amazon Linux
* Redhat
* CentOS
* Debian
* Ubuntu
* macOS

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
