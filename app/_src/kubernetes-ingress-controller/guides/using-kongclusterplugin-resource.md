---
title: Using KongClusterPlugin resource
---

In this guide we will learn how to use KongClusterPlugin resource to configure
plugins in Kong.
The guide will cover configuring a plugin for services across different
namespaces.

## Installation

Please follow the [deployment](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/overview) documentation to install
the {{site.kic_product_name}} onto your Kubernetes cluster.

## Testing connectivity to Kong

This guide assumes that `PROXY_IP` environment variable is
set to contain the IP address or URL pointing to Kong.
If you've not done so, please follow one of the
[deployment guides](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/overview) to configure this environment variable.

If everything is setup correctly, making a request to Kong should return
HTTP 404 Not Found.

```bash
curl -i $PROXY_IP
```

The output is similar to the following:
```
HTTP/1.1 404 Not Found
Content-Type: application/json; charset=utf-8
Connection: keep-alive
Content-Length: 48
Server: kong/1.2.1

{"message":"no Route matched with those values"}
```

This is expected as Kong does not yet know how to proxy the request.

## Installing sample services

We will start by installing two services,
an `httpbin` service and it's corresponding namespace:

```bash
kubectl create namespace httpbin
kubectl apply -n httpbin -f https://bit.ly/k8s-httpbin
```

The output is similar to the following:
```
namespace/httpbin created
service/httpbin created
deployment.apps/httpbin created
```

Next, add an `echo` service and it's corresponding namespace:

```bash
kubectl create namespace echo
kubectl apply -n echo -f https://bit.ly/echo-service
```

The output is similar to the following:
```
namespace/echo created
service/echo created
deployment.apps/echo created
```

## Setup Ingress rules

Let's expose these services outside the Kubernetes cluster
by defining Ingress rules.

First, expose the `httpbin-app`:

```bash
echo "
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: httpbin-app
  namespace: httpbin
  annotations:
    konghq.com/strip-path: 'true'
spec:
  ingressClassName: kong
  rules:
  - http:
      paths:
      - path: /foo
        pathType: ImplementationSpecific
        backend:
          service:
            name: proxy-to-httpbin
            port:
              number: 80
" | kubectl apply -f -
```

The output is similar to the following:
```
ingress.networking.k8s.io/httpbin-app created
```

Next, expose the `echo-app`:

```
echo "
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: echo-app
  namespace: echo
spec:
  ingressClassName: kong
  rules:
  - http:
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

The output is similar to the following:
```
ingress.networking.k8s.io/echo-app created
```

Let's test these endpoints, starting with the `httpbin` service:

```bash
# Access httpbin service
curl -i $PROXY_IP/foo/status/200
```

The output is similar to the following:
```
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Content-Length: 0
Connection: keep-alive
Server: gunicorn/19.9.0
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
X-Kong-Upstream-Latency: 2
X-Kong-Proxy-Latency: 1
Via: kong/1.2.1
```

Next, we can test the `echo` service:

```
# Access echo service
curl -i $PROXY_IP/bar
```

The output is similar to the following:
```
HTTP/1.1 200 OK
Content-Type: text/plain; charset=UTF-8
Transfer-Encoding: chunked
Connection: keep-alive
Server: echoserver
X-Kong-Upstream-Latency: 2
X-Kong-Proxy-Latency: 1
Via: kong/1.2.1

Hostname: echo-d778ffcd8-n9bss

Pod Information:
    node name:  gke-harry-k8s-dev-default-pool-bb23a167-8pgh
    pod name:  echo-d778ffcd8-n9bss
    pod namespace:  default
    pod IP:  10.60.0.4
<-- clipped -- >
```

## Create KongClusterPlugin resource

Now that we have running services, we can add a KongClusterPlugin definition to add a response header to our services:

```bash
echo '
apiVersion: configuration.konghq.com/v1
kind: KongClusterPlugin
metadata:
  name: add-response-header
  annotations:
    kubernetes.io/ingress.class: kong
config:
  add:
    headers:
    - "demo: injected-by-kong"
