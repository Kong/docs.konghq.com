---
title: Enable Application Registration
---

## Introduction
Application Registration allows registered developers on the Kong Developer Portal to
authenticate with supported Authentication plugins against a Service on Kong. Either {{site.base_gateway}} or
external identity provider admins can selectively admit access to Services using Kong Manager.

## Prerequisites
* {{site.ee_product_name}} is installed, version 2.1.0.0 or later. If you plan to use
key authentication, version 2.2.1.0 or later.
* Developer Portal is enabled on the same Workspace as the Service.
* The Service is created and enabled with HTTPS.
* Authentication is enabled on the Developer Portal.
* Logged in as an admin with read and write roles on applications, services, and
  developers.
* The `portal_app_auth` configuration option is configured for your OAuth provider
  and strategy (`kong-oauth2` default or `external-oauth2`). See
[Configure the Authorization Provider Strategy](/enterprise/{{page.kong_version}}/developer-portal/administration/application-registration/auth-provider-strategy) for the Portal Application Registration plugin.
* Authorization provider configured if using a supported third-party
  identity provider with the OIDC plugin:
  * For example instructions using Okta as an identity provider, refer to the
    [Okta example](/enterprise/{{page.kong_version}}/developer-portal/administration/application-registration/okta-config).
  * For example instructions using Azure AD as an identity provider, refer to the
    [Azure example](/enterprise/{{page.kong_version}}/developer-portal/administration/application-registration/azure-oidc-config).

## Enable Application Registration on a Service using Kong Manager {#enable-app-reg-plugin}

To use Application Registration on a Service, the Portal Application Registration
Plugin must be enabled on a Service.

In Kong Manager, access the Service for which you want to enable Application Registration:

1. From your Workspace, in the left navigation pane, go to **API Gateway > Services**.
2. On the Services page, select the Service and click **View**.
3. In the Plugins pane in the Services page, click **Add a Plugin**.
4. On the Add New Plugin page in the Authentication section, find the
   **Portal Application Registration** Plugin and click **Enable**.

   ![Portal Application Registration](/assets/images/docs/dev-portal/app-reg-plugin-panel.png)

5. Enter the configuration settings. Use the parameters in the next section,
   [Application Registration Configuration Parameters](#application-registration-configuration-parameters),
   to complete the fields.

   ![Create application-registration plugin](/assets/images/docs/dev-portal/create-app-reg-plugin-form.png)

   **Important:** Exposing
   the Issuer URL is essential for the
   [Authorization Code Flow](/enterprise/{{page.kong_version}}/developer-portal/administration/application-registration/3rd-party-oauth/#ac-flow)
   workflow configured for third-party identity providers.

   ![Issuer URL](/assets/images/docs/dev-portal/dev-portal-issuer-url.png)

6. Click **Create**.

### Application Registration Configuration Parameters {#app-reg-params}

| Form Parameter | Description                                                                       |
|:---------------|:----------------------------------------------------------------------------------|
| `Service` | The Service that this plugin configuration will target. Required. |
| `Tags` | A set of strings for grouping and filtering, separated by commas. Optional. |
| `Auto Approve` | If enabled, all new Service contract requests are automatically approved. Otherwise, Dev Portal admins must manually approve requests. Default: `false`. |
| `Description` | Description displayed in the information about a Service in the Developer Portal. Optional. |
| `Display Name` | Unique name displayed in the information about a Service in the Developer Portal. Required. |
| `Show Issuer` | Displays the Issuer URL in the Service Details page. Default: `false`. **Important:** Exposing the **Issuer URL** is essential for the [Authorization Code Flow](/enterprise/{{page.kong_version}}/developer-portal/administration/application-registration/3rd-party-oauth/#ac-flow) workflow configured for third-party identity providers. |

## Next steps

Kong OAuth2 strategy:

* If using the Kong-managed authorization strategy
(`kong-oauth2`) with the OAuth2 plugin, configure the Kong [OAuth2](/hub/kong-inc/oauth2/)
plugin as appropriate for your authorization requirements. You can use either the
Kong Manager GUI or cURL commands as documented on the [Plugin Hub](/hub/).
The OAuth2 plugin cannot be used in hybrid mode.
* If using the Kong-managed authorization strategy
(`kong-oauth2`) with key authentication, configure the Kong
[Key Auth](/hub/kong-inc/key-auth/) plugin as appropriate for your authorization
requirements. You can use either the
[Kong Manager GUI](/enterprise/{{page.kong_version}}/developer-portal/administration/application-registration/enable-key-auth-plugin)
or cURL commands as documented on the Plugin Hub. The Key Auth plugin
cannot be used in hybrid mode.

External OAuth2 strategy:

* If using the third-party authorization strategy
(`external-oauth2`), configure the OIDC plugin. You can use the Kong Manager GUI
or cURL commands as documented on the [Plugin Hub](/hub/kong-inc/openid-connect).
When your deployment is hybrid mode, the OIDC plugin must be configured to handle
authentication for the Portal Application Registration plugin.
