---
title: How Kuma works
---

When building any modern digital application, we will inevitably introduce services that will communicate with each other by making requests on the network.

<center>
<img src="/assets/images/docs/diagram-before-after-full-r1.png" alt="" style="padding-top: 20px; padding-bottom: 10px;"/>
</center>

For example, think of any application that communicates with a database to store or retrieve data, or think of a more complex microservice-oriented application that makes many requests across different services to execute its operations:

<center>
<img src="/assets/images/docs/0.4.0/diagram-02.jpg" alt="" style="width: 550px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

Every time our services communicate over the network, we put the end-user experience at risk. As we all know the network between different services can be slow and unpredictable. It can be insecure, hard to trace, and pose many other problems (e.g., routing, versioning, canary deployments). In one sentence, our applications are one step away from being unreliable.

Usually, at this point, developers take one of the following actions to remedy the situation:

- **Write more code**: Developers write code - sometimes in the form of a _smart_ client - that every service will have to utilize when making requests to another service. Usually, this approach introduces a few problems:

  - It creates more technical debt
  - It is typically language-specific; therefore, it prevents innovation
  - Multiple implementations of the library exist, which creates fragmentation in the long run.

- **Sidecar proxy**: The services delegate all the connectivity and observability concerns to an out-of-process runtime, that will be on the execution path of every request. It will proxy all the outgoing connections and accept all the incoming ones. And of course it will execute traffic policies at runtime, like routing or logging. By using this approach, developers don't have to worry about connectivity and focus entirely on their services and applications.

{% tip %}
**Sidecar Proxy**: It's called _sidecar_ proxy because the proxy it's another process running alongside our service process on the same underlying host. There is going to be one instance of a sidecar proxy for each running instance of our services, and because all the incoming and outgoing requests - and their data - always go through the sidecar proxy, it is also called a data-plane (DP) since it sits on the data path.
{% endtip %}

Since we are going to be having many instances for our services, we are also going to be having an equal number of sidecar proxies: that's a lot of proxies! Therefore the sidecar proxy model **requires** a control plane that allows a team to configure the behavior of the proxies dynamically without having to manually configure them. The proxies initiate connections with the control plane to receive new configurations, while at runtime the control provides them with the most updated configuration.

Teams that adopt the sidecar proxy model will either build a control plane from scratch or use existing general-purpose control planes available on the market, such as Kuma. [Compare Kuma with other CPs](#kuma-vs-xyz).

Unlike a data plane proxy (DP), the control plane (CP) is never on the execution path of the requests that the services exchange with each other, and it's being used as a source of truth to dynamically configure the underlying data plane proxies that in the meanwhile we have deployed alongside every instance of every service that is part of the Mesh:

<center>
<img src="/assets/images/docs/0.4.0/diagram-03.jpg" alt="" style="width: 550px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

{% tip %}
**Service Mesh**: An architecture made of sidecar proxies deployed next to our services (the data-planes, or DPs), and a control plane (CP) controlling those DPs, is called Service Mesh. Usually, Service Mesh appears in the context of Kubernetes, but anybody can build Service Meshes on any platform (including VMs and Bare Metal).
{% endtip %}

With Kuma, our main goal is to reduce the code that has to be written and maintained to build reliable architectures. Therefore, Kuma embraces the sidecar proxy model by leveraging Envoy as its sidecar data-plane technology.

By outsourcing all the connectivity, security, and routing concerns to a sidecar proxy, we benefit from our enhanced ability to:

- build applications faster
- focus on the core functionality of our services to drive more business
- build a more secure and standardized architecture by reducing fragmentation

By reducing the code that our teams create and maintain, we can modernize our applications piece by piece without ever needing to bite more than we can chew.

<center>
<img src="/assets/images/docs/0.5.0/diagram-04.jpg" alt="" style=" padding-top: 20px; padding-bottom: 10px;"/>
</center>

## Dependencies

Kuma (`kuma-cp`) is one single executable written in GoLang that can be installed anywhere, hence why it's both universal and simple to deploy. 

* Running on **Kubernetes**: No external dependencies required, since it leverages the underlying K8s API server to store its configuration. Kuma automatically injects the sidecar data plane proxies.

* Running on **Universal**: Kuma requires a PostgreSQL database as a dependency in order to store its configuration. PostgreSQL is a very popular and easy database. You can run Kuma with any managed PostgreSQL offering as well, like AWS RDS or Aurora. Out of sight, out of mind!

Out of the box, Kuma ships with a bundled [Envoy](https://www.envoyproxy.io/) data plane proxy ready to use for our services, so that you don't have to worry about putting all the pieces together.

{% tip %}
Kuma ships with an executable `kuma-dp` that executes the bundled `envoy` executable to create the data plane proxy. For details, see the [Overview](/docs/{{ page.version }}/introduction/what-is-kuma).
{% endtip %}

[Install Kuma](/install/) and follow the instructions to get up and running in a few steps.

## VM and K8s support

The platform agnosticity of Kuma enables Service Mesh to the entire organization - and not just Kubernetes - making it a more viable solution for the entire organization.

Until now, Service Mesh has been considered to be the last step of architecture modernization after transitioning to containers and perhaps to Kubernetes. This approach is entirely backwards. It makes the adoption and the business value of Service Mesh available only after implementing other massive transformations that - in the meanwhile - can go wrong.

In reality, we want Service Mesh to be available *before* we implement other transitions so that we can keep the network both secure and observable in the process. With Kuma, Service Mesh is indeed the **first step** towards modernization.

<center>
<img src="/assets/images/docs/0.5.0/diagram-05.jpg" alt="" style=" padding-top: 20px; padding-bottom: 10px;"/>
</center>

Unlike other control planes, Kuma natively runs across every platform - Kubernetes, VMs and Bare Metal - and it's not limited in scope (like many other control planes that only work on Kubernetes only). Kuma can run on both existing brownfield applications (that are most likely running on VMs), as well as new and modern greenfield applications that may be running on containers and Kubernetes.

Unlike other control planes, Kuma is easy to use. Anybody - from any team - can implement Kuma in [three simple steps](/install/) across both traditional monolithic applications and modern microservices.

Finally, by leveraging out-of-the-box policies and Kuma's powerful tagging selectors, we can implement a variety of behaviors in a variety of topologies, similar to multi-cloud and multi-region architectures.

## Kuma vs XYZ

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

To learn more about the single and multi-zone deployments of Kuma you can ready the [deployments guide](/docs/{{ page.version }}/introduction/deployments).

{% tip %}
**Real-Time Support**: The Kuma community provides channels for real-time communication and support that you can explore in our [Community](/community) page. It also provides dedicated [Enterprise Support](/enterprise) delivered by [Kong](https://konghq.com).
{% endtip %}
