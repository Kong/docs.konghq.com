---
title: Enable or Disable Application Registration for an API Product Version
content_type: how-to
---

To grant developers access to [register an application](/konnect/dev-portal/applications/dev-reg-app-service/), you must enable application registration for an API product version.
When you enable application registration, {{site.konnect_saas}} enables plugins automatically to support the desired mode, either key authentication or OpenID Connect.
These plugins run inside the data plane to support application registration for the API product version and are managed by
{{site.konnect_saas}}.

Enabling application registration is specific to the [geographic region](/konnect/geo). 
You must enable application registration in each geo that you want to allow developers to register with.
Each geo has their own API keys and specifications for application registration in their respective geo.

## Support for any control plane

App registration is fully supported in the `default` control plane when using the application `consumers` and the `acl` plugin. The `default` control plane is the one that is first created in each region when you create an organization.
For non-`default` control planes, app registration is supported using the `konnect-application-auth` plugin available as of {{site.base_gateway}} 3.0.

{:.note}
> **Note:**  Although it can be renamed, the [`default` control plane group](/konnect/gateway-manager/control-plane-groups/) will always be the first and oldest control plane group in each region.

## Prerequisites

- An API product that is versioned and published to the
  {{site.konnect_short_name}} Dev Portal so that it appears in the catalog.

- If you are using [OpenID Connect](#oidc-flow) for your authorization:

  - Set up your application, claims, and scopes in your OpenID identity provider. Refer to your IdP/OP provider's documentation for instructions.

  - Edit the **Reference ID** field in the Dev Portal
    [Update Application](/konnect/dev-portal/applications/dev-apps#edit-my-app)
    dialog to match to your third-party OAuth2 claim.

{:.note}
> **Note:** Generally, it's only recommended for an API product version to be linked to a Gateway service. However, for app registration to work, the link between API product version and a Gateway service is required. 

## Enable app registration with key authentication {#key-auth-flow}

To enable app registration with key authentication, from the {{site.konnect_short_name}} menu, click {% konnect_icon api-product %} **API Products**, select a
service, and follow these steps:

1. Click **Product Versions** to select a version.

2. Select **Disabled** under **App Registration**

3. Select `key-auth` from the **Auth Type** list.

4. Optional: click to enable [**Auto Approve**](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps/) for application registration requests.

5. Click **Enable**.

    This version of the API products now includes a
    read-only entry for the `konnect-application-auth` plugin.

{:.note}
> **Note:** If the API product version is in the `default` control plane group, it will
instead receive read-only entries for the `acl` and `key-auth` plugins to provide
support for {{site.base_gateway}} versions less than 3.0.

## Enable app registration with OpenID Connect {#oidc-flow}

To enable app registration with OpenID Connect, from the {{site.konnect_short_name}} menu, click {% konnect_icon api-product %} **API Products**, select a
service, and follow these steps:


1. Click **Versions** to select a version.

2. Select **Disabled** under **App Registration**

3. Select `openid-connect` from the **Auth Type** list.

   Refer to the [configuration parameters section](#openid-config-parameters) for information
   about each field.

4. Click **Enable**.

    This versions of this service packages now includes
    read-only entries for the `konnect-application-auth` and `openid-connect` plugins.

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

   
## Disable application registration for a service {#disable}

Disabling application registration removes all plugins that were initially enabled through application registration for this service.
To remove a plugin by disabling application registration, follow these steps:

1. Click a service to open the **Service** menu.

2. From the **Service** menu, select **Version** to display all of the registered versions.

3. Click the version you intend to disable.

4. From the **Version actions** drop-down menu, select **Disable app registration**.

5. Click **Disable** from the pop-up modal.


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
