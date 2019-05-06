---
title: Securing Kong Manager
book: admin_gui
---
## What Can Admins Do in Kong Manager?

Kong Manager enables users with **Admin** accounts to access Kong entities such as **Services**, **Plugins**, and **Consumers.**

The following document summarizes Kong Manager's controls for *authentication* and *authorization*. 

## Authentication with Plugins

Kong Enterprise comes packaged with **Authentication Plugins** that can be used to secure Kong Manager. Unlike enabling a **Plugin** on an entity or cluster, enabling an **Authentication Plugin** for Kong Manager *only* requires turning on `enforce_rbac`, setting `admin_gui_auth` to the desired type, and configuring `admin_gui_auth_conf` if needed.

* [**Basic Auth**](https://kongdocs-private.netlify.com/enterprise/0.35-x/kong-manager/authentication/basic/)
* **[OIDC](https://kongdocs-private.netlify.com/enterprise/0.35-x/kong-manager/authentication/oidc/)**
* **[LDAP](https://kongdocs-private.netlify.com/enterprise/0.35-x/kong-manager/authentication/ldap/)**

In addition to the **Authentication Plugins** above, the new **[Sessions Plugin](https://kongdocs-private.netlify.com/enterprise/0.35-x/kong-manager/authentication/sessions/)** may be used to send HTTP cookies to authenticate client requests and maintain session information.

## Access Control with Roles and Workspaces

An **Admin** belongs to a **Workspace** and should have at least one **Role** with a set of **Permissions**. If an **Admin** is in a **Workspace** *without* a **Role**, they will not have the ability to see or interact with anything.

By creating separate** [Workspaces](https://kongdocs-private.netlify.com/enterprise/0.35-x/kong-manager/administration/workspaces/workspaces/)**, an organization with multiple teams can segment its Kong cluster so that different teams do not have access to each other's Kong entities. 

Kong Enterprise implements Role-Based Access Control ([RBAC](https://kongdocs-private.netlify.com/enterprise/0.35-x/kong-manager/administration/rbac/rbac/)). **Admins** are assigned **Roles** that have clearly defined **Permissions**. A **Super Admin** has the ability to: 

* further customize **Permissions**
* create entirely new **Roles**
* invite or deactivate **Admins**
* assign or revoke their **Roles**

In Kong Manager, limiting **Permissions** also restricts the visibility of the application interface and navigation.