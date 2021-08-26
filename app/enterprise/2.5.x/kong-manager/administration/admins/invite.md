---
title: Invite an Admin
book: admin_gui
---

### Invite an Admin

1. Navigate to the **Teams** page in Kong Manager

2. From the **Admins** tab select **Invite Admin**

3. Fill out the username and email address. When a new **Admin** receives an 
invitation, they will only be able to log in with that email address. Assign the appropriate **Role** and click **Invite User** to send the invitation.

    ⚠️ **IMPORTANT**: **Super Admins** can invite users to multiple **Workspaces**, and 
    assign them any **Role** available within **Workspaces**, including **Roles** that exist 
    by default (e.g. `super-admin`, `read-only`) and **Roles** with customized 
    permissions. 

    ⚠️ **IMPORTANT**: The **Super Admin** can see all available roles across 
    **Workspaces** on the **Roles** tab of the **Organization** page.
    
    ⚠️ **IMPORTANT**: By default, the registration link will expire after 259,200 
    seconds (3 days). This time frame can be configured with the `kong.conf` 
    file in `admin_invitation_expiry`.
 
    ⚠️ **IMPORTANT**: If an email fails to send, either due to an incorrect email 
    address or an external error, it will be possible to resend an invitation.

    ⚠️ **IMPORTANT**: If SMTP is not enabled or the invitation email fails to send, 
    it is possible for the Super Admin to copy and provide a registration link 
    directly. See the next section.


4. On the **Teams** page, the new invitee will appear on the **Admins** list with the under **Invited**. Once they accept the invitation, the user will be listed in the main **Admins** list. 

    ![Invited Admins](https://doc-assets.konghq.com/1.3/manager/teams/teams-invited-admin.png)

5. The newly invited **Admin** will have the ability to set a password. If the **Admin** ever forgets the password, it is possible for them to reset it through a recovery email.


### How to Copy and Send a Registration Link

If a mail server is not yet set up, it is still possible to invite Admins to register and log in. 

1. Invite an **Admin** as described in the section above. 

2. If the "View" link is clicked next to the invited Admin's name, a 
    `register_url` is displayed on the invitee's details page. 

    ![Registration URL](https://doc-assets.konghq.com/1.3/manager/teams/teams-invite-admin-generate-registration-link.png)

3. Copy and directly send this link to the invited Admin so that they may set 
    up their credentials and log in. 

>⚠️ **IMPORTANT**: If `admin_gui_auth` is `ldap-auth-advanced`, credentials are not stored in Kong, and the Admin will be directed to Login.

## How to Grant an Admin Access with LDAP

1. Pick a user in the LDAP Directory that will be the Super Admin. 

2. Change the Super Admin’s username in Kong by making a `PATCH` request to
`admins/kong_admin` and setting the value of `username` to the corresponding 
LDAP `attribute`. 

For example, if the LDAP user's attribute is `einstein`, 
the `PATCH` to `/admins/kong_admin` should have a `username` set to `einstein`.

3. Log in to Kong Manager using the LDAP credentials associated with the Super 
Admin.

4. Invite Admins from the "Admins" page in Kong Manager, ensuring that the 
`username` of each Admin is mapped to the `attribute` value set in the LDAP 
directory.

        ⚠️ **IMPORTANT**: To enable the Admins to log in, it is still necessary 
        to assign a Role to them.

5. Once an Admin has logged in successfully and accesses the Admin API using 
their LDAP credentials, they will be marked as “approved” on the "Admins" list 
in Kong Manager

        ⚠️ **IMPORTANT**: The new Admins will still receive an email, but all 
        credentials will be handled through the LDAP server, not Kong Manager 
        or the Admin API.
