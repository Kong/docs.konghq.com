---
title: Customize the Konnect Dev Portal
content_type: how-to
---

{{site.konnect_short_name}} has built-in customization options for managing the Dev Portal so that you can build a consistent experience for the consumers of your API. Customizing your Dev Portal to reflect the likeness of your brand can help convince developers to create applications with your services. With {{site.konnect_short_name}}, you can customize everything from the application. {{site.konnect_short_name}} also offers pre-built themes. 

## Appearance

To customize Dev Portal, you have two options:
* Basic customization using the Dev Portal [Appearance settings](#appearance) in the UI
* Complete customization using the [open source Dev Portal client](/konnect/dev-portal/customization/self-hosted-portal/)

### Basic customization

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

### Complete customization using the open source Dev Portal

You can completely customize the Dev Portal using the [open source Dev Portal client](/konnect/dev-portal/customization/self-hosted-portal/). To enable the self-hosted Dev Portal, navigate to {% konnect_icon dev-portal %} **Dev Portal** > [**Settings**](https://cloud.konghq.com/portal/portal-settings), then set up a custom hosted domain and a custom self-hosted UI domain in the **Portal Domain** tab. They must share a common top-level and second-level domain for security purposes (e.g. `api-developer.company.com` and `developer.company.com`)

This self-hosted portal provides the following benefits: 

* **Fully customizable:** Use the [example frontend Dev Portal application](https://github.com/Kong/konnect-portal) as a starting point and then customize Dev Portal for your needs using the [Portal API](/konnect/api/portal/latest/) and [Portal SDK](https://www.npmjs.com/package/@kong/sdk-portal-js). You can also integrate the API specs with workflows tailored to your organization's own processes.
* **Hosting service choice:** When you self-host, you also get to choose which hosting service you use to deploy your Dev Portal. 
* **Range of customization options:** With the self-hosted Dev Portal, you determine how much you want to customize. You can choose to use the example application right out of the box, or you can use the [Portal API](/konnect/api/portal/latest/) and [Portal SDK](https://www.npmjs.com/package/@kong/sdk-portal-js) for more fine-grained control.

## Custom Dev Portal URL

Every Dev Portal instance has an auto-generated default URL. You can also manage custom URLs within {{site.konnect_short_name}}. This gives users the ability to access the Dev Portal from either the default URL, for example `https://example.us.portal.konghq.com`, or a custom URL like `portal.example.com`.

To add a custom URL to Dev Portal, you need:

* A domain and access to configure the domain's DNS `CNAME` records.
* Your organization's auto-generated default Dev Portal URL.
* A [CAA DNS](https://datatracker.ietf.org/doc/html/rfc6844) record that allows `pki.goog` only if any pre-existing CAA DNS records are present on the domain.

You can also choose to [self-host the Dev Portal with Netlify](/konnect/dev-portal/customization/netlify/) or any other static hosting service that supports single page applications.

[Configure DNS &rarr;](/konnect/reference/custom-dns)

## Single sign-on
{:.badge .enterprise}

A {{site.konnect_short_name}} admin can configure single sign-on (SSO) for the Dev Portal via the identity settings in the {{site.konnect_short_name}} admin interface.

To configure single sign-on, open {% konnect_icon dev-portal %} **Dev Portal**, click **Settings**, then follow these steps:

1. Open the **Identity** tab.

2. Copy the callback URL and enter it in your identity provider.

2. Enter the full domain, including the subdomain and protocol, into the **Provider URL** field (also known as **Issuer**). For example, `https://accounts.google.com` for Google IdP.

3. Enter the unique identifier provided by the IdP into the **Client ID** field.

4. Enter the secret used to verify ownership of your IdP client into the **Client Secret** field.

### Configuration requirements

You must always have a form of authentication configured. Built-in and SSO can be used individually or in combination. Each state results in a different user experience, as represented in the following table:

| State | SSO registration | SSO sign in | Built-in registration| Built-in sign in | Information|
| --- | :-----------: |  ----------- | :-----------: | ----------- |
| **SSO: Enabled**<br>**Built-in: Disabled** | ✅ | ✅ | ❌ | ❌ | - Developers can register and log in with SSO.<br><br>- Developers registered with built-in authentication are forced to use SSO.<br><br>- The built-in authentication window does not display from the Dev Portal.
| **SSO: Disabled**<br>**Built-in: Enabled** | ❌ | ❌ | ✅  |✅  | - Developers can register and log in with a username and password.|
| **SSO: Enabled**<br>**Built-in: Enabled** | ✅  | ✅ | ✅  | ✅  | - Developers can register and log in with either form of authentication.|


### OIDC Details

* If a user account associated with a {{site.konnect_short_name}} developer is removed from the IdP, the {{site.konnect_short_name}} developer account is not deleted. A {{site.konnect_short_name}} admin must delete it from the {{site.konnect_short_name}} dashboard.
* If a {{site.konnect_short_name}} developer associated with an IdP user is deleted, the same IdP user can re-authenticate with the Dev Portal and a new {{site.konnect_short_name}} developer account is created. To persistently revoke access for developers authenticating through your IdP, you must remove the ability for that user to authenticate with the IdP.
* User information from the IdP is not synced with {{site.konnect_short_name}} developers after the first login.
