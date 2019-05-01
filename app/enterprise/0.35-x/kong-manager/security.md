---
title: Securing Kong Manager
book: admin_gui
---
## What Can Admins Do in Kong Manager?

Kong Manager enables users with **Admin** accounts to interact with 
Kong entitities such as **Services**,**Plugins**, and **Consumers**
using a graphical interface. 

An **Admin** belongs to a **Workspace** and has at least one **Role** 
with a set of **Priviliges**. 

The following document summarizes Kong Manager's 
security controls for authentication and authorization. 

## Authentication with Plugins

Kong Enterprise comes packaged with **Authentication Plugins** 
that can be used to secure Kong Manager. Unlike enabling a **Plugin** 
on an entity, using an **Authentication Plugin** for Kong Manager 
simply requires enabling [`enforce_rbac`]() 
and setting 
[`admin_gui_auth`]() 
to the desired **Plugin**.

To use **Basic Authentication**

## Sessions

## Authorization with RBAC and Workspaces

### Workspaces

### Role-Based Access Control

## Network Configuration

To support security at the network level, refer to Kong Manager's 
[Custom Networking Configuration](/enterprise/{{page.kong_version}}/kong-manager/networking/configuration/#custom-configuration).