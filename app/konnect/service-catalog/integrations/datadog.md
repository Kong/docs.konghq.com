---
title: Datadog Integration
content-type: reference
beta: true
discovery_support: true
discovery_default: true
bindable_entities: "Datadog Monitor, Datadog Dashboard"
mechanism: "pull/ingestion model"
---

_Type: External_

The Datadog integration lets you connect Datadog entities directly to your Service Catalog services.

## Authenticate the Datadog integration

1. From the **{% konnect_icon servicehub %} Service Catalog** in {{site.konnect_product_name}}, select **[Integrations](https://cloud.konghq.com/us/service-catalog/integrations)**. 
2. Select **Datadog**, then **Install Datadog**.
3. Select **Authorize**. 

<!--post step, does this take you to Datadog? Where/when do I put in my API key and app key? mention that they need to be public dashboards? something about specifying a site-->

## Resources

| Entity | Description |
|-------|-------------|
| Datadog Monitor | A [Datadog Monitor](https://docs.datadoghq.com/monitors/), which provides visibility into performance issues and outages. |
| Datadog Dashboard | A [Datadog Dashboard](https://docs.datadoghq.com/dashboards/), which provides visibility into the performance and health of systems and applications in your org. |

## Discovery information

<!-- vale off-->

{% include_cached service-catalog-discovery.html 
   discovery_support=page.discovery_support
   discovery_default=page.discovery_default
   bindable_entities=page.bindable_entities
   mechanism=page.mechanism %}

<!-- vale on-->



