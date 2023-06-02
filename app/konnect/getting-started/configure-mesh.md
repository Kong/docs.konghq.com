---
title: Configure a Global Control Plane with Kong Mesh
content_type: tutorial
---

Using Mesh Manager, you can create a {{site.mesh_product_name}} global control plane to manage your {{site.konnect_saas}} services. 

[IMAGE OF GLOBAL CONTROL PLANE MESH THING]

A global control plane configures the basic settings for all services associated with a service mesh. If you have a multi-zone deployment, you can have one global control plane and different control planes for each zone. This allows you to easily configure settings for all services by only editing one configuration file. 

For the purposes of this guide, you'll use {{site.mesh_product_name}} as your service mesh to create a global control plane to manage the service you created previously in the [Configure a Service](/konnect/getting-started/configure-service/) section of the Get Started in {{site.konnect_saas}} documentation. This guide uses Kubernetes to install various service mesh components.

## Prerequisites

* [A Kubernetes cluster with a load balancer](https://kubernetes.io/docs/setup/)
* `kubectl` installed and configured to communicate with your Kubernetes cluster

## Create and deploy a global control plane

In this section, you will be installing a service mesh ({{site.mesh_product_name}}), creating a global control plane in {{site.konnect_short_name}}, and deploying the control plane in {{site.mesh_product_name}}.

### Instructions

1. Download {{site.mesh_product_name}}:
    ```sh
    curl -L https://docs.konghq.com/mesh/installer.sh | VERSION=2.2.0 sh -
    ```
    Ensure that `VERSION` is replaced with the latest version of {{site.mesh_product_name}}. 
1. From the left navigation menu in {{site.konnect_short_name}}, open [MESH MANAGER ICON HERE] [**Mesh Manager**](https://cloud.konghq.com/mesh-manager).
1. Click **New Control Plane**.
1. Enter "example-cp" in the **Mesh name** field.
1. Click **Save**.
1. Click the `example-cp` control plane you just created, and then click **Zone CPs** in the sidebar. 
    You must add a zone to the control plane because...
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

### Explanation of instructions

You now have a very basic {{site.mesh_product_name}} service mesh added to {{site.konnect_short_name}}. This service mesh can't do anything at the moment until we add services and additional configurations to it.

## Configure `kumactl` to connect to your mesh global control plane

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

Explain everything that happened and what they did/recap. 

Then provide some links for potential other things they could do (mTLS, policies).

After you complete this tutorial, you can continue to configure your service mesh in {{site.konnect_short_name}}.

* [Zone Ingress](/mesh/latest/production/cp-deployment/zone-ingress/) - Set up zone ingress in {{site.mesh_product_name}}.
* [Zone Egress](/mesh/latest/production/cp-deployment/zoneegress/) - Set up zone egress in {{site.mesh_product_name}}.
* [Mutual TLS](/mesh/latest/policies/mutual-tls/) - Configure mTLS with {{site.mesh_product_name}}. 
* [Observability](/mesh/latest/explore/observability/) - Find out how to configure observability with {{site.mesh_product_name}}.
* [Traffic Log](/mesh/latest/policies/traffic-log/) - Learn how to configure logging with {{site.mesh_product_name}}.

## Next steps

Now that you've configured a global control plane, you can continue by [importing {{site.base_gateway}} entities into {{site.konnect_short_name}}](/getting-started/import/).