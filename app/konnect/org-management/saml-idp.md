---
title: Set up SSO with SAML 2.0
content_type: how-to
---

As an alternative to {{site.konnect_saas}}’s native authentication, you can set up single sign-on (SSO) access to {{site.konnect_short_name}} through an identity provider (IdP) using SAML 2.0. This method allows your users to log in to {{site.konnect_saas}} with their IdP credentials, eliminating the need for a separate login.

## Prerequisites

* Add {{site.konnect_short_name}} as an application in your IdP.

## Set up SSO in {{site.konnect_short_name}}

1. Log in to {{site.konnect_saas}}, click {% konnect_icon organizations %} **Organization**, and then select **Auth Settings**.

2. Click **Configure provider** under **SAML**. 

3. Enter the **Metadata URL** from your IdP in the **Identity Provider Metadata URL** field, or paste the **Metadata XML** in to the Identity **Provider Metadata XML** field.

4. In the **Organization Login Path** field, enter a unique string. For example: `examplepath`.

   {{site.konnect_short_name}} uses this string to generate a custom login
   URL for your organization.

   Requirements:
    * The path must be unique across all {{site.konnect_short_name}} organizations.
      If your desired path is already taken, you must to choose another one.
    * The path can be any alphanumeric string.
    * The path does not require a slash (`/`).

5. Click **Save**.

## Test and apply the configuration

{:.important}
> **Important:** Keep built-in authentication enabled while you are testing IdP authentication. Only disable built-in authentication after successfully testing IdP authentication.

Test the SSO configuration by navigating to the login URI based on the organization login path you set earlier. For example: `https://cloud.konghq.com/login/examplepath`, where `examplepath` is the unique login path string set in the previous steps.

If the configuration is correct, you will see the IdP sign-in page. You can now manage your organization's user permissions entirely from the IdP application.

## Advanced Settings

In the **Advanced Settings**  section of the OIDC configuration form, you can customize IdP-specific behaviors. The following options are available:

1. **Attribute Mappings**: Customize the mapping of required attributes to different attribute names from those received from the IdP. By default, {{site.konnect_short_name}} requires three attributes: `name`, `email`, and `groups`. These attributes are mapped as follows:
    - `name`: Used as the {{site.konnect_short_name}} account's `full_name`.
    - `email`: Used as the {{site.konnect_short_name}} account's `email`.
    - `groups`: Used to map users to teams defined in the team mappings upon login.

## Troubleshooting

### Authentication issues with large numbers of groups

If users are assigned to a large number of groups (over 150 in most cases), the IdP may send the groups attribute in a non-standard manner, causing authentication issues.

To work around this limitation, use group filtering functions provided by the IdP.
Listed are some reference guides for common IdPs:
* [Azure group filtering](https://learn.microsoft.com/en-us/azure/active-directory/hybrid/connect/how-to-connect-fed-group-claims#group-filtering)
* [Okta group filtering](https://support.okta.com/help/s/article/How-to-send-certain-groups-that-the-user-is-assigned-to-in-one-Group-attribute-statement)

You may need to contact your IdP's support team for assistance in filtering groups emitted for the application.