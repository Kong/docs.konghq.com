---
title: AKS
type: reference
purpose: |
  Additional information needed to install KIC on AKS
---

## Prerequisites

* [Set up an AKS cluster](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough).
* Install `kubectl` and connect to the AKS Kubernetes cluster.

{% include /md/kic/deploy-kic-v3.md version=page.version %}

## Setup environment variables

Create an environment variable with the IP address at which Kong is accessible. This IP address sends requests to the
Kubernetes cluster.

1. Get the IP address at which Kong is accessible:

    ```bash
    $ kubectl get services -n kong
    ```
   The results should look like this:
   ```text
   NAME                 TYPE           CLUSTER-IP      EXTERNAL-IP                           PORT(S)                      AGE
   kong-gateway-proxy                   LoadBalancer   10.0.92.49   20.232.82.183   80:31540/TCP,443:31338/TCP      5m10s
   ```
1. Create an environment variable to hold the ELB hostname:

    ```bash
    $ export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong kong-gateway-proxy)
    ```

> Note: It may take some time for Azure to associate the IP address to the `kong-gateway-proxy` Service.

After you've installed the {{site.kic_product_name}}, learn to use Ingress Controller, see the [getting started](/kubernetes-ingress-controller/{{page.kong_version}}/get-started) tutorial.