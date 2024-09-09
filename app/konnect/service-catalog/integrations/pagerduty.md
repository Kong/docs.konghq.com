---
title: PagerDuty Integration
content-type: reference
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

## Bindable Entities

Entity | Binding Level | Description
-------|---------------|-------------
PagerDuty Service | Service | A PagerDuty service is any entity that can have incidents opened on it. In practice it could be a service, but could also be a group of services or an organization/team.


## Discovery FAQs

| **Question**                                     | **Answer**                      |
|--------------------------------------------------|----------------------------------|
| Is discovery supported by this integration?      | Yes.                            |
| Is discovery enabled by default?                 | Yes.                            |
| What bindable entities can be discovered?        | PagerDuty Services.             |
| What mechanism is used for discovery?            | Pull/Ingestion model.           |



