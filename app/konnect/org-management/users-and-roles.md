---
title: Manage Users and Roles
no_version: true
---

## Overview

Many organizations have strict security requirements. For example, organizations
need the ability to segregate the duties of an administrator to ensure that a
mistake or malicious act by one administrator doesn’t cause an outage.
{{site.konnect_product_name}} provides the ability to manage authorization
through inviting users and granting them defined or custom roles, helping you
secure your administration environment.

{:.note}
> **Note:** If Okta integration is [enabled](/konnect/org-management/okta-idp),
{{site.konnect_short_name}} users and roles become read-only. An organization
admin can view all registered users in {{site.konnect_short_name}}, but cannot
edit them from the {{site.konnect_short_name}} side. To manage
automatically-created users, adjust user permissions through Okta, or
[adjust role mapping](/konnect/org-management/okta-role-mapping).


## Creating a new user

### Invite a new user
1. In {{site.konnect_saas}}, open the ![org icon](/assets/images/icons/konnect/konnect-organization.svg){:.inline .no-image-expand}
 **Organization > Users** page.
2. Click **Invite New User**.
3. Enter the user’s information, then click **Next**.
5. Assign a role or roles for the new user by checking the box next to the role.
    * A user can have more than one role.
    * For role descriptions, click the information (`i`) icon next to the role,
    or see the [Role Definitions section](#role-definitions) below.
6. Click **Invite User**.

    An email invitation is sent to the user.

### Accept invite and create account
1. Click on the link in the invitation email to set up your account.
2. Create a password.

    The password must be 8 characters long and contain at least two of the
    following: a lowercase letter, an uppercase letter, or a special
    character.

    The first and last name, organization, and email address are filled in for
    you and cannot be changed at this time.

3. Log in with your new account and test that you can access the resources
assigned to this account.

## Manage your organization

### View and manage users
1. In {{site.konnect_saas}}, open the ![org icon](/assets/images/icons/konnect/konnect-organization.svg){:.inline .no-image-expand}
 **Organization > Users** page.
2. From the Users page, you can:
   * View usernames, email addresses, and assigned role(s).
   * For users that have been invited but haven't set up an account yet,
   a **pending** indicator displays by their name.
   * To edit assigned roles, click the user's name to drill down to their
   assigned role(s) and the description of each role. Click
   **Actions > Add/Remove Roles** to add or remove role(s) from the
   selected user.

### View and manage roles
1. In {{site.konnect_saas}}, open the ![org icon](/assets/images/icons/konnect/konnect-organization.svg){:.inline .no-image-expand}
 **Organization > Roles** page.
2. From the Roles page, you can:
   * View role titles and a description of each role.
   * For each role, the number of users in your Konnect instance assigned to
   the role are listed in the Users column.
   * Hover over the number in the Users column to display the users assigned
   to the role.
   * Click a **Role** title to display the users assigned to the role and their
   email address.
   * Click **Actions > Add/Remove Users** to add or remove user(s) from the
   selected role.

## Role Definitions
When assigning a role or roles to a user, the following default roles are
available. Users can have more than one role.  

Keywords:
* **Fully manage**: Create, read, update, and delete
* **Partially manage**: Depends on the role

| Role                | Permission  |
|---------------------|-------------|
| Organization Admin  | Users can fully manage all objects, users, and roles in the organization. |
| Service Admin       | Users can fully manage services and versions, manage application registration, publish services to developer portal, and manage global configuration for consumers and plugins.|  
| Service Developer   | Users can view services, and fully manage versions of existing services and their Portal specs. |
| Portal Admin        | Users can fully manage all developer portal content, which includes service pages and supporting content, as well as Dev Portal configuration and Connections. |
| Service Page Editor | Users can partially manage (read, update) the documentation and specs for services and versions, publish services to the developer portal, and enable or disable application registration for service. |
| Runtime Admin       | Users can configure runtimes for the organization and fully manage related global configuration: upstreams, SNIs, and certs.
