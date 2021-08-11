---
title: Disable App Registration for a Service
no_version: true
---

Disabling application registration
deletes all plugins that were initially enabled for a Service. You cannot manually
delete a plugin that was automatically enabled by app registration, such as the
`acl` and `key-auth` or `openid-connect` plugins that
were automatically enabled in tandem when app registration was enabled.
When app registration is enabled, you cannot disable
those authentication plugins either. If you attempt to do so, a modification not
allowed when application registration message appears. The only way to (indirectly, automatically)
delete the automatically enabled authentication plugins is to disable app registration.
Any other plugins that were enabled manually, such as `rate-limiting`, remain enabled.

The main reason for disabling app registration for a Service is when an API
no longer requires authentication. If you want to disable Auto Approve at the
Service level, disable app registration and then enable it again with the Auto Approve
toggle set to disabled.

You can
[enable application registration](/konnect/dev-portal/administrators/app-registration/enable-app-reg)
again any time.

1. From the {{site.konnect_short_name}} menu, click **Services**.

   ![Konnect Services Page](/assets/images/docs/konnect/konnect-services-page.png)

2. Depending on your view, click the tile for the Service in cards view or the row
   for the Service in table view.

   ![Konnect Disable App Registration](/assets/images/docs/konnect/konnect-disable-app-reg.png)

3. From the **Actions** menu, click **Disable app registration**.

   ![Konnect Confirm Disable App Registration](/assets/images/docs/konnect/konnect-confirm-disable-app-reg.png)

4. Click **Disable**.
