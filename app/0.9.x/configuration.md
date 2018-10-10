---
title: Configuration Reference
---

# Configuration Reference

## Configuration loading

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

## Verifying your configuration

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
2016/08/11 14:53:36 [debug] dnsmasq = true
2016/08/11 14:53:36 [debug] dnsmasq_port = 8053
2016/08/11 14:53:36 [debug] log_level = "notice"
[...]
```

[Back to TOC](#table-of-contents)

## Environment variables

When loading properties out of a configuration file, Kong will also look for
environment variables of the same name. This allows you to fully configure Kong
via environment variables, which is very convenient for container-based
infrastructures, for example.

All environment variables prefixed with `KONG_`, capitalized and bearing the same
name as a setting will override it.

Example:

```
log_level = debug # in kong.conf
```

Can be overriden with:

```
$ export KONG_LOG_LEVEL=error
```

[Back to TOC](#table-of-contents)

## Custom Nginx configuration & embedding Kong

Tweaking the Nginx configuration is an essential part of setting up your Kong
instances since it allows you to optimize its performance for your
infrastructure, or embed Kong in an already running OpenResty instance.

### Custom Nginx configuration

Kong can be started, reloaded and restarted with an `--nginx-conf` argument,
which must specify an Nginx configuration template. Such a template uses the
[Penlight][Penlight] [templating engine][pl.template], which is compiled using
the given Kong configuration, before being dumped in your Kong prefix
directory, moments before starting Nginx.

The default template can be found at: https://github.com/Kong/kong/tree/master/kong/templates.
It is splitted in two Nginx configuration files: `nginx.lua` and
`nginx_kong.lua`. The former is minimalistic and includes the later, which
contains everything Kong requires to run. Moments before starting Nginx, those
two files are copied into the prefix directory, which looks like so:

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
        server_name custom_server;
        listen 8888;
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

### Embed Kong in OpenResty

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
  sub-configuration. This include the database, serf, and dnsmasq if enabled.
</div>

[Back to TOC](#table-of-contents)

## Properties reference

### General section

#### prefix

Working directory. Equivalent to Nginx's prefix path, containing temporary files
and logs. Each Kong process must have a separate working directory.

Default: `/usr/local/kong`

---

#### log_level

Log level of the Nginx server. Logs can be found at `<prefix>/logs/error.log`

See http://nginx.org/en/docs/ngx_core_module.html#error_log for a list of
accepted values.

Default: `notice`

---

#### custom_plugins

Comma-separated list of additional plugins this node should load. Use this
property to load custom plugins that are not bundled with Kong. Plugins will
be loaded from the `kong.plugins.{name}.*` namespace.

Default: none

Example: `my-plugin,hello-world,custom-rate-limiting`

---

#### anonymous_reports

Send anonymous usage data such as error stack traces to help improve Kong.

Default: `on`

[Back to TOC](#table-of-contents)

---

### Nginx section

#### proxy_listen

Address and port on which Kong will accept HTTP requests. This is the
public-facing entrypoint of Kong, to which your consumers will make
requests to.

See http://nginx.org/en/docs/http/ngx_http_core_module.html#listen for
a description of the accepted formats for this and other `*_listen` values.

Default: `0.0.0.0:8000`

Example: `0.0.0.0:80`

---

#### proxy_listen_ssl

Address and port on which Kong will accept HTTPS requests if `ssl` is enabled.

Default: `0.0.0.0:8443`

Example: `0.0.0.0:443`

---

#### admin_listen

Address and port on which Kong will expose an entrypoint to the Admin API.
This API lets you configure and manage Kong, and should be kept private
and secured.

Default: `0.0.0.0:8001`

Example: `127.0.0.1:8001`

---

#### admin_listen_ssl

Address and port on which Kong will accept HTTPS requests to the Admin API if `admin_ssl` is enabled.

Default: `0.0.0.0:8444`

Example: `127.0.0.1:8444`

---

#### nginx_worker_processes

Determines the number of worker processes spawned by Nginx.
See http://nginx.org/en/docs/ngx_core_module.html#worker_processes for detailed
usage of this directive and a description of accepted values.

Default: `auto`

---

#### nginx_daemon

Determines wether Nginx will run as a daemon or as a foreground process.
Mainly useful for development or when running Kong inside a Docker environment.

See http://nginx.org/en/docs/ngx_core_module.html#daemon.

Default: `on`

---

#### mem_cache_size

Size of the in-memory cache for database entities. The accepted units are `k` and
`m`, with a minimum recommended value of a few MBs.

Default: `128m`

---

#### ssl

Determines if Nginx should be listening for HTTPS traffic on the
`proxy_listen_ssl` address. If disabled, Nginx will only bind itself
on `proxy_listen`, and all SSL settings will be ignored.

Default: `on`

---

#### ssl_cert

If `ssl` is enabled, the absolute path to the SSL certificate for the
`proxy_listen_ssl` address. If none is specified and `ssl` is enabled, Kong will
generate a default certificate and key.

Default: none

---

#### ssl_cert_key

If `ssl` is enabled, the absolute path to the SSL key for the
`proxy_listen_ssl` address.

Default: none

---

#### admin_ssl

Determines if Nginx should be listening for HTTPS traffic on the `admin_listen_ssl`
address. If disabled, Nginx will only bind itself on `admin_listen`, and all SSL 
settings will be ignored.

Default: `on`

---

#### admin_ssl_cert

If `admin_ssl` is enabled, the absolute path to the SSL certificate for the
`admin_listen_ssl` address. If none is specified and `admin_ssl` is enabled, Kong will
generate a default certificate and key.

Default: none

---

#### admin_ssl_cert_key

If `admin_ssl` is enabled, the absolute path to the SSL key for the
`admin_listen_ssl` address.

Default: none

[Back to TOC](#table-of-contents)

---

### Datastore section

Kong will store all of its data (such as APIs, consumers and plugins) in
either Cassandra or PostgreSQL.

All Kong nodes belonging to the same cluster must connect themselves to the
same database.

---

#### database

Determines which of PostgreSQL or Cassandra this node will use as its
datastore. Accepted values are `postgres` and `cassandra`.

Default: `postgres`

---

#### Postgres settings

name                  |  description
----------------------|-------------------
**pg_host**           | Host of the Postgres server
**pg_port**           | Port of the Postgres server
**pg_user**           | Postgres user
**pg_password**       | Postgres user's password
**pg_database**       | Database to connect to. **must exist**
**pg_ssl**            | Enable SSL connections to the server
**pg_ssl_verify**     | If pg_ssl is enabled, toggle server certificate verification. See `lua_ssl_trusted_certificate` setting.

---

#### Cassandra settings

name                            | description
--------------------------------|------------------
**cassandra_contact_points**    | Comma-separated list of contacts points to your cluster
**cassandra_port**              | Port on which your nodes are listening.
**cassandra_keyspace**          | Keyspace to use in your cluster. Will be created if doesn't exist.
**cassandra_consistency**       | Consistency setting to use when reading/writing
**cassandra_timeout**           | Timeout (in ms) for reading/writing
**cassandra_ssl**               | Enable SSL connections to the nodes
**cassandra_ssl_verify**        | If cassandra_ssl is enabled, toggle server certificate verification. See `lua_ssl_trusted_certificate` setting.
**cassandra_username**          | Username when using the PasswordAuthenticator scheme
**cassandra_password**          | Password when using the PasswordAuthenticator scheme
**cassandra_repl_strategy**     | If creating the keyspace for the first time, specify a replication strategy.
**cassandra_repl_factor**       | Specify a replication factor for the SimpleStrategy
**cassandra_data_centers**      | Specify data centers for the NetworkTopologyStrategy

[Back to TOC](#table-of-contents)

---

### Clustering section

In addition to pointing to the same database, each Kong node must join the
same cluster.

Kong's clustering works on the IP layer (hostnames are not supported, only
IPs) and expects a flat network topology without any NAT between the
datacenters.

A common pattern is to create a VPN between the two datacenters such that
the flat network assumption is not violated.

See the clustering reference for more informations:
https://docs.konghq.com/latest/clustering/

---

#### cluster_listen

Address and port used to communicate with other nodes in the cluster.
All other Kong nodes in the same cluster must be able to communicate over both
TCP and UDP on this address. Only IPv4 addresses are supported.

Default: `0.0.0.0:7946`

---

#### cluster_listen_rpc

Address and port used to communicate with the cluster through the agent
running on this node. Only contains TCP traffic local to this node.

Default: `127.0.0.1:7373`

---

#### cluster_advertise

By default, the `cluster_listen` address is advertised over the cluster.
If the `cluster_listen` host is '0.0.0.0', then the first local, non-loopback
IPv4 address will be advertised to other nodes.
However, in some cases (specifically NAT traversal), there may be a routable
address that cannot be bound to. This flag enables advertising a different
address to support this.

Default: none

---

#### cluster_encrypt_key

Base64-encoded 16-bytes key to encrypt cluster traffic with.

Default: none

---

#### cluster_ttl_on_failure

Time to live (in seconds) of a node in the cluster when it stops sending
healthcheck pings, possibly caused by a node or network failure.
If a node is not able to send a new healthcheck ping before the expiration,
other nodes in the cluster will stop attempting to connect to it.

Recommended to be at least `60`.

Default: `3600`

---

#### cluster_profile

The timing profile for inter-cluster pings and timeouts. If a `lan` or `local`
profile is used over the Internet, a high rate of failures is risked as the
timing contraints would be too tight.

Accepted values are `local`, `lan`, `wan`.

Default: `wan`

[Back to TOC](#table-of-contents)

---

### DNS resolver section

#### dnsmasq

Toggles if Kong should start/stop dnsmasq, which can be used as the Nginx DNS
resolver. Using dnsmasq allows Nginx to resolve domains defined in /etc/hosts.

dnsmasq must be installed and available in your $PATH.

Default: `on`

---

#### dnsmasq_port

The port on which dnsmasq should listen to for queries.

Default: `8053`

---

#### dns_resolver

Configure a name server to be used by Nginx.

Only valid when `dnsmasq` is disabled.

Default: `8.8.8.8`

[Back to TOC](#table-of-contents)

---

### Development & miscellaneous section

Additional settings inherited from lua-nginx-module allowing for more
flexibility and advanced usage.

See the lua-nginx-module documentation for more informations:
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

#### lua_code_cache

When disabled, every request will run in a separate Lua VM instance: all Lua
modules will be loaded from scratch. Useful for adopting an edit-and-refresh
approach while developing a plugin.

Turning this directive off has a severe impact on performance.

See https://github.com/openresty/lua-nginx-module#lua_code_cache

Default: `on`

---

#### lua_package_path

Sets the Lua module search path (LUA_PATH). Useful when developing or using
custom plugins not stored in the default search path.

See https://github.com/openresty/lua-nginx-module#lua_package_path

Default: none

---

#### lua_package_cpath

Sets the Lua C module search path (LUA_CPATH).

See https://github.com/openresty/lua-nginx-module#lua_package_cpath

Default: none

[Back to TOC](#table-of-contents)

[Penlight]: http://stevedonovan.github.io/Penlight/api/index.html
[pl.template]: http://stevedonovan.github.io/Penlight/api/libraries/pl.template.html
