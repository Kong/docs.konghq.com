---
title: Enable or Disable Application Registration for an API Product Version
content_type: how-to
---

To grant developers access to [register an application](/konnect/dev-portal/applications/dev-apps/), you must apply an authentication strategy and enable application registration for an API product version. 
When you apply an auth strategy, {{site.konnect_saas}} enables plugins automatically to support the desired mode, either key authentication or OpenID Connect.
These plugins run inside the data plane to support application registration for the API product version and are managed by
{{site.konnect_saas}}.

Enabling application registration is specific to the [geographic region](/konnect/geo). 
You must enable application registration in each geo that you want to allow developers to register with.
Each geo has their own API keys and specifications for application registration in their respective geo.

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
Auth Configs are independently configured entities, meaning they can be used by multiple API Products (for example, Weather API v2 and Maps API v2 in Staging Portal both use the Okta OIDC config). Independently configured Auth Configs also give you the flexibility to configure the same API Product version to use different auth strategies in different portals. For example, Maps v2 uses the Okta OIDC Auth Config in the Staging Portal, and the Auth0 OIDC Auth Config in the Production portal.

Developers are limited to using a single auth strategy per application. For example, they can create an application to register for both Weather v2 and Maps v2, as both employ `okta-oidc`, however, registering for Weather v1 and Weather v2 within the same application isn't possible due to their differing auth configurations.

## Support for any control plane

App registration is fully supported in the `default` control plane when using the application `consumers` and the `acl` plugin. The `default` control plane is the one that is first created in each geo when you create an organization.
For non-`default` control planes, app registration is supported using the `konnect-application-auth` plugin available as of {{site.base_gateway}} 3.0.

{:.note}
> **Note:**  Although it can be renamed, the [`default` control plane group](/konnect/gateway-manager/control-plane-groups/) will always be the first and oldest control plane group in each geo.

## Prerequisites

- [An API product that is versioned and published to a {{site.konnect_short_name}} Dev Portal](/konnect/dev-portal/publish-service).

