---
title: Configure a Mesh Global Control Plane with the Kubernetes demo app
content_type: tutorial
---

Using Mesh Manager, you can create global control planes to manage your {{site.mesh_product_name}} meshes. This guide explains how to configure a global control plane, install the Kubernetes demo app so you can start interfacing with {{site.mesh_product_name}} in {{site.konnect_saas}}, and how to apply {{site.mesh_product_name}} policies. WHY KUMACTL.

In this scenario, you work for a clothing company that has an website where customers can shop online. Your clothing company is anticipating a high number of sales for your next clothing launch, so you want to get ahead of this by rate limiting your services so your website doesn't crash due to the increase in traffic. You decide that the best way to manage your services is with a service mesh. <!-- why not a plugin? --> Your company already uses {{site.konnect_short_name}} for other services, so you decided to use {{site.konnect_short_name}} to host your global control plane along with {{site.mesh_product_name}} for your service mesh. 

## Prerequisites

* A Kubernetes cluster with [load balancer service capabilities](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer)
* `kubectl` installed and configured to communicate with your Kubernetes cluster
* [The latest version of {{site.mesh_product_name}}](/mesh/latest/production/install-kumactl/)

## Create a global control plane in {{site.konnect_short_name}}

Before you can add your services to the mesh or any configuration, you must create a global control plane in {{site.konnect_short_name}}. This global control plane is hosted by {{site.konnect_short_name}}. The global control plane allows you to configure the data plane proxies for handling mesh traffic. In this scenario, the global control plane is used to configure the rate limiting between mesh services.
 
