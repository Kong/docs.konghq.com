---
title: Konnect Architecture
---

The {{site.konnect_product_name}} platform provides several hosted control plane options 
to manage all service configurations. You can use one or more of the following control plane options:
* {{site.base_gateway}}
* {{site.kic_product_name}} 
* {{site.mesh_product_name}}

The control plane propagates those configurations to
the data plane, which is composed of self-managed data plane 
nodes (and proxies in the case of {{site.mesh_product_name}}). The individual nodes can be running either on-premise or in 
cloud-hosted environments, and each data plane node stores the configuration 
in-memory. 

![{{site.konnect_product_name}}](/assets/images/docs/konnect/konnect-intro.png)

> Figure 1: Diagram of {{site.konnect_short_name}} modules.

Data plane nodes listen for traffic on the proxy port `443`
by default. The {{site.konnect_short_name}} data plane evaluates
incoming client API requests and routes them to the appropriate backend APIs.
While routing requests and providing responses, policies can be applied with
plugins as necessary.

For example, before routing a request, the client might be required to
authenticate. This delivers several benefits, including:

* The Gateway service doesn’t need its own authentication logic since the data plane is
handling authentication.
* The Gateway service only receives valid requests and therefore cycles are not wasted
processing invalid requests.
* All requests are logged for central visibility of traffic.


Try it for yourself! [Get started](https://cloud.konghq.com/quick-start) with {{ site.konnect_short_name }} for free today.