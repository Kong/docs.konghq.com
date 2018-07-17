---
title: Networking
book: admin_gui
chapter: 5
---

# Networking

This document describes the default networking configuration for the Admin GUI as well as common custom configurations. 


## Default Configuration

By default, the Admin GUI starts up without authentication (`admin_gui_auth`), 
and it assumes that the Admin API is available on port 8001 (`admin_api_port`) 
of the same host that serves the Admin GUI.


## Custom Configuration

Common configurations to enable are

1. serving the Admin GUI from a dedicated Kong node 
1. securing the Admin GUI via a Kong authentication plugin
1. securing the Admin GUI and serving it from a dedicated node

When (1) **the Admin GUI is on a dedicated Kong node**, it must make external 
calls to the Admin API. Set `admin_uri` to the location of your Admin API.

When (2) **the Admin GUI is secured via an authentication plugin and _not_ on 
a dedicated node**, it makes calls to the Admin API via the Kong proxy (which 
executes the plugin). By default, the proxy listens on ports 8000 and 8443 on 
localhost. Change `proxy_listen` if necessary, or set `proxy_url`.

When (3) **the Admin GUI is secured and served from a dedicated node**, set 
`proxy_url` to the location of the Kong proxy. The Admin API is not used 
directly in this case.

The table below summarizes which properties to set (or defaults to verify) 
when configuring the Admin GUI connectivity to the Admin API.

authentication enabled | local API    | remote API | auth settings
-----------------------+--------------+------------+--------------
yes                    | proxy_listen | proxy_url  | admin_gui_auth, enforce_rbac, admin_gui_auth_conf
no                     | admin_listen | admin_uri  | n/a

To enable authentication, configure the following properties:

- `admin_gui_auth` - to indicate which Kong auth plugin to use
- `admin_gui_auth_conf` (optional) - to configure the auth plugin
- `enforce_rbac` - to `on` or `both`

When Admin GUI authentication is enabled, RBAC must be turn on to enforce 
authorization rules. Otherwise, whoever can log in to the Admin GUI or
access the Admin API proxy can perform any operation available on the Admin 
API.

### The Admin API Proxy

When you enable `admin_gui_auth` Kong creates a service that routes to 
`/_kong/admin`. This route is accessible on the proxy to which the Admin 
GUI connects to make API requests, and it is secured by the authentication 
plugin that you specified. *This route is intended for the Admin GUI 
application only* and should not be used in any scripts or external tools 
that connect to Kong. For these purposes, use the Admin API on its regular 
host and port, secured with RBAC.

Next: [Property Reference &rsaquo;]({{page.book.next}})
