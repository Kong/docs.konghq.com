---
title: Configuration Property Reference for Kong Developer Portal
---

# Property Reference

This document describes the configuration directives for the Kong Developer
Portal.

## portal

**Default:** `off`

**Description:**<br/>
Should Kong enable the Kong Developer Portal?

If enabled, Kong will expose the Kong Developer Portal GUI, Kong Developer Portal API on the `portal_gui_listen` address, and management endpoints on the Admin API.

**Example:**

```
portal = on
```


## portal_gui_listen

**Default:** `0.0.0.0:8003, 0.0.0.0:8446 ssl`

**Description:**<br/>
Comma-separated list of addresses on which Kong will
expose the Kong Developer Portal GUI. Suffixes can be
specified for each pair, similar to the `admin_listen` 
directive.

**Example:**

```
portal_gui_listen = 0.0.0.0:8003, 0.0.0.0:8446 ssl
```


## portal_gui_url

**Default:** `NONE` (auto generated)

**Description:**<br/>
The URL on which your Kong Developer Portal is accessible. 

When not provided, The Kong Developer Portal GUI will attempt to determine the 
`port` and `host` based on the browsers `window.location`, this assumes that the
accessed `host` has exposed the ports defined on the `portal_gui_listener`
directive.

If the above does not reflect your setup, we highly recommend setting this value.

**Example:**

```
portal_gui_url = https://portal.domain.tld
```


## portal_gui_ssl_cert

**Default:** `NONE` (auto generated)

**Description:**<br/>
The absolute path to the SSL certificate for `portal_gui_listen` values with SSL enabled.

**Example:**

```
portal_gui_ssl_cert = /path/to/portal_gui_ssl.cert
```


## portal_gui_ssl_cert_key

**Default:** `NONE` (auto-generated)

**Description:**<br/>
The absolute path to the SSL key for `portal_gui_listen` values with SSL 
enabled.

**Example:**

```
portal_gui_ssl_key = /path/to/portal_gui_ssl.key
```


## portal_api_listen

**Default:** `0.0.0.0:8004, 0.0.0.0:8447 ssl`

**Description:**<br/>
Comma-separated list of addresses on which Kong will
expose the Developer Portal API. Suffixes can be
specified for each pair, similarly to
the `admin_listen` directive.

```
portal_api_listen = 0.0.0.0:8004, 0.0.0.0:8447 ssl
```

## portal_api_url

**Default:** `NONE` (empty)

**Description:**<br/>
The address on which your Kong Developer Portal API is accessible by Kong. You
should **only** set this value if your Kong Developer Portal API lives on a different node than your Kong Proxy.

When not provided, Kong will use the listeners defined on `portal_api_listen` as 
the value.

**Example:**

```
portal_api_url = https://portal-api.domain.tld
```


## portal_api_ssl_cert

**Default:** `NONE` (auto generated)

**Description:**<br/>
Developer Portal API SSL Certificate.

The absolute path to the SSL certificate for
`portal_api_listen` values with SSL enabled.

**Example:**

```
portal_api_ssl_cert = /path/to/portal_api_ssl.cert
```


## portal_api_ssl_cert_key

**Default:** `NONE` (auto generated)

**Description:**<br/>
Developer Portal API SSL Certificate Key.

The absolute path to the SSL key for
`portal_api_listen` values with SSL enabled.

**Example:**

```
portal_api_ssl_cert_key = /path/to/portal_api_ssl_cert.key
```


## portal_api_access_log

**Default:** `logs/portal_api_access.log`

**Description:**<br/>
Location of log containing all calls made to the Portal API.

`portal_api_access.log` location can be absolute or relative. When using relative pathing, logs will be placed under
the `prefix` location.

Setting this value to `off` will disable logging
Portal API access logs.

**Example:**

```
portal_api_access_log = logs/portal_api_access.log
```


## portal_auto_approve

**Default:** `off`

**Description:**<br/>
Developer Portal Auto Approve Access.

When set to `on`, a developer will
automatically be marked as `approved` after completing
Dev Portal registration. Access can still be revoked through the
Admin GUI or API.

**Example:**

```
portal_auto_approve = on
```


## portal_auth

**Default:** `NONE` (empty)

**Description:**<br/>
Use `portal_auth` to specify the authentication plugin
to apply to your Developer Portal. Developers
will use the specified form of authentication
to request access, register, and login to your
Developer Portal.

**Example (Basic Auth):**

```
portal_auth = basic-auth
```


## portal_auth_config

**Default:** `NONE` (empty)

**Description:**<br/>
Here you can specify authentication plugin configuration
via JSON Object format to be applied to your Developer
Portal auth plugin. For information about Plugin Configuration
consult the associated plugin documentation.

**Example (Basic Auth):**

```
portal_auth_conf = { "hide_credentials": true }
```
