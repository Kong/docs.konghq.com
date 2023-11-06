---
title: Migrating from Ingress to Gateway
type: how-to
purpose: |
    How to migrate from Ingress API to Gateway API
---

## Prerequisites

- Ensure that you have installed `Make`, `git`, and [Go][go] to download and execute the [`ingress2gateway`][ingress2gateway] tool.

    ```bash
    git clone --branch preview https://github.com/kong/ingress2gateway
    cd ingress2gateway
    make build
    export PATH=${PATH}:$(pwd)
    ```

   [go]: https://go.dev/dl/
   [ingress2gateway]: https://github.com/kubernetes-sigs/ingress2gateway

## Convert all the yaml files

In order to migrate your resources from `Ingress` API to Gateway API you need all
the `Ingress`-based `yaml` manifests. You can use these manifests as source to
migrate to the new API by creating copies that replace the `Ingress` resources
with Gateway API resources. Then, use the `ingress2gateway` tool to create new manifests
containing the gateway API configurations.

1. Export your source and destination paths.

    ```bash
    SOURCE_DIR=<your_source_directory>
    DEST_DIR=<your_destination_directory>
    ```

1. Convert the manifests and create new files in the destination directory.

    ```bash
    for file in ${SOURCE_DIR}/*.yaml; do ingress2gateway print --input-file ${file} -A --providers=kong --all-resources > ${DEST_DIR}/$(basename -- $file); done
    ```

1. Check the new manifest files have been correctly created in the destination directory.

    ```bash
    ls ${DEST_DIR}
    ```

1. Copy your annotations from the ingress resources to the Routes. The routes' names
   use the ingress name as prefix to help you track the route that the ingress
   generated. All the `konghq.com/` annotations must be copied except for these,
   that have been natively implemented as Gateway API features.

   1. `konghq.com/methods`
   1. `konghq.com/headers`
   1. `konghq.com/plugins`

## Check the new manifests

The manifests conversion are as follows:

- `Ingress`es are converted to `Gateway` and `HTTPRoute`s
- `TCPIngress`es are converted to `Gateway` and `TCPRoute`s and `TLSRoute`s
- `UDPIngress`es are converted to `Gateway` and `UDPRoute`s

## Migrate from Ingress to Gateway

To migrate from using the ingress resources to the Gateway resources:

1. Apply the new manifest files into the cluster

    ```bash
    kubectl apply -f ${DEST_DIR}
    ```

1. Wait for all the gateways to be programmed

    ```bash
    kubectl wait --for=condition=programmed gateway -A --all
    ```

## Delete the previous configuration

After all the Gateways have been correctly deployed and are programmed, you can
delete the ingress resources. In other words the Gateways should have the status
condition `Programmed` set, and status field set to `True` before you delete the
ingress resources. delete the ingress resources.

> **Note**: It is a best practice to not delete all the ingress resources at once,
> but instead iteratively delete one ingress at a time, verify that no connection
> is lost, then continue.
