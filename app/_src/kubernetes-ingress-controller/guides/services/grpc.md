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
* Route gRPC traffic to it using Ingress or GRPCRoute.

To make `gRPC` requests, you need a client that can invoke gRPC requests. You can use [`grpcurl`](https://github.com/fullstorydev/grpcurl#installation) as the client. Ensure that you have it installed on your local system.

{% include_cached /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=false gateway_api_experimental=true %}

## Deploy a gRPC test application

Kong assumes that services are HTTP-based by default. You need to configure Kong to use gRPCs protocol when it talks to the upstream service using the `konghq.com/protocol` annotation

```bash
echo "---
apiVersion: v1
kind: Service
metadata:
  name: grpcbin
  labels:
    app: grpcbin
  annotations:
    konghq.com/protocol: grpcs
spec:
  ports:
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
      - image: moul/grpcbin
        name: grpcbin
        ports:
        - containerPort: 9001
" | kubectl apply -f -
```
The results should look like this:
```text
deployment.apps/grpcbin created
service/grpcbin created
```

## Create a certificate

{% include /md/kic/add-certificate.md hostname='example.com' kong_version=page.kong_version cert_required=true %}

## Route GRPC traffic

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

All routes are assumed to be either HTTP or HTTPS by default. We need to update the route to specify gRPC as the protocol by adding a `konghq.com/protocols` annotation.

This annotation informs Kong that this route is a gRPC route and not a plain HTTP route.

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

## Test the configuration

Use `grpcurl` to send a gRPC request through the proxy:

```bash
grpcurl -d '{"greeting": "Kong"}' -servername example.com -insecure $PROXY_IP:443 hello.HelloService.SayHello
```

The results should look like this:

```text
{
  "reply": "hello Kong"
}
```

[svc]:https://kubernetes.io/docs/concepts/services-networking/service/
[gRPC]:https://grpc.io/