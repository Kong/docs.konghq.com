---
title: Configuration Property Reference for Kong Enterprise
---

## General

### prefix

**Default:** `/usr/local/kong/`

**Description:**

Working directory. Equivalent to Nginx's prefix path, containing
temporary files and logs. Each Kong process must have a separate
working directory.


### log_level

**Default:** `notice`

**Description:**

Log level of the Nginx server. Logs are found at
`<prefix>/logs/error.log`.

**Note:** See
http://nginx.org/en/docs/ngx_core_module.html#error_log for a list
of accepted values.


### proxy_access_log

**Default:** `logs/access.log`

**Description:**

Path for proxy port request access logs. Set this value to `off` to
disable logging proxy requests. If this value is a relative path,
it will be placed under the `prefix` location.


### proxy_error_log

**Default:** `logs/error.log`

**Description:**

Path for proxy port request error logs. The granularity of these
logs is adjusted by the `log_level` directive.


### admin_access_log

**Default:** `logs/admin_access.log`

**Description:**

Path for Admin API request access logs. Set this value to `off` to
disable logging Admin API requests. If this value is a relative
path, it will be placed under the `prefix` location.


### admin_error_log

**Default:** `logs/error.log`

**Description:**

Path for Admin API request error logs. The granularity of these
logs is adjusted by the `log_level` directive.


### plugins

**Default:** `bundled`

**Description:**

Comma-separated list of plugins this node should load.
By default, only plugins bundled in official distributions are loaded via the `bundled` keyword.. Plugins will be loaded from the `kong.plugins.{name}.*`
namespace.


### anonymous_reports

**Default:** `on`

**Description:**

Send anonymous usage data such as error stack traces to help
improve Kong.


## NGINX


### proxy_listen

**Default:** `0.0.0.0:8000, 0.0.0.0:8443 ssl`

**Description:**

Comma-separated list of addresses and ports on which the proxy
server should listen. The proxy server is the public entrypoint of
Kong, which proxies traffic from your consumers to your backend
services. This value accepts IPv4, IPv6, and hostnames.

Some suffixes can be specified for each pair:

- `ssl` requires that all connections made through a particular
  address/port be made with TLS enabled.
- `http2` allows for clients to open HTTP/2 connections to Kong's proxy
  server.
- `proxy_protocol` enables usage of the PROXY protocol for a given
  address/port.
- `transparent` causes Kong to listen to, and respond from, any and all
  IP addresses and ports you configure in `iptables`.
- `deferred` instructs to use a deferred accept on Linux (the
  TCP_DEFER_ACCEPT socket option).
- `bind` instructs to make a separate bind() call for a given `address:port` pair.
- `reuseport` instructs to create an individual listening socket for each worker process,
  allowing a kernel to distribute incoming connections between worker processes.

This value can be set to `off`, thus disabling the proxy port for this node,
enabling a 'control-plane' mode (without traffic proxying capabilities) which
can configure a cluster of nodes connected to the same database.


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

**Note:** see http://nginx.org/en/docs/http/ngx_http_core_module.html#listen
for a description of the accepted formats for this and other *_listen values.

**Note:** see https://www.nginx.com/resources/admin-guide/proxy-protocol/
for more details about the `proxy_protocol` parameter.

**Example:**

```
proxy_url = https://127.0.0.1:8443
```

### stream_listen

**Description**

Comma-separated list of addresses and ports on which the stream mode should listen.

This value accepts IPv4, IPv6, and hostnames. Some suffixes can be specified for each pair:

- `proxy_protocol` enables usage of the PROXY protocol for a given address/port.
- `transparent` causes Kong Gateway to listen to (and respond from) any and all IP addresses and
  ports you configure in `iptables`.
- `bind` causes Kong Gateway to make a separate bind() call for a given `address:port` pair.
- `reuseport` causes Kong Gateway to create an individual listening socket for each worker process
  allowing a kernel to distribute incoming connections between worker processes.

**Note:** The `ssl` suffix is not supported, and each address/port will accept TCP with or
  without TLS enabled.

**Default:** `off`

