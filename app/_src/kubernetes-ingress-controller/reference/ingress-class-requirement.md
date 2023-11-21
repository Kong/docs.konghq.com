---
title: Resources Requiring Setting Ingress Class and How to Set them
type: reference
purpose: |
  What resources requires setting ingress class by its field or annotation to get reconciled by {{site.kic_product_name}} and how to set them
---

## Ingress Class

[Ingress class][ingress_class] is defined to distinguish ingresses to be processed by different controllers. {{site.kic_product_name}} has the flag `--ingress-class` (default:`kong`) to set the ingress class that the {{site.kic_product_name}} instance processes. In gateway API, [gateway class][gateway_class] has the same usage.

## Resource Requiring Setting Ingress Class or Gateway Class

Some resources requires setting ingress class to get processed by {{site.kic_product_name}}. The ingress class need to be set to the same as specified in the flag `--ingress-class` to get processed. Here's the table with the details.

| Resource Kind       | Resource Group and Version         | Method to set Ingress Class                     | 
|---------------------|------------------------------------|-------------------------------------------------|
| `Ingress`           | `networking.k8s.io/v1`             | Set in `spec.ingressClassName` or               |
|                     |                                    | set in annotation `kubernetes.io/ingress.class` |
| `Gateway`           | `gateway.networking.k8s.io/v1`     | Set in `spec.gatewayClassName`                  |
| `KongClusterPlugin` | `configuration.konghq.com/v1`      | Set in annotation `kubernetes.io/ingress.class` |
| `KongConsumer`      | `configuration.konghq.com/v1`      | Set in annotation `kubernetes.io/ingress.class` |
| `KongConsumerGroup` | `configuration.konghq.com/v1beta1` | Set in annotation `kubernetes.io/ingress.class` |
| `TCPIngress`        | `configuration.konghq.com/v1beta1` | Set in annotation `kubernetes.io/ingress.class` |
| `UDPIngress`        | `configuration.konghq.com/v1beta1` | Set in annotation `kubernetes.io/ingress.class` |

Note: If the `IngressClass` used by {{site.kic_product_name}} (specified in flag `--ingress-class`) has `ingressclass.kubernetes.io/is-default-class` set to `true`, the resources except for `Gateway` does not have ingress classes set are also reconciled by {{site.kic_product_name}}.

[ingress_class]:https://kubernetes.io/docs/concepts/services-networking/ingress/#ingress-class
[gateway_class]:https://gateway-api.sigs.k8s.io/reference/spec/#gateway.networking.k8s.io/v1.GatewayClass
