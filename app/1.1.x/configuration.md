---
title: Configuration Reference
---

## Configuration loading

Kong comes with a default configuration file that can be found at
`/etc/kong/kong.conf.default` if you installed Kong via one of the official
packages. To start configuring Kong, you can copy this file:

```bash
$ cp /etc/kong/kong.conf.default /etc/kong/kong.conf
```

Kong will operate with default settings should all the values in your
configuration be commented out. Upon starting, Kong looks for several
default locations that might contain a configuration file:

```
/etc/kong/kong.conf
/etc/kong.conf
```

You can override this behavior by specifying a custom path for your
configuration file using the `-c / --conf` argument in the CLI:

```bash
$ kong start --conf /path/to/kong.conf
```

The configuration format is straightforward: simply uncomment any property
(comments are defined by the `#` character) and modify it to your needs.
Boolean values can be specified as `on`/`off` or `true`/`false` for convenience.

## Verifying your configuration

You can verify the integrity of your settings with the `check` command:

```bash
$ kong check <path/to/kong.conf>
configuration at <path/to/kong.conf> is valid
```

This command will take into account the environment variables you have
currently set, and will error out in case your settings are invalid.

Additionally, you can also use the CLI in debug mode to have more insight
as to what properties Kong is being started with:

```bash
$ kong start -c <kong.conf> --vv
2016/08/11 14:53:36 [verbose] no config file found at /etc/kong.conf
2016/08/11 14:53:36 [verbose] no config file found at /etc/kong/kong.conf
2016/08/11 14:53:36 [debug] admin_listen = "0.0.0.0:8001"
2016/08/11 14:53:36 [debug] database = "postgres"
2016/08/11 14:53:36 [debug] log_level = "notice"
[...]
```

## Environment variables

When loading properties out of a configuration file, Kong will also look for
environment variables of the same name. This allows you to fully configure Kong
via environment variables, which is very convenient for container-based
infrastructures, for example.

To override a setting using an environment variable, declare an environment
variable with the name of the setting, prefixed with `KONG_` and capitalized.

For example:

```
log_level = debug # in kong.conf
```

can be overridden with:

```bash
$ export KONG_LOG_LEVEL=error
```

## Injecting Nginx directives

Tweaking the Nginx configuration of your Kong instances allows you to optimize
its performance for your infrastructure.

When Kong starts, it builds an Nginx configuration file. You can inject custom
Nginx directives to this file directly via your Kong configuration.

### Injecting individual Nginx directives

Any entry added to your `kong.conf` file that is prefixed by `nginx_http_`,
`nginx_proxy_` or `nginx_admin_` will be converted into an equivalent Nginx
directive by removing the prefix and added to the appropriate section of the
Nginx configuration:

- Entries prefixed with `nginx_http_` will be injected to the overall `http`
block directive.

- Entries prefixed with `nginx_proxy_` will be injected to the `server` block
directive handling Kong's proxy ports.

- Entries prefixed with `nginx_admin_` will be injected to the `server` block
directive handling Kong's Admin API ports.

For example, if you add the following line to your `kong.conf` file:

```
nginx_proxy_large_client_header_buffers=16 128k
```

it will add the following directive to the proxy `server` block of Kong's
Nginx configuration:

```
    large_client_header_buffers 16 128k;
```

