---
title: About Mesh Manager
content_type: explanation
beta: true
---

[Mesh Manager](https://cloud.konghq.com/mesh-manager) in {{site.konnect_product_name}} allows you to create, manage and view your {{site.mesh_product_name}} [service meshes](/mesh/latest/introduction/what-is-a-service-mesh/) in the {{site.konnect_short_name}} UI and using the {{site.konnect_short_name}} platform.

A global control plane is a managed central component that stores and distributes (to local zones) all of the configuration and policies for your meshes and services. The global control planes are responsible for validating and accepting connections from local zone control planes and distributing the appropriate configuration down to each local zone as required. They also serve as the target for all `kumactl` CLI operations when manipulating resources and configuration within the [mesh deployment](/mesh/latest/production/deployment/multi-zone/).

![mesh global control plane](/assets/images/diagrams/diagram-mesh-in-konnect.png)

> _**Figure 1:** {{site.mesh_product_name}} can support multiple zones (like a Kubernetes cluster, VPC, data center, etc.) together in the same distributed deployment. Then, you can create multiple isolated virtual meshes with the same control plane in order to support every team and application in the organization._

Mesh Manager is ideal for organizations who want to have one or more global control planes that allow you to run your mesh deployments across multiple zones. You can run a mix of Kubernetes and Universal zones. Your mesh deployment environments can include multiple isolated meshes (for multi-tenancy) and workloads running in different regions, on different clouds, or in different data-centers.

Here are a few benefits of creating a mesh deployment in {{site.konnect_short_name}} instead of a self-managed setup:

* **Kong-managed global control plane:** By creating your mesh in {{site.konnect_short_name}}, your global control plane is managed by Kong. 
* **All entities in one place:** You can view all your information, such as entities from Kong Ingress Controller (KIC) for Kubernetes, {{site.konnect_short_name}}-managed entities, and now service mesh data all from one central platform. 
* **Managed UI wizard setup:** {{site.konnect_short_name}} simplifies the process of creating a mesh by providing a setup wizard in the UI that guides you through the configuration steps.

## Create a mesh

Creating a fully-functioning {{site.mesh_product_name}} deployment in {{site.konnect_short_name}} involves the following steps:

1. Create the global control plane in {{site.konnect_short_name}} by going to [Mesh Manager](https://cloud.konghq.com/mesh-manager).
1. Add and configure a zone for your control plane from the mesh global control plane dashboard.
1. Configure `kumactl` to connect to your global control plane following the wizard in the UI.
1. Add services to your mesh.
    * If you're using Kubernetes, you must add the [kuma.io/sidecar-injection](/mesh/latest/reference/kubernetes-annotations/#kumaiosidecar-injection) label to the namespace or deployments you want to bring into the mesh. This will automatically enable {{site.product_mesh_name}} and register the service pods in the mesh.
    * If you are using universal, you must create a [dataplane definition](/mesh/latest/production/dp-config/dpp-on-universal/), pass it to the `kuma-dp run` command on a virtual machine, and point it to the local zone control plane.

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

![mesh control plane dashboard](/assets/images/docs/konnect/konnect-mesh-control-plane-dashboard.png)
> _**Figure 1:** Example control plane dashboard with several zones and services, a service mesh, and data plane proxies._
