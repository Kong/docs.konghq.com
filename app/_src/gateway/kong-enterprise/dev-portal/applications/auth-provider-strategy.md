---
title: Authorization Provider Strategy for Application Registration
badge: enterprise
---

You can use {{site.base_gateway}} or an external system of record with the 
Application Registration plugin.

The `portal_app_auth` configuration option must be set in `kong.conf` to enable
the Dev Portal Application Registration plugin with your chosen
authorization strategy:

* `kong-oauth2`: Default. {{site.base_gateway}} is the system of record. The Application
  Registration plugin is used in conjunction with the [OAuth2](/hub/kong-inc/oauth2/) or
  [Key Authentication](/hub/kong-inc/key-auth/) plugin. 
  
  {:.note}
  > **Note**: The OAuth2 plugin can only be used with
  traditional deployments. Because the OAuth2 plugin requires a database
  for every gateway instance, it can't be used with hybrid mode or DB-less
  deployments.

* `external-oauth2`: An external IdP is the system of record. The
  Portal Application Registration plugin is used in conjunction with the
  [OpenID Connect (OIDC)](/hub/kong-inc/openid-connect/) plugin. 
  The `external-oauth2` option can be used with any deployment type.

  The third-party authorization strategy (`external-oauth2`) applies to all
  applications across all Workspaces (Dev Portals) in a {{site.base_gateway}} cluster.

## Using the {{site.base_gateway}} auth strategy

If you're using the default `kong-oauth2` authorization strategy with {{site.base_gateway}} as the system of record, set up app registration using the following steps:

1. Enable the [Application Registration plugin](/gateway/{{page.kong_version}}/kong-enterprise/dev-portal/applications/enable-application-registration/) on a service.

2. Configure either the [OAuth2](/hub/kong-inc/oauth2/) plugin or the [Key Auth](/hub/kong-inc/key-auth/) plugin on the same service as the Application Registration plugin.
    
    The OAuth2 plugin can't be used in hybrid mode.

## Setting external portal authentication {#set-external-oauth2}

If you are using an external IdP (`external-oauth2`), follow these steps.

1. Review and choose one of the
[recommended workflows](/gateway/{{page.kong_version}}/kong-enterprise/dev-portal/authentication/3rd-party-oauth#supported-oauth-flows).

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

1. Restart your {{site.base_gateway}} instance.
   
   ```
   kong reload
   ```
  
1. Enable the [Application Registration plugin](/gateway/{{page.kong_version}}/kong-enterprise/dev-portal/applications/enable-application-registration/) on a service.

1. Configure the [OIDC plugin](/hub/kong-inc/openid-connect/) on the same service as the
 Application Registration plugin.

1. Configure the identity provider for your application, configure your
application in {{site.base_gateway}}, and associate them with each other. See the
[Okta](/gateway/{{page.kong_version}}/kong-enterprise/dev-portal/authentication/okta-config/)
or the [Azure](/gateway/{{page.kong_version}}/kong-enterprise/dev-portal/authentication/azure-oidc-config/) setup examples.