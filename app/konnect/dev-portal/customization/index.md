---
title: Customize the Konnect Dev Portal
no_version: true
content_type: how-to
---

The {{site.konnect_short_name}} Dev Portal currently offers three areas you can customize:
* [Appearance](#appearance)
* [Custom URL](#add-a-custom-dev-portal-domain)
* [Enabling Public Access](/konnect/dev-portal/publish/#access)
* [Custom URL](#single-sign-on)

This doc covers the details of customizing the appearance of your Developer Portal, and the steps to customize a URL.

## Appearance

The Dev Portal can be customized by those with Admin roles via the Appearance
settings in the {{site.konnect_short_name}} Admin UI. To access the Appearance
settings, click {% konnect_icon dev-portal %} **Dev Portal**, then **Appearance**.

Here, you have the ability to modify the following:

* Logos: default logo and fav icon
* Home Page Header: welcome message, primary header, and header image
* Colors: background, text, and button colors
* Themes: default theme and dark mode
* Fonts

For details on the requirements for each customizable option, hover over the information (`i`) icon next to each item in the UI.


## Custom Developer Portal URL

All Dev Portals have an auto-generated default Dev Portal URL. You can add a custom domain. When set up properly, users can access the Dev Portal from both the default URL and the custom URL. The {{site.konnect_short_name}} Kong Developer Portal generates an SSL certificate for your custom domain automatically.

### Prerequisites

* A domain and access to configure domain's CNAME
* Your organization's auto-generated default Dev Portal URL. For example, `https://kong121212.portal.konnect.konghq.com/`.

### Direct your CNAME to the default Dev Portal URL

From your domain registrar's DNS records settings options, point your CNAME to your Dev Portal's default URL.


## Add a custom Dev Portal domain

Add a custom Dev Portal domain through your organization's {{site.konnect_short_name}} Admin UI.

1. In {{site.konnect_short_name}}, open {% konnect_icon dev-portal %} **Dev Portal**, then click **Settings**.

2. Open the **Portal URL** tab.

3. Enter the full domain, including subdomain (if applicable). Don't include a path. It's not necessary to include the URL protocol, for example, `https://` into the **Custom Portal URL** field.

4. Test to see if your custom URL works. You'll see the custom URL listed in your Dev Portal under your default Dev Portal URL. Your SSL certificate will be generated automatically.

   {:.note}
   > **Note:** DNS propagation can take a few hours. If after a few hours you can't access the Dev Portal from the custom URL, contact your domain registrar.

## Single Sign-On
{:.badge .enterprise}

The Dev Portal can be configured to use Single Sign-On (SSO) by a {{site.konnect_short_name}} Admin via the Identity settings in the {{site.konnect_short_name}} Admin interface.

1. In {{site.konnect_short_name}}, open {% konnect_icon dev-portal %} **Dev Portal**, then click **Settings**.

2. Open the **Identity** tab.

   {:.note}
      > **Note:** Copy the callback URL and enter it in your OIDC Provider

3. Enter the full domain, including subdomain and protocol, into the  **Provider URL** field (also known as **Issuer**). e.g. `https://accounts.google.com` for Google IdP

4. Enter the unique identifier provided by the IdP into the **Client ID** field.

5. Enter the secret used to verify ownership of your IdP client into the **Client Secret** field.

### Configuration Requirements

A form of authentication must always be configured. Built-in authentication or OIDC can be used individually and in combination.

* If OIDC is enabled and Built-in is disabled, developer passwords can still be used. When re-enabling Built-in, they will be inactive while built-in is off.

* Enabling both Built-in and OIDC will give developers the option to authenticate  with SSO through the IdP, or with an email and password. 

### OIDC Details

* If a user account associated to a {{site.konnect_short_name}} developer is removed from the IdP, the {{site.konnect_short_name}} developer account will continue to exist. It must be deleted by a {{site.konnect_short_name}} admin from the {{site.konnect_short_name}} dashboard.
* If a {{site.konnect_short_name}} developer associated with an IdP user is deleted, the same IdP user can re-authenticate with the developer portal and a new {{site.konnect_short_name}} developer account will be created. To persistently revoke access for developers authenticating through your IdP, you must remove the ability for that user to authenticate with the IdP.
* User information from the IdP is not synced with Konnect developers after the first login.
