---
title: Exposing a gRPC service
content_type: tutorial
---

{% if_version lte:2.8.x %}
## Installation

Please follow the [deployment](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/overview/) documentation to install
the {{site.kic_product_name}} onto your Kubernetes cluster.

## Prerequisite

To make `gRPC` requests, you need a client that can invoke gRPC requests.
In this guide, we use
[`grpcurl`](https://github.com/fullstorydev/grpcurl#installation).
Ensure that you have it installed on your local system.

## Test connectivity to Kong

This guide assumes that the `PROXY_IP` environment variable is
set to contain the IP address or URL pointing to Kong.
If you haven't done so, follow one of the
[deployment guides](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/overview) to configure the `PROXY_IP` environment variable.

If everything is set up correctly, Kong returns
`HTTP 404 Not Found` since the system does not know yet how to proxy the request. 

```bash
curl -i $PROXY_IP
HTTP/1.1 404 Not Found
Content-Type: application/json; charset=utf-8
Connection: keep-alive
Content-Length: 48
Server: kong/1.2.1

{"message":"no Route matched with those values"}
```

#### Run gRPC

1. Add a gRPC deployment and service:

    ```bash
    kubectl apply -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/v{{site.data.kong_latest_KIC.version}}/deploy/manifests/sample-apps/grpc.yaml
    service/grpcbin created
    deployment.apps/grpcbin created
    ```
2. Create a demo gRPC ingress rule:

    ```bash
    echo "apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: demo
      annotations:
        kubernetes.io/ingress.class: kong
    spec:
      rules:
      - http:
          paths:
          - path: /
            backend:
              serviceName: grpcbin
              servicePort: 9001" | kubectl apply -f -
    ingress.extensions/demo created
    ```

3. Next, we need to update the Ingress rule to specify gRPC as the protocol.
By default, all routes are assumed to be either HTTP or HTTPS. This annotation
informs Kong that this route is a gRPC(s) route and not a plain HTTP route:

    ```bash
    kubectl patch ingress demo -p '{"metadata":{"annotations":{"konghq.com/protocols":"grpc,grpcs"}}}'
    ```

4. We also update the upstream protocol to be `grpcs`.
Similar to routes, Kong assumes that services are HTTP-based by default.
With this annotation, we configure Kong to use gRPCs protocol when it
talks to the upstream service:

    ```bash
    kubectl patch svc grpcbin -p '{"metadata":{"annotations":{"konghq.com/protocol":"grpcs"}}}'
    ```

5. You should be able to run a request over `gRPC`:

    ```bash
    grpcurl -v -d '{"greeting": "Kong Hello world!"}' -insecure $PROXY_IP:443 hello.HelloService.SayHello
    ```
{% endif_version %}

{% if_version gte:2.9.x %}
## Overview

This guide walks through deploying a simple [Service][svc] that listens for
[gRPC connections][gRPC] and exposes this service outside of the cluster using
{{site.base_gateway}}.

For this example, you will:
* Deploy a gRPC test application.
* Route gRPC traffic to it using Ingress or GRPCRoute.

{% include_cached /md/kic/installation.md kong_version=page.kong_version %}

{% include_cached /md/kic/class.md kong_version=page.kong_version %}

[svc]:https://kubernetes.io/docs/concepts/services-networking/service/
[gRPC]:https://grpc.io/

## Prerequisite

To make `gRPC` requests, you need a client that can invoke gRPC requests.
In this guide, we use
[`grpcurl`](https://github.com/fullstorydev/grpcurl#installation).
Ensure that you have it installed on your local system.

## Enable the `GatewayAlpha` feature gate

If you are using the Gateway API, you need to enable the 
[`GatewayAlpha`](/kubernetes-ingress-controller/{{page.kong_version}}/references/feature-gates) 
feature gate in the {{site.kic_product_name}}.

## Deploy a gRPC test application

Add a gRPC deployment and service:

```bash
echo "---
apiVersion: v1
kind: Service
metadata:
  name: grpcbin
  labels:
    app: grpcbin
spec:
  ports:
  - name: grpc
    port: 443
    targetPort: 9001
  selector:
    app: grpcbin
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grpcbin
spec:
  replicas: 1
  selector:
    matchLabels:
      app: grpcbin
  template:
    metadata:
      labels:
        app: grpcbin
    spec:
      containers:
      - image: moul/grpcbin
        name: grpcbin
        ports:
        - containerPort: 9001
" | kubectl apply -f -        
```
Response:
```text
deployment.apps/grpcbin created
service/grpcbin created
```

## Route GRPC traffic

Now that the test application is running, you can create GRPC routing configuration that
proxies traffic to the application:

{% navtabs api %}
{% navtab Ingress %}
```bash
echo "apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo
  annotations:
    kubernetes.io/ingress.class: kong
spec:
  rules:
  - http:
    paths:
    - path: /
      backend:
        serviceName: grpcbin
        servicePort: 443" | kubectl apply -f -
```
Response:
```text
ingress.networking.k8s.io/demo created
```
{% endnavtab %}
{% navtab Gateway API %}
```bash
echo "apiVersion: gateway.networking.k8s.io/v1alpha2
kind: GRPCRoute
metadata:
  name: grpcbin
spec:
  parentRefs:
  - name: kong
  hostnames:
  - example.com
  rules:
  - backendRefs:
    - name: grpcbin
      port: 443
" | kubectl apply -f -
```
Response:
```text
grpcroute.gateway.networking.k8s.io/demo created
```
{% endnavtab %}
{% endnavtabs %}

## Update the Ingress rule

Next, if using the ingress, we need to update the Ingress rule to specify gRPC as the protocol.
By default, all routes are assumed to be either HTTP or HTTPS. This annotation
informs Kong that this route is a gRPC(s) route and not a plain HTTP route:

{% navtabs api %}
{% navtab Ingress %}
```bash
kubectl patch ingress demo -p '{"metadata":{"annotations":{"konghq.com/protocols":"grpc,grpcs"}}}'
```
{% endnavtab %}
{% endnavtabs %}

We also need to update the upstream protocol to be `grpcs`.
Similar to routes, Kong assumes that services are HTTP-based by default.
With this annotation, we configure Kong to use gRPCs protocol when it
talks to the upstream service:

{% navtabs api %}
{% navtab Ingress %}
```bash
kubectl patch svc grpcbin -p '{"metadata":{"annotations":{"konghq.com/protocol":"grpcs"}}}'
```
{% endnavtab %}
{% endnavtabs %}

## Test the configuration

First, retrieve the external IP address of the Kong proxy service:

```bash
export PROXY_IP="$(kubectl -n kong get service kong-proxy \
    -o=go-template='{% raw %}{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}{% endraw %}')"
```

After, use `grpcurl` to send a gRPC request through the proxy:

{% navtabs codeblock %}
{% navtab Command %}
```bash
grpcurl -d '{"greeting": "Kong"}' -servername example.com -insecure $PROXY_IP:443 hello.HelloService.SayHello
```
{% endnavtab %}
{% navtab Response %}
```text
{
  "reply": "hello Kong"
}
```
{% endnavtab %}
{% endnavtabs %}
{% endif_version %}
