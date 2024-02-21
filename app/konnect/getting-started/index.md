---
title: Get started with Konnect
---

{% mermaid %}
flowchart TD
    A{Start my {{site.konnect_short_name}} journey} -->B(Set up an API for me)
    A{Start my {{site.konnect_short_name}} journey} -->C(I want to do it myself)
    B --> D(Use the onboarding wizard for the first time)
    C --> E(Add an API to {{site.konnect_short_name}})
    C --> F(Import {{site.base_gateway}} entities to {{site.konnect_short_name}})

    %% this section defines node interactions
    click D "https://cloud.konghq.com/quick-start"
    click E "/konnect/getting-started/add-api/"
    click F "/konnect/getting-started/import/"
{% endmermaid %}

## About {{site.konnect_short_name}}

{% include_cached /md/konnect/introducing-konnect.md %}

### {{site.konnect_short_name}} architecture

{% include_cached /md/konnect/konnect-architecture.md %}

In the getting started guide, we will show you how to use a {{site.base_gateway}} data plane node to create entities, such as services and routes.

![{{site.konnect_product_name}}](/assets/images/products/konnect/konnect-intro.png)

> Figure 1: Diagram of {{site.konnect_short_name}} modules. The {{site.konnect_short_name}} environment, hosted by Kong, consists of the {{site.konnect_short_name}} applications, {{site.konnect_short_name}} platform, and control planes. The {{site.base_gateway}}, {{site.mesh_product_name}}, and {{site.kic_product_name}} data plane nodes that are connected with the {{site.konnect_short_name}} platform are self-managed.

### {{site.base_gateway}} entities in {{site.konnect_short_name}}

Entities, like services, are self-hosted in {{site.base_gateway}}.

![{{site.konnect_product_name}}](/assets/images/products/konnect/getting-started/konnect-gateway-entities.png)

> Figure 2: Diagram that describes how entities, like services, routes, consumers, and load balancers, are self-hosted by the {{site.base_gateway}} data plane node.

Each self-hosted {{site.base_gateway}} data plane node contains the following entities:

* [**Services:**](/gateway/latest/key-concepts/services/) A service is an entity representing an external upstream API or microservice. For example, a data transformation microservice, a billing API, and so on.
* [**Routes:**](/gateway/latest/key-concepts/routes/) Routes determine how (and if) requests are sent to their services after they reach the gateway. Where a service represents the backend API, a route defines what is exposed to clients. A single service can have many routes. Once a route is matched, the gateway proxies the request to its associated service.
* [**Consumers:**](/gateway/latest/kong-enterprise/consumer-groups/) Consumer objects represent users of a service, and are most often used for authentication. They provide a way to divide access to your services, and make it easy to revoke that access without disturbing a service’s function.
* [**Load balancers:**](/gateway/latest/get-started/load-balancing/) Load balancing is a method of distributing API request traffic across multiple upstream services. Load balancing improves overall system responsiveness and reduces failures by preventing overloading of individual resources.
* [**Upstream targets:**](/gateway/latest/key-concepts/upstreams/) Upstream refers to an API, application, or micro-service that {{site.base_gateway}} forwards requests to. In {{site.base_gateway}}, an upstream object represents a virtual hostname and can be used to health check, circuit break, and load balance incoming requests over multiple services.

When you create one of these entities, like a service, using the {{site.konnect_short_name}} UI or API, Kong automatically creates an entity in the corresponding data plane node. 

For more information, see [{{site.base_gateway}} Configuration in {{site.konnect_short_name}}](/konnect/gateway-manager/configuration/).
