---
title: GKE
type: reference
purpose: |
  Additional information needed to install KIC on GKE
---


## Prerequisites

* [Set up an GKE cluster](https://cloud.google.com/kubernetes-engine/docs/).
* Install `kubectl` and update your `kubeconfig` to point to the GKE Kubernetes cluster by running `gcloud container clusters get-credentials <my-cluster-name> --zone <my-zone> --project <my-project-id>`

{% include /md/kic/deploy-kic-v3.md version=page.version %}

## Setup environment variables

Create an environment variable with the IP address at which Kong is accessible. This IP address sends requests to the
Kubernetes cluster.

1. Get the IP address at which Kong is accessible.

    ```bash
    $ kubectl get services -n kong
    ```
   The results should look like this:
   ```text
   NAME                 TYPE           CLUSTER-IP      EXTERNAL-IP                           PORT(S)                      AGE
   kong-gateway-proxy                   LoadBalancer   34.118.227.63    34.28.38.36   80:32683/TCP,443:30798/TCP      5m2s
   ```
1. Create an environment variable for the LoadBalancer IP.

    ```bash
    $ export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong kong-gateway-proxy)
    ```

    {:.important}
    > It may take some time for GKE to associate the IP address to the `kong-gateway-proxy` Service.

After you've installed the {{site.kic_product_name}}, learn to use Ingress Controller, see the [getting started](/kubernetes-ingress-controller/{{page.kong_version}}/get-started/services-and-routes/) tutorial.