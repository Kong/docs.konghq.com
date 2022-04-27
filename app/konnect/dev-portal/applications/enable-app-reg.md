---
title: Enable and Disable Application Registration for a Service
no_version: true
toc: true
---

When application registration is enabled for a Service, developers must
[register an application](/konnect/dev-portal/applications/dev-reg-app-service)
in order to access a Service.

All versions of a Service
share the same authentication strategy. When you add another version to a Service,
it inherits the automatically enabled plugins for that strategy.

Supported authentication flows are based on the following plugins:
- [Key Authentication](#konnect-key-auth-flow)
- [OpenID Connect](#oidc-flow)

When you enable application registration, the ACL plugin and your chosen authentication
plugin (Key Auth or OIDC) are enabled automatically. You can see them in a
Service version's plugin list, but can't edit or delete them directly. See the
Application Overview section on
[{{site.konnect_short_name}}-managed plugins](/konnect/dev-portal/applications/application-overview/#konnect-managed-plugins)
for more information.

{:.important}
> **Important:** Developers registered through app registration appear as
consumers on the
![icon](/assets/images/icons/konnect/konnect-shared-config.svg){:.inline .no-image-expand}
Shared Config page. Do not delete the ACLs associated with a consumer managed
by app registration.

You can [disable application registration](#disable)
any time at your discretion.

## Prerequisites

- [**Organization Admin** or **Service Admin**](/konnect/org-management/teams-and-roles)
permissions.

- The Services have been created, versioned, and published to the
  {{site.konnect_short_name}} Dev Portal so that they appear in the Catalog.

- If you are using [OpenID Connect](#oidc-flow) for your authorization:

  - Set up your application, claims, and scopes in your OpenID identity provider as
    appropriate for your requirements. Refer to your IdP/OP documentation for instructions.

  - Be sure to edit the **Reference ID** field in the Dev Portal
    [Update Application](/konnect/dev-portal/applications/dev-apps#edit-my-app)
    dialog to match to your third-party OAuth2 claim.

## Enable App Registration for the Key Authentication Flow {#konnect-key-auth-flow}

1. From the {{site.konnect_short_name}} menu, click **ServiceHub** and select a
Service. Now, click the **Versions** button and select the desired version. 

2. From the **Actions** dropdown menu, select **Enable app registration**.

3. Select `key-auth` from the **Auth Type** list.
  Optionally, click to enable **Auto Approve** for application registrations for the selected Service.

6. **Optional** click to enable **Auto Approve**.

      Any developer registration
      requests for an application are automatically approved. A {{site.konnect_short_name}}
      cloud admin does not need to
      [manually approve](/konnect/dev-portal/applications/manage-app-reg-requests/) application
      registration requests for developers.

      You can also [enable Auto Approve portal-wide](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps)
      using the Portal Settings. If Auto Approve is
      enabled or disabled portal-wide, it overrides the per Service Auto Approve setting.

4. Click **Enable**.

    With app registration enabled, all versions of this service now include
    read-only entries for the `acl` and `key-auth` plugins.

## Enable App Registration for the OpenID Connect Flow {#oidc-flow}

1. From the {{site.konnect_short_name}} menu, click **ServiceHub** and select a
Service. Now, click the **Versions** button and select the desired version. 

2. From the **Actions** menu, click **Enable app registration**.

3. Select `openid-connect` (default) from the **Auth Type** list.

   Refer to the [descriptions](#openid-config-params) in the next section for more information
   about each field.

   1. **Required** enter your issuer URL in the **Issuer** field.

   2. **Required** enter one or more scopes in the **Scopes** field.

   3. **Required** enter the claim in the **Consumer claims** field.

   4. **Required** enter one or more auth methods in the **Auth method** field.

   5. **Required** click to enable **Hide Credentials** from the upstream service.

   6. **Optional** click to enable **Auto Approve**.

      Any developer registration
      requests for an application are automatically approved. A {{site.konnect_short_name}}
      cloud admin does not need to
      [manually approve](/konnect/dev-portal/applications/manage-app-reg-requests/) application
      registration requests for developers.

      You can also [enable Auto Approve portal-wide](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps)
      using the Portal Settings. If Auto Approve is
      enabled or disabled portal-wide, it overrides the per Service Auto Approve setting.

1. Click **Enable**.

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

You can disable app registration for a Service when an API
no longer requires authentication. If you want to disable Auto Approve at the
Service level, disable app registration and then enable it again with the Auto Approve
toggle set to disabled.

**Disable application registration from the Service Version page only**.
Do not attempt to disable application registration by deleting or disabling the
read-only application registration plugins (`acl` and `key-auth` or `openid-connect`).
Attempting to remove them manually will break your Service. See the
Application Overview section on
[{{site.konnect_short_name}}-managed plugins](/konnect/dev-portal/applications/application-overview/#konnect-managed-plugins)
for more information.

You can
[enable application registration](/konnect/dev-portal/applications/enable-app-reg)
again any time.

## Disable app registration

1. From the {{site.konnect_short_name}} menu, click **Services** and select a Service.

1. From the **Actions** menu, select **Disable app registration**.

1. Click **Disable**.

## Troubleshooting

If you encounter any of the errors below that can appear in the Enable App Registration dialog,
follow the recommended solution.

| Error Message | Solution |
|------------------------------|---------------------------------------------------------------------------------|
| No Service implementation in the Service package. | Create a Service implementation. See the [example](/konnect/configure/servicehub/manage-services/#implement-service-version) in the Quickstart Guide, and the [ServiceHub](/konnect/configure/servicehub/manage-services/#implement-service-version) documentation. |
| Schema violation, config.issuer: missing host in url (openid-connect)| Be sure to include the host in the Issuer URL of your identity provider. For example: `https://dev-1234567.okta.com/oauth2/default`. |