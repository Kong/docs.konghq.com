---
title: Set up SSO with OpenID Connect
content_type: how-to
no_version: true
---

As an alternative to {{site.konnect_saas}}’s native authentication, you can set
up single sign-on (SSO) access to {{site.konnect_short_name}} through
an identity provider (IdP) with
OpenID Connect.
This authentication method allows your users to log in to {{site.konnect_saas}}
using their IdP credentials, without needing a separate login.

You can't mix authentication methods in {{site.konnect_saas}}. With IdP
authentication enabled, all non-admin {{site.konnect_short_name}} users have to
log in through your IdP. Only the {{site.konnect_short_name}} org
owner can continue to log in with {{site.konnect_short_name}}'s native
authentication.

## Prerequisites

* {{site.konnect_short_name}} must be added to your IdP as an application
* Claims are set up in your IdP

## Set up SSO in {{site.konnect_short_name}}

1. In [{{site.konnect_saas}}](https://cloud.konghq.com), click {% konnect_icon cogwheel %}
**Settings**, and then **Auth Settings**.

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