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

```bash
$ export PROXY_IP=$(minikube service -n kong kong-proxy --url | head -1)
# If installed by helm, service name would be "<release-name>-kong-proxy".
# $ export PROXY_IP=$(minikube service <release-name>-kong-proxy --url | head -1)
$ echo $PROXY_IP
http://192.168.99.100:32728
```

Once you've installed the {{site.kic_product_name}}, please follow our
[getting started](/kong-ingress-controller/{{page.kong_version}}/guides/getting-started) tutorial to learn
about how to use the Ingress Controller.
