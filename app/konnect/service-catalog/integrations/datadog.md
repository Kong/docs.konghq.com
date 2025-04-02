---
title: Datadog Integration
content-type: reference
beta: true
discovery_support: true
bindable_entities: "Datadog Monitor, Datadog Dashboard"
---

_Type: External_

The Datadog integration lets you connect Datadog entities directly to your Service Catalog services.

## Authenticate the Datadog integration

1. From the **{% konnect_icon servicehub %} Service Catalog** in {{site.konnect_product_name}}, select **[Integrations](https://cloud.konghq.com/service-catalog/integrations)**. 
1. Select **Datadog**, then **Install Datadog**.
1. Select your Datadog region and enter your [Datadog API and application keys](https://docs.datadoghq.com/account_management/api-app-keys/). 
1. Select **Authorize**. 

## Resources

| Entity | Description |
|-------|-------------|
| Datadog Monitor | A direct mapping to a [Monitor](https://docs.datadoghq.com/monitors/). These provide visibility into performance issues and outages.|
| Datadog Dashboard | A direct mapping to a [Dashboard](https://docs.datadoghq.com/dashboards/) in Datadog. These provide visibility into the performance and health of systems and applications in your organization.|

## Discovery information

<!-- vale off-->

{% include_cached service-catalog-discovery.html 
   discovery_support=page.discovery_support
   discovery_default=page.discovery_default
   bindable_entities=page.bindable_entities
   mechanism=page.mechanism %}

<!-- vale on-->



