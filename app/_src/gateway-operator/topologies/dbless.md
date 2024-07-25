---
title: DB-less Deployments
---

{% assign gatewayApiVersion = "v1beta1" %}
{% if_version gte:1.1.x %}
{% assign gatewayApiVersion = "v1" %}
{% endif_version %}

{% assign gatewayConfigApiVersion = "v1beta1" %}
{% if_version lte:1.1.x %}
{% assign gatewayConfigApiVersion = "v1alpha1" %}
{% endif_version %}

{{ site.kgo_product_name }} can deploy both a {{ site.kic_product_name }} Control Plane and Data Plane resources automatically.

DB-less deployments are powered using the [Kubernetes Gateway API](https://github.com/kubernetes-sigs/gateway-api).
You configure your `GatewayClass`, `Gateway` and `GatewayConfiguration` objects and {{ site.kgo_product_name }} translates those requirements in to Kong specific configuration.

## Installation

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
            image: kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}
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

You can now run `kubectl get -n default gateway kong` to get the IP address for the running gateway.

{:.note}
> Note: if your cluster can not provision LoadBalancer type Services then the IP you receive may only be routable from within the cluster.

## Configuring Gateways

A `Gateway` resource has subcomponents such as a `ControlPlane` and a `DataPlane,` which are created and managed on its behalf.
At a deeper technical level, `ControlPlane` corresponds with the [{{ site.kic_product_name }}](/kubernetes-ingress-controller/) and `DataPlane` corresponds with the [{{site.base_gateway}}](/gateway/latest/).

While not required for primary usage, it is possible to provide configuration for these subcomponents using the `GatewayConfiguration` API.
That configuration can include the container image and image version to use for the subcomponents, as well as environment and volume mount overrides will be passed down to`Pods` created for that component.

For example:

```yaml
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
            image: kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}
          env:
          - name: TEST_VAR
            value: TEST_VAL
  controlPlaneOptions:
    deployment:
      podTemplateSpec:
        spec:
          containers:
          - name: controller
            image: kong/kubernetes-ingress-controller:{{ site.data.kong_latest_KIC.version }}
          env:
          - name: TEST_VAR
            value: TEST_VAL
```

Configurations like the above can be created on the API, but won't be active until referenced by a `GatewayClass`:

```yaml
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
```

With the `parametersRef` in the above `GatewayClass` being used to attach the `GatewayConfiguration`, that configuration will start applying to all `Gateway`resources created for that class, and will retroactively apply to any `Gateway`resources previously created.

## {{site.ee_product_name}}

You can use {{site.ee_product_name}} as the data plane using the following steps:

{:.note}
> **Note**: The license secret, the `GatewayConfiguration`, and the `Gateway` MUST be created in the same namespace.

1. Create a secret with the Kong license in the namespace you intend to use for deploying the gateway.

    ```bash
    kubectl create secret generic kong-enterprise-license --from-file=license=<license-file> -n <your-namespace>
    ```

2. Create a `GatewayConfiguration` specifying the enterprise container image and the environment variable referencing the license secret.
  The operator will use the image and the environment variable specified in the `GatewayConfiguration` to customize the dataplane.
  As the result, the dataplane will use `kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}` as the image and mount the license secret.

    ```yaml
    kind: GatewayConfiguration
    apiVersion: gateway-operator.konghq.com/{{ gatewayConfigApiVersion }}
    metadata:
      name: kong
      namespace: <your-namespace>
    spec:
      dataPlaneOptions:
        deployment:
          podTemplateSpec:
            spec:
              containers:
              - name: proxy
                image: kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}
              env:
              - name: KONG_LICENSE_DATA
                valueFrom:
                  secretKeyRef:
                    key: license
                    name: kong-enterprise-license
    ```

3. Create a `GatewayClass` that references the `GatewayConfiguration` above.

    ```yaml
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
        namespace: <your-namespace>
    ```

4. And finally create a Gateway that uses the `GatewayClass` above:

    ```yaml
    kind: Gateway
    apiVersion: gateway.networking.k8s.io/{{ gatewayApiVersion }}
    metadata:
      name: kong
      namespace: <your-namespace>
    spec:
      gatewayClassName: kong
      listeners:
      - name: http
        protocol: HTTP
        port: 80
    ```

5. Wait for the `Gateway` to be `Ready`:

    ```bash
    kubectl wait --for=condition=Ready=true gateways.gateway.networking.k8s.io/kong
    ```

6. Check that the data plane is using the enterprise image:

    ```bash
    $ kubectl get deployment -l konghq.com/gateway-operator=dataplane -o jsonpath='{.items[0].spec.template.spec.containers[0].image}'

    kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}
    ```

7. A log message should describe the status of the provided license.

    ```bash
    $ kubectl logs $(kubectl get po -l app=$(kubectl get dataplane -o=jsonpath='{.items[0].metadata.name}') -o=jsonpath="{.items[0].metadata.name}") | grep license_helpers.lua

    2022/08/29 10:50:55 [error] 2111#0: *8 [lua] license_helpers.lua:194: log_license_state(): The Kong Enterprise license will expire on 2022-09-20. Please contact <support@konghq.com> to renew your license., context: ngx.timer
    ```
