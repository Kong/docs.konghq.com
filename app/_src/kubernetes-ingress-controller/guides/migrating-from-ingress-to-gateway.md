---
title: Migrating from Ingress to Gateway
type: how-to
purpose: |
    How to migrate from Ingress API to Gateway API
---

## Prerequisites

This guide will use git and [go][go] to download and execute the [`ingress2gateway`][ingress2gateway]
tool.

```bash
git clone https://github.com/kong/ingress2gateway
cd ingress2gateway
git checkout preview
make build
export PATH=$PATH:$(pwd)
```

[go]: https://go.dev/dl/
[ingress2gateway]: https://github.com/kubernetes-sigs/ingress2gateway

## Convert all your yaml files

In order to migrate your resources from ingress to gateway, you need all your ingress-based
`yaml` manifests. Starting from them you can migrate to the new API by creating copies
that replace the ingress resources with Gateway API ones.
Now, use the `ingress2gateway` tool to create new manifests containing the gateway
API configurations:

1. Export your source and destination paths:

    ```bash
    export SOURCE_DIR=<your_source_directory>
    export DEST_DIR=<your_destination_directory>
    ```

1. Convert your manifests and create new files in the destination directory

    ```bash
    for file in ${SOURCE_DIR}/*.yaml; do ingress2gateway print --input-file ${file} -A --providers=kong --all-resources > ${DEST_DIR}/$(basename -- $file); done
    ```

1. Check the new manifest files have been correctly created in the destination directory:

    ```bash
    ls ${DEST_DIR}
    ```

1. Copy your annotations from the ingress resources to the Routes. The routes' names
   use the ingress name as prefix, so that tracking down which ingress generated
   which route is a straightforward process. All the `konghq.com/` annotations must
   be copied except for the following, that have been natively implemented in the
   ingress to Gateway conversion process:
   1. `konghq.com/methods`
   1. `konghq.com/headers`
   1. `konghq.com/plugins`

## Check your new manifests

The manifests conversion will be performed as follows:

- `Ingress`es will be converted into `Gateway` and `HTTPRoute`s
- `TCPIngress`es will be converted into `Gateway` and `TCPRoute`s and `TLSRoute`s
- `UDPIngress`es will be converted into `Gateway` and `UDPRoute`s

## Migrate from Ingress to Gateway

In order to migrate from using the ingress resources to the Gateway ones, run the
following commands:

1. Apply the new manifest files into the cluster

    ```bash
    kubectl apply -f ${DEST_DIR}
    ```

1. Wait for all the gateways to be programmed

    ```bash
    kubectl wait --for=condition=programmed gateway -A --all
    ```

## Delete the previous configuration

Once all the Gateways have been correctly deployed and are programmed, you can carefully
delete the ingress resources.

> NOTE: we recommend to not delete all the ingress resources at once, but instead
> iteratively delete one ingress at a time, verify that no connection is lost, then
> continue.