Like any other entry in `kong.conf`, these directives can also be specified
using [environment variables](#environment-variables) as shown above. For
example, if you declare an environment variable like this:

```bash
$ export KONG_NGINX_HTTP_OUTPUT_BUFFERS="4 64k"
```

This will result in the following Nginx directive being added to the `http`
block:

```
    output_buffers 4 64k;
```

As always, be mindful of your shell's quoting rules specifying values
containing spaces.

For more details on the Nginx configuration file structure and block
directives, see https://nginx.org/en/docs/beginners_guide.html#conf_structure.

For a list of Nginx directives, see https://nginx.org/en/docs/dirindex.html.
Note however that some directives are dependent of specific Nginx modules,
some of which may not be included with the official builds of Kong.

### Including files via injected Nginx directives

For more complex configuration scenarios, such as adding entire new
`server` blocks, you can use the method described above to inject an
`include` directive to the Nginx configuration, pointing to a file
containing your additional Nginx settings.

For example, if you create a file called `my-server.kong.conf` with
the following contents:

```
# custom server
server {
  listen 2112;
  location / {
    # ...more settings...
    return 200;
  }
}
```

You can make the Kong node serve this port by adding the following
entry to your `kong.conf` file:

```
nginx_http_include = /path/to/your/my-server.kong.conf
```

or, alternatively, by configuring it via an environment variable:

```bash
$ export KONG_NGINX_HTTP_INCLUDE="/path/to/your/my-server.kong.conf"
```

Now, when you start Kong, the `server` section from that file will be added to
that file, meaning that the custom server defined in it will be responding,
alongside the regular Kong ports:

```bash
$ curl -I http://127.0.0.1:2112
HTTP/1.1 200 OK
...
```

Note that if you use a relative path in an `nginx_http_include` property, that
path will be interpreted relative to the value of the `prefix` property of
your `kong.conf` file (or the value of the `-p` flag of `kong start` if you
used it to override the prefix when starting Kong).

## Custom Nginx templates & embedding Kong

For the vast majority of use-cases, using the Nginx directive injection system
explained above should be sufficient for customizing the behavior of Kong's
Nginx instance. This way, you can manage the configuration and tuning of your
Kong node from a single `kong.conf` file (and optionally your own included
files), without having to deal with custom Nginx configuration templates.

There are two scenarios in which you may want to make use of custom Nginx
configuration templates directly:

- In the rare occasion that you may need to modify some of Kong's default
Nginx configuration that are not adjustable via its standard `kong.conf`
properties, you can still modify the template used by Kong for producing its
Nginx configuration and launch Kong using your customized template.

- If you need to embed Kong in an already running OpenResty instance, you
can reuse Kong's generated configuration and include it in your existing
configuration.

### Custom Nginx templates

Kong can be started, reloaded and restarted with an `--nginx-conf` argument,
which must specify an Nginx configuration template. Such a template uses the
[Penlight][Penlight] [templating engine][pl.template], which is compiled using
the given Kong configuration, before being dumped in your Kong prefix
directory, moments before starting Nginx.

The default template can be found at:
https://github.com/kong/kong/tree/master/kong/templates. It is split in two
Nginx configuration files: `nginx.lua` and `nginx_kong.lua`. The former is
minimalistic and includes the latter, which contains everything Kong requires
to run. When `kong start` runs, right before starting Nginx, it copies these
two files into the prefix directory, which looks like so:

```
/usr/local/kong
├── nginx-kong.conf
└── nginx.conf
```

If you must tweak global settings that are defined by Kong but not adjustable
via the Kong configuration in `kong.conf`, you can inline the contents of the
`nginx_kong.lua` configuration template into a custom template file (in this
example called `custom_nginx.template`) like this:

```
# ---------------------
# custom_nginx.template
# ---------------------

worker_processes ${{ "{{NGINX_WORKER_PROCESSES" }}}}; # can be set by kong.conf
daemon ${{ "{{NGINX_DAEMON" }}}};                     # can be set by kong.conf

pid pids/nginx.pid;                      # this setting is mandatory
error_log logs/error.log ${{ "{{LOG_LEVEL" }}}}; # can be set by kong.conf

events {
    use epoll;          # a custom setting
    multi_accept on;
}

http {

  # contents of the nginx_kong.lua template follow:

  resolver ${{ "{{DNS_RESOLVER" }}}} ipv6=off;
  charset UTF-8;
  error_log logs/error.log ${{ "{{LOG_LEVEL" }}}};
  access_log logs/access.log;

  ... # etc
}
```

You can then start Kong with:

```bash
$ kong start -c kong.conf --nginx-conf custom_nginx.template
```

## Embedding Kong in OpenResty

If you are running your own OpenResty servers, you can also easily embed Kong
by including the Kong Nginx sub-configuration using the `include` directive.
If you have an existing Nginx configuration, you can simply include the
Kong-specific portion of the configuration which is output by Kong in a separate
`nginx-kong.conf` file:

```
# my_nginx.conf

# ...your nginx settings...

http {
    include 'nginx-kong.conf';

    # ...your nginx settings...
}
```

You can then start your Nginx instance like so:

```bash
$ nginx -p /usr/local/openresty -c my_nginx.conf
```

and Kong will be running in that instance (as configured in `nginx-kong.conf`).

## Serving both a website and your APIs from Kong

A common use case for API providers is to make Kong serve both a website
and the APIs themselves over the Proxy port &mdash; `80` or `443` in
production. For example, `https://example.net` (Website) and
`https://example.net/api/v1` (API).

To achieve this, we cannot simply declare a new virtual server block,
like we did in the previous section. A good solution is to use a custom
Nginx configuration template which inlines `nginx_kong.lua` and adds a new
`location` block serving the website alongside the Kong Proxy `location`
block:

```
# ---------------------
# custom_nginx.template
# ---------------------

worker_processes ${{ "{{NGINX_WORKER_PROCESSES" }}}}; # can be set by kong.conf
daemon ${{ "{{NGINX_DAEMON" }}}};                     # can be set by kong.conf

pid pids/nginx.pid;                      # this setting is mandatory
error_log logs/error.log ${{ "{{LOG_LEVEL" }}}}; # can be set by kong.conf
events {}

http {
  # here, we inline the contents of nginx_kong.lua
  charset UTF-8;

  # any contents until Kong's Proxy server block
  ...

  # Kong's Proxy server block
  server {
    server_name kong;

    # any contents until the location / block
    ...

    # here, we declare our custom location serving our website
    # (or API portal) which we can optimize for serving static assets
    location / {
      root /var/www/example.net;
      index index.htm index.html;
      ...
    }

    # Kong's Proxy location / has been changed to /api/v1
    location /api/v1 {
      set $upstream_host nil;
      set $upstream_scheme nil;
      set $upstream_uri nil;

      # Any remaining configuration for the Proxy location
      ...
    }
  }

  # Kong's Admin server block goes below
  # ...
}
```

## Properties reference

### General section

#### prefix

Working directory. Equivalent to Nginx's prefix path, containing temporary
files and logs.

Each Kong process must have a separate working directory.

Default: `/usr/local/kong/`

---

#### log_level

Log level of the Nginx server. Logs are found at `<prefix>/logs/error.log`.

See http://nginx.org/en/docs/ngx_core_module.html#error_log for a list of
accepted values.

Default: `notice`

---

#### proxy_access_log

Path for proxy port request access logs. Set this value to `off` to disable
logging proxy requests.

If this value is a relative path, it will be placed under the `prefix`
location.

Default: `logs/access.log`

---

#### proxy_error_log

Path for proxy port request error logs. The granularity of these logs is
adjusted by the `log_level` directive.

Default: `logs/error.log`

---

#### admin_access_log

Path for Admin API request access logs. Set this value to `off` to disable
logging Admin API requests.

If this value is a relative path, it will be placed under the `prefix`
location.

Default: `logs/admin_access.log`

---

#### admin_error_log

Path for Admin API request error logs. The granularity of these logs is
adjusted by the `log_level` directive.

Default: `logs/error.log`

---

#### plugins

Comma-separated list of plugins this node should load. By default, only plugins
bundled in official distributions are loaded via the `bundled` keyword.

Loading a plugin does not enable it by default, but only instructs Kong to load
its source code, and allows to configure the plugin via the various related
Admin API endpoints.

The specified name(s) will be substituted as such in the Lua namespace:
`kong.plugins.{name}.*`.

When the `off` keyword is specified as the only value, no plugins will be
loaded.

`bundled` and plugin names can be mixed together, as the following examples
suggest:

- `plugins = bundled,custom-auth,custom-log` will include the bundled plugins
  plus two custom ones
- `plugins = custom-auth,custom-log` will *only* include the `custom-auth` and
  `custom-log` plugins.
- `plugins = off` will not include any plugins

**Note:** Kong will not start if some plugins were previously configured (i.e.
have rows in the database) and are not specified in this list.

Before disabling a plugin, ensure all instances of it are removed before
restarting Kong.

**Note:** Limiting the amount of available plugins can improve P99 latency when
experiencing LRU churning in the database cache (i.e. when the configured
`mem_cache_size`) is full.

Default: `bundled`

---

#### anonymous_reports

Send anonymous usage data such as error stack traces to help improve Kong.

Default: `on`

---


### NGINX section

#### proxy_listen

Comma-separated list of addresses and ports on which the proxy server should
listen for HTTP/HTTPS traffic.

The proxy server is the public entry point of Kong, which proxies traffic from
your consumers to your backend services. This value accepts IPv4, IPv6, and
hostnames.

Some suffixes can be specified for each pair:

- `ssl` will require that all connections made through a particular
  address/port be made with TLS enabled.
- `http2` will allow for clients to open HTTP/2 connections to Kong's proxy
  server.
- `proxy_protocol` will enable usage of the PROXY protocol for a given
  address/port.
- `transparent` will cause kong to listen to, and respond from, any and all IP
  addresses and ports you configure in iptables.

This value can be set to `off`, thus disabling the HTTP/HTTPS proxy port for
this node.

If stream_listen is also set to `off`, this enables 'control-plane' mode for
this node (in which all traffic proxying capabilities are disabled). This node
can then be used only to configure a cluster of Kong nodes connected to the same
datastore.

Example: `proxy_listen = 0.0.0.0:443 ssl, 0.0.0.0:444 http2 ssl`

See http://nginx.org/en/docs/http/ngx_http_core_module.html#listen for a
description of the accepted formats for this and other `*_listen` values.

See https://www.nginx.com/resources/admin-guide/proxy-protocol/ for more
details about the `proxy_protocol` parameter.

Not all `*_listen` values accept all formats specified in nginx's
documentation.

Default: `0.0.0.0:8000, 0.0.0.0:8443 ssl`

---

#### stream_listen

Comma-separated list of addresses and ports on which the stream mode should
listen.

This value accepts IPv4, IPv6, and hostnames.

Some suffixes can be specified for each pair:

- `proxy_protocol` will enable usage of the PROXY protocol for a given
  address/port.
- `transparent` will cause kong to listen to, and respond from, any and all IP
  addresses and ports you configure in iptables.

**Note:** The `ssl` suffix is not supported, and each address/port will accept
TCP with or without TLS enabled.

Examples:

```
stream_listen = 127.0.0.1:7000
stream_listen = 0.0.0.0:989, 0.0.0.0:20
stream_listen = [::1]:1234
```

By default this value is set to `off`, thus disabling the stream proxy port for
this node.

See http://nginx.org/en/docs/stream/ngx_stream_core_module.html#listen for a
description of the formats that Kong might accept in stream_listen.

Default: `off`

---

#### admin_listen

Comma-separated list of addresses and ports on which the Admin interface should
listen.

The Admin interface is the API allowing you to configure and manage Kong.

Access to this interface should be *restricted* to Kong administrators *only*.
This value accepts IPv4, IPv6, and hostnames.

Some suffixes can be specified for each pair:

- `ssl` will require that all connections made through a particular
  address/port be made with TLS enabled.
- `http2` will allow for clients to open HTTP/2 connections to Kong's proxy
  server.
- Finally, `proxy_protocol` will enable usage of the PROXY protocol for a given
  address/port.

This value can be set to `off`, thus disabling the Admin interface for this
node, enabling a 'data-plane' mode (without configuration capabilities) pulling
its configuration changes from the database.

Example: `stream_listen = 127.0.0.1:8444 http2 ssl`

Default: `127.0.0.1:8001, 127.0.0.1:8444 ssl`

---

#### nginx_user

Defines user and group credentials used by worker processes. If group is
omitted, a group whose name equals that of user is used.

Example: `nginx_user = nginx www`

Default: `nobody nobody`

---

#### nginx_worker_processes

Determines the number of worker processes spawned by Nginx.

See http://nginx.org/en/docs/ngx_core_module.html#worker_processes for detailed
usage of this directive and a description of accepted values.

Default: `auto`

---

#### nginx_daemon

Determines whether Nginx will run as a daemon or as a foreground process.
Mainly useful for development or when running Kong inside a Docker environment.

See http://nginx.org/en/docs/ngx_core_module.html#daemon.

Default: `on`

---

#### mem_cache_size

Size of the in-memory cache for database entities. The accepted units are `k`
and `m`, with a minimum recommended value of a few MBs.

Default: `128m`

---

#### ssl_cipher_suite

Defines the TLS ciphers served by Nginx.

Accepted values are `modern`, `intermediate`, `old`, or `custom`.

See https://wiki.mozilla.org/Security/Server_Side_TLS for detailed descriptions
of each cipher suite.

Default: `modern`

---

#### ssl_ciphers

Defines a custom list of TLS ciphers to be served by Nginx. This list must
conform to the pattern defined by `openssl ciphers`.

This value is ignored if `ssl_cipher_suite` is not `custom`.

Default: none

---

#### ssl_cert

The absolute path to the SSL certificate for `proxy_listen` values with SSL
enabled.

Default: none

---

#### ssl_cert_key

The absolute path to the SSL key for `proxy_listen` values with SSL enabled.

Default: none

---

#### client_ssl

Determines if Nginx should send client-side SSL certificates when proxying
requests.

Default: `off`

---

#### client_ssl_cert

If `client_ssl` is enabled, the absolute path to the client SSL certificate for
the `proxy_ssl_certificate` directive. Note that this value is statically
defined on the node, and currently cannot be configured on a per-API basis.

Default: none

---

#### client_ssl_cert_key

If `client_ssl` is enabled, the absolute path to the client SSL key for the
`proxy_ssl_certificate_key` address. Note this value is statically defined on
the node, and currently cannot be configured on a per-API basis.

Default: none

---

#### admin_ssl_cert

The absolute path to the SSL certificate for `admin_listen` values with SSL
enabled.

Default: none

---

#### admin_ssl_cert_key

The absolute path to the SSL key for `admin_listen` values with SSL enabled.

Default: none

---

#### upstream_keepalive

Sets the maximum number of idle keepalive connections to upstream servers that
are preserved in the cache of each worker process. When this number is exceeded,
the least recently used connections are closed.

A value of `0` will disable this behavior altogether, forcing each upstream
request to open a new connection.

Default: `60`

---

#### headers

Comma-separated list of headers Kong should inject in client responses.

Accepted values are:

- `Server`: Injects `Server: kong/x.y.z` on Kong-produced response (e.g. Admin
  API, rejected requests from auth plugin, etc...).
- `Via`: Injects `Via: kong/x.y.z` for successfully proxied requests.
- `X-Kong-Proxy-Latency`: Time taken (in milliseconds) by Kong to process a
  request and run all plugins before proxying the request upstream.
- `X-Kong-Upstream-Latency`: Time taken (in milliseconds) by the upstream
  service to send response headers.
- `X-Kong-Upstream-Status`: The HTTP status code returned by the upstream
  service. This is particularly useful for clients to distinguish upstream
  statuses if the response is rewritten by a plugin.
- `server_tokens`: Same as specifying both `Server` and `Via`.
- `latency_tokens`: Same as specifying both `X-Kong-Proxy-Latency` and
  `X-Kong-Upstream-Latency`.

In addition to those, this value can be set to `off`, which prevents Kong from
injecting any of the above headers. Note that this does not prevent plugins from
injecting headers of their own.

Example: `headers = via, latency_tokens`

Default: `server_tokens, latency_tokens`

---

#### trusted_ips

Defines trusted IP addresses blocks that are known to send correct
`X-Forwarded-*` headers.

Requests from trusted IPs make Kong forward their `X-Forwarded-*` headers
upstream.

Non-trusted requests make Kong insert its own `X-Forwarded-*` headers.

This property also sets the `set_real_ip_from` directive(s) in the Nginx
configuration. It accepts the same type of values (CIDR blocks) but as a
comma-separated list.

To trust *all* /!\ IPs, set this value to `0.0.0.0/0,::/0`.

If the special value `unix:` is specified, all UNIX-domain sockets will be
trusted.

See http://nginx.org/en/docs/http/ngx_http_realip_module.html#set_real_ip_from
for examples of accepted values.

Default: none

---

#### real_ip_header

Defines the request header field whose value will be used to replace the client
address.

This value sets the `ngx_http_realip_module` directive of the same name in the
Nginx configuration.

If this value receives `proxy_protocol`:

- at least one of the `proxy_listen` entries must have the `proxy_protocol`
  flag enabled.
- the `proxy_protocol` parameter will be appended to the `listen` directive of
  the Nginx template.

See http://nginx.org/en/docs/http/ngx_http_realip_module.html#real_ip_header
for a description of this directive.

Default: `X-Real-IP`

---

#### real_ip_recursive

This value sets the ngx_http_realip_module directive of the same name in the
Nginx configuration.

See http://nginx.org/en/docs/http/ngx_http_realip_module.html#real_ip_recursive
for a description of this directive.

Default: `off`

---

#### client_max_body_size

Defines the maximum request body size allowed by requests proxied by Kong,
specified in the Content-Length request header. If a request exceeds this limit,
Kong will respond with a 413 (Request Entity Too Large). Setting this value to 0
disables checking the request body size.

See
http://nginx.org/en/docs/http/ngx_http_core_module.html#client_max_body_size for
further description of this parameter. Numeric values may be suffixed with `k`
or `m` to denote limits in terms of kilobytes or megabytes.

Default: `0`

---

#### client_body_buffer_size

Defines the buffer size for reading the request body. If the client request
body is larger than this value, the body will be buffered to disk. Note that
when the body is buffered to disk Kong plugins that access or manipulate the
request body may not work, so it is advisable to set this value as high as
possible (e.g., set it as high as `client_max_body_size` to force request bodies
to be kept in memory). Do note that high-concurrency environments will require
significant memory allocations to process many concurrent large request bodies.

See
http://nginx.org/en/docs/http/ngx_http_core_module.html#client_body_buffer_size
for further description of this parameter. Numeric values may be suffixed with
`k` or `m` to denote limits in terms of kilobytes or megabytes.

Default: `8k`

---

#### error_default_type

Default MIME type to use when the request `Accept` header is missing and Nginx
is returning an error for the request.

Accepted values are `text/plain`, `text/html`, `application/json`, and
`application/xml`.

Default: `text/plain`

---


### Datastore section

Kong will store all of its data (such as Routes, Services, Consumers, and
Plugins) in either Cassandra or PostgreSQL, and all Kong nodes belonging to the
same cluster must connect themselves to the same database.

Kong supports the following database versions:

- **PostgreSQL**: 9.5 and above.
- **Cassandra**: 2.2 and above.

---

#### database

Determines which of PostgreSQL or Cassandra this node will use as its
datastore.

Accepted values are `postgres` and `cassandra`.

Default: `postgres`

---


#### Postgres settings

name   | description  | default
-------|--------------|----------
**pg_host** | Host of the Postgres server. | `127.0.0.1`
**pg_port** | Port of the Postgres server. | `5432`
**pg_timeout** | Defines the timeout (in ms), for connecting, reading and writing. | `5000`
**pg_user** | Postgres user. | `kong`
**pg_password** | Postgres user's password. | none
**pg_database** | The database name to connect to. | `kong`
**pg_schema** | The database schema to use. If unspecified, Kong will respect the `search_path` value of your PostgreSQL instance. | none
**pg_ssl** | Toggles client-server TLS connections between Kong and PostgreSQL. | `off`
**pg_ssl_verify** | Toggles server certificate verification if `pg_ssl` is enabled. See the `lua_ssl_trusted_certificate` setting to specify a certificate authority. | `off`

#### Cassandra settings

name   | description  | default
-------|--------------|----------
**cassandra_contact_points** | A comma-separated list of contact points to your cluster. You may specify IP addresses or hostnames. Note that the port component of SRV records will be ignored in favor of `cassandra_port`. When connecting to a multi-DC cluster, ensure that contact points from the local datacenter are specified first in this list. | `127.0.0.1`
**cassandra_port** | The port on which your nodes are listening on. All your nodes and contact points must listen on the same port. Will be created if it doesn't exist. | `9042`
**cassandra_keyspace** | The keyspace to use in your cluster. | `kong`
**cassandra_consistency** | Consistency setting to use when reading/ writing to the Cassandra cluster. | `ONE`
**cassandra_timeout** | Defines the timeout (in ms) for reading and writing. | `5000`
**cassandra_ssl** | Toggles client-to-node TLS connections between Kong and Cassandra. | `off`
**cassandra_ssl_verify** | Toggles server certificate verification if `cassandra_ssl` is enabled. See the `lua_ssl_trusted_certificate` setting to specify a certificate authority. | `off`
**cassandra_username** | Username when using the `PasswordAuthenticator` scheme. | `kong`
**cassandra_password** | Password when using the `PasswordAuthenticator` scheme. | none
**cassandra_lb_policy** | Load balancing policy to use when distributing queries across your Cassandra cluster. Accepted values are: `RoundRobin`, `RequestRoundRobin`, `DCAwareRoundRobin`, and `RequestDCAwareRoundRobin`. Policies prefixed with "Request" make efficient use of established connections throughout the same request. Prefer "DCAware" policies if and only if you are using a multi-datacenter cluster. | `RequestRoundRobin`
**cassandra_local_datacenter** | When using the `DCAwareRoundRobin` or `RequestDCAwareRoundRobin` load balancing policy, you must specify the name of the local (closest) datacenter for this Kong node. | none
**cassandra_repl_strategy** | When migrating for the first time, Kong will use this setting to create your keyspace. Accepted values are `SimpleStrategy` and `NetworkTopologyStrategy`. | `SimpleStrategy`
**cassandra_repl_factor** | When migrating for the first time, Kong will create the keyspace with this replication factor when using the `SimpleStrategy`. | `1`
**cassandra_data_centers** | When migrating for the first time, will use this setting when using the `NetworkTopologyStrategy`. The format is a comma-separated list made of `<dc_name>:<repl_factor>`. | `dc1:2,dc2:3`
**cassandra_schema_consensus_timeout** | Defines the timeout (in ms) for the waiting period to reach a schema consensus between your Cassandra nodes. This value is only used during migrations. | `10000`

### Datastore Cache section

In order to avoid unnecessary communication with the datastore, Kong caches
entities (such as APIs, Consumers, Credentials...) for a configurable period of
time. It also handles invalidations if such an entity is updated.

This section allows for configuring the behavior of Kong regarding the caching
of such configuration entities.

---

#### db_update_frequency

Frequency (in seconds) at which to check for updated entities with the
datastore.

When a node creates, updates, or deletes an entity via the Admin API, other
nodes need to wait for the next poll (configured by this value) to eventually
purge the old cached entity and start using the new one.

Default: `5`

---

#### db_update_propagation

Time (in seconds) taken for an entity in the datastore to be propagated to
replica nodes of another datacenter.

When in a distributed environment such as a multi-datacenter Cassandra cluster,
this value should be the maximum number of seconds taken by Cassandra to
propagate a row to other datacenters.

When set, this property will increase the time taken by Kong to propagate the
change of an entity.

Single-datacenter setups or PostgreSQL servers should suffer no such delays,
and this value can be safely set to 0.

Default: `0`

---

#### db_cache_ttl

Time-to-live (in seconds) of an entity from the datastore when cached by this
node.

Database misses (no entity) are also cached according to this setting.

If set to 0 (default), such cached entities or misses never expire.

Default: `0`

---

#### db_resurrect_ttl

Time (in seconds) for which stale entities from the datastore should be
resurrected for when they cannot be refreshed (e.g., the datastore is
unreachable). When this TTL expires, a new attempt to refresh the stale entities
will be made.

Default: `30`

---


### DNS Resolver section

By default the DNS resolver will use the standard configuration files
`/etc/hosts` and `/etc/resolv.conf`. The settings in the latter file will be
overridden by the environment variables `LOCALDOMAIN` and `RES_OPTIONS` if they
have been set.

Kong will resolve hostnames as either `SRV` or `A` records (in that order, and
`CNAME` records will be dereferenced in the process).

In case a name was resolved as an `SRV` record it will also override any given
port number by the `port` field contents received from the DNS server.

The DNS options `SEARCH` and `NDOTS` (from the `/etc/resolv.conf` file) will be
used to expand short names to fully qualified ones. So it will first try the
entire `SEARCH` list for the `SRV` type, if that fails it will try the `SEARCH`
list for `A`, etc.

For the duration of the `ttl`, the internal DNS resolver will loadbalance each
request it gets over the entries in the DNS record. For `SRV` records the
`weight` fields will be honored, but it will only use the lowest `priority`
field entries in the record.

---

#### dns_resolver

Comma separated list of nameservers, each entry in `ip[:port]` format to be
used by Kong. If not specified the nameservers in the local `resolv.conf` file
will be used.

Port defaults to 53 if omitted. Accepts both IPv4 and IPv6 addresses.

Default: none

---

#### dns_hostsfile

The hosts file to use. This file is read once and its content is static in
memory.

To read the file again after modifying it, Kong must be reloaded.

Default: `/etc/hosts`

---

#### dns_order

The order in which to resolve different record types. The `LAST` type means the
type of the last successful lookup (for the specified name). The format is a
(case insensitive) comma separated list.

Default: `LAST,SRV,A,CNAME`

---

#### dns_valid_ttl

By default, DNS records are cached using the TTL value of a response. If this
property receives a value (in seconds), it will override the TTL for all
records.

Default: none

---

#### dns_stale_ttl

Defines, in seconds, how long a record will remain in cache past its TTL. This
value will be used while the new DNS record is fetched in the background.

Stale data will be used from expiry of a record until either the refresh query
completes, or the `dns_stale_ttl` number of seconds have passed.

Default: `4`

---

#### dns_not_found_ttl

TTL in seconds for empty DNS responses and "(3) name error" responses.

Default: `30`

---

#### dns_error_ttl

TTL in seconds for error responses.

Default: `1`

---

#### dns_no_sync

If enabled, then upon a cache-miss every request will trigger its own dns
query.

When disabled multiple requests for the same name/type will be synchronised to
a single query.

Default: `off`

---


### Development & Miscellaneous section

Additional settings inherited from lua-nginx-module allowing for more
flexibility and advanced usage.

See the lua-nginx-module documentation for more information:
https://github.com/openresty/lua-nginx-module

---

#### lua_ssl_trusted_certificate

Absolute path to the certificate authority file for Lua cosockets in PEM
format. This certificate will be the one used for verifying Kong's database
connections, when `pg_ssl_verify` or `cassandra_ssl_verify` are enabled.

See https://github.com/openresty/lua-nginx-module#lua_ssl_trusted_certificate

Default: none

---

#### lua_ssl_verify_depth

Sets the verification depth in the server certificates chain used by Lua
cosockets, set by `lua_ssl_trusted_certificate`.

This includes the certificates configured for Kong's database connections.

See https://github.com/openresty/lua-nginx-module#lua_ssl_verify_depth

Default: `1`

---

#### lua_package_path

Sets the Lua module search path (LUA_PATH). Useful when developing or using
custom plugins not stored in the default search path.

See https://github.com/openresty/lua-nginx-module#lua_package_path

Default: `./?.lua;./?/init.lua;`

---

#### lua_package_cpath

Sets the Lua C module search path (LUA_CPATH).

See https://github.com/openresty/lua-nginx-module#lua_package_cpath

Default: none

---

#### lua_socket_pool_size

Specifies the size limit for every cosocket connection pool associated with
every remote server.

See https://github.com/openresty/lua-nginx-module#lua_socket_pool_size

Default: `30`

---


### Additional Configuration

#### origins

The origins configuration can be useful in complex networking configurations,
and is typically required when Kong is used in a service mesh.

`origins` is a comma-separated list of pairs of origins, with each half of the
pair separated by an `=` symbol. The origin on the left of each pair is
overridden by the origin on the right. This override occurs after the access
phase, and before upstream resolution. It has the effect of causing Kong to
send traffic that would have gone to the left origin to the right origin instead.

The term origin (singular) refers to a particular scheme/host or IP address/port
triple, as described in RFC 6454 (https://tools.ietf.org/html/rfc6454#section-3.2).
In Kong's `origins` configuration, the scheme *must* be one of `http`, `https`,
`tcp`, or `tls`. In each pair of origins, the scheme *must* be of similar type -
thus `http` can pair with `https`, and `tcp` can pair with `tls`, but `http` and
`https` cannot pair with `tcp` and `tls`.

When an encrypted scheme like `tls` or `https` in the left origin is paired with
an unencrypted scheme like `tcp` or `http` in the right origin, Kong will
terminate TLS on incoming connections matching the left origin, and will then
route traffic unencrypted to the specified right origin. This is useful when
connections will be made to the Kong node over TLS, but the local service (for
which Kong is proxying traffic) doesn't or can't terminate TLS. Similarly, if
the left origin is `tcp` or `http` and the right origin is `tls` or `https`,
Kong will accept unencrypted incoming traffic, and will then wrap that traffic
in TLS as it is routed outbound. This capability is an important enabler of Kong Mesh.

Like all Kong configuration settings, the `origins` setting *can* be declared in
the `Kong.conf` file - however **it is recommended that Kong administrators
avoid doing so**. Instead, `origins` should be set on a per-node basis using
[environment variables](https://docs.konghq.com/{{page.kong_version}}/configuration/#environment-variables).
As such, `origins` is not present in [`kong.conf.default`](https://github.com/Kong/kong/blob/0.15.0/kong.conf.default).

In Kubernetes deployments, it is recommended that `origins` not be configured
and maintained "by hand" - instead, `origins` for each Kong node should be
managed by the Kubernetes Identity Module (KIM).

Default: none

##### Examples

If a given Kong node has the following configuration for `origins`:

```
http://upstream-foo-bar:1234=http://localhost:5678
```

That Kong node will not attempt to resolve `upstream-foo-bar` - instead, that
Kong node will route traffic to `localhost:5678`. In a service mesh deployment
of Kong, this override would be necessary to cause a Kong sidecar adjacent to
an instance of the `upstream-foo-bar` application to route traffic to that
local instance, rather than trying to route traffic back across the network to
a non-local instance of `upstream-foo-bar`.

---

In another typical sidecar deployment, in which the Kong node is deployed on
the same host, virtual machine, or Kubernetes Pod as one instance of a service
for which Kong is acting as a proxy, `origins` would be configured like:

```
https://service-b:9876=http://localhost:5432
```

This arrangement would cause this Kong node to accept _only_ HTTPS connections
on port 9876, terminate TLS, then forward the now-unencrypted traffic to
localhost port 5432.

---

Following is an example consisting of two pairs, demonstrating the correct use
of the `,` separator with no space:

```
https://foo.bar.com:443=http://localhost:80,tls://dog.cat.org:9999=tcp://localhost:8888
```

This configuration would result in Kong accepting _only_ HTTPS traffic on port
443, and _only_ TLS traffic on port 9999, terminating TLS in both cases, then
forwarding the traffic to localhost ports 80 and 8888 respectively. Assuming
that the localhost ports 80 and 8888 are each associated with a separate
service, this configuration could occur when Kong is acting as a node proxy,
which is a local proxy that is acting on behalf of multiple services (which
differs from a sidecar proxy, in which a local proxy acts on behalf of only a
_single_ local service).


[Penlight]: http://stevedonovan.github.io/Penlight/api/index.html
[pl.template]: http://stevedonovan.github.io/Penlight/api/libraries/pl.template.html
