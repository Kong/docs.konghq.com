---
title: Konnect APIs
content-type: explanation
---

## Base URLs

There are two types of base URLs that are used in {{site.konnect_short_name}} APIs:

* Global: https://global.api.konghq.com 

* Region specific: https://{REGION_CODE}.api.konghq.com

The global endpoint is used to manage region-agnostic {{site.konnect_short_name}} entities that live in a global database. These APIs interact with entities that are not region specific and therefore do not have any regional boundaries. For example, identity management and IdP settings are all region-agnostic configurations applied to the organization as a whole.

The region-specific endpoints are used to manage {{site.konnect_short_name}} entities that live in a specific {{site.konnect_short_name}} region. These APIs interact with entities specific to a region and do not have the ability to cross regional boundaries. For example, runtime groups, service listings are all region-specific entities and therefore must use the region-specific endpoint.

## Authentication

The recommended method of authentication for {{site.konnect_short_name}} is [Personal Access Token (PAT)](/konnect/runtime-manager/runtime-groups/declarative-config/#generate-a-personal-access-token), which can be obtained from the [personal access token page](https://cloud.konghq.com/global/tokens) in {{site.konnect_short_name}}. The PAT must be passed in the `Authorization` header of all requests, for example: 

`curl -X GET 'https://global.api.konghq.tech/v2/users/' --header 'Authorization: Bearer kpat_xgfT'`


## API reference documentation

* [Identity Management API](https://developer.konghq.com/spec/5175b87f-bfae-40f6-898d-82d224387f9b/d0e13745-db5c-42d5-80ae-ef803104f5ce) - Interface for management of users, teams, team memberships and role assignments.

* [Runtime Groups API](https://developer.konghq.com/spec/cd849478-4628-4bc2-abcd-5d8a83d3b5f2/24c1f98b-ea51-4277-9178-ca28a6aa85d9/) - Interface for managing runtime groups and certificates.


## More information

* The Konnect API supports filtering, read the [Filtering reference](/konnect/api/filtering/) to learn more.