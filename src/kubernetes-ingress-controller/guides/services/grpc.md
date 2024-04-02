---
title: gRPC
type: how-to
purpose: |
  How to proxy gRPC requests
---

## Overview

This guide walks through deploying a [Service][svc] that listens for [gRPC connections][gRPC] and exposes this service outside of the cluster using {{site.base_gateway}}.

For this example, you need to:

* Deploy a gRPC test application.
* Route gRPC traffic to it using GRPCRoute or Ingress.

To make `gRPC` requests, you need a client that can invoke gRPC requests. You can use [`grpcurl`](https://github.com/fullstorydev/grpcurl#installation) as the client. Ensure that you have it installed on your local system.

{% include_cached /md/kic/prerequisites.md release=page.release disable_gateway_api=false gateway_api_experimental=true %}

## Deploy a gRPC test application

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
  - name: plaintext
    port: 9000
    targetPort: 9000
  - name: tls
    port: 9001
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
      - image: kong/grpcbin
        name: grpcbin
        ports:
        - containerPort: 9000
        - containerPort: 9001
" | kubectl apply -f -
```
The results should look like this:
```text
deployment.apps/grpcbin created
service/grpcbin created
```

## Create a GRPCRoute

### gRPC over HTTPS

All services are assumed to be either HTTP or HTTPS by default. We need to update the service to specify gRPC as the protocol by adding a `konghq.com/protocol` annotation.

The annotation `grpcs` informs Kong that this service is a gRPC (with TLS) service and not a HTTP service.

```bash
kubectl annotate service grpcbin 'konghq.com/protocol=grpcs'
```

The results should look like this:
```text
service/grpcbin annotated
```

#### Create a certificate

{% include /md/kic/add-certificate.md hostname='example.com' release=page.release cert_required=true %}

#### Route gRPC traffic

Now that the test application is running, you can create GRPC routing configuration that
proxies traffic to the application:

{% navtabs api %}
{% navtab Gateway API %}
If you are using the Gateway APIs (GRPCRoute), your Gateway needs additional configuration under `listeners`.

```bash
kubectl patch --type=json gateway kong -p='[

    {
        "op":"add",
        "path":"/spec/listeners/-",
        "value":{
            "name":"grpc",
            "port":443,
            "protocol":"HTTPS",
            "hostname":"example.com",
            "tls": {
                "certificateRefs":[{
                    "group":"",
                    "kind":"Secret",
                    "name":"example.com"
                 }]
            }
        }
    }
]'
```
The results should look like this:
```text
gateway.gateway.networking.k8s.io/kong patched
```

Next, create a `GRPCRoute`:

```bash
echo 'apiVersion: gateway.networking.k8s.io/v1alpha2
kind: GRPCRoute
metadata:
  name: grpcbin
spec:
  parentRefs:
  - name: kong
  hostnames:
  - "example.com"
  rules:
  - backendRefs:
    - name: grpcbin
      port: 9001
' | kubectl apply -f -
```
The results should look like this:
```text
grpcroute.gateway.networking.k8s.io/grpcbin created
```
{% endnavtab %}
{% navtab Ingress %}

All routes and services are assumed to be either HTTP or HTTPS by default. We need to update the service to specify gRPC as the protocol by adding a `konghq.com/protocols` annotation.

This annotation informs Kong that this Ingress routes gRPC (with TLS) traffic and not a HTTP traffic.

```bash
echo "apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: grpcbin
  annotations:
    konghq.com/protocols: grpcs
spec:
  ingressClassName: kong
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: grpcbin
            port:
              number: 9001" | kubectl apply -f -
```
The results should look like this:
```text
ingress.networking.k8s.io/grpcbin created
```
{% endnavtab %}
{% endnavtabs %}

#### Test the configuration

Use `grpcurl` to send a gRPC request through the proxy:

```bash
grpcurl -d '{"greeting": "Kong"}' -authority example.com -insecure $PROXY_IP:443 hello.HelloService.SayHello
```

The results should look like this:

```text
{
  "reply": "hello Kong"
}
```

### gRPC over HTTP

All services are assumed to be either HTTP or HTTPS by default. We need to update the service to specify gRPC as the protocol by adding a `konghq.com/protocol` annotation.

The annotation `grpc` informs Kong that this service is a gRPC (with TLS) service and not a HTTP service.

```bash
kubectl annotate service grpcbin 'konghq.com/protocol=grpc'
```

Now that the test application is running, you can create GRPC routing configuration that
proxies traffic to the application:

For gRPC over HTTP (plaintext without TLS), configuration of Kong Gateway needs to be adjusted. By default Kong Gateway
accepts HTTP/2 traffic with TLS on port `443`. And HTTP/1.1 traffic on port `80`. To accept HTTP/2 (which is required by gRPC standard)
traffic without TLS on port `80`, the configuration has to be adjusted.

```bash
kubectl set env deployment/kong-gateway -n kong 'KONG_PROXY_LISTEN=0.0.0.0:8000 http2, 0.0.0.0:8443 http2 ssl'
```

**Caveat:** Currently, Kong Gateway doesn't offer simultaneous support of HTTP/1.1 and HTTP/2 without TLS on a single TCP socket. Hence
it's not possible to connect with HTTP/1.1 protocol, requests will be rejected. For HTTP/2 with TLS everything works seamlessly (connections
are handled transparently). You may configure an alternative HTTP/2 port (e.g. `8080`) if you require HTTP/1.1 traffic on port 80.

#### Route gRPC traffic

{% navtabs api %}
{% navtab Gateway API %}
{% if_version gte:3.1.x %}
If you are using the Gateway APIs (GRPCRoute), your Gateway needs additional configuration under `listeners`.

```bash
echo 'apiVersion: gateway.networking.k8s.io/v1alpha2
kind: GRPCRoute
metadata:
  name: grpcbin
spec:
  parentRefs:
  - name: kong
  hostnames:
  - "example.com"
  rules:
  - backendRefs:
    - name: grpcbin
      port: 9000
' | kubectl apply -f -
```
The results should look like this:
```text
grpcroute.gateway.networking.k8s.io/grpcbin created
```
{% endif_version %}
{% if_version lte: 3.0.x %}
{:.warning}
> GRPC over HTTP is only supported by {{ site.kic_product_name }} 3.1+
{% endif_version %}
{% endnavtab %}
{% navtab Ingress %}

```bash
echo "apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: grpcbin
  annotations:
    konghq.com/protocols: grpc
spec:
  ingressClassName: kong
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: grpcbin
            port:
              number: 9000" | kubectl apply -f -
```
The results should look like this:
```text
ingress.networking.k8s.io/grpcbin created
```
{% endnavtab %}
{% endnavtabs %}

#### Test the configuration

Use `grpcurl` to send a gRPC request through the proxy:

```bash
grpcurl -plaintext -d '{"greeting": "Kong"}' -authority example.com $PROXY_IP:80 hello.HelloService.SayHello
```

The results should look like this:

```text
{
  "reply": "hello Kong"
}
```

[svc]:https://kubernetes.io/docs/concepts/services-networking/service/
[gRPC]:https://grpc.io/
