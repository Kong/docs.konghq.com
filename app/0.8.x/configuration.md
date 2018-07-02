---
title: Configuration Reference
---

# Configuration Reference

The Kong configuration file is a [YAML][yaml] file that can be specified when using Kong through the [CLI][cli-reference]. This file allows you to configure and customize Kong to your needs. From the ports it uses, the database it connects to, and even the internal NGINX server itself.

## Where should I place my configuration file?

When using Kong, you can specify the location of your configuration file from any command using the `-c` argument. See the [CLI reference][cli-reference] for more information.

However, when no configuration file is passed to Kong, it will look under `/etc/kong/kong.yml` for a fallback configuration file. Should no file be present in this location, Kong will then simply use its default configuration.

## How do I customize my configuration?

If you browse the default configuration, you'll notice that all properties are commented out (to the exception of the Nginx configuration). Indeed, they are all set to their default value if non-specified. If you need to customize a property, uncomment and update it.

**However, beware of respecting the YAML formatting when doing so:** if you uncomment a nested property, be sure to uncomment its parents too!

### Properties

- [**custom_plugins**](#custom_plugins)
- [**nginx_working_dir**](#nginx_working_dir)
- [**proxy_listen**](#proxy_listen)
- [**proxy_listen_ssl**](#proxy_listen_ssl)
- [**admin_api_listen**](#admin_api_listen)
- [**cluster_listen**](#cluster_listen)
- [**cluster_listen_rpc**](#cluster_listen_rpc)
- [**ssl_cert_path**](#ssl_cert_path)
- [**ssl_key_path**](#ssl_key_path)
- [**dns_resolver**](#dns_resolver)
- [**dns_resolvers_available**](#dns_resolvers_available)
- [**cluster**](#cluster)
- [**database**](#database)
- [**cassandra**](#cassandra)
- [**postgres**](#postgres)
- [**send_anonymous_reports**](#send_anonymous_reports)
- [**memory_cache_size**](#memory_cache_size)
- [**nginx**](#nginx)

----

### **custom_plugins**


Additional plugins that this node needs to load. If you want to load custom plugins that are not supported by Kong, uncomment and update this property with the names of the plugins to load. Plugins will be loaded from the `kong.plugins.{name}.*` namespace. See the [Plugin development guide](/{{page.kong_version}}/plugin-development) for how to build your own plugins.

**Default:** none.

**Example:**

```yaml
custom_plugins:
  - custom-plugin
  - custom-plugin-2
```

----

### **nginx_working_dir**

The Kong working directory. Equivalent to nginx's prefix path. This is where this running nginx instance will keep server files including logs. Make sure it has the appropriate permissions.

**Default:**

```yaml
nginx_working_dir: /usr/local/kong/
```

----

### **proxy_listen**

Address and port on which the server will accept HTTP requests, consumers will make requests on this port.

**Default:**

```yaml
proxy_listen: "0.0.0.0:8000"
```

<div class="alert alert-warning">
  <strong>Note:</strong> This port is used to consume APIs through Kong. Set the appropriate firewall settings if you dont't want to expose Kong externally.
</div>

----

### **proxy_listen_ssl**

Same as proxy_listen, but for HTTPS requests.

**Default:**

```yaml
proxy_listen_ssl: "0.0.0.0:8443"
```

<div class="alert alert-warning">
  <strong>Note:</strong> This port is used to consume APIs through Kong. Set the appropriate firewall settings if you dont't want to expose Kong externally.
</div>

----

### **admin_api_listen**

Address and port on which the [RESTful Admin API](/{{page.kong_version}}/admin-api/) will listen to. The admin API is a private API which lets you manage your Kong infrastructure. It needs to be secured appropriately.

**Default:**

```yaml
admin_api_listen: "0.0.0.0:8001"
```

<div class="alert alert-warning">
  <strong>Note:</strong> This port is used to manage your Kong instances, therefore it should be placed behind a firewall
or closed off network to ensure security.
</div>

----

### **cluster_listen**

Address and port used by the node to communicate with other Kong nodes in the cluster with both UDP and TCP messages. All the nodes in the cluster must be able to communicate with this node on this address. Only IPv4 addresses are allowed (no hostnames).

For more information take a look at the [Clustering Reference][clustering-reference].

**Default:**

```yaml
cluster_listen: "0.0.0.0:7946"
```

<div class="alert alert-warning">
  <strong>Note:</strong> This port should be usable by other Kong nodes, but not accessible externally. Therefore appropriate firewall settings are highly recommended.
</div>

----

### **cluster_listen_rpc**

Address and port used by the node to communicate with the local clustering agent (TCP only, and local only). Used internally by this Kong node. Only IPv4 addresses are allowed (no hostnames).

For more information take a look at the [Clustering Reference][clustering-reference].

**Default:**

```yaml
cluster_listen_rpc: "127.0.0.1:7373"
```

<div class="alert alert-warning">
  <strong>Note:</strong> This port should be only used locally, therefore it should be placed behind a firewall or closed off network to ensure security.
</div>

----

### **ssl_cert_path**

The path to the SSL certificate that Kong will use when listening on the `https` port.

**Default:**

By default this property is commented out, which will force Kong to use an auto-generated self-signed certificate stored in the working directory ([`nginx_working_dir`](#nginx_working_dir)).

```yaml
# ssl_cert_path: /path/to/certificate.pem
```

----

### **ssl_key_path**

The path to the SSL certificate key that Kong will use when listening on the `https` port.

**Default:**

By default this property is commented out, which will force Kong to use an auto-generated self-signed certificate key stored in the working directory ([`nginx_working_dir`](#nginx_working_dir)).

```yaml
# ssl_key_path: /path/to/certificate.key
```

----

### **dns_resolver**

The desired DNS resolver to use for this Kong instance as a string, matching one of the DNS resolvers defined under [`dns_resolvers_available`](#dns_resolvers_available).

**Default:**

```yaml
dns_resolver: dnsmasq
```

----

### **dns_resolvers_available**

A dictionary of DNS resolvers Kong can use, and their respective properties. Currently [`dnsmasq`](http://www.thekelleys.org.uk/dnsmasq/doc.html) (default) and `server` are supported.

By choosing `dnsmasq`, Kong will resolve hostnames using the local `/etc/hosts` file and `resolv.conf` configuration. By choosing `server`, you can specify a custom DNS server.

**Default:**

```yaml
dns_resolvers_available:
  # server:
    # address: "8.8.8.8:53"
  dnsmasq:
    port: 8053
```

  **`dns_resolvers_available.server.address`**

  The address to a custom DNS server, in the `address:port` format.

  **`dns_resolvers_available.dnsmasq.port`**

  Port where Dnsmasq will listen to. Dnsmasq is only used locally, therefore will always listen on `127.0.0.1`.

<div class="alert alert-warning">
  <strong>Note:</strong> This port is used to properly resolve DNS addresses locally by Kong, therefore it should be placed behind a firewall or closed off network to ensure security.
</div>

----

### **cluster**

Cluster settings between Kong nodes. For more information take a look at the [Clustering Reference][clustering-reference].

**Default:**

```yaml
## Cluster settings
cluster:
  # advertise: ""
  # encrypt: "foo"
```

  **`advertise`**

  Address and port used by the node to communicate with other Kong nodes in the cluster with both UDP and TCP messages. All the nodes in the cluster must be able to communicate with this node on this address. Only IPv4 addresses are allowed (no hostnames).

  The advertise flag is used to change the address that we advertise to other nodes in the cluster. By default, the [`cluster_listen`](#cluster_listen) address is advertised. If the [`cluster_listen`](#cluster_listen) host is `0.0.0.0`, then the first local, non-loopback, IPv4 address will be advertised to the other nodes. However, in some cases (specifically NAT traversal), there may be a routable address that cannot be bound to. This flag enables gossiping a different address to support this.

  **`encrypt`**

  Key for encrypting network traffic within Kong. Must be a base64-encoded 16-byte key.

  **`ttl_on_failure`**

  The TTL (time to live), in seconds, of a node in the cluster when it stops sending healthcheck pings, maybe because of a failure. If the node is not able to send a new healthcheck before the expiration, then new nodes in the cluster will stop attempting to connect to it on startup. Should be at least `60`.

**Default:**

```yaml
ttl_on_failure: 3600
```

----

### **database**

The name of the desired database to use. Currently, Kong supports [PostgreSQL {{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/) and [Cassandra {{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/).

**Default:**

```yaml
database: cassandra
```

**Supported:** `"cassandra"`, `"postgres"`

----

### **cassandra**

A dictionary holding the properties for Kong to connect to your Cassandra cluster.

<div class="alert alert-warning">
  <strong>Note:</strong> If you don't want to manage/scale your own Cassandra cluster, we suggest using <a href="{{ site.links.instaclustr }}" target="_blank">Instaclustr</a> for Cassandra in the cloud.
</div>

**Example:**

```yaml
cassandra:
  contact_points:
    - "localhost:9042"
  keyspace: kong
```

  **`cassandra.contact_points`**

  The contact points on which Kong should connect to for accessing your Cassandra cluster. Can either be a string or a list of strings containing the host and the port of your node(s).

  **Example:**

```yaml
contact_points:
  - "52.5.149.55:9042"
  - "52.5.149.56:9042"
```

  **`cassandra.keyspace`**

  The keyspace in which Kong operates on your cluster.

  **Default:**

```yaml
keyspace: kong
```

#### Keyspace options

  Set those before running Kong or any migration. Those settings will be used to create a keyspace with the desired options when first running the migrations. If your keyspace already exists, you will have to manually update its options.

  See the [CQL 3.1 documentation](http://docs.datastax.com/en/cql/3.1/cql/cql_reference/create_keyspace_r.html) for a better understanding of those settings.

  **`cassandra.replication_strategy`**

  The name of the replica placement strategy class to use for the keyspace. Can be "SimpleStrategy" or "NetworkTopologyStrategy".

  **Default:**

```yaml
replication_strategy: SimpleStrategy
```

  **`cassandra.replication_factor`**

  For SimpleStrategy only. The number of replicas of data on multiple nodes.

  **Default:**

```yaml
replication_factor: 1
```

  **`cassandra.data_centers`**

  For NetworkTopologyStrategy only. The number of replicas of data on multiple nodes in each data center.

  **Default:** none.

  **Example:**

```yaml
data_centers:
  - dc1
  - dc2
```

  **`cassandra.consistency`**

  Consistency level to use. See [http://docs.datastax.com/en/cassandra/2.0/cassandra/dml/dml_config_consistency_c.html](http://docs.datastax.com/en/cassandra/2.0/cassandra/dml/dml_config_consistency_c.html)

  **Default:**

```yaml
consistency: ONE
```

#### SSL Options

  **`cassandra.ssl.enabled`**

  Enable client-to-node encryption with your Cassandra cluster.

  **Default:**

```yaml
ssl:
  enabled: false
```

  **`cassandra.ssl.verify`**

  Enable SSL certificate verification. If true, a `certificate_authority` must also be provided.

  **Default:**

```yaml
ssl:
  verify: false
```

  **`cassandra.ssl.certificate_authority`**

  Absolute path to the certificate authority file in PEM format. This property will set the certificate to the ngx_lua [`lua_ssl_trusted_certificate`](https://github.com/openresty/lua-nginx-module#lua_ssl_trusted_certificate) directive.

  **Example:**

```yaml
ssl:
  enabled: true
  verify: true
  certificate_authority: "/path/to/cluster-ca-certificate.pem"
```

#### Authentication options

  **`cassandra.user`**

  Provide a user here if your cluster uses the PasswordAuthenticator scheme.

  **Default:** none.

  **Example:**

```yaml
user: cassandra
```

  **`cassandra.password`**

  Provide a password here if your cluster uses the PasswordAuthenticator scheme.

  **Default:** none.

  **Example:**

```yaml
password: cassandra
```

----

### **postgres**

A dictionary holding the properties for Kong to connect to a PostgreSQL server.

**Defaults:**

```yaml
postgres:
  host: "127.0.0.1"
  port: 5432
  user: kong
  password: kong
  database: kong
```

  **`postgres.host`**

  The host to connect to.

  **`postgres.port`**

  The port for this running host.

  **`postgres.user`**

  The username to authenticate with.

  **`postgres.password`**

  The password to authenticate with.

  **`postgres.database`**

  The database name to connect to.

----

### **send_anonymous_reports**

If set to `true`, Kong will collect anonymous error reports which helps us maintain and improve Kong.

**Default:**

```yaml
send_anonymous_reports: true
```

----

### **memory_cache_size**

A value specifying (in MB) the size of the internal preallocated in-memory cache. Kong uses an in-memory cache to store database entities in order to optimize access to the underlying datastore. The cache size needs to be as big as the size of the entities being used by Kong at any given time. The default value is `128`, and the potential maximum value is the total size of the datastore. This value may not be smaller than 32MB.

**Default:**

```yaml
memory_cache_size: 128 # in megabytes
```

----

### **nginx**

The NGINX configuration (or `nginx.conf`) that will be used for this instance. The placeholders will be computed and this property will be written as a file by Kong at `<nginx_working_dir>/nginx.conf` during startup.

**Warning:** Modifying the NGINX configuration can lead to unexpected results, edit the configuration only if you are confident about doing so.

**Default:**

```yaml
nginx: |
  worker_processes auto;
  error_log logs/error.log error;
  daemon on;

  worker_rlimit_nofile {{ "{{auto_worker_rlimit_nofile" }}}};

  env KONG_CONF;

  events {
    worker_connections {{ "{{auto_worker_connections" }}}};
    multi_accept on;
  }

  http {
    resolver {{ "{{dns_resolver" }}}} ipv6=off;
    charset UTF-8;

    access_log logs/access.log;
    access_log off;

    # Timeouts
    keepalive_timeout 60s;
    client_header_timeout 60s;
    client_body_timeout 60s;
    send_timeout 60s;

    # Proxy Settings
    proxy_buffer_size 128k;
    proxy_buffers 4 256k;
    proxy_busy_buffers_size 256k;
    proxy_ssl_server_name on;

    # IP Address
    real_ip_header X-Forwarded-For;
    set_real_ip_from 0.0.0.0/0;
    real_ip_recursive on;

    # Other Settings
    client_max_body_size 0;
    underscores_in_headers on;
    reset_timedout_connection on;
    tcp_nopush on;

    ################################################
    #  The following code is required to run Kong  #
    # Please be careful if you'd like to change it #
    ################################################

    # Lua Settings
    lua_package_path ';;';
    lua_code_cache on;
    lua_max_running_timers 4096;
    lua_max_pending_timers 16384;
    lua_shared_dict reports_locks 100k;
    lua_shared_dict cluster_locks 100k;
    lua_shared_dict cache {{ "{{memory_cache_size" }}}}m;
    lua_shared_dict cassandra 1m;
    lua_shared_dict cassandra_prepared 5m;
    lua_socket_log_errors off;
    {{ "{{lua_ssl_trusted_certificate" }}}}

    init_by_lua '
      kong = require "kong"
      local status, err = pcall(kong.init)
      if not status then
        ngx.log(ngx.ERR, "Startup error: "..err)
        os.exit(1)
      end
    ';

    init_worker_by_lua 'kong.exec_plugins_init_worker()';

    server {
      server_name _;
      listen {{ "{{proxy_listen" }}}};
      listen {{ "{{proxy_listen_ssl" }}}} ssl;

      ssl_certificate_by_lua 'kong.exec_plugins_certificate()';

      ssl_certificate {{ "{{ssl_cert" }}}};
      ssl_certificate_key {{ "{{ssl_key" }}}};
      ssl_protocols TLSv1 TLSv1.1 TLSv1.2;# omit SSLv3 because of POODLE (CVE-2014-3566)

      location / {
        default_type 'text/plain';

        # These properties will be used later by proxy_pass
        set $upstream_host nil;
        set $upstream_url nil;

        # Authenticate the user and load the API info
        access_by_lua 'kong.exec_plugins_access()';

        # Proxy the request
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header Host $upstream_host;
        proxy_pass $upstream_url;
        proxy_pass_header Server;

        # Add additional response headers
        header_filter_by_lua 'kong.exec_plugins_header_filter()';

        # Change the response body
        body_filter_by_lua 'kong.exec_plugins_body_filter()';

        # Log the request
        log_by_lua 'kong.exec_plugins_log()';
      }

      location /robots.txt {
        return 200 'User-agent: *\nDisallow: /';
      }

      error_page 500 /500.html;
      location = /500.html {
        internal;
        content_by_lua '
          local responses = require "kong.tools.responses"
          responses.send_HTTP_INTERNAL_SERVER_ERROR("An unexpected error occurred")
        ';
      }
    }

    server {
      listen {{ "{{admin_api_listen" }}}};

      client_max_body_size 10m;
      client_body_buffer_size 10m;

      location / {
        default_type application/json;
        content_by_lua '
          ngx.header["Access-Control-Allow-Origin"] = "*"
          if ngx.req.get_method() == "OPTIONS" then
            ngx.header["Access-Control-Allow-Methods"] = "GET,HEAD,PUT,PATCH,POST,DELETE"
            ngx.header["Access-Control-Allow-Headers"] = "Content-Type"
            ngx.exit(204)
          end
          local lapis = require "lapis"
          lapis.serve("kong.api.app")
        ';
      }

      location /nginx_status {
        internal;
        access_log off;
        stub_status;
      }

      location /robots.txt {
        return 200 'User-agent: *\nDisallow: /';
      }
    }
  }
```

[cli-reference]: /{{page.kong_version}}/cli
[clustering-reference]: /{{page.kong_version}}/clustering
[yaml]: http://yaml.org
