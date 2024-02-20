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

## {{site.konnect_short_name}} architecture

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

In the getting started guide, we will show you how to use a {{site.base_gateway}} data plane node to create entities, such as services and routes.

![{{site.konnect_product_name}}](/assets/images/products/konnect/konnect-intro.png)

> Figure 1: Diagram of {{site.konnect_short_name}} modules.

### {{site.base_gateway}} entities in {{site.konnect_short_name}}

things

![{{site.konnect_product_name}}](/assets/images/products/konnect/getting-started/konnect-gateway-entities.png)

> Figure 2: things

