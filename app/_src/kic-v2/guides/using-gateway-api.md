---
title: Using Gateway API
alpha: false # This is the default, but is here for completeness
content_type: tutorial

overrides:
  alpha:
    true:
      gte: 2.2.x
      lte: 2.5.x
---

[Gateway API](https://gateway-api.sigs.k8s.io/) is a set of resources for
configuring networking in Kubernetes. It expands on Ingress to configure
additional types of routes (TCP, UDP, and TLS in addition to HTTP/HTTPS),
support backends other than Service, and manage the proxies that implement
routes.

Gateway API and Kong's implementation of Gateway API are both in alpha stage and
under active development. Features and implementation specifics will change
before their initial general availability release.

{% if_version gte:2.4.x %}
## Supported Gateway API Resources

Currently, the {{site.kic_product_name}}'s implementation of the Gateway API supports the following resources:

- [Gateway and GatewayClass](/kubernetes-ingress-controller/{{page.release}}/references/gateway-api-support/#gateways-and-gatewayclasses)
- [HTTPRoute](/kubernetes-ingress-controller/{{page.release}}/references/gateway-api-support/#httproutes)
- [TCPRoute](/kubernetes-ingress-controller/{{page.release}}/references/gateway-api-support/#tcproutes)
- [UDPRoute](/kubernetes-ingress-controller/{{page.release}}/references/gateway-api-support/#udproutes)
- [TLSRoute](/kubernetes-ingress-controller/{{page.release}}/references/gateway-api-support/#tlsroutes)
{% endif_version -%}
{% if_version gte:2.4.x lte:2.6.x -%}
- [`ReferencePolicy`](/kubernetes-ingress-controller/{{page.release}}/references/gateway-api-support/#referencepolicies)
{% endif_version -%}
{% if_version gte:2.6.x -%}
- [ReferenceGrant](/kubernetes-ingress-controller/{{page.release}}/references/gateway-api-support/#referencegrants)
{% endif_version %}

## Enable the feature

The Gateway API CRDs are not yet available by default in Kubernetes. You must
first [install them](https://gateway-api.sigs.k8s.io/guides/getting-started/#installing-gateway-api-crds-manually).

{% if_version gte:2.4.x lte:2.5.x %}
The default controller configuration disables Gateway API handling.
To enable it, set `ingressController.env.feature_gates: Gateway=true` in your Helm
`values.yaml`, or set `CONTROLLER_FEATURE_GATES=Gateway=true` if not using Helm.
{% endif_version %}
{% if_version gte:2.6.x %}
The default controller configuration enables Gateway API handling, however the
alpha features of Gateway API are still behind a feature flag in {{site.kic_product_name}}.
To enable it, set `ingressController.env.feature_gates: GatewayAlpha=true` in your Helm
`values.yaml`, or set `CONTROLLER_FEATURE_GATES=GatewayAlpha=true` if not using Helm.
{% endif_version %}
Note that you must restart Pods with this flag set _after_ installing the
Gateway API CRDs.

If using Helm, you must use chart version 2.7 or higher. Older versions do not
include the ServiceAccount permissions necessary for KIC to read Gateway API
resources.

## Testing connectivity to Kong

This guide assumes that the `PROXY_IP` environment variable is
set to contain the IP address or URL pointing to Kong.
Follow one of the
[deployment guides](/kubernetes-ingress-controller/{{page.release}}/deployment/overview) to configure this environment variable.

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

## Set up an echo service

Set up an echo service to demonstrate how to use the {{site.kic_product_name}}:

```bash
kubectl apply -f {{site.links.web}}/assets/kubernetes-ingress-controller/examples/echo-service.yaml
```

## Add a GatewayClass and Gateway

The Gateway resource represents the proxy instance that handles traffic for a
set of Gateway API routes, and a GatewayClass describes characteristics shared
by all Gateways of a given type.

Add a GatewayClass:

{% if_version lte: 2.5.x %}
```bash
$ echo "apiVersion: gateway.networking.k8s.io/v1alpha2
apiVersion: gateway.networking.k8s.io/v1alpha2
kind: GatewayClass
metadata:
  name: kong
spec:
  controllerName: konghq.com/kic-gateway-controller
" | kubectl apply -f -
```
{% endif_version %}

{% if_version gte:2.6.x %}
```bash
$ echo "apiVersion: gateway.networking.k8s.io/v1beta1
kind: GatewayClass
metadata:
  name: kong
  annotations:
    konghq.com/gatewayclass-unmanaged: 'true'
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
    hostname: kong.example
    protocol: HTTP
" | kubectl apply -f -
```
{% endif_version %}

{% if_version gte:2.6.x %}
```bash
$ echo "apiVersion: gateway.networking.k8s.io/v1beta1
kind: Gateway
metadata:
  name: kong
spec:
  gatewayClassName: kong
  listeners:
  - name: proxy
    port: 80
    hostname: kong.example
    protocol: HTTP
" | kubectl apply -f -
```
{% endif_version %}

```
gateway.gateway.networking.k8s.io/kong created
```
{% if_version gte: 2.5.x %}

This configuration does create an HTTPS listen, as this requires a certificate.
If you have a [TLS Secret](https://kubernetes.io/docs/concepts/configuration/secret/#tls-secrets)
you wish to use, you can add an HTTPS listen with:

```bash
kubectl patch --type=json gateway kong -p='[{
    "op":"add",
	"path":"/spec/listeners/-",
	"value":{
		"name":"proxy-ssl",
		"hostname":"kong.example",
		"port":443,
		"protocol":"HTTPS",
		"tls":{
				"certificateRefs":[{
				    "group":"",
					"kind":"Secret",
					"name":"example-cert-secret"
				}]
		}
    }
}]'
```

Change `example-cert-secret` to the name of your Secret.
{% endif_version %}

{% if_version lte: 2.5.x %}
Because KIC and Kong instances are installed independent of their Gateway
resource, we set the `konghq.com/gateway-unmanaged` annotation to the
`<namespace>/<name>` of the Kong proxy Service. This instructs KIC to populate
that {{site.base_gateway}} resource with listener and status information. 
{% endif_version %}

{% if_version gte:2.6.x %}
To configure KIC to reconcile the Gateway resource, you must set the 
`konghq.com/gatewayclass-unmanaged` annotation as the example in GatewayClass resource used in 
`spec.gatewayClassName` in Gateway resource. Also, the 
`spec.controllerName` of GatewayClass needs to be same as the value of the
`--gateway-api-controller-name` flag configured in KIC. For more information, see [kic-flags](/kubernetes-ingress-controller/{{page.release}}/references/cli-arguments/#flags).
{% endif_version %}

You can check to confirm if KIC has updated the bound Gateway by 
inspecting the list of associated addresses:

```bash
kubectl get gateway kong -o=jsonpath='{.status.addresses}' | jq
```

```
[
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


{:.important}
> The Gateway API specification binds HTTPRoutes to one or more listeners in
> a Gateway resource. These listeners have a specific port, and HTTPRoutes
> should only be available on their listeners' ports per the specification.
> Kong's HTTP proxy implementation [doesn't support this](https://github.com/Kong/kubernetes-ingress-controller/issues/3314).
> If you configure multiple HTTP ports, Kong serves all HTTP routes on all
> ports.

{% if_version lte: 2.5.x %}
```bash
$ echo "apiVersion: gateway.networking.k8s.io/v1alpha2
kind: HTTPRoute
metadata:
  name: echo
  annotations:
    konghq.com/strip-path: "true"
spec:
  parentRefs:
  - group: gateway.networking.k8s.io
    kind: Gateway
    name: kong
  hostnames:
  - kong.example
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

{% if_version gte:2.6.x %}
```bash
$ echo "apiVersion: gateway.networking.k8s.io/v1beta1
kind: HTTPRoute
metadata:
  name: echo
  annotations:
    konghq.com/strip-path: 'true'
spec:
  parentRefs:
  - group: gateway.networking.k8s.io
    kind: Gateway
    name: kong
  hostnames:
  - kong.example
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

After creating an HTTPRoute, accessing `/echo/hostname` forwards a request to the
echo service's `/hostname` path, which yields the name of the pod that served the request:

```bash
curl -i http://kong.example/echo/hostname --resolve kong.example:80:$PROXY_IP
```

```
HTTP/1.1 200 OK
Content-Type: text/plain; charset=utf-8
Content-Length: 21
Connection: keep-alive
Date: Fri, 28 Oct 2022 08:18:18 GMT
X-Kong-Upstream-Latency: 1
X-Kong-Proxy-Latency: 0
Via: kong/3.1.1

echo-658c5ff5ff-8cvgj%
```

{% if_version gte:2.6.x %}
## Traffic splitting with HTTPRoute

HTTPRoute contains a [`BackendRefs`][gateway-api-backendref] field, which allows
users to specify `weight` parameters for echo `BackendRef`.
This can be used to perform traffic splitting.

To do so, you can deploy a second echo Service so that you have
a second `BackendRef` to use for traffic splitting.

```bach
kubectl apply -f {{site.links.web}}/assets/kubernetes-ingress-controller/examples/echo-services.yaml
```
{:.note}
> **Note**: This example contains the previous echo Service so you may deploy
> it without deploying the previous example from the
> [Set up an echo service](#set-up-an-echo-service) section.

Now that those two Services are deployed, you can now deploy your HTTPRoute. This will
perform the traffic splitting between them using the weight parameters:

```bash
echo 'apiVersion: gateway.networking.k8s.io/v1beta1
kind: HTTPRoute
metadata:
  name: echo
  annotations:
    konghq.com/strip-path: "true"
spec:
  parentRefs:
  - name: kong
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /echo
    backendRefs:
    - name: echo
      kind: Service
      port: 80
      weight: 75
    - name: echo2
      kind: Service
      port: 80
      weight: 25
' | kubectl apply -f -
```

Now, accessing `/echo/hostname` should distribute around 75% of requests to Service
echo and around 25% of requests to Service echo2.

```bash
curl http://kong.example/echo/hostname --resolve kong.example:80:$PROXY_IP
echo2-7cb798f47-gh4xg%
curl http://kong.example/echo/hostname --resolve kong.example:80:$PROXY_IP
echo-658c5ff5ff-8cvgj%
curl http://kong.example/echo/hostname --resolve kong.example:80:$PROXY_IP
echo-658c5ff5ff-8cvgj%
curl http://kong.example/echo/hostname --resolve kong.example:80:$PROXY_IP
echo-658c5ff5ff-8cvgj%
```

[gateway-api-backendref]: https://gateway-api.sigs.k8s.io/v1alpha2/references/spec/#gateway.networking.k8s.io/v1beta1.BackendRef
{% endif_version %}

{% if_version lte: 2.5.x %}
## Alpha limitations
{% endif_version %}
{% if_version gte:2.6.x %}
## Beta limitations
{% endif_version %}

{{site.kic_product_name}} Gateway API support is a work in progress, and not all features of
Gateway APIs are supported. In particular:

{% if_version lte: 2.3.x -%}
- HTTPRoute is the only supported route type. TCPRoute, UDPRoute, and TLSRoute
  are not yet implemented.
- HTTPRoute does not yet support multiple `backendRefs`. You cannot distribute
  requests across multiple Services.
{% endif_version -%}
- `queryParam` matches are not supported.
{% if_version gte: 2.4.x -%}
{% if_version lte: 2.5.x -%}
- Gateway Listener configuration does not support `TLSConfig`. You can't
  load certificates for HTTP Routes and TLS Routes via Gateway
  configuration, and must either accept the default Kong certificate or add
  certificates and SNI resources manually via the admin API in DB-backed mode.
{% endif_version -%}
{% endif_version -%}
{% if_version gte: 2.5.x -%}
- Gateways [are not provisioned automatically](/kubernetes-ingress-controller/{{page.release}}/concepts/gateway-api#gateway-management).
- Kong [only supports a single Gateway per GatewayClass](/kubernetes-ingress-controller/{{page.release}}/concepts/gateway-api#listener-compatibility-and-handling-multiple-gateways).
{% endif_version -%}
- HTTPRoutes cannot be bound to a specific port using a [ParentReference](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.ParentReference).
  Kong serves all HTTP routes on all HTTP listeners.
