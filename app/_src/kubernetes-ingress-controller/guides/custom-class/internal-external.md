---
title: Using Custom Classes to split Internal/External traffic
---

{{ site.kic_product_name }} automatically creates a `kong` `IngressClass` when installed. All of the example ingress definitions in the documentation set `spec.ingressClassName: kong`, which allows things to work by default.

Advanced users of {{ site.kic_product_name }} may wish to split traffic in to internal and external ingress definitions. This requires multiple {{ site.kic_product_name }} instances, with each pointing to a different `IngressClass`

## Understanding IngressClass

The `IngressClass` resource is what binds an `Ingress` definition to an ingress controller. The value in the `spec.controller` field defines which ingress controller will process those ingress definitions. {{ site.kic_product_name }} processes any `IngressClass` where `spec.controller` is set to `ingress-controllers.konghq.com/kong`.

## Installing Kong

{{ site.kic_product_name }} processes one `IngressClass` per installation. {{ site.kic_product_name }} requires two deployments to split internal and external traffic.

Each deployment lives in it's own namespace, and the `controller.ingressController.ingressClass` value is set depending on if that deployment should handle internal or external traffic.

```bash
helm upgrade --install kong-internal kong/ingress -n internal --create-namespace --set controller.ingressController.ingressClass=internal
helm upgrade --install kong-external kong/ingress -n external --create-namespace --set controller.ingressController.ingressClass=external
```

## Creating Routes

Rather than setting `spec.ingressClassName: kong` in your `Ingress` definitions, you should now use either `internal` or `external`. Ingress definitions that target `internal` will only be available via {{ site.base_gateway }} running in the `internal` namespace. Definitions that target `external` will only be available via the `external` gateway.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: echo-internal
  annotations:
    konghq.com/strip-path: "true"
spec:
  # This line controls if it's available internally or externally
  ingressClassName: internal 
  rules:
    - http:
        paths:
          - path: /echo
            pathType: ImplementationSpecific
            backend:
              service:
                name: echo
                port:
                  number: 1027
```