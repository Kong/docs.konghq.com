---
title: Upgrade guide
---

<div class="alert alert-warning">
  <strong>Note:</strong> What follows is the upgrade guide for 2.0.x.
  If you are trying to upgrade to an earlier version of Kong, please read
  <a href="https://github.com/Kong/kong/blob/master/UPGRADE.md">UPGRADE.md file in the Kong repo</a>
</div>

This guide will inform you about breaking changes you should be aware of
when upgrading, as well as take you through the correct sequence of steps
in order to obtain a **no-downtime** migration in different upgrade
scenarios.

## Upgrade to `2.0.0`

Kong adheres to [semantic versioning](https://semver.org/), which makes a
distinction between "major", "minor" and "patch" versions. The upgrade path
will be different on which previous version from which you are migrating.
Upgrading into 2.0.x is a major version upgrade, so be aware of any
breaking changes listed in the [CHANGELOG.md](https://github.com/Kong/kong/blob/2.0.0/CHANGELOG.md) document.

#### 1. Dependencies

If you are using the provided binary packages, all necessary dependencies
are bundled and you can skip this section.

If you are building your dependencies by hand, there are changes since the
previous release, so you will need to rebuild them with the latest patches.

The required OpenResty version is
[1.15.8.2](http://openresty.org/en/changelog-1015008.html), and the
the set of [OpenResty
patches](https://github.com/Kong/kong-build-tools/tree/master/openresty-build-tools/openresty-patches)
included has changed, including the latest release of
[lua-kong-nginx-module](https://github.com/Kong/lua-kong-nginx-module).
Our [kong-build-tools](https://github.com/Kong/kong-build-tools)
repository allows you to build OpenResty with the necessary patches
and modules easily.

For Go support, you also need the [Kong go-pluginserver](https://github.com/kong/go-pluginserver).
This is bundled with Kong binary packages and it is automatically started by
Kong if Go plugin support is enabled in Kong's configuration.
Note that the Go version used to compile any Go plugins needs to match the Go
version of the `go-pluginserver`. You can check the Go version used to
build the `go-pluginserver` binary running `go-pluginserver -version`.

#### 2. Breaking Changes

Kong 2.0.0 does include a few breaking changes over Kong 1.x, all of them
related to the removal of service mesh:

- **Removed Service Mesh support** - That has been deprecated in Kong 1.4
  and made off-by-default already, and the code is now be gone in 2.0.
  For Service Mesh, we now have [Kuma](https://kuma.io), which is something
  designed for Mesh patterns from day one, so we feel at peace with removing
  Kong's native Service Mesh functionality and focus on its core capabilities
  as a gateway.
- As part of service mesh removal, serviceless proxying was removed.
  You can still set `service = null` when creating a route for use with
  serverless plugins such as `aws-lambda`, or `request-termination`.
- Removed the `origins` property.
- Removed the `transparent` property.
- Removed the Sidecar Injector plugin which was used for service mesh.
- The **Nginx configuration file has changed**, which means that you need to update
  it if you are using a custom template. Changes were made to improve
  stream mode support and to make the Nginx injections system more
  powerful so that custom templates are less of a necessity. The changes
  are detailed in a diff included below.
  - :warning: Note that the `kong_cache` shm was split into two
    shms: `kong_core_cache` and `kong_cache`. If you are using a
    custom Nginx template, make sure core cache shared dictionaries
    are defined, including db-less mode shadow definitions.
    Both cache values rely on the already existent `mem_cache_size`
    configuration option to set their size, so when upgrading from
    a previous Kong version, the cache memory consumption might
    double if this value is not adjusted.

<details>
<summary><strong>Click here to see the Nginx configuration changes</strong></summary>
<p>

<pre>
diff --git a/kong/templates/nginx_kong.lua b/kong/templates/nginx_kong.lua
index 5c6c1db03..6b4b4a818 100644
--- a/kong/templates/nginx_kong.lua
+++ b/kong/templates/nginx_kong.lua
@@ -5,52 +5,46 @@ server_tokens off;
 &gt; if anonymous_reports then
 ${{SYSLOG_REPORTS}}
 &gt; end
-
 error_log ${{PROXY_ERROR_LOG}} ${{LOG_LEVEL}};

-&gt; if nginx_optimizations then
-&gt;-- send_timeout 60s;          # default value
-&gt;-- keepalive_timeout 75s;     # default value
-&gt;-- client_body_timeout 60s;   # default value
-&gt;-- client_header_timeout 60s; # default value
-&gt;-- tcp_nopush on;             # disabled until benchmarked
-&gt;-- proxy_buffer_size 128k;    # disabled until benchmarked
-&gt;-- proxy_buffers 4 256k;      # disabled until benchmarked
-&gt;-- proxy_busy_buffers_size 256k; # disabled until benchmarked
-&gt;-- reset_timedout_connection on; # disabled until benchmarked
-&gt; end
-
-client_max_body_size ${{CLIENT_MAX_BODY_SIZE}};
-proxy_ssl_server_name on;
-underscores_in_headers on;
-
 lua_package_path       '${{LUA_PACKAGE_PATH}};;';
 lua_package_cpath      '${{LUA_PACKAGE_CPATH}};;';
 lua_socket_pool_size   ${{LUA_SOCKET_POOL_SIZE}};
+lua_socket_log_errors  off;
 lua_max_running_timers 4096;
 lua_max_pending_timers 16384;
+lua_ssl_verify_depth   ${{LUA_SSL_VERIFY_DEPTH}};
+&gt; if lua_ssl_trusted_certificate then
+lua_ssl_trusted_certificate '${{LUA_SSL_TRUSTED_CERTIFICATE}}';
+&gt; end
+
 lua_shared_dict kong                        5m;
+lua_shared_dict kong_locks                  8m;
+lua_shared_dict kong_healthchecks           5m;
+lua_shared_dict kong_process_events         5m;
+lua_shared_dict kong_cluster_events         5m;
+lua_shared_dict kong_rate_limiting_counters 12m;
+lua_shared_dict kong_core_db_cache          ${{MEM_CACHE_SIZE}};
+lua_shared_dict kong_core_db_cache_miss     12m;
 lua_shared_dict kong_db_cache               ${{MEM_CACHE_SIZE}};
-&gt; if database == "off" then
-lua_shared_dict kong_db_cache_2     ${{MEM_CACHE_SIZE}};
-&gt; end
 lua_shared_dict kong_db_cache_miss          12m;
 &gt; if database == "off" then
+lua_shared_dict kong_core_db_cache_2        ${{MEM_CACHE_SIZE}};
+lua_shared_dict kong_core_db_cache_miss_2   12m;
+lua_shared_dict kong_db_cache_2             ${{MEM_CACHE_SIZE}};
 lua_shared_dict kong_db_cache_miss_2        12m;
 &gt; end
-lua_shared_dict kong_locks          8m;
-lua_shared_dict kong_process_events 5m;
-lua_shared_dict kong_cluster_events 5m;
-lua_shared_dict kong_healthchecks   5m;
-lua_shared_dict kong_rate_limiting_counters 12m;
 &gt; if database == "cassandra" then
 lua_shared_dict kong_cassandra              5m;
 &gt; end
-lua_socket_log_errors off;
-&gt; if lua_ssl_trusted_certificate then
-lua_ssl_trusted_certificate '${{LUA_SSL_TRUSTED_CERTIFICATE}}';
+&gt; if role == "control_plane" then
+lua_shared_dict kong_clustering             5m;
+&gt; end
+
+underscores_in_headers on;
+&gt; if ssl_ciphers then
+ssl_ciphers ${{SSL_CIPHERS}};
 &gt; end
-lua_ssl_verify_depth ${{LUA_SSL_VERIFY_DEPTH}};

 # injected nginx_http_* directives
 &gt; for _, el in ipairs(nginx_http_directives) do
@@ -66,61 +60,47 @@ init_worker_by_lua_block {
     Kong.init_worker()
 }

-
-&gt; if #proxy_listeners &gt; 0 then
+&gt; if (role == "traditional" or role == "data_plane") and #proxy_listeners &gt; 0 then
 upstream kong_upstream {
     server 0.0.0.1;
     balancer_by_lua_block {
         Kong.balancer()
     }

-# injected nginx_http_upstream_* directives
-&gt; for _, el in ipairs(nginx_http_upstream_directives) do
+    # injected nginx_upstream_* directives
+&gt; for _, el in ipairs(nginx_upstream_directives) do
     $(el.name) $(el.value);
 &gt; end
 }

 server {
     server_name kong;
-&gt; for i = 1, #proxy_listeners do
-    listen $(proxy_listeners[i].listener);
+&gt; for _, entry in ipairs(proxy_listeners) do
+    listen $(entry.listener);
 &gt; end
+
     error_page 400 404 408 411 412 413 414 417 494 /kong_error_handler;
     error_page 500 502 503 504                     /kong_error_handler;

     access_log ${{PROXY_ACCESS_LOG}};
     error_log  ${{PROXY_ERROR_LOG}} ${{LOG_LEVEL}};

-    client_body_buffer_size ${{CLIENT_BODY_BUFFER_SIZE}};
-
 &gt; if proxy_ssl_enabled then
     ssl_certificate     ${{SSL_CERT}};
     ssl_certificate_key ${{SSL_CERT_KEY}};
+    ssl_session_cache   shared:SSL:10m;
     ssl_certificate_by_lua_block {
         Kong.ssl_certificate()
     }
-
-    ssl_session_cache shared:SSL:10m;
-    ssl_session_timeout 10m;
-    ssl_prefer_server_ciphers on;
-    ssl_ciphers ${{SSL_CIPHERS}};
-&gt; end
-
-&gt; if client_ssl then
-    proxy_ssl_certificate ${{CLIENT_SSL_CERT}};
-    proxy_ssl_certificate_key ${{CLIENT_SSL_CERT_KEY}};
-&gt; end
-
-    real_ip_header     ${{REAL_IP_HEADER}};
-    real_ip_recursive  ${{REAL_IP_RECURSIVE}};
-&gt; for i = 1, #trusted_ips do
-    set_real_ip_from   $(trusted_ips[i]);
 &gt; end

     # injected nginx_proxy_* directives
 &gt; for _, el in ipairs(nginx_proxy_directives) do
     $(el.name) $(el.value);
 &gt; end
+&gt; for i = 1, #trusted_ips do
+    set_real_ip_from  $(trusted_ips[i]);
+&gt; end

     rewrite_by_lua_block {
         Kong.rewrite()
@@ -171,43 +151,93 @@ server {
         proxy_pass_header     Server;
         proxy_pass_header     Date;
         proxy_ssl_name        $upstream_host;
+        proxy_ssl_server_name on;
+&gt; if client_ssl then
+        proxy_ssl_certificate ${{CLIENT_SSL_CERT}};
+        proxy_ssl_certificate_key ${{CLIENT_SSL_CERT_KEY}};
+&gt; end
         proxy_pass            $upstream_scheme://kong_upstream$upstream_uri;
     }

     location @grpc {
         internal;
+        default_type         '';
         set $kong_proxy_mode 'grpc';

+        grpc_set_header      TE                $upstream_te;
         grpc_set_header      Host              $upstream_host;
         grpc_set_header      X-Forwarded-For   $upstream_x_forwarded_for;
         grpc_set_header      X-Forwarded-Proto $upstream_x_forwarded_proto;
         grpc_set_header      X-Forwarded-Host  $upstream_x_forwarded_host;
         grpc_set_header      X-Forwarded-Port  $upstream_x_forwarded_port;
         grpc_set_header      X-Real-IP         $remote_addr;
-
+        grpc_pass_header     Server;
+        grpc_pass_header     Date;
         grpc_pass            grpc://kong_upstream;
     }

     location @grpcs {
         internal;
+        default_type         '';
         set $kong_proxy_mode 'grpc';

+        grpc_set_header      TE                $upstream_te;
         grpc_set_header      Host              $upstream_host;
         grpc_set_header      X-Forwarded-For   $upstream_x_forwarded_for;
         grpc_set_header      X-Forwarded-Proto $upstream_x_forwarded_proto;
         grpc_set_header      X-Forwarded-Host  $upstream_x_forwarded_host;
         grpc_set_header      X-Forwarded-Port  $upstream_x_forwarded_port;
         grpc_set_header      X-Real-IP         $remote_addr;
-
+        grpc_pass_header     Server;
+        grpc_pass_header     Date;
+        grpc_ssl_name        $upstream_host;
+        grpc_ssl_server_name on;
+&gt; if client_ssl then
+        grpc_ssl_certificate ${{CLIENT_SSL_CERT}};
+        grpc_ssl_certificate_key ${{CLIENT_SSL_CERT_KEY}};
+&gt; end
         grpc_pass            grpcs://kong_upstream;
     }

+    location = /kong_buffered_http {
+        internal;
+        default_type         '';
+        set $kong_proxy_mode 'http';
+
+        rewrite_by_lua_block       {;}
+        access_by_lua_block        {;}
+        header_filter_by_lua_block {;}
+        body_filter_by_lua_block   {;}
+        log_by_lua_block           {;}
+
+        proxy_http_version 1.1;
+        proxy_set_header      TE                $upstream_te;
+        proxy_set_header      Host              $upstream_host;
+        proxy_set_header      Upgrade           $upstream_upgrade;
+        proxy_set_header      Connection        $upstream_connection;
+        proxy_set_header      X-Forwarded-For   $upstream_x_forwarded_for;
+        proxy_set_header      X-Forwarded-Proto $upstream_x_forwarded_proto;
+        proxy_set_header      X-Forwarded-Host  $upstream_x_forwarded_host;
+        proxy_set_header      X-Forwarded-Port  $upstream_x_forwarded_port;
+        proxy_set_header      X-Real-IP         $remote_addr;
+        proxy_pass_header     Server;
+        proxy_pass_header     Date;
+        proxy_ssl_name        $upstream_host;
+        proxy_ssl_server_name on;
+&gt; if client_ssl then
+        proxy_ssl_certificate ${{CLIENT_SSL_CERT}};
+        proxy_ssl_certificate_key ${{CLIENT_SSL_CERT_KEY}};
+&gt; end
+        proxy_pass            $upstream_scheme://kong_upstream$upstream_uri;
+    }
+
     location = /kong_error_handler {
         internal;
+        default_type                 '';
+
         uninitialized_variable_warn  off;

         rewrite_by_lua_block {;}
-
         access_by_lua_block  {;}

         content_by_lua_block {
@@ -215,13 +245,13 @@ server {
         }
     }
 }
-&gt; end
+&gt; end -- (role == "traditional" or role == "data_plane") and #proxy_listeners &gt; 0

-&gt; if #admin_listeners &gt; 0 then
+&gt; if (role == "control_plane" or role == "traditional") and #admin_listeners &gt; 0 then
 server {
     server_name kong_admin;
-&gt; for i = 1, #admin_listeners do
-    listen $(admin_listeners[i].listener);
+&gt; for _, entry in ipairs(admin_listeners) do
+    listen $(entry.listener);
 &gt; end

     access_log ${{ADMIN_ACCESS_LOG}};
@@ -233,11 +263,7 @@ server {
 &gt; if admin_ssl_enabled then
     ssl_certificate     ${{ADMIN_SSL_CERT}};
     ssl_certificate_key ${{ADMIN_SSL_CERT_KEY}};
-
-    ssl_session_cache shared:SSL:10m;
-    ssl_session_timeout 10m;
-    ssl_prefer_server_ciphers on;
-    ssl_ciphers ${{SSL_CIPHERS}};
+    ssl_session_cache   shared:AdminSSL:10m;
 &gt; end

     # injected nginx_admin_* directives
@@ -265,20 +291,20 @@ server {
         return 200 'User-agent: *\nDisallow: /';
     }
 }
-&gt; end
+&gt; end -- (role == "control_plane" or role == "traditional") and #admin_listeners &gt; 0

 &gt; if #status_listeners &gt; 0 then
 server {
     server_name kong_status;
-&gt; for i = 1, #status_listeners do
-    listen $(status_listeners[i].listener);
+&gt; for _, entry in ipairs(status_listeners) do
+    listen $(entry.listener);
 &gt; end

     access_log ${{STATUS_ACCESS_LOG}};
     error_log  ${{STATUS_ERROR_LOG}} ${{LOG_LEVEL}};

-    # injected nginx_http_status_* directives
-&gt; for _, el in ipairs(nginx_http_status_directives) do
+    # injected nginx_status_* directives
+&gt; for _, el in ipairs(nginx_status_directives) do
     $(el.name) $(el.value);
 &gt; end

@@ -303,4 +329,26 @@ server {
     }
 }
 &gt; end
+
+&gt; if role == "control_plane" then
+server {
+    server_name kong_cluster_listener;
+&gt; for _, entry in ipairs(cluster_listeners) do
+    listen $(entry.listener) ssl;
+&gt; end
+
+    access_log off;
+
+    ssl_verify_client   optional_no_ca;
+    ssl_certificate     ${{CLUSTER_CERT}};
+    ssl_certificate_key ${{CLUSTER_CERT_KEY}};
+    ssl_session_cache   shared:ClusterSSL:10m;
+
+    location = /v1/outlet {
+        content_by_lua_block {
+            Kong.serve_cluster_listener()
+        }
+    }
+}
+&gt; end -- role == "control_plane"
 ]]
</pre>

</p>
</details>


#### 3. Suggested Upgrade Path

##### Upgrade from `0.x` to `2.0.0`

The lowest version that Kong 2.0.0 supports migrating from is 1.0.0.
If you are migrating from a version lower than 0.14.1, you need to
migrate to 0.14.1 first. Then, once you are migrating from 0.14.1,
please migrate to 1.5.0 first.

The steps for upgrading from 0.14.1 to 1.5.0 are the same as upgrading
from 0.14.1 to Kong 1.0. Please follow the steps described in the
"Migration Steps from 0.14" in the [Suggested Upgrade Path for Kong
1.0](#kong-1-0-upgrade-path), with the addition of the `kong
migrations migrate-apis` command, which you can use to migrate legacy
`apis` configurations.

Once you migrated to 1.5.0, you can follow the instructions in the section
below to migrate to 2.0.0.

##### Upgrade from `1.0.0` - `1.5.0` to `2.0.0`

Kong 2.0.0 supports a no-downtime migration model. This means that while the
migration is ongoing, you will have two Kong clusters running, sharing the
same database. (This is sometimes called the Blue/Green migration model.)

The migrations are designed so that there is no need to fully copy
the data, but this also means that they are designed in such a way so that
the new version of Kong is able to use the data as it is migrated, and to do
it in a way so that the old Kong cluster keeps working until it is finally
time to decommission it. For this reason, the full migration is now split into
two steps, which are performed via commands `kong migrations up` (which does
only non-destructive operations) and `kong migrations finish` (which puts the
database in the final expected state for Kong 2.0.0).

1. Download 2.0.0, and configure it to point to the same datastore
   as your old (1.0 to 1.5) cluster. Run `kong migrations up`.
2. Once that finishes running, both the old and new (2.0.0) clusters can now
   run simultaneously on the same datastore. Start provisioning
   2.0.0 nodes, but do not use their Admin API yet. If you need to
   perform Admin API requests, these should be made to the old cluster's nodes.
   The reason is to prevent the new cluster from generating data
   that is not understood by the old cluster.
3. Gradually divert traffic away from your old nodes, and into
   your 2.0.0 cluster. Monitor your traffic to make sure everything
   is going smoothly.
4. When your traffic is fully migrated to the 2.0.0 cluster,
   decommission your old nodes.
5. From your 2.0.0 cluster, run: `kong migrations finish`.
   From this point on, it will not be possible to start
   nodes in the old cluster pointing to the same datastore anymore. Only run
   this command when you are confident that your migration
   was successful. From now on, you can safely make Admin API
   requests to your 2.0.0 nodes.

##### Installing 2.0.0 on a Fresh Datastore

The following commands should be used to prepare a new 2.0.0 cluster from a
fresh datastore:

```
$ kong migrations bootstrap [-c config]
$ kong start [-c config]
```
