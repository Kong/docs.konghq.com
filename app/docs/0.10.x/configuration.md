---
title: Configuration Reference
---

# Configuration Reference

### Table of Contents

- [Configuration loading](#configuration-loading)
- [Verifying your configuration](#verifying-your-configuration)
- [Environment variables](#environment-variables)
- [Custom Nginx configuration & embedding Kong](#custom-nginx-configuration-embedding-kong)
  - [Custom Nginx configuration](#custom-nginx-configuration)
  - [Embedding Kong](#embedding-kong)
- [Properties reference](#properties-reference)
  - [General section](#general-section)
  - [Nginx section](#nginx-section)
  - [Datastore section](#datastore-section)
  - [Clustering section](#clustering-section)
  - [DNS resolver section](#dns-resolver-section)
  - [Development & miscellaneous section](#development-miscellaneous-section)

### Configuration loading

Kong comes with a default configuration file that can be found at
`/etc/kong/kong.conf.default` if you installed Kong via one of the official
packages. To start configuring Kong, you can copy this file:

```
$ cp /etc/kong/kong.conf.default /etc/kong/kong.conf
```

Kong will operate with default settings should all the values in your
configuration be commented-out. Upon starting, Kong looks for several
default locations that might contain a configuration file:

```
/etc/kong/kong.conf
/etc/kong.conf
```

You can override this behavior by specifying a custom path for your
configuration file using the `-c / --conf` argument in the CLI:

```
$ kong start --conf /path/to/kong.conf
```

The configuration format is straightforward: simply uncomment any property
(comments are defined by the `#` character) and modify it to your needs.
Booleans values can be specified as `on/off` or `true`/`false` for convenience.

[Back to TOC](#table-of-contents)

### Verifying your configuration

You can verify the integrity of your settings with the `check` command:

```
$ kong check <path/to/kong.conf>
configuration at <path/to/kong.conf> is valid
```

This command will take into account the environment variables you have
currently set, and will error out in case your settings are invalid.

Additionally, you can also use the CLI in debug mode to have more insight
as to what properties Kong is being started with:

```
$ kong start -c <kong.conf> --vv
2016/08/11 14:53:36 [verbose] no config file found at /etc/kong.conf
2016/08/11 14:53:36 [verbose] no config file found at /etc/kong/kong.conf
2016/08/11 14:53:36 [debug] admin_listen = "0.0.0.0:8001"
2016/08/11 14:53:36 [debug] cluster_listen = "0.0.0.0:7946"
2016/08/11 14:53:36 [debug] cluster_listen_rpc = "127.0.0.1:7373"
2016/08/11 14:53:36 [debug] cluster_profile = "wan"
2016/08/11 14:53:36 [debug] cluster_ttl_on_failure = 3600
2016/08/11 14:53:36 [debug] database = "postgres"
2016/08/11 14:53:36 [debug] log_level = "notice"
[...]
```

[Back to TOC](#table-of-contents)

### Environment variables

When loading properties out of a configuration file, Kong will also look for
environment variables of the same name. This allows you to fully configure Kong
via environment variables, which is very convenient for container-based
infrastructures, for example.

All environment variables prefixed with `KONG_`, capitalized and bearing the
same name as a setting will override it.

Example:

```
log_level = debug # in kong.conf
```

Can be overridden with:

```
$ export KONG_LOG_LEVEL=error
```

[Back to TOC](#table-of-contents)

### Custom Nginx configuration & embedding Kong

Tweaking the Nginx configuration is an essential part of setting up your Kong
instances since it allows you to optimize its performance for your
infrastructure, or embed Kong in an already running OpenResty instance.

#### Custom Nginx configuration

Kong can be started, reloaded and restarted with an `--nginx-conf` argument,
which must specify an Nginx configuration template. Such a template uses the
[Penlight][Penlight] [templating engine][pl.template], which is compiled using
the given Kong configuration, before being dumped in your Kong prefix
directory, moments before starting Nginx.

The default template can be found at:
https://github.com/Mashape/kong/tree/master/kong/templates.  It is split in
two Nginx configuration files: `nginx.lua` and `nginx_kong.lua`. The former is
minimalistic and includes the later, which contains everything Kong requires to
run. Moments before starting Nginx, those two files are copied into the prefix
directory, which looks like so:

```
/usr/local/kong
├── nginx-kong.conf
├── nginx.conf
```

If you wish to include other `server` blocks in your Nginx configuration, or if
you must tweak global settings that are not exposed by the Kong configuration,
here is a suggestion:

```
# ---------------------
# custom_nginx.template
# ---------------------

worker_processes ${{ "{{NGINX_WORKER_PROCESSES" }}}}; # can be set by kong.conf
daemon ${{ "{{NGINX_DAEMON" }}}};                     # can be set by kong.conf

pid pids/nginx.pid;                      # this setting is mandatory
error_log logs/error.log ${{ "{{LOG_LEVEL" }}}}; # can be set by kong.conf

events {
    use epoll; # custom setting
    multi_accept on;
}

http {
    # include default Kong Nginx config
    include 'nginx-kong.conf';

    # custom server
    server {
        listen 8888;
        server_name custom_server;

        location / {
          ... # etc
        }
    }
}
```

You can then start Kong with:

```
$ kong start -c kong.conf --nginx-conf custom_nginx.template
```

If you wish to customize the Kong Nginx sub-configuration file to, eventually,
add other Lua handlers or customize the `lua_*` directives, you can inline the
`nginx_kong.lua` configuration in this `custom_nginx.template` example file:

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
  resolver ${{ "{{DNS_RESOLVER" }}}} ipv6=off;
  charset UTF-8;
  error_log logs/error.log ${{ "{{LOG_LEVEL" }}}};
  access_log logs/access.log;

  ... # etc
}
```

[Back to TOC](#table-of-contents)

#### Embed Kong in OpenResty

If you are running your own OpenResty servers, you can also easily embed Kong
by including the Kong Nginx sub-configuration using the `include` directive
(similar to the examples of the previous section). However, you will need the
final configuration and not the template. For this, use the `compile` command,
which outputs a fully-compiled Nginx sub-configuration to `stdout`:

```
$ bin/kong compile --conf kong.conf > /usr/local/openresty/conf/nginx-kong.conf

# now start OpenResty with a configuration that "includes" nginx-kong.conf
$ nginx -c /usr/local/openresty/conf/nginx.conf
```

<div class="alert alert-warning">
  <strong>Note:</strong> When embedding Kong this way, you will have to
  ensure the required third-party services are already running and configured
  correctly according to the kong.conf used to compile the Nginx
  sub-configuration. This includes the database, and serf.
</div>

[Back to TOC](#table-of-contents)

### Properties reference

#### General section

##### **prefix**

Working directory. Equivalent to Nginx's prefix path, containing temporary files
and logs. Each Kong process must have a separate working directory.

Default: `/usr/local/kong`

---

##### **log_level**

Log level of the Nginx server. Logs can be found at `<prefix>/logs/error.log`

See http://nginx.org/en/docs/ngx_core_module.html#error_log for a list of
accepted values.

Default: `notice`

---

##### **proxy_access_log**

Path for proxy port request access logs. Set this value to `off` to disable
logging proxy requests. If this value is a relative path, it will be placed
under the `prefix` location.

Default: `logs/access.log`

---

##### **proxy_error_log**

Path for proxy port request error logs. Granularity of these logs is adjusted
by the `log_level` directive.

Default: `logs/error.log`

---

##### **admin_access_log**

Path for Admin API request access logs. Set this value to `off` to disable
logging Admin API requests. If this value is a relative path, it will be placed
under the `prefix` location.

Default: `logs/admin_access.log`

---

##### **admin_error_log**

Path for Admin API request error logs. Granularity of these logs is adjusted by
the `log_level` directive.

Default: `logs/error.log`

---

##### **custom_plugins**

Comma-separated list of additional plugins this node should load. Use this
property to load custom plugins that are not bundled with Kong. Plugins will
be loaded from the `kong.plugins.{name}.*` namespace.

Default: none

Example: `my-plugin,hello-world,custom-rate-limiting`

---

##### **anonymous_reports**

Send anonymous usage data such as error stack traces to help improve Kong.

Default: `on`

[Back to TOC](#table-of-contents)

---

#### Nginx section

##### **proxy_listen**

Address and port on which Kong will accept HTTP requests. This is the
public-facing entrypoint of Kong, to which your consumers will make
requests to.

See http://nginx.org/en/docs/http/ngx_http_core_module.html#listen for
a description of the accepted formats for this and other `*_listen` values.

Default: `0.0.0.0:8000`

Example: `0.0.0.0:80`

---

##### **proxy_listen_ssl**

Address and port on which Kong will accept HTTPS requests if `ssl` is enabled.

Default: `0.0.0.0:8443`

Example: `0.0.0.0:443`

---

##### **admin_listen**

Address and port on which Kong will expose an entrypoint to the Admin API.
This API lets you configure and manage Kong, and should be kept private
and secured.

Default: `0.0.0.0:8001`

Example: `127.0.0.1:8001`

---

##### **admin_listen_ssl**

Address and port on which Kong will accept HTTPS requests to the Admin API if
`admin_ssl` is enabled.

Default: `0.0.0.0:8444`

Example: `127.0.0.1:8444`

---

##### **nginx_worker_processes**

Determines the number of worker processes spawned by Nginx.
See http://nginx.org/en/docs/ngx_core_module.html#worker_processes for detailed
usage of this directive and a description of accepted values.

Default: `auto`

---

##### **nginx_daemon**

Determines whether Nginx will run as a daemon or as a foreground process.
Mainly useful for development or when running Kong inside a Docker environment.

See http://nginx.org/en/docs/ngx_core_module.html#daemon.

Default: `on`

---

##### **mem_cache_size**

Size of the in-memory cache for database entities. The accepted units are `k` and
`m`, with a minimum recommended value of a few MBs.

Default: `128m`

---

##### **ssl**

Determines if Nginx should be listening for HTTPS traffic on the
`proxy_listen_ssl` address. If disabled, Nginx will only bind itself
on `proxy_listen`, and all SSL settings will be ignored.

Default: `on`

---

##### **ssl_cert**

If `ssl` is enabled, the absolute path to the SSL certificate for the
`proxy_listen_ssl` address. If none is specified and `ssl` is enabled, Kong will
generate a default certificate and key.

Default: none

---

##### **ssl_cert_key**

If `ssl` is enabled, the absolute path to the SSL key for the
`proxy_listen_ssl` address.

Default: none

---

##### **client_ssl**

Determines if Nginx should send client-side SSL certificates when proxying
requests.

Default: `off`

---

##### **client_ssl_cert**

If `client_ssl` is enabled, the absolute path to the client SSL certificate for
the `proxy_ssl_certificate` directive. Note that this value is statically
defined on the node, and currently cannot be configured on a per-API basis.

Default: none

---

##### **client_ssl_cert_key**

If `client_ssl` is enabled, the absolute path to the client SSL key for the
`proxy_ssl_certificate_key` address. Note this value is statically defined on
the node, and currently cannot be configured on a per-API basis.

Default: none

---

##### **admin_ssl**

Determines if Nginx should be listening for HTTPS traffic on the
`admin_listen_ssl` address. If disabled, Nginx will only bind itself on
`admin_listen`, and all SSL settings will be ignored.

Default: `on`

---

##### **admin_ssl_cert**

If `admin_ssl` is enabled, the absolute path to the SSL certificate for the
`admin_listen_ssl` address. If none is specified and `admin_ssl` is enabled,
Kong will generate a default certificate and key.

Default: none

---

##### **admin_ssl_cert_key**

If `admin_ssl` is enabled, the absolute path to the SSL key for the
`admin_listen_ssl` address.

Default: none

---

##### **upstream_keepalive**

Sets the maximum number of idle keepalive connections to upstream servers that
are preserved in the cache of each worker process. When this number is
exceeded, the least recently used connections are closed.

Default: `60`

---

##### **server_tokens**

Enables or disables emitting Kong version on error pages and in the `Server`
or `Via` (in case the request was proxied) response header field.

Default: `on`

---

##### **latency_tokens**

Enables or disables emitting Kong latency information in the `X-Kong-Proxy-Latency` 
and `X-Kong-Upstream-Latency` response header fields.

Default: `on`

[Back to TOC](#table-of-contents)

---

#### Datastore section

Kong will store all of its data (such as APIs, Consumers and Plugins) in
either Cassandra or PostgreSQL.

All Kong nodes belonging to the same cluster must connect themselves to the
same database.

---

##### **database**

Determines which of PostgreSQL or Cassandra this node will use as its
datastore. Accepted values are `postgres` and `cassandra`.

Default: `postgres`

---

##### **Postgres settings**

name                  |  description
----------------------|-------------------
**pg_host**           | Host of the Postgres server
**pg_port**           | Port of the Postgres server
**pg_user**           | Postgres user
**pg_password**       | Postgres user's password
**pg_database**       | Database to connect to. **must exist**
**pg_ssl**            | Enable SSL connections to the server
**pg_ssl_verify**     | If `pg_ssl` is enabled, toggle server certificate verification. See `lua_ssl_trusted_certificate` setting.

---

##### **Cassandra settings**

name                            | description
--------------------------------|------------------
**cassandra_contact_points**    | Comma-separated list of contacts points to your cluster.
**cassandra_port**              | Port on which your nodes are listening.
**cassandra_keyspace**          | Keyspace to use in your cluster. Will be created if doesn't exist.
**cassandra_consistency**       | Consistency setting to use when reading/writing.
**cassandra_timeout**           | Timeout (in ms) for reading/writing.
**cassandra_ssl**               | Enable SSL connections to the nodes.
**cassandra_ssl_verify**        | If `cassandra_ssl` is enabled, toggle server certificate verification. See `lua_ssl_trusted_certificate` setting.
**cassandra_username**          | Username when using the PasswordAuthenticator scheme.
**cassandra_password**          | Password when using the PasswordAuthenticator scheme.
**cassandra_consistency**       | Consistency setting to use when reading/writing to the Cassandra cluster.
**cassandra_lb_policy**         | Load balancing policy to use when distributing queries across your Cassandra cluster. Accepted values are `RoundRobin` and `DCAwareRoundRobin`. Prefer the later if and only if you are using a multi-datacenter cluster, and set the `cassandra_local_datacenter` if so.
**cassandra_local_datacenter**  | When using the `DCAwareRoundRobin` policy, you must specify the name of the cluster local (closest) to this Kong node.
**cassandra_repl_strategy**     | If creating the keyspace for the first time, specify a replication strategy.
**cassandra_repl_factor**       | Specify a replication factor for the `SimpleStrategy`.
**cassandra_data_centers**      | Specify data centers for the `NetworkTopologyStrategy`.
**cassandra_schema_consensus_timeout** | Define the timeout (in ms) for the waiting period to each a schema consensus between your Cassandra nodes. This value is only used during migrations.

[Back to TOC](#table-of-contents)

---

#### Clustering section

In addition to pointing to the same database, each Kong node must join the
same cluster.

Kong's clustering works on the IP layer (hostnames are not supported, only
IPs) and expects a flat network topology without any NAT between the
datacenters.

A common pattern is to create a VPN between the two datacenters such that
the flat network assumption is not violated.

See the clustering reference for more informations:
https://getkong.org/docs/latest/clustering/

---

##### **cluster_listen**

Address and port used to communicate with other nodes in the cluster.
All other Kong nodes in the same cluster must be able to communicate over both
TCP and UDP on this address. Only IPv4 addresses are supported.

Default: `0.0.0.0:7946`

---

##### **cluster_listen_rpc**

Address and port used to communicate with the cluster through the agent
running on this node. Only contains TCP traffic local to this node.

Default: `127.0.0.1:7373`

---

##### **cluster_advertise**

By default, the `cluster_listen` address is advertised over the cluster.
If the `cluster_listen` host is '0.0.0.0', then the first local, non-loopback
IPv4 address will be advertised to other nodes.
However, in some cases (specifically NAT traversal), there may be a routable
address that cannot be bound to. This flag enables advertising a different
address to support this.

Default: none

---

##### **cluster_encrypt_key**

Base64-encoded 16-bytes key to encrypt cluster traffic with.

Default: none

---

##### **cluster_keyring_file**

Specifies a file to load keyring data from.
Kong is able to keep encryption keys in sync
and perform key rotations. During a key
rotation, there may be some period of time in
which Kong is required to maintain more than
one encryption key until all members have
received the new key.

Default: none

---

##### **cluster_ttl_on_failure**

Time to live (in seconds) of a node in the cluster when it stops sending
healthcheck pings, possibly caused by a node or network failure.
If a node is not able to send a new healthcheck ping before the expiration,
other nodes in the cluster will stop attempting to connect to it.

Recommended to be at least `60`.

Default: `3600`

---

##### **cluster_profile**

The timing profile for inter-cluster pings and timeouts. If a `lan` or `local`
profile is used over the Internet, a high rate of failures is risked as the
timing constraints would be too tight.

Accepted values are `local`, `lan`, `wan`.

Default: `wan`

[Back to TOC](#table-of-contents)

---

#### DNS resolver section

Kong will resolve hostnames as either `SRV` or `A` records (in that order, and
`CNAME` records will be dereferenced in the process).
In case a name was resolved as an `SRV` record it will also override any given
port number by the `port` field contents received from the dns server.

For the duration of the `ttl`, the internal dns resolver will loadbalance each
request it gets over the entries in the dns record. For `SRV` records the
`weight` fields will be honored, but it will only use the lowest `priority`
field entries in the record.

---

##### **dns_resolver**

Comma separated list of nameservers, each
entry in `ipv4[:port]` format to be used by
Kong. If not specified the nameservers in
the local `resolv.conf` file will be used.
Port defaults to 53 if omitted.

Default: none

---

##### **dns_hostsfile**

The hosts file to use. This file is read once and its content is static
in memory. To read the file again after modifying it, Kong must be reloaded.

Default: `/etc/hosts`

[Back to TOC](#table-of-contents)

---

#### Development & miscellaneous section

Additional settings inherited from lua-nginx-module allowing for more
flexibility and advanced usage.

See the lua-nginx-module documentation for more informations:
https://github.com/openresty/lua-nginx-module

---

##### **lua_ssl_trusted_certificate**

Absolute path to the certificate authority file for Lua cosockets in PEM
format. This certificate will be the one used for verifying Kong's database
connections, when `pg_ssl_verify` or `cassandra_ssl_verify` are enabled.

See https://github.com/openresty/lua-nginx-module#lua_ssl_trusted_certificate

Default: none

---

##### **lua_ssl_verify_depth**

Sets the verification depth in the server certificates chain used by Lua
cosockets, set by `lua_ssl_trusted_certificate`.

This includes the certificates configured for Kong's database connections.

See https://github.com/openresty/lua-nginx-module#lua_ssl_verify_depth

Default: `1`

---

##### **lua_code_cache**

When disabled, every request will run in a separate Lua VM instance: all Lua
modules will be loaded from scratch. Useful for adopting an edit-and-refresh
approach while developing a plugin.

Turning this directive off has a severe impact on performance.

See https://github.com/openresty/lua-nginx-module#lua_code_cache

Default: `on`

---

##### **lua_package_path**

Sets the Lua module search path (LUA_PATH). Useful when developing or using
custom plugins not stored in the default search path.

See https://github.com/openresty/lua-nginx-module#lua_package_path

Default: none

---

##### **lua_package_cpath**

Sets the Lua C module search path (LUA_CPATH).

See https://github.com/openresty/lua-nginx-module#lua_package_cpath

Default: none

---

##### **lua_socket_pool_size**

Specifies the size limit for every cosocket connection pool associated with
every remote server.

See https://github.com/openresty/lua-nginx-module#lua_socket_pool_size

Default: `30`

[Back to TOC](#table-of-contents)

[Penlight]: http://stevedonovan.github.io/Penlight/api/index.html
[pl.template]: http://stevedonovan.github.io/Penlight/api/libraries/pl.template.html
