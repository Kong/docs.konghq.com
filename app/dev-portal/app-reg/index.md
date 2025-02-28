---
title: Self-Service Developer & Application Registration
content_type: concepts
---

Konnect Dev Portal provides a variety of flexible options for controlling access to content and APIs. When combined with a Gateway Service, Developers visiting a Dev Portal can register, create an Application, and retrieve API keys without any necessary intervention.

### Region specific applications
Enabling application registration is specific to the [geographic region](/konnect/geo). 
You must enable application registration in each geo that you want to allow developers to register with.
Each geo has its own portal, API keys, and specifications for application registration.

### Konnect Application Auth plugin

When an authentication strategy is applied during [publishing an API](/dev-portal/apis), {{site.konnect_saas}} enables the Konnect Application Auth (KAA) plugin on the Gateway Service automatically to support the desired mode: key authentication or OpenID Connect (OIDC).

{:.note}
> *The Konnect Application Auth (KAA) plugin added to the Gateway Service is read-only and not configurable outside of the Dev Portal UI & APIs.*

### Authentication strategies

{{site.konnect_short_name}} provides the capability to configure and implement a range of authentication strategies. Utilizing the OpenID Connect authentication strategy allows for specific permissions to be set within your Identity Provider (IdP). This system offers the versatility to either apply a unified authentication strategy across all API Products or to designate a unique authentication strategy to individual API Products.
<!--vale off-->
{% mermaid %}
flowchart TB
    subgraph Staging Portal
    WeatherAPIv1["Weather API v1"] --> key-auth
    WeatherAPIv2["Weather API v2"] --> okta-oidc
    MapsAPIv2-1["Maps API v2"] --> okta-oidc
    end
    subgraph Production Portal
    WeatherAPIv3["Weather API v3"] --> okta-dcr
    MapsAPIv2-2["Maps API v2"] --> auth0-oidc
    end

{% endmermaid %}
<!--vale on-->

<!-- "auth configs" shows up here as a new term without explainiation. Is this really different than authentication strategy? It should either be defined or we should rewrite to use strategy instead. -->

{:.note}
> *Auth Configs are independently configured entities, meaning they can be used by multiple APIs (for example, Weather API v2 and Maps API v2 in Staging Portal both use the Okta OIDC config). Independently configured Auth Configs also give you the flexibility to configure the same API to use different auth strategies in different portals. For example, Maps v2 uses the Okta OIDC Auth Config in the Staging Portal, and the Auth0 OIDC Auth Config in the Production portal.*

{:.note}
> *Developers are limited to using a single auth strategy per application. For example, they can create an application to register for both Weather v2 and Maps v2, as both employ `okta-oidc`, however, registering for Weather v1 and Weather v2 requires two separate applications due to their differing auth configurations.*

## Prerequisites

<!-- link to gw manager in the first bullet? -->

- A version 3.6+ Gateway Service configured in Konnect Gateway Manager,
- [Linked to a portal API](/dev-portal/apis/gateway-service-link), and
- [Published to a Dev Portal](/dev-portal/portals/publishing).

{:.note}
> *An API must be linked to a Konnect Gateway Service (version 3.6+) to be able to restrict access to your API with Authentication Strategies.*

### Dev Portal Security Settings and defaults

In [**Settings/Security**](/dev-portal/portals/settings/security) for each portal, make appropriate choices to setup Developer & Application registration for your needs.

{:.note}
> *When a new Dev Portal is created, if **Private** is selected, **User Authentication** will automatically be enabled, and **key auth** will be the default Application Auth Strategy.

1. Enable **User Authentication** to allow developers to register their applications to access APIs.

2. Optional: Enable **Role-based access control (RBAC)** to control viewing/consuming of APIs in the Dev Portal by defining roles within Teams.

3. Optional: Click the [**Auto Approve**](/dev-portal/settings/security/) checkbox for Developers and/or Applications to automatically approve all registration requests. Otherwise portal admins will need to approve all registrations.

4. Optional: Select the preferred **Default Auth Strategy** (default is Konnect's built-in `key-auth`). This will not retroactively change any published APIs, but will set the default on any new published APIs.

### Get started
* [Key Auth](/dev-portal/app-reg/auth-strategies/key-auth)
* [OIDC](/dev-portal/app-reg/auth-strategies/oidc)
* DCR: Coming soon!