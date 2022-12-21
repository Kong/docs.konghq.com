---
title: Nginx Directives
content-type: reference
---

### Injecting individual Nginx directives

Entries in `kong.conf` that are prefixed with `nginx_http_`,
`nginx_proxy_` or `nginx_admin_` are converted to Nginx
directives.

- Entries prefixed with `nginx_http_` will be injected into the overall `http`
block directive.

- Entries prefixed with `nginx_proxy_` will be injected into the `server` block
directive handling {{site.base_gateway}}'s proxy ports.

- Entries prefixed with `nginx_admin_` will be injected into the `server` block
directive handling {{site.base_gateway}}'s Admin API ports.

For example, if you add the following line to your `kong.conf` file:

```
nginx_proxy_large_client_header_buffers=16 128k
```

It adds the following directive to the proxy `server` block of {{site.base_gateway}}'s
Nginx configuration:

```
large_client_header_buffers 16 128k;
```

These directives can also be specified
using [environment variables](/gateway/latest/production/environment-variables). For
example, if you declare an environment variable like this:

```bash
export KONG_NGINX_HTTP_OUTPUT_BUFFERS="4 64k"
```

This results in the following Nginx directive being added to the `http`
block:

```
output_buffers 4 64k;
```

For more details on the Nginx configuration file structure and block
directives, see the [Nginx reference](https://nginx.org/en/docs/beginners_guide.html#conf_structure).

For a list of Nginx directives, see the [Nginx directives index](https://nginx.org/en/docs/dirindex.html).

### Including files via injected Nginx directives

Complex configurations may require adding new `server` blocks to an Nginx configuration.
You can inject `include` directives into an Nginx configuration that point to Nginx settings files. 

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

You can make the {{site.base_gateway}} node serve this port by adding the following
entry to your `kong.conf` file:

```
nginx_http_include = /path/to/your/my-server.kong.conf
```

You can also use environment variables:

```bash
export KONG_NGINX_HTTP_INCLUDE="/path/to/your/my-server.kong.conf"
```

When you start {{site.base_gateway}}, the `server` section from that file will be added to
that file, meaning that the custom server defined in it will be responding,
alongside the regular {{site.base_gateway}} ports:

```bash
curl -I http://127.0.0.1:2112
HTTP/1.1 200 OK
...
```

If you use a relative path in an `nginx_http_include` property, that
path will be interpreted relative to the value of the `prefix` property of
your `kong.conf` file (or the value of the `-p` flag of `kong start` if you
used it to override the prefix when starting {{site.base_gateway}}).

## Custom Nginx templates and embedding {{site.base_gateway}}

You can use custom Nginx
configuration templates directly in two cases: 

- You need to modify {{site.base_gateway}}'s default
Nginx configuration. Specifically values that are not adjustable in `kong.conf`, you can modify the template used by {{site.base_gateway}} for producing its
Nginx configuration and launch {{site.base_gateway}} using your customized template.

- You need to embed {{site.base_gateway}} in an already running OpenResty instance, you
can reuse {{site.base_gateway}}'s generated configuration and include it in your existing
configuration.

### Custom Nginx templates

{{site.base_gateway}} can be started, reloaded and restarted with an `--nginx-conf` argument,
which must specify an Nginx configuration template. Such a template uses the
[Penlight][Penlight] [templating engine][pl.template], which is compiled using
the {{site.base_gateway}} configuration.

The following Lua functions are available in the [templating engine][pl.template]:

- `pairs`, `ipairs`
- `tostring`
- `os.getenv`

The default template for
{{site.base_gateway}} can be found using this command on the system
running your {{site.base_gateway}} instance:
`find / -type d -name "templates" | grep kong`.
For open-source {{site.base_gateway}}, you can also see the
[templates directory][templates].

The template is split in two
Nginx configuration files: `nginx.lua` and `nginx_kong.lua`. The former is
minimal and includes the latter, which contains everything {{site.base_gateway}} requires
to run. When `kong start` runs, right before starting Nginx, it copies these
two files into the prefix directory, which looks like so:

```
/usr/local/kong
├── nginx-kong.conf
└── nginx.conf
```

If you must tweak global settings that are defined by {{site.base_gateway}} but not adjustable
via the {{site.base_gateway}} configuration in `kong.conf`, you can inline the contents of the
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

You can then start {{site.base_gateway}} with:

```bash
kong start -c kong.conf --nginx-conf custom_nginx.template
```


## More information

* [Embedding {{site.base_gateway}} in OpenResty](/gateway/latest/production/kong-openresty)
* [How to use `kong.conf`](/gateway/latest/production/kong-conf)
* [How to serve an API and a website with Kong](/gateway/latest/production/website-api-serving)


---


[Penlight]: http://stevedonovan.github.io/Penlight/api/index.html
[pl.template]: http://stevedonovan.github.io/Penlight/api/libraries/pl.template.html
[templates]: https://github.com/kong/kong/tree/master/kong/templates
