---
title: Install on Kubernetes
---

This page explains how to install {{site.base_gateway}} with {{site.kic_product_name}} in DB-less mode. To install with a database, see the documentation on installing with Helm.

Note that in DB-less mode on Kubernetes, config is stored in etcd, the Kubernetes native datastore. For more information see [TODO LINK]().

## Prerequisites

- A Kubernetes cluster, v1.19 or later
- `kubectl` v1.19 or later
- (Enterprise only) A `license.json` file from Kong

## Create namespace

Create the namespace for {{site.base_gateway}} with {{site.kic_product_name}}. For example:

```sh
kubectl create namespace kong
```

## Create license secret
{:.badge .enterprise}

1.  Save your license file temporarily with the filename `license` (no file extension).

1.  Run:

    ```sh
    kubectl create secret generic kong-enterprise-license --from-file=./license -n kong
    ```









