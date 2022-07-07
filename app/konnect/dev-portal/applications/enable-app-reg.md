---
title: Enable or Disable Application Registration for a Service
no_version: true
content-type: how-to
---

To grant developers access to [register an application](/konnect/dev-portal/applications/dev-reg-app-service), you must enable application registration for a service version.
When you enable application registration, {{site.konnect_saas}} enables two plugins automatically: [ACL](/hub/kong-inc/acl), and your choice of [Key Authentication](/hub/kong-inc/key-auth)
or [OIDC](/hub/kong-inc/openid-connect). These plugins run in the background to support application registration for the service and are managed by
{{site.konnect_saas}}.

## Prerequisites

- A service that is versioned and published to the
  {{site.konnect_short_name}} Dev Portal so that it appears in the catalog.

- The service version must be in the `default` runtime group.
- The service version must have an [implementation](/konnect/servicehub/service-implementations).

- If you are using [OpenID Connect](#oidc-flow) for your authorization:

  - Set up your application, claims, and scopes in your OpenID identity provider. Refer to your IdP/OP provider's documentation for instructions.

  - Edit the **Reference ID** field in the Dev Portal
    [Update Application](/konnect/dev-portal/applications/dev-apps#edit-my-app)
    dialog to match to your third-party OAuth2 claim.

{:.note}
> **Note:** For instructions on configuring {{site.konnect_short_name}} declaratively, read our [declarative guide](/konnect/runtime-manager/runtime-groups/declarative-config).


## Enable app registration with key authentication {#key-auth-flow}

To enable app registration with key authentication, from the {{site.konnect_short_name}} menu, click {% konnect_icon servicehub %} **Service Hub**, select a
service, and follow these steps: 

1. Click **Versions** to select a version.

2. From the **Version actions** drop-down menu, select **Enable app registration**.

3. Select `key-auth` from the **Auth Type** list.

4. Optional: click to enable [**Auto Approve**](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps/) for application registration requests.

5. Click **Enable**.

    All versions of this service now include
    read-only entries for the `acl` and `key-auth` plugins.

## Enable app registration with OpenID Connect {#oidc-flow}

To enable app registration with OpenID Connect, from the {{site.konnect_short_name}} menu, click {% konnect_icon servicehub %} **Service Hub**, select a
service, and follow these steps: 


1. Click **Versions** to select a version.

2. From the **Version actions** drop-down menu, select **Enable app registration**.

3. Select `openid-connect` from the **Auth Type** list.

   Refer to the [configuration parameters section](#openid-config-parameters) for information
   about each field.

4. Click **Enable**.

    All versions of this service now include
    read-only entries for the  `acl` and `oidc` plugins.

###  OpenID Connect configuration parameters {#openid-config-parameters}

   | Form Parameter | Description                                                                       |Required |
   |:---------------|:----------------------------------------------------------------------------------|--|
   | `Issuer` | The issuer URL from which the OpenID Connect configuration can be discovered. For example: `https://dev-1234567.okta.com/oauth2/default`.  |**True** |
   | `Scopes` | The scopes to be requested from the OpenID Provider. Enter one or more scopes separated by spaces, for example: `open_id` `myscope1`.  | **False**
   | `Consumer claims` |  Name of the claim that is used to find a consumer. | **True**
   | `Auth method` | The supported authentication method(s) you want to enable. This field should contain only the authentication methods that you need to use. Individual entries must be separated by commas. Available options: `password`, `client_credentials`, `authorization_code`, `bearer`, `introspection`, `kong_oauth2`, `refresh_token`, `session`. | **True**
   | `Hide Credentials` |**Default: disabled**<br>  Hide the credential from the upstream service. If enabled, the plugin strips the credential from the request header, query string, or request body, before proxying it. | **False** |
   | `Auto Approve`| **Default: disabled** <br>Automatically approve developer application requests for an application.| **False**

   For more background information about OpenID Connect plugin parameters, see
   [Important Configuration Parameters](/hub/kong-inc/openid-connect/#important-configuration-parameters).

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