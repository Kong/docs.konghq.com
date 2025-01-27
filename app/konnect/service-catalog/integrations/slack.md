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

The Slack integration allows you to see relevant communication channels (via [Slack channels](https://slack.com/help/articles/360017938993-What-is-a-channel)) to a Service Catalog service.

## Authenticate the Slack integration

1. From the **{% konnect_icon servicehub %} Service Catalog** in {{site.konnect_product_name}}, select **[Integrations](https://cloud.konghq.com/us/service-catalog/integrations)**. 
2. Select **Slack**, then **Install Slack**.
3. Select **Authorize**. 

Slack will ask you to grant consent to {{site.konnect_product_name}}. Both read and write scopes are required.

## Resources

Entity | Description
-------|------------
Slack Channel | A Slack channel relating to the Service Catalog service


## Events

**Event**  | **Description** 
-------|------------
 [**`team_access_granted`**](https://api.slack.com/events/team_access_granted)       | Occurs when a Slack bot is installed into a workspace for an Enterprise Grid customer.                            
 [**`team_access_revoked`**](https://api.slack.com/events/team_access_revoked)       | Occurs when a Slack bot is removed from a workspace for an Enterprise Grid customer.                              
 [**`grid_migration_started`**](https://api.slack.com/events/grid_migration_started) | Occurs when a workspace begins migrating to Enterprise Grid.                                                      
 [**`grid_migration_finished`**](https://api.slack.com/events/grid_migration_finished)| Occurs when a workspace has finished migrating to Enterprise Grid.                                                

## Discovery information

<!-- vale off-->

{% include_cached service-catalog-discovery.html 
   discovery_support=page.discovery_support
   discovery_default=page.discovery_default
   bindable_entities=page.bindable_entities
   mechanism=page.mechanism %}

<!-- vale on-->