**Examples:**
```
stream_listen = 127.0.0.1:7000
stream_listen = 0.0.0.989, 0.0.0.0:20
stream_listen = [::1]:1234
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

**Default:** `127.0.0.1:8001, 127.0.0.1:8444 ssl`

**Description:**

Comma-separated list of addresses and ports on which the
Admin interface should listen. The Admin interface is
the API allowing you to configure and manage Kong.
Access to this interface should be *restricted* to Kong
administrators *only*. This value accepts IPv4, IPv6,
and hostnames.

Some suffixes can be specified for each pair:
- `ssl` will require that all connections made
  through a particular address/port be made with TLS
  enabled.
- `http2` will allow for clients to open HTTP/2
  connections to Kong's proxy server.
- Finally, `proxy_protocol` will enable usage of the
  PROXY protocol for a given address/port.

This value can be set to `off`, thus disabling
the Admin interface for this node, enabling a
'data-plane' mode (without configuration
capabilities) pulling its configuration changes
from the database.

### status_listen

**Default:** `off`

**Description:**

Comma-separated list of addresses and ports on which the Status API should
listen.

The Status API is a read-only endpoint allowing monitoring tools to retrieve
metrics, healthiness, and other non-sensitive information of the current Kong
node.

This value can be set to `off`, disabling the Status API for this node.

**Example:** `status_listen = 0.0.0.0:8100`

### nginx_user

**Default:** `nobody nobody`

**Description:**

Defines user and group credentials used by
worker processes. If group is omitted, a
group whose name equals that of user is
used.

**Example:** `[user] [group]`


### nginx_worker_processes

**Default:** `auto`

**Description:**

Determines the number of worker processes spawned by Nginx.


### nginx_daemon

**Default:** `on`

**Description:**

Determines wether Nginx will run as a daemon
or as a foreground process. Mainly useful
for development or when running Kong inside
a Docker environment.


### mem_cache_size

**Default:** `128m`

**Description:**

Size of the in-memory cache for database
entities. The accepted units are `k` and
`m`, with a minimum recommended value of
a few MBs.


### ssl_cipher_suite

**Default:** `modern`

**Description:**

Defines the TLS ciphers served by Nginx.
Accepted values are `modern`,
`intermediate`, `old`, or `custom`.

**Note:** see https://wiki.mozilla.org/Security/Server_Side_TLS for detailed
descriptions of each cipher suite.

### ssl_ciphers

**Default:** `nil`

**Description:**

Defines a custom list of TLS ciphers to be
served by Nginx. This list must conform to
the pattern defined by `openssl ciphers`.
This value is ignored if `ssl_cipher_suite`
is not `custom`.


### ssl_cert

**Default:** `nil`

**Description:**

The absolute path to the SSL certificate for
`proxy_listen` values with SSL enabled.


### ssl_cert_key

**Default:** `nil`

**Description:**

The absolute path to the SSL key for
`proxy_listen` values with SSL enabled.


### client_ssl

**Default:** `off`

**Description:**

Determines if Nginx should send client-side
SSL certificates when proxying requests.


### client_ssl_cert

**Default:** `nil`

**Description:**

If `client_ssl` is enabled, the absolute
path to the client SSL certificate for the
`proxy_ssl_certificate` directive. Note that
this value is statically defined on the
node, and currently cannot be configured on
a per-API basis.


### client_ssl_cert_key

**Default:** `nil`

**Description:**

If `client_ssl` is enabled, the absolute
path to the client SSL key for the
`proxy_ssl_certificate_key` address. Note
this value is statically defined on the
node, and currently cannot be configured on
a per-API basis.


### admin_ssl_cert

**Default:** `nil`

**Description:**

The absolute path to the SSL certificate for
`admin_listen` values with SSL enabled.


### admin_ssl_cert_key

**Default:** `nil`

**Description:**

The absolute path to the SSL key for
`admin_listen` values with SSL enabled.


### headers

**Defaul:t** `server_tokens, latency_tokens`

**Description**
 Specify Kong-specific headers that should be injected in responses to the client.
 Acceptable values are:
 - `server_tokens`: inject 'Via' and 'Server'
   headers.
 - `latency_tokens`: inject
   'X-Kong-Proxy-Latency' and
   'X-Kong-Upstream-Latency' headers.
 - `X-Kong-<header-name>`: only inject this
   specific the header when applicable.

  This value can be set to `off`, which prevents Kong from injecting any of these
 headers. Note that plugins can still inject headers.


### trusted_ips

**Default:** `nil`

**Description:**

Defines trusted IP addresses blocks that are
known to send correct X-Forwarded-* headers.
Requests from trusted IPs make Kong forward
their X-Forwarded-* headers upstream.
Non-trusted requests make Kong insert its
own X-Forwarded-* headers.

This property also sets the
`set_real_ip_from` directive(s) in the Nginx
configuration. It accepts the same type of
values (CIDR blocks) but as a
comma-separated list.

To trust *all* /!\ IPs, set this value to
`0.0.0.0/0,::/0`.

If the special value `unix:` is specified,
all UNIX-domain sockets will be trusted.

**Note:** see http://nginx.org/en/docs/http/ngx_http_realip_module.html for
examples of accepted values.


### real_ip_header

**Default:** `X-Real-IP`

**Description:**

Defines the request header field whose value
will be used to replace the client address.
This value sets the ngx_http_realip_module
directive of the same name in the Nginx
configuration.

If set to `proxy_protocol`, then at least
one of the `proxy_listen` entries must
have the `proxy_protocol` flag enabled.

**Note:** see
http://nginx.org/en/docs/http/ngx_http_realip_module.html#real_ip_header
for a description of this directive.


### real_ip_recursive

**Default:** `off`

**Description:**

This value sets the ngx_http_realip_module
directive of the same name in the Nginx
configuration.

**Note:** see
http://nginx.org/en/docs/http/ngx_http_realip_module.html#real_ip_recursive
for a description of this directive.


### client_max_body_size

**Default:** `0`

**Description:**

Defines the maximum request body size allowed
by requests proxied by Kong, specified in
the Content-Length request header. If a
request exceeds this limit, Kong will
respond with a 413 (Request Entity Too
Large). Setting this value to 0 disables
checking the request body size.

Note: see
http://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size
for further description of this parameter. Numeric values may be suffixed
with 'k' or 'm' to denote limits in terms of kilobytes or megabytes.

### client_body_buffer_size

**Default:** `8k`

**Description:**

Defines the buffer size for reading the
request body. If the client request body is
larger than this value, the body will be
buffered to disk. Note that when the body is
buffered to disk Kong plugins that access or
manipulate the request body may not work, so
it is advisable to set this value as high as
possible (e.g., set it as high as
`client_max_body_size` to force request
bodies to be kept in memory). Do note that
high-concurrency environments will require
significant memory allocations to process
many concurrent large request bodies.

**Note:** see
http://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_buffer_size
for further description of this parameter. Numeric values may be suffixed
with 'k' or 'm' to denote limits in terms of kilobytes or megabytes.


### error_default_type

**Default:** `text/plain`

**Description:**

Default MIME type to use when the request
`Accept` header is missing and Nginx
is returning an error for the request.
Accepted values are `text/plain`,
`text/html`, `application/json`, and
`application/xml`.


## NGINX Injected Directives

Nginx directives can be dynamically injected in the runtime nginx.conf file
without requiring a custom Nginx configuration template.

All configuration properties respecting the naming scheme
`nginx_<namespace>_<directive>` will result in `<directive>` being injected in
the Nginx configuration block corresponding to the property's `<namespace>`.

Example:

`nginx_proxy_large_client_header_buffers = 8 24k`

Will inject the following directive in Kong's proxy `server {}` block:

`large_client_header_buffers 8 24k;`

The following namespaces are supported:

- `nginx_http_<directive>`: Injects `<directive>` in Kong's `http {}` block.
- `nginx_proxy_<directive>`: Injects `<directive>` in Kong's proxy
  `server {}` block.
- `nginx_http_upstream_<directive>`: Injects `<directive>` in Kong's proxy
  `upstream {}` block.
- `nginx_admin_<directive>`: Injects `<directive>` in Kong's Admin API
  `server {}` block.
- `nginx_stream_<directive>`: Injects `<directive>` in Kong's stream module
  `stream {}` block (only effective if `stream_listen` is enabled).
- `nginx_sproxy_<directive>`: Injects `<directive>` in Kong's stream module
  `server {}` block (only effective if `stream_listen` is enabled).

As with other configuration properties, Nginx directives can be injected via
environment variables when capitalized and prefixed with `KONG_`.

Example:

`KONG_NGINX_HTTP_SSL_PROTOCOLS` -> `nginx_http_ssl_protocols`

Will inject the following directive in Kong's `http {}` block:

`ssl_protocols <value>;`

If different sets of protocols are desired between the proxy and Admin API
server, you may specify `nginx_proxy_ssl_protocols` and/or
`nginx_admin_ssl_protocols`, both of which taking precedence over the
`http {}` block.

### nginx_http_ssl_protocols

**Default:** `TLSv1.1 TLSv1.2 TLSv1.3`

**Description:**

Enables the specified protocols for
client-side connections. The set of
supported protocol versions also depends
on the version of OpenSSL Kong was built
with.

See [http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_protocols](http://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_protocols)

### nginx_http_upstream_keepalive

**Default:** `60`

**Description:**

Sets the maximum number of idle keepalive
connections to upstream servers that are
preserved in the cache of each worker
process. When this number is exceeded, the
least recently used connections are closed.
A value of `NONE` will disable this behavior
altogether, forcing each upstream request
to open a new connection.

See [http://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive)

### nginx_http_upstream_keepalive_requests

**Default:** `100`

**Description:**

Sets the maximum number of requests that can
be served through one keepalive connection.
After the maximum number of requests is
made, the connection is closed.

See [http://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive_requests](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive_requests)

### nginx_http_upstream_keepalive_timeout

**Default:** `60s`

**Description:**

Sets a timeout during which an idle
keepalive connection to an upstream server
will stay open.

See [http://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive_timeout](http://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive_timeout)


## Datastore

Kong will store all of its data (such as APIs, consumers, and plugins) in
either Cassandra or PostgreSQL.

All Kong nodes belonging to the same cluster must connect themselves to the
same database.


### database

**Default:** `postgres`

**Description:**

Determines which of PostgreSQL or Cassandra
this node will use as its datastore.
Accepted values are `postgres` and
`cassandra`.


### pg_host

**Default:** `127.0.0.1 `

**Description:**

The PostgreSQL host to connect to.


### pg_port

**Default:** `5432`

**Description:**

The port to connect to.

### pg_timeout

**Default:** `5000`

**Description**

Defines the timout (in milliseconds) for connecting, reading, and writing.

### pg_user

**Default:** `kong`

**Description:**

The username to authenticate if required.


### pg_password

**Default:** `nil`

**Description:**

The password to authenticate if required.


### pg_database

**Default:** `kong`

**Description:**

The database name to connect to.


### pg_ssl

**Default:** `off`

**Description:**

Toggles client-server TLS connections
between Kong and PostgreSQL.


### pg_ssl_verify

**Default:** `off`

**Description:**

Toggles server certificate verification if
`pg_ssl` is enabled. See the `lua_ssl_trusted_certificate`
setting to specify a certificate authority.

### cassandra_contact_points

**Default:** `127.0.0.1`

**Description:**

A comma-separated list of contact points to your cluster.


### cassandra_port

**Default:** `9042`

**Description:**

The port on which your nodes are listening on. All your nodes and contact
points must listen on the same port.


### cassandra_keyspace

**Default:** `kong`

**Description:**

The keyspace to use in your cluster.


### cassandra_timeout

**Default:** `5000`

**Description:**

Defines the timeout (in ms), for reading and writing.


### cassandra_ssl

**Default:** `off`

**Description:**

Toggles client-to-node TLS connections between Kong and Cassandra.


### cassandra_ssl_verify

**Default:** `off`

**Description:**

Toggles server certificate verification if
`cassandra_ssl` is enabled.
See the `lua_ssl_trusted_certificate`
setting to specify a certificate authority.


### cassandra_username

**Default:** `kong`

**Description:**

Username when using the `PasswordAuthenticator` scheme.


### cassandra_password

**Default:** `nil`

**Description:**

Password when using the `PasswordAuthenticator` scheme.


### cassandra_consistency

**Default:** `ONE`

**Description:**

Consistency setting to use when reading/writing to the Cassandra cluster.

### cassandra_lb_policy

**Default:** `RequestRoundRobin`

**Description:**

Load balancing policy to use when
distributing queries across your Cassandra
cluster.
Accepted values are:
`RoundRobin`, `RequestRoundRobin`,
`DCAwareRoundRobin`, and
`RequestDCAwareRoundRobin`.
Prefer the later if and only if you are
using a multi-datacenter cluster.


### cassandra_local_datacenter

**Default:** `nil`

**Description:**

When using the `DCAwareRoundRobin`
or `RequestDCAwareRoundRobin` load
balancing policy, you must specify the name
of the local (closest) datacenter for this
Kong node.


### cassandra_repl_strategy

**Default:** `SimpleStrategy`

**Description:**

When migrating for the first time,
Kong will use this setting to
create your keyspace.
Accepted values are
`SimpleStrategy` and
`NetworkTopologyStrategy`.

### cassandra_repl_factor

**Default:** `1`

**Description:**

When migrating for the first time, Kong
will create the keyspace with this
replication factor when using the
`SimpleStrategy`.


### cassandra_data_centers

**Default:** `dc1:2,dc2:3`

**Description:**

When migrating for the first time,
will use this setting when using the
`NetworkTopologyStrategy`.
The format is a comma-separated list
made of <dc_name>:<repl_factor>.


### cassandra_schema_consensus_timeout

**Default:** `10000`

**Description:**

Defines the timeout (in ms) for
the waiting period to reach a
schema consensus between your
Cassandra nodes.
This value is only used during
migrations.


## Datastore Cache

In order to avoid unecessary communication with the datastore, Kong caches
entities (e.g., APIs, Consumers, Credentials) for a configurable period
of time. It also handles invalidations if such an entity is updated.

This section allows for configuring the behavior of Kong regarding the
caching of such configuration entities.


### db_update_frequency

**Default:** `5`

**Description:**

Frequency (in seconds) at which to check for
updated entities with the datastore.
When a node creates, updates, or deletes an
entity via the Admin API, other nodes need
to wait for the next poll (configured by
this value) to eventually purge the old
cached entity and start using the new one.


### db_update_propagation

**Default:** `0`

**Description:**

Time (in seconds) taken for an entity in the
datastore to be propagated to replica nodes
of another datacenter.
When in a distributed environment such as
a multi-datacenter Cassandra cluster, this
value should be the maximum number of
seconds taken by Cassandra to propagate a
row to other datacenters.
When set, this property will increase the
time taken by Kong to propagate the change
of an entity.
Single-datacenter setups or PostgreSQL
servers should suffer no such delays, and
this value can be safely set to 0.


### db_cache_ttl

**Default:** `0`

**Description:**

Time-to-live (in seconds) of an entity from
the datastore when cached by this node.
Database misses (no entity) are also cached
according to this setting.
If set to 0, such cached entities/misses
never expire.

### db_resurrect_ttl

**Default:** `30`

**Description**

Time (in seconds) for which stale entities from the datastore should be
resurrected for when they cannot be refreshed (e.g., the datastore is
unreachable). When this TTL expires, a new attempt to refresh the stale
entities will be made.


### db_cache_warmup_entities

**Default:** `services, plugins`

**Description**

Entities to be pre-loaded from the datastore into the in-memory cache at Kong
start-up.
This speeds up the first access of endpoints that use the given entities.
When the `services` entity is configured for warmup, the DNS entries for values
in its `host` attribute are pre-resolved asynchronously as well.
Cache size set in `mem_cache_size` should be set to a value large enough to
hold all instances of the specified entities.
If the size is insufficient, Kong will log a warning.


## DNS Resolver

By default the DNS resolver will use the standard configuration files
`/etc/hosts` and `/etc/resolv.conf`. The settings in the latter file will be
overridden by the environment variables `LOCALDOMAIN` and `RES_OPTIONS` if
they have been set.


### dns_resolver

**Default:** `nil`

**Description:**

Comma separated list of nameservers, each
entry in `ip[:port]` format to be used by
Kong. If not specified the nameservers in
the local `resolv.conf` file will be used.
Port defaults to 53 if omitted. Accepts
both IPv4 and IPv6 addresses.


### dns_hostsfile

**Default:** `/etc/hosts`

**Description:**

The hosts file to use. This file is read
once and its content is static in memory.
To read the file again after modifying it,
Kong must be reloaded.


### dns_order

**Default:** `LAST,SRV,A,CNAME`

**Description:**

The order in which to resolve different
record types. The `LAST` type means the
type of the last successful lookup (for the
specified name). The format is a (case
insensitive) comma separated list.

### dns_valid_ttl

**Default:** `nil`

**Description:**

By default, DNS records are cahced using the TTL value of a response. If this
property recevies a value (in seconds), it will override the TTL for all records.

### dns_stale_ttl

**Default:** `4`

**Description:**

 Defines, in seconds, how long a record will
remain in cache past its TTL. This value
will be used while the new DNS record is
fetched in the background.
Stale data will be used from expiry of a
record until either the refresh query
completes, or the `dns_stale_ttl` number of
seconds have passed.


### dns_not_found_ttl

**Default:** `30`

**Description:**

TTL in seconds for empty DNS responses and "(3) name error" responses.


### dns_error_ttl

**Default:** `1`

**Description:**

TTL in seconds for error responses.


### dns_no_sync

**Default:** `off`

**Description:**

If enabled, then upon a cache-miss every
request will trigger its own dns query.
When disabled multiple requests for the
same name/type will be synchronised to a
single query.


## Development & Miscellaneous

Additional settings inherited from lua-nginx-module allowing for more
flexibility and advanced usage.

See the lua-nginx-module documentation for more informations:
https://github.com/openresty/lua-nginx-module


### lua_ssl_trusted_certificate

**Default:** `nil`

**Description:**

Absolute path to the certificate
authority file for Lua cosockets in PEM
format. This certificate will be the one
used for verifying Kong's database
connections, when `pg_ssl_verify` or
`cassandra_ssl_verify` are enabled.


### lua_ssl_verify_depth

**Default:** `1`

**Description:**

Sets the verification depth in the server
certificates chain used by Lua cosockets,
set by `lua_ssl_trusted_certificate`.
This includes the certificates configured
for Kong's database connections.


### lua_package_path

**Default:** `./?.lua;./?/init.lua`

**Description:**

Sets the Lua module search path (LUA_PATH).
Useful when developing or using custom
plugins not stored in the default search
path.


### lua_package_cpath

**Default:** `nil`

**Description:**

Sets the Lua C module search path (LUA_CPATH).


### lua_socket_pool_size

**Default:** `30`

**Description:**

Specifies the size limit for every cosocket
connection pool associated with every remote
server.


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

The lookup, or balancer, address for the Admin GUI.

Accepted format (items in parenthesis are optional):

```
<scheme>://<IP / HOSTNAME>(:<PORT>)
```

**Examples:**
```
- http://127.0.0.1:8003
- https://kong-admin.test
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

