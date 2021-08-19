---
title: Map Konnect Roles to Okta Groups
no_version: true
badge: enterprise
---
By mapping Okta groups to [{{site.konnect_short_name}} roles](/konnect/org-management/users-and-roles),
you can manage a user's {{site.konnect_short_name}} roles directly through Okta group membership.

After mapping is set up:
* Okta users belonging to the mapped groups can log into {{site.konnect_short_name}}.
* When a user logs into {{site.konnect_short_name}} with their Okta account for the first time,
{{site.konnect_short_name}} automatically provisions an account with the relevant permission.
* If your org already has non-admin {{site.konnect_short_name}} users before mapping, on their next
login they will be mapped to the roles defined by their Okta group membership.
* An organization admin can view all registered users in {{site.konnect_short_name}},
but cannot edit them from the {{site.konnect_short_name}} side. To manage
automatically-created users, adjust user permissions through Okta, or
adjust the role mapping.

Any changes to the mapped Okta groups on the Okta side are reflected in
{{site.konnect_saas}}. For example:
* Removing a user from a group in Okta also deactivates their {{site.konnect_short_name}} account
* Moving a user from one group to another changes their permissions in Konnect
to align with the new group-to-role mapping.

## Prerequisites
* [Organization Admin](/konnect/reference/org-management/#role-definitions)
permissions in {{site.konnect_saas}}
* Access to the Okta configuration for your organization
* [Okta authentication enabled](/konnect/org-management/okta-idp) for {{site.konnect_saas}}
* [Groups created](https://help.okta.com/en/prod/Content/Topics/users-groups-profiles/usgp-groups-main.htm)
in the Okta application

## Find groups in Okta
1. Sign in to your [Okta admin account](https://admin.okta.com/).
1. From the left menu, select **Directory > Groups**.
1. Find the groups that you want to map to {{site.konnect_short_name}} roles.

## Map groups to roles in Konnect
Map Okta groups directly to {{site.konnect_short_name}} roles.

1. In [{{site.konnect_saas}}](https://konnect.konghq.com), open
![settings icon](/assets/images/icons/konnect/konnect-settings.svg){:.inline .no-image-expand}
 **Settings** from the left menu, then **Identity Management**.
1. Scroll down to **Role Mapping**.
1. Enter your Okta groups in the relevant fields, then save.

    For example, if you have a `service_admin` group in Okta, you might map it
    to the `Service Admin` role in {{site.konnect_short_name}}. You can hover over the info icon
    beside each field to learn more about the role, or see
    [Users and Roles](/konnect/org-management/users-and-roles) for more information.

    You can now manage your org's user permissions entirely from the Okta
    application.

## Test role mapping and user creation
1. Go to your {{site.konnect_short_name}} organization's login URI.

    You can always find it under ![settings icon](/assets/images/icons/konnect/konnect-settings.svg){:.inline .no-image-expand}
     **Settings > Identity Management**, then copy **Organization Login URI** from this page.

1. Using an account that belongs to one of the groups you just mapped
(for example, an account belonging to the `service_admin` group in Okta), log
in with your Okta credentials.

    If a group-to-role mapping exists, the user is automatically provisioned with
    a {{site.konnect_saas}} account with the relevant permissions.

1. Log out of this account, and log back in with a {{site.konnect_short_name}} admin account.

1. In the left menu, select **Organization**.

    You should see a list of users in this org, including a new entry for the
    previous user and the role that they were assigned.


## Okta reference docs
* [Create claims in Okta](https://developer.okta.com/docs/guides/customize-authz-server/create-claims/)
* [Groups claim](https://developer.okta.com/docs/guides/customize-tokens-groups-claim/add-groups-claim-custom-as/)
* [Custom claims](https://developer.okta.com/docs/guides/customize-tokens-returned-from-okta/add-custom-claim/)
