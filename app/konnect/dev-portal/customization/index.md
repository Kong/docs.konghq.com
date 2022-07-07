---
title: Customize the Konnect Dev Portal
no_version: true
content_type: how-to
---


## Appearance

The Dev Portal can be customized by those with admin roles via the **Appearance
settings** in the {{site.konnect_short_name}} admin UI. To access the appearance
settings, click {% konnect_icon dev-portal %} **Dev Portal**, then **Appearance**.

From the **Appearance** menu you have the ability to modify the following options:

* Logos: default logo and favicon
* Home Page Header: welcome message, primary header, and header image
* Colors: background, text, and button colors
* Themes: default theme and dark mode
* Fonts

For details on the requirements for each customizable option, hover over the information (`i`) icon next to each item in the UI.

## Custom Dev Portal URL

Every Dev Portal instance has an auto-generated default Dev Portal URL, so that users can access the Dev Portal from both the default URL and the custom URL. The {{site.konnect_short_name}} Dev Portal generates an SSL certificate for your custom domain automatically.

### Top-level domains

{{site.konnect_short_name}} offers support for the following top-level domains: 

- `*.io`
- `*.com`
- `*.tech`
- `*.net`
- `*.dev`

### Prerequisites

* A domain and access to configure domain's CNAME
* Your organization's auto-generated default Dev Portal URL. For example, `https://kong121212.portal.konnect.konghq.com/`.

### Direct your CNAME to the default Dev Portal URL

From your domain registrar's DNS records settings options, point your CNAME to your Dev Portal's default URL.

### Add a custom Dev Portal domain

To add a custom URL to Dev Portal, open {% konnect_icon dev-portal %} **Dev Portal**, click **Settings**, then follow these steps: 

1. Open the **Portal URL** tab.

2. Enter the full domain, including any applicable subdomain. 
   
   Don't include a path. It's not necessary to include the URL protocol (for example, `https://`) in the **Custom Portal URL** field.

3. Test your custom URL. You'll see the custom URL listed in the Dev Portal under the default Dev Portal URL. An SSL certificate will be generated automatically.

   {:.note}
   > **Note:** DNS propagation can take a few hours. If after a few hours you can't access the Dev Portal from the custom URL, contact your domain registrar.

## Single Sign-On
{:.badge .enterprise}

A {{site.konnect_short_name}} admin can configure single sign-on (SSO) for the Dev Portal via the identity settings in the {{site.konnect_short_name}} admin interface.

To configure single sign-on, open {% konnect_icon dev-portal %} **Dev Portal**, click **Settings**, then follow these steps: 

1. Open the **Identity** tab.

   {:.note}
1. Copy the callback URL and enter it in your identity provider.

2. Enter the full domain, including the subdomain and protocol, into the  **Provider URL** field (also known as **Issuer**). For example, `https://accounts.google.com` for Google IdP.

3. Enter the unique identifier provided by the IdP into the **Client ID** field.

4. Enter the secret used to verify ownership of your IdP client into the **Client Secret** field.

### Configuration Requirements

You must always have a form of authentication configured. Built-in and SSO can be used individually or in combination. Each state results in a different user experience, as represented in the following table:

| State | SSO registration | SSO sign in | Built-in registration| Built-in sign in | Information|
| --- | :-----------: |  ----------- | :-----------: | ----------- |
| **SSO: Enabled**<br>**Built-in: Disabled** | ✅ | ✅ | ❌ | ❌ | - Developers can register and log in with SSO.<br><br>- Developers registered with Built-in are forced to use SSO.<br><br>- The Built-in authentication window does not display from the Dev Portal. 
| **SSO: Disabled**<br>**Built-in: Enabled** | ❌ | ❌ | ✅  |✅  | - Developers can register and log in with a username and password.| 
| **SSO: Enabled**<br>**Built-in: Enabled** | ✅  | ✅ | ✅  | ✅  | - Developers can register and log in with either form of authentication.|


### OIDC Details

* If a user account associated with a {{site.konnect_short_name}} developer is removed from the IdP, the {{site.konnect_short_name}} developer account is not deleted. A {{site.konnect_short_name}} Admin must delete it from the {{site.konnect_short_name}} dashboard.
* If a {{site.konnect_short_name}} developer associated with an IdP user is deleted, the same IdP user can re-authenticate with the Dev Portal and a new {{site.konnect_short_name}} developer account is created. To persistently revoke access for developers authenticating through your IdP, you must remove the ability for that user to authenticate with the IdP.
* User information from the IdP is not synced with {{site.konnect_short_name}} developers after the first login.
