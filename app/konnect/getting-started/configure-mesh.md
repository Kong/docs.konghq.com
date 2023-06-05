---
title: Configure a Global Control Plane with Kong Mesh
content_type: tutorial
---

Using Mesh Manager, you can create a {{site.mesh_product_name}} global control plane to manage your {{site.konnect_saas}} services. 

A global control plane configures the basic settings for all services associated with a service mesh. If you have a multi-zone deployment, you can have one global control plane and different control planes for each zone. This allows you to easily configure settings for all services by only editing one configuration file. 

![mesh global control plane](/assets/images/diagrams/gslides/kuma_multizone.svg)

> _**Figure 1:** {{site.mesh_product_name}} can support multiple zones (like a Kubernetes cluster, VPC, data center, etc.) together in the same distributed deployment. Then, you can create multiple isolated virtual meshes with the same control plane in order to support every team and application in the organization._

For the purposes of this guide, you'll use {{site.mesh_product_name}} as your service mesh to create a global control plane. You will use Kubernetes to install various service mesh components.

## Prerequisites

* [A Kubernetes cluster with a load balancer](https://kubernetes.io/docs/setup/)
* [`kubectl` installed and configured to communicate with your Kubernetes cluster](https://kubernetes.io/docs/tasks/tools/#kubectl)
* [Download the latest version of {{site.mesh_product_name}}](/mesh/latest/production/install-kumactl/)

## Create a global control plane in {{site.konnect_short_name}}
 
1. From the left navigation menu in {{site.konnect_short_name}}, open [MESH MANAGER ICON HERE] [**Mesh Manager**](https://cloud.konghq.com/mesh-manager).
1. Click **New Control Plane**.
1. Enter "example-cp" in the **Mesh name** field.
1. Click **Save**.

You now have a {{site.mesh_product_name}} global control plane. This control plane can't do anything at the moment because we need to connect a zone to it next. 

## Create a zone in the global control plane

<!-- some explanation of why you need to add a zone, also mention the token stuff-->

1. In [MESH MANAGER ICON HERE] [**Mesh Manager**](https://cloud.konghq.com/mesh-manager), click the `example-cp` control plane you just created, and then click **Zone CPs** in the sidebar.
1. Click **Create Zone**. 
1. Enter "eu" in the **Name** field for the new zone, and then click **Create Zone & generate token**. 
    {:.note}
    > **Note:** The zone name must consist of lower case alphanumeric characters, `.`, or `-`. It must also start and end with an alphanumeric character.
1. <!-- Should we have them enable Ingress and Egress? --> 
1. <!-- can/should they use our Helm charts? those could be nice to get started quickly in this getting started section-->
1. Follow the instructions that display to set up Helm and a secret token. 
    Once {{site.konnect_short_name}} finds the newly created mesh, it will display it. 
1. <!--I was prompted to add a license, is that necessary?-->
1. Click **Next**.
1. <!--Does this just take you to your list of meshes/control planes?-->

You now have a very basic {{site.mesh_product_name}} service mesh added to {{site.konnect_short_name}}. This service mesh can't do anything at the moment until we add services and additional configurations to it.

## Configure `kumactl` to connect to your global control plane

<!--Why do we need to do this? Why do the two need to be connected?-->

1. In {{site.konnect_short_name}}, select your user icon to open the context menu and click **Personal access tokens**, then click **Generate token**.
1. Enter "control-plane" in the **Name** field and click **Generate**.
1. Copy the personal access token that displays.
1. From the left navigation menu in {{site.konnect_short_name}}, open [MESH MANAGER ICON HERE] [**Mesh Manager**](https://cloud.konghq.com/mesh-manager) and select the `example-cp` control plane.
1. Copy your control plane ID.
1. Run the following to ?:
    ```sh
    kumactl config control-planes add --address https://us.api.konghq.com/v0/mesh/control-planes/MGCP_ID/api --name mink-dev --headers 'authorization=Bearer KPAT'
    ```
    * **MGCP_ID:** Replace this with the control plane ID.
    * **KPAT:** Replace this with the personal access token you created for the control plane.
<!-- I got this error: Error: HTTPS is used. You need to specify either --ca-cert-file so kumactl can verify authenticity of the Control Plane or --skip-verify to skip verification-->

<!-- some sentence that explains what the result is-->

## Add services to your service mesh using the Kubernetes demo app

Now that you've added a global control plane and a zone to your service mesh in {{site.konnect_short_name}}, you can add services to your mesh. You can use the {{site.mesh_product_name}} Kubernetes demo app to set up two services so you can see how {{site.mesh_product_name}} can be used to control services, monitor traffic, and track resource status.

The demo application consists of two services:

* `demo-app`: A web application that lets you increment a numeric counter
* `redis`: A data store for the counter

To add the services to your mesh using the demo app, run the following:

```sh
kubectl apply -f https://raw.githubusercontent.com/kumahq/kuma-demo/master/kubernetes/kuma-demo-aio.yaml
```

You can see the services the Kubernetes demo app added by navigating to **Mesh Manager** in the sidebar of {{site.konnect_short_name}}, selecting the `example-cp` and clicking **Meshes** in the sidebar. You can view the services associated with that mesh by clicking **Default** and the **Services** tab.

After you add a service to your service mesh, the {{site.konnect_short_name}} will be populated with metrics from your service mesh. For more information about the Kubernetes demo app, see [Explore {{site.mesh_product_name}} with the Kubernetes demo app](/mesh/latest/quickstart/kubernetes/).

## Conclusion

By following the instructions in this guide, you've created a {{site.mesh_product_name}} global control plane, added a zone to it, configured `kumactl` to connect to your global control plane, and added services to the control plane. 

Now that you've completed this tutorial, you can continue to configure your service mesh in {{site.konnect_short_name}} by following some of these guides:

* [Zone Ingress](/mesh/latest/production/cp-deployment/zone-ingress/) - Set up zone ingress in {{site.mesh_product_name}}.
* [Zone Egress](/mesh/latest/production/cp-deployment/zoneegress/) - Set up zone egress in {{site.mesh_product_name}}.
* [Mutual TLS](/mesh/latest/policies/mutual-tls/) - Configure mTLS with {{site.mesh_product_name}}. 
* [Observability](/mesh/latest/explore/observability/) - Find out how to configure observability with {{site.mesh_product_name}}.
* [Traffic Log](/mesh/latest/policies/traffic-log/) - Learn how to configure logging with {{site.mesh_product_name}}.

## Next steps

Now that you've configured a global control plane, you can continue by [importing {{site.base_gateway}} entities into {{site.konnect_short_name}}](/getting-started/import/).