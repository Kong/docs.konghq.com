---
title: Create a mesh
content_type: how-to
beta: true
---

Creating a fully-functioning {{site.mesh_product_name}} deployment in {{site.konnect_short_name}} involves the following steps:

1. Create the global control plane in {{site.konnect_short_name}}.
1. Add and configure a zone for your control plane.
1. Configure `kumactl` to connect to your global control plane.
1. Add services to your mesh.

### Prerequisites

* [A Kubernetes cluster with a load balancer](https://kubernetes.io/docs/setup/)
* [`kubectl` installed and configured to communicate with your Kubernetes cluster](https://kubernetes.io/docs/tasks/tools/#kubectl)
* The latest version of [{{site.mesh_product_name}} installed](/mesh/latest/production/install-kumactl/)

### Create and configure the global control plane

1. From the left navigation menu in {{site.konnect_short_name}}, open {% konnect_icon mesh-manager %} [**Mesh Manager**](https://cloud.konghq.com/mesh-manager).
1. Click **New Control Plane** and complete the fields as needed.
1. Select the control plane you just created, and then click **Zones** in the sidebar.
1. Click **Create Zone**, configure the fields as needed, and follow the steps in the wizard to connect your zone to {{site.konnect_short_name}}.
   
     {:.note}
    > **Note:** Mesh Manager automatically creates a [managed service account](/konnect/org-management/system-accounts/) that is only used in the zone creation process. 
    This managed system account can't be edited or deleted manually. 
    Instead, its life cycle is managed by {{site.konnect_short_name}}. 
    It is deleted automatically by {{site.konnect_short_name}} when the zone is deleted.
    
1. From the {% konnect_icon mesh-manager %} [**Mesh Manager**](https://cloud.konghq.com/mesh-manager) navigation menu, and select the control plane you created in step 2.
1. Select **Configure kumactl** from the **Control Plane Actions** dropdown menu and follow the steps in the wizard to connect `kumactl` to the control plane.

### Add services to your mesh

After you've configured your global control plane, you can begin adding your services to your mesh in {{site.konnect_short_name}}. 

If you're using Kubernetes, you must add the [kuma.io/sidecar-injection](/mesh/latest/reference/kubernetes-annotations/#kumaiosidecar-injection) label to the namespace or deployments you want to bring into the mesh. This will automatically enable {{site.product_mesh_name}} and register the service pods in the mesh.

If you are using universal, you must create a [dataplane definition](/mesh/latest/production/dp-config/dpp-on-universal/), pass it to the `kuma-dp run` command on a virtual machine, and point it to the local zone control plane.


## More information

* [Multi-zone deployment](/mesh/latest/deployments/multi-zone/) - Find out how multi-zone deployment works in {{site.mesh_product_name}}.
* [Gateway](/mesh/latest/explore/gateway/) - Learn about the {{site.mesh_product_name}} Gateway.
* [Zone Ingresses](/mesh/latest/explore/zone-ingress/) - Find out how to configure the Zone Ingress entity in {{site.mesh_product_name}}.
* [Zone Egresses](/mesh/latest/explore/zoneegress/) - Find out how to configure the Zone Egress entity in {{site.mesh_product_name}}.
* [Observability](/mesh/latest/explore/observability/) - Learn how to configure different observability tools to work with {{site.mesh_product_name}}. 
