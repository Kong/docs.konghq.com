---
nav_title: Overview
---

Applications allow registered developers on Kong Developer Portal to
authenticate against a Gateway service. Dev Portal admins can
selectively admit access to services using the
Application Registration plugin. Furthermore, enabling `enable_proxy_with_consumer_credential` will introduce
an additional method for accessing the service using the consumer's credential.
It is essential to exercise caution when enabling this parameter.
Once activated, it will bypass the plugin's ACL control, potentially compromising security measures.

{:.note}
> **Note**: This plugin is for application registration in _self-managed_ 
> {{site.base_gateway}} instances.
> <br>
> <br>
> In {{site.konnect_short_name}}, the functionality is built in, so you 
> don't need this plugin. See the following documentation:
* [Learn about app registration in {{site.konnect_short_name}}](/konnect/dev-portal/applications/application-overview/)
* [Enable app registration](/konnect/dev-portal/applications/enable-app-reg/)

The Application Registration plugin is used in tandem with supported {{site.base_gateway}} authorization
plugins, depending on your configured Dev
Portal authorization provider. These authorization plugins use either {{site.base_gateway}} (`kong-oauth2`) or a third-party OAuth 
provider (`external-oauth2`) as the system of record (SoR) for application credentials. 

An authorization provider strategy **must be set** before configuring the Application Registration plugin. For more
information, see
[Configure an Authorization Provider Strategy](/gateway/latest/kong-enterprise/dev-portal/applications/auth-provider-strategy/).

Supported authorization plugins for use with application registration:

| {{site.base_gateway}} Plugin | Portal authorization strategy | Supported topologies |
|:------|:-----------------------------------------------------|----------------------|
| [OAuth2](/hub/kong-inc/oauth2/) | `kong-oauth2` | Traditional |
| [Key Auth](/hub/kong-inc/key-auth/)| `kong-oauth2` | Traditional, hybrid, DB-less |
| [OIDC](/hub/kong-inc/openid-connect/)| `external-oauth2` | Traditional, hybrid, DB-less |

To learn how to set up key authentication, see [Enable Key Authentication for Application Registration](/gateway/latest/kong-enterprise/dev-portal/applications/enable-key-auth-plugin/).

If you plan to use the external OAuth option with OIDC, review the
[supported OAuth workflows](/gateway/latest/kong-enterprise/dev-portal/authentication/3rd-party-oauth/).

## Get started with the Application Registration plugin

* [Configuration reference](/hub/kong-inc/application-registration/configuration/)
* [Basic configuration example](/hub/kong-inc/application-registration/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/application-registration/how-to/)
* [Authorization provider strategies](/gateway/latest/kong-enterprise/dev-portal/applications/auth-provider-strategy/#portal-app-auth)
* [Using key authentication with application registration](/gateway/latest/kong-enterprise/dev-portal/applications/enable-key-auth-plugin/)
* [Third-party OAuth2 support](/gateway/latest/kong-enterprise/dev-portal/authentication/3rd-party-oauth/)
* [Application registration with Okta](/gateway/latest/kong-enterprise/dev-portal/authentication/okta-config/)
* [Application registration with Azure AD](/gateway/latest/kong-enterprise/dev-portal/authentication/azure-oidc-config/)