- If you are using [OpenID Connect](#oidc-flow), set up your application, claims, and scopes in your OpenID identity provider. 

{:.note}
> **Note:** Generally, it's only recommended for an API product version to be linked to a Gateway service. However, for app registration to work, the link between API product version and a Gateway service is required. 

## Enable app registration with key authentication {#key-auth-flow}

1. In {% konnect_icon api-product %} **API Products**, select an API product.

1. Click **Product Versions** and select a product version.

  {:.note}
  > **Note:** If the API product version is in the `default` control plane group, it will
  instead receive read-only entries for the `acl` and `key-auth` plugins to provide
  support for {{site.base_gateway}} versions less than 3.0.

1. From the **Dev Portals** tab, click **Publish to Dev Portals**.

1. Enable **Require Authentication** then do one of the following:
  * If your API product is already published to a Dev Portal, select **key-auth** in the Auth Strategy menu for that Dev Portal. 
  * If your API product is not published, add a **Dev Portal**, select the target Dev Portal in the menu, and then select **Key Auth** in the Auth Strategy menu.

1. Enable **Accept application registrations** for each Dev Portal to allow developers to register their applications to consume this API.

5. Optional: Click the [**Auto Approve**](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps/) checkbox if you want to automatically approve all application registration requests.

1. Click **Save**.

## Enable app registration with OpenID Connect {#oidc-flow}

To enable app registration with OpenID Connect, from the {{site.konnect_short_name}} menu, click {% konnect_icon api-product %} **API Products**, select an API product, and follow these steps:

If you already have an OIDC Auth Strategy created in the **Application Auth**:

1. In your API Product, click **Product Versions** to select a version.

1. From the **Dev Portals** tab, click **Publish to Dev Portals**.

1. Enable **Require Authentication** then do one of the following:
  * If your API product is already published to a Dev Portal, select OIDC in the Auth Strategy menu for that Dev Portal. 
  * If your API product is not published, add a **Dev Portal**, select the target Dev Portal in the menu, and then select OIDC in the Auth Strategy menu.

1. Enable **Accept application registrations** for each Dev Portal to allow developers to register their applications to consume this API.

5. Optional: Click the [**Auto Approve**](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps/) checkbox if you want to automatically approve all application registration requests.

1. Click **Save**.

If you do _not_ already have an OIDC Auth Strategy created, we will first create an OIDC Auth strategy, and then apply it to our API product:


1. In the Dev Portal menu, navigate to the **Application Auth** tab. Click **New Auth Strategy** to create an auth strategy. Refer to the [configuration parameters section](#openid-config-parameters) for more information about each field.

2. Enter a name to be seen only in {{site.konnect_short_name}} and a display name that will be displayed on your Dev Portal.

3. In the Auth Type dropdown menu select **OpenID-Connect**. Enter the Issuer URL for your OIDC tenant.

4. Enter any scopes your developers may need access to (e.g. openid, profile, email, etc). Note the required scopes may differ depending on your IdP.

5. Enter the Credential Claims which will match the client ID of the corresponding application in your IdP.

6. Select the relevant Auth Methods you need (for example: `client_credentials`, `bearer`, `session`).

7. Click **Save**

8. In your API Product, click **Product Versions** to select a version.

1. From the **Dev Portals** tab, click **Publish to Dev Portals**.

1. Enable **Require Authentication** then do one of the following:
  * If your API product is already published to a Dev Portal, select OIDC in the Auth Strategy menu for that Dev Portal. 
  * If your API product is not published, add a **Dev Portal**, select the target Dev Portal in the menu, and then select OIDC in the Auth Strategy menu.

1. Enable **Accept application registrations** for each Dev Portal to allow developers to register their applications to consume this API.

5. Optional: Click the [**Auto Approve**](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps/) checkbox if you want to automatically approve all application registration requests.

1. Click **Save**.







{:.note}
> **Note:** If the API product version is in the `default` control plane group, it will
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

   
## Enable app registration with multiple IdPs

In {{site.konnect_short_name}} can configure and manage multiple authentication strategies across various API products and their versions, allowing you to apply distinct authentication scopes for different API versions.

This section will introduce you to the functionality portal product versions using Dynamic client registration (DCR). Using the Application Registration API, you can manage multiple APIs and configure a different DCR on a per API product basis.

Using the [`product-versions`](/konnect/api/portal-management/latest/#/Portal%product%version/#/create-portal-product-version) endpoint, you can link authentication strategies with your API products. 

1. Configure the auth strategies of your choice:
  * [Okta](/konnect/dev-portal/applications/dynamic-client-registration/okta/)
  * [Curity](/konnect/dev-portal/applications/dynamic-client-registration/curity/)
  * [Auth0](/konnect/dev-portal/applications/dynamic-client-registration/auth0/)
  * [Azure](/konnect/dev-portal/applications/dynamic-client-registration/azure/)
  * [Custom IdP](/konnect/dev-portal/applications/dynamic-client-registration/custom/)

1. Before making a request to this endpoint, ensure you have gathered the following details from the previous step:
  * `portalId`: ID of the Dev Portal
  * `product_version_id`: API Product version ID.
  * `auth_strategy_id`: The ID of the auth strategy you configured.

1. Apply the auth strategy to your API, making sure to replace `your_product_version_id` and `your_auth_strategy_id` with the actual IDs you intend to use: 

  ```bash
  curl --request POST \
    --url https://us.api.konghq.com/v2/portals/{portalId}/product-versions/ \
    --header 'Authorization: $KPAT' \
    --header 'content-type: application/json' \
    --data '{
    "product_version_id": "your_product_version_id",
    "auth_strategy_ids": [
      "your_auth_strategy_id"
    ],
    "publish_status": "published",
    "application_registration_enabled": true,
    "auto_approve_registration": true,
    "deprecated": false
  }
  ```

Executing this request does the following: 

* Published API Product Versions: This makes the latest iterations of these APIs available to developers through the Dev Portal.

* Enabled Application Registration: Developers can now register for access to your API. This allows them to integrate this API into their own apps.

* Configured Authentication Strategies: The auth strategies you configured are now all applied to your published API.

{:.note}
>**Note**: If your API Products are not yet published, you will need to publish the API Product itself in order for the API Product versions to be published to your Dev Portal.

## Disable application registration for an API Product version {#disable}

Disabling application registration ensures Dev Portal developers can no longer request new registrations for the API product version. Existing registrations are not affected.
To remove a plugin by disabling application registration, follow these steps:

1. Select an API Product from the **API Product** menu

2. Select **Product Versions** to display all of relevant versions

3. Click the version you intend to disable

4. Select **Enabled** under **App Registration**

5. Toggle the **Application Registration Enabled** button to be **False**

6. Click **Save** to apply your changes

## Remove an Auth Strategy from an API Product Version

Removing an auth strategy from a product version removes the plugins that were initially applied when adding the auth strategy to the version. This opens the API traffic directly to any upstream if there are no other plugins to control request traffic.

To remove the auth strategy and open up API traffic, follow these steps:

1. Select an API Product from the **API Product** menu

2. Select **Product Versions** to display all of relevant versions

3. Click the version you intend to remove the auth strategy from

4. Select **Enabled** under **App Registration**

5. Remove any auth strategy selection

6. Click **Save** to apply your changes. Note: removing the auth strategy will also disable application registration for the product version.

You can
[re-enable application registration](/konnect/dev-portal/applications/enable-app-reg)
at any time.

### Differences between control plane groups

The `konnect-application-auth` plugin manages access control and API key authentication for app registration and replaces the need for the `acl` and `key-auth` plugins. It is used in every non-`default` control plane group. 

In the `default` control plane group, applications are linked to {{site.base_gateway}} consumers and use the `acl` plugin to control access between an application’s consumers and an API product version. For all other control planes, applications are not linked to {{site.base_gateway}} consumers.

### Known limitations

The internal `konnect-application-auth` plugin only supports {{site.base_gateway}} 3.0 or later. If you need to use a version of {{site.base_gateway}} before 3.0, you must create your API product version that is linked to a Gateway service in the `default` group, which still supports consumer mapping with the `acl` plugin.

The `konnect-application-auth` plugin does not connect applications to {{site.base_gateway}} consumers. Therefore, any applications created through the app registration process in any non-default control plane group won't support rate limiting plugins. This will be addressed in a future release.

If you don't use any rate limiting plugins, we recommend upgrading your data plane nodes to {{site.base_gateway}} version 3.0 or later to ensure future compatibility with the `konnect-application-auth` plugin, which has a built-in replacement for the `acl` plugin.
