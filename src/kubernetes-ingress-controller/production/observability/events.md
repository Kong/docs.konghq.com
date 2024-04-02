---
title: Kubernetes Events
type: explanation
purpose: |
  What are events? What events are available? How can they trigger alerts?
---

{{ site.kic_product_name }} provides Kubernetes Events to help understand the state of your system. Events occur when an invalid configuration is rejected by {{ site.base_gateway }} (`KongConfigurationApplyFailed`) or when an invalid configuration such as an upstream service that does not exist is detected (`KongConfigurationTranslationFailed`).

{:.note}
> The Events are not cleared immediately after you resolve the issues. However, the Event `count` stops increasing after you fix the problem. Events do eventually expire after an hour, by default, but may be outdated. 

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