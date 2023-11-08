---
title: Geographic Regions
content_type: explanation
no_version: true
---

{{site.konnect_saas}} allows you to host and operate your cloud instance in a geographic region that you specify. This is important for data privacy and regulatory compliance for you organization. 

Geographic regions allow you to also operate {{site.konnect_saas}} in a similar geographical region to your users and their infrastructure applications. 
<!--- Do not publish yet: "This reduces network latency and minimizes the blast-radius in the event of cross-region connectivity failures." -->

{:.note}
> **Note:** Only Enterprise plans can operate in more than one region at a time. For more information about how to upgrade your plan, see [Change to a Different Plan](/konnect/account-management/).
## Supported regions 

{{site.konnect_saas}} currently supports the following regions:

* US
* EU
* AU

## Region management

When you create a {{site.konnect_saas}} account, you select a geographic region for your instance. Regions are distinct deployments of {{site.konnect_short_name}} with objects, such as services and consumers, that are region-specific. Only authentication, billing, and usage is shared between {{site.konnect_short_name}} regions.

The following objects are region-specific and are not shared between regions:

* [Services](/konnect/servicehub/)
* [Routes](/konnect/getting-started/implement-service/)
* [Consumers](/konnect/runtime-manager/manage-proxy-config/)
* [Application registration](/konnect/dev-portal/applications/enable-app-reg/)
* [Dev Portal](/konnect/dev-portal/access/)
* [Certain teams and roles](/konnect/org-management/teams-and-roles/)