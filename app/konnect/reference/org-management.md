---
title: Managing Users and Roles
no_version: true
---

## Overview

Many organizations have strict security requirements. For example, organizations
need the ability to segregate the duties of an administrator to ensure that a
mistake or malicious act by one administrator doesn’t cause an outage.
{{site.konnect_product_name}} provides the ability to manage authorization
through inviting users and granting them defined or custom roles, helping you
secure your administration environment.

## Creating a New User

### Invite a New User
1. Go to the **Organization > Users** page.
2. Click **Invite New User**.
3. Enter the user’s information, including first name, last name, and email
address to send an email invitation.
4. Click **Next**.
5. Assign a role or roles for the new user by checking the box next to the role.
Note:
    * A user can have more than one role.
    * For role descriptions, click the information (`i`) icon next to the role,
    or see the [Role Definitions section](#role-definitions) below.
6. Click **Invite User**. An email invitation is sent to the user.

### Accept Invite and Create Account
1. Click on the link in the invitation email to set up your account.
2. The first and last name, organization, and email address are filled in for
 you and cannot be changed at this time. Fill in the remaining two fields:

    1. Create a password.

        The password must be 8 characters long and contain at least two of the
        following: a lowercase letter, an uppercase letter, or a special
        character.

    2. In the **Access Code** field, enter the code provided in your invitation
    email.
3. Log in with your new account and test that you can access the resources
assigned to this account.

## Viewing and Managing your Organization

### View and Manage Users
1. Go to the **Organization > Users** page.
2. From the Users page, actions you can perform include:
   * View usernames, email addresses, and assigned role(s).
   * For users that have been invited but haven't set up an account yet,
   a **pending** indicator displays by their name.
   * To edit assigned roles, click the user's name to drill down to their
   assigned role(s) and the description of each role. Click
   **Actions > Add/Remove Roles** to add or remove role(s) from the
   selected user.

### View and Manage Roles
1. Go to the **Organization > Roles** page.
2. From the Roles page, actions you can perform include:
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
available. Default roles are included in every organization, and users can have
more than one role.  

| Role                | Permission  |
|---------------------|-------------|
| Organization Admin  | Full CRUD (create, read, update, and delete) on all objects within an organization, including user and organization configuration. |
| Service Admin       | Full CRUD on Services, and the ability to publish and unpublish Services to the Portal.|  
| Service Developer   | Full CRUD on Service Versions. |
| Portal Admin        | Read and update permissions on the Portal landing page and the Service Detail pages.|
| Service Page Editor | Read and update permissions for individual Service pages, and for creating and registering Applications.|
