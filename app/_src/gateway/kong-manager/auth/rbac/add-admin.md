---
title: Invite an Admin
badge: enterprise
---

An admin is any user in Kong Manager. They may access
Kong entities within their assigned workspaces based
on the permissions of their roles.

This guide describes how to invite an admin in Kong
Manager. As an alternative, if a super admin wants to
invite an admin with the Admin API, it is possible to
do so using
[`/admins`](/gateway/{{page.release}}/admin-api/admins/reference/#invite-an-admin).

## Prerequisites

* Authentication and RBAC are [enabled](/gateway/{{page.release}}/kong-manager/auth/rbac/enable/)
* You have [super admin permissions](/gateway/{{page.release}}/kong-manager/auth/super-admin/)
or a user that has `/admins` and `/rbac` read and write access

## Invite an admin

1. Navigate to the **Teams** page in Kong Manager.

2. From the **Admins** tab, select **Invite Admin**.

3. Fill out the username and email address. When a new admin receives an
invitation, they will only be able to log in with that email address. Assign any appropriate roles and click **Invite Admin** to send the invitation.

     Super admins can invite users to multiple workspaces, and
    assign them any role available within workspaces, including roles that exist by default (for example, `super-admin`, `read-only`) and roles with customized permissions.

    The super admin can see all available roles across
    workspaces on the **Roles** tab of the **Teams** page.


4. On the **Teams** page, the new invitee will appear on the **Admins** list in the **Invited** section.
Once they accept the invitation, the user will be listed in the main **Admins** list.

    By default, the registration link will expire after 259,200
    seconds (3 days). This time frame can be configured in the `kong.conf`
    file using the [`admin_invitation_expiry`](/gateway/{{page.release}}/reference/configuration/) property.

    If an email fails to send, either due to an incorrect email
    address or an external error, you can resend the invitation.

    If SMTP is not enabled or the invitation email fails to send,
    the super admin can copy and provide a registration link directly.

5. The newly invited admin will have the ability to set a password. If the admin ever forgets the password, they can reset it through a recovery email.

## Copy and send a registration link

If a mail server is not yet set up, it is still possible to invite admins to register and log in.

1. Invite an admin as described in the section above.

2. Open the admin's info page. Next to `register_url`, click the **Generate registration link** button.

    Copy and directly send this link to the invited admin so that they may set
    up their credentials and log in.

If `admin_gui_auth` is `ldap-auth-advanced`, credentials are not stored in Kong, and the admin will be directed to log in.

## Grant an admin access with LDAP

1. Pick a user in the LDAP directory that will be the super admin.

2. Change the super admin’s username in Kong by making a `PATCH` request to
`admins/kong_admin` and setting the value of `username` to the corresponding
LDAP `attribute`.

    For example, if the LDAP user's attribute is `einstein`,
    the `PATCH` to `/admins/kong_admin` should have a `username` set to `einstein`.

3. Log in to Kong Manager using the LDAP credentials associated with the super
admin.

4. Invite admins from the **Admins** page in Kong Manager, ensuring that the
`username` of each Admin is mapped to the `attribute` value set in the LDAP
directory.

    To enable the admins to log in, it is still necessary
    to assign a role to them.

5. Once an admin has logged in successfully and accesses the Admin API using
their LDAP credentials, they will be marked as `approved` on the Admins list
in Kong Manager.

    The new admins will still receive an email, but all
    credentials will be handled through the LDAP server, not Kong Manager
    or the Admin API.
