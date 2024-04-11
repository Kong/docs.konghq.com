---
title: Geographic Regions
content_type: explanation
no_version: true
---

{{site.konnect_saas}} allows you to host and operate your cloud instance in a geographic region that you specify. This is important for data privacy and regulatory compliance for you organization. 

Geographic regions allow you to also operate {{site.konnect_saas}} in a similar geo to your users and their infrastructure applications. 
<!--- Do not publish yet: "This reduces network latency and minimizes the blast-radius in the event of cross-region connectivity failures." -->

## Supported geos 

### Control planes

{{site.konnect_saas}} currently supports the following geos:

* AU
* EU
* US

### Dedicated Cloud Gateways

{{site.konnect_saas}} Dedicated Cloud Gateways support the following AWS geos: 


* North America:
    * Ohio (us-east-2)
    * Oregon (us-west-2)
* Europe:
    * Frannkfurt (eu-central-1)
    * Ireland (eu-west-1)
    * London (eu-west-2)
* Asia Pacific:
    * Tokyo (ap-northeast-1)
    * Singapore (ap-southeast-1)
    * Sydney (ap-southeast-2)
    * Mumbai (ap-south-1)

## Geo management

When you create a {{site.konnect_saas}} account, you select a geographic region for your instance. Geos are distinct deployments of {{site.konnect_short_name}} with objects, such as services and consumers, that are geo-specific. Only authentication, billing, and usage is shared between {{site.konnect_short_name}} geos.

The following objects are geo-specific and are not shared between geos:

* [Services](/konnect/servicehub/)
* [API products](/konnect/api-products/)
* [Service meshes and mesh zones](/konnect/mesh-manager/)
* [Routes](/konnect/getting-started/implement-service/)
* [Consumers](/konnect/gateway-manager/configuration/)
* [Application registration](/konnect/dev-portal/applications/enable-app-reg/)
* [Custom teams and roles](/konnect/org-management/teams-and-roles/)