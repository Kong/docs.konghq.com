---
title: Konnect Architecture
no_version: true
---

The {{site.konnect_product_name}} platform provides a cloud control plane (CP),
which manages all service configurations. It propagates those configurations to
all runtime nodes, which use in-memory storage. These nodes can be installed
anywhere, on-premise or in the cloud.

![Konnect Cloud](/assets/images/docs/konnect/konnect-intro.png)

> Figure 1: Diagram of Konnect modules.

Runtime instances, acting as data planes, listen for traffic on the proxy port 443
by default. The {{site.konnect_short_name}} data plane evaluates
incoming client API requests and routes them to the appropriate backend APIs.
While routing requests and providing responses, policies can be applied with
plugins as necessary.

For example, before routing a request, the client might be required to
authenticate. This delivers several benefits, including:

* The Service doesn’t need its own authentication logic since the data plane is
handling authentication.
* The Service only receives valid requests and therefore cycles are not wasted
processing invalid requests.
* All requests are logged for central visibility of traffic.
