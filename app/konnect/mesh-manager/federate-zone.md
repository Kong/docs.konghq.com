---
title: Federate a zone control plane to {{site.konnect_saas}}
content_type: tutorial
---

If you already have a zone control plane which is not connected to any global control plane, you can federate it to {{site.konnect_short_name}} in [Mesh Manager](/konnect/mesh-manager/). 

By federating a zone control plane, you move {{site.mesh_product_name}} from a single-zone setup to [multi-zone](/mesh/latest/production/deployment/multi-zone/) setup. One benefit of moving from single-zone to multi-zone is it gives you automatic service fail-over in case a specific zone fails.

This guide explains how to federate a zone control plane to {{site.konnect_short_name}} by migrating an existing {{site.mesh_product_name}} zone to {{site.konnect_short_name}} and adding another zone.

## Prerequisites

* A universal or Kubernetes cluster with a running zone control plane that isn't connected to the global control plane in {{site.konnect_short_name}}
* [The latest version of `kumactl`](/mesh/latest/production/install-kumactl/) installed and configured to communicate with the self-managed global control plane
* A [{{site.mesh_product_name}} global control plane in {{site.konnect_short_name}}](/konnect/mesh-manager/service-mesh/#create-a-zone-in-the-global-control-plane)

## Transfer resources from the zone control plane to {{site.konnect_short_name}}

1. In {% konnect_icon mesh-manager %} [**Mesh Manager**](https://cloud.konghq.com/mesh-manager), click **Global Control Plane Actions** and then click **Configure kumactl**.

1. Configure kumactl with the zone control plane:

  1. Kubernetes only: If your zone is deployed on Kubernetes, you can port-forward 5681 for easy access:
  
  ```sh
  kubectl port-forward svc/kong-mesh-control-plane -n kong-mesh-system 5681
  ```

  1. Configure `kumactl` with the admin token:
  ```sh
  export ZONE_USER_ADMIN_TOKEN=$(kubectl get secrets -n kong-mesh-system admin-user-token -ojson | jq -r .data.value | base64 -d)
  kumactl config control-planes add \
  --address http://localhost:5681 \
  --headers "authorization=Bearer $ZONE_USER_ADMIN_TOKEN" \
  --name "zone-cp" \
  --overwrite  
  ```

  1. Universal/VM only: Configure `kumactl` with the admin token by following the [authentication](/mesh/latest/production/secure-deployment/api-server-auth/#admin-user-token) docs.

1. Get the required resources for federation:
  ```bash
  kumactl export --profile=federation --format=universal > resources.yaml
  ```

1. Switch the active `kumactl` control plane to {{site.konnect_short_name}}:
  
  1. Find the configured control plane in {{site.konnect_short_name}}:
    
    ```bash
    kumactl config control-planes list
    ```
  1. Switch to the configured control plane:
    
    ```bash
    kumactl config control-planes switch --name {config}
    ```

1. Apply the resources to  {{site.konnect_short_name}}:
  
  ```bash
  kumactl apply -f resources.yaml
  ```

## Connect the zone control plane to {{site.konnect_short_name}}

1. [Create a new zone in {{site.konnect_short_name}}](/konnect/mesh-manager/service-mesh/#create-a-zone-in-the-global-control-plane). 
  Be sure to override your existing zone control plane `values.yaml` configuration with the values provided in the {{site.konnect_short_name}} UI wizard.

1. Restart the zone control plane with the new values. {{site.konnect_short_name}} will automatically start looking for the zone. Once {{site.konnect_short_name}} finds the zone, it will display it in the UI.

## Verify federation

To verify federation, navigate to the global control plane in {% konnect_icon mesh-manager %} [**Mesh Manager**](https://cloud.konghq.com/mesh-manager). You should eventually see the following:
* An online zone in the list of zones
* Any policies that were previously applied on the zone control plane
* Data plane proxies that are running in the zone
