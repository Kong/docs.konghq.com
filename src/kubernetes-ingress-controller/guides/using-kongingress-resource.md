---
title: Using KongIngress resource
---

In this guide, we will learn how to use KongIngress resource to control
proxy behavior.

{:.note}
> **Note:** Many fields available on KongIngress are also available as
> [annotations](/kubernetes-ingress-controller/{{page.kong_version}}/references/annotations).
> You can add these annotations directly to Service and Ingress resources
> without creating a separate KongIngress resource. When an annotation is
> available, it is the preferred means of configuring that setting, and the
> annotation value will take precedence over a KongIngress value if both set
> the same setting. This guide focuses on settings that can only be set using
> KongIngress.

## Installation

Please follow the [deployment](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/overview) documentation to install
the {{site.kic_product_name}} onto your Kubernetes cluster.

## Testing connectivity to Kong

This guide assumes that the `PROXY_IP` environment variable is
set to contain the IP address or URL pointing to Kong.
Please follow one of the
[deployment guides](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/overview) to configure this environment variable.

If everything is setup correctly, making a request to Kong should return
HTTP 404 Not Found.

```bash
$ curl -i $PROXY_IP
HTTP/1.1 404 Not Found
Content-Type: application/json; charset=utf-8
Connection: keep-alive
Content-Length: 48
Server: kong/1.2.1

{"message":"no Route matched with those values"}
```

This is expected as Kong does not yet know how to proxy the request.

## Install a dummy service

We will start by installing the echo service and increasing its replica count:

```bash
$ kubectl apply -f https://bit.ly/echo-service
service/echo created
deployment.apps/echo created
```

```bash
$ kubectl patch deploy echo --patch '{"spec": {"replicas": 2}}'
deployment.apps/echo patched
```

## Setup Ingress

Let's expose the echo service outside the Kubernetes cluster
by defining an Ingress.

```bash
$ echo "
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
ingress.extensions/demo created
```

Let's test:

```bash
$ curl -i $PROXY_IP/foo
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
  node name:	gke-harry-k8s-dev-default-pool-bb23a167-8pgh
  pod name:	echo-d778ffcd8-n9bss
  pod namespace:	default
  pod IP:	10.60.0.4

Server values:
  server_version=nginx: 1.12.2 - lua: 10010

Request Information:
  client_address=10.60.1.10
  method=GET
  real path=/foo
  query=
  request_version=1.1
  request_scheme=http
  request_uri=http://35.233.170.67:8080/foo
```

## Use KongIngress with a Service resource

By default, Kong will round-robin requests between upstream replicas. If you
run `curl -s $PROXY_IP/foo | grep "pod name:"` repeatedly, you should see the
reported Pod name alternate between two values.

