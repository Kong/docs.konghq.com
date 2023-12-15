---
title: Enable Application Registration
badge: enterprise
---

Application registration allows registered developers on the Kong Dev Portal to
authenticate with supported authentication plugins against a service on Kong. 
Either {{site.base_gateway}} or external identity provider admins can selectively 
admit access to services using Kong Manager.

## Prerequisites

* Dev Portal is enabled on the same workspace as the service.
* The service is created and enabled with HTTPS.
* Authentication is enabled on the Dev Portal.
* Logged in as an admin with read and write roles on applications, services, and
  developers.
* The `portal_app_auth` configuration option is configured for your OAuth provider
  and strategy (`kong-oauth2` default or `external-oauth2`). See
[Configure the Authorization Provider Strategy](/gateway/{{page.kong_version}}/developer-portal/administration/application-registration/auth-provider-strategy/) for the Portal Application Registration plugin.
* Authorization provider configured if using a supported third-party
  identity provider with the OIDC plugin:
  * For example instructions using Okta as an identity provider, refer to the
    [Okta example](/gateway/{{page.kong_version}}/developer-portal/administration/application-registration/okta-config/).
  * For example instructions using Azure AD as an identity provider, refer to the
    [Azure example](/gateway/{{page.kong_version}}/developer-portal/administration/application-registration/azure-oidc-config/).

## Enable application registration on a service using Kong Manager {#enable-app-reg-plugin}

To use application registration on a service, enable the Portal Application Registration
plugin.

In Kong Manager, access the service for which you want to enable application registration:

1. From your workspace, in the left navigation pane, go to **API Gateway > Services**.
2. On the Services page, select the service and click **View**.
3. In the Plugins pane in the Services page, click **Add a Plugin**.
4. On the Add New Plugin page in the Authentication section, find the
   **Portal Application Registration** plugin and click **Enable**.

5. Enter the configuration settings. Use the parameters in the next section,
   [Application Registration Configuration Parameters](#application-registration-configuration-parameters),
   to complete the fields.

   {:.important}
   > **Important:** Exposing the Issuer URL is essential for the
   [Authorization Code Flow](/gateway/{{page.kong_version}}/developer-portal/administration/application-registration/3rd-party-oauth/#ac-flow)
   workflow configured for third-party identity providers.

6. Click **Create**.

### Application registration configuration parameters {#app-reg-params}

| Form Parameter | Description                                                                       |
|:---------------|:----------------------------------------------------------------------------------|
| `Service` | The service that this plugin configuration will target. Required. |
| `Tags` | A set of strings for grouping and filtering, separated by commas. Optional. |
| `Auto Approve` | If enabled, all new service contract requests are automatically approved. Otherwise, Dev Portal admins must manually approve requests. Default: `false`. |
| `Description` | Description displayed in the information about a service in the Dev Portal. Optional. |
| `Display Name` | Unique name displayed in the information about a service in the Dev Portal. Required. |
| `Show Issuer` | Displays the Issuer URL in the Service Details page. Default: `false`. **Important:** Exposing the **Issuer URL** is essential for the [Authorization Code Flow](/gateway/{{page.kong_version}}/developer-portal/administration/application-registration/3rd-party-oauth/#ac-flow) workflow configured for third-party identity providers. |

## Next steps

Choose an [authorization strategy](/gateway/{{page.kong_version}}/developer-portal/administration/application-registration/auth-provider-strategy/) 
and configure the appropriate plugin: OAuth2, Key Authentication, or OpenID Connect.