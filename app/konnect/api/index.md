---
title: Konnect APIs
content-type: explanation
no_version: true
---

## Base URLs

There are two types of base URLs that are used in {{site.konnect_short_name}} APIs:

* Global: https://global.api.konghq.com 

* Region specific: https://{region_code}.api.konghq.com (eg: https://us.api.konghq.com)

The global endpoint is used to manage region agnostic {{site.konnect_short_name}} entities that live in a global database. These APIs interact with entities that are not region specific and therefore do not have any regional boundaries. For example, identity management and IdP settings are all region agnostic configurations applied to the organization as a whole.

The region specific endpoints are used to manage {{site.konnect_short_name}} entities that live in a specific {{site.konnect_short_name}} region. These APIs interact with entities specific to a region and do not have the ability to cross regional boundaries. For example, runtime groups, service listings are all region specific entities and therefore must use the region specific endpoint.
Identity Management API Docs

## Authorization

The recommended method of authentication for {{site.konnect_short_name}} is Personal Access Token (PAT) which can be obtained from the personal access token page in the {{site.konnect_short_name}} dashboard. The PAT must be passed in the header of all requests for example: 

`curl -X GET 'https://global.api.konghq.tech/v2/users/' --header 'Authorization: Bearer kpat_xgfT'`


## APIs

* [Identity Management API](/konnect/identity-management-api/) - Interface for management of users, teams, team memberships and role assignments.