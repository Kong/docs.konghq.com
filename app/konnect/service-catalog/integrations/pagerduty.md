---
title: PagerDuty Integration
content-type: reference
beta: true
discovery_support: true
bindable_entities: "PagerDuty Service"
---

_Type: External_

The PagerDuty integration allows you to provide a way to alert the service team (via PagerDuty services) as well as provide information on current open incidents to consumers of the service directory. 

For each linked PagerDuty service, a summary will be provided on the Service Catalog service's details page, showing current unresolved incidents and the current on-call user.

## Authenticate the PagerDuty integration

1. From the **{% konnect_icon servicehub %} Service Catalog** in {{site.konnect_product_name}}, select **[Integrations](https://cloud.konghq.com/us/service-catalog/integrations)**. 
2. Select **PagerDuty**, then **Install PagerDuty**.
3. Select **Authorize**. 

PagerDuty will ask you to grant consent to {{site.konnect_product_name}}. Both Read and Write scopes are required.

## Resources

Entity | Description
-------|------------
PagerDuty Service | A PagerDuty service is any entity that can have incidents opened on it. In practice it could be a service, but could also be a group of services or an organization/team.

## Discovery information

<!-- vale off-->

{% include_cached service-catalog-discovery.html 
   discovery_support=page.discovery_support
   discovery_default=page.discovery_default
   bindable_entities=page.bindable_entities
   mechanism=page.mechanism %}

<!-- vale on-->