---
title: Enable Application Registration for a Service
no_version: true
toc: true
---

When application registration is enabled for a Service, developers must
[register an application](/konnect/dev-portal/developers/dev-reg-app-service)
in order to access a Service.

All versions of a Service
share the same authentication strategy. When you add another version to a Service,
it inherits the automatically enabled plugins for that strategy.

Supported authentication flows are based on the following plugins:
- [Key Authentication](#konnect-key-auth-flow)
- [OpenID Connect](#oidc-flow)

The [ACL](/hub/kong-inc/acl) plugin is also automatically enabled in
conjunction with the `key-auth` or `OIDC` plugins. After app registration is enabled for a Service,
the `key-auth` or `OIDC` and `ACL` plugins are no longer available on the Plugins page because
they have already been enabled.

{:.important}
> **Important:** Developers registered through app registration appear as
consumers on the
![icon](/assets/images/icons/konnect/konnect-shared-config.svg){:.inline .no-image-expand}
Shared Config page. Do not delete the ACLs associated with a consumer managed
by app registration.

Plugins enabled by app registration cannot be disabled using the toggle in the **Plugins** pane
on the Services Version page. The only way to disable or delete them is to disable app registration,
which deletes all plugins that were initially enabled with application registration for a Service.
Any other plugins that were enabled manually, such as `rate-limiting`, remain enabled.

![Konnect Enable App Registration with OIDC](/assets/images/docs/konnect/konnect-enable-app-reg-oidc-toggle.png)

You can [disable application registration](/konnect/dev-portal/administrators/app-registration/disable-app-reg/)
any time at your discretion.

## Prerequisites

- [**Organization Admin** or **Service Admin**](/konnect/reference/org-management/#role-definitions)
permissions.

- The Services have been created, versioned, and published to the
  {{site.konnect_short_name}} Dev Portal so that they appear in the Catalog.

- If you are using [OpenID Connect](#oidc-flow) for your authorization:

  - Set up your application, claims, and scopes in your OpenID identity provider as
    appropriate for your requirements. Refer to your IdP/OP documentation for instructions.

  - Be sure to edit the **Reference ID** field in the Dev Portal
    [Update Application](/konnect/dev-portal/developers/dev-apps#edit-my-app)
    dialog to match to your third-party OAuth2 claim.

## Enable App Registration for the Key Authentication Flow {#konnect-key-auth-flow}

1. From the {{site.konnect_short_name}} menu, click **Services**.

   ![Konnect Services Page](/assets/images/docs/konnect/konnect-services-page.png)

2. Depending on your view, click the tile for the Service in cards view or the row
   for the Service in table view.

   ![Konnect Enable App Registration](/assets/images/docs/konnect/konnect-enable-app-reg-service-menu.png)

3. From the **Actions** menu, click **Enable app registration**.

   ![Konnect Enable App Registration with Key Authentication](/assets/images/docs/konnect/konnect-enable-app-reg-key-auth.png)

4. Select `key-auth` from the **Auth Type** list.

5. (Optional) Click to enable **Auto Approve** for application registrations for the selected Service.

   Any developer registration requests for an application are automatically approved. A {{site.konnect_saas}}
    admin does not need to
   [manually approve](/konnect/dev-portal/administrators/app-registration/manage-app-reg-requests/) application
   registration requests for developers.

   You can also [enable Auto Approve portal-wide](/konnect/dev-portal/administrators/auto-approve-devs-apps)
   using the Settings page for the Dev Portal. If Auto Approve is
   enabled portal-wide, it overrides the per-Service Auto Approve setting.

6. Click **Enable**.

    With app registration enabled, all versions of this service now include
    read-only entries for the `acl` and `key-auth` plugins.

   ![Konnect App Registration Key Auth Plugins](/assets/images/docs/konnect/key-auth-acl-plugins.png)

## Enable App Registration for the OpenID Connect Flow {#oidc-flow}

1. From the {{site.konnect_short_name}} menu, click **Services**.

2. Depending on your view, click the tile for the Service in cards view or the row
   for the Service in table view.

3. From the **Actions** menu, click **Enable app registration**.

4. Select `openid-connect` (default) from the **Auth Type** list.

   ![Konnect Enable App Registration with OpenID Connect](/assets/images/docs/konnect/konnect-enable-app-reg-oidc.png)

   Refer to the [descriptions](#openid-config-params) in the next section for more information
   about each field.

   1. (Required) Enter your issuer URL in the **Issuer** field.

   2. (Required) Enter one or more scopes in the **Scopes** field.

   3. (Required) Enter the claim in the **Consumer claims** field.

   4. (Required) Enter one or more auth methods in the **Auth method** field.

   5. (Optional) Click to enable **Hide Credentials** from the upstream service.

   6. (Optional) Click to enable **Auto Approve**.

      Any developer registration
      requests for an application are automatically approved. A {{site.konnect_short_name}}
      cloud admin does not need to
      [manually approve](/konnect/dev-portal/administrators/app-registration/manage-app-reg-requests/) application
      registration requests for developers.

      You can also [enable Auto Approve portal-wide](/konnect/dev-portal/administrators/auto-approve-devs-apps)
      using the Portal Settings. If Auto Approve is
      enabled or disabled portal-wide, it overrides the per Service Auto Approve setting.

6. Click **Enable**.

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
   | `Auto Approve` | Automatically approve developer registration requests for an application. A Konnect admin does not need to [manually approve](/konnect/dev-portal/administrators/app-registration/manage-app-reg-requests/) application registration requests. Default: disabled. Optional. |

   For more background information about OpenID Connect plugin parameters, see
   [Important Configuration Parameters](/hub/kong-inc/openid-connect/#important-configuration-parameters).

## Troubleshooting

If you encounter any of the errors below that can appear in the Enable App Registration dialog,
follow the recommended solution.

| Error Message | Solution |
|------------------------------|---------------------------------------------------------------------------------|
| No Service implementation in the Service package. | Create a Service implementation. See the [example](/konnect/servicehub/manage-services/#implement-service-version) in the Quickstart Guide, and the [ServiceHub](/konnect/servicehub/manage-services/#implement-service-version) documentation. |
| Schema violation, config.issuer: missing host in url (openid-connect)| Be sure to include the host in the Issuer URL of your identity provider. For example: `https://dev-1234567.okta.com/oauth2/default`. |
