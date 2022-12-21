---
title: VM and K8s support
---

The platform agnosticity of Kuma enables Service Mesh to the entire organization - and not just Kubernetes - making it a more viable solution for the entire organization.

Until now, Service Mesh has been considered to be the last step of architecture modernization after transitioning to containers and perhaps to Kubernetes. This approach is entirely backwards. It makes the adoption and the business value of Service Mesh available only after implementing other massive transformations that - in the meanwhile - can go wrong.

In reality, we want Service Mesh to be available *before* we implement other transitions so that we can keep the network both secure and observable in the process. With Kuma, Service Mesh is indeed the **first step** towards modernization.

<center>
<img src="/assets/images/docs/0.5.0/diagram-05.jpg" alt="" style=" padding-top: 20px; padding-bottom: 10px;"/>
</center>

Unlike other control planes, Kuma natively runs across every platform - Kubernetes, VMs and Bare Metal - and it's not limited in scope (like many other control planes that only work on Kubernetes only). Kuma can run on both existing brownfield applications (that are most likely running on VMs), as well as new and modern greenfield applications that may be running on containers and Kubernetes.

Unlike other control planes, Kuma is easy to use. Anybody - from any team - can implement Kuma in [three simple steps](/install/) across both traditional monolithic applications and modern microservices.

Finally, by leveraging out-of-the-box policies and Kuma's powerful tagging selectors, we can implement a variety of behaviors in a variety of topologies, similar to multi-cloud and multi-region architectures.