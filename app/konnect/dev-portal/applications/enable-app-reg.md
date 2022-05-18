---
title: Enable or Disable Application Registration for a Service
no_version: true
---


To grant developers access to [register an application](/konnect/dev-portal/applications/dev-reg-app-service), you must enable application registration on a Service Version.
When you enable application registration, {{site.konnect_saas}} enables two plugins automatically: [ACL](/hub/kong-inc/acl), and either [Key Authentication](/hub/kong-inc/key-auth)
or [OIDC](/hub/kong-inc/openid-connect). These plugins run in the background to support application registration for the Service and are managed by
{{site.konnect_saas}}. Once enabled, you can [disable application registration](#disable)
at any time.

This guide walks you through the two supported authentication plugins:
- [Key Authentication](#konnect-key-auth-flow)
- [OpenID Connect](#oidc-flow)


## Prerequisites

- The Services have been created, versioned, and published to the
  {{site.konnect_short_name}} Dev Portal so that they appear in the catalog.

- The Service version must have an [implementation](/konnect/configure/servicehub/manage-services/#service-version-implementations)

- If you are using [OpenID Connect](#oidc-flow) for your authorization:

  - Set up your application, claims, and scopes in your OpenID identity provider as
    appropriate for your requirements. Refer to your IdP/OP documentation for instructions.

  - Be sure to edit the **Reference ID** field in the Dev Portal
    [Update Application](/konnect/dev-portal/applications/dev-apps#edit-my-app)
    dialog to match to your third-party OAuth2 claim.

{:.note}
> **Note:** Please refer to the [declarative guide](/konnect/configure/runtime-manager/runtime-groups/declarative-config) for instructions on declarative configuration.

## Enable app registration with key authentication {#konnect-key-auth-flow}

1. From the {{site.konnect_short_name}} menu, click {% konnect_icon servicehub %} **Service Hub** and select a
Service. Now, click the **Versions** button and select the desired version.

2. Click **Version actions** > **Enable app registration**.

3. Select `key-auth` from the **Auth Type** list.
  Optionally, click to enable [**Auto Approve**](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps/) for application
  registrations for the selected Service.

4. Click **Enable**.

    With app registration enabled, all versions of this service now include
    read-only entries for the `acl` and `key-auth` plugins.

## Enable App Registration with OpenID Connect {#oidc-flow}

1. From the {{site.konnect_short_name}} menu, click {% konnect_icon servicehub %} **Service Hub** and select a
Service. Now, click the **Versions** button and select the desired version.

2. Click **Version actions** > **Enable app registration**.

3. Select `openid-connect` from the **Auth Type** list.

   Refer to the [configuration parameters section](#openid-config-params) for information
   about each field.


4. Click **Enable**.

    With app registration enabled, all versions of this service now include
    read-only entries for the `acl` and `oidc` plugins.

###  OpenID Connect Configuration Parameters {#openid-config-params}

   | Form Parameter | Description                                                                       |
   |:---------------|:----------------------------------------------------------------------------------|
   | `Issuer` | The issuer URL from which the OpenID Connect configuration can be discovered. For example: `https://dev-1234567.okta.com/oauth2/default`. Required. |
   | `Scopes` | The scopes to be requested from your OP (OpenID Provider). Enter one or more scopes separated by spaces, such as `open_id` `myscope1`. Optional. |
   | `Consumer claims` |  Name of the claim that is used to find a consumer. Required. |
   | `Auth method` | The supported authentication method or methods you want to enable. This field should contain only the authentication methods that you need to use; otherwise, you unnecessarily widen the attack surface. Separate multiple entries with a comma. Available options: `password`, `client_credentials`, `authorization_code`, `bearer`, `introspection`, `kong_oauth2`, `refresh_token`, `session`. Required. |
   | `Hide Credentials` | Whether to show or hide the credential from the Upstream service. If enabled, the plugin strips the credential from the request (in the header, query string, or request body that contains the key) before proxying it. Default: disabled. Optional.|
   | `Auto Approve` | Automatically approve developer registration requests for an application. A Konnect admin does not need to [manually approve](/konnect/dev-portal/applications/manage-app-reg-requests/) application registration requests. Default: disabled. Optional. |

   For more background information about OpenID Connect plugin parameters, see
   [Important Configuration Parameters](/hub/kong-inc/openid-connect/#important-configuration-parameters).

## Disable App Registration for a Service {#disable}

To disable or delete a plugin that was enabled by app registration,
you must disable app registration itself. You can't use the toggle in the
Plugins pane on a Service version, as the toggle is unavailable for
{{site.konnect_short_name}}-managed plugins.

You can
[re-enable application registration](/konnect/dev-portal/applications/enable-app-reg)
at any time.

### Disable app registration

1. From the {{site.konnect_short_name}} menu, click **Services** and select a Service.

1. From the **Service** menu, select **Version** to display all of the registered versions.

1. Click the Version you intend to disable.

1. Click **Version actions** > **Disable app registration**.
