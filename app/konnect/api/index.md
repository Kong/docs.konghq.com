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

The region-specific endpoints are used to manage {{site.konnect_short_name}} entities that live in a specific {{site.konnect_short_name}} region. These APIs interact with entities specific to a region and do not have the ability to cross regional boundaries. For example, runtime groups, service listings are all region-specific entities and therefore must use the region-specific endpoint.


{:.note .no-icon }
> <span class="badge beta"></span> **A beta API spec for the runtime group configuration API is now available!**
>
| Spec | Developer portal link | Insomnia link |
|------|-----------------------|---------------|
| Konnect runtime group configuration beta API spec |[Developer Portal](/konnect/api/runtime-groups-configuration/v2/)  | <a href="https://insomnia.rest/run/?label=Runtime%20Groups%20Configuration%20API&uri=https%3A%2F%2Fraw.githubusercontent.com%2FKong%2Fdocs.konghq.com%2Fmain%2Fapi-specs%2FKonnect%2Fv2%2Fjson%2Fkonnect-2.json" target="_blank"><img src="https://insomnia.rest/images/run.svg" alt="Run in Insomnia"></a>|

## Authentication

The recommended method of authentication for {{site.konnect_short_name}} is [Personal Access Token (PAT)](/konnect/runtime-manager/declarative-config/#generate-a-personal-access-token), which can be obtained from the [personal access token page](https://cloud.konghq.com/global/account/tokens) in {{site.konnect_short_name}}. The PAT must be passed in the `Authorization` header of all requests, for example: 

`curl -X GET 'https://global.api.konghq.com/v2/users/' --header 'Authorization: Bearer kpat_xgfT'`


## API reference documentation

* [Identity Management API](/konnect/api/identity-management/v2/) - Interface for management of users, teams, team memberships and role assignments.

* [Runtime Groups API](/konnect/api/runtime-groups/v2/) - Interface for managing runtime groups.

* [Portal RBAC API Documentation](/konnect/api/portal-rbac/v2/) - Interface for portal developers, teams, and RBAC rules.

* [Runtime Configuration API](/konnect/api/runtime-groups-configuration/v2/) - Interface for creating and managing control plane certificates, data plane certificates, and {{site.konnect_short_name}} entities.

* [Portal Client API](/konnect/api/portal/v2/) - Interface for building and integrating custom Dev Portal experiences using {{site.konnect_short_name}} API data.

{:.note}
> **Note**: This list represents the APIs supported for use in production environments. 

## More information

* The Konnect API supports filtering, read the [Filtering reference](/konnect/api/filtering/) to learn more.
