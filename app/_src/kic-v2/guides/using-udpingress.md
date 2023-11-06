---
title: Exposing a UDP Service
content_type: tutorial
---

## Overview

Deploy a simple [Service][svc] that listens for [UDP datagrams][udp], and exposes this service outside of the cluster using
{{site.base_gateway}}.

{% include_cached /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=false %}


## Add UDP listens

{{site.base_gateway}} does not include any UDP listen configuration by default.
To expose UDP listens, update the environment variables of the Deployment and port
configuration.

```bash
kubectl patch deploy -n kong kong-gateway --patch '{
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
The results should look like this:
```text
deployment.apps/kong-gateway patched
```

## Add a UDP proxy Service

LoadBalancer Services only support a single transport protocol in [Kubernetes
versions prior to 1.26](https://github.com/kubernetes/enhancements/issues/1435).
To direct UDP traffic to the proxy Service, create a second Service named `kong-udp-proxy`.

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
    app: kong-gateway
  type: LoadBalancer
" | kubectl apply -f -
```
The results should look like this:
```text
service/kong-udp-proxy created
```

This Service is typically added through the `udpProxy`configuration of the Kong Helm chart.
Configure this manually to check the resources the chart manages and for compatibility with non-Helm installs.

## Update the Gateway

If you are using Gateway APIs (UDPRoute) option, your Gateway needs additional
configuration under `listeners`. If you are using UDPIngress, you can skip this step.

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
The results should look like this:
```text
gateway.gateway.networking.k8s.io/kong patched
```


## Deploy a UDP test application

1. Create a namespace for deploying the UDP application.
    ```bash
    kubectl create namespace udp-example
    ```
    The results should look like this:
    ```text
    namespace/udp-example created
    ```
    When you've completed this guide, use the `kubectl delete namespace udp-example` command to clean those resources.

1.  Create a test application Deployment and an associated Service.

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
    The results should look like this:
    ```text
    deployment.apps/tftp created
    service/tftp created
    ```

    [echoserver-udp](https://hub.docker.com/r/cilium/echoserver-udp) is a simple
    test server that accepts UDP TFTP requests and returns basic request
    information. Because curl supports TFTP you can use it to test UDP routing.

## Route UDP traffic

Now that {{site.base_gateway}} is listening on `9999` and the test application
is running, you can create UDP routing configuration that proxies traffic to
the application:

{% navtabs api %}
{% navtab Ingress %}
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
The results should look like this:
```text
udpingress.configuration.konghq.com/tftp created
```
{% endnavtab %}
{% navtab Gateway API %}
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
The results should look like this:
```text
udproute.gateway.networking.k8s.io/tftp created
```
{% endnavtab %}
{% endnavtabs %}

This configuration routes traffic to UDP port `9999` on the
{{site.base_gateway}} proxy to port `9999` on the TFTP test server.

## Test the UDP routing configuration

1. Retrieve the external IP address of the UDP proxy Service you created and set the `KONG_UDP_ENDPOINT` variable.

    ```bash
    export KONG_UDP_ENDPOINT="$(kubectl -n kong get service kong-udp-proxy \
    -o=go-template='{% raw %}{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}{% endraw %}')"
    ```
1. Send a TFTP request through the proxy.

    ```bash
    curl -s tftp://${KONG_UDP_ENDPOINT}:9999/hello
    ```
    The results should look like this:
    ```text
    Hostname: tftp-5849bfd46f-nqk9x
    
    Request Information:
    	client_address=10.244.0.1
    	client_port=39364
    	real path=/hello
    	request_scheme=tftp
    ```
[svc]:https://kubernetes.io/docs/concepts/services-networking/service/
[udp]:https://datatracker.ietf.org/doc/html/rfc768
