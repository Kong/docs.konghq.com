---
title: Kong Ingress on Azure Kubernetes Service (AKS)
---

## Requirements

1. A fully functional AKS cluster.
   Please follow Azure's Guide to
   [setup an AKS cluster](https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough).
1. Basic understanding of Kubernetes
1. A working `kubectl`  linked to the AKS Kubernetes
   cluster we will work on. The above AKS setup guide will help
   you set this up.

{% include_cached /md/kic/deploy-kic.md version=page.version %}

## Setup environment variables

Next, we will setup an environment variable with the IP address at which
Kong is accessible. This will be used to actually send requests into the
Kubernetes cluster.

Execute the following command to get the IP address at which Kong is accessible:

```bash
$ kubectl get services -n kong
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)                      AGE
kong-proxy   LoadBalancer   10.63.250.199   203.0.113.42   80:31929/TCP,443:31408/TCP   57d
```

Let's setup an environment variable to hold the IP address:

```bash
$ export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong kong-proxy)
```

> Note: It may take a while for Microsoft Azure to actually associate the
IP address to the `kong-proxy` Service.

Once you've installed the {{site.kic_product_name}}, please follow our
[getting started](/kubernetes-ingress-controller/{{page.release}}/guides/getting-started) tutorial to learn
about how to use the Ingress Controller.
