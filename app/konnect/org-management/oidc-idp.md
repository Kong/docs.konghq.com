---
title: Set up SSO with OpenID Connect
content_type: how-to
---

As an alternative to {{site.konnect_saas}}’s native authentication, you can set
up single sign-on (SSO) access to {{site.konnect_short_name}} through
an identity provider (IdP) with
OpenID Connect.
This authentication method allows your users to log in to {{site.konnect_saas}}
using their IdP credentials, without needing a separate login.

## Prerequisites

* {{site.konnect_short_name}} must be added to your IdP as an application
* Claims are set up in your IdP

## Set up SSO in {{site.konnect_short_name}}

1. In [{{site.konnect_saas}}](https://cloud.konghq.com), click {% konnect_icon organizations %} **Organization**, and then **Auth Settings**.

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

1. Click **Save**.

## Test and apply the configuration

{:.important}
> **Important:** Keep built-in authentication enabled while you are testing IdP authentication. Only disable built-in authentication after successfully testing IdP authentication.

You can test the SSO configuration by navigating to the login URI based on the organization login path you set earlier. For example: `cloud.konghq.com/login/examplepath`. If your configuration is set up correctly, you will see the IdP sign-in window.

You can now manage your organization's user permissions entirely from the IdP
application.

## Advanced Settings

You can configure custom IdP-specific behaviors in the **Advanced Settings** of the OIDC configuration form. The following options are available:

1. **Scopes**: Specify the list of scopes {{site.konnect_short_name}} requests from the IdP. By default, {{site.konnect_short_name}} requests the `openid`, `email`, and `profile` scopes. The `openid` scope is required and cannot be removed.
2. **Claim Mappings**: Customize the mapping of required attributes to a different claim in the `id_token` {{site.konnect_short_name}} receives from the IdP. By default, {{site.konnect_short_name}} requires three attributes: Name, Email, and Groups. The values in these attributes are mapped as follows:
    - `name`: Used as the {{site.konnect_short_name}} account's `full_name`.
    - `email`: Used as the {{site.konnect_short_name}} account's `email`.
    - `groups`: Used to map users to teams defined in the team mappings upon login.
