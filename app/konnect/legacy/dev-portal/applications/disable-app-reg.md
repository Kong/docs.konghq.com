---
title: Disable App Registration for a Service
no_version: true
---

You can disable app registration for a Service when an API
no longer requires authentication. If you want to disable Auto Approve at the
Service level, disable app registration and then enable it again with the Auto Approve
toggle set to disabled.

Disable application registration from the Service Version page **only**.
Do not attempt to disable application registration by deleting or disabling the
read-only application registration plugins (`acl` and `key-auth` or `openid-connect`).
Attempting to remove them manually will break your Service. See the
Application Overview section on
[{{site.konnect_short_name}}-managed plugins](/konnect/dev-portal/applications/application-overview/#konnect-managed-plugins)
for more information.

You can
[enable application registration](/konnect/dev-portal/applications/enable-app-reg)
again any time.

## Disable app registration

1. From the {{site.konnect_short_name}} menu, click **Services** and select a Service.

1. From the **Actions** menu, select **Disable app registration**.

1. Click **Disable**.
