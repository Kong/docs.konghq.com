---
title: Create a Gateway
content-type: tutorial
book: kgo-kic-get-started
chapter: 2
---

{% assign gatewayApiVersion = "v1" %}
{% assign gatewayConfigApiVersion = "v1beta1" %}

Creating `GatewayClass` and `Gateway` resources in Kubernetes causes {{ site.kgo_product_name }} to create a {{ site.kic_product_name }} and {{ site.base_gateway }} deployment.

## GatewayConfiguration

You can customize your {{ site.kic_product_name }} and {{ site.base_gateway }} deployments using the `GatewayConfiguration` CRD. This allows you to control the image being used, and set any required environment variables.
{%- if_version gte:1.2.x %}
If you are creating a KIC in {{site.konnect_short_name}} deployment, you need to customize the deployment to contain your control plane ID and authentication certificate.
{%- endif_version %}

{% navtabs gc %}
{% navtab Konnect %}

{% include md/kgo/konnect-dataplanes-prerequisites.md disable_accordian=true version=page.version release=page.release is-kic-cp=true manual-secret-provisioning=false skip_install=true %}

## Create the GatewayConfiguration

In order to specify the `KonnectExtension` in `Gateway`'s configuration you need to create a `GatewayConfiguration` object which will hold the `KonnectExtension` reference.

```bash
echo '
kind: GatewayConfiguration
apiVersion: gateway-operator.konghq.com/v1beta1
metadata:
  name: kong
  namespace: default
spec:
  extensions:
    - kind: KonnectExtension
      name: my-konnect-config
      group: konnect.konghq.com
  dataPlaneOptions:
    deployment:
      replicas: 2
  controlPlaneOptions:
    deployment:
      podTemplateSpec:
        spec:
          containers:
          - name: controller
            env:
            - name: CONTROLLER_LOG_LEVEL
              value: debug' | kubectl apply -f -
```

{% endnavtab %}
{% navtab On-Prem %}

Use the following example to customize the log level of {{ site.kic_product_name }}:

```yaml
echo 'kind: GatewayConfiguration
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
            image: kong:{{site.latest_gateway_oss_version}}
  controlPlaneOptions:
    deployment:
      podTemplateSpec:
        spec:
          containers:
          - name: controller
            image: kong/kubernetes-ingress-controller:{{ site.data.kong_latest_KIC.version }}
            env:
            - name: CONTROLLER_LOG_LEVEL
              value: debug' | kubectl apply -f -
```
{% endnavtab %}
{% endnavtabs %}

The results should look like this:

```text
gatewayconfiguration.gateway-operator.konghq.com/kong created
```

## GatewayClass

To use the Gateway API resources to configure your routes, you need to create a `GatewayClass` instance and create a `Gateway` resource that listens on the ports that you need.

```yaml
echo '
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
    port: 80' | kubectl apply -f -
```

The results should look like this:

```text
gatewayclass.gateway.networking.k8s.io/kong created
gateway.gateway.networking.k8s.io/kong created
```

You can verify that everything works by checking the `Gateway` resource via `kubectl`:

```bash
kubectl get gateway kong -o wide
```

You should see the following output:

```
NAME   CLASS   ADDRESS        PROGRAMMED   AGE
kong   kong    172.18.0.102   True         9m5s
```

If the `Gateway` has `Programmed` condition set to `True` then you can visit {{site.konnect_short_name}} and see your configuration being synced by {{ site.kic_product_name }}.