**Default:** `nil`

**Description:**

Here you may specify the configuration for the
authentication plugin you have chosen.

* For Basic Authentication, set the value to `basic-auth`
* For LDAP Authentication, set the value to `ldap-auth-advanced`
* For OpenID Connect, set the value to `openid-connect`

### admin_gui_auth_conf

**Default:** `nil`

**Description:**

Here you may specify the configuration for the
authentication plugin you have chosen.

For information about Plugin Configuration consult
the associated plugin documentation.

**Example (for Basic Auth):**

```
admin_gui_auth_conf = { "hide_credentials": true }
```

### admin_gui_session_conf

**Default:** `nil`

**Description:**

Session Plugin Config (JSON)
Here you may specify the configuration for the Session plugin as used by
Kong Manager.

**Example:**

```
admin_gui_session_conf = { "cookie_name": "kookie", "secret": "changeme"}
```

### admin_gui_auth_header

**Default:** `Kong-Admin-User`

**Description:**

Defines the name of the HTTP request header from which the Admin API will
attempt to identify the Kong Admin user.

### admin_gui_auth_password_complexity

**Default:** `nil`

**Description:**

When `admin_gui_auth = basic-auth`, this property defines
the rules required for Kong Manager passwords. Choose
from preset rules or write your own.

Example using preset rules:

