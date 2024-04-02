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
> (e.g. through [`ServiceMonitor`](https://github.com/prometheus-operator/prometheus-operator/blob/release-0.53/Documentation/api.md#servicemonitor)) and note down the namespace
> in which it's deployed.

1. Add the `prometheus-community` helm charts:

   ```bash
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo update
   ```

1. Install Prometheus via [`kube-prometheus-stack` helm chart](https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack):

   ```bash
   helm upgrade --install --create-namespace -n prometheus prometheus prometheus-community/kube-prometheus-stack
   ```

## Create a ServiceMonitor to scrape {{ site.kgo_product_name }}

To make Prometheus scrape {{ site.kgo_product_name }}'s `/metrics` endpoint, we'll need to create a `ServiceMonitor`:

```yaml
echo '
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
      control-plane: controller-manager ' | kubectl apply -f -
```

After applying the above manifest you can check one of the metrics exposed by {{ site.kgo_product_name }}
to verify that the scrape config has been applied.

To access the Prometheus UI, create a port-forward and visit <http://localhost:9090>

```bash
kubectl port-forward service/prometheus-kube-prometheus-prometheus 9090:9090 -n prometheus
```

This can be verified by going to your Prometheus UI and querying e.g.:

```
up{service=~"kgo-gateway-operator-metrics-service"}
```

{:.important}
> Prometheus metrics can take up to 2 minutes to appear

## Install prometheus-adapter

The `prometheus-adapter` package makes Prometheus metrics usable in Kubernetes.

To deploy `prometheus-adapter` you'll need to decide what time series to expose so that Kubernetes can consume it.

{:.note}
> **Note:** {{ site.kgo_product_name }} enriches specific metrics for use with `prometheus-adapter`. See the [overview](/gateway-operator/{{ page.release }}/guides/autoscaling-workloads/overview/#metrics-support-for-enrichment) for a complete list.

Create a `values.yaml` file to deploy the [`prometheus-adapter` helm chart](https://artifacthub.io/packages/helm/prometheus-community/prometheus-adapter).
This configuration calculates a `kong_upstream_latency_ms_60s_average` metric, which exposes a 60s moving average of upstream response latency:

```yaml
prometheus:
  # Update this value if Prometheus is installed in a different namespace
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
      as: "kong_upstream_latency_ms_60s_average"
    metricsQuery: |
      sum by (exported_service) (rate(kong_upstream_latency_ms_sum{<<.LabelMatchers>>}[60s:10s]))
        /
      sum by (exported_service) (rate(kong_upstream_latency_ms_count{<<.LabelMatchers>>}[60s:10s]))
```

Install `prometheus-adapter` using Helm:

```bash
helm upgrade --install --create-namespace -n prometheus --values values.yaml prometheus-adapter prometheus-community/prometheus-adapter
```

## Send traffic

To trigger autoscaling, run the following command in a new terminal window. This will cause the underlying deployment to sleep for 100ms on each request and thus increase the average response time to that value.

```bash
while curl -k "http://$(kubectl get gateway kong -o custom-columns='name:.status.addresses[0].value' --no-headers -n default)/echo/shell?cmd=sleep%200.1" ; do sleep 1; done
```

Keep this running while we move on to next steps.

## Verify metrics are exposed in Kubernetes

When all is configured you should be able to see the metric you've configured in `prometheus-adapter` exposed via the Kubernetes Custom Metrics API:

```bash
kubectl get --raw '/apis/custom.metrics.k8s.io/v1beta1/namespaces/default/services/echo/kong_upstream_latency_ms_60s_average' | jq
```

{:.note}
> **Note:** The `prometheus-adapter` may take up to 2 minutes to populate the custom metrics

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
      "metricName": "kong_upstream_latency_ms_60s_average",
      "timestamp": "2024-03-06T13:11:12Z",
      "value": "102312m",
      "selector": null
    }
  ]
}
```

{:.note}
> **Note:** `102312m` is a Kubernetes way of expressing numbers as integers.
> `value` represents the latency in microseconds, and is approximately equivalent to 102 milliseconds (ms).

## Use exposed metric in HorizontalPodAutoscaler

When the metric configured in `prometheus-adapter` is available through Kubernetes' Custom Metrics API
we can use it in `HorizontalPodAutoscaler` to autoscale our workload: specifically the `echo` `Deployment`.

This can be done by using the following manifest, which will scale the underlying `echo` `Deployment` between 1 and 10 replicas, trying to keep the average latency across last 60s at 40ms.

```yaml
echo '
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
        name: "kong_upstream_latency_ms_60s_average"
      describedObject:
        apiVersion: v1
        kind: Service
        name: echo
      target:
        type: Value
        value: "40" ' | kubectl apply -f -
```

## Observe Kubernetes `SuccessfulRescale` events

You can watch `SuccessfulRescale` events using the following `kubectl` command:

```bash
kubectl get events -n default --field-selector involvedObject.name=echo --field-selector involvedObject.kind=HorizontalPodAutoscaler -w
```

If everything went well we should see the `SuccessfulRescale` events:

```bash
12m          Normal   SuccessfulRescale   horizontalpodautoscaler/echo   New size: 2; reason: Service metric kong_upstream_latency_ms_60s_average above target
12m          Normal   SuccessfulRescale   horizontalpodautoscaler/echo   New size: 4; reason: Service metric kong_upstream_latency_ms_60s_average above target
12m          Normal   SuccessfulRescale   horizontalpodautoscaler/echo   New size: 8; reason: Service metric kong_upstream_latency_ms_60s_average above target
12m          Normal   SuccessfulRescale   horizontalpodautoscaler/echo   New size: 10; reason: Service metric kong_upstream_latency_ms_60s_average above target
```

Then when latency drops (when you stop sending traffic with the `curl` command) you should observe the `SuccessfulRescale` events scaling your workloads down:

```bash
4s          Normal   SuccessfulRescale   horizontalpodautoscaler/echo   New size: 1; reason: All metrics below target
```
