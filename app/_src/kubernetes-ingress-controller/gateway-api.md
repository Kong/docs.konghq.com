---
title: Gateway API
type: explanation
purpose: |
  Introduce the Kubernetes Gateway API as our preferred configuration method. Explain Gateway, GatewayClass and provide a simple HTTPRoute example
---

Kong are proud to be a driving force behind the Kubernetes Gateway API standard. Since being part of the originating team at Kubecon San Diego 2019, we've continued to actively invest in the project with multiple contributors in maintainer and reviewer roles. Kong are _all-in_ on Gateway API as the future of Kubernetes networking.

{{ site.kic_product_name }} was the first submitted conformance report, and is 100% compliant with the core conformance tests (in addition to many extended tests). Kong has implemented the Gateway API resources as first-class citizens, converting them directly in to {{ site.base_gateway }} configuration rather than using intermediate CRDs. This makes the Gateway API CRDs a native language for {{ site.kic_product_name }}.

The `Ingress` resource will continue to be supported in {{ site.kic_product_name }}, but we highly recommend that new users adopt Gateway API resources such as `HTTPRoute`.

## GatewayClass and Gateway

The `GatewayClass` object performs the same duties as the `IngressClass` resource. A `GatewayClass` represents a set of Gateways that are managed by the same Ingress Controller. They share any values provided in the `GatewayClass.spec.parametersRef` which control how the Gateways are deployed.

A `Gateway` is a 1:1 mapping to the deployment of a hardware or software load balancer. With {{ site.kic_product_name }} a `Gateway` corresponds to a deployment of {{ site.base_gateway }}.

When using {{ site.kic_product_name }} without the [{{ site.kgo_product_name }}](/gateway-operator/latest/) the `GatewayClass` has a `konghq.com/gatewayclass-unmanaged: 'true'` annotation to indicate that it is manually configured.

To create a `GatewayClass` and `Gateway` with {{ site.kic_product_name }} run the following:

```yaml
echo "
---
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: kong
  annotations:
    konghq.com/gatewayclass-unmanaged: 'true'

spec:
  controllerName: konghq.com/kic-gateway-controller
---
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: kong
spec:
  gatewayClassName: kong
  listeners:
  - name: proxy
    port: 80
    protocol: HTTP
" | kubectl apply -f -
```

## Available Route Types

{{ site.kic_product_name }} supports multiple Gateway API route types:

* [`HTTPRoute`](/kubernetes-ingress-controller/{{ page.release }}/guides/services/http/)
* [`TCPRoute`](/kubernetes-ingress-controller/{{ page.release }}/guides/services/tcp/)
* [`UDPRoute`](/kubernetes-ingress-controller/{{ page.release }}/guides/services/udp/)
* [`GRPCRoute`](/kubernetes-ingress-controller/{{ page.release }}/guides/services/grpc/)
