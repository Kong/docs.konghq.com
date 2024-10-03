---
title: Architecture
type: explanation
purpose: |
  How does KIC work? What are it's roles and responsibilities?
---

The {{site.kic_product_name}} configures {{site.base_gateway}} using Ingress or [Gateway API][gateway-api] resources created inside a Kubernetes cluster.

{{site.kic_product_name}} enables you to configure plugins, load balance the services, check the health of the Pods, and leverage all that Kong offers in a standalone installation.

{:.note}
> The {{ site.kic_product_name }} does not proxy any traffic directly. It configures {{ site.base_gateway }} using Kubernetes resources.

The figure illustrates how {{site.kic_product_name}} works:

<!--vale off-->
{% mermaid %}
flowchart TD
    subgraph Kubernetes cluster
        direction LR
        A(<img src="/assets/images/icons/third-party/kubernetes-logo.png" style="max-width:25px; display:block; margin:0 auto;" class="no-image-expand"/> API server) --> |events| B(<img src="/assets/images/logos/konglogo-gradient-secondary.svg" style="max-width:25px; display:block; margin:0 auto;" class="no-image-expand"/>Controller)
        B --> |configuration| C(<img src="/assets/images/logos/konglogo-gradient-secondary.svg" style="max-width:25px; display:block; margin:0 auto;" class="no-image-expand"/>Kong)
        C --> D(services)
    end
{% endmermaid %}
<!--vale on-->

The Controller listens for the changes inside the Kubernetes cluster and updates Kong in response to those changes. So that it can correctly proxy all the traffic. Kong is updated dynamically to respond to changes around scaling, configuration, and failures that occur inside a Kubernetes cluster.

For more information on how Kong works with routes, services, and upstreams,
please see the [proxy](/gateway/latest/reference/proxy/) and [load balancing](/gateway/latest/how-kong-works/load-balancing/) documentation.

## Kubernetes resources

In Kubernetes, there are several concepts that are used to logically identify workloads and route traffic between them.

### Service / Pods

A [Service][k8s-service] inside Kubernetes is a way to abstract an application that is running on a set of Pods. This maps to two objects in Kong: Service and Upstream.

The service object in Kong holds the information of the protocol to use to talk to the upstream service and various other protocol specific settings. The Upstream object defines load-balancing and health-checking behavior.

Pods associated with a Service in Kubernetes map as a target belonging to the upstream, where the upstream corresponds to the Kubernetes Service in Kong. Kong load balances across the Pods of your service. This means that **all requests flowing through Kong are not directed through kube-proxy but directly to the Pod**.

[k8s-service]: https://kubernetes.io/docs/concepts/services-networking/service/

### Gateway API

Gateway API resources can also be used to produce running instances and configurations for {{site.base_gateway}}.

The main concepts here are:

- A [Gateway][gateway-api-gateway] resource in Kubernetes describes how traffic
  can be translated to services within the cluster.
- A [GatewayClass][gateway-api-gatewayclass] defines a set of Gateways that share
  a common configuration and behaviour.
  Each GatewayClass is handled by a single controller, although controllers
  may handle more than one GatewayClass.
- [HTTPRoute][gateway-api-httproute] can be attached to a Gateway which
  configures the HTTP routing behavior.

For more information about Gateway API resources and features supported by {{site.kic_product_name}}, see
[Gateway API](/kubernetes-ingress-controller/latest/concepts/gateway-api).


### Ingress

An [Ingress][ingress] resource in Kubernetes defines a set of rules for proxying traffic. These rules correspond to the concept of a route in Kong.

This image describes the relationship between Kubernetes concepts and Kong's Ingress configuration.

<!--vale off-->
{% mermaid %}
flowchart LR
    subgraph Pods
        direction LR
        E(Target)
        F(Target)
        G(Target)
    end

    subgraph Kubernetes service
        direction TB
        C(Service)
        D(Upstream)
    end
    
    subgraph Ingress rules
        direction LR
        A(Route)
        B(Route)
    end

    A --> C
    B --> C
    C --> D
    D --> E
    D --> F
    D --> G

    classDef lightBlue fill:#cce7ff;
    classDef lightGreen fill:#c4e1c4;
    classDef lightPurple fill:#e6d8eb;
    classDef lightGrey fill:#f5f5f5;

    class A,B lightGreen;
    class C lightBlue;
    class D lightPurple;
    class E,F,G lightGrey;
{% endmermaid %}
<!--vale on-->

[gateway-api]: https://gateway-api.sigs.k8s.io/
[gateway-api-gateway]: https://gateway-api.sigs.k8s.io/concepts/api-overview/#gateway
[gateway-api-gatewayclass]: https://gateway-api.sigs.k8s.io/concepts/api-overview/#gatewayclass
[gateway-api-httproute]: /kubernetes-ingress-controller/{{ page.release }}/guides/services/http/
[ingress]: https://kubernetes.io/docs/concepts/services-networking/ingress/
