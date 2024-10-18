---
title: SwaggerHub Integration
content-type: reference
beta: true
discovery_support: true
discovery_default: true
bindable_entities: "SwaggerHub API version"
mechanism: "pull/ingestion model"
---

_Type: External_

The SwaggerHub integration lets you connect SwaggerHub API specs directly to your Service Catalog services.

## Prerequisites

You need a SwaggerHub API key to authenticate your SwaggerHub account with {{site.konnect_short_name}}.

## Authenticate the SwaggerHub integration

1. From the **{% konnect_icon servicehub %} Service Catalog** in {{site.konnect_product_name}}, select **[Integrations](https://cloud.konghq.com/service-catalog/integrations)**. 
2. Select **SwaggerHub**, then **Install SwaggerHub**.
3. Select **Authorize**. 

This will take you to SwaggerHub, where you can use your SwaggerHub API key to grant {{site.konnect_short_name}} access to your account.

## View SwaggerHub specs in Service Catalog

You can map specs to a Service Catalog service and view them in {{site.konnect_short_name}}.

1. From the **{% konnect_icon servicehub %} Service Catalog** in {{site.konnect_product_name}}, select **[Services](https://cloud.konghq.com/us/service-catalog)**. 
2. Select a service, then open the **API Specs** tab.
2. Select **Add API Spec**.
3. Choose SwaggerHub as the **Source**, then pick your spec and name it.

Once it's uploaded, you can view the rendered spec on the API Specs tab in structured (UI), YAML, or JSON format, and download it in either YAML or JSON format.

## Resources

Entity | Description
-------|-------------
{{page.bindable_entities}} | A [SwaggerHub API version](https://support.smartbear.com/swaggerhub/docs/en/manage-apis/versioning.html?sbsearch=API%20Versions), which is the unique version identifier for a specific API spec.

## Discovery information

{:.note}
> This integration will discover both public and private SwaggerHub APIs in the linked account.

<!-- vale off-->

{% include_cached service-catalog-discovery.html 
   discovery_support=page.discovery_support
   discovery_default=page.discovery_default
   bindable_entities=page.bindable_entities
   mechanism=page.mechanism %}

<!-- vale on-->



