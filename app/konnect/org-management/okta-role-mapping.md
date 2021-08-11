---
title: Map Konnect Roles to Okta Groups
no_version: true
badge: enterprise
---
By mapping Okta groups to [Konnect roles](/konnect/org-management/users-and-roles),
you can manage user authorization directly through your Okta app.

After mapping is set up:
* Okta users belonging to the mapped groups can log into Konnect.
* When a user logs into Konnect with their Okta account for the first time,
Konnect will automatically provision an account with the relevant permission.
* As a Konnect org admin, you will be able to see those users in Konnect,
but you won't be able to edit them from the Konnect side. To manage
automatically-created users, adjust user permissions through Okta.
* If your org already has non-admin Konnect users before mapping, they will be
mapped to the Okta application.

Any changes to the mapped Okta groups on the Okta side will be reflected in
{{site.konnect_saas}}. For example:
* Removing a user from a group in Okta will also deactivate their Konnect account
* Moving a user from one group to another will change their permissions in Konnect
to align with the new group-to-role mapping.

## Prerequisites
* [**Organization Admin**](/konnect/reference/org-management/#role-definitions)
permissions in Konnect Cloud
* [Okta admin account](https://admin.okta.com/)
    (not a developer account? and should we even provide a URL; they will probably have an org-specific URL, right?)
* Okta authentication enabled for {{site.konnect_saas}}
* [Groups created](https://help.okta.com/en/prod/Content/Topics/users-groups-profiles/usgp-groups-main.htm) in the Okta application

## Find groups in Okta
1. Sign in to your [Okta admin account](https://admin.okta.com/).
1. From the left menu, select **Directory > Groups**.
1. Find the groups that you want to map to Konnect roles.

## Map groups to roles in Konnect
Map Okta groups directly to Konnect roles.

1. In [Konnect Cloud](https://konnect.konghq.com), open
![settings icon](/assets/images/icons/konnect/konnect-settings.svg){:.inline .no-image-expand}
**Settings** from the left menu, then **Identity Management**.
1. Scroll down to **Role Mapping**.
1. Enter your Okta groups in the relevant fields, then save.

    For example, if you have a `service_admin` group in Okta, you might map it
    to the `Service Admin` role in Konnect. You can hover over the info icon
    beside each field to learn more about the role, or see
    [Users and Roles](/konnect/org-management/users-and-roles) for more information.

    You can now manage your org's user permissions entirely from the Okta
    application.

## Test role mapping and user creation
1. Go to your Konnect organization's login URI.

    You can always find it under ![settings icon](/assets/images/icons/konnect/konnect-settings.svg){:.inline .no-image-expand}
    **Settings > Identity Management**, then copy **Organization Login URI** from this page.

1. Using an account that belongs to one of the groups you just mapped
(for example, an account belonging to the `service_admin` group in Okta), log
in with your Okta credentials.

    If a group-to-role mapping exists, the user is automatically provisioned with
    a {{site.konnect_saas}} account with the relevant permissions.

1. Log out of this account, and log back in with a Konnect admin account.

1. In the left menu, select **Organization**.

    You should see a list of users in this org, including a new entry for the
    previous user and the role that they were assigned.
