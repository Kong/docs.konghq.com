---
title: Self-Service Developer & Application Registration
content_type: concepts
---

Konnect Dev Portal provides flexible options for controlling access to content and APIs. When combined with a Gateway Service, Developers visiting a Dev Portal can sign up, create an Application, register it with an API, and retrieve API keys without any necessary intervention by Dev Portal administrators. Developer signups and Applications creation require admin approvals by default, which can be changed in Settings/Security.

Application registration can be provided by enabling User Authentication (and optionally Role-based Access Control), linking an API to a Gateway Service (version 3.6+) and then selecting an authentication strategy when publishing the API to a Dev Portal.


### Region specific applications

The Applications and API keys that enable self-service application registration are specific to a [geographic region](/konnect/geo). When an authentication strategy is selected during publication and application registration enabled, the resulting Applications and API keys are specific to the developers in that region.

### Konnect Application Auth plugin

When an authentication strategy is selected during [publishing an API](/dev-portal/apis) to a Dev Portal, {{site.konnect_saas}} will automatically enable and configure the Konnect Application Auth (KAA) plugin on a linked Gateway Service.

Konnect will configure the Konnect Application Auth (KAA) plugin on the linked Gateway Service to use the desired mode: key authentication, Open ID Connect (OIDC), or Dynamic Client Registration (DCR) (DCR coming soon to Beta). This Gateway Service Plugin will prevent unauthenticated usage of the API except by Applications created in the Dev Portal.

If there is no Gateway Service linked to an API when User Authentication is enabled, the configuration is saved and will be applied once a Gateway Service is linked. Likewise, if a Gateway Service is unlinked, the configuration will be removed from that service, and applied to a new service when it is linked.

{:.note}
> *The Konnect Application Auth (KAA) plugin added to the Gateway Service is read-only and not configurable outside of the Dev Portal UI & APIs.*

### Authentication strategies

{{site.konnect_short_name}} provides the capability to configure and implement a range of authentication strategies. Utilizing the OpenID Connect authentication strategy allows for specific permissions to be set within your Identity Provider (IdP). This system offers the versatility to either apply a unified authentication strategy across all API Products or to designate a unique authentication strategy to individual API Products.

As an example, consider an organization with four authentication strategies defined:

* The default `key-auth` strategy that ships with {{site.konnect_short_name}}
* An Okta OIDC strategy `okta-oidc`
* An Okta DCR strategy `okta-dcr`
* An Auth0 OIDC strategy `auth0-oidc`

Along with these, the organization has three APIs, Weather API v1, Weather API v2, and Maps API v2. Finally, the organization has two Dev Portals, Staging and Production.

The following configuration is possible with these building blocks:

* The Staging Portal has all three APIs published to it using two different authentication strategies:
  * The two APIs, Weather API v2 and Maps API v2 both use the `okta-oidc` strategy, and
  * the Weather API v1 uses the `key-auth` strategy.
* The Production Portal has two of the APIs published to it using two different authentication strategies:
  * The Weather API v2 uses the `okta-dcr` strategy, and
  * the Maps API v2 uses the `auth0-oidc` strategy.

The following diagram illustrates this "publication" configuration for application registration, with the arrows representing the authentication strategy used by each API when published to each portal:

<!--vale off-->
{% mermaid %}
flowchart TB
    subgraph Production Portal
    WeatherAPIv2p["Weather API v2"] --> okta-dcr
    MapsAPIv2-2["Maps API v2"] --> auth0-oidc
    end
    subgraph Staging Portal
    WeatherAPIv2s["Weather API v2"] --> okta-oidc
    MapsAPIv2-1["Maps API v2"] --> okta-oidc
    WeatherAPIv1["Weather API v1"] --> key-auth
    end
{% endmermaid %}
<!--vale on-->

{:.note}
> *Authentication strategies are independently configured entities, meaning they can be used by multiple APIs (for example, Weather API v2 and Maps API v2 in Staging Portal both use the Okta OIDC config). Independently configured authentication strategies also give you the flexibility to configure the same API to use different auth strategies in different portals. For example, Maps API v2 uses the Okta OIDC strategy in the Staging Portal, and the Auth0 OIDC Auth Config in the Production Portal.*

{:.note}
> *Developers are limited to using a single auth strategy per application. For example, they can create an application to register for both Weather v2 and Maps v2, as both employ `okta-oidc`, however, registering for Weather APIv1 and Weather API v2 requires two separate applications due to their differing authentication strategies.*

## Prerequisites

<!-- link to gw manager in the first bullet? -->

- A version 3.6+ Gateway Service configured in Konnect Gateway Manager,
- [API linked to Gateway Service](/dev-portal/apis/gateway-service-link), and
- [Published to a Dev Portal](/dev-portal/portals/publishing).

{:.note}
> *An API must be linked to a Konnect Gateway Service (version 3.6+) to be able to restrict access to your API with Authentication Strategies.*

### Dev Portal security settings and defaults

In [**Settings/Security**](/dev-portal/portals/settings/security) for each portal, make appropriate choices to setup Developer & Application registration for your needs.

{:.note}
> *When a new Dev Portal is created, if **Private** is selected, **User Authentication** will automatically be enabled, and **key auth** will be the default Application Auth Strategy.

{:.note}
> *If you would like anonymous/not-logged-in users to be able to see some content, and logged in users to have more access, select **Private** and adjust visibility settings on the APIs and Pages during publishing to make them viewable publicly. Consider using Role-based access control (RBAC, see below) for more granular control for logged-in users.

1. Enable **User Authentication** to allow developers to register their applications to access APIs. Application registration is not possible with anonymous/not-logged-in users.

2. Optional: Enable **Role-based access control (RBAC)** to allow granular control of viewing and consuming APIs in the Dev Portal by defining roles within Teams.

3. Optional: Click the [**Auto Approve**](/dev-portal/settings/security/) checkbox to enable new Developers registrations and/or thier Applications to be approved automatically by the system. If not set, portal admins will need to approve any new registrations and/or applications.

4. Optional: Select the preferred **Default Auth Strategy** (default is the built-in `key-auth` strategy). This will not retroactively change any published APIs, but will set the default on any new publications.

### Get started
* [Key Auth](/dev-portal/app-reg/auth-strategies/key-auth)
* [OIDC](/dev-portal/app-reg/auth-strategies/oidc)
* DCR: Coming soon!
