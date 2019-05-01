---
title: How to Add an Admin
toc: false
---
#### Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Video Walkthrough](#video-walkthrough)
- [Step 1](#step-1)
- [Step 2](#step-2)
- [Step 3](#step-3)
- [Step 4](#step-4)
- [Step 5](#step-5)
- [Step 6](#step-6)
- [Next Steps](#next-steps)

### Introduction

An **Admin** is any user in Kong Manager. They may access 
Kong entities within their assigned **Workspaces** based 
on the **Permissions** of their **Roles**.

This guide describes how to invite an **Admin** in Kong 
Manager. As an alternative, if a **Super Admin** wants to 
invite an **Admin** with the Admin API, it is possible to 
do so using 
[`/admins`](/enterprise/{{page.kong_version}}/admin-api/admins/reference/#invite-an-admin).

### Prerequisites

* [`enforce_rbac = on`](/enterprise/{{page.kong_version}}/property-reference/#enforce_rbac)
* Kong Enterprise has [started](/enterprise/{{page.kong_version}}/getting-started/start-kong.md)
* Logged in to Kong Manager as a **Super Admin** 
* SMTP must be configured to [send invitation emails](/enterprise/{{page.kong_version}}/kong-manager/networking/email/),
but to simply test this workflow without actually sending 
an email, leave [`smtp_mock = on`](/enterprise/{{page.kong_version}}/property-reference/#smtp_mock). See 
[How to Copy and Send a Registration Link](/enterprise/{{page.kong_version}}/kong-manager/administration/admins/invite/#how-to-copy-and-send-a-registration-link) 
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

![Create New Admin](https://konghq.com/wp-content/uploads/2018/11/km-name-admin.png)

## Step 3

On the **Admin** page, the new invitee will appear on the list with 
the **invited**"** status. Once they accept the invitation, their 
status will change to **accepted**.

![Invited Admins](https://konghq.com/wp-content/uploads/2018/11/km-invited-admins.png)

## Step 4

The newly invited **Admin** will have the ability to set a password. 
If the **Admin** forgets the password, it is possible to reset it 
through a recovery email.

### Next Steps
