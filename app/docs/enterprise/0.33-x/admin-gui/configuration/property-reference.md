---
title: Setting custom URLs for the Admin GUI and Admin API
book: admin_gui
chapter: 4
---

# Property Reference

This document describes the configuration directives for the Kong Admin GUI.

## proxy_url

**Default:** `NONE` (auto generated)

**Description:**  
The URL on which Kong is accessible. By default the Admin GUI will use the window request host and append the resolved listener port depending on the requested protocol.

**Example:**

```
proxy_url = http://127.0.0.1:8000
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
admin_gui_auth = ldap-auth-advanced
```

## admin_gui_auth_conf

**Default:** `NONE` (empty)

**Description:**  
Admin GUI Authentication Plugin Config (JSON)

Here you may specify the configuration for the
authentication plugin you have chosen. For information
about Plugin Configuration consult the associated plugin documentation.

**Example (LDAP Auth Advanced):**

```
admin_gui_auth_conf={                                     \
"anonymous":"",                                           \
"attribute":"uid",                                        \ 
"base_dn":"<ENTER_YOUR_BASE_DN_HERE>",                    \
"cache_ttl": 2,                                           \
"header_type":"Basic",                                    \
"keepalive":60000,                                        \
"ldap_host":"<ENTER_YOUR_LDAP_HOST_HERE>",                \
"ldap_port":389,                                          \
"start_tls":false,                                        \
"timeout":10000,                                          \
"verify_ldap_host":true                                   \
}
```
