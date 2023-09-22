---
title: Configure a Global Control Plane with Kong Mesh
content_type: tutorial
beta: true
---

Using Mesh Manager, you can create {{site.mesh_product_name}} global control planes to manage your {{site.konnect_saas}} mesh services. 

A global control plane is a managed central component that stores and distributes (to local zones) all of the configuration and policies for your meshes and services. The global control planes are responsible for validating and accepting connections from local zone control planes and distributing the appropriate configuration down to each local zone as required. They also serve as the target for all `kumactl` CLI operations when manipulating resources and configuration within the [mesh deployment](/mesh/latest/production/deployment/multi-zone/).

![mesh global control plane](/assets/images/diagrams/gslides/kuma_multizone.svg)

> _**Figure 1:** {{site.mesh_product_name}} can support multiple zones (like a Kubernetes cluster, VPC, data center, etc.) together in the same distributed deployment. Then, you can create multiple isolated virtual meshes with the same control plane in order to support every team and application in the organization._

For the purposes of this guide, you'll use {{site.konnect_short_name}} to create a global control plane. You will use Kubernetes to install various service mesh components.

## Prerequisites

* [A Kubernetes cluster with a load balancer](https://kubernetes.io/docs/setup/)
* [`kubectl` installed and configured to communicate with your Kubernetes cluster](https://kubernetes.io/docs/tasks/tools/#kubectl)
* [Download the latest version of {{site.mesh_product_name}}](/mesh/latest/production/install-kumactl/)

## Create a global control plane in {{site.konnect_short_name}}
 
1. From the left navigation menu in {{site.konnect_short_name}}, open {% konnect_icon mesh-manager %} [**Mesh Manager**](https://cloud.konghq.com/mesh-manager).
1. Click **New Control Plane**.
1. Enter "example-cp" in the **Name** field.
1. Click **Save**.

You now have a {{site.mesh_product_name}} global control plane. This control plane can't do anything at the moment because we need to connect a zone to it next. 

## Create a zone in the global control plane

After creating the global control plane, you must add a zone to that control plane. Adding a zone allows you to manage services added to that zone and send and receive configuration changes to the zone. 

{:.important}
> **Important:** Mesh zones are priced based on consumption. Your Konnect free trial provides enough credits for your first two zones. For more information about the pricing and consumption of additional zones, see the [Pricing and Plans](/konnect/account-management/) documentation and Kong's [Pricing](https://konghq.com/pricing) page.

1. In {% konnect_icon mesh-manager %} [**Mesh Manager**](https://cloud.konghq.com/mesh-manager), click the `example-cp` control plane you just created, and then click **Zones** in the sidebar.
1. Click **Create Zone**. 
1. Enter "zone-1" in the **Name** field for the new zone, and then click **Create Zone & generate token**. 
    {:.note}
    > **Note:** The zone name must consist of lower case alphanumeric characters or `-`. It must also start and end with an alphanumeric character.
1. Ensure both [**Zone Ingress**](/mesh/latest/production/cp-deployment/zone-ingress/) and [**Zone Egress**](/mesh/latest/production/cp-deployment/zoneegress/) are enabled.
1. Follow the instructions that display to set up Helm and a secret token. 
    Once {{site.konnect_short_name}} finds the newly created zone, it will display it. 
1. Click **Next**.

You now have a very basic {{site.mesh_product_name}} service mesh added to {{site.konnect_short_name}}. This service mesh can only create meshes and policies at the moment, so we must add services and additional configurations to it.

## Configure `kumactl` to connect to your global control plane

`kumactl` is a CLI tool that you can use to access {{site.mesh_product_name}}. It can create, read, update, and delete resources in {{site.mesh_product_name}} in Universal/{{site.konnect_short_name}} mode.
<!--* (not sure if I removed the right line, so keeping in for easy swap 
Perform read-only operations on {{site.mesh_product_name}} resources on Kubernetes. -->

You connect `kumactl` to the global control plane in {{site.konnect_short_name}} so that you can run commands against the control plane.

1. From the left navigation menu in {{site.konnect_short_name}}, open {% konnect_icon mesh-manager %} [**Mesh Manager**](https://cloud.konghq.com/mesh-manager) and select the `example-cp` control plane.
1. Select **Configure kumactl** from the **Control Plane Actions** dropdown menu and follow the steps in the wizard to connect `kumactl` to the control plane.

You can now run commands against your global control plane using `kumactl`. You can see the [`kumactl` command reference](/mesh/latest/generated/cmd/kumactl/kumactl/) for more information about the commands you can use.

## Add services to your service mesh using the Kubernetes demo app

Now that you've added a global control plane and a zone to your service mesh in {{site.konnect_short_name}}, you can add services to your mesh. You can use the {{site.mesh_product_name}} Kubernetes demo app to set up four services so you can see how {{site.mesh_product_name}} can be used to control services, monitor traffic, and track resource status.

The demo application consists of four services:

* `frontend`: A web application that lets you browse an online clothing store
* `backend`: A nodejs API for querying and filtering clothing items
* `postgres`: A database for storing clothing item reviews
* `redis`: A data store for the clothing item star ratings

To add the services to your mesh using the demo app, run the following:

```sh
kubectl apply -f https://raw.githubusercontent.com/kumahq/kuma-demo/master/kubernetes/kuma-demo-aio.yaml
```

You can see the services the Kubernetes demo app added by navigating to **Mesh Manager** in the sidebar of {{site.konnect_short_name}}, selecting the `example-cp` and clicking **Meshes** in the sidebar. You can view the services associated with that mesh by clicking **Default** and the **Services** tab.

For more information about the Kubernetes demo app, see [Explore {{site.mesh_product_name}} with the Kubernetes demo app](/mesh/latest/quickstart/kubernetes/).

## Conclusion

By following the instructions in this guide, you've created a {{site.mesh_product_name}} global control plane, added a zone to it, configured `kumactl` to connect to your global control plane, and added services to the mesh. 


## Next steps

Now that you've configured a global control plane, you can continue to configure your service mesh in {{site.konnect_short_name}} by following some of these guides:
{:.note}
> **Note:** When following these or any of the other guides for {{site.mesh_product_name}}, use the instructions for Universal mode as they will show you how to use `kumactl` to interact with {{site.konnect_short_name}} Mesh Manager.

<!--* * [Zone Ingress](/mesh/latest/production/cp-deployment/zone-ingress/) - Set up zone ingress in {{site.mesh_product_name}}.
* [Zone Egress](/mesh/latest/production/cp-deployment/zoneegress/) - Set up zone egress in {{site.mesh_product_name}}.-->
* [Mutual TLS](/mesh/latest/policies/mutual-tls/) - Configure mTLS with {{site.mesh_product_name}}. 
* [Observability](/mesh/latest/explore/observability/) - Find out how to configure observability with {{site.mesh_product_name}}.
* [Traffic Log](/mesh/latest/policies/traffic-log/) - Learn how to configure logging with {{site.mesh_product_name}}.
