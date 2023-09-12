---
title: Konnect APIs
content-type: explanation
disable_image_expand: true
---


## Base URLs

There are two types of base URLs that are used in {{site.konnect_short_name}} APIs:

* **Global**: `https://global.api.konghq.com`

* **Region specific**: `https://{REGION_CODE}.api.konghq.com`

The global endpoint is used to manage region-agnostic {{site.konnect_short_name}} entities that live in a global database. These APIs interact with entities that are not region specific and therefore do not have any regional boundaries. For example, identity management and IdP settings are all region-agnostic configurations applied to the organization as a whole.

The region-specific endpoints are used to manage {{site.konnect_short_name}} entities that live in a specific {{site.konnect_short_name}} region. These APIs interact with entities specific to a region and do not have the ability to cross regional boundaries. For example, control planes, data plane nodes, and API product listings are all region-specific entities and therefore must use the region-specific endpoint.


{:.note .no-icon }
> <span class="badge beta"></span> **A beta API spec for the Control Plane Configuration API is now available!**
>
| Spec | Developer portal link | Insomnia link |
|------|-----------------------|---------------|
| Konnect control plane configuration beta API spec |[Developer Portal](https://developer.konghq.com/spec/3c38bff8-3b7b-4323-8e2e-690d35ef97e0/16adcd15-493a-49b2-ad53-8c73891e29bf)  | <a href="https://insomnia.rest/run/?label=Runtime%20Groups%20Configuration%20API&uri=https%3A%2F%2Fraw.githubusercontent.com%2FKong%2Fdocs.konghq.com%2Fmain%2Fapi-specs%2FKonnect%2Fv2%2Fjson%2Fkonnect-2.json" target="_blank"><img src="https://insomnia.rest/images/run.svg" alt="Run in Insomnia"></a>|

## Authentication

The recommended method of authentication for {{site.konnect_short_name}} is [Personal Access Token (PAT)](/konnect/gateway-manager/declarative-config/#generate-a-personal-access-token), which can be obtained from the [personal access token page](https://cloud.konghq.com/global/account/tokens) in {{site.konnect_short_name}}. The PAT must be passed in the `Authorization` header of all requests, for example: 

`curl -X GET 'https://global.api.konghq.com/v2/users/' --header 'Authorization: Bearer kpat_xgfT'`


## API reference documentation

* [Identity Management API](https://developer.konghq.com/spec/5175b87f-bfae-40f6-898d-82d224387f9b/d0e13745-db5c-42d5-80ae-ef803104f5ce) - Interface for management of users, teams, team memberships and role assignments.

* [Control Plane API](https://developer.konghq.com/spec/cd849478-4628-4bc2-abcd-5d8a83d3b5f2/24c1f98b-ea51-4277-9178-ca28a6aa85d9/) - Interface for managing control planes.

* [Portal RBAC API Documentation](https://developer.konghq.com/spec/2dad627f-7269-40db-ab14-01264379cec7/) - Interface for portal developers, teams, and RBAC rules.

* [Control Plane Configuration API](https://developer.konghq.com/spec/3c38bff8-3b7b-4323-8e2e-690d35ef97e0/) - Interface for creating and managing control plane certificates, data plane certificates, and {{site.konnect_short_name}} entities.

* [Portal Client API](https://developer.konghq.com/spec/2aad2bcb-8d82-43b3-abdd-1d5e6e84dbd6/b4539157-4ced-4df5-affa-7d790baee356) - Interface for building and integrating custom Dev Portal experiences using {{site.konnect_short_name}} API data.

{:.note}
> **Note**: This list represents the APIs supported for use in production environments. 

## More information

* The Konnect API supports filtering, read the [filtering reference](/konnect/api/filtering/) to learn more.
