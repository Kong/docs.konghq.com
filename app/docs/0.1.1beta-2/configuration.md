---
title: Configuration Reference
---

# Configuration Reference

Kong is extremely flexible and bends to your needs due to its pluggable architecture. It is also very customizable down to its configuration, allowing it to best fit your needs. From the ports it listens on, the database you want it to use, down to the underlying NGINX configuration, learn how to sharp your instance so it performs best.

### 1. Where to put your configuration file?

1. When using Kong, you can specify a configuration from any command with the `-c` argument. See the [CLI reference][cli-reference] for more informations.
2. If no configuration file was manually given to Kong, it will always look for a configuration located at `/etc/kong/kong.yml`.
3. If no file is present there, Kong will load a default configuration from its Luarocks install path.

### 2. Properties reference

This reference describes every property defined in a typical configuration file and their default values. They are all **required**.

**Summary:**

- [**proxy_port**](#proxy_port)
- [**admin_api_port**](#admin_api_port)
- [**nginx_working_dir**](#nginx_working_dir)
- [**plugins_available**](#plugins_available)
- [**send_anonymous_reports**](#send_anonymous_reports)
- [**databases_available**](#databases_available)
- [**database**](#database)
- [**nginx**](#nginx)
- [**nginx_plus_status**](#nginx_plus_status)

---

#### `proxy_port`

Port on which Kong will proxy requests. This is the port you want your consumers to make requests on.

**Default:**

```yaml
proxy_port: 8000
```

---

#### `admin_api_port`

Port on which the [admin RESTful API](/docs/{{page.kong_version}}/admin-api/) will listen.

**Note:** This port is used to operate Kong, you should keep it private and/or firewalled.

**Default:**

```yaml
admin_api_port: 8001
```

---

#### `nginx_working_dir`

Similar to the NGINX `--prefix` option, it defines a directory that will contain server files, such as access and error logs, or the Kong pid file.

**Default:**

```yaml
nginx_working_dir: /usr/local/kong/
```

---

#### `plugins_available`

A list of plugins installed on this node that Kong will load and try to execute during the lifetime of a request. Kong will look for a [`plugin configuration`](/docs/{{page.kong_version}}/admin-api/#plugin-object) entry for each plugin in this list during every request. That is to determine if the plugin needs to be executed for that particular request. Removing plugins you don't use from this list will lighten your Kong instance.

**Default:**

```yaml
plugins_available:
  - keyauth
  - basicauth
  - ratelimiting
  - tcplog
  - udplog
  - filelog
  - request_transformer
```

---

#### `send_anonymous_reports`

If set to `true`, Kong will send anonymous error reports to Mashape. This helps Mashape maintaining and improving Kong.

**Default:**

```yaml
send_anonymous_reports: true
```

---

#### `databases_available`

A dictionary of databases Kong can connect to. The key is the name of the database, values will be the necessary properties for Kong to connect to it.

  **`databases_available.*.properties`**

  A dictionary of properties needed for Kong to connect to a given database.

  **`databases_available.*.cache_expiration`**

  A value specifying in seconds how much time Kong will keep a cache of the database entities into memory. For example, setting this to a high value will avoid Kong to make regular queries to the database in order to retrieve a given API's target URL.

**Note:** Currently, Kong only supports [Cassandra v2.1.3](http://cassandra.apache.org/).

**Default:**

```yaml
databases_available:
  cassandra:
    properties:
      hosts: "localhost"
      port: 9042
      timeout: 1000
      keyspace: kong
      keepalive: 60000
    cache_expiration: 5
```

---

#### `database`

The desired database to use for this Kong instance as a string, matching one of the databases listed in `databases_available`.

**Default:**

```yaml
database: cassandra
```

---

#### `nginx`

The NGINX configuration (usually known as `nginx.conf`) that will be used for this instance.

**Note:** While it is recommended not to drastically change this configuration to prevent Konf from malfunctioning, you can still edit this configuration to your needs, to a certain extent.

**Default:**

```yaml
nginx: |
  worker_processes auto;
  error_log logs/error.log info;
  daemon on;

  # Set "worker_rlimit_nofile" to a high value
  # worker_rlimit_nofile 65536;

  env KONG_CONF;

  events {
    # Set "worker_connections" to a high value
    worker_connections 1024;
  }

  http {
    resolver 8.8.8.8;
    charset UTF-8;

    access_log logs/access.log;
    access_log on;

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
    client_max_body_size 128m;
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
    lua_shared_dict cache 512m;
    lua_socket_log_errors off;

    init_by_lua '
      kong = require "kong"
      local status, err = pcall(kong.init)
      if not status then
        ngx.log(ngx.ERR, "Startup error: "..err)
        os.exit(1)
      end
    ';

    server {
      listen {{proxy_port}};

      location / {
        default_type 'text/plain';

        # This property will be used later by proxy_pass
        set $backend_url nil;

        # Authenticate the user and load the API info
        access_by_lua 'kong.exec_plugins_access()';

        # Proxy the request
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass $backend_url;

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
          local utils = require "kong.tools.utils"
          utils.show_error(ngx.status, "Oops, an unexpected error occurred!")
        ';
      }
    }

    server {
      listen {{admin_api_port}};

      location / {
        default_type application/json;
        content_by_lua 'require("lapis").serve("kong.api.app")';
      }

      location /robots.txt {
        return 200 'User-agent: *\nDisallow: /';
      }

      # Do not remove, additional configuration placeholder for some plugins
      # {{additional_configuration}}
    }
  }
```

---

#### `nginx_plus_status`

TODO

[cli-reference]: /docs/{{page.kong_version}}/cli
