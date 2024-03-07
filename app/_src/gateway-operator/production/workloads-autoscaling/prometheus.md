---
title: Horizontally autoscale workloads using Prometheus and Prometheus adapter
badge: enterprise
---

{{ site.kgo_product_name }} can be integrated with [Prometheus](https://prometheus.io/)
and [prometheus-adapter](https://github.com/kubernetes-sigs/prometheus-adapter)
in order to use {{ site.base_gateway }} latency metrics to autoscale workloads
based on their metrics.

## Install Prometheus

{:.note}
> **Note:** You can reuse your current Prometheus setup and skip this step
> but please be aware that it needs to be able to scrape {{ site.kgo_product_name }}'s metrics
> (e.g. through [`ServiceMonitor`][service_monitor]) and note down the namespace
> in which it's deployed.

[service_monitor]: https://github.com/prometheus-operator/prometheus-operator/blob/release-0.53/Documentation/api.md#servicemonitor

1. Add `prometheus-community` helm charts:

   ```bash
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo update
   ```

1. Install Prometheus via [`kube-prometheus-stack` helm chart](https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack):

   ```bash
   helm upgrade --install --create-namespace -n prometheus prometheus prometheus-community/kube-prometheus-stack
   ```

## Apply `ServiceMonitor` to scrape {{ site.kgo_product_name }}

In order to make Prometheus scrape {{ site.kgo_product_name }}'s `/metrics` we'll need to add a `ServiceMonitor` which will
make it do so.

This can be done by using the following manifest:

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    release: prometheus
  name: gateway-operator
  namespace: kong-system
spec:
  endpoints:
  - port: https
    scheme: https
    path: /metrics
    bearerTokenFile: /var/run/secrets/kubernetes.io/serviceaccount/token
    tlsConfig:
      insecureSkipVerify: true
  selector:
    matchLabels:
      control-plane: controller-manager
```

After applying the above manifest you can check one of the metrics that's exposed by {{ site.kgo_product_name }}
to verify that the scrape config has been applied.

You should be able to access the UI using a port-forward like this:

```bash
kubectl port-forward service/prometheus-kube-prometheus-prometheus 9090:9090 -n prometheus
```

This can be verified by going to your Prometheus UI and querying e.g.:

```
up{service=~"gateway-operator-controller-manager-metrics-service"}
```

## Install `prometheus-adapter`

In order to adapt metrics from Prometheus so that they can be used by Kubernetes we'll need an adapter.
This can be done by `prometheus-adapter`.

1. In order to deploy `prometheus-adapter` you'll need to decide what time series to expose so that Kubernetes can consume it.

   {:.note}
   > **Note:** To see currently supported {{ site.base_gateway }} metrics which are exposed enriched in {{ site.kgo_product_name }}
   > please consult (/gateway-operator/{{ page.release }}//production/workloads-autoscaling/overview/#metrics-support-for-enrichment).

   In this guide we'll use `kong_upstream_latency_ms_30s_average` which will expose a 30s moving average of upstream response latency.

   To do this we'll use the following `values.yaml` to deploy [`prometheus-adapter` helm chart][prom-adapter-chart]:

   [prom-adapter-chart]: https://artifacthub.io/packages/helm/prometheus-community/prometheus-adapter

   If you're working with Prometheus deployed in a different namespace than `prometheus`, than replace it below in the `prometheus.url` value.

   ```yaml
   prometheus:
     url: http://prometheus-kube-prometheus-prometheus.prometheus.svc

   rules:
     default: false
     custom:
       
     - seriesQuery: '{__name__=~"^kong_upstream_latency_ms_(sum|count)",kubernetes_namespace!="",kubernetes_name!="",kubernetes_kind!=""}'
       resources:
         overrides:
           exported_namespace:
             resource: "namespace"
           exported_service:
             resource: "service"
       name:
         as: "kong_upstream_latency_ms_30s_average"
       metricsQuery: |
         sum by (exported_service) (rate(kong_upstream_latency_ms_sum{<<.LabelMatchers>>}[30s:5s]))
           /
         sum by (exported_service) (rate(kong_upstream_latency_ms_count{<<.LabelMatchers>>}[30s:5s]))
   ```

1. Install `prometheus-adapter` via helm chart

   ```bash
   helm upgrade --install --create-namespace -n prometheus --values values.yaml prometheus-adapter prometheus-community/prometheus-adapter
   ```

## Verify metrics are exposed in Kubernetes

When all is configured you should be able to see the metric you've configure in `prometheus-adapter` exposed via Kubernetes Custom Metrics API:

```bash
kubectl get --raw '/apis/custom.metrics.k8s.io/v1beta1/namespaces/default/services/echo/kong_upstream_latency_ms_30s_average' | jq
```

This should result in:

```json
{
  "kind": "MetricValueList",
  "apiVersion": "custom.metrics.k8s.io/v1beta1",
  "metadata": {},
  "items": [
    {
      "describedObject": {
        "kind": "Service",
        "namespace": "default",
        "name": "echo",
        "apiVersion": "/v1"
      },
      "metricName": "kong_upstream_latency_ms_30s_average",
      "timestamp": "2024-03-06T13:11:12Z",
      "value": "0",
      "selector": null
    }
  ]
}
```

## Use exposed metric in `HorizontalPodAutoscaler`

When the metric configured in `prometheus-adapter` is available through Kubernetes' Custom Metrics API
we can use it in `HorizontalPodAutoscaler` to autoscale our workload: specifically the `echo` `Service`.

This can be done by using the following manifest:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: echo
  namespace: default
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: echo
  minReplicas: 1
  maxReplicas: 10
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 1
      policies:
      - type: Percent
        value: 100
        periodSeconds: 10
    scaleUp:
      stabilizationWindowSeconds: 1
      policies:
      - type: Percent
        value: 100
        periodSeconds: 2
      - type: Pods
        value: 4
        periodSeconds: 2
      selectPolicy: Max
  metrics:
  - type: Object
    object:
      metric:
        name: "kong_upstream_latency_ms_30s_average"
      describedObject:
        apiVersion: v1
        kind: Service
        name: echo

      target:
        type: Value
        value: "40"
```

This configuration will scale the underlying `echo` `Deployment` between 1 and 10 replicas, trying to keep the average latency
across last 30s at 40ms.

You can watch those events using the following `kubectl` command:

```bash
kubectl get events -n default --field-selector involvedObject.name=echo --field-selector involvedObject.kind=HorizontalPodAutoscaler -w
```

Assuming that you have access to the deployed `Gateway` address you can try enforcing the scaling by issuing requests like so:

```bash
while curl -k "http://$(kubectl get gateway kong -o custom-columns='name:.status.addresses[0].value' --no-headers -n default)/echo/shell?cmd=sleep%200.1" ; do sleep 1; done
```

This will cause the underlying deployment to sleep for 100ms on each request and thus increase the average response time to that value.
This will in turn cause the HPA to autoscale the `Deployment`:

```bash
kubectl get events -n default --field-selector involvedObject.name=echo --field-selector involvedObject.kind=HorizontalPodAutoscaler -w
...
12m         Normal   SuccessfulRescale   horizontalpodautoscaler/echo   New size: 5; reason: Service metric kong_upstream_latency_ms_30s_average above target
12m         Normal   SuccessfulRescale   horizontalpodautoscaler/echo   New size: 10; reason: Service metric kong_upstream_latency_ms_30s_average above target
```
