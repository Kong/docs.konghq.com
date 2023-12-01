---
title: Konnect APIs
content-type: explanation
disable_image_expand: true
---


## Base URLs

{{site.konnect_short_name}} API base URLs differ based on the geo they are hosted in or if they are global. For a list of the API base URLs by geo, see [Ports and Network Requirements](/konnect/network/).

The global endpoint is used to manage geo-agnostic {{site.konnect_short_name}} entities that live in a global database. These APIs interact with entities that are not geo-specific and therefore do not have any regional boundaries. For example, identity management and IdP settings are all geo-agnostic configurations applied to the organization as a whole.

The geo-specific endpoints are used to manage {{site.konnect_short_name}} entities that live in a specific {{site.konnect_short_name}} geo. These APIs interact with entities specific to a geo and do not have the ability to cross regional boundaries. For example, control planes, data plane nodes, and API product listings are all geo-specific entities and therefore must use the geo-specific endpoint. See [Geographic Regions](/konnect/geo/) for more information. 




| Spec | Insomnia link |
|------|---------------|
| [Konnect control plane configuration beta API spec](/konnect/api/control-plane-configuration/latest/) | <a href="https://insomnia.rest/run/?label=Control%20Plane%20Configuration%20API&uri=https%3A%2F%2Fraw.githubusercontent.com%2FKong%2Fdocs.konghq.com%2Fmain%2Fapi-specs%2FKonnect%2Fcontrol-planes-config%2Fcontrol-planes-config.yaml" target="_blank"><img src="https://insomnia.rest/images/run.svg" alt="Run in Insomnia"></a>|

## Authentication

The recommended method of authentication for {{site.konnect_short_name}} is [Personal Access Token (PAT)](/konnect/gateway-manager/declarative-config/#generate-a-personal-access-token), which can be obtained from the [personal access token page](https://cloud.konghq.com/global/account/tokens) in {{site.konnect_short_name}}. The PAT must be passed in the `Authorization` header of all requests, for example: 

`curl -X GET 'https://global.api.konghq.com/v2/users/' --header 'Authorization: Bearer kpat_xgfT'`

## Filtering

The Konnect API supports filtering, read the [Filtering reference](/konnect/api/filtering/) to learn more.

## Specifications

For a full list of the API specifications supported for use in production environments, visit [API Specs](/api/). 
