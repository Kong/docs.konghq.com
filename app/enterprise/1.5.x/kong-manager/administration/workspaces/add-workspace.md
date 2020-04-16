---
title: Add a Workspace
toc: false
redirect_from:
  - /enterprise/1.5.x/getting-started/add-workspace
  - /enterprise/latest/getting-started/add-workspace
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
using the [`/workspaces/` route](/enterprise/{{page.kong_version}}/admin-api/workspaces/reference/#add-workspace).

### Prerequisites

* [`enforce_rbac = on`](/enterprise/{{page.kong_version}}/property-reference/#enforce_rbac)
* Kong Enterprise has [started](/enterprise/{{page.kong_version}}/start-kong-securely)
* Logged in to Kong Manager as a **Super Admin**

## Video Walkthrough

<video width="100%" autoplay loop controls>
 <source src="https://konghq.com/wp-content/uploads/2019/02/new-workspace-ent-34.mov" type="video/mp4">
 Your browser does not support the video tag.
</video>

## Step 1

On the **Workspaces** page, click the **New Workspace**
button at the top right to open the **Create Workspace** form.

![New Workspace Form](https://konghq.com/wp-content/uploads/2018/11/km-new-workspace.png)

## Step 2

Name the new **Workspace**.

![Name the New Workspace](https://konghq.com/wp-content/uploads/2018/11/km-name-ws.png)

⚠️ **WARNING**: Each **Workspace** name should be unique,
regardless of letter case. For example, naming one
**Workspace** "Payments" and another one "payments" will
create two different workspaces that appear identical.

⚠️ **WARNING**: Do not name Workspaces the same as these major
routes in Kong Manager:

* Admins
* APIs
* Certificates
* Consumers
* Plugins
* Portal
* Routes
* Services
* SNIs
* Upstreams
* Vitals

## Step 3

Select a color or avatar to make each **Workspace** easier
to distinguish, or accept the default color.

![Select Workspace Color](https://konghq.com/wp-content/uploads/2018/11/km-color-ws.png)

## Step 4

Click the **Create New Workspace** button.

![New Dashboard](https://konghq.com/wp-content/uploads/2018/11/km-new-dashboard.png)

Upon creation, the **Workspace**'s **Dashboard** page will
appear.

## Step 5

On the left sidebar, click the **Admins** link in the
**Security** section. (If the sidebar is collapsed, hover over
the **security badge icon** at the bottom and click the
**Admins** link.)

![Admins Hover Over](https://konghq.com/wp-content/uploads/2018/11/admins-section.png)

### Next Steps

The **Admins** page displays a list of current **Admins** and
**Roles**. Four default **Roles** specific to the new
**Workspace** are already visible, and new **Roles** specific
to the **Workspace** can be assigned from this page.

![New Workspace Admins](https://konghq.com/wp-content/uploads/2018/11/km-ws-admins.png)
