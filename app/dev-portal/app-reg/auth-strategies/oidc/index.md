---
title: OpenID Connect (OIDC)
breadcrumb: OIDC
content_type: explanation
---

OpenID Connect (OIDC) is an open authentication protocol that lets users sign in to multiple sites using one set of credentials. Using the OIDC Authentication Strategy allows Developers visiting your Dev Portal to authenticate using OIDC.

## Prerequisites

- Set up your application, claims, and scopes in your OpenID identity provider

{:.note}
> **Note:** Be sure to complete [Prerequisites for all OIDC Auth Strategies](/dev-portal/app-reg#prerequisites)

### Create OIDC Auth Strategy

If you do *not* already have an OIDC Auth Strategy created, we will first create an OIDC Auth strategy.

1. In the Dev Portal menu, navigate to the **Application Auth** tab. Click **New Auth Strategy** to create an auth strategy. Refer to the [configuration parameters section](#openid-config-parameters) for more information about each field.

2. Enter a name to be seen only in {{site.konnect_short_name}} and a display name that will be displayed on your Dev Portal.

3. In the Auth Type dropdown menu select **OpenID-Connect**. Enter the Issuer URL for your OIDC tenant.

4. Enter any scopes your developers may need access to (e.g. openid, profile, email, etc). Note the required scopes may differ depending on your IdP.

5. Enter the Credential Claims which will match the client ID of the corresponding application in your IdP.

6. Select the relevant Auth Methods you need (for example: `client_credentials`, `bearer`, `session`).

7. Click **Save**

8. Optional: In **Settings/Security**, set the preferred Default Auth Strategy to your new OIDC configuration instead of the default `key-auth`. This setting makes it easier to publish an API (in the next step) using the OIDC Auth Strategy, because this setting will be auto-selected for you. Changing this default will not retroactively change any previously published APIs.

9. [Publish an API](/dev-portal/portals/publishing) with the OIDC Auth Strategy you just created.

Now Developers can access the API using OIDC!

### OpenID Connect configuration parameters {#openid-config-parameters}

For more background information about OpenID Connect plugin parameters, see [Important Configuration Parameters](/hub/kong-inc/openid-connect/#important-configuration-parameters).

   | Form Parameter | Description                                                                       |Required |
   |:---------------|:----------------------------------------------------------------------------------|--|
   | `Issuer` | The issuer URL from which the OpenID Connect configuration can be discovered. For example: `https://dev-1234567.okta.com/oauth2/default`.  |**True** |
   | `Scopes` | The scopes to be requested from the OpenID Provider. Enter one or more scopes separated by spaces, for example: `open_id` `myscope1`.  | **False** |
   | `Credential claims` |  Name of the claim that maps to the unique client id in the identity provider. | **True** |
   | `Auth method` | The supported authentication method(s) you want to enable. This field should contain only the authentication methods that you need to use. Individual entries must be separated by commas. Available options: `password`, `client_credentials`, `authorization_code`, `bearer`, `introspection`, `kong_oauth2`, `refresh_token`, `session`. | **True** |
   | `Hide Credentials` |**Default: disabled**<br>  Hide the credential from the upstream service. If enabled, the plugin strips the credential from the request header, query string, or request body, before proxying it. | **False** |
   | `Auto Approve`| **Default: disabled** <br>Automatically approve developer application requests for an application. | **False** |

## Enable app registration with multiple IdPs

In {{site.konnect_short_name}}, you can configure and manage multiple authentication strategies across various API products and their versions, allowing you to apply distinct authentication scopes for different API versions.

This section will introduce you to the functionality portal APIs using Dynamic client registration (DCR). Using the Application Registration, you can manage multiple APIs and configure a different DCR on a per API basis. DCR is one type of strategy for application auth, where {{site.konnect_short_name}} is integrated directly with the IdP to outsource, link, and automate the credential management using that IDP.

1. Configure the auth strategies of your choice:

   - [Okta](/dev-portal/app-reg/auth-strategies/oidc/dynamic-client-registration/okta/)
   - [Curity](/dev-portal/app-reg/auth-strategies/oidc/dynamic-client-registration/curity/)
   - [Auth0](/dev-portal/app-reg/auth-strategies/oidc/dynamic-client-registration/auth0/)
   - [Azure](/dev-portal/app-reg/auth-strategies/oidc/dynamic-client-registration/azure/)
   - [Custom IdP](/dev-portal/app-reg/auth-strategies/oidc/dynamic-client-registration/custom/)

2. Apply the auth strategy to your API when [publishing](/dev-portal/portals/publishing) to the apprpriate Dev Portals.
