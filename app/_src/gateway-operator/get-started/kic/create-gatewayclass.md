---
title: Create a GatewayClass
content-type: tutorial
book: kgo-kic-get-started
chapter: 2
alpha: true
---

To use the Gateway API resources to configure your routes, you need to create a `GatewayClass` instance and create a `Gateway` resource that listens on the ports that you need.

```yaml
echo '
kind: GatewayClass
apiVersion: gateway.networking.k8s.io/v1beta1
metadata:
  name: kong
spec:
  controllerName: konghq.com/gateway-operator
---
kind: Gateway
apiVersion: gateway.networking.k8s.io/v1beta1
metadata:
  name: kong
spec:
  gatewayClassName: kong
  listeners:
  - name: http
    protocol: HTTP
    port: 80
' | kubectl apply -f -

The results should look like this:

    ```text
    gatewayclass.gateway.networking.k8s.io/kong created
    gateway.gateway.networking.k8s.io/kong created

Run `kubectl get gateway kong` to get the IP address for the gateway and set that as the value for the variable `PROXY_IP`.

```bash
export PROXY_IP=$(kubectl get gateway kong -o jsonpath='{.status.addresses[0].value}')
```

{:.note}
> Note: if your cluster can not provision LoadBalancer type Services then the IP you receive may only be routable from within the cluster.

