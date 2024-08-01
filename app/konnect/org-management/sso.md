---
title: Configure Generic SSO
---


As an alternative to {{site.konnect_saas}}’s native authentication, you can set up single sign-on (SSO) access to {{site.konnect_short_name}} using OpenID Connect or SAML. This authentication method allows your users to log in to {{site.konnect_saas}} using their IdP credentials, without needing a separate login. This topic covers configuring SSO for use with various identity providers.

If you want to configure Okta, please see the [Okta configuration guide](/konnect/org-management/sso/).

## Prerequisites

* {{site.konnect_short_name}} must be added to your IdP as an application
* Claims are set up in your IdP


## Set up SSO in {{site.konnect_short_name}}
{% navtabs %}
{% navtab OIDC%}
1. In [{{site.konnect_saas}}](https://cloud.konghq.com/login), click {% konnect_icon organizations %} **Organization**, and then **Auth Settings**.

1. Click **Configure provider** for **OIDC**.

1. Paste the issuer URI from your IdP in the **Issuer URI** box. 

1. Paste the client ID from your IdP in the **Client ID** box.

1. Paste the client secret from your IdP in the **Client Secret** box.

1. In the **Organization Login Path** box, enter a unique string. For example: `examplepath`.

    {{site.konnect_short_name}} uses this string to generate a custom login
    URL for your organization.

    Requirements:
    * The path must be unique *across all {{site.konnect_short_name}} organizations*.
    If your desired path is already taken, you must to choose another one.
    * The path can be any alphanumeric string.
    * The path does not require a slash (`/`).

1. After clicking Save, close the configuration dialog and click Enable on your OIDC provider.

## Test and apply the configuration

{:.important}
> **Important:** Keep built-in authentication enabled while you are testing IdP authentication. Only disable built-in authentication after successfully testing IdP authentication.

You can test the SSO configuration by navigating to the login URI based on the organization login path you set earlier. For example: `https://cloud.konghq.com/login/examplepath`, where `examplepath` is the unique login path string set in the steps above. 

If your configuration is set up correctly, you will see the IdP sign-in page.

You can now manage your organization's user permissions entirely from the IdP
application.

## Advanced settings

You can configure custom IdP-specific behaviors in the **Advanced Settings** of the OIDC configuration form. The following options are available:

1. **Scopes**: Specify the list of scopes {{site.konnect_short_name}} requests from the IdP. By default, {{site.konnect_short_name}} requests the `openid`, `email`, and `profile` scopes. The `openid` scope is required and cannot be removed.
2. **Claim Mappings**: Customize the mapping of required attributes to a different claim in the `id_token` {{site.konnect_short_name}} receives from the IdP. By default, {{site.konnect_short_name}} requires three attributes: Name, Email, and Groups. The values in these attributes are mapped as follows:
    - `name`: Used as the {{site.konnect_short_name}} account's `full_name`.
    - `email`: Used as the {{site.konnect_short_name}} account's `email`.
    - `groups`: Used to map users to teams defined in the team mappings upon login.
{% endnavtab %}
{% navtab SAML %}

The {{site.konnect_short_name}} SAML integration allows you to configure various identity providers. While technically any SAML-compliant provider can be used, the following have been verified:

* Okta 
* Azure Active Directory
* Oracle Identity Cloud Service 
* Keycloak

1. Log in to {{site.konnect_saas}}, click {% konnect_icon organizations %} **Organization**, and then select **Auth Settings**.

1. Click **Configure provider** under **SAML**. 

1. Enter the **Metadata URL** from your IdP in the **IDP Metadata URL** field.

1. In the **Login Path** field, enter the unique string that matches the one in Okta. For example: `examplepath`.

   {{site.konnect_short_name}} uses this string to generate a custom login
   URL for your organization.

   Requirements:
    * The path must be unique across all {{site.konnect_short_name}} organizations.
      If your desired path is already taken, you must choose another one.
    * The path can be any alphanumeric string.
    * The path does not require a slash (`/`).

1. After clicking **Save**, configure the SP Entity ID and Login URL on your SAML IdP.

## Test and apply the configuration

{:.important}
> **Important:** Keep built-in authentication enabled while you are testing IdP authentication. Only disable built-in authentication after successfully testing IdP authentication.

Test the SSO configuration by navigating to the login URI based on the organization login path you set earlier. For example: `https://cloud.konghq.com/login/examplepath`, where `examplepath` is the unique login path string set in the previous steps.

If the configuration is correct, you will see the IdP sign-in page. You can now manage your organization's user permissions entirely from the IdP application.

{% endnavtab %}
{% endnavtabs %}
## Troubleshooting 

### Provider specific SAML configuration

The following section contains provider specific information and attribute mapping tables necessary for configuring SSO. 
{% navtabs %}
{% navtab Azure %}
* When adding an enterprise application, note that OIDC uses app registration.
* Remove the namespace from the claim name in Azure. You can do this by checking **Customize** on the group claim.
* Using groups maps to the Group ID by default.

Attribute mapping for Azure configuration:

| Azure                                       | Konnect                  |
|---------------------------------------------|--------------------------|
| Identifier (Entity ID)                      | `sp_entity_id`           |
| Reply URL (Assertion Consumer Service URL)  | `callback_url`           |
| App Federation Metadata Url                 | `idp_metadata_url`       |
| email                                       | `user.email`             |
| firstname                                   | `user.givenname`         |
| lastname                                    | `user.surname`           |
| groups                                      | `user.groups`            |
| Unique user identifier                      | `user.principalname`     |


{% endnavtab %}
{% navtab Oracle Cloud %}


* When configuring the Name ID format in Oracle Cloud, make sure to set it to `transient`.
* You will need to manually upload the signing certificate from `sp_metadata_url`.
   - `cert.pem` must use the `X509Certificate` value for signing.

Attribute mapping for Oracle Cloud configuration:

| Oracle Cloud                                | Konnect                  |
|---------------------------------------------|--------------------------|
| Entity ID                                   | `sp_entity_id`           |
| Assertion consumer URL                      | `callback_url`           |
| App Federation Metadata Url                 | `idp_metadata_url`       |





{% endnavtab %}
{% navtab KeyCloak %}

* You will need to manually upload the signing certificate from `sp_metadata_url`.
   - `cert.pem` must use the `X509Certificate` value for signing.
* Go to **Realm Settings** in Keycloak to locate your metadata endpoint. The `sp_metadata_url` for {{site.konnect_short_name}} will be:`http://<keycloak-url>/realms/konnect/protocol/saml/descriptor`

Attribute mapping for KeyCloak configuration:

| KeyCloak                                    | Konnect                  |
|---------------------------------------------|--------------------------|
| Client ID                                   | `sp_entity_id`           |
| Valid redirect URI                          | `callback_url`           |
| App Federation Metadata Url                 | `idp_metadata_url`       |

{% endnavtab %}
{% endnavtabs %}

### Authentication issues with large numbers of groups

If users are assigned a very large number of groups (over 150 in most cases), the IdP may send the groups claim in a non-standard manner, causing authentication issues. 

To work around this limitation in the IdP, we recommend using group filtering functions provided by the IdP for this purpose. 
Here are some quick reference guides for common IdPs:
* [Azure group filtering](https://learn.microsoft.com/en-us/azure/active-directory/hybrid/connect/how-to-connect-fed-group-claims#group-filtering) 
* [Okta group filtering](https://support.okta.com/help/s/article/How-to-send-certain-groups-that-the-user-is-assigned-to-in-one-Group-attribute-statement)

You may need to contact the support team of your identity provider in order to learn how to filter groups emitted for the application.
