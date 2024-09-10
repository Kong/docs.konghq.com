---
title: PagerDuty Integration
content-type: reference
config:
    discovery_support: true
    discovery_default: true
    bindable_entities: "PagerDuty Service"
    mechanism: "pull/ingestion model"
---

_Type: External_

The PagerDuty integration allows you to provide a way to alert the service team (via PagerDuty services) as well as provide information on current open incidents to consumers of the service directory. 

For each linked PagerDuty service, a summary should be provided showing current unresolved incidents and the current on-call user.
An option to start an incident for the PagerDuty service

## Authenticate the PagerDuty integration

1. From {{site.konnect_product_name}} select **[Integrations](https://cloud.konghq.com/us/service-catalog/integrations)**. 
2. Select **PagerDuty**, then **Install PagerDuty**.
3. Select **Authorize**. 

PagerDuty will ask you to grant consent to {{site.konnect_product_name}}. Both Read and Write scopes are required.

## Bindable entities

Entity | Binding Level | Description
-------|---------------|-------------
PagerDuty Service | Service | A PagerDuty service is any entity that can have incidents opened on it. In practice it could be a service, but could also be a group of services or an organization/team.

## Discovery information

{% include_cached service-catalog-discovery.html %}
