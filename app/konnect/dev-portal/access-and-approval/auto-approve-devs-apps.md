---
title: Auto Approve Developer and Application Registrations
content_type: how-to
---

When auto approval is enabled, {{site.konnect_short_name}} admins don't
need to manually approve developer and application requests. You can enable automatic approval from the Dev Portal settings.

If auto approve is not enabled for developers or applications, admins will need to approve new developers and applications manually. For more information on manual approval, see [Manage Developer Access](/konnect/dev-portal/access-and-approval/manage-devs/) and [Manage Application Registration Requests](/konnect/dev-portal/access-and-approval/manage-app-reg-requests/).

{:.note}
> Developer auto approve only affects registrations using the built-in basic authentication. When using [SSO login](/konnect/dev-portal/dev-reg/#sso), a developer is created and approved automatically, even when developer auto approve is disabled.

{:.note}
> If application auto approve is enabled through the Dev Portal settings, it overrides the API product version setting.

## Enable or disable auto approve

Auto approve is disabled by default. You can enable and disable approvals at any time. If there are any pending requests when auto approve is enabled, those requests must be manually approved.

To enable or disable auto approve, open {% konnect_icon dev-portal %}
 **Dev Portal**, then click **Settings**. In the settings, follow these steps:

1. Toggle to enable or disable auto approve for the following options:
      * Auto Approve Developers
      * Auto Approve Applications

2. Click **Save**.
