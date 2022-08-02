---
title: Authorization Provider Strategy for Application Registration
badge: enterprise
---

## Supported Authentication Plugins

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

## Authorization provider strategy configuration for Application Registration {#portal-app-auth}

The `portal_app_auth` configuration option must be set in `kong.conf` to enable
the Dev Portal Application Registration plugin with your chosen
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
  [hybrid mode](/gateway/{{page.kong_version}}/plan-and-deploy/hybrid-mode/)
  deployments because hybrid mode does not support `kong-oauth2`.

### Set external portal authentication {#set-external-oauth2}

If you are using an external IdP, follow these steps.

1. Open `kong.conf.default` and set the `portal_app_auth` option to your chosen
   strategy. The example configuration below switches from the default
   (`kong-oauth2`) to an external IdP (`external-oauth2`).

   ```
   portal_app_auth = external-oauth2
            # Dev Portal application registration
            # auth provider and strategy. Must be set to configure
            # authentication in conjunction with the application_registration plugin.
            # Currently accepts kong-oauth2 or external-oauth2.
   ```

2. [Restart](/gateway/{{page.kong_version}}/reference/cli/#kong-restart) your {{site.base_gateway}}
   instance.

## Next Steps

1. Enable the [Application Registration plugin](/gateway/{{page.kong_version}}/developer-portal/administration/application-registration/enable-application-registration) on a Service.

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
    [Kong Manager GUI](/gateway/{{page.kong_version}}/developer-portal/administration/application-registration/enable-key-auth-plugin)
    or cURL commands as documented on the Plugin Hub. The Key Auth plugin
    cannot be used in hybrid mode.

    Strategy `external-oauth2`:

    1. If you plan to use external OAuth2, review the
    [recommended workflows](/gateway/{{page.kong_version}}/developer-portal/administration/application-registration/3rd-party-oauth#supported-oauth-flows).

    2. If using the third-party authorization strategy
    (`external-oauth2`), configure the OIDC plugin on the same Service as the
    Application Registration plugin. You can use the Kong Manager GUI
    or cURL commands as documented on the [Plugin Hub](/hub/kong-inc/openid-connect).
    When your deployment is hybrid mode, the OIDC plugin must be configured to handle
    authentication for the Portal Application Registration plugin.

    3. Configure the identity provider for your application, configure your
    application in {{site.base_gateway}}, and associate them with each other. See the
    [Okta](/gateway/{{page.kong_version}}/developer-portal/administration/application-registration/okta-config)
    or the [Azure](/gateway/{{page.kong_version}}/developer-portal/administration/application-registration/azure-oidc-config) setup examples.
