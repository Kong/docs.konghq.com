---
title: Using Expression Based Router
alpha: true
---

This page introduces how could {{site.kic_product_name}} use expression router, and its supported 
features and limitations in current version.

[Expression based router](gateway-expression-router) is introduced in {{site.base_gateway}} 3.0 and
later. Compared to the traditional router, expression router have higher performance and allows more
precise priority specification. 

{{site.kic_product_name}} supports expression based router in exprerimental maturity since 2.10. By 
using expression based router, {{site.kic_product_name}} can reduce most of generated routes with 
regular expression match on path, thus improve the performance of the router. 

## Deployment

To use KIC with Kong running expression router, you need {{site.kic_product_name}} with version 2.10
or higher, and {{site.base_gateway}} with version 3.0 or higher. We need to configure environment 
variables in container of {{site.kic_product_name}} and {{site.base_gateway}} to enable expression 
router:

For {{site.kic_product_name}}, we need to enable `ExpressionRoutes` feature gate and `CombinedRoutes`
feature gate to enable {{site.kic_product_name}} to translate kubernetes resources to expression based
Kong routes. (`CombinedRoutes` is enabled by default) For {{site.base_gateway}}, we need to configure 
`KONG_ROUTER_FLAVOR` to `expressions` to use expression based router of {{site.base_gateway}}.

You could use the following `values.yaml` to install {{site.kic_product_name}} using expression router
by helm:

```yaml
image:
  repository: kong
  tag: "3.3" # 3.0 and newer

env:
  database: "off"
  router_flavor: "expressions" # set KONG_ROUTER_FLAVOR to "expressions"

ingressController:
  enabled: true
  image:
    repository: kong/kubernetes-ingress-controller
    tag: "2.10" # 2.10 and newer
  env:
    feature_gates: "ExpressionRoutes=true" # enable "ExpressionRoutes" feature gate
```

then use helm to install kong :

```bash
  helm upgrade --install controller kong/kong -n kong --create-namespace -f values.yaml
```

## Supported Resources

Currently {{site.kic_product_name}} supports the following kubernetes resources when translating to
expression based routes is enabled:

- `Ingress` [networking.k8s.io/v1.Ingress](ingress)
- `HTTPRoute` in gateway APIs ([gateway.networking.k8s.io/v1beta1.HTTPRoute](gateway-api-httproute))
- `GRPCRoute` in gateway APIs ([gateway.networking.k8s.io/v1alpha2.GRPCRoute](gateway-api-grpcroute))

## Limitations and Unsupported Features

In the current versions of {{site.kic_product_name}} and {{site.base_gateway}}, some features and
kubernetes resources supported with traditional routers are not supported if expression router is
enabled.

### Unsupported Kubernetes Resources

The following kubernetes resources are not supported when expression router is enabled:

- `knative.Service` ([serving.knative.dev/v1.Service](knative-service))
- `TCPIngress` ([configuration.konghq.com/v1beta1.TCPIngress](crd-tcpingress))
- `UDPIngress` ([configuration.konghq.com/v1beta1/UDPIngress](crd-udpingress))
- `TCPRoute` ([gateway.networking.k8s.io/v1alpha2.TCPRoute](gateway-api-tcproute))
- `TLSRoute` ([gateway.networking.k8s.io/v1alpha2.TLSRoute](gateway-api-tlsroute))
- `UDPRoute` ([gateway.networking.k8s.io/v1alpha2.UDPRoute](gateway-api-udproute))

### Unsupport Methods of Overriding Routes

Because kubernetes objects could not fully express specification of Kong configurations, {{site.kic_product_name}}
provides methods to override services, routes, plugins, consumers and other objects in Kong configurations
after translating from kubernetes objects. The methods include overriding by `KongIngress` resource and annotations
of resources. When expression router is enabled, some of the methods of overriding routes in kong configurations 
after translating are not supported.

Overriding routes in kong configurations by `KongIngress` is not supported when expression routes is enabled. The 
`route` fields of `KongIngress` resources will be ignored when {{site.kic_product_name}} translate kubernetes resources
to expression based routes.

Overriding `Ingress` with annotations `konghq.com/path_handling` and `konghq.com/regex_priority` is not supported because
the `path_handling` and `regex_priority` fields are not supported in routes of kong configurations when {{site.base_gateway}}
is running expression based router.

For `HTTPRoute` and `GRPCRoute`, annotations `konghq.com/path_handling` and `konghq.com/regex_priority` are not supported
for the same reason. Besides this, annotations `konghq.com/host_aliases`, `konghq.com/methods` and `konghq.com/headers` to
override hosts, methods and headers are not supported.

### Other Unsupported Features and Breaking Changes

- HTTPS redirect is not supported by expression router of {{site.base_gateway}} yet. 
- Current translator assigns the same priority to all translated routes, so the chosen route when multiple routes matches
  the request may be different with the result in using traditional router.
- The standard of regular expressions changed to regex in rust in expression based router instead of PCRE2 in the traditional
  router, so previously valid regex may become invalid if changed to expression based router. For example, non-escape
  character after `\` like `\/`, `\j` becomes invalid in regex of expression based router.

[gateway-expression-router]:/gateway/latest/key-concepts/routes/expressions/
[ingress]:https://kubernetes.io/docs/concepts/services-networking/ingress/
[gateway-api-httproute]:https://gateway-api.sigs.k8s.io/api-types/httproute/
[gateway-api-grpcroute]:https://gateway-api.sigs.k8s.io/api-types/grpcroute/
[gateway-api-tcproute]:https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1alpha2.TCPRoute
[gateway-api-tlsroute]:https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1alpha2.TLSRoute
[gateway-api-udproute]:https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1alpha2.UDPRoute
[crd-tcpingress]:/kubernetes-ingress-controller/{{page.version}}/refereces/custom-resources/#tcpingress
[crd-tcpingress]:/kubernetes-ingress-controller/{{page.version}}/refereces/custom-resources/#udpingress
[knative-service]:https://knative.dev/docs/serving/reference/serving-api/#serving.knative.dev/v1.Service
