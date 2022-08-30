---
title: Serving a website and API with Kong Gateway
content-type: how-to
---

## How to serve both a website and APIs using {{site.base_gateway}}

A common use case for API providers is to make {{site.base_gateway}} serve both a website
and the APIs over port: `80` or `443` in
production. For example, `https://example.net` (Website) and
`https://example.net/api/v1` (API).

You can do this using a custom
Nginx configuration template that calls `nginx_kong.lua` in-line, and adds a new
`location` block that serves website alongside the Kong proxy `location`
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

Then start Nginx:

`nginx -p /usr/local/openresty -c my_nginx.conf`


## More Information

* [Embedding Kong in OpenResty](/gateway/latest/kong-production/kong-openresty)
* [Setting environment variables](/gateway/latest/kong-production/environment-variables)
* [How to use `kong.conf`](/gateway/latest/kong-production/kong-conf)