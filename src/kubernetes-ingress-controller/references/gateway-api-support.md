---
title: Gateway API Support
content_type: reference
alpha: false # This is the default, but is here for completeness

overrides:
  alpha:
    true:
      gte: 2.4.x
      lte: 2.5.x

---

The {{site.kic_product_name}} supports the following resources and features in the
[Gateway API](https://gateway-api.sigs.k8s.io/). By default:

- Core features are supported. If a core feature is not supported in at least one of listed versions,
  it will be listed in the `Core Feature Support` section.
- Extended features are not supported. If an extended feature is supported in at least one of listed versions, 
  it will be listed in the `Extended Feature Support` section.

## Gateways and GatewayClasses

### Supported Versions

| {{site.kic_product_name}} | 2.2.x                       | 2.3.x                       | 2.4.x                       | 2.5.x                       | 2.6.x                       | 2.7.x                       |
|:--------------------------|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|
| `v1beta1`                 | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| `v1alpha2`                | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> |

## HTTP Routes

{{site.kic_product_name}}'s implementation of `HTTPRoute` supports multiple `BackendRefs` with a
round-robin load-balancing strategy applied by default across the
`Endpoints` or the `Services`. `BackendRefs` weights are now supported
to allow you to fine-tune the load-balancing between those backend services.

### Supported Versions

| {{site.kic_product_name}} | 2.2.x                       | 2.3.x                       | 2.4.x                       | 2.5.x                       | 2.6.x                       | 2.7.x                       |
|:--------------------------|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|
| `v1beta1`                 | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| `v1alpha2`                | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> |


### Core Feature Support

Core features not listed here are supported by all listed versions of {{site.kic_product_name}}.

| {{site.kic_product_name}}     | 2.2.x                       | 2.3.x                       | 2.4.x                       | 2.5.x                       | 2.6.x                       | 2.7.x                       |
|:------------------------------|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|
| `queryParam` in route matches | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> |
| `requestRedirect` in filters  | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> |


### Extended Feature Support

Extended features not listed here are not supported by any of listed versions of {{site.kic_product_name}}.

| {{site.kic_product_name}} | 2.2.x                       | 2.3.x                       | 2.4.x                       | 2.5.x                       | 2.6.x                       | 2.7.x                       |
|:--------------------------|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|
| `method` in route matches | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |

## TCP Routes

The {{site.kic_product_name}}'s implementation of `TCPRoute` supports multiple `BackendRefs` in
`TCPRoute` resources for load balancing.

### Supported Versions

| {{site.kic_product_name}} | 2.4.x                       | 2.5.x                       | 2.6.x                       | 2.7.x                       |
|:--------------------------|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|
| `v1alpha2`                | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |

## UDP Routes

The {{site.kic_product_name}}'s implementation of `UDPRoute` supports multiple `BackendRefs` in
`UDPRoute` resources for load balancing.

### Supported Versions

| {{site.kic_product_name}} | 2.4.x                       | 2.5.x                       | 2.6.x                       | 2.7.x                       |
|:--------------------------|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|
| `v1alpha2`                | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |


## TLS Routes

### Supported Versions

| {{site.kic_product_name}} | 2.4.x                       | 2.5.x                       | 2.6.x                       | 2.7.x                       |
|:--------------------------|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|
| `v1alpha2`                | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |


## Reference Grants & Reference Policies

The {{site.kic_product_name}}'s implementation supports using `ReferenceGrant` or `ReferencePolicy` 
to allow routes to reference backends in other namespaces in `BackendRefs`.


### Supported Versions

| {{site.kic_product_name}}    | 2.4.x                       | 2.5.x                       | 2.6.x                       | 2.7.x                       |
|:-----------------------------|:---------------------------:|:---------------------------:|:---------------------------:|:---------------------------:|
| `ReferenceGrant` `v1alpha2`  | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | 
| `ReferencePolicy` `v1alpha2` | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | 


