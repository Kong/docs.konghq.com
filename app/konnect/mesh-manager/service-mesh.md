---
title: Create a service mesh
content_type: how-to
---

Creating a fully-functioning {{site.mesh_product_name}} deployment in {{site.konnect_short_name}} involves the following steps:

1. Create the global control plane in {{site.konnect_short_name}}.
1. Add and configure a zone for your control plane.
1. Configure `kumactl` to connect to your global control plane.
1. Add services to your service mesh.

### Prerequisites

* [A Kubernetes cluster with a load balancer](https://kubernetes.io/docs/setup/)
* [`kubectl` installed and configured to communicate with your Kubernetes cluster](https://kubernetes.io/docs/tasks/tools/#kubectl)
* The latest version of [{{site.mesh_product_name}} installed](/mesh/latest/production/install-kumactl/)

### Create and configure the global control plane

1. From the left navigation menu in {{site.konnect_short_name}}, open  (/assets/images/icons/konnect/icn-mesh-manager.svg) [**Mesh Manager**](https://cloud.konghq.com/mesh-manager).
1. Click **New Control Plane** and complete the fields as needed.
1. Select the control plane you just created, and then click **Zones** in the sidebar.
1. Click **Create Zone**, configure the fields as needed, and follow the steps in the wizard to connect your zone to {{site.konnect_short_name}}.
1. Create a [personal access token in {{site.konnect_short_name}}](/konnect/getting-started/import/#generate-a-personal-access-token). This will be used to connect your global control plane with your {{site.product_mesh_name}} service mesh.
1. Run the following to connect your global control plane to {{site.product_mesh_name}}:
    ```sh
    kumactl config control-planes add --address https://us.api.konghq.com/v0/mesh/control-planes/MGCP_ID/api --name mink-dev --headers 'authorization=Bearer KPAT'
    ```
    * **MGCP_ID:** Replace this with the control plane ID found on the overview page for your global control plane.
    * **KPAT:** Replace this with the personal access token you created for the control plane.

### Add services to your service mesh

After you've configured your global control plane, you can ensure your services are added to your service mesh in {{site.konnect_short_name}}. 

If you're using Kubernetes, you must add the [kuma.io/sidecar-injection](/mesh/latest/reference/kubernetes-annotations/#kumaiosidecar-injection) label to the namespace. This will automatically enable {{site.product_mesh_name}} and register the service or pod in the service mesh.

If you are using universal, you must create a [dataplane definition](/mesh/latest/production/dp-config/dpp-on-universal/), pass it to the `kuma-dp run` command on a virtual machine, and point it to the local zone control plane. When you use universal, you connect the local zone control plane to {{site.konnect_short_name}} instead of the dataplanes.


## More information

* [Multi-zone deployment](/mesh/latest/deployments/multi-zone/) - Find out how multi-zone deployment works in {{site.mesh_product_name}}.
* [Gateway](/mesh/latest/explore/gateway/) - Learn about the {{site.mesh_product_name}} Gateway.
* [Zone Ingresses](/mesh/latest/explore/zone-ingress/) - Find out how to configure the Zone Ingress entity in {{site.mesh_product_name}}.
* [Zone Egresses](/mesh/latest/explore/zoneegress/) - Find out how to configure the Zone Egress entity in {{site.mesh_product_name}}.
* [Observability](/mesh/latest/explore/observability/) - Learn how to configure different observability tools to work with {{site.mesh_product_name}}. 
