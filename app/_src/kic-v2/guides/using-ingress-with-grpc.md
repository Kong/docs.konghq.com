---
title: Exposing a gRPC service
content_type: tutorial
---

## Overview

This guide walks through deploying a simple [Service][svc] that listens for
[gRPC connections][gRPC] and exposes this service outside of the cluster using
{{site.base_gateway}}.

For this example, you will:
* Deploy a gRPC test application.
* Route gRPC traffic to it using Ingress or GRPCRoute.

To make `gRPC` requests, you need a client that can invoke gRPC requests.
In this guide, we use
[`grpcurl`](https://github.com/fullstorydev/grpcurl#installation).
Ensure that you have it installed on your local system.

{% include_cached /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=true %}

## Deploy a gRPC test application

By default, Kong considers all services to be HTTP-based. You need to configure Kong to use gRPCs protocol when it talks to the upstream service using the `konghq.com/protocol` annotation.

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
Response:
```text
deployment.apps/grpcbin created
service/grpcbin created
```

## Route GRPC traffic

Now that the test application is running, you can create GRPC routing configuration that
proxies traffic to the application.

All routes are assumed to be either HTTP or HTTPS by default. You need to update the Ingress rule to specify gRPC as the protocol by adding a `konghq.com/protocols` annotation.

This annotation informs Kong that this route is a gRPC route and not a plain HTTP route

```bash
echo "apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo
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
ingress.networking.k8s.io/demo created
```

## Test the configuration

Use `grpcurl` to send a gRPC request through the proxy:

```bash
grpcurl -d '{"greeting": "Kong"}' -insecure $PROXY_IP:443 hello.HelloService.SayHello
```

The results should look like this:

```text
{
  "reply": "hello Kong"
}
```

[svc]:https://kubernetes.io/docs/concepts/services-networking/service/
[gRPC]:https://grpc.io/