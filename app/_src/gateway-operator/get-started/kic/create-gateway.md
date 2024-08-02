---
title: Create a GatewayClass
content-type: tutorial
book: kgo-kic-get-started
chapter: 2
---

{% assign gatewayApiVersion = "v1beta1" %}
{% if_version gte:1.1.x %}
{% assign gatewayApiVersion = "v1" %}
{% endif_version %}

{% assign gatewayConfigApiVersion = "v1beta1" %}
{% if_version lte:1.1.x %}
{% assign gatewayConfigApiVersion = "v1alpha1" %}
{% endif_version %}

{% if_version lte: 1.1.x %}
{:.note}
> **Note:** `Gateway` and `ControlPlane` controllers are still `alpha` so be sure
> to use the [installation steps from this guide](/gateway-operator/{{ page.release }}/get-started/kic/install/)
> in order to get your `Gateway` up and running.
{% endif_version %}

To use the Gateway API resources to configure your routes, you need to create a `GatewayClass` instance and create a `Gateway` resource that listens on the ports that you need.

```yaml
echo '
kind: GatewayConfiguration
apiVersion: gateway-operator.konghq.com/{{ gatewayConfigApiVersion }}
metadata:
  name: kong
  namespace: default
spec:
  dataPlaneOptions:
    deployment:
      podTemplateSpec:
        spec:
          containers:
          - name: proxy
            image: kong:{{ site.data.kong_latest_gateway.ce-version }}
            readinessProbe:
              initialDelaySeconds: 1
              periodSeconds: 1
  controlPlaneOptions:
    deployment:
      podTemplateSpec:
        spec:
          containers:
          - name: controller
            image: kong/kubernetes-ingress-controller:{{ site.data.kong_latest_KIC.version }}
            env:
            - name: CONTROLLER_LOG_LEVEL
              value: debug
---
kind: GatewayClass
apiVersion: gateway.networking.k8s.io/{{ gatewayApiVersion }}
metadata:
  name: kong
spec:
  controllerName: konghq.com/gateway-operator
  parametersRef:
    group: gateway-operator.konghq.com
    kind: GatewayConfiguration
    name: kong
    namespace: default
---
kind: Gateway
apiVersion: gateway.networking.k8s.io/{{ gatewayApiVersion }}
metadata:
  name: kong
  namespace: default
spec:
  gatewayClassName: kong
  listeners:
  - name: http
    protocol: HTTP
    port: 80

' | kubectl apply -f -
```

The results should look like this:

```text
gatewayconfiguration.gateway-operator.konghq.com/kong created
gatewayclass.gateway.networking.k8s.io/kong created
gateway.gateway.networking.k8s.io/kong created
```

Run `kubectl get gateway kong -n default` to get the IP address for the gateway and set that as the value for the variable `PROXY_IP`.

```bash
export PROXY_IP=$(kubectl get gateway kong -n default -o jsonpath='{.status.addresses[0].value}')
```

{:.note}
> Note: if your cluster can not provision LoadBalancer type Services then the IP you receive may only be routable from within the cluster.
