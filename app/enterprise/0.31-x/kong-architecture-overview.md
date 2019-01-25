---
title: Kong Architecture Overview
---

# Kong Architecture Overview

Broadly, Kong is suite of software that utilizes OpenResty to dynamically configure NGINX and process HTTP requests. This article covers the purpose and architecture of those underlying components as they relate to Kong's execution.

## NGINX

NGINX provides a robust HTTP server infrastructure. It handles HTTP request processing, TLS encryption, request logging, and allocation of operating system resources (e.g. listening for and managing client connections and spawning new processes).

NGINX has a declarative configuration file that resides in its host operating system's filesystem. While some Kong features (e.g. determining upstream request routing based on a request's URL) are possible via NGINX configuration alone, modifying that configuration requires some level of operating system access to edit configuration files and to ask NGINX to reload them, whereas Kong allows users to update configuration via a RESTful HTTP API. [Kong's NGINX
configuration](https://github.com/Kong/kong/tree/master/kong/templates) is fairly basic: beyond configuring standard headers, listening ports, and log paths, most configuration is delegated to OpenResty.

In some cases, it's useful to add your own NGINX configuration alongside Kong's, e.g. to serve a static website alongside your API gateway. In those cases, you can [modify the configuration templates used by Kong](/0.12.x/configuration/#custom-nginx-configuration-embedding-kong).

Requests handled by NGINX pass through a sequence of [phases](https://nginx.org/en/docs/dev/development_guide.html#http_phases). Much of NGINX's functionality (e.g. the [ability to use gzip compression](http://nginx.org/en/docs/http/ngx_http_gzip_module.html) is provided by modules (written in C) that hook into these phases. While it is possible to write your own modules, NGINX must be recompiled every time a module is added or updated. To simplify the process of adding new functionality, Kong uses OpenResty.

## OpenResty

OpenResty is a software suite that bundles NGINX, a set of modules, LuaJIT, and a set of Lua libraries. Chief among these is `ngx_http_lua_module`, an NGINX module which embeds Lua and provides Lua equivalents for most NGINX request phases. This effectively allows development of NGINX modules in Lua while maintaining high performance (LuaJIT is quite fast), and Kong uses it to provide its core configuration management and plugin management infrastructure.

To understand how this is done, it helps to look at an abbreviated section of the Kong NGINX configuration:

```
upstream kong_upstream {
    server 0.0.0.1;
    balancer_by_lua_block {
        kong.balancer()
    }
    keepalive ${{UPSTREAM_KEEPALIVE}};
}

server {
    server_name kong;
    listen ${{PROXY_LISTEN}}${{PROXY_PROTOCOL}};
    error_page 400 404 408 411 412 413 414 417 /kong_error_handler;
    error_page 500 502 503 504 /kong_error_handler;

    access_log ${{PROXY_ACCESS_LOG}};
    error_log ${{PROXY_ERROR_LOG}} ${{LOG_LEVEL}};
    ...
    location / {
        set $upstream_host               '';
        set $upstream_upgrade            '';
        set $upstream_connection         '';
        set $upstream_scheme             '';
        set $upstream_uri                '';
        set $upstream_x_forwarded_for    '';
        set $upstream_x_forwarded_proto  '';
        set $upstream_x_forwarded_host   '';
        set $upstream_x_forwarded_port   '';

        rewrite_by_lua_block {
            kong.rewrite()
        }

        access_by_lua_block {
            kong.access()
        
        }
        ...
        proxy_pass         $upstream_scheme://kong_upstream$upstream_uri;
        ...
```

The above configuration first defines an upstream for later use. Typical configuration would specify an actual address for the upstream, but Kong instead uses the invalid placeholder address `0.0.0.1`, which will be overwritten by code executed in the `balancer_by_lua_block` section--Kong's `balancer` function determines an appropriate address for upstream traffic based on the API and plugin configuration in Kong's datastore.

The remaining configuration sets up which addresses and ports NGINX listens on, defines log paths, and defines a location block. The location block indicates a URI prefix to apply configuration to--in this case, the prefix `/` simply matches all paths. After initializing NGINX variables for use later, it executes Kong's `rewrite` and `access` functions in the appropriate OpenResty Lua blocks. The access phase, for example, corresponds to the `NGX_HTTP_ACCESS_PHASE` in an NGINX module, and is used to determine whether a client is allowed to make a request. As such, it's appropriate for running authentication and access control code.

Beyond running Lua code within NGINX, OpenResty provides modules that allow NGINX to communicate with a variety of database backends, including PostgreSQL and Apache Cassandra. These allow Kong to store and retrieve configurations in a more easily distributed fashion than is possible with flat files.

## Kong

Kong provides a framework for hooking into the above request phases via its plugin architecture. Following from the example above, both the Key Auth and ACL plugins control whether a client (alternately called a consumer) should be able to make a request. Each defines its own access function in its handler, and that function is executed for each plugin enabled on a given route or service by `kong.access()`. Execution order is determined by a priority value--if Key Auth has priority 1003
and ACL has priority 950, Kong will execute Key Auth's access function first and, if it does not drop the request, will then execute ACL's before passing it upstream via `proxy_pass`.

Because Kong's request routing and handling configuration is controlled via its admin API, plugin configuration can be added and removed on on the fly without editing the underlying NGINX configuration, as Kong essentially provides a means to inject location blocks (via API definitions) and configuration within them (by assigning plugins, certificates, etc. to those APIs).

## Summary

Kong's overall infrastructure is composed of three main parts: NGINX provides protocol implementations and worker process management, OpenResty provides Lua integration and hooks into NGINX's request processing phases, and Kong itself utilizes those hooks to route and transform requests.
