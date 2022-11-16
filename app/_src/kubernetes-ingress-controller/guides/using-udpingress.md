---
title: Exposing a UDP Service
content_type: tutorial
---

## Overview

This guide walks through deploying a simple [Service][svc] that listens for
[UDP datagrams][udp], and exposes this service outside of the cluster using
{{site.base_gateway}}.

For this example, you will:
* Deploy a UDP test application.
* Route UDP traffic to it using UDPIngress or UDPRoute.

{% include_cached /md/kic/installation.md kong_version=page.kong_version %}

{% include_cached /md/kic/class.md kong_version=page.kong_version %}

[svc]:https://kubernetes.io/docs/concepts/services-networking/service/
[udp]:https://datatracker.ietf.org/doc/html/rfc768

## Create a namespace

First, create a namespace:

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl create namespace udp-example
```
{% endnavtab %}
{% navtab Response %}
```text
namespace/udp-example created
```
{% endnavtab %}
{% endnavtabs %}

Other examples in this guide will use this namespace. When you've completed
this guide, `kubectl delete namespace udp-example` will clean those resources
up.

## Adding UDP listens

{{site.base_gateway}} does not include any UDP listen configuration by default.
To expose UDP listens, update the Deployment's environment variables and port
configuration:

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl patch deploy -n kong ingress-kong --patch '{
  "spec": {
    "template": {
      "spec": {
        "containers": [
          {
            "name": "proxy",
            "env": [
              {
                "name": "KONG_STREAM_LISTEN",
                "value": "0.0.0.0:9999 udp"
              }
            ],
            "ports": [
              {
                "containerPort": 9999,
                "name": "stream9999",
                "protocol": "UDP"
              }
            ]
          }
        ]
      }
    }
  }
}'
```
{% endnavtab %}
{% navtab Response %}
```text
deployment.extensions/ingress-kong patched
```
{% endnavtab %}
{% endnavtabs %}

## Add a UDP proxy Service

LoadBalancer Services only support a single transport protocol in [Kubernetes
versions prior to 1.26](https://github.com/kubernetes/enhancements/issues/1435).
To direct UDP traffic to the proxy Service, you'll need to create a second
Service:

{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "apiVersion: v1
kind: Service
metadata:
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-backend-protocol: udp
    service.beta.kubernetes.io/aws-load-balancer-type: nlb
  name: kong-udp-proxy
  namespace: kong
spec:
  ports:
  - name: stream9999
    port: 9999
    protocol: UDP
    targetPort: 9999
  selector:
    app: ingress-kong
  type: LoadBalancer
" | kubectl apply -f -
```
{% endnavtab %}
{% navtab Response %}
```text
service/kong-udp-proxy created
```
{% endnavtab %}
{% endnavtabs %}

Note that this Service is typically added via the Kong Helm chart's `udpProxy`
configuration. This guide creates it manually to demonstrate the resources the
chart normally manages for you and for compatibility with non-Helm installs.

## Update the Gateway

If you are using Gateway APIs (UDPRoute) option, your Gateway needs additional
configuration under `listeners`. If you are using UDPIngress, skip this step.

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl patch --type=json gateway kong -p='[
    {
        "op":"add",
        "path":"/spec/listeners/-",
        "value":{
            "name":"stream9999",
            "port":9999,
            "protocol":"UDP",
			"allowedRoutes": {
			    "namespaces": {
				     "from": "All"
				}
			}
        }
    }
]'
```
{% endnavtab %}
{% navtab Response %}
```text
gateway.gateway.networking.k8s.io/kong patched
```
{% endnavtab %}
{% endnavtabs %}


## Deploy a UDP test application

Create a test application Deployment and an associated Service:

{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tftp
  namespace: udp-example
  labels:
    app: tftp
spec:
  replicas: 1
  selector:
    matchLabels:
      app: tftp
  template:
    metadata:
      labels:
        app: tftp
    spec:
      containers:
      - name: tftp
        image: cilium/echoserver-udp:latest
        args:
        - --listen
        - :9999
        ports:
        - containerPort: 9999
---
apiVersion: v1
kind: Service
metadata:
  name: tftp
  namespace: udp-example
spec:
  ports:
  - port: 9999
    name: tftp
    protocol: UDP
    targetPort: 9999
  selector:
    app: tftp
  type: ClusterIP
" | kubectl apply -f -
```
{% endnavtab %}
{% navtab Response %}
```text
deployment.apps/tftp created
service/tftp created
```
{% endnavtab %}
{% endnavtabs %}

[echoserver-udp](https://hub.docker.com/r/cilium/echoserver-udp) is a simple
test server that accepts UDP TFTP requests and returns basic request
information. As curl supports TFTP, it is a convenient option for
testing UDP routing.

## Route UDP traffic

Now that {{site.base_gateway}} is listening on `9999` and the test application
is running, you can create UDP routing configuration that proxies traffic to
the application:

{% navtabs api %}
{% navtab Ingress %}
{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "apiVersion: configuration.konghq.com/v1beta1
kind: UDPIngress
metadata:
  name: tftp
  namespace: udp-example
  annotations:
    kubernetes.io/ingress.class: kong
spec:
  rules:
  - backend:
      serviceName: tftp
      servicePort: 9999
    port: 9999
" | kubectl apply -f -
```
{% endnavtab %}
{% navtab Response %}
```text
udpingress.configuration.konghq.com/tftp created
```
{% endnavtab %}
{% endnavtabs %}
{% endnavtab %}
{% navtab Gateway APIs %}
{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "apiVersion: gateway.networking.k8s.io/v1alpha2
kind: UDPRoute
metadata:
  name: tftp
  namespace: udp-example
spec:
  parentRefs:
  - name: kong
    namespace: default
  rules:
  - backendRefs:
    - name: tftp
      port: 9999
" | kubectl apply -f -
```
{% endnavtab %}
{% navtab Response %}
```text
```
{% endnavtab %}
{% endnavtabs %}
{% endnavtab %}
{% endnavtabs %}

This configuration routes traffic to UDP port `9999` on the
{{site.base_gateway}} proxy to port `9999` on the TFTP test server.

## Test the configuration

First, retrieve the external IP address of the UDP proxy Service you created
previously:

{% navtabs codeblock %}
{% navtab Command %}
```bash
export KONG_UDP_ENDPOINT="$(kubectl -n kong get service kong-udp-proxy \
    -o=go-template='{% raw %}{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}{% endraw %}')"
```
{% endnavtab %}
{% navtab Response %}
No output.
{% endnavtab %}
{% endnavtabs %}

After, use curl to send a TFTP request through the proxy:

{% navtabs codeblock %}
{% navtab Command %}
```bash
curl -s tftp://${KONG_UDP_ENDPOINT}:9999/hello
```
{% endnavtab %}
{% navtab Response %}
```text
Hostname: tftp-5849bfd46f-nqk9x

Request Information:
	client_address=10.244.0.1
	client_port=39364
	real path=/hello
	request_scheme=tftp
```
{% endnavtab %}
{% endnavtabs %}
