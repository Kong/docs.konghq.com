---
title: Proxy TCP requests
type: how-to
purpose: |
  How to proxy TCP requests
---

Create TCP routing configuration for {{site.base_gateway}} in Kubernetes using either the `TCPIngress` custom resource or `TCPRoute` and `TLSRoute` Gateway APIs resource.
TCP-based Ingress means that {{site.base_gateway}} forwards the TCP stream to a Pod of a Service that's running inside Kubernetes. {{site.base_gateway}} does not perform any sort of transformations.

There are two modes available:
- **Port based routing**: {{site.base_gateway}} simply proxies all traffic it receives on a specific port to the Kubernetes Service. TCP connections are load balanced across all the available Pods of the Service.
- **SNI based routing**: {{site.base_gateway}} accepts a TLS-encrypted stream at the specified port and can route traffic to different services based on the `SNI` present in the TLS handshake. {{site.base_gateway}} also terminates the TLS handshake and forward the TCP stream to the Kubernetes Service.

{% include /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=false gateway_api_experimental=true %}

## Expose additional ports

{{site.base_gateway}} does not include any TCP listen configuration by default. To expose TCP listens, update the Deployment's environment variables and port configuration.

1. Update the Deployment.
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
    The results should look like this:
    ```text
    deployment.apps/kong-gateway patched
    ```

    The `ssl` parameter after the 9443 listen instructs {{site.base_gateway}} to expect TLS-encrypted TCP traffic on that port. The 9000 listen has no parameters, and expects plain TCP traffic.

1.  Update the proxy Service to indicate the new ports.

    ```bash
    kubectl patch service -n kong kong-gateway-proxy --patch '{
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
    The results should look like this:
    ```text
    service/kong-gateway-proxy patched
    ```
1.  Configure TCPRoute (Gateway API Only)

    {:.note}
    > If you are using the Gateway APIs (TCPRoute), your Gateway needs additional configuration under `listeners`. 

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
    The results should look like this:
    ```text
    gateway.gateway.networking.k8s.io/kong patched
    ```

{% include /md/kic/test-service-echo.md kong_version=page.kong_version %}

## Route based on ports

To expose the service to the outside world, create a TCPRoute resource for Gateway APIs or a TCPIngress resource for Ingress.

{% navtabs api %}
{% navtab Gateway API %}
```bash
echo "apiVersion: gateway.networking.k8s.io/v1alpha2
kind: TCPRoute
metadata:
  name: echo-plaintext
spec:
  parentRefs:
  - name: kong
    sectionName: stream9000
  rules:
  - backendRefs:
    - name: echo
      port: 1025
" | kubectl apply -f -
```

{:.note}
> v1alpha2 TCPRoutes do not support separate proxy and upstream ports. Traffic
> is redirected to `1025` upstream via Service configuration.

The results should look like this:
```text
tcproute.gateway.networking.k8s.io/echo-plaintext created
```
{% endnavtab %}
{% navtab Ingress %}
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
      serviceName: echo
      servicePort: 1025
" | kubectl apply -f -
```
The results should look like this:
```text
tcpingress.configuration.konghq.com/echo-plaintext created
```
{% endnavtab %}
{% endnavtabs %}

This configuration instructs {{site.base_gateway}} to forward all traffic it
receives on port 9000 to `echo` service on port 1025.

### Test the configuration

1. Check if the Service is ready on the route.
    {% capture the_code %}
{% navtabs codeblock %}
{% navtab Gateway API %}
```bash
kubectl get tcproute echo-plaintext -ojsonpath='{.status.parents[0].conditions[?(@.reason=="Accepted")]}'
```
{% endnavtab %}
{% navtab Ingress %}
```bash
kubectl get tcpingress
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

    The results should look like this:

    {% capture the_code %}
{% navtabs codeblock %}
{% navtab Gateway API %}
```text
{"lastTransitionTime":"2022-11-14T19:48:51Z","message":"","observedGeneration":2,"reason":"Accepted","status":"True","type":"Accepted"}

```
{% endnavtab %}
{% navtab Ingress %}
```text
NAME             ADDRESS        AGE
echo-plaintext   192.0.2.3   3m18s

```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

1. Connect to this service using `telnet`.
    ```shell
    $ telnet $PROXY_IP 9000
    ```

    After you  connect, type some text that you want as a response from the echo Service. 
    ```
    Trying 192.0.2.3...
    Connected to 192.0.2.3.
    Escape character is '^]'.
    Welcome, you are connected to node gke-harry-k8s-dev-pool-1-e9ebab5e-c4gw.
    Running on Pod echo-844545646c-gvmkd.
    In namespace default.
    With IP address 192.0.2.7.
    This text will be echoed back.
    This text will be echoed back.
    ^]
    telnet> Connection closed.
    ```
    To exit, press `ctrl+]` then `ctrl+d`.

    The `echo` Service is now available outside the Kubernetes cluster through {{site.base_gateway}}.

## Route based on SNI

{% include /md/kic/add-certificate.md hostname='tls9443.kong.example' kong_version=page.kong_version %}

1. Create the TCPIngress resource to route TLS-encrypted traffic to the `echo` service.
  {% capture the_code %}
{% navtabs codeblock %}
{% navtab Gateway API %}
```bash
echo "apiVersion: gateway.networking.k8s.io/v1alpha2
kind: TLSRoute
metadata:
  name: echo-tls
spec:
  parentRefs:
    - name: kong
      sectionName: stream9443
  hostnames:
    - tls9443.kong.example
  rules:
    - backendRefs:
      - name: echo
        port: 1025
" | kubectl apply -f -
```
{% endnavtab %}
{% navtab Ingress %}
```bash
echo "apiVersion: configuration.konghq.com/v1beta1
kind: TCPIngress
metadata:
  name: echo-tls
  annotations:
    kubernetes.io/ingress.class: kong
spec:
  tls:
  - secretName: tls9443.kong.example
    hosts:
      - tls9443.kong.example
  rules:
  - host: tls9443.kong.example
    port: 9443
    backend:
      serviceName: echo
      servicePort: 1025
" | kubectl apply -f -
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

    The results should look like this:

    {% capture the_code %}
{% navtabs codeblock %}
{% navtab Gateway API %}
```text
tcproute.gateway.networking.k8s.io/echo-tls created
```
{% endnavtab %}
{% navtab Ingress %}
```text
tcpingress.configuration.konghq.com/echo-tls created
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}


### Test the configuration

You can now access the `echo` service on port 9443 with SNI `tls9443.kong.example`.

In real-world usage, you would create a DNS record for `tls9443.kong.example`pointing to your proxy Service's public IP address, which causes TLS clients to add SNI automatically. For this demo, add it manually using the OpenSSL CLI.

```bash
echo "hello" | openssl s_client -connect $PROXY_IP:9443 -servername tls9443.kong.example -quiet 2>/dev/null
```
Press Ctrl+C to exit.

The results should look like this:
```text
Welcome, you are connected to node kind-control-plane.
Running on Pod echo-5f44d4c6f9-krnhk.
In namespace default.
With IP address 10.244.0.26.
hello
```
