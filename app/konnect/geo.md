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

{{site.konnect_product_name}} currently has the following regions in production:

Area | Geo shortform | Region codes and locations
-----|-----------|---------------------------
North America - AWS | US | `us-east-2` (Ohio, USA) <br>`us-west-2` (Oregon, USA)
Europe - AWS | EU | `eu-central-1` (Frankfurt, Germany) <br> `eu-west-1` (Ireland)
Australia - AWS | AP | `ap-southeast-2` (Sydney, Australia) <br> `ap-southeast-4` (Melbourne, Australia)

### Dedicated Cloud Gateways

{% navtabs %}
{% navtab AWS %}
{{site.konnect_saas}} Dedicated Cloud Gateways support the following AWS geos: 

Area | Geo shortform | Region codes and locations
-----|-----------|---------------------------
North America | US<br>CA | `us-east-2` (Ohio, USA) <br> `us-west-2` (Oregon, USA) <br> `us-west-1` (California, USA) <br> `ca-central-1` (Montreal, Canada)
Europe | EU |  `eu-central-1` (Frankfurt, Germany) <br> `eu-west-1` (Ireland) <br> `eu-west-2` (London, UK) <br> `eu-west-3` (Paris, France) <br> `eu-central-2` (Zurich, Switzerland)
Asia Pacific | AP | `ap-northeast-1` (Tokyo, Japan) <br> `ap-southeast-1` (Singapore) <br> `ap-southeast-2` (Sydney, Australia) <br> `ap-south-1` (Mumbai, India) <br> `ap-south-2` (Hyderabad, India) <br> `ap-northeast-2` (Seoul, South Korea) <br> `ap-southeast-3` (Jakarta, Indonesia)
Middle East and Africa | ME | `me-central-1` (United Arab Emirates)

{% endnavtab %}
{% navtab Azure %}
{{site.konnect_saas}} Dedicated Cloud Gateways support the following Azure geos: 

Area | Geo shortform | Region codes and locations
-----|-----------|---------------------------
North America | US | `eastus2` (Virginia, USA) <br> `westus2` (Washington, USA)
Europe | EU | `germanywestcentral` (Frankfurt, Germany) <br> `northeurope` (Ireland) <br> `uksouth` (UK South)

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