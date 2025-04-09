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

* AU (Australia)
* EU (Europe)
* ME (Middle East)
* US (United States)
* IN (India)


### Dedicated Cloud Gateways

{% navtabs %}
{% navtab AWS %}
{{site.konnect_saas}} Dedicated Cloud Gateways support the following AWS geos: 


* North America:
    * Ohio (`us-east-2`)
    * Oregon (`us-west-2`)
    * N. Virginia (`us-east-1`)
    * N. California(`us-west-1`)
    * Montreal (`ca-central-1`)
* Europe:
    * Frankfurt (`eu-central-1`)
    * Ireland (`eu-west-1`)
    * London (`eu-west-2`)
    * Paris (`eu-west-3`)
    * Zurich (`eu-central-2`)
* Asia Pacific:
    * Tokyo (`ap-northeast-1`)
    * Singapore (`ap-southeast-1`)
    * Sydney (`ap-southeast-2`)
    * Mumbai (`ap-south-1`)
    * Hyderabad (`ap-south-2`)
    * Seoul (`ap-northeast-2`)
* Middle East, and Africa
    * United Arab Emirates (`me-central-1`)

{% endnavtab %}
{% navtab Azure %}
{{site.konnect_saas}} Dedicated Cloud Gateways support the following Azure geos: 

* North America:
    * Virginia (`eastus2`)
    * Washington (`westus2`)
* Europe:
    * Frankfurt (`germanywestcentral`)
    * UK South (`uksouth`)
    * Ireland (`northeurope`)

{% endnavtab %}

{% navtab Google %}
{{site.konnect_saas}} Dedicated Cloud Gateways support the following Google Cloud geos: 

* North America:
    * South Carolina (`us-east1`)
    * Montreal (`northamerica-northeast1`)
* Europe:
    * Belgium (`europe-west1`)
* Asia Pacific:
    * Tokyo (`asia-northeast1`)
    
{% endnavtab %}

{% endnavtabs %}
## Geo management

When you create a {{site.konnect_saas}} account, you select a geographic region for your instance. Geos are distinct deployments of {{site.konnect_short_name}} with objects, such as services and consumers, that are geo-specific. Only authentication, billing, and usage is shared between {{site.konnect_short_name}} geos.

The following objects are geo-specific and are not shared between geos:

* [Services](/konnect/service-catalog/)
* [API products](/konnect/api-products/)
* [Service meshes and mesh zones](/konnect/mesh-manager/)
* [Routes](/konnect/getting-started/implement-service/)
* [Consumers](/konnect/gateway-manager/configuration/)
* [Application registration](/konnect/dev-portal/applications/enable-app-reg/)
* [Custom teams and roles](/konnect/org-management/teams-and-roles/)
* [Dev portals](/konnect/dev-portal/)