1. From the left navigation menu in {{site.konnect_short_name}}, open {% konnect_icon mesh-manager %} [**Mesh Manager**](https://cloud.konghq.com/mesh-manager).
1. Click **New Global Control Plane**.
1. Enter `clothing-website` in the **Name** field and click **Save**.

You now have a global control plane. This control plane won't have any functionality until you connect a zone to it.

## Create a zone in the global control plane

After creating the global control plane, you must add a zone to that control plane. A zone does _______ and you need one because ______. Adding a zone allows you to manage services added to that zone and send and receive configuration changes to the zone.

1. Select the `clothing-website` control plane you just created and then click **Create Zone**.  
  Mesh Manager automatically creates a [managed service account](/konnect/org-management/system-accounts/) that is only used to issue a token during the zone creation process.
1. Enter `zone-1` in the **Name** field for the new zone, and then click **Create Zone & generate token**. 
    
    {:.note}
    > **Note:** The zone name must consist of lower case alphanumeric characters or `-`. It must also start and end with an alphanumeric character.
1. Follow the instructions to set up Helm and a secret token. 
    {{site.konnect_short_name}} will automatically start looking for the zone. Once {{site.konnect_short_name}} finds the zone, it will display it. 

You now have a very basic {{site.mesh_product_name}} service mesh added to {{site.konnect_short_name}}. This service mesh can only create meshes and policies at the moment, so you need to add services and additional configurations to it.

<!--This is standalone mode, right? Does standalone make sense with this tutorial? Is there a way we can bring that more into the narrative? Ex. In this scenario, we will be using standalone mode because ____-->

## Add services to your mesh

Now that you've added a global control plane and a zone to your service mesh in {{site.konnect_short_name}}, you can add services to your mesh. 

In this tutorial, we will use the services from the demo app as an easy way to see how {{site.mesh_product_name}} services can be managed with Mesh Manager. The {{site.mesh_product_name}} Kubernetes demo app sets up four services so you can see how {{site.mesh_product_name}} can be used to control services, monitor traffic, and track resource status:


* `frontend`: A web application that lets you browse an online clothing store
* `backend`: A Node.js API for querying and filtering clothing items
* `postgres`: A database for storing clothing item reviews
* `redis`: A data store for the clothing item star ratings 

1. To add the services to your mesh using the demo app, run the following command:
  ```bash
  kubectl apply -f https://raw.githubusercontent.com/kumahq/kuma-demo/master/kubernetes/kuma-demo-aio.yaml
  ```

1. Open the `demo.yaml` file locally and copy and paste the following:

  ```yaml
  apiVersion: v1
  kind: Namespace
  metadata:
    name: kong-mesh-system
    labels:
      kuma.io/sidecar-injection: enabled
  ---
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: redis
    namespace: kong-mesh-system
  spec:
    selector:
      matchLabels:
        app: redis
    replicas: 1
    template:
      metadata:
        labels:
          app: redis
      spec:
        containers:
          - name: redis
            image: "redis"
            ports:
              - name: tcp
                containerPort: 6379
            lifecycle:
              preStop: # delay shutdown to support graceful mesh leave
                exec:
                  command: ["/bin/sleep", "30"]
              postStart:
                exec:
                  command: ["/usr/local/bin/redis-cli", "set", "zone", "local"]
  ---
  apiVersion: v1
  kind: Service
  metadata:
    name: redis
    namespace: kong-mesh-system
  spec:
    selector:
      app: redis
    ports:
    - protocol: TCP
      port: 6379
  ---
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: demo-app
    namespace: kong-mesh-system
  spec:
    selector:
      matchLabels:
        app: demo-app
    replicas: 1
    template:
      metadata:
        labels:
          app: demo-app
      spec:
        containers:
          - name: demo-app
            image: "kumahq/kuma-demo"
            env:
              - name: REDIS_HOST
                value: "redis.kuma-demo.svc.cluster.local"
              - name: REDIS_PORT
                value: "6379"
              - name: APP_VERSION
                value: "1.0"
              - name: APP_COLOR
                value: "#efefef"
            ports:
              - name: http
                containerPort: 5000
  ---
  apiVersion: v1
  kind: Service
  metadata:
    name: demo-app
    namespace: kong-mesh-system
  spec:
    selector:
      app: demo-app
    ports:
    - protocol: TCP
      appProtocol: http
      port: 5000
  ```

1. Install resources in the `kong-mesh-system` namespace:
  ```bash
  kubectl apply -f demo.yaml
  ```

1. Port forward the service to the namespace on port `5000`:
  ```bash
  kubectl port-forward svc/demo-app -n kong-mesh-system 5000:5000
  ```

1. In a browser, go to `127.0.0.1:5000`. <!--WHY?-->

You can see the services the Kubernetes demo app added by navigating to **Mesh Manager** in the sidebar of {{site.konnect_short_name}}, selecting the `clothing-website` global control plane and clicking **Meshes** in the sidebar. You can view the services associated with that mesh by clicking **Default** and the **Services** tab.

For more information about the Kubernetes demo app, see [Explore {{site.mesh_product_name}} with the Kubernetes demo app](/mesh/latest/quickstart/kubernetes/).

## Configure `kumactl` to connect to your global control plane

`kumactl` is a CLI tool that you can use to access {{site.mesh_product_name}}. It can create, read, update, and delete resources in {{site.mesh_product_name}} in Universal/{{site.konnect_short_name}} mode. Since we are deploying {{site.mesh_product_name}} in Kubernetes mode for this tutorial, `kumactl` is read-only. Instead, `kubectl` is used to apply changes to {{site.mesh_product_name}}. Although we don't use `kumactl` in this tutorial because we are using Kubernetes, it's still best practice to configure it to connect to your global control plane.

1. From the left navigation menu in {{site.konnect_short_name}}, open {% konnect_icon mesh-manager %} [**Mesh Manager**](https://cloud.konghq.com/mesh-manager) and select the `clothing-website` control plane.
1. Select **Configure kumactl** from the **Global Control Plane Actions** dropdown menu and follow the steps in the wizard to connect `kumactl` to the control plane.
1. Verify that the services you added from the previous section with the Kubernetes demo app are running correctly:
  ```bash
  kumactl get dataplanes
  ```
If your data planes were configured correctly with the demo app, the output should return all four data planes: `frontend`, `backend`, `postgres`, and `redis`.

You can now issue commands to your global control plane using `kumactl`. You can see the [`kumactl` command reference](/mesh/latest/explore/cli/#kumactl) for more information about the commands you can use.

## Apply a policy

Now that In this scenario, you will be configuring and applying the [Rate Limit policy](/mesh/latest/policies/rate-limit/) to limit the traffic to your clothing website.

1. Create a `.yaml` file named `rate-limit.yaml`:
  ```yaml
  apiVersion: kuma.io/v1alpha1
  kind: RateLimit
  mesh: default
  metadata:
    name: rate-limit-all-to-backend
  spec:
    sources:
      - match:
          kuma.io/service: "*"
    destinations:
      - match:
          kuma.io/service: frontend_kuma-demo_svc_8080
    conf:
      http:
        requests: 5
        interval: 10s
        onRateLimit:
          status: 423
          headers:
            - key: "x-kuma-rate-limited"
              value: "true"
              append: true
  ```

1. Apply the configuration:
  ```bash
  kubectl apply -f rate-limit.yaml
  ```

1. How do I hit the demo app to trigger the rate limiting policy? And is there a way I can see it in action so I know the policy took affect?

You can see policies associated with your mesh in {{site.konnect_short_name}} by navigating to **Mesh Manager > `clothing-website` > Meshes > `default`** and clicking on the **Policies** tab.

## Conclusion

By following the instructions in this guide, you've created a global control plane for {{site.mesh_product_name}}, added a zone to it, configured `kumactl` to connect to your global control plane, and added services to the mesh. <!--value statement about why this should be done in {{site.konnect_short_name}}-->

You also saw how you can leverage {{site.mesh_product_name}} policies to rate limit traffic to your services. 

## Next steps

Now that you've configured a global control plane, you can continue to configure your service mesh in {{site.konnect_short_name}} by [enabling mTLS and traffic permissions](/mesh/latest/quickstart/kubernetes/#enable-mutual-tls-and-traffic-permissions) on your demo app services.
