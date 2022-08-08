---
title: Add an Admin
badge: enterprise
---

### Introduction

An **Admin** is any user in Kong Manager. They may access
Kong entities within their assigned **Workspaces** based
on the **Permissions** of their **Roles**.

This guide describes how to invite an **Admin** in Kong
Manager. As an alternative, if a **Super Admin** wants to
invite an **Admin** with the Admin API, it is possible to
do so using
[`/admins`](/gateway/{{page.kong_version}}/admin-api/admins/reference/#invite-an-admin).

### Prerequisites

* [`enforce_rbac = on`](/gateway/{{page.kong_version}}/reference/configuration/#enforce_rbac)
* Kong Enterprise has [started](/gateway/{{page.kong_version}}/kong-production/running-kong/start-kong-securely)
* Logged in to Kong Manager as a **Super Admin**
* SMTP must be configured to [send invitation emails](/gateway/{{page.kong_version}}/kong-manager/configuring-to-send-email/),
but to simply test this workflow without actually sending
an email, leave [`smtp_mock = on`](/gateway/{{page.kong_version}}/reference/configuration/#smtp_mock). See
[How to Copy and Send a Registration Link](/gateway/{{page.kong_version}}/kong-manager/admins/invite/#how-to-copy-and-send-a-registration-link)
for details on how to
copy a registration link instead of sending an email.

## Step 1

On the **Admins** page, to invite a new **Admin**, click the
**Create New Admin** button.

## Step 2

Assign the appropriate **Role** and click "Invite Admin" to send
the invitation.

**Note:** When a new **Admin** receives an invitation, they will
only be able to log in with that email address.

## Step 3

On the **Admin** page, the new invitee will appear on the list with
the **invited** status. Once they accept the invitation, their
status will change to **accepted**.

## Step 4

The newly invited **Admin** will have the ability to set a password.
If the **Admin** forgets the password, it is possible to reset it
through a recovery email.
