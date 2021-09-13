---
title: Using Ingress with gRPC
---

## Installation

Please follow the [deployment](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/overview) documentation to install
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
    kubectl apply -f https://bit.ly/grpcbin-service
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
