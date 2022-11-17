---
title: Exposing a TCP Service
content_type: tutorial
---

## Overview

This guide walks through creating TCP routing configuration for
{{site.base_gateway}} in Kubernetes using either the TCPIngress custom
resource or TCPRoute and TLSRoute Gateway APIs resource.

TCP-based Ingress means that {{site.base_gateway}} simply forwards the TCP stream to a Pod
of a Service that's running inside Kubernetes. {{site.base_gateway}} will not perform any
sort of transformations.

There are two modes available:
- **Port based routing**: In this mode, {{site.base_gateway}} simply proxies all traffic it
  receives on a specific port to the Kubernetes Service. TCP connections are
  load balanced across all the available pods of the Service.
- **SNI based routing**: In this mode, {{site.base_gateway}} accepts a TLS-encrypted stream
  at the specified port and can route traffic to different services based on
  the `SNI` present in the TLS handshake. {{site.base_gateway}} will also terminate the TLS
  handshake and forward the TCP stream to the Kubernetes Service.

{% include_cached /md/kic/installation.md kong_version=page.kong_version %}

{% include_cached /md/kic/class.md kong_version=page.kong_version %}

## Add TLS configuration

{% include_cached /md/kic/add-certificate.md hostname='tls9443.kong.example' kong_version=page.kong_version %}

## Adding TCP listens

