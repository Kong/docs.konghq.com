---
title: How to Add a Role and Permissions
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

### Introduction

**Roles** make it easy to logically group and apply the same 
set of **Permissions** to **Admins**. **Permissions** may be 
customized in detail, down to individual actions and endpoints.

Kong Enterprise includes default **Roles** for standard 
use cases, e.g. inviting additional **Super Admins**, 
inviting **Admins** that may only `read` endpoints. 

This guide describes how to create a custom **Role** in Kong 
Manager for a unique use case. As an alternative, if a 
**Super Admin** wants to create a **Role** with the Admin API, 
it is possible to do so using 
[`/rbac/roles`](/enterprise/{{page.kong_version}}/admin-api/rbac/reference/#add-a-role). 
To add **Permissions** to the new **Role**, use 
[`/rbac/roles/{name_or_id}/endpoints`](/enterprise/{{page.kong_version}}/admin-api/rbac/reference/#add-a-role-endpoint-permission) 
for endpoints or 
[`/rbac/roles/{name_or_id}/entities`](/enterprise/{{page.kong_version}}/admin-api/rbac/reference/#add-a-role-entity-permission) 
for specific entities.

### Prerequisites

* [`enforce_rbac = on`](/enterprise/{{page.kong_version}}/property-reference/#enforce_rbac)
* Kong Enterprise has [started](/enterprise/{{page.kong_version}}/getting-started/start-kong.md)
* Logged in to Kong Manager as a **Super Admin** 

## Video Walkthrough

<video width="100%" autoplay loop controls>
 <source src="https://konghq.com/wp-content/uploads/2019/02/role-creation-ent-34.mov" type="video/mp4">
 Your browser does not support the video tag.
</video>

## Step 1

On the **Admins** page, to create a new **Role**, click the 
**Add Role** button at the top right of the list of **Roles**. 

## Step 2

On the **Add Role** form, name the **Role** according to the 
**Permissions** you want to grant. 

![New Role naming](https://konghq.com/wp-content/uploads/2018/11/km-new-role.png)

**Note:** It may be helpful for future reference to include 
a brief comment describing the reason for the **Permissions** or 
a summary of the **Role**.

## Step 3

Click the **Add Permissions** button and fill out the form. Add the endpoint **Permissions** by marking the appropriate checkbox.

![New Role permissions](https://konghq.com/wp-content/uploads/2018/11/km-perms.png)

## Step 4

Click **Add Permission to Role** to see the permissions listed on the form.

![New Role permissions list](https://konghq.com/wp-content/uploads/2018/11/km-perms-list.png)

## Step 5

To forbid access to certain endpoints, click **Add Permission** 
again and use the **negative** checkbox.

![Negative permissions](https://konghq.com/wp-content/uploads/2018/11/km-negative-perms.png)

## Step 6 

Submit the form and see the new **Role** appear on the 
**Admins** page.

![Roles list](https://konghq.com/wp-content/uploads/2018/11/km-roles-list.png)
