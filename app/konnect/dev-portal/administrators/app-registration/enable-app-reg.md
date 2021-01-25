---
title: Enable Application Registration for a Service
no_search: true
no_version: true
toc: true
---

Enable application registration on a Service package in {{site.konnect_short_name}}.
When application registration is enabled, developers must
[register an application](/konnect/dev-portal/developers/dev-reg-app-service)
to a Service.

All versions of a Service
share the same authentication strategy. When you add another version to a Service,
it inherits the automatically enabled plugins for that strategy.

Supported authentication flows are based on the following plugins:
- [Key Authentication](#konnect-key-auth-flow)
- [OpenID Connect](#oidc-flow)

The [ACL](/hub/kong-inc/acl) plugin is also automatically enabled enabled in
conjunction with the `key-auth` or `OIDC` plugins. After app registration is enabled for a Service,
the `key-auth` or `OIDC` and `ACL` plugins are no longer available on the Plugins page because
they have already been enabled. The [Application Registration](/hub/kong-inc/application-registration)
plugin is not available on the {{site.konnect_short_name}} plugins page because it is an implicit implementation
for {{site.konnect_short_name}}, and is only applicable to {{site.ee_product_name}} as an explicit implementation.

You can [disable application registration](/konnect/dev-portal/administrators/app-registration/disable-app-reg/)
again any time at your discretion.

## Prerequisites

- Proper role permissions.

  You must be a {{site.konnect_short_name}} admin with the
  [correct roles and permissions](/konnect/reference/org-management/#role-definitions)
  to manage application connections to a Service.

  The following roles allow you to
  enable app registration for a Service:

  - Organization Admin
  - Service Admin

- The Service packages have been created, versioned, and published to the
  {{site.konnect_short_name}} Dev Portal so that they appear in the Catalog.

- If you are using [OpenID Connect](#oidc-flow) for your authorization, set up your
  application, claims, and scopes in your OpenID identity provider as appropriate for your requirements.
  Refer to your IdP/OP documentation for instructions.

## Enable App Registration for the Key Authentication Flow {#konnect-key-auth-flow}

1. From the {{site.konnect_short_name}} menu, click **Services**.

   The Services page is displayed.

   ![Konnect Services Page](/assets/images/docs/konnect/konnect-services-page.png)

2. Depending on your view, click the tile for the Service in cards view or the row
   for the Service in table view.

   The Overview page for the Service is displayed.

   ![Konnect Enable App Registration](/assets/images/docs/konnect/konnect-enable-app-reg-service-menu.png)

3. From the **Actions** menu, click **Enable app registration**.

   The Enable App Registration dialog is displayed.

   ![Konnect Enable App Registration with Key Authentication](/assets/images/docs/konnect/konnect-enable-app-reg-key-auth.png)

4. Select `key-auth` from the **Auth Type** list.

5. (Optional) Click to enable **Auto Approve**. Any developer registration
   requests for an application are automatically approved. A {{site.konnect_short_name}}
   cloud admin does not need to
   [manually approve](/konnect/dev-portal/administrators/app-registration/manage-app-reg-requests/) application
   registration requests for developers.

6. Click **Enable**.

   The status for application registration changes to **Enabled**.

   The Version information page for the service shows the `acl` and `key-auth` plugins were automatically enabled.

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

   6. (Optional) Click to enable **Auto Approve**. Any developer registration
      requests for an application are automatically approved. A {{site.konnect_short_name}}
      cloud admin does not need to
      [manually approve](/konnect/dev-portal/administrators/app-registration/manage-app-reg-requests/) application
      registration requests for developers.

6. Click **Enable**.

   The status for application registration changes to **Enabled**.

   The Version information page for the service shows the `acl` and `oidc` plugins were automatically enabled.

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
| No Service implementation in the Service package. | Create a Service implementation. See the [example](/konnect/getting-started/configure-service/#implement-a-service-version) in the getting started guide. |
| Schema violation, config.issuer: missing host in url (openid-connect)| Be sure to include the host in the Issuer URL of your identity provider. For example: `https://dev-1234567.okta.com/oauth2/default`. |
