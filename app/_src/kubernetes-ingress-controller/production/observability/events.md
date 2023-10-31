---
title: Kubernetes Events
type: explanation
purpose: |
  What are events? What events are available? How can they trigger alerts?
---

{{ site.kic_product_name }} provides Kubernetes Events to help understand the state of your system. Events are emitted when an invalid configuration is rejected by {{ site.base_gateway }} (`KongConfigurationApplyFailed`) and when an invalid configuration is detected e.g. the upstream service does not exist (`KongConfigurationTranslationFailed`).

{:.note}
> Resolving issues doesn't immediately clear the Events. Events do eventually
> expire (after an hour, by default), but may be outdated. The Event `count`
> will stop increasing after the problem is fixed.

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

{{site.base_gateway}} will reject the route {{site.kic_product_name}} creates
from this Ingress and return an error. {{site.kic_product_name}} will process
this error and create a Kubernetes Event linked to the Ingress.

You can quickly find these Events by searching across all namespaces for Events
with the special failure reasons that indicate {{site.kic_product_name}}
failures:

```bash
kubectl get events -A --field-selector='reason=KongConfigurationApplyFailed'
```

Response:

```
NAMESPACE   LAST SEEN   TYPE      REASON                         OBJECT            MESSAGE
default     35m         Warning   KongConfigurationApplyFailed   ingress/httpbin   invalid methods: cannot set 'methods' when 'protocols' is 'grpc' or 'grpcs'
```

The controller can also create Events with the reason
`KongConfigurationTranslationFailed` when it catches issues before sending
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

{{site.kic_product_name}} creates one Event for every individual problem with a
resource, so you may see multiple Events for a single resource with different
messages. The message describes the reason the resource is invalid. In this
case, it's because gRPC routes cannot use HTTP methods.