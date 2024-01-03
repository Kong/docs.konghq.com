---
title: Horizontally autoscale a Data Plane
content-type: tutorial
book: kgo-konnect-get-started
chapter: 4
---

{% if_version gte:1.2.0 %}

{{ site.kgo_product_name }} can deploy data planes that will horizontally autoscale based on user defined criteria.

If you'd like to configure your data planes based on their average CPU utilization, this is how you can do it.

## Before we begin

In order to perform horizontal autoscaling of data planes, underneath,
{{ site.kgo_product_name }} uses Kubernetes [`HorizontalPodAutoscaler`][hpa].

{:.note}
> In order to be able to use `HorizontalPodAutoscaler` in your clusters you'll need to have a [metrics server][metrics_server_github] installed.
> More info on the metrics server can be found in [official Kubernetes docs][metrics_server].

[metrics_server]: https://kubernetes.io/docs/tasks/debug/debug-cluster/resource-metrics-pipeline/#metrics-server
[metrics_server_github]: https://github.com/kubernetes-sigs/metrics-server
[hpa]: https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/

## Create a `DataPlane` with horizontal autoscaling enabled

In order to enable horizontal autoscaling for your `DataPlane` you have to specify
the `spec.deployment.scaling` section to indicate which metrics should be used
for decision making.

In the example below we'll be using CPU utilization:

```yaml
apiVersion: gateway-operator.konghq.com/v1beta1
kind: DataPlane
metadata:
  name: horizontal-autoscaling
spec:
  deployment:
    scaling:
      horizontal:
        minReplicas: 2
        maxReplicas: 10
        metrics:
        - type: Resource
          resource:
            name: cpu
            target:
              type: Utilization
              averageUtilization: 50
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
              periodSeconds: 10
            - type: Pods
              value: 5
              periodSeconds: 10
            selectPolicy: Max
    podTemplateSpec:
      spec:
        containers:
        - name: proxy
          image: kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}
          resources:
            requests:
              memory: "64Mi"
              cpu: "250m"
            limits:
              memory: "1024Mi"
              cpu: "1000m"
          # Konnect related environment variables, volumes etc...
```

> TODO: add CRD reference section link when [KGO#1281][autoscaling_pr] is merged
> and CRD reference docs are updated ( in reference/custom-resources/1.2.x.md which is yet to be created).

[autoscaling_pr]: https://github.com/Kong/gateway-operator/pull/1281

When the manifest above is applied you should be able to observe a `DataPlane` resource being created,
which will in turn trigger the creation of 2 `Pod`s, running {{site.base_gateway}} (initially)
as well as a `HorizontalPodAutoscaler` which will try to keep the replica count
of those `Pod`s to ensure that the average CPU utilization is around 50.

```bash
$ kubectl get hpa
NAME                     REFERENCE                                           TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
horizontal-autoscaling   Deployment/dataplane-horizontal-autoscaling-4q72p   2%/50%    2         10        2          30s
```

## Test autoscaling with a load test

You can test if the autoscaling works by using one of the tools for load testing, e.g. k6s.

First we'll need the address at which the data plane can be reached:

```
export PROXY_IP=$(kubectl get dataplanes.gateway-operator.konghq.com -o jsonpath='{.status.addresses[0].value}' horizontal-autoscaling)
```

Here's an exemplar config file which you can use to start a load test with [`k6s`][k6s]:

[k6s]: https://k6.io/

```bash
$ cat k6s.js
import http from "k6/http";
import { check } from "k6";

export const options = {
  insecureSkipTLSVerify: true,
  stages: [
    { duration: "120s", target: 5 },
  ],
};

// Simulated user behavior
export default function () {
  let res = http.get(`https://${__ENV.PROXY_IP}`);
  check(res, { "status was 404": (r) => r.status == 404 });
}
```

Now, to start the test simply run:

```
$ k6 run k6.js
```

While the test is running and load is applied to the data plane you can observe the scaling events in the cluster:

```bash
$ kubectl get events --field-selector involvedObject.name=horizontal-autoscaling --field-selector involvedObject.kind=HorizontalPodAutoscaler
LAST SEEN   TYPE      REASON                         OBJECT                                           MESSAGE
3m55s       Normal    SuccessfulRescale              horizontalpodautoscaler/horizontal-autoscaling   New size: 6; reason: cpu resource utilization (percentage of request) above target
3m25s       Normal    SuccessfulRescale              horizontalpodautoscaler/horizontal-autoscaling   New size: 7; reason: cpu resource utilization (percentage of request) above target
2m55s       Normal    SuccessfulRescale              horizontalpodautoscaler/horizontal-autoscaling   New size: 10; reason: cpu resource utilization (percentage of request) above target
85s         Normal    SuccessfulRescale              horizontalpodautoscaler/horizontal-autoscaling   New size: 2; reason: All metrics below target
```

{% endif_version %}
