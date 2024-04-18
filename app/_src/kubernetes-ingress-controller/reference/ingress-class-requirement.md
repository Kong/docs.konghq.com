---
title: Resources Requiring Setting Ingress Class and How to Set them
type: reference
purpose: |
  What resources requires setting ingress class by its field or annotation to get reconciled by {{site.kic_product_name}} and how to set them
---

## Ingress Class

[Ingress class][ingress_class] in Kubernetes allows `Ingress` definitions to be processed by different controllers. {{ site.kic_product_name }} manages ingresses with an Ingress class of `kong`.

{:.note}
> `kong` is the default value and can be changed using the `--ingress-class` CLI flag, or `CONTROLLER_INGRESS_CLASS` environment variable.

## Gateway Class

{{ site.kic_product_name }} reconciles any resources attached to a `GatewayClass` that has a `spec.controllerName` of `konghq.com/kic-gateway-controller`. Gateway API resources are attached to a `Gateway` object using the `spec.parentRefs` field, and the `Gateway` references a `GatewayClass` using the `spec.gatewayClassName` field.

{:.note}
> `konghq.com/kic-gateway-controller` is the default value and can be changed using the `--gateway-api-controller-name` CLI flag, or `CONTROLLER_GATEWAY_API_CONTROLLER_NAME` environment variable.

## Resources that require Ingress Class or Gateway Class

The following resources require an Ingress Class or Gateway Class to be defined. Any resources that are attached to a resource containing an Ingress Class or Gateway Class that {{ site.kic_product_name }} reconciles will be automatically included in reconciliation.

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

**Note**: If the `IngressClass` used by {{site.kic_product_name}} (specified in flag `--ingress-class`) has `ingressclass.kubernetes.io/is-default-class` set to `true`, all resources that do not have an explicit Ingress Class set are also reconciled by {{site.kic_product_name}}. This does not include Gateway API resources.

[ingress_class]:https://kubernetes.io/docs/concepts/services-networking/ingress/#ingress-class
[gateway_class]:https://gateway-api.sigs.k8s.io/reference/spec/#gateway.networking.k8s.io/v1.GatewayClass
