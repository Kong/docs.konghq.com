---
title: Install on Kubernetes
---

This page explains how to install {{site.base_gateway}} with {{site.kic_product_name}} in DB-less mode. To install with a database, see the documentation on installing with [Helm](/gateway/{{page.kong_version}}/install-and-run/helm).

This page also includes the equivalent commands for OpenShift.

Note that in DB-less mode on Kubernetes, config is stored in etcd, the Kubernetes native datastore. For more information see [Kubernetes Deployment Options](/gateway/{{page.kong_version}}/plan-and-deploy/kubernetes-deployment-options).

The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense/).
{{site.ce_product_name}} is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

## Prerequisites

- A Kubernetes cluster, v1.19 or later
- `kubectl` v1.19 or later
- (Enterprise only) A `license.json` file from Kong

## Create namespace

Create the namespace for {{site.base_gateway}} with {{site.kic_product_name}}. For example:

```sh
## on Kubernetes native
kubectl create namespace kong
```

```sh
## on OpenShift
oc new-project kong
```

## Create license secret
{:.badge .enterprise}

1.  Save your license file temporarily with the filename `license` (no file extension).

1.  Run:

    ```sh
    ## on Kubernetes native
    kubectl create secret generic kong-enterprise-license --from-file=<absolute-path-to>/license -n kong
    ```

    ```sh
    ## on OpenShift
    oc create secret generic kong-enterprise-license --from-file=./license -n kong
    ```

## Deploy

1.  Run one of the following:

    ```sh
    ## Kong Gateway on Kubernetes native
    kubectl apply -f https://bit.ly/k4k8s-enterprise-install
    ```

    ```sh
    ## Kong Gateway on OpenShift
    oc create -f https://bit.ly/k4k8s-enterprise-install
    ```

    ```sh
    ## Kong Gateway (OSS) on Kubernetes native
    kubectl apply -f https://bit.ly/kong-ingress-dbless
    ```

    This might take a few minutes.

1.  Check the install status:

    ```sh
    kubectl get pods -n kong
    ```

    or:

    ```sh
    oc get pods -n kong
    ```

1.  To make HTTP requests, you need the IP address of the load balancer. Get the LoadBalancer address and store it in a local PROXY_IP environment variable:

    ```sh
    export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong kong-proxy)
    ```

1.  Check that the value of $PROXY_IP is the value of the external host:

    ```sh
    kubectl get service kong-proxy -n kong
    ```

    or:

    ```sh
    oc get service kong-proxy -n kong
    ```

    {:.note}
    > **Note:** Some cluster providers provide only a DNS name for load balancers. In this case, specify `.hostname` instead of `.ip`.

## Next steps

See the [Kong Ingress Controller docs](/kubernetes-ingress-controller/) for  how-to guides, reference guides, and more.
