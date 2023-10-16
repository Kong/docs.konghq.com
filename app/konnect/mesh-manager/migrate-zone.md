---
title: Migrate Zone Control Plane from the On-Prem Global to {{site.konnect_saas}}
content_type: tutorial
---

This guide explains how to migrate Zone which is connected to the On-Prem Global Control Plane to {{site.konnect_saas}}.

## Prerequisites

* Universal or Kubernetes cluster with running Zone Control Plane connected to the On-Prem Global Control Plane
* [The latest version of kumactl](/mesh/latest/production/install-kumactl/) installed and configured to communicate with Zone Control Plane
* [Mesh Global Control Plane in Konnect](/konnect/mesh-manager/service-mesh/#create-a-zone-in-the-global-control-plane)
* [yq](https://github.com/mikefarah/yq)

## Transfer resources from the On-Prem Global to {{site.konnect_short_name}}

1. Make sure `kumactl config control-planes list` shows On-Prem Global as an active control plane

    {:.note}
    > **Note:** You can use port-forward of the On-Prem Global CP API port 5681 to localhost to get quick access with `kumactl`

1. Get mesh resources and policies for each mesh. The following script gives understanding what resources are required:

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
   
   # For each mesh we produce a single file ${mesh}.yaml that contains all the policies of the mesh including 
   # the mesh resource itself
   
   for mesh in ${meshes}; do
     kumactl get mesh ${mesh} -oyaml | yq '(del(.creationTime,.modificationTime))' > "${outdir}/${mesh}.yaml"
     echo "---" >> "${outdir}/${mesh}.yaml"
     
     for type in ${types}; do
       kumactl get ${type} --mesh ${mesh} -oyaml | yq '.items[] |= (del(.creationTime,.modificationTime)) | .items[] | split_doc' | grep ^ >> "${outdir}/${mesh}.yaml" && echo "---" >> "${outdir}/${mesh}.yaml"
     done
   done
    ```

1. If mTLS is enabled on the mesh and backend type is `builtin` or `provided` then copy mesh secrets.

    * `builtin` – copy secrets named `{mesh_name}.ca-builtin-cert-{backend_name}` and `{mesh_name}.ca-builtin-key-{backend_name}`. More on [storage of secrets](/mesh/{{page.kong_version}}/policies/mutual-tls/#storage-of-secrets)
    * `provided` – copy secrets specified in the mesh resource, see [usage of "provided" CA](/mesh/{{page.kong_version}}/policies/mutual-tls/#usage-of-provided-ca)

1. Switch `kumactl` active control plane to {{site.konnect_short_name}} with `kumactl config control-planes switch --name {config}`

1. Apply resources fetched from the On-Prem Global CP on the steps 2 and 3 with `kumactl apply -f {file_name}`

## Connect Zone CP to Konnect

1. [Create a zone in the global control plane](konnect/mesh-manager/service-mesh/#create-a-zone-in-the-global-control-plane)

1. If [KDS TLS](mesh/{{page.kong_version}}/production/secure-deployment/certificates/#control-plane-to-control-plane-multizone) is enabled with self-signed certificates, set `kuma.controlPlane.tls.kdsZoneClient.secretName=""` so Zone CP could use public certificates to authenticate Konnect.

1. Follow the instructions to set up Helm and a secret token. Konnect will automatically start looking for the zone. Once Konnect finds the zone, it will display it.
