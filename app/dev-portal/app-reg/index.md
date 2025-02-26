---
title: Self-Service Developer & Application Registration
content_type: how-to
---

## Self-Service Developer & Application Registration

Konnect Dev Portal provides a variety of flexible options for controlling access to content and APIs. When combined with a Gateway Service, Developers visiting a Dev Portal can register, create an Application, and retrieve API keys without any necessary intervention.

### Region specific applications
Enabling application registration is specific to the [geographic region](/konnect/geo). 
You must enable application registration in each geo that you want to allow developers to register with.
Each geo has their own API keys and specifications for application registration in their respective geo.

### Konnect Application Auth plugin

When an authentication strategy is applied during [publishing an API](/konnect/dev-portal/apis), {{site.konnect_saas}} enables the Konnect Application Auth (KAA) plugin in the data plane automatically to support the desired mode: key authentication or OpenID Connect (OIDC).

{:.note}
The Konnect Application Auth (KAA) plugin added to the Gateway Service is not configurable outside of Dev Portals & APIs.

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

{:.note}
Auth Configs are independently configured entities, meaning they can be used by multiple APIs (for example, Weather API v2 and Maps API v2 in Staging Portal both use the Okta OIDC config). Independently configured Auth Configs also give you the flexibility to configure the same API Product version to use different auth strategies in different portals. For example, Maps v2 uses the Okta OIDC Auth Config in the Staging Portal, and the Auth0 OIDC Auth Config in the Production portal.

{:.note}
Developers are limited to using a single auth strategy per application. For example, they can create an application to register for both Weather v2 and Maps v2, as both employ `okta-oidc`, however, registering for Weather v1 and Weather v2 within the same application isn't possible due to their differing auth configurations.

## Prerequisites

- An API that is [published to a {{site.konnect_short_name}} Dev Portal](/konnect/dev-portal/portals/publishing).

