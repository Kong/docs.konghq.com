---
title: Exposing a UDP Service
content_type: tutorial
---

## Overview

This guide walks through deploying a simple [Service][svc] that listens for
[UDP datagrams][udp], and exposes this service outside of the cluster using
{{site.base_gateway}}.

For this example, you will:
* Deploy a [CoreDNS][coredns] to serve DNS requests over UDP.
* Route UDP traffic to it using UDPIngress or UDPRoute.

{% include /md/kic/installation.md %}

{% include /md/kic/class.md %}

[dns]:https://datatracker.ietf.org/doc/html/rfc1035
[kubedns]:https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/
[pods]:https://kubernetes.io/docs/concepts/workloads/pods/
[coredns]:https://coredns.io/
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
this guide, `kubectl delete namespace udp-example` will clean them up.

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
    port: 53
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


## Deploy CoreDNS

First, create a basic CoreDNS configuration ConfigMap:

{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns
  namespace: udp-example
data:
  Corefile: |-
    .:53 {
        errors
        health {
           lameduck 5s
        }
        ready
        kubernetes cluster.local in-addr.arpa ip6.arpa {
           pods insecure
           fallthrough in-addr.arpa ip6.arpa
           ttl 30
        }
        forward . /etc/resolv.conf {
           max_concurrent 1000
        }
        cache 30
        loop
        reload
        loadbalance
    }
" | kubectl apply -f -
```
{% endnavtab %}
{% navtab Response %}
```text
configmap/coredns created
```
{% endnavtab %}
{% endnavtabs %}

This simple configuration tells CoreDNS pods to forward all requests to the
default nameservers configured on its host. With configuration in place, create
a CoreDNS Deployment and Service:

{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: coredns
  namespace: udp-example
  labels:
    app: coredns
spec:
  replicas: 1
  selector:
    matchLabels:
      app: coredns
  template:
    metadata:
      labels:
        app: coredns
    spec:
      containers:
      - args:
        - -conf
        - /etc/coredns/Corefile
        image: coredns/coredns
        imagePullPolicy: IfNotPresent
        name: coredns
        ports:
        - containerPort: 53
          protocol: UDP
        volumeMounts:
        - mountPath: /etc/coredns
          name: config-volume
      volumes:
      - configMap:
          defaultMode: 420
          items:
          - key: Corefile
            path: Corefile
          name: coredns
        name: config-volume
---
apiVersion: v1
kind: Service
metadata:
  name: coredns
  namespace: udp-example
spec:
  ports:
  - port: 53
    name: udp-53
    protocol: UDP
    targetPort: 53
  - port: 9999
    name: udp-9999
    protocol: UDP
    targetPort: 53
  selector:
    app: coredns
  type: ClusterIP
" | kubectl apply -f -
```
{% endnavtab %}
{% navtab Response %}
```text
deployment.apps/coredns created
service/coredns created
```
{% endnavtab %}
{% endnavtabs %}

## Route UDP traffic

Now that {{site.base_gateway}} is listening on `9999`, you can create a UDPIngress resource which will attach
the CoreDNS service to that port so you can make DNS requests to it from outside the cluster.

{% navtabs api %}
{% navtab Ingress %}
{% navtabs codeblock %}
{% navtab Command %}
```bash
echo "apiVersion: configuration.konghq.com/v1beta1
kind: UDPIngress
metadata:
  name: coredns
  namespace: udp-example
  annotations:
    kubernetes.io/ingress.class: kong
spec:
  rules:
  - backend:
      serviceName: coredns
      servicePort: 53
    port: 9999
" | kubectl apply -f -
```
{% endnavtab %}
{% navtab Response %}
```text
udpingress.configuration.konghq.com/coredns created
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
  name: coredns
  namespace: udp-example
spec:
  parentRefs:
  - name: kong
    namespace: default
  rules:
  - backendRefs:
    - name: coredns
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
{{site.base_gateway}} proxy to port `53` for our DNS server.

## Test the configuration

Now that setup is complete, all that's left to do is verify that everything is working
by making a DNS request to our CoreDNS server.

> **Note:** This example assumes you have the `dig` command available on your local
 system. If you don't, refer to your operating system documentation for a similar DNS
 lookup tool.

First, retrieve the IP address of the UDP load balancer service that we
configured in previous sections:

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

Now that you've stored the IP in the environment variable `KONG_UDP_ENDPOINT`, you can use
that with `dig` to do a DNS lookup through the CoreDNS server you set up and exposed
using UDPIngress:

{% navtabs codeblock %}
{% navtab Command %}
```bash
dig @${KONG_UDP_ENDPOINT} -p 9999 konghq.com
```
{% endnavtab %}
{% navtab Response %}
```text
;; ANSWER SECTION:
konghq.com.		30	IN	A	34.83.126.248

;; Query time: 60 msec
;; SERVER: <KONG_UDP_ENDPOINT>#9999
;; WHEN: Thu Aug 19 08:39:16 EDT 2021
;; MSG SIZE  rcvd: 77
```
{% endnavtab %}
{% endnavtabs %}

Verify that the `{KONG_UDP_ENDPOINT}` in the `SERVER` section of the response above ends
up being equal to your `${KONG_UDP_ENDPOINT}` value.

Now you're equipped to route UDP traffic into your Kubernetes cluster with {{site.base_gateway}}!
