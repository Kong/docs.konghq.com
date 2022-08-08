---
title: Add a Workspace
badge: enterprise
---

### Introduction

Although an organization's teams share the same Kong cluster,
it is possible to divide the cluster into logical groups with
limited access. These **Workspaces** provide clearer
segmentation of traffic and entities. Each team's
access may be restricted to their own **Workspace**, supporting
the principle of least privilege.

The guide below describes how to create **Workspaces** in Kong
Manager. As an alternative, if a **Super Admin** wants to create
a **Workspace** with the Admin API, it is possible to do so
using the [`/workspaces/` route](/gateway/{{page.kong_version}}/admin-api/workspaces/reference/#add-workspace).

### Prerequisites

* [`enforce_rbac = on`](/gateway/{{page.kong_version}}/reference/configuration/#enforce_rbac)
* Kong Enterprise has [started](/gateway/{{page.kong_version}}/kong-production/running-kong/start-kong-securely)
* Logged in to Kong Manager as a **Super Admin**

## Step 1

On the **Workspaces** page, click the **New Workspace**
button at the top right to open the **Create Workspace** form.

## Step 2

Name the new **Workspace**.

{:.important}
> **Warning**: Each **Workspace** name should be unique,
regardless of letter case. For example, naming one
**Workspace** "Payments" and another one "payments" will
create two different workspaces that appear identical.

{:.important}
> **Warning**: Do not name workspaces the same as these major API names (paths) 
in Admin API:
>
> * Admins
> * APIs
> * Certificates
> * Consumers
> * Plugins
> * Portal
> * Routes
> * Services
> * SNIs
> * Upstreams
> * Vitals

## Step 3

Select a color or avatar to make each **Workspace** easier
to distinguish, or accept the default color.

## Step 4

Click the **Create New Workspace** button.

Upon creation, the **Workspace**'s **Dashboard** page will
appear.

## Step 5

On the left sidebar, click the **Admins** link in the
**Security** section. (If the sidebar is collapsed, hover over
the **security badge icon** at the bottom and click the
**Admins** link.)

### Next Steps

The **Admins** page displays a list of current **Admins** and
**Roles**. Four default **Roles** specific to the new
**Workspace** are already visible, and new **Roles** specific
to the **Workspace** can be assigned from this page.