- If you are using [OpenID Connect](#oidc-flow), set up your application, claims, and scopes in your OpenID identity provider. 

- A Gateway Service configured in Konnect Gateway Manager, and [linked to the published API](/konnect/dev-portal/apis/gateway-service-link) in Dev Portal.

{:.note}
> **Note:** In order to restrict access to calling APIs, a gateway service must be linked. Developer and application registration can function and grant API keys in isolation, but without the gateway service linked, it will not actually map generated API keys to a gateway service in order to restrict access to the API. Any API keys generated in disconnected state (as they exist outside the gateway control plane) will sync to the gateway service once linked.

## Enable app registration with key authentication {#key-auth-flow}

### Dev Portal Settings and defaults

In [**Settings/Security**](/konnect/dev-portal/portals/settings/security) for each portal, make appropriate choices to setup Developer & Application registration for your needs.

{:.note}
When a new Dev Portal is created, if **Private** is selected, **User Authentication** will automatically be enabled.

1. Enable **User Authentication** to allow developers to register their applications to access APIs.

2. Optional: Enable **Role-based access control (RBAC)** to control viewing/consuming of APIs in the Dev Portal by defining roles within Teams.

3. Optional: Click the [**Auto Approve**](/konnect/dev-portal/settings/security/) checkbox for Developers and/or Applications to automatically approve all registration requests. Otherwise portal admins will need to approve all registrations.

4. Optional: Select the preferred **Default Auth Strategy** (default is Konnect's built-in `key-auth`). This will not retroactively change any published APIs, but will set the default on any new published assets.

### Publish API

1. In **Dev Portals/APIs**, select an API.

2. Click **Publish API**, select appropriate Dev Portals, and change Auth Strategy from default, if non-default is preferrred.
    
    <!--TODO: compatibility update to 3.6+ for v3 portal?-->
    {:.note}
    > **Note:** If the API is in the `default` control plane group, it will
    instead receive read-only entries for the `acl` and `key-auth` plugins to provide
    support for {{site.base_gateway}} versions less than 3.0.

3. Within your Dev Portal Settings, click **Published APIs**, and select the API. Click **API/Gateway Service**, and **Link Service**. Select the appropriate control plane and gateway service to link.


## Enable app registration with OpenID Connect {#oidc-flow}

### Create OIDC Auth Strategy

If you do _not_ already have an OIDC Auth Strategy created, we will first create an OIDC Auth strategy.

1. In the Dev Portal menu, navigate to the **Application Auth** tab. Click **New Auth Strategy** to create an auth strategy. Refer to the [configuration parameters section](#openid-config-parameters) for more information about each field.

2. Enter a name to be seen only in {{site.konnect_short_name}} and a display name that will be displayed on your Dev Portal.

3. In the Auth Type dropdown menu select **OpenID-Connect**. Enter the Issuer URL for your OIDC tenant.

4. Enter any scopes your developers may need access to (e.g. openid, profile, email, etc). Note the required scopes may differ depending on your IdP.

5. Enter the Credential Claims which will match the client ID of the corresponding application in your IdP.

6. Select the relevant Auth Methods you need (for example: `client_credentials`, `bearer`, `session`).

7. Click **Save**

8. Optional: In **Settings/Security**, select the preferred Default Auth Strategy (default is Konnect's built-in `key-auth`). This will not retroactively change any published APIs, but will change default on new publishing.


### Enable app registration with OIDC

To enable app registration with OpenID Connect for a specific API, be sure you already have an OIDC Auth Strategy created in the **Application Auth**. 

1. In {% konnect_icon api-product %} **Dev Portals/APIs**, select an API.

2. Click **Publish APIs**, select a Dev Portal, and change Auth Strategy to your OIDC-enabled Auth Strategy previously created.

3. Click **Save**.

TODO: Update for gw 3.6+?
{:.note}
> **Note:** If the published API is in the `default` control plane group, it will
instead receive read-only entries for the `acl` and `openid-connect` plugins to provide
support for {{site.base_gateway}} versions less than 3.0.

###  OpenID Connect configuration parameters {#openid-config-parameters}

In the `default` control plane group, **Credential claim** is used as a **Consumer claim** which identifies a consumer. In non-`default` control plane groups, the **Credential claim** should be mapped to a claim that contains the unique `clientId` or `applicationId` in the identity provider. For more background information about OpenID Connect plugin parameters, see [Important Configuration Parameters](/hub/kong-inc/openid-connect/#important-configuration-parameters).

   | Form Parameter | Description                                                                       |Required |
   |:---------------|:----------------------------------------------------------------------------------|--|
   | `Issuer` | The issuer URL from which the OpenID Connect configuration can be discovered. For example: `https://dev-1234567.okta.com/oauth2/default`.  |**True** |
   | `Scopes` | The scopes to be requested from the OpenID Provider. Enter one or more scopes separated by spaces, for example: `open_id` `myscope1`.  | **False**
   | `Credential claims` |  Name of the claim that maps to the unique client id in the identity provider. | **True**
   | `Auth method` | The supported authentication method(s) you want to enable. This field should contain only the authentication methods that you need to use. Individual entries must be separated by commas. Available options: `password`, `client_credentials`, `authorization_code`, `bearer`, `introspection`, `kong_oauth2`, `refresh_token`, `session`. | **True**
   | `Hide Credentials` |**Default: disabled**<br>  Hide the credential from the upstream service. If enabled, the plugin strips the credential from the request header, query string, or request body, before proxying it. | **False** |
   | `Auto Approve`| **Default: disabled** <br>Automatically approve developer application requests for an application.| **False**


<!-- TODO: DCR support before GA
## Enable app registration with multiple IdPs

In {{site.konnect_short_name}} can configure and manage multiple authentication strategies across various API products and their versions, allowing you to apply distinct authentication scopes for different API versions.

This section will introduce you to the functionality portal product versions using Dynamic client registration (DCR). Using the Application Registration, you can manage multiple APIs and configure a different DCR on a per API basis. DCR is one type of strategy for application auth, where {{site.konnect_short_name}} is integrated directly with the IdP to outsource, link, and automate the credential management using that IDP.

1. Configure the auth strategies of your choice:
  * [Okta](/konnect/dev-portal/applications/dynamic-client-registration/okta/)
  * [Curity](/konnect/dev-portal/applications/dynamic-client-registration/curity/)
  * [Auth0](/konnect/dev-portal/applications/dynamic-client-registration/auth0/)
  * [Azure](/konnect/dev-portal/applications/dynamic-client-registration/azure/)
  * [Custom IdP](/konnect/dev-portal/applications/dynamic-client-registration/custom/)

2. Apply the auth strategy to your API when [publishing](/konnect/dev-portals/portals/publishing) to the apprpriate Dev Portals.
-->