---
title: Networking
book: admin_gui
chapter: 4
---

## Introduction

This document describes the default networking configuration for Kong Manager 
as well as common custom configurations. 


## Default Configuration

By default, Kong Manager starts up without authentication (`admin_gui_auth`), 
and it assumes that the Admin API is available on port 8001 (`admin_api_port`) 
of the same host that serves Kong Manager.


## Custom Configuration

Common configurations to enable are

* Serving Kong Manager from a dedicated Kong node 

  When **Kong Manager is on a dedicated Kong node**, it must make external 
  calls to the Admin API. Set `admin_api_uri` to the location of your Admin API.

* Securing Kong Manager through a Kong authentication plugin

  When **Kong Manager is secured through an authentication plugin and _not_ on 
  a dedicated node**, it makes calls to the Admin API on the same host. By 
  default, the Admin API listens on ports 8001 and 8444 on 
  localhost. Change `admin_listen` if necessary, or set `admin_api_uri`.

* Securing Kong Manager and serving it from a dedicated node

  When **Kong Manager is secured and served from a dedicated node**, set 
  `admin_api_uri` to the location of the Admin API.

The table below summarizes which properties to set (or defaults to verify) 
when configuring Kong Manager connectivity to the Admin API.

| authentication enabled | local API    | remote API    | auth settings                                     |
|------------------------|--------------|---------------|---------------------------------------------------|
| yes                    | admin_listen | admin_api_uri | admin_gui_auth, enforce_rbac, admin_gui_auth_conf |
| no                     | admin_listen | admin_api_uri | n/a                                               |

To enable authentication, configure the following properties:

* [`admin_gui_auth`](/enterprise/{{page.kong_version}}/property-reference/#admin_gui_auth) set to the desired plugin
* [`admin_gui_auth_conf`](/enterprise/{{page.kong_version}}/property-reference/#admin_gui_auth_conf) (optional)
* [`enforce_rbac`](/enterprise/{{page.kong_version}}/property-reference/#enforce_rbac) set to `on`

⚠️ When Kong Manager authentication is enabled, RBAC must be turned on to 
enforce authorization rules. Otherwise, whoever can log in to Kong Manager can 
perform any operation available on the Admin API.

## Configuring Kong Manager to Send Email

A Super Admin can invite other Admins to register in Kong Manager, and Admins 
can reset their passwords using "Forgot Password" functionality. Both of these 
workflows use email to communicate with the user. 

Emails from Kong Manager require the following configuration:

* [`admin_emails_from`](/enterprise/{{page.kong_version}}/property-reference/#admin_emails_from)
* [`admin_emails_reply_to`](/enterprise/{{page.kong_version}}/property-reference/#admin_emails_reply_to)
* [`admin_invitation_expiry`](/enterprise/{{page.kong_version}}/property-reference/#admin_invitation_expiry)

⚠️**Important:** If the SMTP settings are configured incorrectly, 
e.g. if they point to a non-existent email address, Kong Manager will not 
display errors. 

In addition, refer to the 
[general SMTP configuration](enterprise/{{page.kong_version}}/property-reference/#general-smtp-configuration) 
shared by Kong Manager and Dev Portal.


Next: [Workspaces &rsaquo;]({{page.book.next}})
