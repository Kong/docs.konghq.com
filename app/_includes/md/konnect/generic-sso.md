<!-- used in the Dev Portal generic SSO how to and the Org generic SSO how to -->

## Prerequisites

* {{site.konnect_short_name}} must be added to your IdP as an application
* Users that need to use SSO are added to your IdP tenant
* Claims are set up in your IdP


## Set up SSO in {{site.konnect_short_name}}
{% navtabs %}
{% navtab OIDC%}
{% if include.desc == "Konnect Org" %}
1. In [{{site.konnect_saas}}](https://cloud.konghq.com/login), click {% konnect_icon organizations %} **Organization** > **Settings**, and then click the **Authentication Scheme** tab.
{% endif %}
{% if include.desc == "Dev Portal" %}
1. In [{{site.konnect_short_name}} Dev Portal](https://cloud.konghq.com/portal/), click the Dev Portal you want to configure SSO for, click **Settings** in the sidebar and then click the **Identity** tab.
{% endif %}

1. Click **Configure** for OIDC.

1. Paste the issuer URI from your IdP in the **Issuer URI** field. 

1. Paste the client ID from your IdP in the **Client ID** field.

1. Paste the client secret from your IdP in the **Client Secret** field.

{% if include.desc == "Konnect Org" %}
1. In the **Organization Login Path** box, enter a unique string. For example: `examplepath`.

    {{site.konnect_short_name}} uses this string to generate a custom login
    URL for your organization.

    Requirements:
    * The path must be unique *across all {{site.konnect_short_name}} organizations*.
    If your desired path is already taken, you must to choose another one.
    * The path can be any alphanumeric string.
    * The path does not require a slash (`/`).
{% endif %}

1. Optional: You can configure custom IdP-specific behaviors in the **Advanced Settings** of the OIDC configuration form. The following options are available:
    * **Scopes**: Specify the list of scopes {{site.konnect_short_name}} requests from the IdP. By default, {{site.konnect_short_name}} requests the `openid`, `email`, and `profile` scopes. The `openid` scope is required and cannot be removed.
    * **Claim Mappings**: Customize the mapping of required attributes to a different claim in the `id_token` {{site.konnect_short_name}} receives from the IdP. By default, {{site.konnect_short_name}} requires three attributes: Name, Email, and Groups. The values in these attributes are mapped as follows:
        * `name`: Used as the {{site.konnect_short_name}} account's `full_name`.
        * `email`: Used as the {{site.konnect_short_name}} account's `email`.
        * `groups`: Used to map users to teams defined in the team mappings upon login.

1. After clicking **Save**, close the configuration dialog and from the OIDC context menu, click **Enable OIDC**.
{% endnavtab %}
{% navtab SAML %}

The {{site.konnect_short_name}} SAML integration allows you to configure various identity providers. While technically any SAML-compliant provider can be used, the following have been verified:

* Okta 
* Azure Active Directory
* Oracle Identity Cloud Service 
* Keycloak

{% if include.desc == "Konnect Org" %}
1. In [{{site.konnect_saas}}](https://cloud.konghq.com/login), click {% konnect_icon organizations %} **Organization** > **Settings**, and then click the **Authentication Scheme** tab.
{% endif %}
{% if include.desc == "Dev Portal" %}
1. In [{{site.konnect_short_name}} Dev Portal](https://cloud.konghq.com/portal/), click the Dev Portal you want to configure SSO for, click **Settings** in the sidebar and then click the **Identity** tab.
{% endif %}

1. Click **Configure** for SAML. 

1. Enter the **Metadata URL** from your IdP in the **IDP Metadata URL** field.

{% if include.desc == "Konnect Org" %}
1. In the **Login Path** field, enter the unique string that matches the one in your IdP. For example: `examplepath`.

   {{site.konnect_short_name}} uses this string to generate a custom login
   URL for your organization.

   Requirements:
    * The path must be unique across all {{site.konnect_short_name}} organizations.
    * The path can be any alphanumeric string.
    * The path does not require a slash (`/`).
{% endif %}

1. After clicking **Save**, configure the SP Entity ID and Login URL on your SAML IdP.
1. In {{site.konnect_short_name}}, close the configuration dialog and click **Enable SAML** from the context menu.
{% endnavtab %}
{% endnavtabs %}

## Test and apply the configuration

{:.important}
> **Important:** Keep built-in authentication enabled while you are testing IdP authentication. Only disable built-in authentication after successfully testing IdP authentication.

{% if include.desc == "Konnect Org" %}
Test the SSO configuration by navigating to the login URI based on the organization login path you set earlier. For example: `https://cloud.konghq.com/login/examplepath`, where `examplepath` is the unique login path string set in the previous steps.
{% endif %}

{% if include.desc == "Dev Portal" %}
Test the SSO configuration by navigating to the callback URL for your Dev Portal. For example: `https://{portalId}.{region}.portal.konghq.com/login`.
{% endif %}

If the configuration is correct, you will see the IdP sign-in page. 

You can now manage your organization's user permissions entirely from the IdP application.

## Troubleshooting

<details><summary>Troubleshooting authentication issues with large numbers of groups</summary>

{% capture large_group_auth %}
If users are assigned a very large number of groups (over 150 in most cases), the IdP may send the groups claim in a non-standard manner, causing authentication issues. 

To work around this limitation in the IdP, we recommend using group filtering functions provided by the IdP for this purpose. 
Here are some quick reference guides for common IdPs:
* [Azure group filtering](https://learn.microsoft.com/en-us/azure/active-directory/hybrid/connect/how-to-connect-fed-group-claims#group-filtering) 
* [Okta group filtering](https://support.okta.com/help/s/article/How-to-send-certain-groups-that-the-user-is-assigned-to-in-one-Group-attribute-statement)

You may need to contact the support team of your identity provider in order to learn how to filter groups emitted for the application.
{% endcapture %}

{{ large_group_auth | markdownify }}

</details>

