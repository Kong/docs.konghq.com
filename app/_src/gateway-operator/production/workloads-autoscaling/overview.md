---
title: Horizontally autoscale workloads
badge: enterprise
---

{{ site.kgo_product_name }} can scrape {{ site.base_gateway }} and enrich it with Kubernetes metadata so that it can be used by users to autoscale their workloads.

This guide shows how to autoscale your workloads based on their response time.

{:.note}
> **Note:** In order to leverage workloads autoscaling you'll need to install
> {{ site.kgo_product_name }} with {{site.kic_product_name}} using
> [installation steps from this guide](/gateway-operator/{{ page.release }}/get-started/kic/install/).

{:.note}
> **Note:** This is an enterprise feature. In order to use it you'll need a license
> installed in your cluster so that {{ site.kgo_product_name }} can consume it.

## Overview

Through the usage of [`DataPlaneMetricsExtension`](/gateway-operator/{{ page.release }}/reference/custom-resources/#dataplanemetricsextension)
on [`ControlPlane`s](/gateway-operator/{{ page.release }}/reference/custom-resources/#controlplane),
users can enable Kong metrics scraping and enrichment for the purposes of workloads autoscaling using Kubernetes native mechanism like [`HorizontalPodAutoscaler`][hpa].

[hpa]: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/

Applying `DataPlaneMetricsExtension` and attaching it to a `ControlPlane` will:

- Create a managed Prometheus `KongPlugin` instance with the [configuration](/hub/kong-inc/prometheus/configuration/)
  as defined in [`MetricsConfig`](/gateway-operator/{{ page.release }}/reference/custom-resources/#metricsconfig)
- Annotate the selected `Service`s (through `DataPlaneMetricsExtension`'s [`serviceSelector`](/gateway-operator/{{ page.release }}/reference/custom-resources/#serviceselector) field)
  with `konghq.com/plugins` annotation which will point to the managed `KongPlugin` instance.
  This takes into account already existing annotations, so it there are already plugins configured on that `Service`
  the new plugin name will be appended.
- Start the process of scraping {{ site.base_gateway }}'s metrics and enriching them with Kubernetes metadata
- Expose those metrics in {{ site.kgo_product_name }}'s `/metrics`

### Example

Below attached manifest shows a complete working example which

- Deploys `DataPlaneMetricsExtension` which will be used in
  [`GatewayConfiguration`](/gateway-operator/{{ page.release }}/reference/custom-resources/#gatewayconfiguration)
  to customize the `ControlPlane`
- Deploys a Gateway API `Gateway` using the aforementioned `GatewayConfiguration`
- Deploys an `echo` `Service` which will have its latency measured and exposed in
  {{ site.kgo_product_name }}'s `/metrics`

```yaml
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
                  fieldPath: status.podIP
---
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
        metadata:
          labels:
            dataplane-pod-label: example
          annotations:
            dataplane-pod-annotation: example
        spec:
          containers:
          - name: proxy
            image: kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}
            env:
            - name: KONG_LOG_LEVEL
              value: debug
            readinessProbe:
              initialDelaySeconds: 1
              periodSeconds: 1
    network:
      services:
        ingress:
          annotations:
            foo: bar
  controlPlaneOptions:
    deployment:
      podTemplateSpec:
        metadata:
          labels:
            controlplane-pod-label: example
        spec:
          containers:
          - name: controller
            env:
            - name: CONTROLLER_LOG_LEVEL
              value: debug
            readinessProbe:
              initialDelaySeconds: 1
              periodSeconds: 1
    extensions:
    - kind: DataPlaneMetricsExtension
      group: gateway-operator.konghq.com
      name: kong
---
kind: GatewayClass
apiVersion: gateway.networking.k8s.io/v1
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
apiVersion: gateway.networking.k8s.io/v1
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
apiVersion: gateway.networking.k8s.io/v1
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
      port: 80
```

## Metrics support for enrichment

- upstream latency enabled via `latency` configuration option
  - `kong_upstream_latency_ms`

## Custom Metrics providers support

Metrics exposed by {{ site.kgo_product_name }} are not specific to any monitoring solution and can be integrated
with a variety of monitoring systems out there.

Nevertheless you can follow our guides to integrate {{ site.kgo_product_name }} with:

- Prometheus or
- Datadog

### Prometheus

To use Prometheus and `prometheus-adapter` please follow [this guide](./../prometheus/)

### Datadog

To use Datadog please follow [this guide](./../datadog/)
