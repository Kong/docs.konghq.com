---
title: Set up SSO with SAML 2.0
content_type: how-to
---

As an alternative to {{site.konnect_saas}}’s native authentication, you can set
up single sign-on (SSO) access to {{site.konnect_short_name}} through
an identity provider (IdP) with
SAML 2.0.
This authentication method allows your users to log in to {{site.konnect_saas}}
using their IdP credentials, without needing a separate login.

## Prerequisites

* {{site.konnect_short_name}} must be added to your IdP as an application

## Set up SSO in {{site.konnect_short_name}}

1. In [{{site.konnect_saas}}](https://cloud.konghq.com/login), click {% konnect_icon organizations %} **Organization**, and then **Auth Settings**.

2. Click **Configure provider** for **SAML**. 

3. Paste the **Metadata URL** from your IdP in the **Identity Provider Metadata URL** box or if you have the **Metadata XML** paste it in the **Identity Provider Metadata XML** box

4. In the **Organization Login Path** box, enter a unique string. For example: `examplepath`.

   {{site.konnect_short_name}} uses this string to generate a custom login
   URL for your organization.

   Requirements:
    * The path must be unique *across all {{site.konnect_short_name}} organizations*.
      If your desired path is already taken, you must to choose another one.
    * The path can be any alphanumeric string.
    * The path does not require a slash (`/`).

5. Click **Save**.

## Test and apply the configuration

{:.important}
> **Important:** Keep built-in authentication enabled while you are testing IdP authentication. Only disable built-in authentication after successfully testing IdP authentication.

You can test the SSO configuration by navigating to the login URI based on the organization login path you set earlier. For example: `https://cloud.konghq.com/login/examplepath`, where `examplepath` is the unique login path string set in the steps above.

If your configuration is set up correctly, you will see the IdP sign-in page.

You can now manage your organization's user permissions entirely from the IdP
application.

## Advanced Settings

You can configure custom IdP-specific behaviors in the **Advanced Settings** of the OIDC configuration form. The following options are available:

1. **Attribute Mappings**: Customize the mapping of required attributes to a different attribute name from attribute statements receives from the IdP. By default, {{site.konnect_short_name}} requires three attributes: Name, Email, and Groups. The values in these attributes are mapped as follows:
    - `name`: Used as the {{site.konnect_short_name}} account's `full_name`.
    - `email`: Used as the {{site.konnect_short_name}} account's `email`.
    - `groups`: Used to map users to teams defined in the team mappings upon login.

## Troubleshooting

### Authentication issues with large numbers of groups

If users are assigned a very large number of groups (over 150 in most cases), the IdP may send the groups attribute in a non-standard manner, causing authentication issues.

To work around this limitation at the IdP, we recommend using group filtering functions provided by the IdP for this purpose.
Here are some quick reference guides for common IdPs:
* [Azure group filtering](https://learn.microsoft.com/en-us/azure/active-directory/hybrid/connect/how-to-connect-fed-group-claims#group-filtering)
* [Okta group filtering](https://support.okta.com/help/s/article/How-to-send-certain-groups-that-the-user-is-assigned-to-in-one-Group-attribute-statement)

You may need to contact the support team of your identity provider in order to learn how to filter groups emitted for the application.
