---
title: Using KongIngress resource
---

In this guide, we will learn how to use KongIngress resource to control
proxy behavior.

{% if_version lte:2.7.x %}

{:.note}
> **Note:** Many fields available on KongIngress are also available as
> [annotations](/kubernetes-ingress-controller/{{page.kong_version}}/references/annotations).
> You can add these annotations directly to Service and Ingress resources
> without creating a separate KongIngress resource. When an annotation is
> available, it is the preferred means of configuring that setting, and the
> annotation value will take precedence over a KongIngress value if both set
> the same setting. This guide focuses on settings that can only be set using
> KongIngress.

{% endif_version %}
{% if_version gte:2.8.x %}

{:.note}
> As of version 2.8, KongIngress sections other than `upstream` are
> [deprecated](https://github.com/Kong/kubernetes-ingress-controller/issues/3018).
> All settings in the `proxy` and `route` sections are now available with
> dedicated annotations, and these annotations will become the only means of
> configuring those settings in a future release. For example, if you had set
> `proxy.connect_timeout: 30000` in a KongIngress and applied an
> `konghq.com/override` annotation for that KongIngress to a Service, you will
> need to instead apply a `konghq.com/connect-timeout: 30000` annotation to the
> Service.
> 
> The `upstream` section of KongIngress will be replaced with [a new
> resource](https://github.com/Kong/kubernetes-ingress-controller/issues/3174),
> but this is still in development and `upstream` is not officially
> deprecated yet.

{% endif_version %}

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

{% navtabs codeblock %}
{% navtab Command %}
```bash
curl -i $PROXY_IP
```
{% endnavtab %}
{% navtab Response %}
```bash
HTTP/1.1 404 Not Found
Content-Type: application/json; charset=utf-8
Connection: keep-alive
Content-Length: 48
Server: kong/1.2.1

{"message":"no Route matched with those values"}
```
{% endnavtab %}
{% endnavtabs %}

This is expected as Kong does not yet know how to proxy the request.

## Install a dummy service

We will start by installing the echo service and increasing its replica count:

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl apply -f https://bit.ly/echo-service
```
{% endnavtab %}

{% navtab Response %}
```bash
service/echo created
deployment.apps/echo created
```
{% endnavtab %}
{% endnavtabs %}

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl patch deploy echo --patch '{"spec": {"replicas": 2}}'
```
{% endnavtab %}

{% navtab Response %}
```
deployment.apps/echo patched
```
{% endnavtab %}
{% endnavtabs %}

## Setup Ingress

Let's expose the echo service outside the Kubernetes cluster
by defining an Ingress.

{% navtabs codeblock %}
{% navtab Command %}
```bash
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
{% endnavtab %}

{% navtab Response %}
```bash
ingress.extensions/demo created
```
{% endnavtab %}
{% endnavtabs %}

Let's test:

{% navtabs codeblock %}
{% navtab Command %}
```bash
curl -i $PROXY_IP/foo
```
{% endnavtab %}

{% navtab Response %}
```bash
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
{% endnavtab %}
{% endnavtabs %}

## Use KongIngress with a Service resource

By default, Kong will round-robin requests between upstream replicas. If you
run `curl -s $PROXY_IP/foo | grep "pod name:"` repeatedly, you should see the
reported Pod name alternate between two values.

You can configure the Kong upstream associated with the Service to use a
different [load balancing strategy](/gateway/latest/how-kong-works/load-balancing/#balancing-algorithms),
such as consistently sending requests to the same upstream based on a header
value. This and other fields available on the Kong upstream resource can't be
configured using annotations, only using KongIngress.

To modify these behaviours, let's first create a KongIngress resource
defining the new behaviour:

{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "apiVersion: configuration.konghq.com/v1
kind: KongIngress
metadata:
  name: sample-customization
upstream:
  hash_on: header
  hash_on_header: x-lb
  hash_fallback: ip
  algorithm: consistent-hashing" | kubectl apply -f -
```
{% endnavtab %}

{% navtab Response %}
```bash
kongingress.configuration.konghq.com/test created
```
{% endnavtab %}
{% endnavtabs %}

Now, let's associate this KongIngress resource with our Service resource
using the `konghq.com/override` annotation.

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl patch service echo -p '{"metadata":{"annotations":{"konghq.com/override":"sample-customization"}}}'
```
{% endnavtab %}

{% navtab Response %}
```bash
service/echo patched
```
{% endnavtab %}
{% endnavtabs %}

With consistent hashing and client IP fallback, sending repeated requests without any `x-lb` header now sends them to the
same Pod:

{% navtabs codeblock %}
{% navtab Command %}
```bash
for n in {1..5}; do curl -s $PROXY_IP/foo | grep "pod name:"; done
```
{% endnavtab %}

{% navtab Response %}
```bash
	pod name:	echo-588c888c78-6jrmn
	pod name:	echo-588c888c78-6jrmn
	pod name:	echo-588c888c78-6jrmn
	pod name:	echo-588c888c78-6jrmn
	pod name:	echo-588c888c78-6jrmn
```
{% endnavtab %}
{% endnavtabs %}

If you add the header, Kong hashes its value and distributes it to the
same replica when using the same value:

{% navtabs codeblock %}
{% navtab Command %}
```bash
for n in {1..3}; do
  curl -s $PROXY_IP/foo -H "x-lb: foo" | grep "pod name:";
  curl -s $PROXY_IP/foo -H "x-lb: bar" | grep "pod name:";
  curl -s $PROXY_IP/foo -H "x-lb: baz" | grep "pod name:";
done
```
{% endnavtab %}

{% navtab Response %}
```bash
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
{% endnavtab %}
{% endnavtabs %}

Increasing the replicas redistributes some subsequent requests onto the new
replica:

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl patch deploy echo --patch '{"spec": {"replicas": 3}}'
```
{% endnavtab %}

{% navtab Response %}
```bash
deployment.apps/echo patched
```
{% endnavtab %}
{% endnavtabs %}

{% navtabs codeblock %}
{% navtab Command %}
```bash
for n in {1..3}; do
  curl -s $PROXY_IP/foo -H "x-lb: foo" | grep "pod name:";
  curl -s $PROXY_IP/foo -H "x-lb: bar" | grep "pod name:";
  curl -s $PROXY_IP/foo -H "x-lb: baz" | grep "pod name:";
done
```
{% endnavtab %}

{% navtab Response %}
```bash
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
{% endnavtab %}
{% endnavtabs %}

Kong's load balancer doesn't directly distribute requests to each of the
Service's Endpoints. It first distributes them evenly across a number of
equal-size buckets. These buckets are then distributed across the available
Endpoints according to their weight. For Ingresses, however, there is only one
Service, and the controller assigns each Endpoint (represented by a Kong
upstream target) equal weight. In this case, requests are evenly hashed across all
Endpoints.

Gateway API HTTPRoute rules support distributing traffic across multiple
Services. The rule can assign weights to the Services to change the proportion
of requests an individual Service receives. In Kong's implementation, all
Endpoints of a Service have the same weight. Kong calculates a per-Endpoint
upstream target weight such that the aggregate target weight of the Endpoints
is equal to the proportion indicated by the HTTPRoute weight.

For example, say you have two Services with the following configuration:
 * One Service has four Endpoints
 * The other Service has two Endpoints
 * Each Service has weight `50` in the HTTPRoute

The targets created for the two-Endpoint Service have double the
weight of the targets created for the four-Endpoint Service (two weight `16`
targets and four weight `8` targets). Scaling the
four-Endpoint Service to eight would halve the weight of its targets (two
weight `16` targets and eight weight `4` targets).

KongIngress can also configure upstream [health checking behavior](/gateway/latest/reference/health-checks-circuit-breakers/) as well. See [the
KongIngress reference](/kubernetes-ingress-controller/{{page.kong_version}}/references/custom-resources/#kongingress)
for the health check fields.

## Use KongIngress with Ingress resource

{% if_version gte:2.8.x %}
{:.note}
> As of version 2.8, this configuration is deprecated in favor of the
> `konghq.com/headers` annotation. The [Routing by Header](/kubernetes-ingress-controller/{{page.kong_version}}/guides/routing-by-header)
> guide covers the modern version of this configuration.

{% endif_version %}

Kong can match routes based on request headers. For example, you can have two
separate routes for `/foo`, one that matches requests which include an
`x-split: alpha`, and another that matches requests with `x-split: bravo` or
`x-legacy: charlie`. Configuring this using the ingress controller requires
attaching a KongIngress to an Ingress resource. It is not available via an
Ingress annotation.

To start, create a copy of the Ingress you created earlier with a different
name:

{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "
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
```
{% endnavtab %}

{% navtab Response %}
```bash
ingress.extensions/demo-copy created
```
{% endnavtab %}
{% endnavtabs %}

The controller creates this route, but it's not immediately accessible. All
requests for `/foo` will match the original `demo` route.

When two routes have
identical matching criteria, Kong uses their creation time as a tiebreaker, defaulting to the route created first. You may see the matched route flipped if you restart the container when
using DB-less mode, as both routes are then re-added at the same time.

To fix this, create KongIngresses that differentiate the routes via headers:

{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "
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
```
{% endnavtab %}

{% navtab Response %}
```bash
kongingress.configuration.konghq.com/header-alpha created
kongingress.configuration.konghq.com/header-bravo created
```
{% endnavtab %}
{% endnavtabs %}

Now, you can associate these KongIngress resources with your Ingress resources
using the `konghq.com/override` annotation:

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl patch ingress demo -p '{"metadata":{"annotations":{"konghq.com/override":"header-alpha"}}}'
```
{% endnavtab %}

{% navtab Response %}
```bash
ingress.extensions/demo patched
```
{% endnavtab %}
{% endnavtabs %}

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl patch ingress demo-copy -p '{"metadata":{"annotations":{"konghq.com/override":"header-bravo"}}}'
```
{% endnavtab %}

{% navtab Response %}
```bash
ingress.extensions/demo-copy patched
```
{% endnavtab %}
{% endnavtabs %}

Now, neither of the routes will match:

{% navtabs codeblock %}
{% navtab Command %}
```bash
$ curl -s $PROXY_IP/foo
```
{% endnavtab %}

{% navtab Response %}
```bash
{"message":"no Route matched with those values"}
```
{% endnavtab %}
{% endnavtabs %}

Add headers to your requests to make your requests match routes again.
You'll be able to access both routes depending on which header you use:

{% navtabs codeblock %}
{% navtab Command %}
```bash
curl -sv $PROXY_IP/foo -H "kong-debug: 1" -H "x-split: alpha" 2>&1 | grep -i kong-route-name
```
{% endnavtab %}

{% navtab Response %}
```bash
< Kong-Route-Name: default.demo.00
```
{% endnavtab %}
{% endnavtabs %}

{% navtabs codeblock %}
{% navtab Command %}
```bash
curl -sv $PROXY_IP/foo -H "kong-debug: 1" -H "x-split: bravo" -H "x-legacy: enabled"  2>&1 | grep -i kong-route-name
```
{% endnavtab %}

{% navtab Response %}
```bash
< Kong-Route-Name: default.demo-copy.00
```
{% endnavtab %}
{% endnavtabs %}

{% navtabs codeblock %}
{% navtab Command %}
```bash
curl -sv $PROXY_IP/foo -H "kong-debug: 1" -H "x-split: charlie" -H "x-legacy: enabled"  2>&1 | grep -i kong-route-name
```
{% endnavtab %}

{% navtab Response %}
```bash
< Kong-Route-Name: default.demo-copy.00
```
{% endnavtab %}
{% endnavtabs %}

Note that `demo-copy` requires _both_ headers, but matches any of the
individual values configured for a given header.
