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

- Core features are supported. If a core feature is not supported in any
  of the released versions yet, it will be listed in `Unsupported` section.
- Extended features are not supported. If an extended feature is supported in 
  any of the released versions, it will be listed in the section of the 
  first version that support the feature.

## Gateways and GatewayClasses

### v2.2.x

- Supported `v1alpha2` version of Gateways and GatewayClasses.

### v2.5.x

- Added support for `TLSConfig` section to load certificates for HTTPRoutes and
  TLSRoutes attached to the Gateway.

### v2.6.x

- Supported `v1beta1` version of Gateways and GatewayClasses, and removed support of `v1alpha2` version of Gateways and GatewayClasses.

### Unsupported

- Gateways [are not provisioned automatically](/kubernetes-ingress-controller/{{page.release}}/concepts/gateway-api#gateway-management).
- Kong [only supports a single Gateway per GatewayClass](/kubernetes-ingress-controller/{{page.release}}/concepts/gateway-api#listener-compatibility-and-handling-multiple-gateways).

## HTTP Routes

### v2.2.x

- Supported `v1alpha2` version of HTTPRoute.
- Supported extended feature: supported `method` in route matches.

### v2.4.x

- Supported weights of `BackendRefs`. Multiple `BackendRefs` with a round-robin load-balancing strategy 
  is applied by default across the Endpoints or the Services. Configuring weights of `BackendRefs`
  can allow you to fine-tune the load-balancing between those backend services.

### v2.6.x

- Supported `v1beta1` version of HTTPRoute and removed support of `v1alpha2` version of HTTPRoute.

### Unsupported
- Does not support `queryParam` in route matches.
- Does not support `requestRedirect` in filters.
- HTTPRoutes cannot be bound to a specific port using a [ParentReference](https://gateway-api.sigs.k8s.io/references/spec/#gateway.networking.k8s.io/v1beta1.ParentReference).
  Kong serves all HTTP routes on all HTTP listeners.

## TCP Routes

### v2.4.x

- Supported `v1alpha2` of TCPRoute.
- Added support for multiple, weighted `BackendRef` entities.

## UDP Routes

### v2.4.x

- Supported `v1alpha2` of UDPRoute.
- Added support for multiple, weighted `BackendRef` entities.

### Unsupported
- Does not support [GEP-957](https://gateway-api.sigs.k8s.io/geps/gep-957/) port matching.

## TLS Routes

### v2.4.x

- Supported `v1alpha2` of TLSRoute.

## GRPC Routes

### v2.9.x

- Supported `v1alpha2` of GRPCRoute.

## Reference Grants and Reference Policies

### v2.4.x

- Supported `v1alpha2` version of ReferencePolicy to allow routes to
  reference backends in other namespaces in `BackendRefs`.

### v2.6.x

- Supported `v1alpha2` version of ReferenceGrant and removed support of ReferencePolicy.

### v2.9.x

- Supported `v1beta1` version of ReferenceGrant, and removed support of `v1alpha2` version ReferenceGrant.
