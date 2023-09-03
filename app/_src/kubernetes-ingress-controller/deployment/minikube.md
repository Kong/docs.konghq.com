---
title: Kong Ingress on Minikube
---

## Setup Minikube

1. Install [`minikube`](https://github.com/kubernetes/minikube)

   Minikube is a tool that makes it easy to run Kubernetes locally.
   Minikube runs a single-node Kubernetes cluster inside a VM on your laptop
   to try out Kubernetes or develop with it day-to-day.

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

Next, set up an environment variable with the IP address at which
Kong is accessible. This is used to send requests into the
Kubernetes cluster.

1. Get the IP address at which you can access {{site.base_gateway}}:
   
   ```bash
   $ minikube service -n kong kong-proxy --url | head -1
   # If installed by helm, service name would be "<release-name>-kong-proxy".
   # minikube service <release-name>-kong-proxy --url | head -1
   ```
   The results should look like this:
   ```bash
   http://192.168.99.100:32728
   ```
1. Set the environment variable. Replace `<ip-address>` with the {{site.base_gateway}} IP address you just retrieved:
   
   ```bash
   export PROXY_IP=<ip-address>
   echo $PROXY_IP
   ```

1. Verify that you can access {{site.base_gateway}}:

   ```bash
   curl -i $PROXY_IP
   ```
After you've installed the {{site.kic_product_name}}, please follow the
[getting started](/kubernetes-ingress-controller/{{page.kong_version}}/guides/getting-started) tutorial to learn
about how to use the Ingress Controller.

## Troubleshooting connection issues

The network is limited if you are using the Docker driver on Darwin, Windows, or WSL, and the Node IP is not reachable directly.
When you deploy minikube on Linux with the Docker driver results in no tunnel being created. For more information, see [accessing apps](https://minikube.sigs.k8s.io/docs/handbook/accessing/#using-minikube-service-with-tunnel).

### Error message

`curl: (7) Failed to connect to 127.0.0.1 port 80 after 5 ms: Couldn't connect to server`

### Work around

 Run the `minikube tunnel` command in a separate terminal window to keep the tunnel open. 