`admin_gui_auth_password_complexity = { "kong-preset": "min_8" }`

All values for kong-preset require the password to contain
characters from at least three of the following categories:
1) Uppercase characters (A through Z)
2) Lowercase characters (a through z)
3) Base-10 digits (0 through 9)
4) Special characters (for example, &, $, #, %)

|Value to Use | Minimum Length|
|-------------|---------------|
|min_8        |     8         |
|min_12       |    12         |
|min_20       |    20         |

To write your own rules, see
https://manpages.debian.org/jessie/passwdqc/passwdqc.conf.5.en.html.

NOTE: Only keywords "min", "max" and "passphrase" are supported.

Example:

`admin_gui_auth_password_complexity = { "min": "disabled,24,11,9,8" }`

### admin_gui_auth_login_attempts

**Default:** `0`

Number of times a user can attempt to log in to Kong Manager. `0` entails that
infinite attempts are allowed.

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

**Default:** `nil`

**Description:**

Defines the host and port of the TSDB server
to which Vitals data is written and read.
This value is only applied when the
'vitals_strategy` option is set to
'prometheus' or 'influxdb'. This value
accepts IPv4, IPv6, and hostname values.
If the 'vitals_strategy' is set to
'prometheus', this value determines the
address of the Prometheus server from which
Vitals data will be read. For 'influxdb'
strategies, this value controls both the read
and write source for Vitals data.


### vitals_statsd_address

**Default:** `nil`

**Description:**

Defines the host and port (and an optional
protocol) of the StatsD server to which
Kong should write Vitals metics. This value
is only applied when the 'vitals_strategy' is
set to 'prometheus'. This value accepts IPv4,
IPv6, and, hostnames. Additionally, the suffix
'tcp' can be specified; doing so will result
in Kong sending StatsD metrics via TCP
instead of the UDP (default).


### vitals_statsd_prefix

**Default:** `kong`

**Description:**

Defines the prefix value attached to all
Vitals StatsD events. This prefix is useful
when writing metrics to a multi-tenant StatsD
exporter or server.


### vitals_statsd_udp_packet_size

**Default:** `1024`

**Description:**

Defines the maximum buffer size in
which Vitals statsd metrics will be
held and sent in batches.
This value is defined in bytes.


### vitals_prometheus_scrape_interval

**Default:** `5`

**Description:**

Defines the scrape_interval query
parameter sent to the Prometheus
server when reading Vitals data.
This should be same as the scrape
interval (in seconds) of the
Prometheus server.


## Dev Portal


### portal

**Default:** `off`

**Description:**

Enable or disable the Dev Portal Interface and API

When enabled, Kong will expose the Kong Dev Portal Files endpoint and the
public Dev Portal Files API.

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

**Default:** `http`

**Description:**

The Dev Portal URL protocol

Provide the protocol used in conjunction with portal_gui_host to construct the
lookup, or balancer address for Kong Proxy nodes.

**Example:**

```
portal_gui_protocol = http
```


### portal_gui_host

**Default** `127.0.0.1:8003`

**Description**

Dev Portal GUI Host

Provide the host unsed in conjunction with portal_gui_protocol to construct the
lookup, or balancer address for Kong Proxy nodes.

**Example:**

```
portal_gui_host = localhost:8003
```

### portal_cors_origins

**Default:** `nil`

**Description:**

A comma separated list of allowed domains for `Access-Control-Allow-Origin`
header. This can be used to resolve CORS issues in custom networking
environments.

**Example:**

```
portal_cors_origins = http://localhost:8003, https://localhost:8004
```

### portal_gui_use_subdomains

**Default** `Off`

**Description**

Enable workspaced Dev Portals to use subdomains

By default the Dev Portal will use the first namespace in the request path to
determine the workspace. By enabling subdomains, the Dev Portal will expect the
workspace to be included in the request url as a subdomain

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

The absolute path to the SSL certificate for `portal_gui_listen` values with
SSL enabled.

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

**Default:** `nil`

**Description:**

The address on which the Dev Portal API is accessible by Kong.

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

`portal_api_access.log` location can be absolute or relative. When using
relative pathing, logs will be placed under the `prefix` location.

Setting this value to `off` will disable logging
Portal API access logs.

**Example:**

```
portal_api_access_log = logs/portal_api_access.log
```


### portal_api_error_log

**Default:** `logs/error.log`

**Description:**

Developer Portal API Error Log location.

Here you can set an absolute or relative path for your
Portal API access logs.

Setting this value to `off` will disable logging
Portal API access logs.

When using relative pathing, logs will be placed under
the `prefix` location.

Granularity can be adjusted through the `log_level`
directive.

### portal_is_legacy

**Default:** `off`

**Description:**

Developer Portal legacy support

Setting this value to `on` causes all new
portals to render using the legacy rendering system by default.

Setting this value to `off` causes all new
portals to render using the current rendering system.


## Default Dev Portal Authentication

Referenced on workspace creation to set Dev Portal authentication defaults
in the database for that particular workspace.


### portal_auth

**Default:** `nil`

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

### portal_auth_password_complexity

**Default:** `nil`

**Description:**

Dev Portals that are authenticated with the **Basic Auth** plugin support password complexity enforcement using either a predned Kong preset or custom rules.

Kong's Preset requires passwords contain characters from at least three of the following categories:

1. Uppercase characters (A through Z)
2. Lowercase characters (a through z)
3. Base-10 digits (0 through 9)
4. Special characters (&, $, #, % etc)

To write your own rules, see  (https://manpages.debian.org/jessie/passwdqc/passwdqc.conf.5.en.html)

>NOTE: Only the keywords "min", "max", and "passphrase"

**Examples:**

```
portal_auth_password_complexity = { "kong-preset": "min_8"}
```

```
portal_auth_password_complexity = { "min": "12", max: "24"}
```


### portal_auth_conf

**Default:** `nil`

**Description:**

Here you can specify authentication plugin configuration
via JSON Object format to be applied to your Developer
Portal auth plugin. For information about Plugin Configuration
consult the associated plugin documentation.

**Example (Basic Auth):**

```
portal_auth_conf = { "hide_credentials": true }
```

### portal_auth_login_attempts

**Default:** 0

**Description:**

Dictates the number of times a user can attempt to log into the Developer Portal before the password must be reset.

The default value of '0' allows infinite attempts.

>NOTE: This configuration only applies to Developer Portals using `Basic Auth` for authentication.


### portal_auto_approve

**Default:** `off`

**Description:**

When this flag is set to 'on', a developer will automatically be marked as
"approved" after completing registration. Access can still be revoked through the
Kong Manager or Admin API.


### portal_session_conf

**Default:** `nil`

**Description:**

Portal Session Plugin Config (JSON)

Here you may specify the configuration for the Session plugin as use by Kong
Dev Portal.

**Example:**
```
portal_session_conf= {"cookie_name": "portal_session", "secret":"changeme", "storage":"kong"}
```


### portal_token_exp

**Default:** `21600`

**Description:**

Duration in seconds for the expiration of the Dev Portal reset password token.
Default `21600` is six hours.

### portal_email_verification

**Default:** `off`

**Description:**

When enabled, Developers receive an email upon
registration to verify their account.  Developers are
not able to use the Developer Portal until they
verify their account.

Note: SMTP must be turned on in order to use this feature.

## Default Dev Portal SMTP Configuration

Referenced on workspace creation to set SMTP defaults in the database
for that particular workspace.


### portal_invite_email

**Default:** `on`

**Description:**

When enabled, Admins will be able to invite Developers to a Dev Portal by
using the "Invite" button in the Kong Manager.


### portal_access_request_email

**Default:** `on`

**Description:**

When enabled, Admins specified by `smtp_admin_emails` will receive an email
when a Developer requests access to a Dev Portal.


### portal_approved_email

**Default:** `on`

**Description:**

When enabled, Developers will receive an email when access to a Dev Portal has
been approved.


### portal_reset_email

**Default:** `on`

**Description:**

When enabled, Developers will be able to use the "Reset Password" flow on a
Dev Portal and will receive an email with password reset instructions.

When disabled, Developers will *not* be able to reset their account passwords.


### portal_reset_success_email

**Default:** `on`

**Description:**

When enabled, Developers will receive an email after successfully reseting
their Dev Portal account password.

When disabled, Developers will still be able to reset their account passwords,
but will not recieve a confirmation email.


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


### admin_emails_from

**Default:** `""`

**Description:**

The email address for the 'From' header included in Admin emails

**Example :**

```
admin_emails_from = "example@example.com"
```


### admin_emails_reply_to

**Default:** `nil`

**Description:**

The email address for the 'Reply-To' header included in Admin emails

**Example :**

```
admin_emails_reply_to = admin@example.com
```


### admin_invitation_expiry

**Default:** `259200`

**Description:**

Expiration time in seconds for Admin invitation links. Set to zero for no
expiration.


## General SMTP Configuration


### smtp_mock

**Default:** `on`

**Description:**

When enabled this flag will only mock the sending of emails and will not
attempt to send actual emails. This can be used for testing before the SMTP
client is fully configured.

**Examples:**

`smtp_mock = on` Emails will NOT attempt send.
`smtp_mock = off` Emails will attempt send.


### smtp_host

**Default:** `nil`

**Description:**
The host of the SMTP server to connect to.


### smtp_port

**Default:** `nil`

**Description:**

The port number on SMTP server to connect to.


### smtp_starttls

**Default:** `nil`

**Description:**

When set to `on`, STARTTLS is used to encrypt communication with the SMTP
server. This is normally used in conjunction with port 587.


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

When set to `on` SMTPS is used to encrypt communication with the SMTP server.
This is normally used in conjunction with port 465.


### smtp_auth_type

**Default:** `nil`

**Description:**

The method used to authenticate with the SMTP server. Valid options are
`plain`, `login`, or `nil`.


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

When enabled, Kong will store detailed audit data regarding Admin API and
database access. In most cases, updates to the database are associated with
Admin API requests. As such, database object audit log data is tied to a
given HTTP via a unique identifier, providing built-in association of Admin
API and database traffic.


### audit_log

**Default:** `off`

**Description:**

When enabled, Kong will log information about Admin API access and database
row insertions, updates, and deletes.


### audit_log_ignore_methods

**Default:** `nil`

**Description:**

Comma-separated list of HTTP methods that will not generate audit log entries.
By default, all HTTP requests will be logged.


### audit_log_ignore_paths

**Default:** `nil`

**Description:**

Comma-separated list of request paths that will not generate audit log entries.
By default, all HTTP requests will be logged.


### audit_log_ignore_tables

**Default:** `nil`

**Description:**

Comma-separated list of database tables that will not generate audit log
entries. By default, updates to all database tables will be logged (the
term "updates" refers to the creation, update, or deletion of a row).


### audit_log_record_ttl

**Default:** `2592000`

**Description:**

Length, in seconds, of the TTL for audit log records. Records in the database
older than their TTL are automatically purged.


### audit_log_signing_key

**Default:** `nil`

**Description:**

Defines the path to a private RSA signing key that can be used to insert a
signature of audit records, adjacent to the record. The corresponding public
key should be stored offline, and can be used the validate audit entries in
the future. If this value is undefined, no signature will be generated.

## Granular Tracing

Granular tracing offers a mechanism to expose metrics and detailed debug data
about the lifecycle of Kong in a human, or machine, consumable format.

### tracing

**Default:** `off`

**Description:**

When enable, Kong will generate granular debug data about various portions of the
request lifecycle, such as DB or DNS queries, plugin execution, core handler timing,
etc.

### tracing_write_strategy

**Default:** `file`

**Description**

Defines how Kong will write tracing data at the conclusion of the request. The
 default option, `file`, writes a human-readable depiction of tracing data to a
 configurable location on the node's file system. Other strategies write tracing
 data as a JSON document to the configured endpoint. Valid entries for this
 option are `file`, `file_raw`, `http`, `tcp`, `tls`, and `udp`.

### tracing_write_endpoint

**Default:** `nil`

**Description:**

Defines the endpoint to which tracing data will be written. For the 'file' and
'file_raw' tracing write strategies, this value must be a valid location on the
node's file system to which Kong must have write access.

For the `tcp`, `tls`, and `udp` strategies, this value is defined as a string in
the form of:

```
  <HOST>:<PORT>
```

 For the `http` strategy, this value is defined in the form of:
```
  <scheme>://<IP / HOSTNAME>(:<PORT>(/<PATH>))
```
 Traces sent via HTTP are delivered via POST method with an `application/json`
 Content-Type.

### tracing_time_threshold

**Default:** `0`

**Description:**

The minimum time, in microseconds, over which a trace must execute in order to
 write the trace data to the configured endpoint. This configuration can be used
 to lower the noise present in trace data by removing trace objects that are not
 interesting from a timing perspective. The default value of '0' removes this
 limitation, causing traces of any duration to be written.

### tracing_types

**Default:** `all`

**Description:**

Defines the types of traces that are written. Trace types not defined in this
list are ignored, regardless of their lifetime. The default special value of
'all' results in all trace types being written, regardless of type. Included
trace types are: `query`,`legacy_query`, `router`, `balancer.getPeer`, `
balancer.toip`, `connect.toip`, `access.before`, and `access.after`
`cassandra_iterate`, and `plugin`.

### tracing_debug_header

**Default:** `nil`

**Description:**

Defines the name of the HTTP request header that must be present in order to
generate traces within a request. Setting this value provides a mechanism to
selectively generate request traces at the client's request. Note that the value
of the header does not matter, only that the header is present in the request.
When this value is not set and tracing is enabled, Kong will generate trace data
for all requests flowing through the proxy and Admin API.

Note: Data from certificate handling phases is not logged when this setting is enabled.

### generate_trace_details

**Default:** `off`

**Description:**

When enabled, Kong will write context-specific details into traces. Trace details
offer more data about the context of the trace. This can significantly increase
the size of trace reports. Note also that trace details may contain potentially
sensitive information, such as raw SQL queries; care should be taken to store
traces properly when this option is enabled.


## Route Collision Detection and Prevention

### route_validation_strategy

**Default:** `smart`

The strategy used to validate
routes when creating or updating them.
Different strategies are available to tune
how to enforce splitting traffic of
workspaces.

- 'smart' is the default option and uses the algorithm described in [this example](/enterprise/{{page.kong_version}}/admin-api/workspaces/examples/#important-note-conflicting-apis-or-routes-in-workspaces).
- 'off' disables any check
- 'path' enforces routes to comply with the pattern described in config enforce_route_path_pattern

### enforce_route_path_pattern

**Default:** `nil`

Here you can specify Lua pattern to enforce
on a `path` attributes of a route object. You can also add a
placeholder for workspace in pattern to render during runtime based
on the workspace to which the `route` belongs. It is a
field if 'route_validation_strategy' is set to 'path'

**Example:**
For Pattern '/$(workspace)/v%d/.*' valid path are:

1. '/group1/v1/' if route belongs to workspace 'group1'.
2. '/group2/v1/some_path' if route belongs to workspace 'group2'.


## Workspaces


### route_validation_strategy

**Default:** `smart`

The strategy used to validate routes when creating or updating them.
Different strategies are available to tune how to enforce splitting
traffic of workspaces.

- `smart` is the default option and uses the algorithm described in [this example](/enterprise/{{page.kong_version}}/admin-api/workspaces/examples/#important-note-conflicting-apis-or-routes-in-workspaces).

- `off` disables all checks.

- `path` enforces routes to comply with the pattern described in
config enforce_route_path_pattern.

### enforce_route_path_pattern

**Default:** `nil`

Here you can specify Lua pattern which will be enforced on a `path`
attributes of a route object. You can also add a placeholder for
workspace in pattern, which will be rendered during runtime based on
workspace to which `route` belongs to. It a field if
'route_validation_strategy' is set to 'path'

Example:

For Pattern `/$(workspace)/v%d/.*` valid path are:
1. `/group1/v1/` if route belongs to workspace 'group1'.
2. `/group2/v1/some_path` if route belongs to workspace 'group2'.
