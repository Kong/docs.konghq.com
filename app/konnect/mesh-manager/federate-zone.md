---
title: Federate a zone control plane to {{site.konnect_saas}}
content_type: tutorial
---

If you already have a zone control plane which is not connected to any global control plane, you can federate it to {{site.konnect_short_name}} in Mesh Manager. [Mesh Manager](/konnect/mesh-manager/) allows you to create, manage, and view your {{site.mesh_product_name}} service meshes using the {{site.konnect_short_name}} platform.

Here are a few benefits of creating a mesh deployment in {{site.konnect_short_name}} instead of using a self-managed setup:

* **Kong-managed global control plane:** By creating your mesh in {{site.konnect_short_name}}, your global control plane is managed by Kong. 
* **All entities in one place:** You can view all your information, such as entities from {{site.kic_product_name}} (KIC) for Kubernetes, {{site.konnect_short_name}}-managed entities, and now service mesh data, all from one central platform. 
* **Managed UI wizard setup:** {{site.konnect_short_name}} simplifies the process of creating a mesh by providing a setup wizard in the UI that guides you through the configuration steps.

This guide explains how to federate a zone control plane to {{site.konnect_saas}}. 

## Prerequisites

* A universal or Kubernetes cluster with a running zone control plane that is not connected to the global control plane
* [The latest version of kumactl](/mesh/latest/production/install-kumactl/) installed and configured to communicate with the self-managed global control plane
* A [{{site.mesh_product_name}} global control plane in {{site.konnect_short_name}}](/konnect/mesh-manager/service-mesh/#create-a-zone-in-the-global-control-plane)

## Transfer resources from the zone control plane to {{site.konnect_short_name}}

1. Configure kumactl with Mesh Manager:

  In Mesh Manager's control plane overview, click on "Global Control Plane Actions" and "Configure kumactl".

1. Configure kumactl with the zone control plane:

  If your zone is deployed on Kubernetes, you can port-forward 5681 for easy access.
  ```bash
kubectl port-forward svc/kong-mesh-control-plane -n kong-mesh-system 5681
  ```

  Then configure kumactl with admin token with the following commands:
  ```bash
export ZONE_USER_ADMIN_TOKEN=$(kubectl get secrets -n kong-mesh-system admin-user-token -ojson | jq -r .data.value | base64 -d)
kumactl config control-planes add \
  --address http://localhost:5681 \
  --headers "authorization=Bearer $ZONE_USER_ADMIN_TOKEN" \
  --name "zone-cp" \
  --overwrite  
  ```

  If your zone is deployed on VM (Universal), follow [authentication](/mesh/latest/production/secure-deployment/api-server-auth/#admin-user-token) docs on how to configure kumactl with admin token.

1. Get the required resources for federation
   ```bash
kumactl export --profile=federation --format=universal > resources.yaml
   ```

1. Switch the active `kumactl` control plane to {{site.konnect_short_name}}.
  
  Find configured control plane in {{site.konnect_short_name}}
  ```bash
kumactl config control-planes list
  ```
  and switch to it:
  ```bash
kumactl config control-planes switch --name {config}
  ```

1. Apply resources to  {{site.konnect_short_name}}
  ```bash
kumactl apply -f resources.yaml
  ```

## Connect the zone control plane to {{site.konnect_short_name}}

1. [Create a new zone in {{site.konnect_short_name}}](/konnect/mesh-manager/service-mesh/#create-a-zone-in-the-global-control-plane). 
  Be sure to override your existing zone control plane `values.yaml` configuration with the values provided in the {{site.konnect_short_name}} UI wizard.

1. Restart the zone control plane with the new values. {{site.konnect_short_name}} will automatically start looking for the zone. Once {{site.konnect_short_name}} finds the zone, it will display it in the UI.

## Verify federation

To verify federation, explore control plane in Mesh Manager. You should eventually see
* an online zone in the list of zones
* policies that were previously applied on the zone control plane
* data plane proxies that are running in the zone
