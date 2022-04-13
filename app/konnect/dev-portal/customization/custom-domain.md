---
title: Add a Custom Domain
no_version: true
---

All Dev Portals have an auto-generated default Dev Portal URL. To further customize your Dev Portal, you can add a custom domain. When set up properly, users can access both the default URL and the custom URL.

## Prerequisites

* You have the **Organization Admin** or **Portal Admin** role in {{site.konnect_saas}}.
* A domain and access to configure that domain's CNAME. Kong does not offer any custom domains as a service.
* An X.509 certificate, which comes with a private key.
* Your organization's auto-generated default Dev Portal URL, which is in the {{site.konnect_short_name}} Admin UI. For example, `https://kong121212.portal.konnect.konghq.com/`.

## Direct your CNAME to the default Dev Portal URL

In your custom domain DNS records, direct your CNAME to your Dev Portal's default URL. Check your DNS resolution to ensure this was done properly.

## Add a custom Dev Portal domain

Add a custom Dev Portal domain through your organization's {{site.konnect_short_name}} Admin UI.

1. In {{site.konnect_short_name}}, open **Dev Portal** from the left side menu, then click **Settings**.

1. Open the **Portal URL** tab.

1. Enter the following fields.

   * **Custom Portal URL**: Enter the full domain, including subdomain (if applicable). Don't include a path. It's not necessary to include the URL protocol, for example, `https://`.

   * **X.509 Certificate**: Obtain your certificate and add it to the field, including the certification header and footer. For example, a header may look like: `-----BEGIN CERTIFICATE-----`.

        This certificate ensures that your custom domain site is trusted and that the browser doesn't show a warning when users land on the page.

   * **Private Key**: Add the private key that came with your X.509 certificate.

   {:.note}
   > **Note**: You will **not** be able to view or edit keys in the UI once you submit the form. To change your custom domain URL, X.509 certificate, or private key, delete your certificate and re-enter your custom domain URL, X.509 certificate, and private key.

1. Once you've entered all fields, click **Save Certificate**.

1. Test to see if your custom URL works. You'll see the custom URL listed in your Dev Portal under your default Dev Portal URL, even if it doesn't work properly.

    Your site may not resolve immediately. If you can't reach your custom URL, check your DNS records. If there are no issues and your site is unreachable, wait for your site to propagate.
