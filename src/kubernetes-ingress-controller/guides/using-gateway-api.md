---
title: Using Gateway API
---

{% if_version gte: 2.6.x %}
{:.note}
> This guide is considered `beta` maturity. It is not intended for use in production systems.
{% endif_version %}
{% if_version lte: 2.5.x %}
{:.note}
> This guide is considered `alpha` maturity. It is not intended for use in production systems.
{% endif_version %}

[Gateway API](https://gateway-api.sigs.k8s.io/) is a set of resources for
configuring networking in Kubernetes. It expands on Ingress to configure
additional types of routes (TCP, UDP, and TLS in addition to HTTP/HTTPS),
support backends other than Service, and manage the proxies that implement
routes.

## Setup

The Gateway API CRDs are not yet available by default in Kubernetes. You must
first [install them][gwinst].
{% if_version lte: 2.5.x %}

The default controller configuration disables Gateway API handling. To enable
it, set `ingressController.env.feature_gates: Gateway=true` in your Helm
`values.yaml`, or set `CONTROLLER_FEATURE_GATES=Gateway=true` if not using Helm.
Note that you must restart Pods with this flag set _after_ installing the
Gateway API CRDs.
{% endif_version %}

If using Helm, you must use chart version 2.7 or higher. Older versions do not
include the ServiceAccount permissions necessary for KIC to read Gateway API
resources.

[gwinst]:https://gateway-api.sigs.k8s.io/guides/getting-started/#installing-gateway-api

## Testing connectivity to Kong

This guide assumes that the `PROXY_IP` environment variable is
set to contain the IP address or URL pointing to Kong.
Follow one of the
[deployment guides](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/overview) to configure this environment variable.

If everything is set up correctly, making a request to Kong should return
HTTP 404 Not Found.

{:.note}
> **Note**: If you are running the example using Minikube on MacOS, you may need 
to run [`minikube tunnel`](https://minikube.sigs.k8s.io/docs/handbook/accessing/#loadbalancer-access)
in a separate terminal window.  This exposes LoadBalancer services 
externally, which is not enabled by default.

```bash
$ curl -i $PROXY_IP
HTTP/1.1 404 Not Found
Content-Type: application/json; charset=utf-8
Connection: keep-alive
Content-Length: 48
Server: kong/1.2.1

{"message":"no Route matched with those values"}
```

This is expected, as Kong does not yet know how to proxy the request.

## Set up an echo-server

Set up an echo-server application to demonstrate how
to use the {{site.kic_product_name}}:

```bash
$ kubectl apply -f https://bit.ly/echo-service
```

## Add a GatewayClass and Gateway

The Gateway resource represents the proxy instance that handles traffic for a
set of Gateway API routes, and a GatewayClass describes characteristics shared
by all Gateways of a given type.

Add a GatewayClass:

{% if_version lte: 2.5.x %}
```bash
$ echo "apiVersion: gateway.networking.k8s.io/v1alpha2
kind: GatewayClass
metadata:
  name: kong
spec:
  controllerName: konghq.com/kic-gateway-controller
" | kubectl apply -f -
```
{% endif_version %}
{% if_version gte: 2.6.x %}
```bash
$ echo "apiVersion: gateway.networking.k8s.io/v1beta1
kind: GatewayClass
metadata:
  name: kong
spec:
  controllerName: konghq.com/kic-gateway-controller
" | kubectl apply -f -
```
{% endif_version %}

```
gatewayclass.gateway.networking.k8s.io/kong created
```

Add a Gateway:

{% if_version lte: 2.5.x %}
```bash
$ echo "apiVersion: gateway.networking.k8s.io/v1alpha2
kind: Gateway
metadata:
  annotations:
    konghq.com/gateway-unmanaged: kong/kong-proxy
  name: kong
spec:
  gatewayClassName: kong
  listeners:
  - name: proxy
    port: 80
    protocol: HTTP
  - name: proxy-ssl
    port: 443
    protocol: HTTPS
" | kubectl apply -f -
```
{% endif_version %}
{% if_version gte: 2.6.x %}
```bash
$ echo "apiVersion: gateway.networking.k8s.io/v1beta1
kind: Gateway
metadata:
  annotations:
    konghq.com/gateway-unmanaged: kong/kong-proxy
  name: kong
spec:
  gatewayClassName: kong
  listeners:
  - name: proxy
    port: 80
    protocol: HTTP
  - name: proxy-ssl
    port: 443
    protocol: HTTPS
" | kubectl apply -f -
```
{% endif_version %}

```
gateway.gateway.networking.k8s.io/kong created
```

Because KIC and Kong instances are installed independent of their Gateway
resource, we set the `konghq.com/gateway-unmanaged` annotation to the
`<namespace>/<name>` of the Kong proxy Service. This instructs KIC to populate
that Gateway resource with listener and status information. You can check to
confirm if KIC has updated the bound Gateway by inspecting the list of
associated addresses:

```bash
$ kubectl get gateway kong -o=jsonpath='{.status.addresses}' | jq
```

```
[
  {
    "type": "IPAddress",
    "value": "10.96.179.122"
  },
  {
    "type": "IPAddress",
    "value": "10.96.179.122"
  },
  {
    "type": "IPAddress",
    "value": "172.18.0.240"
  }
]
```

## Add an HTTPRoute

HTTPRoute resources are similar to Ingress resources: they contain a set of
matching criteria for HTTP requests and upstream Services to route those
requests to.

{% if_version lte: 2.5.x %}
```bash
$ echo "apiVersion: gateway.networking.k8s.io/v1alpha2
kind: HTTPRoute
metadata:
  name: echo
spec:
  parentRefs:
  - group: gateway.networking.k8s.io
    kind: Gateway
    name: kong
  rules:
  - backendRefs:
    - group: ""
      kind: Service
      name: echo
      port: 80
      weight: 1
    matches:
    - path:
        type: PathPrefix
        value: /echo
" | kubectl apply -f -
```
{% endif_version %}
{% if_version gte: 2.6.x %}
```bash
$ echo "apiVersion: gateway.networking.k8s.io/v1beta1
kind: HTTPRoute
metadata:
  name: echo
spec:
  parentRefs:
  - group: gateway.networking.k8s.io
    kind: Gateway
    name: kong
  rules:
  - backendRefs:
    - group: ""
      kind: Service
      name: echo
      port: 80
      weight: 1
    matches:
    - path:
        type: PathPrefix
        value: /echo
" | kubectl apply -f -
```
{% endif_version %}

After creating an HTTPRoute, accessing `/echo` forwards a request to the
echo service:

```bash
$ curl -i $PROXY_IP/echo
```

```
HTTP/1.1 200 OK
Content-Type: text/plain; charset=UTF-8
Transfer-Encoding: chunked
Connection: keep-alive
Date: Fri, 21 Jun 2019 18:09:02 GMT
Server: echoserver
X-Kong-Upstream-Latency: 1
X-Kong-Proxy-Latency: 1
Via: kong/1.1.2



Hostname: echo-758859bbfb-cnfmx
...
```

## Limitations

Some notable features or options are not currently supported:

{% if_version lte: 2.3.x %}
- HTTPRoute is the only supported route type. TCPRoute, UDPRoute, and TLSRoute
  are not yet implemented.
- HTTPRoute does not yet support multiple backendRefs. You cannot distribute
  requests across multiple Services.
{% endif_version %}
- queryParam matches matches are not supported.
{% if_version gte: 2.4.x %}
- Gateway Listener configuration does not support TLSConfig. You can't
  load certificates for HTTPRoutes and TLSRoutes via Gateway
  configuration, and must either accept the default Kong certificate or add
  certificates and SNI resources manually via the admin API in DB-backed mode.
{% endif_version %}
