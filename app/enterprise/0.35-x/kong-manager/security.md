---
title: Securing Kong Manager
book: admin_gui
---
## What Can Admins Do in Kong Manager?

Kong Manager enables users with **Admin** accounts to interact with 
Kong entitities such as **Services**,**Plugins**, and **Consumers**
using a graphical interface. An **Admin** belongs to a **Workspace** 
and has a **Role** in order to confine **Priviliges** based on a need 
to know. Various **Authentication Plugins** that can be applied to
Kong resources may also be applied to Kong Manager itself through
configuration. The following document summarizes Kong Manager's 
security controls for authentication and authorization. 

## Authentication with Plugins

Why use Basic Auth?

How to use Basic Auth.

Why use LDAP?

How to use LDAP.

Why use OIDC?

How to use OIDC.

Kong Manager may be configured to use a variety of **Authentication
Plugins**. 

### Identification

Depending on the type of authentication, is possible to 
identify Admins by username, email, or custom ID. The following 
table shows how users are identified based on the authentication 
type in Kong Manager:

Basic - custom_id, email, or username - 
LDAP - custom_id - 
OIDC - email - 

### Sessions

## Authorization with RBAC and Workspaces

### Workspaces

### Role-Based Access Control

## Accounting with Audit Logs

## Network Configuration

To support security at the network level, refer to Kong Manager's 
[Custom Networking Configuration](/enterprise/{{page.kong_version}}/kong-manager/networking/configuration/#custom-configuration).