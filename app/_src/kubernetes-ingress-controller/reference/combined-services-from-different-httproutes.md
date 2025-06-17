---
title: Combining Services From Different HTTPRoutes 
type: reference
purpose: |
  Introduce the feature gate to consolidate {{site.base_gateway}} services by combining rules from different HTTPRoutes
---

Similar to the consolidation behavior implemented for `Ingress` resources, {{ site.kic_product_name }} now supports the consolidation of rules from different `HTTPRoute` resources. When multiple `HTTPRoute`s specify the same combination of backend services, they will be translated into a single {{ site.base_gateway }} service, effectively reducing the total number of {{ site.base_gateway }} services required.

## How to Enable the Feature?
The feature is enabled when the feature gate `CombinedServicesFromDifferentHTTPRoutes` is set to `true`. You can refer to the [feature gate reference](/kubernetes-ingress-controller/{{page.release}}/reference/feature-gates) to know more about the feature gates.

## What Does the Feature Gate Do?
When the feature is enabled, The rules having the same combination of backend services (combination of namespace, name, port and weight in `backendRefs` of rules)
in all `HTTPRoute`s within the same namespace will be translated to one {{site.base_gateway}} service.

## How is the Translation Done?

The names of the translated {{site.base_gateway}} service will be changed when the feature is enabled. Instead of generating names from source `HTTPRoute`
and rules, the {{site.base_gateway}} service names will be generated from the consolidated backends.

### Compute Service Name

Names of {{site.base_gateway}} services are computed from the namespace, name, port and weight(if specified). The pattern of names is
`httproute.<namespace>.svc.<backend_ns>.<backend_name>.<backend_port>.[backend_weight]_[next_backends]...` where:
 - `namespace` is the namespace of the `HTTPRoute`s.
 - `backend_ns` is the namespace of the first backend service.
 - `backend_name` is the name of the first backend service.
 - `backend_port` is the port number of the first backend service.
 - `backend_weight` is the weight of the first backend service if specified.
 - `next_backends` are sections computed from other backend services. Backend services are sorted by the namespace and name.

 In addition, When the computed name from the method above is longer than 512 characters (the limit of service name length in {{site.konnect_short_name}}), the service name is trimmed using the following rules:
- Only use `backend_ns`, `backend_name`,`backend_port`, `backend_weight`,
- Append the `_combined.<hash>` to make sure that the name is unique. Where `hash` is the SHA256 digest of the computed service name.

For example, the following two `HTTPRoute`s with rules pointing to the same backends with the same ports and weights:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: httproute-consolidated-1
  namespace: default
spec:
  parentRefs:
  - name: kong
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /httproute-testing
    backendRefs:
    - name: echo-1
      kind: Service
      port: 80
      weight: 75
    - name: echo-2
      kind: Service
      port: 8080
      weight: 25
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: httproute-consolidated-2
  namespace: default
spec:
  parentRefs:
  - name: kong
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /httproute-testing
    backendRefs:
    - name: echo-1
      kind: Service
      port: 80
      weight: 75
    - name: echo-2
      kind: Service
      port: 8080
      weight: 25
```

When the feature is disabled (which is default), the rules in the two `HTTPRoutes` are translated to two distinct {{site.base_gateway}} services:
`httproute.default.httproute-consolidated-1.0` and `httproute.default.httproute-consolidated-2.0`.

When the feature is enabled, The two rules from the two `HTTPRoute`s `httproute-consolidated-1` and `httproute-consolidated-2` result in a single {{site.base_gateway}} service named `httproute.default.svc.default.echo-1.80.75.default.echo-2.80.25`.
