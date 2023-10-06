---
title: Using Expression Based Router
alpha: true
---

The [expression-based routers][gateway-expression-router], introduced in {{site.base_gateway}} 3.0, have higher performance and allow more precise priority specification than the traditional router. By using the expression-based router, {{site.kic_product_name}} can reduce most of generated routes with regular expression match on path, and therefore improve the performance of the router. 

This page explains how {{site.kic_product_name}} can use the expression-based router, and the supported features and limitations of the current version.

## Install {{site.kic_product_name}} with a {{site.base_gateway}} expression-based router

To install {{site.kic_product_name}} with a {{site.base_gateway}} expression-based router, you must configure environment variables in the container of {{site.kic_product_name}} and {{site.base_gateway}}.

### Prerequistes

* {{site.kic_product_name}} 2.10.x or later
* {{site.base_gateway}} 3.0.x or later

### Instructions

For {{site.kic_product_name}}, you must enable `ExpressionRoutes` and `CombinedRoutes` (enabled by default) so {{site.kic_product_name}} can translate Kubernetes resources to expression-based
{{site.base_gateway}} routes. For {{site.base_gateway}}, you must configure `KONG_ROUTER_FLAVOR` for `expressions` to use expression-based router.

You can use the following `values.yaml` to install {{site.kic_product_name}} using the expression-based router by helm:

```yaml
image:
  repository: kong
  tag: "3.3" # 3.0 or later

env:
  database: "off"
  router_flavor: "expressions" # sets KONG_ROUTER_FLAVOR to "expressions"

ingressController:
  enabled: true
  image:
    repository: kong/kubernetes-ingress-controller
    tag: "2.10" # 2.10 or later
  env:
    feature_gates: "ExpressionRoutes=true" # enables the "ExpressionRoutes" feature gate
```

Then, use Helm to install {{site.base_gateway}}:

```bash
  helm upgrade --install controller kong/kong -n kong --create-namespace -f values.yaml
```

## Kubernetes resource support

The following table displays which Kubernetes resources are supported when translating to expression-based routes is enabled in {{site.kic_product_name}}:

| Kubernetes resource | Supported? |
| ------------------- | ---------- |
| [`Ingress`][ingress] | ✅ &nbsp; |
| [`HTTPRoute`][gateway-api-httproute] | ✅ &nbsp; |
| [`GRPCRoute` in gateway APIs][gateway-api-grpcroute] | ✅ &nbsp; |
| [`knative.Service`][knative-service] | ❌ &nbsp; |
| [`TCPIngress`][crd-tcpingress] | ❌ &nbsp; |
| [`UDPIngress`][crd-udpingress] | ❌ &nbsp; |
| [`TCPRoute`][gateway-api-tcproute] | ❌ &nbsp; |
| [`TLSRoute`][gateway-api-tlsroute] | ❌ &nbsp; |
| [`UDPRoute`][gateway-api-udproute] | ❌ &nbsp; |

## Unsupported methods of overriding routes

Because Kubernetes objects can't fully express {{site.base_gateway}} configuration specifications, {{site.kic_product_name}} provides methods to override services, routes, plugins, consumers, and other objects in {{site.base_gateway}} configurations after translating from Kubernetes objects. These methods include overriding using the `KongIngress` resource and annotations
of resources. When the expression-based router is enabled, some of the methods of overriding routes in {{site.base_gateway}} configurations after translating are not supported:

* Overriding routes in {{site.base_gateway}} configurations using `KongIngress` isn't supported when expression routes is enabled. The `route` fields of `KongIngress` resources will be ignored when {{site.kic_product_name}} translates Kubernetes resources to expression based routes.
* You can't override `Ingress` with the `konghq.com/path_handling` and `konghq.com/regex_priority` annotations because the `path_handling` and `regex_priority` fields are not supported in {{site.base_gateway}} route configurations when {{site.base_gateway}} is running the `expressions` router.
* For `HTTPRoute` and `GRPCRoute`, the `konghq.com/path_handling` and `konghq.com/regex_priority` annotations aren't supported for the same reason. Besides this, the `konghq.com/host_aliases`, `konghq.com/methods`, and `konghq.com/headers` annotations can't be used to override hosts, methods, and headers.

### Other unsupported features and breaking changes

- HTTPS redirect isn't supported by the {{site.base_gateway}} expression-based router yet. 
- The current translator assigns the same priority to all translated routes. When there are multiple route that match the request, the chosen route may be different than if you were using a traditional router.
- The standard of regular expressions changed to regex in Rust for the expression-based router (instead of PCRE2 in the traditional
  router), so previously valid regex may become invalid if you enable the expression-based router. For example, a non-escape character after `\` like `\/`, `\j` becomes invalid in the regex of the expression-based router.

[gateway-expression-router]:/gateway/latest/key-concepts/routes/expressions/
[ingress]:https://kubernetes.io/docs/concepts/services-networking/ingress/
[gateway-api-httproute]:https://gateway-api.sigs.k8s.io/api-types/httproute/
[gateway-api-grpcroute]:https://gateway-api.sigs.k8s.io/api-types/grpcroute/
[gateway-api-tcproute]:https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1alpha2.TCPRoute
[gateway-api-tlsroute]:https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1alpha2.TLSRoute
[gateway-api-udproute]:https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1alpha2.UDPRoute
[crd-tcpingress]:/kubernetes-ingress-controller/{{page.release}}/references/custom-resources/#tcpingress/kubernetes-ingress-controller/latest/references/custom-resources/#tcpingress
[crd-udpingress]:/kubernetes-ingress-controller/{{page.release}}/references/custom-resources/#udpingress
[knative-service]:https://knative.dev/docs/serving/reference/serving-api/#serving.knative.dev/v1.Service
