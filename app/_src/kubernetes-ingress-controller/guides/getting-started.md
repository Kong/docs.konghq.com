---
title: Getting started with the Kong Ingress Controller
content_type: tutorial
---

## Overview

This guide walks through setting up an HTTP(S) route and plugin using
{{site.base_gateway}} and {{site.kic_product_name}}.

{% include_cached /md/kic/installation.md kong_version=page.kong_version %}

{% include_cached /md/kic/http-test-service.md kong_version=page.kong_version %}

{% include_cached /md/kic/class.md kong_version=page.kong_version %}

{% include_cached /md/kic/http-test-routing.md kong_version=page.kong_version %}

## Add TLS configuration

{% include_cached /md/kic/add-certificate.md hostname='kong.example' kong_version=page.kong_version %}

Finally, update your routing configuration to use this certificate:

{% navtabs api %}
{% navtab Ingress %}
```bash
kubectl patch --type json ingress echo -p='[{
    "op":"add",
	"path":"/spec/tls",
	"value":[{
        "hosts":["kong.example"],
		"secretName":"kong.example"
    }]
}]'
```
Response:
```text
ingress.networking.k8s.io/echo patched

```
{% endnavtab %}
{% navtab Gateway APIs %}
{% if_version lte: 2.5.x %}
{{site.kic_product_name}} versions below 2.5 do not support certificates with
Gateway APIs.
{% endif_version %}
```bash
kubectl patch --type=json gateway kong -p='[{
    "op":"add",
	"path":"/spec/listeners/-",
	"value":{
		"name":"proxy-ssl",
		"port":443,
		"protocol":"HTTPS",
		"tls":{
				"certificateRefs":[{
				    "group":"",
					"kind":"Secret",
					"name":"kong.example"
				}]
		}
    }
}]'
```
Response:
```text
gateway.gateway.networking.k8s.io/kong patched
```
{% endnavtab %}
{% endnavtabs %}

After, requests will serve the configured certificate:

```bash
curl -ksv https://kong.example/echo --connect-to kong.example:443:${PROXY_IP##http://} 2>&1 | grep -A1 "certificate:"
```
Response:
```text
* Server certificate:
*  subject: CN=kong.example
```

## Using plugins in Kong

Setup a KongPlugin resource:

```bash
echo "
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: request-id
config:
  header_name: my-request-id
  echo_downstream: true
plugin: correlation-id
" | kubectl apply -f -
```
Response:
```text
kongplugin.configuration.konghq.com/request-id created
```

Update your route configuration to use the new plugin:

{% navtabs api %}
{% navtab Ingress %}
```bash
kubectl annotate ingress echo konghq.com/plugins=request-id
```
Response:
```text
ingress.networking.k8s.io/echo annotated
```
{% endnavtab %}
{% navtab Gateway APIs %}
```bash
kubectl annotate httproute echo konghq.com/plugins=request-id
```
Response:
```text
httproute.gateway.networking.k8s.io/echo annotated
```

Kong will now apply your plugin configuration to all routes associated with
this resource. To test it, send another request through the proxy:

```bash
curl -i http://kong.example/echo --connect-to kong.example:80:${PROXY_IP##http://}
```
Response:
```text
HTTP/1.1 200 OK
Content-Type: text/plain; charset=UTF-8
Transfer-Encoding: chunked
Connection: keep-alive
Date: Thu, 10 Nov 2022 22:33:14 GMT
Server: echoserver
my-request-id: ea87894d-7f97-4710-84ae-cbc608bb8107#2
X-Kong-Upstream-Latency: 0
X-Kong-Proxy-Latency: 0
Via: kong/3.1.1

Hostname: echo-fc6fd95b5-6lqnc

Pod Information:
	node name:	kind-control-plane
	pod name:	echo-fc6fd95b5-6lqnc
	pod namespace:	default
	pod IP:	10.244.0.9
...
Request Headers:
    ...
	my-request-id=ea87894d-7f97-4710-84ae-cbc608bb8107#2
...
```
{% endnavtab %}
{% endnavtabs %}

Requests that match the `echo` Ingress or HTTPRoute now include a
`my-request-id` header with a unique ID in both their request headers upstream
and their response headers downstream.

## Using plugins on Services

Kong can also apply plugins to Services. This allows you execute the same
plugin configuration on all requests to that Service, without configuring the
same plugin on multiple Ingresses.

Create a KongPlugin resource:

```bash
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
Response:
```text
kongplugin.configuration.konghq.com/rl-by-ip created
```

Next, apply the `konghq.com/plugins` annotation to the Kubernetes Service
that needs rate-limiting:

```bash
kubectl annotate service echo konghq.com/plugins=rl-by-ip
```
Response:
```text
service/echo annotated
```

Kong will now enforce a rate limit to requests proxied to this Service:

```bash
curl -i http://kong.example/echo --connect-to kong.example:80:${PROXY_IP##http://}
```
Response:
```text
HTTP/1.1 200 OK
Content-Type: text/plain; charset=UTF-8
Transfer-Encoding: chunked
Connection: keep-alive
X-RateLimit-Remaining-Minute: 4
RateLimit-Limit: 5
RateLimit-Remaining: 4
RateLimit-Reset: 13
X-RateLimit-Limit-Minute: 5
Date: Thu, 10 Nov 2022 22:47:47 GMT
Server: echoserver
my-request-id: ea87894d-7f97-4710-84ae-cbc608bb8107#3
X-Kong-Upstream-Latency: 1
X-Kong-Proxy-Latency: 1
Via: kong/3.1.1



Hostname: echo-fc6fd95b5-6lqnc

Pod Information:
	node name:	kind-control-plane
	pod name:	echo-fc6fd95b5-6lqnc
	pod namespace:	default
	pod IP:	10.244.0.9
...
```

## Next steps

* To learn how to secure proxied routes, see the [ACL and JWT Plugins Guide](/kubernetes-ingress-controller/{{page.kong_version}}/guides/configure-acl-plugin/).
* The [External Services Guide](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-external-service/) explains how to proxy services outside of your Kubernetes cluster.
{% if_version gte:2.4.x %}
* [Gateway API](https://gateway-api.sigs.k8s.io/) is a set of resources for
configuring networking in Kubernetes. The {{site.kic_product_name}} supports Gateway API by default. To learn how to use Gateway API supported by the {{site.kic_product_name}}, see [Using Gateway API](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-gateway-api/).
{% endif_version %}
