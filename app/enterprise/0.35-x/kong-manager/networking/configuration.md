---
title: Default and Custom Networking Configuration for Kong Manager
book: admin_gui
---

## Default Configuration

By default, Kong Manager starts up without authentication (see 
[`admin_gui_auth`]), and it assumes that the Admin API is available 
on port 8001 (see [`admin_api_port`]) of the same host that serves 
Kong Manager.

## Custom Configuration

Common configurations to enable are

* Serving Kong Manager from a dedicated Kong node 

  When Kong Manager is on a dedicated Kong node, it must make 
  external calls to the Admin API. Set [`admin_api_uri`] to the 
  location of your Admin API.

* Securing Kong Manager through a **Kong Authentication Plugin**

  When Kong Manager is **secured through an Authentication Plugin** 
  and _not_ on a dedicated node, it makes calls to the Admin API on 
  the same host. By default, the Admin API listens on ports 8001 and 
  8444 on localhost. Change [`admin_listen`] if necessary, or set 
  [`admin_api_uri`].

* Securing Kong Manager and serving it from a dedicated node

  When Kong Manager is **secured and served from a dedicated node**, 
  set [`admin_api_uri`] to the location of the Admin API.

The table below summarizes which properties to set (or defaults to 
verify) when configuring Kong Manager connectivity to the Admin API.

| authentication enabled | local API    | remote API    | auth settings                                     |
|------------------------|--------------|---------------|---------------------------------------------------|
| yes                    | [`admin_listen`] | [`admin_api_uri`] | [`admin_gui_auth`], [`enforce_rbac`], [`admin_gui_auth_conf`], [`admin_gui_session_conf`] |
| no                     | [`admin_listen`] | [`admin_api_uri`] | n/a                                               |

To enable authentication, configure the following properties:

* [`admin_gui_auth`] set to the desired plugin
* [`admin_gui_auth_conf`] (optional)
* [`admin_gui_session_conf`] set to the desired configuration
* [`enforce_rbac`] set to `on`

⚠️ When Kong Manager authentication is enabled, RBAC must be turned 
on to enforce authorization rules. Otherwise, whoever can log in 
to Kong Manager can perform any operation available on the Admin API.

[`admin_gui_auth`]: /enterprise/{{page.kong_version}}/property-reference/#admin_gui_auth
[`admin_api_port`]: /enterprise/{{page.kong_version}}/property-reference/#admin_api_port
[`admin_api_uri`]: /enterprise/{{page.kong_version}}/property-reference/#admin_api_uri
[`admin_gui_auth_conf`]: /enterprise/{{page.kong_version}}/property-reference/#admin_gui_auth_conf
[`enforce_rbac`]: /enterprise/{{page.kong_version}}/property-reference/#enforce_rbac
[`admin_listen`]: /enterprise/{{page.kong_version}}/property-reference/#admin_listen
[`admin_gui_session_conf`]: /enterprise/{{page.kong_version}}/property-reference/#admin_gui_session_conf