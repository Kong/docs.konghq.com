---
title: Org Switcher
content_type: how-to
---

The org switcher allows a user with multiple {{site.konnect_short_name}} accounts to seamlessly switch between their organizations. You can navigate to the org switcher by clicking on **Your Org Name** > **Back to Org Switcher**.

From the org switcher, you can:
- View a list of {{site.konnect_short_name}} organizations to which you have access
- Login to a different {{site.konnect_short_name}} organization
- Create a new {{site.konnect_short_name}} organization

## Email Matching

The org switcher uses the email of the logged in user to locate all organizations where this email is attached to a {{site.konnect_short_name}}. 

In order to gain access to more organizations, the user may:
- Create a new organization - Newly created organizations will automatically show up in the org switcher.
- Be invited to an organization - Organizations that the user is invited to will automatically show up in the org switcher.

{:.note}
> **Note**: It is possible to end up with more than one org switcher identities if the user does not choose to “Link Accounts” when logging into {{site.konnect_short_name}} for the very first time on different social credentials. Organizations will only be associated with one primary account. It is not currently possible to re-link accounts. {{site.konnect_short_name}} recommends “Linking Accounts” when using multiple social identities.

## Switch Organizations

Users can switch organizations while logged in by clicking on the **Org Name** > **Back to Org Switcher**.
The user can login to each organization listed in the org switcher by clicking on the Select  button.

If the organization is configured to be single-sign-on only, then the user will be directed to the configured identity provider to re-authenticate into {{site.konnect_short_name}}.

{:.note}
> **Note**: You cannot be logged in to more than one {{site.konnect_short_name}} organization at the same time. You must return to the org switcher in order to switch to another organization.


## Delete Organizations from Org Switcher

In order to remove organizations from the org switcher, the user can login to that organization and navigate to [**My Account**](https://cloud.konghq.com/global/account) > **Delete Account**. This will delete the {{site.konnect_short_name}} account in that organization and remove the org from org switcher.