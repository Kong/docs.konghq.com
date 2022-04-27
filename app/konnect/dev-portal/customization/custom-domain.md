---
title: Add a Custom Domain
no_version: true
---

All Dev Portals have an auto-generated default Dev Portal URL. To further customize your Dev Portal, you can add a custom domain. When set up properly, users can access the Dev Portal from both the default URL and the custom URL. The Kong Developer Portal also generates an SSL certificate for your custom domain automatically. 

## Prerequisites

* You have the **Organization Admin** or **Portal Admin** role in {{site.konnect_saas}}.
* A domain and access to configure that domain's CNAME
* Your organization's auto-generated default Dev Portal URL. For example, `https://kong121212.portal.konnect.konghq.com/`.

## Direct your CNAME to the default Dev Portal URL

From your domain registrars DNS records settings options, point your CNAME to your Dev Portal's default URL. 


## Add a custom Dev Portal domain

Add a custom Dev Portal domain through your organization's {{site.konnect_short_name}} Admin UI.

1. In {{site.konnect_short_name}}, open **Dev Portal** from the left side menu, then click **Settings**.

2. Open the **Portal URL** tab.

3. Enter the full domain, including subdomain (if applicable). Don't include a path. It's not necessary to include the URL protocol, for example, `https://` into the **Custom Portal URL** field.

4. Test to see if your custom URL works. You'll see the custom URL listed in your Dev Portal under your default Dev Portal URL. Your SSL certificate will be generated automatically. 

   {:.note}
   > **Note:** DNS propagation can take a few hours. If after a few hours you can't access the Developer Portal from the custom URL, contact your domain registrar. 

