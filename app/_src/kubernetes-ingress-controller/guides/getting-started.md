---
title: Getting started with the Kubernetes Ingress Controller
content_type: tutorial
---

## Overview

This guide walks through setting up an HTTP(S) route and plugin using
{{site.base_gateway}} and {{site.kic_product_name}}.

{% include /md/kic/installation.md %}

{% include /md/kic/http-test-service.md %}

{% include /md/kic/class.md %}

## Add routing configuration

Create routing configuration to proxy `/echo` requests to the echo server:

{% navtabs api %}
{% navtab Ingress %}
{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: echo
  annotations:
    konghq.com/strip-path: 'true'
spec:
  ingressClassName: kong
  rules:
  - host: 'kong.example'
    http:
      paths:
      - path: /echo
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
```text
ingress.networking.k8s.io/echo created
```
{% endnavtab %}
{% endnavtabs %}
{% endnavtab %}
{% navtab Gateway APIs %}
{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "
apiVersion: gateway.networking.k8s.io/v1beta1
kind: HTTPRoute
metadata:
  name: echo
  annotations:
    konghq.com/strip-path: 'true'
spec:
  parentRefs:
  - name: kong
  hostnames:
  - 'kong.example'
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /echo
    backendRefs:
    - name: echo
      kind: Service
      port: 80
" | kubectl apply -f -
```
{% endnavtab %}
{% navtab Response %}
```text
httproute.gateway.networking.k8s.io/echo created
```
{% endnavtab %}
{% endnavtabs %}
{% endnavtab %}
{% endnavtabs %}

Test the Ingress rule:

{% navtabs codeblock %}
{% navtab Command %}
```bash
curl -i http://kong.example/echo --resolve kong.example:80:$PROXY_IP
```
{% endnavtab %}
{% navtab Response %}
```text
HTTP/1.1 200 OK
Content-Type: text/plain; charset=UTF-8
Transfer-Encoding: chunked
Connection: keep-alive
Date: Thu, 10 Nov 2022 22:10:40 GMT
Server: echoserver
X-Kong-Upstream-Latency: 0
X-Kong-Proxy-Latency: 0
Via: kong/3.0.0



Hostname: echo-fc6fd95b5-6lqnc

Pod Information:
	node name:	kind-control-plane
	pod name:	echo-fc6fd95b5-6lqnc
	pod namespace:	default
	pod IP:	10.244.0.9
...
```
{% endnavtab %}
{% endnavtabs %}

If everything is deployed correctly, you should see the above response.
This verifies that Kong can correctly route traffic to an application running
inside Kubernetes.

## Add TLS configuration

{% include /md/kic/add-certificate.md hostname=kong.example %}

Finally, update your routing configuration to use this certificate:

{% navtabs api %}
{% navtab Ingress %}
{% navtabs codeblock %}
{% navtab Command %}
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
{% endnavtab %}
{% navtab Response %}
```text
ingress.networking.k8s.io/echo patched

```
{% endnavtab %}
{% endnavtabs %}
{% endnavtab %}
{% navtab Gateway APIs %}
{% if_version lt: 2.5.x %}
{{site.kic_product_name}} versions below 2.5 do not support certificates with
Gateway APIs.
{% endif_version %}
{% if_version gte: 2.5.x %}
{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl patch --type=json gateway kong -p='[{
    "op":"add",
	"path":"/spec/listeners/1/tls",
	"value":{
	    "certificateRefs":[{
		    "group":"",
			"kind":"Secret",
			"name":"kong-example"
		}]
    }
}]'
```
{% endnavtab %}
{% navtab Response %}
```text
gateway.gateway.networking.k8s.io/kong patched
```
{% endnavtab %}
{% endnavtabs %}
{% endif_version %}
{% endnavtab %}
{% endnavtabs %}

After, requests will serve the configured certificate:

{% navtabs codeblock %}
{% navtab Command %}
```bash
curl -ksv https://kong.example/echo --resolve kong.example:443:$PROXY_IP 2>&1 | grep -A1 "certificate:"
```
{% endnavtab %}
{% navtab Response %}
```text
* Server certificate:
*  subject: CN=kong.example
```
{% endnavtab %}
{% endnavtabs %}

## Using plugins in Kong

Setup a KongPlugin resource:

{% navtabs codeblock %}
{% navtab Command %}
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
{% endnavtab %}
{% navtab Response %}
```text
kongplugin.configuration.konghq.com/request-id created
```
{% endnavtab %}
{% endnavtabs %}

Update your route configuration to use the new plugin:

{% navtabs api %}
{% navtab Ingress %}
{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl annotate ingress echo konghq.com/plugins=request-id
```
{% endnavtab %}
{% navtab Response %}
```text
ingress.networking.k8s.io/echo annotated
```
{% endnavtab %}
{% endnavtabs %}
{% endnavtab %}
{% navtab Gateway APIs %}
{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl annotate httproute echo konghq.com/plugins=request-id
```
{% endnavtab %}
{% navtab Response %}
```text
httproute.gateway.networking.k8s.io/echo annotated
```
{% endnavtab %}
{% endnavtabs %}
{% endnavtab %}
{% endnavtabs %}

Kong will now apply your plugin configuration to all routes associated with
this resource. To test, it send another request through the proxy:

{% navtabs codeblock %}
{% navtab Command %}
```bash
curl -i http://kong.example/echo --resolve kong.example:80:$PROXY_IP
```
{% endnavtab %}
{% navtab Response %}
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
Via: kong/3.0.0

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

{% navtabs codeblock %}
{% navtab Command %}
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
{% endnavtab %}
{% navtab Response %}
```text
kongplugin.configuration.konghq.com/rl-by-ip created
```
{% endnavtab %}
{% endnavtabs %}

Next, apply the `konghq.com/plugins` annotation to the Kubernetes Service
that needs rate-limiting:

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl annotate service echo konghq.com/plugins=rl-by-ip
```
{% endnavtab %}
{% navtab Response %}
```text
service/echo annotated
```
{% endnavtab %}
{% endnavtabs %}

Kong will now enforce a rate limit to requests proxied to this Service:

{% navtabs codeblock %}
{% navtab Command %}
```bash
curl -i http://kong.example/echo --resolve kong.example:80:$PROXY_IP
```
{% endnavtab %}
{% navtab Response %}
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
Via: kong/3.0.0



Hostname: echo-fc6fd95b5-6lqnc

Pod Information:
	node name:	kind-control-plane
	pod name:	echo-fc6fd95b5-6lqnc
	pod namespace:	default
	pod IP:	10.244.0.9
...
```
{% endnavtab %}
{% endnavtabs %}

## Next steps

* To learn how to secure proxied routes, see the [ACL and JWT Plugins Guide](/kubernetes-ingress-controller/{{page.kong_version}}/guides/configure-acl-plugin/).
* The [External Services Guide](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-external-service/) explains how to proxy services outside of your Kubernetes cluster.
{% if_version gte:2.4.x %}
* [Gateway API](https://gateway-api.sigs.k8s.io/) is a set of resources for
configuring networking in Kubernetes. The Kubernetes Ingress Controller supports Gateway API by default. To learn how to use Gateway API supported by the Kubernetes Ingress Controller, see [Using Gateway API](/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-gateway-api).
{% endif_version %}
