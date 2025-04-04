---
title: Slack Integration
content-type: reference
beta: true
discovery_support: true
discovery_default: true
bindable_entities: "Slack Channel"
mechanism: "pull/ingestion model"
---

_Type: External_

The Slack integration allows you to see communication channels (via [Slack channels](https://slack.com/help/articles/360017938993-What-is-a-channel)) that are relevant to a Service Catalog service.

## Prerequisites

* You need the Slack Admin privileges to authorize the integration.

## Authenticate the Slack integration

1. From the **{% konnect_icon servicehub %} Service Catalog** in {{site.konnect_product_name}}, select **[Integrations](https://cloud.konghq.com/us/service-catalog/integrations)**. 
2. Select **Slack**, then **Install Slack**.
3. Select **Authorize**. 
   Only Slack admins can authorize the integration.

Slack will ask you to grant consent to {{site.konnect_product_name}}. Both read and write scopes are required.

## Resources

Entity | Description
-------|------------
Slack Channel | A Slack channel that indicates who owns the Service Catalog service. Ideally, this helps users identify who they can contact if they have questions about a service.                                              

## Discovery information

<!-- vale off-->

{% include_cached service-catalog-discovery.html 
   discovery_support=page.discovery_support
   discovery_default=page.discovery_default
   bindable_entities=page.bindable_entities
   mechanism=page.mechanism %}

<!-- vale on-->