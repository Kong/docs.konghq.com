---
title: Kubernetes Ingress Controller Design
---

## Overview

The {{site.kic_product_name}} configures {{site.base_gateway}} using Ingress
or [Gateway API][gateway-api] resources created inside a Kubernetes cluster.

The {{site.kic_product_name}} is made up of two high level components:

- Kong, the core proxy that handles all the traffic
- Controller Manager, a series of processes that synchronize the configuration from Kubernetes to Kong

The {{site.kic_product_name}} performs more than just proxying the traffic coming
into a Kubernetes cluster. It is possible to configure plugins,
load balancing, health checking and leverage all that Kong offers in a
standalone installation.

The following figure shows how it works:

![high-level-design](/assets/images/docs/kubernetes-ingress-controller/high-level-design.png "High Level Design")

The Controller Manager listens for changes happening inside the Kubernetes
cluster and updates Kong in response to those changes to correctly
proxy all the traffic.

Kong is updated dynamically to respond to changes around scaling,
configuration changes, failures that are happening inside a Kubernetes
cluster.

---

For more information on how Kong works with routes, services, and upstreams,
please see the [proxy](/gateway/latest/reference/proxy/)
and [load balancing](/gateway/latest/how-kong-works/load-balancing/) references.

## Translation

Kubernetes resources are mapped to Kong resources to proxy traffic.

There exist 2 flavors of objects in Kubernetes that can be used with
{{site.kic_product_name}} in order to procure a working {{site.base_gateway}}.

- an [Ingress][ingress]
- [Gateway API objects][gateway-api]

### Generic Kubernetes resources

In Kubernetes, there are several main concepts that are use to logically identify
workloads and route traffic between them. Some of them are:

- A [Service][k8s-service] inside Kubernetes is a way to abstract an application that is running on a set of pods.
  This maps to two objects in Kong: Service and Upstream.
  The service object in Kong holds the information on the protocol
  to use to talk to the upstream service and various other protocol
  specific settings. The Upstream object defines load-balancing
  and health-checking behavior.
- Pods associated with a Service in Kubernetes map as a Target belonging
  to the Upstream (the upstream corresponding to the Kubernetes
  Service) in Kong. Kong load balances across the Pods of your service.
  This means that all requests flowing through Kong are not directed via
  kube-proxy but directly to the pod.

[k8s-service]: https://kubernetes.io/docs/concepts/services-networking/service/

### Ingress

An [Ingress][ingress] resource in Kubernetes defines a set of rules for proxying traffic.
These rules correspond to the concept of a route in Kong.

The following image describes the relationship between Kubernetes concepts and Kong's
`Ingress` configuration.

![translating Kubernetes to Kong](/assets/images/docs/kubernetes-ingress-controller/k8s-to-kong.png "Translating k8s resources to Kong")

### Gateway API

Gateway API resources can also be used to produce running instances
and configurations for {{site.base_gateway}}.

The main concepts here are:

- A [`Gateway`][gateway-api-gateway] resource in Kubernetes describes how traffic
  can be translated to services within the cluster.
- A [`GatewayClass`][gateway-api-gatewayclass] defines a set of Gateways that share
  a common configuration and behaviour.
  Each `GatewayClass` will be handled by a single controller, although controllers
  may handle more than one `GatewayClass`.
- [`HTTPRoute`][gateway-api-httproute] can be attached to a Gateway which will
  configure the HTTP routing behavior.
  
You can find more details about Gateway API concepts supported by {{site.kic_product_name}}
[here](/kubernetes-ingress-controller/latest/references/gateway-api-support).

[gateway-api]: https://gateway-api.sigs.k8s.io/
[gateway-api-gateway]: https://gateway-api.sigs.k8s.io/concepts/api-overview/#gateway
[gateway-api-gatewayclass]: https://gateway-api.sigs.k8s.io/concepts/api-overview/#gatewayclass
[gateway-api-httproute]: https://gateway-api.sigs.k8s.io/concepts/api-overview/#httproute
[ingress]: https://kubernetes.io/docs/concepts/services-networking/ingress/
