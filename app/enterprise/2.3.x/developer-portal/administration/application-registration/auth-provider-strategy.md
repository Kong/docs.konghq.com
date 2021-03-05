---
title: Authorization Provider Strategy for Application Registration
---

## Overview

In the 1.5.x beta version of the Application
Registration plugin, the feature was tightly coupled with OAuth2. Kong was the
only available system of record (SoR) for application credentials and the OAuth
configuration was done directly within the Application Registration plugin.

In the {{site.ee_product_name}} 2.1.x version, authentication was decoupled from the
Application Registration plugin. Support has been added for third-party OAuth2
providers. Developers have the flexibility to choose from either
Kong or a third-party identity provider (IdP) as the system of record for
application credentials. With third-party (external) OAuth2 support, developers
can centralize application credential management with the
[supported identity provider](/enterprise/{{page.kong_version}}/developer-portal/administration/application-registration/3rd-party-oauth#idps)
of their choice.

In the {{site.ee_product_name}} 2.2.1.x version and later, support has been added
for the Key Authentication plugin to use with Kong as the system of record.

### Supported Authentication Plugins

OAuth2 plugins for use with the Application Registration plugin:

- When {{site.base_gateway}} is the system of record, the Application Registration plugin works
  in conjunction with the OAuth2 or the Key Authentication plugin.

  <div class="alert alert-warning">
    <strong>Important:</strong> The OAuth2 plugin does not support
    hybrid mode. Since the Key Authentication plugin is using the `kong-oauth2` strategy
    and client ID credential, hybrid mode is also not supported for the Key
    Authentication plugin. If your organization uses hybrid mode, you must use an external identity
    provider and configure the OpenID Connect plugin.
  </div>

- When an external OAuth2 is the system of record, the Application Registration
  plugin works in conjunction with the OpenID Connect plugin.

The third-party authorization strategy (`external-oauth2`) applies to all
applications across all Workspaces (Dev Portals) in a {{site.base_gateway}} cluster.

### Authorization provider strategy configuration for Application Registration {#portal-app-auth}

The `portal_app_auth` configuration option must be set in `kong.conf` to enable
the Developer Portal Application Registration plugin with your chosen
authorization strategy. The default setting (`kong-oauth2`) accommodates the
OAuth2 or Key Authentication plugins.

Available options:

* `kong-oauth2`: Default. {{site.base_gateway}} is the system of record. The Application
  Registration plugin is used in conjunction with the OAuth2 or
  Key Authentication plugin. The `kong-oauth2` option can only be used with
  classic (traditional) deployments. Because the OAuth2 plugin requires a database
  for every gateway instance, the `kong-oauth2` option cannot be used with hybrid mode
  deployments.
* `external-oauth2`: An external IdP is the system of record. The
  Portal Application Registration plugin is used in conjunction with the
  OIDC plugin. The `external-oauth2` option can be used with any deployment type.
  The `external-oauth2` option must be used with
  [hybrid mode](/enterprise/{{page.kong_version}}/deployment/hybrid-mode/)
  deployments because hybrid mode does not support `kong-oauth2`.

#### Set external portal authentication {#set-external-oauth2}

If you are using an external IdP, follow these steps.

1. Open `kong.conf.default` and set the `portal_app_auth` option to your chosen
   strategy. The example configuration below switches from the default
   (`kong-oauth2`) to an external IdP (`external-oauth2`).

   ```
   portal_app_auth = external-oauth2
            # Developer Portal application registration
            # auth provider and strategy. Must be set to configure
            # authentication in conjunction with the application_registration plugin.
            # Currently accepts kong-oauth2 or external-oauth2.
   ```

2. [Restart](/enterprise/{{page.kong_version}}/cli/#kong-restart) your Kong Enterprise
   instance.

### Next Steps

1. Enable the [Application Registration plugin](/enterprise/{{page.kong_version}}/developer-portal/administration/application-registration/enable-application-registration) on a Service.

2. Enable a supported authentication plugin on the same Service as the Application Registration plugin,
   as appropriate for your authorization strategy.

    Strategy `kong-oauth2`:

    * If using the `kong-oauth2` authorization strategy with the OAuth2 plugin, configure the
    [OAuth2](/hub/kong-inc/oauth2/) plugin on the same Service as the Application Registration plugin.
    You can use either the Kong Manager GUI or cURL commands as documented on the [Plugin Hub](/hub/).
    The OAuth2 plugin cannot be used in hybrid mode.
    * If using the `kong-oauth2` authorization strategy with key authentication, configure the
    [Key Auth](/hub/kong-inc/key-auth/) plugin on the same Service as the Application
    Registration plugin. You can use either the
    [Kong Manager GUI](/enterprise/{{page.kong_version}}/developer-portal/administration/application-registration/enable-key-auth-plugin)
    or cURL commands as documented on the Plugin Hub. The Key Auth plugin
    cannot be used in hybrid mode.

    Strategy `external-oauth2`:

    1. If you plan to use external OAuth2, review the
    [recommended workflows](/enterprise/{{page.kong_version}}/developer-portal/administration/application-registration/3rd-party-oauth#supported-oauth-flows).

    2. If using the third-party authorization strategy
    (`external-oauth2`), configure the OIDC plugin on the same Service as the
    Application Registration plugin. You can use the Kong Manager GUI
    or cURL commands as documented on the [Plugin Hub](/hub/kong-inc/openid-connect).
    When your deployment is hybrid mode, the OIDC plugin must be configured to handle
    authentication for the Portal Application Registration plugin.

    3. Configure the identity provider for your application, configure your
    application in {{site.base_gateway}}, and associate them with each other. See the
    [Okta](/enterprise/{{page.kong_version}}/developer-portal/administration/application-registration/okta-config)
    or the [Azure](/enterprise/{{page.kong_version}}/developer-portal/administration/application-registration/azure-oidc-config) setup examples.
