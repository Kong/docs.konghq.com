---
title: Kong Ingress on Minikube
---

## Setup Minikube

1. Install [`minikube`](https://github.com/kubernetes/minikube)

   Minikube is a tool that makes it easy to run Kubernetes locally.
   Minikube runs a single-node Kubernetes cluster inside a VM on your laptop
   for users looking to try out Kubernetes or develop with it day-to-day.

1. Start `minikube`

   ```bash
   minikube start
   ```

   It will take a few minutes to get all resources provisioned.

   ```bash
   kubectl get nodes
   ```

{% include_cached /md/kic/deploy-kic.md version=page.version %}

## Setup environment variables

Next, we will setup an environment variable with the IP address at which
Kong is accessible. This will be used to actually send requests into the
Kubernetes cluster.

1. Get the IP address at which you can access {{site.base_gateway}}:
   
   ```bash
   $ minikube service -n kong kong-proxy --url | head -1
   # If installed by helm, service name would be "<release-name>-kong-proxy".
   # minikube service <release-name>-kong-proxy --url | head -1
   ```
   The output is similar to:
   ```bash
   http://192.168.99.100:32728
   ```
1. Set the environment variable. Replace `<ip-address>` with the {{site.base_gateway}} IP address you just retrieved:
   
   ```bash
   export PROXY_IP=<ip-address>
   echo $PROXY_IP
   ```
Once you've installed the {{site.kic_product_name}}, please follow our
[getting started](/kubernetes-ingress-controller/{{page.kong_version}}/guides/getting-started) tutorial to learn
about how to use the Ingress Controller.
