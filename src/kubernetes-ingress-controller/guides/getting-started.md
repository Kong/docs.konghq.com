---
title: Getting started with the Kubernetes Ingress Controller
---

## Installation

Please follow the [deployment](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/overview) documentation to install
the {{site.kic_product_name}} onto your Kubernetes cluster.

## Testing connectivity to Kong

This guide assumes that `PROXY_IP` environment variable is
set to contain the IP address or URL pointing to Kong.
If you've not done so, please follow one of the
[deployment guides](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/overview) to configure this environment variable.

If everything is setup correctly, making a request to Kong should return back
a HTTP `404 Not Found` status code.

```sh
curl -i $PROXY_IP
```

In this document, the expected output follows each command:
```text
HTTP/1.1 404 Not Found
Content-Type: application/json; charset=utf-8
Connection: keep-alive
Content-Length: 48
X-Kong-Response-Latency: 0
Server: kong/2.8.1

{"message":"no Route matched with those values"}
```

This is expected since Kong doesn't know how to proxy the request yet.

## Set up an echo-server

Setup an echo-server application to demonstrate how
to use the {{site.kic_product_name}}:

```sh
kubectl apply -f https://bit.ly/echo-service
```

```text
service/echo created
deployment.apps/echo created
```

This application just returns information about the
pod and details from the HTTP request.

## Basic proxy

Create an Ingress rule to proxy the echo-server created previously:

```sh
echo "
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo
spec:
  ingressClassName: kong
  rules:
  - http:
      paths:
      - path: /foo
        pathType: ImplementationSpecific
        backend:
          service:
            name: echo
            port:
              number: 80
" | kubectl apply -f -
```

```text
ingress.networking.k8s.io/demo created
```

Test the Ingress rule:

```sh
curl -i $PROXY_IP/foo
```

```text
HTTP/1.1 200 OK
Content-Type: text/plain; charset=UTF-8
Transfer-Encoding: chunked
Connection: keep-alive
Server: echoserver
X-Kong-Upstream-Latency: 0
X-Kong-Proxy-Latency: 1
Via: kong/2.8.1

Hostname: echo-758859bbfb-txt52

Pod Information:
        node name:      minikube
        pod name:       echo-758859bbfb-txt52
        pod namespace:  default
        pod IP: 172.17.0.14
...
```

If everything is deployed correctly, you should see the above response.
This verifies that Kong can correctly route traffic to an application running
inside Kubernetes.

## Using plugins in Kong

Setup a KongPlugin resource:

```sh
echo "
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: request-id
config:
  header_name: my-request-id
plugin: correlation-id
" | kubectl apply -f -
```

```text
kongplugin.configuration.konghq.com/request-id created
```

Create a new Ingress resource which uses this plugin:

```sh
echo "
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo-example-com
  annotations:
    konghq.com/plugins: request-id
spec:
  ingressClassName: kong
  rules:
  - host: example.com
    http:
      paths:
      - path: /bar
        pathType: ImplementationSpecific
        backend:
          service:
            name: echo
            port:
              number: 80
" | kubectl apply -f -
```

```text
ingress.networking.k8s.io/demo-example-com created
```

The above resource directs Kong to execute the request-id plugin whenever
a request is proxied matching any rule defined in the resource.

Send a request to Kong:

```sh
curl -i -H "Host: example.com" $PROXY_IP/bar/sample
```

```text
HTTP/1.1 200 OK
Content-Type: text/plain; charset=UTF-8
Transfer-Encoding: chunked
Connection: keep-alive
Server: echoserver
X-Kong-Upstream-Latency: 1
X-Kong-Proxy-Latency: 1
Via: kong/2.8.1

Hostname: echo-758859bbfb-cnfmx

Pod Information:
        node name:      minikube
        pod name:       echo-758859bbfb-cnfmx
        pod namespace:  default
        pod IP: 172.17.0.9

Server values:
        server_version=nginx: 1.12.2 - lua: 10010

Request Information:
        client_address=172.17.0.2
        method=GET
        real path=/bar/sample
        query=
        request_version=1.1
        request_scheme=http
        request_uri=http://example.com:8080/bar/sample

Request Headers:
        accept=*/*
        connection=keep-alive
        host=example.com
        my-request-id=7250803a-a85a-48da-94be-1aa342ca276f#6
        user-agent=curl/7.54.0
        x-forwarded-for=172.17.0.1
        x-forwarded-host=example.com
        x-forwarded-port=8000
        x-forwarded-proto=http
        x-real-ip=172.17.0.1

Request Body:
        -no body in request-
```

The `my-request-id` can be seen in the request received by echo-server.
It is injected by Kong as the request matches one
of the Ingress rules defined in `demo-example-com` resource.

## Using plugins on Services

Kong Ingress allows plugins to be executed on a service level, meaning
Kong will execute a plugin whenever a request is sent to a specific Kubernetes
service, no matter which Ingress path it came from.

Create a KongPlugin resource:

```sh
echo "
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: rl-by-ip
config:
  minute: 5
  limit_by: ip
  policy: local
plugin: rate-limiting
" | kubectl apply -f -
```

```text
kongplugin.configuration.konghq.com/rl-by-ip created
```

Next, apply the `konghq.com/plugins` annotation on the Kubernetes Service
that needs rate-limiting:

```sh
kubectl patch svc echo \
  -p '{"metadata":{"annotations":{"konghq.com/plugins": "rl-by-ip\n"}}}'
```

```text
service/echo patched
```

Now, any request sent to this service will be protected by a rate-limit
enforced by Kong:

```sh
curl -I $PROXY_IP/foo
```

```text
HTTP/1.1 200 OK
Content-Type: text/plain; charset=UTF-8
Connection: keep-alive
RateLimit-Remaining: 4
RateLimit-Reset: 1
X-RateLimit-Limit-Minute: 5
X-RateLimit-Remaining-Minute: 4
RateLimit-Limit: 5
Server: echoserver
X-Kong-Upstream-Latency: 4
X-Kong-Proxy-Latency: 2
Via: kong/2.8.1
```

```sh
curl -I -H "Host: example.com" $PROXY_IP/bar/sample
```

```text
HTTP/1.1 200 OK
Content-Type: text/plain; charset=UTF-8
Connection: keep-alive
RateLimit-Remaining: 4
RateLimit-Reset: 60
X-RateLimit-Limit-Minute: 5
X-RateLimit-Remaining-Minute: 4
RateLimit-Limit: 5
Server: echoserver
X-Kong-Upstream-Latency: 1
X-Kong-Proxy-Latency: 1
Via: kong/2.8.1
```

## Result

This guide sets up the following configuration:

```text
HTTP requests with /foo -> Kong enforces rate-limit -> echo server

HTTP requests with /bar -> Kong enforces rate-limit +   -> echo-server
   on example.com          injects my-request-id header
```

## Next steps

* To learn how to secure proxied routes, see the [ACL and JWT Plugins Guide](/kubernetes-ingress-controller/{{page.kong_version}}/guides/configure-acl-plugin/).
* The [External Services Guide](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-external-service/) explains how to proxy services outside of your Kubernetes cluster.
{% if_version gte:2.6.x %}
* [Gateway API](https://gateway-api.sigs.k8s.io/) is a set of resources for
configuring networking in Kubernetes. The Kubernetes Ingress Controller supports Gateway API by default. To learn how to use Gateway API supported by the Kubernetes Ingress Controller, see [Using Gateway API](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-gateway-api).
{% endif_version %}
