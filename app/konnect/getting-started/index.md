---
title: Get started with Konnect
---

<table style="border:1px solid #e0e4ea;border-radius:6px">
  <tr style="background-color:#fff;border:none">
    <td rowspan="3" style="border-right:1px solid #e0e4ea;vertical-align:top;border-bottom:none;background-color:#F9FAFB">
        <br>
        <p style="font-size:16px;">How to get started with <img style="min-height:18px" src="/assets/images/logos/kong-konnect-logo.svg" alt="{{site.konnect_product_name}}" class="no-image-expand" /> </p>
    </td>
  </tr>
    <tr style="background-color:#fff;border:none">
    <td style="border-bottom:1px solid #e0e4ea;">
        <br>
        <p><b>Help me set up an API</b></p>
        <p>When you sign up for {{site.konnect_product_name}}, you can get started quickly with our onboarding wizard.</p>
        <p><a href="https://konghq.com/products/kong-konnect/register?utm_medium=referral&utm_source=docs">Sign up today</a></p>
    </td>
</tr>
  <tr style="background-color:#fff;border:none">
    <td style="border-bottom:none">
        <p><b>I know how to get started</b></p>
        <p><a href="/konnect/getting-started/add-api/"><i class="fas fa-plus"></i> Add an API &rarr;</a></p>
        <p><a href="/konnect/getting-started/import/"><i class="fas fa-file-import"></i> Import {{site.base_gateway}} entities &rarr;</a></p>
    </td>
  </tr>
</table>

## About {{site.konnect_short_name}}

{{site.konnect_short_name}} is an API lifecycle management platform that lets you build modern applications better, faster, and more securely. The control plane is hosted in the cloud by Kong, while the data plane is managed by you within your preferred network environment. All of this is powered by {{site.base_gateway}} — Kong's lightweight, fast, and flexible API gateway. 

{{site.konnect_short_name}} can help you with the following use cases:

* **Developers:** Use {{site.konnect_short_name}} as the easiest way to manage {{site.base_gateway}}. This helps save time on writing boilerplate code used to protect and secure APIs. 
* **Small teams:** Use features like API cataloguing, external developer portals, and API analytics to share and monetize their APIs. 
* **Large enterprise companies:** Use multi-geo support for the control plane and achieve federated API management by giving central teams governance tools while providing API teams with speed and flexibility.

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
