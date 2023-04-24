---
title: Configure a Global Control Plane with Kong Mesh
content_type: tutorial
---

Using Mesh Manager, you can create a {{site.mesh_product_name}} global control plane to manage your {{site.konnect_saas}} services. 

[IMAGE OF GLOBAL CONTROL PLANE MESH THING]

A global control plane configures the basic settings for all services associated with a service mesh. If you have a multi-zone deployment, you can have one global control plane and different control planes for each zone. This allows you to easily configure settings for all services by only editing one configuration file. 

For the purposes of this guide, you'll use {{site.mesh_product_name}} as your service mesh to create a global control plane to manage the service you created previously in the [Configure a Service](/konnect/getting-started/configure-service/) section of the Get Started in {{site.konnect_saas}} documentation. This guide uses Kubernetes to install various service mesh components.

## Prerequisites

* [Kubernetes installed](https://kubernetes.io/docs/setup/)

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
1. MAKE A ZONE 
1. Copy and run the Kubernetes mesh configuration that displays at the end of the wizard. 
    Once {{site.konnect_short_name}} finds the newly created mesh, it will display it. 
1. Click **Next**.
1. ? Does this just take you to your list of meshes/control planes?

### Explanation of instructions

You now have a very basic {{site.mesh_product_name}} service mesh added to {{site.konnect_short_name}}. This service mesh can't do anything at the moment until we add services and additional configurations to it.

## Add a service to your service mesh

Now that you've added a global control plane and a zone to your service mesh in {{site.konnect_short_name}}, you can add services to your mesh. You can use the {{site.mesh_product_name}} demo app to set up two services so you can see how {{site.mesh_product_name}} can be used to control services, monitor traffic, and track resource status.

For more information, see one of the following in the {{site.mesh_product_name}} documentation:
* [Explore {{site.mesh_product_name}} with the Kubernetes demo app](/mesh/latest/quickstart/kubernetes/)
* [Explore {{site.mesh_product_name}} with the Universal demo app](/mesh/latest/quickstart/universal/)

After you add a service to your service mesh, the {{site.konnect_short_name}} will be populated with metrics from your service mesh. 

## More information

After you complete this tutorial, you can continue to configure your service mesh in {{site.konnect_short_name}}.

* [Zone Ingress](/mesh/latest/production/cp-deployment/zone-ingress/) - Set up zone ingress in {{site.mesh_product_name}}.
* [Zone Egress](/mesh/latest/production/cp-deployment/zoneegress/) - Set up zone egress in {{site.mesh_product_name}}.
* [Mutual TLS](/mesh/latest/policies/mutual-tls/) - Configure mTLS with {{site.mesh_product_name}}. 
* [Observability](/mesh/latest/explore/observability/) - Find out how to configure observability with {{site.mesh_product_name}}.
* [Traffic Log](/mesh/latest/policies/traffic-log/) - Learn how to configure logging with {{site.mesh_product_name}}.