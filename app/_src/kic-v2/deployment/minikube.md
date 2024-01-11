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

The network is limited if you are using the Docker driver on Darwin, Windows, or WSL, and the Node IP is not reachable directly. When you deploy minikube on Linux with the Docker driver results in no tunnel being created. For more information, see [accessing apps](https://minikube.sigs.k8s.io/docs/handbook/accessing/#using-minikube-service-with-tunnel).

1. Run the `minikube tunnel` command in a separate terminal window  and keep the tunnel open.
   This command creates a network route on the host to the service using the cluster’s IP address as a gateway. It exposes the external IP directly to any program running on the host operating system.

1. Get the IP address at which you can access {{site.base_gateway}}:
   {% capture the_code %}   
{% navtabs codeblock %}
{% navtab kubectl %}
```bash
$ minikube service -n kong kong-proxy --url | head -1
```
{% endnavtab %}
{% navtab Helm Charts %}
   ```bash
   HOST=$(kubectl get svc --namespace kong kong-gateway-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
   PORT=$(kubectl get svc --namespace kong kong-gateway-proxy -o jsonpath='{.spec.ports[0].port}')
   echo $HOST:$PORT
   ```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}
    The results should look like this:
   {% capture the_code %}  
{% navtabs codeblock %}
{% navtab kubectl %}
```bash
http://192.168.99.100:32728

# The format of the URL is http://<HOST>:<PORT>.
```
{% endnavtab %}
{% navtab Helm Charts %}
```bash
192.168.99.100:80
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}
 
1. Set the environment variable. If you deployed using `kubectl` replace `<HOST>` with the IP address of {{site.base_gateway}} in the URL that you retrieved. 
   {% capture the_code %}     
{% navtabs codeblock %}
{% navtab kubectl %}
```bash
export PROXY_IP=${HOST}:${PORT}
```
{% endnavtab %}
{% navtab Helm Charts %}
```bash
export PROXY_IP=${HOST}:${PORT}
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }} 
1. Verify that you can access {{site.base_gateway}}:

   ```bash
   curl -i $PROXY_IP
   ```
   The results should look like this:
   ```text
   HTTP/1.1 404 Not Found
   Date: Wed, 06 Sep 2023 06:48:26 GMT
   Content-Type: application/json; charset=utf-8
   Connection: keep-alive
   Content-Length: 52
   X-Kong-Response-Latency: 0
   Server: kong/3.3.1

   {
     "message":"no Route matched with those values"
   }
   ```
After you've installed the {{site.kic_product_name}}, please follow the
[getting started](/kubernetes-ingress-controller/{{page.release}}/guides/getting-started) tutorial to learn
about how to use the Ingress Controller.