We can configure the Kong upstream associated with the Service to use a
different [load balancing strategy](/gateway/latest/how-kong-works/load-balancing/#balancing-algorithms),
such as consistently sending requests to the same upstream based on a header
value. This and other fields available on the Kong upstream resource cannot be
configured using annotations, only using KongIngress.

To modify these behaviours, let's first create a KongIngress resource
defining the new behaviour:

```bash
$ echo "apiVersion: configuration.konghq.com/v1
kind: KongIngress
metadata:
  name: sample-customization
upstream:
  hash_on: header
  hash_on_header: x-lb
  hash_fallback: ip
  algorithm: consistent-hashing" | kubectl apply -f -
kongingress.configuration.konghq.com/test created
```

Now, let's associate this KongIngress resource with our Service resource
using the `konghq.com/override` annotation.

```bash
$ kubectl patch service echo -p '{"metadata":{"annotations":{"konghq.com/override":"sample-customization"}}}'
service/echo patched
```

Sending repeated requests now without any `x-lb` header will send them to the
same Pod, since we're using consistent hashing and fall back to the client IP
if no header is present:

```bash
$ for n in {1..5}; do curl -s $PROXY_IP/foo | grep "pod name:"; done
	pod name:	echo-588c888c78-6jrmn
	pod name:	echo-588c888c78-6jrmn
	pod name:	echo-588c888c78-6jrmn
	pod name:	echo-588c888c78-6jrmn
	pod name:	echo-588c888c78-6jrmn
```

If we then add the header, Kong will hash its value and distribute it to the
same replica when we use the same value:

```bash
$ for n in {1..3}; do
  curl -s $PROXY_IP/foo -H "x-lb: foo" | grep "pod name:";
  curl -s $PROXY_IP/foo -H "x-lb: bar" | grep "pod name:";
  curl -s $PROXY_IP/foo -H "x-lb: baz" | grep "pod name:";
done
	pod name:	echo-588c888c78-nk4jc
	pod name:	echo-588c888c78-nk4jc
	pod name:	echo-588c888c78-6jrmn
	pod name:	echo-588c888c78-nk4jc
	pod name:	echo-588c888c78-nk4jc
	pod name:	echo-588c888c78-6jrmn
	pod name:	echo-588c888c78-nk4jc
	pod name:	echo-588c888c78-nk4jc
	pod name:	echo-588c888c78-6jrmn
```

Increasing the replicas will redistribute some subsequent requests onto the new
replica:

```bash
$ kubectl patch deploy echo --patch '{"spec": {"replicas": 3}}'
deployment.apps/echo patched
```

```bash
$ for n in {1..3}; do
  curl -s $PROXY_IP/foo -H "x-lb: foo" | grep "pod name:";
  curl -s $PROXY_IP/foo -H "x-lb: bar" | grep "pod name:";
  curl -s $PROXY_IP/foo -H "x-lb: baz" | grep "pod name:";
done
	pod name:	echo-588c888c78-nk4jc
	pod name:	echo-588c888c78-d477r
	pod name:	echo-588c888c78-6jrmn
	pod name:	echo-588c888c78-nk4jc
	pod name:	echo-588c888c78-d477r
	pod name:	echo-588c888c78-6jrmn
	pod name:	echo-588c888c78-nk4jc
	pod name:	echo-588c888c78-d477r
	pod name:	echo-588c888c78-6jrmn
```

Kong's load balancer does not directly distribute requests to each of the
Service's Endpoints. It first distributes them evenly across a number of
equal-size buckets. These buckets are then distributed across the available
Endpoints according to their weight. For Ingresses, however, there is a single
Service, and the controller assigns each Endpoint (represented by a Kong
upstream target) equal weight, and requests are indeed evenly hashed across all
Endpoints.

Gateway API HTTPRoutes support multiple backend Services with associated
weights per Service. The controller still assigns each Endpoint for a given
Service the same weight, but assigns them proportionally across the
multi-Service backend: the Endpoints of a Service will have a Kong target
weight such they collectively receive a percentage of requests equal to their
Service's weight in the HTTPRoute. For example, if you have two Services, one
with 4 Endpoints and one with 2, and each Service has weight 50 in the
HTTPRoute, the targets created for the 2-Endpoint Service have double the
weight of the targets created for the 4-Endpoint Service.

KongIngress can also configure upstream [health checking behavior as
well](/gateway/latest/reference/health-checks-circuit-breakers/). See [the
KongIngress reference](/kubernetes-ingress-controller/{{page.kong_version}}/references/custom-resources/#kongingress)
for the health check fields.

## Use KongIngress with Ingress resource

Kong can match routes based on request headers. For example, you can have two
separate foutes for `/foo`, one which matches requests that include an
`x-split: alpha` and another that matches requests with `x-split: bravo` or
`x-legacy: charlie`. Configuring this using the ingress controller requires
attaching a KongIngress to an Ingress resource. It is not available via an
Ingress annotation.

To start, create a copy of the Ingress we created earlier with a different
name:


```bash
$ echo "
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo-copy
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
ingress.extensions/demo-copy created
```

The controller will create this route, but it will not be accessible: all
requests for `/foo` will match the original `demo` route. When two routes have
identical matching criteria, Kong uses their creation time as a tiebreaker (you
may, however, see the matched route flipped if you restart the container when
using DB-less mode, as both routes will then be re-added at the same time). To
fix this, we'll create KongIngresses that differentiate the routes via headers:

```bash
$ echo "
---
apiVersion: configuration.konghq.com/v1
kind: KongIngress
metadata:
  name: header-alpha
route:
  headers:
    x-split:
	- alpha
---
apiVersion: configuration.konghq.com/v1
kind: KongIngress
metadata:
  name: header-bravo
route:
  headers:
    x-split:
	- bravo
	- charlie
    x-legacy:
	- enabled
  " | kubectl apply -f -
kongingress.configuration.konghq.com/header-alpha created
kongingress.configuration.konghq.com/header-bravo created
```

Now, let's associate these KongIngress resources with our Ingress resources
using the `konghq.com/override` annotation.

```bash
$ kubectl patch ingress demo -p '{"metadata":{"annotations":{"konghq.com/override":"header-alpha"}}}'
ingress.extensions/demo patched
```

```bash
$ kubectl patch ingress demo-copy -p '{"metadata":{"annotations":{"konghq.com/override":"header-bravo"}}}'
ingress.extensions/demo-copy patched
```

Now, neither of the routes will match:

```bash
$ curl -s $PROXY_IP/foo
{"message":"no Route matched with those values"}
```

Adding headers to your requests will make your requests match routes again, and
you'll be able to access both routes depending on which header you use:

```bash
$ curl -sv $PROXY_IP/foo -H "kong-debug: 1" -H "x-split: alpha" 2>&1 | grep -i kong-route-name
< Kong-Route-Name: default.demo.00
```

```bash
$ curl -sv $PROXY_IP/foo -H "kong-debug: 1" -H "x-split: bravo" -H "x-legacy: enabled"  2>&1 | grep -i kong-route-name
< Kong-Route-Name: default.demo-copy.00
```

```bash
$ curl -sv $PROXY_IP/foo -H "kong-debug: 1" -H "x-split: charlie" -H "x-legacy: enabled"  2>&1 | grep -i kong-route-name
< Kong-Route-Name: default.demo-copy.00
```

Note that demo-copy requires _both_ headers, but will match any of the
individual values configured for a given header.
