---
title: Combining Services From Different HTTPRoutes 
type: reference
purpose: |
  Introduce the feature gate to consolidate {{site.base_gateway}} services by combining rules from different HTTPRoutes
alpha: true
---

As have been done to `Ingress`es, {{site.kic_product_name}} can consolidate rules from different `HTTPRoute`s having the same
combination of backend services and translate them into one {{site.base_gateway}} service to reduce the number of {{site.base_gateway}} services.

## How to Enable the Feature?
The feature is enabled when the feature gate `CombinedServicesFromDifferentHTTPRoutes` is set to `true`.

## What Does the Feature Gate Do?
When the feature is enabled, The rules having the same combination of backend services (combination of namespace, name, port and weight in `backendRefs` of rules)
in all `HTTPRoute`s within the same namespace will be translated to one {{site.base_gateway}} service.

## How the Translation is Done?

The names of the translated {{site.base_gateway}} service will be changed when the feature is enabled. Instead of generating names from source `HTTPRoute`
and rules, the {{site.base_gateway}} service names will be generated from the consolidated backends.

### Compute Service Name

Names of {{site.base_gateway}} services will be computed from the namespace, name, port and weight(if specified). The pattern of names is
`httproute.<namespace>.svc.<backend_ns>.<backend_name>.<backend_port>.[backend_weight]_[next_backends]...` where:
 - `namespace` is the namespace of the `HTTPRoute`s.
 - `backend_ns` is the namespace of the first backend service.
 - `backend_name` is the name of the first backend service.
 - `backend_port` is the port number of the first backend service.
 - `backend_weight` is the weight of the first backend service if specified.
 - `next_backends` are sections computed from other backend services. Backend services are sorted by the namespace and name.

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

When the feature is not enabled, the rules in the two `HTTPRoutes` will be translated
to two {{site.base_gateway}} services separately.
The names of the services will be `httproute.default.httproute-consolidated-1.0` and `httproute.default.httproute-consolidated-2.0`.

When the feature is enabled, The two rules from the two `HTTPRoute`s `httproute-consolidated-1` and `httproute-consolidated-2` will be translated to one {{site.base_gateway}} service.
The translated service name will computed by the rules above, resulting to the name `httproute.default.svc.default.echo-1.80.75.default.echo-2.80.25`.

### Trimming {{site.base_gateway}} Service Names

When the computed name from the method above is longer than 512 characters(the limit of service name length in {{site.konnect_short_name}}), the service name is trimmed using the following rules:
- Trim the name to only preserve the information (`backend_ns`, `backend_name`,`backend_port`, `backend_weight`) of the first backend service,
- Append the `_combined.<hash>` to make sure that the name is unique. Where `hash` is the SHA256 digest of the computed service name.
