---
title: Migrate a self-managed zone control plane to {{site.konnect_saas}}
content_type: tutorial
---

If you already have zone control planes in {{site.mesh_product_name}}, you can migrate them to {{site.konnect_short_name}} in Mesh Manager. [Mesh Manager](/konnect/mesh-manager/) allows you to create, manage, and view your {{site.mesh_product_name}} service meshes using the {{site.konnect_short_name}} platform.

Here are a few benefits of creating a mesh deployment in {{site.konnect_short_name}} instead of using a self-managed setup:

* **Kong-managed global control plane:** By creating your mesh in {{site.konnect_short_name}}, your global control plane is managed by Kong. 
* **All entities in one place:** You can view all your information, such as entities from Kong Ingress Controller (KIC) for Kubernetes, {{site.konnect_short_name}}-managed entities, and now service mesh data, all from one central platform. 
* **Managed UI wizard setup:** {{site.konnect_short_name}} simplifies the process of creating a mesh by providing a setup wizard in the UI that guides you through the configuration steps.

This guide explains how to migrate a self-managed zone control plane to {{site.konnect_saas}}. 

## Prerequisites

* A universal or Kubernetes cluster with a running zone control plane connected to the self-managed global control plane
* [The latest version of kumactl](/mesh/latest/production/install-kumactl/) installed and configured to communicate with the self-managed global control plane
* A [{{site.mesh_product_name}} global control plane in {{site.konnect_short_name}}](/konnect/mesh-manager/service-mesh/#create-a-zone-in-the-global-control-plane)
* [yq installed](https://github.com/mikefarah/yq)

## Transfer resources from the self-managed global control plane to {{site.konnect_short_name}}

1. Make sure the self-managed global control plane is active:
  ```bash
  kumactl config control-planes list
  ```
  This should return your self-managed global control plane. If you are using Kubernetes, you can run `kubectl port-forward deployment/mesh-cp-name -n mesh-namespace 5681` to get quick access with `kumactl`.

1. Get the service mesh resources and policies for each service mesh. The following script provides an example of which resources are required:

    ```bash
   #!/bin/bash

   outdir="policies"
   mkdir -p ${outdir}
    
   types="circuit-breakers external-services fault-injections healthchecks meshaccesslogs meshcircuitbreakers
   meshfaultinjections meshgateways meshgatewayroutes meshhealthchecks meshhttproutes meshloadbalancingstrategies
   meshproxypatches meshratelimits meshretries meshtcproutes meshtimeouts meshtraces meshtrafficpermissions
   proxytemplates rate-limits retries timeouts traffic-logs traffic-permissions traffic-routes traffic-traces
   virtual-outbounds"
    
   meshes=$(kumactl get meshes -oyaml | yq '.items[].name')
   
   # For each service mesh we produce a single file ${mesh}.yaml that contains all the policies of the mesh including 
   # the mesh resource itself
   
   for mesh in ${meshes}; do
     kumactl get mesh ${mesh} -oyaml | yq '(del(.creationTime,.modificationTime))' > "${outdir}/${mesh}.yaml"
     echo "---" >> "${outdir}/${mesh}.yaml"
     
     for type in ${types}; do
       kumactl get ${type} --mesh ${mesh} -oyaml | yq '.items[] |= (del(.creationTime,.modificationTime)) | .items[] | split_doc' | grep ^ >> "${outdir}/${mesh}.yaml" && echo "---" >> "${outdir}/${mesh}.yaml"
     done
   done
    ```

1. If mTLS is enabled on the mesh and the backend type is `builtin` or `provided`, then copy the mesh secrets:
    * **Builtin:** Copy secrets named `{mesh_name}.ca-builtin-cert-{backend_name}` and `{mesh_name}.ca-builtin-key-{backend_name}`. For more information, see [storage of secrets](/mesh/{{page.kong_version}}/policies/mutual-tls/#storage-of-secrets).
    * **Provided:** Copy secrets specified in the mesh resource. For more information, see [usage of "provided" CA](/mesh/{{page.kong_version}}/policies/mutual-tls/#usage-of-provided-ca).

1. Switch the active `kumactl` control plane to {{site.konnect_short_name}}:
  ```bash
  kumactl config control-planes switch --name {config}
  ```

1. Apply resources fetched from the self-managed global control plane in steps 2 and 3: 
  ```bash
  kumactl apply -f {file_name}
  ```

## Connect the zone control plane to {{site.konnect_short_name}}

1. [Create a zone in the global control plane](/konnect/mesh-manager/service-mesh/#create-a-zone-in-the-global-control-plane).

1. If [KDS TLS](/mesh/latest/production/secure-deployment/certificates/#control-plane-to-control-plane-multizone) is enabled with self-signed certificates, set `kuma.controlPlane.tls.kdsZoneClient.secretName=""` so the zone control plane can use public certificates to authenticate with {{site.konnect_short_name}}.

1. Follow the instructions in the {{site.konnect_short_name}} UI to set up Helm and a secret token. {{site.konnect_short_name}} will automatically start looking for the zone. Once {{site.konnect_short_name}} finds the zone, it will display it.
