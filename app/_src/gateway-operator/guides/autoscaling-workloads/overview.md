---
title: Horizontally autoscale workloads
badge: enterprise
---

{% assign gatewayApiVersion = "v1beta1" %}
{% if_version gte:1.1.x %}
{% assign gatewayApiVersion = "v1" %}
{% endif_version %}

{{ site.kgo_product_name }} can scrape {{ site.base_gateway }} and enrich it with Kubernetes metadata so that it can be used by users to autoscale their workloads.

{% include md/kgo/prerequisites.md version=page.version release=page.release enterprise=true %}

## Overview

{{ site.base_gateway }} provides extensive metrics through it's Prometheus plugin. However, these metrics are labelled with Kong entities such as `Service` and `Route` rather than Kubernetes resources.

{{ site.kgo_product_name }} provides [`DataPlaneMetricsExtension`](/gateway-operator/{{ page.release }}/reference/custom-resources/#dataplanemetricsextension), which scrapes the Kong metrics and enriches them with Kubernetes labels before exposing them on it's own `/metrics` endpoint.

These enriched metrics can be used with the Kubernetes [`HorizontalPodAutoscaler`](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/) to autoscale workloads.

## How it works

Attaching a `DataPlaneMetricsExtension` resource to a `ControlPlane` will:

- Create a managed Prometheus `KongPlugin` instance with the [configuration](/hub/kong-inc/prometheus/configuration/) defined in [`MetricsConfig`](/gateway-operator/{{ page.release }}/reference/custom-resources/#metricsconfig)
- Append the managed plugin to the selected `Service`s (through `DataPlaneMetricsExtension`'s [`serviceSelector`](/gateway-operator/{{ page.release }}/reference/custom-resources/#serviceselector) field)
   `konghq.com/plugins` annotation
- Scrape {{ site.base_gateway }}'s metrics and enrich them with Kubernetes metadata
- Expose those metrics on {{ site.kgo_product_name }}'s `/metrics` endpoint

## Example

This example deploys an `echo` `Service` which will have its latency measured and exposed on {{ site.kgo_product_name }}'s `/metrics` endpoint. The service allows us to run any shell command, which we'll use to add artificial latency later for testing purposes.

```yaml
echo '
apiVersion: v1
kind: Service
metadata:
  name: echo
  namespace: default
spec:
  ports:
    - protocol: TCP
      name: http
      port: 80
      targetPort: http
  selector:
    app: echo
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: echo
  name: echo
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: echo
  template:
    metadata:
      labels:
        app: echo
    spec:
      containers:
        - name: echo
          image: registry.k8s.io/e2e-test-images/agnhost:2.40
          command:
            - /agnhost
            - netexec
            - --http-port=8080
          ports:
            - containerPort: 8080
              name: http
          env:
            - name: NODE_NAME
              valueFrom:
                fieldRef:
                  fieldPath: spec.nodeName
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
            - name: POD_IP
              valueFrom:
                fieldRef:
                  fieldPath: status.podIP' | kubectl apply -f -
```

Next, create a `DataPlaneMetricsExtension` that points to the `echo` service, attach it to a `GatewayConfiguration` resource and deploy a `Gateway` with a `HTTPRoute` so that we can make a HTTP request to the service.

```yaml
echo '
kind: DataPlaneMetricsExtension
apiVersion: gateway-operator.konghq.com/v1alpha1
metadata:
  name: kong
  namespace: default
spec:
  serviceSelector:
    matchNames:
    - name: echo
  config:
    latency: true
---
kind: GatewayConfiguration
apiVersion: gateway-operator.konghq.com/v1beta1
metadata:
  name: kong
  namespace: default
spec:
  dataPlaneOptions:
    deployment:
      replicas: 1
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
            readinessProbe:
              initialDelaySeconds: 1
              periodSeconds: 1
    extensions:
    - kind: DataPlaneMetricsExtension
      group: gateway-operator.konghq.com
      name: kong
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
---
apiVersion: gateway.networking.k8s.io/{{ gatewayApiVersion }}
kind: HTTPRoute
metadata:
  name: httproute-echo
  namespace: default
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
      port: 80 ' | kubectl apply -f -
```

## Metrics support for enrichment

- upstream latency enabled via `latency` configuration option
  - `kong_upstream_latency_ms`

## Custom Metrics providers support

Metrics exposed by {{ site.kgo_product_name }}  can be integrated with a variety of monitoring systems.

Nevertheless you can follow our guides to integrate {{ site.kgo_product_name }} with:

- [Prometheus](/gateway-operator/{{ page.release }}/guides/autoscaling-workloads/prometheus/)
- [Datadog](/gateway-operator/{{ page.release }}/guides/autoscaling-workloads/datadog/)

## Limitations

### Multi backend Kong services

{{ site.kgo_product_name }} is not able to provide accurate measurements for multi backend Kong services e.g. `HTTPRoute`s that have more than 1 `backendRef`:

```yaml
apiVersion: gateway.networking.k8s.io/{{ gatewayApiVersion }}
kind: HTTPRoute
metadata:
  name: httproute-testing
spec:
  parentRefs:
  - name: kong
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /httproute-testing
    backendRefs:
    - name: httpbin
      kind: Service
      port: 80
      weight: 75
    - name: nginx
      kind: Service
      port: 8080
      weight: 25
```
