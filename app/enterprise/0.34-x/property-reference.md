---
title: Configuration Property Reference for Kong Enterprise
---

## General


### prefix

See the property description in Kong's configuration reference for 
[prefix](https://docs.konghq.com/0.13.x/configuration/#prefix)


### log_level

See the property description in Kong's configuration reference for 
[log_level](https://docs.konghq.com/0.13.x/configuration/#log_level)


### proxy_access_log

See the property description in Kong's configuration reference for 
[proxy_access_log](https://docs.konghq.com/0.13.x/configuration/#proxy_access_log)


### proxy_error_log 

See the property description in Kong's configuration reference for 
[proxy_error_log](https://docs.konghq.com/0.13.x/configuration/#proxy_error_log)


### adming_access_log

See the property description in Kong's configuration reference for 
[admin_access_log](https://docs.konghq.com/0.13.x/configuration/#admin_access_log)


### admin_error_log

See the property description in Kong's configuration reference for 
[admin_error_log](https://docs.konghq.com/0.13.x/configuration/#admin_error_log)


### custom_plugins 

See the property description in Kong's configuration reference for 
[custom_plugins](https://docs.konghq.com/0.13.x/configuration/#custom_plugins)


### anonymous_reports

See the property description in Kong's configuration reference for 
[anonymous_reports](https://docs.konghq.com/0.13.x/configuration/#anonymous_reports)


## NGINX


### proxy_listen

See the property description in Kong's configuration reference for [proxy_listen](https://docs.konghq.com/0.13.x/configuration/#proxy_listen)


### proxy_url

**Default:** `NONE` (auto generated)

**Description:**  

Here you may provide the lookup, or balancer,
address for your Kong Proxy nodes.

This value is commonly used in a microservices
or service-mesh oriented architecture.

Accepted format (parts in parenthesis are optional):

```
<scheme>://<IP / HOSTNAME>(:<PORT>(/<PATH>))
```

**Examples:**

```
- <scheme>://<IP>:<PORT>
  proxy_url = http://127.0.0.1:8000
- SSL <scheme>://<HOSTNAME>
  proxy_url = https://proxy.domain.tld
- <scheme>://<HOSTNAME>/<PATH>
  proxy_url = http://dev-machine/dev-285
```

**Default:**
Kong Manager and Dev Portal will use
the window request host and append the resolved
listener port depending on the requested protocol.

**Note:** see http://nginx.org/en/docs/http/ngx_http_core_module.html#listen for
a description of the accepted formats for this and other *_listen values.

**Note:** see https://www.nginx.com/resources/admin-guide/proxy-protocol/
for more details about the `proxy_protocol` parameter.

**Example:**

```
proxy_url = https://127.0.0.1:8443
```


### admin_api_uri

**Default:** `NONE` (auto generated)

**Description:**  

Hierarchical part of a URI which is composed 
optionally of a host, port, and path at which your 
Admin interface API accepts HTTP or HTTPS traffic. 
When this config is disabled, the gui will use the 
window protocol + host and append the resolved 
admin_gui_listen HTTP/HTTPS port.

**Example:**

```
admin_api_uri = https://127.0.0.1:8444
```


### admin_listen

See the property description in Kong's configuration reference for [admin_listen](https://docs.konghq.com/0.13.x/configuration/#admin_listen)


### nginx_user

See the property description in Kong's configuration reference for [nginx_user](https://docs.konghq.com/0.13.x/configuration/#nginx_user)


### nginx_worker_processes 

See the property description in Kong's configuration reference for  [nginx_worker_processes](https://docs.konghq.com/0.13.x/configuration/#nginx_worker_processes)


### nginx_daemon

See the property description in Kong's configuration reference for [nginx_daemon](https://docs.konghq.com/0.13.x/configuration/#nginx_daemon)


### mem_cache_size

See the property description in Kong's configuration reference for [mem_cahce_size](https://docs.konghq.com/0.13.x/configuration/#mem_cache_size)


### ssl_cipher_suite

See the property description in Kong's configuration reference for [ssl_cipher_suite](https://docs.konghq.com/0.13.x/configuration/#ssl_cipher_suite)


### ssl_ciphers

See the property description in Kong's configuration reference for [ssl_ciphers](https://docs.konghq.com/0.13.x/configuration/#ssl_ciphers)


### ssl_cert

See the property description in Kong's configuration reference for [ssl_cert](https://docs.konghq.com/0.13.x/configuration/#ssl_cert)


### ssl_cert_key

See the property description in Kong's configuration reference for [ssl_cert_key](https://docs.konghq.com/0.13.x/configuration/#ssl_cert_key)


### client_ssl

See the property description in Kong's configuration reference for [client_ssl](https://docs.konghq.com/0.13.x/configuration/#client_ssl)


### client_ssl_cert

See the property description in Kong's configuration reference for [client_ssl_cert](https://docs.konghq.com/0.13.x/configuration/#client_ssl_cert)


### client_ssl_cert_key

See the property description in Kong's configuration reference for [client_ssl_cert_key](https://docs.konghq.com/0.13.x/configuration/#client_ssl_cert_key)


### admin_ssl_cert

See the property description in Kong's configuration reference for [admin_ssl_cert](https://docs.konghq.com/0.13.x/configuration/#admin_ssl_cert)


### admin_ssl_cert_key

See the property description in Kong's configuration reference for [admin_ssl_cert_key](https://docs.konghq.com/0.13.x/configuration/#admin_ssl_cert_key)


### upstream_keepalive

See the property description in Kong's configuration reference for [upstream_keepalive](https://docs.konghq.com/0.13.x/configuration/#upstream_keepalive)


### server_tokens

See the property description in Kong's configuration reference for [server_tokens](https://docs.konghq.com/0.13.x/configuration/#server_tokens)


### latency_tokens

See the property description in Kong's configuration reference for [latency_tokens](https://docs.konghq.com/0.13.x/configuration/#latency_tokens)


### trusted_ips

See the property description in Kong's configuration reference for [trusted_ips](https://docs.konghq.com/0.13.x/configuration/#trusted_ips)


### real_ip_header

See the property description in Kong's configuration reference for [real_ip_header](https://docs.konghq.com/0.13.x/configuration/#real_ip_header)


### real_ip_recursive

See the property description in Kong's configuration reference for [real_ip_recursive](https://docs.konghq.com/0.13.x/configuration/#real_ip_recursive)


### client_max_body_size

See the property description in Kong's configuration reference for [client_max_body_size](https://docs.konghq.com/0.13.x/configuration/#client_max_body_size)


### client_body_buffer_size

See the property description in Kong's configuration reference for [client_body_buffer_size](https://docs.konghq.com/0.13.x/configuration/#client_body_buffer_size)


### error_default_type

See the property description in Kong's configuration reference for [error_default_type](https://docs.konghq.com/0.13.x/configuration/#error_default_type)


## Datastore


### database

See the property description in Kong's configuration reference for [database](https://docs.konghq.com/0.13.x/configuration/#database)


### pg_host

See the property description in Kong's configuration reference for [Postgres settings](https://docs.konghq.com/0.13.x/configuration/#postgres-settings)


### pg_port

See the property description in Kong's configuration reference for [Postgres settings](https://docs.konghq.com/0.13.x/configuration/#postgres-settings)


### pg_user

See the property description in Kong's configuration reference for [Postgres settings](https://docs.konghq.com/0.13.x/configuration/#postgres-settings)


### pg_password

See the property description in Kong's configuration reference for [Postgres settings](https://docs.konghq.com/0.13.x/configuration/#postgres-settings)


### pg_database

See the property description in Kong's configuration reference for [Postgres settings](https://docs.konghq.com/0.13.x/configuration/#postgres-settings)


### pg_ssl

See the property description in Kong's configuration reference for [Postgres settings](https://docs.konghq.com/0.13.x/configuration/#postgres-settings)


### pg_ssl_verify

See the property description in Kong's configuration reference for [Postgres settings](https://docs.konghq.com/0.13.x/configuration/#postgres-settings)


### cassandra_contact_points

See the property description in Kong's configuration reference for [Cassandra settings](https://docs.konghq.com/0.13.x/configuration/#cassandra-settings)


### cassandra_port

See the property description in Kong's configuration reference for [Cassandra settings](https://docs.konghq.com/0.13.x/configuration/#cassandra-settings)


### cassandra_keyspace

See the property description in Kong's configuration reference for [Cassandra settings](https://docs.konghq.com/0.13.x/configuration/#cassandra-settings)


### cassandra_timeout

See the property description in Kong's configuration reference for [Cassandra settings](https://docs.konghq.com/0.13.x/configuration/#cassandra-settings)


### cassandra_ssl

See the property description in Kong's configuration reference for [Cassandra settings](https://docs.konghq.com/0.13.x/configuration/#cassandra-settings)


### cassandra_ssl_verify

See the property description in Kong's configuration reference for [Cassandra settings](https://docs.konghq.com/0.13.x/configuration/#cassandra-settings)


### cassandra_username

See the property description in Kong's configuration reference for [Cassandra settings](https://docs.konghq.com/0.13.x/configuration/#cassandra-settings)


### cassandra_password

See the property description in Kong's configuration reference for [Cassandra settings](https://docs.konghq.com/0.13.x/configuration/#cassandra-settings)


### cassandra_consistency

See the property description in Kong's configuration reference for [Cassandra settings](https://docs.konghq.com/0.13.x/configuration/#cassandra-settings)


### cassandra_lb_policy

See the property description in Kong's configuration reference for [Cassandra settings](https://docs.konghq.com/0.13.x/configuration/#cassandra-settings)


### cassandra_local_datacenter

See the property description in Kong's configuration reference for [Cassandra settings](https://docs.konghq.com/0.13.x/configuration/#cassandra-settings)


### cassandra_repl_strategy

See the property description in Kong's configuration reference for [Cassandra settings](https://docs.konghq.com/0.13.x/configuration/#cassandra-settings)


### cassandra_repl_factor

See the property description in Kong's configuration reference for [Cassandra settings](https://docs.konghq.com/0.13.x/configuration/#cassandra-settings)


### cassandra_data_centers

See the property description in Kong's configuration reference for [Cassandra settings](https://docs.konghq.com/0.13.x/configuration/#cassandra-settings)


### cassandra_schema_consensus_timeout

See the property description in Kong's configuration reference for [Cassandra settings](https://docs.konghq.com/0.13.x/configuration/#cassandra-settings)


## Datastore Cache


### db_update_frequency

See the property description in Kong's configuration reference for [db_update_frequency](https://docs.konghq.com/0.13.x/configuration/#db_update_frequency)


### db_update_propagation

See the property description in Kong's configuration reference for [db_update_propagation](https://docs.konghq.com/0.13.x/configuration/#db_update_propagation)


### db_cache_ttl

See the property description in Kong's configuration reference for [db_cache_ttl](https://docs.konghq.com/0.13.x/configuration/#db_cache_ttl)


## DNS Resolver


### dns_resolver

See the property description in Kong's configuration reference for [dns_resolver](https://docs.konghq.com/0.13.x/configuration/#dns_resolver)


### dns_hostsfile

See the property description in Kong's configuration reference for [dns_hostsfile](https://docs.konghq.com/0.13.x/configuration/#dns_hostsfile)


### dns_order

See the property description in Kong's configuration reference for [dns_order](https://docs.konghq.com/0.13.x/configuration/#dns_order)


### dns_state_ttl

See the property description in Kong's configuration reference for [dns_state_ttl](https://docs.konghq.com/0.13.x/configuration/#dns_state_ttl)


### dns_not_found_ttl

See the property description in Kong's configuration reference for [dns_not_found_ttl](https://docs.konghq.com/0.13.x/configuration/#dns_not_found_ttl)


### dns_error_ttl

See the property description in Kong's configuration reference for [dns_error_ttl](https://docs.konghq.com/0.13.x/configuration/#dns_error_ttl)


### dns_no_sync

See the property description in Kong's configuration reference for [dns_no_sync](https://docs.konghq.com/0.13.x/configuration/#dns_no_sync)


## Development & Miscellaneous


### lua_ssl_trusted_certificate

See the property description in Kong's configuration reference for [lua_ssl_trusted_certificate](https://docs.konghq.com/0.13.x/configuration/#lua_ssl_trusted_certificate)


### lua_ssl_verify_depth

See the property description in Kong's configuration reference for [lua_ssl_verify_depth](https://docs.konghq.com/0.13.x/configuration/#lua_ssl_verify_depth)


### lua_package_path

See the property description in Kong's configuration reference for [lua_package_path](https://docs.konghq.com/0.13.x/configuration/#lua_package_path)


### lua_package_cpath

See the property description in Kong's configuration reference for [lua_package_cpath](https://docs.konghq.com/0.13.x/configuration/#lua_package_cpath)


### lua_socket_pool_size

See the property description in Kong's configuration reference for [lua_socket_pool_size](https://docs.konghq.com/0.13.x/configuration/#lua_socket_pool_size)


### enforce_rbac 

**Default:** `off`

**Description:**

Specifies whether Admin API RBAC is enforced;
accepts one of 'entity', 'both', 'on', or
'off'. When 'on' is passed, only
endpoint-level authorization is enforced;
when 'entity' is passed, entity-level
authorization applies; 'both' enables both
endpoint and entity-level authorization;
'off' disables both. When enabled, Kong will
deny requests to the Admin API when a
nonexistent or invalid RBAC authorization
token is passed, or the RBAC user with which
the token is associated does not have
permissions to access/modify the requested
resource.


### rbac_auth_header

**Default:** `Kong-Admin-Token`

**Description:**

Defines the name of the HTTP request header from which the Admin 
API will attempt to identify the RBAC user.


## Kong Manager


### admin_gui_listen

**Default:** `0.0.0.0:8002, 0.0.0.0:8445 ssl`

**Description:**  
Comma-separated list of addresses and ports on which

Kong will expose the Admin GUI. This web application
lets you configure and manage Kong, and therefore
should be kept private and secured.

Suffixes can be specified for each pair, similarly to 
the `admin_listen` directive.

**Example:**

```
admin_gui_listen = 0.0.0.0:8002, 0.0.0.0:8445 ssl
```


### admin_gui_url

**Default:** `NONE`

**Description:**  

Here you may provide the lookup, or balancer,
address for your admin application.

Accepted format (items in parenthesis are optional):

```
<scheme>://<IP / HOSTNAME>(:<PORT>(/<PATH>))
```

**Examples:**
```
- http://127.0.0.1:8003
- https://kong-admin.test
- http://dev-machine/dev-285
```

**Default:**
The application will use the window request host and
append the resolved listener port depending on the
requested protocol.

```
admin_gui_url = https://kong-admin.test
```


### admin_gui_ssl_cert

**Default:** `NONE` (auto generated)

**Description:**  

The absolute path to the SSL certificate for 
`admin_gui_listen` values with SSL enabled.

**Example:**

```
admin_gui_ssl_cert = /path/to/admin_gui_ssl.cert
```


### admin_gui_ssl_cert_key

**Default:** `NONE` (auto-generated)

**Description:**  

The absolute path to the SSL key for `admin_gui_listen` values with SSL
enabled.

**Example:**

```
admin_gui_ssl_key = /path/to/admin_gui_ssl.key
```


### admin_gui_flags

**Default:** `{}`

**Description:**  

Alters the layout Admin GUI (JSON)


### admin_gui_access_log

**Default:** `logs/admin_gui_access.log`

**Description:**  

Here you can set an absolute or relative path for the
Kong Manager access logs. When the path is relative,
logs are placed in the `prefix` location.

Setting this value to `off` disables access logs
for Kong Manager.


### admin_gui_error_log

**Default:** `logs/admin_gui_error.log`

**Description:**  

Here you can set an absolute or relative path for your
Portal API access logs. When the path is relative,
logs are placed in the `prefix` location.

Setting this value to `off` disables error logs for
Kong Manager. 

Granularity can be adjusted through the `log_level`
directive.


### admin_gui_auth

**Default:** `NONE` (empty)

**Description:**  

Here you may specify the configuration for the 
authentication plugin you have chosen.

* For Basic Authentication, set the value to `basic-auth`
* For LDAP Authentication, set the value to `ldap-auth-advanced`


### admin_gui_auth_conf

**Default:** `NONE` (empty)

**Description:**  

Here you may specify the configuration for the
authentication plugin you have chosen. 

For information about Plugin Configuration consult 
the associated plugin documentation.

**Example (for Basic Auth):**

```
admin_gui_auth_conf = { "hide_credentials": true }
```


## Vitals


### vitals

**Default:** `on`

**Description:**  

When enabled, Kong will store and report metrics about its performance.                                 
When running Kong in a multi-node setup, `vitals` entails two 
separate meanings depending on the node.

On a Proxy-only node, `vitals` determines whether to collect data 
for Vitals.

On an Admin-only node, `vitals` determines whether to display 
Vitals metrics and visualizations on the dashboard.


### vitals_strategy

**Default:** `database`

**Description:** 

Determines whether to use the Kong database
(either PostgreSQL or Cassandra, as defined
by the 'database' config value above), or a
separate storage engine, for Vitals metrics.

Accepted values are 'database', 'prometheus',
or 'influxdb'.


### vitals_tsdb_address

### vitals_statsd_address

### vitals_statsd_prefix

### vitals_statsd_udp_packet_size

### vitals_prometheus_scrape_interval


## Dev Portal


### portal

**Default:** `off`

**Description:**  

Enable or disable the Dev Portal Interface and API

When enabled, Kong will expose the Kong Dev Portal Files endpoint and the public Dev Portal Files API.

**Example:**

```
portal = on
```


### portal_gui_listen

**Default:** `0.0.0.0:8003, 0.0.0.0:8446 ssl`

**Description:**  

Comma-separated list of addresses on which Kong will
expose the Kong Dev Portal GUI. Suffixes can be
specified for each pair, similar to the `admin_listen` 
directive.

**Example:**

```
portal_gui_listen = 0.0.0.0:8003, 0.0.0.0:8446 ssl
```


### portal_gui_protocol

**Default:** `NONE`, Dev Portal will use the window request protocol.

**Description:**  

The Dev Portal URL protocol

Provide the protocol used in conjunction with portal_gui_host to construct the lookup, or balancer address for Kong Proxy nodes.

**Example:**

```
portal_gui_protocol = http
```


### portal_gui_host

**Default** `NONE`, Dev Portal will use the window request domain.

**Description**

Dev Portal GUI Host

Provide the host unsed in conjunction with portal_gui_protocol to construct the lookup, or balancer address for Kong Proxy nodes.

**Example:**

```
portal_gui_host = localhost:8003
```


### port_gui_use_subdomains

**Default** `Off`

**Description** 

Enable workspaced Dev Portals to use subdomains

By default the Dev Portal will use the first namespace in the request path to determine the workspace. By enabling subdomains, the Dev Portal will expect the workspace to be included in the request url as a subdomain

**Example**

```
portal_gui_use_subdomains = off
  - <scheme>://<HOSTNAME>/<WORKSPACE>/<PATH>
  - http://kong-portal.com/example-workspace/index

portal_gui_use_subdomains = on
  - <scheme>://<WORKSPACE>.<HOSTNAME>
  - http://example-workspace.kong-portal.com/index
```


### portal_gui_ssl_cert

**Default:** `NONE` (auto generated)

**Description:**  

The absolute path to the SSL certificate for `portal_gui_listen` values with SSL enabled.

**Example:**

```
portal_gui_ssl_cert = /path/to/portal_gui_ssl.cert
```


### portal_gui_ssl_cert_key

**Default:** `NONE` (auto-generated)

**Description:**  

The absolute path to the SSL key for `portal_gui_listen` values with SSL 
enabled.

**Example:**

```
portal_gui_ssl_key = /path/to/portal_gui_ssl.key
```


### portal_api_listen

**Default:** `0.0.0.0:8004, 0.0.0.0:8447 ssl`

**Description:**  
Comma-separated list of addresses on which Kong will
expose the Dev Portal API. Suffixes can be
specified for each pair, similarly to
the `admin_listen` directive.

```
portal_api_listen = 0.0.0.0:8004, 0.0.0.0:8447 ssl
```


### portal_api_url

**Default:** `NONE` (empty)

**Description:**  

The address on which the Dev Portal API is accessible by Kong. **ONLY**
set this value if the Dev Portal API lives on a different node than the Kong Proxy.

When not provided, Kong will use the listeners defined on `portal_api_listen` as 
the value.

**Example:**

```
portal_api_url = https://portal-api.domain.tld
```


### portal_api_ssl_cert

**Default:** `NONE` (auto generated)

**Description:**  

Dev Portal API SSL Certificate.

The absolute path to the SSL certificate for
`portal_api_listen` values with SSL enabled.

**Example:**

```
portal_api_ssl_cert = /path/to/portal_api_ssl.cert
```


### portal_api_ssl_cert_key

**Default:** `NONE` (auto generated)

**Description:**  

Dev Portal API SSL Certificate Key.

The absolute path to the SSL key for
`portal_api_listen` values with SSL enabled.

**Example:**

```
portal_api_ssl_cert_key = /path/to/portal_api_ssl_cert.key
```


### portal_api_access_log

**Default:** `logs/portal_api_access.log`

**Description:**  

Location of log containing all calls made to the Portal API.

`portal_api_access.log` location can be absolute or relative. When using relative pathing, logs will be placed under
the `prefix` location.

Setting this value to `off` will disable logging
Portal API access logs.

**Example:**

```
portal_api_access_log = logs/portal_api_access.log
```


### portal_api_error_log


## Dev Portal Authentication


### portal_auth

**Default:** `NONE` (empty)

**Description:**  

Use `portal_auth` to specify the authentication plugin
to apply to your Dev Portal. Developers
will use the specified form of authentication
to request access, register, and login to your
Dev Portal.

**Example (Basic Auth):**

```
portal_auth = basic-auth
```


### portal_auth_conf

**Default:** `NONE` (empty)

**Description:**  

Here you can specify authentication plugin configuration
via JSON Object format to be applied to your Developer
Portal auth plugin. For information about Plugin Configuration
consult the associated plugin documentation.

**Example (Basic Auth):**

```
portal_auth_conf = { "hide_credentials": true }
```


### portal_auto_approve

**Default:** `off`

**Description:**

When this flag is set to 'on', a developer will automatically be marked as "approved" after completing registration. Access can still be revoked through the Kong Manager or Admin API.



### portal_token_exp

**Default:** `21600`

**Description:**

Duration in seconds for the expiration of the Dev Portal reset password token. Default `21600` is six hours.


## Dev Portal SMTP Configuration


### portal_invite_email

**Default:** `on`

**Description:**

When enabled, Admins will be able to invite Developers to a Dev Portal by using the "Invite" button in the Kong Manager.


### portal_access_request_email

**Default:** `on`

**Description:**

When enabled, Admins specified by `smtp_admin_emails` will receive an email when a Developer requests access to a Dev Portal.


### portal_approved_email

**Default:** `on`

**Description:**

When enabled, Developers will receive an email when access to a Dev Portal has been approved.


### portal_reset_email

**Default:** `on`

**Description:**

When enabled, Developers will be able to use the "Reset Password" flow on a Dev Portal and will receive an email with password reset instructions.

When disabled, Developers will *not* be able to reset their account passwords.


### portal_reset_success_email

**Default:** `on`

**Description:**

When enabled, Developers will receive an email after successfully reseting their Dev Portal account password.

When disabled, Developers will still be able to reset their account passwords, but will not recieve a confirmation email.


### portal_emails_from

**Default:** `nil`

**Description:**

The name and email address for the 'From' header included in all Dev Portal emails.

**Example :**

```
portal_emails_from = Your Name <example@example.com>
```

⚠️ **IMPORTANT:** Some SMTP servers may require valid email addresses


### portal_emails_reply_to

**Default:** `nil`

**Description:**

The email address for the 'Reply-To' header included in all Dev Portal emails.

**Example :**

```
portal_emails_reply_to: noreply@example.com
```

⚠️ **IMPORTANT:** Some SMTP servers may require valid email addresses


## Admin SMTP Configuration


### admin_invite_email

**Default:** `on`

**Description:**

When enabled invitation emails will be sent to Admins invited to the Kong Manager.


### admin_emails_from

**Default:** `on`

**Description:**

The email address for the 'From' header included in Admin emails

**Example :**

```
admin_emails_from = "example@example.com"
```


### admin_emails_reply_to

**Default:** `on`

**Description:**

The email address for the 'Reply-To' header included in Admin emails

**Example :**

```
admin_emails_reply_to = admin@example.com
```


### admin_invitation_expiry

**Default:** `259200`

**Description:**

Expiration time in seconds for Admin invitation links. Set to zero for no expiration.


## General SMTP Configuration


### smtp_mock

**Default:** `on`

**Description:**

When enabled this flag will only mock the sending of emails and will not attempt to send actual emails. This can be used for testing before the SMTP client is fully configured.


### smtp_host

**Default:** `localhost`

**Description:**
The host of the SMTP server to connect to.


### smtp_port

**Default:** `25`

**Description:**

The port number on SMTP server to connect to.


### smtp_starttls

**Default:** `nil`

**Description:**

When set to `on`, STARTTLS is used to encrypt communication with the SMTP server. This is normally used in conjunction with port 587.


### smtp_username

**Default:** `nil`

**Description:**

Username used for authentication with the SMTP server.


### smtp_password

**Default:** `nil`

**Description:**

Password used for authentication with the SMTP server.


### smtp_ssl

**Default:** `nil`

**Description:**

When set to `on` SMTPS is used to encrypt communication with the SMTP server. This is normally used in conjunction with port 465.


### smtp_auth_type

**Default:** `nil`

**Description:**

The method used to authenticate with the SMTP server. Valid options are `plain`, `login`, or `nil`.


### smtp_domain

**Default:** `localhost.localdomain`

**Description:**

The domain used in the `EHLO` connect and part of the `Message-ID` header.


### smtp_timeout_connect

**Default:** `60000`

**Description:**

The timeout in milliseconds for connecting to the SMTP server.


### smtp_timeout_send

**Default:** `60000`

**Description:**

The timeout in milliseconds for sending data to the SMTP server.


### smtp_timeout_read

**Default:** `60000`

**Description:**

The timeout in milliseconds for reading data from the SMTP server.


### smtp_admin_emails

**Default:** `nil`

**Description:**

Comma separated list of Admin emails to receive notifications.

**Example :**

```
smtp_admin_emails = admin1@example.com, admin2@example.com
```


## Data & Admin Audit


### audit_log

### audit_log_ignore_methods

### audit_log_ignore_paths

### audit_log_ignore_tables

### audit_log_record_ttl

### audit_log_signing_key