plugin: response-transformer
' | kubectl apply -f -
```

The output is similar to the following:
```
kongclusterplugin.configuration.konghq.com/add-response-header created
```

Note how the resource is created at cluster-level and not in any specific namespace:

```bash
kubectl get kongclusterplugins
```

The output is similar to the following:
```
NAME                  PLUGIN-TYPE            AGE
add-response-header   response-transformer   4s
```

If you send requests to `PROXY_IP` now, you will see that the header is not
injected in the responses. The reason being that we have created a
resource but we have not told Kong when to execute the plugin.

## Configuring plugins on Ingress resources

We will associate the KongClusterPlugin resource with the two Ingress resources
that we previously created:

```bash
# Patch httpbin service
kubectl patch ingress -n httpbin httpbin-app -p '{"metadata":{"annotations":{"konghq.com/plugins":"add-response-header"}}}'
The output is similar to the following:
```

The output is similar to the following:
```
ingress.extensions/httpbin-app patched
```

```bash
# Patch echo service
kubectl patch ingress -n echo echo-app -p '{"metadata":{"annotations":{"konghq.com/plugins":"add-response-header"}}}'
```

The output is similar to the following:
```
ingress.extensions/echo-app patched
```

Here, we are asking the {{site.kic_product_name}} to execute the response-transformer
plugin whenever a request matching any of the above two Ingress rules is
processed.

Let's test it out:

```bash
curl -i $PROXY_IP/foo/status/200
```

The output is similar to the following:
```
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Content-Length: 9593
Connection: keep-alive
Server: gunicorn/19.9.0
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
demo:  injected-by-kong
X-Kong-Upstream-Latency: 2
X-Kong-Proxy-Latency: 1
Via: kong/1.2.1
```

Let's test the `echo` service to make sure that the header is injected there too:

```
curl -I $PROXY_IP/bar
```

The output is similar to the following:
```
HTTP/1.1 200 OK
Content-Type: text/plain; charset=UTF-8
Connection: keep-alive
Server: echoserver
demo:  injected-by-kong
X-Kong-Upstream-Latency: 2
X-Kong-Proxy-Latency: 1
Via: kong/1.2.1
```

As can be seen in the output, the `demo` header is injected by Kong when
the request matches the Ingress rules defined in our two Ingress rules.

## Updating plugin configuration

Now, let's update the plugin configuration to change the header value from
`injected-by-kong` to `injected-by-kong-for-kubernetes`:

```bash
echo '
apiVersion: configuration.konghq.com/v1
kind: KongClusterPlugin
metadata:
  name: add-response-header
  annotations:
    kubernetes.io/ingress.class: kong
config:
  add:
    headers:
    - "demo: injected-by-kong-for-kubernetes"
plugin: response-transformer
' | kubectl apply -f -
```

The output is similar to the following:
```
kongclusterplugin.configuration.konghq.com/add-response-header configured
```

If you repeat the requests from the last step, you will see Kong
now responds with updated header value.

This guides demonstrates how plugin configuration can be shared across
services running in different namespaces.
This can prove to be useful if the persona controlling the plugin
configuration is different from service owners that are responsible for the
Service and Ingress resources in Kubernetes.

## Configure a global plugin

Instead of applying plugins to specific services or ingress routes,
you can apply plugins to protect the entire gateway.
To test this, you can configure a rate limiting plugin to throttle requests coming from the same client.

This must be a cluster-level KongClusterPlugin resource because KongPlugin
resources cannot be applied globally. This preserves Kubernetes RBAC guarantees
for cross-namespace isolation.

Create the KongClusterPlugin resource:

```bash
echo "
apiVersion: configuration.konghq.com/v1
kind: KongClusterPlugin
metadata:
  name: global-rate-limit
  annotations:
    kubernetes.io/ingress.class: kong
  labels:
    global: \"true\"
config:
  minute: 5
  limit_by: consumer
  policy: local
plugin: rate-limiting
" | kubectl apply -f -
kongclusterplugin.configuration.konghq.com/global-rate-limit created
```

With this plugin (note the `global` label), every request through
the {{site.kic_product_name}} is rate limited:

```sh
curl -I $PROXY_IP/foo -H 'apikey: my-super-secret-key'
```

```sh
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Content-Length: 9593
Connection: keep-alive
X-RateLimit-Remaining-Minute: 4
X-RateLimit-Limit-Minute: 5
RateLimit-Remaining: 4
RateLimit-Reset: 46
RateLimit-Limit: 5
Server: gunicorn/19.9.0
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
demo:  injected-by-kong
X-Kong-Upstream-Latency: 2
X-Kong-Proxy-Latency: 1
Via: kong/2.8.1
```


Requests to `/bar` are also rate limited:
```sh
curl -I $PROXY_IP/bar
```

```sh
HTTP/1.1 200 OK
Content-Type: text/plain; charset=UTF-8
Connection: keep-alive
X-RateLimit-Remaining-Minute: 4
X-RateLimit-Limit-Minute: 5
RateLimit-Remaining: 4
RateLimit-Reset: 11
RateLimit-Limit: 5
Server: echoserver
demo:  injected-by-kong
X-Kong-Upstream-Latency: 0
X-Kong-Proxy-Latency: 1
Via: kong/2.8.1
```
