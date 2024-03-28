---
title: Routing by Header
---

In addition to URL components, {{site.base_gateway}} can route HTTP requests
using request header values. This guide will walk through creating routes that
use the same URL, but send traffic to different upstream services based on the
requests' headers.

## Installation

Follow the [deployment](/kubernetes-ingress-controller/{{page.release}}/deployment/overview/) documentation to install
the {{site.kic_product_name}} on your Kubernetes cluster.

## Test connectivity to {{site.base_gateway}}

This guide assumes that the `PROXY_IP` environment variable is
set to contain the IP address or URL pointing to {{site.base_gateway}}.
Follow one of the
[deployment guides](/kubernetes-ingress-controller/{{page.release}}/deployment/overview) to configure this environment variable.

If everything is setup correctly, making a request to {{site.base_gateway}} should return
a HTTP `404` status code.

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

This is expected because {{site.base_gateway}} does not yet know how to proxy the request.

## Install an example service

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
by defining an Ingress:

{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo-a
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
ingress.networking.k8s.io/demo-a created
```
{% endnavtab %}
{% endnavtabs %}

Test the echo service:

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
Via: kong/3.1.1

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

## Adding header rules to the Ingress

The `konghq.com/headers.*` annotation controls the `headers` field on {{site.base_gateway}}
routes generated from Ingress resources. When set, these headers must be
present with a specific value for a request to match a route.

The header name is configured by replacing the `*` in the example above with a
header name. The `konghq.com/headers.x-split` and `konghq.com/headers.x-legacy`
annotations indicate allowed values for the `x-split` and `x-legacy` headers,
respectively. To start, add one of these to the `demo-a` Ingress:

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl annotate ingress demo-a konghq.com/headers.x-split=alpha
```
{% endnavtab %}
{% navtab Response %}
```
ingress.networking.k8s.io/demo-a annotated
```
{% endnavtab %}
{% endnavtabs %}

Requests will no longer match the route:

{% navtabs codeblock %}
{% navtab Command %}
```bash
curl -s $PROXY_IP/foo
```
{% endnavtab %}

{% navtab Response %}
```bash
{"message":"no Route matched with those values"}
```
{% endnavtab %}
{% endnavtabs %}

## Add another Ingress

To demonstrate header routing, add another Ingress with a rule for the same
path as `demo-a`:

{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo-b
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
ingress.networking.k8s.io/demo-b created
```
{% endnavtab %}
{% endnavtabs %}

This Ingress will accept a different set of values for `x-split` and
will require an `x-legacy` header:

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl annotate ingress demo-b konghq.com/headers.x-split=bravo,charlie
kubectl annotate ingress demo-b konghq.com/headers.x-legacy=enabled
```
{% endnavtab %}
{% navtab Response %}
```
ingress.networking.k8s.io/demo-b annotated
```
{% endnavtab %}
{% endnavtabs %}

## Send requests with headers

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
< Kong-Route-Name: default.demo-a.00
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
< Kong-Route-Name: default.demo-b.00
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
< Kong-Route-Name: default.demo-b.00
```
{% endnavtab %}
{% endnavtabs %}

Note that `demo-b` requires _both_ headers, but matches any of the
individual values configured for a given header.
