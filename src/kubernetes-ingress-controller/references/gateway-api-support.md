---
title: Gateway API Support
content_type: reference
content_type: reference
---

The {{site.kic_product_name}} supports the following resources and features in the
[Gateway API](https://gateway-api.sigs.k8s.io/). By default:

- Core features are supported. If a core feature is not supported in the
  current version, it will be listed in `Unsupported Core Features`.
- Extended features are not supported. If an extended feature is supported in 
  current version, it will be listed in `Supported Extended Features`.

## Gateways and GatewayClasses

### Supported Versions
- `v1beta1`
- `v1alpha2`

## HTTPRoutes

{{site.kic_product_name}}'s implementation of `HTTPRoute` supports multiple `BackendRefs` with a 
round-robin load-balancing strategy applied by default across the 
`Endpoints` or the `Services`. `BackendRefs` weights are now supported 
to allow you to fine-tune the load-balancing between those backend 
services.

### Supported Versions
- `v1beta1`
- `v1alpha2`

### Supported Extended Features
- Supports `method` in route matches.

### Unsupported Core Features
- Does not support `queryParam` in route matches.
- Does not support `requestRedirect` in filters.

## TCPRoutes

The {{site.kic_product_name}}'s implementation of `TCPRoute` supports multiple `BackendRefs` in 
`TCPRoute` resources for load balancing.

### Supported Versions
- `v1alpha2`

## UDPRoutes

The {{site.kic_product_name}}'s implementation of `UDPRoute` supports multiple `BackendRefs` in
`UDPRoute` resources for load balancing.

### Supported Versions
- `v1alpha2`

## TLSRoutes

### Supported Versions
- `v1alpha2`

{% if_version gte:2.6.x %}
## ReferenceGrants

Kong implementation supports `ReferenceGrant` to allow routes to 
reference backends in other namespaces in `BackendRefs`.

### Supported Versions
- `v1alpha2`
{% endif_version %}

{% if_version gte:2.4.x lte:2.5.x %}
## ReferencePolicies 

The {{site.kic_product_name}}'s implementation supports using `ReferencePolicy` to allow routes to 
reference backends in other namespaces in `BackendRefs`.

### Supported Versions
- `v1alpha2`
{% endif_version %}