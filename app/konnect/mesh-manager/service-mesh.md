---
title: Configure a Mesh Global Control Plane with the Kubernetes demo app
content_type: tutorial
---

Using Mesh Manager, you can create global control planes to manage your {{site.mesh_product_name}} meshes. This guide explains how to configure a global control plane with {{site.mesh_product_name}}, and then install the Kubernetes demo app so you can test out the {{site.mesh_product_name}} interface in {{site.konnect_saas}}.

## Prerequisites

* A Kubernetes cluster with [load balancer service capabilities](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer)
* `kubectl` installed and configured to communicate with your Kubernetes cluster
* [The latest version of {{site.mesh_product_name}}](/mesh/latest/production/install-kumactl/)

## Create a global control plane in {{site.konnect_short_name}}

Before you can add your services to the mesh or any configuration, you must create a global control plane in {{site.konnect_short_name}}. This global control plane is hosted by {{site.konnect_short_name}}. The global control plane allows you to configure the data plane proxies for handling mesh traffic. 
 
1. From the left navigation menu in {{site.konnect_short_name}}, open {% konnect_icon mesh-manager %} [**Mesh Manager**](https://cloud.konghq.com/mesh-manager).
1. Click **New Global Control Plane**.
1. Enter `example-cp` in the **Name** field and click **Save**.

You now have a global control plane. This control plane won't have any functionality until you connect a zone to it.

## Create a zone in the global control plane

After creating the global control plane, you must add a zone to that control plane. Adding a zone allows you to manage services added to that zone and send and receive configuration changes to the zone.

1. Select the `example-cp` control plane you just created and then click **Create Zone**.  
  Mesh Manager automatically creates a [managed service account](/konnect/org-management/system-accounts/) that is only used to issue a token during the zone creation process.
1. Enter `zone-1` in the **Name** field for the new zone, and then click **Create Zone & generate token**. 
    
    {:.note}
    > **Note:** The zone name must consist of lower case alphanumeric characters or `-`. It must also start and end with an alphanumeric character.
1. Follow the instructions to set up Helm and a secret token. 
    {{site.konnect_short_name}} will automatically start looking for the zone. Once {{site.konnect_short_name}} finds the zone, it will display it. 

You now have a very basic {{site.mesh_product_name}} service mesh added to {{site.konnect_short_name}}. This service mesh can only create meshes and policies at the moment, so you need to add services and additional configurations to it.

## Add services to your mesh

Now that you've added a global control plane and a zone to your service mesh in {{site.konnect_short_name}}, you can add services to your mesh. 

In this tutorial, we will use the services from the demo app as an easy way to see how {{site.mesh_product_name}} services can be managed with Mesh Manager. The {{site.mesh_product_name}} Kubernetes demo app sets up four services so you can see how {{site.mesh_product_name}} can be used to control services, monitor traffic, and track resource status:


* `frontend`: A web application that lets you browse an online clothing store
* `backend`: A Node.js API for querying and filtering clothing items
* `postgres`: A database for storing clothing item reviews
* `redis`: A data store for the clothing item star ratings 

To add the services to your mesh using the demo app, run the following command:

```bash
kubectl apply -f https://raw.githubusercontent.com/kumahq/kuma-demo/master/kubernetes/kuma-demo-aio.yaml
```

You can see the services the Kubernetes demo app added by navigating to **Mesh Manager** in the sidebar of {{site.konnect_short_name}}, selecting the `example-cp` and clicking **Meshes** in the sidebar. You can view the services associated with that mesh by clicking **Default** and the **Services** tab.

For more information about the Kubernetes demo app, see [Explore {{site.mesh_product_name}} with the Kubernetes demo app](/mesh/latest/quickstart/kubernetes/).

## Configure `kumactl` to connect to your global control plane

`kumactl` is a CLI tool that you can use to access {{site.mesh_product_name}}. It can create, read, update, and delete resources in {{site.mesh_product_name}} in Universal/{{site.konnect_short_name}} mode. Since we are deploying {{site.mesh_product_name}} in Kubernetes mode for this tutorial, `kumactl` is read-only. Instead, `kubectl` is used to apply changes to {{site.mesh_product_name}}. Although we don't use `kumactl` in this tutorial because we are using Kubernetes, it's still best practice to configure it to connect to your global control plane.

1. From the left navigation menu in {{site.konnect_short_name}}, open {% konnect_icon mesh-manager %} [**Mesh Manager**](https://cloud.konghq.com/mesh-manager) and select the `example-cp` control plane.
1. Select **Configure kumactl** from the **Global Control Plane Actions** dropdown menu and follow the steps in the wizard to connect `kumactl` to the control plane.
1. Verify that the services you added from the previous section with the Kubernetes demo app are running correctly:
  ```bash
  kumactl get dataplanes
  ```
If your data planes were configured correctly with the demo app, the output should return all four data planes: `frontend`, `backend`, `postgres`, and `redis`.

You can now issue commands to your global control plane using `kumactl`. You can see the [`kumactl` command reference](/mesh/latest/explore/cli/#kumactl) for more information about the commands you can use.

## Conclusion

By following the instructions in this guide, you've created a global control plane for {{site.mesh_product_name}}, added a zone to it, configured `kumactl` to connect to your global control plane, and added services to the mesh. 

## Next steps

Now that you've configured a global control plane, you can continue to configure your service mesh in {{site.konnect_short_name}} by [enabling mTLS and traffic permissions](/mesh/latest/quickstart/kubernetes/#enable-mutual-tls-and-traffic-permissions) on your demo app services.
