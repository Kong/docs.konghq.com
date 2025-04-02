---
title: Traceable Integration
content-type: reference
beta: true
discovery_support: true
bindable_entities: "Traceable Service"
---

_Type: External_

The Traceable integration lets you connect Traceable entities directly to your Service Catalog services.

## Authenticate the Traceable integration

1. From the **{% konnect_icon servicehub %} Service Catalog** in {{site.konnect_product_name}}, select **[Integrations](https://cloud.konghq.com/us/service-catalog/integrations)**. 
2. Select **Traceable**, then **Install Traceable**.
3. Select **Authorize**. 

## Resources

Entity | Description
-------|-------------
Traceable Service | A direct mapping to a [Traceable Service](https://docs.traceable.ai/docs/domains-services-backends). These entities holds groups of Traceable API endpoint resources.

## Discovery information

<!-- vale off-->

{% include_cached service-catalog-discovery.html 
   discovery_support=page.discovery_support
   discovery_default=page.discovery_default
   bindable_entities=page.bindable_entities
   mechanism=page.mechanism %}

<!-- vale on-->



