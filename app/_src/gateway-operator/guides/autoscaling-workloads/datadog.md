---
title: Horizontally autoscale workloads using Datadog
badge: enterprise
---

{{ site.kgo_product_name }} can be integrated with [Datadog Metrics][dmetrics]
in order to use {{ site.base_gateway }} latency metrics to autoscale workloads
based on their metrics.

[dmetrics]: https://docs.datadoghq.com/metrics/

## Install Datadog in your Kubernetes cluster

### Datadog API and application keys

To install Datadog agents in your cluster you will need a Datadog API key
and an application key. Please refer to [this Datadog manual page][ddkeys] to obtain those.

[ddkeys]: https://docs.datadoghq.com/account_management/api-app-keys/

### Installing

To install Datadog in your cluster, you can follow [this guide][ddk8sguide]
or use the following `values.yaml`:

```yaml
datadog:
  kubelet:
    tlsVerify: false

clusterAgent:
  enabled: true
  # Enable the metricsProvider to be able to scale based on metrics in Datadog
  metricsProvider:
    # Set this to true to enable Metrics Provider
    enabled: true
    # Enable usage of DatadogMetric CRD to autoscale on arbitrary Datadog queries
    useDatadogMetrics: true

  prometheusScrape:
    enabled: true
    serviceEndpoints: true

agents:
  containers:
    agent:
      env:
      - name: DD_HOSTNAME
        valueFrom:
          fieldRef:
            fieldPath: spec.nodeName
```

to install [Datadog's helm chart][ddchart]:

```bash
helm repo add datadog https://helm.datadoghq.com
helm repo update
helm install -n datadog datadog --set datadog.apiKey=${DD_APIKEY} --set datadog.AppKey=${DD_APPKEY} datadog/datadog
```

[ddk8sguide]: https://docs.datadoghq.com/containers/kubernetes/installation/?tab=helm
[ddchart]: https://github.com/DataDog/helm-charts/tree/main/charts/datadog

## Generate traffic against `echo` `Service`

Assuming that you have access to the deployed `Gateway` address you can try enforcing the scaling by issuing requests like so:

```bash
while curl -k "http://$(kubectl get gateway kong -o custom-columns='name:.status.addresses[0].value' --no-headers -n default)/echo/shell?cmd=sleep%200.1" ; do sleep 1; done
```

This will cause the underlying deployment to sleep for 100ms on each request and thus increase the average response time to that value.

Keep this running while we move on to next steps.

## Annotate {{ site.kgo_product_name }} with Datadog checks config

{:.note}
> **Note:** {{ site.kgo_product_name }} uses [kube-rbac-proxy][kuberbacproxy_github]
> to secure its endpoints behind an RBAC proxy. That's why we'd going to scrape `kube-rbac-proxy`
> and not the `manager` container.


For Datadog to scrape {{ site.kgo_product_name }}'s metrics we need to let it know how to do it.
This can be done through the following annotation on {{ site.kgo_product_name }}'s Pod:

```yaml
ad.datadoghq.com/kube-rbac-proxy.checks: |
  {
    "openmetrics": {
      "instances": [
        {
          "bearer_token_auth": true,
          "bearer_token_path": "/var/run/secrets/kubernetes.io/serviceaccount/token",
          "tls_verify": false,
          "tls_ignore_warning": true,
          "prometheus_url": "https://%%host%%:8443/metrics",
          "namespace": "autoscaling",
          "metrics": [
              "kong_upstream_latency_ms_bucket",
              "kong_upstream_latency_ms_sum",
              "kong_upstream_latency_ms_count",
            ],
          "send_histograms_buckets": true,
          "send_distribution_buckets": true
        }
      ]
    }
  }
```

After applying the above you should see `avg:autoscaling.kong_upstream_latency_ms{service:echo}` metrics in your Datadog Metrics explorer.

[kuberbacproxy_github]: https://github.com/brancz/kube-rbac-proxy

## Use `DatadogMetric` to configure cluster agent to expose external metric

To use an external metric in `HorizontalPodAutoscaler`, we need to configure the Datadog agent to expose it.

There are several ways to achieve this but we'll use a Kubernetes native way and
use [`DatadogMetric` CRD][ddmetricguide]:

```yaml
echo '
apiVersion: datadoghq.com/v1alpha1
kind: DatadogMetric
metadata:
  name: echo-kong-upstream-latency-avg
  namespace: default
spec:
  query: autoscaling.kong_upstream_latency_ms{service:echo} ' | kubectl apply -f -
```

When Datadog's agent calculates this metric for you, it will update its status

You can check the status of `DatadogMetric` with:

```bash
kubectl get -n default datadogmetric echo-kong-upstream-latency-avg -w
```

Which should give you something like this:

```bash
NAME                             ACTIVE   VALID   VALUE               REFERENCES         UPDATE TIME
echo-kong-upstream-latency-avg   True     True    24.46194839477539                      38s
```

If everything works correctly, in a couple of seconds you should be able to get the metric via Kubernetes External Metrics API:

```bash
kubectl get --raw "/apis/external.metrics.k8s.io/v1beta1/namespaces/default/datadogmetric@default:echo-kong-upstream-latency-avg" | jq
{
  "kind": "ExternalMetricValueList",
  "apiVersion": "external.metrics.k8s.io/v1beta1",
  "metadata": {},
  "items": [
    {
      "metricName": "datadogmetric@default:echo-kong-upstream-latency-avg",
      "metricLabels": null,
      "timestamp": "2024-03-08T18:03:02Z",
      "value": "24233138021n"
    }
  ]
}
```

[ddmetricguide]: https://docs.datadoghq.com/containers/guide/cluster_agent_autoscaling_metrics/?tab=helm#autoscaling-with-datadogmetric-queries

### Use `DatadogMetric` in `HorizontalPodAutoscaler`

When we have the metric already available in Kubernetes External API we can use it in HPA like so:

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
  - type: External
    external:
      metric:
        name: datadogmetric@default:echo-kong-upstream-latency-avg
      target:
        type: Value
        value: 40 ' | kubectl apply -f -
```

This HPA will watch for `echo-kong-upstream-latency-avg` `DatadogMetric` from `default` namespace and it will scale
`echo` `Deployment` in that namespace to aim for 40ms average response time.

When everything is configured correctly, `DatadogMetric`'s status will update and it will now have a reference to the HPA:

You can reissue:

```bash
kubectl get -n default datadogmetric echo-kong-upstream-latency-avg -w
```

Which should now show the HPA reference:

```bash
NAME                             ACTIVE   VALID   VALUE               REFERENCES         UPDATE TIME
echo-kong-upstream-latency-avg   True     True    24.46194839477539   hpa:default/echo   38s
```

If everything went well we should see the `SuccessfulRescale` events:

```bash
kubectl get events --field-selector involvedObject.name=echo --field-selector involvedObject.kind=HorizontalPodAutoscaler -w
LAST SEEN   TYPE      REASON                         OBJECT                         MESSAGE
55m         Normal    SuccessfulRescale              horizontalpodautoscaler/echo   New size: 7; reason: All metrics below target
55m         Normal    SuccessfulRescale              horizontalpodautoscaler/echo   New size: 5; reason: All metrics below target
55m         Normal    SuccessfulRescale              horizontalpodautoscaler/echo   New size: 4; reason: All metrics below target
54m         Normal    SuccessfulRescale              horizontalpodautoscaler/echo   New size: 2; reason: All metrics below target
```
