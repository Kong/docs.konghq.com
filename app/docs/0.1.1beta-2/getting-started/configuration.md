---
layout: docs
title: Configuration
version: 0.1.1beta-2
permalink: /docs/0.1.1beta-2/getting-started/configuration/
---

# Configuration

Kong comes with an easy to use configuration file called `kong.yml` in YAML format. You can use this file to configure the Kong Server.

**Note**: To avoid runtime errors, we highly reccomend that every node in the cluster shares the same configuration.

By default Kong will look for this file in the Kong directory, but you can also specify your own configuration file at startup time by specifing the `-c` option like:

```bash
kong start -c /path/to/conf.yml
```

## kong.yml

A typical `kong.yml` file looks like:

```yaml
# Available plugins on this server
plugins_available:
  - keyauth
  - basicauth
  - ratelimiting
  - tcplog
  - udplog
  - filelog

# Nginx prefix path directory
nginx_working_dir: /usr/local/kong/

# Specify the DAO to use
database: cassandra

# Databases configuration
databases_available:
  cassandra:
    properties:
      hosts: localhost
      port: 9042
      timeout: 1000
      keyspace: kong
      keepalive: 60000

# Sends anonymous error reports
send_anonymous_reports: true

# Cache configuration
cache:
  expiration: 5 # in seconds

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

    # Generic Settings
    resolver 8.8.8.8;
    charset UTF-8;

    # Logs
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

    init_by_lua '
      kong = require "kong"
      local status, err = pcall(kong.init)
      if not status then
        ngx.log(ngx.ERR, "Startup error: "..err)
        os.exit(1)
      end
    ';

    server {
      listen 8000;

      location / {
        # Assigns the default MIME-type to be used for files where the
        # standard MIME map doesn't specify anything.
        default_type 'text/plain';

        # This property will be used later by proxy_pass
        set $backend_url nil;
        set $querystring nil;

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
      listen 8001;

      location / {
        default_type application/json;
        content_by_lua '
          require("lapis").serve("kong.web.app")
        ';
      }

      location /static/ {
        alias static/;
      }

      location /admin/ {
        alias admin/;
      }

      location /favicon.ico {
        alias static/favicon.ico;
      }

      location /robots.txt {
        return 200 'User-agent: *\nDisallow: /';
      }
    }
  }
```

Here is a detailed description for each entry:

* `plugins_available` describes an array of plugins that are available and can be used by the server. You can use only the plugins that are being specified here.
* `nginx_working_dir` sets the nginx working directory and its logs.
* `database` is the database Kong is going to use. It's `cassandra` by default and it's the only one supported at the moment.
* `databases_available` describes the configuration to use when connecting to the database.
* `send_anonymous_reports` tells if the system is allowed to send anonymous error logs to a remote logging server in order to allow the maintainers of Kong to fix potential bugs and errors.
* `cache` describes the internal cache settings. The higher the `expiration` valuea and the less connections will be executed on the datastore (reducing latency), but the more time it will take to propagate any change inside the cluster.
* `nginx` contains the Kong Server configuration, and it's the equivalent of `nginx.conf`. Kong Server is built on top of nginx, so you can tune the nginx values to change the Kong Server's settings.

