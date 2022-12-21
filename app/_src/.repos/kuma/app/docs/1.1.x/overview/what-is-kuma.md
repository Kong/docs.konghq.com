---
title: Overview
---

Kuma is a platform agnostic open-source control plane for service mesh and microservices management, with support for Kubernetes, VM, and bare metal environments.

<center>
<img src="/assets/images/diagrams/main-diagram@2x.png" alt="" style="width: 550px; padding-top: 10px"/>
</center>

Kuma helps implement a service mesh approach to distributed deployments as part of the move from monolithic architectures to microservices. You can run a service mesh with Kuma before you start decomposing your monolith, which helps keep your network secure and observable as your architecture changes. Kuma is:

* **Universal and Kubernetes-native**: Platform-agnostic, can run and operate anywhere.
* **Standalone and multi-zone**: Supports multiple clouds, regions, and Kubernetes clusters with native DNS service discovery and ingress capability.
  * [Read more about standalone deployments](/docs/{{ page.version }}/deployments/stand-alone/)
  * [Read more about multi-zone deployments](/docs/{{ page.version }}/deployments/multi-zone/)
* **Multi-mesh**: Supports multiple individual meshes with one control plane, lowering the operational costs of supporting the entire organization.
* **Attribute-based policies**: Lets you apply fine grained service and traffic policies with any arbitrary tag selector for `sources` and `destinations`.
* **Envoy-based**: Powered by Envoy sidecar proxies, without exposing the complexity of Envoy itself.
* **Horizontally scalable**
* **Enterprise-ready**: Supports mission critical enterprise use cases that require uptime and stability.

Bundling [Envoy](https://envoyproxy.io/) as the data plane, Kuma can instrument any L4/L7 traffic to secure, observe, route and enhance connectivity between any services or databases. It can be used natively in Kubernetes via CRDs or via a RESTful API across other environments.

Example of a multi-zone deployment for multiple Kubernetes clusters, or a hybrid Kubernetes/VM cluster:

<center>
<img src="/assets/images/docs/0.6.0/distributed-deployment.jpg" alt="" style="width: 700px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

The core maintainer of Kuma is **Kong**, the maker of the popular open-source Kong Gateway 🦍.
