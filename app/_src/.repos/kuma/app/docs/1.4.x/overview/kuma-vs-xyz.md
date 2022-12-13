---
title: Kuma vs XYZ
---

When Service Mesh first became mainstream around 2017, a few control planes were released by small and large organizations in order to support the first implementations of this new architectural pattern.

These control planes captured a lot of enthusiasm in the early days, but they all lacked pragmatism into creating a viable journey to Service Mesh adoption within existing organizations. These 1st generation solutions are:

* **Greenfield-only**: Hyper-focused on new greenfield applications, without providing a journey to modernize existing workloads running on VM and Bare Metal platforms where the current business runs today, in addition to Kubernetes.
* **Complicated to use**: Service Mesh doesn't have to be complicated, but early implementations were hard to use; they had poor documentation and no clear upgrade path to mitigate breaking changes.
* **Hard to deploy**: Many moving parts, which need to be running optimally at the same time, makes it harder to run and scale a Service Mesh due to the side-effect of higher operational costs.
* **Hard to distribute**: Across different clouds, different data-centers and different Kubernetes clusters with non-intuitive service discovery and connectivity.

Kuma exists today to provide a pragmatic journey to implementing Service Mesh for the entire organization and for every team: for those running on modern Kubernetes environments and for those running on more traditional platforms like Virtual Machines and Bare Metal.

* **Universal and Kubernetes-Native**: Platform-agnostic, can run and operate anywhere on both Kubernetes and VMs.
* **Single and Multi-Zone**: To support multiple clouds, regions and Kubernetes clusters with out of the box multi-zone connectivity thanks to the native service discovery and ingress capability.
* **Multi-Mesh**: To support multiple individual meshes with one control plane, lowering the operational costs of supporting the entire organization.
* **Attribute-Based policies**: To apply fine grained service and traffic policies using any arbitrary tag selector for `sources` and `destinations`.
* **Envoy-Based**: Powered by Envoy sidecar proxies, without exposing the complexity of Envoy itself.
* **Easy to use**: No moving parts. One click policy installation. Horizontally scalable.
* **Enterprise-Ready**: Used by mission critical enterprise use-cases that require uptime and stability.

<center>
<img src="/assets/images/docs/0.6.0/distributed-deployment.jpg" alt="" style="width: 700px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

To learn more about the single and multi-zone deployments of Kuma you can ready the [deployments guide](/docs/latest/documentation/deployments).

{% tip %}
**Real-Time Support**: The Kuma community provides channels for real-time communication and support that you can explore in our [Community](/community) page. It also provides dedicated [Enterprise Support](/enterprise) delivered by [Kong](https://konghq.com).
{% endtip %}