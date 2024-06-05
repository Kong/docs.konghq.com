---
title: Kubernetes Events
type: explanation
purpose: |
  What are events? What events are available? How can they trigger alerts?
---

{{ site.kic_product_name }} provides Kubernetes Events to help understand the state of your system. Events occur when an invalid configuration is rejected by {{ site.base_gateway }} (`KongConfigurationApplyFailed`) or when an invalid configuration such as an upstream service that does not exist is detected (`KongConfigurationTranslationFailed`).

{:.note}
> The Events are not cleared immediately after you resolve the issues. However, the Event `count` stops increasing after you fix the problem. Events do eventually expire after an hour, by default, but may be outdated. 

## Emitted Events

All the events that are emitted by {{site.kic_product_name}} are listed in the table below.

| Reason                                       | Type       | Meaning                                                                                                                                                                                  | Involved objects                                                                                                                                                                                                                                            |
|----------------------------------------------|------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `KongConfigurationTranslationFailed`         | ⚠️ Warning | During the translation of Kubernetes resources into a Kong state, a conflict was detected. The involved object(s) were skipped to unblock building the Kong state without them.          | Any of the supported resources (e.g. `Ingress`, `KongPlugin`, `HTTPRoute`, etc.)                                                                                                                                                                            |
| `KongConfigurationApplyFailed`               | ⚠️ Warning | A Kong state built from Kubernetes resources was rejected by the {{site.base_gateway}} Admin API. The update of the configuration was not effective.                                     | In the case of a failure caused by a specific object - any of the supported resources (e.g. `Ingress`, `KongPlugin`, `HTTPRoute`, etc.). When a specific causing object couldn't be identified, the event is attached to the {{site.kic_product_name}} Pod. |
| `KongConfigurationSucceeded`                 | ℹ️ Normal  | A Kong state built from Kubernetes resources was successfully applied to the {{site.base_gateway}} Admin API.                                                                            | {{site.kic_product_name}} Pod.                                                                                                                                                                                                                              |
{% if_version gte:3.2.x %}
| `FallbackKongConfigurationTranslationFailed` | ⚠️ Warning | During the translation of fallback Kubernetes resources into a Kong state, a conflict was detected. The involved object(s) were skipped to unblock building the Kong state without them. | Any of the supported resources (e.g. `Ingress`, `KongPlugin`, `HTTPRoute`, etc.)                                                                                                                                                                            |
| `FallbackKongConfigurationApplyFailed`       | ⚠️ Warning | A fallback Kong state built from Kubernetes resources was rejected by the {{site.base_gateway}} Admin API. The update of the configuration was not effective.                            | In the case of a failure caused by a specific object - any of the supported resources (e.g. `Ingress`, `KongPlugin`, `HTTPRoute`, etc.). When a specific causing object couldn't be identified, the event is attached to the {{site.kic_product_name}} Pod. |
| `FallbackKongConfigurationSucceeded`         | ℹ️ Normal  | A fallback Kong state built from Kubernetes resources was successfully applied to the {{site.base_gateway}} Admin API.                                                                   | {{site.kic_product_name}} Pod.                                                                                                                                                                                                                              |
{% endif_version %}

### Finding problem resource Events

Once you see a translation or configuration push failure, you can
locate which Kubernetes resources require changes by searching for Events. For
example, this Ingress attempts to create a gRPC route that also uses HTTP
methods, which is impossible:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    konghq.com/methods: GET
    konghq.com/protocols: grpcs
    kubernetes.io/ingress.class: kong
  name: httpbin
spec:
  rules:
  - http:
      paths:
      - backend:
          service:
            name: httpbin
            port:
              number: 80
        path: /bar
        pathType: Prefix
```

{{site.base_gateway}} rejects the route that {{site.kic_product_name}} creates
from this Ingress and return an error. {{site.kic_product_name}} processes
this error and create a Kubernetes Event linked to the Ingress.

You can find these Events by searching across all namespaces for Events
with the reason that indicate {{site.kic_product_name}} failures:

```bash
kubectl get events -A --field-selector='reason=KongConfigurationApplyFailed'
```

The results should look like this:

```
NAMESPACE   LAST SEEN   TYPE      REASON                         OBJECT            MESSAGE
default     35m         Warning   KongConfigurationApplyFailed   ingress/httpbin   invalid methods: cannot set 'methods' when 'protocols' is 'grpc' or 'grpcs'
```

The controller can also create Events with the reason
`KongConfigurationTranslationFailed` when it detects issues before sending
configuration to Kong.

The complete Event contains additional information about the problem resource,
the number of times the problem occurred, and when it occurred:

```yaml
apiVersion: v1
kind: Event
count: 1
firstTimestamp: "2023-02-21T22:42:48Z"
involvedObject:
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  name: httpbin
  namespace: default
kind: Event
lastTimestamp: "2023-02-21T22:42:48Z"
message: 'invalid methods: cannot set ''methods'' when ''protocols'' is ''grpc''
  or ''grpcs'''
metadata:
  name: httpbin.1745f83aefeb8dde
  namespace: default
reason: KongConfigurationApplyFailed
reportingComponent: ""
reportingInstance: ""
source:
  component: kong-client
type: Warning
```

{{site.kic_product_name}} creates one Event for each problem with a
resource, so you may see multiple Events for a single resource with different
messages. The message describes the reason the resource is invalid. In this
case, it's because gRPC routes cannot use HTTP methods.

### Events for cluster scoped resources

Kubernetes events are namespaced and created in the same namespace as the involved object.
Cluster scoped objects are handled differently because they aren't assigned to a particular namespace.

`kubectl` and Kubernetes libraries, like `client-go`, assign the `default` namespace to
events that involve cluster scoped resources.

For example, if you defined the following `KongClusterPlugin`, which has an incorrect schema:

```yaml
apiVersion: configuration.konghq.com/v1
kind: KongClusterPlugin
config:
  config:
    latency_metrics: true
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  labels:
    global: "true"
  name: prometheus
plugin: prometheus
```

You can find the relevant event in the `default` namespace using the following `kubectl` command:

```bash
kubectl get events --field-selector involvedObject.name=prometheus -n default
```

This could output the following:

```bash
LAST SEEN   TYPE      REASON                         OBJECT                         MESSAGE
2s          Warning   KongConfigurationApplyFailed   kongclusterplugin/prometheus   invalid config.config: unknown field
```
