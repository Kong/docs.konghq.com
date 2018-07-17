---
title: Property Reference
book: admin_gui
chapter: 6
---

# Admin GUI Property Reference

This document describes configuration options for the Kong Admin GUI.


## admin_uri

**Default:** `NONE` (auto generated)

**Description:**  
The URL on which the Admin API is accessible. By default the Admin GUI assumes the Admin API is on the same host, and will use the window request host and resolved listener port depending on the requested protocol. This is where the Admin GUI finds the Admin API when `admin_gui_auth` (see below) is not enabled.

Note that this property accepts a value with or without protocol. If you specify the protocol, be sure that it is the same as the one you set in `admin_gui_url`, to prevent rendering errors due to mixed content.

Note: This property will be renamed `admin_url` in a future release, to be consistent with other URL properties in `kong.conf`. Protocol will be required at that time. It is strongly recommended that your Admin API be on a secure port.

**Example:**

```
admin_uri = https://127.0.0.1:8001
```


## proxy_url

**Default:** `NONE` (auto generated)

**Description:**  
The URL on which Kong is accessible. When `admin_gui_auth` is enabled, the Admin GUI makes Admin API requests via the Kong proxy. With no other configuration changes, the Admin GUI assumes the proxy is on the same host, and will use the window request host and resolved listener port depending on the requested protocol.

**Example:**

```
proxy_url = https://127.0.0.1:8000
```


## admin_gui_listen

**Default:** `0.0.0.0:8002, 0.0.0.0:8445 ssl`

**Description:**  
Comma-separated list of addresses and ports on which
Kong will expose the Admin GUI. This web application
lets you configure and manage Kong, and therefore
should be kept private and secured. Suffixes can be
specified for each pair, similarly to the `admin_listen` directive.

**Example:**

```
admin_gui_listen = 0.0.0.0:8002, 0.0.0.0:8445 ssl
```


## admin_gui_url

**Default:** `NONE`

**Description:**  
Here you may provide the lookup, or balancer, address for your admin application.

Accepted format (items in parenthesis are optional):
`<scheme>://<IP / HOSTNAME>(:<PORT>(/<PATH>))`

When not provided, the Kong Admin GUI will attempt to determine the
`port`and `host` based on the browsers `window.location`, this assumes that the
accessed `host`has exposed the ports defined on the `admin_gui_listener`

**Example:**

```
admin_gui_url = https://kong-admin.test
```


## admin_gui_ssl_cert

**Default:** `NONE` (auto generated)

**Description:**  
The absolute path to the SSL certificate for `admin_gui_listen` values with SSL enabled.

**Example:**

```
admin_gui_ssl_cert = /path/to/admin_gui_ssl.cert
```


## admin_gui_ssl_cert_key

**Default:** `NONE` (auto-generated)

**Description:**  
The absolute path to the SSL key for `admin_gui_listen` values with SSL
enabled.

**Example:**

```
admin_gui_ssl_key = /path/to/admin_gui_ssl.key
```


## admin_gui_access_log

**Default:** `logs/admin_gui_access.log`

**Description:**  
Admin GUI Access Logs.

Here you can set an absolute or relative path for the
Admin GUI access logs. When the path is relative,
logs are placed in the `prefix` location.

Setting this value to `off` disables access logs
for the Admin GUI.


## admin_gui_error_log

**Default:** `logs/admin_gui_error.log`

**Description:**  
Admin GUI Error Logs

Here you can set an absolute or relative path for your
Admin API access logs. When the path is relative,
logs are placed in the `prefix` location.

Setting this value to `off` disables error logs for
the Admin GUI. Granularity can be adjusted through the `log_level`
directive.


## admin_gui_auth

**Default:** `NONE` (empty)

**Description:**  
Admin GUI Authentication Plugin Name

Here you may secure access to the Admin GUI by
specifying an authentication plugin to use.

Supported Plugins:

Value to Use        | Authentication Type
----------------------+--------------------------
key-auth            | Key Authentication
basic-auth          | Basic Authentication
ldap-auth-advanced  | LDAP Authentication

**example:**

```
admin_gui_auth = basic-auth
```

## admin_gui_auth_conf

**Default:** `NONE` (empty)

**Description:**  
Admin GUI Authentication Plugin Config (JSON)

Here you may specify the configuration for the
authentication plugin you have chosen. For information
about Plugin Configuration consult the associated plugin documentation.

**Example (Basic Auth):**

```
admin_gui_auth_conf = { "hide_credentials": true }
```