{{site.base_gateway}} does not include any TCP listen configuration by default.
To expose TCP listens, update the Deployment's environment variables and port
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
                "value": "0.0.0.0:9000, 0.0.0.0:9443 ssl"
              }
            ],
            "ports": [
              {
                "containerPort": 9000,
                "name": "stream9000",
                "protocol": "TCP"
              },
              {
                "containerPort": 9443,
                "name": "stream9443",
                "protocol": "TCP"
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

The `ssl` parameter after the 9443 listen instructs {{site.base_gateway}} to
expect TLS-encrypted TCP traffic on that port. The 9000 listen has no
parameters, and expects plain TCP traffic.

## Update the proxy Service

The proxy Service also needs to indicate the new ports:

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl patch service -n kong kong-proxy --patch '{
  "spec": {
    "ports": [
      {
        "name": "stream9000",
        "port": 9000,
        "protocol": "TCP",
        "targetPort": 9000
      },
      {
        "name": "stream9443",
        "port": 9443,
        "protocol": "TCP",
        "targetPort": 9443
      }
    ]
  }
}'
```
{% endnavtab %}
{% navtab Response %}
```text
service/kong-proxy patched
```
{% endnavtab %}
{% endnavtabs %}

## Update the Gateway

If you are using Gateway APIs (TCPRoute) option, your Gateway needs additional
configuration under `listeners`. If you are using TCPIngress, skip this step.

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl patch --type=json gateway kong -p='[
    {
        "op":"add",
        "path":"/spec/listeners/-",
        "value":{
            "name":"stream9000",
            "port":9000,
            "protocol":"TCP"
        }
    },
    {
        "op":"add",
        "path":"/spec/listeners/-",
        "value":{
            "name":"stream9443",
            "port":9443,
            "protocol":"TLS",
            "hostname":"tls9443.kong.example",
			"tls": {
                "certificateRefs":[{
                    "group":"",
                    "kind":"Secret",
                    "name":"tls9443.kong.example"
                }]
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

## Install TCP echo service

Next, install an example TCP service:

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl apply -f {{site.links.web}}/assets/kubernetes-ingress-controller/examples/tcp-echo-service.yaml
```
{% endnavtab %}
{% navtab Response %}
```text
deployment.apps/tcp-echo created
service/tcp-echo created
```
{% endnavtab %}
{% endnavtabs %}

## Route TCP traffic by port

To expose  service to the outside world, create the following
TCPIngress resource:

{% navtabs api %}
{% navtab Ingress %}
{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "apiVersion: configuration.konghq.com/v1beta1
kind: TCPIngress
metadata:
  name: echo-plaintext
  annotations:
    kubernetes.io/ingress.class: kong
spec:
  rules:
  - port: 9000
    backend:
      serviceName: tcp-echo
      servicePort: 2701
" | kubectl apply -f -
```
{% endnavtab %}
{% navtab Response %}
```text
tcpingress.configuration.konghq.com/echo-plaintext created
```
{% endnavtab %}
{% endnavtabs %}
{% endnavtab %}
{% navtab Gateway APIs %}
{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "apiVersion: gateway.networking.k8s.io/v1alpha2
kind: TCPRoute
metadata:
  name: echo-plaintext
spec:
  parentRefs:
  - name: kong
  rules:
  - backendRefs:
    - name: tcp-echo
      port: 9000
" | kubectl apply -f -
```
{% endnavtab %}

{:.note}
> v1alpha2 TCPRoutes do not support separate proxy and upstream ports. Traffic
> is redirected to `2701` upstream via Service configuration.

{% navtab Response %}
```text
tcproute.gateway.networking.k8s.io/echo-plaintext created
```
{% endnavtab %}
{% endnavtabs %}
{% endnavtab %}
{% endnavtabs %}

This configuration instructs {{site.base_gateway}} to forward all traffic it
receives on port 9000 to `tcp-echo` service on port 2701.

### Test the configuration

Status will populate with an IP or Accepted condition once the route is ready:

{% navtabs api %}
{% navtab Ingress %}
{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl get tcpingress
```
{% endnavtab %}
{% navtab Response %}
```text
NAME             ADDRESS        AGE
echo-plaintext   <PROXY_IP>   3m18s
```
{% endnavtab %}
{% endnavtabs %}
{% endnavtab %}
{% navtab Gateway APIs %}
{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl get tcproute echo-plaintext -ojsonpath='{.status.parents[0].conditions[?(@.reason=="Accepted")]}'
```
{% endnavtab %}
{% navtab Response %}
```text
{"lastTransitionTime":"2022-11-14T19:48:51Z","message":"","observedGeneration":2,"reason":"Accepted","status":"True","type":"Accepted"}
```
{% endnavtab %}
{% endnavtabs %}
{% endnavtab %}
{% endnavtabs %}

Connect to this service using `telnet`:

```shell
$ telnet $PROXY_IP 9000
Trying 35.247.39.83...
Connected to 35.247.39.83.
Escape character is '^]'.
Welcome, you are connected to node gke-harry-k8s-dev-pool-1-e9ebab5e-c4gw.
Running on Pod tcp-echo-844545646c-gvmkd.
In namespace default.
With IP address 10.60.1.17.
This text will be echoed back.
This text will be echoed back.
^]
telnet> Connection closed.
```

We can see here that the `tcp-echo` service is now available outside the
Kubernetes cluster via {{site.base_gateway}}.

## Route TLS traffic by SNI

Next, we will demonstrate how {{site.base_gateway}} can route TLS-encrypted
traffic to the `tcp-echo` service.

Create the following TCPIngress resource:

{% navtabs api %}
{% navtab Ingress %}
{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "apiVersion: configuration.konghq.com/v1beta1
kind: TCPIngress
metadata:
  name: echo-tls
  annotations:
    kubernetes.io/ingress.class: kong
spec:
  tls:
  - hosts:
    - tls9443.kong.example
    secretName: tls9443.kong.example
  rules:
  - host: tls9443.kong.example
    port: 9443
    backend:
      serviceName: tcp-echo
      servicePort: 2701
" | kubectl apply -f -
```
{% endnavtab %}
{% navtab Response %}
```text
tcpingress.configuration.konghq.com/echo-tls created
```
{% endnavtab %}
{% endnavtabs %}
{% endnavtab %}
{% navtab Gateway APIs %}
{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "apiVersion: gateway.networking.k8s.io/v1alpha2
kind: TLSRoute
metadata:
  name: tlsecho
spec:
  parentRefs:
  - name: kong
  hostnames:
  - tls9443.kong.example
  rules:
  - backendRefs:
    - name: tcp-echo
      port: 9443
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

### Test the configuration

You can now access the `tcp-echo` service on port 9443 with SNI
`tls9443.kong.example`.

In real-world usage, you would create a DNS record for `tls9443.kong.example`
pointing to your proxy Service's public IP address, which causes TLS clients to
add SNI automatically. For this demo, you'll add it manually using the OpenSSL
CLI:

{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "hello" | openssl s_client -connect $PROXY_IP:9443 -servername tls9443.kong.example -quiet 2>/dev/null 
```
Press Ctrl+C to exit after.
{% endnavtab %}
{% navtab Response %}
```text
Welcome, you are connected to node kind-control-plane.
Running on Pod tcp-echo-5f44d4c6f9-krnhk.
In namespace default.
With IP address 10.244.0.26.
hello
```
{% endnavtab %}
{% endnavtabs %}
